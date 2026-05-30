/*
 * Copyright (C) 2026 Musa Haji and Lazorr
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <atomic>
#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include <mutex>
#include <span>
#include <vector>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "assets/noise/fast_noise_rg8.h"
#include "shared.h"

namespace {

ShaderInjectData shader_injection;

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

reshade::api::resource fast_noise_resource = {0};
reshade::api::resource_view fast_noise_srv = {0};
std::atomic<bool> fast_noise_created{false};
reshade::api::device* fast_noise_owner_device = nullptr;
reshade::api::device* pending_device = nullptr;

static constexpr uint32_t NOISE_WIDTH = 128u;
static constexpr uint32_t NOISE_HEIGHT = 128u;
static constexpr uint32_t NOISE_SLICES = 32u;
static constexpr uint32_t NOISE_TEXEL_COUNT = NOISE_WIDTH * NOISE_HEIGHT * NOISE_SLICES;
static constexpr uint32_t NOISE_BYTES_PER_ELEMENT = static_cast<uint32_t>(sizeof(float) * 2u);
static constexpr uint64_t NOISE_BUFFER_BYTES = static_cast<uint64_t>(NOISE_TEXEL_COUNT) * NOISE_BYTES_PER_ELEMENT;

void CreateFASTNoiseBuffer(reshade::api::device* device) {
  if (fast_noise_created) return;

  static_assert(sizeof(__fast_noise_rg8_base) == NOISE_WIDTH * NOISE_HEIGHT * 2u * NOISE_SLICES,
                "Embedded IS-FAST noise data size mismatch");

  std::vector<float> decoded(NOISE_TEXEL_COUNT * 2u);
  for (uint32_t i = 0u; i < NOISE_TEXEL_COUNT; ++i) {
    decoded[i * 2u + 0u] = static_cast<float>(__fast_noise_rg8_base[i * 2u + 0u]) / 255.0f;
    decoded[i * 2u + 1u] = static_cast<float>(__fast_noise_rg8_base[i * 2u + 1u]) / 255.0f;
  }

  reshade::api::subresource_data initial_data = {};
  initial_data.data = decoded.data();
  initial_data.row_pitch = static_cast<uint32_t>(NOISE_BUFFER_BYTES);
  initial_data.slice_pitch = static_cast<uint32_t>(NOISE_BUFFER_BYTES);

  reshade::api::resource_desc buffer_desc(
      NOISE_BUFFER_BYTES,
      reshade::api::memory_heap::gpu_only,
      reshade::api::resource_usage::shader_resource);

  if (!device->create_resource(buffer_desc, &initial_data,
                               reshade::api::resource_usage::shader_resource, &fast_noise_resource)) {
    reshade::log::message(reshade::log::level::error,
                          "007firstlight: Failed to create IS-FAST noise buffer resource");
    return;
  }

  reshade::api::resource_view_desc srv_desc(
      reshade::api::format::r32_typeless,
      0u,
      static_cast<uint64_t>(NOISE_BUFFER_BYTES / sizeof(uint32_t)));

  if (!device->create_resource_view(fast_noise_resource,
                                    reshade::api::resource_usage::shader_resource, srv_desc, &fast_noise_srv)) {
    reshade::log::message(reshade::log::level::error,
                          "007firstlight: Failed to create SRV for IS-FAST noise buffer");
    device->destroy_resource(fast_noise_resource);
    fast_noise_resource = {0};
    return;
  }

  fast_noise_created = true;
  fast_noise_owner_device = device;
  reshade::log::message(reshade::log::level::info,
                        "007firstlight: IS-FAST noise buffer created for deferred shadow filtering");
}

void DestroyFASTNoiseBuffer(reshade::api::device* device) {
  if (!fast_noise_created) return;
  if (fast_noise_srv.handle != 0u) {
    device->destroy_resource_view(fast_noise_srv);
    fast_noise_srv = {0};
  }
  if (fast_noise_resource.handle != 0u) {
    device->destroy_resource(fast_noise_resource);
    fast_noise_resource = {0};
  }
  fast_noise_created = false;
  fast_noise_owner_device = nullptr;
}

reshade::api::resource_view GetNoiseSRV(reshade::api::command_list* cmd_list) {
  if (!fast_noise_created) {
    static std::mutex creation_mutex;
    std::lock_guard lock(creation_mutex);
    if (!fast_noise_created) {
      reshade::api::device* device = cmd_list != nullptr ? cmd_list->get_device() : pending_device;
      if (device != nullptr) {
        pending_device = device;
        CreateFASTNoiseBuffer(device);
      }
    }
  }
  return fast_noise_srv;
}

void AddISFASTShader(uint32_t crc32, std::span<const uint8_t> code) {
  custom_shaders[crc32] = {
      .crc32 = crc32,
      .code = code,
      .views = {
          {
              .type = reshade::api::descriptor_type::buffer_shader_resource_view,
              .slot = 0,
              .space = 50u,
              .get_view = &GetNoiseSRV,
          },
      },
  };
}

void AddISFASTShaders() {
  AddISFASTShader(0x91447257, __0x91447257);
  AddISFASTShader(0xABDB27F9, __0xABDB27F9);
  AddISFASTShader(0x1D61DE2A, __0x1D61DE2A);
  AddISFASTShader(0x5BF99A8E, __0x5BF99A8E);
  AddISFASTShader(0x9A4B52C5, __0x9A4B52C5);
  AddISFASTShader(0x3C2C790A, __0x3C2C790A);
  AddISFASTShader(0xC02773BA, __0xC02773BA);
  AddISFASTShader(0x7ACD617D, __0x7ACD617D);
  AddISFASTShader(0x6BE10C9B, __0x6BE10C9B);
  AddISFASTShader(0x025B6584, __0x025B6584);
  AddISFASTShader(0x33EEFA91, __0x33EEFA91);
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDX"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_scaling,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per channel matches the original behavior of the tonemapper",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeGamma",
        .binding = &shader_injection.tone_map_gamma,
        .default_value = 1.f,
        .label = "Gamma",
        .section = "Color Grading",
        .min = 0.75f,
        .max = 1.25f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightContrast",
        .binding = &shader_injection.tone_map_contrast_highlights,
        .default_value = 50.f,
        .label = "Highlight Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadowContrast",
        .binding = &shader_injection.tone_map_contrast_shadows,
        .default_value = 50.f,
        .label = "Shadow Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeDechroma",
        .binding = &shader_injection.tone_map_dechroma,
        .default_value = 0.f,
        .label = "Dechroma",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.color_grade_lut_strength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.custom_film_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Vanilla (Broken)", "Vanilla (Fixed)", "Perceptual"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 50.f,
        .label = "FilmGrain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxISFASTShadows",
        .binding = &shader_injection.custom_isfast_shadows,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "IS-FAST Shadow Noise",
        .section = "Shadows",
        .tooltip = "Uses IS-FAST noise for deferred shadow sample rotation to reduce vertical jitter artifacts.",
        .labels = {"Off", "On"},
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-0",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Purist",
        .section = "Options",
        .group = "button-line-0",
        .tooltip = "Follows the original artistic intent more closely.",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"FxFilmGrainType", 1.f},
              {"ToneMapScaling", 1.f},
          });
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "musaqh");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "shortfuse");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Requires HDR on in game\n"),
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapScaling", 1.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeHighlightContrast", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeShadowContrast", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeGamma", 1.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeDechroma", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeLUTStrength", 100.f},
      {"FxBloom", 100.f},
      {"FxFilmGrainType", 0.f},
      {"FxGrainStrength", 50.f},
      {"FxISFASTShadows", 0.f},
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[1]->default_value = peak.value();
    settings[1]->can_reset = true;
  }
}

bool initialized = false;

void OnInitDevice(reshade::api::device* device) {
  pending_device = device;
}

void OnDestroyDevice(reshade::api::device* device) {
  if (fast_noise_created && device == fast_noise_owner_device) {
    DestroyFASTNoiseBuffer(device);
  }
  if (device == pending_device) {
    pending_device = nullptr;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for 007 First Light";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;

        AddISFASTShaders();

        initialized = true;
      }
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
