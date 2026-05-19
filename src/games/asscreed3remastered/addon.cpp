/*
 * Copyright (C) 2026 Vik
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "../../utils/windowing.hpp"
#include "./dlss.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;
ShaderInjectData effective_shader_injection;
bool hdr_output_active = true;
bool hdr_output_state_known = false;

bool IsHDROutputActive() {
  return !hdr_output_state_known || hdr_output_active;
}

void UpdateEffectiveShaderInjection() {
  ac3r::dlss::SetHDROutputActive(IsHDROutputActive());

  effective_shader_injection = shader_injection;

  if (!IsHDROutputActive()) {
    effective_shader_injection.tone_map_type = 0.f;
    effective_shader_injection.custom_film_grain_type = 0.f;
    effective_shader_injection.custom_film_grain_strength = 0.f;
  }
}

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Instructions: In-game HDR must be turned ON.",
        .section = "Setup",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Set the in-game HDR Paper White to 200.",
        .section = "Setup",
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Vanilla leaves the game's native HDR tonemapping unchanged. Vanilla+ uses RenoDX ACES.",
        .labels = {"Vanilla", "Vanilla+"},
        .is_enabled = []() { return IsHDROutputActive(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.tone_map_peak_nits,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the display peak brightness in nits.",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.tone_map_game_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% scene white in nits.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.tone_map_ui_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets UI and HUD brightness in nits for the UI HDR conversion LUT.",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 0.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/glare compensation.",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorFilterStrength",
        .binding = &shader_injection.custom_color_filter_strength,
        .default_value = 100.f,
        .label = "Color Filter Strength",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Perceptual Film Grain",
        .section = "Effects",
        .tooltip = "Adds perceptual luminance-based film grain to the final image.",
        .labels = {"Off", "On"},
        .is_enabled = []() { return IsHDROutputActive(); },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainStrength",
        .binding = &shader_injection.custom_film_grain_strength,
        .default_value = 50.f,
        .label = "Film Grain Strength",
        .section = "Effects",
        .tooltip = "Controls perceptual film grain strength.",
        .max = 100.f,
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.custom_film_grain_type != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "DLAA",
        .binding = &ac3r::dlss::dlaa_enabled,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "TAA/DLSS",
        .section = "Antialiasing",
        .tooltip = "Runs NVIDIA DLAA in place of the game's native temporal AA pass. Requires nvngx_dlss.dll next to the game executable.",
        .labels = {"TAA", "DLSS"},
        .is_visible = []() { return ac3r::dlss::IsSupported(); },
    },
    new renodx::utils::settings::Setting{
        .key = "DLAAPreset",
        .binding = &ac3r::dlss::dlaa_render_preset,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "DLSS Preset",
        .section = "Antialiasing",
        .tooltip = "Selects the NGX DLSS/DLAA render preset.",
        .labels = {"Default", "F - CNN", "J - Transformer 1", "K - Transformer 1", "L - Transformer 2", "M - Transformer 2"},
        .is_enabled = []() { return ac3r::dlss::dlaa_enabled != 0.f; },
        .is_visible = []() { return ac3r::dlss::IsSupported(); },
    },
    new renodx::utils::settings::Setting{
        .key = "HDRExposureCompensation",
        .binding = &shader_injection.exposure_compensation,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "HDR Exposure Compensation",
        .section = "Advanced",
        .tooltip = "Attempts to compensate exposure shifts from the game's white scale.",
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "HDRContrastCompensation",
        .binding = &shader_injection.contrast_compensation,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "HDR Contrast Compensation",
        .section = "Advanced",
        .tooltip = "Attempts to compensate contrast shifts from the game's white scale.",
        .is_enabled = []() { return IsHDROutputActive() && shader_injection.tone_map_type != 0.f; },
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
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
    },
        new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Hartapfel's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/hartapfel"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/musaqh"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
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
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ToneMapHueCorrection", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorFilterStrength", 100.f},
      {"FxFilmGrain", 0.f},
      {"FxFilmGrainStrength", 50.f},
      {"DLAA", 0.f},
      {"DLAAPreset", 0.f},
      {"HDRExposureCompensation", 0.f},
      {"HDRContrastCompensation", 0.f},
  });
}

bool fired_on_init_swapchain = false;
bool borderless_fullscreen_pending = false;

bool ApplyBorderlessFullscreen(reshade::api::swapchain* swapchain) {
  if (swapchain == nullptr) return false;
  if (!renodx::utils::swapchain::IsDXGI(swapchain)) return false;

  HWND hwnd = static_cast<HWND>(swapchain->get_hwnd());
  if (hwnd == nullptr) return false;

  auto* device = swapchain->get_device();
  if (device == nullptr) return false;

  const auto back_buffer = swapchain->get_current_back_buffer();
  if (back_buffer.handle == 0) return false;

  const auto back_buffer_desc = device->get_resource_desc(back_buffer);
  if (back_buffer_desc.texture.width == 0 || back_buffer_desc.texture.height == 0) return false;

  RECT monitor_rect = {};
  if (!renodx::utils::windowing::GetMonitorRect(hwnd, &monitor_rect)) return false;

  const auto monitor_width = static_cast<uint32_t>(monitor_rect.right - monitor_rect.left);
  const auto monitor_height = static_cast<uint32_t>(monitor_rect.bottom - monitor_rect.top);

  if (monitor_width != back_buffer_desc.texture.width || monitor_height != back_buffer_desc.texture.height) {
    return false;
  }

  renodx::utils::windowing::RemoveWindowBorder(hwnd);
  return renodx::utils::windowing::SetWindowPositionAndSize(
      hwnd,
      monitor_rect.left,
      monitor_rect.top,
      monitor_width,
      monitor_height);
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!renodx::utils::swapchain::IsDXGI(swapchain)) return;

  const auto display_info = renodx::utils::swapchain::GetDisplayInfo(swapchain);
  hdr_output_state_known = true;
  hdr_output_active = display_info.hdr_enabled && renodx::utils::swapchain::IsHDRColorSpace(swapchain);
  UpdateEffectiveShaderInjection();

  if (!fired_on_init_swapchain) {
    if (hdr_output_active) {
      float peak = renodx::utils::swapchain::GetPeakNits(swapchain).value_or(1000.f);
      settings[3]->default_value = peak;
    }

    fired_on_init_swapchain = true;
  }

  auto* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());
  IDXGIFactory* factory = nullptr;
  if (native_swapchain != nullptr && SUCCEEDED(native_swapchain->GetParent(IID_PPV_ARGS(&factory)))) {
    factory->MakeWindowAssociation(static_cast<HWND>(swapchain->get_hwnd()), DXGI_MWA_NO_WINDOW_CHANGES);
    factory->Release();
  }

  borderless_fullscreen_pending = !ApplyBorderlessFullscreen(swapchain);
}

bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  if (fullscreen) {
    borderless_fullscreen_pending = true;
    ApplyBorderlessFullscreen(swapchain);
    return true;
  }

  borderless_fullscreen_pending = false;
  return false;
}

void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  UpdateEffectiveShaderInjection();

  if (!borderless_fullscreen_pending) return;
  borderless_fullscreen_pending = !ApplyBorderlessFullscreen(swapchain);
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Assassin's Creed 3 Remastered";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::utils::random::binds.push_back(&shader_injection.custom_random);
        UpdateEffectiveShaderInjection();
        initialized = true;
      }
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  UpdateEffectiveShaderInjection();
  renodx::utils::random::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &effective_shader_injection);
  ac3r::dlss::Use(fdw_reason);

  return TRUE;
}
