/*
 * Copyright (C) 2025 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include <span>

#include "../../mods/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/pipeline.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xC66F9B98),  // Bloom

    CustomShaderEntry(0x4BB65477),  // HDR Calibration Menu

    // CustomShaderEntry(0x4B89087D),  // LUT?
    CustomShaderEntry(0x4D780747),  // ToneMap
    CustomShaderEntry(0x903B49C1),  // BT.2020 + PQ Encode
                                    // CustomShaderEntry(0x64DB1117),  // Gamma Adjust (only relevant in SDR)
};

constexpr float FALLBACK_PEAK_NITS = 1000.f;
float peak_nits_default = FALLBACK_PEAK_NITS;
bool peak_nits_default_initialized = false;
bool swapchain_is_hdr = false;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapOverridePeakBrightness",
        .binding = &shader_injection.tone_map_override_peak_nits,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Override Peak Brightness",
        .section = "Output",
        .tooltip = "Overrides the peak brightness set in the game's HDR calibration",
        .is_visible = []() { return swapchain_is_hdr; },
    },
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = FALLBACK_PEAK_NITS,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Output",
        .tooltip = "Sets the value of peak white in nits.\nDefault: detected display peak nits (1000 nits fallback)",
        .min = 48.f,
        .max = 10000.f,
        .is_enabled = []() { return shader_injection.tone_map_override_peak_nits != 0.f; },
        .is_visible = []() { return swapchain_is_hdr; },
        .is_logarithmic = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Output",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .is_visible = []() { return swapchain_is_hdr; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "Vanilla+"},
    },
    new renodx::utils::settings::Setting{
        .key = "SDREOTFEmulation",
        .binding = &shader_injection.sdr_eotf_emulation,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF, or lowers the tone mapper's black floor instead of applying 2.2",
        .labels = {"Off", "2.2", "Lower Black Floor"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
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
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "HDR10Encoding",
        .binding = &shader_injection.custom_hdr10_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "HDR10 Encoding",
        .section = "Advanced",
        .tooltip = "Sets the HDR10 Encoding format",
        .labels = {"Vanilla (PQ Approximation)", "PQ"},
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-0",
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
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "t9v7wx9NTD");
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
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "musaqh");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "shortfuse");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool /*resize*/) {
  if (swapchain == nullptr) return;

  swapchain_is_hdr = renodx::utils::swapchain::IsHDRColorSpace(swapchain);

  if (!swapchain_is_hdr || peak_nits_default_initialized) return;
  peak_nits_default_initialized = true;
  const auto detected_peak_nits = renodx::utils::swapchain::GetPeakNits(swapchain);
  tone_map_peak_nits_setting->can_reset = detected_peak_nits.has_value() && *detected_peak_nits > 0.f;
  peak_nits_default = (tone_map_peak_nits_setting->can_reset ? *detected_peak_nits : FALLBACK_PEAK_NITS);

  const bool was_using_default = tone_map_peak_nits_setting->GetValue() == tone_map_peak_nits_setting->default_value;
  tone_map_peak_nits_setting->default_value = peak_nits_default;
  if (was_using_default) {
    tone_map_peak_nits_setting->Set(peak_nits_default)->Write();
  }
}

// Workaround until the core rewrite. D3D12 types a pipeline state stream by which of VS, CS or MS has bytecode,
// fails creation if more than one does, and ignores every other subobject (D3D12_PIPELINE_STATE_STREAM_DESC
// remarks). This game's compute streams also carry graphics states, which the core counts as graphics, so the
// PSO resolves to an UNKNOWN bind point and the D3D12 state tracker drops its binds. ReShade only lists a shader
// subobject when it has bytecode, so the first VS, CS or MS found decides the type.
void OnInitPipeline(
    renodx::utils::pipeline::PipelineInfo* info,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  if (info->bind_point != renodx::utils::pipeline::PipelineBindPoint::UNKNOWN) return;
  if (info->device == nullptr || info->device->get_api() != reshade::api::device_api::d3d12) return;
  for (const auto& subobject : std::span(subobjects, subobject_count)) {
    switch (subobject.type) {
      case reshade::api::pipeline_subobject_type::compute_shader:
        info->bind_point = renodx::utils::pipeline::PipelineBindPoint::COMPUTE;
        return;
      case reshade::api::pipeline_subobject_type::vertex_shader:
      case reshade::api::pipeline_subobject_type::mesh_shader:
        info->bind_point = renodx::utils::pipeline::PipelineBindPoint::GRAPHICS;
        return;
      default:
        break;
    }
  }
}

// A swapchain's color space can be set after it is created, so detection repeats until HDR is seen.
void OnPresent(
    [[maybe_unused]] reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    [[maybe_unused]] const reshade::api::rect* source_rect,
    [[maybe_unused]] const reshade::api::rect* dest_rect,
    [[maybe_unused]] uint32_t dirty_rect_count,
    [[maybe_unused]] const reshade::api::rect* dirty_rects) {
  OnInitSwapchain(swapchain, false);
}

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapOverridePeakBrightness", 0.f},
      {"ToneMapPeakNits", peak_nits_default},
      {"ToneMapGameNits", 100.f},
      {"ToneMapType", 0.f},
      {"SDREOTFEmulation", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"FxBloom", 100.f},
      {"HDR10Encoding", 0.f},
  });
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for God of War Ragnarök";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::pipeline::RegisterOnInitCallback(&OnInitPipeline);

      // The game is D3D12 only; other APIs belong to overlays and must keep their layouts untouched.
      renodx::mods::shader::on_create_pipeline_layout = [](reshade::api::device* device, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };
      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;

        renodx::mods::shader::use_root_signature_cbv = true;

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      renodx::utils::pipeline::UnregisterOnInitCallback(&OnInitPipeline);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}