/*
 * Copyright (C) 2026
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
#define DEBUG_LEVEL_0

#include <windows.h>

#include <atomic>
#include <cmath>
#include <format>
#include <optional>
#include <string>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./pipeline_variants.hpp"
#include "./shared.h"
#include "./supported_build.hpp"

namespace {

namespace pipeline_variants =
    renodx::games::doom2016::pipeline_variants;
namespace supported_build = renodx::games::doom2016::supported_build;

constexpr float OUTPUT_MODE_SDR = 0.f;
constexpr float OUTPUT_MODE_HDR10 = 1.f;
constexpr float PEAK_SOURCE_AUTOMATIC = 0.f;
constexpr float PEAK_SOURCE_MANUAL = 1.f;
constexpr float FALLBACK_PEAK_NITS = 1000.f;

ShaderInjectData shader_injection = {
    .peak_white_nits = FALLBACK_PEAK_NITS,
    .diffuse_white_nits = 203.f,
    .graphics_white_nits = 203.f,
    .output_mode = OUTPUT_MODE_SDR,
    .tone_map_type = DOOM2016_TONEMAP_RENO_DRT,
    .tone_map_exposure = 1.f,
    .tone_map_highlights = 1.f,
    .tone_map_shadows = 1.f,
    .tone_map_contrast = 1.f,
    .tone_map_saturation = 1.f,
    .tone_map_highlight_saturation = 1.f,
    .psychov_cone_response = 1.f,
    .psychov_exposure_match = 1.f,
    .psychov_vanilla_slope = 1.f,
    .scene_path_active = 0.f,
    .scene_bt2020 = 0.f,
};

float requested_output_mode = OUTPUT_MODE_HDR10;
float peak_brightness_source = PEAK_SOURCE_AUTOMATIC;
float manual_peak_nits = FALLBACK_PEAK_NITS;
std::optional<float> detected_peak_nits = std::nullopt;
std::atomic_bool output_restart_required = false;
std::atomic<reshade::api::swapchain*> tracked_swapchain = nullptr;
std::string peak_brightness_status =
    "Auto: waiting for the DOOM Vulkan window; using 1000 nits fallback.";
renodx::utils::settings::Setting* peak_brightness_status_setting = nullptr;
bool diagnostic_disable_replacements = false;
bool diagnostic_injection_only = false;
pipeline_variants::DiagnosticMode diagnostic_pipeline_mode =
    pipeline_variants::DiagnosticMode::kProduction;

bool ReadEnvironmentFlag(const wchar_t* name) {
  wchar_t value[8] = {};
  const DWORD length = GetEnvironmentVariableW(
      name,
      value,
      static_cast<DWORD>(std::size(value)));
  return length != 0u && length < std::size(value)
         && value[0] != L'0';
}

bool IsPsychoVMode() {
  return shader_injection.tone_map_type >= DOOM2016_TONEMAP_PSYCHOV_17
         && shader_injection.tone_map_type <= DOOM2016_TONEMAP_PSYCHOV_30;
}

void UpdatePeakBrightnessStatus() {
  if (peak_brightness_status_setting != nullptr) {
    peak_brightness_status_setting->label = peak_brightness_status;
  }
}

void ResolvePeakBrightness() {
  if (peak_brightness_source >= 0.5f) {
    shader_injection.peak_white_nits = std::clamp(
        std::isfinite(manual_peak_nits)
            ? manual_peak_nits
            : FALLBACK_PEAK_NITS,
        48.f,
        4000.f);
    peak_brightness_status = std::format(
        "Manual: effective peak is {:.0f} nits.",
        shader_injection.peak_white_nits);
  } else if (detected_peak_nits.has_value()
             && std::isfinite(*detected_peak_nits)
             && *detected_peak_nits >= 48.f
             && *detected_peak_nits <= 4000.f) {
    shader_injection.peak_white_nits = *detected_peak_nits;
    peak_brightness_status = std::format(
        "Auto: monitor metadata reports {:.0f} nits.",
        shader_injection.peak_white_nits);
  } else {
    shader_injection.peak_white_nits = FALLBACK_PEAK_NITS;
    peak_brightness_status =
        "Auto: HDR monitor peak is unavailable; using 1000 nits fallback.";
  }
  UpdatePeakBrightnessStatus();
}

void RefreshDetectedPeak(reshade::api::swapchain* swapchain) {
  if (swapchain == nullptr || peak_brightness_source >= 0.5f) return;
  detected_peak_nits = renodx::utils::swapchain::GetPeakNits(
      static_cast<HWND>(swapchain->get_hwnd()));
  ResolvePeakBrightness();
}

void HandleOutputModeSetting(float requested) {
  const bool needs_restart =
      (requested >= 0.5f) != (shader_injection.output_mode >= 0.5f);
  output_restart_required.store(needs_restart, std::memory_order_release);
}

bool OnPostProcessDraw(reshade::api::command_list*) {
  shader_injection.scene_path_active =
      pipeline_variants::UsesModifiedPostProcess()
          ? 1.f
          : 0.f;
  shader_injection.scene_bt2020 =
      pipeline_variants::UsesBt2020PostProcess()
          ? 1.f
          : 0.f;
  return true;
}

bool OnOutputDraw(reshade::api::command_list*) {
  return true;
}

renodx::mods::shader::CustomShaders target_shaders = {
    {supported_build::kPostProcessShaderCrc,
     {
         .crc32 = supported_build::kPostProcessShaderCrc,
         .on_draw = &OnPostProcessDraw,
     }},
    {supported_build::kOutputShaderCrc,
     {
         .crc32 = supported_build::kOutputShaderCrc,
         .on_draw = &OnOutputDraw,
     }},
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"OutputMode", OUTPUT_MODE_SDR},
      {"ToneMapType", DOOM2016_TONEMAP_VANILLA},
      {"PeakBrightnessSource", PEAK_SOURCE_MANUAL},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeConeResponse", 50.f},
      {"ToneMapPsychoVExposureMatch", 1.f},
      {"ToneMapPsychoVVanillaHDRSlope", 100.f},
  });
  ResolvePeakBrightness();
  HandleOutputModeSetting(OUTPUT_MODE_SDR);
}

renodx::utils::settings::Settings settings =
    renodx::templates::settings::JoinSettings({
        renodx::templates::settings::CreateSettings({
            {{
                .key = "OutputMode",
                .binding = &requested_output_mode,
                .value_type =
                    renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = OUTPUT_MODE_HDR10,
                .can_reset = true,
                .label = "Output Mode",
                .section = "Display Output",
                .tooltip = "Selects the native Vulkan swapchain output used on the next game start.",
                .labels = {"SDR", "HDR10"},
                .on_change_value = [](float, float current) {
                  HandleOutputModeSetting(current);
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Restart DOOM to apply Output Mode. Vulkan swapchain format and color space are immutable after creation.",
                .section = "Display Output",
                .tint = 0xFF7F00,
                .is_visible = []() {
                  return output_restart_required.load(
                      std::memory_order_acquire);
                },
            }},
        }),
        []() {
          auto defaults =
              renodx::templates::settings::CreateDefaultSettings({
                  {"ToneMapType",
                   {
                       .binding = &shader_injection.tone_map_type,
                       .default_value = DOOM2016_TONEMAP_RENO_DRT,
                       .labels = {
                           "Vanilla",
                           "PsychoV-17",
                           "PsychoV-22",
                           "PsychoV-24",
                           "PsychoV-25",
                           "PsychoV-30",
                           "RenoDRT",
                       },
                       .parse = [](float value) { return value; },
                   }},
                  {"ToneMapPeakNits",
                   {
                       .binding = &manual_peak_nits,
                       .default_value = FALLBACK_PEAK_NITS,
                       .can_reset = false,
                       .label = "Manual Peak Brightness",
                       .tooltip = "Saved manual peak. Auto detection does not overwrite it.",
                       .is_enabled = []() {
                         return peak_brightness_source >= 0.5f;
                       },
                       .on_change_value = [](float, float) {
                         ResolvePeakBrightness();
                       },
                   }},
                  {"ToneMapGameNits",
                   {.binding = &shader_injection.diffuse_white_nits}},
                  {"ToneMapUINits",
                   {.binding = &shader_injection.graphics_white_nits}},
                  {"ColorGradeExposure",
                   {.binding = &shader_injection.tone_map_exposure}},
                  {"ColorGradeHighlights",
                   {.binding = &shader_injection.tone_map_highlights}},
                  {"ColorGradeShadows",
                   {.binding = &shader_injection.tone_map_shadows}},
                  {"ColorGradeContrast",
                   {.binding = &shader_injection.tone_map_contrast}},
                  {"ColorGradeSaturation",
                   {.binding = &shader_injection.tone_map_saturation}},
                  {"ColorGradeHighlightSaturation",
                   {.binding =
                        &shader_injection.tone_map_highlight_saturation}},
              });
          defaults.insert(
              defaults.begin() + 2,
              renodx::templates::settings::CreateSetting({
                  .key = "PeakBrightnessSource",
                  .binding = &peak_brightness_source,
                  .value_type =
                      renodx::utils::settings::SettingValueType::INTEGER,
                  .default_value = PEAK_SOURCE_AUTOMATIC,
                  .can_reset = true,
                  .label = "Peak Brightness Source",
                  .section = "Tone Mapping",
                   .labels = {"Auto", "Manual"},
                   .on_change_value = [](float, float) {
                     if (peak_brightness_source < 0.5f) {
                       auto* swapchain = tracked_swapchain.load(
                           std::memory_order_acquire);
                       if (swapchain != nullptr) {
                         RefreshDetectedPeak(swapchain);
                         return;
                       }
                     }
                     ResolvePeakBrightness();
                   },
              }));
          defaults.insert(
              defaults.begin() + 4,
              peak_brightness_status_setting =
                  renodx::templates::settings::CreateSetting({
                      .key = "PeakBrightnessStatus",
                      .value_type =
                          renodx::utils::settings::SettingValueType::TEXT,
                      .can_reset = false,
                      .label = peak_brightness_status,
                      .section = "Tone Mapping",
                  }));
          return defaults;
        }(),
        renodx::templates::settings::CreateSettings({
            {{
                .key = "ColorGradeConeResponse",
                .binding = &shader_injection.psychov_cone_response,
                .default_value = 50.f,
                .label = "Cone Response",
                .section = "Color Grading",
                .tooltip = "Controls PsychoV cone-response shaping.",
                .min = 0.f,
                .max = 100.f,
                .parse = [](float value) { return value * 0.02f; },
                .is_visible = []() { return IsPsychoVMode(); },
            }},
            {{
                .key = "ToneMapPsychoVExposureMatch",
                .binding = &shader_injection.psychov_exposure_match,
                .value_type =
                    renodx::utils::settings::SettingValueType::BOOLEAN,
                .default_value = 1.f,
                .label = "Exposure Match",
                .section = "Color Grading",
                .tooltip = "Matches PsychoV's 18% anchor to DOOM's analytic vanilla curve.",
                .is_visible = []() { return IsPsychoVMode(); },
            }},
            {{
                .key = "ToneMapPsychoVVanillaHDRSlope",
                .binding = &shader_injection.psychov_vanilla_slope,
                .default_value = 100.f,
                .label = "Vanilla HDR Slope",
                .section = "Color Grading",
                .tooltip = "Blends PsychoV cone response toward DOOM's local neutral-curve slope.",
                .min = 0.f,
                .max = 100.f,
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return IsPsychoVMode(); },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "PsychoV-25 executes at full resolution in this research build. Its mode remains provisional until the required DOOM GPU timing gate passes.",
                .section = "Tone Mapping",
                .tint = 0xFF7F00,
                .is_visible = []() {
                  return shader_injection.tone_map_type ==
                         DOOM2016_TONEMAP_PSYCHOV_25;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "GOG DOOMx64vk.exe only. HDR10 is a true pre-SDR path through the captured float carrier; Auto HDR and RTX HDR must be disabled.",
                .section = "About",
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = std::string("Build: ") +
                         renodx::utils::date::ISO_DATE_TIME,
                .section = "About",
            }},
        }),
    });

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool) {
  if (swapchain == nullptr
      || swapchain->get_device()->get_api()
             != reshade::api::device_api::vulkan) {
    return;
  }
  auto* expected = static_cast<reshade::api::swapchain*>(nullptr);
  if (!tracked_swapchain.compare_exchange_strong(
          expected,
          swapchain,
          std::memory_order_acq_rel)
      && expected != swapchain) {
    return;
  }
  RefreshDetectedPeak(swapchain);
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool) {
  auto* expected = swapchain;
  tracked_swapchain.compare_exchange_strong(
      expected,
      nullptr,
      std::memory_order_acq_rel);
}

void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain*,
    const reshade::api::rect*,
    const reshade::api::rect*,
    std::uint32_t,
    const reshade::api::rect*) {
  shader_injection.scene_path_active = 0.f;
  shader_injection.scene_bt2020 = 0.f;
}

void ConfigureBootOutput() {
  shader_injection.output_mode = requested_output_mode >= 0.5f
                                     ? OUTPUT_MODE_HDR10
                                     : OUTPUT_MODE_SDR;
  output_restart_required.store(false, std::memory_order_release);
  if (shader_injection.output_mode != OUTPUT_MODE_HDR10) return;

  renodx::mods::swapchain::prevent_full_screen = false;
  renodx::mods::swapchain::force_borderless = false;
  renodx::mods::swapchain::force_screen_tearing = false;
  renodx::mods::swapchain::use_resource_cloning = true;
  renodx::mods::swapchain::swap_chain_proxy_vertex_shader =
      __swap_chain_proxy_vertex_shader;
  renodx::mods::swapchain::swap_chain_proxy_pixel_shader =
      __swap_chain_proxy_pixel_shader;
  renodx::mods::swapchain::swap_chain_proxy_format =
      reshade::api::format::r16g16b16a16_float;
  renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
  renodx::mods::swapchain::swapchain_proxy_revert_state = true;
  renodx::mods::swapchain::set_color_space = true;
  renodx::mods::swapchain::use_resize_buffer = false;
  renodx::mods::swapchain::SetUseHDR10(true);
}

std::atomic_bool addon_attached = false;

bool AttachAddon(HMODULE module) {
  HMODULE pinned_module = nullptr;
  if (!GetModuleHandleExW(
          GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS
              | GET_MODULE_HANDLE_EX_FLAG_PIN,
          reinterpret_cast<LPCWSTR>(&AttachAddon),
          &pinned_module)) {
    return false;
  }
  if (addon_attached.exchange(true, std::memory_order_acq_rel)) return true;
  DisableThreadLibraryCalls(module);
  if (!reshade::register_addon(module)) {
    addon_attached.store(false, std::memory_order_release);
    return false;
  }

  renodx::utils::settings::Use(
      DLL_PROCESS_ATTACH,
      &settings,
      &OnPresetOff);
  ConfigureBootOutput();
  ResolvePeakBrightness();

  diagnostic_disable_replacements = ReadEnvironmentFlag(
      L"RENODX_DOOM_DISABLE_REPLACEMENTS");
  if (!diagnostic_disable_replacements) {
    diagnostic_injection_only = ReadEnvironmentFlag(
        L"RENODX_DOOM_INJECTION_ONLY");
    if (ReadEnvironmentFlag(L"RENODX_DOOM_IDENTITY_OUTPUT")) {
      diagnostic_pipeline_mode =
          pipeline_variants::DiagnosticMode::kIdentityOutput;
    } else if (ReadEnvironmentFlag(L"RENODX_DOOM_MODIFIED_OUTPUT")) {
      diagnostic_pipeline_mode =
          pipeline_variants::DiagnosticMode::kModifiedOutput;
    } else if (ReadEnvironmentFlag(L"RENODX_DOOM_IDENTITY_POST")) {
      diagnostic_pipeline_mode =
          pipeline_variants::DiagnosticMode::kIdentityPostProcess;
    } else if (ReadEnvironmentFlag(L"RENODX_DOOM_MODIFIED_POST")) {
      diagnostic_pipeline_mode =
          pipeline_variants::DiagnosticMode::kModifiedPostProcess;
    } else if (ReadEnvironmentFlag(
                   L"RENODX_DOOM_MODIFIED_BOTH_VANILLA")) {
      diagnostic_pipeline_mode =
          pipeline_variants::DiagnosticMode::kModifiedBothVanilla;
    }
    if (!diagnostic_injection_only) {
      pipeline_variants::SetDiagnosticMode(diagnostic_pipeline_mode);
      pipeline_variants::UseEarly(DLL_PROCESS_ATTACH, &shader_injection);
    }
    renodx::mods::shader::manual_shader_scheduling = true;
    renodx::mods::shader::allow_multiple_push_constants = true;
    renodx::mods::shader::minimum_constant_buffer_stages =
        reshade::api::shader_stage::pixel;
    renodx::mods::shader::on_create_pipeline_layout = [](
      reshade::api::device* device,
      std::span<reshade::api::pipeline_layout_param> params) {
    if (device == nullptr
        || device->get_api() != reshade::api::device_api::vulkan
        || params.size() != 1u
        || params[0].type
               != reshade::api::pipeline_layout_param_type::descriptor_table) {
      return false;
    }
    const auto& table = params[0].descriptor_table;
    if (table.ranges == nullptr
        || (table.count != 4u && table.count != 19u)) {
      return false;
    }
    for (std::uint32_t index = 0u; index < table.count; ++index) {
      if (table.ranges[index].binding != index
          || table.ranges[index].count != 1u) {
        return false;
      }
    }
    return true;
    };
    renodx::mods::shader::Use(
        DLL_PROCESS_ATTACH,
        target_shaders,
        &shader_injection);
    if (!diagnostic_injection_only) {
      pipeline_variants::UseLate(DLL_PROCESS_ATTACH);
    } else {
      reshade::log::message(
          reshade::log::level::warning,
          "DOOM 2016 HDR diagnostic: push-constant injection is enabled, but replacement pipeline binding is disabled.");
    }
  } else {
    reshade::log::message(
        reshade::log::level::warning,
        "DOOM 2016 HDR diagnostic: shader replacements are disabled; testing swapchain proxy only.");
  }

  if (shader_injection.output_mode == OUTPUT_MODE_HDR10) {
    // The proxy is a thin copy from the game-facing RGBA16F clone to the real
    // RGB10A2 swapchain. HDR encoding already happened in viewcolor_output,
    // so no per-frame constants belong in this separate immediate pass.
    renodx::mods::swapchain::Use(DLL_PROCESS_ATTACH);
  }

  reshade::register_event<reshade::addon_event::init_swapchain>(
      OnInitSwapchain);
  reshade::register_event<reshade::addon_event::destroy_swapchain>(
      OnDestroySwapchain);
  reshade::register_event<reshade::addon_event::present>(OnPresent);
  return true;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX HDR for DOOM (2016) (GOG, Vulkan, experimental)";

BOOL APIENTRY DllMain(HMODULE module, DWORD reason, LPVOID) {
  if (reason == DLL_PROCESS_ATTACH) {
    return AttachAddon(module) ? TRUE : FALSE;
  }
  if (reason == DLL_PROCESS_DETACH) {
    addon_attached.store(false, std::memory_order_release);
  }
  return TRUE;
}
