/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define NOMINMAX

#include <chrono>
#include <random>

#include <embed/shaders.h>
#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

ShaderInjectData shader_injection;

namespace {

bool is_bloom_enabled = false;
float is_fxaa_enabled = 0;

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x138CBA83),  // videos (pre-rendered)
    CustomShaderEntry(0x1DA0D576),  // colorcorrectionmerge (lutbaker)
    CustomShaderEntryCallback(0xD11C77B6, [](reshade::api::command_list* cmd_list) {  // combineeffects (color grading, dof, bloom)
    is_bloom_enabled = true;
    return true;
    }),
    CustomShaderEntryCallback(0x70CEAF26, [](reshade::api::command_list* cmd_list) {  // combineeffects 2 (color grading)
    is_bloom_enabled = false;
    return true;
    }),
    CustomShaderEntryCallback(0x8159D8EB, [](reshade::api::command_list* cmd_list) {  // fxaa
    is_fxaa_enabled = 1;
    return true;
    }),
    CustomShaderEntryCallback(0xE76323E6, [](reshade::api::command_list* cmd_list) {  // UI
    shader_injection.hasLoadedTitleMenu = 1.f;
    return true;
    }),
};

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
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "Frostbite", "RenoDRT (Daniele)", "RenoDRT (Reinhard)", "DICE"},
        .tint = 0xFB7352,
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .tint = 0xAC7C38,
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .tint = 0xAC7C38,
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
        .tint = 0xAC7C38,
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
        .labels = {"Off", "2.2", "BT.1886"},
        .tint = 0xAC7C38,
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .tint = 0xAC7C38,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueProcessor",
        .binding = &shader_injection.toneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .labels = {"OKLab", "ICtCp", "darktable UCS"},
        .tint = 0xAC7C38,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueShift",
        .binding = &shader_injection.toneMapHueShift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .tint = 0xAC7C38,
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f && shader_injection.toneMapPerChannel == 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 0.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tint = 0xAC7C38,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapShoulderStart",
        .binding = &shader_injection.toneMapShoulderStart,
        .default_value = 0.25f,
        .label = "Rolloff/Shoulder Start",
        .section = "Tone Mapping",
        .tint = 0xAC7C38,
        .max = 0.99f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.toneMapType == 2.f || shader_injection.toneMapType == 5.f ; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 10.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 50.f,
        .label = "Highlights Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlights color.",
        .tint = 0x38F6FC,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeDechroma",
        .binding = &shader_injection.colorGradeDechroma,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .tint = 0x38F6FC,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return fmax(0.00001f, value * 0.01f); },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3.f || shader_injection.toneMapType == 4.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeClip",
        .binding = &shader_injection.colorGradeClip,
        .default_value = 1.f,
        .label = "Clipping",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 4.f; },
        .parse = [](float value) { return value; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .tint = 0x38F6FC,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 1.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTSampling",
        .binding = &shader_injection.colorGradeLUTSampling,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "LUT Sampling",
        .section = "Color Grading",
        .labels = {"Trilinear", "Tetrahedral"},
        .tint = 0x38F6FC,
        .is_enabled = []() { return shader_injection.toneMapType != 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tint = 0x0D1D34,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return is_bloom_enabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBlur",
        .binding = &shader_injection.fxBlur,
        .default_value = 50.f,
        .label = "Blur",
        .section = "Effects",
        .tint = 0x0D1D34,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return is_bloom_enabled; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxCA",
        .binding = &shader_injection.fxCA,
        .default_value = 0.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tint = 0x0D1D34,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxSharpen",
        .binding = &shader_injection.fxSharpen,
        .default_value = 0.f,
        .label = "Sharpening",
        .section = "Effects",
        .tooltip = "Requires FXAA enabled in game settings.",
        .tint = 0x0D1D34,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.FxaaCheck == 1.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFlash",
        .binding = &shader_injection.fxFlash,
        .default_value = 100.f,
        .label = "Flash",
        .section = "Effects",
        .tooltip = "Reduces bright screen flash (example: Daggers' Shadow Strike).",
        .tint = 0x0D1D34,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 0.f,
        .label = "Vignette",
        .section = "Effects",
        .tint = 0x0D1D34,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 0.f,
        .label = "Film Grain",
        .section = "Effects",
        .tint = 0x0D1D34,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrainType",
        .binding = &shader_injection.fxFilmGrainType,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Black & White", "Colored"},
        .tint = 0x0D1D34,
        .is_visible = []() { return shader_injection.fxFilmGrain != 0.f && current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x0D1D34,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapType", 4.f);
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueShift", 50.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 0.f);
          renodx::utils::settings::UpdateSetting("toneMapShoulderStart", 0.25f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 0.f);
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 0.f);
          renodx::utils::settings::UpdateSetting("colorGradeClip", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 1.f);
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Look",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x38F6FC,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 0.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueShift", 50.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100.f);
          renodx::utils::settings::UpdateSetting("toneMapShoulderStart", 0.33f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 42.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 65.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 80.f);
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeClip", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 1.f); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "About",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "About",
        .group = "button-line-2",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Version: " + std::string(renodx::utils::date::ISO_DATE),
        .section = "About",
        .tooltip = std::string(__DATE__),
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
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 0.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxBlur", 50.f);
  renodx::utils::settings::UpdateSetting("fxCA", 0.f);
  renodx::utils::settings::UpdateSetting("fxSharpen", 0.f);
  renodx::utils::settings::UpdateSetting("fxVignette", 0.f);
  renodx::utils::settings::UpdateSetting("fxFlash", 100.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 0.f);
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

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
    static std::mt19937 random_generator(std::chrono::system_clock::now().time_since_epoch().count());
    static auto random_range = static_cast<float>(std::mt19937::max() - std::mt19937::min());
  shader_injection.random_1 = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
  shader_injection.random_2 = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
  shader_injection.random_3 = static_cast<float>(random_generator() + std::mt19937::min()) / random_range;
    shader_injection.FxaaCheck = is_fxaa_enabled;
    is_fxaa_enabled = 0;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Kingdoms of Amalur: Re-Reckoning";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      // RGBA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
          .usage_include = reshade::api::resource_usage::render_target,
      });
      // RGBA8_unorm
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = false,
      });

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
