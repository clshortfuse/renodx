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
  std::unordered_set<reshade::api::device*> upgradedResourceDevices;
  std::unordered_set<reshade::api::device*> pendingResourceClones;
  std::unordered_set<reshade::api::device*> pendingResourceViewClones;

  std::unordered_map<reshade::api::device*, reshade::api::resource_desc> deviceBackBufferDesc;
  std::unordered_map<uint64_t, reshade::api::resource> resourceClones;
  std::unordered_map<uint64_t, reshade::api::resource_view> resourceViewClones;

  static int32_t useResourceCloning = false;
  static int32_t resourceUpgradeIndex = -1;
  static bool upgradeResourceViews = true;
  static reshade::api::device* currentDevice = nullptr;
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
      case reshade::api::format::r10g10b10a2_unorm:
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
    auto device = swapchain->get_device();

    const size_t backBufferCount = swapchain->get_back_buffer_count();

    for (uint32_t index = 0; index < backBufferCount; index++) {
      auto buffer = swapchain->get_back_buffer(index);
      if (index == 0) {
        auto desc = device->get_resource_desc(buffer);
        deviceBackBufferDesc.emplace(device, desc);
      }
      if (upgradeResourceViews) {
        backBuffers.emplace(buffer.handle);

        std::stringstream s;
        s << "initSwapChain("
          << "buffer: 0x" << std::hex << (uint32_t)buffer.handle << std::dec
          << ")";
        reshade::log_message(reshade::log_level::info, s.str().c_str());
      }
    }

    // Reshade doesn't actually inspect colorspace
    // auto colorspace = swapchain->get_color_space();
    if (changeColorSpace(swapchain, targetColorSpace)) {
      reshade::log_message(reshade::log_level::info, "initSwapChain(Color Space: OK)");
    } else {
      reshade::log_message(reshade::log_level::error, "initSwapChain(Color Space: Failed.)");
    }
  }

  static bool on_create_resource(
    reshade::api::device* device,
    reshade::api::resource_desc &desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state
  ) {
    auto pair = deviceBackBufferDesc.find(device);
    if (pair == deviceBackBufferDesc.end()) {
      std::stringstream s;
      s << "createResource(Unknown device)";
      reshade::log_message(reshade::log_level::warning, s.str().c_str());
      return false;
    }
    auto bufferDesc = pair->second;
    if (desc.texture.height != bufferDesc.texture.height) {
      std::stringstream s;
      s << "createResource(Wrong Height: " << desc.texture.height << " | " << bufferDesc.texture.height << " )";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
      return false;
    }
    if (desc.texture.width != bufferDesc.texture.width) {
      std::stringstream s;
      s << "createResource(Wrong Width: " << desc.texture.width << " | " << bufferDesc.texture.width << " )";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
      return false;
    }

    auto oldFormat = desc.texture.format;
    auto newFormat = desc.texture.format;
    switch (desc.texture.format) {
      case reshade::api::format::r10g10b10a2_unorm:
      case reshade::api::format::r8g8b8a8_unorm:
      case reshade::api::format::r8g8b8a8_unorm_srgb:
        newFormat = targetFormat;
        break;
      case reshade::api::format::r8g8b8a8_typeless:
        newFormat = targetFormatTypeless;
        break;
        // break;
      default:
        {
          std::stringstream s;
          s << "createResource(Wrong format: " << (uint32_t)desc.texture.format << ")";
          reshade::log_message(reshade::log_level::debug, s.str().c_str());
        }

        return false;
    }

    resourceCount++;

    if (resourceCount != (resourceUpgradeIndex + 1)) {
      std::stringstream s;
      s << "createResource(Wrong: " << resourceCount - 1 << ")";
      reshade::log_message(reshade::log_level::debug, s.str().c_str());
      return false;
    }
    std::stringstream s;
    s << "createResource("
      << std::hex << (uint32_t)desc.flags << std::dec
      << ", state: " << std::hex << (uint32_t)initial_state << std::dec
      << ", width: " << (uint32_t)desc.texture.width
      << ", height: " << (uint32_t)desc.texture.height
      << ", format: " << (uint32_t)oldFormat << " => " << (uint32_t)newFormat
      << ") [" << resourceCount << "]";
    reshade::log_message(
      desc.texture.format == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );

    if (useResourceCloning) {
      pendingResourceClones.emplace(device);
      return false;
    }

    desc.texture.format = newFormat;
    upgradedResourceDevices.emplace(device);
    return true;
  }

  static void on_init_resource(
    reshade::api::device* device,
    const reshade::api::resource_desc &desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource
  ) {
    if (useResourceCloning) {
      if (!pendingResourceClones.count(device)) return;
      pendingResourceClones.erase(device);
      reshade::api::resource resourceClone;
      reshade::api::resource_desc cloneDesc = desc;
      auto oldFormat = desc.texture.format;
      switch (desc.texture.format) {
        case reshade::api::format::r10g10b10a2_unorm:
        case reshade::api::format::r8g8b8a8_unorm:
        case reshade::api::format::r8g8b8a8_unorm_srgb:
          // cloneDesc.texture.format = targetFormat;
          break;
        case reshade::api::format::r8g8b8a8_typeless:
          // cloneDesc.texture.format = targetFormatTypeless;
          break;
        default:
          {
            std::stringstream s;
            s << "on_init_resource(Wrong format: " << (uint32_t)desc.texture.format << ")";
            reshade::log_message(reshade::log_level::warning, s.str().c_str());
          }
          return;
      }

      bool created = device->create_resource(
        cloneDesc,
        initial_data,
        initial_state,
        &resourceClone
      );
      if (created) {
        resourceClones.emplace(resource.handle, resourceClone);
      }
      std::stringstream s;
      s << "on_init_resource(cloned "
        << reinterpret_cast<void*>(resource.handle)
        << ", flags: " << std::hex << (uint32_t)cloneDesc.flags << std::dec
        << ", state: " << std::hex << (uint32_t)initial_state << std::dec
        << ", width: " << (uint32_t)cloneDesc.texture.width
        << ", height: " << (uint32_t)cloneDesc.texture.height
        << ", format: " << (uint32_t)desc.texture.format << " => " << (uint32_t)cloneDesc.texture.format
        << ")";
      reshade::log_message(
        created ? desc.texture.format == reshade::api::format::unknown
                  ? reshade::log_level::warning
                  : reshade::log_level::info
                : reshade::log_level::error,
        s.str().c_str()
      );
      return;
    }

    if (!upgradedResourceDevices.count(device)) return;
    upgradedResourceDevices.erase(device);
    upgradedResources.emplace(resource.handle);

    std::stringstream s;
    s << "on_init_resource("
      << reinterpret_cast<void*>(resource.handle)
      << ", flags: " << std::hex << (uint32_t)desc.flags << std::dec
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

  static bool on_create_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc &desc
  ) {
    if (!upgradeResourceViews && resourceUpgradeIndex == -1) return false;
    if (desc.format == targetFormat) return false;
    if (!resource.handle) return false;
    auto oldFormat = desc.format;

    if (upgradeResourceViews && backBuffers.count(resource.handle)) {
      desc.format = targetFormat;
    } else if (upgradedResources.count(resource.handle)) {
      desc.format = targetFormat;
    } else if (resourceClones.count(resource.handle)) {
      pendingResourceViewClones.emplace(device);
      return false;
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
      << ")";
    reshade::log_message(
      oldFormat == reshade::api::format::unknown
        ? reshade::log_level::warning
        : reshade::log_level::info,
      s.str().c_str()
    );
    return true;
  }

  static void on_init_resource_view(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc &desc,
    reshade::api::resource_view view
  ) {
    if (!useResourceCloning) return;
    if (!resource.handle) return;
    if (!pendingResourceViewClones.count(device)) return;

    pendingResourceViewClones.erase(device);

    auto pair = resourceClones.find(resource.handle);
    if (pair == resourceClones.end()) {
      reshade::log_message(reshade::log_level::warning, "init_resource_view(missing handle)");
      return;
    }

    reshade::api::resource_view_desc descClone = desc;

    // descClone.format = targetFormat;
    reshade::api::resource_view viewClone;
    bool cloned = device->create_resource_view(
      pair->second,
      usage_type,
      descClone,
      &viewClone
    );
    if (cloned) {
      resourceViewClones.emplace(view.handle, viewClone);
    }

    std::stringstream s;
    s << "init_resource_view(cloned "
      << reinterpret_cast<void*>(view.handle)
      << ", view type: " << (uint32_t)desc.type
      << ", view format: " << (uint32_t)desc.format << " => " << (uint32_t)descClone.format
      << ", resource: " << reinterpret_cast<void*>(resource.handle)
      << ", resource usage: " << std::hex << (uint32_t)usage_type << std::dec;
    if (resource.handle) {
      const auto resourceDesc = device->get_resource_desc(resource);
      s << ", resource type: " << (uint32_t)resourceDesc.type;

      switch (resourceDesc.type) {
        default:
        case reshade::api::resource_type::unknown:
          break;
        case reshade::api::resource_type::buffer:
          s << ", buffer offset: " << desc.buffer.offset;
          s << ", buffer size: " << desc.buffer.size;
          break;
        case reshade::api::resource_type::texture_1d:
        case reshade::api::resource_type::texture_2d:
        case reshade::api::resource_type::texture_3d:
        case reshade::api::resource_type::surface:
          s << ", texture format: " << (uint32_t)resourceDesc.texture.format;
          s << ", texture width: " << (uint32_t)resourceDesc.texture.width;
          s << ", texture height: " << (uint32_t)resourceDesc.texture.height;
      }
    }
    s << ")";
    reshade::log_message(cloned ? reshade::log_level::info : reshade::log_level::error, s.str().c_str());
  }

  static void on_map_buffer_region(
    reshade::api::device* device,
    reshade::api::resource resource,
    uint64_t offset,
    uint64_t size,
    reshade::api::map_access access,
    void** data
  ) {
    if (!useResourceCloning) return;
    auto pair = resourceClones.find(resource.handle);
    if (pair == resourceClones.end()) return;
    auto newResource = pair->second;
    device->map_buffer_region(
      newResource,
      offset,
      size,
      access,
      data
    );
    std::stringstream s;
    s << "on_map_buffer_region(clone: "
      << reinterpret_cast<void*>(resource.handle) << " => " << reinterpret_cast<void*>(newResource.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
  }

  static bool on_copy_resource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest
  ) {
    if (!useResourceCloning) return false;
    auto newSource = source;
    auto newDest = dest;
    auto pair = resourceClones.find(source.handle);
    if (pair == resourceClones.end()) {
      newSource = pair->second;
    } else {
      auto pair = resourceClones.find(dest.handle);
      if (pair == resourceClones.end()) return false;
      newDest = pair->second;
    }
    cmd_list->copy_resource(newSource, newDest);

    std::stringstream s;
    s << "on_copy_resource(clone: "
      << reinterpret_cast<void*>(source.handle) << " => " << reinterpret_cast<void*>(newSource.handle)
      << " to " << reinterpret_cast<void*>(dest.handle) << " => " << reinterpret_cast<void*>(newDest.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return true;
  }

  static void on_barrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states
  ) {
    if (!useResourceCloning) return;
    return;
    for (uint32_t i = 0; i < count; i++) {
      auto pair = resourceClones.find(resources[i].handle);
      if (pair == resourceClones.end()) continue;
      cmd_list->barrier(pair->second, old_states[i], new_states[i]);

      std::stringstream s;
      s << "on_barrier(clone "
        << reinterpret_cast<void*>(resources[i].handle)
        << ", " << std::hex << (uint32_t)old_states[i] << std::dec
        << " => " << std::hex << (uint32_t)new_states[i] << std::dec
        << ")"
        << "[" << i << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  static void on_bind_render_targets_and_depth_stencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv
  ) {
    if (!useResourceCloning) return;
    bool needsNewRTVs = false;
    reshade::api::resource_view* clone;

    for (uint32_t i = 0; i < count; i++) {
      reshade::api::resource_view rtv = rtvs[i];
      auto pair = resourceViewClones.find(rtv.handle);
      if (pair == resourceViewClones.end()) continue;
      if (!needsNewRTVs) {
        clone = new reshade::api::resource_view[count];
        memcpy(clone, rtvs, sizeof(reshade::api::resource_view) * count);
        needsNewRTVs = true;
      }
      auto cloneSubject = &clone[i];
      auto newResourceView = pair->second;
      cloneSubject->handle = pair->second.handle;

      std::stringstream s;
      s << "on_bind_render_targets_and_depth_stencil(rtv clone: "
        << reinterpret_cast<void*>(rtv.handle) << " => " << reinterpret_cast<void*>(newResourceView.handle)
        << ") [" << count << "]";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
    if (needsNewRTVs) {
      cmd_list->bind_render_targets_and_depth_stencil(
        count,
        clone,
        dsv
      );
    } else {
      auto pair = resourceViewClones.find(dsv.handle);
      if (pair == resourceViewClones.end()) return;
      auto newResourceView = pair->second;
      cmd_list->bind_render_targets_and_depth_stencil(
        count,
        rtvs,
        newResourceView
      );
      std::stringstream s;
      s << "on_bind_render_targets_and_depth_stencil(dsv clone: "
        << reinterpret_cast<void*>(dsv.handle) << " => " << reinterpret_cast<void*>(newResourceView.handle)
        << ")";
      reshade::log_message(reshade::log_level::info, s.str().c_str());
    }
  }

  bool on_clear_depth_stencil_view(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view dsv,
    const float* depth,
    const uint8_t* stencil,
    uint32_t rect_count,
    const reshade::api::rect* rects
  ) {
    if (!useResourceCloning) return false;
    auto pair = resourceViewClones.find(dsv.handle);
    if (pair == resourceViewClones.end()) return false;
    auto newResourceView = pair->second;
    cmd_list->clear_depth_stencil_view(
      newResourceView,
      depth,
      stencil,
      rect_count,
      rects
    );
    std::stringstream s;
    s << "on_clear_depth_stencil_view(dsv clone: "
      << reinterpret_cast<void*>(dsv.handle) << " => " << reinterpret_cast<void*>(newResourceView.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return true;
  }

  bool on_clear_render_target_view(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects
  ) {
    if (!useResourceCloning) return false;
    auto pair = resourceViewClones.find(rtv.handle);
    if (pair == resourceViewClones.end()) return false;
    auto newResourceView = pair->second;
    cmd_list->clear_render_target_view(
      newResourceView,
      color,
      rect_count,
      rects
    );
    std::stringstream s;
    s << "on_clear_render_target_view(clone: "
      << reinterpret_cast<void*>(rtv.handle) << " => " << reinterpret_cast<void*>(newResourceView.handle)
      << ")";
    reshade::log_message(reshade::log_level::info, s.str().c_str());
    return true;
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

  static void on_present(
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
    if (value) {
      targetFormat = reshade::api::format::r10g10b10a2_unorm;
      targetColorSpace = reshade::api::color_space::hdr10_st2084;
    } else {
      targetFormat = reshade::api::format::r16g16b16a16_float;
      targetColorSpace = reshade::api::color_space::extended_srgb_linear;
    }
  }

  static void setResourceUpgradeIndex(int32_t value = -1) {
    resourceUpgradeIndex = value;
  }

  static void use(DWORD fdwReason) {
    switch (fdwReason) {
      case DLL_PROCESS_ATTACH:
        reshade::register_event<reshade::addon_event::create_swapchain>(on_create_swapchain);
        reshade::register_event<reshade::addon_event::init_swapchain>(on_init_swapchain);
        reshade::register_event<reshade::addon_event::init_resource>(on_init_resource);
        reshade::register_event<reshade::addon_event::create_resource>(on_create_resource);

        if (useResourceCloning) {
          reshade::register_event<reshade::addon_event::create_resource_view>(on_create_resource_view);
          reshade::register_event<reshade::addon_event::init_resource_view>(on_init_resource_view);

          reshade::register_event<reshade::addon_event::map_buffer_region>(on_map_buffer_region);
          reshade::register_event<reshade::addon_event::copy_resource>(on_copy_resource);
          reshade::register_event<reshade::addon_event::barrier>(on_barrier);

          reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(on_bind_render_targets_and_depth_stencil);
          reshade::register_event<reshade::addon_event::clear_depth_stencil_view>(on_clear_depth_stencil_view);
          reshade::register_event<reshade::addon_event::clear_render_target_view>(on_clear_render_target_view);
        }

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
