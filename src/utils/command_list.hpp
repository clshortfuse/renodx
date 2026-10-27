/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <mutex>
#include <shared_mutex>
#include <stdexcept>
#include <vector>

#include <d3d12.h>
#include <include/reshade.hpp>
#include <wrl/client.h>

#include "./cross_addon.hpp"
#include "./detour.hpp"

namespace renodx::utils::command_list {

// Borrowed arguments are valid only during the callback. Notifications report
// CPU API boundaries, never GPU completion. Callbacks must not throw.
// A false before_submit result rejects the whole batch and suppresses after_submit.
// The rejecting callback must release any transaction state it acquired.
// Cancellation listeners are notified for each accepted before-submit callback
// in reverse order and must ignore callback identities they do not own.
// Registration/unregistration must not occur inside callbacks.
// Batch order/count match the native submission. An entry is nullptr when the
// backend has no ReShade command-list object (for example an unwrapped D3D12 list).
// Use must run before queue/list creation so lifecycle associations are available.
// Participating modules must remain loaded for the process lifetime. Native hooks
// are installed once; Use(DLL_PROCESS_DETACH) is process-exit bookkeeping only.
using BeforeSubmitCallback = bool (*)(reshade::api::command_queue*, uint32_t, reshade::api::command_list* const*);
using AfterSubmitCallback = void (*)(reshade::api::command_queue*, uint32_t, reshade::api::command_list* const*);
using AfterResetCallback = void (*)(reshade::api::command_list*, bool);
using SubmitCancelledCallback = void (*)(BeforeSubmitCallback, reshade::api::command_queue*, uint32_t, reshade::api::command_list* const*);

namespace internal {

struct __declspec(uuid("a6920f3a-cb95-4dd2-aec5-3b5c46ea28b1")) SharedData {
  std::shared_mutex mutex;
  void* execute_target = nullptr;
  void* reset_target = nullptr;
  cross_addon::vector<BeforeSubmitCallback> on_before_submit_callbacks;
  cross_addon::vector<AfterSubmitCallback> on_after_submit_callbacks;
  cross_addon::vector<AfterResetCallback> on_after_reset_callbacks;
  cross_addon::vector<SubmitCancelledCallback> on_submit_cancelled_callbacks;
  void (*install)() = nullptr;
};
static cross_addon::Shared<SharedData> shared;
static bool initialized = false;
static bool installed = false;
static void(STDMETHODCALLTYPE* execute_original)(ID3D12CommandQueue*, UINT, ID3D12CommandList* const*) = nullptr;
static HRESULT(STDMETHODCALLTYPE* reset_original)(ID3D12GraphicsCommandList*, ID3D12CommandAllocator*, ID3D12PipelineState*) = nullptr;

// Lifecycle events publish only an association, never a wrapper-chain edge.
template <typename ApiObject>
static void OnInit(ApiObject* object) {
  if (object->get_device()->get_api() != reshade::api::device_api::d3d12) return;
  const HRESULT result = reinterpret_cast<ID3D12Object*>(object->get_native())->SetPrivateData(
      __uuidof(SharedData), sizeof(object), &object);
  if (FAILED(result)) {
    reshade::log::message(reshade::log::level::error, "command_list: failed to publish D3D12 API association");
    assert(SUCCEEDED(result));
  }
}

template <typename ApiObject>
static void OnDestroy(ApiObject* object) {
  if (object->get_device()->get_api() != reshade::api::device_api::d3d12) return;
  const HRESULT result = reinterpret_cast<ID3D12Object*>(object->get_native())->SetPrivateData(
      __uuidof(SharedData), 0, nullptr);
  if (FAILED(result)) {
    reshade::log::message(reshade::log::level::error, "command_list: failed to clear D3D12 API association");
    assert(SUCCEEDED(result));
  }
}

template <typename ApiObject>
static ApiObject* GetD3D12Association(ID3D12Object* object) {
  ApiObject* mapped = nullptr;
  UINT size = sizeof(mapped);
  if (FAILED(object->GetPrivateData(__uuidof(SharedData), &size, &mapped))
      || size != sizeof(mapped) || mapped == nullptr) {
    return nullptr;
  }
  return mapped;
}

static void STDMETHODCALLTYPE ExecuteCommandLists(
    ID3D12CommandQueue* queue, UINT count, ID3D12CommandList* const* lists) {
  // Keep this call's arguments on the stack: nested submissions must not replace
  // a thread-local pending batch. Consumers own any required queue serialization.
  auto* api_queue = GetD3D12Association<reshade::api::command_queue>(queue);
  if (api_queue == nullptr) {
    reshade::log::message(reshade::log::level::error, "command_list: missing D3D12 queue association; Use must precede object creation");
    assert(api_queue != nullptr);
    return;
  }
  std::array<reshade::api::command_list*, 16> local_lists;
  std::vector<reshade::api::command_list*> overflow_lists;
  auto** api_lists = local_lists.data();
  if (count > local_lists.size()) {
    try {
      overflow_lists.resize(count);
    } catch (const std::exception& error) {
      reshade::log::message(reshade::log::level::error, error.what());
      assert(false && "Unable to translate command-list batch");
      return;
    }
    api_lists = overflow_lists.data();
  }
  for (UINT index = 0; index < count; ++index) {
    api_lists[index] = GetD3D12Association<reshade::api::command_list>(lists[index]);
  }
  const auto& callbacks = shared.data->on_before_submit_callbacks;
  for (std::size_t index = 0; index < callbacks.size(); ++index) {
    if (!callbacks[index](api_queue, count, api_lists)) {
      while (index != 0) {
        const auto accepted = callbacks[--index];
        for (const auto callback : shared.data->on_submit_cancelled_callbacks) {
          callback(accepted, api_queue, count, api_lists);
        }
      }
      reshade::log::message(reshade::log::level::error, "command_list: required submission dependency failed; batch rejected");
      return;
    }
  }
  execute_original(queue, count, lists);
  for (const auto callback : shared.data->on_after_submit_callbacks) {
    callback(api_queue, count, api_lists);
  }
}

static HRESULT STDMETHODCALLTYPE Reset(
    ID3D12GraphicsCommandList* list, ID3D12CommandAllocator* allocator,
    ID3D12PipelineState* initial_state) {
  const HRESULT result = reset_original(list, allocator, initial_state);
  auto* api_list = GetD3D12Association<reshade::api::command_list>(list);
  if (api_list == nullptr) {
    reshade::log::message(reshade::log::level::error, "command_list: missing D3D12 list association; Use must precede object creation");
    assert(api_list != nullptr);
    return result;
  }
  for (const auto callback : shared.data->on_after_reset_callbacks) {
    callback(api_list, SUCCEEDED(result));
  }
  return result;
}

// Published by Shared's elected handler; its module lives until process exit.
static void InstallD3D12() {
  if (!shared.IsEventHandler() || installed
      || shared.data->execute_target == nullptr) return;
  execute_original = reinterpret_cast<decltype(execute_original)>(shared.data->execute_target);
  reset_original = reinterpret_cast<decltype(reset_original)>(shared.data->reset_target);
  detour::Install(std::array{
      detour::Function(&execute_original, &ExecuteCommandLists),
      detour::Function(&reset_original, &Reset),
  });
  installed = true;
}

}  // namespace internal

// Register during module load; registrations stay fixed during rendering.
// Unregister callbacks only after their invocations are quiesced.
static void RegisterOnBeforeSubmitCallback(BeforeSubmitCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_before_submit_callbacks, callback);
}

static void RegisterOnAfterSubmitCallback(AfterSubmitCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_after_submit_callbacks, callback);
}

static void RegisterOnAfterResetCallback(AfterResetCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_after_reset_callbacks, callback);
}

static void RegisterOnSubmitCancelledCallback(SubmitCancelledCallback callback) {
  internal::shared.RegisterCallback(&internal::SharedData::on_submit_cancelled_callbacks, callback);
}

static void UnregisterOnBeforeSubmitCallback(BeforeSubmitCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_before_submit_callbacks, callback);
}

static void UnregisterOnAfterSubmitCallback(AfterSubmitCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_after_submit_callbacks, callback);
}

static void UnregisterOnAfterResetCallback(AfterResetCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_after_reset_callbacks, callback);
}

static void UnregisterOnSubmitCancelledCallback(SubmitCancelledCallback callback) {
  internal::shared.UnregisterCallback(&internal::SharedData::on_submit_cancelled_callbacks, callback);
}

/**
 * Installs hooks on the ReShade D3D12 queue/list implementations resolved by
 * their concrete interface IIDs. This does not infer wrapper order from private data.
 * Register observers explicitly; Use registers the module's hook participant.
 * Discovery by any participant installs the elected module's hooks, without
 * changing callbacks or election. Repeated discovery requires identical targets.
 * @throws std::exception if resolution or detour installation fails.
 */
static void AttachD3D12(
    ID3D12CommandQueue* queue, ID3D12GraphicsCommandList* list) {
  if (!internal::initialized) {
    throw std::logic_error("command_list: Use(DLL_PROCESS_ATTACH) required before attachment");
  }
  if (queue == nullptr || list == nullptr) {
    throw std::invalid_argument("command_list::AttachD3D12 requires a queue and command list");
  }
  // ReShade returns its concrete object (whose first base is the D3D12 COM
  // interface) for these IIDs; see d3d12_command_queue/list.hpp and QueryInterface.
  constexpr GUID queue_iid{0x2C576D2A, 0x0C1C, 0x4D1D, {0xAD, 0x7C, 0xBC, 0x4F, 0xAE, 0xC1, 0x5A, 0xBC}};
  constexpr GUID list_iid{0x479B29E3, 0x9A2C, 0x11D0, {0xB6, 0x96, 0x00, 0xA0, 0xC9, 0x03, 0x48, 0x7A}};
  Microsoft::WRL::ComPtr<ID3D12CommandQueue> reshade_queue;
  Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> reshade_list;
  if (FAILED(queue->QueryInterface(queue_iid, reinterpret_cast<void**>(reshade_queue.GetAddressOf())))
      || FAILED(list->QueryInterface(list_iid, reinterpret_cast<void**>(reshade_list.GetAddressOf())))) {
    throw std::runtime_error("command_list: ReShade D3D12 wrapper interfaces unavailable");
  }
  auto* execute_target = (*reinterpret_cast<void***>(reshade_queue.Get()))[10];
  auto* reset_target = (*reinterpret_cast<void***>(reshade_list.Get()))[10];
  auto* shared = internal::shared.data;
  const std::unique_lock lock(shared->mutex);
  if (shared->execute_target != nullptr
      && (shared->execute_target != execute_target || shared->reset_target != reset_target)) {
    throw std::logic_error("command_list: incompatible D3D12 hook targets");
  }
  shared->execute_target = execute_target;
  shared->reset_target = reset_target;
  shared->install();
}

// Callback setup precedes Use; participating modules are process-lifetime.
static void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    if (internal::initialized) return;
    internal::shared.RegisterModule();
    if (internal::shared.data == nullptr) {
      throw std::runtime_error("command_list: cannot allocate shared observers");
    }
    try {
      internal::shared.RegisterEvent<reshade::addon_event::init_command_queue>(&internal::OnInit<reshade::api::command_queue>);
      internal::shared.RegisterEvent<reshade::addon_event::destroy_command_queue>(&internal::OnDestroy<reshade::api::command_queue>);
      internal::shared.RegisterEvent<reshade::addon_event::init_command_list>(&internal::OnInit<reshade::api::command_list>);
      internal::shared.RegisterEvent<reshade::addon_event::destroy_command_list>(&internal::OnDestroy<reshade::api::command_list>);
      if (internal::shared.IsEventHandler()) {
        internal::shared.data->install = &internal::InstallD3D12;
      }
    } catch (...) {
      internal::shared.UnregisterModule();
      throw;
    }
    internal::initialized = true;
  } else if (reason == DLL_PROCESS_DETACH) {
    if (!internal::initialized) return;
    internal::shared.UnregisterModule();
    internal::initialized = false;
  }
}

}  // namespace renodx::utils::command_list