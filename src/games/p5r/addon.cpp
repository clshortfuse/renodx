/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0
// #define DEBUG_LEVEL_1
// #define DEBUG_LEVEL_2

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/0xB6E26AC7.h>
#include <embed/0xDE5120BF.h>

#include <embed/0x0D85D1F6.h>
#include <embed/0xC6D14699.h>

#include <embed/0x060C3E22.h>
#include <embed/0x23A501DC.h>
#include <embed/0x2944B564.h>
#include <embed/0x3C2773E3.h>
#include <embed/0x4016ED43.h>
#include <embed/0x5C4DD977.h>
#include <embed/0x7C0751EF.h>
#include <embed/0x960502CC.h>
#include <embed/0xAB823647.h>
#include <embed/0xCC71BBE3.h>
#include <embed/0xCF70BF33.h>
#include <embed/0xD434C03A.h>
#include <embed/0xE126DD24.h>
#include <embed/0xEBBDB212.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xB6E26AC7),
    CustomShaderEntry(0xDE5120BF),

    CustomShaderEntry(0x0D85D1F6),
    CustomShaderEntry(0xC6D14699),

    CustomShaderEntry(0x060C3E22),
    CustomShaderEntry(0x23A501DC),
    CustomShaderEntry(0x2944B564),
    CustomShaderEntry(0x3C2773E3),
    CustomShaderEntry(0x4016ED43),
    CustomShaderEntry(0x5C4DD977),
    CustomShaderEntry(0x7C0751EF),
    CustomShaderEntry(0x960502CC),
    CustomShaderEntry(0xAB823647),
    CustomShaderEntry(0xCC71BBE3),
    CustomShaderEntry(0xCF70BF33),
    CustomShaderEntry(0xD434C03A),
    CustomShaderEntry(0xE126DD24),
    CustomShaderEntry(0xEBBDB212),
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
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .can_reset = false,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
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
        .key = "colorGradeColorSpace",
        .binding = &shader_injection.colorGradeColorSpace,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = false,
        .label = "Color Space",
        .section = "Color Grading",
        .tooltip = "Selects color space gamut when clamping",
        .labels = {"None", "BT709", "BT2020", "AP1"},
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
  renodx::utils::settings::UpdateSetting("colorGradeColorSpace", 1.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
}

struct __declspec(uuid("5958c7c4-19b2-4300-af4d-c6802d6c7635")) DeviceData {
  std::shared_mutex mutex;
  reshade::api::pipeline min_alpha_pipeline = {0};
  reshade::api::pipeline max_alpha_pipeline = {0};
  reshade::api::pipeline_layout injection_layout = {0};
  std::unordered_set<uint64_t> unsafe_blend_pipelines;
};

struct __declspec(uuid("452ac839-081c-4891-9880-8533c0a63666")) CommandListData {
  reshade::api::pipeline last_output_merger;
};

void OnInitDevice(reshade::api::device* device) {
  device->create_private_data<DeviceData>();
}

void OnDestroyDevice(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

bool g_completed_render = false;

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  g_completed_render = false;
}

std::unordered_set<uint32_t> g_8bit_hashes = {
    0x060C3E22,
    0x23A501DC,
    0x2944b564,
    0x3C2773E3,
    0x4016ED43,
    0x5C4DD977,
    0x7C0751EF,
    0x960502CC,
    0xAB823647,
    0xB6E26AC7,
    0xCC71BBE3,
    0xCF70BF33,
    0xD434C03A,
    0xE126DD24,
    0xEBBDB212,
};

void PushConstants(reshade::api::command_list* cmd_list, reshade::api::pipeline_layout layout) {
  static const float shader_injection_size = sizeof(shader_injection) / sizeof(uint32_t);
  cmd_list->push_constants(
      reshade::api::shader_stage::all_graphics,  // Used by reshade to specify graphics or compute
      layout,
      0,
      0,
      shader_injection_size,
      &shader_injection);
}

bool OnDrawIndexed(
    reshade::api::command_list* cmd_list,
    uint32_t index_count,
    uint32_t instance_count,
    uint32_t first_index,
    int32_t vertex_offset,
    uint32_t first_instance) {
  if (shader_injection.colorGradeLUTScaling == 0.f) return false;
  auto& command_list_data = cmd_list->get_private_data<CommandListData>();
  if (command_list_data.last_output_merger.handle == 0) return false;

  auto& shader_state = cmd_list->get_private_data<renodx::utils::shader::CommandListData>();

  if (shader_state.pixel_shader_hash == 0xC6D14699) return false;  // Video
  if (shader_state.pixel_shader_hash == 0xB6E26AC7) {
    g_completed_render = true;
    return false;
  }
  if (!g_completed_render) return false;
  if (!g_8bit_hashes.contains(shader_state.pixel_shader_hash)) return false;

  auto& swapchain_state = cmd_list->get_private_data<renodx::utils::swapchain::CommandListData>();

  if (swapchain_state.current_render_targets.empty()) return false;
  const auto target0 = swapchain_state.current_render_targets[0];

  auto* device = cmd_list->get_device();

  auto resource_tag = renodx::utils::resource::GetResourceTag(device, target0);
  if (resource_tag != 1.f) return false;

  auto& data = device->get_private_data<DeviceData>();
  std::shared_lock read_only_lock(data.mutex);
  if (data.unsafe_blend_pipelines.contains(command_list_data.last_output_merger.handle)) {
    if (data.min_alpha_pipeline.handle == 0) {
      reshade::api::blend_desc blend_desc = {};
      blend_desc.blend_enable[0] = true;
      blend_desc.alpha_blend_op[0] = reshade::api::blend_op::min;
      blend_desc.render_target_write_mask[0] = 0x8;

      auto subobjects = reshade::api::pipeline_subobject{
          .type = reshade::api::pipeline_subobject_type::blend_state,
          .count = 1,
          .data = &blend_desc,
      };

      read_only_lock.unlock();
      {
        const std::unique_lock lock(data.mutex);
        device->create_pipeline({0xFFFFFFFFFFFFFFFF}, 1, &subobjects, &data.min_alpha_pipeline);
      }
      read_only_lock.lock();
    }

    if (data.max_alpha_pipeline.handle == 0) {
      reshade::api::blend_desc blend_desc = {};
      blend_desc.blend_enable[0] = true;
      blend_desc.alpha_blend_op[0] = reshade::api::blend_op::max;
      blend_desc.render_target_write_mask[0] = 0x8;
      auto subobjects = reshade::api::pipeline_subobject{
          .type = reshade::api::pipeline_subobject_type::blend_state,
          .count = 1,
          .data = &blend_desc,
      };

      read_only_lock.unlock();
      {
        const std::unique_lock lock(data.mutex);
        device->create_pipeline({0xFFFFFFFFFFFFFFFF}, 1, &subobjects, &data.max_alpha_pipeline);
      }
      read_only_lock.lock();
    }

    if (data.injection_layout.handle == 0) {
      auto& shader_replace_device_data = device->get_private_data<renodx::mods::shader::DeviceData>();
      const std::shared_lock lock(shader_replace_device_data.mutex);
      if (
          auto pair = shader_replace_device_data.modded_pipeline_layouts.find(0xFFFFFFFFFFFFFFFF);
          pair != shader_replace_device_data.modded_pipeline_layouts.end()) {
        read_only_lock.unlock();
        {
          const std::unique_lock lock(data.mutex);
          data.injection_layout = pair->second;
        }
        read_only_lock.lock();
      } else {
        return false;
      }
    }

    cmd_list->bind_render_targets_and_depth_stencil(
        swapchain_state.current_render_targets.size(),
        swapchain_state.current_render_targets.data(),
        {0});

    shader_injection.clampState = CLAMP_STATE__MIN_ALPHA;
    PushConstants(cmd_list, data.injection_layout);
    cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, data.min_alpha_pipeline);
    cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);

    shader_injection.clampState = CLAMP_STATE__MAX_ALPHA;
    PushConstants(cmd_list, data.injection_layout);
    cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, data.max_alpha_pipeline);
    cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);
    cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, command_list_data.last_output_merger);
    cmd_list->bind_render_targets_and_depth_stencil(
        swapchain_state.current_render_targets.size(),
        swapchain_state.current_render_targets.data(),
        swapchain_state.current_depth_stencil);
  }

  shader_injection.clampState = CLAMP_STATE__OUTPUT;
  PushConstants(cmd_list, data.injection_layout);
  cmd_list->draw_indexed(index_count, instance_count, first_index, vertex_offset, first_instance);
  shader_injection.clampState = CLAMP_STATE__NONE;

  return true;
}

// After CreatePipelineState
void OnInitPipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects,
    reshade::api::pipeline pipeline) {
  bool unsafe = false;
  for (uint32_t i = 0; i < subobject_count; ++i) {
    if (unsafe) break;

    const auto& subobject = subobjects[i];
    if (subobject.type != reshade::api::pipeline_subobject_type::blend_state) continue;
    for (uint32_t j = 0; j < subobject.count; ++j) {
      auto& desc = static_cast<reshade::api::blend_desc*>(subobject.data)[j];
      if (!desc.blend_enable[0]) continue;

      if (((desc.render_target_write_mask[0] & 0x1) != 0)
          || ((desc.render_target_write_mask[0] & 0x2) != 0)
          || ((desc.render_target_write_mask[0] & 0x4) != 0)) {
        if (desc.color_blend_op[0] != reshade::api::blend_op::min
            && desc.color_blend_op[0] != reshade::api::blend_op::max) {
          if (
              desc.source_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
              || desc.source_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
              || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::dest_alpha
              || desc.dest_color_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha) {
            unsafe = true;
            break;
          }
        }
      }
      if ((desc.render_target_write_mask[0] & 0x8) != 0) {
        if (desc.alpha_blend_op[0] == reshade::api::blend_op::min
            || desc.alpha_blend_op[0] == reshade::api::blend_op::max) {
          unsafe = true;
          break;
        }
        if (
            desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.source_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::dest_alpha
            || desc.dest_alpha_blend_factor[0] == reshade::api::blend_factor::one_minus_dest_alpha) {
          unsafe = true;
          break;
        }
      }
    }
  }
  if (unsafe) {
    auto& data = device->get_private_data<DeviceData>();
    const std::unique_lock lock(data.mutex);
    data.unsafe_blend_pipelines.emplace(pipeline.handle);
  }
}

void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage type,
    reshade::api::pipeline pipeline) {
  if (type != reshade::api::pipeline_stage::output_merger) return;
  auto& data = cmd_list->get_private_data<CommandListData>();
  data.last_output_merger = pipeline;
}

void OnDestroyPipeline(
    reshade::api::device* device,
    reshade::api::pipeline pipeline) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  data.unsafe_blend_pipelines.erase(pipeline.handle);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Persona 5 Royal";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

      renodx::mods::shader::expected_constant_buffer_index = 7u;

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
          .aspect_ratio = 16.f / 9.f,
      });

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r10g10b10a2_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .aspect_ratio = 16.f / 9.f,
          .resource_tag = 1.f,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .resource_tag = 1.f,
      });

      shader_injection.clampState = CLAMP_STATE__NONE;

      if (!reshade::register_addon(h_module)) return FALSE;
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
      reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
      reshade::register_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::shader::Use(fdw_reason);  // First to trace
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  if (fdw_reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
    reshade::register_event<reshade::addon_event::present>(OnPresent);
  }
  return TRUE;
}
