/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
#define DEBUG_LEVEL_0

#include <format>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./dlss.hpp"
#include "./shared.h"
#include "./shader_injection.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x4D17CEAB),
    CustomShaderEntry(0x29CCB91A),
    CustomShaderEntry(0xD844C4C3),  // FSR1 RCAS final pass
    CustomShaderEntry(0x71B33647),  // final copy when motion blur is off
    CustomShaderEntry(0xDF37C319),  // post-scene HUD, bounded to UI white
    CustomShaderEntry(0xECF8AA5E),  // reload/HUD material after the scene pass
};

ShaderInjectData shader_injection = {
    .layout_version = GEARS_INJECTION_LAYOUT_VERSION,
    .peak_white_nits = 1000.f,
    .diffuse_white_nits = 203.f,
    .graphics_white_nits = 203.f,
    .tone_map_type = GEARS_TONE_MAP_RENODRT,
    .tone_map_exposure = 1.f,
    .tone_map_contrast = 1.f,
    .tone_map_saturation = 1.f,
    .psychov_cone_response = 1.f,
    .psychov_gamut_compression = 1.f,
    .psychov_compression = 0.f,
    .tone_map_highlights = 1.f,
    .tone_map_shadows = 1.f,
    .tone_map_highlight_saturation = 1.f,
    .tone_map_blowout = 0.f,
    .tone_map_flare = 0.f,
    .color_grade_strength = 1.f,
    .swap_chain_output_preset = 2.f,
};
static_assert(sizeof(ShaderInjectData) == 80);

float current_settings_mode = 0.f;
float output_format = 0.f;
float shader_injection_mode = 1.f;
int active_shader_injection_mode = 1;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Simple HDR keeps the game's grade and rolls off highlights with a lightweight curve. Vanilla keeps the original SDR clipping.",
        .labels = {"Vanilla", "RenoDRT", "PsychoV30", "PrismTM", "Simple HDR"},
        .parse = [](float value) {
          if (value < 0.5f) return GEARS_TONE_MAP_VANILLA;
          if (value < 1.5f) return GEARS_TONE_MAP_RENODRT;
          if (value < 2.5f) return GEARS_TONE_MAP_PSYCHOV30;
          if (value < 3.5f) return GEARS_TONE_MAP_PRISM;
          return GEARS_TONE_MAP_SIMPLE;
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the display peak in nits.",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type != GEARS_TONE_MAP_VANILLA; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets scene reference white in nits.",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI composited after the scene pass. In-scene HUD follows Game Brightness.",
        .min = 48.f,
        .max = 500.f,
    },
   new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tooltip = "Sets highlight brightness.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tooltip = "Sets shadow brightness.",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != GEARS_TONE_MAP_VANILLA; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != GEARS_TONE_MAP_VANILLA; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "RenoDRT flare/glare compensation.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == GEARS_TONE_MAP_RENODRT; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Sets the strength of the game's shadow, highlight, midtone and desaturation grade.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != GEARS_TONE_MAP_VANILLA; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVConeResponse",
        .binding = &shader_injection.psychov_cone_response,
        .default_value = 1.f,
        .label = "Cone Response",
        .section = "PsychoV30",
        .min = 0.1f,
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 2.f && shader_injection.tone_map_type == GEARS_TONE_MAP_PSYCHOV30; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVGamutCompression",
        .binding = &shader_injection.psychov_gamut_compression,
        .default_value = 100.f,
        .label = "Gamut Compression",
        .section = "PsychoV30",
        .min = 0.f,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2.f && shader_injection.tone_map_type == GEARS_TONE_MAP_PSYCHOV30; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVCompression",
        .binding = &shader_injection.psychov_compression,
        .default_value = 0.f,
        .label = "Compression",
        .section = "PsychoV30",
        .tooltip = "Zero uses PsychoV30's automatic compression.",
        .min = 0.f,
        .max = 4.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 2.f && shader_injection.tone_map_type == GEARS_TONE_MAP_PSYCHOV30; },
    },
    new renodx::utils::settings::Setting{
        .key = "GearsShaderInjectionMode",
        .binding = &shader_injection_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Shader Injection (Restart Required)",
        .section = "Output",
        .tooltip = "Direct DX11 binds settings only for the two HDR pixel shaders. Standard uses the shared RenoDX shader module. Disabled leaves the game shaders unchanged. Restart after changing this setting.",
        .labels = {"Disabled", "Direct DX11", "Standard"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "GearsOutputFormat",
        .binding = &output_format,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "HDR Output (Restart Required)",
        .section = "Output",
        .tooltip = "scRGB uses a 64-bit output buffer. HDR10 uses a 32-bit output buffer and may reduce presentation bandwidth. Restart the game after changing this setting.",
        .labels = {"scRGB", "HDR10"},
        .is_global = true,
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeScene", 100.f);
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool) {
  // Follow the actual output format, including after a resize. The UI choice
  // is applied only at startup so it cannot relabel an active scRGB buffer.
  shader_injection.swap_chain_output_preset =
      swapchain->get_device()->get_resource_desc(swapchain->get_back_buffer(0)).texture.format
              == reshade::api::format::r10g10b10a2_unorm
          ? 1.f
          : 2.f;
}

bool OnClearRenderTargetView(reshade::api::command_list* cmd_list,
                            reshade::api::resource_view rtv,
                            const float color[4], uint32_t rect_count,
                            const reshade::api::rect* rects) {
  // D3D11 has no deferred render-pass clears to track. Only the backbuffer
  // has a clone; offscreen native HDR resources use the engine's own clear.
  if (const auto clone = renodx::utils::resource::upgrade::GetResourceViewClone(rtv);
      clone.handle != 0u) {
    cmd_list->clear_render_target_view(clone, color, rect_count, rects);
    return true;
  }
  return false;
}

void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain*,
               const reshade::api::rect*, const reshade::api::rect*,
               uint32_t, const reshade::api::rect*) {
  if (auto* data = renodx::utils::data::Get<renodx::mods::swapchain::DeviceData>(queue->get_device());
      data != nullptr) {
    // Present submits D3D11 work. The proxy does not need a separate Flush.
    // This callback follows the proxy callback, so newly created passes stop
    // flushing after their first use; existing passes retain the setting.
    for (auto& [buffer, proxy_pass] : data->swapchain_proxy_passes) {
      proxy_pass->auto_device_flush = false;
      proxy_pass->pass.flush_after_render = false;
    }
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX - Gears of War Redux";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "Gears of War Redux HDR (scRGB / HDR10)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;

      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::use_resource_cloning = true;
      // Like Batman AK and Bulletstorm, draw game/UI output into the FP16
      // proxy directly. Compatibility mode copied an entire frame at Present.
      // Register only D3D11 RTV binding and clear hooks below. The shared
      // per-draw render-pass/clone checks are unnecessary on this native API.
      // Engine/NGX offscreen textures below still use native upgrades.
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::use_resource_cloning_dx12_only = true;
      // The captured swapchain has DXGI_USAGE_RENDER_TARGET_OUTPUT only.
      // Its proxy is the only clone, and the proxy pass binds it explicitly.
      // Native offscreen HDR views need no clone lookup on every SRV/UAV bind.
      renodx::mods::swapchain::swap_chain_proxy_shaders = {
          {reshade::api::device_api::d3d11,
           {.vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
            .pixel_shader = __swap_chain_proxy_pixel_shader_dx11}},
      };

      // NGX receives the engine's native textures, outside ReShade's cloned
      // bindings. Upgrade actual color textures so DLSS sees the written image.
      // Trial the same format/aspect-ratio matching used by the user's mods.
      // Aspect matching includes smaller scene targets with the same ratio.
       constexpr reshade::api::format scene_intermediate_formats[] = {
          reshade::api::format::r8g8b8a8_unorm,
          reshade::api::format::r8g8b8a8_typeless,
          reshade::api::format::r8g8b8a8_unorm_srgb,
          reshade::api::format::b8g8r8a8_unorm,
          reshade::api::format::r10g10b10a2_unorm,
          reshade::api::format::b10g10r10a2_unorm,
      };
      constexpr float scene_intermediate_aspect_ratios[] = {
          16.f / 9.f,
          16.f / 10.f,
          24.f / 10.f,
          43.f / 18.f,
          64.f / 27.f,
      };
      for (const auto old_format : scene_intermediate_formats) {
        for (const float aspect_ratio : scene_intermediate_aspect_ratios) {
          renodx::mods::swapchain::resource_upgrade_infos.push_back({
              .old_format = old_format,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .ignore_size = false,
              .aspect_ratio = aspect_ratio,
              .aspect_ratio_tolerance = 0.001f,
              .usage_include = reshade::api::resource_usage::render_target,
              .name = "Scene Intermediate",
          });
        }
      }

      // The DLSS output has UAV/SRV usage, without render_target. Retain its
      // captured native upgrade so NGX can write unclipped HDR to that texture.
      // The wrapper allocates it at the requested output size, which can be
      // one pixel short of the backbuffer (e.g. 3839x2159 for 3840x2160).
      // Match by backbuffer aspect ratio, not exact size: an unmatched RGBA8
      // output makes the engine's copy into the FP16 alias fail (black scene).
      constexpr auto color_copy_usage = reshade::api::resource_usage::copy_source
                                        | reshade::api::resource_usage::copy_dest
                                        | reshade::api::resource_usage::resolve_dest;
      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .usage = color_copy_usage | reshade::api::resource_usage::unordered_access | reshade::api::resource_usage::shader_resource,
          .aspect_ratio = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
          .aspect_ratio_tolerance = 0.01f,
          .name = "DLSS Output",
      });
      break;
    }
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  gearsofwarredux::dlss::Use(fdw_reason, lpv_reserved, &shader_injection.dlss_linear);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    active_shader_injection_mode = static_cast<int>(shader_injection_mode);
    renodx::mods::swapchain::SetUseHDR10(output_format >= 0.5f);
    reshade::log::message(reshade::log::level::info,
        std::format("Gears Redux HDR: layout 4, swapchain v{}, direct proxy, {} output, shader injection: {}, custom shaders: {}, offscreen upgrade rules: {}",
                    RENODX_MODS_SWAPCHAIN_VERSION,
                    output_format >= 0.5f ? "HDR10" : "scRGB",
                    active_shader_injection_mode == 1 ? "Direct DX11" : active_shader_injection_mode == 2 ? "Standard" : "Disabled",
                    active_shader_injection_mode == 0 ? 0u : custom_shaders.size(),
                    renodx::mods::swapchain::resource_upgrade_infos.size()).c_str());
  }
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  if (!custom_shaders.empty()) {
    if (active_shader_injection_mode == 1) {
      gearsofwarredux::shader::Use(fdw_reason, custom_shaders, &shader_injection);
    } else if (active_shader_injection_mode == 2) {
      renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
    }
  }
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(
        renodx::utils::resource::upgrade::OnBindRenderTargetsAndDepthStencil);
    reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
    reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::register_event<reshade::addon_event::present>(OnPresent);
  } else if (fdw_reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(
        renodx::utils::resource::upgrade::OnBindRenderTargetsAndDepthStencil);
    reshade::unregister_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
    reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::unregister_event<reshade::addon_event::present>(OnPresent);
  }
  return TRUE;
}
