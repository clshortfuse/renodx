#pragma once

#include <d3d12.h>
#include <windows.h>

#include <atomic>
#include <cstdint>
#include <functional>
#include <include/reshade.hpp>
#include <optional>
#include <set>
#include <shared_mutex>
#include <sstream>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <vector>

#include "./command_action.hpp"
#include "./cross_addon.hpp"
#include "./data.hpp"
#include "./descriptor.hpp"
#include "./log.hpp"
#include "./resource.hpp"
#include "./swapchain.hpp"

namespace renodx::utils::resource::upgrade {

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

struct __declspec(uuid("72c2182f-dbf5-42b6-a4d5-ee8de408402d")) DeviceData {
  std::shared_mutex mutex;
  std::vector<renodx::utils::resource::ResourceUpgradeInfo> upgrade_infos;
  std::vector<std::atomic<uint32_t>> upgrade_counts;
  std::vector<std::atomic<bool>> upgrade_completed;
  reshade::api::resource_desc back_buffer_desc;
  std::atomic<bool> resource_upgrade_finished = false;
  std::unordered_map<uint64_t, std::unordered_map<uint32_t, HeapDescriptorInfo*>> heap_descriptor_infos;
};

struct __declspec(uuid("0a2b51ad-ef13-4010-81a4-37a4a0f857a6")) CommandListData {
  std::vector<BoundDescriptorInfo> unbound_descriptors;
  std::vector<PushDescriptorInfo> unpushed_updates;
  uint8_t pass_count = 0;
  std::vector<reshade::api::render_pass_render_target_desc> pending_render_pass_render_targets;
  std::optional<reshade::api::render_pass_depth_stencil_desc> pending_render_pass_depth_stencil;
};

struct __declspec(uuid("1d1ad3fa-98f4-4496-9a3d-1da0104d62ab")) SharedData {
  bool use_resource_cloning = false;
  bool use_auto_cloning = false;
  renodx::utils::resource::ResourceUpgradeInfo auto_upgrade_target = {
      .new_format = reshade::api::format::r16g16b16a16_float,
      .use_resource_view_cloning_and_upgrade = true,
  };
};

struct ResourceCloneOptions {
  bool require_enabled = true;
  bool allow_create = true;
  bool activate = false;
};

using ResourceViewCloneOptions = ResourceCloneOptions;

static cross_addon::Shared<SharedData> shared;

static bool use_resource_cloning = false;
static bool use_resource_cloning_dx12_only = false;
static bool use_auto_cloning = false;
static renodx::utils::resource::ResourceUpgradeInfo auto_upgrade_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .use_resource_view_cloning_and_upgrade = true,
};

static thread_local renodx::utils::resource::ResourceUpgradeInfo* local_applied_target = nullptr;
static thread_local std::optional<reshade::api::swapchain_desc> upgraded_swapchain_desc;
static thread_local std::optional<reshade::api::resource> local_original_resource;
static thread_local std::optional<reshade::api::resource_desc> local_original_resource_desc;
static thread_local std::optional<reshade::api::resource_view_desc> local_original_resource_view_desc;


static thread_local std::optional<ResourceViewInfo> pending_dx12_clone_resource_view_info;

template <typename ViewHandles>
inline void UpdateResourceViewsCloneState(
    const ViewHandles& view_handles,
    const bool enabled,
    const bool can_deactivate,
    utils::resource::ResourceUpgradeInfo* clone_target = nullptr) {
  for (const auto view_handle : view_handles) {
    if (view_handle == 0u) continue;
    utils::resource::UpdateResourceViewInfo({view_handle}, [enabled, can_deactivate, clone_target](utils::resource::ResourceViewInfo* view_info) {
      if (view_info->destroyed || view_info->is_clone) return;
      view_info->clone_enabled = enabled;
      view_info->clone_can_deactivate = can_deactivate;
      if (clone_target != nullptr) {
        view_info->clone_target = clone_target;
      }
    });
  }
}

struct PendingResourceDestroyKey {
  reshade::api::device* device;
  reshade::api::resource resource;

  bool operator<(const PendingResourceDestroyKey& other) const {
    if (std::less<reshade::api::device*>{}(device, other.device)) return true;
    if (std::less<reshade::api::device*>{}(other.device, device)) return false;
    return resource.handle < other.resource.handle;
  }
};

struct PendingResourceViewDestroyKey {
  reshade::api::device* device;
  reshade::api::resource_view view;

  bool operator<(const PendingResourceViewDestroyKey& other) const {
    if (std::less<reshade::api::device*>{}(device, other.device)) return true;
    if (std::less<reshade::api::device*>{}(other.device, device)) return false;
    return view.handle < other.view.handle;
  }
};

static thread_local std::set<PendingResourceDestroyKey> pending_resource_destroys;
static thread_local std::set<PendingResourceViewDestroyKey> pending_resource_view_destroys;
static thread_local std::vector<uint64_t> pending_resource_view_clone_states;

static bool CanDestroyResourcesForDevice(const reshade::api::device* device) {
  if (device == nullptr) return false;
  if (device->get_api() != reshade::api::device_api::opengl) return true;

  // Some OpenGL games destroy the ReShade runtime after clearing and deleting
  // the current context. Do not call into the OpenGL driver to release cloned
  // resources in that state; the context teardown owns those objects already.
  return false;
}

inline bool ActivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  if (resource_view.handle == 0u) return false;
  const auto resource = utils::resource::GetResourceFromView(device, resource_view);
  if (resource.handle == 0u) {
    std::stringstream s;
    s << "utils::resource::upgrade::ActivateCloneHotSwap(no handle for view ";
    s << PRINT_PTR(resource_view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }

  bool clone_enabled = false;
  bool has_clone_target = false;
  bool can_hot_swap = false;
#ifdef DEBUG_LEVEL_1
  bool is_swap_chain = false;
  reshade::api::resource tracked_resource = resource;
#endif
  const auto found_resource_info = utils::resource::GetResourceInfo(resource, [&](const utils::resource::ResourceInfo& info) {
    clone_enabled = info.clone_enabled;
    has_clone_target = info.clone_target != nullptr;
    can_hot_swap = info.clone_target != nullptr && info.clone_target->use_resource_view_hot_swap;
#ifdef DEBUG_LEVEL_1
    is_swap_chain = info.is_swap_chain;
    tracked_resource = info.resource;
#endif
  });
  if (!found_resource_info || clone_enabled) return false;
  if (!has_clone_target || !can_hot_swap) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::ActivateCloneHotSwap(";
    if (is_swap_chain) {
      s << ("backbuffer ");
    }
    s << (has_clone_target ? "hot swap not enabled " : "not cloned ");
    s << PRINT_PTR(tracked_resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    return false;
  }

  bool activated = false;
  std::vector<uint64_t> view_handles;
  utils::resource::ResourceUpgradeInfo* clone_target = nullptr;
  utils::resource::UpdateResourceInfo(resource, [&](utils::resource::ResourceInfo* info) {
    if (info->clone_enabled) return;
    if (info->clone_target == nullptr || !info->clone_target->use_resource_view_hot_swap) {
      return;
    }
    clone_target = info->clone_target;

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "utils::resource::upgrade::ActivateCloneHotSwap(activating res: ";
      s << PRINT_PTR(info->resource.handle);
      s << " => clone: ";
      s << PRINT_PTR(info->clone.handle);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }

#endif
    info->clone_enabled = true;
    info->clone_can_deactivate = true;
    view_handles.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
    activated = true;
  });
  if (activated) {
    UpdateResourceViewsCloneState(view_handles, true, true, clone_target);
  }

  return activated;
}

inline bool DeactivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  const auto resource = utils::resource::GetResourceFromView(device, resource_view);
  if (resource.handle == 0u) {
    std::stringstream s;
    s << "utils::resource::upgrade::DeactivateCloneHotSwap(no handle for view ";
    s << PRINT_PTR(resource_view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }

  bool deactivated = false;
  std::vector<uint64_t> view_handles;
  utils::resource::UpdateResourceInfo(resource, [&](utils::resource::ResourceInfo* info) {
    if (!info->clone_can_deactivate) return;
    if (!info->clone_enabled) return;
    info->clone_enabled = false;
    info->clone_can_deactivate = false;
    view_handles.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
    deactivated = true;
  });
  if (deactivated) {
    UpdateResourceViewsCloneState(view_handles, false, false);
  }

  return deactivated;
}

static bool FlushResourceViewInDescriptorTable(
    reshade::api::device* device,
    const reshade::api::resource& resource) {
  return true;
}

inline reshade::api::resource CloneResource(
    const reshade::api::resource& resource,
    std::optional<utils::resource::ResourceInfo> resource_info = std::nullopt) {
  if (resource.handle == 0u) return {0u};

  if (!resource_info.has_value()) {
    reshade::api::resource existing_clone = {0u};
    const auto found = utils::resource::GetResourceInfo(resource, [&](const utils::resource::ResourceInfo& info) {
      if (info.destroyed) return;
      if (info.clone.handle != 0u) {
        existing_clone = info.clone;
        return;
      }
      if (info.device == nullptr || info.clone_target == nullptr) {
        return;
      }
      resource_info = info;
    });
    if (!found) return {0u};
    if (existing_clone.handle != 0u) return existing_clone;
    if (!resource_info.has_value()) return {0u};
  }

  if (resource_info->destroyed) return {0u};
  if (resource_info->clone.handle != 0u) return resource_info->clone;
  if (resource_info->device == nullptr || resource_info->clone_target == nullptr) {
    return {0u};
  }

  auto new_desc = resource_info->desc;
  new_desc.texture.format = resource_info->clone_target->new_format;
  new_desc.usage = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(resource_info->desc.usage)
      | (resource_info->clone_target->usage_set & ~resource_info->clone_target->usage_unset));
  if (new_desc.heap == reshade::api::memory_heap::custom) {
    new_desc.heap = reshade::api::memory_heap::gpu_only;
  }

  // New: Force Texture2D if surface
  if (new_desc.type == reshade::api::resource_type::surface) {
    new_desc.type = reshade::api::resource_type::texture_2d;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::CloneResource(";
    s << PRINT_PTR(resource.handle);
    s << ", format: " << resource_info->desc.texture.format << " => " << new_desc.texture.format;
    s << ", type: " << resource_info->desc.type;
    s << ", flags: " << std::hex << static_cast<uint32_t>(resource_info->desc.flags) << std::dec;
    s << ", heap: " << std::hex << static_cast<uint32_t>(resource_info->desc.heap) << std::dec;
    s << ", usage: 0x" << std::hex << static_cast<uint32_t>(resource_info->desc.usage) << std::dec;
    s << ", new_usage: 0x" << std::hex << static_cast<uint32_t>(new_desc.usage) << std::dec;
    s << ", dimensions: " << resource_info->desc.texture.width << "x" << resource_info->desc.texture.height;
    s << ", initial_state: " << resource_info->initial_state;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  if (resource_info->clone_target->use_shared_handle) {
    assert(false && "Cloning with shared handle is not currently supported");
    return {0u};
  }

  new_desc.flags = reshade::api::resource_flags::none;

  reshade::api::resource created_clone = {0u};
  if (!resource_info->device->create_resource(
          new_desc,
          nullptr,  // initial_data
          resource_info->initial_state,
          &created_clone,
          nullptr)) {
    std::stringstream s;
    s << "utils::resource::cloning::CloneResource(Failed to clone: ";
    s << PRINT_PTR(resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
    return {0u};
  }

  const auto extra_ram = renodx::utils::resource::ComputeTextureSize(new_desc);
  utils::resource::UpsertResourceInfo(created_clone, [&](utils::resource::ResourceInfo* info, const bool inserted) {
    *info = {
        .device = resource_info->device,
        .desc = new_desc,
        .fallback_desc = resource_info->desc,
        .resource = created_clone,
        .fallback = resource,
        .is_clone = true,
        .extra_vram = extra_ram,
        .initial_state = resource_info->initial_state,
    };
  });

  reshade::api::resource clone = {0u};
  bool published_created_clone = false;
  utils::resource::UpdateResourceInfo(resource, [&](utils::resource::ResourceInfo* info) {
    if (info->destroyed) return;
    if (info->clone.handle != 0u) {
      clone = info->clone;
      return;
    }

    info->clone = created_clone;
    info->clone_desc = new_desc;
    clone = created_clone;
    published_created_clone = true;
  });

  if (!published_created_clone) {
    utils::resource::UpdateResourceInfo(created_clone, [&](utils::resource::ResourceInfo* info) {
      info->destroyed = true;
    });
    resource_info->device->destroy_resource(created_clone);
    return clone;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::CloneResource(";
    s << PRINT_PTR(resource.handle);
    s << " => " << PRINT_PTR(created_clone.handle);
    s << ", +vram: " << extra_ram;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  return created_clone;
}

[[deprecated("Use CloneResource(const reshade::api::resource&) instead.")]]
inline reshade::api::resource CloneResource(utils::resource::ResourceInfo* resource_info) {
  if (resource_info == nullptr) return {0u};
  if (resource_info->clone.handle != 0u) return resource_info->clone;
  return CloneResource(resource_info->resource, *resource_info);
}

inline reshade::api::resource GetResourceClone(
    const reshade::api::resource& resource,
    const ResourceCloneOptions& options = {},
    utils::resource::ResourceUpgradeInfo** clone_target = nullptr) {
  if (clone_target != nullptr) {
    *clone_target = nullptr;
  }
  if (resource.handle == 0u) return {0u};

  reshade::api::resource clone = {0u};
  bool can_create = false;
  bool activated = false;
  utils::resource::ResourceUpgradeInfo* target = nullptr;
  std::optional<utils::resource::ResourceInfo> resource_info = std::nullopt;

  if (options.activate) {
    std::vector<uint64_t> view_handles;
    const auto found = utils::resource::UpdateResourceInfo(resource, [&](utils::resource::ResourceInfo* info) {
      if (info->destroyed) return;
      if (info->clone_target == nullptr) {
        clone = info->clone;
        return;
      }
      target = info->clone_target;
      if (!info->clone_enabled) {
        info->clone_enabled = true;
        info->clone_can_deactivate = false;
        view_handles.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
        activated = true;
      }
      if (info->clone.handle != 0u) {
        clone = info->clone;
        return;
      }
      can_create = true;
      if (options.allow_create) {
        resource_info = *info;
      }
    });
    if (!found) return {0u};
    if (activated) {
      UpdateResourceViewsCloneState(view_handles, true, false, target);
    }
  } else {
    const auto found = utils::resource::GetResourceInfo(resource, [&](const utils::resource::ResourceInfo& info) {
      if (info.destroyed) return;
      target = info.clone_target;
      if (options.require_enabled && !info.clone_enabled) return;
      if (info.clone.handle != 0u) {
        clone = info.clone;
        return;
      }
      can_create = info.clone_target != nullptr;
      if (can_create && options.allow_create) {
        resource_info = info;
      }
    });
    if (!found) return {0u};
  }

  if (clone_target != nullptr) {
    *clone_target = target;
  }

  if (clone.handle != 0u) return clone;
  if (!options.allow_create || !can_create) return {0u};

  return CloneResource(resource, std::move(resource_info));
}

inline reshade::api::resource_view CloneResourceView(
    const reshade::api::resource_view& view,
    reshade::api::resource resource_clone = {0u},
    utils::resource::ResourceUpgradeInfo* target = nullptr,
    std::optional<utils::resource::ResourceViewInfo> view_info_snapshot = std::nullopt) {
  if (view.handle == 0u) return {0u};

  if (!view_info_snapshot.has_value()) {
    const auto found = utils::resource::GetResourceViewInfo(view, [&](const utils::resource::ResourceViewInfo& info) {
      view_info_snapshot = info;
    });
    if (!found) return {0u};
  }

  if (view_info_snapshot->destroyed || view_info_snapshot->is_clone) return {0u};
  if (view_info_snapshot->clone.handle != 0u) return view_info_snapshot->clone;
  if (view_info_snapshot->device == nullptr || view_info_snapshot->original_resource.handle == 0u) return {0u};

  if (resource_clone.handle == 0u) {
    ResourceCloneOptions options = {};
    options.require_enabled = false;
    resource_clone = GetResourceClone(view_info_snapshot->original_resource, options, &target);
    if (resource_clone.handle == 0u) return {0u};
  }
  if (target == nullptr) {
    target = view_info_snapshot->clone_target;
  }
  if (target == nullptr) return {0u};

  bool published_created_clone = false;

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::CloneResourceView(";
    s << PRINT_PTR(view.handle);
    s << ", original resource: " << PRINT_PTR(view_info_snapshot->original_resource.handle);
    s << ", creating view clone";
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  auto new_desc = view_info_snapshot->desc;
  if (auto pair2 = target->view_upgrades.find({view_info_snapshot->usage, new_desc.format});
      pair2 != target->view_upgrades.end() && pair2->second != reshade::api::format::unknown) {
    new_desc.format = pair2->second;
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "utils::resource::upgrade::CloneResourceView(";
      s << PRINT_PTR(view.handle);
      s << ", view_upgrades format: " << new_desc.format;
      s << ", clone resource: " << PRINT_PTR(resource_clone.handle);
      s << ", type: " << new_desc.type;
      s << ", usage: " << static_cast<uint32_t>(view_info_snapshot->usage) << "(" << view_info_snapshot->usage << ")";
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
  } else {
    new_desc.format = target->new_format;
#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "utils::resource::upgrade::CloneResourceView(";
      s << PRINT_PTR(view.handle);
      s << ", fallback format: " << new_desc.format;
      s << ", clone resource: " << PRINT_PTR(resource_clone.handle);
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
  }

  reshade::api::resource_view created_clone = {0u};
  if (!view_info_snapshot->device->create_resource_view(resource_clone, view_info_snapshot->usage, new_desc, &created_clone)) {
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::resource::upgrade::CloneResourceView(Failed to clone view: ";
    s << PRINT_PTR(view.handle);
    s << ", original resource: " << PRINT_PTR(view_info_snapshot->original_resource.handle);
    s << ", new usage: " << view_info_snapshot->usage;
    s << ", new format: " << new_desc.format;
    s << ", new type: " << new_desc.type;
    s << ")";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
#endif
    assert(false && "Failed to clone resource view");
    return {0u};
  }

  utils::resource::UpsertResourceViewInfo(created_clone, [&](utils::resource::ResourceViewInfo* info, const bool) {
    *info = {
        .device = view_info_snapshot->device,
        .desc = new_desc,
        .fallback_desc = view_info_snapshot->desc,
        .view = created_clone,
        .fallback = view,
        .original_resource = view_info_snapshot->original_resource,
        .clone_resource = resource_clone,
        .resource_info = nullptr,
        .clone_target = target,
        .usage = view_info_snapshot->usage,
        .is_clone = true,
        .is_swap_chain = view_info_snapshot->is_swap_chain,
    };
  });

  reshade::api::resource_view existing_clone = {0u};
  utils::resource::UpdateResourceViewInfo(view, [&](utils::resource::ResourceViewInfo* info) {
    if (info->destroyed || info->is_clone) return;
    if (info->clone.handle != 0u) {
      existing_clone = info->clone;
      return;
    }

    info->clone = created_clone;
    info->clone_desc = new_desc;
    info->clone_resource = resource_clone;
    if (info->clone_target == nullptr) {
      info->clone_target = target;
    }
    existing_clone = created_clone;
    published_created_clone = true;
  });

  if (!published_created_clone) {
    utils::resource::UpdateResourceViewInfo(created_clone, [&](utils::resource::ResourceViewInfo* info) {
      info->destroyed = true;
    });
    view_info_snapshot->device->destroy_resource_view(created_clone);
    return existing_clone;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::CloneResourceView(";
    s << PRINT_PTR(view.handle);
    s << " => " << PRINT_PTR(created_clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  return created_clone;
}

inline reshade::api::resource_view GetResourceViewClone(
    const reshade::api::resource_view& view,
    const ResourceViewCloneOptions& options = {}) {
  if (view.handle == 0u) return {0u};

  reshade::api::resource_view clone = {0u};
  std::optional<utils::resource::ResourceViewInfo> view_info = std::nullopt;
  utils::resource::GetResourceViewInfo(view, [&](const utils::resource::ResourceViewInfo& info) {
    assert(!info.destroyed && "GetResourceViewClone called on destroyed resource view.");
    if (info.destroyed || info.is_clone) return;
    if (info.original_resource.handle == 0u) return;
    if (!info.clone_enabled && options.require_enabled && !options.activate) return;

    if (info.clone.handle != 0u) {
      // Use created clone
      clone = info.clone;
      return;
    }

    if (!options.allow_create) return;

    // Ask to create one
    view_info = info;
  });

  if (view_info.has_value()) {
    utils::resource::ResourceUpgradeInfo* clone_target = nullptr;
    const auto resource_clone = GetResourceClone(view_info->original_resource, options, &clone_target);
    if (resource_clone.handle == 0u) return {0u};

    clone = CloneResourceView(view, resource_clone, clone_target, view_info);
  }

  return clone;
}

inline reshade::api::resource GetResourceClone(
    utils::resource::ResourceInfo* resource_info = nullptr,
    const ResourceCloneOptions& options = {}) {
  if (resource_info == nullptr) return {0u};
  return GetResourceClone(resource_info->resource, options);
}

static reshade::api::resource_view* ApplyRenderTargetClones(
    const reshade::api::resource_view* rtvs,
    const uint32_t& count) {
  reshade::api::resource_view* new_rtvs = nullptr;
  bool changed = false;
  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::resource_view& resource_view = rtvs[i];
    if (resource_view.handle == 0u) continue;

    const auto new_resource_view = GetResourceViewClone(resource_view);
    if (new_resource_view.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::ApplyRenderTargetClones(rewrite ";
    s << PRINT_PTR(resource_view.handle);
    s << " => ";
    s << PRINT_PTR(new_resource_view.handle);
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
  return new_rtvs;
}

static reshade::api::render_pass_render_target_desc* ApplyRenderTargetClones(
    const reshade::api::render_pass_render_target_desc* rts,
    const uint32_t& count) {
  reshade::api::render_pass_render_target_desc* new_rts = nullptr;
  bool changed = false;
  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::resource_view& resource_view = rts[i].view;
    if (resource_view.handle == 0u) continue;

    const auto new_resource_view = GetResourceViewClone(resource_view);
    if (new_resource_view.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::ApplyRenderTargetClones(rewrite ";
    s << PRINT_PTR(resource_view.handle);
    s << " => ";
    s << PRINT_PTR(new_resource_view.handle);
    s << ") [" << i << "]";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    if (!changed) {
      const size_t size = count * sizeof(reshade::api::render_pass_render_target_desc);
      new_rts = static_cast<reshade::api::render_pass_render_target_desc*>(malloc(size));
      memcpy(new_rts, rts, size);
      changed = true;
    }
    new_rts[i].view = new_resource_view;
  }
  return new_rts;
}

inline bool HandlePendingRenderPassRenderTargets(
    reshade::api::command_list* cmd_list,
    CommandListData* cmd_list_data = nullptr) {
  if (cmd_list_data == nullptr) {
    cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
    if (cmd_list_data == nullptr) return false;
  };
  if (cmd_list_data->pending_render_pass_render_targets.empty()) return false;
  cmd_list->end_render_pass();
  cmd_list->begin_render_pass(
      cmd_list_data->pending_render_pass_render_targets.size(),
      cmd_list_data->pending_render_pass_render_targets.data(),
      cmd_list_data->pending_render_pass_depth_stencil.has_value()
          ? &*cmd_list_data->pending_render_pass_depth_stencil
          : nullptr);

  cmd_list_data->pending_render_pass_render_targets.clear();
  cmd_list_data->pending_render_pass_depth_stencil.reset();

  return true;
}

inline void RewriteRenderTargets(
    reshade::api::command_list* cmd_list,
    const uint32_t& count,
    const reshade::api::resource_view* rtvs,
    const reshade::api::resource_view& dsv) {
  if (count == 0u) return;

  auto* new_rtvs = ApplyRenderTargetClones(rtvs, count);
  if (new_rtvs == nullptr) return;
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::opengl) {
    cmd_list->bind_render_targets_and_depth_stencil(count, new_rtvs, {0u});
  } else {
    cmd_list->bind_render_targets_and_depth_stencil(count, new_rtvs, dsv);
  }
  free(new_rtvs);
}

inline void DiscardDescriptors(reshade::api::command_list* cmd_list) {
  return;
  // Not implemented

  auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  cmd_data->unbound_descriptors.clear();
  cmd_data->unpushed_updates.clear();
}

inline void FlushDescriptors(reshade::api::command_list* cmd_list) {
  return;
  // Not implemented
  auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  for (auto info : cmd_data->unbound_descriptors) {
    cmd_list->bind_descriptor_tables(
        info.stages,
        info.layout,
        info.first,
        info.count,
        info.tables.data());
  }
  cmd_data->unbound_descriptors.clear();

  for (auto info : cmd_data->unpushed_updates) {
    cmd_list->push_descriptors(
        info.stages,
        info.layout,
        info.layout_param,
        info.update);
  }
  cmd_data->unpushed_updates.clear();
}

static bool SetUpgradeInfos(reshade::api::device* device, std::span<renodx::utils::resource::ResourceUpgradeInfo> infos) {
  auto* private_data = renodx::utils::data::Get<DeviceData>(device);
  if (private_data == nullptr) return false;

  const std::unique_lock lock(private_data->mutex);
  private_data->upgrade_infos.assign(infos.begin(), infos.end());
  private_data->upgrade_counts = std::vector<std::atomic<uint32_t>>(private_data->upgrade_infos.size());
  private_data->upgrade_completed = std::vector<std::atomic<bool>>(private_data->upgrade_infos.size());
  private_data->resource_upgrade_finished.store(false, std::memory_order_release);
  return true;
}

// clang-format off






























// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

// Hooks

static void OnInitDevice(reshade::api::device* device) {
  renodx::utils::data::Create<DeviceData>(device);

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "utils::resource::upgrade::OnInitDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ", api: " << device->get_api();
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
};

static void OnDestroyDevice(reshade::api::device* device) {
  renodx::utils::data::Delete<DeviceData>(device);

#ifdef DEBUG_LEVEL_0
  std::stringstream s;
  s << "utils::resource::upgrade::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
#endif
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return;

  renodx::utils::data::Create<CommandListData>(cmd_list);
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return;

  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* device = swapchain->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  data->resource_upgrade_finished.store(true, std::memory_order_release);
  data->back_buffer_desc = device->get_resource_desc(swapchain->get_current_back_buffer());
#ifdef DEBUG_LEVEL_0
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnInitSwapchain(reset resource upgrade)");
#endif
  const uint32_t len = data->upgrade_counts.size();
  // Reset
  for (uint32_t i = 0; i < len; i++) {
    if (i < data->upgrade_infos.size() && data->upgrade_infos[i].ignore_reset) continue;
    data->upgrade_counts[i].store(0u, std::memory_order_relaxed);
    data->upgrade_completed[i].store(false, std::memory_order_relaxed);
  }
  data->resource_upgrade_finished.store(false, std::memory_order_release);
}

static bool OnCreateResource(
    reshade::api::device* device,
    reshade::api::resource_desc& desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state) {
  local_applied_target = nullptr;
  local_original_resource.reset();
  local_original_resource_desc.reset();

  if (device == nullptr) {
    std::stringstream s;
    s << "utils::resource::upgrade::OnCreateResource(Empty device)";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }
  switch (desc.type) {
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      assert(false);
      reshade::log::message(reshade::log::level::warning, "utils::resource::upgrade::OnCreateResource(Unknown resource type)");
    default:
      return false;
  }

  auto* private_data = renodx::utils::data::Get<DeviceData>(device);
  if (private_data == nullptr) return false;
  if (private_data->resource_upgrade_finished.load(std::memory_order_acquire)) return false;

  const auto& device_back_buffer_desc = private_data->back_buffer_desc;
  if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnCreateResource(No swapchain desc";
    s << ", device: " << PRINT_PTR(reinterpret_cast<uintptr_t>(device));
    s << ", flags: 0x" << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
    s << ", state: 0x" << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
    s << ", format: " << desc.texture.format;
    s << ", width: " << desc.texture.width;
    s << ", height: " << desc.texture.height;
    s << ", usage: " << desc.usage << "(" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec << ")";
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    // return false;
  }

  auto& upgrade_infos = private_data->upgrade_infos;
  auto& upgrade_counts = private_data->upgrade_counts;
  auto& upgrade_completed = private_data->upgrade_completed;
  const auto len = upgrade_infos.size();
  if (upgrade_counts.size() < len || upgrade_completed.size() < len) return false;

  // const float resource_tag = -1;

  renodx::utils::resource::ResourceUpgradeInfo* found_target = nullptr;
  bool all_completed = true;
  bool found_exact = false;
  for (auto i = 0; i < len; i++) {
    renodx::utils::resource::ResourceUpgradeInfo* target = &upgrade_infos[i];
    if (upgrade_completed[i].load(std::memory_order_acquire)) continue;
    if (
        !target->use_resource_view_cloning
        && !target->use_resource_view_cloning_and_upgrade
        && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
      const uint32_t counted = upgrade_counts[i].fetch_add(1u, std::memory_order_acq_rel) + 1u;
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResource(counting target";
      if (!target->name.empty()) {
        s << ", name: " << target->name.c_str();
      }
      s << ", format: " << target->old_format;
      s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
      s << ", index: " << target->index;
      s << ", counted: " << counted;
      // s << ", data: " << PRINT_PTR(initial_data);
      s << ") [" << i << "/" << len << "]";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

      if (target->index != -1 && static_cast<uint32_t>(target->index + 1) == counted) {
        found_target = target;
        upgrade_completed[i].store(true, std::memory_order_release);
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
    private_data->resource_upgrade_finished.store(true, std::memory_order_release);
  }

  reshade::api::resource original_resource = {0};

  if (initial_data != nullptr) {
    // Create a temporary texture to store the texture data instead
    device->create_resource(
        desc,
        initial_data,
        initial_state,
        &original_resource);

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResource(created fallback for initial data";
      if (!found_target->name.empty()) {
        s << ", name: " << found_target->name.c_str();
      }
      s << ", fallback: " << PRINT_PTR(original_resource.handle);
      s << ", original_format: " << desc.texture.format;
      s << ", width: " << desc.texture.width;
      s << ", height: " << desc.texture.height;
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif

    // Internal clear needed for OpenGL
    initial_data->data = nullptr;
    initial_data = nullptr;
  }

  if (desc.texture.format == reshade::api::format::unknown
#ifdef DEBUG_LEVEL_0
      || true
#endif
  ) {
    std::stringstream s;
    s << "utils::resource::upgrade::OnCreateResource(Upgrading";
    if (!found_target->name.empty()) {
      s << ", name: " << found_target->name.c_str();
    }
    s << ", flags: 0x" << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
    s << ", state: 0x" << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
    s << ", format: " << desc.texture.format << " => " << found_target->new_format;
    s << ", width: " << desc.texture.width;
    s << ", height: " << desc.texture.height;
    s << ", usage: " << desc.usage << "(" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec << ")";
    s << ", target_dimensions: " << found_target->dimensions.width << "x" << found_target->dimensions.height << "x" << found_target->dimensions.depth;
    s << ", target_aspect: " << found_target->aspect_ratio;
    s << ", complete: " << all_completed;
    if (original_resource.handle != 0u) {
      s << ", fallback: " << PRINT_PTR(original_resource.handle);
    }
    s << ")";

    reshade::log::message(
        desc.texture.format == reshade::api::format::unknown
            ? reshade::log::level::warning
            : reshade::log::level::info,
        s.str().c_str());
  }

  const auto original_desc = desc;
  desc.texture.format = found_target->new_format;

  if (found_target->new_dimensions.width == renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER) {
    desc.texture.width = device_back_buffer_desc.texture.width;
  } else if (found_target->new_dimensions.width >= 0) {
    desc.texture.width = found_target->new_dimensions.width;
  }

  if (found_target->new_dimensions.height == renodx::utils::resource::ResourceUpgradeInfo::BACK_BUFFER) {
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

  local_original_resource = original_resource;
  local_original_resource_desc = original_desc;
  local_applied_target = found_target;
  return true;
}

inline void OnInitResourceInfo(renodx::utils::resource::ResourceInfo* resource_info) {
  if (!shared.IsEventHandler()) return;

  auto* device = resource_info->device;
  auto* private_data = renodx::utils::data::Get<DeviceData>(device);
  if (private_data == nullptr) return;

  // if (device == proxy_device_reshade) return;

  auto& desc = resource_info->desc;

  switch (desc.type) {
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::surface:
      break;
    case reshade::api::resource_type::unknown:
      reshade::log::message(reshade::log::level::warning, "utils::resource::upgrade::OnInitResource(Unknown resource type)");
    default:
      // if (private_data.applied_target != nullptr) {
      //   reshade::log::message(reshade::log::level::warning, "utils::resource::upgrade::OnInitResource(Modified?)");
      //   private_data.applied_target = nullptr;
      // }
      return;
  }

  auto& resource = resource_info->resource;
  auto& initial_state = resource_info->initial_state;
  bool changed = false;

  if (local_applied_target != nullptr) {
    changed = true;
    auto* applied_target = local_applied_target;
    if (local_applied_target->resource_tag != -1) {
      resource_info->resource_tag = local_applied_target->resource_tag;
    }
    resource_info->upgraded = true;
    resource_info->upgrade_target = local_applied_target;
    resource_info->fallback = local_original_resource.value();
    resource_info->fallback_desc = local_original_resource_desc.value();

    resource_info->extra_vram = renodx::utils::resource::ComputeTextureSize(desc)
                                - renodx::utils::resource::ComputeTextureSize(resource_info->fallback_desc);

    local_applied_target = nullptr;

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "utils::resource::upgrade::OnInitResource(applied create-time upgrade";
      if (!applied_target->name.empty()) {
        s << ", name: " << applied_target->name.c_str();
      }
      s << ", resource: " << PRINT_PTR(resource.handle);
      s << ", fallback: " << PRINT_PTR(resource_info->fallback.handle);
      s << ", format: " << resource_info->fallback_desc.texture.format << " => " << desc.texture.format;
      s << ", dimensions: " << resource_info->fallback_desc.texture.width << "x" << resource_info->fallback_desc.texture.height;
      s << " => " << desc.texture.width << "x" << desc.texture.height;
      s << ", +vram: " << resource_info->extra_vram;
      s << ")";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
#endif

  } else if (shared.data->use_resource_cloning) {
    if (resource_info->is_swap_chain) {
      // Swapchain upgrades can only be handled on CreateSwapchain
      return;
    }

    if (private_data->resource_upgrade_finished.load(std::memory_order_acquire)) return;

    const auto& device_back_buffer_desc = private_data->back_buffer_desc;

    if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::resource::upgrade::OnInitResource(No swapchain desc: ";
      s << ", device: " << PRINT_PTR(reinterpret_cast<uintptr_t>(device));
      s << ", flags: 0x" << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
      s << ", state: 0x" << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
      s << ", format: " << desc.texture.format;
      s << ", width: " << desc.texture.width;
      s << ", height: " << desc.texture.height;
      s << ", usage: " << desc.usage << "(" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec << ")";
      s << ")";
#endif
      // New, upgrade infos can now handle unknown back buffer state
      // return;
    }

    auto& upgrade_infos = private_data->upgrade_infos;
    auto& upgrade_counts = private_data->upgrade_counts;
    auto& upgrade_completed = private_data->upgrade_completed;
    const uint32_t len = upgrade_infos.size();
    if (upgrade_counts.size() < len || upgrade_completed.size() < len) return;

    renodx::utils::resource::ResourceUpgradeInfo* found_target = nullptr;
    bool all_completed = true;
    bool found_exact = false;
    for (uint32_t i = 0; i < len; i++) {
      auto* target = &upgrade_infos[i];
      if (upgrade_completed[i].load(std::memory_order_acquire)) continue;
      if (
          (target->use_resource_view_cloning
           || target->use_resource_view_cloning_and_upgrade)
          && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
        const uint32_t counted = upgrade_counts[i].fetch_add(1u, std::memory_order_acq_rel) + 1u;
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::OnInitResource(counting target";
        s << ", format: " << target->old_format;
        s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
        s << ", index: " << target->index;
        s << ", counted: " << counted;
        s << ") [" << i << "/" << len << "]";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (target->index != -1 && static_cast<uint32_t>(target->index + 1) == counted) {
          found_target = target;
          upgrade_completed[i].store(true, std::memory_order_release);
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
    if (found_target != nullptr) {
      if (all_completed) {
#ifdef DEBUG_LEVEL_1
        reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnInitResource(All resource cloning completed)");
#endif
        private_data->resource_upgrade_finished.store(true, std::memory_order_release);
      }

      // On the fly generation
      resource_info->clone_target = found_target;
      // resource_info.initial_state = initial_state;
      resource_info->resource_tag = found_target->resource_tag;
      if (found_target->resource_tag != -1) {
        resource_info->resource_tag = found_target->resource_tag;
      }
      if (!found_target->use_resource_view_hot_swap) {
        resource_info->clone_enabled = true;
        resource_info->clone_can_deactivate = false;
#ifdef DEBUG_LEVEL_1
        {
          std::stringstream s;
          s << "utils::resource::upgrade::OnInitResource(Marking resource for cloning: ";
          s << PRINT_PTR(resource.handle);
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
        }
#endif
      }
      changed = true;
    }
  }

#ifdef DEBUG_LEVEL_1
  if (changed
#ifdef DEBUG_LEVEL_3
      || true
#endif
  ) {
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitResource(tracking ";
    s << PRINT_PTR(resource.handle);
    s << ", device: " << PRINT_PTR(reinterpret_cast<uintptr_t>(device));
    s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
    s << ", state: " << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
    s << ", width: " << desc.texture.width;
    s << ", height: " << desc.texture.height;
    //  s << ", initial_data: " << (initial_data == nullptr ? "false" : "true");
    s << ", format: " << desc.texture.format;
    if (resource_info->resource_tag != -1) {
      s << ", tag: " << resource_info->resource_tag;
    }
    if (resource_info->fallback.handle != 0u) {
      s << ", fallback: " << PRINT_PTR(resource_info->fallback.handle);
    }
    if (resource_info->extra_vram != 0u) {
      s << ", +vram: " << resource_info->extra_vram;
    }
    s << ")";

    reshade::log::message(
        desc.texture.format == reshade::api::format::unknown
            ? reshade::log::level::warning
            : reshade::log::level::info,
        s.str().c_str());
  }
#endif
}

inline void OnDestroyResourceInfo(utils::resource::ResourceInfo* info) {
  if (!shared.IsEventHandler()) return;

  for (const auto view_handle : info->resource_view_handles) {
    pending_resource_view_clone_states.push_back(view_handle);
  }

  if (!info->is_clone && info->fallback.handle != 0u) {
    pending_resource_destroys.insert({
        .device = info->device,
        .resource = info->fallback,
    });
  }

  if (info->clone.handle != 0u) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnDestroyResource(destroy cloned resource and views";
    s << ", resource: " << PRINT_PTR(info->resource.handle);
    s << ", clone: " << PRINT_PTR(info->clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

#ifdef DEBUG_LEVEL_0
    if (info->proxy_resource.handle != 0u) {
      std::stringstream s;
      s << "utils::resource::upgrade::OnDestroyResource(destroy proxy resource";
      s << ", resource: " << PRINT_PTR(info->resource.handle);
      s << ", proxy: " << PRINT_PTR(info->proxy_resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
#endif

    // Device points to original device (may not be current)
    pending_resource_destroys.insert({
        .device = info->device,
        .resource = info->clone,
    });
  }

  if (info->extra_vram != 0u) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnDestroyResource(";
    s << "Resource: " << PRINT_PTR(info->resource.handle);
    s << ", clone: " << PRINT_PTR(info->clone.handle);
    s << ", -vram: " << info->extra_vram;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    info->extra_vram = 0;
  }
}

inline bool OnCopyBufferToTexture(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint64_t source_offset,
    uint32_t row_length,
    uint32_t slice_height,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  bool source_upgraded = false;
  bool destination_upgraded = false;
  bool source_clone_enabled = false;
  bool destination_clone_enabled = false;
  reshade::api::resource source_clone_existing = {0u};
  reshade::api::resource destination_clone_existing = {0u};
  reshade::api::resource_desc destination_desc = {};
  reshade::api::resource_desc destination_clone_desc = {};
  const auto found_source_info = utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
    source_upgraded = info.upgraded;
    source_clone_enabled = info.clone_enabled;
    source_clone_existing = info.clone;
  });
  if (!found_source_info) return false;

  const auto found_destination_info = utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
    destination_upgraded = info.upgraded;
    destination_clone_enabled = info.clone_enabled;
    destination_clone_existing = info.clone;
    destination_desc = info.desc;
    destination_clone_desc = info.clone_desc;
  });
  if (!found_destination_info) return false;

  const bool need_source_clone = (source_clone_enabled && source_clone_existing.handle == 0u);
  const auto source_clone = need_source_clone ? CloneResource(source) : source_clone_existing;

  const bool need_dest_clone = (destination_clone_enabled && destination_clone_existing.handle == 0u);
  const auto dest_clone = need_dest_clone ? CloneResource(dest) : destination_clone_existing;

  if (!source_upgraded && !destination_upgraded
      && (source_clone.handle == 0u) && (dest_clone.handle == 0u)) return false;

  if (destination_desc.texture.format == destination_clone_desc.texture.format) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnCopyBufferToTexture(Redirected to clone: ";
    s << PRINT_PTR(dest.handle);
    s << " => " << PRINT_PTR(dest_clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->copy_buffer_to_texture(source, source_offset, row_length, slice_height, dest_clone, dest_subresource, dest_box);

    return true;
    // remap to other
  }
  // Mismatched, copy to original and blit?
  cmd_list->copy_buffer_to_texture(source, source_offset, row_length, slice_height, dest, dest_subresource, dest_box);

  std::stringstream s;
  s << "utils::resource::upgrade::OnCopyBufferToTexture(mismatched ";
  s << PRINT_PTR(source.handle);
  s << "[" << source_offset << "]";
  s << " => " << PRINT_PTR(dest.handle);
  s << "[" << dest_subresource << "]";
  s << " (" << destination_clone_desc.texture.format << ")";
  if (dest_box != nullptr) {
    s << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";

  reshade::log::message(reshade::log::level::warning, s.str().c_str());

  if (cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan) {
    // perform blit
    const auto source_texture = dest;
    const auto destination_texture = dest_clone;
    cmd_list->copy_texture_region(source_texture, dest_subresource, dest_box, destination_texture, dest_subresource, dest_box);
    return true;
  } else {
    // Can't blit on D3D12 with mismatched formats.
    return true;
  }
}

inline bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  assert(local_original_resource_view_desc.has_value() == false);
  local_original_resource_view_desc.reset();
  if (resource.handle == 0u) return false;

  // if (device == proxy_device_reshade) return false;

  bool expected = false;
  bool found_upgrade = false;

  reshade::api::resource_desc resource_desc = {};
  bool has_resource_desc = false;

  reshade::api::resource_view_desc current_desc = desc;
  if (desc.type == reshade::api::resource_view_type::unknown) {
    resource_desc = utils::resource::GetResourceDesc(device, resource);
    has_resource_desc = resource_desc.type != reshade::api::resource_type::unknown;
    if (!has_resource_desc) return false;
    current_desc = utils::resource::PopulateUnknownResourceViewDesc(device, desc, usage_type, resource_desc);
  }
  switch (current_desc.type) {
    case reshade::api::resource_view_type::texture_1d:
    case reshade::api::resource_view_type::texture_1d_array:
    case reshade::api::resource_view_type::texture_2d:
    case reshade::api::resource_view_type::texture_2d_array:
    case reshade::api::resource_view_type::texture_2d_multisample:
    case reshade::api::resource_view_type::texture_2d_multisample_array:
    case reshade::api::resource_view_type::texture_3d:
    case reshade::api::resource_view_type::texture_cube:
    case reshade::api::resource_view_type::texture_cube_array:
      break;
    case reshade::api::resource_view_type::unknown:
      assert(false);
    default:
    case reshade::api::resource_view_type::acceleration_structure:
    case reshade::api::resource_view_type::buffer:

      return false;
  }

  bool is_back_buffer = false;
  const utils::resource::ResourceUpgradeInfo* upgrade_target = nullptr;
  const utils::resource::ResourceUpgradeInfo* clone_target = nullptr;

  const bool resource_info_found = utils::resource::GetLiveResourceInfo(resource, [&](const utils::resource::ResourceInfo& info) {
    resource_desc = info.desc;
    is_back_buffer = info.is_swap_chain;
    upgrade_target = info.upgrade_target;
    clone_target = info.clone_target;
    has_resource_desc = true;
  });
  if (!has_resource_desc) {
    resource_desc = device->get_resource_desc(resource);
    has_resource_desc = true;

#ifdef DEBUG_LEVEL_0
    {
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResourceView(Unknown resource: ";
      s << PRINT_PTR(resource.handle);
      s << ", type: " << desc.type;
      s << ", format: " << desc.format;
      s << ", resource type: " << resource_desc.type;
      s << ", resource format: " << resource_desc.texture.format;
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
#endif
  }

  if (current_desc.format == reshade::api::format::unknown) {
    current_desc = utils::resource::PopulateUnknownResourceViewDesc(device, desc, usage_type, resource_desc);
    if (current_desc.format == reshade::api::format::unknown) {
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResourceView(Unknown format for resource view: ";
      s << PRINT_PTR(resource.handle);
      s << ", type: " << current_desc.type;
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
      assert(current_desc.format != reshade::api::format::unknown);
      return false;
    }
  }

  reshade::api::resource_view_desc new_desc = current_desc;
  const auto typeless_resource_format = utils::resource::FormatToTypeless(resource_desc.texture.format);
  const auto typeless_view_format = utils::resource::FormatToTypeless(current_desc.format);
  bool forced_native_format = false;

  const auto log_unexpected_create_resource_view = [&](const char* reason, bool will_assert) {
    std::stringstream s;
    s << "utils::resource::upgrade::OnCreateResourceView(";
    s << "unexpected";
    s << ", reason: " << reason;
    s << ", will_assert: " << (will_assert ? "true" : "false");
    s << ", forced_native_format: " << (forced_native_format ? "true" : "false");
    s << ", view type: " << desc.type << " => " << current_desc.type << " => " << new_desc.type;
    s << ", view format: " << desc.format << " => " << current_desc.format << " => " << new_desc.format;
    s << ", typeless view/resource: " << typeless_view_format << " => " << typeless_resource_format;
    s << ", resource: " << PRINT_PTR(resource.handle);
    s << ", resource width: " << resource_desc.texture.width;
    s << ", resource height: " << resource_desc.texture.height;
    s << ", resource format: " << resource_desc.texture.format;
    s << ", resource usage: " << usage_type;
    s << ", tracked resource: " << (resource_info_found ? "true" : "false");
    s << ", is_back_buffer: " << (is_back_buffer ? "true" : "false");
    s << ", has_upgrade_target: " << (upgrade_target != nullptr ? "true" : "false");
    s << ", has_clone_target: " << (clone_target != nullptr ? "true" : "false");
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  };

  if (is_back_buffer) {
    // Back buffers should have their upgrade_target set already
    // Treat no differently than other resources
  }
  if (upgrade_target != nullptr) {
    const auto* target = upgrade_target;
    if (auto pair2 = target->view_upgrades.find({usage_type, current_desc.format});
        pair2 != target->view_upgrades.end() && pair2->second != reshade::api::format::unknown) {
      new_desc.format = pair2->second;
      found_upgrade = true;
      expected = true;
    }
  }
  if (upgrade_target != nullptr) {
    if (!found_upgrade) {
      log_unexpected_create_resource_view("missing upgrade-target view format remap", false);
    }
  } else {
    // Resource upgrades in general may cause format mismatches
    if (typeless_resource_format != typeless_view_format) {
      if (resource_desc.texture.format != typeless_resource_format) {
        switch (resource_desc.texture.format) {
          case reshade::api::format::r8g8b8a8_unorm:
          case reshade::api::format::b8g8r8a8_unorm:
          case reshade::api::format::r8g8b8a8_unorm_srgb:
          case reshade::api::format::b8g8r8a8_unorm_srgb:
          case reshade::api::format::r10g10b10a2_unorm:
          case reshade::api::format::b10g10r10a2_unorm:
          case reshade::api::format::r16g16b16a16_float:
            new_desc.format = resource_desc.texture.format;
            expected = false;
            found_upgrade = true;
            break;
          default:
            if (renodx::utils::resource::IsCompressible(current_desc.format, resource_desc.texture.format)) {
              break;
            }
            new_desc.format = resource_desc.texture.format;
            forced_native_format = true;
            log_unexpected_create_resource_view("invalid typed view/resource format mismatch", true);
            assert(false && "utils::resource::upgrade::OnCreateResourceView(invalid typed view/resource format mismatch; coerced to native resource format for post-assert continuation)");
        }
      }
    }
  }

  const bool changed = (current_desc.format != new_desc.format);

#if defined(DEBUG_LEVEL_1) || defined(DEBUG_LEVEL_0)
#ifdef DEBUG_LEVEL_1
  if (true) {
#else
  if (changed) {
#endif
    std::stringstream s;
    s << "utils::resource::upgrade::OnCreateResourceView(" << (changed ? "upgrading" : "logging");
    s << ", found_upgrade: " << (found_upgrade ? "true" : "false");
    if (is_back_buffer) {
      s << ", back buffer view";
    }
    s << ", expected: " << (expected ? "true" : "false");
    s << ", forced_native_format: " << (forced_native_format ? "true" : "false");
    s << ", view type: " << desc.type << " => " << current_desc.type;
    s << ", view format: " << desc.format << " => " << current_desc.format << " => " << new_desc.format;
    s << ", typeless view/resource: " << typeless_view_format << " => " << typeless_resource_format;
    s << ", resource: " << PRINT_PTR(resource.handle);
    s << ", resource width: " << resource_desc.texture.width;
    s << ", resource height: " << resource_desc.texture.height;
    s << ", resource format: " << resource_desc.texture.format;
    s << ", resource usage: " << usage_type;
    s << ", tracked resource: " << (resource_info_found ? "true" : "false");
    s << ", has_upgrade_target: " << (upgrade_target != nullptr ? "true" : "false");
    s << ", has_clone_target: " << (clone_target != nullptr ? "true" : "false");
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  };
#endif

  if (shared.data->use_resource_cloning) {
    if (clone_target != nullptr) {
      const auto* upgrade_info = clone_target;
      if (!upgrade_info->use_resource_view_cloning_and_upgrade) {
        return false;
      }
      // Upgrade on init instead (allows resource view handle reuse)
      // Cloning with upgrade

      // local_original_resource_view =
    }
  }
  if (!changed) return false;

  local_original_resource_view_desc = desc;

  desc.type = new_desc.type;
  desc.format = new_desc.format;

  return true;
}

inline void OnInitResourceViewInfo(utils::resource::ResourceViewInfo* resource_view_info) {
  if (local_original_resource_view_desc.has_value()) {
    resource_view_info->fallback_desc = local_original_resource_view_desc.value();
    local_original_resource_view_desc.reset();
  }

  if (!shared.IsEventHandler()) return;

  if (resource_view_info->device->get_api() != reshade::api::device_api::d3d12) return;

  if (resource_view_info->clone_target == nullptr) return;
  if (resource_view_info->clone_target->use_resource_view_hot_swap) return;
  if (!resource_view_info->clone_target->use_resource_view_cloning
      && !resource_view_info->clone_target->use_resource_view_cloning_and_upgrade) return;

  switch (resource_view_info->usage) {
    case reshade::api::resource_usage::render_target:
    case reshade::api::resource_usage::shader_resource:
    case reshade::api::resource_usage::unordered_access:
      break;
    default:
      return;
  }

  // Copy locally
  pending_dx12_clone_resource_view_info = *resource_view_info;

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitResourceViewInfo(queue d3d12 fast clone";
    s << ", resource: " << PRINT_PTR(resource_view_info->original_resource.handle);
    s << ", view: " << PRINT_PTR(resource_view_info->view.handle);
    s << ", usage: " << resource_view_info->usage;
    s << ", desc type: " << resource_view_info->desc.type;
    s << ", desc format: " << resource_view_info->desc.format;
    s << ", target: " << resource_view_info->clone_target->name;
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif
}

inline void OnInitResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    const reshade::api::resource_view_desc& desc,
    reshade::api::resource_view view) {
  if (device->get_api() != reshade::api::device_api::d3d12) return;

  if (!pending_dx12_clone_resource_view_info.has_value()) return;
  if (pending_dx12_clone_resource_view_info->device != device || pending_dx12_clone_resource_view_info->view.handle != view.handle) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitResourceView(skip d3d12 fast clone; pending mismatch";
    s << ", pending device: " << pending_dx12_clone_resource_view_info->device;
    s << ", current device: " << device;
    s << ", pending view: " << PRINT_PTR(pending_dx12_clone_resource_view_info->view.handle);
    s << ", current view: " << PRINT_PTR(view.handle);
    s << ", current resource: " << PRINT_PTR(resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    return;
  }
  if (resource.handle == 0u || pending_dx12_clone_resource_view_info->original_resource.handle != resource.handle) {
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitResourceView(reset d3d12 fast clone; resource mismatch";
    s << ", pending resource: " << PRINT_PTR(pending_dx12_clone_resource_view_info->original_resource.handle);
    s << ", current resource: " << PRINT_PTR(resource.handle);
    s << ", view: " << PRINT_PTR(view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    pending_dx12_clone_resource_view_info.reset();
    return;
  }
  if (pending_dx12_clone_resource_view_info->usage != usage_type) {
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitResourceView(reset d3d12 fast clone; usage mismatch";
    s << ", resource: " << PRINT_PTR(resource.handle);
    s << ", view: " << PRINT_PTR(view.handle);
    s << ", pending usage: " << pending_dx12_clone_resource_view_info->usage;
    s << ", current usage: " << usage_type;
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    pending_dx12_clone_resource_view_info.reset();
    return;
  }
  pending_dx12_clone_resource_view_info.reset();

  const auto clone = GetResourceViewClone(view, {.activate = true});

  if (clone.handle == 0u) {
#ifdef DEBUG_LEVEL_0
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitResourceView(failed d3d12 fast clone";
    s << ", resource: " << PRINT_PTR(resource.handle);
    s << ", view: " << PRINT_PTR(view.handle);
    s << ", usage: " << usage_type;
    s << ", desc type: " << desc.type;
    s << ", desc format: " << desc.format;
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    return;
  }

  const auto heap_type = usage_type == reshade::api::resource_usage::render_target
                             ? D3D12_DESCRIPTOR_HEAP_TYPE_RTV
                             : D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;

  const D3D12_CPU_DESCRIPTOR_HANDLE destination_descriptor = {static_cast<SIZE_T>(view.handle)};
  const D3D12_CPU_DESCRIPTOR_HANDLE source_descriptor = {static_cast<SIZE_T>(clone.handle)};

  auto* dx12_device = reinterpret_cast<ID3D12Device*>(static_cast<uintptr_t>(device->get_native()));  // NOLINT(performance-no-int-to-ptr)

  dx12_device->CopyDescriptorsSimple(1u, destination_descriptor, source_descriptor, heap_type);

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitResourceView(copied d3d12 fast clone descriptor";
    s << ", resource: " << PRINT_PTR(resource.handle);
    s << ", view: " << PRINT_PTR(view.handle);
    s << " => clone: " << PRINT_PTR(clone.handle);
    s << ", usage: " << usage_type;
    s << ", heap_type: " << heap_type;
    s << ", desc type: " << desc.type;
    s << ", desc format: " << desc.format;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
#endif
}

inline void OnDestroyResourceViewInfo(utils::resource::ResourceViewInfo* resource_view_info) {
  if (!shared.IsEventHandler()) return;

#ifdef DEBUG_LEVEL_2
  bool is_swap_chain = false;
  if (resource_view_info->original_resource.handle != 0u) {
    utils::resource::GetResourceInfo(resource_view_info->original_resource, [&is_swap_chain](const utils::resource::ResourceInfo& info) {
      is_swap_chain = info.is_swap_chain && !info.destroyed;
    });
  }
  if (is_swap_chain) {
    reshade::log::message(reshade::log::level::warning, "Destroyed swapchain RTV");
  }
#endif
  if (resource_view_info->clone.handle != 0u) {
    assert(resource_view_info->device != nullptr);
    pending_resource_view_destroys.insert({
        .device = resource_view_info->device,
        .view = resource_view_info->clone,
    });
  }

  if (!resource_view_info->is_clone && resource_view_info->fallback.handle != 0u) {
    assert(resource_view_info->device != nullptr);
    pending_resource_view_destroys.insert({
        .device = resource_view_info->device,
        .view = resource_view_info->fallback,
    });
  }
}

inline void OnAfterDestroy() {
  std::vector<uint64_t> resource_view_clone_states;
  std::set<PendingResourceDestroyKey> resource_destroys;
  std::set<PendingResourceViewDestroyKey> resource_view_destroys;
  resource_view_clone_states.swap(pending_resource_view_clone_states);
  resource_destroys.swap(pending_resource_destroys);
  resource_view_destroys.swap(pending_resource_view_destroys);

  UpdateResourceViewsCloneState(resource_view_clone_states, false, false);

  for (const auto& value : resource_view_destroys) {
    auto* device = value.device;
    const auto view = value.view;
    if (device == nullptr || view.handle == 0u) continue;
    const bool can_destroy_device_resources = CanDestroyResourcesForDevice(device);

    bool should_destroy = false;
    const auto found = utils::resource::UpdateResourceViewInfo(view, [&](utils::resource::ResourceViewInfo* info) {
      if (info->destroyed) return;
      if (info->device != nullptr && info->device != device) return;

      if (info->device == nullptr) {
        info->device = device;
      }

      info->destroyed = true;
      should_destroy = true;
    });
    if ((!found || should_destroy) && can_destroy_device_resources) {
      device->destroy_resource_view(view);
    }
  }
  for (const auto& value : resource_destroys) {
    auto* device = value.device;
    const auto resource = value.resource;
    if (device == nullptr || resource.handle == 0u) continue;
    const bool can_destroy_device_resources = CanDestroyResourcesForDevice(device);

    bool should_destroy = false;
    const auto found = utils::resource::UpdateResourceInfo(resource, [&](utils::resource::ResourceInfo* info) {
      if (info->destroyed) return;
      if (info->device != nullptr && info->device != device) return;

      if (info->device == nullptr) {
        info->device = device;
      }

      info->destroyed = true;
      should_destroy = true;
    });
    if ((!found || should_destroy) && can_destroy_device_resources) {
      device->destroy_resource(resource);
    }
  }
}

inline bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  reshade::api::resource_desc source_desc = {};
  reshade::api::resource_desc source_clone_desc = {};
  bool source_clone_enabled = false;
  reshade::api::resource source_clone_existing = {0u};
  const auto found_source_info = utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
    source_desc = info.desc;
    source_clone_desc = info.clone_desc;
    source_clone_enabled = info.clone_enabled;
    source_clone_existing = info.clone;
  });
  if (!found_source_info) return false;

  switch (source_desc.type) {
    case reshade::api::resource_type::unknown:
    case reshade::api::resource_type::buffer:
      return false;
    case reshade::api::resource_type::texture_1d:
    case reshade::api::resource_type::texture_2d:
    case reshade::api::resource_type::texture_3d:
    case reshade::api::resource_type::surface:
    default:
      break;
  }

  reshade::api::resource_desc dest_desc = {};
  reshade::api::resource_desc dest_clone_desc = {};
  bool destination_clone_enabled = false;
  reshade::api::resource destination_clone_existing = {0u};
  const auto found_destination_info = utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
    dest_desc = info.desc;
    dest_clone_desc = info.clone_desc;
    destination_clone_enabled = info.clone_enabled;
    destination_clone_existing = info.clone;
  });
  if (!found_destination_info) return false;

  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_desc;
  auto dest_desc_new = dest_desc;
  bool source_clone_attempted = false;
  bool destination_clone_attempted = false;
  bool can_be_copied = utils::resource::AreCopyFormatsCompatible(
        source_desc_new.texture.format,
        dest_desc_new.texture.format);

  auto* shared_data = shared.data;
  if (!can_be_copied && shared_data->use_auto_cloning) {
    if (!source_clone_enabled && source_desc.texture.format != shared_data->auto_upgrade_target.new_format) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnCopyResource(";
      s << "Auto upgrading source: ";
      s << "original: " << PRINT_PTR(source.handle);
      s << ", format: " << source_desc.texture.format;
      s << ", type: " << source_desc.type;
      s << ");";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      bool should_activate_auto_clone = false;
      utils::resource::UpdateResourceInfo(source, [&](utils::resource::ResourceInfo* info) {
        if (info->clone_target == nullptr) {
          info->clone_target = &shared_data->auto_upgrade_target;
        }
        if (info->clone_target != nullptr) {
          should_activate_auto_clone = true;
        }
        source_clone_enabled = info->clone_enabled || should_activate_auto_clone;
        source_clone_existing = info->clone;
        source_clone_desc = info->clone_desc;
      });
      if (should_activate_auto_clone) {
        source_clone_existing = GetResourceClone(
            source,
            {
                .require_enabled = false,
                .allow_create = true,
                .activate = true,
            });
        source_clone_attempted = true;
        utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
          source_clone_desc = info.clone_desc;
        });
      }
    }
    if (!destination_clone_enabled && dest_desc.texture.format != shared_data->auto_upgrade_target.new_format) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnCopyResource(";
      s << "Auto upgrading destination: ";
      s << "original: " << PRINT_PTR(dest.handle);
      s << ", format: " << dest_desc.texture.format;
      s << ", type: " << dest_desc.type;
      s << ");";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      bool should_activate_auto_clone = false;
      utils::resource::UpdateResourceInfo(dest, [&](utils::resource::ResourceInfo* info) {
        if (info->clone_target == nullptr) {
          info->clone_target = &shared_data->auto_upgrade_target;
        }
        if (info->clone_target != nullptr) {
          should_activate_auto_clone = true;
        }
        destination_clone_enabled = info->clone_enabled || should_activate_auto_clone;
        destination_clone_existing = info->clone;
        dest_clone_desc = info->clone_desc;
      });
      if (should_activate_auto_clone) {
        destination_clone_existing = GetResourceClone(
            dest,
            {
                .require_enabled = false,
                .allow_create = true,
                .activate = true,
            });
        destination_clone_attempted = true;
        utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
          dest_clone_desc = info.clone_desc;
        });
      }
    }
  }

  if (source_clone_enabled || destination_clone_enabled) {
    auto source_clone =
        source_clone_enabled && source_clone_existing.handle == 0u && !source_clone_attempted
            ? CloneResource(source)
            : source_clone_existing;
    auto dest_clone =
        destination_clone_enabled && destination_clone_existing.handle == 0u && !destination_clone_attempted
            ? CloneResource(dest)
            : destination_clone_existing;

    if (source_clone.handle != 0u) {
      if (source_clone_existing.handle == 0u) {
        utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
          source_clone_desc = info.clone_desc;
        });
      }
      source_desc_new = source_clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      if (destination_clone_existing.handle == 0u) {
        utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
          dest_clone_desc = info.clone_desc;
        });
      }
      dest_desc_new = dest_clone_desc;
      dest_new = dest_clone;
    }
    can_be_copied = utils::resource::AreCopyFormatsCompatible(
        source_desc_new.texture.format,
        dest_desc_new.texture.format);
  }

  // {
  //   std::stringstream s;
  //   s << "utils::resource::upgrade::OnCopyResource(";
  //   s << "attempt resource copy: ";
  //   s << PRINT_PTR(source.handle) << " => " << PRINT_PTR(dest.handle);
  //   s << ", format: " << source_desc.texture.format << " => " << dest_desc.texture.format;
  //   s << ", type: " << source_desc.type << " => " << dest_desc.type;
  //   s << ", clone: " << PRINT_PTR(source_new.handle) << " => " << PRINT_PTR(dest_new.handle);
  //   s << ", clone_format: " << source_desc_new.texture.format << " => " << dest_desc_new.texture.format;
  //   s << ", clone_type: " << source_desc_new.type << " => " << dest_desc_new.type;
  //   s << ");";
  //   reshade::log::message(reshade::log::level::debug, s.str().c_str());
  // }

  if (can_be_copied) {
    cmd_list->copy_resource(source_new, dest_new);
    return true;
  }

  // Mismatched (don't copy);
#ifdef DEBUG_LEVEL_2
  std::stringstream s;
  s << "utils::resource::upgrade::OnCopyResource(";
  s << "prevent resource copy: ";
  s << "original: " << PRINT_PTR(source.handle) << " => " << PRINT_PTR(dest.handle);
  s << ", format: " << source_desc.texture.format << " => " << dest_desc.texture.format;
  s << ", type: " << source_desc.type << " => " << dest_desc.type;
  s << ", clone: " << PRINT_PTR(source_new.handle) << " => " << PRINT_PTR(dest_new.handle);
  s << ", clone_format: " << source_desc_new.texture.format << " => " << dest_desc_new.texture.format;
  s << ", clone_type: " << source_desc_new.type << " => " << dest_desc_new.type;
  s << ");";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  return true;
}

// Create DescriptorTables with RSVs
inline bool OnUpdateDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_update* updates) {
  if (count == 0u) return false;
  if (device->get_api() == reshade::api::device_api::d3d12) return false;
#ifdef DEBUG_LEVEL_3
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnUpdateDescriptorTables()");
#endif
  static thread_local std::vector<reshade::api::descriptor_table_update> new_updates;
  static thread_local std::vector<std::vector<reshade::api::resource_view>> resource_view_descriptors;
  static thread_local std::vector<std::vector<reshade::api::sampler_with_resource_view>> sampler_resource_view_descriptors;
  bool changed = false;
  // bool active = false;

  // std::vector<std::pair<std::pair<int, int>, utils::resource::ResourceViewInfo*>> infos;

  uint32_t last_written_update_index = 0u;
  auto copy_updates_until = [&](uint32_t end_index) {
    if (!changed) {
      if (new_updates.size() < count) new_updates.resize(count);
      changed = true;
    }
    if (last_written_update_index < end_index) {
      memcpy(new_updates.data() + last_written_update_index, updates + last_written_update_index, sizeof(reshade::api::descriptor_table_update) * (end_index - last_written_update_index));
      last_written_update_index = end_index;
    }
  };

  for (uint32_t i = 0; i < count; ++i) {
    const auto& update = updates[i];
    if (update.table.handle == 0u) {
      continue;
    }
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        const auto* original_descriptors = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors);
        reshade::api::sampler_with_resource_view* replacement_descriptors = nullptr;
        for (uint32_t j = 0; j < update.count; j++) {
          const auto& item = original_descriptors[j];
          auto resource_view = item.view;
          if (resource_view.handle == 0u) continue;
          const auto resource_view_clone = GetResourceViewClone(resource_view);
          if (resource_view_clone.handle == 0u) continue;
#ifdef DEBUG_LEVEL_2
          std::stringstream s;
          s << "utils::resource::upgrade::OnUpdateDescriptorTables(found clonable: ";
          s << PRINT_PTR(resource_view_clone.handle);
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

          if (replacement_descriptors == nullptr) {
            copy_updates_until(i);
            if (sampler_resource_view_descriptors.size() <= i) {
              sampler_resource_view_descriptors.resize(i + 1u);
            }
            auto& descriptors = sampler_resource_view_descriptors[i];
            if (descriptors.size() < update.count) {
              descriptors.resize(update.count);
            }
            replacement_descriptors = descriptors.data();
            memcpy(replacement_descriptors, original_descriptors, sizeof(reshade::api::sampler_with_resource_view) * update.count);
            auto new_update = update;
            new_update.descriptors = replacement_descriptors;
            new_updates[i] = new_update;
            last_written_update_index = i + 1u;
          }

          replacement_descriptors[j].view = resource_view_clone;
          // if (data.enabled_cloned_resources.contains(new_resource.handle)) {
          //   active = true;
          // }
        }

      } break;
      case reshade::api::descriptor_type::texture_shader_resource_view:
      case reshade::api::descriptor_type::texture_unordered_access_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:        {
        const auto* original_descriptors = static_cast<const reshade::api::resource_view*>(update.descriptors);
        reshade::api::resource_view* replacement_descriptors = nullptr;
        for (uint32_t j = 0; j < update.count; j++) {
          const auto& resource_view = original_descriptors[j];
          if (resource_view.handle == 0u) continue;
          reshade::api::resource_view resource_view_clone = GetResourceViewClone(resource_view);
          if (resource_view_clone.handle == 0u) continue;
#ifdef DEBUG_LEVEL_2
          std::stringstream s;
          s << "utils::resource::upgrade::OnUpdateDescriptorTables(found clonable: ";
          s << PRINT_PTR(resource_view_clone.handle);
          s << ")";
          reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

          if (replacement_descriptors == nullptr) {
            copy_updates_until(i);
            if (resource_view_descriptors.size() <= i) {
              resource_view_descriptors.resize(i + 1u);
            }
            auto& descriptors = resource_view_descriptors[i];
            if (descriptors.size() < update.count) {
              descriptors.resize(update.count);
            }
            replacement_descriptors = descriptors.data();
            memcpy(replacement_descriptors, original_descriptors, sizeof(reshade::api::resource_view) * update.count);
            auto new_update = update;
            new_update.descriptors = replacement_descriptors;
            new_updates[i] = new_update;
            last_written_update_index = i + 1u;
          }

          replacement_descriptors[j] = resource_view_clone;
          // if (data.enabled_cloned_resources.contains(new_resource.handle)) {
          //   active = true;
          // }
        }
      } break;
      default:
        break;
    }
  }

  if (changed) {
    if (last_written_update_index < count) {
      memcpy(new_updates.data() + last_written_update_index, updates + last_written_update_index, sizeof(reshade::api::descriptor_table_update) * (count - last_written_update_index));
    }
    device->update_descriptor_tables(count, new_updates.data());

  } else {
#ifdef DEBUG_LEVEL_2
    std::stringstream s;
    s << "utils::resource::upgrade::OnUpdateDescriptorTables(no clonable.)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
  }
#ifdef DEBUG_LEVEL_3
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnUpdateDescriptorTables(done)");
#endif
  return false;
}

inline bool OnCopyDescriptorTables(
    reshade::api::device* device,
    uint32_t count,
    const reshade::api::descriptor_table_copy* copies) {
  if (device->get_api() == reshade::api::device_api::d3d12) return false;
  if (!shared.data->use_resource_cloning) return false;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnCopyDescriptorTables()");
#endif
  for (uint32_t i = 0; i < count; i++) {
    const auto& copy = copies[i];
    for (uint32_t j = 0; j < copy.count; j++) {
      auto* data = renodx::utils::data::Get<DeviceData>(device);
      if (data == nullptr) return false;
      const std::unique_lock lock(data->mutex);

      reshade::api::descriptor_heap source_heap = {0};
      uint32_t source_base_offset = 0;
      device->get_descriptor_heap_offset(copy.source_table, copy.source_binding + j, copy.source_array_offset, &source_heap, &source_base_offset);
      reshade::api::descriptor_heap dest_heap = {0};
      uint32_t dest_base_offset = 0;
      device->get_descriptor_heap_offset(copy.dest_table, copy.dest_binding + j, copy.dest_array_offset, &dest_heap, &dest_base_offset);

      bool erase = false;
      if (auto pair = data->heap_descriptor_infos.find(source_heap.handle); pair != data->heap_descriptor_infos.end()) {
        auto& source_map = pair->second;
        if (auto pair2 = source_map.find(source_base_offset); pair2 != source_map.end()) {
          if (dest_heap.handle == source_heap.handle) {
            source_map[dest_base_offset] = source_map[source_base_offset];
          } else {
            if (auto pair3 = data->heap_descriptor_infos.find(dest_heap.handle); pair3 != data->heap_descriptor_infos.end()) {
              auto& dest_map = pair3->second;
              dest_map[dest_base_offset] = source_map[source_base_offset];
            } else {
              data->heap_descriptor_infos[dest_heap.handle] = {{
                  dest_base_offset,
                  source_map[source_base_offset],
              }};
            }
          }
#ifdef DEBUG_LEVEL_1
          std::stringstream s;
          s << "utils::resource::upgrade::OnCopyDescriptorTables(cloning heap: ";
          s << PRINT_PTR(source_heap.handle);
          s << "[" << source_base_offset << "]";
          s << " => ";
          s << PRINT_PTR(dest_heap.handle);
          s << "[" << dest_base_offset << "]";
          s << ", table: " << PRINT_PTR(source_map[source_base_offset]->replacement_descriptor_handle);
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
        if (auto pair3 = data->heap_descriptor_infos.find(dest_heap.handle); pair3 != data->heap_descriptor_infos.end()) {
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

inline void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if (count == 0u) return;
  if (layout == 0u) return;
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnBindDescriptorTables()");
#endif
  auto* device = cmd_list->get_device();
  reshade::api::descriptor_table* new_tables = nullptr;
  bool built_new_tables = false;
  bool active = false;

  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  const std::unique_lock lock(data->mutex);
  reshade::api::descriptor_heap heap = {0};
  uint32_t base_offset = 0;
  for (uint32_t i = 0; i < count; ++i) {
    device->get_descriptor_heap_offset(tables[i], 0, 0, &heap, &base_offset);

    HeapDescriptorInfo* info = nullptr;
    bool found_info = false;
    if (auto pair = data->heap_descriptor_infos.find(heap.handle); pair != data->heap_descriptor_infos.end()) {
      auto& map = pair->second;
      if (auto pair2 = map.find(base_offset); pair2 != map.end()) {
        info = pair2->second;
        found_info = true;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::OnBindDescriptorTables(found heap info: ";
        s << PRINT_PTR(heap.handle);
        s << "[" << base_offset << "]";
        s << ", handle: " << PRINT_PTR(info->replacement_descriptor_handle);
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
        if (new_table.handle == 0u) {
          std::stringstream s;
          s << "utils::resource::upgrade::OnBindDescriptorTables(could not allocate new table: ";
          s << PRINT_PTR(tables[i].handle);
          s << " via ";
          s << PRINT_PTR(layout.handle);
          s << "[" << first + i << "]";
          s << ", allocated: " << (allocated ? "true" : "false");
          s << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());

          allocated = device->allocate_descriptor_table({0}, 0u, &new_table);
          if (new_table.handle == 0u) {
            std::stringstream s;
            s << "utils::resource::upgrade::OnBindDescriptorTables(could not allocate new table (2): ";
            s << PRINT_PTR(tables[i].handle);
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
        s << "utils::resource::upgrade::OnBindDescriptorTables(allocate new table pre-bind: ";
        s << PRINT_PTR(tables[i].handle);
        s << " => ";
        s << PRINT_PTR(new_table.handle);
        s << " via ";
        s << PRINT_PTR(layout.handle);
        s << "[" << first + i << "]";
        s << ", updates: " << reinterpret_cast<uintptr_t>(&info->updates);
        s << " (" << info->updates.size() << ")";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        auto* update_data = info->updates.data();
        const auto len = static_cast<uint32_t>(info->updates.size());
        for (uint32_t j = 0; j < len; ++j) {
          auto& item = update_data[j];
          item.table = {new_table.handle};
        }
#ifdef DEBUG_LEVEL_1
        std::stringstream s2;
        s2 << "utils::resource::upgrade::OnBindDescriptorTables(updated created table: ";
        s2 << reinterpret_cast<uintptr_t>(&info->updates);
        s2 << ", size" << len;
        s2 << ")";
        reshade::log::message(reshade::log::level::debug, s2.str().c_str());
#endif
        device->update_descriptor_tables(len, update_data);
        info->replacement_descriptor_handle = new_table.handle;
      } else {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::OnBindDescriptorTables(no base_offset: ";
        s << PRINT_PTR(heap.handle) << "[" << base_offset << "]";
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
        s << "utils::resource::upgrade::OnBindDescriptorTables(replace bind: ";
        s << PRINT_PTR(tables[i].handle);
        s << " => ";
        s << PRINT_PTR(new_tables[i].handle);
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
    s << "utils::resource::upgrade::OnBindDescriptorTables(apply bind)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->bind_descriptor_tables(stages, layout, first, count, new_tables);
    free(new_tables);
  } else if (built_new_tables) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnBindDescriptorTables(skip inactive replacement bind)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    free(new_tables);
  }
#ifdef DEBUG_LEVEL_2
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnBindDescriptorTables(done)");
#endif
}

// Set DescriptorTables RSVs
inline void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t layout_param,
    const reshade::api::descriptor_table_update& update) {
  if (update.count == 0u) return;
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return;

  static thread_local std::vector<reshade::api::resource_view> resource_view_descriptors;
  static thread_local std::vector<reshade::api::sampler_with_resource_view> sampler_resource_view_descriptors;
  static thread_local reshade::api::descriptor_table_update new_update;

#ifdef DEBUG_LEVEL_3
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnPushDescriptors()");
#endif

  bool changed = false;

  switch (update.type) {
    case reshade::api::descriptor_type::sampler_with_resource_view: {
      const auto* original_descriptors = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors);
      reshade::api::sampler_with_resource_view* replacement_descriptors = nullptr;
      for (uint32_t i = 0; i < update.count; i++) {
        auto resource_view = original_descriptors[i].view;
        if (resource_view.handle == 0) continue;
        auto clone = GetResourceViewClone(resource_view);
        if (clone.handle == 0) continue;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::OnPushDescriptors(found clonable: ";
        s << PRINT_PTR(clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (replacement_descriptors == nullptr) {
          if (sampler_resource_view_descriptors.size() < update.count) sampler_resource_view_descriptors.resize(update.count);
          replacement_descriptors = sampler_resource_view_descriptors.data();
          memcpy(replacement_descriptors, original_descriptors, sizeof(reshade::api::sampler_with_resource_view) * update.count);
          new_update = update;
          new_update.descriptors = replacement_descriptors;
          changed = true;
        }

        replacement_descriptors[i].view = clone;
      }
    } break;
    case reshade::api::descriptor_type::texture_shader_resource_view:
    case reshade::api::descriptor_type::texture_unordered_access_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
    case reshade::api::descriptor_type::acceleration_structure:        {
      const auto* original_descriptors = static_cast<const reshade::api::resource_view*>(update.descriptors);
      reshade::api::resource_view* replacement_descriptors = nullptr;
      for (uint32_t i = 0; i < update.count; i++) {
        auto resource_view = original_descriptors[i];
        if (resource_view.handle == 0) continue;
        auto clone = GetResourceViewClone(resource_view);
        if (clone.handle == 0) continue;

#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::OnPushDescriptors(found clonable: ";
        s << PRINT_PTR(clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

        if (replacement_descriptors == nullptr) {
          if (resource_view_descriptors.size() < update.count) resource_view_descriptors.resize(update.count);
          replacement_descriptors = resource_view_descriptors.data();
          memcpy(replacement_descriptors, original_descriptors, sizeof(reshade::api::resource_view) * update.count);
          new_update = update;
          new_update.descriptors = replacement_descriptors;
          changed = true;
        }

        replacement_descriptors[i] = clone;
      }
    } break;
    default:
      break;
  }

  if (changed) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnPushDescriptors(apply push)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->push_descriptors(stages, layout, layout_param, new_update);
  }
#ifdef DEBUG_LEVEL_3
  reshade::log::message(reshade::log::level::debug, "push_descriptors(done)");
#endif
}

// Set render target RSV
inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  if (count == 0u) return;
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return;

  RewriteRenderTargets(cmd_list, count, rtvs, dsv);
}

#if RESHADE_API_VERSION >= 20
#define RENODX_RENDER_PASS_RETURN_TYPE  bool
#define RENODX_RENDER_PASS_RETURN_VALUE false;
#else
#define RENODX_RENDER_PASS_RETURN_TYPE  void
#define RENODX_RENDER_PASS_RETURN_VALUE ;
#endif

static RENODX_RENDER_PASS_RETURN_TYPE OnBeginRenderPass(
    reshade::api::command_list* cmd_list,
    uint32_t count, const reshade::api::render_pass_render_target_desc* rts,
    const reshade::api::render_pass_depth_stencil_desc* ds
#if RESHADE_API_VERSION >= 20
    ,
    reshade::api::render_pass_flags flags
#endif
) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return RENODX_RENDER_PASS_RETURN_VALUE;

  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) {
    assert(cmd_list_data != nullptr);
    return RENODX_RENDER_PASS_RETURN_VALUE;
  }

  // ReShade handles nested render passes by ending previous
  assert(cmd_list_data->pass_count == 0);
  cmd_list_data->pass_count++;

  if (count == 0u) {
    // TODO(shortfuse): Support depth clones
    return RENODX_RENDER_PASS_RETURN_VALUE;
  }

  auto* new_rts = ApplyRenderTargetClones(rts, count);
  if (new_rts == nullptr) return RENODX_RENDER_PASS_RETURN_VALUE;
#if RESHADE_API_VERSION >= 20
  cmd_list->begin_render_pass2(count, new_rts, ds, flags);
  free(new_rts);
  return true;
#else
  // Game can possibly have sent an unused render pass
  // Doesn't truly matter if old was one flushed
  assert(cmd_list_data->pending_render_pass_render_targets.empty() && "utils::resource::upgrade::OnBeginRenderPass() - pending_render_pass_render_targets should be empty");
  cmd_list_data->pending_render_pass_render_targets.assign(new_rts, new_rts + count);
  free(new_rts);
  if (ds == nullptr) {
    cmd_list_data->pending_render_pass_depth_stencil.reset();
  } else {
    reshade::api::render_pass_depth_stencil_desc desc_copy = (*ds);
    cmd_list_data->pending_render_pass_depth_stencil = desc_copy;
  }
#endif
}

static RENODX_RENDER_PASS_RETURN_TYPE OnEndRenderPass(reshade::api::command_list* cmd_list) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return RENODX_RENDER_PASS_RETURN_VALUE;

  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data != nullptr) {
    if (cmd_list_data->pass_count > 0u) {
      cmd_list_data->pass_count--;
    } else {
      assert(cmd_list_data->pass_count > 0u && "utils::resource::upgrade::OnEndRenderPass() - pass_count should be greater than 0");
    }
    // Probe for now
    assert(cmd_list_data->pending_render_pass_render_targets.empty() && "utils::resource::upgrade::OnEndRenderPass() - pending_render_pass_render_targets should be empty");

    cmd_list_data->pending_render_pass_render_targets.clear();
    cmd_list_data->pending_render_pass_depth_stencil.reset();
  }

  return RENODX_RENDER_PASS_RETURN_VALUE;
}

#undef RENODX_RENDER_PASS_RETURN_TYPE
#undef RENODX_RENDER_PASS_RETURN_VALUE

inline bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return false;

  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return false;
  HandlePendingRenderPassRenderTargets(cmd_list, cmd_list_data);
  if (rtv.handle == 0) return false;
  auto clone = GetResourceViewClone(rtv);
  if (clone.handle != 0) {
    cmd_list->clear_render_target_view(clone, color, rect_count, rects);
  }
  return false;
}

inline auto on_render_pass_command = []<typename Context>(Context& context) -> renodx::utils::command_action::CallbackResult<Context> {
  if (!shared.IsEventHandler()) return {};
  if (context.cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return {};

  if constexpr (std::is_same_v<typename Context::ArgumentType, renodx::utils::command_action::IndirectArguments>) {
    switch (context.arguments.command) {
      case reshade::api::indirect_command::draw:
      case reshade::api::indirect_command::draw_indexed:
      case reshade::api::indirect_command::dispatch_mesh:
        HandlePendingRenderPassRenderTargets(context.cmd_list);
        break;
      default:
        break;
    }
  } else {
    HandlePendingRenderPassRenderTargets(context.cmd_list);
  }

  return {};
};

inline bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return false;

  reshade::api::resource_view clone = {0u};
  reshade::api::format format = reshade::api::format::unknown;
  const auto found_info = utils::resource::GetResourceViewInfo(uav, [&clone, &format](const utils::resource::ResourceViewInfo& info) {
    if (info.destroyed) return;
    clone = info.clone;
    format = info.desc.format;
  });
  if (!found_info) return false;
  if (clone.handle != 0) {
    switch (format) {
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

inline bool OnClearUnorderedAccessViewFloat(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const float values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return false;

  auto clone = GetResourceViewClone(uav);

  if (clone.handle != 0) {
    cmd_list->clear_unordered_access_view_float(clone, values, rect_count, rects);
  }
  return false;
}

inline bool OnResolveTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    uint32_t dest_x,
    uint32_t dest_y,
    uint32_t dest_z,
    reshade::api::format format) {
  reshade::api::resource_desc source_desc = {};
  reshade::api::resource_desc source_clone_desc = {};
  bool source_clone_enabled = false;
  reshade::api::resource source_clone_existing = {0u};
  const auto found_source_info = utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
    source_desc = info.desc;
    source_clone_desc = info.clone_desc;
    source_clone_enabled = info.clone_enabled;
    source_clone_existing = info.clone;
  });
  if (!found_source_info) return false;
  if (source_desc.type != reshade::api::resource_type::texture_2d
      && source_desc.type != reshade::api::resource_type::texture_3d) {
    return false;
  }
  reshade::api::resource_desc dest_desc = {};
  reshade::api::resource_desc dest_clone_desc = {};
  bool destination_clone_enabled = false;
  reshade::api::resource destination_clone_existing = {0u};
  const auto found_destination_info = utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
    dest_desc = info.desc;
    dest_clone_desc = info.clone_desc;
    destination_clone_enabled = info.clone_enabled;
    destination_clone_existing = info.clone;
  });
  if (!found_destination_info) return false;
  if (dest_desc.type != source_desc.type) return false;
  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_desc;
  auto dest_desc_new = dest_desc;
  bool source_clone_attempted = false;
  bool destination_clone_attempted = false;
  bool can_be_resolved = utils::resource::AreCopyFormatsCompatible(
        source_desc_new.texture.format,
        dest_desc_new.texture.format);

  auto* shared_data = shared.data;
  if (!can_be_resolved && shared_data->use_auto_cloning) {
    if (!source_clone_enabled && source_desc.texture.format != shared_data->auto_upgrade_target.new_format) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnResolveTextureRegion(";
      s << "Auto upgrading source: ";
      s << "original: " << PRINT_PTR(source.handle);
      s << ", format: " << source_desc.texture.format;
      s << ", type: " << source_desc.type;
      s << ");";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      bool should_activate_auto_clone = false;
      utils::resource::UpdateResourceInfo(source, [&](utils::resource::ResourceInfo* info) {
        if (info->clone_target == nullptr) {
          info->clone_target = &shared_data->auto_upgrade_target;
        }
        if (info->clone_target != nullptr) {
          should_activate_auto_clone = true;
        }
        source_clone_enabled = info->clone_enabled || should_activate_auto_clone;
        source_clone_existing = info->clone;
        source_clone_desc = info->clone_desc;
      });
      if (should_activate_auto_clone) {
        source_clone_existing = GetResourceClone(
            source,
            {
                .require_enabled = false,
                .allow_create = true,
                .activate = true,
            });
        source_clone_attempted = true;
        utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
          source_clone_desc = info.clone_desc;
        });
      }
    }
    if (!destination_clone_enabled && dest_desc.texture.format != shared_data->auto_upgrade_target.new_format) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnResolveTextureRegion(";
      s << "Auto upgrading destination: ";
      s << "original: " << PRINT_PTR(dest.handle);
      s << ", format: " << dest_desc.texture.format;
      s << ", type: " << dest_desc.type;
      s << ");";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      bool should_activate_auto_clone = false;
      utils::resource::UpdateResourceInfo(dest, [&](utils::resource::ResourceInfo* info) {
        if (info->clone_target == nullptr) {
          info->clone_target = &shared_data->auto_upgrade_target;
        }
        if (info->clone_target != nullptr) {
          should_activate_auto_clone = true;
        }
        destination_clone_enabled = info->clone_enabled || should_activate_auto_clone;
        destination_clone_existing = info->clone;
        dest_clone_desc = info->clone_desc;
      });
      if (should_activate_auto_clone) {
        destination_clone_existing = GetResourceClone(
            dest,
            {
                .require_enabled = false,
                .allow_create = true,
                .activate = true,
            });
        destination_clone_attempted = true;
        utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
          dest_clone_desc = info.clone_desc;
        });
      }
    }
  }

  if (source_clone_enabled || destination_clone_enabled) {
    auto source_clone =
        source_clone_enabled && source_clone_existing.handle == 0u && !source_clone_attempted
            ? CloneResource(source)
            : source_clone_existing;
    auto dest_clone =
        destination_clone_enabled && destination_clone_existing.handle == 0u && !destination_clone_attempted
            ? CloneResource(dest)
            : destination_clone_existing;

    if (source_clone.handle != 0u) {
      if (source_clone_existing.handle == 0u) {
        utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
          source_clone_desc = info.clone_desc;
        });
      }
      source_desc_new = source_clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      if (destination_clone_existing.handle == 0u) {
        utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
          dest_clone_desc = info.clone_desc;
        });
      }
      dest_desc_new = dest_clone_desc;
      dest_new = dest_clone;
    }
    can_be_resolved = utils::resource::AreCopyFormatsCompatible(
        source_desc_new.texture.format,
        dest_desc_new.texture.format);
  }

  if (can_be_resolved) {
    auto new_format = format;
    if (utils::resource::FormatToTypeless(source_desc_new.texture.format) != source_desc_new.texture.format) {
      new_format = source_desc_new.texture.format;
    } else {
      switch (source_desc_new.texture.format) {
        case reshade::api::format::r16g16b16a16_typeless:
          new_format = reshade::api::format::r16g16b16a16_float;
          break;
        case reshade::api::format::b8g8r8a8_typeless:
          new_format = reshade::api::format::b8g8r8a8_unorm;
          break;
        case reshade::api::format::r8g8b8a8_typeless:
          new_format = reshade::api::format::r8g8b8a8_unorm;
          break;
        default:
          assert(false);
          break;
      }
    }

    cmd_list->resolve_texture_region(
        source_new, source_subresource, source_box,
        dest_new, dest_subresource, dest_x, dest_y, dest_z,
        new_format);

    return true;
  }

  // Mismatched (don't resolve);
  assert(false);
#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "utils::resource::upgrade::OnResolveTextureRegion(";
  s << "prevent texture resolve: ";
  s << "original: " << PRINT_PTR(source.handle) << " => " << PRINT_PTR(dest.handle);
  s << ", format: " << source_desc.texture.format << " => " << dest_desc.texture.format;
  s << ", type: " << source_desc.type << " => " << dest_desc.type;
  s << ", clone: " << PRINT_PTR(source_new.handle) << " => " << PRINT_PTR(dest_new.handle);
  s << ", clone_format: " << source_desc_new.texture.format << " => " << dest_desc_new.texture.format;
  s << ", clone_type: " << source_desc_new.type << " => " << dest_desc_new.type;
  s << ");";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  return true;
}

inline void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  if (count == 0u) return;
  if (cmd_list->get_device()->get_api() == reshade::api::device_api::d3d12) return;

  if (count == 1u) {
    if (old_states[0] == reshade::api::resource_usage::undefined) return;
    const auto& resource = resources[0];
    if (resource.handle == 0u) return;

    auto clone = GetResourceClone(resource);
    if (clone.handle == 0u) return;

    cmd_list->barrier(clone, old_states[0], new_states[0]);
    return;
  }

  // Prefer thread_local vector rather than map; benchmarked faster for < 128 entries.
  static thread_local std::vector<std::pair<uint64_t, reshade::api::resource>> cached_resource_clones;
  static thread_local std::vector<reshade::api::resource> clone_barrier_resources;
  static thread_local std::vector<reshade::api::resource_usage> clone_barrier_old_states;
  static thread_local std::vector<reshade::api::resource_usage> clone_barrier_new_states;
  if (cached_resource_clones.size() < count) cached_resource_clones.resize(count);
  if (clone_barrier_resources.size() < count) clone_barrier_resources.resize(count);
  if (clone_barrier_old_states.size() < count) clone_barrier_old_states.resize(count);
  if (clone_barrier_new_states.size() < count) clone_barrier_new_states.resize(count);

  uint32_t cached_resource_clone_count = 0u;
  uint32_t clone_barrier_count = 0u;

  for (uint32_t i = 0; i < count; ++i) {
    if (old_states[i] == reshade::api::resource_usage::undefined) continue;
    const auto& resource = resources[i];
    if (resource.handle == 0u) continue;

    reshade::api::resource clone = {0u};
    bool found_cached_entry = false;
    for (uint32_t cache_index = 0u; cache_index < cached_resource_clone_count; ++cache_index) {
      const auto& cached_resource_clone = cached_resource_clones[cache_index];
      if (cached_resource_clone.first != resource.handle) continue;
      clone = cached_resource_clone.second;
      found_cached_entry = true;
      break;
    }

    if (!found_cached_entry) {
      clone = GetResourceClone(resource);
      cached_resource_clones[cached_resource_clone_count++] = {resource.handle, clone};
    }

    if (clone.handle == 0u) continue;
    clone_barrier_resources[clone_barrier_count] = clone;
    clone_barrier_old_states[clone_barrier_count] = old_states[i];
    clone_barrier_new_states[clone_barrier_count] = new_states[i];
    ++clone_barrier_count;
  }

  if (clone_barrier_count != 0u) {
    cmd_list->barrier(
        clone_barrier_count,
        clone_barrier_resources.data(),
        clone_barrier_old_states.data(),
        clone_barrier_new_states.data());
  }
}

inline bool OnCopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  // Reshade's get_resource_desc is more complex on D3D12, so we use our own

  reshade::api::resource_desc source_desc = {};
  reshade::api::resource_desc source_clone_desc = {};
  bool source_clone_enabled = false;
  reshade::api::resource source_clone_existing = {0u};
  const auto found_source_info = utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
    source_desc = info.desc;
    source_clone_desc = info.clone_desc;
    source_clone_enabled = info.clone_enabled;
    source_clone_existing = info.clone;
  });
  if (!found_source_info) return false;
  if (source_desc.type != reshade::api::resource_type::texture_2d
      && source_desc.type != reshade::api::resource_type::texture_3d) {
    return false;
  }
  reshade::api::resource_desc dest_desc = {};
  reshade::api::resource_desc dest_clone_desc = {};
  bool destination_clone_enabled = false;
  reshade::api::resource destination_clone_existing = {0u};
  const auto found_destination_info = utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
    dest_desc = info.desc;
    dest_clone_desc = info.clone_desc;
    destination_clone_enabled = info.clone_enabled;
    destination_clone_existing = info.clone;
  });
  if (!found_destination_info) return false;
  if (dest_desc.type != source_desc.type) return false;
  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_desc;
  auto dest_desc_new = dest_desc;

  bool source_clone_attempted = false;
  bool destination_clone_attempted = false;
  bool can_be_copied = utils::resource::AreCopyFormatsCompatible(
      source_desc_new.texture.format,
      dest_desc_new.texture.format);

  auto* shared_data = shared.data;
  if (!can_be_copied && shared_data->use_auto_cloning) {
    if (!source_clone_enabled && source_desc.texture.format != shared_data->auto_upgrade_target.new_format) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnCopyTextureRegion(";
      s << "Auto upgrading source: ";
      s << "original: " << PRINT_PTR(source.handle);
      s << ", format: " << source_desc.texture.format;
      s << ", type: " << source_desc.type;
      s << ");";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      bool should_activate_auto_clone = false;
      utils::resource::UpdateResourceInfo(source, [&](utils::resource::ResourceInfo* info) {
        if (info->clone_target == nullptr) {
          info->clone_target = &shared_data->auto_upgrade_target;
        }
        if (info->clone_target != nullptr) {
          should_activate_auto_clone = true;
        }
        source_clone_enabled = info->clone_enabled || should_activate_auto_clone;
        source_clone_existing = info->clone;
        source_clone_desc = info->clone_desc;
      });
      if (should_activate_auto_clone) {
        source_clone_existing = GetResourceClone(
            source,
            {
                .require_enabled = false,
                .allow_create = true,
                .activate = true,
            });
        source_clone_attempted = true;
        utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
          source_clone_desc = info.clone_desc;
        });
      }
    }
    if (!destination_clone_enabled && dest_desc.texture.format != shared_data->auto_upgrade_target.new_format) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnCopyTextureRegion(";
      s << "Auto upgrading destination: ";
      s << "original: " << PRINT_PTR(dest.handle);
      s << ", format: " << dest_desc.texture.format;
      s << ", type: " << dest_desc.type;
      s << ");";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      bool should_activate_auto_clone = false;
      utils::resource::UpdateResourceInfo(dest, [&](utils::resource::ResourceInfo* info) {
        if (info->clone_target == nullptr) {
          info->clone_target = &shared_data->auto_upgrade_target;
        }
        if (info->clone_target != nullptr) {
          should_activate_auto_clone = true;
        }
        destination_clone_enabled = info->clone_enabled || should_activate_auto_clone;
        destination_clone_existing = info->clone;
        dest_clone_desc = info->clone_desc;
      });
      if (should_activate_auto_clone) {
        destination_clone_existing = GetResourceClone(
            dest,
            {
                .require_enabled = false,
                .allow_create = true,
                .activate = true,
            });
        destination_clone_attempted = true;
        utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
          dest_clone_desc = info.clone_desc;
        });
      }
    }
  }

  if (source_clone_enabled || destination_clone_enabled) {
    auto source_clone =
        source_clone_enabled && source_clone_existing.handle == 0u && !source_clone_attempted
            ? CloneResource(source)
            : source_clone_existing;
    auto dest_clone =
        destination_clone_enabled && destination_clone_existing.handle == 0u && !destination_clone_attempted
            ? CloneResource(dest)
            : destination_clone_existing;

    if (source_clone.handle != 0u) {
      if (source_clone_existing.handle == 0u) {
        utils::resource::GetResourceInfo(source, [&](const utils::resource::ResourceInfo& info) {
          source_clone_desc = info.clone_desc;
        });
      }
      source_desc_new = source_clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      if (destination_clone_existing.handle == 0u) {
        utils::resource::GetResourceInfo(dest, [&](const utils::resource::ResourceInfo& info) {
          dest_clone_desc = info.clone_desc;
        });
      }
      dest_desc_new = dest_clone_desc;
      dest_new = dest_clone;
    }

    can_be_copied = utils::resource::AreCopyFormatsCompatible(
        source_desc_new.texture.format,
        dest_desc_new.texture.format);
  }

  if (can_be_copied) {
    cmd_list->copy_texture_region(source_new, source_subresource, source_box, dest_new, dest_subresource, dest_box, filter);
    return true;
  }
  // Mismatched (don't copy);

  std::stringstream s;
  s << "OnCopyTextureRegion";
  s << "(mismatched: " << PRINT_PTR(source.handle);
  s << "[" << source_subresource << "]";
  if (source.handle != source_new.handle) {
    s << "(clone: " << PRINT_PTR(source_new.handle);
  }
  if (source_box != nullptr) {
    s << " (" << source_box->top << ", " << source_box->left << ", " << source_box->front << ")";
  }
  s << " (" << source_desc.texture.format << ")";
  if (source.handle != source_new.handle) {
    s << " (clone: " << source_desc_new.texture.format << ")";
  }
  s << " => " << PRINT_PTR(dest.handle);
  if (dest.handle != dest_new.handle) {
    s << " (clone: " << PRINT_PTR(dest_new.handle);
  }
  s << "[" << dest_subresource << "]";
  s << " (" << dest_desc.texture.format << ")";
  if (dest.handle != dest_new.handle) {
    s << " (clone: " << dest_desc_new.texture.format << ")";
  }
  if (dest_box != nullptr) {
    s << " (" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";

  reshade::log::message(reshade::log::level::warning, s.str().c_str());

  // assert(false);

  if (cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan) {
    // perform blit
    cmd_list->copy_texture_region(source, source_subresource, source_box, dest, dest_subresource, dest_box);
    return true;
  } else {
    // Can't blit on D3D12 with mismatched formats.
    // Fall through to the original copy rather than silently dropping it.
    return false;
  }
}

// clang-format off







// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static void Use(DWORD fdw_reason) {
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    renodx::utils::resource::Use(fdw_reason);
  }

  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH: {
      if (shared.RegisterModule([](SharedData& data) {
            data.use_resource_cloning = data.use_resource_cloning || use_resource_cloning || use_resource_cloning_dx12_only;
            data.use_auto_cloning = data.use_auto_cloning || use_auto_cloning;
            if (use_auto_cloning) {
              data.auto_upgrade_target = auto_upgrade_target;
            }
          })) {
#ifdef DEBUG_LEVEL_0
        reshade::log::message(reshade::log::level::info, "Resource upgrade attached.");
#endif
      }

      shared.RegisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.RegisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.RegisterEvent<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
      shared.RegisterEvent<reshade::addon_event::create_resource>(OnCreateResource);
      shared.RegisterEvent<reshade::addon_event::create_resource_view>(OnCreateResourceView);

      renodx::utils::resource::RegisterOnInitResourceInfoCallback(&OnInitResourceInfo);
      renodx::utils::resource::RegisterOnDestroyResourceInfoCallback(&OnDestroyResourceInfo);
      renodx::utils::resource::RegisterOnInitResourceViewInfoCallback(&OnInitResourceViewInfo);
      renodx::utils::resource::RegisterOnDestroyResourceViewInfoCallback(&OnDestroyResourceViewInfo);
      renodx::utils::resource::RegisterOnAfterDestroyCallback(&OnAfterDestroy);

      const bool use_non_dx12_resource_cloning_events = use_resource_cloning && !use_resource_cloning_dx12_only;
      const bool use_resource_cloning_any = use_resource_cloning || use_resource_cloning_dx12_only;

      shared.RegisterEvent<reshade::addon_event::init_resource_view>(OnInitResourceView, use_resource_cloning_any);

      shared.RegisterEvent<reshade::addon_event::copy_resource>(OnCopyResource);

      shared.RegisterEvent<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      shared.RegisterEvent<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);

      shared.RegisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList, use_non_dx12_resource_cloning_events);
      shared.RegisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList, use_non_dx12_resource_cloning_events);

      shared.RegisterEvent<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil, use_non_dx12_resource_cloning_events);
      shared.RegisterEvent<reshade::addon_event::begin_render_pass>(OnBeginRenderPass, use_non_dx12_resource_cloning_events);
      shared.RegisterEvent<reshade::addon_event::end_render_pass>(OnEndRenderPass, use_non_dx12_resource_cloning_events);
      if (use_non_dx12_resource_cloning_events) {
        renodx::utils::command_action::Register(
            on_render_pass_command,
            {
                .command_types = renodx::utils::command_action::COMMAND_TYPE_DIRECT_DRAW
                               | renodx::utils::command_action::COMMAND_TYPE_DISPATCH_MESH
                               | renodx::utils::command_action::COMMAND_TYPE_INDIRECT,
            });
        renodx::utils::command_action::Use(fdw_reason);
      }
      shared.RegisterEvent<reshade::addon_event::push_descriptors>(OnPushDescriptors, use_non_dx12_resource_cloning_events);
      shared.RegisterEvent<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables, use_non_dx12_resource_cloning_events);
      // shared.RegisterEvent<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables, use_resource_cloning);
      // shared.RegisterEvent<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables, use_resource_cloning);
      shared.RegisterEvent<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView, use_non_dx12_resource_cloning_events);
      shared.RegisterEvent<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint, use_non_dx12_resource_cloning_events);
      shared.RegisterEvent<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat, use_non_dx12_resource_cloning_events);

      shared.RegisterEvent<reshade::addon_event::barrier>(OnBarrier, use_non_dx12_resource_cloning_events);
      shared.RegisterEvent<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture, use_resource_cloning_any);

      break;
    }

    case DLL_PROCESS_DETACH:
      shared.UnregisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.UnregisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);

      shared.UnregisterEvent<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      shared.UnregisterEvent<reshade::addon_event::create_resource>(OnCreateResource);
      shared.UnregisterEvent<reshade::addon_event::create_resource_view>(OnCreateResourceView);

      renodx::utils::resource::UnregisterOnInitResourceInfoCallback(&OnInitResourceInfo);
      renodx::utils::resource::UnregisterOnDestroyResourceInfoCallback(&OnDestroyResourceInfo);
      renodx::utils::resource::UnregisterOnInitResourceViewInfoCallback(&OnInitResourceViewInfo);
      renodx::utils::resource::UnregisterOnDestroyResourceViewInfoCallback(&OnDestroyResourceViewInfo);
      renodx::utils::resource::UnregisterOnAfterDestroyCallback(&OnAfterDestroy);

      shared.UnregisterEvent<reshade::addon_event::init_resource_view>(OnInitResourceView);

      shared.UnregisterEvent<reshade::addon_event::copy_resource>(OnCopyResource);

      shared.UnregisterEvent<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      shared.UnregisterEvent<reshade::addon_event::init_command_list>(OnInitCommandList);
      shared.UnregisterEvent<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      shared.UnregisterEvent<reshade::addon_event::begin_render_pass>(OnBeginRenderPass);
      shared.UnregisterEvent<reshade::addon_event::end_render_pass>(OnEndRenderPass);
      if (use_resource_cloning && !use_resource_cloning_dx12_only) {
        renodx::utils::command_action::Unregister(on_render_pass_command);
        renodx::utils::command_action::Use(fdw_reason);
      }

      shared.UnregisterEvent<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      shared.UnregisterEvent<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      shared.UnregisterEvent<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      // shared.UnregisterEvent<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      // shared.UnregisterEvent<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      shared.UnregisterEvent<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
      shared.UnregisterEvent<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
      shared.UnregisterEvent<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

      shared.UnregisterEvent<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      shared.UnregisterEvent<reshade::addon_event::barrier>(OnBarrier);
      shared.UnregisterEvent<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);

      if (shared.UnregisterModule()) {
#ifdef DEBUG_LEVEL_0
        reshade::log::message(reshade::log::level::info, "ResourceUtil detached.");
#endif
      }

      break;
  }

  if (fdw_reason == DLL_PROCESS_DETACH) {
    renodx::utils::resource::Use(fdw_reason);
  }
}

}  // namespace renodx::utils::resource::upgrade
