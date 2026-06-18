/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define RENODX_MODS_SWAPCHAIN_VERSION 2

#define DEBUG_LEVEL_0

#include <d3d12.h>
#include <windows.h>
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <iomanip>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/bitwise.hpp"
#include "../../utils/dlss_hook.hpp"
#include "../../utils/format.hpp"
#include "../../utils/path.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"

#include "./eyeadaptation/adaptation.hpp"
#include "./photomode.hpp"

#include "./shared.h"

namespace {

float initial_frame_gen_support = 0.f;
HMODULE addon_module_handle = nullptr;
bool dlss_hooks_attached = false;
bool dlss_frame_gen_had_early_load_on_boot = false;
std::optional<reshade::api::color_space> next_color_space = std::nullopt;
std::optional<reshade::api::color_space> current_color_space = std::nullopt;
ShaderInjectData shader_injection;

constexpr const char* PRIMARY_RENDER_UPGRADE_NAME = "Starfield Primary Render";

std::filesystem::path GetModulePath(HMODULE h_module) {
  wchar_t path[MAX_PATH] = L"";
  GetModuleFileNameW(h_module, path, ARRAYSIZE(path));
  return path;
}

std::string GetAddonFileName() {
  if (addon_module_handle == nullptr) return {};
  return GetModulePath(addon_module_handle).filename().string();
}

bool EqualsInsensitive(std::string_view lhs, std::string_view rhs) {
  return _stricmp(std::string(lhs).c_str(), std::string(rhs).c_str()) == 0;
}

bool HasLoadFromDllMainEntry();
bool EnsureLoadFromDllMainEntry();

std::string FormatHResult(HRESULT hr) {
  std::stringstream s;
  s << "0x" << std::uppercase << std::hex << std::setw(8) << std::setfill('0')
    << static_cast<uint32_t>(hr);
  return s.str();
}

void ConfigureDlssHookPaths() {
  auto dlss_path = renodx::utils::settings::ReadGlobalString("DLSSPath");
  auto streamline_path = renodx::utils::settings::ReadGlobalString("StreamlinePath");

  if (dlss_path.empty()) {
    dlss_path = (renodx::utils::path::GetExecutableBasePath() / "nvngx_dlss.dll").string();
  }
  if (streamline_path.empty()) {
    streamline_path = (renodx::utils::path::GetExecutableBasePath() / "sl.interposer.dll").string();
  }

  renodx::utils::dlss_hook::nvngx_dlss_file_path = dlss_path;
  renodx::utils::dlss_hook::streamline_interposer_file_path = streamline_path;

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "Configured DLSS FG hook paths";
  s << ", DLSSPath: " << renodx::utils::dlss_hook::nvngx_dlss_file_path;
  s << ", StreamlinePath: " << renodx::utils::dlss_hook::streamline_interposer_file_path;
  reshade::log::message(reshade::log::level::info, s.str().c_str());
#endif
}

std::vector<std::string> ReadConfigArray(const char* section, const char* key) {
  size_t value_size = 0;
  if (!reshade::get_config_value(nullptr, section, key, nullptr, &value_size) || value_size == 0) {
    return {};
  }

  std::string raw_value(value_size, '\0');
  if (!reshade::get_config_value(nullptr, section, key, raw_value.data(), &value_size)) {
    return {};
  }

  std::vector<std::string> values;
  for (size_t offset = 0; offset < raw_value.size();) {
    const auto* entry = raw_value.c_str() + offset;
    const size_t entry_size = std::strlen(entry);
    if (entry_size == 0) break;

    values.emplace_back(entry);
    offset += entry_size + 1;
  }

  return values;
}

bool HasLoadFromDllMainEntry() {
  const auto addon_file = GetAddonFileName();
  if (addon_file.empty()) return false;

  return std::ranges::any_of(
      ReadConfigArray("ADDON", "LoadFromDllMain"),
      [&](const auto& value) {
        return EqualsInsensitive(std::filesystem::path(value).filename().string(), addon_file);
      });
}

bool EnsureLoadFromDllMainEntry() {
  const auto addon_file = GetAddonFileName();
  if (addon_file.empty()) return false;

  auto values = ReadConfigArray("ADDON", "LoadFromDllMain");
  for (const auto& value : values) {
    if (EqualsInsensitive(std::filesystem::path(value).filename().string(), addon_file)) {
      return true;
    }
  }

  values.push_back(addon_file);

  std::string serialized;
  for (const auto& value : values) {
    serialized.append(value);
    serialized.push_back('\0');
  }

  reshade::set_config_value(nullptr, "ADDON", "LoadFromDllMain", serialized.c_str(), serialized.size());

  std::stringstream s;
  s << "Added " << addon_file << " to ADDON.LoadFromDllMain in ReShade.ini. Restart required.";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  return true;
}

bool IsDlssFrameGenSelected() {
  return renodx::utils::settings::FindSetting("FrameGenSupport")->GetValue() == 2.f;
}

void DetectDlssFrameGenLoadMode(HMODULE h_module) {
  static bool checked_load_mode = false;

  if (checked_load_mode) return;
  checked_load_mode = true;

  const auto module_file = GetModulePath(h_module).filename().string();
  const bool streamline_loaded = renodx::utils::platform::IsModuleLoaded(
      renodx::utils::dlss_hook::streamline_interposer_file_path);
  const bool dlss_loaded = renodx::utils::platform::IsModuleLoaded(
      renodx::utils::dlss_hook::nvngx_dlss_file_path);

  if (HasLoadFromDllMainEntry()) {
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << module_file << " is listed in ADDON.LoadFromDllMain.";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
#endif
    return;
  }

  std::stringstream s;
  s << module_file << " is not listed in ADDON.LoadFromDllMain";

  if (streamline_loaded || dlss_loaded) {
    s << " and ";

    if (streamline_loaded) {
      s << std::filesystem::path(renodx::utils::dlss_hook::streamline_interposer_file_path).filename().string();
    }

    if (streamline_loaded && dlss_loaded) {
      s << ", ";
    }

    if (dlss_loaded) {
      s << std::filesystem::path(renodx::utils::dlss_hook::nvngx_dlss_file_path).filename().string();
    }

    s << " is already loaded. " << module_file
      << " is not listed in ADDON.LoadFromDllMain, so early DLSS FG hooks may have been missed unless ReShade was loaded through another early path.";
  } else {
    s << ". " << module_file
      << " is not listed in ADDON.LoadFromDllMain. Early DLSS FG hooks may still work if ReShade was loaded through another early path.";
  }

  reshade::log::message(reshade::log::level::warning, s.str().c_str());
}

std::chrono::steady_clock::time_point last_eye_adaptation_time = {};
float accumulated_eye_adaptation_time = 0.0f;
bool eye_adaptation_measure_seen_since_resolve = false;

constexpr uint32_t EYE_ADAPTATION_FRAME_FLAGS =
    CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_RAN
    | CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_RAN;

custom::passes::adaptation::Config adaptation_pass_config = {
    .histogram_bins = 256u,
    .transport_buffer_dword_count = sizeof(RenodxEyeAdaptationTransportLayout) / sizeof(uint32_t),
};

inline bool IsActiveFrameGenFSR3() {
  return initial_frame_gen_support == 1.f;
}

inline bool IsSdrOutputSelected() {
  return !IsActiveFrameGenFSR3() && renodx::utils::settings::FindSetting("OutputMode")->GetValue() == 0.f;
}

inline bool IsPsychoV17Enabled() {
  return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_PSYCHOV17;
}

inline bool IsCustomToneMapperEnabled() {
  return shader_injection.tone_map_type != RENODX_TONE_MAP_TYPE_VANILLA;
}

inline bool IsRenoDRTEnabled() {
  return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_RENODRT;
}

inline bool IsPerceptualEyeAdaptationEnabled() {
  return IsPsychoV17Enabled()
         && renodx::utils::bitwise::HasFlag(
             shader_injection.custom_flags,
             CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL);
}

void AdvanceEyeAdaptationClock() {
  const auto now = std::chrono::steady_clock::now();
  float frame_delta_time = 1.0f / 60.0f;
  if (last_eye_adaptation_time.time_since_epoch().count() != 0) {
    frame_delta_time = std::chrono::duration<float>(now - last_eye_adaptation_time).count();
    if (!(frame_delta_time > 0.0f) || frame_delta_time > 1.0f) {
      frame_delta_time = 1.0f / 60.0f;
    }
  }
  last_eye_adaptation_time = now;
  accumulated_eye_adaptation_time += frame_delta_time;
  shader_injection.custom_frame_delta_time = frame_delta_time;
  shader_injection.custom_frame_time = accumulated_eye_adaptation_time;
}

void BeginEyeAdaptationDispatchFrame() {
  AdvanceEyeAdaptationClock();
  shader_injection.custom_flags = renodx::utils::bitwise::UnsetFlag(
      shader_injection.custom_flags,
      EYE_ADAPTATION_FRAME_FLAGS);
  if (!IsPerceptualEyeAdaptationEnabled()) {
    shader_injection.custom_flags = renodx::utils::bitwise::UnsetFlag(
        shader_injection.custom_flags,
        CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL_RESOLVE_HAD_RUN);
  }
}

void OverrideDlssgOptions(const sl::ViewportHandle& viewport_handle, sl::DLSSGOptions& options) {
  (void)viewport_handle;

  if (options.colorBufferFormat == 0u
      && options.hudLessBufferFormat == 0u
      && options.uiBufferFormat == 0u) {
    return;
  }

  if (renodx::mods::swapchain::target_format != reshade::api::format::r10g10b10a2_unorm) {
    return;
  }

  options.colorBufferFormat = DXGI_FORMAT_R10G10B10A2_UNORM;
  options.hudLessBufferFormat = DXGI_FORMAT_R16G16B16A16_FLOAT;
}

void OnInitDevice(reshade::api::device* device) {
  if (renodx::utils::settings::FindSetting("FxUpgradeRender")->GetValue() != 2.f) return;
  if (device->get_api() != reshade::api::device_api::d3d12) return;

  static std::optional<bool> supports_r9g9b9e5 = std::nullopt;
  if (supports_r9g9b9e5.has_value()) return;  // Already ran

  auto* native_device = reinterpret_cast<ID3D12Device*>(static_cast<uintptr_t>(device->get_native()));  // NOLINT(performance-no-int-to-ptr)
  {
    D3D12_FEATURE_DATA_FORMAT_SUPPORT format_support = {};
    format_support.Format = DXGI_FORMAT_R9G9B9E5_SHAREDEXP;
    const HRESULT hr = native_device->CheckFeatureSupport(
        D3D12_FEATURE_FORMAT_SUPPORT,
        &format_support,
        sizeof(format_support));
    if (FAILED(hr)) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "OnInitDevice(CheckFeatureSupport R9G9B9E5 failed: ";
      s << FormatHResult(hr);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      return;
    }

    supports_r9g9b9e5 = (format_support.Support1 & D3D12_FORMAT_SUPPORT1_RENDER_TARGET) != 0;
  }

  if (!supports_r9g9b9e5.value()) {
#ifdef DEBUG_LEVEL_0
    reshade::log::message(reshade::log::level::info, "OnInitDevice(R9G9B9E5 unsupported, will use R16G16B16A16F instead)");
#endif
    return;
  }

  const auto target = std::ranges::find_if(renodx::mods::swapchain::swap_chain_upgrade_targets, [](const auto& target) {
    return target.name == PRIMARY_RENDER_UPGRADE_NAME;
  });

  if (target == renodx::mods::swapchain::swap_chain_upgrade_targets.end()) {
    assert(false && "Primary render upgrade target not found");
    return;
  }

  target->new_format = reshade::api::format::r9g9b9e5;
  target->view_upgrades = renodx::utils::resource::VIEW_UPGRADES_R9G9B9E5;
#ifdef DEBUG_LEVEL_0
  reshade::log::message(reshade::log::level::info, "OnInitDevice(Primary render upgrade format set to R9G9B9E5)");
#endif
}

inline void SyncSwapChainOutputPreset() {
  auto queue_color_space = [](reshade::api::color_space color_space) {
    if (current_color_space.has_value() && current_color_space.value() == color_space) {
      next_color_space = std::nullopt;
      return;
    }
    next_color_space = color_space;
  };

  if (IsActiveFrameGenFSR3()) {
    shader_injection.swap_chain_output_preset = 2.f;
    queue_color_space(reshade::api::color_space::extended_srgb_linear);
    return;
  }

  const bool is_hdr10 = renodx::mods::swapchain::target_format == reshade::api::format::r10g10b10a2_unorm;
  const bool is_hdr_output = renodx::utils::settings::FindSetting("OutputMode")->GetValue() != 0.f;

  if (is_hdr_output) {
    shader_injection.peak_white_nits = renodx::utils::settings::FindSetting("ToneMapPeakNits")->GetValue();
    shader_injection.diffuse_white_nits = renodx::utils::settings::FindSetting("ToneMapGameNits")->GetValue();
    shader_injection.graphics_white_nits = renodx::utils::settings::FindSetting("ToneMapUINits")->GetValue();
    shader_injection.swap_chain_output_preset = is_hdr10
                                                    ? 1.f
                                                    : 2.f;
    queue_color_space(
        is_hdr10
            ? reshade::api::color_space::hdr10_st2084
            : reshade::api::color_space::extended_srgb_linear);
    return;
  }

  shader_injection.peak_white_nits = 1.f;
  shader_injection.diffuse_white_nits = 1.f;
  shader_injection.graphics_white_nits = 1.f;
  shader_injection.swap_chain_output_preset = is_hdr10 ? 0.f : 2.f;
  queue_color_space(
      is_hdr10
          ? reshade::api::color_space::srgb_nonlinear
          : reshade::api::color_space::extended_srgb_linear);
}

bool OnEyeAdaptationHistogramShader(reshade::api::command_list* cmd_list) {
  BeginEyeAdaptationDispatchFrame();
  if (IsPerceptualEyeAdaptationEnabled()) {
    custom::passes::adaptation::ClearHistogram(cmd_list);
  }
  shader_injection.custom_flags = renodx::utils::bitwise::SetFlag(
      shader_injection.custom_flags,
      CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_RAN
          | CUSTOM_EYE_ADAPTATION_FLAGS__HISTOGRAM_HAD_RUN);
  eye_adaptation_measure_seen_since_resolve = true;
  return true;
}

bool OnEyeAdaptationResolveShader(reshade::api::command_list* cmd_list) {
  if (!eye_adaptation_measure_seen_since_resolve) {
    BeginEyeAdaptationDispatchFrame();
  }
  const bool perceptual_eye_adaptation_enabled = IsPerceptualEyeAdaptationEnabled();
  shader_injection.custom_flags = renodx::utils::bitwise::SetFlag(
      shader_injection.custom_flags,
      CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_RAN
          | CUSTOM_EYE_ADAPTATION_FLAGS__RESOLVE_HAD_RUN
          | (perceptual_eye_adaptation_enabled ? CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL_RESOLVE_HAD_RUN : 0u));
  if (!perceptual_eye_adaptation_enabled) {
    shader_injection.custom_flags = renodx::utils::bitwise::UnsetFlag(
        shader_injection.custom_flags,
        CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL_RESOLVE_HAD_RUN);
  }
  eye_adaptation_measure_seen_since_resolve = false;
  return true;
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  if (swapchain == nullptr || !renodx::mods::swapchain::IsUpgraded(swapchain)) {
    std::stringstream s;
    s << "mods::swapchain::OnPresent(swapchain=";
    s << PRINT_PTR(reinterpret_cast<uintptr_t>(swapchain));
    s << ") - Unupgraded swapchain, skipping";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return;
  }

  SyncSwapChainOutputPreset();
  if (next_color_space.has_value()) {
    const auto pending_color_space = next_color_space.value();
    const bool changed = renodx::utils::swapchain::ChangeColorSpace(swapchain, pending_color_space);
    current_color_space = next_color_space;
    next_color_space = std::nullopt;
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "[Starfield] OnPresent(ChangeColorSpace)";
    s << " requested=" << pending_color_space;
    s << ", changed=" << (changed ? "true" : "false");
    s << ", swapchain_color_space=" << swapchain->get_color_space();
    reshade::log::message(reshade::log::level::info, s.str().c_str());
#endif
  }
}

renodx::mods::shader::CustomShaders custom_shaders = {
    {
        0x3DE15D58,
        {
            .crc32 = 0x3DE15D58,
            .code = __0x3DE15D58,
            .on_inject = &OnEyeAdaptationHistogramShader,
            .views = {
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 0u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetTransportView,
                },
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 1u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetHistogramView,
                },
            },
        },
    },
    {
        0x32780864,
        {
            .crc32 = 0x32780864,
            .code = __0x32780864,
            .on_inject = &OnEyeAdaptationResolveShader,
            .views = {
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 0u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetTransportView,
                },
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 1u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetHistogramView,
                },
            },
        },
    },
    {
        0x65C4E902,
        {
            .crc32 = 0x65C4E902,
            .code = __0x65C4E902,
            .views = {
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 0u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetTransportView,
                },
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 1u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetHistogramView,
                },
            },
        },
    },
    {
        0x7051F23E,
        {
            .crc32 = 0x7051F23E,
            .code = __0x7051F23E,
            .views = {
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 0u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetTransportView,
                },
                {
                    .type = reshade::api::descriptor_type::texture_unordered_access_view,
                    .slot = 1u,
                    .space = 50u,
                    .get_view = &custom::passes::adaptation::GetHistogramView,
                },
            },
        },
    },
    __ALL_CUSTOM_SHADERS,
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Output Mode",
        .section = "Output",
        .tooltip = "Controls the swapchain output path."
                   "\nSDR uses 10-bit sRGB and BT.709."
                   "\nHDR uses 10-bit PQ and BT.2020."
                   "\nFSR3 frame generation forces scRGB.",
        .labels = {"SDR", "HDR"},
        .is_enabled = []() { return !IsActiveFrameGenFSR3(); },
        .on_change_value = [](float, float) { SyncSwapChainOutputPreset(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Output",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return !IsSdrOutputSelected(); },
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
        .is_enabled = []() { return !IsSdrOutputSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Output",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return !IsSdrOutputSelected(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Output",
        .tooltip = "Emulates output decoding used on SDR displays.",
        .labels = {"None", "2.2", "BT.1886"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Grading",
        .labels = {"Vanilla", "RenoDRT", "PsychoV-17"},
        .parse = [](float value) {
          if (value == 1.f) return RENODX_TONE_MAP_TYPE_RENODRT;
          if (value == 2.f) return RENODX_TONE_MAP_TYPE_PSYCHOV17;
          return RENODX_TONE_MAP_TYPE_VANILLA;
        },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Grading",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeConeResponse",
        .binding = &shader_injection.custom_cone_response,
        .default_value = 50.f,
        .label = "Cone Response",
        .section = "Grading",
        .tooltip = "Scales PsychoV cone response. When Vanilla Tonemapper Slope is enabled, this multiplies the vanilla-derived baseline.",
        .max = 100.f,
        .is_enabled = []() { return IsPsychoV17Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.custom_lut_strength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTScaling",
        .binding = &shader_injection.custom_lut_scaling,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Grading",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTSampling",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FLAGS__LUT_SAMPLING_TETRAHEDRAL},
        .label = "LUT Sampling",
        .section = "Grading",
        .labels = {"Trilinear", "Tetrahedral"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxVanillaToneMap",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_RENODRT_FLAGS__TONEMAP_BY_LUMINANCE},
        .label = "RenoDRT Tone Mapping",
        .section = "Grading",
        .tooltip = "Controls whether RenoDRT matches the vanilla SDR signal\nper-channel or by luminance before HDR reconstruction.",
        .labels = {"Per-Channel", "Luminance"},
        .is_enabled = []() { return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_RENODRT; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUpgradeMethod",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .packed_values = {
            CUSTOM_FLAGS__UPGRADE_METHOD_UPGRADE_TONEMAP,
            CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_MAX_CHANNEL,
            CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_LUMINANCE,
            CUSTOM_FLAGS__UPGRADE_METHOD_NEUTWO_PER_CHANNEL,
            CUSTOM_FLAGS__UPGRADE_METHOD_EXTENDED_VANILLA_N2,
        },
        .label = "Upgrade Method",
        .section = "Grading",
        .tooltip = "Controls how the RenoDRT path reconstructs HDR\nfrom the vanilla SDR signal before tone mapping.",
        .labels = {"UpgradeToneMap", "N2 Max Channel", "N2 Luminance", "N2 Per-Channel", "Extended + N2 Max Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_RENODRT; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapN2MidgrayPrescale",
        .binding = &shader_injection.custom_n2_midgray_prescale,
        .default_value = 100.f,
        .label = "N2 Midgray Prescale",
        .section = "Grading",
        .tooltip = "Blends RenoDRT N2 input from raw scene (0)\nto vanilla midgray-scaled scene (100).",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == RENODX_TONE_MAP_TYPE_RENODRT
                                    && (std::bit_cast<uint32_t>(shader_injection.custom_flags) & CUSTOM_FLAGS__UPGRADE_METHOD_MASK) != CUSTOM_UPGRADE_METHOD__UPGRADE_TONEMAP; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTBlendMask",
        .binding = &shader_injection.custom_lut_blend_mask,
        .default_value = 100.f,
        .label = "LUT Blend Mask",
        .section = "Grading",
        .tooltip = "Controls how much the game's per-pixel LUT blend mask\nis preserved after N2 downscale.\nHigher values keep more of Starfield's original LUT mask behavior.\nLower values bypass it.",
        .max = 100.f,
        .is_enabled = []() { return IsPsychoV17Enabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVVanillaTonemapMidgray",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {
            0u,
            CUSTOM_PSYCHOV_FLAGS__VANILLA_MIDGRAY,
            CUSTOM_PSYCHOV_FLAGS__VANILLA_MIDGRAY | CUSTOM_PSYCHOV_FLAGS__VANILLA_MIDGRAY_SOLVE,
        },
        .label = "Vanilla Midgray Reference",
        .section = "Grading",
        .tooltip = "Chooses how PsychoV borrows the vanilla tonemapper anchor."
               "\nFast solves fixed/rational curves and uses the fast 18%% ratio shortcut for Hable."
               "\nAccurate inverts the vanilla curve for 18%% output.",
        .labels = {"Off", "Fast", "Accurate"},
        .is_enabled = []() { return IsPsychoV17Enabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoVVanillaTonemapSlope",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {
            0u,
            CUSTOM_PSYCHOV_FLAGS__VANILLA_SLOPE,
            CUSTOM_PSYCHOV_FLAGS__VANILLA_SLOPE | CUSTOM_PSYCHOV_FLAGS__VANILLA_SLOPE_FIRST_DERIVATIVE,
        },
        .label = "Vanilla Tonemapper Slope",
        .section = "Grading",
        .tooltip = "Chooses how PsychoV borrows the vanilla tonemapper slope."
               "\nFast uses a local finite-difference estimate."
               "\nAccurate uses the analytic first derivative.",
        .labels = {"Off", "Fast", "Accurate"},
        .is_enabled = []() { return IsPsychoV17Enabled(); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .can_reset = false,
        .label = "Eye Adaptation",
        .section = "Grading",
        .is_enabled = []() { return IsPsychoV17Enabled(); },
        .on_draw = []() {
              ImGui::Separator();
              ImGui::TextUnformatted("Eye Adaptation");
              return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxEyeAdaptation",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_EYE_ADAPTATION_FLAGS__PERCEPTUAL},
        .label = "Eye Adaptation",
        .section = "Grading",
        .tooltip = "Chooses between Starfield's vanilla auto exposure and the custom perceptual PsychoV eye adaptation.",
        .labels = {"Vanilla", "Perceptual"},
        .is_enabled = []() { return IsPsychoV17Enabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "AE_MinBrightness",
        .binding = &shader_injection.custom_eye_adaptation_min_brightness,
        .default_value = 0.01f,
        .label = "AE Min Brightness",
        .section = "Grading",
        .tooltip = "Minimum perceptual eye-adaptation target brightness as a percentage of diffuse white.",
        .min = 0.01f,
        .max = 2.f,
        .format = "%.2f%%",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "AE_MaxBrightness",
        .binding = &shader_injection.custom_eye_adaptation_max_brightness,
        .default_value = 30.f,
        .label = "AE Max Brightness",
        .section = "Grading",
        .tooltip = "Maximum perceptual eye-adaptation target brightness as a percentage of diffuse white.",
        .min = 0.f,
        .max = 50.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "AE_DarkToLightTime",
        .binding = &shader_injection.custom_eye_adaptation_dark_to_light_time,
        .default_value = 1.6f,
        .label = "AE Short Adapt",
        .section = "Grading",
        .tooltip = "Short-term adaptation time constant in seconds for perceptual eye adaptation.",
        .min = 0.5f,
        .max = 20.f,
        .format = "%.1f s",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
        .is_logarithmic = true,
    },
    new renodx::utils::settings::Setting{
        .key = "AE_LightToDarkTime",
        .binding = &shader_injection.custom_eye_adaptation_light_to_dark_time,
        .default_value = 4.3f,
        .label = "AE Long Adapt",
        .section = "Grading",
        .tooltip = "Long-term dark-adaptation time constant in seconds for perceptual eye adaptation.",
        .min = 1.f,
        .max = 90.f,
        .format = "%.1f s",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
        .is_logarithmic = true,
    },
    new renodx::utils::settings::Setting{
        .key = "AE_TargetSmoothing",
        .binding = &shader_injection.custom_eye_adaptation_target_smoothing_time,
        .default_value = 100.f,
        .label = "AE Meter Delay",
        .section = "Grading",
        .tooltip = "Smooths measured brightness before perceptual eye adaptation reacts. Values are milliseconds.",
        .min = 0.f,
        .max = 1000.f,
        .format = "%.0f ms",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
        .parse = [](float value) { return value * 0.001f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .packed_values = {0u, CUSTOM_FILM_GRAIN_FLAGS__PERCEPTUAL},
        .label = "Film Grain Type",
        .section = "Effects",
        .tooltip = "Chooses whether film grain uses Starfield's vanilla path or RenoDX perceptual film grain.",
        .labels = {"Vanilla", "Perceptual"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrain",
        .binding = &shader_injection.custom_film_grain,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxUpgradeRender",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Rendering",
        .section = "Processing",
        .tooltip = "Upgrades the rendering format to reduce banding (requires restart)"
                   // "\nR9G9B9E5 falls back to R16G16B16A16F if not supported."
                   "\nNote: May be unstable with FSR3",
        .labels = {
            "R11G11B10F",
            "R16G16B16A16F",
            // "R9G9B9E5",
        },
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "FrameGenSupport",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Frame Gen Support",
        .section = "Processing",
        .tooltip = "Enables swapchain compatibility paths for frame generation integrations (requires restart).",
        .labels = {"None", "FSR3", "DLSS"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .can_reset = false,
        .label = "Restart game to apply Frame Gen Support changes.",
        .section = "Processing",
        .tint = 0xFFB84D,
        .is_visible = []() { return renodx::utils::settings::FindSetting("FrameGenSupport")->GetValue() != initial_frame_gen_support; },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .can_reset = false,
        .label = "DLSS FG early-load hint",
        .section = "Processing",
        .tint = 0xFFB84D,
        .on_draw = []() {
              const auto addon_file = GetAddonFileName();
              const bool configured = IsDlssFrameGenSelected()
                                      && !dlss_frame_gen_had_early_load_on_boot
                                      && HasLoadFromDllMainEntry();

              if (configured) {
                ImGui::BeginDisabled();
              }
              if (ImGui::Button(configured
                                    ? "DLSS FG Early Load Configured (Restart Required)"
                                    : "Enable DLSS FG Early Load")) {
                EnsureLoadFromDllMainEntry();
              }
              if (configured) {
                ImGui::EndDisabled();
              }
              if (ImGui::IsItemHovered()) {
                ImGui::SetTooltip("[Addon]\nLoadFromDllMain=%s", addon_file.c_str());
              }

              return false; },
        .is_visible = []() { return IsDlssFrameGenSelected() && !dlss_frame_gen_had_early_load_on_boot; },
        .is_sticky = true,
    },
#ifndef NDEBUG
    new renodx::utils::settings::Setting{
        .key = "DebugShowOverlay",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_SHOW_OVERLAY},
        .label = "Show Overlay",
        .section = "Debug",
        .tooltip = "Shows the tonemapper debug overlay without forcing current or target anchors.",
    },
    new renodx::utils::settings::Setting{
        .key = "DebugForceCurrent",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_FORCE_CURRENT},
        .label = "Force Current",
        .section = "Debug",
        .tooltip = "Overrides the tonemapper current anchor with Debug Value.",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugForceTarget",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_FORCE_TARGET},
        .label = "Force Target",
        .section = "Debug",
        .tooltip = "Overrides the tonemapper target anchor with Debug Value. Enable both force flags to force both anchors.",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugInspectPrevField",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_INSPECT_PREV_FIELD},
        .label = "Inspect Prev Field/Target",
        .section = "Debug",
        .tooltip = "Exports previous field and filtered target into the debug payload.",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugInspectResiduals",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_INSPECT_RESIDUALS},
        .label = "Inspect Prev Fast/Slow",
        .section = "Debug",
        .tooltip = "Exports previous fast and slow residuals into the debug payload.",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugShowTonemapInfo",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_SHOW_TONEMAP_INFO},
        .label = "Show Tonemap Info",
        .section = "Debug",
        .tooltip = "Adds vanilla tonemap mode and breakpoint/inflection values to the debug overlay.",
        .is_enabled = []() {
          return renodx::utils::bitwise::HasFlag(shader_injection.custom_flags, CUSTOM_FLAGS__DEBUG_SHOW_OVERLAY);
        },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugShowHistogramSource",
        .binding = &shader_injection.custom_flags,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .packed_values = {0u, CUSTOM_FLAGS__DEBUG_SHOW_HISTOGRAM_SOURCE},
        .label = "Show Histogram Source",
        .section = "Debug",
        .tooltip = "Writes the perceptual histogram 2x2 source average into the histogram color buffer and the metered scalar into the histogram luma buffer.",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled(); },
    },
    new renodx::utils::settings::Setting{
        .key = "DebugValue",
        .binding = &shader_injection.custom_debug_value,
        .default_value = 18.f,
        .label = "Debug Value",
        .section = "Debug",
        .tooltip = "Forced anchor value used by the force debug flags. Values are percent of diffuse white.",
        .min = 0.01f,
        .max = 100.f,
        .format = "%.2f%%",
        .is_enabled = []() { return IsPerceptualEyeAdaptationEnabled()
                                    && (renodx::utils::bitwise::HasFlag(shader_injection.custom_flags, CUSTOM_FLAGS__DEBUG_FORCE_CURRENT)
                                        || renodx::utils::bitwise::HasFlag(shader_injection.custom_flags, CUSTOM_FLAGS__DEBUG_FORCE_TARGET)); },
        .parse = [](float value) { return value * 0.01f; },
    },
#endif
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            if (setting->is_global) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          SyncSwapChainOutputPreset();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Look",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ToneMapGameNits", 203.f},
              {"ColorGradeShadows", 55.f},
              {"ColorGradeHighlights", 55.f},
              {"ColorGradeContrast", 60.f},
              {"ColorGradeSaturation", 80.f},
              {"ColorGradeBlowout", 80.f},
              {"FxBloom", 15.f},
          });
          SyncSwapChainOutputPreset();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "PsychoV17",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ToneMapType", 2.f},
              {"ColorGradeBlowout", 0.f},
              {"ColorGradeConeResponse", 60.f},
              {"FxBloom", 15.f},
          });
          SyncSwapChainOutputPreset();
        },
    },
};

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
      {"ColorGradeLUTStrength", 100.f},
      {"ColorGradeLUTScaling", 0.f},
      {"ColorGradeLUTSampling", 0.f},
      {"ColorGradeLUTBlendMask", 100.f},
      {"FxEyeAdaptation", 0.f},
      {"PsychoVVanillaTonemapMidgray", 1.f},
      {"PsychoVVanillaTonemapSlope", 1.f},
      {"AE_MinBrightness", 0.01f},
      {"AE_MaxBrightness", 15.f},
      {"AE_DarkToLightTime", 1.6f},
      {"AE_LightToDarkTime", 4.3f},
      {"AE_TargetSmoothing", 0.f},
#ifndef NDEBUG
      {"DebugForceCurrent", 0.f},
      {"DebugForceTarget", 0.f},
      {"DebugInspectPrevField", 0.f},
      {"DebugInspectResiduals", 0.f},
      {"DebugShowTonemapInfo", 0.f},
      {"DebugValue", 18.f},
#endif
      {"FxBloom", 50.f},
      {"FxFilmGrain", 50.f},
      {"FxVanillaToneMap", 0.f},
      {"ToneMapN2MidgrayPrescale", 100.f},
  });
  SyncSwapChainOutputPreset();
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Starfield";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      addon_module_handle = h_module;
      if (!reshade::register_addon(h_module)) return FALSE;

      // while (IsDebuggerPresent() == 0) Sleep(100);

      renodx::mods::shader::on_create_pipeline_layout = [](reshade::api::device* device, auto params) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };

      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      renodx::mods::shader::expected_constant_buffer_space = 50;

      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::mods::swapchain::force_borderless = false;
      renodx::mods::swapchain::use_auto_cloning = true;
      // Starfield manages swapchain color space locally via Output Mode and OnPresent.
      // Avoid applying a boot-time color space in init_swapchain, since that can briefly
      // force HDR10 before the local SDR/HDR choice is evaluated.
      renodx::mods::swapchain::set_color_space = false;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::use_resource_cloning_dx12_only = true;

      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
      initial_frame_gen_support = renodx::utils::settings::FindSetting("FrameGenSupport")->GetValue();
      dlss_frame_gen_had_early_load_on_boot = HasLoadFromDllMainEntry();

      // HDR10 not supported because we want FSR3-FG to also use rgba16f
      renodx::mods::swapchain::SetUseHDR10(true);

      if (renodx::utils::settings::FindSetting("FrameGenSupport")->GetValue() == 1.f) {
        reshade::log::message(reshade::log::level::info, "Enabling FSR3 frame generation swapchain support");
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .use_resource_view_cloning = true,
            .usage_include = reshade::api::resource_usage::render_target
                             | reshade::api::resource_usage::copy_dest,
        });
        renodx::mods::swapchain::SetUseHDR10(false);
      } else if (renodx::utils::settings::FindSetting("FrameGenSupport")->GetValue() == 2.f) {
        ConfigureDlssHookPaths();
        DetectDlssFrameGenLoadMode(h_module);
        renodx::utils::streamline::v2::override_dlssg_set_options = &OverrideDlssgOptions;
        renodx::utils::dlss_hook::Use(DLL_PROCESS_ATTACH);

        dlss_hooks_attached = true;
      }

      SyncSwapChainOutputPreset();

      // RGBA8 Resource Pool and Render
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .use_resource_view_cloning = true,
          .aspect_ratio = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
          .usage_include = reshade::api::resource_usage::render_target,
          // .usage_exclude = reshade::api::resource_usage::unordered_access,
          .name = "Starfield RGBA8 Resource Pool and Render",
          .resource_tag = CUSTOM_RESOURCE_TAG_RENDER,
      });

      // Primary render (reduces banding)
      {
        const auto render_upgrade_mode = renodx::utils::settings::FindSetting("FxUpgradeRender")->GetValue();
        if (render_upgrade_mode == 1.f || render_upgrade_mode == 2.f) {
          reshade::log::message(
              reshade::log::level::info,
              render_upgrade_mode == 2.f
                  ? "Upgrading rendering to R9G9B9E5 if supported; fallback is R16G16B16A16F"
                  : "Upgrading rendering to R16G16B16A16F");
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r11g11b10_float,
              .new_format = reshade::api::format::r16g16b16a16_float,
              .use_resource_view_cloning = true,
              .aspect_ratio = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
              .usage_include = reshade::api::resource_usage::render_target,
              .name = PRIMARY_RENDER_UPGRADE_NAME,
          });
        }
      }

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      if (dlss_hooks_attached) {
        renodx::utils::streamline::v2::override_dlssg_set_options = nullptr;
        renodx::utils::dlss_hook::Use(DLL_PROCESS_DETACH);
        dlss_hooks_attached = false;
      }
      renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
      reshade::unregister_addon(h_module);
      initial_frame_gen_support = 0.f;
      dlss_frame_gen_had_early_load_on_boot = false;
      next_color_space = std::nullopt;
      current_color_space = std::nullopt;
      addon_module_handle = nullptr;
      break;
  }

  custom::passes::adaptation::Use(fdw_reason, adaptation_pass_config);
  custom::passes::photomode::Use(fdw_reason, &shader_injection);

  renodx::utils::random::Use(fdw_reason, {&shader_injection.custom_random});
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
