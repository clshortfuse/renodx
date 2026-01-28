/*
 * Copyright (C) 2024 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <d3d10_1.h>
#include <array>

#pragma comment(lib, "d3d10.lib")

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "Neutwo"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
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
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 0.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 50.f,
        .label = "Blowout",
        .section = "Tone Mapping",
        .tooltip = "Emulates blowout from per channel tonemapping",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 55.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeDechroma",
        .binding = &shader_injection.tone_map_dechroma,
        .default_value = 0.f,
        .label = "Dechroma",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0 && shader_injection.tone_map_type != 3; },
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
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.scene_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Selects the strength of the game's custom scene grading.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSceneScaling",
        .binding = &shader_injection.color_grade_scaling,
        .default_value = 100.f,
        .label = "Scene Grading Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the scene grading to full range when size is clamped.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxBloom",
        .binding = &shader_injection.custom_bloom,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Effects",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxGrainType",
        .binding = &shader_injection.custom_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Grain Type",
        .section = "Effects",
        .tooltip = "Replaces vanilla film grain with perceptual",
        .labels = {"Vanilla", "Perceptual"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 0.f,
        .label = "FilmGrain",
        .section = "Effects",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.custom_grain_type != 0; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/musaqh"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 203.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 203.f},
      {"GammaCorrection", 0},
      {"ToneMapHueShift", 0},
      {"ToneMapBlowout", 0.f},
      {"ToneMapWhiteClip", 0.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeDechroma", 0.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeScene", 100.f},
      {"ColorGradeSceneScaling", 0.f},
      {"FxBloom", 100.f},
      {"FxGrainType", 0.f},
      {"FxGrainStrength", 50.f},
  });
}

namespace revert_state {

struct D3D10StateBlock {
  ID3D10StateBlock* block = nullptr;

  void Capture(reshade::api::device* device) {
    if (device->get_api() != reshade::api::device_api::d3d10) return;
    auto* native_device = reinterpret_cast<ID3D10Device*>(device->get_native());
    D3D10_STATE_BLOCK_MASK state_block_mask = {};
    D3D10StateBlockMaskEnableAll(&state_block_mask);
    if (SUCCEEDED(D3D10CreateStateBlock(native_device, &state_block_mask, &block)) && block != nullptr) {
      block->Capture();
      return;
    }
    if (block != nullptr) {
      block->Release();
      block = nullptr;
    }
  }

  void Revert() {
    if (block == nullptr) return;
    block->Apply();
    block->Release();
    block = nullptr;
  }
};

}  // namespace revert_state

namespace final_pass {

struct __declspec(uuid("4c3b1f24-7d1f-4f32-9b31-7efecf0e8701")) FinalPassDeviceData {
  reshade::api::pipeline pipeline = {};
  reshade::api::pipeline_layout layout = {};
  reshade::api::format pipeline_format = reshade::api::format::unknown;
};

struct __declspec(uuid("8a2a2a44-36c9-4c38-9bdf-4a38e3c0c3aa")) FinalPassSwapchainData {
  std::vector<reshade::api::resource_view> swapchain_rtvs;
  reshade::api::resource final_texture = {};
  reshade::api::resource_view final_texture_view = {};
  reshade::api::sampler final_texture_sampler = {};
  reshade::api::descriptor_table sampler_table = {};
  reshade::api::descriptor_table srv_table = {};
};

void CreateFinalPassLayout(reshade::api::device* device, FinalPassDeviceData* data) {
  if (data->layout.handle != 0u) return;

  reshade::api::descriptor_range sampler_range = {};
  sampler_range.binding = 0;
  sampler_range.dx_register_index = 0;
  sampler_range.dx_register_space = 0;
  sampler_range.count = 1;
  sampler_range.visibility = reshade::api::shader_stage::all_graphics;
  sampler_range.type = reshade::api::descriptor_type::sampler;

  reshade::api::descriptor_range srv_range = {};
  srv_range.binding = 0;
  srv_range.dx_register_index = 0;
  srv_range.dx_register_space = 0;
  srv_range.count = 1;
  srv_range.visibility = reshade::api::shader_stage::all_graphics;
  srv_range.type = reshade::api::descriptor_type::texture_shader_resource_view;

  reshade::api::pipeline_layout_param param_sampler;
  param_sampler.type = reshade::api::pipeline_layout_param_type::descriptor_table;
  param_sampler.descriptor_table.count = 1;
  param_sampler.descriptor_table.ranges = &sampler_range;

  reshade::api::pipeline_layout_param param_srv;
  param_srv.type = reshade::api::pipeline_layout_param_type::descriptor_table;
  param_srv.descriptor_table.count = 1;
  param_srv.descriptor_table.ranges = &srv_range;

  reshade::api::pipeline_layout_param param_constants;
  param_constants.type = reshade::api::pipeline_layout_param_type::push_constants;
  if (device->get_api() == reshade::api::device_api::d3d12 || device->get_api() == reshade::api::device_api::vulkan) {
    param_constants.push_constants.count = sizeof(shader_injection) / sizeof(uint32_t);
  } else {
    param_constants.push_constants.count = 1;
  }

  int cb_index = renodx::mods::shader::expected_constant_buffer_index;
  if (cb_index == -1) cb_index = 13;
  param_constants.push_constants.dx_register_index = cb_index;
  param_constants.push_constants.dx_register_space = renodx::mods::shader::expected_constant_buffer_space;

  std::array<reshade::api::pipeline_layout_param, 3> params = {
      param_sampler,
      param_srv,
      param_constants,
  };
  device->create_pipeline_layout(static_cast<uint32_t>(params.size()), params.data(), &data->layout);
}

void EnsureFinalPassPipeline(reshade::api::device* device, FinalPassDeviceData* data, reshade::api::format format) {
  if (data->pipeline.handle != 0u && data->pipeline_format == format) return;

  if (data->pipeline.handle != 0u) {
    device->destroy_pipeline(data->pipeline);
    data->pipeline = {};
  }

  std::vector<reshade::api::pipeline_subobject> subobjects;

  reshade::api::shader_desc vs_desc = {};
  vs_desc.code = __swap_chain_proxy_vertex_shader.data();
  vs_desc.code_size = __swap_chain_proxy_vertex_shader.size();
  subobjects.push_back({reshade::api::pipeline_subobject_type::vertex_shader, 1, &vs_desc});

  reshade::api::shader_desc ps_desc = {};
  ps_desc.code = __swap_chain_proxy_pixel_shader.data();
  ps_desc.code_size = __swap_chain_proxy_pixel_shader.size();
  subobjects.push_back({reshade::api::pipeline_subobject_type::pixel_shader, 1, &ps_desc});

  auto pipeline_format = format;
  subobjects.push_back({reshade::api::pipeline_subobject_type::render_target_formats, 1, &pipeline_format});

  uint32_t num_vertices = 3;
  subobjects.push_back({reshade::api::pipeline_subobject_type::max_vertex_count, 1, &num_vertices});

  auto topology = reshade::api::primitive_topology::triangle_list;
  subobjects.push_back({reshade::api::pipeline_subobject_type::primitive_topology, 1, &topology});

  reshade::api::blend_desc blend_state = {};
  subobjects.push_back({reshade::api::pipeline_subobject_type::blend_state, 1, &blend_state});

  reshade::api::rasterizer_desc rasterizer_state = {};
  rasterizer_state.cull_mode = reshade::api::cull_mode::none;
  subobjects.push_back({reshade::api::pipeline_subobject_type::rasterizer_state, 1, &rasterizer_state});

  reshade::api::depth_stencil_desc depth_stencil_state = {};
  depth_stencil_state.depth_enable = false;
  depth_stencil_state.depth_write_mask = false;
  depth_stencil_state.depth_func = reshade::api::compare_op::always;
  depth_stencil_state.stencil_enable = false;
  depth_stencil_state.front_stencil_read_mask = 0xFF;
  depth_stencil_state.front_stencil_write_mask = 0xFF;
  depth_stencil_state.front_stencil_func = depth_stencil_state.back_stencil_func;
  depth_stencil_state.front_stencil_fail_op = depth_stencil_state.back_stencil_fail_op;
  depth_stencil_state.front_stencil_depth_fail_op = depth_stencil_state.back_stencil_depth_fail_op;
  depth_stencil_state.front_stencil_pass_op = depth_stencil_state.back_stencil_pass_op;
  depth_stencil_state.back_stencil_read_mask = 0xFF;
  depth_stencil_state.back_stencil_write_mask = 0xFF;
  depth_stencil_state.back_stencil_func = reshade::api::compare_op::always;
  depth_stencil_state.back_stencil_fail_op = reshade::api::stencil_op::keep;
  depth_stencil_state.back_stencil_depth_fail_op = reshade::api::stencil_op::keep;
  depth_stencil_state.back_stencil_pass_op = reshade::api::stencil_op::keep;
  subobjects.push_back({reshade::api::pipeline_subobject_type::depth_stencil_state, 1, &depth_stencil_state});

  reshade::api::pipeline pipeline = {};
  if (device->create_pipeline(data->layout, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &pipeline)) {
    data->pipeline = pipeline;
    data->pipeline_format = format;
  } else {
    data->pipeline = {};
    data->pipeline_format = reshade::api::format::unknown;
  }
}

void OnInitDevice(reshade::api::device* device) {
  auto* data = device->create_private_data<FinalPassDeviceData>();
  CreateFinalPassLayout(device, data);
}

void OnDestroyDevice(reshade::api::device* device) {
  auto* data = device->get_private_data<FinalPassDeviceData>();
  if (data == nullptr) return;
  if (data->pipeline.handle != 0u) device->destroy_pipeline(data->pipeline);
  if (data->layout.handle != 0u) device->destroy_pipeline_layout(data->layout);
  device->destroy_private_data<FinalPassDeviceData>();
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  auto* data = swapchain->get_private_data<FinalPassSwapchainData>();
  if (data == nullptr) return;

  for (const auto& rtv : data->swapchain_rtvs) {
    device->destroy_resource_view(rtv);
  }
  if (data->final_texture_sampler.handle != 0u) device->destroy_sampler(data->final_texture_sampler);
  if (data->final_texture_view.handle != 0u) device->destroy_resource_view(data->final_texture_view);
  if (data->final_texture.handle != 0u) device->destroy_resource(data->final_texture);
  if (data->sampler_table.handle != 0u) device->free_descriptor_table(data->sampler_table);
  if (data->srv_table.handle != 0u) device->free_descriptor_table(data->srv_table);

  swapchain->destroy_private_data<FinalPassSwapchainData>();
}

void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  auto* cmd_list = queue->get_immediate_command_list();

  auto* data = device->get_private_data<FinalPassDeviceData>();
  auto* swapchain_data = swapchain->get_private_data<FinalPassSwapchainData>();
  if (data == nullptr || swapchain_data == nullptr) return;

#if 1
  // Capture full D3D10 device state before our draw (ReShade tracking is partial).
  revert_state::D3D10StateBlock state_block;
  state_block.Capture(device);
#endif

  auto back_buffer_resource = swapchain->get_current_back_buffer();
  auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);

  EnsureFinalPassPipeline(device, data, back_buffer_desc.texture.format);
  if (data->pipeline.handle == 0u || data->layout.handle == 0u) return;

  // copy backbuffer
  {
    const reshade::api::resource resources[2] = {back_buffer_resource, swapchain_data->final_texture};
    const reshade::api::resource_usage state_old[2] = {reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource};
    const reshade::api::resource_usage state_new[2] = {reshade::api::resource_usage::copy_source, reshade::api::resource_usage::copy_dest};

    cmd_list->barrier(2, resources, state_old, state_new);
    cmd_list->copy_texture_region(back_buffer_resource, 0, nullptr, swapchain_data->final_texture, 0, nullptr);
    cmd_list->barrier(2, resources, state_new, state_old);
  }

  // Bind our final pass pipeline and target the current backbuffer.
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, data->pipeline);
  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::render_target);

  reshade::api::render_pass_render_target_desc render_target = {
      .view = swapchain_data->swapchain_rtvs.at(swapchain->get_current_back_buffer_index()),
  };
  cmd_list->begin_render_pass(1, &render_target, nullptr);

  // Bind sampler/SRV used by the final pass shader.
  const reshade::api::descriptor_table tables[] = {
      swapchain_data->sampler_table,
      swapchain_data->srv_table,
  };
  cmd_list->bind_descriptor_tables(
      reshade::api::shader_stage::all_graphics,
      data->layout,
      0,
      static_cast<uint32_t>(std::size(tables)),
      tables);

  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();

  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource);

#if 1
  // Restore state to exactly what the game had before our draw.
  state_block.Revert();
#endif
}

void InitSwapchainResources(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  auto* device_data = device->get_private_data<FinalPassDeviceData>();
  if (device_data == nullptr || device_data->layout.handle == 0u) return;
  auto* swapchain_data = swapchain->create_private_data<FinalPassSwapchainData>();
  if (swapchain_data == nullptr) return;

  for (uint32_t i = 0; i < swapchain->get_back_buffer_count(); ++i) {
    auto back_buffer_resource = swapchain->get_back_buffer(i);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    auto desc = reshade::api::resource_view_desc(
        reshade::api::resource_view_type::texture_2d,
        reshade::api::format_to_default_typed(back_buffer_desc.texture.format),
        0,
        1,
        0,
        1);
    device->create_resource_view(
        back_buffer_resource,
        reshade::api::resource_usage::render_target,
        desc,
        &swapchain_data->swapchain_rtvs.emplace_back());
  }

  {
    auto back_buffer_resource = swapchain->get_back_buffer(0);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    reshade::api::resource_desc desc = {};
    desc.type = reshade::api::resource_type::texture_2d;
    desc.texture = {
        .width = back_buffer_desc.texture.width,
        .height = back_buffer_desc.texture.height,
        .depth_or_layers = 1,
        .levels = 1,
        .format = reshade::api::format_to_typeless(back_buffer_desc.texture.format),
        .samples = 1,
    };
    desc.heap = reshade::api::memory_heap::gpu_only;
    desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
    desc.flags = reshade::api::resource_flags::none;

    device->create_resource(desc, nullptr, reshade::api::resource_usage::shader_resource, &swapchain_data->final_texture);
    device->create_resource_view(
        swapchain_data->final_texture,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format)),
        &swapchain_data->final_texture_view);
    device->create_sampler({}, &swapchain_data->final_texture_sampler);
  }

  if (swapchain_data->sampler_table.handle == 0u) {
    device->allocate_descriptor_table(device_data->layout, 0, &swapchain_data->sampler_table);
  }
  if (swapchain_data->srv_table.handle == 0u) {
    device->allocate_descriptor_table(device_data->layout, 1, &swapchain_data->srv_table);
  }

  reshade::api::descriptor_table_update updates[2] = {
      {
          .table = swapchain_data->sampler_table,
          .binding = 0,
          .array_offset = 0,
          .count = 1,
          .type = reshade::api::descriptor_type::sampler,
          .descriptors = &swapchain_data->final_texture_sampler,
      },
      {
          .table = swapchain_data->srv_table,
          .binding = 0,
          .array_offset = 0,
          .count = 1,
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
          .descriptors = &swapchain_data->final_texture_view,
      },
  };
  device->update_descriptor_tables(static_cast<uint32_t>(std::size(updates)), updates);
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  InitSwapchainResources(swapchain);
}

void RegisterEvents() {
  reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
  reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
  reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
  reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
  reshade::register_event<reshade::addon_event::present>(OnPresent);
}

void UnregisterEvents() {
  reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
  reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
  reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
  reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
  reshade::unregister_event<reshade::addon_event::present>(OnPresent);
}

}  // namespace final_pass

namespace bloom_upgrades {

// fractional bloom resolutions that need upgrading
constexpr std::pair<const char*, int> kBloomDivs[] = {
    {"BloomDiv4", 4},
    {"BloomDiv8", 8},
    {"BloomDiv16", 16},
    {"BloomDiv32", 32},
    {"BloomDiv64", 64},
};

void UpdateBloomTargets(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  auto* data = renodx::utils::data::Get<renodx::mods::swapchain::DeviceData>(device);
  if (!data) return;

  auto bb = device->get_resource_desc(swapchain->get_current_back_buffer());
  if (bb.type == reshade::api::resource_type::unknown) return;

  // apply per-divisor upgrades to matching bloom targets
  for (const auto& [name, div] : kBloomDivs) {
    for (auto& target : data->swap_chain_upgrade_targets) {
      if (target.name == name) {
        target.dimensions = {
            static_cast<int16_t>(bb.texture.width / div),
            static_cast<int16_t>(bb.texture.height / div),
            renodx::utils::resource::ResourceUpgradeInfo::ANY};
        break;
      }
    }
  }
}

void AddBloomTargets() {
  for (const auto& [name, _] : kBloomDivs) {
    renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        .old_format = reshade::api::format::r8g8b8a8_unorm,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .usage_include = reshade::api::resource_usage::render_target,
        .name = name,
    });
  }
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  UpdateBloomTargets(swapchain);
}

void RegisterEvents() {
  reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
}

void UnregisterEvents() {
  reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
}

}  // namespace bloom_upgrades

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!fired_on_init_swapchain) {
    fired_on_init_swapchain = true;
    auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
    if (peak.has_value()) {
      settings[1]->default_value = peak.value();
      settings[1]->can_reset = true;
    }
    bool was_upgraded = renodx::mods::swapchain::IsUpgraded(swapchain);
    if (was_upgraded) {
      settings[1]->default_value = 100.f;
    }
  }
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Assassin's Creed™: Director's Cut Edition";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;

        // renodx::mods::swapchain::use_resource_cloning = false;
        // renodx::mods::swapchain::swapchain_proxy_revert_state = true;

        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::revert_constant_buffer_ranges = true;

#if 1  // Render Target Upgrades

        // Main Render
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .dimensions = {.width = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER,
                           .height = renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER},
            .usage_include = reshade::api::resource_usage::render_target,
        });

        // Bloom
        bloom_upgrades::AddBloomTargets();

#endif

        initialized = true;
      }

      final_pass::RegisterEvents();
      bloom_upgrades::RegisterEvents();

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

      break;
    case DLL_PROCESS_DETACH:
      final_pass::UnregisterEvents();
      bloom_upgrades::UnregisterEvents();

      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // auto detect peak
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);  // film grain
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
