/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2

#include <embed/0x054D0CB8.h>
#include <embed/0x0A152BB1.h>
#include <embed/0x0D5ADD1F.h>
#include <embed/0x17FAB08F.h>
#include <embed/0x1C18052A.h>
#include <embed/0x32580F53.h>
#include <embed/0x3B344832.h>
#include <embed/0x4348FFAE.h>
#include <embed/0x58E74610.h>
#include <embed/0xAC5319C5.h>
#include <embed/0xE9D9E225.h>
#include <embed/0xEED8A831.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/swapchain.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomSwapchainShader(0x0D5ADD1F),  // output
    CustomShaderEntry(0xAC5319C5),      // film grain
    CustomShaderEntry(0x0A152BB1),      // HDRComposite
    CustomShaderEntry(0x054D0CB8),      // HDRComposite (no bloom)
    CustomShaderEntry(0x3B344832),      // HDRComposite (lut only)
    CustomShaderEntry(0x17FAB08F),      // PostSharpen
    CustomShaderEntry(0x1C18052A),      // CAS1
    CustomShaderEntry(0x58E74610),      // CAS2
    CustomShaderEntry(0x4348FFAE),      // CAS3
    CustomShaderEntry(0xEED8A831),      // CAS4
    // CustomShaderEntry(0xE9D9E225),   // ui
    CustomShaderEntry(0x32580F53),  // movie
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
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
        .can_reset = false,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100%% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .can_reset = false,
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
        .can_reset = false,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates an EOTF",
        .labels = {"Off", "2.2", "2.4"},
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTScaling",
        .binding = &shader_injection.colorGradeLUTScaling,
        .default_value = 100.f,
        .label = "LUT Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSceneGrading",
        .binding = &shader_injection.colorGradeSceneGrading,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Selects the strength of the game's custom scene grading.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "FilmGrain",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
  // renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
}

bool HandlePreDraw(reshade::api::command_list* cmd_list, bool is_dispatch = false) {
  const auto& shader_state = cmd_list->get_private_data<renodx::utils::shader::CommandListData>();

  // flow
  // 0x0a152bb1 (tonemapper) (r11g11b10 => rgb8a_unorm tRender)
  // 0x17FAB08F (sharpen?)   (rgb8a_unorm tRender => rgb8a_unorm tComposite)
  // 0xe9d9e225 (ui)         (rgb8a_unorm tUI => rgb8a_unorm tComposite)

  auto pixel_shader_hash = shader_state.GetCurrentPixelShaderHash();
  if (
      !is_dispatch
      && (pixel_shader_hash == 0x0a152bb1     // tonemapper
          || pixel_shader_hash == 0x054D0CB8  // tonemapper
          || pixel_shader_hash == 0x3B344832  // tonemapper
          || pixel_shader_hash == 0x17fab08f  // sharpener
          || pixel_shader_hash == 0x32580F53  // movie
          || pixel_shader_hash == 0xe9d9e225  // ui
          || pixel_shader_hash == 0x0d5add1f  // copy
          )) {
    auto& swapchain_state = cmd_list->get_private_data<renodx::utils::swapchain::CommandListData>();

    bool changed = false;
    const uint32_t render_target_count = swapchain_state.current_render_targets.size();
    for (uint32_t i = 0; i < render_target_count; i++) {
      auto render_target = swapchain_state.current_render_targets[i];
      if (render_target.handle == 0) continue;
      if (renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), render_target)) {
        changed = true;
      }
    }
    if (changed) {
      // Change render targets to desired
      renodx::mods::swapchain::RewriteRenderTargets(
          cmd_list,
          render_target_count,
          swapchain_state.current_render_targets.data(),
          swapchain_state.current_depth_stencil);
      renodx::mods::swapchain::FlushDescriptors(cmd_list);
    }
  } else {
    renodx::mods::swapchain::DiscardDescriptors(cmd_list);
  }

  return false;
}

bool OnDraw(reshade::api::command_list* cmd_list, uint32_t vertex_count,
            uint32_t instance_count, uint32_t first_vertex, uint32_t first_instance) {
  return HandlePreDraw(cmd_list);
}

bool OnDrawIndexed(reshade::api::command_list* cmd_list, uint32_t index_count,
                   uint32_t instance_count, uint32_t first_index, int32_t vertex_offset, uint32_t first_instance) {
  return HandlePreDraw(cmd_list);
}

bool OnDrawOrDispatchIndirect(reshade::api::command_list* cmd_list, reshade::api::indirect_command type,
                              reshade::api::resource buffer, uint64_t offset, uint32_t draw_count, uint32_t stride) {
  return HandlePreDraw(cmd_list);
}

bool OnDispatch(reshade::api::command_list* cmd_list,
                uint32_t group_count_x, uint32_t group_count_y, uint32_t group_count_z) {
  return HandlePreDraw(cmd_list, true);
}

auto timestamp_start = std::chrono::steady_clock::now();

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto timestamp_end = std::chrono::steady_clock::now();
  auto delta = timestamp_end - timestamp_start;
  shader_injection.elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(delta).count();
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Starfield";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  if (fdw_reason == DLL_PROCESS_ATTACH && !reshade::register_addon(h_module)) return FALSE;

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::mods::shader::allow_multiple_push_constants = true;
      // renodx::mods::shader::expected_constant_buffer_index = 3;
      renodx::mods::shader::expected_constant_buffer_space = 9;
      renodx::mods::swapchain::use_resource_cloning = true;
      // renodx::mods::swapchain::use_resize_buffer = true;
      // renodx::mods::swapchain::use_resize_bufferOnSetFullScreen = true;
      renodx::mods::swapchain::prevent_full_screen = true;

      // RGBA8 Resource pool
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .index = 0,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = false,
      });

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          // .ignore_size = true,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r16g16b16a16_typeless,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
      });
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  renodx::utils::shader::Use(fdw_reason);
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::draw>(OnDraw);
    reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
    reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDrawOrDispatchIndirect);
    reshade::register_event<reshade::addon_event::dispatch>(OnDispatch);
    reshade::register_event<reshade::addon_event::present>(OnPresent);
  }

  return TRUE;
}
