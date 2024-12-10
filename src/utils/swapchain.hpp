/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <dxgi1_6.h>
#include <ios>
#include <mutex>
#include <optional>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./device.hpp"
#include "./platform.hpp"
#include "./resource.hpp"

namespace renodx::utils::swapchain {

namespace internal {
static std::shared_mutex mutex;
static reshade::api::effect_runtime* current_effect_runtime = nullptr;
static reshade::api::color_space current_color_space = reshade::api::color_space::unknown;
}  // namespace internal

struct __declspec(uuid("25b7ec11-a51f-4884-a6f7-f381d198b9af")) SwapchainData {
  reshade::api::swapchain_desc original_descc;
  reshade::api::swapchain_desc current_desc;
  std::unordered_set<uint64_t> back_buffers;
  std::shared_mutex mutex;
};

struct __declspec(uuid("4721e307-0cf3-4293-b4a5-40d0a4e62544")) DeviceData {
  std::unordered_set<reshade::api::swapchain*> swapchains;
  std::unordered_set<uint64_t> back_buffers;
  reshade::api::resource_desc back_buffer_desc;
  std::shared_mutex mutex;
};

struct __declspec(uuid("3cf9a628-8518-4509-84c3-9fbe9a295212")) CommandListData {
  std::vector<reshade::api::resource_view> current_render_targets;
  reshade::api::resource_view current_depth_stencil = {0};
  bool has_swapchain_render_target_dirty = true;
  bool has_swapchain_render_target = false;
};

static std::shared_mutex mutex;

static void OnInitDevice(reshade::api::device* device) {
  auto& data = device->create_private_data<DeviceData>();
}

static void OnDestroyDevice(reshade::api::device* device) {
  device->destroy_private_data<DeviceData>();
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  auto& swapchain_data = swapchain->create_private_data<SwapchainData>();
  const size_t back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0; index < back_buffer_count; index++) {
    auto buffer = swapchain->get_back_buffer(index);
    swapchain_data.back_buffers.emplace(buffer.handle);
  }
  auto* device = swapchain->get_device();
  if (device != nullptr) {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::unique_lock lock(device_data.mutex);
    device_data.swapchains.emplace(swapchain);

    for (uint32_t index = 0; index < back_buffer_count; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      device_data.back_buffers.emplace(buffer.handle);
      if (index == 0) {
        auto desc = device->get_resource_desc(buffer);
        device_data.back_buffer_desc = desc;
      }
    }
  }
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain) {
  auto& swapchain_data = swapchain->get_private_data<SwapchainData>();
  auto* device = swapchain->get_device();
  if (device != nullptr) {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::unique_lock lock(device_data.mutex);
    device_data.swapchains.erase(swapchain);
    for (const uint64_t handle : swapchain_data.back_buffers) {
      device_data.back_buffers.erase(handle);
    }
  }
  swapchain->destroy_private_data<SwapchainData>();
}

static void OnInitEffectRuntime(reshade::api::effect_runtime* runtime) {
  std::unique_lock lock(internal::mutex);
  internal::current_effect_runtime = runtime;
  reshade::log::message(reshade::log::level::info, "Effect runtime created.");
  if (internal::current_color_space != reshade::api::color_space::unknown) {
    runtime->set_color_space(internal::current_color_space);
    reshade::log::message(reshade::log::level::info, "Effect runtime colorspace updated.");
  }
}

static void OnDestroyEffectRuntime(reshade::api::effect_runtime* runtime) {
  std::unique_lock lock(internal::mutex);
  if (internal::current_effect_runtime == runtime) {
    internal::current_effect_runtime = nullptr;
  }
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  auto& data = cmd_list->create_private_data<CommandListData>();
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

static bool IsBackBuffer(reshade::api::device* device, reshade::api::resource resource) {
  bool result = false;
  {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::shared_lock lock(device_data.mutex);
    result = device_data.back_buffers.contains(resource.handle);
  }
  return result;
}

static bool IsBackBuffer(reshade::api::command_list* cmd_list, reshade::api::resource resource) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return false;
  return IsBackBuffer(device, resource);
}

static reshade::api::resource_desc GetBackBufferDesc(reshade::api::device* device) {
  reshade::api::resource_desc desc = {};
  {
    auto& device_data = device->get_private_data<DeviceData>();
    const std::shared_lock lock(device_data.mutex);
    desc = device_data.back_buffer_desc;
  }
  return desc;
}

static reshade::api::resource_desc GetBackBufferDesc(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return {};
  return GetBackBufferDesc(device);
}

static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  const bool found_swapchain_rtv = false;
  cmd_list_data.current_render_targets.assign(rtvs, rtvs + count);
  cmd_list_data.current_depth_stencil = dsv;
  cmd_list_data.has_swapchain_render_target_dirty = true;
}

static bool HasBackBufferRenderTarget(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();

  if (!cmd_list_data.has_swapchain_render_target_dirty) {
    return cmd_list_data.has_swapchain_render_target;
  }

  const uint32_t count = cmd_list_data.current_render_targets.size();
  if (count == 0u) {
    cmd_list_data.has_swapchain_render_target_dirty = false;
    cmd_list_data.has_swapchain_render_target = false;
    return false;
  }
  auto* device = cmd_list->get_device();
  auto& device_data = device->get_private_data<DeviceData>();
  const std::shared_lock device_lock(device_data.mutex);

  bool found_swapchain_rtv = false;
  for (const auto& rtv : cmd_list_data.current_render_targets) {
    if (rtv.handle == 0u) continue;
    const auto& resource = device->get_resource_from_view(rtv);
    if (resource.handle == 0u) continue;
    if (!device_data.back_buffers.contains(resource.handle)) continue;
    found_swapchain_rtv = true;
    break;
  }

  cmd_list_data.has_swapchain_render_target_dirty = false;
  cmd_list_data.has_swapchain_render_target = found_swapchain_rtv;
  return found_swapchain_rtv;
}

static std::vector<reshade::api::resource_view>& GetRenderTargets(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  return cmd_list_data.current_render_targets;
};

static reshade::api::resource_view& GetDepthStencil(reshade::api::command_list* cmd_list) {
  auto& cmd_list_data = cmd_list->get_private_data<CommandListData>();
  return cmd_list_data.current_depth_stencil;
};

static bool IsDirectX(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  return device::IsDirectX(device);
}

static std::optional<DXGI_OUTPUT_DESC1> GetDirectXOutputDesc1(reshade::api::swapchain* swapchain) {
  auto* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

  IDXGISwapChain4* swapchain4;

  if (!SUCCEEDED(native_swapchain->QueryInterface(IID_PPV_ARGS(&swapchain4)))) {
    reshade::log::message(reshade::log::level::error, "GetDirectXOutputDesc1(Failed to get native swap chain)");
    return std::nullopt;
  }

  DXGI_COLOR_SPACE_TYPE dx_color_space;

  IDXGIOutput* output;
  HRESULT hr = swapchain4->GetContainingOutput(&output);

  swapchain4->Release();
  swapchain4 = nullptr;

  if (!SUCCEEDED(hr)) {
    reshade::log::message(reshade::log::level::error, "GetDirectXOutputDesc1(Failed to get containing output)");
    return std::nullopt;
  }

  IDXGIOutput6* output6;
  hr = output->QueryInterface(&output6);

  output->Release();
  output = nullptr;

  if (!SUCCEEDED(hr)) {
    reshade::log::message(reshade::log::level::error, "GetDirectXOutputDesc1(Failed to query output6)");
    return std::nullopt;
  }

  // https://learn.microsoft.com/en-us/windows/win32/direct3darticles/high-dynamic-range#idxgioutput6
  DXGI_OUTPUT_DESC1 output_desc;

  hr = output6->GetDesc1(&output_desc);

  output6->Release();
  output6 = nullptr;

  if (!SUCCEEDED(hr)) {
    reshade::log::message(reshade::log::level::error, "GetDirectXOutputDesc1(Failed to get output desc)");
    return std::nullopt;
  }
  return output_desc;
}

static std::optional<float> GetPeakNits(reshade::api::swapchain* swapchain) {
  if (!IsDirectX(swapchain)) return std::nullopt;

  auto output_desc = GetDirectXOutputDesc1(swapchain);
  if (!output_desc.has_value()) return std::nullopt;

  // Current display colorspace (not swapchain)
  if (output_desc->ColorSpace != DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020
      && output_desc->ColorSpace != DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709) {
    reshade::log::message(reshade::log::level::warning, "GetPeakNits(Not HDR)");
    // Not WCG/HDR
    return std::nullopt;
  }

  return output_desc->MaxLuminance;
}

static bool IsHDRColorSpace(reshade::api::swapchain* swapchain) {
  switch (swapchain->get_color_space()) {
    case reshade::api::color_space::extended_srgb_linear:
    case reshade::api::color_space::hdr10_hlg:
    case reshade::api::color_space::hdr10_st2084:
      return true;
    default:
      return false;
  }
}

static std::optional<float> GetSDRWhiteNits(reshade::api::swapchain* swapchain) {
  if (!IsDirectX(swapchain)) return std::nullopt;

  auto output_desc = GetDirectXOutputDesc1(swapchain);
  if (!output_desc.has_value()) return std::nullopt;

  auto path = renodx::utils::platform::GetPathInfo(output_desc->Monitor);
  if (!path.has_value()) return std::nullopt;

  DISPLAYCONFIG_SDR_WHITE_LEVEL white_level = {};
  white_level.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_SDR_WHITE_LEVEL;
  white_level.header.size = sizeof(white_level);
  white_level.header.adapterId = path->targetInfo.adapterId;
  white_level.header.id = path->targetInfo.id;
  if (DisplayConfigGetDeviceInfo(&white_level.header) == ERROR_SUCCESS) {
    return static_cast<float>(white_level.SDRWhiteLevel) / 1000 * 80;  // From wingdi.h.
  }

  return std::nullopt;
}

static bool ChangeColorSpace(reshade::api::swapchain* swapchain, reshade::api::color_space color_space) {
  if (IsDirectX(swapchain)) {
    DXGI_COLOR_SPACE_TYPE dx_color_space = DXGI_COLOR_SPACE_CUSTOM;
    switch (color_space) {
      case reshade::api::color_space::srgb_nonlinear:       dx_color_space = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709; break;
      case reshade::api::color_space::extended_srgb_linear: dx_color_space = DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709; break;
      case reshade::api::color_space::hdr10_st2084:         dx_color_space = DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020; break;
      case reshade::api::color_space::hdr10_hlg:            dx_color_space = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P2020; break;
      default:                                              return false;
    }

    auto* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    IDXGISwapChain4* swapchain4;

    if (!SUCCEEDED(native_swapchain->QueryInterface(IID_PPV_ARGS(&swapchain4)))) {
      reshade::log::message(reshade::log::level::error, "changeColorSpace(Failed to get native swap chain)");
      return false;
    }

    const HRESULT hr = swapchain4->SetColorSpace1(dx_color_space);

    {
      // Notify SpecialK of color space change
      // {018B57E4-1493-4953-ADF2-DE6D99CC05E5}
      static constexpr GUID SKID_SWAP_CHAIN_COLOR_SPACE =
          {0x18b57e4, 0x1493, 0x4953, {0xad, 0xf2, 0xde, 0x6d, 0x99, 0xcc, 0x5, 0xe5}};

      swapchain4->SetPrivateData(
          SKID_SWAP_CHAIN_COLOR_SPACE,
          sizeof(DXGI_COLOR_SPACE_TYPE),
          &dx_color_space);
    }

    swapchain4->Release();
    swapchain4 = nullptr;
    if (!SUCCEEDED(hr)) {
      return false;
    }
  } else {
    // Vulkan ???
  }

  std::unique_lock lock(internal::mutex);
  internal::current_color_space = color_space;

  if (internal::current_effect_runtime != nullptr) {
    internal::current_effect_runtime->set_color_space(internal::current_color_space);
  } else {
    reshade::log::message(reshade::log::level::warning, "renodx::utils::swapchain::ChangeColorSpace(effectRuntimeNotSet)");
  }

  return true;
}

static void ResizeBuffer(
    reshade::api::swapchain* swapchain,
    reshade::api::format format = reshade::api::format::r16g16b16a16_float,
    reshade::api::color_space color_space = reshade::api::color_space::unknown) {
  if (!IsDirectX(swapchain)) return;
  auto* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

  IDXGISwapChain4* swapchain4;

  if (FAILED(native_swapchain->QueryInterface(IID_PPV_ARGS(&swapchain4)))) {
    reshade::log::message(reshade::log::level::error, "resize_buffer(Failed to get native swap chain)");
    return;
  }

  DXGI_SWAP_CHAIN_DESC1 desc;
  if (FAILED(swapchain4->GetDesc1(&desc))) {
    reshade::log::message(reshade::log::level::error, "resize_buffer(Failed to get desc)");
    swapchain4->Release();
    swapchain4 = nullptr;
    return;
  }

  // Reshade formats are mostly compatible with DXGI_FORMAT
  auto new_format = static_cast<DXGI_FORMAT>(format);

  if (desc.Format == new_format) {
    reshade::log::message(reshade::log::level::debug, "resize_buffer(Format OK)");
    swapchain4->Release();
    swapchain4 = nullptr;
    return;
  }
  reshade::log::message(reshade::log::level::debug, "resize_buffer(Resizing...)");

  const HRESULT hr = swapchain4->ResizeBuffers(
      desc.BufferCount == 1 ? 2 : 0,
      desc.Width,
      desc.Height,
      new_format,
      desc.Flags);

  swapchain4->Release();
  swapchain4 = nullptr;

  if (hr == DXGI_ERROR_INVALID_CALL) {
    std::stringstream s;
    s << "mods::swapchain::ResizeBuffer(DXGI_ERROR_INVALID_CALL";
    s << ", BufferCount = " << desc.BufferCount;
    s << ", Width = " << desc.Width;
    s << ", Height = " << desc.Height;
    s << ", Format = " << desc.Format;
    s << ", Flags = 0x" << std::hex << desc.Flags << std::dec;
    s << ')';
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return;
  }
  {
    std::stringstream s;
    s << "mods::swapchain::ResizeBuffer(";
    s << "resize: " << hr;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  // Reshade doesn't actually inspect colorspace
  // auto colorspace = swapchain->get_color_space();
  if (color_space != reshade::api::color_space::unknown) {
    if (ChangeColorSpace(swapchain, color_space)) {
      reshade::log::message(reshade::log::level::info, "resize_buffer(Color Space: OK)");
    } else {
      reshade::log::message(reshade::log::level::error, "resize_buffer(Color Space: Failed.)");
    }
  }
}

static bool attached = false;

inline void Use(DWORD fdw_reason) {
  renodx::utils::resource::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::init_effect_runtime>(OnInitEffectRuntime);
      reshade::register_event<reshade::addon_event::destroy_effect_runtime>(OnDestroyEffectRuntime);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::init_effect_runtime>(OnInitEffectRuntime);
      reshade::unregister_event<reshade::addon_event::destroy_effect_runtime>(OnDestroyEffectRuntime);

      break;
  }
}
}  // namespace renodx::utils::swapchain
