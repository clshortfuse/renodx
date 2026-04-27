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

    CustomShaderEntry(0x8EA31781),  // Lens Flare

    CustomShaderEntry(0x8AFBFA0F),  // tonemap
    CustomShaderEntry(0xC4C732B7),  // tonemap - desaturation
    CustomShaderEntry(0x793F6207),  // tonemap - desaturation + blood
    CustomShaderEntry(0x0646427B),  // tonemap - dizzy
    CustomShaderEntry(0x746E4324),  // tonemap - dizzy + desaturation + blood
    CustomShaderEntry(0xD29C360E),  // tonemap - dizzy + blood
    CustomShaderEntry(0x0FE2C69C),  // tonemap - blood
    CustomShaderEntry(0xEC6C0919),  // tonemap - flashbang
    CustomShaderEntry(0x3282021C),  // tonemap - no motion blur

    // untested tonemap shaders, done in batch
    CustomShaderEntry(0x00A4168B),
    CustomShaderEntry(0x05922218),
    CustomShaderEntry(0x09C787D1),
    CustomShaderEntry(0x0B2018BD),
    CustomShaderEntry(0x13F1B0C2),
    CustomShaderEntry(0x174A943A),
    CustomShaderEntry(0x1C6423B6),
    CustomShaderEntry(0x1FFE87AC),
    CustomShaderEntry(0x2516994B),
    CustomShaderEntry(0x2B9AC3F5),
    CustomShaderEntry(0x2D0A2D3C),
    CustomShaderEntry(0x2D2FD5CF),
    CustomShaderEntry(0x32150225),
    CustomShaderEntry(0x3872E94A),
    CustomShaderEntry(0x3AD0660C),
    CustomShaderEntry(0x3B3AEBE9),
    CustomShaderEntry(0x3B9C6411),
    CustomShaderEntry(0x4198B9C9),
    CustomShaderEntry(0x4232CD40),
    CustomShaderEntry(0x482D27BF),
    CustomShaderEntry(0x4AF4FBBD),
    CustomShaderEntry(0x53092D40),
    CustomShaderEntry(0x57C8C5ED),
    CustomShaderEntry(0x5C6CBB10),
    CustomShaderEntry(0x5DA1F07C),
    CustomShaderEntry(0x63B81F3E),
    CustomShaderEntry(0x684EFA7F),
    CustomShaderEntry(0x696EE0C3),
    CustomShaderEntry(0x6B4D6066),
    CustomShaderEntry(0x6D197C24),
    CustomShaderEntry(0x6E6805B3),
    CustomShaderEntry(0x72824EB3),
    CustomShaderEntry(0x7AAE5175),
    CustomShaderEntry(0x8530B19F),
    CustomShaderEntry(0x882C9228),
    CustomShaderEntry(0x8AF3B1CF),
    CustomShaderEntry(0x8D475CF4),
    CustomShaderEntry(0x8FF33C5A),
    CustomShaderEntry(0x8FF37B42),
    CustomShaderEntry(0x916A3EB9),
    CustomShaderEntry(0x94C8C8AF),
    CustomShaderEntry(0x992490D5),
    CustomShaderEntry(0x9B1B7A3B),
    CustomShaderEntry(0x9CB4B3B3),
    CustomShaderEntry(0x9F3B0C2E),
    CustomShaderEntry(0x9F66B097),
    CustomShaderEntry(0x9FB8F2AF),
    CustomShaderEntry(0xA12A3A52),
    CustomShaderEntry(0xA165B1DC),
    CustomShaderEntry(0xA3A1A206),
    CustomShaderEntry(0xA42E7789),
    CustomShaderEntry(0xBA70D4DE),
    CustomShaderEntry(0xBF47BDEB),
    CustomShaderEntry(0xC48C6BD8),
    CustomShaderEntry(0xC5B944C4),
    CustomShaderEntry(0xC90ABAEC),
    CustomShaderEntry(0xCAFA3751),
    CustomShaderEntry(0xCE613E94),
    CustomShaderEntry(0xD22F7C27),
    CustomShaderEntry(0xD8CB699A),
    CustomShaderEntry(0xDB9A3B41),
    CustomShaderEntry(0xE58DDDD3),
    CustomShaderEntry(0xEC1225A1),
    CustomShaderEntry(0xF3C63133),

    CustomShaderEntry(0xA090F460),  // terminal

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

    CustomShaderEntry(0x05F61FE8),  // final game shader - SMAA T1x
    CustomShaderEntry(0x2D6BBE3A),  // final game shader - SMAA T2x

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
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Requires HDR on in game"),
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

      // Final Shader
      // renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;
      // renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      // renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      // renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      // needed for AA
      // breaks resource views used to linearize the image during AA
      // fixed by removing sRGB encoding from the new final shaders after AA
      for (auto index : {
               10,  // SMAA T1x
               12,  // SMAA T2x
               13,  // SMAA T2x
           }) {
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::b8g8r8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_typeless,
            .index = index,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        });
      }

      // Alias Isolation - Chromatic Aberration
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      });

      // peak nits
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
