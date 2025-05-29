/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

// #include <embed/0x9165A474.h> // black smoke
// #include <embed/0xEC3D14D2.h> // distant fog/smoke
// #include <embed/0x32A56036.h> // distant fog/smoke
// #include <embed/0x372AEE4E.h> // black smoke
// #include <embed/0xAB16B3F7.h> // fire
// #include <embed/0xB561688F.h> // distant smoke?
// #include <embed/0x1FB36E90.h> // screen blood effect
// #include <embed/0x61D242D6.h>  // bloom
// #include <embed/0XBA89E3AC.h> // lens flare - sunstar
// #include <embed/0x3F53E66E.h>  // lens flare - circles and color
// #include <embed/0x95588EA5.h> // radial dirty lens effect
// #include <embed/0x8135BEA2.h> // radial lens flare
// #include <embed/0xA67ABF78.h>  // tonemap
// #include <embed/0xA6EC1DEC.h>  // god rays

// #include <embed/0x11737C11.h> // debris and other effects?
// #include <embed/0x372BEBAB.h>  // LUT 1 (only used in title screen?)
// #include <embed/0xED9872EB.h> // AA?
// #include <embed/0x45D95DCB.h>  // LUT 2c - B&W Film Grain
// #include <embed/0x558540C8.h>  // Gamma adjust
// #include <embed/0x8194877A.h>  // caps brightness
// #include <embed/0xBA423838.h>  // LUT 2d - B&W No Film Grain
// #include <embed/0xC20255E1.h>  // LUT 2a - Film Grain
// #include <embed/0xD42BAD58.h>  // LUT 2b - No Film Grain

// #include <embed/0x548937E1.h>    // UI - loading screen
// #include <embed/0x404A04C7.h>    // UI - highlighted stuff, orange elements
// #include <embed/0xBCBEE1E5.h>    // UI - text
// #include <embed/0xDC15A986.h>    // UI - Alpha, semitransparent UI boxes, quit overlay
// #include <embed/0x6562755C.h>    // UI - Alpha, some text
// #include <embed/0xB917BF4E.h>    // UI - HUD, nav arrows, sliders, some icons, text boxes
// #include <embed/0x7E8358E3.h>    // UI - HUD numbers
// #include <embed/0x929C8CA5.h>    // UI - Minimap
// #include <embed/0x4D09799F.h>    // UI - HUD Floating markers
// #include <embed/0x9F9A6B19.h>    // UI - Menu tab bar
// #include <embed/0xD292312D.h>    // UI - ?
// #include <embed/0x822D56FA.h>    // UI - Menu blur
// #include <embed/0x23EFA382.h>    // UI - Images
// #include <embed/0x7D5191F6.h>    // UI - Loading please wait
// #include <embed/0x637A1F5C.h>    // UI - popup notification
// #include <embed/0x379D46ED.h>    // UI - Death screen images
#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "Vanilla+ (DICE)"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .can_reset = false,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 50.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates hue shifting from the vanilla tonemapper",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeGamutExpansion",
        .binding = &shader_injection.colorGradeGamutExpansion,
        .default_value = 0.f,
        .label = "Gamut Expansion",
        .section = "Color Grading",
        .tooltip = "Generates HDR colors (BT.2020) from bright saturated SDR (BT.709) ones.",  // Description taken from pumboautohdr
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxLensFlare",
        .binding = &shader_injection.fxLensFlare,
        .default_value = 100.f,
        .label = "Lens Flare",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "FilmGrain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 100.f);
  renodx::utils::settings::UpdateSetting("fxLensFlare", 100.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
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
  bool was_upgraded = renodx::mods::swapchain::IsUpgraded(swapchain);
  if (was_upgraded) {
    settings[1]->default_value = 100.f;
  }
}

}  // namespace

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Dying Light";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

        renodx::mods::shader::force_pipeline_cloning = true;
      //   renodx::mods::shader::trace_unmodified_shaders = true;
      renodx::mods::swapchain::force_borderless = false;
      //   renodx::mods::swapchain::prevent_full_screen = true;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak and paper white

      for (auto index : {3, 4}) {
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .index = index,
        });
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak and paper white
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}