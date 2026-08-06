/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <atomic>
#include <cstdint>
#include <format>
#include <mutex>
#include <unordered_map>

#include <Windows.h>

#include <include/reshade.hpp>

#include "../../utils/command_action.hpp"
#include "./gtao_temporal_contract.hpp"
#include "./supported_build.hpp"
#include "./temporal_capture.hpp"

namespace renodx::games::detroitbecomehuman::gtao_runtime {

namespace contract = gtao_temporal_contract;

inline constexpr std::uint32_t kGtaoMainShaderCrc = 0x2D2071B2u;
inline constexpr std::uint32_t kGtaoAlternateMainShaderCrc = 0xBC7B6738u;
inline constexpr std::uint32_t kGtaoDenoiseShaderCrc = 0xE9DF0773u;

struct Texture {
  reshade::api::resource resource = {0u};
  reshade::api::resource_view srv = {0u};
  reshade::api::resource_view uav = {0u};
};

struct DispatchState {
  std::uint32_t read_index = 0u;
  std::uint32_t write_index = 0u;
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
  std::uint64_t generation = 0u;
  reshade::api::resource_view motion_view = {0u};
  bool history_valid = false;
};

struct Resources {
  reshade::api::device* device = nullptr;
  std::array<Texture, 2u> ao_history = {};
  std::array<Texture, 2u> depth_history = {};
  Texture zero_texture = {};
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
  std::uint32_t latest_index = 1u;
  bool history_valid = false;
  bool cleared = false;
  std::uint64_t generation = 1u;
  std::unordered_map<std::uint64_t, DispatchState> active_main;
  std::unordered_map<std::uint64_t, DispatchState> completed_main;
};

inline std::mutex resource_mutex;
inline Resources resources;
inline std::atomic_bool enabled = true;
inline std::atomic_uint32_t output_width = 0u;
inline std::atomic_uint32_t output_height = 0u;
inline std::atomic_uint64_t last_failure_key = 0u;
inline std::atomic_uint64_t last_ready_key = 0u;

inline void Log(reshade::log::level level, const std::string& message) {
  reshade::log::message(level, ("Detroit XeGTAO: " + message).c_str());
}

inline void LogFailureOnce(std::uint64_t key, const std::string& message) {
  if (last_failure_key.exchange(key, std::memory_order_acq_rel) == key) return;
  Log(reshade::log::level::warning, message);
}

inline void DestroyTexture(reshade::api::device* device, Texture* texture) {
  if (device == nullptr || texture == nullptr) return;
  if (texture->srv.handle != 0u) device->destroy_resource_view(texture->srv);
  if (texture->uav.handle != 0u) device->destroy_resource_view(texture->uav);
  if (texture->resource.handle != 0u) device->destroy_resource(texture->resource);
  *texture = {};
}

inline void DestroyLocked(reshade::api::device* device) {
  if (device == nullptr) return;
  for (auto& texture : resources.ao_history) DestroyTexture(device, &texture);
  for (auto& texture : resources.depth_history) DestroyTexture(device, &texture);
  DestroyTexture(device, &resources.zero_texture);
  resources = {};
}

inline void Destroy(reshade::api::device* device) {
  std::scoped_lock lock(resource_mutex);
  if (resources.device != nullptr && resources.device != device) return;
  DestroyLocked(device);
}

inline bool CreateTexture(
    reshade::api::device* device,
    std::uint32_t width,
    std::uint32_t height,
    reshade::api::format format,
    Texture* output) {
  if (device == nullptr || output == nullptr || width == 0u || height == 0u) {
    return false;
  }

  reshade::api::resource_desc desc = {};
  desc.type = reshade::api::resource_type::texture_2d;
  desc.texture = {width, height, 1u, 1u, format, 1u};
  desc.heap = reshade::api::memory_heap::gpu_only;
  desc.usage = reshade::api::resource_usage::shader_resource
               | reshade::api::resource_usage::unordered_access;
  desc.flags = reshade::api::resource_flags::none;

  const auto view_desc = reshade::api::resource_view_desc(
      reshade::api::resource_view_type::texture_2d,
      format,
      0u,
      1u,
      0u,
      1u);
  if (!device->create_resource(
          desc,
          nullptr,
          reshade::api::resource_usage::shader_resource,
          &output->resource)
      || !device->create_resource_view(
          output->resource,
          reshade::api::resource_usage::shader_resource,
          view_desc,
          &output->srv)
      || !device->create_resource_view(
          output->resource,
          reshade::api::resource_usage::unordered_access,
          view_desc,
          &output->uav)) {
    DestroyTexture(device, output);
    return false;
  }
  return true;
}

inline bool EnsureResourcesLocked(
    reshade::api::command_list* command_list,
    contract::Extent extent) {
  auto* device = command_list != nullptr ? command_list->get_device() : nullptr;
  if (device == nullptr || !extent.IsValid()
      || device->get_api() != reshade::api::device_api::vulkan) {
    return false;
  }

  if (resources.device == device && resources.width == extent.width
      && resources.height == extent.height
      && resources.ao_history[0].resource.handle != 0u
      && resources.depth_history[0].resource.handle != 0u
      && resources.zero_texture.resource.handle != 0u) {
    return true;
  }

  if (resources.device != nullptr) DestroyLocked(resources.device);
  resources.device = device;
  resources.width = extent.width;
  resources.height = extent.height;

  bool created = CreateTexture(
      device,
      1u,
      1u,
      reshade::api::format::r32_float,
      &resources.zero_texture);
  for (auto& texture : resources.ao_history) {
    created = created && CreateTexture(device, extent.width, extent.height, reshade::api::format::r16_float, &texture);
  }
  for (auto& texture : resources.depth_history) {
    created = created && CreateTexture(device, extent.width, extent.height, reshade::api::format::r32_float, &texture);
  }
  if (!created) {
    LogFailureOnce(
        UINT64_C(0x4352454154450001),
        std::format(
            "could not allocate {}x{} temporal AO history; vanilla HBAO is used for this dispatch.",
            extent.width,
            extent.height));
    DestroyLocked(device);
    return false;
  }

  resources.device = device;
  resources.width = extent.width;
  resources.height = extent.height;
  resources.latest_index = 1u;
  resources.history_valid = false;
  resources.cleared = false;
  ++resources.generation;
  return true;
}

inline void ClearTexture(
    reshade::api::command_list* command_list,
    const Texture& texture) {
  static constexpr float kZero[4] = {0.f, 0.f, 0.f, 0.f};
  command_list->barrier(
      texture.resource,
      reshade::api::resource_usage::shader_resource,
      reshade::api::resource_usage::unordered_access);
  command_list->clear_unordered_access_view_float(
      texture.uav, kZero, 0u, nullptr);
  command_list->barrier(
      texture.resource,
      reshade::api::resource_usage::unordered_access,
      reshade::api::resource_usage::shader_resource);
}

inline void ClearHistoryLocked(reshade::api::command_list* command_list) {
  if (resources.cleared) return;
  for (const auto& texture : resources.ao_history) {
    ClearTexture(command_list, texture);
  }
  for (const auto& texture : resources.depth_history) {
    ClearTexture(command_list, texture);
  }
  ClearTexture(command_list, resources.zero_texture);
  resources.cleared = true;
  resources.history_valid = false;
}

inline void SetEnabled(bool value) {
  enabled.store(value, std::memory_order_release);
  if (value) return;
  std::scoped_lock lock(resource_mutex);
  resources.history_valid = false;
  resources.completed_main.clear();
  ++resources.generation;
}

inline void SetOutputExtent(std::uint32_t width, std::uint32_t height) {
  const auto previous_width = output_width.exchange(width, std::memory_order_acq_rel);
  const auto previous_height = output_height.exchange(height, std::memory_order_acq_rel);
  if (width == previous_width && height == previous_height) return;
  std::scoped_lock lock(resource_mutex);
  resources.history_valid = false;
  resources.cleared = false;
  resources.completed_main.clear();
  ++resources.generation;
}

inline void InvalidateHistory() {
  std::scoped_lock lock(resource_mutex);
  resources.history_valid = false;
  resources.cleared = false;
  resources.completed_main.clear();
  ++resources.generation;
}

[[nodiscard]] inline bool PrepareMainDispatch(
    reshade::api::command_list* command_list,
    const renodx::utils::command_action::DispatchArguments& dispatch) {
  if (!enabled.load(std::memory_order_acquire) || command_list == nullptr) {
    return false;
  }

  const auto temporal_input = temporal_capture::GetLatestGtaoTemporalInput(
      command_list->get_device());
  const contract::Extent temporal_extent = temporal_input.valid
                                               ? contract::Extent{
                                                     temporal_input.width,
                                                     temporal_input.height}
                                               : contract::Extent{};
  const contract::Extent swapchain_extent = {
      output_width.load(std::memory_order_acquire),
      output_height.load(std::memory_order_acquire),
  };
  const auto extent = contract::SelectHistoryExtent(
      dispatch.group_count_x,
      dispatch.group_count_y,
      temporal_extent,
      swapchain_extent);

  std::scoped_lock lock(resource_mutex);
  if (!EnsureResourcesLocked(command_list, extent)) return false;
  ClearHistoryLocked(command_list);

  const bool motion_matches = temporal_input.valid
                              && temporal_input.width == resources.width
                              && temporal_input.height == resources.height;
  const bool can_reproject = resources.history_valid && motion_matches
                             && !temporal_input.reset;
  const std::uint32_t read_index = resources.latest_index;
  const std::uint32_t write_index = 1u - read_index;

  command_list->barrier(
      resources.ao_history[write_index].resource,
      reshade::api::resource_usage::shader_resource,
      reshade::api::resource_usage::unordered_access);
  command_list->barrier(
      resources.depth_history[write_index].resource,
      reshade::api::resource_usage::shader_resource,
      reshade::api::resource_usage::unordered_access);

  const auto command_buffer = command_list->get_native();
  resources.active_main[command_buffer] = {
      .read_index = read_index,
      .write_index = write_index,
      .width = resources.width,
      .height = resources.height,
      .generation = resources.generation,
      .motion_view = motion_matches ? temporal_input.view
                                    : resources.zero_texture.srv,
      .history_valid = can_reproject,
  };
  return true;
}

inline void FinishMainDispatch(
    renodx::utils::command_action::CommandContext<
        renodx::utils::command_action::DispatchArguments>& context,
    const void*) {
  if (context.cmd_list == nullptr) return;
  std::scoped_lock lock(resource_mutex);
  const auto command_buffer = context.cmd_list->get_native();
  const auto found = resources.active_main.find(command_buffer);
  if (found == resources.active_main.end()) return;
  const DispatchState state = found->second;
  resources.active_main.erase(found);
  if (resources.device == nullptr || state.write_index >= 2u) {
    return;
  }

  context.cmd_list->barrier(
      resources.ao_history[state.write_index].resource,
      reshade::api::resource_usage::unordered_access,
      reshade::api::resource_usage::shader_resource);
  context.cmd_list->barrier(
      resources.depth_history[state.write_index].resource,
      reshade::api::resource_usage::unordered_access,
      reshade::api::resource_usage::shader_resource);

  if (state.generation != resources.generation
      || !enabled.load(std::memory_order_acquire)) {
    return;
  }

  resources.latest_index = state.write_index;
  resources.history_valid = true;
  resources.completed_main[command_buffer] = state;
  const std::uint64_t ready_key =
      (static_cast<std::uint64_t>(state.width) << 32u) | state.height;
  if (last_ready_key.exchange(ready_key, std::memory_order_acq_rel)
      != ready_key) {
    Log(
        reshade::log::level::info,
        std::format(
            "temporal history active at {}x{} (full-precision AO + view depth, motion reprojection {}).",
            state.width,
            state.height,
            state.history_valid ? "enabled" : "warming up"));
  }
}

[[nodiscard]] inline bool IsMainPrepared(
    reshade::api::command_list* command_list) {
  if (!enabled.load(std::memory_order_acquire) || command_list == nullptr) {
    return false;
  }
  std::scoped_lock lock(resource_mutex);
  return resources.active_main.contains(command_list->get_native());
}

[[nodiscard]] inline bool IsDenoisePrepared(
    reshade::api::command_list* command_list) {
  if (!enabled.load(std::memory_order_acquire) || command_list == nullptr) {
    return false;
  }
  std::scoped_lock lock(resource_mutex);
  const auto found = resources.completed_main.find(command_list->get_native());
  return found != resources.completed_main.end()
         && found->second.generation == resources.generation;
}

template <typename Selector>
[[nodiscard]] inline reshade::api::resource_view GetActiveMainView(
    reshade::api::command_list* command_list,
    Selector&& selector) {
  if (command_list == nullptr) return {0u};
  std::scoped_lock lock(resource_mutex);
  const auto found = resources.active_main.find(command_list->get_native());
  if (found == resources.active_main.end()
      || found->second.generation != resources.generation) {
    return {0u};
  }
  return selector(found->second);
}

inline reshade::api::resource_view GetMotionView(
    reshade::api::command_list* command_list) {
  return GetActiveMainView(
      command_list,
      [](const DispatchState& state) { return state.motion_view; });
}

inline reshade::api::resource_view GetPreviousAoView(
    reshade::api::command_list* command_list) {
  return GetActiveMainView(command_list, [](const DispatchState& state) {
    return state.history_valid ? resources.ao_history[state.read_index].srv
                               : resources.zero_texture.srv;
  });
}

inline reshade::api::resource_view GetPreviousDepthView(
    reshade::api::command_list* command_list) {
  return GetActiveMainView(command_list, [](const DispatchState& state) {
    return state.history_valid ? resources.depth_history[state.read_index].srv
                               : resources.zero_texture.srv;
  });
}

inline reshade::api::resource_view GetCurrentAoUav(
    reshade::api::command_list* command_list) {
  return GetActiveMainView(command_list, [](const DispatchState& state) {
    return resources.ao_history[state.write_index].uav;
  });
}

inline reshade::api::resource_view GetCurrentDepthUav(
    reshade::api::command_list* command_list) {
  return GetActiveMainView(command_list, [](const DispatchState& state) {
    return resources.depth_history[state.write_index].uav;
  });
}

template <typename Selector>
[[nodiscard]] inline reshade::api::resource_view GetCompletedMainView(
    reshade::api::command_list* command_list,
    Selector&& selector) {
  if (command_list == nullptr) return {0u};
  std::scoped_lock lock(resource_mutex);
  const auto found = resources.completed_main.find(command_list->get_native());
  if (found == resources.completed_main.end()
      || found->second.generation != resources.generation) {
    return {0u};
  }
  return selector(found->second);
}

inline reshade::api::resource_view GetResolvedAoView(
    reshade::api::command_list* command_list) {
  return GetCompletedMainView(command_list, [](const DispatchState& state) {
    return resources.ao_history[state.write_index].srv;
  });
}

inline reshade::api::resource_view GetResolvedDepthView(
    reshade::api::command_list* command_list) {
  return GetCompletedMainView(command_list, [](const DispatchState& state) {
    return resources.depth_history[state.write_index].srv;
  });
}

struct MainDispatchCallback {
  [[nodiscard]] renodx::utils::command_action::CallbackResult<
      renodx::utils::command_action::CommandContext<
          renodx::utils::command_action::DispatchArguments>>
  operator()(renodx::utils::command_action::CommandContext<
             renodx::utils::command_action::DispatchArguments>& context) const {
    if (!PrepareMainDispatch(context.cmd_list, context.arguments)) return {};
    return {
        .post_callback = &FinishMainDispatch,
        .replay = true,
    };
  }
};

inline constexpr MainDispatchCallback kMainDispatchCallback;

inline void Use(DWORD reason) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      renodx::utils::command_action::Register(
          kMainDispatchCallback,
          {.shader_hash = kGtaoMainShaderCrc,
           .command_types =
               renodx::utils::command_action::COMMAND_TYPE_DISPATCH});
      renodx::utils::command_action::Register(
          kMainDispatchCallback,
          {.shader_hash = kGtaoAlternateMainShaderCrc,
           .command_types =
               renodx::utils::command_action::COMMAND_TYPE_DISPATCH});
      break;
    case DLL_PROCESS_DETACH:
      renodx::utils::command_action::Unregister(kMainDispatchCallback);
      break;
  }
}

}  // namespace renodx::games::detroitbecomehuman::gtao_runtime
