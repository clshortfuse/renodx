/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

//#define DEBUG_LEVEL_1 //added


#include <embed/0x15A8E557.h> // UI, Font, weapon menu
#include <embed/0x6130DB10.h> // UI, Hud, Icons
#include <embed/0x1B480C7D.h> // UI
#include <embed/0x623A2690.h> // UI, Save Menu
#include <embed/0x9FD76798.h> // UI, Crafting 1
#include <embed/0x39E8661A.h> // UI, Radio Waves
#include <embed/0x742364E2.h> // Movies -- ingame FMV
#include <embed/0x698CEF9E.h> // Movies -- Intro movies 1
#include <embed/0x6F66059D.h> // Noise
#include <embed/0xB13F7764.h> // Tonemapper




#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {


  CustomShaderEntry(0x15A8E557), // UI, Font, weapon menu
  CustomShaderEntry(0x6130DB10), // UI, Hud, Icons
  CustomShaderEntry(0x1B480C7D), // UI
  CustomShaderEntry(0x623A2690), // UI, Save Menu
  CustomShaderEntry(0x9FD76798), // UI, Crafting 1
  CustomShaderEntry(0x39E8661A), // UI, Radio Waves
  CustomShaderEntry(0x742364E2), // Movies -- Ingame fmv
  CustomShaderEntry(0x698CEF9E), // Movies -- Intro Movies 1
  CustomShaderEntry(0x6F66059D), // Noise
  CustomShaderEntry(0xB13F7764),  // Tonemapper

};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
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

     new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom Strength",
        .section = "Effects",
        .tooltip = "Controls Bloom Strength",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },


};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  //Start PostProcess effects on/off
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);

}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for The Evil Within 2";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::force_pipeline_cloning = true; //So the mod works with the toolkit

      renodx::mods::swapchain::force_borderless = false; //needed for stability
      renodx::mods::swapchain::prevent_full_screen = false; //needed for stability


     
      
      // RGBA8_TYPELESS
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
    //   .index = 39, //Maybe find the specific render target that uncaps the game one day, but not right now
    //   .ignore_size = true, //Ignoring size allows you to uncap when the game runs in a sub-native resolution, but tons of artifacts are created
      });

      // RGBA8_UNORM
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //   .index = 39, //Maybe find the specific render target that uncaps the game one day, but not right now
          //   .ignore_size = true, //Ignoring size allows you to uncap when the game runs in a sub-native resolution, but tons of artifacts are created
      });

      // R11G11B10_Float / FP11
   //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
   //       .old_format = reshade::api::format::r11g11b10_float,
   //       .new_format = reshade::api::format::r16g16b16a16_float,
          //   .index = 39, //Maybe find the specific render target that uncaps the game one day, but not right now
          //   .ignore_size = true, //Ignoring size allows you to uncap when the game runs in a sub-native resolution, but tons of artifacts are created
   //   });

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