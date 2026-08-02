/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define DEBUG_LEVEL_0

#include <d3dcompiler.h>
#include <windows.h>

#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <span>
#include <string>
#include <vector>

#include <include/reshade.hpp>

#include "src/utils/render.hpp"

namespace {

constexpr uint32_t WIDTH = 32u;
constexpr uint32_t HEIGHT = 32u;
constexpr uint32_t READBACK_ROW_PITCH = 256u;

struct Pixel {
  uint8_t r = 0u;
  uint8_t g = 0u;
  uint8_t b = 0u;
  uint8_t a = 0u;
};

bool ran = false;

constexpr char VERTEX_SHADER[] = R"(
struct VertexOutput {
  float4 position : SV_Position;
  float2 uv : TEXCOORD0;
};

VertexOutput main(uint vertex_id : SV_VertexID) {
  VertexOutput output;
  output.uv = float2((vertex_id << 1) & 2, vertex_id & 2);
  output.position = float4(output.uv * float2(2.f, -2.f) + float2(-1.f, 1.f), 0.f, 1.f);
  return output;
}
)";

constexpr char PIXEL_SHADER[] = R"(
Texture2D<float4> source_texture : register(t0);
SamplerState source_sampler : register(s0);

cbuffer TestConstants : register(b0) {
  float4 scale;
};

float4 main(float4 position : SV_Position, float2 uv : TEXCOORD0) : SV_Target {
  return source_texture.SampleLevel(source_sampler, uv, 0.f) * scale;
}
)";

std::vector<uint8_t> CompileShader(const char* source, const char* profile) {
  ID3DBlob* code = nullptr;
  ID3DBlob* errors = nullptr;
  const HRESULT result = D3DCompile(
      source,
      std::strlen(source),
      nullptr,
      nullptr,
      nullptr,
      "main",
      profile,
      D3DCOMPILE_ENABLE_STRICTNESS,
      0,
      &code,
      &errors);
  if (FAILED(result) || code == nullptr) {
    if (errors != nullptr) {
      reshade::log::message(
          reshade::log::level::error,
          static_cast<const char*>(errors->GetBufferPointer()));
      errors->Release();
    }
    if (code != nullptr) code->Release();
    return {};
  }

  const auto* begin = static_cast<const uint8_t*>(code->GetBufferPointer());
  std::vector<uint8_t> output(begin, begin + code->GetBufferSize());
  code->Release();
  if (errors != nullptr) errors->Release();
  return output;
}

bool CreateSource(
    reshade::api::device* device,
    uint32_t packed_color,
    reshade::api::resource* resource,
    reshade::api::resource_view* view) {
  std::array<uint32_t, 16> pixels;
  pixels.fill(packed_color);
  reshade::api::subresource_data initial_data = {
      .data = pixels.data(),
      .row_pitch = 4u * sizeof(uint32_t),
      .slice_pitch = static_cast<uint32_t>(pixels.size() * sizeof(uint32_t)),
  };
  const reshade::api::resource_desc resource_desc(
      4u,
      4u,
      1u,
      1u,
      reshade::api::format::r8g8b8a8_unorm,
      1u,
      reshade::api::memory_heap::gpu_only,
      reshade::api::resource_usage::shader_resource | reshade::api::resource_usage::copy_dest);
  if (!device->create_resource(
          resource_desc,
          &initial_data,
          reshade::api::resource_usage::shader_resource,
          resource)) {
    return false;
  }

  if (!device->create_resource_view(
          *resource,
          reshade::api::resource_usage::shader_resource,
          reshade::api::resource_view_desc(reshade::api::format::r8g8b8a8_unorm),
          view)) {
    device->destroy_resource(*resource);
    *resource = {};
    return false;
  }
  return true;
}

bool RenderAndReadPixel(
    renodx::utils::render::RenderPass* pass,
    reshade::api::command_queue* queue,
    reshade::api::resource back_buffer,
    reshade::api::resource readback,
    Pixel* pixel) {
  auto* command_list = queue->get_immediate_command_list();
  if (command_list == nullptr) return false;

  command_list->barrier(
      back_buffer,
      reshade::api::resource_usage::present,
      reshade::api::resource_usage::render_target);
  if (!pass->Render(command_list, queue)) return false;
  command_list->barrier(
      back_buffer,
      reshade::api::resource_usage::render_target,
      reshade::api::resource_usage::copy_source);
  command_list->copy_texture_to_buffer(
      back_buffer,
      0u,
      nullptr,
      readback,
      0u,
      WIDTH,
      HEIGHT);
  command_list->barrier(
      back_buffer,
      reshade::api::resource_usage::copy_source,
      reshade::api::resource_usage::present);
  queue->flush_immediate_command_list();
  queue->wait_idle();

  void* mapped = nullptr;
  if (!queue->get_device()->map_buffer_region(
          readback,
          0u,
          READBACK_ROW_PITCH * HEIGHT,
          reshade::api::map_access::read_only,
          &mapped)) {
    return false;
  }
  const auto* bytes = static_cast<const uint8_t*>(mapped);
  *pixel = {
      .r = bytes[0],
      .g = bytes[1],
      .b = bytes[2],
      .a = bytes[3],
  };
  queue->get_device()->unmap_buffer_region(readback);
  return true;
}

bool Near(Pixel actual, Pixel expected) {
  const auto near_channel = [](uint8_t lhs, uint8_t rhs) {
    return std::abs(static_cast<int>(lhs) - static_cast<int>(rhs)) <= 2;
  };
  return near_channel(actual.r, expected.r)
         && near_channel(actual.g, expected.g)
         && near_channel(actual.b, expected.b)
         && near_channel(actual.a, expected.a);
}

std::string Describe(Pixel pixel) {
  return std::to_string(pixel.r) + ","
         + std::to_string(pixel.g) + ","
         + std::to_string(pixel.b) + ","
         + std::to_string(pixel.a);
}

void WriteResult(
    bool passed,
    Pixel automatic,
    Pixel legacy_first,
    Pixel legacy_second,
    const char* error = nullptr,
    Pixel caller_owned = {}) {
  std::array<wchar_t, 32768> path = {};
  const DWORD length = GetEnvironmentVariableW(
      L"RENODX_RENDER_PASS_RESULT",
      path.data(),
      static_cast<DWORD>(path.size()));
  if (length == 0u || length >= path.size()) return;

  std::ofstream output(path.data(), std::ios::binary);
  output << (passed ? "PASS\n" : "FAIL\n");
  output << "automatic=" << Describe(automatic) << "\n";
  output << "legacy_first=" << Describe(legacy_first) << "\n";
  output << "legacy_second=" << Describe(legacy_second) << "\n";
  output << "caller_owned=" << Describe(caller_owned) << "\n";
  if (error != nullptr) output << "error=" << error << "\n";
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  (void)source_rect;
  (void)dest_rect;
  (void)dirty_rect_count;
  (void)dirty_rects;
  if (ran) return;
  ran = true;

  auto* device = swapchain->get_device();
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d12) {
    WriteResult(false, {}, {}, {}, "test requires D3D12");
    return;
  }

  const auto vertex_shader = CompileShader(VERTEX_SHADER, "vs_5_0");
  const auto pixel_shader = CompileShader(PIXEL_SHADER, "ps_5_0");
  if (vertex_shader.empty() || pixel_shader.empty()) {
    WriteResult(false, {}, {}, {}, "shader compilation failed");
    return;
  }

  reshade::api::resource source_a = {};
  reshade::api::resource source_b = {};
  reshade::api::resource_view source_a_view = {};
  reshade::api::resource_view source_b_view = {};
  reshade::api::resource_view render_target_view = {};
  reshade::api::resource readback = {};
  reshade::api::sampler legacy_sampler = {};
  const auto back_buffer = swapchain->get_current_back_buffer();
  const auto back_buffer_desc = device->get_resource_desc(back_buffer);

  const bool resources_created = CreateSource(device, 0xFFC08040u, &source_a, &source_a_view)
                                 && CreateSource(device, 0xFF4080C0u, &source_b, &source_b_view)
                                 && device->create_resource_view(
                                     back_buffer,
                                     reshade::api::resource_usage::render_target,
                                     reshade::api::resource_view_desc(back_buffer_desc.texture.format),
                                     &render_target_view)
                                 && device->create_resource(
                                     reshade::api::resource_desc(
                                         static_cast<uint64_t>(READBACK_ROW_PITCH) * HEIGHT,
                                         reshade::api::memory_heap::gpu_to_cpu,
                                         reshade::api::resource_usage::copy_dest),
                                     nullptr,
                                     reshade::api::resource_usage::copy_dest,
                                     &readback);
  if (!resources_created) {
    WriteResult(false, {}, {}, {}, "resource creation failed");
    if (readback.handle != 0u) device->destroy_resource(readback);
    if (render_target_view.handle != 0u) device->destroy_resource_view(render_target_view);
    if (source_b_view.handle != 0u) device->destroy_resource_view(source_b_view);
    if (source_b.handle != 0u) device->destroy_resource(source_b);
    if (source_a_view.handle != 0u) device->destroy_resource_view(source_a_view);
    if (source_a.handle != 0u) device->destroy_resource(source_a);
    return;
  }

  const std::array<float, 4> scale = {0.5f, 0.5f, 0.5f, 1.f};
  Pixel automatic = {};
  Pixel legacy_first = {};
  Pixel legacy_second = {};
  Pixel caller_owned = {};

  renodx::utils::render::RenderPass automatic_pass;
  automatic_pass.render_target_slots.views = {render_target_view};
  automatic_pass.shader_resource_slots.views = {source_a_view};
  automatic_pass.sampler_descs = {{.filter = reshade::api::filter_mode::min_mag_mip_point}};
  automatic_pass.push_constants[{0u, 0u}] = scale;
  automatic_pass.pipeline_subobjects.vertex_shader = vertex_shader;
  automatic_pass.pipeline_subobjects.pixel_shader = pixel_shader;
  automatic_pass.revert_state_after_render = false;
  automatic_pass.use_render_pass = false;
  bool passed = RenderAndReadPixel(
      &automatic_pass,
      queue,
      back_buffer,
      readback,
      &automatic);

  const reshade::api::sampler_desc sampler_desc = {
      .filter = reshade::api::filter_mode::min_mag_mip_point,
  };
  passed = passed && device->create_sampler(sampler_desc, &legacy_sampler);

  reshade::api::resource_view legacy_source_a = source_a_view;
  reshade::api::resource_view legacy_source_b = source_b_view;
  renodx::utils::render::RenderPass legacy_pass;
  legacy_pass.render_target_slots.views = {render_target_view};
  legacy_pass.shader_resource_slots.views = {source_a_view};
  legacy_pass.samplers = {legacy_sampler};
  legacy_pass.push_constants[{0u, 0u}] = scale;
  legacy_pass.pipeline_subobjects.vertex_shader = vertex_shader;
  legacy_pass.pipeline_subobjects.pixel_shader = pixel_shader;
  legacy_pass.auto_generate_descriptor_table_updates = false;
  legacy_pass.descriptor_table_updates = {
      {
          .table = {},
          .binding = 0u,
          .array_offset = 0u,
          .count = 1u,
          .type = reshade::api::descriptor_type::sampler,
          .descriptors = &legacy_sampler,
      },
      {
          .table = {},
          .binding = 0u,
          .array_offset = 0u,
          .count = 1u,
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
          .descriptors = &legacy_source_a,
      },
  };
  legacy_pass.revert_state_after_render = false;
  legacy_pass.use_render_pass = false;

  passed = passed && RenderAndReadPixel(&legacy_pass, queue, back_buffer, readback, &legacy_first);
  legacy_pass.descriptor_table_updates[1].descriptors = &legacy_source_b;
  passed = passed && RenderAndReadPixel(&legacy_pass, queue, back_buffer, readback, &legacy_second);

  const std::array<reshade::api::descriptor_range, 2> caller_owned_ranges = {{
      {
          .binding = 0u,
          .dx_register_index = 0u,
          .dx_register_space = 0u,
          .count = 1u,
          .visibility = reshade::api::shader_stage::all,
          .array_size = 1u,
          .type = reshade::api::descriptor_type::sampler,
      },
      {
          .binding = 0u,
          .dx_register_index = 0u,
          .dx_register_space = 0u,
          .count = 1u,
          .visibility = reshade::api::shader_stage::all,
          .array_size = 1u,
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
      },
  }};
  std::array<reshade::api::pipeline_layout_param, 3> caller_owned_layout_params = {
      reshade::api::pipeline_layout_param(1u, caller_owned_ranges.data()),
      reshade::api::pipeline_layout_param(1u, caller_owned_ranges.data() + 1u),
      {},
  };
  caller_owned_layout_params[2].type = reshade::api::pipeline_layout_param_type::push_constants;
  caller_owned_layout_params[2].push_constants = {
      .binding = 0u,
      .dx_register_index = 0u,
      .dx_register_space = 0u,
      .count = static_cast<uint32_t>(scale.size()),
      .visibility = reshade::api::shader_stage::all,
  };
  reshade::api::pipeline_layout caller_owned_layout = {};
  std::array<reshade::api::descriptor_table, 2> caller_owned_tables = {};
  passed = passed
           && device->create_pipeline_layout(
               static_cast<uint32_t>(caller_owned_layout_params.size()),
               caller_owned_layout_params.data(),
               &caller_owned_layout)
           && device->allocate_descriptor_table(caller_owned_layout, 0u, caller_owned_tables.data())
           && device->allocate_descriptor_table(caller_owned_layout, 1u, caller_owned_tables.data() + 1u);

  const auto configure_caller_owned_pass = [&](renodx::utils::render::RenderPass* pass,
                                               reshade::api::resource_view* source) {
    pass->render_target_slots.views = {render_target_view};
    pass->samplers = {legacy_sampler};
    pass->push_constants[{0u, 0u}] = scale;
    pass->pipeline_subobjects.vertex_shader = vertex_shader;
    pass->pipeline_subobjects.pixel_shader = pixel_shader;
    pass->auto_generate_descriptor_table_updates = false;
    pass->descriptor_table_updates = {
        {
            .table = {},
            .binding = 0u,
            .array_offset = 0u,
            .count = 1u,
            .type = reshade::api::descriptor_type::sampler,
            .descriptors = &legacy_sampler,
        },
        {
            .table = {},
            .binding = 0u,
            .array_offset = 0u,
            .count = 1u,
            .type = reshade::api::descriptor_type::texture_shader_resource_view,
            .descriptors = source,
        },
    };
    pass->descriptor_tables.assign(caller_owned_tables.begin(), caller_owned_tables.end());
    pass->layout = caller_owned_layout;
    pass->revert_state_after_render = false;
    pass->use_render_pass = false;
  };

  renodx::utils::render::RenderPass caller_owned_first_pass;
  configure_caller_owned_pass(&caller_owned_first_pass, &legacy_source_a);
  passed = passed && RenderAndReadPixel(&caller_owned_first_pass, queue, back_buffer, readback, &caller_owned);
  caller_owned_first_pass.DestroyAll(device);

  renodx::utils::render::RenderPass caller_owned_second_pass;
  configure_caller_owned_pass(&caller_owned_second_pass, &legacy_source_b);
  passed = passed && RenderAndReadPixel(&caller_owned_second_pass, queue, back_buffer, readback, &caller_owned);

  constexpr Pixel expected_a = {.r = 32u, .g = 64u, .b = 96u, .a = 255u};
  constexpr Pixel expected_b = {.r = 96u, .g = 64u, .b = 32u, .a = 255u};
  passed = passed
           && Near(automatic, expected_a)
           && Near(legacy_first, expected_a)
           && Near(legacy_second, expected_b)
           && Near(caller_owned, expected_b);
  WriteResult(passed, automatic, legacy_first, legacy_second, nullptr, caller_owned);

  queue->wait_idle();
  automatic_pass.DestroyAll(device);
  legacy_pass.DestroyAll(device);
  caller_owned_second_pass.DestroyAll(device);
  for (const auto table : caller_owned_tables) {
    if (table.handle != 0u) device->free_descriptor_table(table);
  }
  if (caller_owned_layout.handle != 0u) device->destroy_pipeline_layout(caller_owned_layout);
  if (legacy_sampler.handle != 0u) device->destroy_sampler(legacy_sampler);
  device->destroy_resource(readback);
  device->destroy_resource_view(render_target_view);
  device->destroy_resource_view(source_b_view);
  device->destroy_resource(source_b);
  device->destroy_resource_view(source_a_view);
  device->destroy_resource(source_a);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX RenderPass Behavior Test";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "D3D12 RenderPass descriptor regression test";

BOOL APIENTRY DllMain(HMODULE module, DWORD reason, LPVOID reserved) {
  (void)reserved;
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(module)) return FALSE;
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(module);
      break;
    default:
      break;
  }
  renodx::utils::resource::Use(reason);
  renodx::utils::state::Use(reason);
  return TRUE;
}