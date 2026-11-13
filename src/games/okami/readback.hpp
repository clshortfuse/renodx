/*
 * Copyright (C) 2026 megazeban
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11_1.h>
#include <wrl/client.h>

#include <atomic>
#include <cstdint>
#include <sstream>

#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../utils/format.hpp"
#include "../../utils/resource.hpp"

// CPU readbacks of upgraded render targets.
//
// The game reads some render targets back on the CPU. Rejuvenation is one: it
// draws the missing part of an object into render target 10, copies that into
// a staging texture of the target's original format (B8G8R8A8), maps it and
// treats every non-black pixel as the mask to paint over. With the target
// upgraded to FP16, the copy becomes FP16 -> B8G8R8A8, which D3D11 cannot do,
// so the resource upgrade drops it: the staging texture stays black, the mask
// is empty and no stroke can restore anything.
//
// For a copy from an upgraded render target into a staging texture, draw the
// FP16 texture into a private render target of the staging texture's format
// (the UNORM write clamps and orders the channels as the vanilla target
// would), then copy that into the staging texture.
namespace okami::readback {

namespace internal {

using Microsoft::WRL::ComPtr;

struct __declspec(uuid("b0771e49-033b-4da5-8fe0-37281713d2b8")) DeviceData {
  ComPtr<ID3D11VertexShader> vertex_shader;
  ComPtr<ID3D11PixelShader> pixel_shader;
  ComPtr<ID3D11RasterizerState> rasterizer_state;
  // A private pipeline state, swapped in for the blit, so the game's bindings
  // come back exactly as they were.
  ComPtr<ID3DDeviceContextState> context_state;
  // The 8-bit render target the upgraded texture is drawn into, then copied
  // from. Created natively, so the resource upgrade never sees it.
  ComPtr<ID3D11Texture2D> intermediate;
  ComPtr<ID3D11RenderTargetView> intermediate_rtv;
  bool initialized = false;
  bool failed = false;
};

enum Skip : uint32_t {
  SKIP_NOT_STAGING = 1u << 0,
  SKIP_UNSUPPORTED_COPY = 1u << 1,
  SKIP_NOT_SHADER_RESOURCE = 1u << 2,
  SKIP_NOT_IMMEDIATE = 1u << 3,
  SKIP_SETUP_FAILED = 1u << 4,
  SKIP_INTERMEDIATE_FAILED = 1u << 5,
  SKIP_VIEW_FAILED = 1u << 6,
};

static bool attached = false;
static std::atomic_bool converted_logged = false;
static std::atomic_uint32_t skips_logged = 0u;

// Logs each reason once, so a copy that is still dropped shows up in ReShade.log.
static void LogSkipOnce(
    Skip skip,
    const char* reason,
    reshade::api::resource source,
    const reshade::api::resource_desc& source_desc,
    const reshade::api::resource_desc& dest_desc) {
  if ((skips_logged.fetch_or(skip, std::memory_order_relaxed) & skip) != 0u) return;
  std::stringstream s;
  s << "[Okami] Copy from upgraded render target not converted (" << reason << ")";
  s << ", source=" << PRINT_PTR(source.handle);
  s << ", size=" << source_desc.texture.width << "x" << source_desc.texture.height;
  s << ", format=" << source_desc.texture.format << " => " << dest_desc.texture.format;
  s << ", dest_heap=" << static_cast<uint32_t>(dest_desc.heap);
  reshade::log::message(reshade::log::level::warning, s.str().c_str());
}

static bool Initialize(ID3D11Device* device, DeviceData* data) {
  if (data->initialized) return !data->failed;
  data->initialized = true;
  data->failed = true;

  ComPtr<ID3D11Device1> device1;
  if (FAILED(device->QueryInterface(IID_PPV_ARGS(&device1)))) return false;

  const D3D_FEATURE_LEVEL feature_level = device->GetFeatureLevel();
  const UINT state_flags = (device->GetCreationFlags() & D3D11_CREATE_DEVICE_SINGLETHREADED) != 0u
                               ? D3D11_1_CREATE_DEVICE_CONTEXT_STATE_SINGLETHREADED
                               : 0u;
  if (FAILED(device1->CreateDeviceContextState(
          state_flags, &feature_level, 1, D3D11_SDK_VERSION, __uuidof(ID3D11Device),
          nullptr, &data->context_state))) {
    return false;
  }

  if (FAILED(device->CreateVertexShader(
          __readback_blit_vertex_shader.data(), __readback_blit_vertex_shader.size(),
          nullptr, &data->vertex_shader))) {
    return false;
  }
  if (FAILED(device->CreatePixelShader(
          __readback_blit_pixel_shader.data(), __readback_blit_pixel_shader.size(),
          nullptr, &data->pixel_shader))) {
    return false;
  }

  D3D11_RASTERIZER_DESC rasterizer_desc = {};
  rasterizer_desc.FillMode = D3D11_FILL_SOLID;
  rasterizer_desc.CullMode = D3D11_CULL_NONE;
  rasterizer_desc.DepthClipEnable = TRUE;
  if (FAILED(device->CreateRasterizerState(&rasterizer_desc, &data->rasterizer_state))) return false;

  data->failed = false;
  return true;
}

static bool PrepareIntermediate(
    ID3D11Device* device,
    DeviceData* data,
    uint32_t width,
    uint32_t height,
    DXGI_FORMAT format,
    DXGI_FORMAT view_format) {
  if (data->intermediate != nullptr) {
    D3D11_TEXTURE2D_DESC existing = {};
    data->intermediate->GetDesc(&existing);
    if (existing.Width == width && existing.Height == height && existing.Format == format) return true;
    data->intermediate_rtv.Reset();
    data->intermediate.Reset();
  }

  D3D11_TEXTURE2D_DESC texture_desc = {};
  texture_desc.Width = width;
  texture_desc.Height = height;
  texture_desc.MipLevels = 1;
  texture_desc.ArraySize = 1;
  texture_desc.Format = format;
  texture_desc.SampleDesc.Count = 1;
  texture_desc.Usage = D3D11_USAGE_DEFAULT;
  texture_desc.BindFlags = D3D11_BIND_RENDER_TARGET;
  if (FAILED(device->CreateTexture2D(&texture_desc, nullptr, &data->intermediate))) return false;

  D3D11_RENDER_TARGET_VIEW_DESC rtv_desc = {};
  rtv_desc.Format = view_format;
  rtv_desc.ViewDimension = D3D11_RTV_DIMENSION_TEXTURE2D;
  if (FAILED(device->CreateRenderTargetView(data->intermediate.Get(), &rtv_desc, &data->intermediate_rtv))) {
    data->intermediate.Reset();
    return false;
  }
  return true;
}

static void Blit(
    ID3D11DeviceContext1* context,
    const DeviceData& data,
    ID3D11ShaderResourceView* srv,
    uint32_t width,
    uint32_t height) {
  ComPtr<ID3DDeviceContextState> game_state;
  context->SwapDeviceContextState(data.context_state.Get(), &game_state);

  const D3D11_VIEWPORT viewport = {
      0.f, 0.f, static_cast<float>(width), static_cast<float>(height), 0.f, 1.f};
  context->IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
  context->VSSetShader(data.vertex_shader.Get(), nullptr, 0);
  context->PSSetShader(data.pixel_shader.Get(), nullptr, 0);
  context->PSSetShaderResources(0, 1, &srv);
  context->RSSetState(data.rasterizer_state.Get());
  context->RSSetViewports(1, &viewport);
  context->OMSetRenderTargets(1, data.intermediate_rtv.GetAddressOf(), nullptr);
  context->Draw(3, 0);

  // Leave nothing bound in the private state, so it holds no references.
  ID3D11ShaderResourceView* null_srv = nullptr;
  context->PSSetShaderResources(0, 1, &null_srv);
  context->OMSetRenderTargets(0, nullptr, nullptr);

  context->SwapDeviceContextState(game_state.Get(), nullptr);
}

static bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  auto* device = cmd_list->get_device();
  if (device->get_api() != reshade::api::device_api::d3d11) return false;

  // The upgraded texture holding what the game rendered: the resource itself
  // when it was upgraded at creation, or its clone.
  reshade::api::resource upgraded = {0u};
  bool is_clone = false;
  renodx::utils::resource::GetResourceInfo(source, [&](const renodx::utils::resource::ResourceInfo& info) {
    if (info.destroyed || info.is_clone) return;
    if (info.clone_enabled) {
      upgraded = info.clone;
      is_clone = true;
    } else if (info.upgraded) {
      upgraded = source;
    }
  });
  if (upgraded.handle == 0u) return false;

  const auto upgraded_desc = device->get_resource_desc(upgraded);
  const auto dest_desc = device->get_resource_desc(dest);
  // Copies the formats allow are left to the upgrade.
  if (upgraded_desc.type != reshade::api::resource_type::texture_2d
      || dest_desc.type != reshade::api::resource_type::texture_2d
      || renodx::utils::resource::AreCopyFormatsCompatible(upgraded_desc.texture.format, dest_desc.texture.format)) {
    return false;
  }

  // Only readbacks: copies into staging textures.
  if (dest_desc.heap != reshade::api::memory_heap::gpu_to_cpu
      && dest_desc.heap != reshade::api::memory_heap::cpu_only) {
    LogSkipOnce(SKIP_NOT_STAGING, "destination is not a staging texture", source, upgraded_desc, dest_desc);
    return false;
  }
  if (upgraded_desc.texture.width != dest_desc.texture.width
      || upgraded_desc.texture.height != dest_desc.texture.height
      || upgraded_desc.texture.depth_or_layers != 1u
      || upgraded_desc.texture.levels != 1u
      || upgraded_desc.texture.samples != 1u
      || dest_desc.texture.depth_or_layers != 1u
      || dest_desc.texture.levels != 1u) {
    LogSkipOnce(SKIP_UNSUPPORTED_COPY, "size, mips, layers or samples", source, upgraded_desc, dest_desc);
    return false;
  }
  if ((upgraded_desc.usage & reshade::api::resource_usage::shader_resource) == 0) {
    LogSkipOnce(SKIP_NOT_SHADER_RESOURCE, "not a shader resource", source, upgraded_desc, dest_desc);
    return false;
  }

  auto* context = reinterpret_cast<ID3D11DeviceContext*>(cmd_list->get_native());
  ComPtr<ID3D11DeviceContext1> context1;
  if (FAILED(context->QueryInterface(IID_PPV_ARGS(&context1)))
      || context1->GetType() != D3D11_DEVICE_CONTEXT_IMMEDIATE) {
    LogSkipOnce(SKIP_NOT_IMMEDIATE, "not the immediate context", source, upgraded_desc, dest_desc);
    return false;
  }

  auto* data = device->get_private_data<DeviceData>();
  if (data == nullptr) data = device->create_private_data<DeviceData>();
  auto* native_device = reinterpret_cast<ID3D11Device*>(device->get_native());
  if (!Initialize(native_device, data)) {
    LogSkipOnce(SKIP_SETUP_FAILED, "blit setup failed", source, upgraded_desc, dest_desc);
    return false;
  }
  if (!PrepareIntermediate(
          native_device,
          data,
          dest_desc.texture.width,
          dest_desc.texture.height,
          static_cast<DXGI_FORMAT>(dest_desc.texture.format),
          static_cast<DXGI_FORMAT>(reshade::api::format_to_default_typed(dest_desc.texture.format, 0)))) {
    LogSkipOnce(SKIP_INTERMEDIATE_FAILED, "intermediate render target creation failed", source, upgraded_desc, dest_desc);
    return false;
  }

  D3D11_SHADER_RESOURCE_VIEW_DESC srv_desc = {};
  srv_desc.Format = static_cast<DXGI_FORMAT>(reshade::api::format_to_default_typed(upgraded_desc.texture.format, 0));
  srv_desc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
  srv_desc.Texture2D.MipLevels = 1;
  ComPtr<ID3D11ShaderResourceView> srv;
  if (FAILED(native_device->CreateShaderResourceView(
          reinterpret_cast<ID3D11Resource*>(upgraded.handle), &srv_desc, &srv))) {
    LogSkipOnce(SKIP_VIEW_FAILED, "shader resource view creation failed", source, upgraded_desc, dest_desc);
    return false;
  }

  Blit(context1.Get(), *data, srv.Get(), dest_desc.texture.width, dest_desc.texture.height);
  context1->CopyResource(reinterpret_cast<ID3D11Resource*>(dest.handle), data->intermediate.Get());

  if (!converted_logged.exchange(true, std::memory_order_relaxed)) {
    std::stringstream s;
    s << "[Okami] Converted readback of upgraded render target";
    s << ", source=" << PRINT_PTR(source.handle);
    s << (is_clone ? " (clone)" : " (upgraded at creation)");
    s << ", size=" << dest_desc.texture.width << "x" << dest_desc.texture.height;
    s << ", format=" << upgraded_desc.texture.format << " => " << dest_desc.texture.format;
    s << ", dest=" << PRINT_PTR(dest.handle);
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  return true;
}

static void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d11 && device->get_private_data<DeviceData>() == nullptr) {
    device->create_private_data<DeviceData>();
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

}  // namespace internal

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::register_event<reshade::addon_event::copy_resource>(internal::OnCopyResource);
      break;

    case DLL_PROCESS_DETACH:
      if (!internal::attached) return;
      internal::attached = false;
      reshade::unregister_event<reshade::addon_event::copy_resource>(internal::OnCopyResource);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      break;
  }
}

}  // namespace okami::readback
