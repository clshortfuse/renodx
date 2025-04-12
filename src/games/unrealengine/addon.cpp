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

#define TracedShaderEntry(value)                                  \
  {                                                               \
      value,                                                      \
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

#define TracedDualShaderEntry(value)                                                  \
  {                                                                                   \
      value,                                                                          \
      {                                                                               \
          .crc32 = value,                                                             \
          .on_drawn = [](auto cmd_list) {                                             \
            if (drawn_shaders.contains(value)) return;                                \
            drawn_shaders.emplace(value);                                             \
            reshade::log::message(                                                    \
                reshade::log::level::debug,                                           \
                std::format("Replaced 0x{:08x}", value).c_str());                     \
          },                                                                          \
          .code_by_device = {                                                         \
              {reshade::api::device_api::d3d11, RENODX_JOIN_MACRO(__##value, _dx11)}, \
              {reshade::api::device_api::d3d12, RENODX_JOIN_MACRO(__##value, _dx12)}, \
          },                                                                          \
      },                                                                              \
  }

renodx::mods::shader::CustomShaders custom_shaders = {
    // Crisis Core FF7 Reunion
    TracedShaderEntry(0xAC791084),  // fmv

    // Kingdom Hearts 3
    TracedDualShaderEntry(0x00E9C5FE),
    TracedDualShaderEntry(0xE9343033),

    // Persona 3 Reload
    TracedShaderEntry(0xCB9976C8),
    TracedShaderEntry(0xBFE48347),

    // Wuthering Waves
    TracedDualShaderEntry(0x271E2688),
    TracedDualShaderEntry(0x11ACA4BD),
    TracedDualShaderEntry(0x9081A2D8),
    TracedDualShaderEntry(0xE6B4B2E3),

    // GTA: San Andreas
    TracedDualShaderEntry(0xB864B3B8),

    // SM5 LUT Builder
    TracedDualShaderEntry(0x1BA80C5E),
    TracedDualShaderEntry(0x1DF6036B),
    TracedDualShaderEntry(0x20EAC9B6),
    TracedDualShaderEntry(0x2A94C68A),
    TracedDualShaderEntry(0x2569985B),
    TracedDualShaderEntry(0x3040FD90),
    TracedDualShaderEntry(0x31FE4421),
    TracedDualShaderEntry(0x36E3A438),
    TracedDualShaderEntry(0x4E6F963D),
    TracedDualShaderEntry(0x5CAE0013),
    TracedDualShaderEntry(0x61C2EA30),
    TracedDualShaderEntry(0x6CA6068F),
    TracedDualShaderEntry(0x73B2BA54),
    TracedDualShaderEntry(0x7570E7B1),
    TracedDualShaderEntry(0x80CD76B6),
    TracedDualShaderEntry(0x876F0F03),
    TracedDualShaderEntry(0x8CD01256),
    TracedDualShaderEntry(0xA918F0C8),
    TracedDualShaderEntry(0xB1614732),
    TracedDualShaderEntry(0xB4F3140C),
    TracedDualShaderEntry(0xBEB7EB31),
    TracedDualShaderEntry(0xB972BF8F),
    TracedDualShaderEntry(0xC130BE2D),
    TracedDualShaderEntry(0xC1BCC6B5),
    TracedDualShaderEntry(0xC2A711CC),
    TracedDualShaderEntry(0xC32C8BEA),
    TracedDualShaderEntry(0xCA383248),
    TracedDualShaderEntry(0xCC8FD0FF),
    TracedDualShaderEntry(0xD2748E73),
    TracedDualShaderEntry(0xD4A45A02),
    TracedDualShaderEntry(0xE6EB2840),
    TracedDualShaderEntry(0xF6AA7756),
    TracedDualShaderEntry(0xFBB78F9F),
    TracedDualShaderEntry(0x6E6FC244),
    TracedDualShaderEntry(0x8D3D2FA0),
    TracedDualShaderEntry(0x97BAC8AF),
    TracedDualShaderEntry(0x2F460105),
    TracedDualShaderEntry(0x5BD6A5C2),
    TracedDualShaderEntry(0x85DEEF21),
    TracedDualShaderEntry(0xF5AC79AB),
    TracedDualShaderEntry(0x40A581ED),
    TracedDualShaderEntry(0x18639D8F),
    TracedDualShaderEntry(0x95A3F50E),
    TracedDualShaderEntry(0x6757E671),
    TracedDualShaderEntry(0x0F17B0B3),
    TracedDualShaderEntry(0xE349C52A),

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
    TracedShaderEntry(0xEBB3E98C),
    TracedShaderEntry(0x50F22BD6),
    TracedShaderEntry(0x8119F75A),
    TracedShaderEntry(0xE3BB0C03),
    TracedShaderEntry(0x95B1E481),
    TracedShaderEntry(0x49D6D8F2),
    TracedShaderEntry(0x06F39D1E),
    TracedShaderEntry(0xDA10C03E),

    TracedShaderEntry(0x9DF2DDD4),
    TracedShaderEntry(0xBBB5CA7B),
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
        .parse = [](float value) { return value * 3.f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
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
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.toneMapHueShift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 100.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
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
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
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
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
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
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.colorGradeHighlightSaturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Adds highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return (value * 0.01f); },
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
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeStrength",
        .binding = &shader_injection.colorGradeStrength,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 100.f,
        .label = "Grading Strength",
        .section = "Color Grading",
        .tooltip = "Chooses strength of original color grading.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
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
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() { renodx::utils::settings::ResetSettings(); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "SDR Grading Bypass",
        .section = "Options",
        .group = "button-line-1",
        .tooltip = "Improves highlight appearance in games with little to no SDR grading",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ColorGradeContrast", 80.f},
              {"ColorGradeSaturation", 80.f},
              {"ColorGradeBlowout", 80.f},
              {"ColorGradeStrength", 0.f},
          });
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-2",
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
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::Launch("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
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

void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d11) {
    renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
    renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx11;
    return;
  }

  if (device->get_api() == reshade::api::device_api::d3d12) {
    reshade::log::message(reshade::log::level::info, "Switching to DX12...");
    // Switch over to DX12

    renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx12;
    renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx12;
    // renodx::mods::shader::custom_shaders doesn't use the shader data, just hashes
    // Update on utils::shaders instead

    reshade::log::message(reshade::log::level::info, "Added replacements.");
  }
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
    fired_on_init_swapchain = true;
  }
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

const std::unordered_map<
    std::string,                             // Filename or ProductName
    std::unordered_map<std::string, float>>  // {Key, Value}
    GAME_DEFAULT_SETTINGS = {
        {
            "Psychonauts2-WinGDK-Shipping.exe",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"ForceBorderless", 0.f},
            },
        },
        {
            "CRISIS CORE -FINAL FANTASY VII- REUNION",
            {
                {"Upgrade_B8G8R8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Wuthering Waves",
            {
                {"Upgrade_R10G10B10A2_UNORM", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
};

float g_dump_shaders = 0;
std::unordered_set<uint32_t> g_dumped_shaders = {};

bool OnDrawForLUTDump(
    reshade::api::command_list* cmd_list,
    uint32_t vertex_count,
    uint32_t instance_count,
    uint32_t first_vertex,
    uint32_t first_instance) {
  if (g_dump_shaders == 0) return false;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);

  auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);

  auto pixel_shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
  if (pixel_shader_hash == 0u) return false;

  auto* swapchain_state = renodx::utils::swapchain::GetCurrentState(cmd_list);
  bool found_lut_render_target = false;

  auto* device = cmd_list->get_device();
  for (auto render_target : swapchain_state->current_render_targets) {
    auto resource_tag = renodx::utils::resource::GetResourceTag(render_target);
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
    auto shader_data = renodx::utils::shader::GetShaderData(pixel_state);
    if (!shader_data.has_value()) {
      std::stringstream s;
      s << "utils::shader::dump(Failed to retreive shader data: ";
      s << PRINT_CRC32(pixel_shader_hash);
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
        pixel_shader_hash,
        shader_data.value(),
        reshade::api::pipeline_subobject_type::pixel_shader,
        "lutbuilder_");

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
  auto process_path = renodx::utils::platform::GetCurrentProcessPath();
  auto filename = process_path.filename().string();
  auto default_settings = GAME_DEFAULT_SETTINGS.find(filename);

  {
    std::stringstream s;
    if (default_settings == GAME_DEFAULT_SETTINGS.end()) {
      auto product_name = renodx::utils::platform::GetProductName(process_path);

      default_settings = GAME_DEFAULT_SETTINGS.find(product_name);

      if (default_settings == GAME_DEFAULT_SETTINGS.end()) {
        s << "No default settings for ";
      } else {
        s << "Marked default values for ";
      }
      s << filename;
      s << " (" << product_name << ")";
    } else {
      s << "Marked default values for ";
      s << filename;
    }
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  auto add_setting = [&](auto* setting) {
    if (default_settings != GAME_DEFAULT_SETTINGS.end()) {
      auto values = default_settings->second;
      if (auto values_pair = values.find(setting->key);
          values_pair != values.end()) {
        setting->default_value = static_cast<float>(values_pair->second);
        std::stringstream s;
        s << "Default value for ";
        s << setting->key;
        s << ": ";
        s << setting->default_value;
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
    }
    renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
    settings.push_back(setting);
  };

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
    add_setting(new_setting);

    auto value = new_setting->GetValue();
    if (value > 0) {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = format,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = (value == UPGRADE_TYPE_ANY),
          .use_resource_view_cloning = true,
          .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
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

  {
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
    add_setting(swapchain_setting);
    renodx::mods::swapchain::swapchain_proxy_compatibility_mode = swapchain_setting->GetValue() != 0;
  }

  {
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
    add_setting(scrgb_setting);

    shader_injection.processingUseSCRGB = scrgb_setting->GetValue();
    renodx::mods::swapchain::SetUseHDR10(scrgb_setting->GetValue() == 0);
  }

  {
    auto* force_borderless_setting = new renodx::utils::settings::Setting{
        .key = "ForceBorderless",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Force Borderless",
        .section = "Resource Upgrades",
        .tooltip = "Forces fullscreen to be borderless for proper HDR",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };

    add_setting(force_borderless_setting);

    if (force_borderless_setting->GetValue() == 0) {
      renodx::mods::swapchain::force_borderless = false;
    }
  }

  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "PreventFullscreen",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Prevent Fullscreen",
        .section = "Resource Upgrades",
        .tooltip = "Prevent exclusive fullscreen for proper HDR",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };

    renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
    add_setting(setting);
  }

  {
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
    add_setting(lut_dump_setting);

    g_dump_shaders = lut_dump_setting->GetValue();
  }

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

      renodx::mods::shader::on_create_pipeline_layout = [](auto, auto params) {
        auto process_path = renodx::utils::platform::GetCurrentProcessPath();
        auto product_name = renodx::utils::platform::GetProductName(process_path);
        auto param_count = params.size();
        if (params.size() >= 20) return false;

        if (product_name == "Jusant") return true;

        // UE DX12 has a 4 param root sig that crashes if modified. Track for now
        return std::ranges::any_of(params, [](auto param) {
          return (param.type == reshade::api::pipeline_layout_param_type::descriptor_table);
        });
      };

      if (!initialized) {
        AddAdvancedSettings();

        for (auto* new_setting : info_settings) {
          settings.push_back(new_setting);
        }

        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::force_pipeline_cloning = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;

        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader_dx11;
        renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader_dx11;

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r10g10b10a2_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .dimensions = {.width = 32, .height = 32, .depth = 32},
            .resource_tag = 1.f,
        });

        initialized = true;
      }

      if (g_dump_shaders != 0.f) {
        renodx::utils::swapchain::Use(fdw_reason);
        renodx::utils::shader::Use(fdw_reason);
        renodx::utils::shader::use_shader_cache = true;
        renodx::utils::resource::Use(fdw_reason);
        reshade::register_event<reshade::addon_event::draw>(OnDrawForLUTDump);
        reshade::log::message(reshade::log::level::info, "DumpLUTShaders enabled.");
      }

      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::shader::Use(fdw_reason);
      renodx::utils::swapchain::Use(fdw_reason);
      renodx::utils::resource::Use(fdw_reason);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::draw>(OnDrawForLUTDump);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  return TRUE;
}
