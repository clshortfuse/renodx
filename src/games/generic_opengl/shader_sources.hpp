#pragma once

#include "gl_api.hpp"
#include "parameters.hpp"
#include "../../utils/hash.hpp"
#include <format>
#include <memory>
#include <mutex>
#include <unordered_map>
#include <unordered_set>

namespace generic_opengl::sources {
struct Stage { const char* name; unsigned gl_type; };
inline Stage ShaderStage(reshade::api::pipeline_subobject_type type) {
  using enum reshade::api::pipeline_subobject_type;
  switch (type) {
    case vertex_shader: return {"vs", 0x8B31};
    case pixel_shader: return {"ps", 0x8B30};
    case geometry_shader: return {"gs", 0x8DD9};
    case hull_shader: return {"hs", 0x8E88};
    case domain_shader: return {"ds", 0x8E87};
    case compute_shader: return {"cs", 0x91B9};
    default: return {nullptr, 0};
  }
}

struct Replacement {
  std::string original;
  std::string source;
};
inline std::mutex mutex;
// Never mutate published source bytes: ReShade reads them after the callback.
inline std::unordered_map<std::string, std::shared_ptr<const Replacement>> cache;
inline std::unordered_set<std::string> accepted;

inline bool OnCreate(reshade::api::device* device, reshade::api::pipeline_layout,
                     uint32_t count, const reshade::api::pipeline_subobject* objects) {
  if (internal_gl || device->get_api() != reshade::api::device_api::opengl || count != 1
      || !objects || objects[0].count != 1 || !objects[0].data) return false;
  const auto stage = ShaderStage(objects[0].type);
  if (!stage.name) return false;
  auto* desc = static_cast<reshade::api::shader_desc*>(objects[0].data);
  if (!desc->code || desc->code_size == 0 || desc->code_size > MAX_SOURCE_SIZE) return false;
  std::string_view original(static_cast<const char*>(desc->code), desc->code_size);
  while (!original.empty() && original.back() == '\0') original.remove_suffix(1);
  // Binary/SPIR-V inputs and driver-native program formats are not text shaders.
  if (original.empty() || original.find('\0') != std::string_view::npos) return false;
  const bool arb = original.starts_with("!!ARBfp1.0") || original.starts_with("!!ARBvp1.0");
  if (!arb && desc->entry_point == nullptr) return false;
  const auto crc = renodx::utils::hash::ComputeCRC32(
      reinterpret_cast<const uint8_t*>(original.data()), original.size());
  const auto key = std::format("0x{:08X}.{}.{}", crc, stage.name, arb ? "arb" : "glsl");
  InternalScope scope;
  try {
    std::shared_ptr<const Replacement> replacement;
    {
      const std::lock_guard lock(mutex);
      auto found = cache.find(key);
      if (found == cache.end()) {
        auto loaded = std::make_shared<Replacement>();
        loaded->original = original;
        if (profile.dump) {
          fs::create_directories(profile.root / "dump");
          const auto path = profile.root / "dump" / key;
          if (!fs::exists(path)) {
            std::ofstream stream(path, std::ios::binary);
            stream.write(original.data(), static_cast<std::streamsize>(original.size()));
            if (!stream) throw std::runtime_error("Cannot dump " + key);
          }
        }
        if (profile.replace) {
          const auto mapped = profile.files.find(key);
          const auto path = ProfilePath(mapped != profile.files.end() ? mapped->second : "replacements/" + key);
          if (fs::exists(path)) loaded->source = ReadSource(path);
        }
        Log("Captured " + key + (loaded->source.empty() ? " (original)" : " (replacement found)"));
        found = cache.emplace(key, std::move(loaded)).first;
      }
      replacement = found->second;
    }
    if (replacement->original != original) {
      Log("CRC collision for " + key + "; leaving original untouched", true);
      return false;
    }
    if (replacement->source.empty()) return false;
    // Validate in every uploading context; capabilities may differ across contexts.
    const GL gl;
    if (arb) {
      if (!gl.gen_arb || !gl.bind_arb || !gl.upload_arb || !gl.arb_iv || !gl.delete_arb || !gl.get) return false;
      if (!replacement->source.starts_with(original.substr(0, 10))) {
        Log("ARB replacement has the wrong program header: " + key, true);
        return false;
      }
      const unsigned target = stage.gl_type == 0x8B31 ? 0x8620 : 0x8804;
      int previous = 0, error_position = -1;
      unsigned temporary = 0;
      gl.arb_iv(target, 0x8677, &previous);
      gl.gen_arb(1, &temporary);
      if (!temporary) return false;
      gl.bind_arb(target, temporary);
      gl.upload_arb(target, 0x8875, static_cast<int>(replacement->source.size()), replacement->source.data());
      gl.get(0x864B, &error_position);
      gl.bind_arb(target, static_cast<unsigned>(previous));
      gl.delete_arb(1, &temporary);
      if (error_position >= 0) {
        Log("ARB validation failed at byte " + std::to_string(error_position) + ": " + key, true);
        return false;
      }
    } else {
      const auto shader = gl.Compile(stage.gl_type, replacement->source);
      if (!shader) return false;
      gl.delete_shader(shader);
    }
    desc->code = replacement->source.data();
    desc->code_size = replacement->source.size();
    Log("Submitting replacement " + key);
    return true;
  } catch (const std::exception& error) {
    Log(std::string("Source replacement skipped: ") + error.what(), true);
    return false;
  }
}

inline void OnInit(reshade::api::device* device, reshade::api::pipeline_layout,
                   uint32_t count, const reshade::api::pipeline_subobject* objects,
                   reshade::api::pipeline pipeline) {
  if (internal_gl || device->get_api() != reshade::api::device_api::opengl || !objects) return;
  unsigned arb_target = 0;
  if (count == 1 && ShaderStage(objects[0].type).name && objects[0].data && objects[0].count == 1) {
    const auto* desc = static_cast<const reshade::api::shader_desc*>(objects[0].data);
    if (desc->entry_point == nullptr)
      arb_target = objects[0].type == reshade::api::pipeline_subobject_type::vertex_shader ? 0x8620 : 0x8804;
  }
  parameters::Track(device, static_cast<unsigned>(pipeline.handle), arb_target, false);
  const std::lock_guard lock(mutex);
  for (uint32_t index = 0; index < count; ++index) {
    if (!ShaderStage(objects[index].type).name || objects[index].count != 1 || !objects[index].data) continue;
    const auto* desc = static_cast<const reshade::api::shader_desc*>(objects[index].data);
    if (!desc->code || desc->code_size > MAX_SOURCE_SIZE) continue;
    std::string_view source(static_cast<const char*>(desc->code), desc->code_size);
    while (!source.empty() && source.back() == '\0') source.remove_suffix(1);
    for (const auto& [key, replacement] : cache) {
      if (!replacement->source.empty() && replacement->source == source) {
        parameters::Track(device, static_cast<unsigned>(pipeline.handle), arb_target, true);
        if (accepted.insert(key).second) Log("Driver accepted replacement " + key);
      }
    }
  }
}

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::create_pipeline>(OnCreate);
    reshade::register_event<reshade::addon_event::init_pipeline>(OnInit);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::create_pipeline>(OnCreate);
    reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInit);
  }
}
}  // namespace generic_opengl::sources
