/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <dxgi1_6.h>
#include <algorithm>
#include <chrono>
#include <cmath>
#include <deque>
#include <functional>
#include <ios>
#include <mutex>
#include <optional>
#include <sstream>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>

#include "./data.hpp"
#include "./device.hpp"
#include "./format.hpp"
#include "./platform.hpp"
#include "./resource.hpp"

namespace renodx::utils::swapchain {

static float fps_limit = 0.f;

struct __declspec(uuid("4721e307-0cf3-4293-b4a5-40d0a4e62544")) DeviceData {
  std::shared_mutex mutex;
  std::unordered_set<reshade::api::effect_runtime*> effect_runtimes;
  reshade::api::resource_desc back_buffer_desc;
  reshade::api::color_space current_color_space = reshade::api::color_space::unknown;
};

struct __declspec(uuid("3cf9a628-8518-4509-84c3-9fbe9a295212")) CommandListData {
  std::vector<reshade::api::resource_view> current_render_targets;
  reshade::api::resource_view current_depth_stencil = {0};
  bool has_swapchain_render_target_dirty = true;
  bool has_swapchain_render_target = false;
  uint8_t pass_count = 0;
};

static bool IsBackBuffer(reshade::api::resource resource) {
  auto* info = resource::GetResourceInfo(resource);
  if (info == nullptr) return false;
  return info->is_swap_chain;
}

static CommandListData* GetCurrentState(reshade::api::command_list* cmd_list) {
  return renodx::utils::data::Get<CommandListData>(cmd_list);
}

static reshade::api::resource_desc GetBackBufferDesc(reshade::api::device* device) {
  reshade::api::resource_desc desc = {};
  {
    auto* device_data = renodx::utils::data::Get<DeviceData>(device);
    if (device_data == nullptr) {
      reshade::log::message(reshade::log::level::error, "GetBackBufferDesc(No device data)");
      return desc;
    }
    // const std::shared_lock lock(device_data->mutex);
    desc = device_data->back_buffer_desc;
  }
  return desc;
}

static reshade::api::resource_desc GetBackBufferDesc(reshade::api::command_list* cmd_list) {
  auto* device = cmd_list->get_device();
  if (device == nullptr) return {};
  return GetBackBufferDesc(device);
}

static bool HasBackBufferRenderTarget(reshade::api::command_list* cmd_list) {
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return false;
  if (!cmd_list_data->has_swapchain_render_target_dirty) {
    return cmd_list_data->has_swapchain_render_target;
  }

  const uint32_t count = cmd_list_data->current_render_targets.size();
  if (count == 0u) {
    cmd_list_data->has_swapchain_render_target_dirty = false;
    cmd_list_data->has_swapchain_render_target = false;
    return false;
  }

  bool found_swapchain_rtv = false;
  for (const auto& rtv : cmd_list_data->current_render_targets) {
    if (rtv.handle == 0u) continue;
    auto* resource_view_info = resource::GetResourceViewInfo(rtv);
    if (resource_view_info == nullptr) continue;
    if (resource_view_info->resource_info == nullptr) continue;
    if (!resource_view_info->resource_info->is_swap_chain) continue;
    found_swapchain_rtv = true;
    break;
  }

  cmd_list_data->has_swapchain_render_target_dirty = false;
  cmd_list_data->has_swapchain_render_target = found_swapchain_rtv;
  return found_swapchain_rtv;
}

static std::vector<reshade::api::resource_view>& GetRenderTargets(reshade::api::command_list* cmd_list) {
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  assert(cmd_list_data != nullptr);
  return cmd_list_data->current_render_targets;
};

static reshade::api::resource_view& GetDepthStencil(reshade::api::command_list* cmd_list) {
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  assert(cmd_list_data != nullptr);
  return cmd_list_data->current_depth_stencil;
};

static bool IsDirectX(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  return device::IsDirectX(device);
}

static bool IsDXGI(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  return device::IsDXGI(device);
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
  if (!IsDXGI(swapchain)) return std::nullopt;

  auto output_desc = GetDirectXOutputDesc1(swapchain);
  if (!output_desc.has_value()) return std::nullopt;

  // Current display colorspace (not swapchain)
  if (output_desc->ColorSpace != DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020
      && output_desc->ColorSpace != DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709) {
    std::stringstream s;
    s << "GetPeakNits(Not HDR Color Space: " << static_cast<int>(output_desc->ColorSpace);
    s << ", Peak Nits: " << output_desc->MaxLuminance << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    // Not WCG/HDR
    return std::nullopt;
  }

  return output_desc->MaxLuminance;
}

static float ComputeReferenceWhite(const float peak_nits) {
  // use high precision for calculations
  const double local_peak_nits = static_cast<double>(peak_nits);

  // source for all math functions: Rec. ITU-R BT.2100-3 Table 5 (end)

  // 75% HLG calculated at high precision
  // calculated as following:
  // a = 0.17883277
  // b = 1 - 4 * a
  // c = 0.5 - a * ln(4 * a)
  // then calculate the HLG inverse OETF with x=0.75
  // hlg_at_75_percent = (exp((0.75 - c) / a) + b) / 12
  const double hlg_at_75_percent = 0.26496256042100718;

  // get gamma for the HLG OOTF
  const double gamma = 1.2 + (0.42 * std::log10(local_peak_nits / 1000.0));

  // calculate the refernce white value
  // HLG OOTF
  // hlg_at_75_percent is both E and Y_S
  const double reference_white = local_peak_nits * std::pow(hlg_at_75_percent, gamma - 1.0) * hlg_at_75_percent;

  return std::clamp(std::roundf(static_cast<float>(reference_white)), 100.f, 300.f);
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

static bool GetHDRSupported(const DISPLAYCONFIG_PATH_INFO& path) {
  DISPLAYCONFIG_GET_ADVANCED_COLOR_INFO_2 advanced_color_info_2 = {};
  advanced_color_info_2.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_ADVANCED_COLOR_INFO_2;
  advanced_color_info_2.header.size = sizeof(advanced_color_info_2);
  advanced_color_info_2.header.adapterId = path.targetInfo.adapterId;
  advanced_color_info_2.header.id = path.targetInfo.id;
  if (DisplayConfigGetDeviceInfo(&advanced_color_info_2.header) == ERROR_SUCCESS) {
    return advanced_color_info_2.highDynamicRangeSupported != 0;
  }
  // Fallback to older struct
  DISPLAYCONFIG_GET_ADVANCED_COLOR_INFO advanced_color_info_1 = {};
  advanced_color_info_1.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_ADVANCED_COLOR_INFO;
  advanced_color_info_1.header.size = sizeof(advanced_color_info_1);
  advanced_color_info_1.header.adapterId = path.targetInfo.adapterId;
  advanced_color_info_1.header.id = path.targetInfo.id;
  if (DisplayConfigGetDeviceInfo(&advanced_color_info_1.header) == ERROR_SUCCESS) {
    return advanced_color_info_1.advancedColorSupported != 0;
  }
  return false;
}

static bool GetHDREnabled(const DISPLAYCONFIG_PATH_INFO& path) {
  DISPLAYCONFIG_GET_ADVANCED_COLOR_INFO_2 advanced_color_info_2 = {};
  advanced_color_info_2.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_ADVANCED_COLOR_INFO_2;
  advanced_color_info_2.header.size = sizeof(advanced_color_info_2);
  advanced_color_info_2.header.adapterId = path.targetInfo.adapterId;
  advanced_color_info_2.header.id = path.targetInfo.id;
  if (DisplayConfigGetDeviceInfo(&advanced_color_info_2.header) == ERROR_SUCCESS) {
    return advanced_color_info_2.highDynamicRangeUserEnabled != 0;
  }
  // Fallback to older struct
  DISPLAYCONFIG_GET_ADVANCED_COLOR_INFO advanced_color_info_1 = {};
  advanced_color_info_1.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_ADVANCED_COLOR_INFO;
  advanced_color_info_1.header.size = sizeof(advanced_color_info_1);
  advanced_color_info_1.header.adapterId = path.targetInfo.adapterId;
  advanced_color_info_1.header.id = path.targetInfo.id;
  if (DisplayConfigGetDeviceInfo(&advanced_color_info_1.header) == ERROR_SUCCESS) {
    return advanced_color_info_1.advancedColorEnabled != 0;
  }
  return false;
}

static bool SetHDREnabled(const DISPLAYCONFIG_PATH_INFO& path, bool enabled = true) {
  if (GetHDREnabled(path) == enabled) return true;

  DISPLAYCONFIG_SET_HDR_STATE hdr_state = {};
  hdr_state.header.type = DISPLAYCONFIG_DEVICE_INFO_SET_HDR_STATE;
  hdr_state.header.size = sizeof(hdr_state);
  hdr_state.header.adapterId = path.targetInfo.adapterId;
  hdr_state.header.id = path.targetInfo.id;
  hdr_state.enableHdr = enabled ? 1 : 0;
  if (DisplayConfigSetDeviceInfo(&hdr_state.header) == ERROR_SUCCESS) {
    return true;
  }
  // Fallback to older struct
  DISPLAYCONFIG_SET_ADVANCED_COLOR_STATE advanced_color_state = {};
  advanced_color_state.header.type = DISPLAYCONFIG_DEVICE_INFO_SET_ADVANCED_COLOR_STATE;
  advanced_color_state.header.size = sizeof(advanced_color_state);
  advanced_color_state.header.adapterId = path.targetInfo.adapterId;
  advanced_color_state.header.id = path.targetInfo.id;
  advanced_color_state.enableAdvancedColor = enabled ? 1 : 0;
  return DisplayConfigSetDeviceInfo(&advanced_color_state.header) == ERROR_SUCCESS;
}

static bool SetHDREnabled(reshade::api::swapchain* swapchain, bool enabled = true) {
  if (!IsDXGI(swapchain)) return false;

  auto output_desc = GetDirectXOutputDesc1(swapchain);
  if (!output_desc.has_value()) return false;

  auto path = renodx::utils::platform::GetPathInfo(output_desc->Monitor);
  if (!path.has_value()) return false;

  return SetHDREnabled(path.value(), enabled);
}

struct DisplayInfo {
  reshade::api::swapchain* swapchain = nullptr;
  std::optional<DXGI_OUTPUT_DESC1> output_desc = std::nullopt;
  std::optional<DISPLAYCONFIG_PATH_INFO> display_config = std::nullopt;
  bool hdr_supported = false;
  bool hdr_enabled = false;
  bool hdr_forced = false;
  float peak_nits = 1000.f;
  float sdr_white_nits = 203.f;
  // Unreliable
  // reshade::api::format display_color_space = reshade::api::format::unknown;
};

static DisplayInfo GetDisplayInfo(reshade::api::swapchain* swapchain, bool force_hdr = false) {
  DisplayInfo info;
  if (!IsDXGI(swapchain)) return info;
  info.output_desc = GetDirectXOutputDesc1(swapchain);
  if (!info.output_desc.has_value()) return info;

  info.display_config = renodx::utils::platform::GetPathInfo(info.output_desc->Monitor);
  if (!info.display_config.has_value()) return info;

  info.hdr_supported = GetHDRSupported(info.display_config.value());

  info.hdr_enabled = GetHDREnabled(info.display_config.value());

  if (force_hdr && info.hdr_supported && !info.hdr_enabled) {
    if (SetHDREnabled(info.display_config.value(), true)) {
      info.hdr_enabled = true;
      info.hdr_forced = true;
      info.output_desc = GetDirectXOutputDesc1(swapchain);
    } else {
      reshade::log::message(reshade::log::level::error, "GetDisplayInfo(Failed to enable HDR on display)");
    }
  }

  // HDR needs to be enabled to get correct values
  if (info.hdr_enabled) {
    DISPLAYCONFIG_SDR_WHITE_LEVEL white_level = {};
    white_level.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_SDR_WHITE_LEVEL;
    white_level.header.size = sizeof(white_level);
    white_level.header.adapterId = info.display_config->targetInfo.adapterId;
    white_level.header.id = info.display_config->targetInfo.id;
    if (DisplayConfigGetDeviceInfo(&white_level.header) == ERROR_SUCCESS) {
      info.sdr_white_nits = static_cast<float>(white_level.SDRWhiteLevel) / 1000 * 80;  // From wingdi.h.
      if (info.sdr_white_nits == 200.f) {
        info.sdr_white_nits = 203.f;
      }
    }
    info.peak_nits = info.output_desc->MaxLuminance;
  }

  // DirectX still reports SDR color space when changing display mode to HDR

  // switch (info.output_desc->ColorSpace) {
  //   case DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709:
  //     info.display_color_space = reshade::api::format::r16g16b16a16_float;
  //     // assert(info.hdr_enabled == true);
  //     break;
  //   case DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020:
  //     info.display_color_space = reshade::api::format::r10g10b10a2_unorm;
  //     assert(info.hdr_enabled == true);
  //     break;
  //   default:
  //     assert(false);
  //     [[fallthrough]];
  //   case DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709:
  //     info.display_color_space = reshade::api::format::r8g8b8a8_unorm;
  //     assert(info.hdr_enabled == false);
  //     break;
  // }

  return info;
}

static std::optional<float> GetSDRWhiteNits(reshade::api::swapchain* swapchain) {
  if (!IsDXGI(swapchain)) return std::nullopt;

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
    auto white_nits = static_cast<float>(white_level.SDRWhiteLevel) / 1000 * 80;  // From wingdi.h.
    if (white_nits == 200.f) {
      white_nits = 203.f;
    }
    return white_nits;
  }

  return std::nullopt;
}

static bool ChangeColorSpace(reshade::api::swapchain* swapchain, reshade::api::color_space color_space) {
  if (IsDXGI(swapchain)) {
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
      if (swapchain4 != nullptr) {
        swapchain4->Release();
        swapchain4 = nullptr;
      }
      return false;
    }

    const HRESULT hr = swapchain4->SetColorSpace1(dx_color_space);

    if (FAILED(hr)) {
      if (swapchain4 != nullptr) {
        swapchain4->Release();
        swapchain4 = nullptr;
      }
      std::stringstream s;
      s << "renodx::utils::swapchain::ChangeColorSpace(Failed to set DirectX color space, hr = 0x" << std::hex << hr << std::dec << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      return false;
    }

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
  } else {
    // Vulkan ???
  }

  auto* device = swapchain->get_device();

  std::unordered_set<reshade::api::effect_runtime*> runtimes;
  auto* data = renodx::utils::data::Get<DeviceData>(device);

  if (data != nullptr) {
    std::unique_lock lock(data->mutex);

    data->current_color_space = color_space;
    runtimes = data->effect_runtimes;
  }

  for (auto* runtime : runtimes) {
    runtime->set_color_space(color_space);
    reshade::log::message(reshade::log::level::debug, "renodx::utils::swapchain::ChangeColorSpace(Updated runtime)");
  }

  return true;
}

static void ResizeBuffer(
    reshade::api::swapchain* swapchain,
    reshade::api::format format = reshade::api::format::r16g16b16a16_float,
    reshade::api::color_space color_space = reshade::api::color_space::unknown) {
  if (!IsDXGI(swapchain)) return;
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

namespace internal {
static bool attached = false;
static std::chrono::high_resolution_clock::time_point last_time_point;
static float last_fps_limit;
static auto busy_spin_duration = std::chrono::nanoseconds(0);
static std::uint32_t busy_spin_failures = 0;

static std::deque<std::chrono::nanoseconds> wait_latency_history;
static const size_t MAX_LATENCY_HISTORY_SIZE = 1000;

static bool is_primary_hook = false;
static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet<DeviceData>(device, data);
  if (!created) return;

  is_primary_hook = true;
}
static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  device->destroy_private_data<DeviceData>();
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!is_primary_hook) return;
  auto* device = swapchain->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);

  data->back_buffer_desc = device->get_resource_desc(swapchain->get_current_back_buffer());
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!is_primary_hook) return;
  auto* device = swapchain->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  data->back_buffer_desc = {};
}

static void OnInitEffectRuntime(reshade::api::effect_runtime* runtime) {
  if (!is_primary_hook) return;
  auto* device = runtime->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);

  // Runtime may be on a separate device
  std::stringstream s;
  if (data == nullptr) {
    s << "utils::swapchain::OnInitEffectRuntime(No device data: " << reinterpret_cast<uintptr_t>(device);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return;
  }

  reshade::api::color_space color_space;
  {
    const std::unique_lock lock(data->mutex);
    data->effect_runtimes.emplace(runtime);
    s << "utils::swapchain::OnInitEffectRuntime(Runtime: " << reinterpret_cast<uintptr_t>(device);
    if (!data->effect_runtimes.contains(runtime)) {
      s << " (new) ";
    }
    color_space = data->current_color_space;
  }
  if (color_space != reshade::api::color_space::unknown) {
    runtime->set_color_space(color_space);
    s << ", colorspace: ";
    s << color_space;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  } else {
    s << ", colorspace: unknown";
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }
}

static void OnDestroyEffectRuntime(reshade::api::effect_runtime* runtime) {
  if (!is_primary_hook) return;
  auto* device = runtime->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);

  // Runtime may be on a separate device
  if (data == nullptr) return;

  const std::unique_lock lock(data->mutex);
  data->effect_runtimes.erase(runtime);
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (!is_primary_hook) return;
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;
  const bool found_swapchain_rtv = false;
  if (count != 0) {
    cmd_list_data->current_render_targets.assign(rtvs, rtvs + count);
    cmd_list_data->has_swapchain_render_target_dirty = true;
  }
  cmd_list_data->current_depth_stencil = dsv;
}

static void OnBeginRenderPass(
    reshade::api::command_list* cmd_list,
    uint32_t count, const reshade::api::render_pass_render_target_desc* rts,
    const reshade::api::render_pass_depth_stencil_desc* ds) {
  if (!is_primary_hook) return;
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;
  const bool found_swapchain_rtv = false;

  // Ignore subpasses
  if (cmd_list_data->pass_count++ != 0) return;

  cmd_list_data->current_render_targets.reserve(count);
  for (const auto& rt : std::span<const reshade::api::render_pass_render_target_desc>(rts, count)) {
    cmd_list_data->current_render_targets.push_back(rt.view);
  }
  if (ds != nullptr) {
    cmd_list_data->current_depth_stencil = ds->view;
  } else {
    cmd_list_data->current_depth_stencil = {0};
  }
  cmd_list_data->has_swapchain_render_target_dirty = true;
}

static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;

  // Ignore subpasses
  if (--cmd_list_data->pass_count != 0) return;

  cmd_list_data->current_render_targets.clear();
  cmd_list_data->current_depth_stencil = {0};
  cmd_list_data->has_swapchain_render_target_dirty = true;
}

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  // is_primary_hook not needed
  if (last_fps_limit != fps_limit) {
    busy_spin_duration = std::chrono::nanoseconds(0);
    wait_latency_history.clear();
    last_fps_limit = fps_limit;
  }
  if (fps_limit <= 0.f) return;

  const auto time_per_frame = std::chrono::high_resolution_clock::duration(std::chrono::milliseconds(1000)) / static_cast<double>(fps_limit);
  const auto next_time_point = last_time_point + time_per_frame;

  auto now = std::chrono::high_resolution_clock::now();
  auto time_till_next_frame = next_time_point - now;
  if (time_till_next_frame.count() <= 0) {
    last_time_point = now;
    return;
  }

  // Use sleep/timer for as much as reliably possible
  auto wait_duration = time_till_next_frame - busy_spin_duration;
  bool changed_busy_spin_duration = false;
  if (wait_duration.count() > 0) {
#if defined(RENODX_FPS_LIMIT_HR_TIMER)
    static const HANDLE WAITABLE_TIMER = CreateWaitableTimerExW(
        nullptr, nullptr,
        CREATE_WAITABLE_TIMER_HIGH_RESOLUTION,
        TIMER_ALL_ACCESS);
    auto remaining = wait_duration;
    auto ticks = remaining.count() / 100;  // 100ns ticks
    while (remaining.count() > 0) {
      LARGE_INTEGER due;
      due.QuadPart = -ticks;
      SetWaitableTimerEx(WAITABLE_TIMER, &due, 0, nullptr, nullptr, nullptr, 0);
      WaitForSingleObject(WAITABLE_TIMER, INFINITE);
      remaining = next_time_point - busy_spin_duration - std::chrono::high_resolution_clock::now();
    }
#else
    std::this_thread::sleep_for(wait_duration);
#endif

    auto after_wait = std::chrono::high_resolution_clock::now();
    auto actual_wait_duration = after_wait - now;
    auto wait_latency = actual_wait_duration - wait_duration;

    // Record the wait latency
    wait_latency_history.push_back(std::chrono::duration_cast<std::chrono::nanoseconds>(wait_latency));
    auto current_size = wait_latency_history.size() + 1;
    if (current_size > MAX_LATENCY_HISTORY_SIZE) {
      wait_latency_history.pop_front();
      --current_size;
    }

    // Calculate the worst 1% latency
    if (current_size >= MAX_LATENCY_HISTORY_SIZE * 0.10f) {  // Ensure enough data points
      auto sorted_latencies = wait_latency_history;
      std::ranges::sort(sorted_latencies, std::greater<>());
      auto worst_1_percent = sorted_latencies[current_size * 0.01];
      busy_spin_duration = std::chrono::duration_cast<std::chrono::nanoseconds>(worst_1_percent * 1.5);
    }

    busy_spin_failures = 0;
    now = after_wait;
  } else {
    ++busy_spin_failures;

    if (busy_spin_failures > fps_limit) {
      // Full second of failures, try increasing
      busy_spin_failures = 0;

      if (wait_latency_history.empty()) {
        busy_spin_duration = std::chrono::nanoseconds(0);
      } else {
        auto sorted_latencies = wait_latency_history;
        std::ranges::sort(sorted_latencies, std::less<>());
        if (sorted_latencies[0] * 1.5 < time_per_frame) {
          // Decrease spin lock duration by 10%
          busy_spin_duration = std::chrono::duration_cast<std::chrono::nanoseconds>(busy_spin_duration * 0.90f);
        } else {
          // Lowest latency is longer than time per frame
        }
      }
    }
  }

  while (now < next_time_point) {
    YieldProcessor();  // __builtin_ia32_pause or _mm_pause
    // Spin lock until the next time point
    now = std::chrono::high_resolution_clock::now();
  }

  last_time_point = now;
}
}  // namespace internal

static void Use(DWORD fdw_reason) {
  renodx::utils::resource::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;

      reshade::log::message(reshade::log::level::info, "utils::swapchain attached.");

      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      reshade::register_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      reshade::register_event<reshade::addon_event::init_effect_runtime>(internal::OnInitEffectRuntime);
      reshade::register_event<reshade::addon_event::destroy_effect_runtime>(internal::OnDestroyEffectRuntime);
      reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(internal::OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      reshade::unregister_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      reshade::unregister_event<reshade::addon_event::init_effect_runtime>(internal::OnInitEffectRuntime);
      reshade::unregister_event<reshade::addon_event::destroy_effect_runtime>(internal::OnDestroyEffectRuntime);
      reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);

      break;
  }
}
}  // namespace renodx::utils::swapchain
