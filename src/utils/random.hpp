/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <chrono>
#include <random>

#include <include/reshade.hpp>

namespace renodx::utils::random {

static std::vector<float*> binds;

namespace internal {
static std::vector<std::mt19937> generators;

static constexpr const auto RANDOM_RANGE = static_cast<float>((std::mt19937::max)() - (std::mt19937::min)());

static void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  auto binds_count = binds.size();
  auto generators_count = generators.size();

  for (auto i = 0; i < binds_count; ++i) {
    if (generators_count <= i) {
      generators.emplace_back(std::chrono::system_clock::now().time_since_epoch().count() + i);
      ++generators_count;
    }
    *binds[i] = (generators[i]() + (std::mt19937::min)()) / RANDOM_RANGE;
  }
  if (generators_count > binds_count) {
    generators.resize(binds_count);
  }
}

static bool attached = false;
}  // namespace internal

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::log::message(reshade::log::level::info, "utils::random attached.");

      reshade::register_event<reshade::addon_event::present>(internal::OnPresent);
      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(internal::OnPresent);

      break;
  }
}

}  // namespace renodx::utils::random
