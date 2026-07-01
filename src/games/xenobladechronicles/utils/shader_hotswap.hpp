/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <windows.h>

#include <cstdint>
#include <mutex>
#include <shared_mutex>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <include/reshade.hpp>

#include "../../../utils/bitwise.hpp"
#include "../../../utils/data.hpp"
#include "../../../utils/resource.hpp"
#include "../../../utils/resource_upgrade.hpp"
#include "../../../utils/shader.hpp"

namespace renodx_custom::utils::shader_hotswap {

inline std::vector<renodx::utils::resource::ResourceUpgradeInfo> targets;
inline std::vector<uint32_t> disable_hashes;

namespace internal {

struct ShaderHotSwap {
  std::vector<uint32_t> target_indices;
  std::unordered_map<uint64_t, uint32_t> resource_targets;
};

struct __declspec(uuid("7b4133e4-66d8-41d4-8b88-aeff73353fd3")) DeviceData {
  std::shared_mutex mutex;
  std::unordered_map<uint32_t, ShaderHotSwap> shader_hot_swaps;
  std::unordered_map<uint32_t, uint32_t> shader_hot_swap_pass_counts;
  bool suspended = false;
};

struct __declspec(uuid("b566b301-2b89-45a6-a3bb-1afab2f599f4")) CommandListData {
  std::vector<reshade::api::resource_view> current_render_targets;
  std::vector<uint32_t> active_shader_hashes;
  std::unordered_set<uint32_t> shader_hot_swap_counted_targets;
  uint8_t pass_count = 0;
};

inline void RebuildShaderHotSwaps(DeviceData& hot_swap_data) {
  hot_swap_data.shader_hot_swaps.clear();
  for (uint32_t i = 0; i < targets.size(); ++i) {
    auto& target = targets[i];
    if (target.shader_hash == 0u) continue;
    hot_swap_data.shader_hot_swaps[target.shader_hash].target_indices.push_back(i);
  }
}

inline bool IsManagedTarget(const renodx::utils::resource::ResourceUpgradeInfo* target) {
  if (target == nullptr || targets.empty()) return false;
  const auto* target_begin = targets.data();
  const auto* target_end = target_begin + targets.size();
  return target >= target_begin && target < target_end;
}

inline bool IsDisableHash(uint32_t shader_hash) {
  return std::ranges::any_of(disable_hashes, [shader_hash](uint32_t hash) {
    return hash == shader_hash;
  });
}

inline void ResetShaderHotSwapState(DeviceData* hot_swap_data = nullptr) {
  if (hot_swap_data != nullptr) {
    hot_swap_data->shader_hot_swaps.clear();
    hot_swap_data->shader_hot_swap_pass_counts.clear();
  }

  for (auto& target : targets) {
    target.completed = false;
  }
}

inline void DetachPromotedTargets(reshade::api::device* device) {
  if (device == nullptr) return;

  std::vector<reshade::api::resource> managed_resources;
  renodx::utils::resource::ForEachResourceInfo([&](const renodx::utils::resource::ResourceInfo& info) {
    if (info.device != device) return;
    if (!IsManagedTarget(info.clone_target)) return;
    managed_resources.push_back(info.resource);
  });

  for (const auto& resource : managed_resources) {
    std::vector<uint64_t> view_handles;
    renodx::utils::resource::UpdateResourceInfo(resource, [&](renodx::utils::resource::ResourceInfo* info) {
      if (info->destroyed || info->is_clone) return;
      if (!IsManagedTarget(info->clone_target)) return;

      info->clone_enabled = false;
      info->clone_can_deactivate = false;
      info->clone_target = nullptr;
      info->resource_tag = -1.f;
      view_handles.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
    });

    for (const auto view_handle : view_handles) {
      if (view_handle == 0u) continue;
      renodx::utils::resource::UpdateResourceViewInfo({view_handle}, [&](renodx::utils::resource::ResourceViewInfo* view_info) {
        if (view_info->destroyed || view_info->is_clone) return;
        if (!IsManagedTarget(view_info->clone_target)) return;

        view_info->clone_enabled = false;
        view_info->clone_can_deactivate = false;
        view_info->clone_target = nullptr;
      });
    }
  }
}

inline bool TryPromoteShaderHotSwapTarget(
    ShaderHotSwap& hot_swap,
    uint32_t target_index,
    renodx::utils::resource::ResourceInfo* resource_info) {
  if (resource_info == nullptr) return false;
  if (target_index >= targets.size()) return false;
  if (resource_info->destroyed || resource_info->is_clone) return false;
  if (resource_info->clone_target != nullptr) return false;
  if (hot_swap.resource_targets.contains(resource_info->resource.handle)) return false;

  auto& target = targets[target_index];
  if (target.completed) return false;
  if (target.shader_hash == 0u) return false;

  resource_info->clone_target = &target;
  if (target.resource_tag != -1) {
    resource_info->resource_tag = target.resource_tag;
  }
  if (!target.use_resource_view_hot_swap) {
    resource_info->clone_enabled = true;
    resource_info->clone_can_deactivate = false;
    renodx::utils::resource::upgrade::UpdateResourceViewsCloneState(
        resource_info->resource_view_handles,
        true,
        false,
        &target);
  }

  hot_swap.resource_targets[resource_info->resource.handle] = target_index;
  target.completed = true;
  return true;
}

inline bool CanPromoteShaderHotSwapTarget(
    ShaderHotSwap& hot_swap,
    uint32_t target_index,
    renodx::utils::resource::ResourceInfo* resource_info) {
  if (resource_info == nullptr) return false;
  if (target_index >= targets.size()) return false;
  if (resource_info->destroyed || resource_info->is_clone) return false;
  if (resource_info->clone_target != nullptr) return false;
  if (hot_swap.resource_targets.contains(resource_info->resource.handle)) return false;

  auto& target = targets[target_index];
  if (target.completed) return false;
  if (target.shader_hash == 0u) return false;

  return true;
}

inline bool CountShaderHotSwapPass(
    DeviceData& hot_swap_data,
    CommandListData& cmd_list_data,
    uint32_t target_index,
    int32_t pass_index) {
  if (pass_index < 0) return true;
  if (!cmd_list_data.shader_hot_swap_counted_targets.insert(target_index).second) return false;
  auto& pass_count = hot_swap_data.shader_hot_swap_pass_counts[target_index];
  const auto current_pass_index = pass_count++;
  return current_pass_index == static_cast<uint32_t>(pass_index);
}

inline bool DiscoverShaderHotSwapRenderTargets(reshade::api::command_list* cmd_list) {
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return false;
  if (cmd_list_data->active_shader_hashes.empty()) return false;
  if (cmd_list_data->current_render_targets.empty()) return false;

  auto* device = cmd_list->get_device();
  auto* upgrade_data = renodx::utils::data::Get<renodx::utils::resource::upgrade::DeviceData>(device);
  auto* hot_swap_data = renodx::utils::data::Get<DeviceData>(device);
  if (upgrade_data == nullptr || hot_swap_data == nullptr) return false;

  bool changed = false;
  const std::shared_lock upgrade_lock(upgrade_data->mutex);
  const std::unique_lock hot_swap_lock(hot_swap_data->mutex);
  if (hot_swap_data->shader_hot_swaps.empty()) {
    RebuildShaderHotSwaps(*hot_swap_data);
  }

  const auto back_buffer_desc = upgrade_data->back_buffer_desc;
  for (const auto shader_hash : cmd_list_data->active_shader_hashes) {
    auto hot_swap_iterator = hot_swap_data->shader_hot_swaps.find(shader_hash);
    if (hot_swap_iterator == hot_swap_data->shader_hot_swaps.end()) continue;
    auto& hot_swap = hot_swap_iterator->second;

    for (const auto target_index : hot_swap.target_indices) {
      if (target_index >= targets.size()) continue;
      auto& target = targets[target_index];
      if (target.completed) continue;

      const auto try_render_target = [&](const reshade::api::resource_view& render_target, bool& counted) {
        counted = false;
        if (render_target.handle == 0u) return false;
        renodx::utils::resource::ResourceInfo* resource_info = nullptr;
        const auto found_view_info = renodx::utils::resource::GetLiveResourceViewInfo(
            render_target,
            [&](const renodx::utils::resource::ResourceViewInfo& view_info) {
              resource_info = view_info.resource_info;
            });
        if (!found_view_info || resource_info == nullptr) return false;
        if (!target.CheckResourceDesc(resource_info->desc, back_buffer_desc, resource_info->initial_state)) return false;

        const bool uses_promoted_resource = hot_swap.resource_targets.contains(resource_info->resource.handle);
        const bool can_promote_resource = CanPromoteShaderHotSwapTarget(hot_swap, target_index, resource_info);
        if (!uses_promoted_resource && !can_promote_resource) return false;

        counted = true;
        if (!CountShaderHotSwapPass(*hot_swap_data, *cmd_list_data, target_index, target.index)) return false;
        if (uses_promoted_resource) return false;
        return TryPromoteShaderHotSwapTarget(hot_swap, target_index, resource_info);
      };

      for (const auto& render_target : cmd_list_data->current_render_targets) {
        bool counted = false;
        if (try_render_target(render_target, counted)) {
          changed = true;
          break;
        }
        if (counted) break;
      }
    }
  }

  return changed;
}

inline void OnInitDevice(reshade::api::device* device) {
  renodx::utils::data::Create<DeviceData>(device);
}

inline void OnDestroyDevice(reshade::api::device* device) {
  renodx::utils::data::Delete<DeviceData>(device);
}

inline void OnInitCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Create<CommandListData>(cmd_list);
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CommandListData>(cmd_list);
}

inline void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  (void)resize;
  auto* hot_swap_data = renodx::utils::data::Get<DeviceData>(swapchain->get_device());
  if (hot_swap_data == nullptr) return;

  const std::unique_lock hot_swap_lock(hot_swap_data->mutex);
  hot_swap_data->suspended = false;
  ResetShaderHotSwapState(hot_swap_data);
}

inline void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  (void)queue;
  (void)source_rect;
  (void)dest_rect;
  (void)dirty_rect_count;
  (void)dirty_rects;
  if (swapchain == nullptr) return;

  auto* hot_swap_data = renodx::utils::data::Get<DeviceData>(swapchain->get_device());
  if (hot_swap_data == nullptr) return;
  const std::unique_lock lock(hot_swap_data->mutex);
  hot_swap_data->shader_hot_swap_pass_counts.clear();
}

inline void OnBindPipeline(
    reshade::api::command_list* cmd_list,
    reshade::api::pipeline_stage stages,
    reshade::api::pipeline pipeline) {
  (void)stages;
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;
  cmd_list_data->active_shader_hashes.clear();
  if (pipeline.handle == 0u) return;

  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return;

  const auto pixel_shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(shader_state);
  if (pixel_shader_hash == 0u) return;

  cmd_list_data->active_shader_hashes.push_back(pixel_shader_hash);

  auto* hot_swap_data = renodx::utils::data::Get<DeviceData>(cmd_list->get_device());
  if (hot_swap_data != nullptr) {
    bool should_detach = false;
    bool is_suspended = false;

    {
      const std::unique_lock hot_swap_lock(hot_swap_data->mutex);
      if (hot_swap_data->shader_hot_swaps.empty()) {
        RebuildShaderHotSwaps(*hot_swap_data);
      }

      if (IsDisableHash(pixel_shader_hash)) {
        should_detach = !hot_swap_data->suspended;
        hot_swap_data->suspended = true;
        is_suspended = true;
      } else if (hot_swap_data->suspended) {
        if (hot_swap_data->shader_hot_swaps.contains(pixel_shader_hash)) {
          hot_swap_data->suspended = false;
          ResetShaderHotSwapState(hot_swap_data);
        } else {
          is_suspended = true;
        }
      }
    }

    if (should_detach) {
      DetachPromotedTargets(cmd_list->get_device());
      const std::unique_lock hot_swap_lock(hot_swap_data->mutex);
      ResetShaderHotSwapState(hot_swap_data);
      return;
    }

    if (is_suspended) return;
  }

  (void)DiscoverShaderHotSwapRenderTargets(cmd_list);
}

inline void OnBindRenderTargetsAndDepthStencil(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource_view* rtvs,
    reshade::api::resource_view dsv) {
  (void)dsv;
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) return;

  cmd_list_data->current_render_targets.clear();
  cmd_list_data->shader_hot_swap_counted_targets.clear();
  if (count != 0u && rtvs != nullptr) {
    cmd_list_data->current_render_targets.assign(rtvs, rtvs + count);
  }
  (void)DiscoverShaderHotSwapRenderTargets(cmd_list);
}

#if RESHADE_API_VERSION >= 20
inline bool
#else
inline void
#endif
OnBeginRenderPass(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::render_pass_render_target_desc* rts,
    const reshade::api::render_pass_depth_stencil_desc* ds
#if RESHADE_API_VERSION >= 20
    ,
    reshade::api::render_pass_flags flags
#endif
) {
  (void)ds;
#if RESHADE_API_VERSION >= 20
  (void)flags;
#endif
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) {
#if RESHADE_API_VERSION >= 20
    return false;
#else
    return;
#endif
  }

  if (cmd_list_data->pass_count++ != 0u) {
#if RESHADE_API_VERSION >= 20
    return false;
#else
    return;
#endif
  }

  cmd_list_data->current_render_targets.clear();
  cmd_list_data->shader_hot_swap_counted_targets.clear();
  if (count != 0u && rts != nullptr) {
    cmd_list_data->current_render_targets.reserve(count);
    for (uint32_t i = 0; i < count; ++i) {
      cmd_list_data->current_render_targets.push_back(rts[i].view);
    }
  }
  (void)DiscoverShaderHotSwapRenderTargets(cmd_list);
#if RESHADE_API_VERSION >= 20
  return false;
#endif
}

#if RESHADE_API_VERSION >= 20
inline bool
#else
inline void
#endif
OnEndRenderPass(reshade::api::command_list* cmd_list) {
  auto* cmd_list_data = renodx::utils::data::Get<CommandListData>(cmd_list);
  if (cmd_list_data == nullptr) {
#if RESHADE_API_VERSION >= 20
    return false;
#else
    return;
#endif
  }

  if (cmd_list_data->pass_count != 0u) {
    cmd_list_data->pass_count--;
  }
  if (cmd_list_data->pass_count == 0u) {
    cmd_list_data->current_render_targets.clear();
    cmd_list_data->shader_hot_swap_counted_targets.clear();
    cmd_list_data->active_shader_hashes.clear();
  }
#if RESHADE_API_VERSION >= 20
  return false;
#endif
}

}  // namespace internal

inline void UseEarly(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::register_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
      reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      reshade::register_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      reshade::register_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::end_render_pass>(internal::OnEndRenderPass);
      reshade::unregister_event<reshade::addon_event::begin_render_pass>(internal::OnBeginRenderPass);
      reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(internal::OnBindRenderTargetsAndDepthStencil);
      reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(internal::OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      break;
  }
}

inline void UseLate(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      reshade::register_event<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::bind_pipeline>(internal::OnBindPipeline);
      break;
  }
}

}  // namespace renodx_custom::utils::shader_hotswap
