/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cassert>
#include <functional>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <vector>

#include <include/reshade.hpp>

#include "../utils/bitwise.hpp"
#include "../utils/data.hpp"
#include "../utils/format.hpp"
#include "../utils/hash.hpp"
#include "../utils/log.hpp"

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

const std::unordered_map<
    std::pair<reshade::api::resource_usage, reshade::api::format>,
    reshade::api::format, utils::hash::HashPair>
    VIEW_UPGRADES_R9G9B9E5 = {
        ViewUpgradeAll(r16g16b16a16_typeless, r9g9b9e5),
        ViewUpgradeAll(r10g10b10a2_typeless, r9g9b9e5),
        ViewUpgradeAll(r8g8b8a8_typeless, r9g9b9e5),
        ViewUpgradeAll(r16g16b16a16_float, r9g9b9e5),
        ViewUpgradeAll(r16g16b16a16_unorm, r9g9b9e5),
        ViewUpgradeAll(r16g16b16a16_snorm, r9g9b9e5),
        ViewUpgradeAll(r10g10b10a2_unorm, r9g9b9e5),
        ViewUpgradeAll(b10g10r10a2_unorm, r9g9b9e5),
        ViewUpgradeAll(r8g8b8a8_unorm, r9g9b9e5),
        ViewUpgradeAll(b8g8r8a8_unorm, r9g9b9e5),
        ViewUpgradeAll(r8g8b8a8_snorm, r9g9b9e5),
        ViewUpgradeAll(r8g8b8a8_unorm_srgb, r9g9b9e5),
        ViewUpgradeAll(b8g8r8a8_unorm_srgb, r9g9b9e5),
        ViewUpgradeAll(r11g11b10_float, r9g9b9e5),
        ViewUpgradeAll(r9g9b9e5, r9g9b9e5),
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
  bool use_shared_handle = false;

  static const int16_t BACK_BUFFER = -1;
  static const int16_t ANY = -2;
  float aspect_ratio = ANY;
  float aspect_ratio_tolerance = 0.0001f;

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
        const float diff = std::abs(view_ratio - target_ratio);
        if (diff > this->aspect_ratio_tolerance) return false;
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
  reshade::api::resource_desc fallback_desc;
  reshade::api::resource resource = {0u};
  reshade::api::resource clone = {0u};
  reshade::api::resource fallback = {0u};
  bool destroyed = false;
  bool upgraded = false;
  bool clone_enabled = false;
  bool is_swap_chain = false;
  bool is_clone = false;
  uint32_t extra_vram = 0;
  ResourceUpgradeInfo* clone_target = nullptr;
  ResourceUpgradeInfo* upgrade_target = nullptr;
  reshade::api::resource_usage initial_state = reshade::api::resource_usage::undefined;
  float resource_tag = -1;
  reshade::api::resource_view swap_chain_proxy_clone_srv = {0u};
  reshade::api::resource_view swap_chain_proxy_rtv = {0u};
  void* shared_handle = nullptr;
  reshade::api::resource proxy_resource = {0u};
};

struct ResourceViewInfo {
  reshade::api::device* device;

  reshade::api::resource_view_desc desc;
  reshade::api::resource_view_desc clone_desc;
  reshade::api::resource_view_desc fallback_desc;
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
  bool is_clone = false;
};

static bool is_primary_hook = false;

static struct Store {
  data::ParallelNodeHashMap<uint64_t, ResourceInfo, std::shared_mutex> resource_infos;
  data::ParallelNodeHashMap<uint64_t, ResourceViewInfo, std::shared_mutex> resource_view_infos;
  std::vector<std::function<void(ResourceInfo* resource_info)>> on_init_resource_info_callbacks;
  std::vector<std::function<void(ResourceInfo* resource_info)>> on_destroy_resource_info_callbacks;

  std::vector<std::function<void(ResourceViewInfo* resource_view_info)>> on_init_resource_view_info_callbacks;
  std::vector<std::function<void(ResourceViewInfo* resource_view_info)>> on_destroy_resource_view_info_callbacks;
} local_store;

static Store* store = &local_store;

inline ResourceInfo* GetResourceInfo(const reshade::api::resource& resource, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = store->resource_infos.try_emplace_p(resource.handle, ResourceInfo({.resource = resource}));
    return &pointer->second;
  }
  ResourceInfo* info = nullptr;
  store->resource_infos.if_contains(resource.handle, [&info](std::pair<const uint64_t, ResourceInfo>& pair) {
    info = &pair.second;
  });
  if (info == nullptr) {
    log::e("utils::resource::GetResourceInfo(Resource not found for handle: ",
           log::AsPtr(resource.handle), ")");
    assert(info != nullptr);
  }
  return info;
}

inline ResourceInfo* GetResourceInfoUnsafe(const reshade::api::resource& resource, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = store->resource_infos.try_emplace_p(resource.handle, ResourceInfo({.resource = resource}));
    return &pointer->second;
  }
  ResourceInfo* data = nullptr;
  store->resource_infos.if_contains_unsafe(resource.handle, [&data](std::pair<const uint64_t, ResourceInfo>& pair) {
    data = &pair.second;
  });
  if (data == nullptr) {
    log::e("utils::resource::GetResourceInfoUnsafe(Resource not found for handle: ",
           log::AsPtr(resource.handle), ")");
    assert(data != nullptr);
  }

  return data;
}

inline ResourceViewInfo* GetResourceViewInfo(const reshade::api::resource_view& view, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = store->resource_view_infos.try_emplace_p(view.handle, ResourceViewInfo({.view = view}));
    return &pointer->second;
  }
  ResourceViewInfo* data = nullptr;
  store->resource_view_infos.if_contains(view.handle, [&data](std::pair<const uint64_t, ResourceViewInfo>& pair) {
    data = &pair.second;
  });
  if (data == nullptr) {
    log::e("utils::resource::GetResourceViewInfo(Resource view not found for handle: ",
           log::AsPtr(view.handle), ")");
    assert(data != nullptr);
  }
  return data;
}

inline ResourceViewInfo* GetResourceViewInfoUnsafe(const reshade::api::resource_view& view, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = store->resource_view_infos.try_emplace_p(view.handle, ResourceViewInfo({.view = view}));
    return &pointer->second;
  }
  ResourceViewInfo* data = nullptr;
  store->resource_view_infos.if_contains_unsafe(view.handle, [&data](std::pair<const uint64_t, ResourceViewInfo>& pair) {
    data = &pair.second;
  });
  if (data == nullptr) {
    log::e("utils::resource::GetResourceViewInfoUnsafe(Resource view not found for handle: ",
           log::AsPtr(view.handle), ")");
    assert(data != nullptr);
  }
  return data;
}

struct __declspec(uuid("3c7a0a1f-4bf3-4e7a-ac02-6f63fdc70187")) DeviceData {
  Store* store;
};

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet(device, data);

  if (created) {
    std::stringstream s;
    s << "utils::resource::OnInitDevice(Hooking device: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    is_primary_hook = true;
    data->store = store;
  } else {
    std::stringstream s;
    s << "utils::resource::OnInitDevice(Attaching to hook: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
    store = data->store;
    for (auto& callback : local_store.on_init_resource_info_callbacks) {
      store->on_init_resource_info_callbacks.push_back(callback);
    }
    for (auto& callback : local_store.on_destroy_resource_info_callbacks) {
      store->on_destroy_resource_info_callbacks.push_back(callback);
    }
    for (auto& callback : local_store.on_init_resource_view_info_callbacks) {
      store->on_init_resource_view_info_callbacks.push_back(callback);
    }
    for (auto& callback : local_store.on_destroy_resource_view_info_callbacks) {
      store->on_destroy_resource_view_info_callbacks.push_back(callback);
    }
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  std::stringstream s;
  s << "utils::resource::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  device->destroy_private_data<DeviceData>();
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!is_primary_hook) return;
  auto* device = swapchain->get_device();

  const size_t back_buffer_count = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    auto resource = swapchain->get_back_buffer(index);
    auto desc = device->get_resource_desc(resource);
    ResourceInfo new_info = {
        .device = device,
        .desc = desc,
        .resource = resource,
        .is_swap_chain = true,
        .initial_state = reshade::api::resource_usage::general,
    };
    bool was_destroyed = false;
    auto [pair, inserted] = store->resource_infos.try_emplace_p(resource.handle, new_info);
    if (!inserted) {
      assert(pair->second.resource.handle == resource.handle);
      was_destroyed = pair->second.destroyed;
      if (!pair->second.destroyed) {
        for (auto& callback : store->on_destroy_resource_info_callbacks) {
          callback(&pair->second);
        }
      }
      pair->second = new_info;
    }

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::resource::OnInitSwapchain(";
      s << PRINT_PTR(resource.handle);
      if (device->get_api() == reshade::api::device_api::opengl) {
        const int opengl_target = resource.handle >> 40;
        const int opengl_object = resource.handle & 0xFFFFFFFF;
        s << ", opengl target: " << opengl_target;
        s << ", opengl object: " << opengl_object;
      }
      s << ", type: " << desc.type;

      if (desc.type == reshade::api::resource_type::unknown) {
        assert(false);
      } else if (desc.type == reshade::api::resource_type::buffer) {
        s << ", size: " << desc.buffer.size;
      } else {
        s << ", format: " << desc.texture.format;
        s << ", width: " << desc.texture.width;
        s << ", height: " << desc.texture.height;
        s << ", depth_or_layers: " << desc.texture.depth_or_layers;
        s << ", levels: " << desc.texture.levels;
      }
      s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
      s << ", inserted: " << (inserted ? "true" : "false");
      s << ", was_destroyed: " << (was_destroyed ? "true" : "false");
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
    for (auto& callback : store->on_init_resource_info_callbacks) {
      callback(&pair->second);
    }
  }
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!is_primary_hook) return;
  const size_t back_buffer_count = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    auto buffer = swapchain->get_back_buffer(index);
    auto* info = GetResourceInfo(buffer, false);
    if (info == nullptr) {
      assert(info != nullptr);
      continue;
    }
    info->destroyed = true;

    for (auto& callback : store->on_destroy_resource_info_callbacks) {
      callback(info);
    }
  }
}

inline void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (!is_primary_hook) return;
  if (resource.handle == 0) return;

  ResourceInfo new_data = {
      .device = device,
      .desc = desc,
      .resource = resource,
      .destroyed = false,
      .initial_state = initial_state,
  };

  ResourceInfo* pointer = nullptr;

  bool was_destroyed = false;

  auto [pair, inserted] = store->resource_infos.try_emplace_p(resource.handle, new_data);
  if (!inserted) {
    assert(pair->second.resource.handle == resource.handle);
    was_destroyed = pair->second.destroyed;
    if (!pair->second.destroyed) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::resource::OnInitResource(Resource reused: ";
      s << static_cast<uintptr_t>(resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      for (auto& callback : store->on_destroy_resource_info_callbacks) {
        callback(&pair->second);
      }
    }
    pair->second = new_data;
  }

#ifdef DEBUG_LEVEL_2
  {
    std::stringstream s;
    s << "utils::resource::OnInitResource(";
    s << PRINT_PTR(resource.handle);
    if (device->get_api() == reshade::api::device_api::opengl) {
      const int opengl_target = resource.handle >> 40;
      const int opengl_object = resource.handle & 0xFFFFFFFF;
      s << ", opengl target: " << opengl_target;
      s << ", opengl object: " << opengl_object;
    }
    s << ", type: " << desc.type;

    if (desc.type == reshade::api::resource_type::unknown) {
      assert(false);
    } else if (desc.type == reshade::api::resource_type::buffer) {
      s << ", size: " << desc.buffer.size;
    } else {
      s << ", format: " << desc.texture.format;
      s << ", width: " << desc.texture.width;
      s << ", height: " << desc.texture.height;
      s << ", depth_or_layers: " << desc.texture.depth_or_layers;
      s << ", levels: " << desc.texture.levels;
    }
    s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
    if (initial_data != nullptr) {
      s << ", initial_data: " << initial_data;
    } else {
      s << ", initial_data: nullptr";
    }
    s << ", initial_state: " << initial_state;
    s << ", inserted: " << (inserted ? "true" : "false");
    s << ", was_destroyed: " << (was_destroyed ? "true" : "false");
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  for (auto& callback : store->on_init_resource_info_callbacks) {
    callback(&pair->second);
  }
}

inline void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (!is_primary_hook) return;
  if (resource.handle == 0) return;

  reshade::api::resource pending_fallback = {0u};
  auto exists = store->resource_infos.if_contains(
      resource.handle,
      [&device, &resource, &pending_fallback](std::pair<const uint64_t, ResourceInfo>& pair) {
        auto* resource_info = &pair.second;
        if (resource_info->destroyed) {
          log::w("utils::resource::OnDestroyResource(Resource already destroyed: ",
                 log::AsPtr(resource.handle), ")");
          assert(!resource_info->destroyed);
          return;
        }
        if (resource_info->device != device) {
          log::e("utils::resource::OnDestroyResource(Resource destroyed on different device: ",
                 log::AsPtr(resource.handle), ")");
          assert(resource_info->device == device);
        }
        if (resource_info->resource.handle != resource.handle) {
          log::e("utils::resource::OnDestroyResource(Resource handle mismatch: ",
                 log::AsPtr(resource.handle), " != ", log::AsPtr(resource_info->resource.handle), ")");
          assert(resource_info->resource.handle == resource.handle);
          return;
        }
        if (resource_info->is_clone) {
          log::e("utils::resource::OnDestroyResource(Resource is a clone, cannot destroy directly: ",
                 log::AsPtr(resource.handle), ")");
          assert(!resource_info->is_clone);
          assert(resource_info->fallback.handle != 0u);

          pending_fallback = resource_info->fallback;
          return;
        }

        resource_info->device = device;
        resource_info->destroyed = true;

        for (auto& callback : store->on_destroy_resource_info_callbacks) {
          callback(resource_info);
        }
      });
  if (pending_fallback.handle != 0u) {
    // If we have a pending fallback, destroy it instead
    device->destroy_resource(pending_fallback);
    OnDestroyResource(device, pending_fallback);
  }
}

inline reshade::api::resource_view_desc PopulateUnknownResourceViewDesc(
    reshade::api::device* device,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_usage usage_type,
    ResourceInfo* resource_info) {
  reshade::api::resource_view_desc new_desc = desc;
  switch (device->get_api()) {
    case reshade::api::device_api::d3d11:
      // Set this parameter to NULL to create a view that accesses the entire
      // resource (using the format the resource was created with).
    case reshade::api::device_api::d3d12:
      // A null pDesc is used to initialize a default descriptor, if possible.
      // This behavior is identical to the D3D11 null descriptor behavior,
      // where defaults are filled in. This behavior inherits the resource format
      // and dimension (if not typeless) and for buffers SRVs target a full buffer
      // and are typed (not raw or structured), and for textures SRVs target
      // a full texture, all mips and all array slices.
      // Not all resources support null descriptor initialization.
      if (resource_info == nullptr) {
        assert(resource_info != nullptr);
        return desc;
      }
      switch (resource_info->desc.type) {
        case reshade::api::resource_type::buffer:
          new_desc.type = reshade::api::resource_view_type::buffer;
          new_desc.format = reshade::api::format::unknown;
          break;
        case reshade::api::resource_type::texture_1d:
          if (resource_info->desc.texture.depth_or_layers > 1) {
            new_desc.type = reshade::api::resource_view_type::texture_1d_array;
          } else {
            new_desc.type = reshade::api::resource_view_type::texture_1d;
          }
          new_desc.texture.level_count = UINT32_MAX;
          new_desc.texture.layer_count = resource_info->desc.texture.depth_or_layers;
          new_desc.format = resource_info->desc.texture.format;
          break;
        case reshade::api::resource_type::surface:
        case reshade::api::resource_type::texture_2d:
          switch (usage_type) {
            case reshade::api::resource_usage::unordered_access:
              new_desc.texture.level_count = 1;
              break;
            default:
              new_desc.texture.level_count = UINT32_MAX;
          }
          new_desc.texture.layer_count = resource_info->desc.texture.depth_or_layers;
          if (resource_info->desc.texture.depth_or_layers > 1) {
            if (resource_info->desc.texture.samples > 1) {
              new_desc.type = reshade::api::resource_view_type::texture_2d_multisample_array;
            } else if (renodx::utils::bitwise::HasFlag(resource_info->desc.flags, reshade::api::resource_flags::cube_compatible)) {
              new_desc.type = reshade::api::resource_view_type::texture_cube_array;
            } else {
              new_desc.type = reshade::api::resource_view_type::texture_2d_array;
            }
          } else if (resource_info->desc.texture.samples > 1) {
            new_desc.type = reshade::api::resource_view_type::texture_2d_multisample;
          } else if (renodx::utils::bitwise::HasFlag(resource_info->desc.flags, reshade::api::resource_flags::cube_compatible)) {
            new_desc.type = reshade::api::resource_view_type::texture_cube;
          } else {
            new_desc.type = reshade::api::resource_view_type::texture_2d;
          }
          new_desc.format = resource_info->desc.texture.format;
          break;
        case reshade::api::resource_type::texture_3d:
          new_desc.format = resource_info->desc.texture.format;
          new_desc.texture.level_count = UINT32_MAX;
          new_desc.texture.layer_count = UINT32_MAX;
          break;
        case reshade::api::resource_type::unknown:
        default:
          assert(false);
          break;
      }
      break;
    default:
      assert(false && "Unknown format in unsupported device API");
      break;
  }

#ifdef DEBUG_LEVEL_2
  renodx::utils::log::d(
      "utils::resource::PopulateUnknownResourceViewDesc(",
      "Populated unknown resource view: ",
      ", format: ", desc.format, " => ", new_desc.format,
      ", type: ", desc.type, " => ", new_desc.type,
      ", first_layer: ", desc.texture.first_layer, " => ", new_desc.texture.first_layer,
      ", first_level: ", desc.texture.first_level, " => ", new_desc.texture.first_level,
      ", layer_count: ", desc.texture.layer_count, " => ", new_desc.texture.layer_count,
      ", level_count: ", desc.texture.level_count, " => ", new_desc.texture.level_count,
      ")");
#endif
  return new_desc;
}

inline void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (!is_primary_hook) return;
  if (view.handle == 0u) return;

  ResourceViewInfo new_data = {
      .device = device,
      .desc = desc,
      .view = view,
      .original_resource = resource,
      .usage = usage_type,
  };

  if (resource.handle != 0u) {
    new_data.resource_info = GetResourceInfo(resource, false);
    if (new_data.resource_info != nullptr) {
      new_data.clone_target = new_data.resource_info->clone_target;
    } else {
      assert(new_data.resource_info != nullptr);
    }
  }

  if (desc.type == reshade::api::resource_view_type::unknown
      || (desc.format == reshade::api::format::unknown
          && desc.type != reshade::api::resource_view_type::buffer
          && desc.type != reshade::api::resource_view_type::acceleration_structure)) {
    new_data.desc = PopulateUnknownResourceViewDesc(device, desc, usage_type, new_data.resource_info);
  }

  auto [pair, inserted] = store->resource_view_infos.try_emplace_p(view.handle, new_data);
  if (!inserted) {
    assert(pair->second.view.handle == view.handle);
    if (!pair->second.destroyed) {
#ifdef DEBUG_LEVEL_2
      std::stringstream s;
      s << "utils::resource::OnInitResourceView(Resource view reused: ";
      s << PRINT_PTR(view.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      for (const auto& callback : store->on_destroy_resource_view_info_callbacks) {
        callback(&pair->second);
      }
    }
    pair->second = new_data;
  }
  for (const auto& callback : store->on_init_resource_view_info_callbacks) {
    callback(&pair->second);
  }
}

inline void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  if (!is_primary_hook) return;
  if (view.handle == 0u) return;

  auto* resource_view_info = GetResourceViewInfo(view);
  if (resource_view_info == nullptr) {
    log::e("utils::resource::OnDestroyResourceView(Resource view not found for handle: ",
           log::AsPtr(view.handle), ")");
    assert(resource_view_info != nullptr);
    return;
  }

  resource_view_info->destroyed = true;
  assert(resource_view_info->view.handle != 0u);
  for (auto& callback : store->on_destroy_resource_view_info_callbacks) {
    callback(resource_view_info);
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

static uint32_t ComputeTextureSize(
    const reshade::api::resource_desc& desc,
    reshade::api::device_api device_api = reshade::api::device_api::d3d12) {
  auto row_pitch = format_row_pitch(desc.texture.format, desc.texture.width);
  if (device_api == reshade::api::device_api::d3d12) {
    row_pitch = (row_pitch + 255) & ~255;
  }
  auto size = format_slice_pitch(desc.texture.format, row_pitch, desc.texture.height);
  return size;
}

// https://learn.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#format-conversion-using-direct3d-101
// https://learn.microsoft.com/en-us/windows/win32/direct3d11/texture-block-compression-in-direct3d-11
static bool IsCompressible(
    reshade::api::format uncompressed,
    reshade::api::format compressed) {
  switch (uncompressed) {
    // 32 bit width
    case reshade::api::format::r32_uint:
    case reshade::api::format::r32_sint:
      switch (compressed) {
        // Special case
        case reshade::api::format::r9g9b9e5:
          return true;
        default:
          return false;
      }
    // 64 bit width / 8 bytes per 4x4 block
    case reshade::api::format::r16g16b16a16_uint:
    case reshade::api::format::r16g16b16a16_sint:
    case reshade::api::format::r32g32_uint:
    case reshade::api::format::r32g32_sint:
      switch (compressed) {
        case reshade::api::format::bc1_unorm:
        case reshade::api::format::bc1_unorm_srgb:
        case reshade::api::format::bc1_typeless:
        case reshade::api::format::bc4_unorm:
        case reshade::api::format::bc4_snorm:
        case reshade::api::format::bc4_typeless:
          return true;
        default:
          return false;
      }
    // 128 bit width / 16 bytes per 4x4 block
    case reshade::api::format::r32g32b32a32_uint:
    case reshade::api::format::r32g32b32a32_sint:
    case reshade::api::format::r32g32b32a32_typeless:
      switch (compressed) {
        case reshade::api::format::bc2_unorm:
        case reshade::api::format::bc2_unorm_srgb:
        case reshade::api::format::bc2_typeless:
        case reshade::api::format::bc3_unorm:
        case reshade::api::format::bc3_unorm_srgb:
        case reshade::api::format::bc3_typeless:
        case reshade::api::format::bc5_unorm:
        case reshade::api::format::bc5_snorm:
        case reshade::api::format::bc5_typeless:
        case reshade::api::format::bc6h_typeless:
        case reshade::api::format::bc6h_ufloat:
        case reshade::api::format::bc6h_sfloat:
        case reshade::api::format::bc7_unorm:
        case reshade::api::format::bc7_unorm_srgb:
        case reshade::api::format::bc7_typeless:
          return true;
        default:
          return false;
      }
    default:
      return false;
  }
}

inline reshade::api::format FormatToTypeless(reshade::api::format value) {
  switch (value) {
    case reshade::api::format::l8_unorm:
    case reshade::api::format::r8_typeless:
    case reshade::api::format::r8_uint:
    case reshade::api::format::r8_sint:
    case reshade::api::format::r8_unorm:
    case reshade::api::format::r8_snorm:
      return reshade::api::format::r8_typeless;
    case reshade::api::format::l8a8_unorm:
    case reshade::api::format::r8g8_typeless:
    case reshade::api::format::r8g8_uint:
    case reshade::api::format::r8g8_sint:
    case reshade::api::format::r8g8_unorm:
    case reshade::api::format::r8g8_snorm:
      return reshade::api::format::r8g8_typeless;
    case reshade::api::format::r8g8b8a8_typeless:
    case reshade::api::format::r8g8b8a8_uint:
    case reshade::api::format::r8g8b8a8_sint:
    case reshade::api::format::r8g8b8a8_unorm:
    case reshade::api::format::r8g8b8a8_unorm_srgb:
    case reshade::api::format::r8g8b8a8_snorm:
    case reshade::api::format::r8g8b8x8_unorm:
    case reshade::api::format::r8g8b8x8_unorm_srgb:
      return reshade::api::format::r8g8b8a8_typeless;
    case reshade::api::format::b8g8r8a8_typeless:
    case reshade::api::format::b8g8r8a8_unorm:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
      return reshade::api::format::b8g8r8a8_typeless;
    case reshade::api::format::b8g8r8x8_typeless:
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
      return reshade::api::format::b8g8r8x8_typeless;
    case reshade::api::format::r10g10b10a2_typeless:
    case reshade::api::format::r10g10b10a2_uint:
    case reshade::api::format::r10g10b10a2_unorm:
    case reshade::api::format::r10g10b10a2_xr_bias:
      return reshade::api::format::r10g10b10a2_typeless;
    case reshade::api::format::b10g10r10a2_typeless:
    case reshade::api::format::b10g10r10a2_uint:
    case reshade::api::format::b10g10r10a2_unorm:
      return reshade::api::format::b10g10r10a2_typeless;
    case reshade::api::format::l16_unorm:
    case reshade::api::format::d16_unorm:
    case reshade::api::format::r16_typeless:
    case reshade::api::format::r16_uint:
    case reshade::api::format::r16_sint:
    case reshade::api::format::r16_float:
    case reshade::api::format::r16_unorm:
    case reshade::api::format::r16_snorm:
      return reshade::api::format::r16_typeless;
    case reshade::api::format::l16a16_unorm:
    case reshade::api::format::r16g16_typeless:
    case reshade::api::format::r16g16_uint:
    case reshade::api::format::r16g16_sint:
    case reshade::api::format::r16g16_float:
    case reshade::api::format::r16g16_unorm:
    case reshade::api::format::r16g16_snorm:
      return reshade::api::format::r16g16_typeless;
    case reshade::api::format::r16g16b16a16_typeless:
    case reshade::api::format::r16g16b16a16_uint:
    case reshade::api::format::r16g16b16a16_sint:
    case reshade::api::format::r16g16b16a16_float:
    case reshade::api::format::r16g16b16a16_unorm:
    case reshade::api::format::r16g16b16a16_snorm:
      return reshade::api::format::r16g16b16a16_typeless;
    case reshade::api::format::d32_float:
    case reshade::api::format::r32_typeless:
    case reshade::api::format::r32_uint:
    case reshade::api::format::r32_sint:
    case reshade::api::format::r32_float:
      return reshade::api::format::r32_typeless;
    case reshade::api::format::r32g32_typeless:
    case reshade::api::format::r32g32_uint:
    case reshade::api::format::r32g32_sint:
    case reshade::api::format::r32g32_float:
      return reshade::api::format::r32g32_typeless;
    case reshade::api::format::r32g32b32_typeless:
    case reshade::api::format::r32g32b32_uint:
    case reshade::api::format::r32g32b32_sint:
    case reshade::api::format::r32g32b32_float:
      return reshade::api::format::r32g32b32_typeless;
    case reshade::api::format::r32g32b32a32_typeless:
    case reshade::api::format::r32g32b32a32_uint:
    case reshade::api::format::r32g32b32a32_sint:
    case reshade::api::format::r32g32b32a32_float:
      return reshade::api::format::r32g32b32a32_typeless;
    case reshade::api::format::d32_float_s8_uint:
    case reshade::api::format::r32_g8_typeless:
    case reshade::api::format::r32_float_x8_uint:
    case reshade::api::format::x32_float_g8_uint:
      return reshade::api::format::r32_g8_typeless;
      // Do not also convert 'd24_unorm_x8_uint' here, to keep it distinguishable from 'd24_unorm_s8_uint'
    case reshade::api::format::d24_unorm_s8_uint:
    case reshade::api::format::r24_g8_typeless:
    case reshade::api::format::r24_unorm_x8_uint:
    case reshade::api::format::x24_unorm_g8_uint:
      return reshade::api::format::r24_g8_typeless;
    case reshade::api::format::bc1_typeless:
    case reshade::api::format::bc1_unorm:
    case reshade::api::format::bc1_unorm_srgb:
      return reshade::api::format::bc1_typeless;
    case reshade::api::format::bc2_typeless:
    case reshade::api::format::bc2_unorm:
    case reshade::api::format::bc2_unorm_srgb:
      return reshade::api::format::bc2_typeless;
    case reshade::api::format::bc3_typeless:
    case reshade::api::format::bc3_unorm:
    case reshade::api::format::bc3_unorm_srgb:
      return reshade::api::format::bc3_typeless;
    case reshade::api::format::bc4_typeless:
    case reshade::api::format::bc4_unorm:
    case reshade::api::format::bc4_snorm:
      return reshade::api::format::bc4_typeless;
    case reshade::api::format::bc5_typeless:
    case reshade::api::format::bc5_unorm:
    case reshade::api::format::bc5_snorm:
      return reshade::api::format::bc5_typeless;
    case reshade::api::format::bc6h_typeless:
    case reshade::api::format::bc6h_ufloat:
    case reshade::api::format::bc6h_sfloat:
      return reshade::api::format::bc6h_typeless;
    case reshade::api::format::bc7_typeless:
    case reshade::api::format::bc7_unorm:
    case reshade::api::format::bc7_unorm_srgb:
      return reshade::api::format::bc7_typeless;
    default:
      return value;
  }
}

static bool attached = false;

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "ResourceUtil attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
      reshade::register_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
      reshade::register_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
      break;

    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
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
