/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <dxgi.h>
#include <dxgi1_6.h>

#include <cstdint>
#include <cstdio>
#include <initializer_list>
#include <memory>
#include <mutex>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "../utils/descriptor.hpp"
#include "../utils/format.hpp"
#include "../utils/hash.hpp"
#include "../utils/mutex.hpp"
#include "../utils/pipeline.hpp"
#include "../utils/resource.hpp"
#include "../utils/state.hpp"
#include "../utils/swapchain.hpp"

namespace renodx::mods::swapchain {

// STRUCTS
struct SwapChainUpgradeTarget {
  reshade::api::format old_format = reshade::api::format::r8g8b8a8_unorm;
  reshade::api::format new_format = reshade::api::format::r16g16b16a16_float;
  int32_t index = -1;
  bool ignore_size = false;
  uint32_t shader_hash = 0;
  bool use_resource_view_cloning = false;
  bool use_resource_view_hot_swap = false;
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
  reshade::api::resource_usage state = reshade::api::resource_usage::undefined;

  static const int16_t BACK_BUFFER = -1;
  static const int16_t ANY = -2;
  float aspect_ratio = ANY;

  uint32_t usage_set = 0;
  uint32_t usage_unset = 0;

  bool ignore_reset = false;

#define SwapChainViewUpgrade(usage, source, destination) \
  { {reshade::api::resource_usage::usage, reshade::api::format::source}, reshade::api::format::destination }
#define SwapChainViewUpgradeAll(source, destination)               \
  SwapChainViewUpgrade(shader_resource, source, destination),      \
      SwapChainViewUpgrade(unordered_access, source, destination), \
      SwapChainViewUpgrade(render_target, source, destination)

  const std::unordered_map<
      std::pair<reshade::api::resource_usage, reshade::api::format>,
      reshade::api::format, utils::hash::HashPair>
      VIEW_UPGRADES_RGBA16F = {
          SwapChainViewUpgradeAll(r16g16b16a16_typeless, r16g16b16a16_typeless),
          SwapChainViewUpgradeAll(r10g10b10a2_typeless, r16g16b16a16_typeless),
          SwapChainViewUpgradeAll(r8g8b8a8_typeless, r16g16b16a16_typeless),
          SwapChainViewUpgradeAll(r16g16b16a16_float, r16g16b16a16_float),
          SwapChainViewUpgradeAll(r10g10b10a2_unorm, r16g16b16a16_float),
          SwapChainViewUpgradeAll(b10g10r10a2_unorm, r16g16b16a16_float),
          SwapChainViewUpgradeAll(r8g8b8a8_unorm, r16g16b16a16_float),
          SwapChainViewUpgradeAll(b8g8r8a8_unorm, r16g16b16a16_float),
          SwapChainViewUpgradeAll(r8g8b8a8_snorm, r16g16b16a16_float),
          SwapChainViewUpgradeAll(r8g8b8a8_unorm_srgb, r16g16b16a16_float),
          SwapChainViewUpgradeAll(b8g8r8a8_unorm_srgb, r16g16b16a16_float),
          SwapChainViewUpgradeAll(r11g11b10_float, r16g16b16a16_float),
  };

  const std::unordered_map<
      std::pair<reshade::api::resource_usage, reshade::api::format>,
      reshade::api::format, utils::hash::HashPair>
      VIEW_UPGRADES_R10G10B10A2_UNORM = {
          SwapChainViewUpgradeAll(r10g10b10a2_typeless, r10g10b10a2_typeless),
          SwapChainViewUpgradeAll(r8g8b8a8_typeless, r10g10b10a2_typeless),
          SwapChainViewUpgradeAll(r10g10b10a2_unorm, r10g10b10a2_unorm),
          SwapChainViewUpgradeAll(b10g10r10a2_unorm, r10g10b10a2_unorm),
          SwapChainViewUpgradeAll(r8g8b8a8_unorm, r10g10b10a2_unorm),
          SwapChainViewUpgradeAll(b8g8r8a8_unorm, r10g10b10a2_unorm),
          SwapChainViewUpgradeAll(r8g8b8a8_unorm_srgb, r10g10b10a2_unorm),
          SwapChainViewUpgradeAll(b8g8r8a8_unorm_srgb, r10g10b10a2_unorm),
  };

  std::unordered_map<
      std::pair<reshade::api::resource_usage, reshade::api::format>,
      reshade::api::format, utils::hash::HashPair>
      view_upgrades = VIEW_UPGRADES_RGBA16F;

  struct Dimensions {
    int16_t width = ANY;
    int16_t height = ANY;
    int16_t depth = ANY;
  };
  Dimensions dimensions = {.width = BACK_BUFFER, .height = BACK_BUFFER, .depth = BACK_BUFFER};
  Dimensions new_dimensions = {.width = ANY, .height = ANY, .depth = ANY};

  reshade::api::resource_usage usage_include = reshade::api::resource_usage::undefined;
  reshade::api::resource_usage usage_exclude = reshade::api::resource_usage::undefined;

  bool use_resource_view_cloning_and_upgrade = false;

  std::string name;

  [[nodiscard]] bool CheckResourceDesc(
      reshade::api::resource_desc desc,
      reshade::api::resource_desc back_buffer_desc,
      reshade::api::resource_usage state = reshade::api::resource_usage::undefined) const {
    if (desc.texture.format != this->old_format) return false;
    if (this->usage != reshade::api::resource_usage::undefined) {
      if (this->usage != desc.usage) return false;
    }

    if (this->usage_include != 0 && (desc.usage & this->usage_include) == 0) return false;
    if (this->usage_exclude != 0 && (desc.usage & this->usage_exclude) != 0) return false;

    if (this->state != reshade::api::resource_usage::undefined) {
      if (this->state != state) return false;
    }
    if (!this->ignore_size) {
      if (this->aspect_ratio == ANY) {
        if (dimensions.width == BACK_BUFFER) {
          if (back_buffer_desc.type == reshade::api::resource_type::unknown) return false;
          if (desc.texture.width != back_buffer_desc.texture.width) return false;
        } else if (dimensions.width > 0) {
          if (desc.texture.width != dimensions.width) return false;
        }

        if (dimensions.height == BACK_BUFFER) {
          if (back_buffer_desc.type == reshade::api::resource_type::unknown) return false;
          if (desc.texture.height != back_buffer_desc.texture.height) return false;
        } else if (dimensions.height > 0) {
          if (desc.texture.height != dimensions.height) return false;
        }

        if (dimensions.depth >= 0) {
          if (desc.texture.depth_or_layers != dimensions.depth) return false;
        }
      } else {
        const float view_ratio = static_cast<float>(desc.texture.width) / static_cast<float>(desc.texture.height);
        float target_ratio;
        if (this->aspect_ratio == BACK_BUFFER) {
          if (back_buffer_desc.type == reshade::api::resource_type::unknown) return false;
          target_ratio = back_buffer_desc.texture.width / back_buffer_desc.texture.height;
        } else {
          target_ratio = this->aspect_ratio;
        }
        static const float TOLERANCE = 0.0001f;
        const float diff = std::abs(view_ratio - target_ratio);
        if (diff > TOLERANCE) return false;
      }
    }
    return true;
  }

  float resource_tag = -1;

  uint32_t counted = 0;
  bool completed = false;
};

struct BoundDescriptorInfo {
  reshade::api::shader_stage stages;
  reshade::api::pipeline_layout layout;
  uint32_t first;
  uint32_t count;
  std::vector<reshade::api::descriptor_table> tables;
};

struct PushDescriptorInfo {
  reshade::api::shader_stage stages;
  reshade::api::pipeline_layout layout;
  uint32_t layout_param;
  reshade::api::descriptor_table_update update;
};

struct HeapDescriptorInfo {
  std::vector<reshade::api::descriptor_table_update> updates;
  uint64_t replacement_descriptor_handle;
  bool is_active;
};

struct __declspec(uuid("809df2f6-e1c7-4d93-9c6e-fa88dd960b7c")) DeviceData {
  reshade::api::resource original_resource;
  reshade::api::resource_view original_resource_view;

  SwapChainUpgradeTarget* applied_target = nullptr;
  bool upgraded_resource_needs_view_clone = false;
  bool upgraded_resource_view = false;
  bool resource_upgrade_finished = false;
  bool prevent_full_screen = false;

  // <resource_original.handle, SwapChainUpgradeTarget>
  std::unordered_map<uint64_t, SwapChainUpgradeTarget*> resource_upgrade_targets;
  // <resource_original.handle, SwapChainUpgradeTarget>
  std::unordered_map<uint64_t, SwapChainUpgradeTarget*> resource_clone_targets;
  // <resource_view_original.handle, SwapChainUpgradeTarget>
  std::unordered_map<uint64_t, SwapChainUpgradeTarget*> resource_view_clone_targets;

  // <resource_original.handle, resource_usage>
  std::unordered_map<uint64_t, reshade::api::resource_usage> resource_initial_state;
  // <resource_original.handle, resource_usage>
  std::unordered_map<uint64_t, reshade::api::resource_usage> resource_view_usage;

  // <resource_original.handle>
  std::unordered_set<uint64_t> resource_clone_enabled;

  // <resource_original.handle, resource_clone.handle>
  std::unordered_map<uint64_t, uint64_t> resource_clones;
  // <resource_view_original.handle, resource_view_clone.handle>
  std::unordered_map<uint64_t, reshade::api::resource_view> resource_view_clones;

  std::unordered_map<uint64_t, reshade::api::resource> upgraded_resources;
  std::unordered_map<uint64_t, reshade::api::format> upgraded_resource_formats;
  std::unordered_map<uint64_t, reshade::api::resource_view> upgraded_resource_views;

  std::shared_mutex mutex;

  // <descriptor_heap.handle, std::map<base_offset, descriptor_table>>
  std::unordered_map<uint64_t, std::unordered_map<uint32_t, HeapDescriptorInfo*>> heap_descriptor_infos;

  reshade::api::pipeline_layout swap_chain_proxy_layout = {0};
  reshade::api::pipeline swap_chain_proxy_pipeline = {0};
  reshade::api::sampler swap_chain_proxy_sampler = {0};
  // Clone => SRV
  std::unordered_map<uint64_t, reshade::api::resource_view> swap_chain_proxy_srvs;
  // Buffer => RTV
  std::unordered_map<uint64_t, reshade::api::resource_view> swap_chain_proxy_rtvs;
  std::unordered_map<uint64_t, reshade::api::resource_view> swap_chain_rtvs;

  std::vector<std::uint8_t> swap_chain_proxy_vertex_shader;
  std::vector<std::uint8_t> swap_chain_proxy_pixel_shader;
  int32_t expected_constant_buffer_index = -1;
  uint32_t expected_constant_buffer_space = 0;
};

struct __declspec(uuid("0a2b51ad-ef13-4010-81a4-37a4a0f857a6")) CommandListData {
  std::vector<BoundDescriptorInfo> unbound_descriptors;
  std::vector<PushDescriptorInfo> unpushed_updates;
};

// Variables

static const reshade::api::resource_view NULL_RESOURCE_VIEW = {0};

static bool attached = false;
static std::vector<SwapChainUpgradeTarget> swap_chain_upgrade_targets = {};
static reshade::api::format target_format = reshade::api::format::r16g16b16a16_float;
static reshade::api::color_space target_color_space = reshade::api::color_space::extended_srgb_linear;
static bool use_shared_device = false;
static bool use_resource_cloning = false;
static bool use_resize_buffer = false;
static bool use_resize_buffer_on_set_full_screen = false;
static bool use_resize_buffer_on_demand = false;
static bool use_resize_buffer_on_present = false;
static bool upgrade_unknown_resource_views = false;
static bool upgrade_resource_views = true;
static bool prevent_full_screen = true;
static bool force_borderless = true;
static bool is_vulkan = false;
static bool swapchain_proxy_compatibility_mode = true;
static reshade::api::format swap_chain_proxy_format = reshade::api::format::r16g16b16a16_float;
static std::vector<std::uint8_t> swap_chain_proxy_vertex_shader = {};
static std::vector<std::uint8_t> swap_chain_proxy_pixel_shader = {};
static int32_t expected_constant_buffer_index = -1;
static uint32_t expected_constant_buffer_space = 0;
static float* shader_injection = nullptr;
static size_t shader_injection_size = 0;

static SwapChainUpgradeTarget swap_chain_proxy_upgrade_target = {
    .new_format = target_format,
    .usage_set =
        static_cast<uint32_t>(
            reshade::api::resource_usage::shader_resource
            | reshade::api::resource_usage::render_target),
    .use_resource_view_cloning_and_upgrade = true,
};

// Methods

static bool UsingSwapchainProxy() {
  return !swap_chain_proxy_pixel_shader.empty();
}

static bool UsingSwapchainCompatibilityMode() {
  return swapchain_proxy_compatibility_mode && (target_format == swap_chain_proxy_format);
}

static void CheckSwapchainSize(
    reshade::api::swapchain* swapchain,
    reshade::api::resource_desc buffer_desc) {
  if (!prevent_full_screen && !force_borderless) return;
  HWND output_window = static_cast<HWND>(swapchain->get_hwnd());
  if (output_window == nullptr) {
    reshade::log::message(reshade::log::level::debug, "No HWND?");
    return;
  }

  if (utils::swapchain::IsDirectX(swapchain)) {
    auto* native_swapchain = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());

    if (prevent_full_screen) {
      IDXGIFactory* factory;
      if (SUCCEEDED(native_swapchain->GetParent(IID_PPV_ARGS(&factory)))) {
        factory->MakeWindowAssociation(output_window, DXGI_MWA_NO_WINDOW_CHANGES);
        reshade::log::message(reshade::log::level::debug, "mods::swapchain::CheckSwapchainSize(set DXGI_MWA_NO_WINDOW_CHANGES)");
        factory->Release();
        factory = nullptr;
      } else {
        reshade::log::message(reshade::log::level::error, "mods::swapchain::CheckSwapchainSize(could not find DXGI factory)");
      }
    }
  }

  if (force_borderless) {
    RECT window_rect = {};
    GetClientRect(output_window, &window_rect);

    const int screen_width = GetSystemMetrics(SM_CXSCREEN);
    const int screen_height = GetSystemMetrics(SM_CYSCREEN);
    const int window_width = window_rect.right - window_rect.left;
    const int window_height = window_rect.bottom - window_rect.top;

    std::stringstream s;
    s << "mods::swapchain::CheckSwapchainSize(";
    s << "screenWidth: " << screen_width;
    s << ", screenHeight: " << screen_height;
    s << ", bufferWidth: " << buffer_desc.texture.width;
    s << ", bufferHeight: " << buffer_desc.texture.height;
    s << ", windowWidth: " << window_width;
    s << ", windowHeight: " << window_height;
    s << ", windowTop: " << window_rect.top;
    s << ", windowLeft: " << window_rect.left;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    if (screen_width != buffer_desc.texture.width) return;
    if (screen_height != buffer_desc.texture.height) return;
    // if (window_rect.top == 0 && window_rect.left == 0) return;
    SetWindowLongPtr(output_window, GWL_STYLE, WS_VISIBLE | WS_POPUP);
    SetWindowPos(output_window, HWND_TOP, 0, 0, screen_width, screen_height, SWP_FRAMECHANGED);
  }
}

static reshade::api::descriptor_table_update CloneDescriptorUpdateWithResourceView(
    const reshade::api::descriptor_table_update update,
    reshade::api::resource_view view,
    uint32_t index = 0) {
  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view: {
      auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[index];
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::sampler_with_resource_view{
              .sampler = item.sampler,
              .view = view,
          },
      };
      break;
    }
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::shader_resource_view:

    case reshade::api::descriptor_type::unordered_access_view: {
      return reshade::api::descriptor_table_update{
          .table = update.table,
          .binding = update.binding + index,
          .count = 1,
          .type = update.type,
          .descriptors = new reshade::api::resource_view{view.handle},
      };
      break;
    }
    default:
      break;
  }
  return {};
}

static bool FlushResourceViewInDescriptorTable(
    reshade::api::device* device,
    reshade::api::resource resource) {
  return true;
}

static bool ActivateCloneHotSwap(
    reshade::api::device* device,
    reshade::api::resource_view resource_view) {
  auto resource = device->get_resource_from_view(resource_view);
  if (resource.handle == 0u) {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(no handle for rsv ";
    s << reinterpret_cast<void*>(resource_view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  reshade::api::resource clone_resource;

  auto cloned_resource_pair = data.resource_clones.find(resource.handle);
  if (cloned_resource_pair == data.resource_clones.end()) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(";
    if (renodx::utils::swapchain::IsBackBuffer(device, resource)) {
      s << ("backbuffer ");
    }
    s << "not cloned ";
    s << reinterpret_cast<void*>(resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    // Resource is not a cloned resource (fail)
    return false;
  }

  clone_resource = reshade::api::resource{cloned_resource_pair->second};

  if (data.resource_clone_enabled.contains(resource.handle)) {
    // Already activated
    return false;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::ActivateCloneHotSwap(activating res: ";
    s << reinterpret_cast<void*>(resource.handle);
    s << " => clone: ";
    s << reinterpret_cast<void*>(clone_resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

#endif

  data.resource_clone_enabled.insert(resource.handle);
  return true;
}

static reshade::api::resource CloneResource(
    reshade::api::device* device,
    DeviceData* private_data,
    const reshade::api::resource resource) {
  auto desc = device->get_resource_desc(resource);
  auto* target = private_data->resource_clone_targets[resource.handle];
  reshade::api::resource_desc new_desc = desc;
  new_desc.texture.format = target->new_format;
  new_desc.usage = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(desc.usage)
      | (target->usage_set & ~target->usage_unset));

  auto& initial_state = private_data->resource_initial_state[resource.handle];
  reshade::api::resource resource_clone = {0};
#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "mods::swapchain::CloneResource(";
  s << reinterpret_cast<void*>(resource.handle);
  s << ", format: " << desc.texture.format << " => " << new_desc.texture.format;
  s << ", type: " << desc.type;
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", heap: " << std::hex << static_cast<uint32_t>(desc.heap) << std::dec;
  s << ", usage: 0x" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
  s << ", new_usage: 0x" << std::hex << static_cast<uint32_t>(new_desc.usage) << std::dec;
  s << ", initial_state: " << initial_state;
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  new_desc.flags = reshade::api::resource_flags::none;

  if (device->create_resource(
          new_desc,
          nullptr,  // initial_data
          initial_state,
          &resource_clone)) {
    private_data->resource_clones[resource.handle] = resource_clone.handle;

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "mods::swapchain::CloneResource(";
      s << reinterpret_cast<void*>(resource.handle);
      s << " => " << reinterpret_cast<void*>(resource_clone.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
  } else {
    resource_clone.handle = 0;
    {
      std::stringstream s;
      s << "mods::swapchain::CloneResource(Failed to clone: ";
      s << reinterpret_cast<void*>(resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
    }
  }

  // private_data->resources_that_need_resource_view_clones.insert(resource.handle);

  return resource_clone;
}

static void SetupSwapchainProxyLayout(reshade::api::device* device, DeviceData* data) {
  reshade::api::pipeline_layout_param param_sampler;
  param_sampler.type = reshade::api::pipeline_layout_param_type::push_descriptors;
  param_sampler.push_descriptors.count = 1;
  param_sampler.push_descriptors.type = reshade::api::descriptor_type::sampler;

  reshade::api::pipeline_layout_param param_srv;
  param_srv.type = reshade::api::pipeline_layout_param_type::push_descriptors;
  param_srv.push_descriptors.count = 1;
  param_srv.push_descriptors.type = reshade::api::descriptor_type::texture_shader_resource_view;

  std::vector<reshade::api::pipeline_layout_param> new_layout_params = {param_sampler, param_srv};

  if (shader_injection_size != 0u) {
    reshade::api::pipeline_layout_param param_constants;
    param_constants.type = reshade::api::pipeline_layout_param_type::push_constants;
    param_constants.push_constants.count = 1;
    if (device->get_api() == reshade::api::device_api::d3d12 || device->get_api() == reshade::api::device_api::vulkan) {
      param_constants.push_constants.count = shader_injection_size;
    } else {
      param_constants.push_constants.count = 1;
    }
    if (data->expected_constant_buffer_index == -1) {
      if (device->get_api() == reshade::api::device_api::d3d12 || device->get_api() == reshade::api::device_api::vulkan) {
        param_constants.push_constants.dx_register_index = 0;
      } else {
        param_constants.push_constants.dx_register_index = 13;
      }
    } else {
      param_constants.push_constants.dx_register_index = data->expected_constant_buffer_index;
    }
    param_constants.push_constants.dx_register_space = data->expected_constant_buffer_space;
    new_layout_params.push_back(param_constants);
  }

  reshade::log::message(reshade::log::level::debug, "mods::swapchain::SetupSwapchainProxy(Creating pipeline layout)");

  device->create_pipeline_layout(new_layout_params.size(), new_layout_params.data(), &data->swap_chain_proxy_layout);
}

static void SetupSwapchainProxy(
    reshade::api::swapchain* swapchain,
    reshade::api::device* device,
    DeviceData* data) {
  const size_t back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    swap_chain_proxy_upgrade_target.new_format = swap_chain_proxy_format;
    if (swap_chain_proxy_format == reshade::api::format::r10g10b10a2_unorm) {
      swap_chain_proxy_upgrade_target.view_upgrades = swap_chain_proxy_upgrade_target.VIEW_UPGRADES_R10G10B10A2_UNORM;
    }
    auto buffer = swapchain->get_back_buffer(index);
    if (!UsingSwapchainCompatibilityMode()) {
      {
        std::stringstream s;
        s << "mods::swapchain::SetupSwapchainProxy(Marking swapchain buffer for cloning: ";
        s << reinterpret_cast<void*>(buffer.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }
      data->resource_clone_enabled.emplace(buffer.handle);
    }
    data->resource_clone_targets[buffer.handle] = &swap_chain_proxy_upgrade_target;
    data->resource_initial_state[buffer.handle] = reshade::api::resource_usage::general;
  }

  SetupSwapchainProxyLayout(device, data);
  if (data->swap_chain_proxy_layout != 0u) {
    data->swap_chain_proxy_pipeline = renodx::utils::pipeline::CreateRenderPipeline(
        device,
        data->swap_chain_proxy_layout,
        {
            {reshade::api::pipeline_subobject_type::vertex_shader, data->swap_chain_proxy_vertex_shader},
            {reshade::api::pipeline_subobject_type::pixel_shader, data->swap_chain_proxy_pixel_shader},
        },
        target_format);
  }

  device->create_sampler({}, &data->swap_chain_proxy_sampler);
}

static reshade::api::resource GetResourceClone(
    reshade::api::device* device,
    DeviceData* private_data,
    const reshade::api::resource resource) {
  if (!private_data->resource_clone_enabled.contains(resource.handle)) return {0};
  auto& handle = private_data->resource_clones[resource.handle];
  if (handle == 0) {
    handle = CloneResource(device, private_data, resource).handle;
  }
  return {handle};
}

static reshade::api::resource GetResourceClone(
    reshade::api::device* device,
    const DeviceData* private_data,
    const reshade::api::resource resource) {
  if (!private_data->resource_clone_enabled.contains(resource.handle)) return {0};
  auto pair = private_data->resource_clones.find(resource.handle);
  if (pair != private_data->resource_clones.end()) {
    return {pair->second};
  }
  return {0};
}

static const reshade::api::resource_view& GetResourceViewClone(
    reshade::api::device* device,
    DeviceData* private_data,
    const reshade::api::resource_view resource_view) {
  auto target_pair = private_data->resource_view_clone_targets.find(resource_view.handle);
  if (target_pair == private_data->resource_view_clone_targets.end()) return NULL_RESOURCE_VIEW;

  const auto resource = device->get_resource_from_view(resource_view);
  if (resource.handle == 0) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::GetResourceViewClone(";
    s << reinterpret_cast<void*>(resource_view.handle);
    s << ", no resource";
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    return NULL_RESOURCE_VIEW;
  }

  if (!private_data->resource_clone_enabled.contains(resource.handle)) return NULL_RESOURCE_VIEW;

  auto& resource_view_clone = private_data->resource_view_clones[resource_view.handle];
  if (resource_view_clone.handle == 0) {
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "mods::swapchain::GetResourceViewClone(";
      s << reinterpret_cast<void*>(resource_view.handle);
      s << ", original resource: " << reinterpret_cast<void*>(resource.handle);
      s << ", creating view clone";
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
#endif
    auto& resource_handle = private_data->resource_clones[resource.handle];
    if (resource_handle == 0) {
      resource_handle = CloneResource(device, private_data, resource).handle;
    }
    if (resource_handle == 0u) {
      std::stringstream s;
      s << "mods::swapchain::GetResourceViewClone(Failed to build resource clone: ";
      s << reinterpret_cast<void*>(resource_view.handle);
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return NULL_RESOURCE_VIEW;
    }
    auto* target = target_pair->second;
    auto new_desc = device->get_resource_view_desc(resource_view);
    auto usage = private_data->resource_view_usage[resource_view.handle];

    if (auto pair2 = target->view_upgrades.find({usage, new_desc.format});
        pair2 != target->view_upgrades.end()) {
      new_desc.format = pair2->second;
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::GetResourceViewClone(";
      s << reinterpret_cast<void*>(resource_view.handle);

      s << ", view_upgrades format: " << new_desc.format;
      s << ", clone: " << reinterpret_cast<void*>(resource_handle);
      s << ", type: " << new_desc.type;
      s << ", usage: " << static_cast<uint32_t>(usage) << "(" << usage << ")";
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    } else {
      new_desc.format = target->new_format;
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::GetResourceViewClone(";
      s << reinterpret_cast<void*>(resource_view.handle);
      s << ", fallback format: " << new_desc.format;
      s << ", clone: " << reinterpret_cast<void*>(resource_handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    }

    device->create_resource_view(
        {resource_handle},
        usage,
        new_desc,
        &resource_view_clone);

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "mods::swapchain::GetResourceViewClone(";
      s << reinterpret_cast<void*>(resource_view.handle);
      s << " => " << reinterpret_cast<void*>(resource_view_clone.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
  }
  return resource_view_clone;
}

static const reshade::api::resource_view& GetResourceViewClone(
    reshade::api::device* device,
    const reshade::api::resource_view resource_view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  return GetResourceViewClone(device, &data, resource_view);
}

static const reshade::api::resource_view& GetResourceViewClone(
    reshade::api::command_list* cmd_list,
    const reshade::api::resource_view resource_view) {
  return GetResourceViewClone(cmd_list->get_device(), resource_view);
}

static void ReleaseResourceView(
    reshade::api::device* device,
    DeviceData& data,  // mutex locked
    reshade::api::resource_view view) {
  if (auto pair = data.resource_view_clones.find(view.handle);
      pair != data.resource_view_clones.end()) {
    device->destroy_resource_view({pair->second});
    data.resource_view_clones.erase(pair);
  }
  data.resource_view_clone_targets.erase(view.handle);
  data.swap_chain_rtvs.erase(view.handle);
}

static void RewriteRenderTargets(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (count == 0u) return;

  auto* device = cmd_list->get_device();

  reshade::api::resource_view* new_rtvs = nullptr;

  bool changed = false;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::resource_view resource_view = rtvs[i];
    if (resource_view.handle == 0u) continue;

    auto new_resource_view = GetResourceViewClone(device, &data, resource_view);

    if (new_resource_view.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::RewriteRenderTargets(rewrite ";
    s << reinterpret_cast<void*>(resource_view.handle);
    s << " => ";
    s << reinterpret_cast<void*>(new_resource_view.handle);
    s << ") [" << i << "]";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    if (!changed) {
      const size_t size = count * sizeof(reshade::api::resource_view);
      new_rtvs = static_cast<reshade::api::resource_view*>(malloc(size));
      memcpy(new_rtvs, rtvs, size);
      changed = true;
    }
    new_rtvs[i] = new_resource_view;
  }
  if (!changed) return;

  cmd_list->bind_render_targets_and_depth_stencil(count, new_rtvs, dsv);
  free(new_rtvs);
}

static void DiscardDescriptors(reshade::api::command_list* cmd_list) {
  auto& cmd_data = cmd_list->get_private_data<CommandListData>();
  cmd_data.unbound_descriptors.clear();
  cmd_data.unpushed_updates.clear();
}

static void FlushDescriptors(reshade::api::command_list* cmd_list) {
  auto& cmd_data = cmd_list->get_private_data<CommandListData>();
  for (auto info : cmd_data.unbound_descriptors) {
    cmd_list->bind_descriptor_tables(
        info.stages,
        info.layout,
        info.first,
        info.count,
        info.tables.data());
  }
  cmd_data.unbound_descriptors.clear();

  for (auto info : cmd_data.unpushed_updates) {
    cmd_list->push_descriptors(
        info.stages,
        info.layout,
        info.layout_param,
        info.update);
  }
  cmd_data.unpushed_updates.clear();
}

static void DrawSwapChainProxy(reshade::api::swapchain* swapchain, reshade::api::command_queue* queue) {
  auto* cmd_list = queue->get_immediate_command_list();
  auto current_back_buffer = swapchain->get_current_back_buffer();
  auto* device = swapchain->get_device();
  auto& data = device->get_private_data<DeviceData>();

  auto previous_state = renodx::utils::state::GetCurrentState(cmd_list);

  if (std::addressof(data) == nullptr) return;

  // std::shared_lock data_lock(data.mutex);

  reshade::api::resource swapchain_clone;

  if (UsingSwapchainCompatibilityMode()) {
    auto& handle = data.resource_clones[current_back_buffer.handle];
    if (handle == 0) {
      handle = CloneResource(device, &data, current_back_buffer).handle;
    }
    if (handle == 0u) return;
    swapchain_clone = {handle};

    // Copy current swapchain to clone
    cmd_list->copy_resource(current_back_buffer, swapchain_clone);
  } else {
    auto clone_pair = data.resource_clones.find(current_back_buffer.handle);
    if (clone_pair == data.resource_clones.end()) return;

    swapchain_clone = {clone_pair->second};
  }

  std::stringstream s;
  s << "mods::swapchain::OnPresent(";
  s << reinterpret_cast<void*>(swapchain_clone.handle);
  s << " => " << reinterpret_cast<void*>(current_back_buffer.handle);

  if (data.swap_chain_proxy_layout.handle == 0u) {
    reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnPresent(No pipeline layout handle. Creating...)");
    SetupSwapchainProxyLayout(device, &data);
    if (data.swap_chain_proxy_layout.handle == 0u) {
      reshade::log::message(reshade::log::level::warning, "No pipeline layout handle.");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
    {
      std::stringstream s;
      s << "mods::swapchain::OnPresent(Pipeline layout:";
      s << reinterpret_cast<void*>(data.swap_chain_proxy_layout.handle);
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }
  s << ", layout: " << reinterpret_cast<void*>(data.swap_chain_proxy_layout.handle);

  // Bind sampler and SRV

  auto& srv = data.swap_chain_proxy_srvs[swapchain_clone.handle];
  if (srv.handle == 0u) {
    reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnPresent(No SRV. Creating...)");
    device->create_resource_view(
        swapchain_clone,
        reshade::api::resource_usage::shader_resource,
        reshade::api::resource_view_desc(swap_chain_proxy_format),
        &srv);

    if (srv.handle == 0u) {
      reshade::log::message(reshade::log::level::warning, "No SRV.");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
  }
  s << ", srv: " << reinterpret_cast<void*>(srv.handle);

  // Create RTV on the fly (reusing existing may cause conflicts)

  auto& rtv = data.swap_chain_proxy_rtvs[current_back_buffer.handle];
  if (rtv.handle == 0u) {
    auto buffer_desc = device->get_resource_desc(current_back_buffer);
    device->create_resource_view(
        current_back_buffer,
        reshade::api::resource_usage::render_target,
        reshade::api::resource_view_desc(buffer_desc.texture.format),
        &rtv);

    if (rtv.handle == 0u) {
      reshade::log::message(reshade::log::level::warning, "No RTV.");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
  }

  s << ", rtv: " << reinterpret_cast<void*>(rtv.handle);

  reshade::api::render_pass_render_target_desc render_target_desc = {.view = rtv};
  cmd_list->begin_render_pass(1, &render_target_desc, nullptr);

  if (data.swap_chain_proxy_pipeline.handle == 0) {
    reshade::log::message(reshade::log::level::warning, "No pipeline handle. Creating...");
    data.swap_chain_proxy_pipeline = renodx::utils::pipeline::CreateRenderPipeline(
        device,
        data.swap_chain_proxy_layout,
        {
            {reshade::api::pipeline_subobject_type::vertex_shader, data.swap_chain_proxy_vertex_shader},
            {reshade::api::pipeline_subobject_type::pixel_shader, data.swap_chain_proxy_pixel_shader},
        },
        target_format);
    if (data.swap_chain_proxy_pipeline == 0u) {
      reshade::log::message(reshade::log::level::error, "No pipeline handle. Creating failed.");
      cmd_list->copy_resource(swapchain_clone, current_back_buffer);
      return;
    }
  }
  s << ", pipeline: " << reinterpret_cast<void*>(data.swap_chain_proxy_pipeline.handle);
  cmd_list->bind_pipeline(reshade::api::pipeline_stage::all_graphics, data.swap_chain_proxy_pipeline);
  size_t param_index = -1;

  // cmd_list->barrier(swapchain_clone, reshade::api::resource_usage::general, reshade::api::resource_usage::shader_resource);

  cmd_list->push_descriptors(
      reshade::api::shader_stage::all_graphics,
      data.swap_chain_proxy_layout,
      0,
      {
          .table = {},
          .binding = 0,
          .array_offset = 0,
          .count = 1,
          .type = reshade::api::descriptor_type::sampler,
          .descriptors = &data.swap_chain_proxy_sampler,
      });
  cmd_list->push_descriptors(
      reshade::api::shader_stage::all_graphics,
      data.swap_chain_proxy_layout,
      1,
      {
          .table = {},
          .binding = 0,
          .array_offset = 0,
          .count = 1,
          .type = reshade::api::descriptor_type::texture_shader_resource_view,
          .descriptors = &srv,
      });
  if (shader_injection_size != 0u) {
    const std::shared_lock lock(renodx::utils::mutex::global_mutex);
    cmd_list->push_constants(
        reshade::api::shader_stage::all_graphics,  // Used by reshade to specify graphics or compute
        data.swap_chain_proxy_layout,
        2,
        0,
        shader_injection_size,
        shader_injection);
  }

  auto clone_desc = device->get_resource_desc(swapchain_clone);
  const reshade::api::viewport viewport = {
      .x = 0.0f,
      .y = 0.0f,
      .width = static_cast<float>(clone_desc.texture.width),
      .height = static_cast<float>(clone_desc.texture.height),
      .min_depth = 0.0f,
      .max_depth = 1.0f,
  };

  cmd_list->bind_viewports(0, 1, &viewport);
  const reshade::api::rect scissor_rect = {
      .left = 0,
      .top = 0,
      .right = static_cast<int32_t>(clone_desc.texture.width),
      .bottom = static_cast<int32_t>(clone_desc.texture.height),
  };
  cmd_list->bind_scissor_rects(0, 1, &scissor_rect);
  cmd_list->draw(3, 1, 0, 0);
  cmd_list->end_render_pass();
  if (data.swap_chain_rtvs.empty()) {
    // RTV may not actually be new, but reference to previous one
    device->destroy_resource_view(rtv);
    data.swap_chain_proxy_rtvs.erase(current_back_buffer.handle);
  }
  queue->flush_immediate_command_list();

  if (previous_state.has_value()) {
    // Don't restore RTVs for now (crashes DX11)
    previous_state->render_targets.clear();
    previous_state->Apply(cmd_list);
  }

#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
}

static void SetUseHDR10(bool value = true) {
  if (value) {
    target_format = reshade::api::format::r10g10b10a2_unorm;
    target_color_space = reshade::api::color_space::hdr10_st2084;
  } else {
    target_format = reshade::api::format::r16g16b16a16_float;
    target_color_space = reshade::api::color_space::extended_srgb_linear;
  }
}

static void SetUpgradeResourceViews(bool value = true) {
  upgrade_resource_views = value;
}

// Hooks

static void OnInitDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::swapchain::OnInitDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  auto& data = device->create_private_data<DeviceData>();
  data.prevent_full_screen = prevent_full_screen;
  data.swap_chain_proxy_vertex_shader = swap_chain_proxy_vertex_shader;
  data.swap_chain_proxy_pixel_shader = swap_chain_proxy_pixel_shader;
  data.expected_constant_buffer_index = expected_constant_buffer_index;
  data.expected_constant_buffer_space = expected_constant_buffer_space;

  if (device->get_api() == reshade::api::device_api::vulkan) {
    is_vulkan = true;
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  std::stringstream s;
  s << "mods::swapchain::OnDestroyDevice(";
  s << reinterpret_cast<void*>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  auto& data = device->get_private_data<DeviceData>();
  if (data.swap_chain_proxy_sampler.handle != 0u) {
    device->destroy_sampler(data.swap_chain_proxy_sampler);
  }
  device->destroy_private_data<DeviceData>();
}

static void OnInitCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->create_private_data<CommandListData>();
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<CommandListData>();
}

// Before CreatePipelineState
static bool OnCreateSwapchain(reshade::api::swapchain_desc& desc, void* hwnd) {
  auto old_format = desc.back_buffer.texture.format;
  auto old_present_mode = desc.present_mode;
  auto old_present_flags = desc.present_flags;
  auto old_buffer_count = desc.back_buffer_count;

  if (!use_resize_buffer) {
    desc.back_buffer.texture.format = target_format;

    if (desc.back_buffer_count == 1) {
      // 0 is only for resize, so if game uses more than 2 buffers, that will be retained
      desc.back_buffer_count = 2;
    }
  }

  if (!is_vulkan) {
    switch (desc.present_mode) {
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_SEQUENTIAL):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL);
        break;
      case static_cast<uint32_t>(DXGI_SWAP_EFFECT_DISCARD):
        desc.present_mode = static_cast<uint32_t>(DXGI_SWAP_EFFECT_FLIP_DISCARD);
        break;
    }

    if (!use_resize_buffer) {
      if (prevent_full_screen) {
        desc.present_flags &= ~DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
      }
      desc.present_flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;
    }
  }

  std::stringstream s;
  s << "mods::swapchain::OnCreateSwapchain(";
  s << "swap: " << old_format << " => " << desc.back_buffer.texture.format;
  s << ", present mode:";
  s << "0x" << std::hex << old_present_mode << std::dec;
  s << " => ";
  s << "0x" << std::hex << desc.present_mode << std::dec;
  s << ", present flag:";
  s << "0x" << std::hex << old_present_flags << std::dec;
  s << " => ";
  s << "0x" << std::hex << desc.present_flags << std::dec;
  s << ", buffers:";
  s << old_buffer_count;
  s << " => ";
  s << desc.back_buffer_count;
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());

  return (old_format != desc.back_buffer.texture.format)
         || (old_present_mode != desc.present_mode)
         || (old_present_flags != desc.present_flags);
}

static void OnPresentForResizeBuffer(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  if (use_resize_buffer_on_demand && !use_resize_buffer_on_present) return;
  reshade::unregister_event<reshade::addon_event::present>(OnPresentForResizeBuffer);
  renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return;
  const std::unique_lock lock(data.mutex);

  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnInitSwapchain(reset resource upgrade)");
  data.resource_upgrade_finished = false;
  const uint32_t len = swap_chain_upgrade_targets.size();
  // Reset
  for (uint32_t i = 0; i < len; i++) {
    renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
    if (target->ignore_reset) continue;
    target->counted = 0;
    target->completed = false;
  }

  auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
  CheckSwapchainSize(swapchain, device_back_buffer_desc);

  if (UsingSwapchainProxy()) {
    SetupSwapchainProxy(swapchain, device, &data);
  }

  if (use_resize_buffer && device_back_buffer_desc.texture.format != target_format) {
    if (use_resize_buffer_on_demand || use_resize_buffer_on_present) {
      reshade::register_event<reshade::addon_event::present>(OnPresentForResizeBuffer);
    } else if (!use_resize_buffer_on_set_full_screen) {
      renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
    }
    return;
  }
  renodx::utils::swapchain::ChangeColorSpace(swapchain, target_color_space);
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain) {
  auto* device = swapchain->get_device();
  auto& data = device->get_private_data<DeviceData>();
  if (std::addressof(data) == nullptr) return;

  const size_t back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    auto buffer = swapchain->get_back_buffer(index);

    data.resource_clone_enabled.erase(buffer.handle);
    data.resource_clone_targets.erase(buffer.handle);
    data.resource_initial_state.erase(buffer.handle);
    if (auto pair = data.resource_clones.find(buffer.handle);
        pair != data.resource_clones.end()) {
      auto clone_handle = pair->second;

      if (auto srv_pair = data.swap_chain_proxy_srvs.find(clone_handle);
          srv_pair != data.swap_chain_proxy_srvs.end()) {
        device->destroy_resource_view({srv_pair->second});
        data.swap_chain_proxy_srvs.erase(srv_pair);
      }

      device->destroy_resource({clone_handle});
      data.resource_clones.erase(pair);
    }
    if (auto rtv_pair = data.swap_chain_proxy_rtvs.find(buffer.handle);
        rtv_pair != data.swap_chain_proxy_rtvs.end()) {
      device->destroy_resource_view({rtv_pair->second});
      data.swap_chain_proxy_rtvs.erase(rtv_pair);
    }
  }

  device->destroy_sampler(data.swap_chain_proxy_sampler);
  device->destroy_pipeline_layout(data.swap_chain_proxy_layout);
  device->destroy_pipeline(data.swap_chain_proxy_pipeline);
  data.swap_chain_proxy_sampler = {0};
  data.swap_chain_proxy_layout = {0};
  data.swap_chain_proxy_pipeline = {0};
}

static bool OnCreateResource(
    reshade::api::device* device,
    reshade::api::resource_desc& desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state) {
  if (device == nullptr) {
    std::stringstream s;
    s << "mods::swapchain::OnCreateResource(Empty device)";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }
  switch (desc.type) {
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnCreateResource(Unknown resource type)");
    default:
      return false;
  }

  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);
  if (private_data.resource_upgrade_finished) return false;

  auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
  if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnCreateResource(No swapchain yet: ";
    s << reinterpret_cast<void*>(device);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    return false;
  }

  const uint32_t len = swap_chain_upgrade_targets.size();

  const float resource_tag = -1;

  SwapChainUpgradeTarget* found_target = nullptr;
  bool all_completed = true;
  bool found_exact = false;
  for (uint32_t i = 0; i < len; i++) {
    renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
    std::stringstream s;
    if (target->completed) continue;
    if (
        !target->use_resource_view_cloning
        && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
      s << "mods::swapchain::OnCreateResource(counting target";
      s << ", format: " << target->old_format;
      s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
      s << ", index: " << target->index;
      s << ", counted: " << target->counted;
      // s << ", data: " << reinterpret_cast<void*>(initial_data);
      s << ") [" << i << "/" << len << "]";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());

      target->counted++;
      if (target->index != -1 && (target->index + 1) == target->counted) {
        found_target = target;
        target->completed = true;
        found_exact = true;
        continue;
      }
      if (target->index == -1) {
        if (!found_exact) {
          found_target = target;
        }
        all_completed = false;
        continue;
      }
    }
    all_completed = false;
  }

  if (found_target == nullptr) return false;

  if (all_completed) {
    private_data.resource_upgrade_finished = true;
  }

  std::stringstream s;
  s << "mods::swapchain::OnCreateResource(Upgrading";
  s << ", flags: 0x" << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: 0x" << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", format: " << desc.texture.format << " => " << found_target->new_format;
  s << ", width: " << desc.texture.width;
  s << ", height: " << desc.texture.height;
  s << ", usage: " << desc.usage << "(" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec << ")";
  s << ", complete: " << all_completed;
  reshade::api::resource original_resource = {0};

  if (initial_data != nullptr) {
    // Create a temporary texture to store the texture data instead
    device->create_resource(
        desc,
        initial_data,
        initial_state,
        &original_resource);
    s << ", fallback: " << reinterpret_cast<void*>(original_resource.handle);
    // Wipe initial data
    initial_data = nullptr;
  }

  s << ")";
  reshade::log::message(
      desc.texture.format == reshade::api::format::unknown
          ? reshade::log::level::warning
          : reshade::log::level::info,
      s.str().c_str());

  desc.texture.format = found_target->new_format;

  if (found_target->new_dimensions.width == SwapChainUpgradeTarget::BACK_BUFFER) {
    desc.texture.width = device_back_buffer_desc.texture.width;
  } else if (found_target->new_dimensions.width >= 0) {
    desc.texture.width = found_target->new_dimensions.width;
  }

  if (found_target->new_dimensions.height == SwapChainUpgradeTarget::BACK_BUFFER) {
    desc.texture.height = device_back_buffer_desc.texture.height;
  } else if (found_target->new_dimensions.height >= 0) {
    desc.texture.height = found_target->new_dimensions.height;
  }

  if (found_target->new_dimensions.depth >= 0) {
    desc.texture.depth_or_layers = found_target->new_dimensions.depth;
  }

  desc.usage = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(desc.usage)
      | (found_target->usage_set & ~found_target->usage_unset));

  private_data.original_resource = original_resource;
  private_data.applied_target = found_target;
  return true;
}

static void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (device == nullptr) {
    std::stringstream s;
    s << "mods::swapchain::OnInitResource(Empty device)";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return;
  }

  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);

  switch (desc.type) {
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnInitResource(Unknown resource type)");
    default:
      if (private_data.applied_target != nullptr) {
        reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnInitResource(Modified??)");
        private_data.applied_target = nullptr;
      }
      return;
  }

  bool changed = false;
  std::stringstream s;
  s << "mods::swapchain::OnInitResource(tracking ";
  s << reinterpret_cast<void*>(resource.handle);
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
  s << ", width: " << desc.texture.width;
  s << ", height: " << desc.texture.height;
  s << ", initial_data: " << (initial_data == nullptr ? "false" : "true");
  s << ", format: " << desc.texture.format;
  if (private_data.applied_target != nullptr) {
    changed = true;
    if (private_data.applied_target->resource_tag != -1) {
      s << ", tag: " << private_data.applied_target->resource_tag;
      renodx::utils::resource::SetResourceTag(device, resource, private_data.applied_target->resource_tag);
    }
    private_data.resource_upgrade_targets[resource.handle] = private_data.applied_target;
    private_data.applied_target = nullptr;

    private_data.upgraded_resources[resource.handle] = private_data.original_resource;
    private_data.upgraded_resource_formats[resource.handle] = desc.texture.format;
    if (private_data.original_resource.handle != 0u) {
      s << ", fallback: " << reinterpret_cast<void*>(private_data.original_resource.handle);
      private_data.original_resource = {0};
      s << "(orphaned)";
    } else {
      s << ", fallback: (none)";
    }
  } else if (use_resource_cloning) {
    if (private_data.resource_upgrade_finished) return;
    auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
    if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::OnInitResource(No swapchain yet: ";
      s << reinterpret_cast<void*>(device);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      return;
    }

    const uint32_t len = swap_chain_upgrade_targets.size();

    renodx::mods::swapchain::SwapChainUpgradeTarget* found_target = nullptr;
    bool all_completed = true;
    bool found_exact = false;
    for (uint32_t i = 0; i < len; i++) {
      renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
      std::stringstream s;
      if (target->completed) continue;
      if (
          target->use_resource_view_cloning
          && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
        s << "mods::swapchain::OnInitResource(counting target";
        s << ", format: " << target->old_format;
        s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
        s << ", index: " << target->index;
        s << ", counted: " << target->counted;
        s << ") [" << i << "/" << len << "]";
#ifdef DEBUG_LEVEL_0
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        target->counted++;
        if (target->index != -1 && (target->index + 1) == target->counted) {
          found_target = target;
          target->completed = true;
          found_exact = true;
          continue;
        }
        if (target->index == -1) {
          if (!found_exact) {
            found_target = target;
          }
          all_completed = false;
          continue;
        }
      }
      all_completed = false;
    }
    if (found_target == nullptr) return;
    if (all_completed) {
#ifdef DEBUG_LEVEL_0
      reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnInitResource(All resource cloning completed)");
#endif
      private_data.resource_upgrade_finished = true;
    }

    // On the fly generation
    private_data.resource_clone_targets[resource.handle] = found_target;
    private_data.resource_initial_state[resource.handle] = initial_state;
    if (found_target->resource_tag != -1) {
      renodx::utils::resource::SetResourceTag(device, resource, found_target->resource_tag);
    }
    if (!found_target->use_resource_view_hot_swap) {
      private_data.resource_clone_enabled.insert(resource.handle);
      {
        std::stringstream s;
        s << "mods::swapchain::OnInitResource(Marking resource for cloning: ";
        s << reinterpret_cast<void*>(resource.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }
    }
    changed = true;
    s << ", flagged: true";
  } else {
    // Nothing to do
    return;
  }

  s << ")";

#ifdef DEBUG_LEVEL_1
  changed = true;
#endif

  if (changed) {
    reshade::log::message(
        desc.texture.format == reshade::api::format::unknown
            ? reshade::log::level::warning
            : reshade::log::level::info,
        s.str().c_str());
  }
}

static void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  renodx::utils::resource::RemoveResourceTag(device, resource);

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "mods::swapchain::OnDestroyResource(destroy resource";
    s << ", resource: " << reinterpret_cast<void*>(resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  data.resource_upgrade_targets.erase(resource.handle);

  if (
      auto pair = data.upgraded_resources.find(resource.handle);
      pair != data.upgraded_resources.end()) {
    device->destroy_resource(pair->second);
    data.upgraded_resources.erase(pair);
    data.upgraded_resource_formats.erase(resource.handle);
  }

  if (use_resource_cloning) {
    data.resource_clone_enabled.erase(resource.handle);
    data.resource_clone_targets.erase(resource.handle);
    if (
        auto pair = data.resource_clones.find(resource.handle);
        pair != data.resource_clones.end()) {
      auto clone_resource = reshade::api::resource{pair->second};
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::OnDestroyResource(destroy cloned resource and views";
      s << ", resource: " << reinterpret_cast<void*>(resource.handle);
      s << ", clone: " << reinterpret_cast<void*>(clone_resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

      device->destroy_resource(clone_resource);
      data.resource_clones.erase(resource.handle);
    }
  }
}

static bool OnCopyBufferToTexture(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint64_t source_offset,
    uint32_t row_length,
    uint32_t slice_height,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  auto* device = cmd_list->get_device();
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);

  auto source_pair = data.upgraded_resource_formats.find(source.handle);
  const bool source_upgraded = source_pair != data.upgraded_resource_formats.end();

  auto destination_pair = data.upgraded_resource_formats.find(dest.handle);
  const bool dest_upgraded = destination_pair != data.upgraded_resource_formats.end();

  const auto source_clone = GetResourceClone(device, &data, source);
  const auto dest_clone = GetResourceClone(device, &data, dest);

  if (!source_upgraded && !dest_upgraded
      && (source_clone.handle == 0u) && (dest_clone.handle == 0u)) return false;

  auto original_source_desc = device->get_resource_desc(source);
  auto original_dest_desc = device->get_resource_desc(dest);
  auto source_desc = original_source_desc;
  auto dest_desc = original_dest_desc;

  if (original_source_desc.type != reshade::api::resource_type::buffer) {
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Unexpected source type: ";
    s << original_source_desc.type;
    s << ", resource: " << reinterpret_cast<void*>(source.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return true;
  }

  if (original_dest_desc.type != reshade::api::resource_type::texture_2d && original_dest_desc.type != reshade::api::resource_type::texture_3d) {
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Unexpected dest type: ";
    s << original_dest_desc.type;
    s << ", resource: " << reinterpret_cast<void*>(dest.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return true;
  }

  if (source_clone.handle == 0u) {
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Unexpected source clone: ";
    s << reinterpret_cast<void*>(dest.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return true;
  }

  if (dest_clone.handle == 0u) {
    reshade::log::message(reshade::log::level::warning, "mods::swapchain::OnCopyBufferToTexture(Unreachable?)");
  }
  dest_desc = device->get_resource_desc(source_clone);

  if (original_dest_desc.texture.format == dest_desc.texture.format) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnCopyBufferToTexture(Redirected to clone: ";
    s << reinterpret_cast<void*>(dest.handle);
    s << " => " << reinterpret_cast<void*>(dest_clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->copy_buffer_to_texture(source, source_offset, row_length, slice_height, dest_clone, dest_subresource);

    return true;
    // remap to other
  }
  // Mismatched, copy to original and blit?
  cmd_list->copy_buffer_to_texture(source, source_offset, row_length, slice_height, dest, dest_subresource);

  std::stringstream s;
  s << "mods::swapchain::OnCopyBufferToTexture(mismatched ";
  s << reinterpret_cast<void*>(source.handle);
  s << "[" << source_offset << "]";
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << "[" << dest_subresource << "]";
  s << " (" << dest_desc.texture.format << ")";
  if (dest_box != nullptr) {
    s << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";

  reshade::log::message(reshade::log::level::warning, s.str().c_str());

  if (device->get_api() == reshade::api::device_api::vulkan) {
    // perform blit
    cmd_list->copy_texture_region(dest, dest_subresource, dest_box, dest_clone, dest_subresource, dest_box);
    return true;
  } else {
    // Perform DirectX blit
    return true;
  }

  return true;
}

static bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  if (resource.handle == 0u) return false;
  bool expected = false;
  bool found_upgrade = false;

  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);

  if (!upgrade_unknown_resource_views && desc.format == reshade::api::format::unknown) {
    return false;
  }
  reshade::api::resource_view_desc new_desc = desc;
  const reshade::api::resource_desc resource_desc = device->get_resource_desc(resource);
  bool is_back_buffer = renodx::utils::swapchain::IsBackBuffer(device, resource);
  if (upgrade_resource_views && is_back_buffer) {
    new_desc.format = target_format;
    expected = true;
    found_upgrade = true;
  } else if (auto pair = private_data.resource_upgrade_targets.find(resource.handle);
             pair != private_data.resource_upgrade_targets.end()) {
    auto* target = pair->second;
    if (auto pair2 = target->view_upgrades.find({usage_type, desc.format});
        pair2 != target->view_upgrades.end()) {
      new_desc.format = pair2->second;
      found_upgrade = true;
    }
    if (!found_upgrade) {
      std::stringstream s;
      s << "mods::swapchain::OnCreateResourceView(";
      s << "unexpected case(" << desc.format << ")";
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
    expected = true;
  } else if (resource_desc.texture.format == target_format || resource_desc.texture.format == reshade::api::format::r16g16b16a16_typeless) {
    switch (new_desc.format) {
      case reshade::api::format::r8g8b8a8_typeless:
      case reshade::api::format::b8g8r8a8_typeless:
      case reshade::api::format::r10g10b10a2_typeless:
      case reshade::api::format::r16g16b16a16_typeless:
        new_desc.format = reshade::api::format::r16g16b16a16_typeless;
        break;
      case reshade::api::format::r8g8b8a8_unorm:
      case reshade::api::format::b8g8r8a8_unorm:
        new_desc.format = target_format;
        break;
      case reshade::api::format::r8g8b8a8_unorm_srgb:
      case reshade::api::format::b8g8r8a8_unorm_srgb:
        // Should upgrade shader
        new_desc.format = target_format;
        break;
      case reshade::api::format::b10g10r10a2_unorm:
      case reshade::api::format::r10g10b10a2_unorm:
        new_desc.format = target_format;
        break;
      case reshade::api::format::r16g16b16a16_float:
        break;
      default: {
        std::stringstream s;
        s << "mods::swapchain::OnCreateResourceView(";
        s << "unexpected case(" << desc.format << ")";
        s << ")";
        reshade::log::message(reshade::log::level::warning, s.str().c_str());
        break;
      }
    }
  } else {
    return false;
  }

  const bool changed = (desc.format != new_desc.format);
  std::stringstream s;
  s << "mods::swapchain::OnCreateResourceView(" << (changed ? "upgrading" : "logging");
  s << ", found_upgrade: " << (found_upgrade ? "true" : "false");
  s << ", expected: " << (expected ? "true" : "false");
  s << ", view type: " << desc.type;
  s << ", view format: " << desc.format << " => " << new_desc.format;
  s << ", resource: " << reinterpret_cast<void*>(resource.handle);
  s << ", resource width: " << resource_desc.texture.width;
  s << ", resource height: " << resource_desc.texture.height;
  s << ", resource format: " << resource_desc.texture.format;
  s << ", resource usage: " << usage_type;
  s << ")";

  if (!changed) {
#ifdef DEBUG_LEVEL_1
    reshade::log::message(
        desc.format == reshade::api::format::unknown
            ? reshade::log::level::warning
            : reshade::log::level::info,
        s.str().c_str());
#endif
    if (!is_back_buffer) return false;
    if (!UsingSwapchainProxy()) return false;
    if (swap_chain_proxy_format == target_format) return false;
    // Continue to creating a resource clone
  }

  if (use_resource_cloning) {
    if (auto pair = private_data.resource_clone_targets.find(resource.handle);
        pair != private_data.resource_clone_targets.end()) {
      auto* upgrade_info = pair->second;
      if (!upgrade_info->use_resource_view_cloning_and_upgrade) {
        return false;
      }
      // Upgrade on init instead (allows resource view handle reuse)
      // Cloning with upgrade
    }
  }
  if (!changed) return false;

  reshade::log::message(
      desc.format == reshade::api::format::unknown
          ? reshade::log::level::warning
          : reshade::log::level::info,
      s.str().c_str());
  desc.format = new_desc.format;
  private_data.upgraded_resource_view = true;
  return true;
}

static void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (resource.handle == 0u) return;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnInitResourceView()");
#endif
  auto& private_data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(private_data.mutex);

  ReleaseResourceView(device, private_data, view);
  if (use_resource_cloning) {
    if (auto target_pair = private_data.resource_clone_targets.find(resource.handle);
        target_pair != private_data.resource_clone_targets.end()) {
      private_data.resource_view_clone_targets[view.handle] = target_pair->second;
      private_data.resource_view_usage[view.handle] = usage_type;
    }
  }

  if (utils::swapchain::IsBackBuffer(device, resource)) {
    if ((usage_type & reshade::api::resource_usage::render_target) != 0u) {
      private_data.swap_chain_rtvs[resource.handle] = view;
    }
  }

  if (private_data.upgraded_resource_view) {
    private_data.upgraded_resource_view = false;
    if (private_data.original_resource_view.handle != 0u) {
      private_data.upgraded_resource_views[view.handle] = private_data.original_resource_view;
      private_data.original_resource_view = {0};
    }
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnInitResourceView(done)");
#endif
}

static void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  ReleaseResourceView(device, data, view);
}

static bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  auto* device = cmd_list->get_device();
  auto source_desc = device->get_resource_desc(source);
  auto dest_desc = device->get_resource_desc(dest);
  if (source_desc.type == reshade::api::resource_type::texture_2d
      || source_desc.type == reshade::api::resource_type::texture_3d) {
    if (dest_desc.type == source_desc.type) {
      if (use_resource_cloning) {
        auto& data = device->get_private_data<DeviceData>();
        const std::unique_lock lock(data.mutex);

        auto source_clone = GetResourceClone(device, &data, source);
        auto dest_clone = GetResourceClone(device, &data, dest);

        if (source_clone.handle != 0u) {
          source_desc = device->get_resource_desc(source_clone);
          source = source_clone;
        }
        if (dest_clone.handle != 0u) {
          dest_desc = device->get_resource_desc(dest_clone);
          dest = dest_clone;
        }
      }

      if (source_desc.texture.format == dest_desc.texture.format) {
        cmd_list->copy_resource(source, dest);
        return true;
      }
#ifdef DEBUG_LEVEL_2
      reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnCopyResource(prevent resource copy)");
#endif
      // Mismatched (don't copy);
      return true;
    }
  }
  return false;
}

// Create DescriptorTables with RSVs
static bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (count == 0u) return false;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnUpdateDescriptorTables()");
#endif
  reshade::api::descriptor_table_update* new_updates = nullptr;
  bool changed = false;
  bool active = false;

  for (uint32_t i = 0; i < count; i++) {
    const auto& update = updates[i];
    if (update.table.handle == 0u) continue;
    for (uint32_t j = 0; j < update.count; j++) {
      switch (update.type) {
        case reshade::api::descriptor_type::sampler_with_resource_view: {
          auto item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
          auto resource_view = item.view;
          auto resource_view_clone = GetResourceViewClone(device, resource_view);
          if (resource_view_clone.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "mods::swapchain::OnUpdateDescriptorTables(found clonable: ";
          s << reinterpret_cast<void*>(resource_view_clone.handle);
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

          if (!changed) {
            new_updates = renodx::utils::descriptor::CloneDescriptorTableUpdates(updates, count);
          }

          // NOLINTNEXTLINE(google-readability-casting)
          ((reshade::api::sampler_with_resource_view*)(new_updates[i].descriptors))[j].view = resource_view_clone;
          changed = true;
          // if (data.enabled_cloned_resources.contains(new_resource.handle)) {
          //   active = true;
          // }
          break;
        }
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::shader_resource_view:

        case reshade::api::descriptor_type::unordered_access_view: {
          auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          auto resource_view_clone = GetResourceViewClone(device, resource_view);

          if (resource_view_clone.handle == 0) continue;

#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "mods::swapchain::OnUpdateDescriptorTables(found clonable: ";
          s << reinterpret_cast<void*>(resource_view_clone.handle);
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

          if (!changed) {
            new_updates = renodx::utils::descriptor::CloneDescriptorTableUpdates(updates, count);
          }

          // NOLINTNEXTLINE(google-readability-casting)
          ((reshade::api::resource_view*)(new_updates[i].descriptors))[j] = resource_view_clone;
          changed = true;
          // if (data.enabled_cloned_resources.contains(new_resource.handle)) {
          //   active = true;
          // }
          break;
        }
        default:
          break;
      }
    }
  }

  if (changed) {
    device->update_descriptor_tables(count, new_updates);
    // free(new_updates);

  } else {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnUpdateDescriptorTables(no clonable.)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnUpdateDescriptorTables(done)");
#endif
  return false;
}

static bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (!use_resource_cloning) return false;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnCopyDescriptorTables()");
#endif
  for (uint32_t i = 0; i < count; i++) {
    const auto& copy = copies[i];
    for (uint32_t j = 0; j < copy.count; j++) {
      auto& data = device->get_private_data<DeviceData>();
      const std::unique_lock lock(data.mutex);

      reshade::api::descriptor_heap source_heap = {0};
      uint32_t source_base_offset = 0;
      device->get_descriptor_heap_offset(copy.source_table, copy.source_binding + j, copy.source_array_offset, &source_heap, &source_base_offset);
      reshade::api::descriptor_heap dest_heap = {0};
      uint32_t dest_base_offset = 0;
      device->get_descriptor_heap_offset(copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &dest_heap, &dest_base_offset);

      bool erase = false;
      if (auto pair = data.heap_descriptor_infos.find(source_heap.handle); pair != data.heap_descriptor_infos.end()) {
        auto& source_map = pair->second;
        if (auto pair2 = source_map.find(source_base_offset); pair2 != source_map.end()) {
          if (dest_heap.handle == source_heap.handle) {
            source_map[dest_base_offset] = source_map[source_base_offset];
          } else {
            if (auto pair3 = data.heap_descriptor_infos.find(dest_heap.handle); pair3 != data.heap_descriptor_infos.end()) {
              auto& dest_map = pair3->second;
              dest_map[dest_base_offset] = source_map[source_base_offset];
            } else {
              data.heap_descriptor_infos[dest_heap.handle] = {{
                  dest_base_offset,
                  source_map[source_base_offset],
              }};
            }
          }
#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "mods::swapchain::OnCopyDescriptorTables(cloning heap: ";
          s << reinterpret_cast<void*>(source_heap.handle);
          s << "[" << source_base_offset << "]";
          s << " => ";
          s << reinterpret_cast<void*>(dest_heap.handle);
          s << "[" << dest_base_offset << "]";
          s << ", table: " << reinterpret_cast<void*>(source_map[source_base_offset]->replacement_descriptor_handle);
          s << ", size: " << source_map[source_base_offset]->updates.size();
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        } else {
          erase = true;
        }
      } else {
        erase = true;
      }
      if (erase) {
        if (auto pair3 = data.heap_descriptor_infos.find(dest_heap.handle); pair3 != data.heap_descriptor_infos.end()) {
          auto& dest_map = pair3->second;
          dest_map.erase(dest_base_offset);
        }
      }
    }
  }

#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "copy_descriptor_tables(done)");
#endif

  return false;
}

static void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if (count == 0u) return;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnBindDescriptorTables()");
#endif
  auto* device = cmd_list->get_device();
  reshade::api::descriptor_table* new_tables = nullptr;
  bool built_new_tables = false;
  bool active = false;

  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  reshade::api::descriptor_heap heap = {0};
  uint32_t base_offset = 0;
  for (uint32_t i = 0; i < count; ++i) {
    device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);

    HeapDescriptorInfo* info = nullptr;
    bool found_info = false;
    if (auto pair = data.heap_descriptor_infos.find(heap.handle); pair != data.heap_descriptor_infos.end()) {
      auto& map = pair->second;
      if (auto pair2 = map.find(base_offset); pair2 != map.end()) {
        info = pair2->second;
        found_info = true;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(found heap info: ";
        s << reinterpret_cast<void*>(heap.handle);
        s << "[" << base_offset << "]";
        s << ", handle: " << reinterpret_cast<void*>(info->replacement_descriptor_handle);
        s << ", size: " << info->updates.size();
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      }
    }
    if (found_info) {
      if (info->replacement_descriptor_handle == 0) {
        reshade::api::descriptor_table new_table = {0};
        bool allocated = device->allocate_descriptor_table(layout, first + i, &new_table);
        if (new_table.handle == 0) {
          std::stringstream s;
          s << "mods::swapchain::OnBindDescriptorTables(could not allocate new table: ";
          s << reinterpret_cast<void*>(tables[i].handle);
          s << " via ";
          s << reinterpret_cast<void*>(layout.handle);
          s << "[" << first + i << "]";
          s << ", allocated: " << (allocated ? "true" : "false");
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());

          allocated = device->allocate_descriptor_table({0}, 0u, &new_table);
          if (new_table.handle == 0) {
            std::stringstream s;
            s << "mods::swapchain::OnBindDescriptorTables(could not allocate new table (2): ";
            s << reinterpret_cast<void*>(tables[i].handle);
            s << " via ";
            s << reinterpret_cast<void*>(0);
            s << "[" << first + i << "]";
            s << ", allocated: " << (allocated ? "true" : "false");
            s << ")";
            reshade::log::message(reshade::log::level::error, s.str().c_str());
            continue;
          }
          info->replacement_descriptor_handle = new_table.handle;
        }
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(allocate new table pre-bind: ";
        s << reinterpret_cast<void*>(tables[i].handle);
        s << " => ";
        s << reinterpret_cast<void*>(new_table.handle);
        s << " via ";
        s << reinterpret_cast<void*>(layout.handle);
        s << "[" << first + i << "]";
        s << ", updates: " << reinterpret_cast<void*>(&info->updates);
        s << " (" << info->updates.size() << ")";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        auto* update_data = info->updates.data();
        auto len = info->updates.size();
        for (uint32_t j = 0; j < len; ++j) {
          auto& item = update_data[j];
          item.table = {new_table.handle};
        }
#ifdef DEBUG_LEVEL_1
        std::stringstream s2;
        s2 << "mods::swapchain::OnBindDescriptorTables(updated created table: ";
        s2 << reinterpret_cast<void*>(&info->updates);
        s2 << ", size" << len;
        s2 << ")";
        reshade::log::message(reshade::log::level::debug, s2.str().c_str());
#endif
        device->update_descriptor_tables(len, update_data);
        info->replacement_descriptor_handle = new_table.handle;
      } else {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(no base_offset: ";
        s << reinterpret_cast<void*>(heap.handle) << "[" << base_offset << "]";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      }

      if (info->replacement_descriptor_handle != 0) {
        if (!built_new_tables) {
          const size_t size = count * sizeof(reshade::api::descriptor_table);
          new_tables = static_cast<reshade::api::descriptor_table*>(malloc(size));
          memcpy(new_tables, tables, size);
          built_new_tables = true;
        }
        new_tables[i].handle = info->replacement_descriptor_handle;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnBindDescriptorTables(replace bind: ";
        s << reinterpret_cast<void*>(tables[i].handle);
        s << " => ";
        s << reinterpret_cast<void*>(new_tables[i].handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
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
    s << "mods::swapchain::OnBindDescriptorTables(apply bind)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->bind_descriptor_tables(stages, layout, first, count, new_tables);
  } else if (built_new_tables) {
    auto& cmd_data = cmd_list->get_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnBindDescriptorTables(storing unbound descriptor)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_data.unbound_descriptors.push_back({
        .stages = stages,
        .layout = layout,
        .first = first,
        .count = count,
        .tables = {new_tables[0], new_tables[count - 1]},
    });
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnBindDescriptorTables(done)");
#endif
}

// Set DescriptorTables RSVs
static void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (update.count == 0u) return;

  reshade::api::descriptor_table_update new_update;

#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnPushDescriptors()");
#endif

  bool changed = false;
  bool active = false;

  for (uint32_t i = 0; i < update.count; i++) {
    // if (!update.table.handle) continue;
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        auto resource_view = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i].view;
        if (resource_view.handle == 0) continue;
        auto clone = GetResourceViewClone(cmd_list, resource_view);
        if (clone.handle == 0) continue;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnPushDescriptors(found clonable: ";
        s << reinterpret_cast<void*>(clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (!changed) {
          new_update = renodx::utils::descriptor::CloneDescriptorTableUpdates(&update, 1)[0];
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::sampler_with_resource_view*)(new_update.descriptors))[i].view = clone;
        changed = true;
        break;
      }
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::shader_resource_view:
      case reshade::api::descriptor_type::unordered_access_view:        {
        auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
        if (resource_view.handle == 0) continue;
        auto clone = GetResourceViewClone(cmd_list, resource_view);
        if (clone.handle == 0) continue;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "mods::swapchain::OnPushDescriptors(found clonable: ";
        s << reinterpret_cast<void*>(clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (!changed) {
          new_update = renodx::utils::descriptor::CloneDescriptorTableUpdates(&update, 1)[0];
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::resource_view*)(new_update.descriptors))[i] = clone;
        changed = true;

        break;
      }
      default:
        break;
    }
  }

  if (changed || active) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnPushDescriptors(apply push)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->push_descriptors(stages, layout, layout_param, new_update);
  } else if (changed) {
    auto& cmd_data = cmd_list->get_private_data<CommandListData>();
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "mods::swapchain::OnPushDescriptors(storing unpushed descriptor)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_data.unpushed_updates.push_back({
        .stages = stages,
        .layout = layout,
        .layout_param = layout_param,
        .update = new_update,
    });
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "push_descriptors(done)");
#endif
}

// Set render target RSV
static void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (count == 0u) return;

  RewriteRenderTargets(cmd_list, count, rtvs, dsv);
}

static bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto clone = GetResourceViewClone(cmd_list, rtv);
  if (clone.handle != 0) {
    cmd_list->clear_render_target_view(clone, color, rect_count, rects);
  }
  return false;
}

static bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto clone = GetResourceViewClone(cmd_list, uav);
  if (clone.handle != 0) {
    auto desc = cmd_list->get_device()->get_resource_view_desc(clone);
    switch (desc.format) {
      case reshade::api::format::r16g16b16a16_float:
      case reshade::api::format::r11g11b10_float:    {
        float values_float[4] = {
            static_cast<float>(values[0]),
            static_cast<float>(values[1]),
            static_cast<float>(values[2]),
            static_cast<float>(values[3]),
        };
        // std::transform(values[0], values[3], values_float, [](uint32_t value) { return static_cast<float>(value); });
        cmd_list->clear_unordered_access_view_float(clone, values_float, rect_count, rects);
        break;
      }
      default:
        cmd_list->clear_unordered_access_view_uint(clone, values, rect_count, rects);
    }
  }
  return false;
}

static bool OnClearUnorderedAccessViewFloat(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const float values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  auto clone = GetResourceViewClone(cmd_list, uav);

  if (clone.handle != 0) {
    cmd_list->clear_unordered_access_view_float(clone, values, rect_count, rects);
  }
  return false;
}

static bool OnResolveTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    int32_t dest_x,
    int32_t dest_y,
    int32_t dest_z,
    reshade::api::format format) {
  auto* device = cmd_list->get_device();
  auto& data = device->get_private_data<DeviceData>();
  const std::shared_lock lock(data.mutex);
  auto source_pair = data.upgraded_resource_formats.find(source.handle);
  if (source_pair == data.upgraded_resource_formats.end()) return false;

  auto destination_pair = data.upgraded_resource_formats.find(dest.handle);
  if (destination_pair == data.upgraded_resource_formats.end()) return false;

  auto source_format = source_pair->second;
  auto destination_format = destination_pair->second;

  if (source_format != destination_format) return false;

  auto new_format = source_format;
  if (source_format == reshade::api::format::r16g16b16a16_typeless) {
    new_format = reshade::api::format::r16g16b16a16_float;
  }

  if (format == new_format) return false;

  cmd_list->resolve_texture_region(
      source, source_subresource, source_box,
      dest, dest_subresource, dest_x, dest_y, dest_z,
      new_format);
  return true;
}

static void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  if (count == 0u) return;
  auto* device = cmd_list->get_device();
  if (device == nullptr) return;
  auto& data = device->get_private_data<DeviceData>();
  const std::unique_lock lock(data.mutex);
  for (uint32_t i = 0; i < count; i++) {
    const auto& resource = resources[i];
    const auto& old_state = old_states[i];
    const auto& new_state = new_states[i];

    const auto clone = GetResourceClone(device, &data, resource);
    if (clone.handle != 0) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "mods::swapchain::OnBarrier(apply barrier clone: ";
      s << reinterpret_cast<void*>(resource.handle);
      s << " => ";
      s << reinterpret_cast<void*>(clone.handle);
      s << ", state: " << old_state << " => " << new_state;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      cmd_list->barrier(clone, old_state, new_state);
    }
  }
}

static bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  auto* device = cmd_list->get_device();
  auto source_desc = device->get_resource_desc(source);
  auto dest_desc = device->get_resource_desc(dest);
  if (source_desc.type != reshade::api::resource_type::texture_2d
      && source_desc.type != reshade::api::resource_type::texture_3d) return false;
  if (dest_desc.type != source_desc.type) return false;
  if (use_resource_cloning) {
    auto& data = device->get_private_data<DeviceData>();
    const std::unique_lock lock(data.mutex);

    auto source_clone = GetResourceClone(device, &data, source);
    auto dest_clone = GetResourceClone(device, &data, dest);

    if (source_clone.handle == 0u && dest_clone.handle == 0u) return false;

    if (source_clone.handle != 0u) {
      source_desc = device->get_resource_desc(source_clone);

      source = source_clone;
    }
    if (dest_clone.handle != 0u) {
      dest_desc = device->get_resource_desc(dest_clone);
      dest = dest_clone;
    }
  }

  if (source_desc.texture.format == dest_desc.texture.format) {
    cmd_list->copy_texture_region(source, source_subresource, source_box, dest, dest_subresource, dest_box, filter);
    return true;
  }
  // Mismatched (don't copy);

  std::stringstream s;
  s << "OnCopyTextureRegion";
  s << "(mismatched: " << reinterpret_cast<void*>(source.handle);
  s << "[" << source_subresource << "]";
  if (source_box != nullptr) {
    s << "(" << source_box->top << ", " << source_box->left << ", " << source_box->front << ")";
  }
  s << " (" << source_desc.texture.format << ")";
  s << " => " << reinterpret_cast<void*>(dest.handle);
  s << "[" << dest_subresource << "]";
  s << " (" << dest_desc.texture.format << ")";
  if (dest_box != nullptr) {
    s << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";

  reshade::log::message(reshade::log::level::warning, s.str().c_str());

  if (device->get_api() == reshade::api::device_api::vulkan) {
    // perform blit
    cmd_list->copy_texture_region(source, source_subresource, source_box, dest, dest_subresource, dest_box);
    return true;
  } else {
    // Perform DirectX blit
    return true;
  }
}

static bool OnSetFullscreenState(reshade::api::swapchain* swapchain, bool fullscreen, void* hmonitor) {
  if (use_resize_buffer && use_resize_buffer_on_set_full_screen) {
    renodx::utils::swapchain::ResizeBuffer(swapchain, target_format, target_color_space);
  }
  auto* device = swapchain->get_device();
  auto& private_data = device->get_private_data<DeviceData>();
  if (std::addressof(private_data) == nullptr) return false;

  const std::unique_lock lock(private_data.mutex);
  reshade::log::message(reshade::log::level::debug, "mods::swapchain::OnSetFullscreenState(reset resource upgrade)");
  private_data.resource_upgrade_finished = false;
  const uint32_t len = swap_chain_upgrade_targets.size();
  // Reset
  for (uint32_t i = 0; i < len; i++) {
    renodx::mods::swapchain::SwapChainUpgradeTarget* target = &swap_chain_upgrade_targets[i];
    if (target->ignore_reset) continue;
    target->counted = 0;
    target->completed = false;
  }

  if (!fullscreen) return false;
  if (private_data.prevent_full_screen) {
    HWND output_window = static_cast<HWND>(swapchain->get_hwnd());
    if (output_window != nullptr) {
      auto device_back_buffer_desc = renodx::utils::swapchain::GetBackBufferDesc(device);
      // HMONITOR monitor = (HMONITOR)hmonitor;
      const uint32_t screen_width = GetSystemMetrics(SM_CXSCREEN);
      const uint32_t screen_height = GetSystemMetrics(SM_CYSCREEN);
      const uint32_t texture_width = device_back_buffer_desc.texture.width;
      const uint32_t texture_height = device_back_buffer_desc.texture.height;
      const uint32_t top = floor((screen_height - texture_height) / 2.f);
      const uint32_t left = floor((screen_width - texture_width) / 2.f);
      SetWindowLongPtr(output_window, GWL_STYLE, WS_VISIBLE | WS_POPUP);
      SetWindowPos(output_window, HWND_TOP, left, top, texture_width, texture_height, SWP_FRAMECHANGED);
    }
    reshade::log::message(reshade::log::level::info, "Preventing fullscreen");
    return true;
  }
  return false;
}

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  DrawSwapChainProxy(swapchain, queue);
}

template <typename T = float*>
static void Use(DWORD fdw_reason, T* new_injections = nullptr) {
  renodx::utils::resource::Use(fdw_reason);
  renodx::utils::swapchain::Use(fdw_reason);
  renodx::utils::state::Use(fdw_reason);
  if (use_resource_cloning) {
    renodx::utils::descriptor::Use(fdw_reason);
  }

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "mods::swapchain attached.");
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::register_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::create_resource>(OnCreateResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);

      reshade::register_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);
      reshade::register_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);

      reshade::register_event<reshade::addon_event::copy_resource>(OnCopyResource);

      reshade::register_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      if (use_resource_cloning) {
        reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
        reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

        reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
        reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
        reshade::register_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
        // reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
        // reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
        reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

        reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
        reshade::register_event<reshade::addon_event::barrier>(OnBarrier);
        reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);

        if (UsingSwapchainProxy()) {
          // Create swapchain proxy
          reshade::register_event<reshade::addon_event::present>(OnPresent);
          if (new_injections != nullptr) {
            shader_injection_size = sizeof(T) / sizeof(uint32_t);
            shader_injection = reinterpret_cast<float*>(new_injections);
          }
        }
      }

      reshade::register_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::create_resource>(OnCreateResource);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);

      reshade::unregister_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);
      reshade::unregister_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::unregister_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);

      reshade::unregister_event<reshade::addon_event::copy_resource>(OnCopyResource);

      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      // reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      // reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::unregister_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      // reshade::register_event<reshade::addon_event::barrier>(OnBarrier);
      reshade::unregister_event<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);

      reshade::unregister_event<reshade::addon_event::present>(OnPresent);

      reshade::unregister_event<reshade::addon_event::set_fullscreen_state>(OnSetFullscreenState);

      break;
  }
}
}  // namespace renodx::mods::swapchain
