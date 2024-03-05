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

  static reshade::api::device* currentDevice = nullptr;
  static uint32_t swapChainHeight = -1;
  static uint32_t swapChainWidth = -1;

  // Before CreatePipelineState
  static bool on_create_swapchain(reshade::api::swapchain_desc &desc, void* hwnd) {
    bool changed = true;
    auto oldFormat = desc.back_buffer.texture.format;
    auto oldPresentMode = desc.present_mode;

    switch (desc.back_buffer.texture.format) {
      case reshade::api::format::r8g8b8a8_unorm:
      case reshade::api::format::r8g8b8a8_unorm_srgb:
        desc.back_buffer.texture.format = reshade::api::format::r16g16b16a16_float;
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
      << "swap: "
      << "0x" << std::hex << (uint32_t)oldFormat << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.back_buffer.texture.format << std::dec
      << ", present:"
      << "0x" << std::hex << (uint32_t)oldPresentMode << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.present_mode << std::dec
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return changed;
  }

  static bool changeColorSpace(reshade::api::swapchain* swapchain, DXGI_COLOR_SPACE_TYPE ColorSpace) {
    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    ATL::CComPtr<IDXGISwapChain4> swapchain4;

    if (!SUCCEEDED(native_swapchain->QueryInterface(__uuidof(IDXGISwapChain4), (void**)&swapchain4))) {
      reshade::log_message(reshade::log_level::error, "changeColorSpace(Failed to get native swap chain)");
      return false;
    }

    return SUCCEEDED(swapchain4->SetColorSpace1(ColorSpace));
  }

  static void on_init_swapchain(reshade::api::swapchain* swapchain) {
    const auto device = swapchain->get_device();
    currentDevice = device;
    const size_t backBufferCount = swapchain->get_back_buffer_count();

    for (uint32_t index = 0; index < backBufferCount; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      backBuffers.emplace(buffer.handle);

      std::stringstream s;
      s << "initSwapChain("
        << "buffer: 0x" << std::hex << (uint32_t)buffer.handle << std::dec << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }

    // Reshade doesn't actually inspect colorspace
    // auto colorspace = swapchain->get_color_space();
    if (changeColorSpace(swapchain, DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709)) {
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
    if (desc.format == reshade::api::format::r16g16b16a16_float) return false;
    auto oldFormat = desc.format;

    bool changed = false;
    if (backBuffers.find(resource.handle) != backBuffers.end()) {
      desc.format = reshade::api::format::r16g16b16a16_float;
      changed = true;
    } else {
      const auto resourceDesc = device->get_resource_desc(resource);

      if (resourceDesc.texture.height != swapChainHeight) return false;
      if (resourceDesc.texture.width != swapChainWidth) return false;

      if (desc.format == reshade::api::format::r8g8b8a8_unorm) {
        desc.format = reshade::api::format::r16g16b16a16_float;
        changed = true;
      } else if (desc.format == reshade::api::format::r8g8b8a8_typeless) {
        desc.format = reshade::api::format::r16g16b16a16_typeless;
        changed = true;
      } else if (desc.format == reshade::api::format::r8g8b8a8_unorm_srgb) {
        desc.format = reshade::api::format::r16g16b16a16_float;
        changed = true;
      }
    }

    if (changed) {
      desc.format = reshade::api::format::r16g16b16a16_float;
      std::stringstream s;
      s << "createResourceView("
        << std::hex << (uint32_t)resource.handle << std::dec
        << ": " << (uint32_t)oldFormat
        << " => " << (uint32_t)desc.format
        << ", " << std::hex << (uint32_t)usage_type << std::dec << ")";
      reshade::log_message(
        oldFormat == reshade::api::format::unknown
          ? reshade::log_level::warning
          : reshade::log_level::info,
        s.str().c_str()
      );
    }
    return changed;
  }

  static bool on_create_resource(
    reshade::api::device* device,
    reshade::api::resource_desc &desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state
  ) {
    if (device != currentDevice) return false;
    if (desc.texture.height != swapChainHeight) return false;
    if (desc.texture.width != swapChainWidth) return false;

    std::stringstream s;
    s << "createResource("
      << std::hex << (uint32_t)desc.flags << std::dec
      << ", " << (uint32_t)desc.buffer.size
      << ", " << std::hex << (uint32_t)initial_state << std::dec
      << ", " << (uint32_t)desc.texture.width
      << ", " << (uint32_t)desc.texture.height
      << ", " << (uint32_t)desc.texture.format << ")";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );

    if (desc.texture.format == reshade::api::format::r8g8b8a8_unorm_srgb) {
      desc.texture.format = reshade::api::format::r16g16b16a16_float;
      return true;
    }
    if (desc.texture.format == reshade::api::format::r8g8b8a8_typeless) {
      desc.texture.format = reshade::api::format::r16g16b16a16_typeless;
      return true;
    }
    if (desc.texture.format == reshade::api::format::r8g8b8a8_unorm) {
      desc.texture.format = reshade::api::format::r16g16b16a16_float;
      return true;
    }
    return false;
  }

  void on_destroy_device(reshade::api::device* device) {
    if (currentDevice == device) {
      currentDevice = nullptr;
    }
  }

  void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::register_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        reshade::register_event<reshade::addon_event::create_resource>(on_create_resource);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::unregister_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        reshade::unregister_event<reshade::addon_event::create_resource>(on_create_resource);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
        break;
    }
  }
}  // namespace SwapChainUpgradeMod
