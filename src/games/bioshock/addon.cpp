/*
 * Copyright (C) 2024 Filippo Tarpini
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0xEC834D82.h>
#include <embed/0x6457104F.h>
#include <embed/0xDAA8E1E9.h>
#include <embed/0x0C454543.h>
#include <embed/0x3F8A5A79.h>
#include <embed/0x64B4F8D8.h>
#include <embed/0x21303C74.h>
#include <embed/0x63693A7F.h>

#include <embed/0xFFFFFFFD.h>  // Custom final VS
#include <embed/0xFFFFFFFE.h>  // Custom final PS

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xEC834D82),
    CustomShaderEntry(0x6457104F),
    CustomShaderEntry(0xDAA8E1E9),
    CustomShaderEntry(0x0C454543),
    CustomShaderEntry(0x3F8A5A79),
    CustomShaderEntry(0x64B4F8D8),
    CustomShaderEntry(0x21303C74),
    CustomShaderEntry(0x63693A7F),
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "peakWhiteNits",
        .binding = &shader_injection.peakWhiteNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Display Mapping",
        .tooltip = "Sets the value of peak white in nits (match it to your display's peak white)",
        .min = 400.f,
        .max = 10000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "paperWhiteNits",
        .binding = &shader_injection.paperWhiteNits,
        .default_value = 203.f,
        .can_reset = true,
        .label = "Paper White Brightness",
        .section = "Display Mapping",
        .tooltip = "Sets the value of paper white in nits",
        .min = 80.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "BloomAmount",
        .binding = &shader_injection.BloomAmount,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Bloom Amount",
        .section = "FX",
        .tooltip = "Game's default bloom shader amount",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "FogAmount",
        .binding = &shader_injection.FogAmount,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Fog Amount",
        .section = "FX",
        .tooltip = "Game's default fog shader amount",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          static const std::string obfuscated_link = std::string("start https://discord.gg/J9fM") + std::string("3EVuEZ");
          system(obfuscated_link.c_str());
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
}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

// NOTE: Bioshock is x32 not x64
extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for BioShock (Remastered)";

// NOLINTEND(readability-identifier-naming)

// Final shader [ty Ersh/FF14]
struct __declspec(uuid("1228220F-364A-46A2-BB29-1CCE591A018A")) DeviceData {
  reshade::api::effect_runtime* main_runtime = nullptr;
  std::atomic_bool rendered_effects = false;
  std::vector<reshade::api::resource_view> swapchain_rtvs;
  reshade::api::pipeline final_pipeline = {};
  reshade::api::resource final_texture = {};
  reshade::api::resource_view final_texture_view = {};
  reshade::api::sampler final_texture_sampler = {};
  reshade::api::pipeline_layout final_layout = {};
};

constexpr reshade::api::pipeline_layout PIPELINE_LAYOUT{0};

void OnInitDevice(reshade::api::device* device) {
  auto& data = device->create_private_data<DeviceData>();

  // create pipeline
  {
    std::vector<reshade::api::pipeline_subobject> subobjects;

    reshade::api::shader_desc vs_desc = {};
    vs_desc.code = __0xFFFFFFFD.begin();
    vs_desc.code_size = __0xFFFFFFFD.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::vertex_shader, 1, &vs_desc});

    reshade::api::shader_desc ps_desc = {};
    ps_desc.code = __0xFFFFFFFE.begin();
    ps_desc.code_size = __0xFFFFFFFE.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::pixel_shader, 1, &ps_desc});

    reshade::api::format format = reshade::api::format::r16g16b16a16_float;
    subobjects.push_back({reshade::api::pipeline_subobject_type::render_target_formats, 1, &format});

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

    device->create_pipeline(PIPELINE_LAYOUT, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &data.final_pipeline);
  }

  // create layout
  {
    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    new_params.push_constants.count = 1;
    new_params.push_constants.dx_register_index = 13;
    new_params.push_constants.visibility = reshade::api::shader_stage::vertex | reshade::api::shader_stage::pixel | reshade::api::shader_stage::compute;
    device->create_pipeline_layout(1, &new_params, &data.final_layout);
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  auto& data = device->get_private_data<DeviceData>();

  device->destroy_pipeline(data.final_pipeline);
  device->destroy_pipeline_layout(data.final_layout);

  device->destroy_private_data<DeviceData>();
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto device = swapchain->get_device();
  auto& data = device->get_private_data<DeviceData>();

  if (!fired_on_init_swapchain) {
    fired_on_init_swapchain = true;
    auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
    if (peak.has_value()) {
      settings[0]->default_value = peak.value();
      settings[0]->can_reset = true;
    }
  }

  for (int i = 0; i < swapchain->get_back_buffer_count(); ++i) {
    auto back_buffer_resource = swapchain->get_back_buffer(i);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    auto desc = reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, reshade::api::format_to_default_typed(back_buffer_desc.texture.format), 0, 1, 0, 1);
    device->create_resource_view(back_buffer_resource, reshade::api::resource_usage::render_target, desc, &data.swapchain_rtvs.emplace_back());
  }

  // create copy target
  {
    auto back_buffer_resource = swapchain->get_back_buffer(0);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    reshade::api::resource_desc desc = {};
    desc.type = reshade::api::resource_type::texture_2d;
    desc.texture = {
        back_buffer_desc.texture.width,
        back_buffer_desc.texture.height,
        1,
        1,
        reshade::api::format_to_typeless(back_buffer_desc.texture.format),
        1,
    };
    desc.heap = reshade::api::memory_heap::gpu_only;
    desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
    desc.flags = reshade::api::resource_flags::none;
    device->create_resource(desc, nullptr, reshade::api::resource_usage::shader_resource, &data.final_texture);
    device->create_resource_view(data.final_texture, reshade::api::resource_usage::shader_resource, reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format)), &data.final_texture_view);
    device->create_sampler({}, &data.final_texture_sampler);
  }
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto device = swapchain->get_device();
  auto& data = device->get_private_data<DeviceData>();

  for (const auto& rtv : data.swapchain_rtvs) {
    device->destroy_resource_view(rtv);
  }

  data.swapchain_rtvs.clear();

  device->destroy_sampler(data.final_texture_sampler);
  device->destroy_resource_view(data.final_texture_view);
  device->destroy_resource(data.final_texture);
}

// more or less the same as what reshade does to render its techniques
void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  auto device = queue->get_device();
  auto cmd_list = queue->get_immediate_command_list();

  auto& data = device->get_private_data<DeviceData>();

  auto back_buffer_resource = swapchain->get_current_back_buffer();
  auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);

  // copy backbuffer
  {
    const reshade::api::resource resources[2] = {back_buffer_resource, data.final_texture};
    const reshade::api::resource_usage state_old[2] = {reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource};
    const reshade::api::resource_usage state_new[2] = {reshade::api::resource_usage::copy_source, reshade::api::resource_usage::copy_dest};

    cmd_list->barrier(2, resources, state_old, state_new);
    cmd_list->copy_texture_region(back_buffer_resource, 0, nullptr, data.final_texture, 0, nullptr);
    cmd_list->barrier(2, resources, state_new, state_old);
  }

  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, data.final_pipeline);

  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::render_target);

  reshade::api::render_pass_render_target_desc render_target = {};
  render_target.view = data.swapchain_rtvs.at(swapchain->get_current_back_buffer_index());
  cmd_list->begin_render_pass(1, &render_target, nullptr);

  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::texture_shader_resource_view, &data.final_texture_view});
  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::sampler, &data.final_texture_sampler});

  // push the renodx settings
  cmd_list->push_constants(reshade::api::shader_stage::all_graphics, data.final_layout, 0, 0, sizeof(shader_injection) / 4, &shader_injection);

  const reshade::api::viewport viewport = {
      0.0f, 0.0f,
      static_cast<float>(back_buffer_desc.texture.width),
      static_cast<float>(back_buffer_desc.texture.height),
      0.0f, 1.0f};
  cmd_list->bind_viewports(0, 1, &viewport);

  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();

  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource);
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 13;

      renodx::mods::swapchain::force_borderless = false;

      renodx::utils::settings::use_presets = false;

      // Final shader
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      
      // TODO: figure out why this doesn't work, most of the scene rendering is still R11G11B10F (does it have a different size from the swapchain?)
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r11g11b10_float,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
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

  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::mods::swapchain::Use(fdw_reason);

  return TRUE;
}
