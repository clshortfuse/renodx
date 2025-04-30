/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <cstdint>
#include <filesystem>
#include <shared_mutex>
#include <string>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/ini_file.hpp"
#include "../../utils/path.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

int lut_invalidation_level = 0;
int global_invalidation_level = 0;

bool current_hdr_ini_enabled = false;
float current_hdr_upgrade = 3.f;
float current_render_reshade_before_ui = 0.f;

bool initial_hdr_ini_enabled = current_hdr_ini_enabled;
float initial_hdr_upgrade = current_hdr_upgrade;
float initial_render_reshade_before_ui = current_render_reshade_before_ui;

ShaderInjectData shader_injection;

bool OnLutBuilderReplace(reshade::api::command_list* cmd_list) {
  lut_invalidation_level = 0;
  return true;
}

bool OnCustomGammaDrawn(reshade::api::command_list* cmd_list) {
  if (initial_render_reshade_before_ui == 0.f && initial_hdr_upgrade == 0.f) return true;
  if (current_render_reshade_before_ui == 0.f) return true;

  auto* cmd_list_data = renodx::utils::data::Get<renodx::utils::swapchain::CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return true;
  if (cmd_list_data->current_render_targets.empty()) return true;

  auto rtv0 = cmd_list_data->current_render_targets[0];
  if (rtv0.handle == 0) return true;
  if (initial_hdr_upgrade != 0.f) {
    auto* info = renodx::utils::resource::GetResourceViewInfo(rtv0);
    if (info->clone.handle != 0u) {
      rtv0 = info->clone;
    }
  }

  auto* data = renodx::utils::data::Get<renodx::utils::swapchain::DeviceData>(cmd_list->get_device());
  if (data == nullptr) return true;
  const std::shared_lock lock(data->mutex);
  for (auto* runtime : data->effect_runtimes) {
    runtime->render_effects(cmd_list, rtv0, rtv0);
  }

  return true;
}

std::string GetIniFolderPath() {
  auto process_name = renodx::utils::platform::GetCurrentProcessPath();
  bool is_game_pass = process_name.string().find("WinGDK") != std::string::npos;

  auto envirables_variables = renodx::utils::platform::GetEnvironmentVariables();
  auto user_profile_pair = envirables_variables.find("USERPROFILE");
  if (user_profile_pair == envirables_variables.end()) return "";
  auto user_profile = user_profile_pair->second;
  if (user_profile.empty()) return "";

  static const std::string ENGINE_INI_PATH = "/Documents/My Games/Oblivion Remastered/Saved/Config/Windows/";
  static const std::string GAME_PASS_ENGINE_INI_PATH = "/Documents/My Games/Oblivion Remastered/Saved/Config/WinGDK/";
  auto ini_path = is_game_pass ? GAME_PASS_ENGINE_INI_PATH : ENGINE_INI_PATH;
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
        reshade::log::message(reshade::log::level::info, "Found HDR enabled in Engine.ini");
        return true;
      }
    }
    reshade::log::message(reshade::log::level::info, "HDR not enabled in Engine.ini");
  }

  return false;
}

bool EnableHDR() {
  const auto ini_folder_path = GetIniFolderPath();
  if (ini_folder_path.empty()) return false;

  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", false);
  if (renodx::utils::ini_file::UpdateIniFile(
          ini_folder_path + "Engine.ini",
          {{"ConsoleVariables", "r.HDR.EnableHDROutput", "1"}},
          true,
          true)) {
    reshade::log::message(reshade::log::level::info, "Enabled HDR in Engine.ini");
  } else {
    reshade::log::message(reshade::log::level::warning, "Failed to enabled HDR in Engine.ini");
  }
  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", true);

  return true;
}

bool DisableHDR() {
  const auto ini_folder_path = GetIniFolderPath();
  if (ini_folder_path.empty()) return false;

  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", false);
  if (renodx::utils::ini_file::UpdateIniFile(
          ini_folder_path + "Engine.ini",
          {{"ConsoleVariables", "r.HDR.EnableHDROutput", "0"}},
          false,
          false)) {
    reshade::log::message(reshade::log::level::info, "Disabled HDR in Engine.ini");
  } else {
    reshade::log::message(reshade::log::level::info, "HDR not enabled in Engine.ini");
  }
  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", true);

  return true;
}

bool UpdateUIBrightnessIni() {
  const auto ini_folder_path = GetIniFolderPath();
  if (ini_folder_path.empty()) return false;

  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", false);
  if (renodx::utils::ini_file::UpdateIniFile(
          ini_folder_path + "Engine.ini",
          {{"ConsoleVariables", "r.HDR.UI.Luminance", std::to_string(static_cast<std::uint32_t>(shader_injection.graphics_white_nits))}},
          true,
          true)) {
    reshade::log::message(reshade::log::level::info, "Enabled HDR in Engine.ini");
  } else {
    reshade::log::message(reshade::log::level::warning, "Failed to enabled HDR in Engine.ini");
  }
  renodx::utils::platform::UpdateReadOnlyAttribute(ini_folder_path + "Engine.ini", true);

  return true;
}

void UpdateHDRIni() {
  if (current_hdr_ini_enabled) {
    if (current_hdr_upgrade != 3.f) {
      reshade::log::message(reshade::log::level::info, "Should disable HDR");
      DisableHDR();
      current_hdr_ini_enabled = false;
    }
  } else {
    if (current_hdr_upgrade == 3.f) {
      reshade::log::message(reshade::log::level::info, "Should enable HDR");
      EnableHDR();
      current_hdr_ini_enabled = true;
    }
  }
}

renodx::mods::shader::CustomShaders custom_shaders = {
    // Lut Builders
    CustomShaderEntryCallback(0x00C34813, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x35359B86, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x47329E4A, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x484B4E2B, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x56299258, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x57EE8201, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x5D14010F, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x704AB527, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x7D28F020, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x81243B91, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x8AB5FB23, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x92690156, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x9ECC8B3C, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xA8DA5452, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xAF588657, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xB439D7F0, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xC3C5B8AD, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xC51C976F, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xF890095A, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xFF16F46F, &OnLutBuilderReplace),

    // Eye Adaptation
    CustomShaderEntry(0x41DCD632),

    // Output
    CustomShaderEntry(0xEED8F029),
    CustomShaderEntry(0x8E39B831),
    CustomShaderEntry(0x59C7FFCE),
    CustomShaderEntry(0x1BD60193),
    CustomShaderEntry(0x99B126EC),
    CustomShaderEntry(0x9D0421B9),
    CustomShaderEntry(0xCF3ED7E2),
    CustomShaderEntry(0xCC2B95BB),
    CustomShaderEntry(0xB6EDB152),
    CustomShaderEntry(0xD1CDE904),
    CustomShaderEntry(0x04C003FD),
    CustomShaderEntry(0x440BCDEB),

    // FMV
    CustomShaderEntry(0x1FAA96A2),

    // Custom Gamma
    {0x70EB957B, {
                     .crc32 = 0x70EB957B,
                     .code = __0x70EB957B,
                     .on_drawn = &OnCustomGammaDrawn,
                 }},

};

auto* hdr_upgrade_setting = renodx::templates::settings::CreateSetting({
    .key = "HDRUpgrade",
    .binding = &current_hdr_upgrade,
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 3.f,
    .label = "HDR Upgrade",
    .section = "Processing",
    .tooltip = "Selects how to apply HDR upgrade (restart required)",
    .labels = {"None",
               "Swap Chain",
               "Swap Chain + Videos",
               "UE HDR"},
    .on_change_value = [](float previous, float current) { UpdateHDRIni(); },
    .is_global = true,
});

auto* reshade_before_ui_setting = renodx::templates::settings::CreateSetting({
    .key = "RenderReshadeBeforeUI",
    .binding = &current_render_reshade_before_ui,
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 0.f,
    .label = "Reshade Effects Before UI",
    .section = "Processing",
    .labels = {"Off", "On"},
    .is_global = true,
});

void OnLUTSettingChange() {
  lut_invalidation_level = 2;
};

void OnOptimizableSettingChange() {
  if (lut_invalidation_level < 1) {
    lut_invalidation_level = 1;
  }
};

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    {
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Restart game to apply changes.",
            .tint = 0xFF0000,
            .is_visible = []() {
              if (current_render_reshade_before_ui == 1.f) {
                if (initial_render_reshade_before_ui == 0.f
                    && (initial_hdr_upgrade != 1.f || initial_hdr_upgrade != 2.f)) {
                  return true;
                }
              }
              if (current_hdr_upgrade != initial_hdr_upgrade) return true;
              if (current_hdr_ini_enabled != initial_hdr_ini_enabled) return true;
              return false;
            },
            .is_sticky = true,
        },
    },
    {
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Pause and unpause the game to apply changes.",
            .tint = 0xFF0000,
            .is_visible = []() {
              return lut_invalidation_level == 2
                     || (shader_injection.custom_lut_optimization == 1.f && lut_invalidation_level != 0);
            },
            .is_sticky = true,
        },
    },
    {
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Pause and unpause the game to apply changes.",
            .on_change = []() {
              CheckHDREnabled();
            },
        },
    },
    renodx::templates::settings::CreateDefaultSettings({
        {"ToneMapType", {.binding = &shader_injection.tone_map_type, .on_change = &OnLUTSettingChange}},
        {"ToneMapPeakNits", {.binding = &shader_injection.peak_white_nits, .on_change = &OnOptimizableSettingChange}},
        {"ToneMapGameNits", {.binding = &shader_injection.diffuse_white_nits, .on_change = &OnOptimizableSettingChange}},
        {"ToneMapUINits", {.binding = &shader_injection.graphics_white_nits, .on_change_value = [](float old_value, float new_value) {
                             OnOptimizableSettingChange();
                             UpdateUIBrightnessIni();
                           }}},
        {"ToneMapGammaCorrection", {.binding = &shader_injection.gamma_correction, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeHighlights", {.binding = &shader_injection.tone_map_highlights, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeShadows", {.binding = &shader_injection.tone_map_shadows, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeContrast", {.binding = &shader_injection.tone_map_contrast, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeSaturation", {.binding = &shader_injection.tone_map_saturation, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeHighlightSaturation", {.binding = &shader_injection.tone_map_highlight_saturation, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeBlowout", {.binding = &shader_injection.tone_map_blowout, .on_change = &OnOptimizableSettingChange}},
        {"ColorGradeFlare", {.binding = &shader_injection.tone_map_flare, .on_change = &OnOptimizableSettingChange}},
        {"SceneGradeStrength", {.binding = &shader_injection.scene_grade_strength, .on_change = &OnLUTSettingChange}},
        {"SceneGradeHueCorrection", {.binding = &shader_injection.scene_grade_hue_correction, .on_change = &OnLUTSettingChange}},
        {"SceneGradeSaturationCorrection", {.binding = &shader_injection.scene_grade_saturation_correction, .on_change = &OnLUTSettingChange}},
        {"SceneGradeBlowoutRestoration", {.binding = &shader_injection.scene_grade_blowout_restoration, .on_change = &OnLUTSettingChange}},
        {"SceneGradeHueShift", {.binding = &shader_injection.scene_grade_hue_shift, .on_change = &OnLUTSettingChange}},
        {"FxBloom", {.binding = &shader_injection.custom_bloom}},
    }),
    {
        renodx::templates::settings::CreateSetting({
            .key = "FxAutoExposure",
            .binding = &shader_injection.custom_auto_exposure,
            .default_value = 100.f,
            .label = "Auto Exposure",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxChromaticAberration",
            .binding = &shader_injection.custom_chromatic_aberration,
            .default_value = 100.f,
            .label = "Chromatic Aberration",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxEyeAdaptation",
            .binding = &shader_injection.custom_eye_adaptation,
            .default_value = 100.f,
            .label = "Eye Adaptation",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxGrainType",
            .binding = &shader_injection.custom_grain_type,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 1.f,
            .label = "Grain Type",
            .section = "Effects",
            .labels = {"Vanilla", "Perceptual"},
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxGrainStrength",
            .binding = &shader_injection.custom_grain_strength,
            .default_value = 0.f,
            .label = "Grain Strength",
            .section = "Effects",
            .parse = [](float value) { return value * 0.01f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "FxHDRVideos",
            .binding = &shader_injection.custom_hdr_videos,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 2.f,
            .label = "HDR Videos",
            .section = "Effects",
            .labels = {"Off", "BT.2446a", "RenoDRT"},
            .is_enabled = []() { return initial_hdr_upgrade == 2.f; },
        }),
        renodx::templates::settings::CreateSetting({
            .key = "LUTOptimization",
            .binding = &shader_injection.custom_lut_optimization,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 0.f,
            .label = "LUT Optimization",
            .section = "Processing",
            .tooltip = "Selects whether to use UE's LUT optimization or tone map every frame.",
            .labels = {"Off", "On"},
            .on_change = &OnLUTSettingChange,
        }),
        reshade_before_ui_setting,
        hdr_upgrade_setting,
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Discord",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x5865F2,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "More Mods",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x2B3137,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Github",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0x2B3137,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "ShortFuse's Ko-Fi",
            .section = "Links",
            .group = "button-line-2",
            .tint = 0xFF5A16,
            .on_change = []() {
              renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
            },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
            .section = "About",
        },
    },
});

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
      {"FxHDRVideos", 0.f},
      {"FxAutoExposure", 100.f},
      {"FxChromaticAberration", 100.f},
      {"FxEyeAdaptation", 100.f},
      {"FxCustomGrain", 100.f},
      {"FxBloom", 0.f},
  });
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Oblivion Remastered";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, hdr_upgrade_setting);
        hdr_upgrade_setting->Write();
        initial_hdr_upgrade = current_hdr_upgrade;

        renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, reshade_before_ui_setting);
        reshade_before_ui_setting->Write();
        initial_render_reshade_before_ui = current_render_reshade_before_ui;

        initial_hdr_ini_enabled = CheckHDREnabled();
        current_hdr_ini_enabled = initial_hdr_ini_enabled;
        UpdateHDRIni();

        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
          return static_cast<bool>(params.size() < 20);
        };

        if (initial_hdr_upgrade == 1.f || initial_hdr_upgrade == 2.f) {
          renodx::mods::swapchain::SetUseHDR10(true);
          renodx::mods::swapchain::force_borderless = false;
          renodx::mods::swapchain::prevent_full_screen = false;
          renodx::mods::swapchain::force_screen_tearing = true;
          renodx::mods::swapchain::expected_constant_buffer_index = 13;
          renodx::mods::swapchain::expected_constant_buffer_space = 50;
          renodx::mods::swapchain::use_resource_cloning = true;
          renodx::mods::swapchain::swap_chain_proxy_shaders = {
              {
                  reshade::api::device_api::d3d11,
                  {
                      .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                      .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                  },
              },
              {
                  reshade::api::device_api::d3d12,
                  {
                      .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                      .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                  },
              },
          };

          // DLSSFG
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r10g10b10a2_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .usage_include = reshade::api::resource_usage::render_target,
          });
          // Internal LUT
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r10g10b10a2_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .dimensions = {.width = 32, .height = 32, .depth = 32},
          });

          // // UI
          // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          //     .old_format = reshade::api::format::b8g8r8a8_typeless,
          //     .new_format = reshade::api::format::r16g16b16a16_float,
          //     .use_resource_view_cloning = true,
          //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          // });
        }

        if (initial_hdr_upgrade == 2.f) {
          // FMV
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::b8g8r8a8_typeless,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .aspect_ratio = 3360.f / 1440.f,
          });

          // FMV
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::b8g8r8a8_typeless,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .aspect_ratio = 3440.f / 1440.f,
          });
        }

        renodx::utils::random::binds.push_back(&shader_injection.custom_random);

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  if (initial_render_reshade_before_ui != 0.f) {
    renodx::utils::swapchain::Use(fdw_reason);
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if (initial_hdr_upgrade == 1.f || initial_hdr_upgrade == 2.f) {
    renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  }
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
