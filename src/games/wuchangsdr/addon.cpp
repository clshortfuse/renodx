/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <string>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/ini_file.hpp"
#include "../../utils/path.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

static const float HDR_TYPE_SWAPCHAIN = 0.f;
static const float HDR_TYPE_UNREAL = 1.f;

static const float VALIDATION_TYPE_VALID = 0.f;
static const float VALIDATION_TYPE_INVALID = 1.f;

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

// bool current_hdr_ini_enabled = false;
// float current_hdr_upgrade = HDR_TYPE_SWAPCHAIN;

// bool initial_hdr_ini_enabled = current_hdr_ini_enabled;
// float initial_hdr_upgrade = HDR_TYPE_SWAPCHAIN;

ShaderInjectData shader_injection;

// std::string GetIniFolderPath() {
//   auto process_name = renodx::utils::platform::GetCurrentProcessPath();
//   bool is_game_pass = process_name.string().find("WinGDK") != std::string::npos;

//   auto envirables_variables = renodx::utils::platform::GetEnvironmentVariables();
//   auto user_profile_pair = envirables_variables.find("USERPROFILE");
//   if (user_profile_pair == envirables_variables.end()) return "";
//   auto user_profile = user_profile_pair->second;
//   if (user_profile.empty()) return "";

//   static const std::string ENGINE_INI_PATH = "/AppData/Local/Project_Plague/Saved/Config/Windows/";
//   static const std::string GAME_PASS_ENGINE_INI_PATH = "/AppData/Local/Project_Plague/Saved/Config/WinGDK/";
//   auto ini_path = is_game_pass ? GAME_PASS_ENGINE_INI_PATH : ENGINE_INI_PATH;
//   return user_profile + ini_path;
// }

// bool CheckHDREnabled() {
//   const auto ini_folder_path = GetIniFolderPath();
//   auto engine_ini_path = ini_folder_path + "Engine.ini";
//   if (renodx::utils::path::CheckExistsFile(engine_ini_path)) {
//     auto ini_contents = renodx::utils::path::ReadTextFile(engine_ini_path);
//     auto ini_map = renodx::utils::ini_file::ParseIniContents(ini_contents);
//     const auto* entry = renodx::utils::ini_file::FindLastEntry(ini_map, "ConsoleVariables", "r.HDR.EnableHDROutput");
//     if (entry != nullptr) {
//       auto value = std::get<2>(*entry);
//       if (value == "1") {
//         reshade::log::message(reshade::log::level::info, "CheckHDREnabled: Enabled");
//         return true;
//       }
//     }
//     reshade::log::message(reshade::log::level::info, "CheckHDREnabled: Not Enabled");
//   }

//   return false;
// }

// bool EnableHDR() {
//   const auto ini_folder_path = GetIniFolderPath();
//   if (ini_folder_path.empty()) {
//     reshade::log::message(reshade::log::level::warning, "EnableHDR: Path not found");
//     return false;
//   }

//   renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", false);
//   if (renodx::utils::ini_file::UpdateIniFile(
//           ini_folder_path + "Engine.ini",
//           {{"ConsoleVariables", "r.HDR.EnableHDROutput", "1"}},
//           true,
//           true)) {
//     reshade::log::message(reshade::log::level::info, "EnableHDR: Updated");
//   } else {
//     reshade::log::message(reshade::log::level::warning, "EnableHDR: Failed");
//   }
//   renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", true);

//   return true;
// }

// bool DisableHDR() {
//   const auto ini_folder_path = GetIniFolderPath();
//   if (ini_folder_path.empty()) {
//     reshade::log::message(reshade::log::level::warning, "DisableHDR: Path not found");
//     return false;
//   }

//   renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", false);
//   if (renodx::utils::ini_file::UpdateIniFile(
//           ini_folder_path + "Engine.ini",
//           {{"ConsoleVariables", "r.HDR.EnableHDROutput", ""}},
//           false,
//           false)) {
//     reshade::log::message(reshade::log::level::info, "DisableHDR: Updated");
//   } else {
//     reshade::log::message(reshade::log::level::info, "DisableHDR: Not Updated");
//   }
//   renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", true);

//   return true;
// }

// bool UsingSwapchainUpgrade() {
//   return (initial_hdr_upgrade == HDR_TYPE_SWAPCHAIN);
// }

// bool UsingSwapchainUtil() {
//   return UsingSwapchainUpgrade();
// }

// void UpdateHDRIni() {
//   if (current_hdr_ini_enabled) {
//     if (current_hdr_upgrade != HDR_TYPE_UNREAL) {
//       reshade::log::message(reshade::log::level::info, "Should disable HDR");
//       DisableHDR();
//       current_hdr_ini_enabled = false;
//     }
//   } else {
//     if (current_hdr_upgrade == HDR_TYPE_UNREAL) {
//       reshade::log::message(reshade::log::level::info, "Should enable HDR");
//       EnableHDR();
//       current_hdr_ini_enabled = true;
//     }
//   }
// }

// const std::unordered_map<std::string, float> CANNOT_PRESET_VALUES = {
//     {"ToneMapPeakNits", 0},
//     {"ToneMapGameNits", 0},
//     {"ToneMapUINits", 0},
//     {"OverrideBlackClip", 0},
//     {"FPSLimit", 0},
// };

// const std::unordered_map<std::string, float> RECOMMENDED_VALUES = {
//     {"ColorGradeLUTScaling", 70.f},
// };

// auto* hdr_upgrade_setting = renodx::templates::settings::CreateSetting({.key = "HDRMethod",
//                                                                         .binding = &current_hdr_upgrade,
//                                                                         .value_type = renodx::utils::settings::SettingValueType::INTEGER,
//                                                                         .default_value = HDR_TYPE_SWAPCHAIN,
//                                                                         .can_reset = false,
//                                                                         .label = "HDR Upgrade Method",
//                                                                         .section = "HDR Settings",
//                                                                         .tooltip = "Sets the method used for upgrading to HDR. Unreal HDR offers full framegen compatibility.",
//                                                                         .labels = {"SDR", "Unreal HDR"},
//                                                                         .on_change_value = [](float previous, float current) { UpdateHDRIni(); },
//                                                                         .is_global = true});

renodx::utils::settings::Settings settings = {
//     new renodx::utils::settings::Setting{
//         .value_type = renodx::utils::settings::SettingValueType::TEXT,
//         .label = "Restart game to apply changes",
//         .tint = 0xFF0000,
//         .is_visible = []() {
//           if (current_hdr_upgrade != initial_hdr_upgrade) return true;
//           if (current_hdr_ini_enabled != initial_hdr_ini_enabled) return true;
//           return false;
//         },
//         .is_sticky = true,
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ToneMapType",
//         .binding = &shader_injection.tone_map_type,
//         .value_type = renodx::utils::settings::SettingValueType::INTEGER,
//         .default_value = 3.f,
//         .label = "Tone Mapper",
//         .section = "Tone Mapping",
//         .tooltip = "Sets the tone mapper type",
//         .labels = {"Vanilla", "None", "ACES", "Vanilla+ (ACES + UE Filmic Blend)", "UE Filmic (SDR)"},
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ToneMapPeakNits",
//         .binding = &shader_injection.peak_white_nits,
//         .default_value = 1000.f,
//         .can_reset = false,
//         .label = "Peak Brightness",
//         .section = "Tone Mapping",
//         .tooltip = "Sets the value of peak white in nits",
//         .min = 48.f,
//         .max = 4000.f,
//         .is_enabled = []() { return shader_injection.tone_map_type == 2.f || shader_injection.tone_map_type == 3.f; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ToneMapGameNits",
//         .binding = &shader_injection.diffuse_white_nits,
//         .default_value = 203.f,
//         .label = "Game Brightness",
//         .section = "Tone Mapping",
//         .tooltip = "Sets the value of 100% white in nits",
//         .min = 48.f,
//         .max = 500.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ToneMapUINits",
//         .binding = &shader_injection.graphics_white_nits,
//         .default_value = 203.f,
//         .label = "UI Brightness",
//         .section = "Tone Mapping",
//         .tooltip = "Sets the brightness of UI and HUD elements in nits",
//         .min = 48.f,
//         .max = 500.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0; },
//     },
//     // new renodx::utils::settings::Setting{
//     //     .key = "ToneMapHueCorrection",
//     //     .binding = &shader_injection.tone_map_hue_correction,
//     //     .default_value = 0.f,
//     //     .label = "Hue Correction",
//     //     .section = "Tone Mapping",
//     //     .tooltip = "Hue retention strength.",
//     //     .max = 100.f,
//     //     .is_enabled = []() { return shader_injection.tone_map_type >= 2 && shader_injection.tone_map_type != 4; },
//     //     .parse = [](float value) { return value * 0.01f; },
//     // },
//     new renodx::utils::settings::Setting{
//         .key = "OverrideBlackClip",
//         .binding = &shader_injection.override_black_clip,
//         .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
//         .default_value = 1.f,
//         .label = "Overrides Black Clip",
//         .section = "Tone Mapping",
//         .tooltip = "Outputs 0.0001 nits for black, prevents crushing.",
//         .is_enabled = []() { return shader_injection.tone_map_type == 3; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ToneMapScaling",
//         .binding = &shader_injection.tone_map_per_channel,
//         .value_type = renodx::utils::settings::SettingValueType::INTEGER,
//         .default_value = 0.f,
//         .label = "Scaling",
//         .section = "Tone Mapping",
//         .tooltip = "Luminance scales colors consistently in midtones and shadows",
//         .labels = {"Luminance", "Per Channel"},
//         .is_enabled = []() { return shader_injection.tone_map_type == 3.f; },
//     },
//     new renodx::utils::settings::Setting{
//         .value_type = renodx::utils::settings::SettingValueType::BUTTON,
//         .label = "Vanilla",
//         .section = "Presets",
//         .group = "button-line-1",
//         .on_change = []() {
//           for (auto* setting : settings) {
//             if (setting->key.empty()) continue;
//             if (!setting->can_reset) continue;
//             if (setting->is_global) continue;
//             if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
//             renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
//           }
//         },
//     },
//     new renodx::utils::settings::Setting{
//         .value_type = renodx::utils::settings::SettingValueType::BUTTON,
//         .label = "Recommended",
//         .section = "Presets",
//         .group = "button-line-1",
//         .on_change = []() {
//           for (auto* setting : settings) {
//             if (setting->key.empty()) continue;
//             if (!setting->can_reset) continue;
//             if (setting->is_global) continue;
//             if (CANNOT_PRESET_VALUES.contains(setting->key)) continue;
//             if (RECOMMENDED_VALUES.contains(setting->key)) {
//               renodx::utils::settings::UpdateSetting(setting->key, RECOMMENDED_VALUES.at(setting->key));
//             } else {
//               renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
//             }
//           }
//         },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeExposure",
//         .binding = &shader_injection.tone_map_exposure,
//         .default_value = 1.f,
//         .label = "Exposure",
//         .section = "Color Grading",
//         .max = 2.f,
//         .format = "%.2f",
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeHighlights",
//         .binding = &shader_injection.tone_map_highlights,
//         .default_value = 50.f,
//         .label = "Highlights",
//         .section = "Color Grading",
//         .max = 100.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//         .parse = [](float value) { return value * 0.02f; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeShadows",
//         .binding = &shader_injection.tone_map_shadows,
//         .default_value = 50.f,
//         .label = "Shadows",
//         .section = "Color Grading",
//         .max = 100.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//         .parse = [](float value) { return value * 0.02f; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeContrast",
//         .binding = &shader_injection.tone_map_contrast,
//         .default_value = 50.f,
//         .label = "Contrast",
//         .section = "Color Grading",
//         .max = 100.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//         .parse = [](float value) { return value * 0.02f; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeSaturation",
//         .binding = &shader_injection.tone_map_saturation,
//         .default_value = 50.f,
//         .label = "Saturation",
//         .section = "Color Grading",
//         .max = 100.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//         .parse = [](float value) { return value * 0.02f; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeHighlightSaturation",
//         .binding = &shader_injection.tone_map_highlight_saturation,
//         .default_value = 50.f,
//         .label = "Highlight Saturation",
//         .section = "Color Grading",
//         .tooltip = "Adds or removes highlight color.",
//         .max = 100.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//         .parse = [](float value) { return value * 0.02f; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeBlowout",
//         .binding = &shader_injection.tone_map_blowout,
//         .default_value = 0.f,
//         .label = "Blowout",
//         .section = "Color Grading",
//         .tooltip = "Controls highlight desaturation due to overexposure.",
//         .max = 100.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//         .parse = [](float value) { return value * 0.01f; },
//     },
//     new renodx::utils::settings::Setting{
//         .key = "ColorGradeFlare",
//         .binding = &shader_injection.tone_map_flare,
//         .default_value = 0.f,
//         .label = "Flare",
//         .section = "Color Grading",
//         .tooltip = "Flare/Glare Compensation",
//         .max = 100.f,
//         .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
//         .parse = [](float value) { return value * 0.02f; },
//     },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.custom_lut_strength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        //.is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTScaling",
        .binding = &shader_injection.custom_lut_scaling,
        .default_value = 70.f,
        .label = "LUT Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
        .max = 100.f,
        //.is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 4; },
        .parse = [](float value) { return value * 0.0065f; },
    },
    //hdr_upgrade_setting,
    // new renodx::utils::settings::Setting{.key = "FPSLimit", .binding = &renodx::utils::swapchain::fps_limit, .default_value = 0.f, .label = "FPS Limit", .section = "Other", .min = 0.f, .max = 480.f},
    //     new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::TEXT,
    //     .label = std::string("Note: This FPS limiter is not recommended with frame gen."),
    //     .section = "Other",
    // },
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
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "ShortFuse's Ko-Fi",
    //     .section = "Links",
    //     .group = "button-line-2",
    //     .tint = 0xFF5A16,
    //     .on_change = []() {
    //       renodx::utils::platform::LaunchURL("https://ko-fi.com/", "shortfuse");
    //     },
    // },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Mod maintained by Jon, with immense help from Musa, Ritsu, and Marat"),
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Special thanks to ShortFuse for RenoDX"),
        .section = "About",
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
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Jon's Ko-Fi",
        .section = "About",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/kickfister");
        },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"toneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapGammaCorrection", 0.f},
      {"UIGammaCorrection", 0.f},
      {"ToneMapHueCorrection", 0.f},
      {"OverrideBlackClip", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeLUTStrength", 0.f},
      {"ColorGradeLUTScaling", 0.f},
      {"FixPostProcess", 0.f},
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

bool initialized = false;
}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Wuchang";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        return (params.size() < 15);
      };

      if (!initialized) {
        //renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, hdr_upgrade_setting);
        // hdr_upgrade_setting->Write();
        // initial_hdr_upgrade = current_hdr_upgrade;

        // initial_hdr_ini_enabled = CheckHDREnabled();
        // current_hdr_ini_enabled = initial_hdr_ini_enabled;
        // UpdateHDRIni();

        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::force_pipeline_cloning = true;

        renodx::utils::settings::use_presets = false;

        // if (initial_hdr_upgrade == HDR_TYPE_SWAPCHAIN) {
        //   renodx::mods::swapchain::use_resource_cloning = true;
        //   renodx::mods::swapchain::expected_constant_buffer_index = 13;
        //   renodx::mods::swapchain::expected_constant_buffer_space = 50;
        //   renodx::mods::swapchain::SetUseHDR10();
        //   renodx::mods::swapchain::swap_chain_proxy_shaders = {
        //       {
        //           reshade::api::device_api::d3d11,
        //           {
        //               .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
        //               .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
        //           },
        //       },
        //       {
        //           reshade::api::device_api::d3d12,
        //           {
        //               .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
        //               .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
        //           },
        //       },
        //   };
        //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
        //                                                                  .new_format = reshade::api::format::r16g16b16a16_float,
        //                                                                  .use_resource_view_cloning = true});

        //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //       .old_format = reshade::api::format::r10g10b10a2_unorm,
        //       .new_format = reshade::api::format::r16g16b16a16_float,
        //       .dimensions = {.width = 32, .height = 32, .depth = 32},
        //       .resource_tag = 1.f,
        //   });

        //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //       .old_format = reshade::api::format::r10g10b10a2_unorm,
        //       .new_format = reshade::api::format::r16g16b16a16_float,
        //       .use_resource_view_cloning = true,
        //       .aspect_ratio = 2560.f / 1024.f,
        //   });
        // }

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  //renodx::utils::swapchain::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  // if (UsingSwapchainUpgrade()) {
  //   renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  // }

  return TRUE;
}
