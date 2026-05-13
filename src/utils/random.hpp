/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <initializer_list>
#include <mutex>
#include <random>
#include <utility>
#include <vector>

#include <include/reshade.hpp>

#include "./cross_addon.hpp"

namespace renodx::utils::random {

[[deprecated("Use random::Use() instead")]]
static std::vector<float*> binds;

namespace internal {

using FloatRandomizer = std::pair<float*, std::mt19937>;

struct __declspec(uuid("b9c38ad7-3b9a-4fa9-94a7-18e9214bc9a6")) SharedData {
  std::mutex mutex;
  cross_addon::vector<FloatRandomizer> binds;
};

static cross_addon::Shared<SharedData> shared;

static constexpr const auto RANDOM_RANGE = static_cast<double>((std::mt19937::max)()) - static_cast<double>((std::mt19937::min)()) + 1.0;

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto* data = shared.data;
  if (data == nullptr) return;

  std::lock_guard lock(data->mutex);
  for (auto& [value, generator] : data->binds) {
    if (value == nullptr) continue;

    *value = static_cast<float>(
        (static_cast<double>(generator()) - static_cast<double>((std::mt19937::min)())) / RANDOM_RANGE);
  }
}
}  // namespace internal

static bool AddBinding(float* bind) {
  if (internal::shared.data == nullptr) {
    binds.push_back(bind);
  } else {
    std::lock_guard lock(internal::shared.data->mutex);
    auto& shared_binds = internal::shared.data->binds;
    if (std::ranges::any_of(shared_binds, [bind](const internal::FloatRandomizer& item) {
          return item.first == bind;
        })) {
      return false;
    }
    const auto seed = static_cast<std::mt19937::result_type>(
        std::chrono::steady_clock::now().time_since_epoch().count() + shared_binds.size());
    shared_binds.push_back({bind, std::mt19937(seed)});
  }
  return true;
}

static bool RemoveBinding(float* bind) {
  if (internal::shared.data == nullptr) {
    auto it = std::ranges::find(binds, bind);
    if (it != binds.end()) {
      binds.erase(it);
      return true;
    }
  } else {
    std::lock_guard lock(internal::shared.data->mutex);
    auto& shared_binds = internal::shared.data->binds;
    auto it = std::ranges::find_if(shared_binds, [bind](const internal::FloatRandomizer& item) {
      return item.first == bind;
    });
    if (it != shared_binds.end()) {
      shared_binds.erase(it);
      return true;
    }
  }
  return false;
}

static void Use(DWORD fdw_reason, std::initializer_list<float*> binds = {}) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::shared.RegisterModule()) {
        // log started
        reshade::log::message(reshade::log::level::info, "utils::random attached...");
      }
      for (auto* bind : binds) {
        AddBinding(bind);
      }
      for (auto* bind : random::binds) {
        AddBinding(bind);
      }

      internal::shared.RegisterEvent<reshade::addon_event::present>(internal::OnPresent);
      break;

    case DLL_PROCESS_DETACH:
      internal::shared.UnregisterEvent<reshade::addon_event::present>(internal::OnPresent);
      for (auto* bind : random::binds) {
        RemoveBinding(bind);
      }
      for (auto* bind : binds) {
        RemoveBinding(bind);
      }
      internal::shared.UnregisterModule();

      break;
  }
}

}  // namespace renodx::utils::random
