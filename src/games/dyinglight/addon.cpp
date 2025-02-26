/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

// #include <embed/0x9165A474.h> // black smoke
// #include <embed/0xEC3D14D2.h> // distant fog/smoke
// #include <embed/0x32A56036.h> // distant fog/smoke
// #include <embed/0x372AEE4E.h> // black smoke
// #include <embed/0xAB16B3F7.h> // fire
// #include <embed/0xB561688F.h> // distant smoke?
// #include <embed/0x1FB36E90.h> // screen blood effect
#include <embed/0x61D242D6.h>    // bloom
// #include <embed/0XBA89E3AC.h> // lens flare - sunstar
#include <embed/0x3F53E66E.h>    // lens flare - circles and color
// #include <embed/0x95588EA5.h> // radial dirty lens effect
// #include <embed/0x8135BEA2.h> // radial lens flare
#include <embed/0xA6EC1DEC.h>    // god rays
#include <embed/0xA67ABF78.h>    // tonemap
// #include <embed/0x11737C11.h> // debris and other effects?
#include <embed/0x372BEBAB.h>    // LUT 1 (only used in title screen?)
// #include <embed/0xED9872EB.h> // AA?
#include <embed/0xC20255E1.h>    // LUT 2a - Film Grain
#include <embed/0xD42BAD58.h>    // LUT 2b - No Film Grain
#include <embed/0x45D95DCB.h>    // LUT 2c - B&W Film Grain
#include <embed/0xBA423838.h>    // LUT 2d - B&W No Film Grain
#include <embed/0x8194877A.h>    // caps brightness
#include <embed/0x558540C8.h>    // Gamma adjust
// #include <embed/0x548937E1.h>    // UI - loading screen
// #include <embed/0x404A04C7.h>    // UI - highlighted stuff, orange elements
// #include <embed/0xBCBEE1E5.h>    // UI - text
// #include <embed/0xDC15A986.h>    // UI - Alpha, semitransparent UI boxes, quit overlay
// #include <embed/0x6562755C.h>    // UI - Alpha, some text
// #include <embed/0xB917BF4E.h>    // UI - HUD, nav arrows, sliders, some icons, text boxes
// #include <embed/0x7E8358E3.h>    // UI - HUD numbers
// #include <embed/0x929C8CA5.h>    // UI - Minimap
// #include <embed/0x4D09799F.h>    // UI - HUD Floating markers
// #include <embed/0x9F9A6B19.h>    // UI - Menu tab bar
// #include <embed/0xD292312D.h>    // UI - ?
// #include <embed/0x822D56FA.h>    // UI - Menu blur
// #include <embed/0x23EFA382.h>    // UI - Images
// #include <embed/0x7D5191F6.h>    // UI - Loading please wait
// #include <embed/0x637A1F5C.h>    // UI - popup notification
// #include <embed/0x379D46ED.h>    // UI - Death screen images

#include <embed/0xFFFFFFFD.h> // Custom final VS
#include <embed/0xFFFFFFFE.h> // Custom final PS

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x1FB36E90),       // screen blood effect
    CustomShaderEntry(0x61D242D6),          // bloom
    CustomShaderEntry(0x3F53E66E),          // lens flare - circles and color
    // CustomShaderEntry(0x95588EA5),       // radial dirty lens effect
    // CustomShaderEntry(0x8135BEA2),       // radial lens flare
    CustomShaderEntry(0xA6EC1DEC),          // god rays
    CustomShaderEntry(0xA67ABF78),          // tonemap
    // CustomShaderEntry(0x11737C11),       // debris and other effects?
    CustomShaderEntry(0x372BEBAB),          // LUT 1
    // CustomShaderEntry(0xED9872EB),       // AA?
    CustomShaderEntry(0xC20255E1),          // LUT 2a - Film Grain
    CustomShaderEntry(0xD42BAD58),          // LUT 2b - No Film Grain
    CustomShaderEntry(0x45D95DCB),          // LUT 2c - B&W Film Grain
    CustomShaderEntry(0xBA423838),          // LUT 2d - B&W No Film Grain
    CustomShaderEntry(0x8194877A),          // caps brightness
    CustomSwapchainShader(0x558540C8),      // Gamma adjust

    // CustomSwapchainShader(0x548937E1),      // UI - loading screen
    // CustomSwapchainShader(0x404A04C7),      // UI - highlighted stuff, orange elements
    // CustomSwapchainShader(0xBCBEE1E5),      // UI - text
    // CustomSwapchainShader(0xDC15A986),      // UI - Alpha, semitransparent UI boxes, quit overlay
    // CustomSwapchainShader(0x6562755C),      // UI - Alpha, some text
    // CustomSwapchainShader(0xB917BF4E),      // UI - HUD, nav arrows, slider outlines, some icons, some text boxes
    // CustomSwapchainShader(0x7E8358E3),      // UI - HUD numbers
    // CustomSwapchainShader(0x929C8CA5),      // UI - Minimap  
    // CustomShaderEntry(0x4D09799F),      // UI - HUD Floating markers
    // CustomSwapchainShader(0x9F9A6B19),      // UI - Menu tab bar
    // CustomSwapchainShader(0xD292312D),      // UI - ?
    // CustomSwapchainShader(0x822D56FA),      // UI - Menu blur
    // // CustomSwapchainShader(0x03554D47),      // UI - Menu background - breaks alpha
    // CustomSwapchainShader(0x23EFA382),      // UI - Images
    // CustomSwapchainShader(0x7D5191F6),      // UI - Loading please wait
    // CustomSwapchainShader(0x637A1F5C),      // UI - popup notification
    // CustomSwapchainShader(0x379D46ED),      // UI - Death screen images
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 4.f,
        .can_reset = false,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "Vanilla+ (DICE)"},
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
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .can_reset = false,
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
        .default_value = 1.f,
        .can_reset = false,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a 2.2 EOTF (use with HDR or sRGB)",
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 50.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates hue shifting from the vanilla tonemapper",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 10.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTStrength",
        .binding = &shader_injection.colorGradeLUTStrength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType != 1; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeGamutExpansion",
        .binding = &shader_injection.colorGradeGamutExpansion,
        .default_value = 0.f,
        .label = "Gamut Expansion",
        .section = "Color Grading",
        .tooltip = "Generates HDR colors (BT.2020) from bright saturated SDR (BT.709) ones.",   // Description taken from pumboautohdr
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 2; },
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
        .key = "fxLensFlare",
        .binding = &shader_injection.fxLensFlare,
        .default_value = 50.f,
        .label = "Lens Flare",
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
  renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 100);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeBlowout", 0.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxLensFlare", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
}

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Dying Light";

// NOLINTEND(readability-identifier-naming)

// Begin custom final copy pasta [ty Ersh/FF14]
struct __declspec(uuid("1228220F-364A-46A2-BB29-1CCE591A018A")) DeviceData {
  reshade::api::effect_runtime* main_runtime = nullptr;
  std::atomic_bool rendered_effects = false;
  std::vector<reshade::api::resource_view> swapchain_rtvs;
  reshade::api::pipeline final_pipeline = {};
  reshade::api::resource final_texture = {};
  reshade::api::resource_view final_texture_view = {};
  reshade::api::sampler final_texture_sampler = {};
  reshade::api::pipeline_layout final_layout = {};
  reshade::api::pipeline_layout copy_layout = {};
};

constexpr reshade::api::pipeline_layout PIPELINE_LAYOUT{0};

void OnInitDevice(reshade::api::device* device) {
  auto* data = device->create_private_data<DeviceData>();

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

    device->create_pipeline(PIPELINE_LAYOUT, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &data->final_pipeline);
  }

  // create layout
  {
    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    new_params.push_constants.count = 1;
    new_params.push_constants.dx_register_index = 13;
    new_params.push_constants.visibility = reshade::api::shader_stage::vertex | reshade::api::shader_stage::pixel | reshade::api::shader_stage::compute;
    device->create_pipeline_layout(1, &new_params, &data->final_layout);
  }

  {
    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    new_params.push_constants.count = 1;
    new_params.push_constants.dx_register_index = 12;
    new_params.push_constants.visibility = reshade::api::shader_stage::vertex | reshade::api::shader_stage::pixel | reshade::api::shader_stage::compute;
    device->create_pipeline_layout(1, &new_params, &data->copy_layout);
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  auto* data = device->get_private_data<DeviceData>();

  device->destroy_pipeline(data->final_pipeline);
  device->destroy_pipeline_layout(data->final_layout);

  device->destroy_private_data<DeviceData>();
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto device = swapchain->get_device();
  auto* data = device->get_private_data<DeviceData>();

  for (int i = 0; i < swapchain->get_back_buffer_count(); ++i) {
    auto back_buffer_resource = swapchain->get_back_buffer(i);
    auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);
    auto desc = reshade::api::resource_view_desc(reshade::api::resource_view_type::texture_2d, reshade::api::format_to_default_typed(back_buffer_desc.texture.format), 0, 1, 0, 1);
    device->create_resource_view(back_buffer_resource, reshade::api::resource_usage::render_target, desc, &data->swapchain_rtvs.emplace_back());
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
    device->create_resource(desc, nullptr, reshade::api::resource_usage::shader_resource, &data->final_texture);
    device->create_resource_view(data->final_texture, reshade::api::resource_usage::shader_resource, reshade::api::resource_view_desc(reshade::api::format_to_default_typed(desc.texture.format)), &data->final_texture_view);
    device->create_sampler({}, &data->final_texture_sampler);
  }
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto device = swapchain->get_device();
  auto* data = device->get_private_data<DeviceData>();

  for (const auto& rtv : data->swapchain_rtvs) {
    device->destroy_resource_view(rtv);
  }

  data->swapchain_rtvs.clear();

  device->destroy_sampler(data->final_texture_sampler);
  device->destroy_resource_view(data->final_texture_view);
  device->destroy_resource(data->final_texture);
}

// more or less the same as what reshade does to render its techniques
void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  auto device = queue->get_device();
  auto cmd_list = queue->get_immediate_command_list();

  auto* data = device->get_private_data<DeviceData>();

  auto back_buffer_resource = swapchain->get_current_back_buffer();
  auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);

  // copy backbuffer
  {
    const reshade::api::resource resources[2] = {back_buffer_resource, data->final_texture};
    const reshade::api::resource_usage state_old[2] = {reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource};
    const reshade::api::resource_usage state_new[2] = {reshade::api::resource_usage::copy_source, reshade::api::resource_usage::copy_dest};

    cmd_list->barrier(2, resources, state_old, state_new);
    cmd_list->copy_texture_region(back_buffer_resource, 0, nullptr, data->final_texture, 0, nullptr);
    cmd_list->barrier(2, resources, state_new, state_old);
  }

  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, data->final_pipeline);

  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::shader_resource, reshade::api::resource_usage::render_target);

  reshade::api::render_pass_render_target_desc render_target = {};
  render_target.view = data->swapchain_rtvs.at(swapchain->get_current_back_buffer_index());
  cmd_list->begin_render_pass(1, &render_target, nullptr);

  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::texture_shader_resource_view, &data->final_texture_view});
  cmd_list->push_descriptors(reshade::api::shader_stage::all_graphics, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::sampler, &data->final_texture_sampler});

  // push the renodx settings
  cmd_list->push_constants(reshade::api::shader_stage::all_graphics, data->final_layout, 0, 0, sizeof(shader_injection) / 4, &shader_injection);

  const reshade::api::viewport viewport = {
      0.0f, 0.0f,
      static_cast<float>(back_buffer_desc.texture.width),
      static_cast<float>(back_buffer_desc.texture.height),
      0.0f, 1.0f};
  cmd_list->bind_viewports(0, 1, &viewport);

  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();

  cmd_list->barrier(back_buffer_resource, reshade::api::resource_usage::render_target, reshade::api::resource_usage::shader_resource);

  // reset the copy tracker, entirely unrelated to the final shader above
  //track_next_copy = false; // We dont need this, just pasted from FF14 code
  //shader_injection.copyTracker = 0; // We dont need this, just pasted from FF14 code
}
// End custom final copy pasta

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

    //   renodx::mods::shader::force_pipeline_cloning = true;
    //   renodx::mods::shader::trace_unmodified_shaders = true;
      renodx::mods::swapchain::force_borderless = false;
    //   renodx::mods::swapchain::prevent_full_screen = true;

     //final shader copy pasta start
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
     //final shader copy pasta end

      for (auto index : {3, 4}) {
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_typeless,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .index = index,
        });
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  renodx::mods::swapchain::Use(fdw_reason);

  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}