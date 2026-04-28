/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

#define UpgradeRTVShader(value)              \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .on_draw = [](auto* cmd_list) {                                                           \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                       \
            bool changed = false;                                                                   \
            for (auto rtv : rtvs) {                                                                 \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv); \
            }                                                                                       \
            if (changed) {                                                                          \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                  \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});      \
            }                                                                                       \
            return true; }, \
      },                                     \
  }

#define UpgradeRTVReplaceShader(value)       \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .code = __##value,                 \
          .on_draw = [](auto* cmd_list) {                                                             \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                         \
            bool changed = false;                                                                     \
            for (auto rtv : rtvs) {                                                                   \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv);   \
            }                                                                                         \
            if (changed) {                                                                            \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                    \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0}); \
            }                                                                                         \
            return true; }, \
      },                                     \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x2726E8B6),  // Fog

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

    CustomSwapchainShader(0x043049C7),  // Video
    CustomSwapchainShader(0xCC0C2DF3),  // UI - gamma adjust slider notch, line above settings explanations
    CustomSwapchainShader(0x72826F5B),  // UI - some text
    CustomSwapchainShader(0xD98FBA78),  // UI - button prompts
    CustomSwapchainShader(0xF1A79FBF),  // UI - nav elements, pause menu blur
    CustomSwapchainShader(0x335B9229),  // HUD - health bar, interact prompts
    CustomSwapchainShader(0xC38B68F9),  // UI - most text
    CustomSwapchainShader(0xD7880DBE),  // UI - working joe attack qte
    CustomSwapchainShader(0x7560E408),  // UI - Map menu top bar navigation
    CustomSwapchainShader(0xA0A0F573),  // UI - possibly unecessary, selected item in journal
    CustomSwapchainShader(0xF7F77ABD),  // UI - overlay when quitting game from main menus

    CustomSwapchainShader(0xA6B73F9E),  // UI - digital flashes when searching container, startup video with autodesk logo
    CustomSwapchainShader(0x46CDBB69),  // UI - digital flashes in item select
    CustomSwapchainShader(0xE7CF0218),  // UI - transparent element under health bar

    CustomSwapchainShader(0xF42FA869),  // UI - red text background when searching container
    CustomSwapchainShader(0xB95A4E01),  // UI - can't see difference? cxmul red text background when searching container
    CustomSwapchainShader(0xECFC10A2),  // UI - maybe

    UpgradeRTVReplaceShader(0x05F61FE8),  // final game shader - SMAA T1x
    UpgradeRTVReplaceShader(0x2D6BBE3A),  // final game shader - SMAA T2x
    UpgradeRTVReplaceShader(0x23F15352),  // SMAA 1
    UpgradeRTVReplaceShader(0x007F7E1C),  // SMAA 2
    UpgradeRTVReplaceShader(0xD212ED15),  // SMAA T2x

    UpgradeRTVReplaceShader(0x7E16EE16),  // Sharpening, ChromAb SRV - from Alias: Isolation

};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDX"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100%% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.colorGradeHighlightSaturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxLensFlare",
        .binding = &shader_injection.fxLensFlare,
        .default_value = 100.f,
        .label = "Lens Flare",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 100.f,
        .label = "Vignette",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.fxFilmGrainType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Noise", "Film Grain (B&W)", "Film Grain (Colored)"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 100.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxSharpening",
        .binding = &shader_injection.fxSharpening,
        .default_value = 0.f,
        .label = "Sharpening",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value == 0 ? 0.f : exp2(-(1.f - (value * 0.01f))); },
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
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("FxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("FxLensFlare", 50.f);
  renodx::utils::settings::UpdateSetting("FxVignette", 50.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrainType", 0.f);
  renodx::utils::settings::UpdateSetting("FxFilmGrain", 50.f);
  renodx::utils::settings::UpdateSetting("FxSharpening", 0.f);
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (!peak.has_value()) {
    peak = 1000.f;
  }
  settings[1]->default_value = peak.value();
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Alien: Isolation";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 11;
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::swapchain::use_resource_cloning = true;

      // Final Shader
      // renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;
      // renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      // renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      // renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      // Game render + SMAA T1x / T2x
      // breaks resource views used to linearize the image during AA
      // fixed by removing sRGB encoding from the new final shaders after AA
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
          .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER, .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
      });
      // Alias Isolation - Chromatic Aberration
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
          .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER, .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits

      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
