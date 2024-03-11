/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <atlbase.h>
#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>
#include <stdio.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include "../../external/reshade/include/reshade.hpp"

namespace SwapChainUpgradeMod {
  std::unordered_set<uint64_t> backBuffers;
  std::unordered_set<uint64_t> upgradedResources;

  static uint32_t resourceUpgradeIndex = -1;
  static reshade::api::device* currentDevice = nullptr;
  static uint32_t swapChainHeight = -1;
  static uint32_t swapChainWidth = -1;
  static reshade::api::effect_runtime* currentEffectRuntime = nullptr;
  static reshade::api::color_space currentColorSpace = reshade::api::color_space::unknown;
  static bool needsSRGBPostProcess = false;
  static reshade::api::format targetFormat = reshade::api::format::r16g16b16a16_float;
  static reshade::api::format targetFormatTypeless = reshade::api::format::r16g16b16a16_typeless;
  static reshade::api::color_space targetColorSpace = reshade::api::color_space::extended_srgb_linear;

  // Before CreatePipelineState
  static bool on_create_swapchain(reshade::api::swapchain_desc &desc, void* hwnd) {
    bool changed = true;
    auto oldFormat = desc.back_buffer.texture.format;
    auto oldPresentMode = desc.present_mode;

    switch (desc.back_buffer.texture.format) {
      case reshade::api::format::r8g8b8a8_unorm:
        needsSRGBPostProcess = true;
      case reshade::api::format::r8g8b8a8_unorm_srgb:
        desc.back_buffer.texture.format = targetFormat;
        break;
      default: changed = false;
    }
    if (changed) {
      if (desc.back_buffer_count < 2) {
        desc.back_buffer_count = 2;
      }

      swapChainHeight = desc.back_buffer.texture.height;
      swapChainWidth = desc.back_buffer.texture.width;

      switch (desc.present_mode) {
        case static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL):
          desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL);
          break;
        case static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD):
          desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
          break;
      }
    }

    std::stringstream s;
    s << "createSwapChain("
      << "swap: " << (uint32_t)oldFormat << " => " << (uint32_t)desc.back_buffer.texture.format
      << ", present:"
      << "0x" << std::hex << (uint32_t)oldPresentMode << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.present_mode << std::dec
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return changed;
  }

  static bool changeColorSpace(reshade::api::swapchain* swapchain, reshade::api::color_space colorSpace) {
    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    ATL::CComPtr<IDXGISwapChain4> swapchain4;

    if (!SUCCEEDED(native_swapchain->QueryInterface(__uuidof(IDXGISwapChain4), (void**)&swapchain4))) {
      reshade::log_message(reshade::log_level::error, "changeColorSpace(Failed to get native swap chain)");
      return false;
    }

    DXGI_COLOR_SPACE_TYPE dxColorSpace = DXGI_COLOR_SPACE_CUSTOM;
    switch (colorSpace) {
      case reshade::api::color_space::srgb_nonlinear:       dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709; break;
      case reshade::api::color_space::extended_srgb_linear: dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709; break;
      case reshade::api::color_space::hdr10_st2084:         dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020; break;
      case reshade::api::color_space::hdr10_hlg:            dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P2020; break;
      default:                                              return false;
    }

    if (!SUCCEEDED(swapchain4->SetColorSpace1(dxColorSpace))) {
      return false;
    }

    currentColorSpace = colorSpace;

    if (currentEffectRuntime) {
      currentEffectRuntime->set_color_space(currentColorSpace);
    } else {
      reshade::log_message(reshade::log_level::warning, "changeColorSpace(effectRuntimeNotSet)");
    }

    return true;
  }

  static int32_t resourceCount = 0;

  static void on_init_swapchain(reshade::api::swapchain* swapchain) {
    const auto device = swapchain->get_device();
    currentDevice = device;
    const size_t backBufferCount = swapchain->get_back_buffer_count();

    for (uint32_t index = 0; index < backBufferCount; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      backBuffers.emplace(buffer.handle);

      std::stringstream s;
      s << "initSwapChain("
        << "buffer: 0x" << std::hex << (uint32_t)buffer.handle << std::dec
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }

    // Reshade doesn't actually inspect colorspace
    // auto colorspace = swapchain->get_color_space();
    if (changeColorSpace(swapchain, targetColorSpace)) {
      reshade::log_message(reshade::log_level::info, "initSwapChain(Color Space: OK)");
    } else {
      reshade::log_message(reshade::log_level::error, "initSwapChain(Color Space: Failed.)");
    }
  }

  static bool on_create_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc &desc
  ) {
    if (device == nullptr) return false;
    if (device != currentDevice) return false;
    if (desc.format == targetFormat) return false;
    auto oldFormat = desc.format;

    if (backBuffers.count(resource.handle)) {
      desc.format = targetFormat;
    } else if (upgradedResources.count(resource.handle)) {
      desc.format = targetFormat;
    } else {
      return false;
    }

    std::stringstream s;
    s << "createResourceView("
      << std::hex << (uint32_t)resource.handle << std::dec
      << ", view type: " << (uint32_t)desc.type
      << ", view format: " << (uint32_t)oldFormat << " => " << (uint32_t)desc.format
      << ", resource: " << reinterpret_cast<void*>(resource.handle)
      << ", resource usage: " << std::hex << (uint32_t)usage_type << std::dec
      << ", buffer offset: " << desc.buffer.offset
      << ", buffer size: " << desc.buffer.size
      << ")";
    reshade::log_message(
      oldFormat == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
    return true;
  }

  static bool markNextResource = false;

  static bool on_create_resource(
    reshade::api::device* device,
    reshade::api::resource_desc &desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state
  ) {
    if (device != currentDevice) return false;
    if (resourceCount >= resourceUpgradeIndex) return false;
    if (desc.texture.height != swapChainHeight) return false;
    if (desc.texture.width != swapChainWidth) return false;

    auto oldFormat = desc.texture.format;
    switch (desc.texture.format) {
      case reshade::api::format::r8g8b8a8_unorm:
        // case reshade::api::format::r8g8b8a8_unorm_srgb:
        desc.texture.format = targetFormat;
        break;
      case reshade::api::format::r8g8b8a8_typeless:
        // desc.texture.format = targetFormatTypeless;
        // break;
      default:
        return false;
    }

    resourceCount++;
    if (resourceCount != resourceUpgradeIndex) return false;
    std::stringstream s;
    s << "createResource("
      << std::hex << (uint32_t)desc.flags << std::dec
      << ", size: " << (uint32_t)desc.buffer.size
      << ", state: " << std::hex << (uint32_t)initial_state << std::dec
      << ", width: " << (uint32_t)desc.texture.width
      << ", height: " << (uint32_t)desc.texture.height
      << ", format: " << (uint32_t)oldFormat << " => " << (uint32_t)desc.texture.format
      << ") [" << resourceCount << "]";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );

    markNextResource = true;
    return true;
  }

  static void on_init_resource(
    reshade::api::device* device,
    const reshade::api::resource_desc &desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource
  ) {
    if (!markNextResource) return;
    markNextResource = false;
    upgradedResources.emplace(resource.handle);
    std::stringstream s;
    s << "initResource("
      << reinterpret_cast<void*>(resource.handle)
      << ", flags: " << std::hex << (uint32_t)desc.flags << std::dec
      << ", size: " << (uint32_t)desc.buffer.size
      << ", state: " << std::hex << (uint32_t)initial_state << std::dec
      << ", width: " << (uint32_t)desc.texture.width
      << ", height: " << (uint32_t)desc.texture.height
      << ", format: " << (uint32_t)desc.texture.format
      << ")";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
  }

  static void on_destroy_device(reshade::api::device* device) {
    if (currentDevice == device) {
      currentDevice = nullptr;
    }
  }

  void on_init_effect_runtime(reshade::api::effect_runtime* runtime) {
    currentEffectRuntime = runtime;
    reshade::log_message(reshade::log_level::info, "Effect runtime created.");
    if (currentColorSpace != reshade::api::color_space::unknown) {
      runtime->set_color_space(currentColorSpace);
      reshade::log_message(reshade::log_level::info, "Effect runtime colorspace updated.");
    }
  }

  void on_destroy_effect_runtime(reshade::api::effect_runtime* runtime) {
    if (currentEffectRuntime = runtime) {
      currentEffectRuntime = nullptr;
    }
  }

  void on_present(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects
  ) {
    if (!needsSRGBPostProcess) return;
    // Enable RenoDXHelper
  }

  void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::register_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        reshade::register_event<reshade::addon_event::create_resource>(on_create_resource);
        reshade::register_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::register_event<reshade::addon_event::init_effect_runtime>(on_init_effect_runtime);
        reshade::register_event<reshade::addon_event::destroy_effect_runtime>(on_destroy_effect_runtime);
        reshade::register_event<reshade::addon_event::present>(on_present);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::unregister_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        reshade::unregister_event<reshade::addon_event::create_resource>(on_create_resource);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::unregister_event<reshade::addon_event::init_effect_runtime>(on_init_effect_runtime);
        reshade::unregister_event<reshade::addon_event::destroy_effect_runtime>(on_destroy_effect_runtime);
        reshade::unregister_event<reshade::addon_event::present>(on_present);
        break;
    }
  }
}  // namespace SwapChainUpgradeMod