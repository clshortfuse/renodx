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
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomSwapchainShader(0xAC791084),  // fmv

    // SM5 LUT Builder
    CustomShaderEntry(0x2569985B),
    CustomShaderEntry(0x31FE4421),
    CustomShaderEntry(0x36E3A438),
    CustomShaderEntry(0x5CAE0013),
    CustomShaderEntry(0x61C2EA30),
    CustomShaderEntry(0x73B2BA54),
    CustomShaderEntry(0x7570E7B1),
    CustomShaderEntry(0x80CD76B6),
    CustomShaderEntry(0xA918F0C8),
    CustomShaderEntry(0xB1614732),
    CustomShaderEntry(0xBEB7EB31),
    CustomShaderEntry(0xC130BE2D),
    CustomShaderEntry(0xC1BCC6B5),
    CustomShaderEntry(0xC2A711CC),
    CustomShaderEntry(0xCA383248),
    CustomShaderEntry(0xCC8FD0FF),
    CustomShaderEntry(0xD4A45A02),
    CustomShaderEntry(0xE6EB2840),
    CustomShaderEntry(0xF6AA7756),

    // SM6 LUT Builder

    CustomShaderEntry(0x269E94C1),
    CustomShaderEntry(0x3028EBE7),
    CustomShaderEntry(0x33247499),
    CustomShaderEntry(0x4CC68F73),
    CustomShaderEntry(0x4F3FCE76),
    CustomShaderEntry(0x5D760393),
    CustomShaderEntry(0x6CFBD4C0),
    CustomShaderEntry(0x90BBE81C),
    CustomShaderEntry(0x94D26E3A),
    CustomShaderEntry(0xB530B36A),
    CustomShaderEntry(0xB6CA5FD9),
    CustomShaderEntry(0xBAA27141),

};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
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
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.toneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Per Channel",
        .section = "Tone Mapping",
        .tooltip = "Applies tonemapping per-channel instead of by luminance",
        .labels = {"Off", "On"},
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 50.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return (value * 0.02f) - 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeColorSpace",
        .binding = &shader_injection.colorGradeColorSpace,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Color Space",
        .section = "Color Grading",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B09 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::Launch(
              "https://discord.gg/"
              // Anti-bot
              "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::Launch("https://ko-fi.com/shortfuse");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeColorSpace", 0.f);
}

bool applied_dx12 = false;
void OnInitDevice(reshade::api::device* device) {
  if (applied_dx12) return;
  if (device->get_api() != reshade::api::device_api::d3d12) return;
  // Switch over to DX12
  renodx::mods::shader::expected_constant_buffer_space = 50;
  renodx::mods::swapchain::expected_constant_buffer_space = 50;

  renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
    return device->get_api() == reshade::api::device_api::d3d12;
  };

  renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx12;
  renodx::mods::shader::custom_shaders[0x2569985B] = {.crc32 = 0x2569985B, .code = __lutbuilder_0x2569985B_dx12};
  renodx::mods::shader::custom_shaders[0x31FE4421] = {.crc32 = 0x31FE4421, .code = __lutbuilder_0x31FE4421_dx12};
  renodx::mods::shader::custom_shaders[0x36E3A438] = {.crc32 = 0x36E3A438, .code = __lutbuilder_0x36E3A438_dx12};
  renodx::mods::shader::custom_shaders[0x5CAE0013] = {.crc32 = 0x5CAE0013, .code = __lutbuilder_0x5CAE0013_dx12};
  renodx::mods::shader::custom_shaders[0x61C2EA30] = {.crc32 = 0x61C2EA30, .code = __lutbuilder_0x61C2EA30_dx12};
  renodx::mods::shader::custom_shaders[0x73B2BA54] = {.crc32 = 0x73B2BA54, .code = __lutbuilder_0x73B2BA54_dx12};
  renodx::mods::shader::custom_shaders[0x7570E7B1] = {.crc32 = 0x7570E7B1, .code = __lutbuilder_0x7570E7B1_dx12};
  renodx::mods::shader::custom_shaders[0x80CD76B6] = {.crc32 = 0x80CD76B6, .code = __lutbuilder_0x80CD76B6_dx12};
  renodx::mods::shader::custom_shaders[0xA918F0C8] = {.crc32 = 0xA918F0C8, .code = __lutbuilder_0xA918F0C8_dx12};
  renodx::mods::shader::custom_shaders[0xB1614732] = {.crc32 = 0xB1614732, .code = __lutbuilder_0xB1614732_dx12};
  renodx::mods::shader::custom_shaders[0xBEB7EB31] = {.crc32 = 0xBEB7EB31, .code = __lutbuilder_0xBEB7EB31_dx12};
  renodx::mods::shader::custom_shaders[0xC130BE2D] = {.crc32 = 0xC130BE2D, .code = __lutbuilder_0xC130BE2D_dx12};
  renodx::mods::shader::custom_shaders[0xC1BCC6B5] = {.crc32 = 0xC1BCC6B5, .code = __lutbuilder_0xC1BCC6B5_dx12};
  renodx::mods::shader::custom_shaders[0xC2A711CC] = {.crc32 = 0xC2A711CC, .code = __lutbuilder_0xC2A711CC_dx12};
  renodx::mods::shader::custom_shaders[0xCA383248] = {.crc32 = 0xCA383248, .code = __lutbuilder_0xCA383248_dx12};
  renodx::mods::shader::custom_shaders[0xCC8FD0FF] = {.crc32 = 0xCC8FD0FF, .code = __lutbuilder_0xCC8FD0FF_dx12};
  renodx::mods::shader::custom_shaders[0xD4A45A02] = {.crc32 = 0xD4A45A02, .code = __lutbuilder_0xD4A45A02_dx12};
  renodx::mods::shader::custom_shaders[0xE6EB2840] = {.crc32 = 0xE6EB2840, .code = __lutbuilder_0xE6EB2840_dx12};
  renodx::mods::shader::custom_shaders[0xF6AA7756] = {.crc32 = 0xF6AA7756, .code = __lutbuilder_0xF6AA7756_dx12};
  applied_dx12 = true;
}

bool fired_on_init_swapchain = false;
void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[1]->default_value = peak.value();
    settings[1]->can_reset = true;
  }
}

void AddUpgrade(reshade::api::format old_format) {
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = old_format,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .usage_include = reshade::api::resource_usage::render_target,
  });
}

void AddPsychonauts2Patches() {
  renodx::mods::swapchain::force_borderless = false;
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r10g10b10a2_unorm,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .ignore_size = true,
      .usage_include = reshade::api::resource_usage::render_target,
  });
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = reshade::api::format::r11g11b10_float,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .ignore_size = true,
      .usage_include = reshade::api::resource_usage::render_target,
  });
}

void AddHifiRushPatches() {
  // for (auto index : {1}) {
  //   renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
  //       .old_format = reshade::api::format::b8g8r8a8_typeless,
  //       .new_format = reshade::api::format::b8g8r8a8_typeless,
  //       .index = index,
  //       .view_upgrades = {},
  //       .usage_include = reshade::api::resource_usage::render_target,
  //   });
  // }
  // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
  //     .old_format = reshade::api::format::b8g8r8a8_typeless,
  //     .new_format = reshade::api::format::r16g16b16a16_typeless,
  //     .usage_include = reshade::api::resource_usage::render_target,
  // });
}

void AddGamePatches() {
  try {
    auto process_path = renodx::utils::platform::GetCurrentProcessPath();
    auto filename = process_path.filename().string();
    if (filename == "Psychonauts2-WinGDK-Shipping.exe") {
      AddPsychonauts2Patches();
    } else if (filename == "Hi-Fi-RUSH.exe") {
      AddHifiRushPatches();
    } else if (filename == "TheThaumaturge-Win64-Shipping.exe") {
      AddUpgrade(reshade::api::format::r10g10b10a2_unorm);
    } else if (filename == "SystemReShock-Win64-Shipping.exe") {
      AddUpgrade(reshade::api::format::b8g8r8a8_typeless);
    } else {
      return;
    }
    reshade::log::message(reshade::log::level::info, std::format("Applied patches for {}.", filename).c_str());
  } catch (...) {
    reshade::log::message(reshade::log::level::error, "Could not read process path");
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Unreal Engine (DirectX 11)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::allow_multiple_push_constants = true;

      renodx::mods::swapchain::expected_constant_buffer_index = 13;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .dimensions = {.width = 32, .height = 32, .depth = 32},
      });

      AddGamePatches();

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  return TRUE;
}
