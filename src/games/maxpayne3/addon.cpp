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
    // Tone Mapping
    UpgradeRTVReplaceShader(0x01F5E795),
    UpgradeRTVReplaceShader(0x03A86F66),
    UpgradeRTVReplaceShader(0x0933B817),
    UpgradeRTVReplaceShader(0x0C569FD2),
    UpgradeRTVReplaceShader(0x0D3AF9C7),
    UpgradeRTVReplaceShader(0x114F4F53),
    UpgradeRTVReplaceShader(0x117628FE),
    UpgradeRTVReplaceShader(0x14AEA21C),
    UpgradeRTVReplaceShader(0x15B7734B),
    UpgradeRTVReplaceShader(0x15E1CBDD),
    UpgradeRTVReplaceShader(0x16CFDCB8),
    UpgradeRTVReplaceShader(0x17A1A6D3),
    UpgradeRTVReplaceShader(0x19F74577),
    UpgradeRTVReplaceShader(0x1AC127A1),
    UpgradeRTVReplaceShader(0x1E050193),
    UpgradeRTVReplaceShader(0x1E2ADE00),
    UpgradeRTVReplaceShader(0x1EA3AFF3),
    UpgradeRTVReplaceShader(0x1FC015A1),
    UpgradeRTVReplaceShader(0x23B18BD8),
    UpgradeRTVReplaceShader(0x25E34175),
    UpgradeRTVReplaceShader(0x2C22239B),
    UpgradeRTVReplaceShader(0x2D1B343D),
    UpgradeRTVReplaceShader(0x3037741F),
    UpgradeRTVReplaceShader(0x32FA784C),
    UpgradeRTVReplaceShader(0x3615A753),
    UpgradeRTVReplaceShader(0x3C11574E),
    UpgradeRTVReplaceShader(0x3E1C4800),
    UpgradeRTVReplaceShader(0x4E20C085),
    UpgradeRTVReplaceShader(0x5164E9B0),
    UpgradeRTVReplaceShader(0x51E829A0),
    UpgradeRTVReplaceShader(0x5591404A),
    UpgradeRTVReplaceShader(0x572E9E14),
    UpgradeRTVReplaceShader(0x57D8BE2F),
    UpgradeRTVReplaceShader(0x59F2397F),
    UpgradeRTVReplaceShader(0x5A714D9A),
    UpgradeRTVReplaceShader(0x5BDCF58B),
    UpgradeRTVReplaceShader(0x5D6CE5AA),
    UpgradeRTVReplaceShader(0x5DC18676),
    UpgradeRTVReplaceShader(0x5F7F2CF0),
    UpgradeRTVReplaceShader(0x5FEA60BA),
    UpgradeRTVReplaceShader(0x62FBFD42),
    UpgradeRTVReplaceShader(0x6577C52F),
    UpgradeRTVReplaceShader(0x669480A7),
    UpgradeRTVReplaceShader(0x69865D5B),
    UpgradeRTVReplaceShader(0x69A7604F),
    UpgradeRTVReplaceShader(0x6DCED770),
    UpgradeRTVReplaceShader(0x6F56C009),
    UpgradeRTVReplaceShader(0x76CE7813),
    UpgradeRTVReplaceShader(0x7A442117),
    UpgradeRTVReplaceShader(0x7CB0B3AA),
    UpgradeRTVReplaceShader(0x7FAFDA2A),
    UpgradeRTVReplaceShader(0x80A70632),
    UpgradeRTVReplaceShader(0x88668588),
    UpgradeRTVReplaceShader(0x8DE915B0),
    UpgradeRTVReplaceShader(0x8EE688FF),
    UpgradeRTVReplaceShader(0x90A1640C),
    UpgradeRTVReplaceShader(0x96C78726),
    UpgradeRTVReplaceShader(0x982D2E83),
    UpgradeRTVReplaceShader(0x985D8946),
    UpgradeRTVReplaceShader(0x988E0440),
    UpgradeRTVReplaceShader(0x9A761B73),
    UpgradeRTVReplaceShader(0x9ADA439F),
    UpgradeRTVReplaceShader(0x9D18D405),
    UpgradeRTVReplaceShader(0x9F31A4DD),
    UpgradeRTVReplaceShader(0xA20B8702),
    UpgradeRTVReplaceShader(0xA237779F),
    UpgradeRTVReplaceShader(0xA5CFC1D9),
    UpgradeRTVReplaceShader(0xB133932C),
    UpgradeRTVReplaceShader(0xB1A5D3BC),
    UpgradeRTVReplaceShader(0xB2AB7C39),
    UpgradeRTVReplaceShader(0xB3E0329B),
    UpgradeRTVReplaceShader(0xB481AC95),
    UpgradeRTVReplaceShader(0xB802E7CF),
    UpgradeRTVReplaceShader(0xC016166E),
    UpgradeRTVReplaceShader(0xC0603F3A),
    UpgradeRTVReplaceShader(0xC1CD0E29),
    UpgradeRTVReplaceShader(0xC35017A0),
    UpgradeRTVReplaceShader(0xC51143A4),
    UpgradeRTVReplaceShader(0xC92236C8),
    UpgradeRTVReplaceShader(0xCCD10E2A),
    UpgradeRTVReplaceShader(0xCD48C081),
    UpgradeRTVReplaceShader(0xCD5272DD),
    UpgradeRTVReplaceShader(0xD20F4621),
    UpgradeRTVReplaceShader(0xD29EAC60),
    UpgradeRTVReplaceShader(0xD5EC60BF),
    UpgradeRTVReplaceShader(0xD7538577),
    UpgradeRTVReplaceShader(0xDB7B34F8),
    UpgradeRTVReplaceShader(0xDCCD53B8),
    UpgradeRTVReplaceShader(0xE36C9160),
    UpgradeRTVReplaceShader(0xE4322A68),
    UpgradeRTVReplaceShader(0xE5A49BBB),
    UpgradeRTVReplaceShader(0xE9E20657),
    UpgradeRTVReplaceShader(0xEA3CC1E3),
    UpgradeRTVReplaceShader(0xEA3F39A4),
    UpgradeRTVReplaceShader(0xECCE1541),
    UpgradeRTVReplaceShader(0xF20EF8A7),
    UpgradeRTVReplaceShader(0xF225B2E1),
    UpgradeRTVReplaceShader(0xF803A073),
    UpgradeRTVReplaceShader(0xF895DAFE),
    UpgradeRTVReplaceShader(0xFC2389A4),
    UpgradeRTVReplaceShader(0xFE7B20B4),
    UpgradeRTVReplaceShader(0xFF318C23),
    UpgradeRTVReplaceShader(0x4F343009),
    UpgradeRTVReplaceShader(0x10EE0B20),
    UpgradeRTVReplaceShader(0xA631D7F8),

    // Anti-Aliasing
    UpgradeRTVReplaceShader(0x3FA8CBC3),  // FXAA - High
    UpgradeRTVReplaceShader(0xFBC327C8),  // FXAA - Very High

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
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
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
          .use_resource_view_cloning = true,
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
