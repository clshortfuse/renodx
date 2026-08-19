/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

float draw_ui = 1.f;

// Part of the check to see if grading exist
bool check(reshade::api::command_list* cmd_list) {
  shader_injection.grading_exist = 1.f;
  return true;
}

// Part if lutbuilder exists, set grading back to 0
bool lutbuilder(reshade::api::command_list* cmd_list) {
  shader_injection.grading_exist = 0.f;
  return true;
}

// on DRAW
#define CustomDirectXShadersCallbackOnDraw(__crc32__, __callback__)                   \
  {                                                                                   \
    __crc32__, {                                                                      \
      .crc32 = __crc32__,                                                             \
      .on_draw = __callback__,                                                        \
      .code_by_device = {                                                             \
          {reshade::api::device_api::d3d11, RENODX_JOIN_MACRO(__##__crc32__, _dx11)}, \
          {reshade::api::device_api::d3d12, RENODX_JOIN_MACRO(__##__crc32__, _dx12)}, \
      },                                                                              \
    }                                                                                 \
  }

// on DRAWN
#define CustomDirectXShadersCallbackOnDrawn(__crc32__, __callback__)                  \
  {                                                                                   \
    __crc32__, {                                                                      \
      .crc32 = __crc32__,                                                             \
      .on_drawn = __callback__,                                                       \
      .code_by_device = {                                                             \
          {reshade::api::device_api::d3d11, RENODX_JOIN_MACRO(__##__crc32__, _dx11)}, \
          {reshade::api::device_api::d3d12, RENODX_JOIN_MACRO(__##__crc32__, _dx12)}, \
      },                                                                              \
    }                                                                                 \
  }

renodx::mods::shader::CustomShaders custom_shaders = {

    // Hide UI Vertex Shaders

    {
        0x6DF08FD2,
        {
            .crc32 = 0x6DF08FD2,
            .on_draw = [](auto) {
              return draw_ui;
            },
        },
    },

    {
        0x927B8EE0,
        {
            .crc32 = 0x927B8EE0,
            .on_draw = [](auto) {
              return draw_ui;
            },
        },
    },

    {
        0x8BE61B4F,
        {
            .crc32 = 0x8BE61B4F,
            .on_draw = [](auto) {
              return draw_ui;
            },
        },
    },

    // Grading shaders
    CustomDirectXShadersCallbackOnDrawn(0x3CFCA6D5, &check),
    CustomDirectXShadersCallbackOnDrawn(0x4D541E80, &check),
    CustomDirectXShadersCallbackOnDrawn(0x84676A8E, &check),
    CustomDirectXShadersCallbackOnDrawn(0xD0AE0A40, &check),
    CustomDirectXShadersCallbackOnDrawn(0xD2F5778E, &check),
    CustomDirectXShadersCallbackOnDrawn(0xD019CA1A, &check),

    // Lutbuilders
    CustomDirectXShadersCallbackOnDrawn(0xC1BCC6B5, &lutbuilder),
    CustomDirectXShadersCallbackOnDrawn(0xE6EB2840, &lutbuilder),

    __ALL_CUSTOM_SHADERS,
};

float current_settings_mode = 0;

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

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
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeStrength",
    //     .binding = &shader_injection.color_grade_strength,
    //     .default_value = 100.f,
    //     .label = "Strength",
    //     .section = "Scene Grading",
    //     .tooltip = "Scene grading as applied by the game",
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
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
        // .is_visible = []() { return current_settings_mode >= 2; },
        .is_visible = []() { return false; },

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
        // .is_visible = []() { return current_settings_mode >= 2; },
        .is_visible = []() { return false; },
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
        // .is_visible = []() { return current_settings_mode >= 2; },
        .is_visible = []() { return false; },
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
        // .is_visible = []() { return current_settings_mode >= 2; },
        .is_visible = []() { return false; },
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
        .is_enabled = []() { return shader_injection.tone_map_type == 3 || shader_injection.tone_map_type == 6; },
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

    new renodx::utils::settings::Setting{
        .key = "Fx_Bloom",
        .binding = &shader_injection.fx_bloom,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Custom Bloom",
        .section = "Effects",
        .tooltip = "Doesn't apply bloom on shadows",
        .labels = {"Off", "On"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "Fx_GrainType",
        .binding = &shader_injection.fx_custom_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Grain Type",
        .section = "Effects",
        .labels = {"Vanilla", "Perceptual"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "Fx_GrainStrength",
        .binding = &shader_injection.fx_custom_grain_strength,
        .default_value = 25.f,
        .label = "Grain Strength",
        .section = "Effects",
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "Lut_Scaling",
        .binding = &shader_injection.lut_scaling,
        .default_value = 25.f,
        .label = "Lut Scaling",
        .section = "Effects",
        .tooltip = "Scales the color grade LUT to full range",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "Draw_UI",
        .binding = &draw_ui,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Draw UI",
        .section = "Effects",
        .tooltip = "Allows hiding the UI, useful for screenshots.",
        .labels = {"Off", "On"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    new renodx::utils::settings::Setting{
        .key = "Debug_YUV",
        .binding = &shader_injection.debug_yuv,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Debug YUV",
        .section = "Effects",
        .tooltip = "Allows hiding the UI, useful for screenshots.",
        .labels = {"Vanilla BT601 Limited", "Bt709 Full", "BT709 from YCbCrLimited", "BT601 Limited Reno"},
        //.is_visible = []() { return current_settings_mode >= 1; },
        .is_visible = []() { return false; },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Please make sure the game's brightness is set to default! \r\n \r\n - Join the RenoDX discord for help!",
        .section = "Instructions",
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          static const std::string obfuscated_link = std::string("start https://discord.gg/F6AU") + std::string("TeWJHM");
          system(obfuscated_link.c_str());
        },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Get more RenoDX mods!",
        .section = "About",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          system("start https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },

};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeColorSpace", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapHueShiftMethod", 4.f);
  renodx::utils::settings::UpdateSetting("Fx_Bloom", 0.f);
  renodx::utils::settings::UpdateSetting("Fx_GrainType", 0.f);
  renodx::utils::settings::UpdateSetting("Lut_Scaling", 0.f);
  renodx::utils::settings::UpdateSetting("Draw_UI", 1.f);
}

// bool fired_on_init_swapchain = false;

// void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
//   if (fired_on_init_swapchain) return;
//   fired_on_init_swapchain = true;
//   auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
//   if (peak.has_value()) {
//     settings[1]->default_value = peak.value();
//     settings[1]->can_reset = true;
//   }
// }

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Shin Megami Tensei V: Vengeance";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        return (params.size() < 20);
      };

      // renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
      //   return device->get_api() == reshade::api::device_api::d3d12;  // So overlays dont kill the game
      // };

      renodx::mods::swapchain::SetUseHDR10(true);
      renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;

      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;

      renodx::mods::shader::force_pipeline_cloning = true;   // So the mod works with the toolkit
      renodx::mods::swapchain::force_borderless = false;     // needed for stability
      renodx::mods::swapchain::prevent_full_screen = false;  // needed for stability

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;
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

      // BGRA8 TYPELESS ASPECT RATIO
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          .usage_include = reshade::api::resource_usage::render_target,
      });

      // // FP11 ASPECT RATIO
      // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //     .old_format = reshade::api::format::r11g11b10_float,
      //     .new_format = reshade::api::format::r16g16b16a16_float,
      //     .use_resource_view_cloning = true,
      //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      //     .usage_include = reshade::api::resource_usage::render_target,
      // });

      // // BGRA8 UNORM ASPECT RATIO
      // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //     .old_format = reshade::api::format::b8g8r8a8_unorm,
      //     .new_format = reshade::api::format::r16g16b16a16_float,
      //     .use_resource_view_cloning = true,
      //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      //     //.usage_include = reshade::api::resource_usage::render_target,
      // });

      // // RGB10A2 UNORM ASPECT RATIO
      // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      //     .old_format = reshade::api::format::r10g10b10a2_unorm,
      //     .new_format = reshade::api::format::r16g16b16a16_float,
      //     .use_resource_view_cloning = true,
      //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
      //     .usage_include = reshade::api::resource_usage::render_target,
      // });

      // 32x32x32 lutbuilder
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .use_resource_view_cloning = true,
          .dimensions = {.width = 32, .height = 32, .depth = 32},
          .resource_tag = 1.f,
      });

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}