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

#include <source/com_ptr.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

ShaderInjectData shader_injection = {};
int executed_shader_count = 0;  // Counter for executed post-process shaders

bool UpdateTonemappedState(reshade::api::command_list* cmd_list) {
  ++executed_shader_count;

  // Value updates before shader is run,
  // so set `isTonemapped` to 1.f only after the second shader is found
  if (executed_shader_count >= 2) {
    shader_injection.isTonemapped = 1.f;
  }
  return true;  // Allow the shader to execute
}

void ResetShaderCount() {
  executed_shader_count = 0;            // Reset the counter
  shader_injection.isTonemapped = 0.f;  // Reset tonemapped state
}

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntryCallback(0x9D6291BC, &UpdateTonemappedState),  // Color grading LUT + fog + fade

    CustomShaderEntryCallback(0x08C91A0A, &UpdateTonemappedState),  // Fade shader
    CustomShaderEntryCallback(0x3F4881E9, &UpdateTonemappedState),  // Sepia filter
    CustomShaderEntryCallback(0xB103EAA6, &UpdateTonemappedState),  // Post process and gamma adjustment
    CustomShaderEntryCallback(0x7455FB8A, &UpdateTonemappedState),  // Vignette

    CustomShaderEntry(0xE61B6A3B),  // Grunge filter

    // CustomShaderEntry(0xA02CE990),  // SMAA

    CustomShaderEntry(0x1FB08827),  // UI Shader
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
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = true,
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
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Buy Pumbo a Coffee",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFFDD00,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://buymeacoffee.com/", "realfiloppi");
        },

    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://ko-fi.com/", "musaqh");
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

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for The Town of Light";


   // Caches all the states we might need to modify to draw a simple pixel shader.
// First call "Cache()" (once) and then call "Restore()" (once).
struct DrawStateStack {
  // This is the max according to PSSetShader() documentation
  static constexpr UINT max_shader_class_instances = 256;

  // Not used by Prey's CryEngine
#define ENABLE_SHADER_CLASS_INSTANCES 0

  DrawStateStack() {
#if ENABLE_SHADER_CLASS_INSTANCES
    std::memset(&vs_instances, 0, sizeof(void*) * max_shader_class_instances);
    std::memset(&ps_instances, 0, sizeof(void*) * max_shader_class_instances);
#endif
  }

  // Cache aside the previous resources/states:
  void Cache(ID3D11DeviceContext* device_context) {
    device_context->OMGetBlendState(&blend_state, blend_factor, &blend_sample_mask);
    device_context->IAGetPrimitiveTopology(&primitive_topology);
    device_context->RSGetScissorRects(&scissor_rects_num, nullptr);  // This will get the number of scissor rects used
    device_context->RSGetScissorRects(&scissor_rects_num, &scissor_rects[0]);
    device_context->RSGetViewports(&viewports_num, nullptr);  // This will get the number of viewports used
    device_context->RSGetViewports(&viewports_num, &viewports[0]);
    device_context->PSGetShaderResources(0, 1, &shader_resource_view);  // Only cache the first one
    device_context->PSGetSamplers(0, 1, &ps_sampler);  // Only cache the first one
    device_context->PSGetConstantBuffers(renodx::mods::shader::expected_constant_buffer_index, 1, &constant_buffer_1);  // Hardcoded to our "renodx::mods::shader::expected_constant_buffer_index" given that we generally use that one
    device_context->OMGetRenderTargets(D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT, &render_target_views[0], &depth_stencil_view);
#if ENABLE_SHADER_CLASS_INSTANCES
    device_context->VSGetShader(&vs, vs_instances, &vs_instances_count);
    device_context->PSGetShader(&ps, ps_instances, &ps_instances_count);
    ASSERT_ONCE(vs_instances_count == 0 && ps_instances_count == 0);
#else
    device_context->VSGetShader(&vs, nullptr, 0);
    device_context->PSGetShader(&ps, nullptr, 0);
#endif
    device_context->IAGetInputLayout(&input_layout);


#if 0  // These are not needed until proven otherwise, we don't change, nor rely on these states
    ID3D11RasterizerState* RS;
    UINT StencilRef;
    ID3D11DepthStencilState* DepthStencilState;
    ID3D11SamplerState* PSSampler;
    ID3D11Buffer* IndexBuffer;
    ID3D11Buffer* VertexBuffer;
    UINT IndexBufferOffset, VertexBufferStride, VertexBufferOffset;
    DXGI_FORMAT IndexBufferFormat;

    device_context->RSGetState(&RS);
    device_context->OMGetDepthStencilState(&DepthStencilState, &StencilRef);
    device_context->IAGetIndexBuffer(&IndexBuffer, &IndexBufferFormat, &IndexBufferOffset);
    device_context->IAGetVertexBuffers(0, 1, &VertexBuffer, &VertexBufferStride, &VertexBufferOffset);
#endif
  }

  // Restore the previous resources/states:
  void Restore(ID3D11DeviceContext* device_context) {
    device_context->OMSetBlendState(blend_state.get(), blend_factor, blend_sample_mask);
    device_context->IASetPrimitiveTopology(primitive_topology);
    device_context->RSSetScissorRects(scissor_rects_num, &scissor_rects[0]);
    device_context->RSSetViewports(viewports_num, &viewports[0]);
    ID3D11ShaderResourceView* const shader_resource_view_const = shader_resource_view.get();
    device_context->PSSetShaderResources(0, 1, &shader_resource_view_const);
    ID3D11SamplerState* const ps_sampler_const = ps_sampler.get();
    device_context->PSSetSamplers(0, 1, &ps_sampler_const);
    ID3D11Buffer* constant_buffer_const = constant_buffer_1.get();
    device_context->PSSetConstantBuffers(renodx::mods::shader::expected_constant_buffer_index, 1, &constant_buffer_const);
    device_context->OMSetRenderTargets(D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT, &render_target_views[0], depth_stencil_view.get());
    for (UINT i = 0; i < D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT; i++) {
      if (render_target_views[i] != nullptr) {
        render_target_views[i]->Release();
        render_target_views[i] = nullptr;
      }
    }
#if ENABLE_SHADER_CLASS_INSTANCES
    device_context->VSSetShader(vs.get(), vs_instances, vs_instances_count);
    device_context->PSSetShader(ps.get(), ps_instances, ps_instances_count);
    for (UINT i = 0; i < max_shader_class_instances; i++) {
      if (vs_instances[i] != nullptr) {
        vs_instances[i]->Release();
        vs_instances[i] = nullptr;
      }
      if (ps_instances[i] != nullptr) {
        ps_instances[i]->Release();
        ps_instances[i] = nullptr;
      }
    }
#else
    device_context->VSSetShader(vs.get(), nullptr, 0);
    device_context->PSSetShader(ps.get(), nullptr, 0);
#endif
    device_context->IASetInputLayout(input_layout.get());
  }

  com_ptr<ID3D11BlendState> blend_state;
  FLOAT blend_factor[4] = {1.f, 1.f, 1.f, 1.f};
  UINT blend_sample_mask;
  com_ptr<ID3D11VertexShader> vs;
  com_ptr<ID3D11PixelShader> ps;
#if ENABLE_SHADER_CLASS_INSTANCES
  UINT vs_instances_count = max_shader_class_instances;
  UINT ps_instances_count = max_shader_class_instances;
  ID3D11ClassInstance* vs_instances[max_shader_class_instances];
  ID3D11ClassInstance* ps_instances[max_shader_class_instances];
#endif
  D3D11_PRIMITIVE_TOPOLOGY primitive_topology;
  ID3D11RenderTargetView* render_target_views[D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT];

  com_ptr<ID3D11DepthStencilView> depth_stencil_view;
  com_ptr<ID3D11ShaderResourceView> shader_resource_view;
  com_ptr<ID3D11Buffer> constant_buffer_1;
  D3D11_RECT scissor_rects[D3D11_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE];
  UINT scissor_rects_num = 1;
  D3D11_VIEWPORT viewports[D3D11_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE];
  UINT viewports_num = 1;
  com_ptr<ID3D11SamplerState> ps_sampler;
  com_ptr<ID3D11InputLayout> input_layout;

#undef ENABLE_SHADER_CLASS_INSTANCES
};

// Final shader [ty Ersh/FF14]
struct __declspec(uuid("1228220F-364A-46A2-BB29-1CCE591A018A")) DeviceData {
  reshade::api::pipeline final_pipeline = {};
  reshade::api::pipeline_layout final_layout = {};
};

struct __declspec(uuid("1228110F-324A-46A2-BB29-1BCE591C115B")) SwapchainData {
  std::vector<reshade::api::resource_view> swapchain_rtvs;
  reshade::api::resource final_texture = {};
  reshade::api::resource_view final_texture_view = {};
  reshade::api::sampler final_texture_sampler = {};
};

constexpr reshade::api::pipeline_layout PIPELINE_LAYOUT{0};

void OnInitDevice(reshade::api::device* device) {
  auto* data = device->create_private_data<DeviceData>();

  // create pipeline
  {
    std::vector<reshade::api::pipeline_subobject> subobjects;

    reshade::api::shader_desc vs_desc = {};
    vs_desc.code = __0xFFFFFFFD.data();
    vs_desc.code_size = __0xFFFFFFFD.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::vertex_shader, 1, &vs_desc});

    reshade::api::shader_desc ps_desc = {};
    ps_desc.code = __0xFFFFFFFE.data();
    ps_desc.code_size = __0xFFFFFFFE.size();
    subobjects.push_back({reshade::api::pipeline_subobject_type::pixel_shader, 1, &ps_desc});

    auto topology = reshade::api::primitive_topology::triangle_strip;
    subobjects.push_back({reshade::api::pipeline_subobject_type::primitive_topology, 1, &topology});

    reshade::api::blend_desc blend_state = {};
    subobjects.push_back({reshade::api::pipeline_subobject_type::blend_state, 1, &blend_state});

#if 0
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
#endif

    device->create_pipeline(PIPELINE_LAYOUT, static_cast<uint32_t>(subobjects.size()), subobjects.data(), &data->final_pipeline);
  }

  // create layout
  {
    reshade::api::pipeline_layout_param new_params;
    new_params.type = reshade::api::pipeline_layout_param_type::push_constants;
    new_params.push_constants.count = 1;
    new_params.push_constants.dx_register_index = 13; // Same as "renodx::mods::shader::expected_constant_buffer_index"
    new_params.push_constants.visibility = reshade::api::shader_stage::vertex | reshade::api::shader_stage::pixel;
    device->create_pipeline_layout(1, &new_params, &data->final_layout);
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  auto* data = device->get_private_data<DeviceData>();

  device->destroy_pipeline(data->final_pipeline);
  device->destroy_pipeline_layout(data->final_layout);

  device->destroy_private_data<DeviceData>();
}

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto device = swapchain->get_device();
  auto* data = device->create_private_data<SwapchainData>();

  if (!fired_on_init_swapchain) {
    fired_on_init_swapchain = true;
    auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
    if (peak.has_value()) {
      settings[2]->default_value = peak.value();
      settings[2]->can_reset = true;
    }
  }

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
  auto* data = device->get_private_data<SwapchainData>();

  for (const auto& rtv : data->swapchain_rtvs) {
    device->destroy_resource_view(rtv);
  }
  device->destroy_sampler(data->final_texture_sampler);
  device->destroy_resource_view(data->final_texture_view);
  device->destroy_resource(data->final_texture);

  swapchain->destroy_private_data<SwapchainData>();
}

// more or less the same as what reshade does to render its techniques
void OnPresent(reshade::api::command_queue* queue, reshade::api::swapchain* swapchain, const reshade::api::rect* source_rect, const reshade::api::rect* dest_rect, uint32_t dirty_rect_count, const reshade::api::rect* dirty_rects) {
  ResetShaderCount();  // Reset executed shaders and tonemapped with each new frame

  auto device = queue->get_device();
  auto cmd_list = queue->get_immediate_command_list();

  ID3D11Device* native_device = (ID3D11Device*)(queue->get_device()->get_native());
  ID3D11DeviceContext* native_device_context = (ID3D11DeviceContext*)(queue->get_immediate_command_list()->get_native());

  auto* data = device->get_private_data<DeviceData>();
  auto* swapchain_data = device->get_private_data<SwapchainData>();

  auto back_buffer_resource = swapchain->get_current_back_buffer();
  auto back_buffer_desc = device->get_resource_desc(back_buffer_resource);

  DrawStateStack draw_state_stack;
  draw_state_stack.Cache(native_device_context);

  // copy backbuffer
  cmd_list->copy_resource(back_buffer_resource, swapchain_data->final_texture);

  cmd_list->bind_pipeline(reshade::api::pipeline_stage::vertex_shader | reshade::api::pipeline_stage::pixel_shader | reshade::api::pipeline_stage::input_assembler | reshade::api::pipeline_stage::output_merger, data->final_pipeline);

  reshade::api::render_pass_render_target_desc render_target = {};
  render_target.view = swapchain_data->swapchain_rtvs.at(swapchain->get_current_back_buffer_index());
  cmd_list->begin_render_pass(1, &render_target, nullptr);

  cmd_list->push_descriptors(reshade::api::shader_stage::pixel, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::texture_shader_resource_view, &swapchain_data->final_texture_view});
  cmd_list->push_descriptors(reshade::api::shader_stage::pixel, PIPELINE_LAYOUT, 0, reshade::api::descriptor_table_update{{}, 0, 0, 1, reshade::api::descriptor_type::sampler, &swapchain_data->final_texture_sampler});

  // push the same usual renodx settings (we use the same data in the final shader)
  cmd_list->push_constants(reshade::api::shader_stage::pixel, data->final_layout, 0, 0, sizeof(shader_injection) / 4, &shader_injection);

  const reshade::api::viewport viewport = {
      0.0f, 0.0f,
      static_cast<float>(back_buffer_desc.texture.width),
      static_cast<float>(back_buffer_desc.texture.height),
      0.0f, 1.0f};
  cmd_list->bind_viewports(0, 1, &viewport);

  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();

  draw_state_stack.Restore(native_device_context);
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::shader::expected_constant_buffer_index = 13;

      // renodx::mods::shader::force_pipeline_cloning = true;
      // renodx::mods::swapchain::use_resource_cloning = true;
      // renodx::mods::shader::trace_unmodified_shaders = true;
      renodx::mods::swapchain::force_borderless = true;
      // renodx::mods::swapchain::prevent_full_screen = true;

      // Final shader
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);

// TODO(Musa): figure out why upgrades break when lowering resolution
#if 0  // NOLINT main textures
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_unorm,
          .new_format = reshade::api::format::r16g16b16a16_float,
      });
#endif
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
