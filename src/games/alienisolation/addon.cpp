/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID                   ImU64
#define RENODX_MODS_SWAPCHAIN_VERSION 2
#define DEBUG_LEVEL_0
// #define ALIENISOLATION_ALIAS_LOGGING 1

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./aliasisolation/aliasisolation.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

static bool HasRGBA16FloatRenderTarget(reshade::api::command_list* cmd_list) {
  const auto& rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);
  for (const auto& rtv : rtvs) {
    if (rtv.handle == 0u) continue;

    auto* view_info = renodx::utils::resource::GetResourceViewInfo(rtv);
    if (view_info != nullptr && view_info->desc.format == reshade::api::format::r16g16b16a16_float) {
      return true;
    }
  }

  return false;
}

static bool IsAliasIsolationEnabled(reshade::api::command_list*) {
  return alienisolation::aliasisolation::constant_buffers::IsEnabled();
}

static bool SkipAliasIsolationShaderInjection(reshade::api::command_list*) {
  return false;
}

static bool logged_alias_shadow_linearize = false;
static bool logged_alias_shadow_downsample = false;
#if ALIENISOLATION_ENABLE_BARREL_DISTORTION_REMOVAL
static bool logged_alias_main_post = false;
#endif
#if ALIENISOLATION_ENABLE_BLOOM_MERGE_REPLACEMENT
static bool logged_alias_bloom_merge = false;
#endif

static bool AliasIsolationReplacementGate(const char* name, uint32_t hash, bool& logged) {
  const bool enabled = IsAliasIsolationEnabled(nullptr);
  if (enabled && !logged) {
    logged = true;
    alienisolation::aliasisolation::logging::Info("using mods::shader replacement ", name, " hash=", alienisolation::aliasisolation::logging::Crc32(hash));
  }
  return enabled;
}

#define CustomRGBA16FloatShader(value)                                                      \
  {                                                                                         \
    value, { .crc32 = value, .code = __##value, .on_replace = &HasRGBA16FloatRenderTarget } \
  }

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

#define AliasIsolationReplacementShader(value, replacement_shader, name, log_state)                                        \
  {                                                                                                                        \
    value, {                                                                                                               \
        .crc32 = value,                                                                                                    \
        .code = replacement_shader,                                                                                        \
        .on_replace = [](reshade::api::command_list*) { return AliasIsolationReplacementGate(name, value, log_state); },   \
        .on_inject = &SkipAliasIsolationShaderInjection,                                                                   \
    }                                                                                                                      \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x2726E8B6),  // Fog
    CustomShaderEntry(0x043049C7),  // Video

#if ALIENISOLATION_ENABLE_BARREL_DISTORTION_REMOVAL
    AliasIsolationReplacementShader(
        alienisolation::aliasisolation::shader_hashes::MAIN_POST_VS,
        __aliasisolation_main_post,
        "barrel distortion VS",
        logged_alias_main_post),
#endif
    AliasIsolationReplacementShader(
        alienisolation::aliasisolation::shader_hashes::SHADOW_LINEARIZE_PS,
        __aliasisolation_shadow_linearize,
        "shadow linearize PS",
        logged_alias_shadow_linearize),
    AliasIsolationReplacementShader(
        alienisolation::aliasisolation::shader_hashes::SHADOW_DOWNSAMPLE_PS,
        __aliasisolation_shadow_downsample,
        "shadow downsample PS",
        logged_alias_shadow_downsample),
#if ALIENISOLATION_ENABLE_BLOOM_MERGE_REPLACEMENT
    AliasIsolationReplacementShader(
        alienisolation::aliasisolation::shader_hashes::BLOOM_MERGE_PS,
        __aliasisolation_bloom_merge,
        "bloom merge PS",
        logged_alias_bloom_merge),
#endif

    UpgradeRTVReplaceShader(0x8EA31781),  // Lens Flare

    UpgradeRTVReplaceShader(0x8AFBFA0F),  // tonemap
    UpgradeRTVReplaceShader(0xC4C732B7),  // tonemap - desaturation
    UpgradeRTVReplaceShader(0x793F6207),  // tonemap - desaturation + blood
    UpgradeRTVReplaceShader(0x0646427B),  // tonemap - dizzy
    UpgradeRTVReplaceShader(0x746E4324),  // tonemap - dizzy + desaturation + blood
    UpgradeRTVReplaceShader(0xD29C360E),  // tonemap - dizzy + blood
    UpgradeRTVReplaceShader(0x0FE2C69C),  // tonemap - blood
    UpgradeRTVReplaceShader(0xEC6C0919),  // tonemap - flashbang
    UpgradeRTVReplaceShader(0x3282021C),  // tonemap - no motion blur

    // untested tonemap shaders, done in batch
    UpgradeRTVReplaceShader(0x00A4168B),
    UpgradeRTVReplaceShader(0x05922218),
    UpgradeRTVReplaceShader(0x09C787D1),
    UpgradeRTVReplaceShader(0x0B2018BD),
    UpgradeRTVReplaceShader(0x13F1B0C2),
    UpgradeRTVReplaceShader(0x174A943A),
    UpgradeRTVReplaceShader(0x1C6423B6),
    UpgradeRTVReplaceShader(0x1FFE87AC),
    UpgradeRTVReplaceShader(0x2516994B),
    UpgradeRTVReplaceShader(0x2B9AC3F5),
    UpgradeRTVReplaceShader(0x2D0A2D3C),
    UpgradeRTVReplaceShader(0x2D2FD5CF),
    UpgradeRTVReplaceShader(0x32150225),
    UpgradeRTVReplaceShader(0x3872E94A),
    UpgradeRTVReplaceShader(0x3AD0660C),
    UpgradeRTVReplaceShader(0x3B3AEBE9),
    UpgradeRTVReplaceShader(0x3B9C6411),
    UpgradeRTVReplaceShader(0x4198B9C9),
    UpgradeRTVReplaceShader(0x4232CD40),
    UpgradeRTVReplaceShader(0x482D27BF),
    UpgradeRTVReplaceShader(0x4AF4FBBD),
    UpgradeRTVReplaceShader(0x53092D40),
    UpgradeRTVReplaceShader(0x57C8C5ED),
    UpgradeRTVReplaceShader(0x5C6CBB10),
    UpgradeRTVReplaceShader(0x5DA1F07C),
    UpgradeRTVReplaceShader(0x63B81F3E),
    UpgradeRTVReplaceShader(0x684EFA7F),
    UpgradeRTVReplaceShader(0x696EE0C3),
    UpgradeRTVReplaceShader(0x6B4D6066),
    UpgradeRTVReplaceShader(0x6D197C24),
    UpgradeRTVReplaceShader(0x6E6805B3),
    UpgradeRTVReplaceShader(0x72824EB3),
    UpgradeRTVReplaceShader(0x7AAE5175),
    UpgradeRTVReplaceShader(0x8530B19F),
    UpgradeRTVReplaceShader(0x882C9228),
    UpgradeRTVReplaceShader(0x8AF3B1CF),
    UpgradeRTVReplaceShader(0x8D475CF4),
    UpgradeRTVReplaceShader(0x8FF33C5A),
    UpgradeRTVReplaceShader(0x8FF37B42),
    UpgradeRTVReplaceShader(0x916A3EB9),
    UpgradeRTVReplaceShader(0x94C8C8AF),
    UpgradeRTVReplaceShader(0x992490D5),
    UpgradeRTVReplaceShader(0x9B1B7A3B),
    UpgradeRTVReplaceShader(0x9CB4B3B3),
    UpgradeRTVReplaceShader(0x9F3B0C2E),
    UpgradeRTVReplaceShader(0x9F66B097),
    UpgradeRTVReplaceShader(0x9FB8F2AF),
    UpgradeRTVReplaceShader(0xA12A3A52),
    UpgradeRTVReplaceShader(0xA165B1DC),
    UpgradeRTVReplaceShader(0xA3A1A206),
    UpgradeRTVReplaceShader(0xA42E7789),
    UpgradeRTVReplaceShader(0xBA70D4DE),
    UpgradeRTVReplaceShader(0xBF47BDEB),
    UpgradeRTVReplaceShader(0xC48C6BD8),
    UpgradeRTVReplaceShader(0xC5B944C4),
    UpgradeRTVReplaceShader(0xC90ABAEC),
    UpgradeRTVReplaceShader(0xCAFA3751),
    UpgradeRTVReplaceShader(0xCE613E94),
    UpgradeRTVReplaceShader(0xD22F7C27),
    UpgradeRTVReplaceShader(0xD8CB699A),
    UpgradeRTVReplaceShader(0xDB9A3B41),
    UpgradeRTVReplaceShader(0xE58DDDD3),
    UpgradeRTVReplaceShader(0xEC1225A1),
    UpgradeRTVReplaceShader(0xF3C63133),

    // CustomShaderEntry(0xA090F460),  // terminal

    CustomRGBA16FloatShader(0xCC0C2DF3),  // UI - gamma adjust slider notch, line above settings explanations
    CustomRGBA16FloatShader(0x72826F5B),  // UI - some text
    CustomRGBA16FloatShader(0xD98FBA78),  // UI - button prompts
    CustomRGBA16FloatShader(0xF1A79FBF),  // UI - nav elements, pause menu blur
    CustomRGBA16FloatShader(0x335B9229),  // HUD - health bar, interact prompts
    CustomRGBA16FloatShader(0xC38B68F9),  // UI - most text
    CustomRGBA16FloatShader(0xD7880DBE),  // UI - working joe attack qte
    CustomRGBA16FloatShader(0x7560E408),  // UI - Map menu top bar navigation
    CustomRGBA16FloatShader(0xA0A0F573),  // UI - possibly unecessary, selected item in journal
    CustomRGBA16FloatShader(0xF7F77ABD),  // UI - overlay when quitting game from main menus

    CustomRGBA16FloatShader(0xA6B73F9E),  // UI - digital flashes when searching container, startup video with autodesk logo
    CustomRGBA16FloatShader(0x46CDBB69),  // UI - digital flashes in item select
    CustomRGBA16FloatShader(0xE7CF0218),  // UI - transparent element under health bar

    CustomRGBA16FloatShader(0xF42FA869),  // UI - red text background when searching container
    CustomRGBA16FloatShader(0xB95A4E01),  // UI - can't see difference? cxmul red text background when searching container
    CustomRGBA16FloatShader(0xECFC10A2),  // UI - maybe

    UpgradeRTVReplaceShader(0x05F61FE8),  // final game shader - SMAA T1x
    UpgradeRTVReplaceShader(0x2D6BBE3A),  // final game shader - SMAA T2x
    UpgradeRTVReplaceShader(0x23F15352),  // SMAA 1
    UpgradeRTVReplaceShader(0x007F7E1C),  // SMAA 2
    UpgradeRTVReplaceShader(0xD212ED15),  // SMAA T2x

    CustomShaderEntry(0xEEEC0277),  // FXAA

};

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
        .tooltip = "Sets the value of 100%% white in nits",
        .min = 48.f,
        .max = 500.f,
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
        .binding = &shader_injection.custom_lut_strength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
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
        .key = "FxLensFlare",
        .binding = &shader_injection.custom_lens_flare,
        .default_value = 100.f,
        .label = "Lens Flare",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.custom_vignette,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.custom_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Noise", "Film Grain (B&W)", "Film Grain (Colored)"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 100.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
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
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/musaqh"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeDechroma", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("FxBloom", 100.f);
  renodx::utils::settings::UpdateSetting("FxLensFlare", 100.f);
  renodx::utils::settings::UpdateSetting("FxVignette", 100.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrainType", 0.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrain", 100.f);
  alienisolation::aliasisolation::OnPresetOff();
}

struct __declspec(uuid("95F75086-12B7-4574-BE86-A91EA9390802")) DeviceData {
  std::vector<reshade::api::resource_view> swapchain_rtvs;
  reshade::api::pipeline final_pipeline = {};
  reshade::api::resource final_texture = {};
  reshade::api::resource_view final_texture_view = {};
  reshade::api::sampler final_texture_sampler = {};
  reshade::api::pipeline_layout final_layout = {};
};

constexpr reshade::api::pipeline_layout PIPELINE_LAYOUT{0};

void OnInitDevice(reshade::api::device* device) {
  auto* data = device->create_private_data<DeviceData>();

  {
    std::vector<reshade::api::pipeline_subobject> subobjects;

    reshade::api::shader_desc vs_desc = {};
    vs_desc.code = __swap_chain_proxy_vertex_shader.data();
    vs_desc.code_size = __swap_chain_proxy_vertex_shader.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::vertex_shader, 1, &vs_desc});

    reshade::api::shader_desc ps_desc = {};
    ps_desc.code = __swap_chain_proxy_pixel_shader.data();
    ps_desc.code_size = __swap_chain_proxy_pixel_shader.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::pixel_shader, 1, &ps_desc});

    reshade::api::format format = reshade::api::format::r16g16b16a16_float;
    subobjects.push_back({reshade::api::pipeline_subobject_type::render_target_formats, 1, &format});

    uint32_t num_vertices = 3;
    subobjects.push_back({reshade::api::pipeline_subobject_type::max_vertex_count, 1, &num_vertices});

    auto topology = reshade::api::primitive_topology::triangle_list;
    subobjects.push_back({reshade::api::pipeline_subobject_type::primitive_topology, 1, &topology});

    reshade::api::blend_desc blend_state = {};
    subobjects.push_back({reshade::api::pipeline_subobject_type::blend_state, 1, &blend_state});

    reshade::api::rasterizer_desc rasterizer_state = {};
    rasterizer_state.cull_mode = reshade::api::cull_mode::none;
    subobjects.push_back({reshade::api::pipeline_subobject_type::rasterizer_state, 1, &rasterizer_state});

    reshade::api::depth_stencil_desc depth_stencil_state = {};
    depth_stencil_state.depth_enable = false;
    depth_stencil_state.depth_write_mask = false;
    depth_stencil_state.depth_func = reshade::api::compare_op::always;
    depth_stencil_state.stencil_enable = false;
    depth_stencil_state.front_stencil_read_mask = 0xFF;
    depth_stencil_state.front_stencil_write_mask = 0xFF;
    depth_stencil_state.front_stencil_func = depth_stencil_state.back_stencil_func;
    depth_stencil_state.front_stencil_fail_op = depth_stencil_state.back_stencil_fail_op;
    depth_stencil_state.front_stencil_depth_fail_op = depth_stencil_state.back_stencil_depth_fail_op;
    depth_stencil_state.front_stencil_pass_op = depth_stencil_state.back_stencil_pass_op;
    depth_stencil_state.back_stencil_read_mask = 0xFF;
    depth_stencil_state.back_stencil_write_mask = 0xFF;
    depth_stencil_state.back_stencil_func = reshade::api::compare_op::always;
    depth_stencil_state.back_stencil_fail_op = reshade::api::stencil_op::keep;
    depth_stencil_state.back_stencil_depth_fail_op = reshade::api::stencil_op::keep;
    depth_stencil_state.back_stencil_pass_op = reshade::api::stencil_op::keep;
    subobjects.push_back({reshade::api::pipeline_subobject_type::depth_stencil_state, 1, &depth_stencil_state});

    device->create_pipeline(PIPELINE_LAYOUT, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &data->final_pipeline);
  }

  {
    reshade::api::pipeline_layout_param params = {};
    params.type = reshade::api::pipeline_layout_param_type::push_constants;
    params.push_constants.count = sizeof(shader_injection) / 4;
    params.push_constants.dx_register_index = 11;
    params.push_constants.visibility = reshade::api::shader_stage::all_graphics;
    device->create_pipeline_layout(1, &params, &data->final_layout);
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr) return;

  device->destroy_pipeline(data->final_pipeline);
  device->destroy_pipeline_layout(data->final_layout);

  device->destroy_private_data<DeviceData>();
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr) return;

  if (!fired_on_init_swapchain) {
    fired_on_init_swapchain = true;

    auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
    if (!peak.has_value()) {
      peak = 1000.f;
    }
    settings[1]->default_value = peak.value();
  }

  for (uint32_t i = 0; i < swapchain->get_back_buffer_count(); ++i) {
    auto back_buffer_resource = swapchain->get_back_buffer(i);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    auto desc = reshade::api::resource_view_desc(
        reshade::api::resource_view_type::texture_2d,
        reshade::api::format_to_default_typed(back_buffer_desc.texture.format),
        0,
        1,
        0,
        1);
    device->create_resource_view(back_buffer_resource, reshade::api::resource_usage::render_target, desc, &data->swapchain_rtvs.emplace_back());
  }

  {
    auto back_buffer_resource = swapchain->get_back_buffer(0);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    reshade::api::resource_desc desc = {};
    desc.type = reshade::api::resource_type::texture_2d;
    desc.texture = {
        back_buffer_desc.texture.width,
        back_buffer_desc.texture.height,
        1,
        1,
        reshade::api::format_to_typeless(back_buffer_desc.texture.format),
        1,
    };
    desc.heap = reshade::api::memory_heap::gpu_only;
    desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
    desc.flags = reshade::api::resource_flags::none;
    device->create_resource(desc, nullptr, reshade::api::resource_usage::shader_resource, &data->final_texture);
    device->create_resource_view(
        data->final_texture,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format)),
        &data->final_texture_view);
    device->create_sampler({}, &data->final_texture_sampler);
  }
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr) return;

  for (const auto& rtv : data->swapchain_rtvs) {
    device->destroy_resource_view(rtv);
  }
  data->swapchain_rtvs.clear();

  device->destroy_sampler(data->final_texture_sampler);
  device->destroy_resource_view(data->final_texture_view);
  device->destroy_resource(data->final_texture);

  data->final_texture_sampler = {};
  data->final_texture_view = {};
  data->final_texture = {};
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  auto* cmd_list = queue->get_immediate_command_list();
  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr || data->final_texture.handle == 0) return;

  auto back_buffer_resource = swapchain->get_current_back_buffer();
  auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);

  {
    const reshade::api::resource resources[2] = {back_buffer_resource, data->final_texture};
    const reshade::api::resource_usage state_old[2] = {reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource};
    const reshade::api::resource_usage state_new[2] = {reshade::api::resource_usage::copy_source, reshade::api::resource_usage::copy_dest};

    cmd_list->barrier(2, resources, state_old, state_new);
    cmd_list->copy_texture_region(back_buffer_resource, 0, nullptr, data->final_texture, 0, nullptr);
    cmd_list->barrier(2, resources, state_new, state_old);
  }

  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, data->final_pipeline);
  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::render_target);

  reshade::api::render_pass_render_target_desc render_target = {};
  render_target.view = data->swapchain_rtvs.at(swapchain->get_current_back_buffer_index());
  cmd_list->begin_render_pass(1, &render_target, nullptr);

  cmd_list->push_descriptors(
      reshade::api::shader_stage::all_graphics,
      PIPELINE_LAYOUT,
      0,
      reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::texture_shader_resource_view, &data->final_texture_view});
  cmd_list->push_descriptors(
      reshade::api::shader_stage::all_graphics,
      PIPELINE_LAYOUT,
      0,
      reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::sampler, &data->final_texture_sampler});

  cmd_list->push_constants(reshade::api::shader_stage::all_graphics, data->final_layout, 0, 0, sizeof(shader_injection) / 4, &shader_injection);

  const reshade::api::viewport viewport = {
      0.0f,
      0.0f,
      static_cast<float>(back_buffer_desc.texture.width),
      static_cast<float>(back_buffer_desc.texture.height),
      0.0f,
      1.0f};
  cmd_list->bind_viewports(0, 1, &viewport);

  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();
  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Alien: Isolation";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      alienisolation::aliasisolation::AppendSettings(settings, &shader_injection);

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

      renodx::mods::shader::expected_constant_buffer_index = 11;
      // renodx::mods::shader::force_pipeline_cloning = true;

      renodx::mods::swapchain::use_resource_cloning = true;

      // Tonemap + SMAA T1x / T2x
      // breaks resource views used to linearize the image during AA
      // fixed by removing sRGB encoding from the new final shaders after AA
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
          .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER, .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
          .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER, .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
      });

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      break;
  }

  alienisolation::aliasisolation::Use(fdw_reason, &shader_injection);
  renodx::utils::random::Use(fdw_reason);  // film grain
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
