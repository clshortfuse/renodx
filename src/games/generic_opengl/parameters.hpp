#pragma once

#include "gl_api.hpp"
#include <deps/imgui/imgui.h>
#include <algorithm>
#include <array>
#include <mutex>
#include <unordered_map>
#include <unordered_set>

namespace generic_opengl::parameters {
inline constexpr size_t FLOAT_COUNT = 64;
inline constexpr size_t VECTOR_COUNT = FLOAT_COUNT / 4;
inline constexpr const char* SECTION = "RenoDX.GenericOpenGL.Parameters";
inline std::mutex mutex;
inline std::array<float, FLOAT_COUNT> values{};
inline uint64_t revision = 1, program_revision = 1;
inline std::unordered_map<reshade::api::device*, std::unordered_set<uint64_t>> programs;
inline fs::file_time_type last_file_time{};
inline ULONGLONG next_poll = 0;

// ARB program names occupy a separate namespace from GLSL program names.
inline uint64_t ProgramKey(unsigned program, unsigned arb_target = 0) {
  return (uint64_t{arb_target} << 32) | program;
}
inline void Track(reshade::api::device* device, unsigned program, unsigned target, bool replacement) {
  if (!profile.parameters.enabled) return;
  const std::lock_guard lock(mutex);
  if (replacement) programs[device].insert(ProgramKey(program, target));
  else programs[device].erase(ProgramKey(program, target));
  ++program_revision;
}
inline void OnDestroyDevice(reshade::api::device* device) {
  const std::lock_guard lock(mutex);
  programs.erase(device);
  ++program_revision;
}

inline void PollValues() {
  const std::lock_guard lock(mutex);
  if (GetTickCount64() < next_poll) return;
  next_poll = GetTickCount64() + 500;
  try {
    const auto path = ProfilePath("parameter_values.json");
    if (!fs::exists(path)) return;
    const auto modified = fs::last_write_time(path);
    if (modified == last_file_time) return;
    // Remember malformed revisions too, so a partial edit cannot flood the log.
    last_file_time = modified;
    const auto json = nlohmann::json::parse(ReadSource(path));
    if (!json.is_object()) throw std::runtime_error("Expected an object of parameter names and values");
    auto next = values;
    for (const auto& [key, item] : json.items()) {
      const auto found = std::find_if(profile.parameters.values.begin(), profile.parameters.values.end(),
          [&](const auto& parameter) { return parameter.name == key; });
      if (found == profile.parameters.values.end()) throw std::runtime_error("Unknown parameter: " + key);
      const float value = item.get<float>();
      if (!std::isfinite(value) || value < found->min || value > found->max)
        throw std::runtime_error("Out-of-range parameter: " + key);
      next[static_cast<size_t>(found - profile.parameters.values.begin())] = value;
    }
    values = next;
    ++revision;
    Log("Reloaded parameter_values.json; shader parameters updated");
  } catch (const std::exception& error) {
    Log(std::string("Parameter values unchanged: ") + error.what(), true);
  }
}
inline void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain*,
    const reshade::api::rect*, const reshade::api::rect*, uint32_t, const reshade::api::rect*) {
  if (queue->get_device()->get_api() == reshade::api::device_api::opengl) PollValues();
}
inline void Overlay(reshade::api::effect_runtime*) {
  ImGui::TextUnformatted("Parameters for OpenGL replacement shaders");
  ImGui::TextUnformatted("Four consecutive values occupy each renodx_params vec4.");
  for (size_t index = 0; index < profile.parameters.values.size(); ++index) {
    float value;
    { const std::lock_guard lock(mutex); value = values[index]; }
    const auto& parameter = profile.parameters.values[index];
    ImGui::PushID(static_cast<int>(index));
    if (ImGui::SliderFloat(parameter.label.c_str(), &value, parameter.min, parameter.max)) {
      { const std::lock_guard lock(mutex); values[index] = value; ++revision; }
      reshade::set_config_value(nullptr, SECTION, parameter.name.c_str(), value);
    }
    ImGui::SameLine();
    if (ImGui::SmallButton("Reset")) {
      { const std::lock_guard lock(mutex); values[index] = parameter.value; ++revision; }
      reshade::set_config_value(nullptr, SECTION, parameter.name.c_str(), parameter.value);
    }
    ImGui::PopID();
  }
}

struct ProgramInfo {
  unsigned block = ~0u;
  int location = -1;
  int count = 0;
};
struct Context {
  unsigned buffer = 0;
  uint64_t buffer_revision = 0, cache_revision = 0;
  std::unordered_map<uint64_t, ProgramInfo> cache;
};
struct State {
  unsigned program = 0, block = ~0u;
  int block_binding = 0, buffer = 0, generic_buffer = 0;
  int64_t buffer_start = 0, buffer_size = 0;
  int location = -1, count = 0;
  std::array<float, FLOAT_COUNT> uniforms{};
  struct ARB { unsigned target = 0; unsigned count = 0; std::array<float, FLOAT_COUNT> values{}; };
  std::array<ARB, 2> arb{};
};

// Bracket every affected native draw/dispatch; restore indexed UBO ranges, the
// generic binding, program block bindings, uniforms and ARB parameter values.
inline State Before(Context* context, const GL& gl, reshade::api::device* device,
                    unsigned program, bool owned_fixed_program = false) {
  State state;
  if (!profile.parameters.enabled) return state;
  std::array<float, FLOAT_COUNT> snapshot;
  uint64_t current_revision;
  bool glsl = owned_fixed_program;
  std::array<bool, 2> arb_enabled{};
  {
    const std::lock_guard lock(mutex);
    if (context->cache_revision != program_revision) {
      context->cache.clear();
      context->cache_revision = program_revision;
    }
    snapshot = values;
    current_revision = revision;
    const auto found = programs.find(device);
    if (found != programs.end()) {
      glsl = glsl || found->second.contains(ProgramKey(program));
      if (program == 0 && gl.arb_iv && gl.enabled) {
        for (size_t index = 0; index < 2; ++index) {
          const unsigned target = index == 0 ? 0x8620 : 0x8804;
          if (!(index == 0 ? gl.arb_vertex : gl.arb_fragment) || !gl.enabled(target)) continue;
          int bound = 0;
          gl.arb_iv(target, 0x8677, &bound);
          arb_enabled[index] = found->second.contains(ProgramKey(static_cast<unsigned>(bound), target));
        }
      }
    }
  }
  if (program != 0 && glsl && gl.uniform_location && gl.uniform4fv && gl.get_uniform) {
    auto [entry, inserted] = context->cache.try_emplace(program);
    auto& info = entry->second;
    if (inserted) {
      if (gl.uniform_buffers && gl.block_index && gl.block_iv && gl.block_binding
          && gl.gen_buffers && gl.bind_buffer && gl.buffer_data && gl.buffer_subdata
          && gl.bind_base && gl.bind_range && gl.get_indexed && gl.get_indexed64) {
        const auto block = gl.block_index(program, "RenoDX");
        if (block != ~0u) {
          int size = 0, max_bindings = 0;
          gl.block_iv(program, block, 0x8A40, &size); // GL_UNIFORM_BLOCK_DATA_SIZE
          gl.get(0x8A2F, &max_bindings);
          if (size == sizeof(snapshot) && profile.parameters.ubo_binding < static_cast<unsigned>(max_bindings)) info.block = block;
          else Log("RenoDX block skipped: requires 16 std140 vec4 values (256 bytes) and a valid UBO binding", true);
        }
      }
      // Legacy GLSL uniform arrays may be optimized to fewer than 16 elements.
      if (gl.active_uniform && gl.program_iv) {
        int active = 0;
        gl.program_iv(program, 0x8B86, &active);
        for (int index = 0; index < active; ++index) {
          char name[256] = {};
          int count = 0;
          unsigned type = 0;
          gl.active_uniform(program, index, sizeof(name), nullptr, &count, &type, name);
          if ((std::string_view(name) == "renodx_params[0]" || std::string_view(name) == "renodx_params") && type == 0x8B52) {
            info.location = gl.uniform_location(program, name);
            info.count = std::min(count, static_cast<int>(VECTOR_COUNT));
            break;
          }
        }
      }
      if (info.block != ~0u || info.location >= 0) Log("Bound parameter interface for replacement GLSL program " + std::to_string(program));
    }
    if (info.block != ~0u) {
      gl.get(0x8A28, &state.generic_buffer);
      if (context->buffer == 0) {
        gl.gen_buffers(1, &context->buffer);
        if (context->buffer) {
          gl.bind_buffer(0x8A11, context->buffer);
          gl.buffer_data(0x8A11, sizeof(snapshot), snapshot.data(), 0x88E8);
          context->buffer_revision = current_revision;
        }
      } else if (context->buffer_revision != current_revision) {
        gl.bind_buffer(0x8A11, context->buffer);
        gl.buffer_subdata(0x8A11, 0, sizeof(snapshot), snapshot.data());
        context->buffer_revision = current_revision;
      }
      if (context->buffer) {
        state.program = program;
        state.block = info.block;
        gl.block_iv(program, info.block, 0x8A3F, &state.block_binding);
        gl.get_indexed(0x8A28, profile.parameters.ubo_binding, &state.buffer);
        gl.get_indexed64(0x8A29, profile.parameters.ubo_binding, &state.buffer_start);
        gl.get_indexed64(0x8A2A, profile.parameters.ubo_binding, &state.buffer_size);
        gl.block_binding(program, info.block, profile.parameters.ubo_binding);
        gl.bind_base(0x8A11, profile.parameters.ubo_binding, context->buffer);
      }
      gl.bind_buffer(0x8A11, static_cast<unsigned>(state.generic_buffer));
    }
    if (info.location >= 0) {
      state.location = info.location;
      state.count = info.count;
      for (int index = 0; index < info.count; ++index) gl.get_uniform(program, info.location + index, state.uniforms.data() + 4 * index);
      gl.uniform4fv(info.location, info.count, snapshot.data());
    }
  }
  const unsigned vectors = static_cast<unsigned>((profile.parameters.values.size() + 3) / 4);
  for (size_t index = 0; index < 2; ++index) {
    if (!arb_enabled[index]) continue;
    const auto get = profile.parameters.arb_environment ? gl.get_arb_env : gl.get_arb_local;
    const auto set = profile.parameters.arb_environment ? gl.arb_env : gl.arb_local;
    if (!get || !set) continue;
    const unsigned target = index == 0 ? 0x8620 : 0x8804;
    int limit = 0;
    gl.arb_iv(target, profile.parameters.arb_environment ? 0x88B5 : 0x88B4, &limit);
    if (profile.parameters.arb_start + vectors > static_cast<unsigned>(std::max(limit, 0))) continue;
    state.arb[index].target = target;
    state.arb[index].count = vectors;
    for (unsigned vector = 0; vector < vectors; ++vector) {
      get(target, profile.parameters.arb_start + vector, state.arb[index].values.data() + vector * 4);
      set(target, profile.parameters.arb_start + vector, snapshot.data() + vector * 4);
    }
  }
  return state;
}

inline void After(const GL& gl, const State& state) {
  if (state.location >= 0) gl.uniform4fv(state.location, state.count, state.uniforms.data());
  if (state.block != ~0u) {
    gl.block_binding(state.program, state.block, static_cast<unsigned>(state.block_binding));
    if (state.buffer != 0 && state.buffer_size > 0)
      gl.bind_range(0x8A11, profile.parameters.ubo_binding, static_cast<unsigned>(state.buffer),
                    static_cast<ptrdiff_t>(state.buffer_start), static_cast<ptrdiff_t>(state.buffer_size));
    else gl.bind_base(0x8A11, profile.parameters.ubo_binding, static_cast<unsigned>(state.buffer));
    gl.bind_buffer(0x8A11, static_cast<unsigned>(state.generic_buffer));
  }
  const auto set = profile.parameters.arb_environment ? gl.arb_env : gl.arb_local;
  for (const auto& arb : state.arb)
    for (unsigned vector = 0; vector < arb.count; ++vector)
      set(arb.target, profile.parameters.arb_start + vector, arb.values.data() + vector * 4);
}

inline void Use(DWORD reason) {
  if (!profile.parameters.enabled) return;
  if (reason == DLL_PROCESS_ATTACH) {
    for (size_t index = 0; index < profile.parameters.values.size(); ++index) {
      const auto& parameter = profile.parameters.values[index];
      float value = parameter.value;
      reshade::get_config_value(nullptr, SECTION, parameter.name.c_str(), value);
      values[index] = std::isfinite(value) ? std::clamp(value, parameter.min, parameter.max) : parameter.value;
    }
    PollValues();
    reshade::register_event<reshade::addon_event::present>(OnPresent);
    reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
    reshade::register_overlay("OpenGL Shader Parameters", Overlay);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_overlay("OpenGL Shader Parameters", Overlay);
    reshade::unregister_event<reshade::addon_event::present>(OnPresent);
    reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
  }
}
}  // namespace generic_opengl::parameters
