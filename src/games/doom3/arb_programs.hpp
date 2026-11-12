#pragma once

#include <string>
#include <mutex>
#include <string_view>
#include <unordered_map>
#include <include/reshade.hpp>
#include "../../utils/device_proxy.hpp"
#include "../../utils/hash.hpp"

namespace doom3::arb {

// Keep replacement bytes alive through ReShade's native upload and init event.
// Only these captured dhewm3 programs are eligible; other game versions,
// normal/shadow clamps, and programs modified by another addon are untouched.
inline std::unordered_map<uint32_t, std::string> replacements;
inline std::mutex replacements_mutex;
inline constexpr std::string_view CLAMP =
    "MUL_SAT dhewm3tmpres.xyz, program.env[21], dhewm3tmpres;";
inline constexpr std::string_view UNCLAMP =
    "MUL dhewm3tmpres.xyz, program.env[21], dhewm3tmpres;\n"
    "MAX dhewm3tmpres.xyz, dhewm3tmpres, 0.0;";

inline bool OnCreatePipeline(reshade::api::device* device, reshade::api::pipeline_layout,
                             uint32_t count, const reshade::api::pipeline_subobject* objects) {
  if (device->get_api() != reshade::api::device_api::opengl
      || !renodx::utils::device_proxy::UseProxyRequested()) return false;
  // glProgramStringARB exposes exactly one program, unlike GLSL link events.
  if (count != 1 || objects[0].type != reshade::api::pipeline_subobject_type::pixel_shader
      || objects[0].count != 1 || objects[0].data == nullptr) return false;
  auto* desc = static_cast<reshade::api::shader_desc*>(objects[0].data);
  if (desc->code == nullptr || desc->code_size < 10 || desc->code_size > 16384) return false;
  const std::string_view original(static_cast<const char*>(desc->code), desc->code_size);
  if (!original.starts_with("!!ARBfp1.0")) return false;
  const auto hash = renodx::utils::hash::ComputeCRC32(
      static_cast<const uint8_t*>(desc->code), desc->code_size);
  if (hash != 0xE414AC30u && hash != 0x121690B2u) return false;
  const auto position = original.find(CLAMP);
  if (position == std::string_view::npos
      || original.find(CLAMP, position + CLAMP.size()) != std::string_view::npos) return false;
  const std::lock_guard lock(replacements_mutex);
  auto [replacement, inserted] = replacements.try_emplace(hash, original);
  if (inserted) replacement->second.replace(position, CLAMP.size(), UNCLAMP);
  // Preserve brightness, gamma POWs, alpha and all other instructions.
  // MAX retains the nonnegative base required by POW, without clipping HDR.
  desc->code = replacement->second.data();
  desc->code_size = replacement->second.size();
  reshade::log::message(reshade::log::level::info,
      hash == 0xE414AC30u ? "[Doom3 ARB] Submitting unclamped interaction program."
                        : "[Doom3 ARB] Submitting unclamped distortion program.");
  return true;
}

inline void OnInitPipeline(reshade::api::device* device, reshade::api::pipeline_layout,
                           uint32_t count, const reshade::api::pipeline_subobject* objects,
                           reshade::api::pipeline) {
  if (device->get_api() != reshade::api::device_api::opengl || count != 1
      || objects[0].type != reshade::api::pipeline_subobject_type::pixel_shader
      || objects[0].count != 1 || objects[0].data == nullptr) return;
  const auto* desc = static_cast<const reshade::api::shader_desc*>(objects[0].data);
  if (desc->code == nullptr) return;
  const std::lock_guard lock(replacements_mutex);
  for (const auto& [hash, source] : replacements) {
    if (desc->code_size != source.size()
        || std::string_view(static_cast<const char*>(desc->code), desc->code_size) != source) continue;
    // ReShade emits init_pipeline for ARB programs only after successful upload.
    reshade::log::message(reshade::log::level::info,
        hash == 0xE414AC30u ? "[Doom3 ARB] Driver accepted unclamped interaction program."
                          : "[Doom3 ARB] Driver accepted unclamped distortion program.");
    break;
  }
}

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
    reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
    reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
  }
}
}  // namespace doom3::arb
