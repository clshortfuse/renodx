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
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>
#include "../common/format.hpp"

namespace SwapChainUpgradeMod {
  struct SwapChainUpgradeTarget {
    reshade::api::format oldFormat = reshade::api::format::r8g8b8a8_unorm;
    reshade::api::format newFormat = reshade::api::format::r16g16b16a16_float;
    int32_t index = -1;
    uint32_t _counted = 0;
    bool completed = false;
  };

  struct __declspec(uuid("809df2f6-e1c7-4d93-9c6e-fa88dd960b7c")) device_data {
    bool upgradedResource = false;
    bool hasBufferDesc = false;
    bool resourceUpgradeFinished = false;
    reshade::api::resource_desc deviceBackBufferDesc;
    std::unordered_set<uint64_t> backBuffers;
    std::unordered_set<uint64_t> upgradedResources;
  };

  static std::vector<SwapChainUpgradeTarget> swapChainUpgradeTargets = {};

  static bool upgradeResourceViews = true;
  static bool useSharedDevice = false;

  static reshade::api::effect_runtime* currentEffectRuntime = nullptr;
  static reshade::api::color_space currentColorSpace = reshade::api::color_space::unknown;
  static bool needsSRGBPostProcess = false;
  static reshade::api::format targetFormat = reshade::api::format::r16g16b16a16_float;
  static reshade::api::format targetFormatTypeless = reshade::api::format::r16g16b16a16_typeless;
  static reshade::api::color_space targetColorSpace = reshade::api::color_space::extended_srgb_linear;

  static void on_init_device(reshade::api::device* device) {
    std::stringstream s;
    s << "init_device("
      << reinterpret_cast<void*>(device->get_native())
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    device->create_private_data<device_data>();
  }

  static void on_destroy_device(reshade::api::device* device) {
    std::stringstream s;
    s << "destroy_device("
      << reinterpret_cast<void*>(device->get_native())
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    device->destroy_private_data<device_data>();
  }

  // Before CreatePipelineState
  static bool on_create_swapchain(reshade::api::swapchain_desc &desc, void* hwnd) {
    auto oldFormat = desc.back_buffer.texture.format;
    auto oldPresentMode = desc.present_mode;
    auto oldPresentFlags = desc.present_flags;
    auto oldBufferCount = desc.back_buffer_count;

    desc.back_buffer.texture.format = targetFormat;

    if (desc.back_buffer_count == 1) {
      // 0 is only for resize, so if game uses more than 2 buffers, that will be retained
      desc.back_buffer_count = 2;
    }

    switch (desc.present_mode) {
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL);
        break;
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
        break;
    }

    desc.present_flags &= ~DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
    desc.present_flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;

    std::stringstream s;
    s << "createSwapChain("
      << "swap: " << to_string(oldFormat) << " => " << to_string(desc.back_buffer.texture.format)
      << ", present mode:"
      << "0x" << std::hex << (uint32_t)oldPresentMode << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.present_mode << std::dec
      << ", present flag:"
      << "0x" << std::hex << (uint32_t)oldPresentFlags << std::dec
      << " => "
      << "0x" << std::hex << (uint32_t)desc.present_flags << std::dec
      << ", buffers:"
      << oldBufferCount
      << " => "
      << desc.back_buffer_count
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());

    // No effect if nothing has actually changed
    return true;
  }

  static bool changeColorSpace(reshade::api::swapchain* swapchain, reshade::api::color_space colorSpace) {
    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    IDXGISwapChain4* swapchain4;

    if (!SUCCEEDED(native_swapchain->QueryInterface(IID_PPV_ARGS(&swapchain4)))) {
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

  static void checkSwapchainSize(
    reshade::api::swapchain* swapchain,
    reshade::api::resource_desc buffer_desc
  ) {
    HWND outputWindow = (HWND)swapchain->get_hwnd();
    if (outputWindow == nullptr) {
      reshade::log_message(reshade::log_level::debug, "No HWND?");
      return;
    }

    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    IDXGIFactory* factory;
    bool hr = native_swapchain->GetParent(IID_PPV_ARGS(&factory));
    if (SUCCEEDED(hr)) {
      factory->MakeWindowAssociation(outputWindow, DXGI_MWA_NO_WINDOW_CHANGES);
      reshade::log_message(reshade::log_level::debug, "checkSwapchainSize(set DXGI_MWA_NO_WINDOW_CHANGES)");
    } else {
      reshade::log_message(reshade::log_level::error, "checkSwapchainSize(could not find DXGI factory)");
    }

    RECT window_rect = {};
    GetClientRect(outputWindow, &window_rect);

    int screenWidth = GetSystemMetrics(SM_CXSCREEN);
    int screenHeight = GetSystemMetrics(SM_CYSCREEN);
    int windowWidth = window_rect.right - window_rect.left;
    int windowHeight = window_rect.bottom - window_rect.top;

    std::stringstream s;
    s << "checkSwapchainSize("
      << "screenWidth: " << screenWidth
      << ", screenHeight: " << screenHeight
      << ", bufferWidth: " << buffer_desc.texture.width
      << ", bufferHeight: " << buffer_desc.texture.height
      << ", windowWidth: " << windowWidth
      << ", windowHeight: " << windowHeight
      << ", windowTop: " << window_rect.top
      << ", windowLeft: " << window_rect.left
      << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());

    if (screenWidth != buffer_desc.texture.width) return;
    if (screenHeight != buffer_desc.texture.height) return;
    // if (window_rect.top == 0 && window_rect.left == 0) return;
    SetWindowLongPtr(outputWindow, GWL_STYLE, WS_VISIBLE | WS_POPUP);
    SetWindowPos(outputWindow, HWND_TOP, 0, 0, screenWidth, screenHeight, SWP_FRAMECHANGED);
  }

  static void on_init_swapchain(reshade::api::swapchain* swapchain) {
    auto device = swapchain->get_device();
    if (!device) return;
    auto &privateData = device->get_private_data<device_data>();

    if (privateData.resourceUpgradeFinished) {
      reshade::log_message(reshade::log_level::debug, "initSwapChain(reset resource upgrade)");
      privateData.resourceUpgradeFinished = false;
      uint32_t len = swapChainUpgradeTargets.size();
      // Reset
      for (uint32_t i = 0; i < len; i++) {
        SwapChainUpgradeMod::SwapChainUpgradeTarget* target = &swapChainUpgradeTargets.data()[i];
        target->_counted = 0;
        target->completed = false;
      }
    }

    const size_t backBufferCount = swapchain->get_back_buffer_count();

    for (uint32_t index = 0; index < backBufferCount; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      if (index == 0) {
        auto desc = device->get_resource_desc(buffer);
        privateData.deviceBackBufferDesc = desc;
        privateData.hasBufferDesc = true;
        checkSwapchainSize(swapchain, desc);
      }
      privateData.backBuffers.emplace(buffer.handle);

      std::stringstream s;
      s << "initSwapChain("
        << "buffer: " << reinterpret_cast<void*>(buffer.handle)
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

  static void on_destroy_swapchain(reshade::api::swapchain* swapchain) {
    auto device = swapchain->get_device();
    if (!device) return;
    auto &privateData = device->get_private_data<device_data>();
    privateData.hasBufferDesc = false;

    const size_t backBufferCount = swapchain->get_back_buffer_count();
    for (uint32_t index = 0; index < backBufferCount; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      privateData.backBuffers.erase(buffer.handle);

      std::stringstream s;
      s << "destroySwapchain("
        << "buffer: 0x" << std::hex << (uint32_t)buffer.handle << std::dec
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  static bool on_create_resource(
    reshade::api::device* device,
    reshade::api::resource_desc &desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state
  ) {
    if (!device) {
      std::stringstream s;
      s << "createResource(Empty device)";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      return false;
    }

    if (desc.type != reshade::api::resource_type::texture_2d) return false;

    auto &privateData = device->get_private_data<device_data>();
    if (privateData.resourceUpgradeFinished) return false;

    if (!privateData.hasBufferDesc) {
      std::stringstream s;
      s << "createResource(Unknown device "
        << reinterpret_cast<void*>(device->get_native())
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      return false;
    }
    auto bufferDesc = privateData.deviceBackBufferDesc;
    if (desc.texture.height != bufferDesc.texture.height) {
      return false;
    }
    if (desc.texture.width != bufferDesc.texture.width) {
      return false;
    }

    uint32_t len = swapChainUpgradeTargets.size();

    auto oldFormat = desc.texture.format;
    auto newFormat = desc.texture.format;

    bool allCompleted = true;
    for (uint32_t i = 0; i < len; i++) {
      SwapChainUpgradeMod::SwapChainUpgradeTarget* target = &swapChainUpgradeTargets.data()[i];
      std::stringstream s;
      if (target->completed) continue;
      if (oldFormat == target->oldFormat) {
        s << "createResource(counting target"
          << ", format: " << to_string(target->oldFormat)
          << ", index: " << target->index
          << ", counted: " << target->_counted
          << ") [" << i << "]"
          << "(" << len << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());

        target->_counted++;
        if (target->index == -1) {
          newFormat = target->newFormat;
          allCompleted = false;
          continue;
        }
        if ((target->index + 1) == target->_counted) {
          newFormat = target->newFormat;
          target->completed = true;
          continue;
        }
      }
      allCompleted = false;
    }
    if (oldFormat == newFormat) return false;
    if (allCompleted) {
      privateData.resourceUpgradeFinished = true;
    }

    std::stringstream s;
    s << "createResource(upgrading"
      << ", flags: 0x" << std::hex << (uint32_t)desc.flags << std::dec
      << ", state: 0x" << std::hex << (uint32_t)initial_state << std::dec
      << ", width: " << (uint32_t)desc.texture.width
      << ", height: " << (uint32_t)desc.texture.height
      << ", format: " << to_string(oldFormat) << " => " << to_string(newFormat)
      << ", complete: " << allCompleted
      << ")";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );

    desc.texture.format = newFormat;
    privateData.upgradedResource = true;
    return true;
  }

  static void on_init_resource(
    reshade::api::device* device,
    const reshade::api::resource_desc &desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource
  ) {
    auto &privateData = device->get_private_data<device_data>();
    if (!privateData.upgradedResource) return;
    privateData.upgradedResource = false;
    privateData.upgradedResources.emplace(resource.handle);
    std::stringstream s;
    s << "on_init_resource(tracking "
      << reinterpret_cast<void*>(resource.handle)
      << ", flags: " << std::hex << (uint32_t)desc.flags << std::dec
      << ", state: " << std::hex << (uint32_t)initial_state << std::dec
      << ", width: " << (uint32_t)desc.texture.width
      << ", height: " << (uint32_t)desc.texture.height
      << ", format: " << to_string(desc.texture.format)
      << ")";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
  }

  static bool on_create_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc &desc
  ) {
    if (!resource.handle) return false;
    auto oldFormat = desc.format;

    auto &privateData = device->get_private_data<device_data>();
    reshade::api::resource_desc resource_desc = device->get_resource_desc(resource);
    if (upgradeResourceViews && privateData.backBuffers.count(resource.handle)) {
      desc.format = targetFormat;
    } else if (privateData.upgradedResources.count(resource.handle)) {
      switch (desc.format) {
        case reshade::api::format::r8g8b8a8_typeless:
        case reshade::api::format::b8g8r8a8_typeless:
          desc.format = reshade::api::format::r16g16b16a16_typeless;
          break;
        case reshade::api::format::r8g8b8a8_unorm:
        case reshade::api::format::b8g8r8a8_unorm:
          desc.format = targetFormat;
          break;
        case reshade::api::format::r8g8b8a8_unorm_srgb:
        case reshade::api::format::b8g8r8a8_unorm_srgb:
          // Should upgrade shader
          desc.format = targetFormat;
          break;
        default:
          break;
      }
    } else {
      return false;
    }

    std::stringstream s;
    s << "createResourceView(upgrading"
      << ", view type: " << to_string(desc.type)
      << ", view format: " << to_string(oldFormat) << " => " << to_string(desc.format)
      << ", resource: " << reinterpret_cast<void*>(resource.handle)
      << ", resource width: " << resource_desc.texture.width
      << ", resource height: " << resource_desc.texture.height
      << ", resource usage: " << std::hex << (uint32_t)usage_type << std::dec
      << ")";
    reshade::log_message(
      oldFormat == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
    return oldFormat != desc.format;
  }

  static void on_init_effect_runtime(reshade::api::effect_runtime* runtime) {
    currentEffectRuntime = runtime;
    reshade::log_message(reshade::log_level::info, "Effect runtime created.");
    if (currentColorSpace != reshade::api::color_space::unknown) {
      runtime->set_color_space(currentColorSpace);
      reshade::log_message(reshade::log_level::info, "Effect runtime colorspace updated.");
    }
  }

  static void on_destroy_effect_runtime(reshade::api::effect_runtime* runtime) {
    if (currentEffectRuntime = runtime) {
      currentEffectRuntime = nullptr;
    }
  }

  static bool on_set_fullscreen_state(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
    if (!fullscreen) return false;
    HWND outputWindow = (HWND)swapchain->get_hwnd();
    if (outputWindow) {
      auto backBufferDesc = swapchain->get_device()->get_resource_desc(swapchain->get_back_buffer(0));
      // HMONITOR monitor = (HMONITOR)hmonitor;
      uint32_t screenWidth = GetSystemMetrics(SM_CXSCREEN);
      uint32_t screenHeight = GetSystemMetrics(SM_CYSCREEN);
      uint32_t textureWidth = backBufferDesc.texture.width;
      uint32_t textureHeight = backBufferDesc.texture.height;
      uint32_t top = floor((screenHeight - textureHeight) / 2.f);
      uint32_t left = floor((screenWidth - textureWidth) / 2.f);
      reshade::log_message(reshade::log_level::info, "Preventing fullscreen");
      SetWindowLongPtr(outputWindow, GWL_STYLE, WS_VISIBLE | WS_POPUP);
      SetWindowPos(outputWindow, HWND_TOP, left, top, textureWidth, textureHeight, SWP_FRAMECHANGED);
      BringWindowToTop(outputWindow);
      SetForegroundWindow(outputWindow);
      SetFocus(outputWindow);
    }

    return true;
  }

  static void setUseHDR10(bool value = true) {
    if (value) {
      targetFormat = reshade::api::format::r10g10b10a2_unorm;
      targetColorSpace = reshade::api::color_space::hdr10_st2084;
    } else {
      targetFormat = reshade::api::format::r16g16b16a16_float;
      targetColorSpace = reshade::api::color_space::extended_srgb_linear;
    }
  }

  static void setUpgradeResourceViews(bool value = true) {
    upgradeResourceViews = value;
  }

  static void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);

        reshade::register_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::register_event<reshade::addon_event::destroy_swapchain>(on_destroy_swapchain);

        reshade::register_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::register_event<reshade::addon_event::create_resource>(on_create_resource);

        reshade::register_event<reshade::addon_event::create_resource_view>(on_create_resource_view);

        reshade::register_event<reshade::addon_event::init_effect_runtime>(on_init_effect_runtime);
        reshade::register_event<reshade::addon_event::destroy_effect_runtime>(on_destroy_effect_runtime);

#if RESHADE_API_VERSION >= 11
        reshade::register_event<reshade::addon_event::set_fullscreen_state>(on_set_fullscreen_state);
#endif

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);
        reshade::unregister_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::unregister_event<reshade::addon_event::destroy_swapchain>(on_destroy_swapchain);
        reshade::unregister_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::unregister_event<reshade::addon_event::create_resource>(on_create_resource);
        reshade::unregister_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        reshade::unregister_event<reshade::addon_event::init_effect_runtime>(on_init_effect_runtime);
        reshade::unregister_event<reshade::addon_event::destroy_effect_runtime>(on_destroy_effect_runtime);

#if RESHADE_API_VERSION >= 11
        reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(on_set_fullscreen_state);
#endif
        break;
    }
  }
}  // namespace SwapChainUpgradeMod
