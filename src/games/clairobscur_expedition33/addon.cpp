/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <filesystem>
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

static const float HDR_TYPE_SWAPCHAIN = 0.f;
static const float HDR_TYPE_UNREAL = 1.f;

static const float VALIDATION_TYPE_VALID = 0.f;
static const float VALIDATION_TYPE_INVALID = 1.f;

namespace {

int lut_invalidation_level = VALIDATION_TYPE_VALID;
int global_invalidation_level = 0;

bool current_hdr_ini_enabled = false;
float current_hdr_upgrade = HDR_TYPE_SWAPCHAIN;

bool initial_hdr_ini_enabled = current_hdr_ini_enabled;
float initial_hdr_upgrade = HDR_TYPE_SWAPCHAIN;

ShaderInjectData shader_injection;

bool OnLutBuilderReplace(reshade::api::command_list* cmd_list) {
  lut_invalidation_level = VALIDATION_TYPE_VALID;
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

  static const std::string ENGINE_INI_PATH = "/AppData/Local/Sandfall/Saved/Config/Windows/";
  static const std::string GAME_PASS_ENGINE_INI_PATH = "/AppData/Local/Sandfall/Saved/Config/WinGDK/";
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

void UpdateHDRIni() {
  if (current_hdr_ini_enabled) {
    if (current_hdr_upgrade != HDR_TYPE_UNREAL) {
      reshade::log::message(reshade::log::level::info, "Should disable HDR");
      DisableHDR();
      current_hdr_ini_enabled = false;
    }
  } else {
    if (current_hdr_upgrade == HDR_TYPE_UNREAL) {
      reshade::log::message(reshade::log::level::info, "Should enable HDR");
      EnableHDR();
      current_hdr_ini_enabled = true;
    }
  }
}

bool UsingSwapchainUpgrade() {
  return (initial_hdr_upgrade == HDR_TYPE_SWAPCHAIN);
}

bool UsingSwapchainUtil() {
  return UsingSwapchainUpgrade();
}

void OnLUTSettingChange() {
  lut_invalidation_level = VALIDATION_TYPE_INVALID;
};

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntryCallback(0x4A0DBF57, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x50F22BD6, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x0649A5D1, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0x773A9497, &OnLutBuilderReplace),
    CustomShaderEntryCallback(0xF9332C83, &OnLutBuilderReplace),
    __ALL_CUSTOM_SHADERS};

auto* hdr_upgrade_setting = renodx::templates::settings::CreateSetting({
    .key = "HDRUpgrade",
    .binding = &current_hdr_upgrade,
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = HDR_TYPE_SWAPCHAIN,
    .can_reset = false,
    .label = "HDR Upgrade Method",
    .section = "HDR Settings",
    .tooltip = "Sets the method used for upgrading to HDR. Unreal HDR offers full framegen compatibility.",
    .labels = {"SDR",
               "Unreal HDR"},
    .tint = 0xFF0000,
    .on_change_value = [](float previous, float current) { UpdateHDRIni(); },
    .is_global = true,
});

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings(
    {{
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::TEXT,
             .label = "Restart game to apply changes",
             .tint = 0xFF0000,
             .is_visible = []() {
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
             .label = "Enter Expedition Menu to apply changes",
             .tint = 0xFF0000,
             .is_visible = []() {
               return lut_invalidation_level == VALIDATION_TYPE_INVALID;
             },
             .is_sticky = true,
         },
     },
     {
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::TEXT,
             .label = "SET HDR UPGRADE METHOD TO UNREAL HDR IF YOU'RE USING FG OR FACING BLACKSCREEN!",
             .tint = 0xFF0000,
             .is_visible = []() { return current_hdr_upgrade != HDR_TYPE_UNREAL; },
             .is_sticky = true,
         },
     },
     {hdr_upgrade_setting},
     renodx::templates::settings::CreateDefaultSettings({
         {"ToneMapType", {.binding = &shader_injection.tone_map_type, .default_value = 3.f, .labels = {"Vanilla (UE ACES if using Unreal HDR and UE Filmic if using SDR)", "None", "ACES", "UE Filmic Extended (HDR)", "UE Filmic (SDR)"}, .parse = [](float value) { return value; }, .on_change = &OnLUTSettingChange}},
         {"ToneMapPeakNits", {.binding = &shader_injection.peak_white_nits, .on_change = &OnLUTSettingChange}},
         {"ToneMapGameNits", {.binding = &shader_injection.diffuse_white_nits, .on_change = &OnLUTSettingChange}},
         {"ToneMapUINits", {.binding = &shader_injection.graphics_white_nits, .on_change = &OnLUTSettingChange}},
         {"ToneMapScaling", {.binding = &shader_injection.tone_map_per_channel, .default_value = 1.f, .labels = {"Luminance and Per Channel Blend", "Per Channel"}, .on_change = &OnLUTSettingChange}},
         //  {"ToneMapHueCorrection", {.binding = &shader_injection.tone_map_hue_correction, .default_value = 0.f, .label = "Hue Correction (Midtones and Shadows)", .tooltip = "Hue retention strength. Only applies to midtones and shadows.", .on_change = &OnLUTSettingChange}},
         {"SceneGradeSaturationCorrection", {.binding = &shader_injection.scene_grade_saturation_correction, .default_value = 0.f, .is_enabled = []() { return shader_injection.tone_map_per_channel == 0.f; }}},
         {"SceneGradeHueCorrection", {.binding = &shader_injection.scene_grade_hue_correction, .default_value = 0.f, .label = "Hue Correction (Midtones and Shadows)", .tooltip = "Hue retention strength. Only applies to midtones and shadows.", .on_change = &OnLUTSettingChange}},
         //  {"SceneGradeBlowoutRestoration", &shader_injection.scene_grade_blowout_restoration},
         {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure, .on_change = &OnLUTSettingChange}},
         {"ColorGradeHighlights", {.binding = &shader_injection.tone_map_highlights, .on_change = &OnLUTSettingChange}},
         {"ColorGradeShadows", {.binding = &shader_injection.tone_map_shadows, .on_change = &OnLUTSettingChange}},
         {"ColorGradeContrast", {.binding = &shader_injection.tone_map_contrast, .on_change = &OnLUTSettingChange}},
         {"ColorGradeSaturation", {.binding = &shader_injection.tone_map_saturation, .on_change = &OnLUTSettingChange}},
         {"ColorGradeHighlightSaturation", {.binding = &shader_injection.tone_map_highlight_saturation, .on_change = &OnLUTSettingChange}},
         {"ColorGradeBlowout", {.binding = &shader_injection.tone_map_blowout, .on_change = &OnLUTSettingChange}},
         {"ColorGradeFlare", {.binding = &shader_injection.tone_map_flare, .on_change = &OnLUTSettingChange}},
     }),
     {
         /* renodx::templates::settings::CreateSetting({
             .key = "FxGrainType",
             .binding = &shader_injection.custom_grain_type,
             .value_type = renodx::utils::settings::SettingValueType::INTEGER,
             .default_value = 1.f,
             .label = "Grain Type",
             .section = "Effects",
             .tooltip = "Replaces film grain with perceptual",
             .labels = {"Vanilla", "Perceptual"},
             .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
         }),
         renodx::templates::settings::CreateSetting({
             .key = "FxGrainStrength",
             .binding = &shader_injection.custom_grain_strength,
             .default_value = 25.f,
             .label = "Perceptual Grain Strength",
             .section = "Effects",
             .is_enabled = []() { return shader_injection.custom_grain_type != 0; },
             .parse = [](float value) { return value * 0.01f; },
             .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
         }), */
         renodx::templates::settings::CreateSetting({
             .key = "FxPostProcessGrain",
             .binding = &shader_injection.custom_enable_post_filmgrain,
             .value_type = renodx::utils::settings::SettingValueType::INTEGER,
             .default_value = 1.f,
             .label = "Film Grain",
             .section = "Effects",
             .tooltip = "Enable cutscenes film grain",
             .labels = {"Disabled", "Enabled"},
             .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
         }),
         new renodx::utils::settings::Setting{
             .key = "FxSharpness",
             .binding = &shader_injection.custom_sharpness,
             .default_value = 0.f,
             .label = "RCAS Sharpness",
             .section = "Effects",
             .tooltip = "Controls Lilium's RCAS Sharpness",
             .max = 100.f,
             .parse = [](float value) { return value == 0 ? 0.f : exp2(-(1.f - (value * 0.01f))); },
             .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 2; },
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::BUTTON,
             .label = "Reset All",
             .section = "Options",
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
             .label = "Musa's Recommended Settings",
             .section = "Options",
             .group = "button-line-1",
             .on_change = []() {
               renodx::utils::settings::ResetSettings();
               renodx::utils::settings::UpdateSettings({
                   {"ToneMapScaling", 0.f},
                   {"SceneGradeSaturationCorrection", 50.f},
                   {"SceneGradeHueCorrection", 100.f},
               });
             },
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::BUTTON,
             .label = "RenoDX Discord",
             .section = "Links",
             .group = "button-line-2",
             .tint = 0x5865F2,
             .on_change = []() {
               renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
             },
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::BUTTON,
             .label = "HDR Den Discord",
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
             .label = "Ritsu's Ko-Fi",
             .section = "Links",
             .group = "button-line-3",
             .tint = 0xFF5F5F,
             .on_change = []() {
               renodx::utils::platform::LaunchURL("https://ko-fi.com/ritsucecil");
             },
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::BUTTON,
             .label = "ShortFuse's Ko-Fi",
             .section = "Links",
             .group = "button-line-3",
             .tint = 0xFF5F5F,
             .on_change = []() {
               renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse");
             },
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::BUTTON,
             .label = "HDR Den's Ko-Fi",
             .section = "Links",
             .group = "button-line-3",
             .tint = 0xFF5F5F,
             .on_change = []() {
               renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden");
             },
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::TEXT,
             .label = "Game mod by Ritsu, updated by Musa, RenoDX Framework by ShortFuse.",
             .section = "About",
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::TEXT,
             .label = "Credits to Lilium (& Musa) for RCAS!",
             .section = "About",
         },
         new renodx::utils::settings::Setting{
             .value_type = renodx::utils::settings::SettingValueType::TEXT,
             .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
             .section = "About",
         },
     }});

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 4.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapHueCorrection", 0.f},
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
bool initialized = false;

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  settings[6]->can_reset = true;
  if (peak.has_value()) {
    settings[6]->default_value = roundf(peak.value());
  } else {
    settings[6]->default_value = 1000.f;
  }

  settings[7]->default_value = fmin(renodx::utils::swapchain::ComputeReferenceWhite(settings[6]->default_value), 203.f);
  fired_on_init_swapchain = true;
}

void OnInitDevice(reshade::api::device* device) {
  int vendor_id;
  auto retrieved = device->get_property(reshade::api::device_properties::vendor_id, &vendor_id);
  if (retrieved && vendor_id == 0x10de && current_hdr_upgrade == HDR_TYPE_SWAPCHAIN) {  // Nvidia vendor ID
    // Bugs out AMD GPUs
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r11g11b10_float,
                                                                   .new_format = reshade::api::format::r16g16b16a16_typeless,
                                                                   .use_resource_view_cloning = true});
  }
}
}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Expedition 33";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        return static_cast<bool>(params.size() < 20);
      };

      if (!initialized) {
        renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, hdr_upgrade_setting);
        hdr_upgrade_setting->Write();
        initial_hdr_upgrade = current_hdr_upgrade;

        initial_hdr_ini_enabled = CheckHDREnabled();
        current_hdr_ini_enabled = initial_hdr_ini_enabled;
        UpdateHDRIni();

        shader_injection.custom_is_engine_hdr = current_hdr_upgrade == HDR_TYPE_UNREAL ? 1.f : 0.f;

        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;

        // Has to be false for puredark FG mod compatibility
        renodx::mods::shader::use_pipeline_layout_cloning = false;

        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;
        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::prevent_full_screen = false;
        renodx::mods::swapchain::force_screen_tearing = false;
        renodx::mods::swapchain::use_resize_buffer = true;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::set_color_space = false;
        renodx::mods::swapchain::SetUseHDR10(true);

        // Not used anymore, but kept for reference
        if (initial_hdr_upgrade == HDR_TYPE_SWAPCHAIN) {
          renodx::mods::swapchain::set_color_space = true;
          renodx::mods::swapchain::use_resize_buffer = false;

          renodx::mods::swapchain::expected_constant_buffer_index = 13;
          renodx::mods::swapchain::expected_constant_buffer_space = 50;
          renodx::mods::swapchain::SetUseHDR10();
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

          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::b8g8r8a8_typeless,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
          });
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::b8g8r8a8_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              // .usage_include = reshade::api::resource_usage::render_target,
          });

          // Some mod causing issues?
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                         .new_format = reshade::api::format::r16g16b16a16_float,
                                                                         .use_resource_view_cloning = true,
                                                                         .aspect_ratio = 3780.f / 2128.f});

          // Ultrawide
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                         .new_format = reshade::api::format::r16g16b16a16_float,
                                                                         .use_resource_view_cloning = true,
                                                                         .aspect_ratio = 3044.f / 1276.f});

          // Ultrawide DLAA
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                         .new_format = reshade::api::format::r16g16b16a16_float,
                                                                         .use_resource_view_cloning = true,
                                                                         .aspect_ratio = 3840.f / 1608.f});

          // Fixes DLAA lol
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r10g10b10a2_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .aspect_ratio = 3044.f / 1712.f,
          });

          // Portrait letterboxes screens
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r10g10b10a2_unorm,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .aspect_ratio = 2880.f / 2160.f,
          });

          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                         .new_format = reshade::api::format::r16g16b16a16_float,
                                                                         .dimensions = {.width = 32, .height = 32, .depth = 32}});

          // Everything else
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({.old_format = reshade::api::format::r10g10b10a2_unorm,
                                                                         .new_format = reshade::api::format::r16g16b16a16_float,
                                                                         .use_resource_view_cloning = true});

          renodx::mods::swapchain::force_borderless = false;
          renodx::mods::swapchain::prevent_full_screen = false;
        }

        renodx::utils::random::binds.push_back(&shader_injection.custom_random);
        initialized = true;
      }

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_addon(h_module);
      break;
  }

  if (UsingSwapchainUtil()) {
    renodx::utils::swapchain::Use(fdw_reason);
  }
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if (UsingSwapchainUpgrade()) {
    renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  }
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
