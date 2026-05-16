/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cassert>
#include <optional>
#include <ranges>
#include <shared_mutex>
#include <sstream>
#include <type_traits>
#include <utility>

#include <include/reshade.hpp>

#include "../utils/bitwise.hpp"
#include "../utils/cross_addon.hpp"
#include "../utils/format.hpp"
#include "../utils/hash.hpp"
#include "../utils/log.hpp"

namespace renodx::utils::resource {

static bool use_resource_replace = false;

#define ViewUpgrade(usage, source, destination) \
  {{reshade::api::resource_usage::usage, reshade::api::format::source}, reshade::api::format::destination}

#define ViewUpgradeAll(source, destination)               \
  ViewUpgrade(shader_resource, source, destination),      \
      ViewUpgrade(unordered_access, source, destination), \
      ViewUpgrade(render_target, source, destination)

using ResourceViewUpgradeMap = cross_addon::unordered_map<
    std::pair<reshade::api::resource_usage, reshade::api::format>,
    reshade::api::format,
    utils::hash::HashPair>;

const ResourceViewUpgradeMap VIEW_UPGRADES_RGBA16F = {
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
    ViewUpgradeAll(b8g8r8x8_unorm, r16g16b16a16_float),
    ViewUpgradeAll(b8g8r8x8_unorm_srgb, r16g16b16a16_float),
};

const ResourceViewUpgradeMap VIEW_UPGRADES_RGBA8_UNORM = {
    ViewUpgradeAll(r8g8b8a8_typeless, r8g8b8a8_typeless),
    ViewUpgradeAll(r8g8b8a8_unorm, r8g8b8a8_unorm),
    ViewUpgradeAll(r8g8b8a8_unorm_srgb, r8g8b8a8_unorm),
    ViewUpgradeAll(b8g8r8a8_unorm, r8g8b8a8_unorm),
    ViewUpgradeAll(b8g8r8a8_unorm_srgb, r8g8b8a8_unorm),
    ViewUpgradeAll(b8g8r8x8_unorm, r8g8b8a8_unorm),
    ViewUpgradeAll(b8g8r8x8_unorm_srgb, r8g8b8a8_unorm),
};

const ResourceViewUpgradeMap VIEW_UPGRADES_R10G10B10A2_UNORM = {
    ViewUpgradeAll(r10g10b10a2_typeless, r10g10b10a2_typeless),
    ViewUpgradeAll(r8g8b8a8_typeless, r10g10b10a2_typeless),
    ViewUpgradeAll(r10g10b10a2_unorm, r10g10b10a2_unorm),
    ViewUpgradeAll(b10g10r10a2_unorm, r10g10b10a2_unorm),
    ViewUpgradeAll(r8g8b8a8_unorm, r10g10b10a2_unorm),
    ViewUpgradeAll(b8g8r8a8_unorm, r10g10b10a2_unorm),
    ViewUpgradeAll(r8g8b8a8_unorm_srgb, r10g10b10a2_unorm),
    ViewUpgradeAll(b8g8r8a8_unorm_srgb, r10g10b10a2_unorm),
    ViewUpgradeAll(b8g8r8x8_unorm, r10g10b10a2_unorm),
    ViewUpgradeAll(b8g8r8x8_unorm_srgb, r10g10b10a2_unorm),
};

const ResourceViewUpgradeMap VIEW_UPGRADES_R11G11B10_FLOAT = {
    ViewUpgradeAll(r10g10b10a2_typeless, r11g11b10_float),
    ViewUpgradeAll(r8g8b8a8_typeless, r11g11b10_float),
    ViewUpgradeAll(r10g10b10a2_unorm, r11g11b10_float),
    ViewUpgradeAll(b10g10r10a2_unorm, r11g11b10_float),
    ViewUpgradeAll(r8g8b8a8_unorm, r11g11b10_float),
    ViewUpgradeAll(b8g8r8a8_unorm, r11g11b10_float),
    ViewUpgradeAll(r8g8b8a8_unorm_srgb, r11g11b10_float),
    ViewUpgradeAll(b8g8r8a8_unorm_srgb, r11g11b10_float),
    ViewUpgradeAll(b8g8r8x8_unorm, r11g11b10_float),
    ViewUpgradeAll(b8g8r8x8_unorm_srgb, r11g11b10_float),
};

const ResourceViewUpgradeMap VIEW_UPGRADES_R9G9B9E5 = {
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
    ViewUpgradeAll(b8g8r8x8_unorm, r9g9b9e5),
    ViewUpgradeAll(b8g8r8x8_unorm_srgb, r9g9b9e5),
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

  ResourceViewUpgradeMap view_upgrades = VIEW_UPGRADES_RGBA16F;

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

  cross_addon::string name;

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

enum class ResourceUploadSource : uint8_t {
  UNKNOWN = 0u,
  INITIAL_DATA = 1u,
  UPDATE_TEXTURE_REGION = 2u,
};

struct ResourceUploadSignature {
  ResourceUploadSource source = ResourceUploadSource::UNKNOWN;
  uint32_t subresource = 0u;
  uint32_t crc32 = 0u;
  reshade::api::format format = reshade::api::format::unknown;
  uint32_t width = 0u;
  uint32_t height = 0u;
  uint32_t depth_or_layers = 0u;
  uint32_t row_pitch = 0u;
  uint32_t slice_pitch = 0u;
  uint64_t source_size = 0u;
  bool full_update = true;
};

inline const char* ResourceUploadSourceName(ResourceUploadSource source) {
  switch (source) {
    case ResourceUploadSource::INITIAL_DATA:
      return "initial_data";
    case ResourceUploadSource::UPDATE_TEXTURE_REGION:
      return "update_texture_region";
    case ResourceUploadSource::UNKNOWN:
    default:
      return "unknown";
  }
}

struct ResourceInfo {
  reshade::api::device* device = nullptr;
  reshade::api::resource_desc desc;
  reshade::api::resource_desc clone_desc;
  reshade::api::resource_desc fallback_desc;
  reshade::api::resource resource = {0u};
  reshade::api::resource clone = {0u};
  reshade::api::resource fallback = {0u};
  bool destroyed = false;
  bool upgraded = false;
  bool clone_enabled = false;
  bool clone_can_deactivate = false;
  bool is_swap_chain = false;
  bool is_clone = false;
  uint32_t extra_vram = 0;
  ResourceUpgradeInfo* clone_target = nullptr;
  ResourceUpgradeInfo* upgrade_target = nullptr;
  reshade::api::resource_usage initial_state = reshade::api::resource_usage::undefined;
  cross_addon::unordered_set<uint64_t> resource_view_handles;
  float resource_tag = -1;
  reshade::api::resource_view swap_chain_proxy_clone_srv = {0u};
  reshade::api::resource_view swap_chain_proxy_rtv = {0u};
  void* shared_handle = nullptr;
  reshade::api::resource proxy_resource = {0u};
  std::optional<ResourceUploadSignature> initial_upload = std::nullopt;
  std::optional<ResourceUploadSignature> latest_upload = std::nullopt;
};

struct ResourceViewInfo {
  reshade::api::device* device = nullptr;

  reshade::api::resource_view_desc desc;
  reshade::api::resource_view_desc clone_desc;
  reshade::api::resource_view_desc fallback_desc;
  reshade::api::resource_view view = {0u};
  reshade::api::resource_view clone = {0u};
  reshade::api::resource_view fallback = {0u};
  bool destroyed = false;
  bool upgraded = false;
  bool clone_enabled = false;
  bool clone_can_deactivate = false;
  reshade::api::resource original_resource = {0u};
  reshade::api::resource clone_resource = {0u};
  ResourceInfo* resource_info = nullptr;
  ResourceUpgradeInfo* clone_target = nullptr;
  ResourceUpgradeInfo* upgrade_target = nullptr;
  reshade::api::resource_usage usage = reshade::api::resource_usage::undefined;
  bool is_clone = false;
  bool is_swap_chain = false;
};

using ResourceInfoMap = cross_addon::parallel_node_hash_map<uint64_t, ResourceInfo, std::shared_mutex>;
using ResourceViewInfoMap = cross_addon::parallel_node_hash_map<uint64_t, ResourceViewInfo, std::shared_mutex>;

template <typename T>
using TypedCallback = void (*)(T*);

template <typename T>
using CallbackList = cross_addon::vector<TypedCallback<T>>;

using VoidCallback = void (*)();
using VoidCallbackList = cross_addon::vector<VoidCallback>;

struct __declspec(uuid("b5fdfd6a-cb13-4523-a499-e3b5e4759665")) SharedData {
  ResourceInfoMap resource_infos;
  ResourceViewInfoMap resource_view_infos;

  CallbackList<ResourceInfo> on_init_resource_info_callbacks;
  CallbackList<ResourceInfo> on_destroy_resource_info_callbacks;

  CallbackList<ResourceViewInfo> on_init_resource_view_info_callbacks;
  CallbackList<ResourceViewInfo> on_destroy_resource_view_info_callbacks;
  VoidCallbackList on_after_destroy_callbacks;

  bool use_resource_replace = false;
};

static cross_addon::Shared<SharedData> shared;

template <typename Callback>
inline void AddCallback(cross_addon::vector<Callback>& callbacks, Callback callback) {
  assert(callback != nullptr);
  if (callback == nullptr) return;

  if (!std::ranges::any_of(callbacks, [callback](Callback record) {
        return record == callback;
      })) {
    callbacks.push_back(callback);
  }
}

template <typename Callback>
inline void RemoveCallback(cross_addon::vector<Callback>& callbacks, Callback callback) {
  assert(callback != nullptr);
  if (callback == nullptr) return;

  std::erase_if(callbacks, [callback](Callback record) {
    return record == callback;
  });
}

inline void RegisterOnInitResourceInfoCallback(TypedCallback<ResourceInfo> callback) {
  AddCallback(shared.data->on_init_resource_info_callbacks, callback);
}
inline void RegisterOnDestroyResourceInfoCallback(TypedCallback<ResourceInfo> callback) {
  AddCallback(shared.data->on_destroy_resource_info_callbacks, callback);
}
inline void RegisterOnInitResourceViewInfoCallback(TypedCallback<ResourceViewInfo> callback) {
  AddCallback(shared.data->on_init_resource_view_info_callbacks, callback);
}
inline void RegisterOnDestroyResourceViewInfoCallback(TypedCallback<ResourceViewInfo> callback) {
  AddCallback(shared.data->on_destroy_resource_view_info_callbacks, callback);
}
inline void RegisterOnAfterDestroyCallback(VoidCallback callback) {
  AddCallback(shared.data->on_after_destroy_callbacks, callback);
}

inline void UnregisterOnInitResourceInfoCallback(TypedCallback<ResourceInfo> callback) {
  RemoveCallback(shared.data->on_init_resource_info_callbacks, callback);
}
inline void UnregisterOnDestroyResourceInfoCallback(TypedCallback<ResourceInfo> callback) {
  RemoveCallback(shared.data->on_destroy_resource_info_callbacks, callback);
}
inline void UnregisterOnInitResourceViewInfoCallback(TypedCallback<ResourceViewInfo> callback) {
  RemoveCallback(shared.data->on_init_resource_view_info_callbacks, callback);
}
inline void UnregisterOnDestroyResourceViewInfoCallback(TypedCallback<ResourceViewInfo> callback) {
  RemoveCallback(shared.data->on_destroy_resource_view_info_callbacks, callback);
}
inline void UnregisterOnAfterDestroyCallback(VoidCallback callback) {
  RemoveCallback(shared.data->on_after_destroy_callbacks, callback);
}

template <typename T, CallbackList<T> SharedData::* member>
static void DispatchCallbacks(T* value) {
  for (const auto& callback : shared.data->*member) {
    if (callback != nullptr) {
      callback(value);
    }
  }
}

static void DispatchAfterDestroyCallbacks() {
  for (const auto& callback : shared.data->on_after_destroy_callbacks) {
    if (callback != nullptr) {
      callback();
    }
  }
}

[[deprecated("Use GetResourceInfo<F>")]] [[nodiscard]]
inline ResourceInfo* GetResourceInfo(const reshade::api::resource& resource, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = shared.data->resource_infos.try_emplace_p(resource.handle, ResourceInfo({.resource = resource}));
    return &pointer->second;
  }
  ResourceInfo* info = nullptr;
  shared.data->resource_infos.if_contains(resource.handle, [&info](std::pair<const uint64_t, ResourceInfo>& pair) {
    info = &pair.second;
  });
  if (info == nullptr) {
    log::e("utils::resource::GetResourceInfo(Resource not found for handle: ",
           log::AsPtr(resource.handle), ")");
    assert(info != nullptr);
  }
  return info;
}

[[deprecated("Use GetResourceInfo<F> or UpdateResourceInfo<F>")]] [[nodiscard]]
inline ResourceInfo* GetResourceInfoUnsafe(const reshade::api::resource& resource, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = shared.data->resource_infos.try_emplace_p(resource.handle, ResourceInfo({.resource = resource}));
    return &pointer->second;
  }
  ResourceInfo* data = nullptr;
  shared.data->resource_infos.if_contains_unsafe(resource.handle, [&data](std::pair<const uint64_t, ResourceInfo>& pair) {
    data = &pair.second;
  });
  if (data == nullptr) {
    log::e("utils::resource::GetResourceInfoUnsafe(Resource not found for handle: ",
           log::AsPtr(resource.handle), ")");
    assert(data != nullptr);
  }

  return data;
}

template <typename F>
inline bool GetResourceInfo(const reshade::api::resource& resource, F&& f) {
  assert(resource.handle != 0u && "Cannot get ResourceInfo for a resource with null handle.");

  return shared.data->resource_infos.if_contains(resource.handle, [&f](const std::pair<const uint64_t, ResourceInfo>& pair) {
    std::forward<F>(f)(pair.second);
  });
}

template <typename F>
inline bool GetLiveResourceInfo(const reshade::api::resource& resource, F&& f) {
  assert(resource.handle != 0u && "Cannot get ResourceInfo for a resource with null handle.");

  bool found_live = false;
  shared.data->resource_infos.if_contains(resource.handle, [&f, &found_live](const std::pair<const uint64_t, ResourceInfo>& pair) {
    if (pair.second.destroyed) return;
    found_live = true;
    std::forward<F>(f)(pair.second);
  });
  return found_live;
}

template <typename F>
inline bool UpdateResourceInfo(const reshade::api::resource& resource, F&& f) {
  assert(resource.handle != 0u && "Cannot update ResourceInfo for a resource with null handle.");

  return shared.data->resource_infos.modify_if(resource.handle, [&f](std::pair<const uint64_t, ResourceInfo>& pair) {
    std::forward<F>(f)(&pair.second);
  });
}

template <typename F>
inline bool UpsertResourceInfo(const reshade::api::resource& resource, F&& f) {
  assert(resource.handle != 0u && "Cannot upsert ResourceInfo for a resource with null handle.");

  return shared.data->resource_infos.lazy_emplace_l(
      resource.handle,
      [&](std::pair<const uint64_t, ResourceInfo>& pair) {
        std::forward<F>(f)(&pair.second, false);
      },
      [&](const ResourceInfoMap::constructor& ctor) {
        ResourceInfo data = {.resource = resource};
        std::forward<F>(f)(&data, true);
        ctor(resource.handle, data);
      });
}

[[deprecated("Use GetResourceViewInfo<F>")]] [[nodiscard]]
inline ResourceViewInfo* GetResourceViewInfo(const reshade::api::resource_view& view, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = shared.data->resource_view_infos.try_emplace_p(view.handle, ResourceViewInfo({.view = view}));
    return &pointer->second;
  }
  ResourceViewInfo* data = nullptr;
  shared.data->resource_view_infos.if_contains(view.handle, [&data](std::pair<const uint64_t, ResourceViewInfo>& pair) {
    data = &pair.second;
  });
  if (data == nullptr) {
    log::e("utils::resource::GetResourceViewInfo(Resource view not found for handle: ",
           log::AsPtr(view.handle), ")");
    assert(data != nullptr);
  }
  return data;
}

[[deprecated("Use GetResourceViewInfo<F>")]] [[nodiscard]]
inline ResourceViewInfo* GetResourceViewInfoUnsafe(const reshade::api::resource_view& view, const bool& create = false) {
  if (create) {
    auto [pointer, inserted] = shared.data->resource_view_infos.try_emplace_p(view.handle, ResourceViewInfo({.view = view}));
    return &pointer->second;
  }
  ResourceViewInfo* data = nullptr;
  shared.data->resource_view_infos.if_contains_unsafe(view.handle, [&data](std::pair<const uint64_t, ResourceViewInfo>& pair) {
    data = &pair.second;
  });
  if (data == nullptr) {
    log::e("utils::resource::GetResourceViewInfoUnsafe(Resource view not found for handle: ",
           log::AsPtr(view.handle), ")");
    assert(data != nullptr);
  }
  return data;
}

template <typename F>
inline bool GetResourceViewInfo(const reshade::api::resource_view& view, F&& f) {
  assert(view.handle != 0u && "Cannot get ResourceViewInfo for a view with null handle.");

  return shared.data->resource_view_infos.if_contains(view.handle, [&f](const std::pair<const uint64_t, ResourceViewInfo>& pair) {
    std::forward<F>(f)(pair.second);
  });
}

template <typename F>
inline bool GetLiveResourceViewInfo(const reshade::api::resource_view& view, F&& f) {
  assert(view.handle != 0u && "Cannot get ResourceViewInfo for a view with null handle.");

  bool found_live = false;
  shared.data->resource_view_infos.if_contains(view.handle, [&f, &found_live](const std::pair<const uint64_t, ResourceViewInfo>& pair) {
    if (pair.second.destroyed) return;
    found_live = true;
    std::forward<F>(f)(pair.second);
  });
  return found_live;
}

template <typename F>
inline bool UpdateResourceViewInfo(const reshade::api::resource_view& view, F&& f) {
  assert(view.handle != 0u && "Cannot update ResourceViewInfo for a view with null handle.");

  return shared.data->resource_view_infos.modify_if(view.handle, [&f](std::pair<const uint64_t, ResourceViewInfo>& pair) {
    std::forward<F>(f)(&pair.second);
  });
}

inline reshade::api::resource_desc GetResourceDesc(
    const reshade::api::device* device,
    const reshade::api::resource& resource) {
  if (device == nullptr || resource.handle == 0u) return {};

  switch (device->get_api()) {
    case reshade::api::device_api::opengl: {
      reshade::api::resource_desc desc = {};
      bool found = false;
      GetResourceInfo(resource, [&desc, &found](const ResourceInfo& resource_info) {
        if (resource_info.destroyed) return;
        desc = resource_info.desc;
        found = desc.type != reshade::api::resource_type::unknown;
      });
      if (found) {
        return desc;
      }
      break;
    }
    default:
      break;
  }

  return device->get_resource_desc(resource);
}

inline reshade::api::resource_view_desc GetResourceViewDesc(
    const reshade::api::device* device,
    const reshade::api::resource_view& view) {
  if (device == nullptr || view.handle == 0u) return {};

  switch (device->get_api()) {
    case reshade::api::device_api::d3d12:
    case reshade::api::device_api::opengl: {
      reshade::api::resource_view_desc desc = {};
      bool found = false;
      GetResourceViewInfo(view, [&desc, &found](const ResourceViewInfo& resource_view_info) {
        if (resource_view_info.destroyed) return;
        desc = resource_view_info.desc;
        found = desc.type != reshade::api::resource_view_type::unknown;
      });
      if (found) {
        return desc;
      }
      break;
    }
    default:
      break;
  }

  return device->get_resource_view_desc(view);
}

inline reshade::api::resource GetResourceFromView(
    const reshade::api::device* device,
    const reshade::api::resource_view& view) {
  if (device == nullptr || view.handle == 0u) return {0u};

  switch (device->get_api()) {
    case reshade::api::device_api::d3d12: {
      reshade::api::resource resource = {0u};
      bool destroyed = true;
      const auto found = GetResourceViewInfo(view, [&resource, &destroyed](const ResourceViewInfo& resource_view_info) {
        destroyed = resource_view_info.destroyed;
        if (destroyed) return;
        resource = resource_view_info.original_resource;
      });
      if (found && !destroyed) {
        return resource;
      }
    }
    default:
      break;
  }

  return device->get_resource_from_view(view);
}

template <typename F>
inline bool UpsertResourceViewInfo(const reshade::api::resource_view& view, F&& f) {
  assert(view.handle != 0u && "Cannot upsert ResourceViewInfo for a view with null handle.");

  return shared.data->resource_view_infos.lazy_emplace_l(
      view.handle,
      [&](std::pair<const uint64_t, ResourceViewInfo>& pair) {
        std::forward<F>(f)(&pair.second, false);
      },
      [&](const ResourceViewInfoMap::constructor& ctor) {
        ResourceViewInfo data = {.view = view};
        std::forward<F>(f)(&data, true);
        ctor(view.handle, data);
      });
}

template <typename F>
inline void ForEachResourceInfo(F&& f) {
  shared.data->resource_infos.for_each([&f](const std::pair<const uint64_t, ResourceInfo>& pair) {
    std::forward<F>(f)(pair.second);
  });
}

template <typename F>
inline void ForEachResourceViewInfo(F&& f) {
  shared.data->resource_view_infos.for_each([&f](const std::pair<const uint64_t, ResourceViewInfo>& pair) {
    std::forward<F>(f)(pair.second);
  });
}

// Insert a ResourceViewInfo entry, or reuse an existing one. When reusing,
// optionally assert that the existing entry was destroyed.
[[deprecated("Use UpsertResourceViewInfo<F>")]]
inline std::pair<ResourceViewInfo*, bool> EmplaceResourceViewInfoOrReuse(
    const reshade::api::resource_view& view,
    const ResourceViewInfo& info,
    const bool require_destroyed) {
  auto [it, inserted] = shared.data->resource_view_infos.try_emplace_p(view.handle, info);
  if (!inserted) {
    if (require_destroyed) {
      assert(it->second.destroyed && "ResourceViewInfo reused but it was not destroyed.");
    }
    it->second = info;
  }
  return {&it->second, inserted};
}

inline void RegisterSwapchainInitialized(reshade::api::swapchain* swapchain, bool resize) {
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
    bool inserted = false;
    bool was_destroyed = false;
    bool should_run_after_destroy_callbacks = false;
    UpsertResourceInfo(resource, [&](ResourceInfo* info, const bool was_inserted) {
      inserted = was_inserted;
      if (!was_inserted) {
        assert(info->resource.handle == resource.handle);
        was_destroyed = info->destroyed;
        if (!info->destroyed) {
          DispatchCallbacks<ResourceInfo, &SharedData::on_destroy_resource_info_callbacks>(info);
          should_run_after_destroy_callbacks = true;
        }
      }

      *info = new_info;
      DispatchCallbacks<ResourceInfo, &SharedData::on_init_resource_info_callbacks>(info);
    });
    if (should_run_after_destroy_callbacks) {
      DispatchAfterDestroyCallbacks();
    }

#ifdef DEBUG_LEVEL_2
    {
      std::stringstream s;
      s << "utils::resource::RegisterSwapchainInitialized(";
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
  }
}

inline void RegisterSwapchainDestroyed(reshade::api::swapchain* swapchain, bool resize) {
  const size_t back_buffer_count = swapchain->get_back_buffer_count();

  for (uint32_t index = 0; index < back_buffer_count; ++index) {
    auto buffer = swapchain->get_back_buffer(index);
    bool should_run_after_destroy_callbacks = false;
    const auto found = UpdateResourceInfo(buffer, [&](ResourceInfo* info) {
      if (info->device == nullptr) {
        info->device = swapchain->get_device();
      }
      info->destroyed = true;
      DispatchCallbacks<ResourceInfo, &SharedData::on_destroy_resource_info_callbacks>(info);
      should_run_after_destroy_callbacks = true;
    });
    if (!found) {
      assert(found);
      continue;
    }
    if (should_run_after_destroy_callbacks) {
      DispatchAfterDestroyCallbacks();
    }
  }
}

template <typename F>
inline std::invoke_result_t<F&&> RegisterSwapchainChange(reshade::api::swapchain* swapchain, F&& change) {
  using Result = std::invoke_result_t<F&&>;

  RegisterSwapchainDestroyed(swapchain, true);
  if constexpr (std::is_void_v<Result>) {
    std::forward<F>(change)();
    RegisterSwapchainInitialized(swapchain, true);
  } else {
    auto result = std::forward<F>(change)();
    RegisterSwapchainInitialized(swapchain, true);
    return result;
  }
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  RegisterSwapchainInitialized(swapchain, resize);
}

static void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  RegisterSwapchainDestroyed(swapchain, resize);
}

inline bool IsUploadSignatureTrackable(const reshade::api::resource_desc& desc) {
  if (desc.type != reshade::api::resource_type::texture_2d) return false;
  if (desc.texture.width == 0u || desc.texture.height == 0u) return false;
  return true;
}

inline bool IsFullSubresourceUpdate(
    const reshade::api::resource_desc& desc,
    uint32_t subresource,
    const reshade::api::subresource_box* box) {
  if (box == nullptr) return true;
  if (!IsUploadSignatureTrackable(desc)) return false;

  const auto levels = std::max<uint32_t>(desc.texture.levels, 1u);
  const auto level = subresource % levels;
  const auto width = std::max<uint32_t>(desc.texture.width >> level, 1u);
  const auto height = std::max<uint32_t>(desc.texture.height >> level, 1u);
  const auto depth = 1u;

  return static_cast<uint32_t>(box->left) == 0u
         && static_cast<uint32_t>(box->top) == 0u
         && static_cast<uint32_t>(box->front) == 0u
         && static_cast<uint32_t>(box->right - box->left) == width
         && static_cast<uint32_t>(box->bottom - box->top) == height
         && static_cast<uint32_t>(box->back - box->front) == depth;
}

inline std::optional<ResourceUploadSignature> BuildUploadSignature(
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data& data,
    uint32_t subresource,
    ResourceUploadSource source,
    bool full_update = true) {
  if (!IsUploadSignatureTrackable(desc)) return std::nullopt;
  if (data.data == nullptr) return std::nullopt;
  // ReShade does not provide the source byte size for update_texture_region.
  // For partial boxes, deriving it from the destination resource can over-read
  // the caller's upload pointer, so only signature-track complete subresources.
  if (!full_update) return std::nullopt;

  const auto levels = std::max<uint32_t>(desc.texture.levels, 1u);
  const auto level = subresource % levels;
  const auto width = std::max<uint32_t>(desc.texture.width >> level, 1u);
  const auto height = std::max<uint32_t>(desc.texture.height >> level, 1u);
  const auto depth_or_layers = 1u;
  const auto row_pitch = data.row_pitch != 0u
                             ? data.row_pitch
                             : reshade::api::format_row_pitch(desc.texture.format, width);
  const auto slice_pitch = data.slice_pitch != 0u
                               ? data.slice_pitch
                               : reshade::api::format_slice_pitch(desc.texture.format, row_pitch, height);
  if (slice_pitch == 0u) return std::nullopt;

  return ResourceUploadSignature{
      .source = source,
      .subresource = subresource,
      .crc32 = utils::hash::ComputeCRC32(static_cast<const uint8_t*>(data.data), slice_pitch),
      .format = desc.texture.format,
      .width = width,
      .height = height,
      .depth_or_layers = depth_or_layers,
      .row_pitch = row_pitch,
      .slice_pitch = slice_pitch,
      .source_size = slice_pitch,
      .full_update = full_update,
  };
}

inline void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (resource.handle == 0) return;

  bool inserted = false;
  bool was_destroyed = false;
  bool should_run_after_destroy_callbacks = false;
  ResourceInfo new_data = {
      .device = device,
      .desc = desc,
      .resource = resource,
      .destroyed = false,
      .initial_state = initial_state,
  };
  if (shared.data->use_resource_replace && initial_data != nullptr) {
    const auto upload_signature = BuildUploadSignature(desc, initial_data[0], 0u, ResourceUploadSource::INITIAL_DATA, true);
    if (upload_signature.has_value()) {
      new_data.initial_upload = upload_signature;
      new_data.latest_upload = upload_signature;
    }
  }
  UpsertResourceInfo(resource, [&](ResourceInfo* info, const bool was_inserted) {
    inserted = was_inserted;
    if (!was_inserted) {
      assert(info->resource.handle == resource.handle);
      was_destroyed = info->destroyed;
      if (!info->destroyed) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::OnInitResource(Resource reused: ";
        s << static_cast<uintptr_t>(resource.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        DispatchCallbacks<ResourceInfo, &SharedData::on_destroy_resource_info_callbacks>(info);
        should_run_after_destroy_callbacks = true;
      }
    }
    *info = new_data;

    DispatchCallbacks<ResourceInfo, &SharedData::on_init_resource_info_callbacks>(info);
  });
  if (should_run_after_destroy_callbacks) {
    DispatchAfterDestroyCallbacks();
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
}

inline bool OnUpdateTextureRegion(
    reshade::api::device* device,
    const reshade::api::subresource_data& data,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  if (dest.handle == 0u) return false;
  if (!shared.data->use_resource_replace) return false;

  std::optional<ResourceUploadSignature> signature = std::nullopt;
  const auto found = GetResourceInfo(dest, [&device, &data, dest_subresource, dest_box, &signature](const ResourceInfo& resource_info) {
    if (resource_info.destroyed) return;
    if (resource_info.device != device) return;

    signature = BuildUploadSignature(
        resource_info.desc,
        data,
        dest_subresource,
        ResourceUploadSource::UPDATE_TEXTURE_REGION,
        IsFullSubresourceUpdate(resource_info.desc, dest_subresource, dest_box));
  });
  if (!found || !signature.has_value()) return false;

  shared.data->resource_infos.modify_if(dest.handle, [&device, &signature](std::pair<const uint64_t, ResourceInfo>& pair) {
    if (pair.second.destroyed) return;
    if (pair.second.device != device) return;
    pair.second.latest_upload = signature;
  });
  return false;
}

// NOLINTNEXTLINE(misc-no-recursion)
inline void OnDestroyResource(reshade::api::device* device, reshade::api::resource resource) {
  if (resource.handle == 0) return;

  bool should_run_after_destroy_callbacks = false;
  const auto found = UpdateResourceInfo(resource, [&](ResourceInfo* resource_info) {
    if (resource_info->destroyed) {
#ifdef DEBUG_LEVEL_0
      if (resource_info->is_swap_chain) {
        log::w("utils::resource::OnDestroyResource(Swap chain resource already destroyed: ",
               log::AsPtr(resource.handle), ")");
      } else {
        log::w("utils::resource::OnDestroyResource(Resource already destroyed: ",
               log::AsPtr(resource.handle), ")");

        assert(!resource_info->destroyed);
      }
#endif
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
      return;
    }

    // resource_info->device = device;
    resource_info->destroyed = true;
    DispatchCallbacks<ResourceInfo, &SharedData::on_destroy_resource_info_callbacks>(resource_info);
    should_run_after_destroy_callbacks = true;
  });
  if (!found) {
    log::e("utils::resource::OnDestroyResource(Resource not found for handle: ",
           log::AsPtr(resource.handle), ")");
    assert(found);
    return;
  }
  if (should_run_after_destroy_callbacks) {
    DispatchAfterDestroyCallbacks();
  }
}

inline reshade::api::resource_view_desc PopulateUnknownResourceViewDesc(
    const reshade::api::device* device,
    const reshade::api::resource_view_desc& desc,
    const reshade::api::resource_usage usage_type,
    const reshade::api::resource_desc& resource_desc) {
  reshade::api::resource_view_desc new_desc = desc;
  switch (device->get_api()) {
    case reshade::api::device_api::d3d9:
      // DX9 will always be unknown. Games may used special Nvidia types or 'NULL'
      return new_desc;
    case reshade::api::device_api::d3d10:
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
      switch (resource_desc.type) {
        case reshade::api::resource_type::buffer:
          new_desc.type = reshade::api::resource_view_type::buffer;
          new_desc.format = reshade::api::format::unknown;
          break;
        case reshade::api::resource_type::texture_1d:
          if (resource_desc.texture.depth_or_layers > 1) {
            new_desc.type = reshade::api::resource_view_type::texture_1d_array;
          } else {
            new_desc.type = reshade::api::resource_view_type::texture_1d;
          }
          new_desc.texture.level_count = UINT32_MAX;
          new_desc.texture.layer_count = resource_desc.texture.depth_or_layers;
          new_desc.format = resource_desc.texture.format;
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
          new_desc.texture.layer_count = resource_desc.texture.depth_or_layers;
          if (resource_desc.texture.depth_or_layers > 1) {
            if (resource_desc.texture.samples > 1) {
              new_desc.type = reshade::api::resource_view_type::texture_2d_multisample_array;
            } else if (renodx::utils::bitwise::HasFlag(resource_desc.flags, reshade::api::resource_flags::cube_compatible)) {
              new_desc.type = reshade::api::resource_view_type::texture_cube_array;
            } else {
              new_desc.type = reshade::api::resource_view_type::texture_2d_array;
            }
          } else if (resource_desc.texture.samples > 1) {
            new_desc.type = reshade::api::resource_view_type::texture_2d_multisample;
          } else if (renodx::utils::bitwise::HasFlag(resource_desc.flags, reshade::api::resource_flags::cube_compatible)) {
            new_desc.type = reshade::api::resource_view_type::texture_cube;
          } else {
            new_desc.type = reshade::api::resource_view_type::texture_2d;
          }
          new_desc.format = resource_desc.texture.format;
          break;
        case reshade::api::resource_type::texture_3d:
          new_desc.type = reshade::api::resource_view_type::texture_3d;
          new_desc.format = resource_desc.texture.format;
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

[[deprecated("Use PopulateUnknownResourceViewDesc(device, desc, usage_type, resource_desc) instead.")]]
inline reshade::api::resource_view_desc PopulateUnknownResourceViewDesc(
    reshade::api::device* device,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_usage usage_type,
    const ResourceInfo* resource_info) {
  if (resource_info == nullptr) {
    assert(resource_info != nullptr);
    return desc;
  }
  return PopulateUnknownResourceViewDesc(device, desc, usage_type, resource_info->desc);
}

inline void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (view.handle == 0u) return;

  ResourceViewInfo new_data = {
      .device = device,
      .desc = desc,
      .view = view,
      .original_resource = resource,
      .usage = usage_type,
  };
  reshade::api::resource_desc populated_resource_desc = {};
  bool has_populated_resource_desc = false;

  if (resource.handle != 0u) {
    const auto found = UpdateResourceInfo(resource, [&](ResourceInfo* resource_info) {
      resource_info->resource_view_handles.insert(view.handle);
      new_data.resource_info = resource_info;
      new_data.clone_target = resource_info->clone_target;
      new_data.clone_enabled = resource_info->clone_enabled;
      new_data.clone_can_deactivate = resource_info->clone_can_deactivate;
      new_data.is_swap_chain = resource_info->is_swap_chain;
      populated_resource_desc = resource_info->desc;
      has_populated_resource_desc = true;
    });
    if (!found || !has_populated_resource_desc) {
      populated_resource_desc = device->get_resource_desc(resource);
      has_populated_resource_desc = true;
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::resource::OnInitResourceView(Resource missing during view init: ";
      s << PRINT_PTR(view.handle);
      s << ", resource: ";
      s << PRINT_PTR(resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    }
  }

  if (desc.type == reshade::api::resource_view_type::unknown
      || (desc.format == reshade::api::format::unknown
          && desc.type != reshade::api::resource_view_type::buffer
          && desc.type != reshade::api::resource_view_type::acceleration_structure)) {
    if (!has_populated_resource_desc) {
      assert(resource.handle != 0u);
    } else {
      new_data.desc = PopulateUnknownResourceViewDesc(device, desc, usage_type, populated_resource_desc);
    }
  }

  bool inserted = false;
  bool was_destroyed = false;
  bool should_run_after_destroy_callbacks = false;
  UpsertResourceViewInfo(view, [&](ResourceViewInfo* info, const bool was_inserted) {
    inserted = was_inserted;
    if (!was_inserted) {
      assert(info->view.handle == view.handle);
      was_destroyed = info->destroyed;
      if (!info->destroyed) {
#ifdef DEBUG_LEVEL_2
        std::stringstream s;
        s << "utils::resource::OnInitResourceView(Resource view reused: ";
        s << PRINT_PTR(view.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
        DispatchCallbacks<ResourceViewInfo, &SharedData::on_destroy_resource_view_info_callbacks>(info);
        should_run_after_destroy_callbacks = true;
      }
    }

    *info = new_data;
    DispatchCallbacks<ResourceViewInfo, &SharedData::on_init_resource_view_info_callbacks>(info);
  });
  if (should_run_after_destroy_callbacks) {
    DispatchAfterDestroyCallbacks();
  }
}

inline void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  if (view.handle == 0u) return;

  bool should_run_after_destroy_callbacks = false;
  reshade::api::resource original_resource = {0u};
  const auto found = UpdateResourceViewInfo(view, [&](ResourceViewInfo* resource_view_info) {
    if (resource_view_info->destroyed) {
      log::w("utils::resource::OnDestroyResourceView(Resource view already destroyed: ",
             log::AsPtr(view.handle), ")");
      return;
    }

    if (resource_view_info->device == nullptr) {
      resource_view_info->device = device;
    }
    original_resource = resource_view_info->original_resource;
    resource_view_info->destroyed = true;
    DispatchCallbacks<ResourceViewInfo, &SharedData::on_destroy_resource_view_info_callbacks>(resource_view_info);
    should_run_after_destroy_callbacks = true;
    assert(resource_view_info->view.handle != 0u);
  });
  if (!found) {
    log::e("utils::resource::OnDestroyResourceView(Resource view not found for handle: ",
           log::AsPtr(view.handle), ")");
    assert(found);
    return;
  }
  if (original_resource.handle != 0u) {
    UpdateResourceInfo(original_resource, [&](ResourceInfo* resource_info) {
      resource_info->resource_view_handles.erase(view.handle);
    });
  }
  if (should_run_after_destroy_callbacks) {
    DispatchAfterDestroyCallbacks();
  }
}

static float GetResourceTag(const reshade::api::resource& resource) {
  float resource_tag = -1.f;
  GetResourceInfo(resource, [&resource_tag](const ResourceInfo& resource_info) {
    resource_tag = resource_info.resource_tag;
  });
  return resource_tag;
}

static float GetResourceTag(const reshade::api::resource_view& resource_view) {
  reshade::api::resource original_resource = {0u};
  bool destroyed = false;
  const auto found_resource_view_info = GetResourceViewInfo(resource_view, [&original_resource, &destroyed](const ResourceViewInfo& resource_view_info) {
    original_resource = resource_view_info.original_resource;
    destroyed = resource_view_info.destroyed;
  });
  if (!found_resource_view_info || destroyed) return -1;
  float resource_tag = -1.f;
  GetResourceInfo(original_resource, [&resource_tag](const ResourceInfo& resource_info) {
    if (resource_info.destroyed) return;
    resource_tag = resource_info.resource_tag;
  });
  return resource_tag;
}

inline std::optional<ResourceUploadSignature> GetInitialUploadSignature(const reshade::api::resource& resource) {
  std::optional<ResourceUploadSignature> signature = std::nullopt;
  GetResourceInfo(resource, [&signature](const ResourceInfo& resource_info) {
    if (resource_info.destroyed) return;
    signature = resource_info.initial_upload;
  });
  return signature;
}

inline std::optional<ResourceUploadSignature> GetLatestUploadSignature(const reshade::api::resource& resource) {
  std::optional<ResourceUploadSignature> signature = std::nullopt;
  GetResourceInfo(resource, [&signature](const ResourceInfo& resource_info) {
    if (resource_info.destroyed) return;
    signature = resource_info.latest_upload;
  });
  return signature;
}

inline std::optional<ResourceUploadSignature> GetInitialUploadSignature(const reshade::api::resource_view& resource_view) {
  reshade::api::resource original_resource = {0u};
  bool destroyed = false;
  const auto found_resource_view_info = GetResourceViewInfo(resource_view, [&original_resource, &destroyed](const ResourceViewInfo& resource_view_info) {
    original_resource = resource_view_info.original_resource;
    destroyed = resource_view_info.destroyed;
  });
  if (!found_resource_view_info || destroyed) {
    return std::nullopt;
  }
  std::optional<ResourceUploadSignature> signature = std::nullopt;
  GetResourceInfo(original_resource, [&signature](const ResourceInfo& resource_info) {
    if (resource_info.destroyed) return;
    signature = resource_info.initial_upload;
  });
  return signature;
}

inline std::optional<ResourceUploadSignature> GetLatestUploadSignature(const reshade::api::resource_view& resource_view) {
  reshade::api::resource original_resource = {0u};
  bool destroyed = false;
  const auto found_resource_view_info = GetResourceViewInfo(resource_view, [&original_resource, &destroyed](const ResourceViewInfo& resource_view_info) {
    original_resource = resource_view_info.original_resource;
    destroyed = resource_view_info.destroyed;
  });
  if (!found_resource_view_info || destroyed) {
    return std::nullopt;
  }
  std::optional<ResourceUploadSignature> signature = std::nullopt;
  GetResourceInfo(original_resource, [&signature](const ResourceInfo& resource_info) {
    if (resource_info.destroyed) return;
    signature = resource_info.latest_upload;
  });
  return signature;
}

static bool IsKnownResourceView(const reshade::api::resource_view& view) {
  if (view.handle == 0u) return false;
  bool destroyed = true;
  const auto found = GetResourceViewInfo(view, [&destroyed](const ResourceViewInfo& resource_view_info) {
    destroyed = resource_view_info.destroyed;
  });
  return found && !destroyed;
}

[[deprecated("Use GetResourceFromView(device, view) instead.")]]
inline reshade::api::resource GetResourceFromView(const reshade::api::resource_view& view) {
  if (view.handle == 0u) return {0};
  reshade::api::resource original_resource = {0u};
  bool destroyed = false;
  const auto found = GetResourceViewInfo(view, [&original_resource, &destroyed](const ResourceViewInfo& resource_view_info) {
    original_resource = resource_view_info.original_resource;
    destroyed = resource_view_info.destroyed;
  });
  if (!found || destroyed) return {0u};
  return original_resource;
}

static bool IsResourceViewEmpty(reshade::api::device* device, const reshade::api::resource_view& view) {
  if (view.handle == 0u) return true;
  reshade::api::resource original_resource = {0u};
  bool destroyed = false;
  const auto found = GetResourceViewInfo(view, [&original_resource, &destroyed](const ResourceViewInfo& resource_view_info) {
    original_resource = resource_view_info.original_resource;
    destroyed = resource_view_info.destroyed;
  });
  if (!found || destroyed) return true;
  return original_resource.handle == 0u;
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
    case reshade::api::format::r32_typeless:
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
    case reshade::api::format::r16g16b16a16_typeless:
    case reshade::api::format::r16g16b16a16_uint:
    case reshade::api::format::r16g16b16a16_sint:
    case reshade::api::format::r32g32_typeless:
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

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      const bool registered = shared.RegisterModule([](SharedData& data) {
        data.use_resource_replace = data.use_resource_replace || use_resource_replace;
      });
      shared.RegisterEvent<reshade::addon_event::update_texture_region>(OnUpdateTextureRegion, use_resource_replace);

      if (registered) {
        reshade::log::message(reshade::log::level::info, "ResourceUtil attached.");
      }

      shared.RegisterEvent<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      shared.RegisterEvent<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      shared.RegisterEvent<reshade::addon_event::init_resource>(OnInitResource);
      shared.RegisterEvent<reshade::addon_event::destroy_resource>(OnDestroyResource);
      shared.RegisterEvent<reshade::addon_event::init_resource_view>(OnInitResourceView);
      shared.RegisterEvent<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
      break;
    }

    case DLL_PROCESS_DETACH:
      shared.UnregisterEvent<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      shared.UnregisterEvent<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      shared.UnregisterEvent<reshade::addon_event::init_resource>(OnInitResource);
      shared.UnregisterEvent<reshade::addon_event::update_texture_region>(OnUpdateTextureRegion);
      shared.UnregisterEvent<reshade::addon_event::destroy_resource>(OnDestroyResource);
      shared.UnregisterEvent<reshade::addon_event::init_resource_view>(OnInitResourceView);
      shared.UnregisterEvent<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
      shared.UnregisterModule();
      break;
  }
}
}  // namespace renodx::utils::resource
