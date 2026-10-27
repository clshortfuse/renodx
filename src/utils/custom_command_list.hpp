/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d11.h>
#include <d3d12.h>
#include <windows.h>

#include <cassert>
#include <cstdint>
#include <format>
#include <memory>
#include <vector>

#include <include/reshade.hpp>

#include "./data.hpp"
#include "./directx.hpp"
#include "./platform.hpp"

namespace renodx::utils::custom_command_list {
// Reports implemented independent recording/submission, not device availability.
constexpr bool Supports(reshade::api::device_api api) {
  return api == reshade::api::device_api::d3d11 || api == reshade::api::device_api::d3d12;
}

// Native identity marker for distinguishing wrapped game lists from immediate lists.
struct __declspec(uuid("4a81eaf0-4626-4f18-a2e0-c83737f67e91")) ReShadeD3D12ListData {};
namespace internal {
static bool attached = false;
static thread_local std::vector<reshade::api::command_list*>* creating = nullptr;

static void OnInitCommandList(reshade::api::command_list* list) {
  if (creating != nullptr) {
    creating->push_back(list);
  }
  if (list == nullptr || list->get_device()->get_api() != reshade::api::device_api::d3d12) return;
  auto* native = reinterpret_cast<ID3D12GraphicsCommandList*>(list->get_native());
  if (native != nullptr) {
    const auto result = native->SetPrivateData(__uuidof(ReShadeD3D12ListData), sizeof(list), &list);
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error,
                            std::format("custom_command_list: publish ReShade list identity failed, HRESULT={:#010x}",
                                        static_cast<uint32_t>(result))
                                .c_str());
      assert(SUCCEEDED(result) && "Failed to publish ReShade list identity");
    }
  }
}

static void OnDestroyCommandList(reshade::api::command_list* list) {
  if (list == nullptr || list->get_device()->get_api() != reshade::api::device_api::d3d12) return;
  auto* native = reinterpret_cast<ID3D12GraphicsCommandList*>(list->get_native());
  if (native != nullptr) {
    const auto result = native->SetPrivateData(__uuidof(ReShadeD3D12ListData), 0u, nullptr);
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error,
                            std::format("custom_command_list: clear ReShade list identity failed, HRESULT={:#010x}",
                                        static_cast<uint32_t>(result))
                                .c_str());
      assert(SUCCEEDED(result) && "Failed to clear ReShade list identity");
    }
  }
}

struct CommandListCreationScope {
  std::vector<reshade::api::command_list*> lists;
  std::vector<reshade::api::command_list*>* previous = creating;
  CommandListCreationScope() { creating = &lists; }
  ~CommandListCreationScope() { creating = previous; }
  CommandListCreationScope(const CommandListCreationScope&) = delete;
  CommandListCreationScope& operator=(const CommandListCreationScope&) = delete;
};

// Private data only on lists created here. Keep this UUID-backed layout append-only.
template <reshade::api::device_api Api>
struct CommandListData {
  static_assert(Supports(Api), "Unsupported command-list data backend");
};

template <>
struct __declspec(uuid("96701fb7-bf78-4773-af8a-a8db6574bb56")) CommandListData<reshade::api::device_api::d3d12> {
  IUnknown* creator = nullptr;
  ID3D12CommandAllocator* allocator = nullptr;
  ID3D12GraphicsCommandList* list = nullptr;
  bool closed = false;
  bool failed = false;
  CommandListData() = default;
  CommandListData(const CommandListData&) = delete;
  CommandListData& operator=(const CommandListData&) = delete;
  ~CommandListData() {
    if (list != nullptr) {
      list->Release();
    }
    if (allocator != nullptr) {
      allocator->Release();
    }
    if (creator != nullptr) {
      creator->Release();
    }
  }
};

template <>
struct __declspec(uuid("6b32395d-aa86-4ed5-b620-e77c81e38635")) CommandListData<reshade::api::device_api::d3d11> {
  IUnknown* creator = nullptr;
  ID3D11DeviceContext* deferred = nullptr;
  ID3D11CommandList* finished = nullptr;
  bool closed = false;
  bool failed = false;
  CommandListData() = default;
  CommandListData(const CommandListData&) = delete;
  CommandListData& operator=(const CommandListData&) = delete;
  ~CommandListData() {
    if (finished != nullptr) {
      finished->Release();
    }
    if (deferred != nullptr) {
      deferred->Release();
    }
    if (creator != nullptr) {
      creator->Release();
    }
  }
};

}  // namespace internal

// CPU ownership only. Retire GPU work before releasing the handle, outside
// DllMain and before device/addon teardown. Serialize all per-list access.
template <reshade::api::device_api Api>
struct Deleter {
  void operator()(reshade::api::command_list* list) const noexcept {
    auto* ownership = data::Get<internal::CommandListData<Api>>(list);
    if (ownership == nullptr) {
      reshade::log::message(reshade::log::level::error, "custom_command_list: destroy requires an owned list");
      assert(ownership != nullptr && "Destroy requires an owned list");
      return;
    }
    list->set_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(internal::CommandListData<Api>)), 0);
    platform::DeleteSharedObject(ownership);
  }
};

template <reshade::api::device_api Api>
using CustomCommandList = std::unique_ptr<reshade::api::command_list, Deleter<Api>>;

// Register after register_addon. Destroy all lists before unregistering.
inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH && !internal::attached) {
    reshade::register_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
    reshade::register_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
    internal::attached = true;
  } else if (reason == DLL_PROCESS_DETACH && internal::attached) {
    reshade::unregister_event<reshade::addon_event::destroy_command_list>(internal::OnDestroyCommandList);
    reshade::unregister_event<reshade::addon_event::init_command_list>(internal::OnInitCommandList);
    internal::attached = false;
  }
}

// Returns owned ready-to-record commands, or nullptr. No queue or GPU wait is needed.
// The caller must retire and release before device/addon teardown. ReShade 6.7.3
// private-data GUIDs resolve the proxy; an explicit D3D12 creator must be that
// published proxy. Command-list creation never uses the downstream device.
// Only DIRECT lists and DIRECT submission queues are supported.
template <reshade::api::device_api Api>
  requires(Supports(Api))
inline CustomCommandList<Api> Create(reshade::api::device* device,
                                     D3D12_COMMAND_LIST_TYPE type = D3D12_COMMAND_LIST_TYPE_DIRECT,
                                     uint32_t node_mask = 0,
                                     ID3D12Device* creation_device = nullptr) {
  const auto report_failure = [](const char* operation, HRESULT result) {
    reshade::log::message(reshade::log::level::error,
                          std::format("utils::custom_command_list::Create failed: {}, HRESULT={:#010x}",
                                      operation, static_cast<uint32_t>(result))
                              .c_str());
  };
  if (!internal::attached || device == nullptr) {
    report_failure("utility not attached or device is null", E_INVALIDARG);
    assert(internal::attached && device != nullptr && "Create requires attachment and a device");
    return nullptr;
  }
  if (device->get_api() != Api) {
    report_failure("device does not match command-list backend", E_INVALIDARG);
    assert(device->get_api() == Api && "Device does not match command-list backend");
    return nullptr;
  }
  if constexpr (Api == reshade::api::device_api::d3d11) {
    if (node_mask != 0 || creation_device != nullptr) {
      report_failure("D3D11 does not accept D3D12 creation parameters", E_INVALIDARG);
      return nullptr;
    }
  }
  if (type != D3D12_COMMAND_LIST_TYPE_DIRECT) {
    report_failure("only direct command lists are supported", E_INVALIDARG);
    return nullptr;
  }
  std::unique_ptr<internal::CommandListData<Api>, decltype([](internal::CommandListData<Api>* value) {
                    platform::DeleteSharedObject(value);
                  })>
      ownership(platform::CreateSharedObject<internal::CommandListData<Api>>());
  if (ownership == nullptr) {
    report_failure("ownership allocation", E_OUTOFMEMORY);
    assert(ownership != nullptr && "Custom command-list ownership allocation failed");
    return nullptr;
  }
  internal::CommandListCreationScope capture;
  uintptr_t native = 0;
  if constexpr (Api == reshade::api::device_api::d3d12) {
    auto* proxy = directx::FindReShadeDeviceProxy<ID3D12Device>(device);
    if (proxy != nullptr) {
      // The ReShade device constructor publishes its concrete device interface.
      // Association discovery does not make an arbitrary supplied creator that interface.
      if (creation_device != nullptr && creation_device != proxy) {
        report_failure("creation device must be the published ReShade proxy", E_INVALIDARG);
        return nullptr;
      }
      auto* downstream = proxy;
      if (!directx::NativeFromReShadeProxy(&downstream)) return nullptr;
      if (reinterpret_cast<uintptr_t>(downstream) != static_cast<uintptr_t>(device->get_native())) {
        report_failure("creation device must be the matching ReShade proxy", E_INVALIDARG);
        assert(reinterpret_cast<uintptr_t>(downstream) == static_cast<uintptr_t>(device->get_native())
               && "Published ReShade proxy does not match its API device");
        return nullptr;
      }
      proxy->AddRef();
      ownership->creator = proxy;
      const HRESULT allocator_result = proxy->CreateCommandAllocator(type, IID_PPV_ARGS(&ownership->allocator));
      if (FAILED(allocator_result)) {
        report_failure("D3D12 CreateCommandAllocator", allocator_result);
        assert(SUCCEEDED(allocator_result) && "D3D12 CreateCommandAllocator failed");
        return nullptr;
      }
      const HRESULT list_result = proxy->CreateCommandList(node_mask, type, ownership->allocator,
                                                           nullptr, IID_PPV_ARGS(&ownership->list));
      if (SUCCEEDED(list_result)) {
        auto* list = ownership->list;
        if (!directx::NativeFromReShadeProxy(&list)) return nullptr;
        native = reinterpret_cast<uintptr_t>(list);
      } else {
        report_failure("D3D12 CreateCommandList", list_result);
        assert(SUCCEEDED(list_result) && "D3D12 CreateCommandList failed");
        return nullptr;
      }
    } else {
      report_failure("D3D12 ReShade proxy private data missing or invalid", E_NOINTERFACE);
      assert(proxy != nullptr && "Required D3D12 ReShade proxy unavailable");
      return nullptr;
    }
  } else if constexpr (Api == reshade::api::device_api::d3d11) {
    auto* creator = directx::FindReShadeDeviceProxy<ID3D11Device>(device);
    if (creator != nullptr) {
      creator->AddRef();
      ownership->creator = creator;
      const HRESULT context_result = creator->CreateDeferredContext(0, &ownership->deferred);
      if (SUCCEEDED(context_result)) {
        auto* context = ownership->deferred;
        if (!directx::NativeFromReShadeProxy(&context)) return nullptr;
        native = reinterpret_cast<uintptr_t>(context);
      } else {
        report_failure("D3D11 CreateDeferredContext", context_result);
        assert(SUCCEEDED(context_result) && "D3D11 CreateDeferredContext failed");
        return nullptr;
      }
    } else {
      report_failure("D3D11 ReShade device proxy missing or invalid", E_NOINTERFACE);
      assert(creator != nullptr && "Required D3D11 ReShade proxy unavailable");
      return nullptr;
    }
  }
  for (auto* list : capture.lists) {
    // ReShade may sign-extend native pointers in its 64-bit API representation on x86.
    if (native != 0 && list->get_device() == device && static_cast<uintptr_t>(list->get_native()) == native) {
      list->set_private_data(reinterpret_cast<const uint8_t*>(&__uuidof(internal::CommandListData<Api>)),
                             reinterpret_cast<uintptr_t>(ownership.get()));
      (void)ownership.release();
      return CustomCommandList<Api>(list);
    }
  }
  reshade::log::message(reshade::log::level::error,
                        std::format("utils::custom_command_list::Create capture mismatch: device={:p}, native={:#x}, captured={}",
                                    static_cast<void*>(device), native, capture.lists.size())
                            .c_str());
  assert(false && "Custom command-list creation did not capture the matching ReShade API list");
  return nullptr;
}

// Closing finishes recording without submission or waiting; repeated Close is a no-op.
// Use this API rather than closing the borrowed native proxy directly.
// Failure permanently rejects further Close/Reset/Submit on this owned list.
template <reshade::api::device_api Api>
inline bool Close(const CustomCommandList<Api>& commands) {
  auto* list = commands.get();
  if (list == nullptr) {
    reshade::log::message(reshade::log::level::error, "custom_command_list: Close requires a non-null list");
    assert(list != nullptr && "Close requires a non-null list");
    return false;
  }
  auto* ownership = data::Get<internal::CommandListData<Api>>(list);
  if (ownership == nullptr) {
    reshade::log::message(reshade::log::level::error, "custom_command_list: Close requires an owned list");
    assert(ownership != nullptr && "Close requires an owned list");
    return false;
  }
  if (ownership->failed) {
    reshade::log::message(reshade::log::level::error, "custom_command_list: attempted reuse after recording failure");
    assert(!ownership->failed && "Failed custom command list must not be reused");
    return false;
  }
  if (ownership->closed) return true;
  if constexpr (Api == reshade::api::device_api::d3d11) {
    // Record and finish at the same downstream boundary used by the API list.
    const auto result = reinterpret_cast<ID3D11DeviceContext*>(list->get_native())->FinishCommandList(FALSE, &ownership->finished);
    if (FAILED(result)) {
      ownership->failed = true;
      reshade::log::message(reshade::log::level::error,
                            std::format("custom_command_list: D3D11 FinishCommandList failed, HRESULT={:#010x}",
                                        static_cast<uint32_t>(result))
                                .c_str());
      assert(SUCCEEDED(result) && "D3D11 FinishCommandList failed");
      return false;
    }
    ownership->closed = true;
    return true;
  } else {
    const auto result = ownership->list->Close();
    if (FAILED(result)) {
      ownership->failed = true;
      reshade::log::message(reshade::log::level::error,
                            std::format("custom_command_list: D3D12 Close failed, HRESULT={:#010x}",
                                        static_cast<uint32_t>(result))
                                .c_str());
      assert(SUCCEEDED(result) && "D3D12 Close failed");
      return false;
    }
    ownership->closed = true;
    return true;
  }
}

// Discard unsubmitted recording and start a new one.
// The caller must retire GPU uses before Reset. Serialize per-list access.
template <reshade::api::device_api Api>
inline bool Reset(const CustomCommandList<Api>& commands) {
  if (!Close(commands)) return false;
  auto* list = commands.get();
  auto* ownership = data::Get<internal::CommandListData<Api>>(list);
  if constexpr (Api == reshade::api::device_api::d3d11) {
    ownership->finished->Release();
    ownership->finished = nullptr;
    ownership->closed = false;
    return true;
  } else {
    ownership->failed = true;
    assert(ownership->allocator != nullptr && "Reset requires an owned D3D12 allocator");
    const auto device_result = reinterpret_cast<ID3D12Device*>(list->get_device()->get_native())->GetDeviceRemovedReason();
    if (FAILED(device_result)) {
      reshade::log::message(reshade::log::level::error,
                            std::format("custom_command_list: D3D12 recording device removed, HRESULT={:#010x}",
                                        static_cast<uint32_t>(device_result))
                                .c_str());
      assert(SUCCEEDED(device_result) && "D3D12 recording device removed");
      return false;
    }
    const auto allocator_result = ownership->allocator->Reset();
    if (FAILED(allocator_result)) {
      reshade::log::message(reshade::log::level::error,
                            std::format("custom_command_list: D3D12 allocator Reset failed, HRESULT={:#010x}",
                                        static_cast<uint32_t>(allocator_result))
                                .c_str());
      assert(SUCCEEDED(allocator_result) && "D3D12 allocator Reset failed");
      return false;
    }
    const auto list_result = ownership->list->Reset(ownership->allocator, nullptr);
    if (FAILED(list_result)) {
      reshade::log::message(reshade::log::level::error,
                            std::format("custom_command_list: D3D12 list Reset failed, HRESULT={:#010x}",
                                        static_cast<uint32_t>(list_result))
                                .c_str());
      assert(SUCCEEDED(list_result) && "D3D12 list Reset failed");
      return false;
    }
    ownership->closed = false;
    ownership->failed = false;
    return true;
  }
}

// Caller orders producer work and retains the list/resources until its own fence
// completes. Downstream submission deliberately does not flush ReShade immediate work.
// False means no execution call occurred. Retire GPU work after submission.
template <reshade::api::device_api Api>
inline bool Submit(reshade::api::command_queue* queue, const CustomCommandList<Api>& commands) {
  auto* list = commands.get();
  const bool valid_arguments = queue != nullptr && list != nullptr;
  if (!valid_arguments) {
    reshade::log::message(reshade::log::level::error, "custom_command_list: Submit requires a queue and an owned list");
    assert(valid_arguments && "Submit requires a queue and an owned custom command list");
    return false;
  }
  const bool matching_device = queue->get_device() == list->get_device();
  if (!matching_device) {
    reshade::log::message(reshade::log::level::error, "custom_command_list: Submit queue and list devices do not match");
    assert(matching_device && "Submit requires queue and list from the same ReShade device");
    return false;
  }
  if (!Close(commands)) return false;
  if constexpr (Api == reshade::api::device_api::d3d11) {
    reinterpret_cast<ID3D11DeviceContext*>(queue->get_native())->ExecuteCommandList(data::Get<internal::CommandListData<Api>>(list)->finished, TRUE);
    return true;
  } else {
    assert(reinterpret_cast<ID3D12CommandQueue*>(queue->get_native())->GetDesc().Type
               == D3D12_COMMAND_LIST_TYPE_DIRECT
           && "Custom DIRECT command lists require a DIRECT queue");
    ID3D12CommandList* submitted[]{reinterpret_cast<ID3D12GraphicsCommandList*>(list->get_native())};
    reinterpret_cast<ID3D12CommandQueue*>(queue->get_native())->ExecuteCommandLists(1, submitted);
    return true;
  }
}

}  // namespace renodx::utils::custom_command_list
