/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

// Baseline for RenoDX Zelda: Ocarina of Time ports to Nintendo Switch 2.
// Required game-executable allocation changes are documented in DllMain below;
// they must also be implemented by native ports, independently of ReShade.

#define ImTextureID ImU64

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <mutex>
#include <shared_mutex>
#include <unordered_set>

#include "../../mods/shader.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

bool addon_registered = false;
ShaderInjectData shader_injection = {};
std::shared_mutex hdr_swapchains_mutex;
std::unordered_set<reshade::api::swapchain*> hdr_swapchains;

std::array<float, 2> aa_constants = {1.f, 0.f};
thread_local std::array<float, 5> adaptation_constants = {};

struct __declspec(uuid("d17bb4b2-bf65-47d9-ae8e-58b00b86f38d")) AdaptationDeviceData {
  std::shared_mutex mutex;
  std::array<reshade::api::resource, 2> resources = {};
  std::array<reshade::api::resource_view, 2> views = {};
  std::unordered_set<reshade::api::command_list*> recorded_commands;
  std::unordered_set<reshade::api::command_list*> fog_commands;
  reshade::api::command_queue* writer_queue = nullptr;
  uint32_t read_index = 0u;
  uint32_t generation = 0u;
  bool draw_claimed = false;
  bool fog_claimed = false;
  bool queue_mismatch = false;
  float delta_seconds = 1.f / 60.f;
  std::chrono::steady_clock::time_point last_present = std::chrono::steady_clock::now();
};

void OnAdaptationInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::vulkan) {
    device->create_private_data<AdaptationDeviceData>();
  }
}

void OnAdaptationInitQueue(reshade::api::command_queue* queue) {
  auto* device = queue->get_device();
  if (device->get_api() != reshade::api::device_api::vulkan) return;
  auto* data = device->get_private_data<AdaptationDeviceData>();
  if (data == nullptr || data->resources[0].handle != 0u
      || static_cast<uint32_t>(queue->get_type() & reshade::api::command_queue_type::graphics) == 0u) return;
  const reshade::api::resource_desc desc(reshade::api::resource_type::texture_2d, 3u, 1u, 1u, 1u,
                                         reshade::api::format::r32g32b32a32_float, 1u, reshade::api::memory_heap::gpu_only,
                                         reshade::api::resource_usage::unordered_access | reshade::api::resource_usage::copy_dest);
  // Pixel 0 is (linear combined anchor, log2 fast, log2 slow, generation); pixel 1 is FOV capture.
  // Pixel 2 is (log2 filtered target, bleached fraction, reserved, generation).
  // log2(0.18); negative generation stamps still invalidate these initial records.
  std::array<float, 12> seed = {0.18f, -2.473931188332412f, -2.473931188332412f, -1.f,
                                0.f, 0.f, 0.f, -2.f,
                                -2.473931188332412f, 0.f, 0.f, -2.f};
  const reshade::api::subresource_data initial = {.data = seed.data(), .row_pitch = 48u, .slice_pitch = 48u};
  const reshade::api::resource_view_desc view_desc(reshade::api::resource_view_type::texture_2d,
                                                   reshade::api::format::r32g32b32a32_float, 0u, 1u, 0u, 1u);
  for (uint32_t i = 0u; i < 2u; ++i) {
    if (!device->create_resource(desc, &initial, reshade::api::resource_usage::unordered_access, &data->resources[i])
        || !device->create_resource_view(data->resources[i], reshade::api::resource_usage::unordered_access,
                                         view_desc, &data->views[i])) {
      reshade::log::message(reshade::log::level::error, "Zelda adaptation: state image/view creation failed");
      for (uint32_t j = 0u; j < 2u; ++j) {
        if (data->views[j].handle != 0u) device->destroy_resource_view(data->views[j]);
        if (data->resources[j].handle != 0u) device->destroy_resource(data->resources[j]);
      }
      data->resources = {};
      data->views = {};
      return;
    }
  }
  for (uint32_t i = 0u; i < 2u; ++i) {
    renodx::utils::resource::OnInitResource(device, desc, nullptr, reshade::api::resource_usage::unordered_access, data->resources[i]);
    renodx::utils::resource::OnInitResourceView(device, data->resources[i], reshade::api::resource_usage::unordered_access, view_desc, data->views[i]);
  }
}

// Scene and fog callbacks prepare descriptor constants on their recording thread.
bool PrepareAdaptationDraw(reshade::api::command_list* cmd_list, bool meter) {
  adaptation_constants = {};
  auto* data = cmd_list->get_device()->get_private_data<AdaptationDeviceData>();
  if (data == nullptr) return false;
  std::lock_guard lock(data->mutex);
  uint32_t custom_flags = 0u;
  std::memcpy(&custom_flags, &shader_injection.custom_flags, sizeof(custom_flags));
  adaptation_constants[0] = data->delta_seconds;
  adaptation_constants[1] = static_cast<float>(data->generation);
  adaptation_constants[4] = static_cast<float>(data->read_index);
  if (meter && (custom_flags & 16u) != 0u
      && !data->draw_claimed && !data->queue_mismatch && data->views[1].handle != 0u) {
    data->draw_claimed = true;
    data->recorded_commands.insert(cmd_list);
    adaptation_constants[3] = 1.f;
  }
  return (custom_flags & 16u) != 0u;
}

bool OnDrawAdaptationFog(reshade::api::command_list* cmd_list) {
  if (!PrepareAdaptationDraw(cmd_list, false)) return true;
  auto* data = cmd_list->get_device()->get_private_data<AdaptationDeviceData>();
  if (data != nullptr) {
    std::lock_guard lock(data->mutex);
    if (!data->fog_claimed && !data->queue_mismatch && data->views[1].handle != 0u) {
      data->fog_claimed = true;
      data->fog_commands.insert(cmd_list);
      adaptation_constants[2] = 1.f;
    }
  }
  return true;
}

void OnAdaptationExecute(reshade::api::command_queue* queue, reshade::api::command_list* cmd_list) {
  auto* data = queue->get_device()->get_private_data<AdaptationDeviceData>();
  if (data == nullptr) return;
  std::lock_guard lock(data->mutex);
  const bool meter = data->recorded_commands.erase(cmd_list) != 0u;
  const bool fog = data->fog_commands.erase(cmd_list) != 0u;
  if (!meter && !fog) return;
  if (data->writer_queue == nullptr) data->writer_queue = queue;
  if (data->writer_queue != queue) {
    data->queue_mismatch = true;
    reshade::log::message(reshade::log::level::error, "Zelda adaptation: multiple writer queues unsupported");
  }
}

void OnAdaptationPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain,
                         [[maybe_unused]] const reshade::api::rect* source_rect, [[maybe_unused]] const reshade::api::rect* dest_rect,
                         [[maybe_unused]] uint32_t dirty_rect_count, [[maybe_unused]] const reshade::api::rect* dirty_rects) {
  {
    std::lock_guard lock(hdr_swapchains_mutex);
    const auto color_space = swapchain->get_color_space();
    if (color_space == reshade::api::color_space::hdr10_st2084
        || color_space == reshade::api::color_space::extended_srgb_linear) {
      hdr_swapchains.insert(swapchain);
    } else {
      hdr_swapchains.erase(swapchain);
    }
  }
  auto* data = queue->get_device()->get_private_data<AdaptationDeviceData>();
  if (data == nullptr) return;
  std::lock_guard lock(data->mutex);
  const auto now = std::chrono::steady_clock::now();
  data->delta_seconds = std::chrono::duration<float>(now - data->last_present).count();
  data->last_present = now;
  if (data->writer_queue != nullptr && data->writer_queue != queue) data->queue_mismatch = true;
  if (data->views[1].handle != 0u && !data->queue_mismatch) {
    auto* cmd_list = queue->get_immediate_command_list();
    if (cmd_list != nullptr) {
      // Covers prior storage reads as well as writes before ping-pong reuse.
      for (auto resource : data->resources) {
        cmd_list->barrier(resource, reshade::api::resource_usage::unordered_access,
                          reshade::api::resource_usage::unordered_access);
      }
      queue->flush_immediate_command_list();
      data->read_index ^= 1u;
    } else {
      data->queue_mismatch = true;
      reshade::log::message(reshade::log::level::error, "Zelda adaptation: present command list unavailable");
    }
  }
  data->generation = (data->generation + 1u) % RENODX_ADAPTATION_GENERATION_COUNT;
  data->draw_claimed = false;
  data->fog_claimed = false;
  data->recorded_commands.clear();
  data->fog_commands.clear();
}

void OnAdaptationDestroyDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::vulkan) return;
  auto* data = device->get_private_data<AdaptationDeviceData>();
  if (data == nullptr) return;
  for (uint32_t i = 0u; i < 2u; ++i) {
    if (data->views[i].handle != 0u) {
      renodx::utils::resource::OnDestroyResourceView(device, data->views[i]);
      device->destroy_resource_view(data->views[i]);
    }
    if (data->resources[i].handle != 0u) {
      renodx::utils::resource::OnDestroyResource(device, data->resources[i]);
      device->destroy_resource(data->resources[i]);
    }
  }
  device->destroy_private_data<AdaptationDeviceData>();
}

bool OnDrawScene(reshade::api::command_list* cmd_list) {
  PrepareAdaptationDraw(cmd_list, true);
  return true;
}

void OnDestroyOutputSwapchain(reshade::api::swapchain* swapchain, [[maybe_unused]] bool resize) {
  std::lock_guard lock(hdr_swapchains_mutex);
  hdr_swapchains.erase(swapchain);
}

// Guest keys below are FNV-1a64 of bounded original Switch 2 instructions.
renodx::mods::shader::CustomShaders custom_shaders = {
  CustomShaderEntry(0xED732BB7),  // Switch 2: 88DE917DF2385E5F. Scene ACES fit and native HDR expansion.
    CustomShaderEntry(0x09EB4538),  // Switch 2: 047C7173198BA00A. Gameplay variant with local exposure.
    CustomShaderEntry(0x0CB15954),  // Switch 2: 1D3239DD29FF4F88. Native SDR scene, fixed 203/203 PsychoV35 reference.
    CustomShaderEntry(0x92D6F81D),  // Switch 2: 756B22AA4E7E5573. Native HDR output encoder.
    CustomShaderEntry(0x400192C0),  // Switch 2: 4B2ADCC4D5577ED1. Capture the ray scales actually consumed by fog.
    CustomShaderEntry(0x0258153C),  // Switch 2: 4B2ADCC4D5577ED1. New fog body, same observed camera ray scales.
    CustomShaderEntry(0xA141DF7D),  // Switch 2: 558BBC45E0F2E10B. AA strength and pre-encoding clamp.
    CustomShaderEntry(0x8B59FC8F),  // Switch 2: 8475D671E6967428. Finite edge-analysis inputs; native work metadata.
    CustomShaderEntry(0xF8FA1F78),  // Switch 2: 9387DB798781F081. Skip unused direction generation at AA0.
    CustomShaderEntry(0x96CFD4A3),  // Switch 2: 9387DB798781F081. New native direction body, same AA-off gate.
    CustomShaderEntry(0x5EBDBDE6),  // Switch 2: F48DB7481BE856B9. Docked: shader-side linear AA-off path.
    CustomShaderEntry(0x03979DBE),  // Switch 2: D8EFD9F0C95ABD80. Handheld: same paired linear AA-off path.
    CustomShaderEntry(0x7C5BB2F5),  // Switch 2: DA6DF3E54C716DF2. Full-resolution paired linear AA-off path.
    CustomShaderEntry(0xD1303F9F),  // Switch 2: DA6DF3E54C716DF2. Native cooperative matrices with paired AA-off/store adapters.
    CustomShaderEntry(0xECF2108C),  // Switch 2: F48DB7481BE856B9. Docked cooperative-matrix body with the same adapters.
    CustomShaderEntry(0xA38C7C10),  // Switch 2: D8EFD9F0C95ABD80. Handheld cooperative-matrix body with the same adapters.
};

bool IsPsychoVEnabled() {
  return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV35;
}

bool IsAdaptedMatchingEnabled() {
  uint32_t custom_flags = 0u;
  std::memcpy(&custom_flags, &shader_injection.custom_flags, sizeof(custom_flags));
  return IsPsychoVEnabled() && (custom_flags & 16u) != 0u;
}

bool IsCustomToneMapperEnabled() {
  return shader_injection.tone_map_type != RENODX_TONE_MAP_TYPE_VANILLA;
}

bool IsHdrOutputEnabled() {
  std::shared_lock lock(hdr_swapchains_mutex);
  return !hdr_swapchains.empty() && IsCustomToneMapperEnabled();
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Output",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsHdrOutputEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Output",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHdrOutputEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Output",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHdrOutputEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "GlobalColorSpace",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {0u, 4u, 8u},
        .label = "Global Color Space",
        .section = "Output",
        .labels = {"Vanilla", "BT709", "DCI-P3"},
        .is_enabled = []() {
          std::shared_lock lock(hdr_swapchains_mutex);
          return !hdr_swapchains.empty();
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapTypeV3",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tonemapper",
        .section = "Grading",
        .labels = {"Vanilla", "PsychoV35"},
        .parse = [](float value) {
          if (value == 1.f) return RENODX_TONE_MAP_TYPE_PSYCHOV35;
          return RENODX_TONE_MAP_TYPE_VANILLA;
        },
    },
    new renodx::utils::settings::Setting{
        .key = "MidgrayMatching",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {0u, 1u, 16u},
        .label = "Midgray",
        .section = "Grading",
        .labels = {"Render", "Vanilla", "Eye Adaptation"},
        .is_enabled = &IsPsychoVEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "VanillaSlope",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, 2u},
        .label = "Match Tone Slope",
        .section = "Grading",
        .labels = {"Off", "On"},
        .is_enabled = &IsPsychoVEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeConeContrast",
        .binding = &shader_injection.tone_map_cone_contrast,
        .default_value = 50.f,
        .label = "Tone Slope",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsPsychoVEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGameHueClip",
        .binding = &shader_injection.custom_hue_clip,
        .default_value = 50.f,
        .label = "Hue Clip Emulation",
        .section = "Grading",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f",
        .is_enabled = &IsPsychoVEnabled,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Grading",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2fx",
        .is_enabled = &IsCustomToneMapperEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = &IsCustomToneMapperEnabled,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "AdaptationTarget",
        .binding = &shader_injection.adaptation_target,
        .default_value = 18.f,
        .label = "Adaptation Target",
        .section = "Eye Adaptation",
        .min = 1.f,
        .max = 100.f,
        .format = "%.1f%%",
        .is_enabled = &IsAdaptedMatchingEnabled,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "AdaptationMinStops",
        .binding = &shader_injection.adaptation_min_stops,
        .default_value = -4.f,
        .label = "Min Stops",
        .section = "Eye Adaptation",
        .min = -8.f,
        .max = 0.f,
        .format = "%+.1f",
        .is_enabled = &IsAdaptedMatchingEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "AdaptationMaxStops",
        .binding = &shader_injection.adaptation_max_stops,
        .default_value = 2.f,
        .label = "Max Stops",
        .section = "Eye Adaptation",
        .min = 0.f,
        .max = 8.f,
        .format = "%+.1f",
        .is_enabled = &IsAdaptedMatchingEnabled,
    },
    new renodx::utils::settings::Setting{
        .key = "FxLocalExposure",
        .binding = &shader_injection.local_exposure,
        .default_value = 0.f,
        .label = "Local Exposure",
        .section = "Effects",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_VANILLA; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.bloom_strength,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugAAStrength",
        .binding = aa_constants.data(),
        .default_value = 100.f,
        .label = "AA Strength",
        .section = "Effects",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f",
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugReconstruction",
        .binding = &aa_constants[1],
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Reconstruction",
        .section = "Effects",
        .labels = {"Native", "Encoded Bilinear", "Encoded Nearest"},
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .on_change = []() { renodx::utils::settings::ResetSettings(); },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapTypeV3", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeConeContrast", 50.f},
      {"GlobalColorSpace", 0.f},
      {"FxGameHueClip", 0.f},
      {"MidgrayMatching", 1.f},
      {"VanillaSlope", 1.f},
      {"AdaptationTarget", 18.f},
      {"AdaptationMinStops", -4.f},
      {"AdaptationMaxStops", 2.f},
      {"FxLocalExposure", 50.f},
      {"FxBloom", 50.f},
      {"DebugAAStrength", 100.f},
      {"DebugReconstruction", 0.f},
  });
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX for The Legend of Zelda: Ocarina of Time for Switch 2";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD reason, [[maybe_unused]] LPVOID reserved) {
  switch (reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;
      addon_registered = true;

      // REQUIRED: the game's allocation labeled "agl::RenderDisplay(color)" must be RGBA16F
      // before this addon sees it. Patch the guest executable (IPS or equivalent),
      // or implement the equivalent allocation change in a native recompilation.
      // This addon replaces host shaders; it does not patch the game executable.
      //
      // Version 1.1.1, format-selection instruction at main+0x65234C:
      // Main build ID: e0f3ccfaf50065ae4ea01eb5aeb13b1a45da3348000000000000000000000000.
      //   0x52800349 -> 0x52800589: mov w9, #26 -> mov w9, #44
      //   Little-endian bytes: 49 03 80 52 -> 89 05 80 52.
      // "agl::RenderDisplay(color)" is a literal at main+0x3D01085, used by the
      // allocation descriptor passed to main+0x3ED00 at main+0x9CD1A0.
      // Recorded static trace: the selected format is stored at object+0x1B8,
      // passed through main+0x6531C0 to main+0x9CD030, then used in that descriptor.
      // These function addresses are not recovered function/class names.
      // Engine format 26 is R11G11B10F; format 44 is RGBA16F. Both float outcomes
      // must select 44. Change only this instruction; preserve the surrounding
      // comparisons and allocation/view handling. Leave the separate UNORM branch
      // at main+0x6525B0 unchanged. Enable this change for HDR startup only; SDR
      // startup must retain the original instruction. Reverify sites for other
      // executable versions; these are main-relative offsets, not IPS file offsets.
      // This is distinct from the patch site at main+0x65545C, and this site
      // alone does not establish an end-to-end signed floating-point buffer chain.
      //
      // Intentionally NOT a ReShade-side R11G11B10F -> RGBA16F upgrade:
      // renodx::utils::resource::ResourceUpgradeInfo float_buffer_upgrade = {
      //     .old_format = reshade::api::format::r11g11b10_float,
      //     .new_format = reshade::api::format::r16g16b16a16_float,
      // };
      // We rely on the game already allocating RGBA16F so its own allocation
      // sizes and views agree; a host resource-format substitution is not a
      // replacement for the executable/recompilation change above.
      // Substitute bytecode during the game's native pipeline creation only.
      // Automatic scheduling also queues runtime fallbacks that reconstruct pipelines.
      renodx::mods::shader::manual_shader_scheduling = true;
      // Same decompiled output program; newer emitter reorders SPIR-V constants.
      custom_shaders.emplace(0x1AA2E33Au, custom_shaders.at(0x92D6F81Du));
      custom_shaders.at(0x1AA2E33Au).crc32 = 0x1AA2E33Au;
      // Observed variants with matching finite-input math; native NaN min/max
      // semantics differ, so these reuse our existing replacement policy.
      for (const auto& [variant, original] : std::array<std::pair<uint32_t, uint32_t>, 11>{
               {{0x59090418u, 0x09EB4538u},
                {0xAFE7D0DFu, 0xED732BB7u},
                {0xDC0F0504u, 0x0CB15954u},
                {0x8758A179u, 0x8B59FC8Fu},
            {0x72093B9Au, 0xA141DF7Du},
            {0x4215C2F2u, 0x09EB4538u},
            {0xFFEC817Au, 0x8B59FC8Fu},
            {0x4B2CB17Du, 0x0258153Cu},
            {0x646D3FBEu, 0xA141DF7Du},
            {0xE43C7048u, 0x96CFD4A3u},
            {0xFD02B807u, 0xD1303F9Fu}}}) {
        custom_shaders.emplace(variant, custom_shaders.at(original));
        custom_shaders.at(variant).crc32 = variant;
      }
      custom_shaders.at(0xED732BB7u).on_draw = &OnDrawScene;
      custom_shaders.at(0xAFE7D0DFu).on_draw = &OnDrawScene;
      custom_shaders.at(0x09EB4538u).on_draw = &OnDrawScene;
      custom_shaders.at(0x59090418u).on_draw = &OnDrawScene;
      custom_shaders.at(0x4215C2F2u).on_draw = &OnDrawScene;
      custom_shaders.at(0x0CB15954u).on_draw = &OnDrawScene;
      custom_shaders.at(0xDC0F0504u).on_draw = &OnDrawScene;
      custom_shaders.at(0x400192C0u).on_draw = &OnDrawAdaptationFog;
      custom_shaders.at(0x0258153Cu).on_draw = &OnDrawAdaptationFog;
      custom_shaders.at(0x4B2CB17Du).on_draw = &OnDrawAdaptationFog;
      for (auto& [hash, shader] : custom_shaders) {
        renodx::utils::shader::QueueCompileTimeReplacement(hash, shader.code);
        shader.views.push_back({
            .type = reshade::api::descriptor_type::constant_buffer,
            .slot = 3u,
            .space = 1u,
            .get_constants = []() -> std::span<const float> { return aa_constants; },
        });
        shader.views.push_back({
            .type = reshade::api::descriptor_type::constant_buffer,
            .slot = 4u,
            .space = 1u,
            .get_constants = []() -> std::span<const float> {
              return {reinterpret_cast<const float*>(&shader_injection), sizeof(shader_injection) / sizeof(float)};
            },
        });
        if (hash != 0xED732BB7u && hash != 0x09EB4538u && hash != 0x0CB15954u
            && hash != 0x59090418u && hash != 0xDC0F0504u && hash != 0xAFE7D0DFu
            && hash != 0x400192C0u && hash != 0x0258153Cu
            && hash != 0x4215C2F2u && hash != 0x4B2CB17Du) continue;
        for (uint32_t slot = 0u; slot < 2u; ++slot) {
          shader.views.push_back({
              .type = reshade::api::descriptor_type::texture_unordered_access_view,
              .slot = slot,
              .space = 1u,
              .get_view = [slot](reshade::api::command_list* cmd_list) {
                auto* data = cmd_list->get_device()->get_private_data<AdaptationDeviceData>();
                if (data == nullptr) return reshade::api::resource_view{};
                std::shared_lock lock(data->mutex);
                return data->views[slot];
              },
          });
        }
        shader.views.push_back({
            .type = reshade::api::descriptor_type::constant_buffer,
            .slot = 2u,
            .space = 1u,
            .get_constants = []() -> std::span<const float> { return adaptation_constants; },
        });
      }
      reshade::register_event<reshade::addon_event::init_device>(OnAdaptationInitDevice);
      reshade::register_event<reshade::addon_event::init_command_queue>(OnAdaptationInitQueue);
      reshade::register_event<reshade::addon_event::execute_command_list>(OnAdaptationExecute);
      reshade::register_event<reshade::addon_event::present>(OnAdaptationPresent);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroyOutputSwapchain);
      reshade::register_event<reshade::addon_event::destroy_device>(OnAdaptationDestroyDevice);
      renodx::utils::resource::Use(reason);
      renodx::utils::settings::Use(reason, &settings, &OnPresetOff);
      renodx::mods::shader::Use(reason, custom_shaders);
      break;
    }
    case DLL_PROCESS_DETACH:
      if (addon_registered) {
        renodx::mods::shader::Use(reason, custom_shaders);
        reshade::unregister_event<reshade::addon_event::present>(OnAdaptationPresent);
        reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroyOutputSwapchain);
        reshade::unregister_event<reshade::addon_event::execute_command_list>(OnAdaptationExecute);
        reshade::unregister_event<reshade::addon_event::destroy_device>(OnAdaptationDestroyDevice);
        reshade::unregister_event<reshade::addon_event::init_command_queue>(OnAdaptationInitQueue);
        reshade::unregister_event<reshade::addon_event::init_device>(OnAdaptationInitDevice);
        renodx::utils::resource::Use(reason);
        renodx::utils::settings::Use(reason, &settings, &OnPresetOff);
        reshade::unregister_addon(h_module);
      }
      break;
  }
  return TRUE;
}