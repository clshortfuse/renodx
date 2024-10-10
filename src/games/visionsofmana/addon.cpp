/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

// #define DEBUG_LEVEL_1 //added

#include <embed/0x099B9006.h>  //ui -- Party's faces
#include <embed/0x12E3927E.h>  //ui -- dialog box
#include <embed/0x23729AED.h>  //ui -- main menu
#include <embed/0x27A2F211.h>  //ui -- The background in the pause/load menus
#include <embed/0x29A889E6.h>  //ui
#include <embed/0x2FA199F2.h>  //ui
#include <embed/0x2FB8A3BC.h>  //ui
#include <embed/0x3884890C.h>  //ui -- Pause menu skills/items/essence/etc text
#include <embed/0x4ADD8064.h>  //UI
#include <embed/0x6D432834.h>  //ui
#include <embed/0x76B068AD.h>  //ui
#include <embed/0x8EC8EF33.h>  //ui
#include <embed/0x94614EA1.h>  //ui
#include <embed/0xA42D4BBE.h>  //ui
#include <embed/0xB86F8772.h>  //UI -- Speach bubbles above npc's heads
#include <embed/0xC3126A03.h>  //ui
#include <embed/0xC3979EE8.h>  //ui
#include <embed/0xC6FA129B.h>  //ui
#include <embed/0xC90A6F07.h>  //ui
#include <embed/0xEAADB3AA.h>  //ui
#include <embed/0xA6BF5D3C.h> // ui -- World map
#include <embed/0x039B084D.h> // ui -- "take her hand"
////
#include <embed/0x82F9B4AC.h>  // Movies, Intro
////

#include <embed/0x60E37F45.h>  // Sample 2 [Cutscenes?]
#include <embed/0xBBA0606A.h>  // Sample1
#include <embed/0xC1BCC6B5.h>  // Lutbuilder1 [Game world]
#include <embed/0xE6EB2840.h>  // Lutbuilder 2 [Tokyo]
#include <embed/0x6BC6B830.h> // Sample 3 [Stats UI]
#include <embed/0x61C2EA30.h> // Lutbuilder3 [Menu]
#include <embed/0xB7F426D8.h> // Sample 4
#include <embed/0xD102F1EB.h> // Sample 5


#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {

    CustomShaderEntry(0x94614EA1),  // UI
    CustomShaderEntry(0xC6FA129B),  // UI
    CustomShaderEntry(0xC90A6F07),  // UI
    CustomShaderEntry(0xEAADB3AA),  // UI
    CustomShaderEntry(0x099B9006),  // UI -- Party's Faces
    CustomShaderEntry(0xC3979EE8),  // UI
    CustomShaderEntry(0x29A889E6),  // UI
    CustomShaderEntry(0x2FB8A3BC),  // UI
    CustomShaderEntry(0x6D432834),  // UI
    CustomShaderEntry(0x8EC8EF33),  // UI
    CustomShaderEntry(0xC3126A03),  // UI
    CustomShaderEntry(0x2FA199F2),  // UI
    CustomShaderEntry(0x76B068AD),  // UI
    CustomShaderEntry(0x3884890C),  // UI -- Pause menu skills/items/essence/etc text
    CustomShaderEntry(0x27A2F211),  // UI -- The background in the pause/load menus
    CustomShaderEntry(0xB86F8772),  // UI -- Speach bubbles above npc's heads
    CustomShaderEntry(0x12E3927E),  // UI -- Dialog box
    CustomShaderEntry(0xA42D4BBE),  // UI
    CustomShaderEntry(0x4ADD8064),  // UI
    CustomShaderEntry(0x23729AED),  // UI -- Main Menu
    CustomShaderEntry(0xA6BF5D3C), // UI -- World Map
    CustomShaderEntry(0x039B084D), // UI -- "Take Her Hand"
    ////
    CustomShaderEntry(0x82F9B4AC),  // Movies, Intro
    ////
    CustomShaderEntry(0xC1BCC6B5),  // Lutbuilder1 [Game world]
    CustomShaderEntry(0xBBA0606A),  // Sample1
    CustomShaderEntry(0xE6EB2840),  // Lutbuilder 2 [Tokyo]
    CustomShaderEntry(0x60E37F45),  // Sample 2 [Cutscenes?]
    CustomShaderEntry(0x6BC6B830), // Sample 3 [ Stats UI ]
    CustomShaderEntry(0x61C2EA30), // Lutbuilder3 [Menu]
    CustomShaderEntry(0xB7F426D8), // Sample 4
    CustomShaderEntry(0xD102F1EB), // Sample 5


};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES"},
        .is_enabled = []() { return shader_injection.toneMapType != 2; },
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
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100%% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },

    //new renodx::utils::settings::Setting{
    //    .key = "colorGradeBlowout",
    //    .binding = &shader_injection.colorGradeBlowout,
    //    .default_value = 50.f,
    //    .label = "Blowout",
    //    .section = "Color Grading",
    //    .tooltip = "Controls highlight desaturation due to overexposure.",
    //    .max = 100.f,
    //    .parse = [](float value) { return value * 0.01f; },
    //},

    //new renodx::utils::settings::Setting{
    //    .key = "toneMapHueCorrection",
    //    .binding = &shader_injection.toneMapHueCorrection,
    //    .default_value = 50.f,
    //    .label = "Hue Correction",
    //    .section = "Color Grading",
    //    .tooltip = "Emulates hue shifting from the vanilla tonemapper",
    //    .max = 100.f,
    //    .parse = [](float value) { return value * 0.01f; },
    //},

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = " - Please make sure 'Screen Brightness' and 'Field Brightness' are set to default in System Settings/Graphics Settings. \r\n - You can hit 'Revert Category' under Graphics settings to reset said settings to default. \r\n \r\n - Join the HDR Den discord for help!",
        .section = "Instructions",
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          system("start https://discord.gg/5WZXDpmbpP");
        },
    },

};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 2.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  //renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
  //renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 50.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for SMT5V";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;  // So overlays dont kill the game
      };
      renodx::mods::shader::expected_constant_buffer_space = 50;  // Cbuffer slot 50

      renodx::mods::shader::force_pipeline_cloning = true; //So the mod works with the toolkit
      renodx::mods::swapchain::force_borderless = false;     // needed for stability
      renodx::mods::swapchain::prevent_full_screen = false;  // needed for stability

      //// BGRA8_TYPELESS
      //renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //    .old_format = reshade::api::format::b8g8r8a8_typeless,
      //    .new_format = reshade::api::format::r16g16b16a16_float,

      //});

      //// BGRA8_UNORM
      //renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //    .old_format = reshade::api::format::b8g8r8a8_unorm,
      //    .new_format = reshade::api::format::r16g16b16a16_float,

      //});

      //// RGB10A2_UNORM
      //renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //    .old_format = reshade::api::format::b10g10r10a2_unorm,
      //    .new_format = reshade::api::format::r16g16b16a16_float,

      //});

      //// BGRA8_TYPELESS 16:9
      // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //     .old_format = reshade::api::format::b8g8r8a8_typeless,
      //     .new_format = reshade::api::format::r16g16b16a16_float,
      //     .aspect_ratio = 16.f/9.f,

      //});

      //// BGRA8_UNORM 16:9
      // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //     .old_format = reshade::api::format::b8g8r8a8_unorm,
      //     .new_format = reshade::api::format::r16g16b16a16_float,
      //     .aspect_ratio = 16.f/9.f,

      //});

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
