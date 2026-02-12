#pragma once

#include <cstdint>
#include <include/reshade.hpp>
#include <include/reshade_api_resource.hpp>
#include <shared_mutex>
#include <sstream>
#include <utility>
#include <vector>

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
  reshade::api::resource_desc back_buffer_desc;
  bool resource_upgrade_finished = false;
  std::unordered_map<uint64_t, std::unordered_map<uint32_t, HeapDescriptorInfo*>> heap_descriptor_infos;
};

struct __declspec(uuid("0a2b51ad-ef13-4010-81a4-37a4a0f857a6")) CommandListData {
  std::vector<BoundDescriptorInfo> unbound_descriptors;
  std::vector<PushDescriptorInfo> unpushed_updates;
  uint8_t pass_count = 0;
};

static bool attached = false;
static bool use_resource_cloning = false;
static bool use_auto_cloning = false;
static bool is_primary_hook = false;
static reshade::api::device* shared_handle_creator_device = nullptr;
static renodx::utils::resource::ResourceUpgradeInfo auto_upgrade_target = {
    .new_format = reshade::api::format::r16g16b16a16_float,
    .use_resource_view_cloning_and_upgrade = true,
};

inline void SetSharedHandleCreatorDevice(reshade::api::device* device) {
  shared_handle_creator_device = device;
}

static thread_local renodx::utils::resource::ResourceUpgradeInfo* local_applied_target = nullptr;
static thread_local std::optional<reshade::api::swapchain_desc> upgraded_swapchain_desc;
static thread_local std::optional<reshade::api::resource> local_original_resource;
static thread_local std::optional<reshade::api::resource_desc> local_original_resource_desc;
static thread_local std::optional<reshade::api::resource_view_desc> local_original_resource_view_desc;

inline bool ActivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  if (resource_view.handle == 0u) return false;
  auto* resource_view_info = utils::resource::GetResourceViewInfo(resource_view);

  if (resource_view_info == nullptr) {
    // Unknown
    return false;
  }

  if (resource_view_info->resource_info == nullptr) {
    std::stringstream s;
    s << "utils::resource::upgrade::ActivateCloneHotSwap(no handle for rsv ";
    s << PRINT_PTR(resource_view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }

  auto& info = *resource_view_info->resource_info;
  if (info.clone_enabled) return false;

  if (info.clone_target == nullptr) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::ActivateCloneHotSwap(";
    if (info.is_swap_chain) {
      s << ("backbuffer ");
    }
    s << "not cloned ";
    s << PRINT_PTR(info.resource.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    // Resource is not a cloned resource (fail)
    return false;
  }

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::ActivateCloneHotSwap(activating res: ";
    s << PRINT_PTR(info.resource.handle);
    s << " => clone: ";
    s << PRINT_PTR(info.clone.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
  }

#endif

  info.clone_enabled = true;

  return true;
}

inline bool DeactivateCloneHotSwap(
    reshade::api::device* device,
    const reshade::api::resource_view& resource_view) {
  auto* resource_view_info = utils::resource::GetResourceViewInfo(resource_view);

  if (resource_view_info == nullptr) {
    // Unknown
    return false;
  }

  if (resource_view_info->resource_info == nullptr) {
    std::stringstream s;
    s << "utils::resource::upgrade::ActivateCloneHotSwap(no handle for rsv ";
    s << PRINT_PTR(resource_view.handle);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
    return false;
  }

  auto& info = *resource_view_info->resource_info;
  if (!info.clone_enabled) return false;

  info.clone_enabled = false;

  return true;
}

static bool FlushResourceViewInDescriptorTable(
    reshade::api::device* device,
    const reshade::api::resource& resource) {
  return true;
}

inline reshade::api::resource CloneResource(utils::resource::ResourceInfo* resource_info) {
  if (resource_info == nullptr) return {0u};

  auto& desc = resource_info->desc;
  auto* target = resource_info->clone_target;

  // New: Early out on no target
  if (target == nullptr) return {0u};

  resource_info->clone_desc = resource_info->desc;

  reshade::api::resource_desc& new_desc = resource_info->clone_desc;

  new_desc.texture.format = target->new_format;
  new_desc.usage = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(desc.usage)
      | (target->usage_set & ~target->usage_unset));
  if (new_desc.heap == reshade::api::memory_heap::custom) {
    new_desc.heap = reshade::api::memory_heap::gpu_only;
  }

  // New: Force Texture2D if surface
  if (new_desc.type == reshade::api::resource_type::surface) {
    new_desc.type = reshade::api::resource_type::texture_2d;
  }

  auto& initial_state = resource_info->initial_state;
  reshade::api::resource& resource_clone = resource_info->clone;

#ifdef DEBUG_LEVEL_1
  std::stringstream s;
  s << "utils::resource::upgrade::CloneResource(";
  s << PRINT_PTR(resource_info->resource.handle);
  s << ", format: " << desc.texture.format << " => " << new_desc.texture.format;
  s << ", type: " << desc.type;
  s << ", flags: " << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
  s << ", heap: " << std::hex << static_cast<uint32_t>(desc.heap) << std::dec;
  s << ", usage: 0x" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
  s << ", new_usage: 0x" << std::hex << static_cast<uint32_t>(new_desc.usage) << std::dec;
  s << ", dimensions: " << desc.texture.width << "x" << desc.texture.height;
  s << ", initial_state: " << initial_state;
  s << ")";
  reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif

  void** shared_handle = nullptr;

  if (target->use_shared_handle) {
    new_desc.flags = reshade::api::resource_flags::shared;
    new_desc.type = reshade::api::resource_type::texture_2d;
    shared_handle = &resource_info->shared_handle;

    if (resource_info->device->get_api() == reshade::api::device_api::opengl) {
      new_desc.flags |= reshade::api::resource_flags::shared_nt_handle;
    }
    new_desc.usage |= reshade::api::resource_usage::copy_source;
    new_desc.usage |= reshade::api::resource_usage::copy_dest;
    if (resource_info->device != shared_handle_creator_device) {
      if (shared_handle_creator_device == nullptr) {
        // no present yet, ignore
        return {0u};
      }
      assert(resource_info->proxy_resource.handle == 0u);

      // Export a shared handle from the creator device so host creation below imports it.
      *shared_handle = nullptr;
      shared_handle_creator_device->create_resource(new_desc, nullptr, initial_state, &resource_info->proxy_resource, shared_handle);

      assert(resource_info->proxy_resource.handle != 0u);

      renodx::utils::resource::store->resource_infos[resource_info->proxy_resource.handle] = {
          .device = shared_handle_creator_device,
          .desc = new_desc,
          .resource = resource_info->proxy_resource,
      };

      // shared handle can now be used in opengl or dx9
    }

  } else {
    new_desc.flags = reshade::api::resource_flags::none;
  }

  auto* device = resource_info->device;
  if (device->create_resource(
          new_desc,
          nullptr,  // initial_data
          initial_state,
          &resource_clone,
          shared_handle)) {
    auto extra_ram = renodx::utils::resource::ComputeTextureSize(new_desc);
    utils::resource::store->resource_infos[resource_clone.handle] = {
        .device = device,
        .desc = new_desc,
        .resource = resource_clone,
        .fallback = resource_info->resource,
        .is_clone = true,
        .extra_vram = extra_ram,
        .initial_state = initial_state,
    };

#ifdef DEBUG_LEVEL_1
    {
      std::stringstream s;
      s << "utils::resource::upgrade::CloneResource(";
      s << PRINT_PTR(resource_info->resource.handle);
      s << " => " << PRINT_PTR(resource_clone.handle);
      s << ", +vram: " << extra_ram;
      s << ")";
      reshade::log::message(reshade::log::level::debug, s.str().c_str());
    }
#endif
  } else {
    resource_clone.handle = 0;
    {
      std::stringstream s;
      s << "utils::resource::cloning::CloneResource(Failed to clone: ";
      s << PRINT_PTR(resource_info->resource.handle);
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
    }
  }

  // private_data->resources_that_need_resource_view_clones.insert(resource.handle);

  return resource_info->clone;
}

inline reshade::api::resource CloneResource(const reshade::api::resource& resource) {
  return CloneResource(utils::resource::GetResourceInfo(resource));
}

inline reshade::api::resource GetResourceClone(utils::resource::ResourceInfo* resource_info = nullptr) {
  if (resource_info == nullptr) return {0u};

  if (!resource_info->clone_enabled) {
    return {0};
  }

  if (resource_info->clone.handle != 0) {
    return resource_info->clone;
  }

  CloneResource(resource_info);

  return resource_info->clone;
}

inline reshade::api::resource GetResourceClone(const reshade::api::resource& resource) {
  return GetResourceClone(utils::resource::GetResourceInfo(resource));
}

inline reshade::api::resource_view GetResourceViewClone(
    utils::resource::ResourceViewInfo* resource_view_info = nullptr) {
  if (resource_view_info == nullptr) return {0u};

  if (resource_view_info->is_clone) {
    // DX9 can sometimes return the same render clone back after depth stencil
    return {0u};
  }

  auto* target = resource_view_info->clone_target;
  if (target == nullptr) {
    if (resource_view_info == nullptr
        || resource_view_info->resource_info->clone_target == nullptr) {
      return {0u};
    }
    // Resources marked for cloning after Views were created need views updated
    target = resource_view_info->clone_target = resource_view_info->resource_info->clone_target;
  }

  const auto& resource = resource_view_info->original_resource;

  if (resource.handle == 0 || resource_view_info->resource_info == nullptr) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::GetResourceViewClone(";
    s << PRINT_PTR(resource_view_info->view.handle);
    s << ", no resource";
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    assert(resource.handle != 0 && resource_view_info->resource_info != nullptr);
    return {0u};
  }

  auto& resource_info = resource_view_info->resource_info;

  if (!resource_info->clone_enabled) return {0u};

  if (resource_view_info->clone.handle != 0u) return resource_view_info->clone;

#ifdef DEBUG_LEVEL_1
  {
    std::stringstream s;
    s << "utils::resource::upgrade::GetResourceViewClone(";
    s << PRINT_PTR(resource_view_info->view.handle);
    s << ", original resource: " << PRINT_PTR(resource.handle);
    s << ", creating view clone";
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
#endif

  auto& resource_clone = resource_info->clone;

  {
    if (resource_clone.handle == 0u) {
      CloneResource(resource_info);
    }

    if (resource_clone.handle == 0u) {
      std::stringstream s;
      s << "utils::resource::cloning::GetResourceViewClone(Failed to build resource clone: ";
      s << PRINT_PTR(resource_view_info->view.handle);
      s << ")";
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return {0u};
    }

    {
      auto* target = resource_view_info->clone_target;

      resource_view_info->clone_desc = resource_view_info->desc;
      auto& new_desc = resource_view_info->clone_desc;
      auto& usage = resource_view_info->usage;

      if (auto pair2 = target->view_upgrades.find({usage, new_desc.format});
          pair2 != target->view_upgrades.end() && pair2->second != reshade::api::format::unknown) {
        new_desc.format = pair2->second;
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::GetResourceViewClone(";
        s << PRINT_PTR(resource_view_info->view.handle);

        s << ", view_upgrades format: " << new_desc.format;
        s << ", clone: " << PRINT_PTR(resource_clone.handle);
        s << ", type: " << new_desc.type;
        s << ", usage: " << static_cast<uint32_t>(usage) << "(" << usage << ")";
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      } else {
        new_desc.format = target->new_format;
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::GetResourceViewClone(";
        s << PRINT_PTR(resource_view_info->view.handle);
        s << ", fallback format: " << new_desc.format;
        s << ", clone: " << PRINT_PTR(resource_clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
      }

      auto* device = resource_view_info->device;
      bool created = device->create_resource_view(
          resource_clone,
          usage,
          new_desc,
          &resource_view_info->clone);
      if (created) {
        renodx::utils::resource::store->resource_view_infos[resource_view_info->clone.handle] = renodx::utils::resource::ResourceViewInfo({
            .device = device,
            .desc = new_desc,
            .view = resource_view_info->clone,
            .fallback = resource_view_info->view,
            .resource_info = resource_info,
            // .clone_target = resource_info->clone_target,
            .usage = usage,
            .is_clone = true,
        });
      } else {
        resource_view_info->clone.handle = 0;
#ifdef DEBUG_LEVEL_0
        std::stringstream s;
        s << "utils::resource::upgrade::GetResourceViewClone(Failed to clone view: ";
        s << PRINT_PTR(resource_view_info->view.handle);
        s << ", original resource: " << PRINT_PTR(resource.handle);
        s << ", new usage: " << usage;
        s << ", new format: " << new_desc.format;
        s << ", new type: " << new_desc.type;
        s << ")";
        reshade::log::message(reshade::log::level::error, s.str().c_str());
#endif
        assert(false && "Failed to clone resource view");
      }
#ifdef DEBUG_LEVEL_1
      {
        std::stringstream s;
        s << "utils::resource::upgrade::GetResourceViewClone(";
        s << PRINT_PTR(resource_view_info->view.handle);
        s << " => " << PRINT_PTR(resource_view_info->clone.handle);
        s << ")";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
      }
#endif
    }
  }

  return resource_view_info->clone;
}

inline reshade::api::resource_view GetResourceViewClone(const reshade::api::resource_view& view) {
  return GetResourceViewClone(utils::resource::GetResourceViewInfo(view));
}

static reshade::api::resource_view* ApplyRenderTargetClones(
    const reshade::api::resource_view* rtvs,
    const uint32_t& count) {
  reshade::api::resource_view* new_rtvs = nullptr;
  bool changed = false;
  std::vector<std::pair<int, utils::resource::ResourceViewInfo*>> infos;

  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::resource_view& resource_view = rtvs[i];
    if (resource_view.handle == 0u) continue;
    auto* resource_view_info = utils::resource::GetResourceViewInfo(resource_view);
    if (resource_view_info != nullptr) {
      infos.emplace_back(i, resource_view_info);
    }
  }

  for (const auto& [i, info] : infos) {
    auto new_resource_view = GetResourceViewClone(info);
    if (new_resource_view.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::ApplyRenderTargetClones(rewrite ";
    s << PRINT_PTR(info->view.handle);
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
  std::vector<std::pair<int, utils::resource::ResourceViewInfo*>> infos;

  for (uint32_t i = 0; i < count; ++i) {
    const reshade::api::resource_view& resource_view = rts[i].view;
    if (resource_view.handle == 0u) continue;
    auto* resource_view_info = utils::resource::GetResourceViewInfo(resource_view);
    if (resource_view_info != nullptr) {
      infos.emplace_back(i, resource_view_info);
    }
  }

  for (const auto& [i, info] : infos) {
    auto new_resource_view = GetResourceViewClone(info);
    if (new_resource_view.handle == 0u) continue;

#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::ApplyRenderTargetClones(rewrite ";
    s << PRINT_PTR(info->view.handle);
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
  return true;
}

// clang-format off






























// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format off

// Hooks

static void OnInitDevice(reshade::api::device* device) {
  DeviceData* data;
  bool created = renodx::utils::data::CreateOrGet(device, data);

  if (created) {
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitDevice(Hooking device: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());

    is_primary_hook = true;
  } else {
    std::stringstream s;
    s << "utils::resource::upgrade::OnInitDevice(Attaching to hook: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ", api: " << device->get_api();
    s << ")";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
  }
};

static void OnDestroyDevice(reshade::api::device* device) {
  if (!is_primary_hook) return;
  std::stringstream s;
  s << "utils::resource::upgrade::OnDestroyDevice(";
  s << reinterpret_cast<uintptr_t>(device);
  s << ")";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
  renodx::utils::data::Delete<DeviceData>(device);
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

static void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

static void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (!is_primary_hook) return;
  auto* device = swapchain->get_device();
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  data->back_buffer_desc = device->get_resource_desc(swapchain->get_current_back_buffer());
  data->resource_upgrade_finished = false;
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnInitSwapchain(reset resource upgrade)");
  const uint32_t len = data->upgrade_infos.size();
  // Reset
  for (uint32_t i = 0; i < len; i++) {
    auto* target = &data->upgrade_infos[i];
    if (target->ignore_reset) continue;
    target->counted = 0;
    target->completed = false;
  }
}

static bool OnCreateResource(
    reshade::api::device* device,
    reshade::api::resource_desc& desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage initial_state) {
  if (!is_primary_hook) return false;
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
  if (private_data->resource_upgrade_finished) return false;

  // Lock not needed since device creation is single-threaded
  // const std::unique_lock lock(private_data->mutex);

  if (private_data->back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnCreateResource(No swapchain desc: ";
    s << reinterpret_cast<uintptr_t>(device);
    s << ")";
    reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    // return false;
  }

  const auto& device_back_buffer_desc = private_data->back_buffer_desc;
  auto& upgrade_infos = private_data->upgrade_infos;
  const auto len = upgrade_infos.size();

  // const float resource_tag = -1;

  renodx::utils::resource::ResourceUpgradeInfo* found_target = nullptr;
  bool all_completed = true;
  bool found_exact = false;
  for (auto i = 0; i < len; i++) {
    renodx::utils::resource::ResourceUpgradeInfo* target = &upgrade_infos[i];
    if (target->completed) continue;
    if (
        !target->use_resource_view_cloning
        && !target->use_resource_view_cloning_and_upgrade
        && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResource(counting target";
      s << ", format: " << target->old_format;
      s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
      s << ", index: " << target->index;
      s << ", counted: " << target->counted;
      // s << ", data: " << PRINT_PTR(initial_data);
      s << ") [" << i << "/" << len << "]";
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

  if (found_target == nullptr) return false;

  if (all_completed) {
    private_data->resource_upgrade_finished = true;
  }

  reshade::api::resource original_resource = {0};

  if (initial_data != nullptr) {
    // Create a temporary texture to store the texture data instead
    device->create_resource(
        desc,
        initial_data,
        initial_state,
        &original_resource);

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
    s << ", flags: 0x" << std::hex << static_cast<uint32_t>(desc.flags) << std::dec;
    s << ", state: 0x" << std::hex << static_cast<uint32_t>(initial_state) << std::dec;
    s << ", format: " << desc.texture.format << " => " << found_target->new_format;
    s << ", width: " << desc.texture.width;
    s << ", height: " << desc.texture.height;
    s << ", usage: " << desc.usage << "(" << std::hex << static_cast<uint32_t>(desc.usage) << std::dec << ")";
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
  if (!is_primary_hook) return;

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

  // const std::unique_lock lock(private_data.mutex);

  auto& resource = resource_info->resource;
  auto& initial_state = resource_info->initial_state;
  bool changed = false;

  if (local_applied_target != nullptr) {
    changed = true;
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

  } else if (use_resource_cloning) {
    auto* private_data = renodx::utils::data::Get<DeviceData>(device);
    if (private_data == nullptr) {
      assert(private_data != nullptr);
      return;
    }

    if (resource_info->is_swap_chain) {
      // Swapchain upgrades can only be handled on CreateSwapchain
      return;
    }

    if (private_data->resource_upgrade_finished) return;
    const auto& device_back_buffer_desc = private_data->back_buffer_desc;

    if (device_back_buffer_desc.type == reshade::api::resource_type::unknown) {
#ifdef DEBUG_LEVEL_1
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResource(No swapchain desc: ";
      s << reinterpret_cast<uintptr_t>(device);
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
      // New, upgrade infos can now handle unknown back buffer state
      // return;
    }

    auto& upgrade_infos = private_data->upgrade_infos;
    const uint32_t len = upgrade_infos.size();

    renodx::utils::resource::ResourceUpgradeInfo* found_target = nullptr;
    bool all_completed = true;
    bool found_exact = false;
    for (uint32_t i = 0; i < len; i++) {
      auto* target = &upgrade_infos[i];
      if (target->completed) continue;
      if (
          (target->use_resource_view_cloning
           || target->use_resource_view_cloning_and_upgrade)
          && target->CheckResourceDesc(desc, device_back_buffer_desc, initial_state)) {
#ifdef DEBUG_LEVEL_1
        std::stringstream s;
        s << "utils::resource::upgrade::OnInitResource(counting target";
        s << ", format: " << target->old_format;
        s << ", usage: " << std::hex << static_cast<uint32_t>(desc.usage) << std::dec;
        s << ", index: " << target->index;
        s << ", counted: " << target->counted;
        s << ") [" << i << "/" << len << "]";
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
    if (found_target != nullptr) {
      if (all_completed) {
#ifdef DEBUG_LEVEL_1
        reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnInitResource(All resource cloning completed)");
#endif
        private_data->resource_upgrade_finished = true;
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
  if (!is_primary_hook) return;

  if (!info->is_clone && info->fallback.handle != 0u) {
    info->device->destroy_resource(info->fallback);
    info->fallback.handle = 0u;
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
    info->device->destroy_resource(info->clone);
    info->clone.handle = 0u;

    // todo: Signal clone destruction
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
  if (!is_primary_hook) return false;
  auto* source_info = utils::resource::GetResourceInfo(source);
  if (source_info == nullptr) return false;

  auto* destination_info = utils::resource::GetResourceInfo(dest);

  if (destination_info == nullptr) return false;

  const auto source_clone = GetResourceClone(source_info);
  const auto dest_clone = GetResourceClone(destination_info);

  if (!source_info->upgraded && !destination_info->upgraded
      && (source_clone.handle == 0u) && (dest_clone.handle == 0u)) return false;

  if (destination_info->desc.texture.format == destination_info->clone_desc.texture.format) {
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnCopyBufferToTexture(Redirected to clone: ";
    s << PRINT_PTR(dest.handle);
    s << " => " << PRINT_PTR(dest_clone.handle);
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
  s << "utils::resource::upgrade::OnCopyBufferToTexture(mismatched ";
  s << PRINT_PTR(source.handle);
  s << "[" << source_offset << "]";
  s << " => " << PRINT_PTR(dest.handle);
  s << "[" << dest_subresource << "]";
  s << " (" << destination_info->clone_desc.texture.format << ")";
  if (dest_box != nullptr) {
    s << "(" << dest_box->top << ", " << dest_box->left << ", " << dest_box->front << ")";
  }
  s << ")";

  reshade::log::message(reshade::log::level::warning, s.str().c_str());

  if (cmd_list->get_device()->get_api() == reshade::api::device_api::vulkan) {
    // perform blit
    cmd_list->copy_texture_region(dest, dest_subresource, dest_box, dest_clone, dest_subresource, dest_box);
    return true;
  } else {
    // Perform DirectX blit
    return true;
  }

  return true;
}

inline bool OnCreateResourceView(
    reshade::api::device* device,
    reshade::api::resource resource,
    reshade::api::resource_usage usage_type,
    reshade::api::resource_view_desc& desc) {
  if (!is_primary_hook) return false;
  assert(local_original_resource_view_desc.has_value() == false);
  local_original_resource_view_desc.reset();
  if (resource.handle == 0u) return false;

  // if (device == proxy_device_reshade) return false;

  bool expected = false;
  bool found_upgrade = false;

  utils::resource::ResourceInfo* resource_info = nullptr;
  reshade::api::resource_view_desc current_desc = desc;
  if (desc.type == reshade::api::resource_view_type::unknown) {
    resource_info = utils::resource::GetResourceInfo(resource);
    if (resource_info == nullptr) return false;
    current_desc = utils::resource::PopulateUnknownResourceViewDesc(device, desc, usage_type, resource_info);
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

  utils::resource::ResourceInfo temp_resource_info = {};
  if (resource_info == nullptr) {
    resource_info = utils::resource::GetResourceInfo(resource);
    if (resource_info == nullptr) {
      auto reshade_desc = device->get_resource_desc(resource);
      temp_resource_info = {
          .device = device,
          .desc = reshade_desc,
          .resource = resource,
          .initial_state = reshade::api::resource_usage::general,
      };
      resource_info = &temp_resource_info;

#ifdef DEBUG_LEVEL_0
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResourceView(Unknown resource: ";
      s << PRINT_PTR(resource.handle);
      s << ", type: " << desc.type;
      s << ", format: " << desc.format;
      s << ", resource type: " << reshade_desc.type;
      s << ", resource format: " << reshade_desc.texture.format;
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
#endif
    }
  }

  if (current_desc.format == reshade::api::format::unknown) {
    current_desc = utils::resource::PopulateUnknownResourceViewDesc(device, desc, usage_type, resource_info);
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

  reshade::api::resource_desc& resource_desc = resource_info->desc;
  bool& is_back_buffer = resource_info->is_swap_chain;

  if (is_back_buffer) {
    // Back buffers should have their upgrade_target set already
    // Treat no differently than other resources
  }
  if (resource_info->upgrade_target != nullptr) {
    auto* target = resource_info->upgrade_target;
    if (auto pair2 = target->view_upgrades.find({usage_type, current_desc.format});
        pair2 != target->view_upgrades.end() && pair2->second != reshade::api::format::unknown) {
      new_desc.format = pair2->second;
      found_upgrade = true;
      expected = true;
    }
  }
  if (resource_info->upgrade_target != nullptr) {
    if (!found_upgrade) {
      std::stringstream s;
      s << "utils::resource::upgrade::OnCreateResourceView(";
      s << "unexpected case(" << current_desc.format << ")";
      s << ")";
      reshade::log::message(reshade::log::level::warning, s.str().c_str());
    }
  } else {
    // Resource upgrades in general may cause format mismatches
    auto typeless_resource_format = utils::resource::FormatToTypeless(resource_desc.texture.format);
    auto typeless_view_format = utils::resource::FormatToTypeless(current_desc.format);
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
            std::stringstream s;
            s << "utils::resource::upgrade::OnCreateResourceView(";
            s << "unexpected case(" << current_desc.format << ")";
            s << ")";
            reshade::log::message(reshade::log::level::warning, s.str().c_str());
            assert(false);
        }
      }
    }
  }

  const bool changed = (current_desc.format != new_desc.format);

  if (changed
#ifdef DEBUG_LEVEL_1
      || true
#endif
  ) {
    std::stringstream s;
    s << "utils::resource::upgrade::OnCreateResourceView(" << (changed ? "upgrading" : "logging");
    s << ", found_upgrade: " << (found_upgrade ? "true" : "false");
    if (is_back_buffer) {
      s << ", back buffer view";
    }
    s << ", expected: " << (expected ? "true" : "false");
    s << ", view type: " << desc.type << " => " << current_desc.type;
    s << ", view format: " << desc.format << " => " << current_desc.format << " => " << new_desc.format;
    s << ", resource: " << PRINT_PTR(resource.handle);
    s << ", resource width: " << resource_desc.texture.width;
    s << ", resource height: " << resource_desc.texture.height;
    s << ", resource format: " << resource_desc.texture.format;
    s << ", resource usage: " << usage_type;
    s << ")";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  };


  if (use_resource_cloning) {
    if (resource_info->clone_target != nullptr) {
      auto* upgrade_info = resource_info->clone_target;
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
}

inline void OnDestroyResourceViewInfo(utils::resource::ResourceViewInfo* resource_view_info) {
#ifdef DEBUG_LEVEL_2
  if (resource_view_info->resource_info != nullptr && resource_view_info->resource_info->is_swap_chain) {
    reshade::log::message(reshade::log::level::warning, "Destroyed swapchain RTV");
  }
#endif
  if (resource_view_info->clone.handle != 0u) {
    assert(resource_view_info->device != nullptr);
    resource_view_info->device->destroy_resource_view(resource_view_info->clone);
    resource_view_info->clone.handle = 0u;
  }

  if (!resource_view_info->is_clone && resource_view_info->fallback.handle != 0u) {
    assert(resource_view_info->device != nullptr);
    resource_view_info->device->destroy_resource_view(resource_view_info->fallback);
    resource_view_info->fallback.handle = 0u;
  }
}

inline bool OnCopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  if (!is_primary_hook) return false;
  auto* source_info = utils::resource::GetResourceInfo(source);
  if (source_info == nullptr) return false;

  auto& source_desc = source_info->desc;

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

  auto* destination_info = utils::resource::GetResourceInfo(dest);
  if (destination_info == nullptr) return false;
  auto& dest_desc = destination_info->desc;

  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_desc;
  auto dest_desc_new = dest_desc;

  bool can_be_copied;

  if (use_resource_cloning) {
    auto source_clone = GetResourceClone(source_info);
    auto dest_clone = GetResourceClone(destination_info);

    if (source_clone.handle != 0u) {
      source_desc_new = source_info->clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      dest_desc_new = destination_info->clone_desc;
      dest_new = dest_clone;
    }
    can_be_copied = (source_desc_new.texture.format == dest_desc_new.texture.format)
                    || (utils::resource::FormatToTypeless(source_desc_new.texture.format) == utils::resource::FormatToTypeless(dest_desc_new.texture.format))
                    || utils::resource::IsCompressible(source_desc_new.texture.format, dest_desc_new.texture.format);

    if (!can_be_copied && use_auto_cloning) {
      if (source_info->desc.texture.format != auto_upgrade_target.new_format && source_info->clone_target == nullptr) {
        std::stringstream s;
        s << "utils::resource::upgrade::OnCopyResource(";
        s << "Auto upgrading source: ";
        s << "original: " << PRINT_PTR(source.handle);
        s << ", format: " << source_desc.texture.format;
        s << ", type: " << source_desc.type;
        s << ");";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
        source_info->clone_target = &auto_upgrade_target;
      }
      if (destination_info->desc.texture.format != auto_upgrade_target.new_format && destination_info->clone_target == nullptr) {
        std::stringstream s;
        s << "utils::resource::upgrade::OnCopyResource(";
        s << "Auto upgrading destination: ";
        s << "original: " << PRINT_PTR(dest.handle);
        s << ", format: " << dest_desc.texture.format;
        s << ", type: " << dest_desc.type;
        s << ");";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
        destination_info->clone_target = &auto_upgrade_target;
      }
    }
  } else {
    can_be_copied = (source_desc_new.texture.format == dest_desc_new.texture.format)
                    || (utils::resource::FormatToTypeless(source_desc_new.texture.format) == utils::resource::FormatToTypeless(dest_desc_new.texture.format))
                    || utils::resource::IsCompressible(source_desc_new.texture.format, dest_desc_new.texture.format);
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
  if (!is_primary_hook) return false;
  if (count == 0u) return false;
#ifdef DEBUG_LEVEL_3
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnUpdateDescriptorTables()");
#endif
  reshade::api::descriptor_table_update* new_updates = nullptr;
  bool changed = false;
  // bool active = false;

  // std::vector<std::pair<std::pair<int, int>, utils::resource::ResourceViewInfo*>> infos;

  for (uint32_t i = 0; i < count; ++i) {
    const auto& update = updates[i];
    if (update.table.handle == 0u) continue;
    for (uint32_t j = 0; j < update.count; j++) {
      switch (update.type) {
        case reshade::api::descriptor_type::sampler_with_resource_view: {
          const auto& item = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[j];
          auto resource_view = item.view;
          if (resource_view.handle == 0u) continue;
          auto* info = utils::resource::GetResourceViewInfo(resource_view);
          auto resource_view_clone = GetResourceViewClone(info);
          if (resource_view_clone.handle == 0u) continue;
#ifdef DEBUG_LEVEL_2
          std::stringstream s;
          s << "utils::resource::upgrade::OnUpdateDescriptorTables(found clonable: ";
          s << PRINT_PTR(resource_view_clone.handle);
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

        } break;
        case reshade::api::descriptor_type::texture_shader_resource_view:
        case reshade::api::descriptor_type::texture_unordered_access_view:
        case reshade::api::descriptor_type::buffer_shader_resource_view:
        case reshade::api::descriptor_type::buffer_unordered_access_view:
        case reshade::api::descriptor_type::acceleration_structure:        {
          const auto& resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[j];
          if (resource_view.handle == 0u) continue;
          auto* info = utils::resource::GetResourceViewInfo(resource_view);
          auto resource_view_clone = GetResourceViewClone(info);
          if (resource_view_clone.handle == 0u) continue;
#ifdef DEBUG_LEVEL_2
          std::stringstream s;
          s << "utils::resource::upgrade::OnUpdateDescriptorTables(found clonable: ";
          s << PRINT_PTR(resource_view_clone.handle);
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
        } break;
        default:
          break;
      }
    }
  }

  if (changed) {
    device->update_descriptor_tables(count, new_updates);
    // free(new_updates);

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
  if (!is_primary_hook) return false;
  if (!use_resource_cloning) return false;
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
  if (!is_primary_hook) return;
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
        auto len = info->updates.size();
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
  } else if (built_new_tables) {
    auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
    if (cmd_data == nullptr) return;
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnBindDescriptorTables(storing unbound descriptor)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_data->unbound_descriptors.push_back({
        .stages = stages,
        .layout = layout,
        .first = first,
        .count = count,
        .tables = {new_tables[0], new_tables[count - 1]},
    });
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
  if (!is_primary_hook) return;
  if (update.count == 0u) return;

  reshade::api::descriptor_table_update new_update;

#ifdef DEBUG_LEVEL_3
  reshade::log::message(reshade::log::level::debug, "utils::resource::upgrade::OnPushDescriptors()");
#endif

  bool changed = false;
  bool active = false;

  for (uint32_t i = 0; i < update.count; i++) {
    // if (!update.table.handle) continue;
    switch (update.type) {
      case reshade::api::descriptor_type::sampler_with_resource_view: {
        auto resource_view = static_cast<const reshade::api::sampler_with_resource_view*>(update.descriptors)[i].view;
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

        if (!changed) {
          new_update = renodx::utils::descriptor::CloneDescriptorTableUpdates(&update, 1)[0];
        }

        // NOLINTNEXTLINE(google-readability-casting)
        ((reshade::api::sampler_with_resource_view*)(new_update.descriptors))[i].view = clone;
        changed = true;
        break;
      }
      case reshade::api::descriptor_type::texture_shader_resource_view:
      case reshade::api::descriptor_type::texture_unordered_access_view:
      case reshade::api::descriptor_type::buffer_shader_resource_view:
      case reshade::api::descriptor_type::buffer_unordered_access_view:
      case reshade::api::descriptor_type::acceleration_structure:        {
        auto resource_view = static_cast<const reshade::api::resource_view*>(update.descriptors)[i];
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
    s << "utils::resource::upgrade::OnPushDescriptors(apply push)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_list->push_descriptors(stages, layout, layout_param, new_update);
  } else if (changed) {
    auto* cmd_data = renodx::utils::data::Get<CommandListData>(cmd_list);
    if (cmd_data == nullptr) return;
#ifdef DEBUG_LEVEL_1
    std::stringstream s;
    s << "utils::resource::upgrade::OnPushDescriptors(storing unpushed descriptor)";
    reshade::log::message(reshade::log::level::debug, s.str().c_str());
#endif
    cmd_data->unpushed_updates.push_back({
        .stages = stages,
        .layout = layout,
        .layout_param = layout_param,
        .update = new_update,
    });
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
  if (!is_primary_hook) return;
  if (count == 0u) return;

  RewriteRenderTargets(cmd_list, count, rtvs, dsv);
}

static void OnBeginRenderPass(
    reshade::api::command_list* cmd_list,
    uint32_t count, const reshade::api::render_pass_render_target_desc* rts,
    const reshade::api::render_pass_depth_stencil_desc* ds) {
  if (!is_primary_hook) return;
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;

  // Ignore subpasses
  if (cmd_list_data->pass_count++ != 0) return;

  auto* new_rts = ApplyRenderTargetClones(rts, count);
  if (new_rts == nullptr) return;
  cmd_list->end_render_pass();
  cmd_list->begin_render_pass(count, new_rts, ds);
  free(new_rts);
}

static void OnEndRenderPass(reshade::api::command_list* cmd_list) {
  if (!is_primary_hook) return;
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;
  cmd_list_data->pass_count--;
}

inline bool OnClearRenderTargetView(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view rtv,
    const float color[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!is_primary_hook) return false;
  if (rtv.handle == 0) return false;
  auto clone = GetResourceViewClone(rtv);
  if (clone.handle != 0) {
    cmd_list->clear_render_target_view(clone, color, rect_count, rects);
  }
  return false;
}

inline bool OnClearUnorderedAccessViewUint(
    reshade::api::command_list* cmd_list,
    reshade::api::resource_view uav,
    const uint32_t values[4],
    uint32_t rect_count,
    const reshade::api::rect* rects) {
  if (!is_primary_hook) return false;
  auto* info = utils::resource::GetResourceViewInfo(uav);
  if (info == nullptr) return false;
  auto& clone = info->clone;
  if (clone.handle != 0) {
    switch (info->desc.format) {
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
  if (!is_primary_hook) return false;
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
  if (!is_primary_hook) return false;
  auto* source_info = utils::resource::GetResourceInfo(source);
  if (source_info == nullptr) return false;

  auto* destination_info = utils::resource::GetResourceInfo(dest);
  if (destination_info == nullptr) return false;

  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_info->desc;
  auto dest_desc_new = destination_info->desc;

  bool can_be_resolved;

  if (use_resource_cloning) {
    auto source_clone = GetResourceClone(source_info);
    auto dest_clone = GetResourceClone(destination_info);

    if (source_clone.handle != 0u) {
      source_desc_new = source_info->clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      dest_desc_new = destination_info->clone_desc;
      dest_new = dest_clone;
    }
    can_be_resolved = (source_desc_new.texture.format == dest_desc_new.texture.format)
                      || (utils::resource::FormatToTypeless(source_desc_new.texture.format) == utils::resource::FormatToTypeless(dest_desc_new.texture.format))
                      || utils::resource::IsCompressible(source_desc_new.texture.format, dest_desc_new.texture.format);

    if (!can_be_resolved && use_auto_cloning) {
      if (source_info->desc.texture.format != auto_upgrade_target.new_format && source_info->clone_target == nullptr) {
        std::stringstream s;
        s << "utils::resource::upgrade::OnResolveTextureRegion(";
        s << "Auto upgrading source: ";
        s << "original: " << PRINT_PTR(source.handle);
        s << ", format: " << source_info->desc.texture.format;
        s << ", type: " << source_info->desc.type;
        s << ");";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
        source_info->clone_target = &auto_upgrade_target;
      }
      if (destination_info->desc.texture.format != auto_upgrade_target.new_format && destination_info->clone_target == nullptr) {
        std::stringstream s;
        s << "utils::resource::upgrade::OnResolveTextureRegion(";
        s << "Auto upgrading destination: ";
        s << "original: " << PRINT_PTR(dest.handle);
        s << ", format: " << destination_info->desc.texture.format;
        s << ", type: " << destination_info->desc.type;
        s << ");";
        reshade::log::message(reshade::log::level::debug, s.str().c_str());
        destination_info->clone_target = &auto_upgrade_target;
      }
    }
  } else {
    can_be_resolved = (source_desc_new.texture.format == dest_desc_new.texture.format)
                      || (utils::resource::FormatToTypeless(source_desc_new.texture.format) == utils::resource::FormatToTypeless(dest_desc_new.texture.format))
                      || utils::resource::IsCompressible(source_desc_new.texture.format, dest_desc_new.texture.format);
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
#ifndef DEBUG_LEVEL_1
  std::stringstream s;
  s << "utils::resource::upgrade::OnResolveTextureRegion(";
  s << "prevent texture resolve: ";
  s << "original: " << PRINT_PTR(source.handle) << " => " << PRINT_PTR(dest.handle);
  s << ", format: " << source_info->desc.texture.format << " => " << destination_info->desc.texture.format;
  s << ", type: " << source_info->desc.type << " => " << destination_info->desc.type;
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
  if (!is_primary_hook) return;
  if (count == 0u) return;

  std::unordered_set<uint64_t> checked_resources;
  // std::vector<std::pair<int, utils::resource::ResourceInfo*>> infos;

  for (uint32_t i = 0; i < count; ++i) {
    if (old_states[i] == reshade::api::resource_usage::undefined) continue;
    const auto& resource = resources[i];
    if (resource.handle == 0u) continue;
    bool checked = !checked_resources.insert(resource.handle).second;
    if (checked) continue;
    auto* info = utils::resource::GetResourceInfo(resource);
    if (info == nullptr) continue;
    if (info->destroyed) continue;
    auto clone = GetResourceClone(info);
    if (clone.handle == 0u) continue;
    cmd_list->barrier(clone, old_states[i], new_states[i]);
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
  if (!is_primary_hook) return false;
  // Reshade's get_resource_desc is more complex on D3D12, so we use our own

  auto* source_info = utils::resource::GetResourceInfo(source);
  if (source_info == nullptr) return false;
  auto& source_desc = source_info->desc;
  if (source_desc.type != reshade::api::resource_type::texture_2d
      && source_desc.type != reshade::api::resource_type::texture_3d) {
    return false;
  }
  auto* destination_info = utils::resource::GetResourceInfo(dest);
  if (destination_info == nullptr) return false;

  auto& dest_desc = destination_info->desc;
  if (dest_desc.type != source_desc.type) return false;
  auto source_new = source;
  auto dest_new = dest;
  auto source_desc_new = source_desc;
  auto dest_desc_new = dest_desc;
  if (use_resource_cloning) {
    auto source_clone = GetResourceClone(source_info);
    auto dest_clone = GetResourceClone(destination_info);

    if (source_clone.handle != 0u) {
      source_desc_new = source_info->clone_desc;
      source_new = source_clone;
    }
    if (dest_clone.handle != 0u) {
      dest_desc_new = destination_info->clone_desc;
      dest_new = dest_clone;
    }
  }

  bool can_be_copied = (source_desc_new.texture.format == dest_desc_new.texture.format)
                       || (utils::resource::FormatToTypeless(source_desc_new.texture.format) == utils::resource::FormatToTypeless(dest_desc_new.texture.format))
                       || utils::resource::IsCompressible(source_desc_new.texture.format, dest_desc_new.texture.format);

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
    s << " (clone: " << PRINT_PTR(source_new.handle);
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
    // Perform DirectX blit
    return true;
  }
}


// clang-format off







// THIS SPACE INTENTIONALLY LEFT BLANK

// clang-format on

static void Use(DWORD fdw_reason) {
  renodx::utils::resource::Use(fdw_reason);
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::log::message(reshade::log::level::info, "Resource upgrade attached.");

      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);
      reshade::register_event<reshade::addon_event::create_resource>(OnCreateResource);
      reshade::register_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);

      renodx::utils::resource::store->on_init_resource_info_callbacks.emplace_back(&OnInitResourceInfo);
      renodx::utils::resource::store->on_destroy_resource_info_callbacks.emplace_back(&OnDestroyResourceInfo);
      renodx::utils::resource::store->on_init_resource_view_info_callbacks.emplace_back(&OnInitResourceViewInfo);
      renodx::utils::resource::store->on_destroy_resource_view_info_callbacks.emplace_back(&OnDestroyResourceViewInfo);

      reshade::register_event<reshade::addon_event::copy_resource>(OnCopyResource);

      reshade::register_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);

      if (use_resource_cloning) {
        reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
        reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);

        reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
        reshade::register_event<reshade::addon_event::begin_render_pass>(OnBeginRenderPass);
        reshade::register_event<reshade::addon_event::end_render_pass>(OnEndRenderPass);
        reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
        reshade::register_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
        // reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
        // reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
        reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
        reshade::register_event<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

        reshade::register_event<reshade::addon_event::barrier>(OnBarrier);
        reshade::register_event<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);
      }

      break;

    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      reshade::log::message(reshade::log::level::info, "ResourceUtil detached.");
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);

      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

      // reshade::register_event<reshade::addon_event::create_pipeline>(on_create_pipeline);

      reshade::unregister_event<reshade::addon_event::create_resource>(OnCreateResource);
      reshade::unregister_event<reshade::addon_event::create_resource_view>(OnCreateResourceView);

      // renodx::utils::resource::on_init_resource_info_callbacks.erase(&OnInitResourceInfo);
      // renodx::utils::resource::on_destroy_resource_info_callbacks.erase(&OnDestroyResourceInfo);
      // renodx::utils::resource::on_init_resource_view_info_callbacks.erase(&OnInitResourceViewInfo);
      // renodx::utils::resource::on_destroy_resource_view_info_callbacks.erase(&OnDestroyResourceViewInfo);

      reshade::unregister_event<reshade::addon_event::copy_resource>(OnCopyResource);

      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(OnResolveTextureRegion);

      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::begin_render_pass>(OnBeginRenderPass);
      reshade::unregister_event<reshade::addon_event::end_render_pass>(OnEndRenderPass);

      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::update_descriptor_tables>(OnUpdateDescriptorTables);
      // reshade::register_event<reshade::addon_event::copy_descriptor_tables>(OnCopyDescriptorTables);
      // reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::unregister_event<reshade::addon_event::clear_render_target_view>(OnClearRenderTargetView);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_uint>(OnClearUnorderedAccessViewUint);
      reshade::unregister_event<reshade::addon_event::clear_unordered_access_view_float>(OnClearUnorderedAccessViewFloat);

      reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::barrier>(OnBarrier);
      reshade::unregister_event<reshade::addon_event::copy_buffer_to_texture>(OnCopyBufferToTexture);

      break;
  }
}

}  // namespace renodx::utils::resource::upgrade
