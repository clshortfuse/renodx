/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <windows.h>

#include <deps/imgui/imgui.h>
#include <excpt.h>
#include <tlhelp32.h>
#include <array>
#include <include/reshade.hpp>
#include <sstream>

#include <unordered_map>
#include <vector>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/vtable.hpp"
#include "./shared.h"

namespace {

const int CUSTOM_LUT_SHADER = 0x81567E40;
float g_custom_lut_draws = 0.f;
float g_custom_lut_count = 0.f;
ShaderInjectData shader_injection;

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x20133A8B),  // Final
    CustomShaderEntryCallback(0x81567E40, [](auto*) {
      ++g_custom_lut_count;
      shader_injection.custom_custom_lut_count = g_custom_lut_count;

      return true;
    }),
};

float current_settings_mode = 0;
float output_mode = 1.f;
float exclusive_fullscreen_detected = 0.f;
renodx::utils::settings::Setting* exclusive_fullscreen_warning_setting = nullptr;
renodx::utils::settings::Setting* output_mode_setting = nullptr;
renodx::utils::settings::Setting* force_display_hdr_setting = nullptr;
renodx::utils::settings::Setting* tone_map_type_setting = nullptr;
renodx::utils::settings::Setting* tone_map_peak_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_game_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_ui_nits_setting = nullptr;
renodx::utils::settings::Setting* tone_map_gamma_correction_setting = nullptr;

reshade::api::swapchain* tracked_swapchain = nullptr;
std::optional<reshade::api::color_space> next_color_space = std::nullopt;

void HandleOutputModeChange() {
  float output_mode = output_mode_setting->GetValue();
  bool is_10bit = renodx::mods::swapchain::target_format == reshade::api::format::r10g10b10a2_unorm;
  if (output_mode == 0.f) {
    if (is_10bit) {
      next_color_space = reshade::api::color_space::srgb_nonlinear;
      shader_injection.swap_chain_output_preset = 0.f;
      shader_injection.peak_white_nits = 1.f;
      shader_injection.diffuse_white_nits = 1.f;
      shader_injection.graphics_white_nits = 1.f;
    } else {
      shader_injection.swap_chain_output_preset = 2.f;
      shader_injection.peak_white_nits = 80.f;
      shader_injection.diffuse_white_nits = 80.f;
      shader_injection.graphics_white_nits = 80.f;
    }
  } else {
    if (is_10bit) {
      next_color_space = reshade::api::color_space::hdr10_st2084;
    }
    shader_injection.swap_chain_output_preset = 1.f;
    shader_injection.peak_white_nits = tone_map_peak_nits_setting->GetValue();
    shader_injection.diffuse_white_nits = tone_map_game_nits_setting->GetValue();
    shader_injection.graphics_white_nits = tone_map_ui_nits_setting->GetValue();
  }
}

bool IsHDREnabled() { return shader_injection.swap_chain_output_preset == 1.f; }

renodx::utils::settings::Settings settings = {
    exclusive_fullscreen_warning_setting = new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Exclusive fullscreen detected. Use Borderless instead.",
        .tint = 0xFF0000,
        .is_visible = []() { return exclusive_fullscreen_detected != 0.f; },
        .is_sticky = true,
    },
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
    output_mode_setting = new renodx::utils::settings::Setting{
        .key = "OutputMode",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Output Mode",
        .labels = {"SDR", "HDR"},
        .on_change_value = [](float previous, float current) { HandleOutputModeChange(); },
    },
    force_display_hdr_setting = new renodx::utils::settings::Setting{
        .key = "ForceDisplayHDR",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Force Display HDR",
        .tooltip = "Forces Display into HDR mode on game start (if supported)",
        .labels = {"Off", "On"},
        .is_global = true,
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    tone_map_type_setting = new renodx::utils::settings::Setting{
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
    tone_map_peak_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = &IsHDREnabled,
        .parse = [](float value) {
          return (output_mode_setting->GetValue() == 0.f)
                     ? 203.f
                     : value;
        },
    },
    tone_map_game_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
        .parse = [](float value) {
          return (output_mode_setting->GetValue() == 0.f)
                     ? 203.f
                     : value;
        },
    },
    tone_map_ui_nits_setting = new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = &IsHDREnabled,
    },
    tone_map_gamma_correction_setting = new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping",
        .tooltip = "Emulates output decoding used on SDR displays.",
        .labels = {"None", "2.2", "BT.1886"},
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
    new renodx::utils::settings::Setting{
        .key = "ToneMapWhiteClip",
        .binding = &shader_injection.tone_map_white_clip,
        .default_value = 100.f,
        .label = "White Clip",
        .section = "Tone Mapping",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          HandleOutputModeChange();
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
              {"ToneMapWhiteClip", 20.f},
              {"ColorGradeHighlights", 50.f},
              {"ColorGradeShadows", 50.f},
              {"ColorGradeContrast", 60.f},
              {"ColorGradeSaturation", 60.f},
              {"ColorGradeBlowout", 25.f},
              {"FxVignette", 50.f},
              {"FxBloom", 25.f},
              {"FxGrainStrength", 25.f},
          });
          if (output_mode_setting->GetValue() == 1.f) {
            auto current_peak = tone_map_peak_nits_setting->GetValue();
            renodx::utils::settings::UpdateSetting("ToneMapGameNits", renodx::utils::swapchain::ComputeReferenceWhite(current_peak));
          } else {
            renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
          }
          HandleOutputModeChange();
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Options",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "F6AUTeWJHM");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Options",
        .group = "button-line-2",
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
        .section = "Debug",
        .group = "button-line-3",
        .on_draw = []() {
          ImGui::Text("Custom LUT Draws: %d", static_cast<int>(g_custom_lut_draws));
          return false; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"OutputMode", 0.f},
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0.f},
      {"ToneMapHueProcessor", 0.f},
      {"ToneMapHueCorrection", 0.f},
      {"ToneMapHueShift", 0.f},
      {"ToneMapWhiteClip", 1.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"FxVignette", 50.f},
      {"FxBloom", 50.f},
      {"FxGrainStrength", 0.f},
  });
}

void OnPresetChange() {
  HandleOutputModeChange();
}

std::optional<bool> initial_hdr_forced = std::nullopt;
std::optional<DISPLAYCONFIG_PATH_INFO> forced_display_config = std::nullopt;

void UpdateDisplaySettings(reshade::api::swapchain* swapchain = tracked_swapchain) {
  if (swapchain == nullptr) return;
  auto attempt_hdr_on = (!initial_hdr_forced.has_value() && force_display_hdr_setting->GetValue() != 0.f);
  auto display_info = renodx::utils::swapchain::GetDisplayInfo(swapchain, attempt_hdr_on);

  if (!initial_hdr_forced.has_value()) {
    if (display_info.hdr_forced) {
      initial_hdr_forced = true;
      forced_display_config = display_info.display_config;
    } else {
      initial_hdr_forced = false;
    }
  }

  bool use_sdr = !display_info.hdr_supported || !display_info.hdr_enabled;

  output_mode_setting->Set(use_sdr ? 0.f : 1.f);
  tone_map_gamma_correction_setting->default_value = (use_sdr ? 0.f : 1.f);
  tone_map_peak_nits_setting->default_value = display_info.peak_nits;
  tone_map_ui_nits_setting->default_value = display_info.sdr_white_nits;
}

void RevertForcedHDR() {
  if (initial_hdr_forced.has_value() && initial_hdr_forced.value()) {
    // Restore initial HDR state
    assert(forced_display_config.has_value());
    bool passed = renodx::utils::swapchain::SetHDREnabled(forced_display_config.value(), false);
    if (passed) {
      OutputDebugStringW(L"Restored initial HDR state on display");
    } else {
      OutputDebugStringW(L"Failed to disable HDR on display");
    }
  }
}

bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  if (fullscreen) {
    exclusive_fullscreen_detected = 1.f;
  }
  return false;
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  g_custom_lut_draws = g_custom_lut_count;
  g_custom_lut_count = 0.f;

  auto* device = queue->get_device();

  auto* data = renodx::utils::data::Get<renodx::mods::swapchain::DeviceData>(device);
  if (data == nullptr) return;
  if (!data->upgraded_swapchains.contains(swapchain)) return;
  if (tracked_swapchain != swapchain) {
    tracked_swapchain = swapchain;
    UpdateDisplaySettings(swapchain);
    HandleOutputModeChange();
  } else if (next_color_space.has_value()) {
    renodx::utils::swapchain::ChangeColorSpace(tracked_swapchain, next_color_space.value());
    next_color_space = std::nullopt;
  }
}

decltype(&TerminateProcess) real_TerminateProcess = nullptr;
BOOL WINAPI HookTerminateProcess(HANDLE hProcess, UINT uExitCode) {
  DWORD targetPid = 0;
  if (hProcess != nullptr) {
    targetPid = GetProcessId(hProcess);
  }
  if (targetPid == 0 || targetPid == GetCurrentProcessId()) {
    OutputDebugStringW(L"HookTerminateProcess: intercepted TerminateProcess for current process\n");
    RevertForcedHDR();
  }
  return real_TerminateProcess(hProcess, uExitCode);
}

decltype(&ExitProcess) real_ExitProcess = nullptr;
VOID WINAPI HookExitProcess(UINT uExitCode) {
  OutputDebugStringW(L"HookExitProcess: intercepted ExitProcess\n");
  RevertForcedHDR();
  real_ExitProcess(uExitCode);
}

extern "C" IMAGE_DOS_HEADER __ImageBase;

void SetupPinnedModule() {
  static bool setup_pinned_module = false;
  static std::array<renodx::utils::vtable::HookItem, 2> g_process_hook_items = {{
      {"ExitProcess", reinterpret_cast<void**>(&real_ExitProcess), reinterpret_cast<void*>(&HookExitProcess)},
      {"TerminateProcess", reinterpret_cast<void**>(&real_TerminateProcess), reinterpret_cast<void*>(&HookTerminateProcess)},
  }};

  if (setup_pinned_module) return;

  HMODULE h_module = nullptr;
  auto ret = GetModuleHandleExW(
      GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
      reinterpret_cast<LPCWSTR>(&__ImageBase),
      &h_module);
  if (ret == 0 || h_module == nullptr) {
    std::stringstream s;
    s << "Failed to pin addon module: " << std::hex << GetLastError();
    reshade::log::message(reshade::log::level::error, s.str().c_str());

    // Attempt to increment instead:

    ret = GetModuleHandleExW(
        GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS,
        reinterpret_cast<LPCWSTR>(&__ImageBase),
        &h_module);

    if (ret == 0 || h_module == nullptr) {
      std::stringstream s;
      s << "Failed to increment addon module ref count: " << std::hex << GetLastError();
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return;
    }
    reshade::log::message(reshade::log::level::debug, "Incremented addon module");
  } else {
    reshade::log::message(reshade::log::level::debug, "Pinned addon module");
  }

  HMODULE h_kernel = GetModuleHandleW(L"kernel32.dll");
  if (h_kernel == nullptr) {
    reshade::log::message(reshade::log::level::error, "Failed to get handle for kernel32.dll");
  }
  bool hooked = renodx::utils::vtable::Hook(h_kernel, g_process_hook_items);
  if (!hooked) {
    reshade::log::message(reshade::log::level::error, "Failed to hook process termination APIs");
    return;
  }
  reshade::log::message(reshade::log::level::debug, "Hooked process termination APIs");
  setup_pinned_module = true;
}

bool initialized = false;
bool addon_registered = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Wobbly Life)";

extern "C" __declspec(dllexport) void AddonInit(HMODULE addon_module, HMODULE reshade_module) {
  if (!addon_registered) {
    if (!reshade::register_addon(addon_module)) return;
  }

  reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
  renodx::utils::settings::Use(DLL_PROCESS_ATTACH, &settings, &OnPresetOff);
  renodx::utils::swapchain::Use(DLL_PROCESS_ATTACH);
  renodx::mods::swapchain::Use(DLL_PROCESS_ATTACH, &shader_injection);
  renodx::mods::shader::Use(DLL_PROCESS_ATTACH, custom_shaders, &shader_injection);
  renodx::utils::random::Use(DLL_PROCESS_ATTACH);
  reshade::register_event<reshade::addon_event::present>(OnPresent);
}

extern "C" __declspec(dllexport) void AddonUninit(HMODULE addon_module, HMODULE reshade_module) {
  reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);
  renodx::utils::settings::Use(DLL_PROCESS_DETACH, &settings, &OnPresetOff);
  renodx::utils::swapchain::Use(DLL_PROCESS_DETACH);
  renodx::mods::swapchain::Use(DLL_PROCESS_DETACH, &shader_injection);
  renodx::mods::shader::Use(DLL_PROCESS_DETACH, custom_shaders, &shader_injection);
  renodx::utils::random::Use(DLL_PROCESS_DETACH);
  reshade::unregister_event<reshade::addon_event::present>(OnPresent);
  reshade::unregister_addon(addon_module);
  addon_registered = false;
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      addon_registered = true;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::SetUseHDR10(true);
        renodx::mods::swapchain::prevent_full_screen = true;
        renodx::mods::swapchain::force_borderless = true;
        renodx::mods::swapchain::use_auto_upgrade = true;
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        renodx::utils::settings::on_preset_changed_callbacks.emplace_back(&HandleOutputModeChange);

        initialized = true;
      }

      // Force settings to load early
      renodx::utils::settings::Use(DLL_PROCESS_ATTACH, &settings, &OnPresetOff);
      if (force_display_hdr_setting->GetValue() != 0.f) {
        SetupPinnedModule();
      }

      //   AddonInit is called after
      break;
    case DLL_PROCESS_DETACH:
      //   AddonUninit has called by Reshade

      if (lpv_reserved != nullptr) {
        // Process is terminating (and pinned)
        RevertForcedHDR();
      }

      break;
  }

  return TRUE;
}
