/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x94614EA1.h> //ui
#include <embed/0xC6FA129B.h> //ui
#include <embed/0xC90A6F07.h> //ui
#include <embed/0xEAADB3AA.h> //ui
#include <embed/0x099B9006.h> //ui -- Party's faces
#include <embed/0xC3979EE8.h> //ui
#include <embed/0x29A889E6.h> //ui
#include <embed/0x2FB8A3BC.h> //ui
#include <embed/0x6D432834.h> //ui
#include <embed/0x8EC8EF33.h> //ui
#include <embed/0xC3126A03.h> //ui
#include <embed/0x2FA199F2.h> //ui
#include <embed/0x76B068AD.h> //ui
#include <embed/0xB86F8772.h> //ui -- Speach bubbles above npc's heads
#include <embed/0x12E3927E.h> //ui -- dialog box
#include <embed/0xBBA0606A.h> //rec709
#include <embed/0xC1BCC6B5.h> //Lut Builder
#include <embed/0xD019CA1A.h> //Tonemapper/unclamp [game world]
#include <embed/0x4D541E80.h> //Tonemapper/unclamp [shop/in-engine cutscenes]
#include <embed/0x3CFCA6D5.h> //Tonemapper/unclamp [tokyo]



#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    // dx11 only
   // todo: gamma correct faces and some other UI shaders
    CustomSwapchainShader(0x94614EA1),  // UI 
    CustomSwapchainShader(0xC6FA129B),  // UI
    CustomSwapchainShader(0xC90A6F07),  // UI
    CustomSwapchainShader(0xEAADB3AA),   // UI
    CustomSwapchainShader(0x099B9006),  // UI -- Party's Faces
    CustomSwapchainShader(0xC3979EE8),  // UI
    CustomSwapchainShader(0x29A889E6),  // UI
    CustomSwapchainShader(0x2FB8A3BC),  // UI
    CustomSwapchainShader(0x6D432834),  // UI
    CustomSwapchainShader(0x8EC8EF33),  // UI
    CustomSwapchainShader(0xC3126A03),  // UI
    CustomSwapchainShader(0x2FA199F2),  // UI
    CustomSwapchainShader(0x76B068AD),  // UI
    CustomSwapchainShader(0xB86F8772),  // UI -- Speach bubbles above npc's heads
    CustomSwapchainShader(0x12E3927E),  // UI -- Dialog box
    CustomShaderEntry(0xBBA0606A),       // 709??
    CustomShaderEntry(0xC1BCC6B5),      // Lut Builder
    CustomShaderEntry(0xD019CA1A),       // Tonemapper!! [game world]
    CustomShaderEntry(0x4D541E80),      // Tonemapper!! [shop/in-engine cutscenes]
    CustomShaderEntry(0x3CFCA6D5)       // Tonemapper!! [tokyo/classroom]

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
        .labels = {"Vanilla", "None", "ACES", "RenoDX"},
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
        .label = "Bloom",
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
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
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
      renodx::mods::shader::force_pipeline_cloning = true; //So the mod works with the toolkit


       // BGRA8_typeless pushes highlights in a good way
      /*
      // BGRA8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.index = 0,
          //.ignore_size = true,
      });
      */

      /*
      // render targets upgrade
      // RGBA8_typeless
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,   
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.index = 0,
          .ignore_size = true,
      });
      
      // RGBA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.index = 0,
          .ignore_size = true,
      });
      // RGBA8_unorm_srgb
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.index = 0,
          .ignore_size = true,
      });
      
      
      
      //RGB10A2_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
      });
      
      // R11G11B10_float
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.ignore_size = true,
      });
      */


      /*
      // BGRA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.index = 0,
          //.ignore_size = true,
      });
      
      
       
      // BGRA8_unorm_srgb
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm_srgb,
          .new_format = reshade::api::format::r16g16b16a16_float,
          //.index = 0,
          .ignore_size = true,
      });

      */

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
