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

#define TracedShaderEntry(value)                                    \
  {                                                                 \
    value,                                                          \
        {                                                           \
            .crc32 = value,                                         \
            .code = __##value,                                      \
            .on_drawn = [](auto cmd_list) {                         \
              if (drawn_shaders.contains(value)) return;            \
              drawn_shaders.emplace(value);                         \
              reshade::log::message(                                \
                  reshade::log::level::debug,                       \
                  std::format("Replaced 0x{:08x}", value).c_str()); \
            },                                                      \
        },                                                          \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    // Crisis Core FF7 Reunion
    TracedShaderEntry(0xAC791084),  // fmv

    // Kingdom Hearts 3
    TracedShaderEntry(0x00E9C5FE),
    TracedShaderEntry(0xE9343033),

    // SM5 LUT Builder
    TracedShaderEntry(0x1DF6036B),
    TracedShaderEntry(0x20EAC9B6),
    TracedShaderEntry(0x2569985B),
    TracedShaderEntry(0x3040FD90),
    TracedShaderEntry(0x31FE4421),
    TracedShaderEntry(0x36E3A438),
    TracedShaderEntry(0x5CAE0013),
    TracedShaderEntry(0x61C2EA30),
    TracedShaderEntry(0x6CA6068F),
    TracedShaderEntry(0x73B2BA54),
    TracedShaderEntry(0x7570E7B1),
    TracedShaderEntry(0x80CD76B6),
    TracedShaderEntry(0x876F0F03),
    TracedShaderEntry(0x8CD01256),
    TracedShaderEntry(0xA918F0C8),
    TracedShaderEntry(0xB1614732),
    TracedShaderEntry(0xB4F3140C),
    TracedShaderEntry(0xBEB7EB31),
    TracedShaderEntry(0xB972BF8F),
    TracedShaderEntry(0xC130BE2D),
    TracedShaderEntry(0xC1BCC6B5),
    TracedShaderEntry(0xC2A711CC),
    TracedShaderEntry(0xC32C8BEA),
    TracedShaderEntry(0xCA383248),
    TracedShaderEntry(0xCC8FD0FF),
    TracedShaderEntry(0xD2748E73),
    TracedShaderEntry(0xD4A45A02),
    TracedShaderEntry(0xE6EB2840),
    TracedShaderEntry(0xF6AA7756),
    TracedShaderEntry(0xFBB78F9F),

    // SM6 LUT Builder

    TracedShaderEntry(0x269E94C1),
    TracedShaderEntry(0x3028EBE7),
    TracedShaderEntry(0x33247499),
    TracedShaderEntry(0x4CC68F73),
    TracedShaderEntry(0x4F3FCE76),
    TracedShaderEntry(0x5D760393),
    TracedShaderEntry(0x6CFBD4C0),
    TracedShaderEntry(0x90BBE81C),
    TracedShaderEntry(0x94D26E3A),
    TracedShaderEntry(0xB530B36A),
    TracedShaderEntry(0xB6CA5FD9),
    TracedShaderEntry(0xBAA27141),
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .is_visible = []() {
          return settings[0]->GetValue() >= 1;
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
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
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrectionMethod",
        .binding = &shader_injection.toneMapHueCorrectionMethod,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Correction Method",
        .section = "Tone Mapping",
        .tooltip = "Applies hue shift emulation before tonemapping",
        .labels = {"AP1 Grade", "SDR Grade"},
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },

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
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 1; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
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
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
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
        .key = "ColorGradeColorSpace",
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
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("ColorGradeColorSpace", 0.f);
}

bool applied_dx12 = false;
void OnInitDevice(reshade::api::device* device) {
  if (applied_dx12) return;

  if (device->get_api() != reshade::api::device_api::d3d12) return;

  reshade::log::message(reshade::log::level::info, "Switching to DX12...");
  // Switch over to DX12
  renodx::mods::shader::expected_constant_buffer_space = 50;
  renodx::mods::swapchain::expected_constant_buffer_space = 50;

  renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
    return device->get_api() == reshade::api::device_api::d3d12;
  };

  renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx12;
  renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx12;
  // renodx::mods::shader::custom_shaders doesn't use the shader data, just hashes
  // Update on utils::shaders instead

  renodx::utils::shader::UpdateReplacements({
      // Kingdom Hearts 3
      {0x00E9C5FE, __lutbuilder_0x00E9C5FE_dx12},
      {0xE9343033, __lutbuilder_0xE9343033_dx12},
      // SM5 LUT Builder
      {0x1DF6036B, __lutbuilder_0x1DF6036B_dx12},
      {0x20EAC9B6, __lutbuilder_0x20EAC9B6_dx12},
      {0x2569985B, __lutbuilder_0x2569985B_dx12},
      {0x3040FD90, __lutbuilder_0x3040FD90_dx12},
      {0x31FE4421, __lutbuilder_0x31FE4421_dx12},
      {0x36E3A438, __lutbuilder_0x36E3A438_dx12},
      {0x5CAE0013, __lutbuilder_0x5CAE0013_dx12},
      {0x61C2EA30, __lutbuilder_0x61C2EA30_dx12},
      {0x6CA6068F, __lutbuilder_0x6CA6068F_dx12},
      {0x73B2BA54, __lutbuilder_0x73B2BA54_dx12},
      {0x7570E7B1, __lutbuilder_0x7570E7B1_dx12},
      {0x80CD76B6, __lutbuilder_0x80CD76B6_dx12},
      {0x876F0F03, __lutbuilder_0x876F0F03_dx12},
      {0x8CD01256, __lutbuilder_0x8CD01256_dx12},
      {0xA918F0C8, __lutbuilder_0xA918F0C8_dx12},
      {0xB1614732, __lutbuilder_0xB1614732_dx12},
      {0xB4F3140C, __lutbuilder_0xB4F3140C_dx12},
      {0xBEB7EB31, __lutbuilder_0xBEB7EB31_dx12},
      {0xB972BF8F, __lutbuilder_0xB972BF8F_dx12},
      {0xC130BE2D, __lutbuilder_0xC130BE2D_dx12},
      {0xC1BCC6B5, __lutbuilder_0xC1BCC6B5_dx12},
      {0xC2A711CC, __lutbuilder_0xC2A711CC_dx12},
      {0xC32C8BEA, __lutbuilder_0xC32C8BEA_dx12},
      {0xCA383248, __lutbuilder_0xCA383248_dx12},
      {0xCC8FD0FF, __lutbuilder_0xCC8FD0FF_dx12},
      {0xD2748E73, __lutbuilder_0xD2748E73_dx12},
      {0xD4A45A02, __lutbuilder_0xD4A45A02_dx12},
      {0xE6EB2840, __lutbuilder_0xE6EB2840_dx12},
      {0xF6AA7756, __lutbuilder_0xF6AA7756_dx12},
      {0xFBB78F9F, __lutbuilder_0xFBB78F9F_dx12},
  });

  reshade::log::message(reshade::log::level::info, "Added replacements.");

  applied_dx12 = true;
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

void AddUpgrade(reshade::api::format old_format, bool ignore_size = true) {
  renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
      .old_format = old_format,
      .new_format = reshade::api::format::r16g16b16a16_float,
      .ignore_size = ignore_size,
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

void AddGamePatches() {
  try {
    auto process_path = renodx::utils::platform::GetCurrentProcessPath();
    auto filename = process_path.filename().string();

    for (const auto& [key, format] : UPGRADE_TARGETS) {
      uint32_t value;

      if (!reshade::get_config_value(
              nullptr,
              renodx::utils::settings::global_name.c_str(),
              ("Upgrade_" + key).c_str(),
              value)) return;
      if (value > 0) {
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = format,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = (value == 3u),
            .aspect_ratio = static_cast<float>((value == 2u)
                                                   ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
                                                   : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
            .usage_include = reshade::api::resource_usage::render_target,
        });
        std::stringstream s;
        s << "Applying user resource upgrade for ";
        s << format << ": " << value;
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
    }

    reshade::log::message(reshade::log::level::info, std::format("Applied patches for {}.", filename).c_str());
  } catch (...) {
    reshade::log::message(reshade::log::level::error, "Could not read process path");
  }
}

float g_dump_shaders = 0;
std::unordered_set<uint32_t> g_dumped_shaders = {};

bool OnDrawForLUTDump(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  if (g_dump_shaders == 0) return false;

  auto shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  auto pixel_shader_hash = shader_state.GetCurrentPixelShaderHash();
  if (pixel_shader_hash == 0u) return false;

  auto& swapchain_state = cmd_list->get_private_data<renodx::utils::swapchain::CommandListData>();
  bool found_lut_render_target = false;

  auto* device = cmd_list->get_device();
  for (auto render_target : swapchain_state.current_render_targets) {
    auto resource_tag = renodx::utils::resource::GetResourceTag(device, render_target);
    if (resource_tag == 1.f) {
      found_lut_render_target = true;
      break;
    }
  }
  if (!found_lut_render_target) return false;

  if (custom_shaders.contains(pixel_shader_hash)) return false;

  if (g_dumped_shaders.contains(pixel_shader_hash)) return false;

  reshade::log::message(
      reshade::log::level::debug,
      std::format("Dumping lutbuiler: 0x{:08x}", pixel_shader_hash).c_str());

  g_dumped_shaders.emplace(pixel_shader_hash);

  renodx::utils::path::default_output_folder = "renodx";
  renodx::utils::shader::dump::default_dump_folder = ".";
  bool found = false;
  try {
    auto pair = shader_state.current_shader_pipelines.find(reshade::api::pipeline_stage::pixel_shader);
    if (pair == shader_state.current_shader_pipelines.end()) return false;

    auto pipeline = pair->second;
    auto details = renodx::utils::shader::GetPipelineShaderDetails(device, pipeline);
    for (const auto& [subobject_index, shader_hash] : details->shader_hashes_by_index) {
      // Store immediately in case pipeline destroyed before present
      if (shader_hash != pixel_shader_hash) continue;
      found = true;
      auto shader_data = details->GetShaderData(shader_hash, subobject_index);
      if (!shader_data.has_value()) {
        std::stringstream s;
        s << "utils::shader::dump(Failed to retreive shader data: ";
        s << PRINT_CRC32(shader_hash);
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        return false;
      }

      auto shader_version = renodx::utils::shader::compiler::directx::DecodeShaderVersion(shader_data.value());
      if (shader_version.GetMajor() == 0) {
        // No shader information found
        return false;
      }

      renodx::utils::shader::dump::DumpShader(
          shader_hash,
          shader_data.value(),
          reshade::api::pipeline_subobject_type::pixel_shader,
          "lutbuilder_");
    }
    if (!found) throw std::exception("Pipeline not found");
  } catch (...) {
    std::stringstream s;
    s << "utils::shader::dump(Failed to decode shader data: ";
    s << PRINT_CRC32(pixel_shader_hash);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

  return false;
}

void AddAdvancedSettings() {
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
    reshade::get_config_value(nullptr, renodx::utils::settings::global_name.c_str(), ("Upgrade_" + key).c_str(), new_setting->value_as_int);
    settings.push_back(new_setting);
  }

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
  reshade::get_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "Upgrade_SwapChainCompatibility", swapchain_setting->value_as_int);
  renodx::mods::swapchain::swapchain_proxy_compatibility_mode = swapchain_setting->GetValue() != 0;
  settings.push_back(swapchain_setting);

  auto* scrgb_setting = new renodx::utils::settings::Setting{
      .key = "Upgrade_UseSCRGB",
      .binding = &shader_injection.processingUseSCRGB,
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
  reshade::get_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "Upgrade_UseSCRGB", scrgb_setting->value_as_int);
  shader_injection.processingUseSCRGB = scrgb_setting->GetValue();
  renodx::mods::swapchain::SetUseHDR10(scrgb_setting->GetValue() == 0);
  settings.push_back(scrgb_setting);

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
  reshade::get_config_value(nullptr, renodx::utils::settings::global_name.c_str(), "DumpLUTShaders", lut_dump_setting->value_as_int);
  g_dump_shaders = lut_dump_setting->GetValue();
  settings.push_back(lut_dump_setting);

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
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);
      renodx::utils::resource::Use(fdw_reason);

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        // UE DX12 has a 4 param root sig that crashes if modified. Track for now
        return std::ranges::any_of(params, [](auto param) {
          return (param.type == reshade::api::pipeline_layout_param_type::descriptor_table);
        });
      };

      // while (IsDebuggerPresent() == 0) Sleep(100);

      if (!initialized) {
        AddGamePatches();

        AddAdvancedSettings();

        for (auto* new_setting : info_settings) {
          settings.push_back(new_setting);
        }

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
            .resource_tag = 1.f,
        });

        initialized = true;
      }

      reshade::register_event<reshade::addon_event::draw>(OnDrawForLUTDump);

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);
      renodx::utils::resource::Use(fdw_reason);
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
