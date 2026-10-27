/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "./view_lifetime_evidence.hpp"

#if RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS

#include <windows.h>

#include <array>
#include <cstdint>
#include <cstdio>
#include <cwchar>
#include <mutex>
#include <new>

#include <include/reshade.hpp>
#include "../../utils/log.hpp"
#include "../../utils/resource.hpp"

namespace rdr2vk::view_lifetime_trace {

static void OnInitResourceView(reshade::api::device* device, reshade::api::resource resource,
                               [[maybe_unused]] reshade::api::resource_usage usage,
                               const reshade::api::resource_view_desc& desc,
                               reshade::api::resource_view view) {
  const auto generation = Record("create_event", device->get_native(), view.handle, resource.handle,
                                 0, 0, false, false, static_cast<std::uint32_t>(desc.format));
  if (native_call.creating) {
    native_call.generation = generation;
  }
}

static void OnDestroyResourceView(reshade::api::device* device, reshade::api::resource_view view) {
  // This callback alone does not prove Vulkan was asked to destroy the view
  // twice. Shared cleanup can set destroyed before it calls Vulkan.
  bool found = false;
  std::uint64_t resource = 0;
  std::uint64_t clone = 0;
  std::uint64_t fallback = 0;
  bool destroyed = false;
  bool is_clone = false;
  renodx::utils::resource::GetResourceViewInfo(view, [&](const auto& info) {
    found = true;
    resource = info.original_resource.handle;
    clone = info.clone.handle;
    fallback = info.fallback.handle;
    destroyed = info.destroyed;
    is_clone = info.is_clone;
  });
  if (found) {
    Record("destroy_event", device->get_native(), view.handle, resource, clone, fallback, destroyed, is_clone);
  } else {
    Record("destroy_event_unknown", device->get_native(), view.handle);
  }
}

static void OnRetireView(renodx::utils::resource::ResourceViewInfo* info) {
  Record("shared_retire", (info->device != nullptr ? info->device->get_native() : 0),
         info->view.handle, info->original_resource.handle, info->clone.handle,
         info->fallback.handle, info->destroyed, info->is_clone);
}

static void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    wchar_t path[MAX_PATH] = {};
    if (GetModuleFileNameW(nullptr, path, MAX_PATH) == 0) return;
    auto* end = wcsrchr(path, L'\\');
    if (end == nullptr) return;
    swprintf_s(end + 1, MAX_PATH - (end + 1 - path), L"rdr2vk-view-lifetime-%lu.trace", GetCurrentProcessId());
    trace.views.reset(new (std::nothrow) std::array<ViewEvidence, VIEW_SLOTS>{});
    if (trace.views == nullptr) {
      renodx::utils::log::e("rdr2vk: could not allocate memory for the view-lifetime history.");
      return;
    }
    trace.file = CreateFileW(path, GENERIC_WRITE, FILE_SHARE_READ, nullptr, CREATE_ALWAYS,
                             FILE_ATTRIBUTE_NORMAL, nullptr);
    if (trace.file == INVALID_HANDLE_VALUE) {
      renodx::utils::log::e("rdr2vk: could not open the view-lifetime trace file; error=", GetLastError());
      return;
    }
    WriteText("rdr2vk lifetime trace v4: saves up to 8 view-error reports, 4 access-violation reports, and 16 failed-creation reports. Exceptions are recorded, never handled.\nproblem=1 recreate_during_destroy; 2 overlap; 3 repeated_native_destroy; 4 duplicate_callback; 5 repeated_unbracketed_event; 6 old_lifetime_return; 7 descriptor_after_destroy; 8 descriptor_during_destroy.\n");
    LARGE_INTEGER frequency = {};
    QueryPerformanceFrequency(&frequency);
    std::array<char, 256> clock = {};
    snprintf(clock.data(), clock.size(), "clock: qpc_frequency=%lld; recorded fence and submit calls do not prove the GPU finished using a particular view.\n", frequency.QuadPart);
    WriteText(clock.data());
    const auto* driver = reinterpret_cast<const unsigned char*>(GetModuleHandleW(L"nvoglv64.dll"));
    if (driver != nullptr) {
      const auto* dos_header = reinterpret_cast<const IMAGE_DOS_HEADER*>(driver);
      const auto* nt_headers = reinterpret_cast<const IMAGE_NT_HEADERS*>(driver + dos_header->e_lfanew);
      trace.driver_begin = reinterpret_cast<std::uintptr_t>(driver);
      trace.driver_end = trace.driver_begin + nt_headers->OptionalHeader.SizeOfImage;
    }
    snprintf(clock.data(), clock.size(), "modules: game=%p addon=%p driver_begin=%llx driver_end=%llx; phase=0 capture,1 histories,2 forwarding\n",
             GetModuleHandleW(nullptr), GetModuleHandleW(L"renodx-rdr2vk.addon64"),
             static_cast<unsigned long long>(trace.driver_begin), static_cast<unsigned long long>(trace.driver_end));
    WriteText(clock.data());
    trace.exception_handler = AddVectoredExceptionHandler(1, OnException);
    if (trace.exception_handler == nullptr) {
      renodx::utils::log::w("rdr2vk: could not install the exception recorder; recording before native calls remains active.");
    }
    reshade::register_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
    reshade::register_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
    renodx::utils::resource::RegisterOnDestroyResourceViewInfoCallback(OnRetireView);
    renodx::utils::log::i("rdr2vk: view-lifetime recording is on; normal events stay in memory and error reports have fixed limits.");
  } else if (reason == DLL_PROCESS_DETACH) {
    if (trace.exception_handler != nullptr) {
      RemoveVectoredExceptionHandler(trace.exception_handler);
      trace.exception_handler = nullptr;
    }
    reshade::unregister_event<reshade::addon_event::init_resource_view>(OnInitResourceView);
    reshade::unregister_event<reshade::addon_event::destroy_resource_view>(OnDestroyResourceView);
    renodx::utils::resource::UnregisterOnDestroyResourceViewInfoCallback(OnRetireView);
    const std::unique_lock lock(trace.mutex);
    if (trace.file != INVALID_HANDLE_VALUE) {
      std::array<char, 512> summary = {};
      snprintf(summary.data(), summary.size(), "shutdown: events=%llu evictions=%llu untracked=%llu reports=%u buffer_create_enter=%llu buffer_create_return=%llu buffer_destroy_enter=%llu buffer_destroy_return=%llu blocked_duplicates=%llu descriptor_updates=%llu sync_events=%llu fault_reports=%u\n",
               trace.sequence, trace.evictions, trace.untracked, trace.reports, trace.create_enters,
               trace.create_returns, trace.destroy_enters, trace.destroy_returns, trace.blocked_duplicates,
               trace.descriptor_updates, trace.sync_sequence, trace.fault_reports);
      WriteText(summary.data());
      CloseHandle(trace.file);
      trace.file = INVALID_HANDLE_VALUE;
    }
    trace.views.reset();
  }
}

}  // namespace rdr2vk::view_lifetime_trace

#endif  // RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS