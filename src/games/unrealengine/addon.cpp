/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/path.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/shader_dump.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

std::unordered_set<std::uint32_t> drawn_shaders;

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) { return value * 3.f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.tone_map_peak_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.tone_map_game_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.tone_map_ui_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.tone_map_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeStrength",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Strength",
        .section = "Scene Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHueCorrection",
        .binding = &shader_injection.color_grade_hue_correction,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Scene Grading",
        .tooltip = "Corrects per-channel hue shifts from per-channel grading.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturationCorrection",
        .binding = &shader_injection.color_grade_saturation_correction,
        .default_value = 100.f,
        .label = "Saturation Correction",
        .section = "Scene Grading",
        .tooltip = "Corrects unbalanced saturation from per-channel grading.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowoutRestoration",
        .binding = &shader_injection.color_grade_blowout_restoration,
        .default_value = 50.f,
        .label = "Blowout Restoration",
        .section = "Scene Grading",
        .tooltip = "Restores color from blowout from per-channel grading.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHueShift",
        .binding = &shader_injection.color_grade_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Scene Grading",
        .tooltip = "Selects strength of hue shifts from per-channel grading.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.color_grade_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Custom Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.color_grade_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.color_grade_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.color_grade_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.color_grade_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Custom Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.color_grade_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Custom Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.color_grade_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Custom Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.color_grade_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Custom Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeClip",
        .binding = &shader_injection.reno_drt_white_clip,
        .default_value = 65.f,
        .label = "White Clip",
        .section = "Custom Color Grading",
        .tooltip = "Clip point for white in nits",
        .min = 1.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeColorSpace",
        .binding = &shader_injection.color_grade_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Color Space",
        .section = "Custom Color Grading",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
};

const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {
    {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},
    {"B8G8R8A8_TYPELESS", reshade::api::format::b8g8r8a8_typeless},
    {"R8G8B8A8_UNORM", reshade::api::format::r8g8b8a8_unorm},
    {"B8G8R8A8_UNORM", reshade::api::format::b8g8r8a8_unorm},
    {"R8G8B8A8_SNORM", reshade::api::format::r8g8b8a8_snorm},
    {"R8G8B8A8_UNORM_SRGB", reshade::api::format::r8g8b8a8_unorm_srgb},
    {"B8G8R8A8_UNORM_SRGB", reshade::api::format::b8g8r8a8_unorm_srgb},
    {"R10G10B10A2_TYPELESS", reshade::api::format::r10g10b10a2_typeless},
    {"R10G10B10A2_UNORM", reshade::api::format::r10g10b10a2_unorm},
    {"B10G10R10A2_UNORM", reshade::api::format::b10g10r10a2_unorm},
    {"R11G11B10_FLOAT", reshade::api::format::r11g11b10_float},
    {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless},
};

renodx::utils::settings::Settings info_settings = {
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() { renodx::utils::settings::ResetSettings(); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "SDR Grading Bypass",
        .section = "Options",
        .group = "button-line-1",
        .tooltip = "Improves highlight appearance in games with little to no SDR grading",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ColorGradeContrast", 80.f},
              {"ColorGradeSaturation", 80.f},
              {"ColorGradeBlowout", 80.f},
              {"ColorGradeStrength", 0.f},
          });
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "F6AUTeWJHM");
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
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0.f},
      {"ToneMapHueCorrection", 0.f},
      {"ColorGradeStrength", 100.f},
      {"ColorGradeSaturationCorrection", 0.f},
      {"ColorGradeBlowoutRestoration", 0.f},
      {"ColorGradeHueShift", 100.f},
      {"ColorGradeHueShift", 100.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeClip", 4.f},
      {"ColorGradeColorSpace", 0.f},
  });
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
    fired_on_init_swapchain = true;
  }
}

// Per game resource upgrades, where we need custom paramaters -- the sliders (output size/ratio/all) don't work
void AddExpedition33Upgrades() {
  // Portrait letterboxes screens
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 2880.f / 2160.f,
  });

  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 3840.f / 1608.f,
  });
  // DLAA support
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 3044.f / 1712.f,
  });
}

void AddAvowedUpgrades() {
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 4360.f / 2160.f,
  });
}

void AddWuchangUpgrades() {
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 2560.f / 1024.f,
  });
}

void AddSonicRacingCrossWorldsUpgrades() {
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 16.f / 9.f,
  });
}

void AddLostSoulAsideUpgrades() {
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::b8g8r8a8_typeless,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 5040.f / 2160.f, // Ultrawide support
      .aspect_ratio_tolerance = 0.1f,
  });
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning = true,
      .aspect_ratio = 5040.f / 2160.f, // Ultrawide support
      .aspect_ratio_tolerance = 0.1f,
  });
}

void AddGamePatches() {
  auto process_path = renodx::utils::platform::GetCurrentProcessPath();
  auto filename = process_path.filename().string();
  auto product_name = renodx::utils::platform::GetProductName(process_path);

  if (product_name == "Expedition 33") {
    AddExpedition33Upgrades();
  } else if (product_name == "Avowed") {
    AddAvowedUpgrades();
  } else if (product_name == "Tony Hawks(TM) Pro Skater(TM) 3 + 4") {
    renodx::mods::swapchain::swapchain_proxy_revert_state = true;
  } else if (product_name == "Project_Plague") {
    AddWuchangUpgrades();
  } else if (product_name == "SonicRacingCrossWorlds") {
    AddSonicRacingCrossWorldsUpgrades();
  } else if (product_name == "Lost Soul Aside") {
    AddLostSoulAsideUpgrades();
  } else {
    return;
  }
  reshade::log::message(reshade::log::level::info, std::format("Applied patches for {} ({}).", filename, product_name).c_str());
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

const std::unordered_map<
    std::string,                             // Filename or ProductName
    std::unordered_map<std::string, float>>  // {Key, Value}
    GAME_DEFAULT_SETTINGS = {
        {
            "Psychonauts2-WinGDK-Shipping.exe",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"ForceBorderless", 0.f},
            },
        },
        {
            "CRISIS CORE -FINAL FANTASY VII- REUNION",
            {
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "RainCodePlus-Win64-Shipping.exe",
            {
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },
        {
            "Wuthering Waves",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Expedition 33",
            {
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_B8G8R8A8_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Avowed",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "InfinityNikki",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },

        {
            "Stellar Blade",
            {
                {"Upgrade_CopyDestinations", 1.f},
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Stellar Blade (Demo)",
            {
                {"Upgrade_CopyDestinations", 1.f},
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Lies of P",
            {
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Like a Dragon: Ishin!",
            {
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },

        {
            "Pal",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },

        {
            "Project_Plague",
            {
                {"Upgrade_CopyDestinations", 1.f},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Banishers: Ghosts of New Eden",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Lost Soul Aside",
            {
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Borderlands3.exe",
            {
              {"Upgrade_CopyDestinations", 1.f},  
              {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
              {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
              {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },
        {
            "SonicRacingCrossWorlds",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },

};

float g_dump_shaders = 0.f;
float g_upgrade_copy_destinations = 0.f;

namespace lut_dump {
std::unordered_set<uint32_t> g_dumped_shaders = {};
struct __declspec(uuid("019886a1-be4c-70df-b8ea-f2c4bab7e95d")) CommandListData {
  // State
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::resource_view> pixel_srv_binds;
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::resource_view> pixel_uav_binds;
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::resource_view> compute_srv_binds;
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::resource_view> compute_uav_binds;
  std::map<std::pair<uint32_t, uint32_t>, reshade::api::buffer_range> constants;
  std::map<uint32_t, reshade::api::resource_view> render_targets;
  std::optional<reshade::api::blend_desc> blend_desc = std::nullopt;
  std::optional<reshade::api::rasterizer_desc> rasterizer_desc = std::nullopt;

  // std::vector<PipelineBindDetails> pipeline_binds;
};
void OnInitCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

void OnResetCommandList(reshade::api::command_list* cmd_list) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) return;
  renodx::utils::data::Delete<CommandListData>(cmd_list);
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  auto* data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (data == nullptr) {
    assert(false && "Command list data not found");
    return;
  }

  auto* device = cmd_list->get_device();

  renodx::utils::pipeline_layout::PipelineLayoutData* layout_data = nullptr;
  auto populate_layout_data = [&]() {
    if (layout_data != nullptr) return true;
    auto* local_layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(layout);
    if (local_layout_data == nullptr) {
      reshade::log::message(reshade::log::level::error, "Could not find handle.");
      return false;
    }
    layout_data = local_layout_data;
    return true;
  };

  auto log_resource_view = [&](uint32_t index,
                               reshade::api::resource_view view,
                               std::map<std::pair<uint32_t, uint32_t>,
                                        reshade::api::resource_view>& destination) {
    if (!populate_layout_data()) return;

    auto layout_params = layout_data->params;
    const auto& param = layout_params[layout_param];
    uint32_t dx_register_index = 0;
    uint32_t dx_register_space = 0;
    switch (param.type) {
      case reshade::api::pipeline_layout_param_type::descriptor_table: {
        if (param.descriptor_table.count != 1) {
          reshade::log::message(reshade::log::level::error, "Wrong count.");
          // add warning
          return;
        }
        dx_register_index = param.descriptor_table.ranges[0].dx_register_index;
        dx_register_space = param.descriptor_table.ranges[0].dx_register_space;
        break;
      }
      case reshade::api::pipeline_layout_param_type::push_descriptors:
        dx_register_index = param.push_descriptors.dx_register_index;
        dx_register_space = param.push_descriptors.dx_register_space;
        break;
      default:
        reshade::log::message(reshade::log::level::error, "Not descriptor table.");
        return;
    }

    auto slot = std::pair<uint32_t, uint32_t>(dx_register_index + update.binding + index, dx_register_space);

    if (view.handle == 0u) {
      destination.erase(slot);
    } else {
      destination[slot] = view;
    }
  };

  for (uint32_t i = 0; i < update.count; i++) {
    switch (update.type) {
      case reshade::api::descriptor_type::sampler:
        break;
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i];
        if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
          log_resource_view(i, item.view, data->pixel_srv_binds);
        } else if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
          log_resource_view(i, item.view, data->compute_srv_binds);
        }
      } break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::shader_resource_view:        {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
          log_resource_view(i, item, data->pixel_srv_binds);
        } else if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
          log_resource_view(i, item, data->compute_srv_binds);
        }
        break;
      }
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::unordered_access_view:        {
        auto item = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::pixel)) {
          log_resource_view(i, item, data->pixel_uav_binds);
        } else if (renodx::utils::bitwise::HasFlag(stages, reshade::api::shader_stage::compute)) {
          log_resource_view(i, item, data->compute_uav_binds);
        }

        break;
      }
      case reshade::api::descriptor_type::constant_buffer: {
        if (!populate_layout_data()) return;
        auto layout_params = layout_data->params;
        auto param = layout_params[layout_param];
        if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors) {
          assert(param.push_descriptors.type == reshade::api::descriptor_type::constant_buffer);

          uint32_t pair_a = 0;
          uint32_t pair_b = 0;
          switch (device->get_api()) {
            case reshade::api::device_api::d3d9:
            case reshade::api::device_api::d3d10:
            case reshade::api::device_api::d3d11:
            case reshade::api::device_api::d3d12:
              pair_a = param.push_constants.dx_register_index + update.binding + i;
              pair_b = param.push_constants.dx_register_space;
              break;

            case reshade::api::device_api::opengl:
              break;

            case reshade::api::device_api::vulkan:
              pair_a = update.binding;
              pair_b = update.array_offset + i;
              break;
            default:
              assert(false);
          }
          auto buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
          auto slot = std::pair<uint32_t, uint32_t>(pair_a, pair_b);
          data->constants[slot] = buffer_range;
        } else if (param.type == reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges) {
          uint32_t pair_a = 0;
          uint32_t pair_b = 0;

          switch (device->get_api()) {
            case reshade::api::device_api::d3d9:
            case reshade::api::device_api::d3d10:
            case reshade::api::device_api::d3d11:
            case reshade::api::device_api::d3d12:
              assert(false);
              break;
            case reshade::api::device_api::opengl:
              break;

            case reshade::api::device_api::vulkan:
              assert(param.descriptor_table.count > update.binding);
              assert(param.descriptor_table.ranges[update.binding].binding == update.binding);
              pair_a = update.binding;
              pair_b = update.array_offset + i;
              break;
            default:
              assert(false);
          }
          auto buffer_range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[i];
          auto slot = std::pair<uint32_t, uint32_t>(pair_a, pair_b);
          data->constants[slot] = buffer_range;

        } else {
          assert(false);
        }

      } break;
      default:
        break;
    }
  }
}

bool OnDraw(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  if (g_dump_shaders == 0) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);

  auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);

  auto pixel_shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
  if (pixel_shader_hash == 0u) return false;

  // if (custom_shaders.contains(pixel_shader_hash)) return false;

  if (g_dumped_shaders.contains(pixel_shader_hash)) return false;

  auto* swapchain_state = renodx::utils::swapchain::GetCurrentState(cmd_list);
  bool found_lut_render_target = false;

  auto* device = cmd_list->get_device();
  for (auto render_target : swapchain_state->current_render_targets) {
    auto resource_tag = renodx::utils::resource::GetResourceTag(render_target);
    if (resource_tag == 1.f) {
      found_lut_render_target = true;
      break;
    }
  }
  if (!found_lut_render_target) return false;

  reshade::log::message(
      reshade::log::level::debug,
      std::format("Dumping lutbuiler: 0x{:08x}", pixel_shader_hash).c_str());

  g_dumped_shaders.emplace(pixel_shader_hash);

  renodx::utils::path::default_output_folder = "renodx";
  renodx::utils::shader::dump::default_dump_folder = ".";
  bool found = false;
  try {
    auto shader_data = renodx::utils::shader::GetShaderData(pixel_state);
    if (!shader_data.has_value()) {
      std::stringstream s;
      s << "utils::shader::dump(Failed to retreive shader data: ";
      s << PRINT_CRC32(pixel_shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return false;
    }

    auto shader_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_data.value());
    if (shader_version.GetMajor() == 0) {
      // No shader information found
      return false;
    }

    std::string prefix = custom_shaders.contains(pixel_shader_hash)
                             ? "lutbuilder_"
                             : "lutbuilder_new_";
    renodx::utils::shader::dump::DumpShader(
        pixel_shader_hash,
        shader_data.value(),
        reshade::api::pipeline_subobject_type::pixel_shader,
        prefix);

  } catch (...) {
    std::stringstream s;
    s << "utils::shader::dump(Failed to decode shader data: ";
    s << PRINT_CRC32(pixel_shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

  return false;
}

bool OnDispatch(
    reshade::api::command_list* cmd_list,
    uint32_t group_count_x,
    uint32_t group_count_y,
    uint32_t group_count_z) {
  if (g_dump_shaders == 0.f) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);

  auto* compute_state = renodx::utils::shader::GetCurrentComputeState(shader_state);

  auto compute_shader_hash = renodx::utils::shader::GetCurrentComputeShaderHash(compute_state);
  if (compute_shader_hash == 0u) return false;
  if (g_dumped_shaders.contains(compute_shader_hash)) return false;

  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);

  auto compute_uav_binds = cmd_list_data->compute_uav_binds;

  auto* device = cmd_list->get_device();

  if (shader_state->last_pipeline != 0u) {
    auto* pipeline_shader_details = renodx::utils::shader::GetPipelineShaderDetails(shader_state->last_pipeline);
    if (pipeline_shader_details != nullptr) {
      auto* layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(pipeline_shader_details->layout);
      if (layout_data != nullptr) {
        const auto& info = *layout_data;
        auto param_count = info.params.size();
        auto* descriptor_data = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
        if (descriptor_data == nullptr) return false;
        for (auto param_index = 0; param_index < param_count; ++param_index) {
          const auto& param = info.params.at(param_index);
          const auto& table = info.tables[param_index];

          uint32_t descriptor_table_count;
          const reshade::api::descriptor_range* descriptor_table_ranges;
          switch (param.type) {
            case reshade::api::pipeline_layout_param_type::descriptor_table:
              if (table.handle == 0u) continue;
              descriptor_table_count = param.descriptor_table.count;
              descriptor_table_ranges = param.descriptor_table.ranges;
              break;
            case reshade::api::pipeline_layout_param_type::descriptor_table_with_static_samplers:
              if (table.handle == 0u) continue;
              descriptor_table_count = param.descriptor_table_with_static_samplers.count;
              descriptor_table_ranges = param.descriptor_table_with_static_samplers.ranges;
              break;

            case reshade::api::pipeline_layout_param_type::push_constants:
            case reshade::api::pipeline_layout_param_type::push_descriptors:
            case reshade::api::pipeline_layout_param_type::push_descriptors_with_ranges:
            case reshade::api::pipeline_layout_param_type::push_descriptors_with_static_samplers:
              continue;
          }

          for (uint32_t j = 0; j < descriptor_table_count; ++j) {
            const auto& range = descriptor_table_ranges[j];

            // Skip unbounded ranges
            if (range.count == UINT32_MAX) continue;

            switch (range.type) {
              case reshade::api::descriptor_type::shader_resource_view:
              case reshade::api::descriptor_type::sampler_with_resource_view:
              case reshade::api::descriptor_type::buffer_shader_resource_view:
              case reshade::api::descriptor_type::unordered_access_view:
                break;
              default:
                continue;
            }

            if (!renodx::utils::bitwise::HasFlag(range.visibility, reshade::api::shader_stage::compute)) {
              continue;
            }
            // if (!renodx::utils::bitwise::HasFlag(range.visibility, reshade::api::shader_stage::pixel)) {
            //   continue;
            // }

            uint32_t base_offset = 0;
            reshade::api::descriptor_heap heap = {0};
            device->get_descriptor_heap_offset(table, range.binding, 0, &heap, &base_offset);
            const std::shared_lock descriptor_lock(descriptor_data->mutex);

            for (uint32_t k = 0; k < range.count; ++k) {
              auto heap_pair = descriptor_data->heaps.find(heap.handle);
              if (heap_pair == descriptor_data->heaps.end()) {
                // Unknown heap?
                continue;
              }
              const auto& heap_data = heap_pair->second;
              auto offset = base_offset + k;
              if (offset >= heap_data.size()) {
                // Invalid location (may be oversized bind)
                continue;
              }
              auto known_pair = descriptor_data->resource_view_heap_locations.find(heap.handle);
              if (known_pair == descriptor_data->resource_view_heap_locations.end()) continue;
              auto& known = known_pair->second;
              if (!known.contains(offset)) {
                // Unknown Resource View
                continue;
              }

              const auto& [descriptor_type, descriptor_data] = heap_data[offset];
              reshade::api::resource_view resource_view = {0};
              bool is_uav = false;
              switch (descriptor_type) {
                case reshade::api::descriptor_type::sampler_with_resource_view:
                  resource_view = std::get<reshade::api::sampler_with_resource_view>(descriptor_data).view;
                  break;
                case reshade::api::descriptor_type::buffer_unordered_access_view:
                case reshade::api::descriptor_type::texture_unordered_access_view:
                  is_uav = true;
                  // fallthrough
                case reshade::api::descriptor_type::buffer_shader_resource_view:
                case reshade::api::descriptor_type::texture_shader_resource_view:
                  resource_view = std::get<reshade::api::resource_view>(descriptor_data);
                  break;
                case reshade::api::descriptor_type::constant_buffer:
                case reshade::api::descriptor_type::shader_storage_buffer:
                case reshade::api::descriptor_type::acceleration_structure:
                  break;
                default:
                  break;
              }

              auto slot = std::pair<uint32_t, uint32_t>(range.dx_register_index + k, range.dx_register_space);

              if (is_uav || range.type == reshade::api::descriptor_type::unordered_access_view) {
                if (resource_view.handle == 0u) {
                  compute_uav_binds.erase(slot);
                } else {
                  auto* resource_view_info = renodx::utils::resource::GetResourceViewInfo(resource_view);
                  if (resource_view_info->resource_info == nullptr && renodx::utils::resource::IsResourceViewEmpty(device, resource_view)) {
                    compute_uav_binds.erase(slot);
                  } else {
                    compute_uav_binds[slot] = resource_view;
                  }
                }
              } else {
                // if (resource_view.handle == 0u) {
                //   draw_details.srv_binds.erase(slot);
                // } else {
                //   auto detail_item = GetResourceViewDetails(resource_view, device);
                //   if (detail_item.resource.handle == 0u && renodx::utils::resource::IsResourceViewEmpty(device, resource_view)) {
                //     draw_details.srv_binds.erase(slot);
                //   } else {
                //     draw_details.srv_binds[slot] = detail_item;
                //   }
                // }
              }
            }
          }
        }
      }
    }
  }

  if (compute_uav_binds.empty()) return false;
  auto pair = compute_uav_binds.find({0, 0});
  if (pair == compute_uav_binds.end()) return false;
  auto uav_view = pair->second;
  if (uav_view.handle == 0u) return false;
  auto* uav_view_info = renodx::utils::resource::GetResourceViewInfo(uav_view);
  if (uav_view_info == nullptr) return false;
  if (uav_view_info->resource_info == nullptr) return false;
  if (uav_view_info->resource_info->resource_tag != 1.f) return false;

  reshade::log::message(
      reshade::log::level::debug,
      std::format("Dumping lutbuiler: 0x{:08x}", compute_shader_hash).c_str());

  g_dumped_shaders.emplace(compute_shader_hash);

  renodx::utils::path::default_output_folder = "renodx";
  renodx::utils::shader::dump::default_dump_folder = ".";
  bool found = false;
  try {
    auto shader_data = renodx::utils::shader::GetShaderData(compute_state);
    if (!shader_data.has_value()) {
      std::stringstream s;
      s << "utils::shader::dump(Failed to retreive shader data: ";
      s << PRINT_CRC32(compute_shader_hash);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return false;
    }

    auto shader_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_data.value());
    if (shader_version.GetMajor() == 0) {
      // No shader information found
      return false;
    }

    std::string prefix = custom_shaders.contains(compute_shader_hash)
                             ? "lutbuilder_"
                             : "lutbuilder_new_";

    renodx::utils::shader::dump::DumpShader(
        compute_shader_hash,
        shader_data.value(),
        reshade::api::pipeline_subobject_type::pixel_shader,
        prefix);

  } catch (...) {
    std::stringstream s;
    s << "utils::shader::dump(Failed to decode shader data: ";
    s << PRINT_CRC32(compute_shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }
  return false;
}

void Use(DWORD fdw_reason) {
  renodx::utils::descriptor::trace_descriptor_tables = true;  // RIP FPS

  renodx::utils::pipeline_layout::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);
  renodx::utils::shader::Use(fdw_reason);
  renodx::utils::shader::use_shader_cache = true;
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::descriptor::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::draw>(OnDraw);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
      reshade::log::message(reshade::log::level::info, "DumpLUTShaders enabled.");
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      reshade::unregister_event<reshade::addon_event::dispatch>(OnDispatch);
      break;
  }
}
}  // namespace lut_dump

void AddAdvancedSettings() {
  auto process_path = renodx::utils::platform::GetCurrentProcessPath();
  auto filename = process_path.filename().string();
  auto default_settings = GAME_DEFAULT_SETTINGS.find(filename);

  {
    std::stringstream s;
    if (default_settings == GAME_DEFAULT_SETTINGS.end()) {
      auto product_name = renodx::utils::platform::GetProductName(process_path);

      default_settings = GAME_DEFAULT_SETTINGS.find(product_name);

      if (default_settings == GAME_DEFAULT_SETTINGS.end()) {
        s << "No default settings for ";
      } else {
        s << "Marked default values for ";
      }
      s << filename;
      s << " (" << product_name << ")";
    } else {
      s << "Marked default values for ";
      s << filename;
    }
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  auto add_setting = [&](auto* setting) {
    if (default_settings != GAME_DEFAULT_SETTINGS.end()) {
      auto values = default_settings->second;
      if (auto values_pair = values.find(setting->key);
          values_pair != values.end()) {
        setting->default_value = static_cast<float>(values_pair->second);
        std::stringstream s;
        s << "Default value for ";
        s << setting->key;
        s << ": ";
        s << setting->default_value;
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
    }
    renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
    settings.push_back(setting);
  };

  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_CopyDestinations",
        .binding = &g_upgrade_copy_destinations,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Upgrade Copy Destinations",
        .section = "Resource Upgrades",
        .tooltip = "Includes upgrading texture copy destinations.",
        .labels = {
            "Off",
            "On",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);

    g_upgrade_copy_destinations = setting->GetValue();
  }

  for (const auto& [key, format] : UPGRADE_TARGETS) {
    auto* new_setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_" + key,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = key,
        .section = "Resource Upgrades",
        .labels = {
            "Off",
            "Output size",
            "Output ratio",
            "Any size",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(new_setting);

    auto value = new_setting->GetValue();
    if (value > 0) {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = format,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = (value == UPGRADE_TYPE_ANY),
          .use_resource_view_cloning = true,
          .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
                                                 ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
                                                 : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
          .usage_include = reshade::api::resource_usage::render_target
                           | (g_upgrade_copy_destinations == 0.f
                                  ? reshade::api::resource_usage::undefined
                                  : reshade::api::resource_usage::copy_dest),
      });
      std::stringstream s;
      s << "Applying user resource upgrade for ";
      s << format << ": " << value;
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }

  {
    auto* swapchain_setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_SwapChainCompatibility",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swap Chain Compatibility Mode",
        .section = "Resource Upgrades",
        .tooltip = "Enhances support for third-party addons to read the swap chain.",
        .labels = {
            "Off",
            "On",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(swapchain_setting);
    renodx::mods::swapchain::swapchain_proxy_compatibility_mode = swapchain_setting->GetValue() != 0;
  }

  {
    auto* scrgb_setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_UseSCRGB",
        .binding = &shader_injection.processing_use_scrgb,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swap Chain Format",
        .section = "Resource Upgrades",
        .tooltip = "Selects use of HDR10 or scRGB swapchain.",
        .labels = {
            "HDR10",
            "scRGB",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(scrgb_setting);

    shader_injection.processing_use_scrgb = scrgb_setting->GetValue();
    renodx::mods::swapchain::SetUseHDR10(scrgb_setting->GetValue() == 0);
  }

  {
    auto* force_borderless_setting = new renodx::utils::settings::Setting{
        .key = "ForceBorderless",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Force Borderless",
        .section = "Resource Upgrades",
        .tooltip = "Forces fullscreen to be borderless for proper HDR",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(force_borderless_setting);

    if (force_borderless_setting->GetValue() == 0) {
      renodx::mods::swapchain::force_borderless = false;
    }
  }

  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "PreventFullscreen",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Prevent Fullscreen",
        .section = "Resource Upgrades",
        .tooltip = "Prevent exclusive fullscreen for proper HDR",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);

    renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
  }

  {
    auto* lut_dump_setting = new renodx::utils::settings::Setting{
        .key = "DumpLUTShaders",
        .binding = &g_dump_shaders,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Dump LUT Shaders",
        .section = "Resource Upgrades",
        .tooltip = "Traces and dumps LUT shaders.",
        .labels = {
            "Off",
            "On",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(lut_dump_setting);

    g_dump_shaders = lut_dump_setting->GetValue();
  }

  settings.push_back({new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "The application must be restarted for upgrades to take effect.",
      .section = "Resource Upgrades",
      .is_visible = []() { return settings[0]->GetValue() >= 2; },
  }});
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Unreal Engine";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        return (params.size() < 20);
      };

      if (!initialized) {
        AddAdvancedSettings();

        for (auto* new_setting : info_settings) {
          settings.push_back(new_setting);
        }

        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::force_pipeline_cloning = true;

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

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .dimensions = {.width = 32, .height = 32, .depth = 32},
            .resource_tag = 1.f,
        });

        AddGamePatches();

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);
      renodx::utils::resource::Use(fdw_reason);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  if (g_dump_shaders != 0.f) {
    lut_dump::Use(fdw_reason);
  }
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  return TRUE;
}
