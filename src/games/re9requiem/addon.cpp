/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <atomic>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/settings.hpp"
#include "shared.h"

namespace {

ShaderInjectData shader_injection;

static void MarkToneMappingLutInvalidated();
static void MarkToneMappingLutRefreshed();
static void EnsureToneMappingLutBuilderTracking();

static constexpr uint32_t kToneMappingLutBuilderCrc32 = 0x2450198E;
static std::atomic_bool tone_mapping_lut_invalidated = false;

renodx::mods::shader::CustomShaders custom_shaders = {
    {kToneMappingLutBuilderCrc32, {
                                      .crc32 = kToneMappingLutBuilderCrc32,
                                      .code = __0x2450198E,  // OCIOTransformBakeCS_0x2450198E (Tone Mapping LUT builder)
                                      .on_drawn = [](reshade::api::command_list* /*cmd_list*/) {
                                        MarkToneMappingLutRefreshed();
                                      },
                                  }},
    __ALL_CUSTOM_SHADERS};

static void EnsureToneMappingLutBuilderTracking() {
  auto shader = custom_shaders.find(kToneMappingLutBuilderCrc32);
  if (shader == custom_shaders.end()) return;

  // Keep callback tracking even if duplicate hash resolution picks another entry.
  shader->second.on_drawn = [](reshade::api::command_list* /*cmd_list*/) {
    MarkToneMappingLutRefreshed();
  };
}

static void OnToneMappingLutSettingChanged(float previous, float current) {
  if (previous != current) MarkToneMappingLutInvalidated();
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "WARNING: Some changes are not applied yet. Toggle HDR Off/On in-game to apply them.",
        .section = "Tone Mapping",
        .tint = 0xFF3B30,
        .is_visible = []() { return tone_mapping_lut_invalidated.load(std::memory_order_relaxed); },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type.\nToggle HDR off and on again to rebuild the Tone Mapping LUT and fully apply changes.",
        .labels = {"Vanilla", "RenoDX (Vanilla + Neutwo)"},
        .on_change_value = &OnToneMappingLutSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits.\nToggle HDR off and on again to rebuild the Tone Mapping LUT and fully apply changes.",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .on_change_value = &OnToneMappingLutSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits.\nToggle HDR off and on again to rebuild the Tone Mapping LUT and fully apply changes.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .on_change_value = &OnToneMappingLutSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF.\nToggle HDR off and on again to rebuild the Tone Mapping LUT and fully apply changes.",
        .labels = {"Off", "2.2 (Per Channel)", "2.2 (By Luminosity)"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .on_change_value = &OnToneMappingLutSettingChanged,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "UI",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "UIGammaCorrection",
        .binding = &shader_injection.gamma_correction_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI SDR EOTF Emulation",
        .section = "UI",
        .tooltip = "Emulates a 2.2 EOTF for the UI",
        .labels = {"Off", "2.2"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "UIVisibility",
        .binding = &shader_injection.custom_ui_visibility,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI Visibility",
        .section = "UI",
        .labels = {"Hide", "Show"},
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
        .key = "ColorGradePreToneMapShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Pre Tone Map Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradePostToneMapShadows",
        .binding = &shader_injection.post_tone_map_shadows,
        .default_value = 85.f,
        .label = "Post Tone Map Shadows",
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
        .key = "ColorGradePostToneMapFlare",
        .binding = &shader_injection.post_tone_map_flare,
        .default_value = 0.f,
        .label = "Post Tone Map Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_lut_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Selects the strength of the game's custom scene grading.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSceneScaling",
        .binding = &shader_injection.color_grade_lut_scaling,
        .default_value = 0.f,
        .label = "Scene Grading Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the scene grading to full range when size is clamped.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSceneScaling2",
        .binding = &shader_injection.color_grade_lut_scaling_2,
        .default_value = 0.f,
        .label = "Secondary Scene Grading Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the scene grading to full range when size is clamped for the secondary scene grading.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxNoise",
        .binding = &shader_injection.custom_noise,
        .default_value = 0.f,
        .label = "Noise",
        .section = "Effects",
        .tooltip = "Noise pattern added to game in some areas.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxVanillaGrainStrength",
        .binding = &shader_injection.vanilla_grain_strength,
        .default_value = 0.f,
        .label = "Vanilla Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 50.f,
        .label = "Custom Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
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
          MarkToneMappingLutInvalidated();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Match SDR",
        .section = "Options",
        .group = "button-line-0",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"GammaCorrection", 1.f},
              {"ColorGradePreToneMapShadows", 50.f},
              {"ColorGradePostToneMapShadows", 50.f},
              {"FxNoise", 100.f},
              {"FxVanillaGrainStrength", 100.f},
              {"FxGrainStrength", 0.f},
          });
          MarkToneMappingLutInvalidated();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preserve Shadow Detail",
        .section = "Options",
        .group = "button-line-0",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"GammaCorrection", 0.f},
              {"ColorGradePreToneMapShadows", 50.f},
              {"ColorGradePostToneMapShadows", 50.f},
              {"ColorGradeSceneScaling", 100.f},
              {"ColorGradeSceneScaling2", 100.f},
          });
          MarkToneMappingLutInvalidated();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
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
        .label = std::string("- Requires HDR on in game"
                             "\n- Requires REFramework"),
        .section = "About",
    },
};

static void MarkToneMappingLutInvalidated() {
  tone_mapping_lut_invalidated.store(true, std::memory_order_relaxed);
}

static void MarkToneMappingLutRefreshed() {
  tone_mapping_lut_invalidated.store(false, std::memory_order_relaxed);
}

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"GammaCorrection", 0.f},
      {"ToneMapUINits", 203.f},
      {"UIGammaCorrection", 0.f},
      {"UIVisibility", 1.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeGamma", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradePreToneMapShadows", 50.f},
      {"ColorGradePostToneMapShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeDechroma", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradePostToneMapFlare", 0.f},
      {"ColorGradeScene", 100.f},
      {"ColorGradeSceneScaling", 0.f},
      {"ColorGradeSceneScaling2", 0.f},
      {"FxNoise", 100.f},
      {"FxVanillaGrainStrength", 100.f},
      {"FxGrainStrength", 0.f},
  });
  MarkToneMappingLutInvalidated();
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

void OnInitDevice(reshade::api::device* device) {
#if UPGRADE_FP11
  std::vector<renodx::utils::resource::ResourceUpgradeInfo> upgrade_infos = {};

  int vendor_id;
  auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
  if (retrieved && vendor_id == 0x10de) {  // Nvidia vendor ID
                                           // Bugs out AMD GPUs
    upgrade_infos.push_back({
        .old_format = reshade::api::format::r11g11b10_float,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
                       .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
    });
  }

  renodx::utils::resource::upgrade::SetUpgradeInfos(device, upgrade_infos);
#endif
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Resident Evil Requiem";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::utils::resource::upgrade::Use(fdw_reason);  // fp16 upgrades
      EnsureToneMappingLutBuilderTracking();

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::utils::settings::on_preset_changed_callbacks.emplace_back([]() {
          MarkToneMappingLutInvalidated();
        });

        initialized = true;
      }
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);        // fp11 upgrades for NVIDIA
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::resource::upgrade::Use(fdw_reason);  // fp16 upgrades

      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);        // fp11 upgrades for NVIDIA
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);  // film grain
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
