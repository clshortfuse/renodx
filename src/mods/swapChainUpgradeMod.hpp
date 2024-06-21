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
#include <utility>
#include <vector>

#include <crc32_hash.hpp>
#include <include/reshade.hpp>
#include "../utils/DescriptorTableUtil.hpp"
#include "../utils/ResourceUtil.hpp"
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
    reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
    reshade::api::resource_usage state = reshade::api::resource_usage::undefined;

    const float ASPECT_RATIO_IGNORE = -1.f;
    const float ASPECT_RATIO_BACK_BUFFER = 0.f;
    float aspectRatio = ASPECT_RATIO_IGNORE;

    uint32_t usageSet = 0;
    uint32_t usageUnset = 0;

    bool ignoreReset = false;

    std::unordered_map<reshade::api::resource_usage, std::unordered_map<reshade::api::format, reshade::api::format>> viewUpgrades;

    bool checkResourceDesc(
      reshade::api::resource_desc desc,
      reshade::api::resource_desc backBufferDesc,
      reshade::api::resource_usage state = reshade::api::resource_usage::undefined
    ) {
      if (desc.texture.format != this->oldFormat) return false;
      if (this->usage != reshade::api::resource_usage::undefined) {
        if (this->usage != desc.usage) return false;
      }
      if (this->state != reshade::api::resource_usage::undefined) {
        if (this->state != state) return false;
      }
      if (this->ignoreSize == false) {
        if (this->aspectRatio == ASPECT_RATIO_IGNORE) {
          if (desc.texture.width != backBufferDesc.texture.width) return false;
          if (desc.texture.height != backBufferDesc.texture.height) return false;
        } else {
          float viewRatio = (float)desc.texture.width / (float)desc.texture.height;
          float targetRatio;
          if (this->aspectRatio == ASPECT_RATIO_BACK_BUFFER) {
            targetRatio = backBufferDesc.texture.width / backBufferDesc.texture.height;
          } else {
            targetRatio = this->aspectRatio;
          }
          static const float tolerance = 0.0001f;
          float diff = std::abs(viewRatio - targetRatio);
          if (diff > tolerance) return false;
        }
      }
      return true;
    }

    float resourceTag = -1;
    uint32_t _counted = 0;
    bool completed = false;
  };

  static bool useSharedDevice = false;
  static bool useResourceCloning = false;
  static bool useResourceFallbacks = false;
  static bool useResizeBuffer = false;
  static bool useResizeBufferOnSetFullScreen = false;
  static bool useResizeBufferOnPresent = false;
  static bool upgradeUnknownResourceViews = false;
  static bool upgradeResourceViews = true;
  static bool preventFullScreen = true;
  static bool forceBorderless = true;

  struct bound_descriptor_info {
    reshade::api::shader_stage stages;
    reshade::api::pipeline_layout layout;
    uint32_t first;
    uint32_t count;
    std::vector<reshade::api::descriptor_table> tables;
  };

  struct push_descriptor_info {
    reshade::api::shader_stage stages;
    reshade::api::pipeline_layout layout;
    uint32_t layout_param;
    reshade::api::descriptor_table_update update;
  };

  struct heap_descriptor_info {
    std::vector<reshade::api::descriptor_table_update> updates;
    uint64_t replacement_descriptor_handle;
    bool is_active;
  };

  struct __declspec(uuid("809df2f6-e1c7-4d93-9c6e-fa88dd960b7c")) device_data {
    reshade::api::resource originalResource;
    reshade::api::resource_view originalResourceView;

    SwapChainUpgradeTarget* appliedTarget = nullptr;
    bool upgradedResourceNeedsViewClone = false;
    bool upgradedResourceView = false;
    bool resourceUpgradeFinished = false;
    bool preventFullScreen = false;

    // <originalResource.handle, SwapChainUpgradeTarget>
    std::unordered_map<uint64_t, SwapChainUpgradeTarget*> resourceUpgradeTargets;

    std::unordered_map<uint64_t, reshade::api::resource> upgradedResources;
    // <originalResource.handle, clonedResource.handle>
    std::unordered_map<uint64_t, uint64_t> clonedResources;
    // <clonedResource.handle>
    std::unordered_set<uint64_t> permanentClonedResources;
    std::unordered_set<uint64_t> enabledClonedResources;
    std::unordered_map<uint64_t, reshade::api::resource_view> upgradedResourceViews;

    // <originalResourceView.handle>
    std::unordered_set<uint64_t> resourceViewsCloned;

    // <OriginalResourceView.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> renderTargetResourceViewClones;
    // <OriginalResourceView.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> uavResourceViewClones;
    // <OriginalResourceView.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> shaderResourceViewClones;

    // <resource.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> resourceRenderTargetResourceClones;
    // <resource.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> resourceUAVs;
    // <resource.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> resourceUAVClones;
    // <resource.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> resourceSRVs;
    // <resource.handle, CloneResourceView.handle>
    std::unordered_map<uint64_t, uint64_t> resourceSRVClones;

    std::unordered_set<uint64_t> resourcesThatNeedResourceViewClones;

    // <resource.handle, resourceClone.handle>
    std::unordered_map<uint64_t, uint64_t> resourceClones;
    std::unordered_map<uint64_t, uint32_t> pipelineToShaderHashMap;
    std::shared_mutex mutex;
    std::unordered_map<uint64_t, reshade::api::resource> rebuiltBuffers;

    // <descriptor_table.handle[index], <cloneResourceView.handle>>
    std::unordered_map<std::pair<uint64_t, uint32_t>, uint64_t, DescriptorTableUtil::hash_pair> tableDescriptorResourceViewReplacements;

    // <descriptor_heap.handle, std::map<base_offset, descriptor_table>>
    std::unordered_map<uint64_t, std::unordered_map<uint32_t, heap_descriptor_info*>> heapDescriptorInfos;

    std::unordered_map<uint64_t, uint64_t> descriptorTableClones;
    std::unordered_set<uint64_t> activeDescriptorTableClones;
  };

  struct __declspec(uuid("0a2b51ad-ef13-4010-81a4-37a4a0f857a6")) CommandListData {
    std::vector<bound_descriptor_info> unboundDescriptors;
    std::vector<push_descriptor_info> unpushedUpdates;
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

  static void on_init_command_list(reshade::api::command_list* cmd_list) {
    cmd_list->create_private_data<CommandListData>();
  }

  static void on_destroy_command_list(reshade::api::command_list* cmd_list) {
    cmd_list->destroy_private_data<CommandListData>();
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
    privateData->resourcesThatNeedResourceViewClones.insert(resource.handle);
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

  static void resize_buffer(
    reshade::api::swapchain* swapchain
  ) {
    IDXGISwapChain* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    IDXGISwapChain4* swapchain4;

    if (FAILED(native_swapchain->QueryInterface(IID_PPV_ARGS(&swapchain4)))) {
      reshade::log_message(reshade::log_level::error, "resize_buffer(Failed to get native swap chain)");
      return;
    }

    DXGI_SWAP_CHAIN_DESC1 desc;
    if (FAILED(swapchain4->GetDesc1(&desc))) {
      reshade::log_message(reshade::log_level::error, "resize_buffer(Failed to get desc)");
      swapchain4->Release();
      swapchain4 = nullptr;
      return;
    }

    auto newFormat = (targetFormat == reshade::api::format::r16g16b16a16_float)
                     ? DXGI_FORMAT_R16G16B16A16_FLOAT
                     : DXGI_FORMAT_R10G10B10A2_UNORM;
    if (desc.Format == newFormat) {
      reshade::log_message(reshade::log_level::debug, "resize_buffer(Format OK)");
      swapchain4->Release();
      swapchain4 = nullptr;
      return;
    }
    reshade::log_message(reshade::log_level::debug, "resize_buffer(Resizing...)");

    HRESULT hr = swapchain4->ResizeBuffers(
      desc.BufferCount == 1 ? 2 : 0,
      desc.Width,
      desc.Height,
      newFormat,
      desc.Flags
    );

    swapchain4->Release();
    swapchain4 = nullptr;

    if (hr == DXGI_ERROR_INVALID_CALL) {
      std::stringstream s;
      s << "resize_buffer(DXGI_ERROR_INVALID_CALL"
        << ", BufferCount = " << desc.BufferCount
        << ", Width = " << desc.Width
        << ", Height = " << desc.Height
        << ", Format = " << to_string(desc.Format)
        << ", Flags = 0x" << std::hex << desc.Flags << std::dec
        << ')';
      reshade::log_message(reshade::log_level::error, s.str().c_str());
      return;
    }
    std::stringstream s;
    s << "resize_buffer("
      << "resize: " << hr
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());

    // Reshade doesn't actually inspect colorspace
    // auto colorspace = swapchain->get_color_space();
    if (changeColorSpace(swapchain, targetColorSpace)) {
      reshade::log_message(reshade::log_level::info, "resize_buffer(Color Space: OK)");
    } else {
      reshade::log_message(reshade::log_level::error, "resize_buffer(Color Space: Failed.)");
    }
  }

  static void on_present_for_resize_buffer(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects
  ) {
    reshade::unregister_event<reshade::addon_event::present>(on_present_for_resize_buffer);
    resize_buffer(swapchain);
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
      if (target->ignoreReset) continue;
      target->_counted = 0;
      target->completed = false;
    }

    auto deviceBackBufferDesc = SwapchainUtil::getBackBufferDesc(device);
    checkSwapchainSize(swapchain, deviceBackBufferDesc);

    if (useResizeBuffer && deviceBackBufferDesc.texture.format != targetFormat) {
      if (useResizeBufferOnPresent) {
        reshade::register_event<reshade::addon_event::present>(on_present_for_resize_buffer);
      } else if (!useResizeBufferOnSetFullScreen) {
        resize_buffer(swapchain);
      }
      return;
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
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "createResource(Unknown device "
        << reinterpret_cast<void*>(device)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      return false;
    }

    uint32_t len = swapChainUpgradeTargets.size();

    float resourceTag = -1;

    SwapChainUpgradeTarget* foundTarget = nullptr;
    bool allCompleted = true;
    bool foundExact = false;
    for (uint32_t i = 0; i < len; i++) {
      SwapChainUpgradeMod::SwapChainUpgradeTarget* target = &swapChainUpgradeTargets.data()[i];
      std::stringstream s;
      if (target->completed) continue;
      if (
        !target->useResourceViewCloning
        && target->checkResourceDesc(desc, deviceBackBufferDesc, initial_state)
      ) {
        s << "createResource(counting target"
          << ", format: " << to_string(target->oldFormat)
          << ", usage: " << std::hex << (uint32_t)desc.usage << std::dec
          << ", index: " << target->index
          << ", counted: " << target->_counted
          // << ", data: " << reinterpret_cast<void*>(initial_data)
          << ") [" << i << "/" << len << "]";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());

        target->_counted++;
        if (target->index != -1 && (target->index + 1) == target->_counted) {
          foundTarget = target;
          target->completed = true;
          foundExact = true;
          continue;
        }
        if (target->index == -1) {
          if (!foundExact) {
            foundTarget = target;
          }
          allCompleted = false;
          continue;
        }
      }
      allCompleted = false;
    }

    if (foundTarget == nullptr) return false;

    if (allCompleted) {
      privateData.resourceUpgradeFinished = true;
    }

    std::stringstream s;
    s << "createResource(upgrading"
      << ", flags: 0x" << std::hex << (uint32_t)desc.flags << std::dec
      << ", state: 0x" << std::hex << (uint32_t)initial_state << std::dec
      << ", format: " << to_string(desc.texture.format) << " => " << to_string(foundTarget->newFormat)
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
    }

    s << ")";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );

    desc.texture.format = foundTarget->newFormat;
    desc.usage = (reshade::api::resource_usage)((uint32_t)desc.usage | foundTarget->usageSet & ~foundTarget->usageUnset);

    privateData.originalResource = originalResource;
    privateData.appliedTarget = foundTarget;
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
        if (privateData.appliedTarget != nullptr) {
          reshade::log_message(reshade::log_level::warning, "Modified??");
          privateData.appliedTarget = nullptr;
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
    if (privateData.appliedTarget) {
      if (privateData.appliedTarget->resourceTag != -1) {
        ResourceUtil::setResourceTag(device, resource, privateData.appliedTarget->resourceTag);
      }
      privateData.resourceUpgradeTargets[resource.handle] = privateData.appliedTarget;
      privateData.appliedTarget = nullptr;

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
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "init_resource(Unknown device "
          << reinterpret_cast<void*>(device)
          << ")";
        reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
        return;
      }

      uint32_t len = swapChainUpgradeTargets.size();

      SwapChainUpgradeMod::SwapChainUpgradeTarget* foundTarget = nullptr;
      bool allCompleted = true;
      bool foundExact = false;
      for (uint32_t i = 0; i < len; i++) {
        SwapChainUpgradeMod::SwapChainUpgradeTarget* target = &swapChainUpgradeTargets.data()[i];
        std::stringstream s;
        if (target->completed) continue;
        if (
          target->useResourceViewCloning
          && target->checkResourceDesc(desc, deviceBackBufferDesc, initial_state)
        ) {
          s << "on_init_resource(counting target"
            << ", format: " << to_string(target->oldFormat)
            << ", usage: " << std::hex << (uint32_t)desc.usage << std::dec
            << ", index: " << target->index
            << ", counted: " << target->_counted
            << ") [" << i << "/" << len << "]";
#ifdef DEBUG_LEVEL_0
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

          target->_counted++;
          if (target->index != -1 && (target->index + 1) == target->_counted) {
            foundTarget = target;
            target->completed = true;
            foundExact = true;
            continue;
          }
          if (target->index == -1) {
            if (!foundExact) {
              foundTarget = target;
            }
            allCompleted = false;
            continue;
          }
        }
        allCompleted = false;
      }
      if (foundTarget == nullptr) return;
      if (allCompleted) {
#ifdef DEBUG_LEVEL_0
        reshade::log_message(reshade::log_level::debug, "All resource cloning completed.");
#endif
        privateData.resourceUpgradeFinished = true;
      }

      reshade::api::resource_desc new_desc = desc;
      new_desc.texture.format = foundTarget->newFormat;
      new_desc.usage = (reshade::api::resource_usage)((uint32_t)desc.usage | foundTarget->usageSet & ~foundTarget->usageUnset);

      reshade::api::resource clonedResource = cloneResource(
        device,
        &privateData,
        new_desc,
        initial_data,
        initial_state,
        resource
      );
      if (foundTarget->resourceTag != -1) {
        ResourceUtil::setResourceTag(device, resource, foundTarget->resourceTag);
      }
      if (!foundTarget->useResourceViewHotSwap) {
        privateData.permanentClonedResources.insert(clonedResource.handle);
        privateData.enabledClonedResources.insert(clonedResource.handle);
      }
      privateData.resourceUpgradeTargets[resource.handle] = foundTarget;
      s << ", newformat: " << to_string(new_desc.texture.format);
      s << ", clone: " << reinterpret_cast<void*>(clonedResource.handle);
      s << ", hotswap: " << (foundTarget->useResourceViewHotSwap ? "true" : "false");
    } else {
      // Nothing to do
      return;
    }

    s << ")";

#ifdef DEBUG_LEVEL_1
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
#endif
  }

  static void on_destroy_resource(reshade::api::device* device, reshade::api::resource resource) {
    ResourceUtil::removeResourceTag(device, resource);

    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "on_destroy_resource(destroy resource"
        << ", resource: " << reinterpret_cast<void*>(resource.handle)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif

    data.resourceUpgradeTargets.erase(resource.handle);

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
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "on_destroy_resource(destroy cloned resource and views"
          << ", resource: " << reinterpret_cast<void*>(resource.handle)
          << ", clone: " << reinterpret_cast<void*>(cloneResource.handle)
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

        data.enabledClonedResources.erase(cloneResource.handle);
        data.permanentClonedResources.erase(cloneResource.handle);
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
    } else if (auto pair = privateData.resourceUpgradeTargets.find(resource.handle);
               pair != privateData.resourceUpgradeTargets.end()) {
      auto target = pair->second;
      bool foundUpgrade = false;
      if (auto pair2 = target->viewUpgrades.find(usage_type);
          pair2 != target->viewUpgrades.end()) {
        auto formatMap = pair2->second;
        if (auto pair3 = formatMap.find(desc.format);
            pair3 != formatMap.end()) {
          new_desc.format = pair3->second;
          foundUpgrade = true;
        }
      }
      if (!foundUpgrade) {
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
            {
              std::stringstream s;
              s << "unexpected case(" << to_string(desc.format) << ")";
              reshade::log_message(reshade::log_level::warning, s.str().c_str());
            }
            break;
        }
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
        case reshade::api::format::r10g10b10a2_unorm:
          new_desc.format = targetFormat;
          break;
        default:
          {
            std::stringstream s;
            s << "unexpected case(" << to_string(desc.format) << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
          }
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

    if (!changed) {
#ifdef DEBUG_LEVEL_1
      reshade::log_message(
        desc.format == reshade::api::format::unknown
          ? reshade::log_level::warning
          : reshade::log_level::info,
        s.str().c_str()
      );
#endif
      return false;
    }
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
      // Upgrade on init instead (allows resource view handle reuse)
      return false;
    }

    reshade::log_message(
      desc.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
    desc.format = new_desc.format;
    privateData.upgradedResourceView = true;
    return true;
  }

  static void release_resource_view(
    reshade::api::device* device,
    device_data &data,  // mutex locked
    reshade::api::resource_view view
  ) {
    if (
      auto pair = data.upgradedResourceViews.find(view.handle);
      pair != data.upgradedResourceViews.end()
    ) {
      device->destroy_resource_view(pair->second);
      data.upgradedResourceViews.erase(view.handle);
    }

    if (data.resourceViewsCloned.contains(view.handle)) {
      if (
        auto pair = data.uavResourceViewClones.find(view.handle);
        pair != data.uavResourceViewClones.end()
      ) {
        device->destroy_resource_view(reshade::api::resource_view{pair->second});
        data.uavResourceViewClones.erase(view.handle);
      }

      if (
        auto pair = data.shaderResourceViewClones.find(view.handle);
        pair != data.shaderResourceViewClones.end()
      ) {
        device->destroy_resource_view(reshade::api::resource_view{pair->second});
        data.shaderResourceViewClones.erase(view.handle);
      }

      if (
        auto pair = data.renderTargetResourceViewClones.find(view.handle);
        pair != data.renderTargetResourceViewClones.end()
      ) {
        device->destroy_resource_view(reshade::api::resource_view{pair->second});
        data.renderTargetResourceViewClones.erase(view.handle);
      }
      data.resourceViewsCloned.erase(view.handle);
    }
  }

  static void on_init_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc &desc,
    reshade::api::resource_view view
  ) {
    if (!resource.handle) return;
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "init_resource_view()");
#endif
    auto &privateData = device->get_private_data<device_data>();
    std::unique_lock lock(privateData.mutex);

    release_resource_view(device, privateData, view);
    if (
      useResourceCloning
      && privateData.resourcesThatNeedResourceViewClones.contains(resource.handle)
      && privateData.clonedResources.contains(resource.handle)
    ) {
      reshade::api::resource_view_desc new_desc = desc;
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
      s << "on_init_resource_view(made clone: "
        << reinterpret_cast<void*>(view.handle)
        << " => "
        << reinterpret_cast<void*>(clonedResourceView.handle)
        << ", resource: " << reinterpret_cast<void*>(resource.handle);
      if (clonedResourceViewResource.handle != resource.handle) {
        s << " => " << reinterpret_cast<void*>(clonedResourceViewResource.handle);
      }

      privateData.resourceViewsCloned.insert(view.handle);

      if (usage_type == reshade::api::resource_usage::render_target) {
        privateData.renderTargetResourceViewClones[view.handle] = clonedResourceView.handle;
        privateData.resourceRenderTargetResourceClones[resource.handle] = clonedResourceView.handle;
        s << ", type: render_target";
      }
      if (usage_type == reshade::api::resource_usage::unordered_access) {
        privateData.uavResourceViewClones[view.handle] = clonedResourceView.handle;
        privateData.resourceUAVClones[resource.handle] = clonedResourceView.handle;
        privateData.resourceUAVs[resource.handle] = view.handle;
        s << ", type: uav";
      }

      if (usage_type == reshade::api::resource_usage::shader_resource) {
        privateData.shaderResourceViewClones[view.handle] = clonedResourceView.handle;
        privateData.resourceSRVClones[resource.handle] = clonedResourceView.handle;
        privateData.resourceSRVs[resource.handle] = view.handle;
        s << ", type: shader_resource";
      }
      ResourceUtil::setResourceFromResourceView(device, clonedResourceView, clonedResourceViewResource);

      s << ")";
#ifdef DEBUG_LEVEL_1
      reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
    } else {
      if (useResourceCloning) {
        bool wasCloned = privateData.resourceViewsCloned.contains(resource.handle);
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "on_init_resource_view(unused view "
          << reinterpret_cast<void*>(view.handle)
          << ", resource: " << reinterpret_cast<void*>(resource.handle)
          << ", was cloned: " << (wasCloned ? "true" : "false")
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
#endif
        if (wasCloned) {
          privateData.resourceViewsCloned.erase(resource.handle);

          // TODO Clean up all other descriptors
        }
        // Clean incorrect resource view?
      }
    }

    if (privateData.upgradedResourceView) {
      privateData.upgradedResourceView = false;
      if (privateData.originalResourceView.handle) {
        privateData.upgradedResourceViews[view.handle] = privateData.originalResourceView;
        privateData.originalResourceView = {0};
      }
    }
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "init_resource_view(done)");
#endif
  }

  static void on_destroy_resource_view(reshade::api::device* device, reshade::api::resource_view view) {
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);
    release_resource_view(device, data, view);
  }

  static reshade::api::resource_view findReplacementResourceView(
    device_data &data,
    reshade::api::resource_view resourceView,
    reshade::api::resource_usage usage
  ) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "findReplacementResourceView(looking for : "
      << reinterpret_cast<void*>(resourceView.handle)
      << ", usage: " << to_string(usage)
      << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

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
          << reinterpret_cast<void*>(resourceView.handle)
          << ", usage: " << to_string(usage)
          << ")";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        return resourceView;
    }

    auto pair2 = viewClonesMap->find(resourceView.handle);
    if (pair2 != viewClonesMap->end()) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "findReplacementResourceView(found: "
        << "rsv: " << reinterpret_cast<void*>(resourceView.handle)
        << " => "
        << "res: " << reinterpret_cast<void*>(pair2->second)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      return reshade::api::resource_view{pair2->second};
    }
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "findReplacementResourceView(no clone exists: "
        << "rsv: " << reinterpret_cast<void*>(resourceView.handle)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif
    return resourceView;
  }

  static reshade::api::descriptor_table_update cloneDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update update,
    reshade::api::resource_view view,
    uint32_t index = 0
  ) {
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view:
        {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
          return reshade::api::descriptor_table_update{
            .table = update.table,
            .binding = update.binding + index,
            .count = 1,
            .type = update.type,
            .descriptors = new reshade::api::sampler_with_resource_view{
                                                                        item.sampler,
                                                                        view}
          };
        }
        break;
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:
        {
          return reshade::api::descriptor_table_update{
            .table = update.table,
            .binding = update.binding + index,
            .count = 1,
            .type = update.type,
            .descriptors = new reshade::api::resource_view{
              view.handle
            }
          };
        }
        break;
      default:
        break;
    }
    return {};
  }

  static reshade::api::resource_view findReplacementResourceView(
    device_data &data,
    reshade::api::resource_view resourceView,
    reshade::api::descriptor_type type
  ) {
    switch (type) {
      case reshade::api::descriptor_type::sampler_with_resource_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::shader_resource_view:
        return findReplacementResourceView(data, resourceView, reshade::api::resource_usage::shader_resource);
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::unordered_access_view:
        return findReplacementResourceView(data, resourceView, reshade::api::resource_usage::unordered_access);
      default:
        return findReplacementResourceView(data, resourceView, reshade::api::resource_usage::undefined);
    }
  }

  static bool logDescriptorTableReplacement(
    device_data &data,  // Should be mutex locked
    const reshade::api::descriptor_table table,
    const uint32_t index,
    const reshade::api::resource_view view = {0}
  ) {
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "logDescriptorTableReplacement("
        << reinterpret_cast<void*>(table.handle)
        << "[" << index << "]"
        << ", view " << reinterpret_cast<void*>(view.handle)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
    auto oldSize = data.tableDescriptorResourceViewReplacements.size();
#endif

    auto primaryKey = std::pair<uint64_t, uint32_t>(table.handle, index);
    if (view.handle) {
      data.tableDescriptorResourceViewReplacements[primaryKey] = view.handle;
#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "logDescriptorTableReplacement(insert "
          << reinterpret_cast<void*>(table.handle)
          << "[" << index << "]"
          << ", view " << reinterpret_cast<void*>(view.handle)
          << ", size " << oldSize << " => " << data.tableDescriptorResourceViewReplacements.size()
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
      for (auto pair : data.tableDescriptorResourceViewReplacements) {
        auto key = pair.first;
        {
          std::stringstream s;
          s << "logDescriptorTableReplacement(list "
            << reinterpret_cast<void*>(key.first)
            << "[" << key.second << "]"
            << ", view " << reinterpret_cast<void*>(pair.second)
            << ")";
          reshade::log_message(reshade::log_level::info, s.str().c_str());
        }
      }
#endif

      return true;
    }

    data.tableDescriptorResourceViewReplacements.erase(primaryKey);
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "logDescriptorTableReplacement(remove "
        << reinterpret_cast<void*>(table.handle)
        << "[" << index << "]"
        << ", view " << reinterpret_cast<void*>(view.handle)
        << ", size " << oldSize << " => " << data.tableDescriptorResourceViewReplacements.size()
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
#endif
    return false;
  }

  static bool flushResourceViewInDescriptorTable(
    reshade::api::device* device,
    reshade::api::resource resource
  ) {
    auto &data = device->get_private_data<device_data>();
    // std::shared_lock lock(data.mutex);

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "flushResourceViewInDescriptorTable(resource: "
        << reinterpret_cast<void*>(resource.handle)
        << ", device: " << reinterpret_cast<void*>(device)
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
    }
#endif

    if (auto uavCloneHandles = data.resourceUAVClones.find(resource.handle);
        uavCloneHandles != data.resourceUAVClones.end()) {
      auto uavCloneHandle = uavCloneHandles->second;
      if (
        auto uavHandles = data.resourceUAVs.find(resource.handle);
        uavHandles != data.resourceUAVs.end()
      ) {
        auto uavHandle = uavHandles->second;
        auto &descriptorTableData = device->get_private_data<DescriptorTableUtil::DeviceData>();
        std::unique_lock lock(descriptorTableData.mutex);
        if (
          auto locations = descriptorTableData.resourceViewTableDescriptionLocations.find(uavHandle);
          locations != descriptorTableData.resourceViewTableDescriptionLocations.end()
        ) {
          auto set = *locations->second;
          for (auto primaryKey : set) {
            bool replace = false;
            if (
              auto replacements = data.tableDescriptorResourceViewReplacements.find(primaryKey);
              replacements != data.tableDescriptorResourceViewReplacements.end()
            ) {
              replace = replacements->second != uavCloneHandle;  // Wrong clone
            } else {
              replace = true;
            }

            if (replace) {
              if (auto updatePair = descriptorTableData.tableDescriptorResourceViews.find(primaryKey);
                  updatePair != descriptorTableData.tableDescriptorResourceViews.end()) {
                auto update = updatePair->second;
                auto newView = reshade::api::resource_view{uavCloneHandle};
                auto newUpdate = cloneDescriptorUpdateWithResourceView(update, newView);
                device->update_descriptors(newUpdate);
                logDescriptorTableReplacement(data, newUpdate.table, newUpdate.binding, newView);
              }
            }
          }
        }
      }
    }

    if (auto srvCloneHandles = data.resourceSRVClones.find(resource.handle);
        srvCloneHandles != data.resourceSRVClones.end()) {
      auto srvCloneHandle = srvCloneHandles->second;
      if (
        auto srvHandles = data.resourceSRVs.find(resource.handle);
        srvHandles != data.resourceSRVs.end()
      ) {
        auto srvHandle = srvHandles->second;
        auto &descriptorTableData = device->get_private_data<DescriptorTableUtil::DeviceData>();
        std::unique_lock lock(descriptorTableData.mutex);
        if (
          auto locations = descriptorTableData.resourceViewTableDescriptionLocations.find(srvHandle);
          locations != descriptorTableData.resourceViewTableDescriptionLocations.end()
        ) {
          auto set = *locations->second;
          for (auto primaryKey : set) {
            bool replace = false;
            if (
              auto replacements = data.tableDescriptorResourceViewReplacements.find(primaryKey);
              replacements != data.tableDescriptorResourceViewReplacements.end()
            ) {
              replace = replacements->second != srvCloneHandle;  // Wrong clone
            } else {
              replace = true;
            }

            if (replace) {
              if (auto updatePair = descriptorTableData.tableDescriptorResourceViews.find(primaryKey);
                  updatePair != descriptorTableData.tableDescriptorResourceViews.end()) {
                auto update = updatePair->second;
                auto newView = reshade::api::resource_view{srvCloneHandle};
                auto newUpdate = cloneDescriptorUpdateWithResourceView(update, newView);
                device->update_descriptors(newUpdate);
                logDescriptorTableReplacement(data, newUpdate.table, newUpdate.binding, newView);
              }
            }
          }
        }
      }
    }

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
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "on_present(reset on present"
      << ", count: "
      << data.tableDescriptorResourceViewReplacements.size()
      << ")";
    reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    data.enabledClonedResources.clear();

    for (auto item : data.permanentClonedResources) {
      data.enabledClonedResources.insert(item);
    }
  }

  static bool activateCloneHotSwap(
    reshade::api::device* device,
    reshade::api::resource_view resource_view
  ) {
    auto resource = ResourceUtil::getResourceFromResourceView(device, resource_view);
    if (!resource.handle) {
      std::stringstream s;
      s << "activateCloneHotSwap(no handle for rsv "
        << reinterpret_cast<void*>(resource_view.handle)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      return false;
    }
    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);

    reshade::api::resource cloneResource;

    auto clonedResourcePair = data.clonedResources.find(resource.handle);
    if (clonedResourcePair == data.clonedResources.end()) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "activateCloneHotSwap(";
      if (SwapchainUtil::isBackBuffer(device, resource)) {
        s << ("backbuffer ");
      }
      s << "not cloned "
        << reinterpret_cast<void*>(resource.handle)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
#endif
      // Resource is not a cloned resource (fail)
      return false;
    }

    cloneResource = reshade::api::resource{clonedResourcePair->second};

    if (data.enabledClonedResources.contains(cloneResource.handle)) {
      // Already activated
      return false;
    }

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "activateCloneHotSwap(activating res: "
        << reinterpret_cast<void*>(resource.handle)
        << " => clone: "
        << reinterpret_cast<void*>(cloneResource.handle)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }
    if (!data.resourceSRVClones.contains(resource.handle)) {
      std::stringstream s;
      s << "activateCloneHotSwap(no srv, res: "
        << reinterpret_cast<void*>(resource.handle)
        << " => clone: "
        << reinterpret_cast<void*>(cloneResource.handle)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }

    if (!data.resourceUAVClones.contains(resource.handle)) {
      std::stringstream s;
      s << "activateCloneHotSwap(no uav, res: "
        << reinterpret_cast<void*>(resource.handle)
        << " => clone: "
        << reinterpret_cast<void*>(cloneResource.handle)
        << ")";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
    }
#endif

    // data.pendingResourceViewUpdateFlush.insert(resource.handle);
    // flushResourceViewInDescriptorTable(device, resource);

#ifdef DEBUG_LEVEL_1

#endif

    // reshade::register_event<reshade::addon_event::present>(on_present_for_descriptor_reset);
    data.enabledClonedResources.insert(cloneResource.handle);
    return true;
  }

  // Create DescriptorTables with RSVs
  static bool on_update_descriptor_tables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates
  ) {
    if (!count) return false;
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "update_descriptor_tables()");
#endif
    reshade::api::descriptor_table_update* new_updates = nullptr;
    bool changed = false;
    bool active = false;

    for (uint32_t i = 0; i < count; i++) {
      auto &update = updates[i];
      if (!update.table.handle) continue;
      for (uint32_t j = 0; j < update.count; j++) {
        switch (update.type) {
          case reshade::api::descriptor_type::sampler_with_resource_view:
            {
              auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
              auto resourceView = item.view;
              auto &data = device->get_private_data<device_data>();
              std::unique_lock lock(data.mutex);
              auto newResourceView = findReplacementResourceView(
                data,
                resourceView,
                reshade::api::resource_usage::shader_resource
              );
              if (newResourceView.handle == 0) {
                std::stringstream s;
                s << "update_descriptor_tables(invalid resource view clone for : "
                  << reinterpret_cast<void*>(resourceView.handle)
                  << ")";
                reshade::log_message(reshade::log_level::warning, s.str().c_str());
                break;
              }
              if (resourceView.handle == newResourceView.handle) break;

              auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
              if (!newResource.handle) break;

#ifdef DEBUG_LEVEL_1
              std::stringstream s;
              s << "update_descriptor_tables(found clonable: "
                << reinterpret_cast<void*>(newResourceView.handle)
                << ")";
              reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
              if (!changed) {
                new_updates = DescriptorTableUtil::clone_descriptor_table_updates(updates, count);
              }

              ((reshade::api::sampler_with_resource_view*)(new_updates[i].descriptors))[j].view = newResourceView;
              changed = true;
              if (data.enabledClonedResources.contains(newResource.handle)) {
                active = true;
              }
            }
            break;
          case reshade::api::descriptor_type::buffer_shader_resource_view:
          case reshade::api::descriptor_type::buffer_unordered_access_view:
          case reshade::api::descriptor_type::shader_resource_view:
          case reshade::api::descriptor_type::unordered_access_view:
            {
              auto resourceView = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
              auto &data = device->get_private_data<device_data>();
              std::unique_lock lock(data.mutex);
              auto newResourceView = findReplacementResourceView(
                data,
                resourceView,
                update.type
              );
              if (newResourceView.handle == 0) {
                std::stringstream s;
                s << "update_descriptor_tables(invalid resource view clone for : "
                  << reinterpret_cast<void*>(resourceView.handle)
                  << ")";
                reshade::log_message(reshade::log_level::warning, s.str().c_str());
                break;
              }
              if (resourceView.handle == newResourceView.handle) break;
              auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
              if (!newResource.handle) break;

#ifdef DEBUG_LEVEL_1
              std::stringstream s;
              s << "update_descriptor_tables(found clonable: "
                << reinterpret_cast<void*>(newResourceView.handle)
                << ")";
              reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

              if (!changed) {
                new_updates = DescriptorTableUtil::clone_descriptor_table_updates(updates, count);
              }

              ((reshade::api::resource_view*)(new_updates[i].descriptors))[j] = newResourceView;
              changed = true;
              if (data.enabledClonedResources.contains(newResource.handle)) {
                active = true;
              }
            }
            break;
          default:
            break;
        }
      }
    }

    if (changed) {
      auto originalTableHandle = updates[0].table.handle;
      auto &data = device->get_private_data<device_data>();
      std::unique_lock lock(data.mutex);

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(updates[0].table, 0, 0, &heap, &base_offset);

#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "update_descriptor_tables(caching descriptor table: "
        << reinterpret_cast<void*>(updates[0].table.handle)
        << ", count: " << count
        << ", active: " << (active ? "true" : "false")
        << ", heap: " << reinterpret_cast<void*>(heap.handle)
        << "[" << base_offset << "]"
        << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

      std::vector<reshade::api::descriptor_table_update> vector(new_updates, new_updates + count);

      if (auto pair = data.heapDescriptorInfos.find(heap.handle); pair != data.heapDescriptorInfos.end()) {
        auto &map = pair->second;
        if (auto pair2 = map.find(base_offset); pair2 != map.end()) {
          map[base_offset]->updates = vector;
          map[base_offset]->replacement_descriptor_handle = 0;
          map[base_offset]->is_active = active;
        } else {
          map[base_offset] = new heap_descriptor_info{
            .updates = vector,
            .is_active = active,
          };
        }
      } else {
        data.heapDescriptorInfos[heap.handle] = {
          {base_offset,
           new heap_descriptor_info{
           .updates = vector,
           .is_active = active,
           }}
        };
      }

    } else {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "update_descriptor_tables(no clonable.)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
    }
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "update_descriptor_tables(done)");
#endif
    return false;
  }

  static bool on_copy_descriptor_tables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies
  ) {
    if (!useResourceCloning) return false;
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "copy_descriptor_tables()");
#endif
    for (uint32_t i = 0; i < count; i++) {
      auto &copy = copies[i];
      for (uint32_t j = 0; j < copy.count; j++) {
        auto &data = device->get_private_data<device_data>();
        std::unique_lock lock(data.mutex);

        reshade::api::descriptor_heap source_heap = {0};
        uint32_t source_base_offset = 0;
        device->get_descriptor_heap_offset(copy.source_table, copy.source_binding + j, copy.source_array_offset, &source_heap, &source_base_offset);
        reshade::api::descriptor_heap dest_heap = {0};
        uint32_t dest_base_offset = 0;
        device->get_descriptor_heap_offset(copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &dest_heap, &dest_base_offset);

        bool erase = false;
        if (auto pair = data.heapDescriptorInfos.find(source_heap.handle); pair != data.heapDescriptorInfos.end()) {
          auto &source_map = pair->second;
          if (auto pair2 = source_map.find(source_base_offset); pair2 != source_map.end()) {
            if (dest_heap.handle == source_heap.handle) {
              source_map[dest_base_offset] = source_map[source_base_offset];
            } else {
              if (auto pair3 = data.heapDescriptorInfos.find(dest_heap.handle); pair3 != data.heapDescriptorInfos.end()) {
                auto &dest_map = pair3->second;
                dest_map[dest_base_offset] = source_map[source_base_offset];
              } else {
                data.heapDescriptorInfos[dest_heap.handle] = {
                  {dest_base_offset, source_map[source_base_offset]}
                };
              }
            }
#ifdef DEBUG_LEVEL_1
            std::stringstream s;
            s << "copy_descriptor_tables(cloning heap: "
              << reinterpret_cast<void*>(source_heap.handle)
              << "[" << source_base_offset << "]"
              << " => "
              << reinterpret_cast<void*>(dest_heap.handle)
              << "[" << dest_base_offset << "]"
              << ", table: " << reinterpret_cast<void*>(source_map[source_base_offset]->replacement_descriptor_handle)
              << ", size: " << source_map[source_base_offset]->updates.size()
              << ")";
            reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
          } else {
            erase = true;
          }
        } else {
          erase = true;
        }
        if (erase) {
          if (auto pair3 = data.heapDescriptorInfos.find(dest_heap.handle); pair3 != data.heapDescriptorInfos.end()) {
            auto &dest_map = pair3->second;
            dest_map.erase(dest_base_offset);
          }
        }
      }
    }

#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "copy_descriptor_tables(done)");
#endif

    return false;
  }

  static void on_bind_descriptor_tables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables
  ) {
    if (!count) return;
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "bind_descriptor_tables()");
#endif
    auto device = cmd_list->get_device();
    reshade::api::descriptor_table* new_tables = nullptr;
    bool built_new_tables = false;
    bool active = false;

    auto &data = device->get_private_data<device_data>();
    std::unique_lock lock(data.mutex);
    reshade::api::descriptor_heap heap = {0};
    uint32_t base_offset = 0;
    for (uint32_t i = 0; i < count; ++i) {
      device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);

      heap_descriptor_info* info = nullptr;
      bool found_info = false;
      if (auto pair = data.heapDescriptorInfos.find(heap.handle); pair != data.heapDescriptorInfos.end()) {
        auto &map = pair->second;
        if (auto pair2 = map.find(base_offset); pair2 != map.end()) {
          info = pair2->second;
          found_info = true;

#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "bind_descriptor_tables(found heap info: "
            << reinterpret_cast<void*>(heap.handle)
            << "[" << base_offset << "]"
            << ", handle: " << reinterpret_cast<void*>(info->replacement_descriptor_handle)
            << ", size: " << info->updates.size()
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        }
      }
      if (found_info) {
        if (info->replacement_descriptor_handle == 0) {
          reshade::api::descriptor_table new_table = {0};
          bool allocated = device->allocate_descriptor_table(layout, first + i, &new_table);
          if (new_table.handle == 0) {
            std::stringstream s;
            s << "bind_descriptor_tables(could not allocate new table: "
              << reinterpret_cast<void*>(tables[i].handle)
              << " via "
              << reinterpret_cast<void*>(layout.handle)
              << "[" << first + i << "]"
              << ", allocated: " << (allocated ? "true" : "false")
              << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());

            allocated = device->allocate_descriptor_table({0}, 0u, &new_table);
            if (new_table.handle == 0) {
              std::stringstream s;
              s << "bind_descriptor_tables(could not allocate new table (2): "
                << reinterpret_cast<void*>(tables[i].handle)
                << " via "
                << reinterpret_cast<void*>(0)
                << "[" << first + i << "]"
                << ", allocated: " << (allocated ? "true" : "false")
                << ")";
              reshade::log_message(reshade::log_level::error, s.str().c_str());
              continue;
            }
            info->replacement_descriptor_handle = new_table.handle;
          }
#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "bind_descriptor_tables(allocate new table pre-bind: "
            << reinterpret_cast<void*>(tables[i].handle)
            << " => "
            << reinterpret_cast<void*>(new_table.handle)
            << " via "
            << reinterpret_cast<void*>(layout.handle)
            << "[" << first + i << "]"
            << ", updates: " << reinterpret_cast<void*>(&info->updates)
            << " (" << info->updates.size() << ")"
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

          auto update_data = info->updates.data();
          auto len = info->updates.size();
          for (uint32_t j = 0; j < len; ++j) {
            auto &item = update_data[j];
            item.table = {new_table.handle};
          }
#ifdef DEBUG_LEVEL_1
          std::stringstream s2;
          s2 << "bind_descriptor_tables(updated created table: "
             << reinterpret_cast<void*>(&info->updates)
             << ", size" << len
             << ")";
          reshade::log_message(reshade::log_level::debug, s2.str().c_str());
#endif
          device->update_descriptor_tables(len, update_data);
          info->replacement_descriptor_handle = new_table.handle;
        } else {
#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "bind_descriptor_tables(no base_offset: "
            << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]"
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        }

        if (info->replacement_descriptor_handle != 0) {
          if (!built_new_tables) {
            size_t size = count * sizeof(reshade::api::descriptor_table);
            new_tables = (reshade::api::descriptor_table*)malloc(size);
            memcpy(new_tables, tables, size);
            built_new_tables = true;
          }
          new_tables[i].handle = info->replacement_descriptor_handle;

#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "bind_descriptor_tables(replace bind: "
            << reinterpret_cast<void*>(tables[i].handle)
            << " => "
            << reinterpret_cast<void*>(new_tables[i].handle)
            << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

          if (info->is_active) {
            active = true;
          }
        }
      }
    }

    if (active) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "bind_descriptor_tables(apply bind)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      cmd_list->bind_descriptor_tables(stages, layout, first, count, new_tables);
    } else if (built_new_tables) {
      auto &cmd_data = cmd_list->get_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "bind_descriptor_tables(storing unbound descriptor)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      cmd_data.unboundDescriptors.push_back({
        .stages = stages,
        .layout = layout,
        .first = first,
        .count = count,
        .tables = {new_tables[0], new_tables[count - 1]},
      });
    }
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "bind_descriptor_tables(done)");
#endif
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

    reshade::api::descriptor_table_update new_update;
    bool changed = false;
    bool active = false;

    for (uint32_t i = 0; i < update.count; i++) {
      // if (!update.table.handle) continue;
      switch (update.type) {
        case reshade::api::descriptor_type::sampler_with_resource_view:
          {
            auto resourceView = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i].view;
            if (resourceView.handle == 0) continue;
            auto &data = device->get_private_data<device_data>();
            std::unique_lock lock(data.mutex);
            auto newResourceView = findReplacementResourceView(
              data,
              resourceView,
              reshade::api::resource_usage::shader_resource
            );
            if (resourceView.handle == newResourceView.handle) break;
            auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
            if (!newResource.handle) break;

            if (!changed) {
              new_update = DescriptorTableUtil::clone_descriptor_table_updates(&update, 1)[0];
            }

            ((reshade::api::sampler_with_resource_view*)(new_update.descriptors))[i].view = newResourceView;
            changed = true;
            if (data.enabledClonedResources.contains(newResource.handle)) {
              active = true;
            }
          }
          break;
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::shader_resource_view:
        case reshade::api::descriptor_type::unordered_access_view:
          {
            auto resourceView = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
            if (resourceView.handle == 0) continue;
            auto &data = device->get_private_data<device_data>();
            std::unique_lock lock(data.mutex);
            auto newResourceView = findReplacementResourceView(
              data,
              resourceView,
              update.type
            );
            if (newResourceView.handle == 0) {
              std::stringstream s;
              s << "push_descriptors(invalid resource view clone for : "
                << reinterpret_cast<void*>(resourceView.handle)
                << ")";
              reshade::log_message(reshade::log_level::warning, s.str().c_str());
              break;
            }
            if (resourceView.handle == newResourceView.handle) break;
            auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
            if (!newResource.handle) break;

#ifdef DEBUG_LEVEL_1
            std::stringstream s;
            s << "push_descriptors(found clonable: "
              << reinterpret_cast<void*>(newResourceView.handle)
              << ")";
            reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif

            if (!changed) {
              new_update = DescriptorTableUtil::clone_descriptor_table_updates(&update, 1)[0];
            }

            ((reshade::api::resource_view*)(new_update.descriptors))[i] = newResourceView;
            changed = true;
            if (data.enabledClonedResources.contains(newResource.handle)) {
              active = true;
            }
          }
          break;
        default:
          break;
      }
    }

    if (active) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "push_descriptors(apply push)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      cmd_list->push_descriptors(stages, layout, layout_param, new_update);
    } else if (changed) {
      auto &cmd_data = cmd_list->get_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "push_descriptors(storing unpushed descriptor)";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
      cmd_data.unpushedUpdates.push_back({
        .stages = stages,
        .layout = layout,
        .layout_param = layout_param,
        .update = new_update,
      });
    }
#ifdef DEBUG_LEVEL_2
    reshade::log_message(reshade::log_level::debug, "push_descriptors(done)");
#endif
  }

  static void rewriteRenderTargets(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv
  ) {
    if (!count) return;

    auto device = cmd_list->get_device();

    size_t lastNonNull = -1;

    size_t size = count * sizeof(reshade::api::resource_view);
    reshade::api::resource_view* new_rtvs = (reshade::api::resource_view*)malloc(size);
    memcpy(new_rtvs, rtvs, count);
    bool changed = false;
    auto &data = device->get_private_data<device_data>();
    std::shared_lock lock(data.mutex);
    for (uint32_t i = 0; i < count; i++) {
      const reshade::api::resource_view resourceView = rtvs[i];
      if (!resourceView.handle) continue;
      lastNonNull = i;

      auto newResourceView = findReplacementResourceView(
        data,
        resourceView,
        reshade::api::resource_usage::render_target
      );

      if (resourceView.handle == newResourceView.handle) continue;
      auto newResource = ResourceUtil::getResourceFromResourceView(device, newResourceView);
      if (!newResource.handle) continue;

      if (
        auto enabledClonedResource = data.enabledClonedResources.find(newResource.handle);
        enabledClonedResource != data.enabledClonedResources.end()
      ) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "rewriting render target("
          << reinterpret_cast<void*>(resourceView.handle)
          << " => "
          << reinterpret_cast<void*>(newResourceView.handle)
          << ", res: " << reinterpret_cast<void*>(newResource.handle)
          << ") [" << i << "]";
        reshade::log_message(reshade::log_level::debug, s.str().c_str());
#endif
        changed = true;
        new_rtvs[i] = newResourceView;
      } else {
#ifdef DEBUG_LEVEL_1
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
    cmd_list->bind_render_targets_and_depth_stencil(lastNonNull + 1, new_rtvs, dsv);
  }

  static void discardDescriptors(reshade::api::command_list* cmd_list) {
    auto &cmd_data = cmd_list->get_private_data<CommandListData>();
    cmd_data.unboundDescriptors.clear();
    cmd_data.unpushedUpdates.clear();
  }

  static void flushDescriptors(reshade::api::command_list* cmd_list) {
    auto &cmd_data = cmd_list->get_private_data<CommandListData>();
    for (auto info : cmd_data.unboundDescriptors) {
      cmd_list->bind_descriptor_tables(
        info.stages,
        info.layout,
        info.first,
        info.count,
        info.tables.data()
      );
    }
    cmd_data.unboundDescriptors.clear();

    for (auto info : cmd_data.unpushedUpdates) {
      cmd_list->push_descriptors(
        info.stages,
        info.layout,
        info.layout_param,
        info.update
      );
    }
    cmd_data.unpushedUpdates.clear();
  }

  // Set render target RSV
  static void on_bind_render_targets_and_depth_stencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv
  ) {
    if (!count) return;


    rewriteRenderTargets(cmd_list, count, rtvs, dsv);
  }

  static bool on_clear_render_target_view(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects
  ) {
    auto device = cmd_list->get_device();
    if (device == nullptr) return false;
    device_data &data = device->get_private_data<device_data>();
    std::shared_lock lock(data.mutex);
    if (auto pair = data.renderTargetResourceViewClones.find(rtv.handle);
        pair != data.renderTargetResourceViewClones.end()) {
      cmd_list->clear_render_target_view(
        reshade::api::resource_view{pair->second},
        color,
        rect_count,
        rects
      );
    }
    return false;
  }

  static bool on_clear_unordered_access_view_uint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects
  ) {
    auto device = cmd_list->get_device();
    if (device == nullptr) return false;
    device_data &data = device->get_private_data<device_data>();
    std::shared_lock lock(data.mutex);
    if (auto pair = data.uavResourceViewClones.find(uav.handle);
        pair != data.uavResourceViewClones.end()) {
      cmd_list->clear_unordered_access_view_uint(
        reshade::api::resource_view{pair->second},
        values,
        rect_count,
        rects
      );
    }
    return false;
  }

  static bool on_clear_unordered_access_view_float(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const float values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects
  ) {
    auto device = cmd_list->get_device();
    if (device == nullptr) return false;
    device_data &data = device->get_private_data<device_data>();
    std::shared_lock lock(data.mutex);
    if (auto pair = data.uavResourceViewClones.find(uav.handle);
        pair != data.uavResourceViewClones.end()) {
      cmd_list->clear_unordered_access_view_float(
        reshade::api::resource_view{pair->second},
        values,
        rect_count,
        rects
      );
    }
    return false;
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
#ifdef DEBUG_LEVEL_1
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
    if (useResizeBuffer && useResizeBufferOnSetFullScreen) {
      resize_buffer(swapchain);
    }
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
      if (target->ignoreReset) continue;
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

  static bool attached = false;

  static void use(DWORD fdwReason) {
    ResourceUtil::use(fdwReason);
    SwapchainUtil::use(fdwReason);
    if (useResourceCloning) {
      DescriptorTableUtil::use(fdwReason);
    }

    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        if (attached) return;
        attached = true;
        reshade::log_message(reshade::log_level::info, "SwapChainUpgradeMod attached.");
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
          reshade::register_event<reshade::addon_event::init_command_list>(on_init_command_list);
          reshade::register_event<reshade::addon_event::destroy_command_list>(on_destroy_command_list);

          reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(on_bind_render_targets_and_depth_stencil);
          reshade::register_event<reshade::addon_event::push_descriptors>(on_push_descriptors);
          reshade::register_event<reshade::addon_event::update_descriptor_tables>(on_update_descriptor_tables);
          reshade::register_event<reshade::addon_event::copy_descriptor_tables>(on_copy_descriptor_tables);
          reshade::register_event<reshade::addon_event::bind_descriptor_tables>(on_bind_descriptor_tables);
          reshade::register_event<reshade::addon_event::clear_render_target_view>(on_clear_render_target_view);
          reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(on_clear_unordered_access_view_uint);
          reshade::register_event<reshade::addon_event::clear_unordered_access_view_float>(on_clear_unordered_access_view_float);

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
