/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <functional>
#include <include/reshade_api_device.hpp>
#include <mutex>
#include <shared_mutex>
#include <unordered_map>

#include <include/reshade.hpp>
#include <vector>

#include "../utils/hash.hpp"

namespace renodx::utils::resource {

#define ViewUpgrade(usage, source, destination) \
  {{reshade::api::resource_usage::usage, reshade::api::format::source}, reshade::api::format::destination}

#define ViewUpgradeAll(source, destination)               \
  ViewUpgrade(shader_resource, source, destination),      \
      ViewUpgrade(unordered_access, source, destination), \
      ViewUpgrade(render_target, source, destination)

const std::unordered_map<
    std::pair<reshade::api::resource_usage, reshade::api::format>,
    reshade::api::format, utils::hash::HashPair>
    VIEW_UPGRADES_RGBA16F = {
        ViewUpgradeAll(r16g16b16a16_typeless, r16g16b16a16_typeless),
        ViewUpgradeAll(r10g10b10a2_typeless, r16g16b16a16_typeless),
        ViewUpgradeAll(r8g8b8a8_typeless, r16g16b16a16_typeless),
        ViewUpgradeAll(r16g16b16a16_float, r16g16b16a16_float),
        ViewUpgradeAll(r16g16b16a16_unorm, r16g16b16a16_float),
        ViewUpgradeAll(r16g16b16a16_snorm, r16g16b16a16_float),
        ViewUpgradeAll(r10g10b10a2_unorm, r16g16b16a16_float),
        ViewUpgradeAll(b10g10r10a2_unorm, r16g16b16a16_float),
        ViewUpgradeAll(r8g8b8a8_unorm, r16g16b16a16_float),
        ViewUpgradeAll(b8g8r8a8_unorm, r16g16b16a16_float),
        ViewUpgradeAll(r8g8b8a8_snorm, r16g16b16a16_float),
        ViewUpgradeAll(r8g8b8a8_unorm_srgb, r16g16b16a16_float),
        ViewUpgradeAll(b8g8r8a8_unorm_srgb, r16g16b16a16_float),
        ViewUpgradeAll(r11g11b10_float, r16g16b16a16_float),
};

const std::unordered_map<
    std::pair<reshade::api::resource_usage, reshade::api::format>,
    reshade::api::format, utils::hash::HashPair>
    VIEW_UPGRADES_R10G10B10A2_UNORM = {
        ViewUpgradeAll(r10g10b10a2_typeless, r10g10b10a2_typeless),
        ViewUpgradeAll(r8g8b8a8_typeless, r10g10b10a2_typeless),
        ViewUpgradeAll(r10g10b10a2_unorm, r10g10b10a2_unorm),
        ViewUpgradeAll(b10g10r10a2_unorm, r10g10b10a2_unorm),
        ViewUpgradeAll(r8g8b8a8_unorm, r10g10b10a2_unorm),
        ViewUpgradeAll(b8g8r8a8_unorm, r10g10b10a2_unorm),
        ViewUpgradeAll(r8g8b8a8_unorm_srgb, r10g10b10a2_unorm),
        ViewUpgradeAll(b8g8r8a8_unorm_srgb, r10g10b10a2_unorm),
};

const std::unordered_map<
    std::pair<reshade::api::resource_usage, reshade::api::format>,
    reshade::api::format, utils::hash::HashPair>
    VIEW_UPGRADES_R11G11B10_FLOAT = {
        ViewUpgradeAll(r10g10b10a2_typeless, r11g11b10_float),
        ViewUpgradeAll(r8g8b8a8_typeless, r11g11b10_float),
        ViewUpgradeAll(r10g10b10a2_unorm, r11g11b10_float),
        ViewUpgradeAll(b10g10r10a2_unorm, r11g11b10_float),
        ViewUpgradeAll(r8g8b8a8_unorm, r11g11b10_float),
        ViewUpgradeAll(b8g8r8a8_unorm, r11g11b10_float),
        ViewUpgradeAll(r8g8b8a8_unorm_srgb, r11g11b10_float),
        ViewUpgradeAll(b8g8r8a8_unorm_srgb, r11g11b10_float),
};

#undef ViewUpgrade
#undef ViewUpgradeAll

struct ResourceUpgradeInfo {
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
          target_ratio = static_cast<float>(back_buffer_desc.texture.width) / static_cast<float>(back_buffer_desc.texture.height);
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

struct ResourceInfo {
  reshade::api::device* device;
  reshade::api::resource_desc desc;
  reshade::api::resource_desc clone_desc;
  reshade::api::resource resource = {0u};
  reshade::api::resource clone = {0u};
  reshade::api::resource fallback = {0u};
  bool destroyed = false;
  bool upgraded = false;
  bool clone_enabled = false;
  bool is_swap_chain = false;
  reshade::api::format format = reshade::api::format::unknown;
  ResourceUpgradeInfo* clone_target = nullptr;
  ResourceUpgradeInfo* upgrade_target = nullptr;
  reshade::api::resource_usage initial_state = reshade::api::resource_usage::undefined;
  float resource_tag = -1;
  reshade::api::resource_view swap_chain_proxy_clone_srv = {0u};
  reshade::api::resource_view swap_chain_proxy_rtv = {0u};
};

struct ResourceViewInfo {
  reshade::api::device* device;

  reshade::api::resource_view_desc desc;
  reshade::api::resource_view_desc clone_desc;
  reshade::api::resource_view view = {0u};
  reshade::api::resource_view clone = {0u};
  reshade::api::resource_view fallback = {0u};
  bool destroyed = false;
  bool upgraded = false;
  reshade::api::resource original_resource = {0u};
  reshade::api::resource clone_resource = {0u};
  ResourceInfo* resource_info = nullptr;
  ResourceUpgradeInfo* clone_target = nullptr;
  ResourceUpgradeInfo* upgrade_target = nullptr;
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
};

static std::shared_mutex resource_infos_mutex;
static std::unordered_map<uint64_t, ResourceInfo> resource_infos;
static std::shared_mutex resource_view_infos_mutex;
static std::unordered_map<uint64_t, ResourceViewInfo> resource_view_infos;

static std::vector<std::function<void(ResourceInfo* resource_info)>> on_init_resource_info_callbacks;
static std::vector<std::function<void(ResourceInfo* resource_info)>> on_destroy_resource_info_callbacks;

static std::vector<std::function<void(ResourceViewInfo* resource_view_info)>> on_init_resource_view_info_callbacks;
static std::vector<std::function<void(ResourceViewInfo* resource_view_info)>> on_destroy_resource_view_info_callbacks;

inline ResourceInfo* GetResourceInfo(const reshade::api::resource& resource, const bool& create = false) {
  {
    std::shared_lock lock(resource_infos_mutex);
    auto pair = resource_infos.find(resource.handle);
    if (pair != resource_infos.end()) return &pair->second;
    if (!create) return nullptr;
  }

  {
    std::unique_lock write_lock(resource_infos_mutex);
    auto& info = resource_infos.insert({resource.handle, ResourceInfo({.resource = resource})}).first->second;
    return &info;
  }
}

inline ResourceInfo* GetResourceInfoUnsafe(const reshade::api::resource& resource, const bool& create = false) {
  auto pair = resource_infos.find(resource.handle);
  if (pair != resource_infos.end()) return &pair->second;
  if (!create) return nullptr;
  auto& info = resource_infos.insert({resource.handle, ResourceInfo({.resource = resource})}).first->second;
  return &info;
}

inline ResourceInfo& CreateResourceInfo(const reshade::api::resource& resource) {
  std::unique_lock write_lock(resource_infos_mutex);
  auto& info = resource_infos[resource.handle];
  info.destroyed = false;
  info.resource = resource;
  return info;
}

inline ResourceViewInfo* GetResourceViewInfo(const reshade::api::resource_view& view, const bool& create = false) {
  {
    std::shared_lock lock(resource_view_infos_mutex);
    auto pair = resource_view_infos.find(view.handle);
    if (pair != resource_view_infos.end()) return &pair->second;
    if (!create) return nullptr;
  }
  {
    std::unique_lock write_lock(resource_view_infos_mutex);
    auto& info = resource_view_infos.insert({view.handle, ResourceViewInfo({.view = view})}).first->second;
    return &info;
  }
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();

  const size_t back_buffer_count = swapchain->get_back_buffer_count();
  std::vector<ResourceInfo*> infos(back_buffer_count);

  {
    std::unique_lock lock(resource_infos_mutex);
    for (uint32_t index = 0; index < back_buffer_count; ++index) {
      auto buffer = swapchain->get_back_buffer(index);
      auto& info = resource_infos[buffer.handle];
      info = {
          .device = device,
          .desc = device->get_resource_desc(buffer),
          .resource = buffer,
          .is_swap_chain = true,
          .initial_state = reshade::api::resource_usage::general,
      };
      infos[index] = &info;
    }
    lock.unlock();
  }

  for (auto& resource_info : infos) {
    for (auto& callback : on_init_resource_info_callbacks) {
      callback(resource_info);
    }
  }
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  const size_t back_buffer_count = swapchain->get_back_buffer_count();
  std::vector<ResourceInfo*> infos;
  {
    std::unique_lock lock(resource_infos_mutex);
    for (uint32_t index = 0; index < back_buffer_count; ++index) {
      auto buffer = swapchain->get_back_buffer(index);
      auto pair = resource_infos.find(buffer.handle);
      if (pair == resource_infos.end()) {
        assert(false);
        continue;
      }
      auto& info = pair->second;
      info.destroyed = true;
      infos.push_back(&info);
    }
    lock.unlock();
  }

  for (auto& resource_info : infos) {
    for (auto& callback : on_destroy_resource_info_callbacks) {
      callback(resource_info);
    }
  }
}

inline void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (resource.handle == 0) return;

  // assume write new
  std::unique_lock lock(resource_infos_mutex);
  auto& resource_info = resource_infos[resource.handle];
  lock.unlock();
  resource_info = {
      .device = device,
      .desc = desc,
      .resource = resource,
      .initial_state = initial_state,
  };
  for (auto& callback : on_init_resource_info_callbacks) {
    callback(&resource_info);
  }
}

inline void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (resource.handle == 0) return;

  std::shared_lock lock(resource_infos_mutex);
  auto pair = resource_infos.find(resource.handle);
  if (pair == resource_infos.end()) return;
  lock.unlock();
  auto& resource_info = pair->second;

  resource_info.device = device;
  resource_info.destroyed = true;

  for (auto& callback : on_destroy_resource_info_callbacks) {
    callback(&resource_info);
  }
}

inline void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (view.handle == 0u) return;
  std::unique_lock lock(resource_view_infos_mutex);
  auto& resource_view_info = resource_view_infos[view.handle];
  lock.unlock();

  if (resource_view_info.view.handle != 0u && !resource_view_info.destroyed) {
    for (const auto& callback : on_destroy_resource_view_info_callbacks) {
      callback(&resource_view_info);
    }
  }

  ResourceInfo* resource_info = nullptr;
  if (resource.handle != 0u) {
    std::unique_lock resource_lock(resource_infos_mutex);
    resource_info = &resource_infos[resource.handle];
  }

  resource_view_info = {
      .device = device,
      .desc = desc,
      .view = view,
      .original_resource = resource,
      .resource_info = resource_info,
      .usage = usage_type,
  };
  if (resource_info != nullptr) {
    resource_view_info.clone_target = resource_view_info.resource_info->clone_target;
  }

  for (const auto& callback : on_init_resource_view_info_callbacks) {
    callback(&resource_view_info);
  }
}

inline void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  if (view.handle == 0u) return;

  std::shared_lock lock(resource_view_infos_mutex);
  auto pair = resource_view_infos.find(view.handle);
  if (pair == resource_view_infos.end()) return;
  lock.unlock();

  auto& resource_view_info = pair->second;
  resource_view_info.destroyed = true;
  if (resource_view_info.view.handle != 0u) {
    for (auto& callback : on_destroy_resource_view_info_callbacks) {
      callback(&resource_view_info);
    }
  }
}

static float GetResourceTag(const reshade::api::resource& resource) {
  auto* resource_info = GetResourceInfo(resource);
  if (resource_info == nullptr) return -1;
  return resource_info->resource_tag;
}

static float GetResourceTag(const reshade::api::resource_view& resource_view) {
  auto* resource_view_info = GetResourceViewInfo(resource_view);
  if (resource_view_info == nullptr) return -1;
  if (resource_view_info->destroyed) return -1;
  if (resource_view_info->resource_info == nullptr) return -1;
  return resource_view_info->resource_info->resource_tag;
}

static void SetResourceTag(const reshade::api::resource& resource, const float& tag) {
  auto* resource_info = GetResourceInfo(resource, true);
  resource_info->resource_tag = tag;
}

static void RemoveResourceTag(const reshade::api::resource& resource) {
  auto* resource_info = GetResourceInfo(resource);
  if (resource_info == nullptr) return;
  resource_info->resource_tag = -1.f;
}

static bool IsKnownResourceView(const reshade::api::resource_view& view) {
  if (view.handle == 0u) return false;
  auto* resource_view_info = GetResourceViewInfo(view);
  return resource_view_info != nullptr && !resource_view_info->destroyed;
}

inline reshade::api::resource GetResourceFromView(const reshade::api::resource_view& view) {
  if (view.handle == 0u) return {0};
  auto* resource_view_info = GetResourceViewInfo(view);
  if (resource_view_info == nullptr) return {0u};
  if (resource_view_info->destroyed) return {0u};
  if (resource_view_info->resource_info == nullptr) return {0u};
  return resource_view_info->resource_info->resource;
}

static bool IsResourceViewEmpty(reshade::api::device* device, const reshade::api::resource_view& view) {
  if (view.handle == 0u) return true;
  auto* resource_view_info = GetResourceViewInfo(view);
  if (resource_view_info == nullptr) return true;
  if (resource_view_info->destroyed) return true;
  return (resource_view_info->original_resource.handle == 0u);
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "ResourceUtil attached.");

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::unregister_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::unregister_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
      break;
  }
}
}  // namespace renodx::utils::resource
