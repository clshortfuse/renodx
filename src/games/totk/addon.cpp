/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID                   ImU64
#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = renodx::templates::settings::JoinSettings({
    renodx::templates::settings::CreateDefaultSettings({
        {"ToneMapType", &shader_injection.tone_map_type},
        {"ToneMapPeakNits", &shader_injection.peak_white_nits},
        {"ToneMapGameNits", &shader_injection.diffuse_white_nits},
        {"ToneMapUINits", &shader_injection.graphics_white_nits},
        {"ToneMapGammaCorrection", &shader_injection.gamma_correction},
    }),
    {
        new renodx::utils::settings::Setting{
            .key = "tonemap_clamp_color_space",
            .binding = &shader_injection.custom_tonemap_clamp,
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 0.f,
            .can_reset = true,
            .label = "Clamp Tonemap Grading",
            .section = "Tone Mapping",
            .tooltip = "Clamps the tonemap colour grading. Use BT.709 for a vanilla result.",
            .labels = {"BT.709", "BT.2020"},
            .parse = [](float value) { return value; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
        new renodx::utils::settings::Setting{
            .key = "SDRBlendFactor",
            .binding = &shader_injection.tone_map_sdr_blend_factor,
            .default_value = 18.f,
            .label = "SDR Blend Factor",
            .section = "Tone Mapping",
            .tooltip = "Blends SDR to look more faithful to the art style",
            .min = 0.f,
            .max = 60.f,
            .is_enabled = []() { return shader_injection.tone_map_type > 0.f; },
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
        new renodx::utils::settings::Setting{
            .key = "ColorGradeScene",
            .binding = &shader_injection.scene_grade_strength,
            .default_value = 70.f,
            .label = "Hue Shift",
            .section = "Tone Mapping",
            .tooltip = "Emulates SDR hue shifts to match vanilla",
            .max = 100.f,
            .is_enabled = []() { return shader_injection.tone_map_type > 0.f; },
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
        new renodx::utils::settings::Setting{
            .key = "ColorGradeBlowout",
            .binding = &shader_injection.tone_map_blowout,
            .default_value = 65.f,
            .label = "SDR Blowout",
            .section = "Tone Mapping",
            .tooltip = "Emulates SDR blowout to match vanilla",
            .max = 100.f,
            .is_enabled = []() { return shader_injection.tone_map_type > 0.f; },
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },
    },
    renodx::templates::settings::CreateDefaultSettings({
        {"ColorGradeExposure", &shader_injection.tone_map_exposure},
        {"ColorGradeHighlights", &shader_injection.tone_map_highlights},
        {"ColorGradeShadows", &shader_injection.tone_map_shadows},
        {"ColorGradeContrast", &shader_injection.tone_map_contrast},
        {"ColorGradeSaturation", &shader_injection.tone_map_saturation},
        {"ColorGradeHighlightSaturation", &shader_injection.tone_map_highlight_saturation},
        {"ColorGradeFlare", &shader_injection.tone_map_flare},
    }),
    {

        new renodx::utils::settings::Setting{
            .key = "VanillaSaturation",
            .binding = &shader_injection.vanilla_saturation,
            .default_value = 100.f,
            .label = "Vanilla Saturation",
            .section = "Color Grading",
            .tooltip = "Controls intensity of saturation applied by the game",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
            .is_visible = []() { return renodx::templates::settings::current_settings_mode > 1.f; },
        },

        new renodx::utils::settings::Setting{
            .key = "FxHueClip",
            .binding = &shader_injection.custom_bloom,
            .default_value = 100.f,
            .label = "Bloom",
            .section = "Effects",
            .tooltip = "Controls vanilla bloom strength",
            .max = 100.f,
            .parse = [](float value) { return value * 0.01f; },
        },
        // new renodx::utils::settings::Setting{
        //     .key = "FxBloom",
        //     .binding = &shader_injection.custom_bloom,
        //     .default_value = 25.f,
        //     .label = "Bloom Strength",
        //     .section = "Color Grading",
        //     .max = 100.f,
        //     .parse = [](float value) { return value * 0.01f; },
        //     .is_visible = []() { return settings[0]->GetValue() >= 2.f; },
        // },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "RenoDX Discord",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0x5865F2,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/kSTf", "EbcCpC"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den Discord",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0x5865F2,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/XUhv", "tR54yc"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Github",
            .section = "Links",
            .group = "button-line-1",
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "Ritsu's Ko-Fi",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/ritsucecil"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "ShortFuse's Ko-Fi",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::BUTTON,
            .label = "HDR Den's Ko-Fi",
            .section = "Links",
            .group = "button-line-1",
            .tint = 0xFF5F5F,
            .parse = [](float value) { return value; },
            .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/hdrden"); },
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Game mod by souperman9, tonemapper updated by Musa, RenoDX Framework by ShortFuse, RenoVK fork by Ritsu. \nSpecial thanks to Izueh, Marat, and miru97",
            .section = "About",
        },
        new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
            .section = "About",
        },
    },
});

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  // Reset frame state
}

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
      {"ColorGradeScene", 100.f},
      {"FxHueClip", 100.f},
      {"FxSaturationClip", 0.f},
  });
}

constexpr uint32_t kLateFinalShaderCrc = 0xEF015FAB;
constexpr uint32_t kLateFinalMinimumWidth = 1600;
constexpr uint32_t kLateFinalMinimumHeight = 900;
constexpr reshade::api::format kLateFinalResourceFormat = reshade::api::format::r8g8b8a8_typeless;
constexpr reshade::api::format kLateFinalViewFormat = reshade::api::format::r8g8b8a8_unorm_srgb;

renodx::utils::resource::ResourceUpgradeInfo late_final_clone_info = []() {
    renodx::utils::resource::ResourceUpgradeInfo info = {};
    info.new_format = reshade::api::format::r16g16b16a16_float;
    info.use_resource_view_cloning = true;
    info.use_resource_view_hot_swap = true;
    info.usage_set = static_cast<uint32_t>(
            reshade::api::resource_usage::shader_resource
            | reshade::api::resource_usage::render_target);
    return info;
}();

bool SkipLateFinalShaderReplacement(reshade::api::command_list*) {
    return false;
}

bool IsLateFinalRenderTarget(const renodx::utils::resource::ResourceViewInfo* resource_view_info) {
    if (resource_view_info == nullptr || resource_view_info->resource_info == nullptr) return false;

    const auto& desc = resource_view_info->resource_info->desc;
    if (desc.type != reshade::api::resource_type::texture_2d
            && desc.type != reshade::api::resource_type::surface) {
        return false;
    }

    return desc.texture.width >= kLateFinalMinimumWidth
            && desc.texture.height >= kLateFinalMinimumHeight
            && desc.texture.format == kLateFinalResourceFormat
            && resource_view_info->desc.format == kLateFinalViewFormat;
}

bool UpgradeLateFinalRenderTarget(
        reshade::api::command_list* cmd_list,
        reshade::api::resource_view render_target) {
    auto* resource_view_info = renodx::utils::resource::GetResourceViewInfo(render_target);
    if (!IsLateFinalRenderTarget(resource_view_info)) return false;

    resource_view_info->resource_info->clone_target = &late_final_clone_info;
    return renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), render_target);
}

bool RewriteLateFinalRenderTargets(
        reshade::api::command_list* cmd_list,
        const std::vector<reshade::api::resource_view>& render_targets) {
    if (render_targets.empty() || render_targets[0].handle == 0u) return false;
    if (!UpgradeLateFinalRenderTarget(cmd_list, render_targets[0])) return false;

    renodx::mods::swapchain::FlushDescriptors(cmd_list);
    renodx::mods::swapchain::RewriteRenderTargets(
            cmd_list,
            static_cast<uint32_t>(render_targets.size()),
            render_targets.data(),
            renodx::utils::swapchain::GetDepthStencil(cmd_list));
    return true;
}

bool OnLateFinalDraw(reshade::api::command_list* cmd_list) {
    auto& render_targets = renodx::utils::swapchain::GetRenderTargets(cmd_list);
    RewriteLateFinalRenderTargets(cmd_list, render_targets);
    return true;
}

void RegisterLateFinalShader() {
    auto& shader = custom_shaders[kLateFinalShaderCrc];
    shader.crc32 = kLateFinalShaderCrc;
    shader.on_replace = &SkipLateFinalShaderReplacement;
    shader.on_draw = &OnLateFinalDraw;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Breath of the Wild";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::swapchain::use_resource_cloning = true;

      // Always set to true for Vulkan
      renodx::mods::shader::allow_multiple_push_constants = true;

      /*
        If expand_existing_constant_buffer is set to false renoDX will add new cbuffer range (instead of reusing the game's).
        This behaviour is overridden if renoDX finds a cbuffer that targets all shader_stages in minimum_constant_buffer_stages.
        e.g. If a game's cbuffer range targets all stages, renoDX will expand it regardless of expand_existing_constant_buffer value.
        Remove the stages you're not injecting to.
      */
      renodx::mods::shader::minimum_constant_buffer_stages = reshade::api::shader_stage::pixel;

    RegisterLateFinalShader();

      // Register event handlers
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    }
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

    renodx::mods::swapchain::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
