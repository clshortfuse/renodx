/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
// #define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2
// #define DEBUG_LEVEL_3
#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "shared.h"

namespace {

#define UpgradeRTVReplaceShader(value)                                                                         \
  {                                                                                                            \
      value,                                                                                                   \
      {                                                                                                        \
          .crc32 = value,                                                                                      \
          .code = __##value,                                                                                   \
          .on_draw = [](auto* cmd_list) {                                                                      \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                                  \
            bool changed = false;                                                                              \
            for (auto rtv : rtvs) {                                                                            \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv) || changed; \
            }                                                                                                  \
            if (changed) {                                                                                     \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                             \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});          \
            }                                                                                                  \
            return true;                                                                                       \
          },                                                                                                   \
      },                                                                                                       \
  }

#define UpgradeRTVShader(value)                                                                                \
  {                                                                                                            \
      value,                                                                                                   \
      {                                                                                                        \
          .crc32 = value,                                                                                      \
          .on_draw = [](auto* cmd_list) {                                                                      \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                                  \
            bool changed = false;                                                                              \
            for (auto rtv : rtvs) {                                                                            \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv) || changed; \
            }                                                                                                  \
            if (changed) {                                                                                     \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                             \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});          \
            }                                                                                                  \
            return true;                                                                                       \
          },                                                                                                   \
      },                                                                                                       \
  }

ShaderInjectData shader_injection;

constexpr float FALLBACK_PEAK_NITS = 1000.f;
bool peak_nits_default_initialized = false;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;

renodx::mods::shader::CustomShaders custom_shaders = {
    // Drawn directly onto swapchain
    UpgradeRTVReplaceShader(0xCB1874B7),  // PostFX
    UpgradeRTVReplaceShader(0xB7822C98),  // PostFX - MSAA 4x
    UpgradeRTVReplaceShader(0xCC0D7856),  // PostFX - MSAA 8x
    UpgradeRTVReplaceShader(0xC3EDCD63),  // PostFX - Scanlines - MSAA Off
    UpgradeRTVReplaceShader(0x5770A95E),  // PostFX - Scanlines - MSAA 2x
    UpgradeRTVReplaceShader(0x30842A90),  // PostFX - Scanlines - MSAA 4x
    UpgradeRTVReplaceShader(0x1F296E17),  // PostFX - Scanlines - MSAA 8x
    UpgradeRTVReplaceShader(0xD3F808EC),  // PostFX - Letterbox
    UpgradeRTVReplaceShader(0x17ECFF74),  // PostFX

    UpgradeRTVShader(0xDE56DCA4),  // MSAA 2x resolve
    UpgradeRTVShader(0x0CF23584),  // MSAA 4x resolve
    UpgradeRTVShader(0xE58346BE),  // MSAA 8x resolve

    __ALL_CUSTOM_SHADERS,
};

renodx::utils::settings::Settings settings = {
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = FALLBACK_PEAK_NITS,
        .label = "Peak Brightness",
        .section = "Output",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 10000.f,
        .is_logarithmic = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Output",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Output",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Output",
        .tooltip = "Emulates output decoding used on SDR displays.",
        .labels = {"None", "2.2", "BT.1886"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDX (Vanilla+)", "RenoDX (PsychoV)"},
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightContrast",
        .binding = &shader_injection.tone_map_contrast_highlights,
        .default_value = 50.f,
        .label = "Highlight Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadowContrast",
        .binding = &shader_injection.tone_map_contrast_shadows,
        .default_value = 50.f,
        .label = "Shadow Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
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
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain_strength,
        .default_value = 0.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
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
        .label = "PsychoV Recommended Settings",
        .section = "Options",
        .group = "button-line-0",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ToneMapType", 2.f},
              {"ColorGradeContrast", 52.f},
              {"ColorGradeShadows", 33.f},
              {"ColorGradeFlare", 73.f},
              {"GammaCorrection", 0.f},
              {"FxFilmGrain", 25.f},
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
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0.f},
      {"ColorGradeHighlightContrast", 50.f},
      {"ColorGradeShadowContrast", 50.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeDechroma", 0.f},
      {"ColorGradeFlare", 0.f},
      {"FxBloom", 100.f},
      {"FxFilmGrain", 0.f},
  });
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool /*resize*/) {
  if (swapchain == nullptr || peak_nits_default_initialized) return;
  peak_nits_default_initialized = true;

  const auto detected_peak_nits = renodx::utils::swapchain::GetPeakNits(swapchain);
  tone_map_peak_nits_setting->default_value = detected_peak_nits.value_or(FALLBACK_PEAK_NITS);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Max Payne 3";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_index = 13;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
        renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx11;
        renodx::mods::swapchain::swapchain_proxy_revert_state = true;

        renodx::mods::swapchain::SetUseHDR10();

        initialized = true;
      }

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,  // Results in black screen otherwise
      });

      // Defer typeless upgrades until PostFX to avoid affecting earlier shadow passes.
      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_hot_swap = true,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason, {&shader_injection.custom_random});
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
