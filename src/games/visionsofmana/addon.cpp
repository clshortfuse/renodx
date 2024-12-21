/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

// #define DEBUG_LEVEL_1 //added

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {

    // CustomShaderEntry(0x82F9B4AC),  // Movies, Intro
    ////
    CustomShaderEntry(0xC1BCC6B5),  // Lutbuilder1 [Game world]
    CustomShaderEntry(0xBBA0606A),  // Sample1
    CustomShaderEntry(0xE6EB2840),  // Lutbuilder 2 [Tokyo]
    CustomShaderEntry(0x60E37F45),  // Sample 2 [Cutscenes?]
    CustomShaderEntry(0x6BC6B830),  // Sample 3 [ Stats UI ]
    CustomShaderEntry(0x61C2EA30),  // Lutbuilder3 [Menu]
    CustomShaderEntry(0xB7F426D8),  // Sample 4
    CustomShaderEntry(0xD102F1EB),  // Sample 5
    CustomShaderEntry(0x3FA88630),  // Sandland Sample 1

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
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        //.is_enabled = []() { return shader_injection.toneMapType != 2; },
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
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 50.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.02f - 1.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates Vanilla hue shifts.",
        .min = 0.f,
        .max = 100.f,
        //.is_enabled = []() { return shader_injection.toneMapHueCorrectionMethod != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },

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
          static const std::string obfuscated_link = std::string("start https://discord.gg/5WZX") + std::string("DpmbpP");
          system(obfuscated_link.c_str());
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Get more RenoDX mods!",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          system("start https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Per Channel",
        .section = "Tone Mapping",
        .tooltip = "Applies tonemapping per-channel instead of by luminance",
        .labels = {"Off", "On"},
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.ToneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.toneMapType == 3; },

    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrectionMethod",
        .binding = &shader_injection.toneMapHueCorrectionMethod,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Correction Method",
        .section = "Tone Mapping",
        .tooltip = "Applies hue shift emulation before tonemapping",
        .labels = {"Default", "ACES AP1", "Filmic", "SDR Grade"},
        .is_enabled = []() { return shader_injection.toneMapType == 3; },

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
  // renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
  // renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 50.f);
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
      renodx::mods::shader::expected_constant_buffer_space = 50;  // cbuffer slot 50
      //renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;

      renodx::mods::shader::force_pipeline_cloning = true;   // So the mod works with the toolkit
      renodx::mods::swapchain::use_resource_cloning = true;  //
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;

      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = {
          _swap_chain_proxy_vertex_shader,
          _swap_chain_proxy_vertex_shader + sizeof(_swap_chain_proxy_vertex_shader),
      };
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = {
          _swap_chain_proxy_pixel_shader,
          _swap_chain_proxy_pixel_shader + sizeof(_swap_chain_proxy_pixel_shader),
      };

      renodx::mods::swapchain::force_borderless = false;     // needed for stability
      renodx::mods::swapchain::prevent_full_screen = false;  // needed for stability

      //   //// RGB10_A2 32x32x32 lutbuilder
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
          .dimensions = {.width = 32, .height = 32, .depth = 32},
      });

      //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //       .old_format = reshade::api::format::r8g8b8a8_unorm,
      //       .new_format = reshade::api::format::r16g16b16a16_float,
      //   });

      //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //       .old_format = reshade::api::format::b8g8r8a8_unorm,
      //       .new_format = reshade::api::format::r16g16b16a16_float,
      //   });

      //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //       .old_format = reshade::api::format::r8g8b8a8_typeless,
      //       .new_format = reshade::api::format::r16g16b16a16_float,
      //   });

      //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //       .old_format = reshade::api::format::b8g8r8a8_typeless,
      //       .new_format = reshade::api::format::r16g16b16a16_float,
      //   });

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
