/*
 * Copyright (C) 2026 RenoDX contributors
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID                   ImU64
#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <vector>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection = {};
float current_settings_mode = 0.f;

bool OnToneMapDraw(reshade::api::command_list* cmd_list) {
  auto render_targets = renodx::utils::swapchain::GetRenderTargets(cmd_list);
  bool changed = false;

  for (const auto render_target : render_targets) {
    changed = renodx::mods::swapchain::ActivateCloneHotSwap(
                  cmd_list->get_device(), render_target)
              || changed;
  }

  if (changed) {
    renodx::mods::swapchain::FlushDescriptors(cmd_list);
    renodx::mods::swapchain::RewriteRenderTargets(
        cmd_list,
        static_cast<uint32_t>(render_targets.size()),
        render_targets.data(),
        {0u});
  }
  return true;
}

// Dishonored 2 repeatedly requests exclusive fullscreen when its window gains
// focus. Match Dishonored2GraphicalUpgrade's modern-windowed behavior without
// invoking RenoDX's fake-fullscreen window resize path.
bool OnCreateSwapchainModernWindowed(
    reshade::api::device_api,
    reshade::api::swapchain_desc& desc,
    void*) {
  desc.back_buffer.texture.format = reshade::api::format::r10g10b10a2_unorm;
  if (desc.back_buffer_count < 2u) desc.back_buffer_count = 2u;
  desc.present_mode = DXGI_SWAP_EFFECT_FLIP_DISCARD;
  desc.fullscreen_state = false;
  desc.present_flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;
  desc.fullscreen_refresh_rate = 0.f;
  desc.sync_interval = 0u;
  return true;
}

bool OnSetFullscreenStateModernWindowed(
    reshade::api::swapchain*,
    bool fullscreen,
    void*) {
  return fullscreen;
}

#define Dishonored2ToneMapShader(hash)                                   \
  {                                                                      \
    hash, { .crc32 = hash, .code = __##hash, .on_draw = &OnToneMapDraw } \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    Dishonored2ToneMapShader(0xA6F33860),  // Main tonemap with 3D color cube.
    Dishonored2ToneMapShader(0x11E16EF3),  // Black-and-white tonemap variant.
    CustomShaderEntry(0x1A0CD2AE),         // Final upscale/copy before Iggy UI.
};

#undef Dishonored2ToneMapShader

renodx::utils::settings::Setting* peak_nits_setting = nullptr;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Selects the HDR tone mapper.",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
    },
    peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the peak display brightness in nits.",
        .min = 200.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets diffuse white brightness in nits.",
        .min = 80.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets UI and HUD white brightness independently from the scene.",
        .min = 80.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping",
        .tooltip = "Matches the SDR look before expanding highlights.",
        .labels = {"Off", "Gamma 2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "OverrideBlackClip",
        .binding = &shader_injection.override_black_clip,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Override Black Clip / Fix Raised Blacks",
        .section = "Tone Mapping",
        .tooltip = "Reanchors Dishonored 2's tone-curve and 3D LUT black point to true "
                   "black and disables RenoDRT flare. Disable if an intentionally faded "
                   "scene looks too dark.",
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "BloomIntensity",
        .binding = &shader_injection.bloom_intensity,
        .default_value = 100.f,
        .label = "Bloom Intensity",
        .section = "Graphical Upgrade",
        .tooltip = "Adjusts bloom before HDR tone mapping.",
        .max = 200.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "LensDirtAmount",
        .binding = &shader_injection.lens_dirt_amount,
        .default_value = 0.f,
        .label = "Lens Dirt",
        .section = "Graphical Upgrade",
        .tooltip = "Controls the game's lens-dirt texture without changing bloom.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "Sharpening",
        .binding = &shader_injection.sharpening,
        .default_value = 0.f,
        .label = "HDR-safe Sharpening",
        .section = "Graphical Upgrade",
        .tooltip = "Applies local contrast sharpening without clipping HDR highlights.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FilmGrain",
        .binding = &shader_injection.film_grain,
        .default_value = 30.f,
        .label = "Film Grain",
        .section = "Graphical Upgrade",
        .tooltip = "Adds luminance-preserving monochrome film grain in linear HDR.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Controls the strength of the game's 3D color cube.",
        .max = 100.f,
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
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
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
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
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
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Highlight Desaturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Adds a soft shadow toe. Ignored while Override Black Clip is enabled.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.override_black_clip == 0.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Tone Map Scaling",
        .section = "Tone Mapping",
        .labels = {"Luminance", "Per Channel"},
        .is_visible = []() { return current_settings_mode >= 1.f; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("GammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("OverrideBlackClip", 0.f);
  renodx::utils::settings::UpdateSetting("BloomIntensity", 100.f);
  renodx::utils::settings::UpdateSetting("LensDirtAmount", 100.f);
  renodx::utils::settings::UpdateSetting("Sharpening", 0.f);
  renodx::utils::settings::UpdateSetting("FilmGrain", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeScene", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlightSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeFlare", 0.f);
}

bool initialized_peak_nits = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  // The generic swapchain handler marks recreated back buffers for cloning,
  // but their RTVs may already exist. Propagate that state to existing views
  // so the first post-resize bind creates the FP16 clone at draw time, after
  // VoidEngine's burst of ResizeBuffers calls has finished.
  const auto back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    const auto buffer = swapchain->get_back_buffer(index);
    std::vector<uint64_t> view_handles;
    renodx::utils::resource::ResourceUpgradeInfo* clone_target = nullptr;

    renodx::utils::resource::GetResourceInfo(
        buffer,
        [&](const renodx::utils::resource::ResourceInfo& info) {
          if (!info.clone_enabled || info.clone_target == nullptr) return;
          view_handles.assign(
              info.resource_view_handles.begin(), info.resource_view_handles.end());
          clone_target = info.clone_target;
        });

    if (clone_target != nullptr && !view_handles.empty()) {
      renodx::utils::resource::upgrade::UpdateResourceViewsCloneState(
          view_handles, true, false, clone_target);
    }
  }

  if (initialized_peak_nits) return;
  initialized_peak_nits = true;

  const auto detected_peak_nits = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (detected_peak_nits.has_value()) {
    peak_nits_setting->default_value = roundf(detected_peak_nits.value());
    peak_nits_setting->can_reset = true;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX for Dishonored 2";
extern "C" __declspec(dllexport) const uint32_t
    DISHONORED2_GRAPHICAL_UPGRADE_COMPATIBILITY_ABI = 1u;

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::expected_constant_buffer_space = 50;

      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::prevent_full_screen = false;
      renodx::mods::swapchain::force_screen_tearing = false;
      renodx::mods::swapchain::set_color_space = true;
      renodx::mods::swapchain::SetUseHDR10();
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader =
          __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader =
          __swap_chain_proxy_pixel_shader;

      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
          .aspect_ratio = renodx::mods::swapchain::ResourceUpgradeInfo::BACK_BUFFER,
          .aspect_ratio_tolerance = 0.01f,
          .usage_include = reshade::api::resource_usage::render_target,
          .name = "Dishonored 2 post-tonemap intermediate",
      });

      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::create_swapchain>(
          OnCreateSwapchainModernWindowed);
      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(
          OnSetFullscreenStateModernWindowed);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      break;
  }

  renodx::utils::random::Use(
      fdw_reason, {&shader_injection.swap_chain_output_dither_seed});
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    // Register after swapchain::Use so the game-specific policy is applied
    // after generic swapchain changes and clone targets exist before init.
    reshade::register_event<reshade::addon_event::create_swapchain>(
        OnCreateSwapchainModernWindowed);
    reshade::register_event<reshade::addon_event::set_fullscreen_state>(
        OnSetFullscreenStateModernWindowed);
    reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
  }
  if (fdw_reason == DLL_PROCESS_DETACH) {
    // The modules unregister ReShade events in Use(), so the add-on must remain
    // registered until all module teardown has completed.
    reshade::unregister_addon(h_module);
  }
  return TRUE;
}
