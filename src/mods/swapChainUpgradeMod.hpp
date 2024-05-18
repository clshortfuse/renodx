/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

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
#include "../utils/SwapchainUtil.hpp"
#include "../utils/float16.hpp"
#include "../utils/format.hpp"

namespace SwapChainUpgradeMod {
  struct SwapChainUpgradeTarget {
    reshade::api::format oldFormat = reshade::api::format::r8g8b8a8_unorm;
    reshade::api::format newFormat = reshade::api::format::r16g16b16a16_float;
    int32_t index = -1;
    bool ignoreSize = false;
    uint32_t shaderHash = 0;
    bool useResourceViewCloning = false;
    bool useResourceViewHotSwap = false;
    reshade::api::resource_usage state = reshade::api::resource_usage::undefined;
    uint32_t _counted = 0;
    bool completed = false;
  };

  static bool useSharedDevice = false;
  static bool useResourceCloning = false;
  static bool useResourceFallbacks = false;
  static bool useResizeBuffer = false;
  static bool upgradeUnknownResourceViews = false;
  static bool upgradeResourceViews = true;
  static bool preventFullScreen = true;
  static bool forceBorderless = true;

  struct __declspec(uuid("809df2f6-e1c7-4d93-9c6e-fa88dd960b7c")) device_data {
    reshade::api::resource originalResource;
    reshade::api::resource_view originalResourceView;
    reshade::api::resource_view clonedResourceView;

    bool upgradedResource = false;
    bool upgradedResourceNeedsViewClone = false;
    bool upgradedResourceView = false;
    bool resourceUpgradeFinished = false;
    bool preventFullScreen = false;
    std::unordered_map<uint64_t, reshade::api::resource> upgradedResources;
    // <originalResource.handle, clonedResource.handle>
    std::unordered_map<uint64_t, uint64_t> clonedResources;
    // <clonedResource.handle>
    std::unordered_set<uint64_t> enabledClonedResources;
    std::unordered_map<uint64_t, reshade::api::resource_view> upgradedResourceViews;
    std::unordered_map<uint64_t, uint64_t> renderTargetResourceViewClones;
    std::unordered_map<uint64_t, uint64_t> uavResourceViewClones;
    // <OriginalResource.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> shaderResourceViewClones;
    std::unordered_set<uint64_t> resourcesThatNeedResourceViewClones;
    std::unordered_map<uint64_t, uint64_t> resourceClones;
    std::unordered_map<uint64_t, uint32_t> pipelineToShaderHashMap;
    std::shared_mutex mutex;
    std::unordered_map<uint64_t, reshade::api::resource> rebuiltBuffers;

    std::unordered_map<uint64_t, std::vector<reshade::api::descriptor_table_update>*> clonedDescriptorUpdates;
    std::unordered_map<uint64_t, std::vector<reshade::api::descriptor_table_update>*> clonedDescriptorResets;
    std::unordered_set<uint64_t> flushedResourceViewUpdates;
  };

  static std::vector<SwapChainUpgradeTarget> swapChainUpgradeTargets = {};

  static reshade::api::effect_runtime* currentEffectRuntime = nullptr;
  static reshade::api::color_space currentColorSpace = reshade::api::color_space::unknown;
  static bool needsSRGBPostProcess = false;
  static reshade::api::format targetFormat = reshade::api::format::r16g16b16a16_float;
  static reshade::api::format targetFormatTypeless = reshade::api::format::r16g16b16a16_typeless;
  static reshade::api::color_space targetColorSpace = reshade::api::color_space::extended_srgb_linear;

  static void on_init_device(reshade::api::device* device) {
    std::stringstream s;
    s << "init_device("
      << reinterpret_cast<void*>(device)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    auto &data = device->create_private_data<device_data>();
    data.preventFullScreen = preventFullScreen;
  }

  static void on_destroy_device(reshade::api::device* device) {
    std::stringstream s;
    s << "destroy_device("
      << reinterpret_cast<void*>(device)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    device->destroy_private_data<device_data>();
  }

  // Clones resource and schedules render target assignments
  // Will also fix descriptor tables that are using
  static reshade::api::resource cloneResource(
    reshade::api::device* device,
    device_data* privateData,
    const reshade::api::resource_desc &new_desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource
  ) {
    reshade::api::resource cloneResource = {0};

    device->create_resource(
      new_desc,
      nullptr,
      initial_state,
      &cloneResource
    );
    privateData->clonedResources[resource.handle] = cloneResource.handle;
    privateData->resourcesThatNeedResourceViewClones.emplace(resource.handle);
    return cloneResource;
  }

  // Before CreatePipelineState
  static bool on_create_swapchain(reshade::api::swapchain_desc &desc, void* hwnd) {
    auto oldFormat = desc.back_buffer.texture.format;
    auto oldPresentMode = desc.present_mode;
    auto oldPresentFlags = desc.present_flags;
    auto oldBufferCount = desc.back_buffer_count;

    if (!useResizeBuffer) {
      desc.back_buffer.texture.format = targetFormat;

      if (desc.back_buffer_count == 1) {
        // 0 is only for resize, so if game uses more than 2 buffers, that will be retained
        desc.back_buffer_count = 2;
      }
    }

    switch (desc.present_mode) {
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL);
        break;
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
        break;
    }

    if (!useResizeBuffer) {
      if (preventFullScreen) {
        desc.present_flags &= ~DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
      }
      desc.present_flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;
    }

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

    return (oldFormat != desc.back_buffer.texture.format)
        || (oldPresentMode != desc.present_mode)
        || (oldPresentFlags != desc.present_flags);
  }

  static bool changeColorSpace(reshade::api::swapchain* swapchain, reshade::api::color_space colorSpace) {
    DXGI_COLOR_SPACE_TYPE dxColorSpace = DXGI_COLOR_SPACE_CUSTOM;
    switch (colorSpace) {
      case reshade::api::color_space::srgb_nonlinear:       dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709; break;
      case reshade::api::color_space::extended_srgb_linear: dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709; break;
      case reshade::api::color_space::hdr10_st2084:         dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020; break;
      case reshade::api::color_space::hdr10_hlg:            dxColorSpace = DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P2020; break;
      default:                                              return false;
    }

    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    IDXGISwapChain4* swapchain4;

    if (!SUCCEEDED(native_swapchain->QueryInterface(IID_PPV_ARGS(&swapchain4)))) {
      reshade::log_message(reshade::log_level::error, "changeColorSpace(Failed to get native swap chain)");
      return false;
    }

    HRESULT hr = swapchain4->SetColorSpace1(dxColorSpace);
    swapchain4->Release();
    swapchain4 = nullptr;
    if (!SUCCEEDED(hr)) {
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
    if (!preventFullScreen && !forceBorderless) return;
    HWND outputWindow = (HWND)swapchain->get_hwnd();
    if (outputWindow == nullptr) {
      reshade::log_message(reshade::log_level::debug, "No HWND?");
      return;
    }

    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    if (preventFullScreen) {
      IDXGIFactory* factory;
      if (SUCCEEDED(native_swapchain->GetParent(IID_PPV_ARGS(&factory)))) {
        factory->MakeWindowAssociation(outputWindow, DXGI_MWA_NO_WINDOW_CHANGES);
        reshade::log_message(reshade::log_level::debug, "checkSwapchainSize(set DXGI_MWA_NO_WINDOW_CHANGES)");
        factory->Release();
        factory = nullptr;
      } else {
        reshade::log_message(reshade::log_level::error, "checkSwapchainSize(could not find DXGI factory)");
      }
    }

    if (forceBorderless) {
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
  }

  static void on_init_swapchain(reshade::api::swapchain* swapchain) {
    auto device = swapchain->get_device();
    if (!device) return;
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);

    reshade::log_message(reshade::log_level::debug, "initSwapChain(reset resource upgrade)");
    data.resourceUpgradeFinished = false;
    uint32_t len = swapChainUpgradeTargets.size();
    // Reset
    for (uint32_t i = 0; i < len; i++) {
      SwapChainUpgradeMod::SwapChainUpgradeTarget* target = &swapChainUpgradeTargets.data()[i];
      target->_counted = 0;
      target->completed = false;
    }

    auto deviceBackBufferDesc = SwapchainUtil::getBackBufferDesc(device);
    checkSwapchainSize(swapchain, deviceBackBufferDesc);

    if (useResizeBuffer && deviceBackBufferDesc.texture.format != targetFormat) {
      reshade::log_message(reshade::log_level::debug, "Wrong swapchain format. Resizing...");
      IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

      IDXGISwapChain4* swapchain4;

      if (FAILED(native_swapchain->QueryInterface(IID_PPV_ARGS(&swapchain4)))) {
        reshade::log_message(reshade::log_level::error, "initSwapchain(Failed to get native swap chain)");
        return;
      }

      DXGI_SWAP_CHAIN_DESC1 desc;
      if (FAILED(swapchain4->GetDesc1(&desc))) {
        reshade::log_message(reshade::log_level::error, "initSwapchain(Failed to get desc)");
        swapchain4->Release();
        swapchain4 = nullptr;
        return;
      }

      HRESULT hr = swapchain4->ResizeBuffers(
        desc.BufferCount == 1 ? 2 : 0,
        desc.Width,
        desc.Height,
        (targetFormat == reshade::api::format::r16g16b16a16_float)
          ? DXGI_FORMAT_R16G16B16A16_FLOAT
          : DXGI_FORMAT_R10G10B10A2_UNORM,
        desc.Flags
      );

      swapchain4->Release();
      swapchain4 = nullptr;

      if (hr == DXGI_ERROR_INVALID_CALL) {
        reshade::log_message(reshade::log_level::error, "initSwapchain(DXGI_ERROR_INVALID_CALL)");
        return;
      }
      std::stringstream s;
      s << "initSwapChain("
        << "resize: " << hr
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

  // After CreatePipelineState
  static bool on_create_pipeline(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects
  ) {
    // DX12 can use PSO objects that need to be cloned
    reshade::api::pipeline_subobject* newSubobjects = nullptr;

    uint32_t foundShader = 0;
    bool modded = false;
    for (uint32_t i = 0; i < subobject_count; ++i) {
      if (subobjects[i].type == reshade::api::pipeline_subobject_type::render_target_formats) {
        reshade::api::format* formats = (reshade::api::format*)subobjects[i].data;
        if (subobjects[i].count == 1) {
          const_cast<reshade::api::pipeline_subobject*>(subobjects)[i].data = nullptr;
          const_cast<reshade::api::pipeline_subobject*>(subobjects)[i].count = 0;
          modded = true;
        }
        // for (size_t j = 0; j < subobjects[i].count; j++) {
        //   switch (formats[j]) {
        //     case reshade::api::format::r8g8b8a8_unorm:
        //     case reshade::api::format::r8g8b8a8_unorm_srgb:
        //       formats[j] = reshade::api::format::unknown;
        //       modded = true;
        //       break;
        //     default:
        //       break;
        //   }
        // }
      }
    }
    if (modded) {
      std::stringstream s;
      s << "init_pipeline(modded resource)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
    return modded;
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
    switch (desc.type) {
      case reshade::api::resource_type::texture_2d:
      case reshade::api::resource_type::surface:
        break;
      case reshade::api::resource_type::unknown:
        reshade::log_message(reshade::log_level::warning, "Unknown resource type");
      default:
        return false;
    }

    auto &privateData = device->get_private_data<device_data>();
    std::unique_lock lock(privateData.mutex);
    if (privateData.resourceUpgradeFinished) return false;

    auto deviceBackBufferDesc = SwapchainUtil::getBackBufferDesc(device);
    if (deviceBackBufferDesc.type == reshade::api::resource_type::unknown) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "createResource(Unknown device "
        << reinterpret_cast<void*>(device)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
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
      if (
        !target->useResourceViewCloning
        && oldFormat == target->oldFormat
        && (target->ignoreSize || ((desc.texture.height == deviceBackBufferDesc.texture.height) && (desc.texture.width == deviceBackBufferDesc.texture.width)))
        && (target->state == reshade::api::resource_usage::undefined || (desc.usage == target->state))
      ) {
        s << "createResource(counting target"
          << ", format: " << to_string(target->oldFormat)
          << ", usage: " << std::hex << (uint32_t)desc.usage << std::dec
          << ", index: " << target->index
          << ", counted: " << target->_counted
          << ", data: " << reinterpret_cast<void*>(initial_data)
          << ") [" << i << "/" << len << "]";
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
      << ", format: " << to_string(oldFormat) << " => " << to_string(newFormat)
      << ", width: " << (uint32_t)desc.texture.width
      << ", height: " << (uint32_t)desc.texture.height
      << ", usage: " << to_string(desc.usage) << "(" << std::hex << (uint32_t)(desc.usage) << std::dec << ")"
      << ", complete: " << allCompleted;
    reshade::api::resource originalResource = {0};
    if (useResourceFallbacks) {
      device->create_resource(
        desc,
        initial_data,
        initial_state,
        &originalResource
      );
      s << ", fallback: " << reinterpret_cast<void*>(originalResource.handle);

    } else {
      desc.texture.format = newFormat;
    }

    s << ")";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );

    privateData.originalResource = originalResource;
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
    if (!device) {
      std::stringstream s;
      s << "init_resource(Empty device)";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      return;
    }

    auto &privateData = device->get_private_data<device_data>();
    std::unique_lock lock(privateData.mutex);

    switch (desc.type) {
      case reshade::api::resource_type::texture_2d:
      case reshade::api::resource_type::surface:
        break;
      case reshade::api::resource_type::unknown:
        reshade::log_message(reshade::log_level::warning, "Unknown resource type");
      default:
        if (privateData.upgradedResource) {
          reshade::log_message(reshade::log_level::warning, "Modified??");
          privateData.upgradedResource = false;
        }
        return;
    }

    std::stringstream s;
    s << "on_init_resource(tracking "
      << reinterpret_cast<void*>(resource.handle)
      << ", flags: " << std::hex << (uint32_t)desc.flags << std::dec
      << ", state: " << std::hex << (uint32_t)initial_state << std::dec
      << ", width: " << (uint32_t)desc.texture.width
      << ", height: " << (uint32_t)desc.texture.height
      << ", format: " << to_string(desc.texture.format);
    if (privateData.upgradedResource) {
      privateData.upgradedResource = false;

      privateData.upgradedResources[resource.handle] = privateData.originalResource;
      if (privateData.originalResource.handle) {
        s << ", fallback: " << reinterpret_cast<void*>(privateData.originalResource.handle);
        privateData.originalResource = {0};
      } else {
        s << ", fallback: (none)";
      }
    } else if (useResourceCloning) {
      if (privateData.resourceUpgradeFinished) return;
      auto deviceBackBufferDesc = SwapchainUtil::getBackBufferDesc(device);
      if (deviceBackBufferDesc.type == reshade::api::resource_type::unknown) {
#if DEBUG_LEVEL >= 1
        std::stringstream s;
        s << "init_resource(Unknown device "
          << reinterpret_cast<void*>(device)
          << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
        return;
      }

      uint32_t len = swapChainUpgradeTargets.size();

      auto oldFormat = desc.texture.format;
      auto newFormat = desc.texture.format;

      bool allCompleted = true;
      bool hotSwap = false;
      bool matched = false;
      for (uint32_t i = 0; i < len; i++) {
        SwapChainUpgradeMod::SwapChainUpgradeTarget* target = &swapChainUpgradeTargets.data()[i];
        std::stringstream s;
        if (target->completed) continue;
        if (
          target->useResourceViewCloning
          && oldFormat == target->oldFormat
          && (target->ignoreSize || ((desc.texture.height == deviceBackBufferDesc.texture.height) && (desc.texture.width == deviceBackBufferDesc.texture.width)))
          && (target->state == reshade::api::resource_usage::undefined || (desc.usage == target->state))
        ) {
          s << "on_init_resource(counting target"
            << ", format: " << to_string(target->oldFormat)
            << ", usage: " << std::hex << (uint32_t)desc.usage << std::dec
            << ", index: " << target->index
            << ", counted: " << target->_counted
            << ") [" << i << "/" << len << "]";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());

          target->_counted++;
          if (matched) continue;
          if ((target->index + 1) == target->_counted) {
            newFormat = target->newFormat;
            target->completed = true;
            hotSwap = target->useResourceViewHotSwap;
            matched = true;
            continue;
          }
          if (target->index == -1) {
            newFormat = target->newFormat;
            allCompleted = false;
            hotSwap = target->useResourceViewHotSwap;
            matched = true;
            continue;
          }
        }
        allCompleted = false;
      }
      if (oldFormat == newFormat) {
        return;
      }
      if (allCompleted) {
        privateData.resourceUpgradeFinished = true;
      }

      reshade::api::resource_desc new_desc = desc;
      new_desc.texture.format = newFormat;
      reshade::api::resource clonedResource = cloneResource(
        device,
        &privateData,
        new_desc,
        initial_data,
        initial_state,
        resource
      );
      if (!hotSwap) {
        privateData.enabledClonedResources.emplace(clonedResource.handle);
      }
      s << ", clone: " << reinterpret_cast<void*>(clonedResource.handle);
      s << ", hotswap: " << (hotSwap ? "true" : "false");
    } else {
      // Nothing to do
      return;
    }

    s << ")";

    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
  }

  static void on_destroy_resource(reshade::api::device* device, reshade::api::resource resource) {
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);
#if DEBUG_LEVEL >= 1
    {
      std::stringstream s;
      s << "on_destroy_resource(destroy resource"
        << ", resource: " << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif

    if (
      auto pair = data.upgradedResources.find(resource.handle);
      pair != data.upgradedResources.end()
    ) {
      device->destroy_resource(pair->second);
      data.upgradedResources.erase(resource.handle);
    }

    if (useResourceCloning) {
      if (
        auto pair = data.clonedResources.find(resource.handle);
        pair != data.clonedResources.end()
      ) {
        auto cloneResource = reshade::api::resource{pair->second};
#if DEBUG_LEVEL >= 1
        std::stringstream s;
        s << "on_destroy_resource(destroy cloned resource and views"
          << ", resource: " << (void*)resource.handle
          << ", clone: " << (void*)cloneResource.handle
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

        data.enabledClonedResources.erase(cloneResource.handle);
        data.clonedDescriptorUpdates.erase(resource.handle);  // vector leak
        data.clonedDescriptorResets.erase(resource.handle);   // vector leak
        if (
          auto pair = data.uavResourceViewClones.find(resource.handle);
          pair != data.uavResourceViewClones.end()
        ) {
          device->destroy_resource_view(reshade::api::resource_view{pair->second});
          data.uavResourceViewClones.erase(resource.handle);
        }

        if (
          auto pair = data.shaderResourceViewClones.find(resource.handle);
          pair != data.shaderResourceViewClones.end()
        ) {
          device->destroy_resource_view(reshade::api::resource_view{pair->second});
          data.shaderResourceViewClones.erase(resource.handle);
        }

        if (
          auto pair = data.renderTargetResourceViewClones.find(resource.handle);
          pair != data.renderTargetResourceViewClones.end()
        ) {
          device->destroy_resource_view(reshade::api::resource_view{pair->second});
          data.renderTargetResourceViewClones.erase(resource.handle);
        }

        device->destroy_resource(cloneResource);
        data.clonedResources.erase(resource.handle);
      }
    }
  }

  static bool on_copy_buffer_to_texture(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint64_t source_offset,
    uint32_t row_length,
    uint32_t slice_height,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box
  ) {
    auto device = cmd_list->get_device();
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);

    if (
      auto pair = data.upgradedResources.find(dest.handle);
      pair != data.upgradedResources.end()
    ) {
      reshade::api::resource fallback_resource = {pair->second.handle};

      if (
        auto pair = data.rebuiltBuffers.find(source.handle);
        pair != data.rebuiltBuffers.end()
      ) {
        reshade::api::resource rebuiltBuffer = {pair->second};

        cmd_list->copy_buffer_to_texture(
          rebuiltBuffer,
          source_offset * 2,
          row_length,
          slice_height,
          dest,
          dest_subresource,
          dest_box
        );
        std::stringstream s;
        s << "on_copy_buffer_to_texture(used buffer: "
          << reinterpret_cast<void*>(rebuiltBuffer.handle)
          << " for "
          << reinterpret_cast<void*>(source.handle)
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
        return true;
      } else {
        std::stringstream s;
        s << "on_copy_buffer_to_texture(buffer not built for: "
          << reinterpret_cast<void*>(source.handle)
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }

      auto fallback_desc = device->get_resource_desc(fallback_resource);

      auto buffer_desc = device->get_resource_desc(source);
      void* mapped_ptr;
      if (device->map_buffer_region(source, source_offset, ~0ull, reshade::api::map_access::read_only, &mapped_ptr)) {
        std::stringstream s;
        s << "on_copy_buffer_to_texture(got data)";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());

        reshade::api::subresource_data old_resource_data;

        old_resource_data.data = mapped_ptr;

        uint8_t* data_p = static_cast<uint8_t*>(old_resource_data.data);
        // Add sufficient padding for block compressed textures that are not a multiple of 4 in all dimensions
        std::vector<uint16_t> rgba16_pixel_data(fallback_desc.texture.height * fallback_desc.texture.width * 4);

        {
          std::stringstream s;
          s << "on_copy_buffer_to_texture(will build "
            << rgba16_pixel_data.size()
            << ", row pitch: " << old_resource_data.row_pitch
            << ", slice_path: " << old_resource_data.slice_pitch
            << ", height: " << fallback_desc.texture.height
            << ", width: " << fallback_desc.texture.width
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
        }

        for (size_t y = 0; y < fallback_desc.texture.height; ++y, data_p += old_resource_data.row_pitch) {
          for (size_t x = 0; x < fallback_desc.texture.width; ++x) {
            const uint8_t* const src = data_p + x * 4;
            uint16_t* const dst = rgba16_pixel_data.data() + ((y * fallback_desc.texture.width + x) * 4);

            dst[0] = float2half_rn(src[0] / 255.0f);
            dst[1] = float2half_rn(src[1] / 255.0f);
            dst[2] = float2half_rn(src[2] / 255.0f);
            dst[3] = float2half_rn(src[3] / 255.0f);
          }
        }

        {
          std::stringstream s;
          s << "on_copy_buffer_to_texture(will unmap)";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
        }
        device->unmap_buffer_region(source);

        // Create new buffer
        reshade::api::resource_desc new_buffer_desc;
        new_buffer_desc.type = reshade::api::resource_type::buffer;
        new_buffer_desc.buffer.size = rgba16_pixel_data.size() * sizeof(uint16_t);
        reshade::api::resource new_resource;
        reshade::api::subresource_data new_data;
        new_data.data = rgba16_pixel_data.data();
        new_data.row_pitch = fallback_desc.texture.width;
        new_data.slice_pitch = new_data.row_pitch * fallback_desc.texture.height;

        {
          std::stringstream s;
          s << "on_copy_buffer_to_texture(will create new texture: "
            << new_buffer_desc.buffer.size
            << " from "
            << reinterpret_cast<void*>(rgba16_pixel_data.data())
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
        }

        if (device->create_resource(
              new_buffer_desc,
              &new_data,
              reshade::api::resource_usage::general,
              &new_resource
            )) {
          data.rebuiltBuffers[source.handle] = new_resource;
          std::stringstream s;
          s << "on_copy_buffer_to_texture(made new resource: "
            << reinterpret_cast<void*>(new_resource.handle)
            << " for "
            << reinterpret_cast<void*>(source.handle)
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
          cmd_list->copy_buffer_to_texture(
            new_resource,
            source_offset * 2,
            row_length,
            slice_height,
            dest,
            dest_subresource,
            dest_box
          );

        } else {
          reshade::log_message(reshade::log_level::error, "on_copy_buffer_to_texture(failed to make)");
        }

      } else {
        std::stringstream s;
        s << "on_copy_buffer_to_texture(no got data)";
        reshade::log_message(reshade::log_level::error, s.str().c_str());
      }
      {
        std::stringstream s;
        s << "on_copy_buffer_to_texture(done)";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
      }
      return true;
    }

    return false;
  }

  static bool on_create_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc &desc
  ) {
    if (!resource.handle) return false;
    bool expected = false;

    auto &privateData = device->get_private_data<device_data>();
    std::unique_lock lock(privateData.mutex);

    if (!upgradeUnknownResourceViews && desc.format == reshade::api::format::unknown) {
      return false;
    }
    reshade::api::resource_view_desc new_desc = desc;
    reshade::api::resource_desc resource_desc = device->get_resource_desc(resource);
    if (upgradeResourceViews && SwapchainUtil::isBackBuffer(device, resource)) {
      new_desc.format = targetFormat;
      expected = true;
    } else if (privateData.upgradedResources.contains(resource.handle) || privateData.clonedResources.contains(resource.handle)) {
      switch (desc.format) {
        case reshade::api::format::r8g8b8a8_typeless:
        case reshade::api::format::b8g8r8a8_typeless:
        case reshade::api::format::r10g10b10a2_typeless:
          new_desc.format = reshade::api::format::r16g16b16a16_typeless;
          break;
        case reshade::api::format::r8g8b8a8_unorm:
        case reshade::api::format::b8g8r8a8_unorm:
        case reshade::api::format::r8g8b8a8_snorm:
          // Should upgrade shader
          new_desc.format = targetFormat;
          break;
        case reshade::api::format::r8g8b8a8_unorm_srgb:
        case reshade::api::format::b8g8r8a8_unorm_srgb:
          new_desc.format = targetFormat;
          break;
        case reshade::api::format::b10g10r10a2_unorm:
        case reshade::api::format::r10g10b10a2_unorm:
          // Should upgrade shader
          new_desc.format = targetFormat;
          break;
        default:
          break;
      }
      expected = true;
    } else if (resource_desc.texture.format == targetFormat || resource_desc.texture.format == reshade::api::format::r16g16b16a16_typeless) {
      switch (new_desc.format) {
        case reshade::api::format::r8g8b8a8_typeless:
        case reshade::api::format::b8g8r8a8_typeless:
        case reshade::api::format::r10g10b10a2_typeless:
          new_desc.format = reshade::api::format::r16g16b16a16_typeless;
          break;
        case reshade::api::format::r8g8b8a8_unorm:
        case reshade::api::format::b8g8r8a8_unorm:
          new_desc.format = targetFormat;
          break;
        case reshade::api::format::r8g8b8a8_unorm_srgb:
        case reshade::api::format::b8g8r8a8_unorm_srgb:
          // Should upgrade shader
          new_desc.format = targetFormat;
          break;
        case reshade::api::format::b10g10r10a2_unorm:
          new_desc.format = targetFormat;
          break;
        default:
          break;
      }
    } else {
      return false;
    }

    bool changed = (desc.format != new_desc.format);
    std::stringstream s;
    s << "createResourceView("
      << (changed ? "upgrading" : "logging")
      << ", expected: " << (expected ? "true" : "false")
      << ", view type: " << to_string(desc.type)
      << ", view format: " << to_string(desc.format) << " => " << to_string(new_desc.format)
      << ", resource: " << reinterpret_cast<void*>(resource.handle)
      << ", resource width: " << resource_desc.texture.width
      << ", resource height: " << resource_desc.texture.height
      << ", resource format: " << to_string(resource_desc.texture.format)
      << ", resource usage: " << to_string(usage_type)
      << ")";
    reshade::log_message(
      desc.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );

    if (!changed) return false;
    if (useResourceFallbacks) {
      reshade::api::resource_view originalResourceView = {0};
      reshade::api::resource originalResource = resource;
      {
        if (
          auto pair = privateData.upgradedResources.find(resource.handle);
          pair != privateData.upgradedResources.end()
        ) {
          originalResource = pair->second;
          device->create_resource_view(
            originalResource,
            usage_type,
            desc,
            &originalResourceView
          );
          privateData.originalResourceView = originalResourceView;
        } else {
          privateData.originalResourceView = {};
        }
      }
    } else if (
      useResourceCloning
      && privateData.resourcesThatNeedResourceViewClones.contains(resource.handle)
    ) {
      reshade::api::resource_view clonedResourceView = {0};
      reshade::api::resource clonedResourceViewResource = resource;

      if (
        auto pair = privateData.clonedResources.find(resource.handle);
        pair != privateData.clonedResources.end()
      ) {
        clonedResourceViewResource = {pair->second};
      }

      device->create_resource_view(
        clonedResourceViewResource,
        usage_type,
        new_desc,
        &clonedResourceView
      );
      std::stringstream s;
      s << "createResourceView(made clone:"
        << reinterpret_cast<void*>(clonedResourceView.handle)
        << ", resource: " << reinterpret_cast<void*>(resource.handle);
      if (clonedResourceViewResource.handle != resource.handle) {
        s << " => " << reinterpret_cast<void*>(clonedResourceViewResource.handle);
      }

      if (usage_type == reshade::api::resource_usage::unordered_access) {
        privateData.uavResourceViewClones[resource.handle] = clonedResourceView.handle;
        s << ", type: uav";
      }
      if (usage_type == reshade::api::resource_usage::render_target) {
        privateData.renderTargetResourceViewClones[resource.handle] = clonedResourceView.handle;
        s << ", type: render_target";
      }
      if (usage_type == reshade::api::resource_usage::shader_resource) {
        privateData.shaderResourceViewClones[resource.handle] = clonedResourceView.handle;
        s << ", type: shader_resource";
      }
      ResourceUtil::setResourceFromResourceView(device, clonedResourceView, clonedResourceViewResource);

      s << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
      return false;
    }

    desc.format = new_desc.format;
    privateData.upgradedResourceView = true;
    return true;
  }

  static void on_init_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc &desc,
    reshade::api::resource_view view
  ) {
    if (!resource.handle) return;
    auto &privateData = device->get_private_data<device_data>();
    std::unique_lock lock(privateData.mutex);
    if (!privateData.upgradedResourceView) return;
    privateData.upgradedResourceView = false;
    if (privateData.originalResourceView.handle) {
      privateData.upgradedResourceViews[view.handle] = privateData.originalResourceView;
      privateData.originalResourceView = {0};
    }
  }

  static void on_destroy_resource_view(reshade::api::device* device, reshade::api::resource_view view) {
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);

    if (
      auto pair = data.upgradedResourceViews.find(view.handle);
      pair != data.upgradedResourceViews.end()
    ) {
      device->destroy_resource_view(pair->second);
      data.upgradedResourceViews.erase(view.handle);
    }
  }

  static reshade::api::resource_view findReplacementResourceView(
    reshade::api::device* device,
    reshade::api::resource_view resourceView,
    reshade::api::resource_usage usage
  ) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "findReplacementResourceView(looking for : "
      << (void*)resourceView.handle
      << ", usage: " << to_string(usage)
      << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

    auto resource = ResourceUtil::getResourceFromResourceView(device, resourceView);
    if (!resource.handle) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "findReplacementResourceView(not found: "
        << (void*)resourceView.handle
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      return resourceView;
    }

    auto &data = device->get_private_data<device_data>();
    std::shared_lock lock(data.mutex);

    std::unordered_map<uint64_t, uint64_t>* viewClonesMap;
    switch (usage) {
      case reshade::api::resource_usage::shader_resource:
        viewClonesMap = &data.shaderResourceViewClones;
        break;
      case reshade::api::resource_usage::unordered_access:
        viewClonesMap = &data.uavResourceViewClones;
        break;
      case reshade::api::resource_usage::render_target:
        viewClonesMap = &data.renderTargetResourceViewClones;
        break;
      default:
        std::stringstream s;
#ifdef DEBUG_LEVEL_1
        s << "findReplacementResourceView(unknown usage: "
          << (void*)resourceView.handle
          << ", usage: " << to_string(usage)
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        return resourceView;
    }

    auto pair2 = viewClonesMap->find(resource.handle);
    if (pair2 != viewClonesMap->end()) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "findReplacementResourceView(found: "
        << "rsv: " << (void*)resourceView.handle
        << " => "
        << "res: " << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      return reshade::api::resource_view{pair2->second};
    }
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "findReplacementResourceView(no clone exists: "
        << "rsv: " << (void*)resourceView.handle
        << " => "
        << "res: " << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif
    return resourceView;
  }

  static reshade::api::resource_view findReplacementResourceView(
    reshade::api::device* device,
    reshade::api::resource_view resourceView,
    reshade::api::descriptor_type type
  ) {
    switch (type) {
      case reshade::api::descriptor_type::sampler_with_resource_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::shader_resource_view:
        return findReplacementResourceView(device, resourceView, reshade::api::resource_usage::shader_resource);
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::unordered_access_view:
        return findReplacementResourceView(device, resourceView, reshade::api::resource_usage::unordered_access);
      default:
        return findReplacementResourceView(device, resourceView, reshade::api::resource_usage::undefined);
    }
  }

  static void queueResourceViewInDescriptorTable(
    device_data &data,
    reshade::api::resource resource,
    reshade::api::descriptor_table_update oldUpdate,
    reshade::api::descriptor_table_update newUpdate
  ) {
    if (
      auto pair = data.clonedDescriptorResets.find(resource.handle);
      pair != data.clonedDescriptorResets.end()
    ) {
      std::vector<reshade::api::descriptor_table_update> &vector = *pair->second;
      size_t oldSize = vector.size();
      vector.push_back(oldUpdate);
      std::stringstream s;
      s << "queueResourceViewInDescriptorTable(added queue reset "
        << (void*)resource.handle
        << ", size: " << oldSize << " => " << vector.size()
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());

    } else {
      data.clonedDescriptorResets[resource.handle] = new std::vector<reshade::api::descriptor_table_update>{oldUpdate};
      std::stringstream s;
      s << "queueResourceViewInDescriptorTable(new queue reset "
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }

    if (
      auto pair = data.clonedDescriptorUpdates.find(resource.handle);
      pair != data.clonedDescriptorUpdates.end()
    ) {
      std::vector<reshade::api::descriptor_table_update> &vector = *pair->second;
      size_t oldSize = vector.size();
      vector.push_back(newUpdate);
      std::stringstream s;
      s << "queueResourceViewInDescriptorTable(added queue update "
        << (void*)resource.handle
        << ", size: " << oldSize << " => " << vector.size()
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    } else {
      data.clonedDescriptorUpdates[resource.handle] = new std::vector<reshade::api::descriptor_table_update>{newUpdate};
      std::stringstream s;
      s << "queueResourceViewInDescriptorTable(new queue update "
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
  }

  static bool flushResourceViewInDescriptorTable(
    reshade::api::device* device,
    reshade::api::resource resource
  ) {
    auto &data = device->get_private_data<device_data>();
    // std::shared_lock lock(data.mutex);

#if DEBUG_LEVEL >= 1
    {
      std::stringstream s;
      s << "flushResourceViewInDescriptorTable(resource: "
        << (void*)resource.handle
        << ", device: " << (void*)device
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif

    auto pair = data.clonedDescriptorUpdates.find(resource.handle);
    if (pair == data.clonedDescriptorUpdates.end()) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "flushResourceViewInDescriptorTable(update never queued "
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      return false;
    }

    std::vector<reshade::api::descriptor_table_update> &vector = *pair->second;

    if (!vector.size()) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "flushResourceViewInDescriptorTable(queue is empty!"
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      return false;
    }
#if DEBUG_LEVEL >= 1
    {
      std::stringstream s;
      s << "flushResourceViewInDescriptorTable(found updates"
        << (void*)resource.handle
        << ", size: " << vector.size()
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif

    for (auto update : vector) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "flushResourceViewInDescriptorTable(flush update "
        << (void*)resource.handle
        << ", table: " << (void*)update.table.handle
        << ", array_offset: " << update.array_offset
        << ", binding: " << update.binding
        << ", count: " << update.count
        << ", type: " << to_string(update.type)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      device->update_descriptors(update);
    }

    return true;
  }

  static bool resetResourceViewInDescriptorTable(
    reshade::api::device* device,
    reshade::api::resource resource
  ) {
    auto &data = device->get_private_data<device_data>();
    // std::shared_lock lock(data.mutex);

#if DEBUG_LEVEL >= 1
    {
      std::stringstream s;
      s << "resetResourceViewInDescriptorTable(resource: "
        << (void*)resource.handle
        << ", device: " << (void*)device
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif

    auto pair = data.clonedDescriptorResets.find(resource.handle);
    if (pair == data.clonedDescriptorResets.end()) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "resetResourceViewInDescriptorTable(update never queued "
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      return false;
    }

    std::vector<reshade::api::descriptor_table_update> &vector = *pair->second;

    if (!vector.size()) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "resetResourceViewInDescriptorTable(queue is empty!"
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      return false;
    }
#if DEBUG_LEVEL >= 1
    {
      std::stringstream s;
      s << "resetResourceViewInDescriptorTable(found updates"
        << (void*)resource.handle
        << ", size: " << vector.size()
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif

    for (auto update : vector) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "resetResourceViewInDescriptorTable(flush update "
        << (void*)resource.handle
        << ", table: " << (void*)update.table.handle
        << ", array_offset: " << update.array_offset
        << ", binding: " << update.binding
        << ", count: " << update.count
        << ", type: " << to_string(update.type)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      device->update_descriptors(update);
    }

    // vector.clear();
    return true;
  }

  static void on_present_for_descriptor_reset(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects
  ) {
    reshade::unregister_event<reshade::addon_event::present>(on_present_for_descriptor_reset);
    auto device = swapchain->get_device();
    if (!device) return;
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);
    if (!data.enabledClonedResources.size()) return;
#if DEBUG_LEVEL >= 1
    std::stringstream s;
    s << "on_present(reset on present)";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    data.enabledClonedResources.clear();
    for (uint64_t resourceHandle : data.flushedResourceViewUpdates) {
      auto resource = reshade::api::resource{resourceHandle};

      resetResourceViewInDescriptorTable(device, resource);

      if (
        auto pair = data.clonedResources.find(resource.handle);
        pair != data.clonedResources.end()
      ) {
        auto cloneResource = reshade::api::resource{pair->second};
        data.enabledClonedResources.emplace(cloneResource.handle);
      }
    }
    data.flushedResourceViewUpdates.clear();
  }

  static bool activateCloneHotSwap(
    reshade::api::device* device,
    reshade::api::resource_view resource_view
  ) {
    auto resource = ResourceUtil::getResourceFromResourceView(device, resource_view);
    if (!resource.handle) {
      std::stringstream s;
      s << "activateCloneHotSwap(no handle for rsv "
        << (void*)resource_view.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      return false;
    }
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);

    reshade::api::resource cloneResource;

    auto clonedResourcePair = data.clonedResources.find(resource.handle);
    if (clonedResourcePair == data.clonedResources.end()) {
#if DEBUG_LEVEL >= 1
      std::stringstream s;
      s << "activateCloneHotSwap(";
      if (SwapchainUtil::isBackBuffer(device, resource)) {
        s << ("backbuffer ");
      }
      s << "not cloned "
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      // Resource is not a cloned resource (fail)
      return false;
    }

    cloneResource = reshade::api::resource{clonedResourcePair->second};

    if (data.enabledClonedResources.contains(cloneResource.handle)) {
      // Already activated
      return true;
    }

#if DEBUG_LEVEL >= 1
    {
      std::stringstream s;
      s << "activateCloneHotSwap(activating: "
        << (void*)resource.handle
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
    if (!data.shaderResourceViewClones.contains(resource.handle)) {
      std::stringstream s;
      s << "activateCloneHotSwap(no srv "
        << (void*)resource.handle
        << " => "
        << (void*)cloneResource.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }

    if (!data.uavResourceViewClones.contains(resource.handle)) {
      std::stringstream s;
      s << "activateCloneHotSwap(no uav "
        << (void*)resource.handle
        << " => "
        << (void*)cloneResource.handle
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }
#endif

    // data.pendingResourceViewUpdateFlush.emplace(resource.handle);
    flushResourceViewInDescriptorTable(device, resource);
    data.flushedResourceViewUpdates.emplace(cloneResource.handle);

#if DEBUG_LEVEL >= 1
    std::stringstream s;
    s << "activateCloneHotSwap(activated "
      << (void*)resource.handle
      << " => "
      << (void*)cloneResource.handle
      << ")";
    reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif

    reshade::register_event<reshade::addon_event::present>(on_present_for_descriptor_reset);
    data.enabledClonedResources.emplace(cloneResource.handle);
    return true;
  }

  // Create DescriptorTables with RSVs
  static bool on_update_descriptor_tables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates
  ) {
    if (!count) return false;

    size_t size = count * sizeof(reshade::api::descriptor_table_update);

    reshade::api::descriptor_table_update* new_updates = (reshade::api::descriptor_table_update*)malloc(size);
    memcpy(new_updates, updates, size);
    bool changed = false;

    for (uint32_t i = 0; i < count; i++) {
      auto &update = updates[i];
      for (uint32_t j = 0; j < update.count; j++) {
        switch (update.type) {
          case reshade::api::descriptor_type::sampler_with_resource_view:
            {
              auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
              auto resourceView = item.view;
              auto newResourceView = findReplacementResourceView(
                device,
                resourceView,
                reshade::api::resource_usage::shader_resource
              );
              if (resourceView.handle == newResourceView.handle) break;

              auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
              if (!newResource.handle) break;
              auto &data = device->get_private_data<device_data>();
              std::unique_lock lock(data.mutex);

              if (
                auto enabledClonedResource = data.enabledClonedResources.find(newResource.handle);
                enabledClonedResource != data.enabledClonedResources.end()
              ) {
#if DEBUG_LEVEL >= 1
                std::stringstream s;
                s << "update_descriptor_tables(rewriting descriptor table: "
                  << reinterpret_cast<void*>(update.table.handle)
                  << "[" << update.binding + j << "]"
                  << ", rsv: "
                  << reinterpret_cast<void*>(resourceView.handle)
                  << " => "
                  << reinterpret_cast<void*>(newResourceView.handle)
                  << ", type: shader_resource)";
                reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
                ((reshade::api::sampler_with_resource_view*)(new_updates[i].descriptors))[j].view = newResourceView;
                changed = true;
              } else {
                auto resource = ResourceUtil::getResourceFromResourceView(device, resourceView);
#if DEBUG_LEVEL >= 1
                std::stringstream s;
                s << "update_descriptor_tables(queuing descriptor table: "
                  << reinterpret_cast<void*>(update.table.handle)
                  << "[" << update.binding + j << "]"
                  << ", rsv: "
                  << reinterpret_cast<void*>(resourceView.handle)
                  << " => "
                  << reinterpret_cast<void*>(newResourceView.handle)
                  << ", type: shader_resource)";
                reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

                queueResourceViewInDescriptorTable(
                  data,
                  resource,
                  update,
                  reshade::api::descriptor_table_update{
                    .table = update.table,
                    .binding = update.binding + j,
                    .count = 1,
                    .type = update.type,
                    .descriptors = new reshade::api::sampler_with_resource_view{
                                                                                item.sampler,
                                                                                newResourceView}
                }
                );
              }
            }
            break;
          case reshade::api::descriptor_type::buffer_shader_resource_view:
          case reshade::api::descriptor_type::buffer_unordered_access_view:
          case reshade::api::descriptor_type::shader_resource_view:
          case reshade::api::descriptor_type::unordered_access_view:
            {
              auto resourceView = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
              auto newResourceView = findReplacementResourceView(
                device,
                resourceView,
                update.type
              );
              if (resourceView.handle == newResourceView.handle) break;
              auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
              if (!newResource.handle) break;
              auto &data = device->get_private_data<device_data>();
              std::unique_lock lock(data.mutex);

              if (
                auto enabledClonedResource = data.enabledClonedResources.find(newResource.handle);
                enabledClonedResource != data.enabledClonedResources.end()
              ) {
#if DEBUG_LEVEL >= 1
                std::stringstream s;
                s << "update_descriptor_tables(rewriting descriptor table: "
                  << reinterpret_cast<void*>(update.table.handle)
                  << "[" << update.binding + j << "]"
                  << ", rsv: "
                  << reinterpret_cast<void*>(resourceView.handle)
                  << " => "
                  << reinterpret_cast<void*>(newResourceView.handle)
                  << ", type: " << to_string(update.type);
                reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

                ((reshade::api::resource_view*)(new_updates[i].descriptors))[j] = newResourceView;
                changed = true;
              } else {
                auto resource = ResourceUtil::getResourceFromResourceView(device, resourceView);
#if DEBUG_LEVEL >= 1
                std::stringstream s;
                s << "update_descriptor_tables(queuing descriptor table: "
                  << reinterpret_cast<void*>(update.table.handle)
                  << "[" << update.binding + j << "]"
                  << ", rsv: "
                  << reinterpret_cast<void*>(resourceView.handle)
                  << " => "
                  << reinterpret_cast<void*>(newResourceView.handle)
                  << ", type: " << to_string(update.type);
                reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
                queueResourceViewInDescriptorTable(
                  data,
                  resource,
                  update,
                  reshade::api::descriptor_table_update{
                    .table = update.table,
                    .binding = update.binding + j,
                    .count = 1,
                    .type = update.type,
                    .descriptors = new reshade::api::resource_view{
                      newResourceView.handle
                    }
                  }
                );
              }
            }
            break;
          default:
            break;
        }
      }
    }
    if (changed) {
      device->update_descriptor_tables(count, new_updates);
      return true;
    } else {
      // free(new_updates);
    }
    return false;
  }

  // Set DescriptorTables RSVs
  static void on_push_descriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update &update
  ) {
    if (!update.count) return;
    auto device = cmd_list->get_device();

    reshade::api::descriptor_table_update new_update = update;
    bool changed = false;

    for (uint32_t i = 0; i < update.count; i++) {
      switch (update.type) {
        case reshade::api::descriptor_type::sampler_with_resource_view:
          {
            auto resourceView = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i].view;
            auto newResourceView = findReplacementResourceView(
              device,
              resourceView,
              reshade::api::resource_usage::shader_resource
            );
            if (resourceView.handle == newResourceView.handle) break;
            auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
            if (!newResource.handle) break;

            auto &data = device->get_private_data<device_data>();
            std::unique_lock lock(data.mutex);

            if (
              auto enabledClonedResource = data.enabledClonedResources.find(newResource.handle);
              enabledClonedResource != data.enabledClonedResources.end()
            ) {
#if DEBUG_LEVEL >= 1
              std::stringstream s;
              s << "update_descriptor_tables(rewriting descriptor table: "
                << reinterpret_cast<void*>(update.table.handle)
                << "[" << update.binding + i << "]"
                << ", rsv: "
                << reinterpret_cast<void*>(resourceView.handle)
                << " => "
                << reinterpret_cast<void*>(newResourceView.handle)
                << ", type: shader_resource)";
              reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
              ((reshade::api::sampler_with_resource_view*)(new_update.descriptors))[i].view = newResourceView;
              changed = true;
            } else {
              // queueResourceViewInDescriptorTable(
              //   data,
              //   resourceView,
              //   update.table,
              //   update.binding + i,
              //   update.type
              // );
            }

            changed = true;
          }
          break;
        case reshade::api::descriptor_type::shader_resource_view:
          {
            auto resourceView = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
            auto newResourceView = findReplacementResourceView(
              device,
              resourceView,
              reshade::api::resource_usage::shader_resource
            );
            if (resourceView.handle == newResourceView.handle) break;
            auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
            if (!newResource.handle) break;
            auto &data = device->get_private_data<device_data>();
            std::unique_lock lock(data.mutex);

            if (
              auto enabledClonedResource = data.enabledClonedResources.find(newResource.handle);
              enabledClonedResource != data.enabledClonedResources.end()
            ) {
#if DEBUG_LEVEL >= 1
              std::stringstream s;
              s << "update_descriptor_tables(rewriting descriptor table: "
                << reinterpret_cast<void*>(update.table.handle)
                << "[" << update.binding + i << "]"
                << ", rsv: "
                << reinterpret_cast<void*>(resourceView.handle)
                << " => "
                << reinterpret_cast<void*>(newResourceView.handle)
                << ", type: shader_resource)";
              reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
              ((reshade::api::resource_view*)(new_update.descriptors))[i] = resourceView;
              changed = true;
            } else {
              // queueResourceViewInDescriptorTable(
              //   data,
              //   resourceView,
              //   update.table,
              //   update.binding + i,
              //   update.type
              // );
            }
          }
          break;
        case reshade::api::descriptor_type::unordered_access_view:
          {
            auto resourceView = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
            auto newResourceView = findReplacementResourceView(
              device,
              resourceView,
              reshade::api::resource_usage::unordered_access
            );
            if (resourceView.handle == newResourceView.handle) break;
            auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
            if (!newResource.handle) break;
            auto &data = device->get_private_data<device_data>();
            std::unique_lock lock(data.mutex);

            if (
              auto enabledClonedResource = data.enabledClonedResources.find(newResource.handle);
              enabledClonedResource != data.enabledClonedResources.end()
            ) {
#if DEBUG_LEVEL >= 1
              std::stringstream s;
              s << "update_descriptor_tables(rewriting descriptor table: "
                << reinterpret_cast<void*>(update.table.handle)
                << "[" << update.binding + i << "]"
                << ", rsv: "
                << reinterpret_cast<void*>(resourceView.handle)
                << " => "
                << reinterpret_cast<void*>(newResourceView.handle)
                << ", type: unordered_access)";
              reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
              ((reshade::api::resource_view*)(new_update.descriptors))[i] = resourceView;
              changed = true;
            } else {
              // queueResourceViewInDescriptorTable(
              //   data,
              //   resourceView,
              //   update.table,
              //   update.binding + i,
              //   update.type
              // );
            }
          }
          break;
        default:
          break;
      }
    }
    if (changed) {
      cmd_list->push_descriptors(stages, layout, layout_param, new_update);
    }
  }

  static void rewriteRenderTargets(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs
  ) {
    if (!count) return;

    auto device = cmd_list->get_device();
    if (device == nullptr) return;

    size_t size = count * sizeof(reshade::api::resource_view);
    reshade::api::resource_view* new_rtvs = (reshade::api::resource_view*)malloc(size);
    memcpy(new_rtvs, rtvs, count);
    bool changed = false;
    for (uint32_t i = 0; i < count; i++) {
      const reshade::api::resource_view resourceView = rtvs[i];
      if (!resourceView.handle) continue;

      auto newResourceView = findReplacementResourceView(
        device,
        resourceView,
        reshade::api::resource_usage::render_target
      );

      if (resourceView.handle == newResourceView.handle) continue;
      auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
      if (!newResource.handle) continue;

      auto &data = device->get_private_data<device_data>();
      std::unique_lock lock(data.mutex);

      if (
        auto enabledClonedResource = data.enabledClonedResources.find(newResource.handle);
        enabledClonedResource != data.enabledClonedResources.end()
      ) {
#if DEBUG_LEVEL >= 1
        std::stringstream s;
        s << "rewriting render target("
          << reinterpret_cast<void*>(resourceView.handle)
          << " => "
          << reinterpret_cast<void*>(newResourceView.handle)
          << ", res: " << newResource.handle
          << ") [" << i << "]";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        changed = true;
        new_rtvs[i] = newResourceView;
      } else {
#if DEBUG_LEVEL >= 1
        std::stringstream s;
        s << "ignoring render target("
          << reinterpret_cast<void*>(resourceView.handle)
          << " => "
          << reinterpret_cast<void*>(newResourceView.handle)
          << ") [" << i << "]";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      }
    }
    if (!changed) return;
    cmd_list->bind_render_targets_and_depth_stencil(count, new_rtvs);
  }

  // Set render target RSV
  static void on_bind_render_targets_and_depth_stencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv
  ) {
    if (!count) return;

    rewriteRenderTargets(cmd_list, count, rtvs);
  }

  static void on_barrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states
  ) {
    if (!count) return;
    auto device = cmd_list->get_device();
    if (device == nullptr) return;
    device_data &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);
    for (uint32_t i = 0; i < count; i++) {
      auto &resource = resources[i];
      auto &old_state = old_states[i];
      auto &new_state = new_states[i];

      if (
        auto pair = data.clonedResources.find(resource.handle);
        pair != data.clonedResources.end()
      ) {
        auto cloneResource = reshade::api::resource{pair->second};
        if (data.enabledClonedResources.contains(cloneResource.handle)) {
#if DEBUG_LEVEL >= 1
          std::stringstream s;
          s << "on_barrier(apply barrier clone: "
            << reinterpret_cast<void*>(resource.handle)
            << " => "
            << reinterpret_cast<void*>(cloneResource.handle)
            << ", state: " << to_string(old_state) << " => " << to_string(new_state)
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
          cmd_list->barrier(cloneResource, old_state, new_state);
        }
      }
    }
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
    auto device = swapchain->get_device();
    if (!device) return false;
    auto &privateData = device->get_private_data<device_data>();
    std::unique_lock lock(privateData.mutex);
    reshade::log_message(reshade::log_level::debug, "set_fullscreen_state(reset resource upgrade)");
    privateData.resourceUpgradeFinished = false;
    uint32_t len = swapChainUpgradeTargets.size();
    // Reset
    for (uint32_t i = 0; i < len; i++) {
      SwapChainUpgradeMod::SwapChainUpgradeTarget* target = &swapChainUpgradeTargets.data()[i];
      target->_counted = 0;
      target->completed = false;
    }

    if (!fullscreen) return false;
    if (privateData.preventFullScreen) {
      HWND outputWindow = (HWND)swapchain->get_hwnd();
      if (outputWindow) {
        auto deviceBackBufferDesc = SwapchainUtil::getBackBufferDesc(device);
        // HMONITOR monitor = (HMONITOR)hmonitor;
        uint32_t screenWidth = GetSystemMetrics(SM_CXSCREEN);
        uint32_t screenHeight = GetSystemMetrics(SM_CYSCREEN);
        uint32_t textureWidth = deviceBackBufferDesc.texture.width;
        uint32_t textureHeight = deviceBackBufferDesc.texture.height;
        uint32_t top = floor((screenHeight - textureHeight) / 2.f);
        uint32_t left = floor((screenWidth - textureWidth) / 2.f);
        SetWindowLongPtr(outputWindow, GWL_STYLE, WS_VISIBLE | WS_POPUP);
        SetWindowPos(outputWindow, HWND_TOP, left, top, textureWidth, textureHeight, SWP_FRAMECHANGED);
      }
      reshade::log_message(reshade::log_level::info, "Preventing fullscreen");
      return true;
    }
    return false;
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
    ResourceUtil::use(fdwReason);
    SwapchainUtil::use(fdwReason);

    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::init_device>(on_init_device);
        reshade::register_event<reshade::addon_event::destroy_device>(on_destroy_device);

        reshade::register_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);

        // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

        reshade::register_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::register_event<reshade::addon_event::create_resource>(on_create_resource);
        reshade::register_event<reshade::addon_event::destroy_resource>(on_destroy_resource);

        reshade::register_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        reshade::register_event<reshade::addon_event::init_resource_view>(on_init_resource_view);
        reshade::register_event<reshade::addon_event::destroy_resource_view>(on_destroy_resource_view);

        if (useResourceCloning) {
          reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(on_bind_render_targets_and_depth_stencil);
          reshade::register_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
          reshade::register_event<reshade::addon_event::update_descriptor_tables>(on_update_descriptor_tables);
          // reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(on_copy_buffer_to_texture);
          // reshade::register_event<reshade::addon_event::barrier>(on_barrier);
        }

        reshade::register_event<reshade::addon_event::init_effect_runtime>(on_init_effect_runtime);
        reshade::register_event<reshade::addon_event::destroy_effect_runtime>(on_destroy_effect_runtime);

        reshade::register_event<reshade::addon_event::set_fullscreen_state>(on_set_fullscreen_state);

        break;
      case DLL_PROCESS_DETACH:
        reshade::unregister_event<reshade::addon_event::init_device>(on_init_device);
        reshade::unregister_event<reshade::addon_event::destroy_device>(on_destroy_device);

        reshade::unregister_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::unregister_event<reshade::addon_event::init_swapchain>(on_init_swapchain);

        reshade::unregister_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::unregister_event<reshade::addon_event::create_resource>(on_create_resource);

        reshade::unregister_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
        reshade::unregister_event<reshade::addon_event::init_resource_view>(on_init_resource_view);

        reshade::unregister_event<reshade::addon_event::init_effect_runtime>(on_init_effect_runtime);
        reshade::unregister_event<reshade::addon_event::destroy_effect_runtime>(on_destroy_effect_runtime);

        reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(on_set_fullscreen_state);

        break;
    }
  }
}  // namespace SwapChainUpgradeMod
