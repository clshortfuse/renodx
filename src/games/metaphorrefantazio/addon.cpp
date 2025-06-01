/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

// Empty addon just for running the game in HDR

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

#define OutputShaderEntry(value)                         \
  {                                                      \
      value,                                             \
      {                                                  \
          .crc32 = value,                                \
          .code = __##value,                             \
          .on_drawn = [](auto cmd_list) {                \
            shader_injection.output_has_drawn = 1.f;     \
            shader_injection.lutbuilder_has_drawn = 0.f; \
            return true;                                 \
          },                                             \
      },                                                 \
  }

#define LutBuilderShaderEntry(value)                     \
  {                                                      \
      value,                                             \
      {                                                  \
          .crc32 = value,                                \
          .code = __##value,                             \
          .on_drawn = [](auto cmd_list) {                \
            shader_injection.output_has_drawn = 0.f;     \
            shader_injection.lutbuilder_has_drawn = 1.f; \
            return true;                                 \
          },                                             \
      },                                                 \
  }

#define GodrayShaderEntry(value)                      \
  {                                                   \
      value,                                          \
      {                                               \
          .crc32 = value,                             \
          .code = __##value,                          \
          .on_draw = [](auto cmd_list) {              \
            shader_injection.godray_drawn_count += 1; \
            return true;                              \
          },                                          \
      },                                              \
  }

#define FinalShaderEntry(value)                          \
  {                                                      \
      value,                                             \
      {                                                  \
          .crc32 = value,                                \
          .code = __##value,                             \
          .on_drawn = [](auto cmd_list) {                \
            shader_injection.output_has_drawn = 0.f;     \
            shader_injection.lutbuilder_has_drawn = 0.f; \
            shader_injection.godray_drawn_count = 0.f;   \
            return true;                                 \
          },                                             \
      },                                                 \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    LutBuilderShaderEntry(0xD8196629),
    OutputShaderEntry(0xAC103037),
    GodrayShaderEntry(0x0DA4540E),
    FinalShaderEntry(0x1F993880),
    __ALL_CUSTOM_SHADERS,
};

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({renodx::templates::settings::CreateDefaultSettings({
                                                                                            {"ToneMapType", &shader_injection.tone_map_type},
                                                                                            {"ToneMapPeakNits", &shader_injection.peak_white_nits},
                                                                                            {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
                                                                                            {"ToneMapUINits", &shader_injection.graphics_white_nits},
                                                                                            {"ColorGradeExposure", &shader_injection.tone_map_exposure},
                                                                                            {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
                                                                                            {"ColorGradeShadows", &shader_injection.tone_map_shadows},
                                                                                            {"ColorGradeContrast", &shader_injection.tone_map_contrast},
                                                                                            {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
                                                                                            {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
                                                                                            {"ColorGradeBlowout", &shader_injection.tone_map_blowout},
                                                                                            {"ColorGradeFlare", &shader_injection.tone_map_flare},
                                                                                        }),
                                                                                        {
                                                                                            new renodx::utils::settings::Setting{
                                                                                                .key = "SwapChainCustomColorSpace",
                                                                                                .binding = &shader_injection.swap_chain_custom_color_space,
                                                                                                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                                                                                                .default_value = 0.f,
                                                                                                .label = "Custom Color Space",
                                                                                                .section = "Display Output",
                                                                                                .tooltip = "Selects output color space"
                                                                                                           "\nUS Modern for BT.709 D65."
                                                                                                           "\nJPN Modern for BT.709 D93."
                                                                                                           "\nUS CRT for BT.601 (NTSC-U)."
                                                                                                           "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                                                                                                           "\nDefault: US CRT",
                                                                                                .labels = {
                                                                                                    "US Modern",
                                                                                                    "JPN Modern",
                                                                                                    "US CRT",
                                                                                                    "JPN CRT",
                                                                                                },
                                                                                                .is_visible = []() { return settings[0]->GetValue() >= 2; },
                                                                                            },
                                                                                            new renodx::utils::settings::Setting{
                                                                                                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                                                                                                .label = "Special thanks to Shortfuse & the folks at HDR Den for their support! Join the HDR Den discord for help!",
                                                                                                .section = "About",
                                                                                            },
                                                                                            new renodx::utils::settings::Setting{
                                                                                                .value_type = renodx::utils::settings::SettingValueType::BUTTON,
                                                                                                .label = "HDR Den Discord",
                                                                                                .section = "About",
                                                                                                .group = "button-line-1",
                                                                                                .tint = 0x5865F2,
                                                                                                .on_change = []() {
                                                                                                  renodx::utils::platform::LaunchURL("https://discord.gg/5WZX", "DpmbpP");
                                                                                                },
                                                                                            },
                                                                                            new renodx::utils::settings::Setting{
                                                                                                .value_type = renodx::utils::settings::SettingValueType::BUTTON,
                                                                                                .label = "Get more RenoDX mods!",
                                                                                                .section = "About",
                                                                                                .group = "button-line-1",
                                                                                                .tint = 0x5865F2,
                                                                                                .on_change = []() {
                                                                                                  renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
                                                                                                },
                                                                                            },
                                                                                            new renodx::utils::settings::Setting{
                                                                                                .value_type = renodx::utils::settings::SettingValueType::BUTTON,
                                                                                                .label = "ShortFuse's Ko-Fi",
                                                                                                .section = "About",
                                                                                                .group = "button-line-1",
                                                                                                .tint = 0xFF5F5F,
                                                                                                .on_change = []() {
                                                                                                  renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
                                                                                                },
                                                                                            },
                                                                                            new renodx::utils::settings::Setting{
                                                                                                .value_type = renodx::utils::settings::SettingValueType::BUTTON,
                                                                                                .label = "HDR Den's Ko-Fi",
                                                                                                .section = "About",
                                                                                                .group = "button-line-1",
                                                                                                .tint = 0xFF5F5F,
                                                                                                .on_change = []() {
                                                                                                  renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden");
                                                                                                },
                                                                                            },
                                                                                            new renodx::utils::settings::Setting{
                                                                                                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                                                                                                .label = "This build was compiled on " + build_date + " at " + build_time + ".",
                                                                                                .section = "About",
                                                                                            },
                                                                                        }});

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapGammaCorrection", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  settings[2]->can_reset = true;
  if (peak.has_value()) {
    settings[2]->default_value = roundf(peak.value());
  } else {
    settings[2]->default_value = 1000.f;
  }

  // highlights
  settings[6]->can_reset = true;
  settings[6]->default_value = 55.f;

  settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);
  fired_on_init_swapchain = true;
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX Metaphor";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX Metaphor";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::shader::force_pipeline_cloning = true;  // So the mod works with the toolkit

      // RGBA8_unorm
      /* renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      }); */
      // RGBA8_unorm_srgb
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      // RGB10A2_unorm
      /* renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      // R11G11B10_float
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      // BGRA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      // BGRA8_unorm_srgb
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm_srgb,
          .new_format = reshade::api::format::r16g16b16a16_float,
      }); */

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
