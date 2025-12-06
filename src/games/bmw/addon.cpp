/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/ini_file.hpp"
#include "../../utils/path.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xBFA7B92F), // lutbuilder
    CustomShaderEntry(0xA43658B6), // lutbuilder 2
    CustomShaderEntry(0xE1970A14), // lutbuilder 3
    CustomShaderEntry(0x22FF7D28), // lutbuilder 4
    CustomShaderEntry(0x2136F151), // lutbuilder 5
    CustomShaderEntry(0xA6EBE600), // final shader
};

ShaderInjectData shader_injection;

bool current_hdr_ini_enabled = false;

bool hdr_ini_failed = false;

std::string GetIniFolderPath() {
  auto process_name = renodx::utils::platform::GetCurrentProcessPath();

  auto envirables_variables = renodx::utils::platform::GetEnvironmentVariables();
  auto user_profile_pair = envirables_variables.find("LOCALAPPDATA");
  if (user_profile_pair == envirables_variables.end()) return "";
  auto user_profile = user_profile_pair->second;
  if (user_profile.empty()) return "";

  static const std::string ENGINE_INI_PATH = "/b1/Saved/Config/Windows/";
  auto ini_path = ENGINE_INI_PATH;
  return user_profile + ini_path;
}

bool CheckHDREnabled() {
  const auto ini_folder_path = GetIniFolderPath();
  auto engine_ini_path = ini_folder_path + "Engine.ini";
  if (renodx::utils::path::CheckExistsFile(engine_ini_path)) {
    auto ini_contents = renodx::utils::path::ReadTextFile(engine_ini_path);
    auto ini_map = renodx::utils::ini_file::ParseIniContents(ini_contents);
    const auto* entry = renodx::utils::ini_file::FindLastEntry(ini_map, "ConsoleVariables", "r.HDR.EnableHDROutput");
    if (entry != nullptr) {
      auto value = std::get<2>(*entry);
      if (value == "1") {
        reshade::log::message(reshade::log::level::info, "CheckHDREnabled: Enabled");
        return true;
      }
    }
    reshade::log::message(reshade::log::level::info, "CheckHDREnabled: Not Enabled");
  }

  return false;
}

bool EnableHDR() {
  const auto ini_folder_path = GetIniFolderPath();
  if (ini_folder_path.empty()) {
    reshade::log::message(reshade::log::level::warning, "EnableHDR: Path not found");
    return false;
  }

  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", false);
  
  if (renodx::utils::ini_file::UpdateIniFile(
          ini_folder_path + "Engine.ini",
          {{"ConsoleVariables", "r.HDR.EnableHDROutput", "1"}},
          true,
          true)) {
    reshade::log::message(reshade::log::level::info, "EnableHDR: Updated");
  } else {
    reshade::log::message(reshade::log::level::warning, "EnableHDR: Failed");
    return false;
  }
  
  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", true);

  return true;
}

bool DisableHDR() {
  const auto ini_folder_path = GetIniFolderPath();
  if (ini_folder_path.empty()) {
    reshade::log::message(reshade::log::level::warning, "DisableHDR: Path not found");
    return false;
  }

  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", false);
  if (renodx::utils::ini_file::UpdateIniFile(
          ini_folder_path + "Engine.ini",
          {{"ConsoleVariables", "r.HDR.EnableHDROutput", ""}},
          false,
          false)) {
    reshade::log::message(reshade::log::level::info, "DisableHDR: Updated");
  } else {
    reshade::log::message(reshade::log::level::info, "DisableHDR: Not Updated");
  }
  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", true);

  return true;
}

const std::unordered_map<std::string, float> HDR_LOOK_VALUES = {
    {"toneMapType", 1.f},
    {"toneMapGammaCorrection", 1.f},
    {"colorGradeExposure", 1.f},
    {"colorGradeHighlights", 50.f},
    {"colorGradeShadows", 55.f},
    {"colorGradeContrast", 60.f},
    {"colorGradeSaturation", 60.f},
    {"colorGradeBlowout", 60.f},
    {"colorGradeStrength", 90.f},
    {"colorGradeFlare", 30.f},
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) { return value * 3.f; },
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
        .can_reset = true,
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
        .can_reset = true,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2"},
    },
    /* new renodx::utils::settings::Setting{
        .key = "ToneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Per Channel",
        .section = "Tone Mapping",
        .tooltip = "Applies tonemapping per-channel instead of by luminance (More accurate to SDR but less saturated)",
        .labels = {"Off", "On"},
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
    }, */
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
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return (value * -0.02f) + 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.colorGradeDechroma,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Adds highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return (value * 0.01f); },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeStrength",
        .binding = &shader_injection.colorGradeStrength,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 100.f,
        .label = "Grading Strength",
        .section = "Color Grading",
        .tooltip = "Chooses strength of original color grading.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Presets",
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
        .label = "HDR Look",
        .section = "Presets",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;

            if (HDR_LOOK_VALUES.contains(setting->key)) {
              renodx::utils::settings::UpdateSetting(setting->key, HDR_LOOK_VALUES.at(setting->key));
            } else {
              renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
            }
          }
        },
    },
    /*new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "The mod requires UE HDR cvars and will automatically write those to the Engine.ini on first boot, if not present.",
        .section = "Instructions",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Status: Engine.ini updated. Restart the game!",
        .section = "Instructions",
        .tint = 0xFF0000,
        .is_visible = []() { return (!current_hdr_ini_enabled && !hdr_ini_failed); }
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Status: Updating Engine.ini failed. Try the manual installation instructions.",
        .section = "Instructions",
        .tint = 0xFF0000,
        .is_visible = []() { return (!current_hdr_ini_enabled && hdr_ini_failed); }
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Status: Mod should work correctly.",
        .section = "Instructions",
        .tint = 0x00FF00,
        .is_visible = []() { return current_hdr_ini_enabled; }
    },*/
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "IMPORTANT: After booting the game, RenoDX will write the necessary lines to your game's Engine.ini file. Restart the game for RenoDX to take effect. \r\n\r\n- Use default in-game gamma and brightness \r\n- Disable the default add-ons (Generic depth & Effect runtime sync) to gain performance",
        .section = "Instructions",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Game mod by akuru, RenoDX framework by ShortFuse",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More mods",
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
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    /*new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "If you want to uninstall the mod, here's an easy button to remove the Engine.ini changes. You'll need to manually remove ReShade and the addon.",
        .section = "Uninstall",
        //.is_visible = []() { return current_hdr_ini_enabled; }
    },*/
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Removes the RenoDX Engine.ini changes",
        .section = "Uninstall",
        .group = "button-line-1",
        .on_change = []() {
          DisableHDR();
        },
        //.is_visible = []() { return current_hdr_ini_enabled; }
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeDechroma", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeFlare", 0.f);
  //renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  //renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
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

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX - Black Myth: Wukong";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        if (!CheckHDREnabled()) {
          // UE HDR cvars not present
          if (!EnableHDR()) {
            // something failed while updating
            hdr_ini_failed = true;
          }
        } else {
          // UE HDR cvars present
          current_hdr_ini_enabled = true;
        }

        initialized = true;
      }

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };

      renodx::mods::shader::expected_constant_buffer_space = 50;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      //renodx::mods::shader::force_pipeline_cloning = false; 

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  return TRUE;
}
