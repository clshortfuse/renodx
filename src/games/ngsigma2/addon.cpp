/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings(
{
  renodx::templates::settings::CreateDefaultSettings({
    {"ToneMapType", {.binding = &shader_injection.tone_map_type, .labels = {"Vanilla", "Exponential Rolloff"}}}
  }),
  renodx::templates::settings::CreateDefaultSettings({
  {"ToneMapPeakNits", &shader_injection.peak_white_nits},
  {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
  {"ToneMapUINits", &shader_injection.graphics_white_nits},
  {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
  {"ToneMapHueCorrection", &shader_injection.tone_map_hue_correction},
  {"ToneMapHueShift", &shader_injection.tone_map_hue_shift},
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
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "HDR Look",
      .section = "Presets",
      .group = "button-line-1",
      .tint = 0xb5b2b1,
      .on_change = []() {
        renodx::utils::settings::UpdateSetting("ToneMapType", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapHueProcessor", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapWorkingColorSpace", 0.f);
        renodx::utils::settings::UpdateSetting("GammaCorrection", 1.f);
        renodx::utils::settings::UpdateSetting("ToneMapScaling", 0.f);
        renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 55.f);
        renodx::utils::settings::UpdateSetting("ColorGradeShadows", 57.f);
        renodx::utils::settings::UpdateSetting("ColorGradeContrast", 60.f);
        renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 60.f);
        renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
        renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 50.f);
        renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
      }
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "Reset All",
      .section = "Presets",
      .group = "button-line-1",
      .on_change = []() {
        for (auto setting : settings) {
          if (setting->key.empty()) continue;
          if (!setting->can_reset) continue;
          renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
        }
      },
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "Game mod by akuru, RenoDX Framework by ShortFuse",
      .section = "About",
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "HDR Den Discord",
      .section = "Links",
      .group = "button-line-1",
      .tint = 0x5865F2,
      .on_change = []() {
        renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc");
      },
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::BUTTON,
      .label = "More RenoDX mods",
      .section = "Links",
      .group = "button-line-1",
      .on_change = []() {
        renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
      },
  },
  new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
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

  //settings[3]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[2]->default_value), 203.f);

  fired_on_init_swapchain = true;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Ninja Gaiden Sigma 2";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      //renodx::mods::swapchain::swapchain_proxy_revert_state = true;

      // RGBA8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          //.ignore_size = true,
      });

      // RGBA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          //.ignore_size = true,
      });

      // B8G8R8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          //.ignore_size = true,
      });

      // B8G8R8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          //.ignore_size = true,
      });

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}