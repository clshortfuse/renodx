/*
 * Copyright (C) 2023 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

thread_local uint64_t g_current_uav0 = 0;

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

#define UpgradeUAVShader(value)                                                                        \
  {                                                                                                    \
      value,                                                                                           \
      {                                                                                                \
          .crc32 = value,                                                                              \
          .on_draw = [](auto* cmd_list) {                                                              \
            reshade::api::resource_view current_uav0 = {g_current_uav0};                               \
            if (current_uav0.handle == 0) return true;                                                 \
            if (renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), current_uav0)) { \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                     \
            }                                                                                          \
            return true;                                                                               \
          },                                                                                           \
      },                                                                                               \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    // Upgrades
    UpgradeRTVReplaceShader(0xD7E646E3),  // tonemap
    UpgradeRTVReplaceShader(0x6BE69EF3),  // tonemap, no bloom
    UpgradeRTVReplaceShader(0xEBD83636),  // tonemap, no bloom, no lut

    UpgradeRTVShader(0x723CBF3F),  // AA?
    UpgradeRTVShader(0x315EA715),  // AA?

    UpgradeRTVShader(0x7561AC83),  // MLAAx2/x4
    UpgradeRTVShader(0x44FAE038),  // MLAAx2/x4

    UpgradeRTVShader(0x8A421A14),  // FXAA
    UpgradeRTVShader(0x0B263009),  // FXAA

    UpgradeUAVShader(0xF28CD45D),  // FSR1 Compute Shader
    UpgradeUAVShader(0x5647AAC2),  // FSR1 Compute Shader

    __ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDX (Vanilla+)", "RenoDX (Custom)"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 10000.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .is_logarithmic = true,
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
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type == 1.f; },
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
        .tooltip = "Flare/Glare",
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 0.f,
        .label = "Grain Strength",
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
};
void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapScaling", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeDechroma", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeLUTStrength", 100.f},
      {"FxBloom", 100.f},
      {"FxGrainStrength", 0.f},
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

void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (update.count == 0u) return;
  if (update.type != reshade::api::descriptor_type::texture_unordered_access_view) return;

  for (uint32_t i = 0u; i < update.count; i++) {
    if ((update.binding + i) != 0u) continue;

    g_current_uav0 = static_cast<const reshade::api::resource_view*>(update.descriptors)[i].handle;
    return;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Elite Dangerous";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::force_pipeline_cloning = true;

        // Swapchain Proxy
        renodx::mods::swapchain::SetUseHDR10();
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
        renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

        // On Demand Upgrades
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = true,
            .use_resource_view_hot_swap = true,
        });

        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = true,
            .use_resource_view_hot_swap = true,
            .usage_include = reshade::api::resource_usage::unordered_access,
        });

        initialized = true;
      }

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::utils::random::Use(fdw_reason, {&shader_injection.custom_random});

  return TRUE;
}
