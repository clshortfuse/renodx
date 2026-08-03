/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define DEBUG_LEVEL_0

#include <algorithm>
#include <array>
#include <barrier>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <thread>
#include <vector>

#include <include/reshade.hpp>

#include "src/utils/descriptor.hpp"

namespace {

constexpr uint32_t TEST_LAYOUT_COUNT = 64u;
constexpr uint32_t THREAD_COUNT = 16u;

std::vector<reshade::api::pipeline_layout> g_test_layouts;
reshade::api::device* g_device = nullptr;
reshade::api::pipeline_layout g_allocation_layout = {};
uint32_t g_successful_request_count = 0u;
uint32_t g_failed_request_count = 0u;
uint32_t g_divergent_layout_count = 0u;
bool g_ran = false;

bool IsTestLayout(
    uint32_t param_count,
    const reshade::api::pipeline_layout_param* params) {
  if (param_count != 1u
      || params[0].type != reshade::api::pipeline_layout_param_type::descriptor_table
      || params[0].descriptor_table.count != 1u) {
    return false;
  }
  const auto& range = params[0].descriptor_table.ranges[0];
  return range.type == reshade::api::descriptor_type::texture_shader_resource_view
         && range.dx_register_index == 41u
         && range.dx_register_space == 564u
         && range.count == 1u;
}

bool OnCreatePipelineLayout(
    reshade::api::device* device,
    uint32_t& param_count,
    reshade::api::pipeline_layout_param*& params) {
  if (device->get_api() != reshade::api::device_api::d3d12
      || g_allocation_layout.handle != 0u
      || !IsTestLayout(param_count, params)) {
    return false;
  }
  if (!device->create_pipeline_layout(param_count, params, &g_allocation_layout)) {
    g_allocation_layout = {};
  }
  return false;
}

void OnInitPipelineLayout(
    reshade::api::device* device,
    uint32_t param_count,
    const reshade::api::pipeline_layout_param* params,
    reshade::api::pipeline_layout layout) {
  if (device->get_api() != reshade::api::device_api::d3d12
      || !IsTestLayout(param_count, params)) {
    return;
  }
  g_device = device;
  g_test_layouts.push_back(layout);
}

void RunRace() {
  if (g_device == nullptr
      || g_allocation_layout.handle == 0u
      || g_test_layouts.size() != TEST_LAYOUT_COUNT) {
    return;
  }

  for (const auto layout : g_test_layouts) {
    std::array<reshade::api::descriptor_table, THREAD_COUNT> tables = {};
    std::array<bool, THREAD_COUNT> allocated = {};
    std::barrier start{THREAD_COUNT};
    std::vector<std::thread> threads;
    threads.reserve(THREAD_COUNT);
    for (uint32_t index = 0u; index < THREAD_COUNT; ++index) {
      threads.emplace_back([&, index] {
        start.arrive_and_wait();
        allocated[index] = renodx::utils::descriptor::GetOrAllocateDescriptorTable(
            g_device,
            layout,
            g_allocation_layout,
            0u,
            &tables[index]);
      });
    }
    for (auto& thread : threads) thread.join();

    reshade::api::descriptor_table first_success = {};
    bool divergent = false;
    for (uint32_t index = 0u; index < THREAD_COUNT; ++index) {
      if (!allocated[index] || tables[index].handle == 0u) {
        ++g_failed_request_count;
        continue;
      }
      ++g_successful_request_count;
      if (first_success.handle == 0u) {
        first_success = tables[index];
      } else if (tables[index].handle != first_success.handle) {
        divergent = true;
      }
    }
    if (divergent) ++g_divergent_layout_count;
  }

  char* result_path = nullptr;
  size_t result_path_size = 0u;
  if (_dupenv_s(&result_path, &result_path_size, "RENODX_DESCRIPTOR_RACE_RESULT") != 0
      || result_path == nullptr
      || result_path[0] == '\0') {
    std::free(result_path);
    return;
  }
  const bool passed = g_test_layouts.size() == TEST_LAYOUT_COUNT
                      && g_failed_request_count == 0u
                      && g_divergent_layout_count == 0u;
  std::ofstream output(std::filesystem::path(result_path), std::ios::binary | std::ios::trunc);
  std::free(result_path);
  output << (passed ? "PASS\n" : "FAIL\n");
  output << "layouts=" << g_test_layouts.size() << '\n';
  output << "threads_per_layout=" << THREAD_COUNT << '\n';
  output << "successful_requests=" << g_successful_request_count << '\n';
  output << "failed_requests=" << g_failed_request_count << '\n';
  output << "divergent_layouts=" << g_divergent_layout_count << '\n';
}

}  // namespace

void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain*,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  if (g_ran) return;
  g_ran = true;
  RunRace();
}

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX Descriptor Cache Race Test";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "Concurrent descriptor-table cache regression test";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD reason, LPVOID) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::utils::descriptor::Use(reason);
      reshade::register_event<reshade::addon_event::create_pipeline_layout>(OnCreatePipelineLayout);
      reshade::register_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_event<reshade::addon_event::init_pipeline_layout>(OnInitPipelineLayout);
      reshade::unregister_event<reshade::addon_event::create_pipeline_layout>(OnCreatePipelineLayout);
      if (g_device != nullptr && g_allocation_layout.handle != 0u) {
        g_device->destroy_pipeline_layout(g_allocation_layout);
      }
      renodx::utils::descriptor::Use(reason);
      reshade::unregister_addon(h_module);
      break;
    default:
      break;
  }
  return TRUE;
}