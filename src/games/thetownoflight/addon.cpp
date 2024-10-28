/*
 * Copyright (C) 2024 Filippo Tarpini
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

// #include <embed/0x1FB08827.h>
// #include <embed/0x9D6291BC.h>
// #include <embed/0xB103EAA6.h>
// #include <embed/0xE61B6A3B.h>

// #include <embed/0xFFFFFFFD.h>  // Custom final VS
// #include <embed/0xFFFFFFFE.h>  // Custom final PS

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection;

bool IsTonemapped(reshade::api::command_list* cmd_list) {
  shader_injection.isTonemapped = 1.f;
  return true;
}

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntryCallback(0x9D6291BC, &IsTonemapped),  // Color grading LUT + fog + fade
    CustomShaderEntryCallback(0xB103EAA6, &IsTonemapped),  // Post process and user gamma adjustment (defaulted to 1)
    CustomShaderEntry(0xE61B6A3B),                         // Overlay effect in main menu
    CustomShaderEntry(0x1FB08827),                         // UI
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "outputMode",
        .binding = &shader_injection.outputMode,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.0f,
        .label = "Output Mode",
        .section = "Tone Mapping",
        .tooltip = "Select SDR or HDR game output. Make sure to match that with your current display mode, SDR for SDR and HDR for HDR.",
        .labels = {"SDR", "HDR"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type. The game did not have a tonemapper so highlights were heavily clipped.",
        .labels = {"Vanilla", "DICE"},
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 400.f,
        .max = 10000.f,
        .is_enabled = []() { return (shader_injection.outputMode == 1 && shader_injection.toneMapType == 1); },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 80.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.outputMode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 80.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.outputMode == 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "testInverse",
        .binding = &shader_injection.testInverse,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "testInverse",
        .section = "Test",
        .tooltip = "test if inverse tonemapping is working",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          system("start https://discord.gg/5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .on_change = []() {
          system("start https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Buy Pumbo a Coffee",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0xFF5F5F,
        .on_change = []() {
          system("start https://buymeacoffee.com/realfiloppi");
        },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("outputMode", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for The Town of Light";

// NOLINTEND(readability-identifier-naming)

bool fired_on_init_swapchain = false;
void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  if (!fired_on_init_swapchain) {
    fired_on_init_swapchain = true;
    auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
    if (peak.has_value()) {
      settings[2]->default_value = peak.value();
      settings[2]->can_reset = true;
    }
  }
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect, uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  shader_injection.isTonemapped = 0.f;
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 13;

      // renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::swapchain::use_resource_cloning = true;
      // renodx::mods::shader::trace_unmodified_shaders = true;
      renodx::mods::swapchain::force_borderless = true;
      // renodx::mods::swapchain::prevent_full_screen = true;
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = true;
      renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
      renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          // .shader_hash = 0x9D6291BC,
          // .use_resource_view_cloning = true,
          // .use_resource_view_hot_swap = true,
          // .aspect_ratio = screen_width / screen_height,
      });
#if 0  // NOLINT Seemingly unused (they might be used for copies of the scene buffer used as UI background)
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::b8g8r8a8_unorm_srgb,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
#endif

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  return TRUE;
}
