/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <d3d10_1.h>
#include <d3d11_4.h>
#include <d3d12.h>
#include <d3d9.h>
#include <emmintrin.h>
#include <ntstatus.h>
#include <windows.h>
#include <winternl.h>

// The KMT declarations require NTSTATUS from winternl.h first.
#include <d3dkmthk.h>

#include <include/reshade.hpp>

#include <array>
#include <atomic>
#include <cassert>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <deque>
#include <exception>
#include <functional>
#include <limits>
#include <map>
#include <memory>
#include <mutex>
#include <shared_mutex>
#include <stdexcept>
#include <string>
#include <string_view>
#include <system_error>
#include <thread>
#include <type_traits>
#include <utility>
#include <variant>
#include <vector>

#include "./cross_addon.hpp"
#include "./data.hpp"
#include "./minhook.hpp"
#include "./platform.hpp"

namespace renodx::utils::gpu_fence {

// No fence point was accepted; this does not imply that GPU work was retired.
inline constexpr std::uint64_t NO_SIGNAL = 0;

namespace internal {

// Backend ownership and GPU timeline operations.
struct D3DKMTFence {
  struct External {
    std::shared_ptr<void> binding_owner;
    std::shared_ptr<std::atomic_bool> binding_valid;
    D3DKMT_HANDLE object = 0;
    D3DKMT_HANDLE context = 0;
    std::vector<D3DKMT_HANDLE> additional_contexts;
    decltype(&D3DKMTDestroySynchronizationObject) destroy = nullptr;
    decltype(&D3DKMTWaitForSynchronizationObjectFromGpu) wait_gpu = nullptr;
    External(HANDLE handle, D3DKMT_HANDLE device, D3DKMT_HANDLE consumer_context,
             std::shared_ptr<void> owner = {}) : binding_owner(std::move(owner)), context(consumer_context) {
      auto* const gdi = GetModuleHandleW(L"gdi32.dll");
      if (gdi == nullptr || handle == nullptr || device == 0 || context == 0) return;
      const auto open = reinterpret_cast<decltype(&D3DKMTOpenSyncObjectFromNtHandle2)>(GetProcAddress(gdi, "D3DKMTOpenSyncObjectFromNtHandle2"));
      destroy = reinterpret_cast<decltype(destroy)>(GetProcAddress(gdi, "D3DKMTDestroySynchronizationObject"));
      wait_gpu = reinterpret_cast<decltype(wait_gpu)>(GetProcAddress(gdi, "D3DKMTWaitForSynchronizationObjectFromGpu"));
      if (open == nullptr || destroy == nullptr || wait_gpu == nullptr) {
        reshade::log::message(reshade::log::level::error, "utils::gpu_fence KMT import requires open/destroy/GPU-wait exports");
        return;
      }
      D3DKMT_OPENSYNCOBJECTFROMNTHANDLE2 args{
          .hNtHandle = handle,
          .hDevice = device,
          .Flags = {.NoGPUAccess = 1},
      };
      const auto import_status = open(&args);
      if (import_status >= 0) {
        object = args.hSyncObject;
      } else {
        reshade::log::message(reshade::log::level::error,
                              ("utils::gpu_fence D3DKMTOpenSyncObjectFromNtHandle2 NTSTATUS=" + std::to_string(import_status)).c_str());
      }
    }
    External(const External&) = delete;
    External& operator=(const External&) = delete;
    ~External() {
      // Caller must retire queued uses before releasing this imported object.
      if (object != 0) {
        D3DKMT_DESTROYSYNCHRONIZATIONOBJECT args{.hSyncObject = object};
        const auto result = destroy(&args);
        if (result < 0) {
          reshade::log::message(reshade::log::level::error,
                                ("utils::gpu_fence imported KMT object destruction NTSTATUS=" + std::to_string(result)).c_str());
          assert(false && "Imported KMT object destruction failed");
        }
      }
    }
    [[nodiscard]] bool EnqueueGPUWaitExternal(std::uint64_t target) const {
      if (binding_valid != nullptr && !binding_valid->load()) return false;
      if (object == 0) return false;
      D3DKMT_WAITFORSYNCHRONIZATIONOBJECTFROMGPU args{
          .hContext = context,
          .ObjectCount = 1,
          .ObjectHandleArray = &object,
          .MonitoredFenceValueArray = &target,
      };
      const auto primary_result = wait_gpu(&args);
      if (primary_result < 0) {
        reshade::log::message(reshade::log::level::error,
                              ("utils::gpu_fence KMT primary wait NTSTATUS=" + std::to_string(primary_result)).c_str());
        return false;
      }
      for (const auto additional : additional_contexts) {
        args.hContext = additional;
        const auto result = wait_gpu(&args);
        if (result < 0) {
          reshade::log::message(reshade::log::level::error,
                                ("utils::gpu_fence KMT broadcast wait failed after primary submission, NTSTATUS=" + std::to_string(result)).c_str());
          assert(false && "KMT broadcast wait partially submitted");
          return false;
        }
      }
      return true;
    }
  };
  // Serialize use and destruction. Retire both APIs' GPU uses before destruction,
  // outside DllMain. The retained binding owns the native device lifetime;
  // the caller must still retire work before resetting its submission context.
  struct Native {
    std::shared_ptr<void> binding_owner;
    std::shared_ptr<std::atomic_bool> binding_valid;
    // Keep child objects alive until the primary object's destruction completes.
    // The submission wrappers in joined_contexts are destroyed before this owner.
    std::vector<std::shared_ptr<Native>> joined_fences;
    D3DKMT_HANDLE object = 0;
    volatile const UINT64* completed = nullptr;
    decltype(&D3DKMTDestroySynchronizationObject) destroy = nullptr;
    ~Native() {
      if (object != 0) {
        D3DKMT_DESTROYSYNCHRONIZATIONOBJECT args{.hSyncObject = object};
        const auto result = destroy(&args);
        if (result < 0) {
          reshade::log::message(reshade::log::level::error,
                                ("utils::gpu_fence native KMT object destruction NTSTATUS=" + std::to_string(result)).c_str());
          assert(false && "Native KMT object destruction failed");
        }
      }
    }
    UINT64 GetCompletedValue() const {
      if (binding_valid != nullptr && !binding_valid->load()) return std::numeric_limits<UINT64>::max();
      // CPU mapping is read-only. Do not use interlocked read/modify/write here.
      if (completed == nullptr) return std::numeric_limits<UINT64>::max();
#if defined(_M_IX86)
      // Aligned MOVQ is a single 64-bit read on SSE2-capable x86 CPUs. The
      // compiler barriers prevent caching/reordering across GPU observations.
      std::atomic_signal_fence(std::memory_order_seq_cst);
      const auto observed = _mm_loadl_epi64(reinterpret_cast<const __m128i*>(const_cast<const UINT64*>(completed)));
      std::atomic_signal_fence(std::memory_order_seq_cst);
      return static_cast<UINT64>(_mm_cvtsi128_si64(observed));
#else
      return *completed;
#endif
    }
  };
  std::shared_ptr<Native> fence;
  D3DKMT_HANDLE context = 0;
  decltype(&D3DKMTSignalSynchronizationObjectFromGpu2) signal_gpu = nullptr;
  decltype(&D3DKMTWaitForSynchronizationObjectFromGpu) wait_gpu = nullptr;
  std::vector<std::unique_ptr<D3DKMTFence>> joined_contexts;
  std::uint64_t value = 0;

  D3DKMTFence() = default;
  D3DKMTFence(const D3DKMTFence&) = delete;
  D3DKMTFence& operator=(const D3DKMTFence&) = delete;

  bool Initialize(D3DKMT_HANDLE producer_device, D3DKMT_HANDLE producer_context,
                  std::shared_ptr<void> binding_owner = {}) {
    assert(producer_device != 0 && producer_context != 0 && fence == nullptr);
    if (producer_device == 0 || producer_context == 0 || fence != nullptr) return false;
    // gdi32 is already loaded by native D3D9; avoid acquiring a library reference.
    auto* const gdi = GetModuleHandleW(L"gdi32.dll");
    if (gdi == nullptr) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence KMT initialization requires loaded gdi32.dll");
      return false;
    }
    auto native = std::make_shared<Native>();
    native->binding_owner = std::move(binding_owner);
    auto create = reinterpret_cast<decltype(&D3DKMTCreateSynchronizationObject2)>(GetProcAddress(gdi, "D3DKMTCreateSynchronizationObject2"));
    native->destroy = reinterpret_cast<decltype(native->destroy)>(GetProcAddress(gdi, "D3DKMTDestroySynchronizationObject"));
    signal_gpu = reinterpret_cast<decltype(signal_gpu)>(GetProcAddress(gdi, "D3DKMTSignalSynchronizationObjectFromGpu2"));
    wait_gpu = reinterpret_cast<decltype(wait_gpu)>(GetProcAddress(gdi, "D3DKMTWaitForSynchronizationObjectFromGpu"));
    if (create == nullptr || native->destroy == nullptr || signal_gpu == nullptr) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence KMT initialization requires create/destroy/GPU-signal exports");
      return false;
    }
    D3DKMT_CREATESYNCHRONIZATIONOBJECT2 args{
        .hDevice = producer_device,
        .Info = {
            .Type = D3DDDI_MONITORED_FENCE,
            .Flags = {
                .Shared = 1,
                .NtSecuritySharing = 1,
                .NoGPUAccess = 1,
            },
        },
    };
    const auto result = create(&args);
    if (result < 0) {
      reshade::log::message(reshade::log::level::error,
                            ("utils::gpu_fence KMT fence creation NTSTATUS=" + std::to_string(result)).c_str());
      return false;
    }
    native->object = args.hSyncObject;
    native->completed = static_cast<const volatile UINT64*>(args.Info.MonitoredFence.FenceValueCPUVirtualAddress);
    if (native->completed == nullptr || reinterpret_cast<std::uintptr_t>(native->completed) % alignof(UINT64) != 0) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence KMT creation returned an invalid CPU fence mapping");
      return false;
    }
    fence = std::move(native);
    context = producer_context;
    return true;
  }

  // Caller must submit producer work on this context before signaling.
  // Values must increase; do not CPU-signal this producer-owned fence.
  bool QueueFence(std::uint64_t target) {
    if (fence != nullptr && fence->binding_valid != nullptr && !fence->binding_valid->load()) return false;
    assert(fence != nullptr && fence->object != 0 && target > value
           && target < std::numeric_limits<std::uint64_t>::max() - 1);
    if (fence == nullptr || fence->object == 0 || target <= value
        || target >= std::numeric_limits<std::uint64_t>::max() - 1) return false;
    if (!joined_contexts.empty() && wait_gpu == nullptr) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence KMT joined-context wait unavailable");
      assert(false && "Missing joined-context wait function");
      return false;
    }
    for (const auto& joined : joined_contexts) {
      assert(joined->fence != nullptr && joined->fence->object != 0 && target > joined->value);
      if (joined->fence == nullptr || joined->fence->object == 0 || target <= joined->value) {
        reshade::log::message(reshade::log::level::error, "utils::gpu_fence invalid joined KMT timeline");
        assert(false && "Invalid joined KMT timeline");
        return false;
      }
    }
    const UINT64 monitored_value = target;
    bool submitted = false;
    const auto signal_context = [&monitored_value, target, &submitted](D3DKMTFence* producer) {
      assert(producer->fence != nullptr && producer->fence->object != 0 && target > producer->value);
      if (producer->fence == nullptr || producer->fence->object == 0 || target <= producer->value) return false;
      D3DKMT_SIGNALSYNCHRONIZATIONOBJECTFROMGPU2 signal{
          .ObjectCount = 1,
          .ObjectHandleArray = &producer->fence->object,
          .BroadcastContextCount = 1,
          .BroadcastContextArray = &producer->context,
          .MonitoredFenceValueArray = &monitored_value,
      };
      const auto result = producer->signal_gpu(&signal);
      if (result < 0) {
        reshade::log::message(reshade::log::level::error,
                              ("utils::gpu_fence KMT signal NTSTATUS=" + std::to_string(result)).c_str());
        if (submitted) {
          reshade::log::message(reshade::log::level::error, "utils::gpu_fence KMT signal failed after partial submission");
          assert(false && "KMT signal partially submitted");
        }
        return false;
      }
      submitted = true;
      producer->value = target;
      return true;
    };
    for (const auto& joined : joined_contexts) {
      if (!signal_context(joined.get())) return false;
      D3DKMT_WAITFORSYNCHRONIZATIONOBJECTFROMGPU wait{
          .hContext = context,
          .ObjectCount = 1,
          .ObjectHandleArray = &joined->fence->object,
          .MonitoredFenceValueArray = &monitored_value,
      };
      const auto result = wait_gpu(&wait);
      if (result < 0) {
        reshade::log::message(reshade::log::level::error,
                              ("utils::gpu_fence KMT join wait failed after signal, NTSTATUS=" + std::to_string(result)).c_str());
        assert(false && "KMT join partially submitted");
        return false;
      }
    }
    return signal_context(this);
  }

  [[nodiscard]] std::uint64_t QueueFence() {
    if (fence == nullptr || value >= std::numeric_limits<std::uint64_t>::max() - 2) return 0;
    if (!QueueFence(value + 1)) return 0;
    return value;
  }
};

// Native fences only; unsupported devices do not fall back to EVENT queries.
struct D3D11Fence {
  std::shared_ptr<ID3D11Fence> fence;
  std::shared_ptr<ID3D11DeviceContext4> context;
  std::uint64_t value = 0;

  explicit D3D11Fence(ID3D11DeviceContext* immediate) {
    assert(immediate != nullptr && immediate->GetType() == D3D11_DEVICE_CONTEXT_IMMEDIATE);
    if (immediate == nullptr || immediate->GetType() != D3D11_DEVICE_CONTEXT_IMMEDIATE) {
      throw std::invalid_argument("D3D11 fence requires an immediate context");
    }
    ID3D11Device* context_device = nullptr;
    immediate->GetDevice(&context_device);
    const auto owned_context_device = std::shared_ptr<ID3D11Device>(context_device, [](ID3D11Device* owned) { owned->Release(); });
    ID3D11Device5* native_device = nullptr;
    const auto device_result = owned_context_device->QueryInterface(IID_PPV_ARGS(&native_device));
    if (FAILED(device_result)) {
      throw std::runtime_error("D3D11 fence requires ID3D11Device5; QueryInterface HRESULT=" + std::to_string(device_result));
    }
    const auto owned_native_device = std::shared_ptr<ID3D11Device5>(native_device, [](ID3D11Device5* owned) { owned->Release(); });
    ID3D11DeviceContext4* native_context = nullptr;
    const auto context_result = immediate->QueryInterface(IID_PPV_ARGS(&native_context));
    if (FAILED(context_result)) {
      throw std::runtime_error("D3D11 fence requires ID3D11DeviceContext4; QueryInterface HRESULT=" + std::to_string(context_result));
    }
    auto owned_native_context = std::shared_ptr<ID3D11DeviceContext4>(native_context, [](ID3D11DeviceContext4* owned) { owned->Release(); });
    ID3D11Fence* created = nullptr;
    const auto result = owned_native_device->CreateFence(0, D3D11_FENCE_FLAG_SHARED, IID_PPV_ARGS(&created));
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error,
                            ("utils::gpu_fence D3D11 CreateFence HRESULT=" + std::to_string(result)).c_str());
      assert(false && "D3D11 fence creation failed");
      throw std::runtime_error("D3D11 fence creation failed");
    }
    fence = std::shared_ptr<ID3D11Fence>(created, [](ID3D11Fence* owned) { owned->Release(); });
    context = std::move(owned_native_context);
  }

  [[nodiscard]] std::uint64_t QueueFence() {
    assert(context != nullptr);
    if (context == nullptr || value >= std::numeric_limits<std::uint64_t>::max() - 2) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence D3D11 missing context or exhausted timeline");
      assert(false && "D3D11 signal requires a context and an available fence point");
      return NO_SIGNAL;
    }
    const auto result = context->Signal(fence.get(), value + 1);
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error,
                            ("utils::gpu_fence D3D11 Signal HRESULT=" + std::to_string(result)).c_str());
      assert(SUCCEEDED(result) && "D3D11 fence Signal failed");
      return 0;
    }
    return ++value;
  }
};

struct D3D12Fence {
  std::shared_ptr<ID3D12Fence> fence;
  std::uint64_t value = 0;

  explicit D3D12Fence(ID3D12Device* device) {
    assert(device != nullptr);
    if (device == nullptr) throw std::invalid_argument("D3D12 fence requires a device");
    ID3D12Fence* created = nullptr;
    const auto result = device->CreateFence(0, D3D12_FENCE_FLAG_SHARED, IID_PPV_ARGS(&created));
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error,
                            ("utils::gpu_fence D3D12 CreateFence HRESULT=" + std::to_string(result)).c_str());
      assert(false && "D3D12 fence creation failed");
      throw std::runtime_error("D3D12 fence creation failed");
    }
    fence = std::shared_ptr<ID3D12Fence>(created, [](ID3D12Fence* owned) { owned->Release(); });
  }

  [[nodiscard]] std::uint64_t QueueFence(ID3D12CommandQueue* source) {
    if (value >= std::numeric_limits<std::uint64_t>::max() - 2) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence D3D12 exhausted timeline");
      assert(false && "D3D12 signal requires an available fence point");
      return NO_SIGNAL;
    }
    // Order signals without retaining a queue past its ReShade wrapper lifetime.
    // Waiting on the preceding signal is also valid on the same queue.
    if (value != 0) {
      const auto result = source->Wait(fence.get(), value);
      if (FAILED(result)) {
        reshade::log::message(reshade::log::level::error,
                              ("utils::gpu_fence D3D12 ordering Wait HRESULT=" + std::to_string(result)).c_str());
        assert(SUCCEEDED(result) && "D3D12 fence ordering Wait failed");
        return 0;
      }
    }
    const auto result = source->Signal(fence.get(), value + 1);
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error,
                            ("utils::gpu_fence D3D12 Signal HRESULT=" + std::to_string(result)).c_str());
      assert(SUCCEEDED(result) && "D3D12 fence Signal failed");
      return 0;
    }
    return ++value;
  }
};

struct OpenGLSemaphore {
  // GL_EXT_semaphore_win32 names these tokens after D3D12, but compatible
  // shared ID3D11Fence handles use the same import type and timeline parameter.
  // Our D3D9Ex/D3D10 KMT path exports monitored fences as NT handles via
  // D3DKMTShareObjects, not opaque KMT semaphore share handles.
  static constexpr unsigned int HANDLE_TYPE_D3D12_FENCE = 0x9594;
  static constexpr unsigned int D3D12_FENCE_VALUE = 0x9595;
  unsigned int object = 0;
  HGLRC context = nullptr;
  HDC dc = nullptr;
  decltype(&wglGetCurrentContext) get_current = nullptr;
  decltype(&wglGetCurrentDC) get_dc = nullptr;
  decltype(&wglMakeCurrent) make_current = nullptr;
  void(APIENTRY* delete_semaphores)(int, const unsigned int*) = nullptr;
  void(APIENTRY* parameter)(unsigned int, unsigned int, const std::uint64_t*) = nullptr;
  void(APIENTRY* signal)(unsigned int, unsigned int, const unsigned int*, unsigned int, const unsigned int*, const unsigned int*) = nullptr;
  void(APIENTRY* wait)(unsigned int, unsigned int, const unsigned int*, unsigned int, const unsigned int*, const unsigned int*) = nullptr;

  explicit OpenGLSemaphore(HANDLE handle) {
    auto* module = GetModuleHandleW(L"opengl32.dll");
    const auto get_proc = reinterpret_cast<decltype(&wglGetProcAddress)>(GetProcAddress(module, "wglGetProcAddress"));
    get_current = reinterpret_cast<decltype(get_current)>(GetProcAddress(module, "wglGetCurrentContext"));
    get_dc = reinterpret_cast<decltype(get_dc)>(GetProcAddress(module, "wglGetCurrentDC"));
    make_current = reinterpret_cast<decltype(make_current)>(GetProcAddress(module, "wglMakeCurrent"));
    if (get_proc == nullptr || get_current == nullptr || get_dc == nullptr || make_current == nullptr) {
      throw std::runtime_error("OpenGL semaphore requires WGL and GL exports");
    }
    context = get_current();
    dc = get_dc();
    auto gen = reinterpret_cast<void(APIENTRY*)(int, unsigned int*)>(get_proc("glGenSemaphoresEXT"));
    auto import = reinterpret_cast<void(APIENTRY*)(unsigned int, unsigned int, void*)>(get_proc("glImportSemaphoreWin32HandleEXT"));
    delete_semaphores = reinterpret_cast<decltype(delete_semaphores)>(get_proc("glDeleteSemaphoresEXT"));
    parameter = reinterpret_cast<decltype(parameter)>(get_proc("glSemaphoreParameterui64vEXT"));
    signal = reinterpret_cast<decltype(signal)>(get_proc("glSignalSemaphoreEXT"));
    wait = reinterpret_cast<decltype(wait)>(get_proc("glWaitSemaphoreEXT"));
    const auto is_semaphore = reinterpret_cast<unsigned char(APIENTRY*)(unsigned int)>(get_proc("glIsSemaphoreEXT"));
    const auto valid = [](auto proc) {
      const auto address = reinterpret_cast<std::uintptr_t>(proc);
      return address > 3 && address != std::numeric_limits<std::uintptr_t>::max();
    };
    if (context == nullptr || dc == nullptr || !valid(gen) || !valid(import) || !valid(delete_semaphores)
        || !valid(parameter) || !valid(signal) || !valid(wait) || !valid(is_semaphore)) {
      throw std::runtime_error("OpenGL shared fences require EXT_semaphore_win32");
    }
    gen(1, &object);
    import(object, HANDLE_TYPE_D3D12_FENCE, handle);
    if (object == 0 || is_semaphore(object) == 0) {
      delete_semaphores(1, &object);
      object = 0;
      throw std::runtime_error("OpenGL D3D12 fence import did not create a semaphore");
    }
  }
  ~OpenGLSemaphore() {
    // Contexts/DCs are borrowed: retire GPU uses and destroy the fence before
    // releasing them, with no other thread using these contexts. Rebinding
    // must run outside ReShade WGL callbacks; destruction is never loader-safe.
    auto* const previous_context = get_current();
    if (previous_context == context) {
      delete_semaphores(1, &object);
      return;
    }
    auto* const previous_dc = get_dc();
    if (make_current(dc, context) == FALSE) {
      const auto error = GetLastError();
      reshade::log::message(reshade::log::level::error,
                            ("utils::gpu_fence GL import retirement bind failed, Win32 error=" + std::to_string(error)).c_str());
      assert(false && "Could not bind GL import context for retirement");
      return;
    }
    delete_semaphores(1, &object);
    if (make_current(previous_dc, previous_context) == FALSE) {
      const auto error = GetLastError();
      reshade::log::message(reshade::log::level::error,
                            ("utils::gpu_fence GL import retirement restore failed, Win32 error=" + std::to_string(error)).c_str());
      assert(false && "Could not restore WGL binding after import retirement");
    }
  }

  void Submit(bool signal_operation, std::uint64_t value) const {
    assert(get_current() == context && "GL fence submission requires its owning context");
    parameter(object, D3D12_FENCE_VALUE, &value);
    if (signal_operation) {
      signal(object, 0, nullptr, 0, nullptr, nullptr);
    } else {
      wait(object, 0, nullptr, 0, nullptr, nullptr);
    }
  }
};

struct OpenGLFence {
  // The native fence owns its KMT device/adapter through binding_owner.
  // Release the GL import first; CPU observation never requires a GL context.
  std::shared_ptr<D3DKMTFence::Native> fence;
  std::unique_ptr<OpenGLSemaphore> semaphore;
  HDC dc = nullptr;
  HGLRC producer = nullptr;
  decltype(&wglGetCurrentContext) get_current = nullptr;
  decltype(&wglGetCurrentDC) get_dc = nullptr;
  std::uint64_t value = 0;

  OpenGLFence() {
    auto* const module = GetModuleHandleW(L"opengl32.dll");
    if (module == nullptr) throw std::runtime_error("OpenGL fence requires loaded opengl32.dll");
    get_current = reinterpret_cast<decltype(get_current)>(GetProcAddress(module, "wglGetCurrentContext"));
    get_dc = reinterpret_cast<decltype(get_dc)>(GetProcAddress(module, "wglGetCurrentDC"));
    const auto get_proc = reinterpret_cast<decltype(&wglGetProcAddress)>(GetProcAddress(module, "wglGetProcAddress"));
    if (get_current == nullptr || get_dc == nullptr || get_proc == nullptr) {
      throw std::runtime_error("OpenGL fence requires WGL context exports");
    }
    producer = get_current();
    dc = get_dc();
    if (producer == nullptr || dc == nullptr) throw std::runtime_error("OpenGL fence requires a current producer context/DC");
    const auto get_integer = reinterpret_cast<void(APIENTRY*)(unsigned int, int*)>(GetProcAddress(module, "glGetIntegerv"));
    const auto get_string = reinterpret_cast<const unsigned char*(APIENTRY*)(unsigned int, unsigned int)>(get_proc("glGetStringi"));
    const auto get_bytes = reinterpret_cast<void(APIENTRY*)(unsigned int, unsigned char*)>(get_proc("glGetUnsignedBytevEXT"));
    const auto valid = [](auto proc) {
      const auto address = reinterpret_cast<std::uintptr_t>(proc);
      return address > 3 && address != std::numeric_limits<std::uintptr_t>::max();
    };
    if (!valid(get_bytes) || !valid(get_string) || get_integer == nullptr) {
      throw std::runtime_error("OpenGL fence requires EXT external-object adapter identification");
    }
    int extension_count = 0;
    get_integer(0x821D, &extension_count);  // GL_NUM_EXTENSIONS
    bool supported = false;
    for (int index = 0; index < extension_count; ++index) {
      const auto* extension = get_string(0x1F03, static_cast<unsigned int>(index));  // GL_EXTENSIONS
      if (extension != nullptr && std::string_view(reinterpret_cast<const char*>(extension)) == "GL_EXT_semaphore_win32") {
        supported = true;
        break;
      }
    }
    if (!supported) throw std::runtime_error("OpenGL fence requires GL_EXT_semaphore_win32");
    const auto load = [](const char* name) {
      const auto proc = GetProcAddress(GetModuleHandleW(L"gdi32.dll"), name);
      if (proc == nullptr) throw std::runtime_error(std::string("OpenGL fence requires ") + name);
      return proc;
    };
    const auto require = [](NTSTATUS result, const char* operation) {
      if (result < 0) {
        reshade::log::message(reshade::log::level::error,
                              (std::string("utils::gpu_fence ") + operation + " NTSTATUS=" + std::to_string(result)).c_str());
        throw std::runtime_error(std::string(operation) + " NTSTATUS=" + std::to_string(result));
      }
    };
    struct NativeDevice {
      D3DKMT_HANDLE adapter = 0;
      D3DKMT_HANDLE device = 0;
      decltype(&D3DKMTDestroyDevice) destroy = nullptr;
      decltype(&D3DKMTCloseAdapter) close = nullptr;
      ~NativeDevice() {
        if (device != 0) {
          D3DKMT_DESTROYDEVICE args{.hDevice = device};
          const auto result = destroy(&args);
          if (result < 0) {
            reshade::log::message(reshade::log::level::error,
                                  ("utils::gpu_fence GL backing device destruction NTSTATUS=" + std::to_string(result)).c_str());
            assert(false && "GL backing device destruction failed");
          }
        }
        if (adapter != 0) {
          D3DKMT_CLOSEADAPTER args{.hAdapter = adapter};
          const auto result = close(&args);
          if (result < 0) {
            reshade::log::message(reshade::log::level::error,
                                  ("utils::gpu_fence GL backing adapter close NTSTATUS=" + std::to_string(result)).c_str());
            assert(false && "GL backing adapter close failed");
          }
        }
      }
    };
    auto owner = std::make_shared<NativeDevice>();
    owner->destroy = reinterpret_cast<decltype(owner->destroy)>(load("D3DKMTDestroyDevice"));
    owner->close = reinterpret_cast<decltype(owner->close)>(load("D3DKMTCloseAdapter"));
    D3DKMT_OPENADAPTERFROMLUID adapter{};
    get_bytes(0x9599, reinterpret_cast<unsigned char*>(&adapter.AdapterLuid));  // GL_DEVICE_LUID_EXT
    require(reinterpret_cast<decltype(&D3DKMTOpenAdapterFromLuid)>(load("D3DKMTOpenAdapterFromLuid"))(&adapter), "GL backing open adapter");
    owner->adapter = adapter.hAdapter;
    D3DKMT_CREATEDEVICE device{.hAdapter = owner->adapter};
    require(reinterpret_cast<decltype(&D3DKMTCreateDevice)>(load("D3DKMTCreateDevice"))(&device), "GL backing create device");
    owner->device = device.hDevice;
    fence = std::make_shared<D3DKMTFence::Native>();
    fence->binding_owner = std::move(owner);
    fence->destroy = reinterpret_cast<decltype(fence->destroy)>(load("D3DKMTDestroySynchronizationObject"));
    D3DKMT_CREATESYNCHRONIZATIONOBJECT2 create{
        .hDevice = device.hDevice,
        .Info = {
            .Type = D3DDDI_MONITORED_FENCE,
            .Flags = {
                .Shared = 1,
                .NtSecuritySharing = 1,
                .NoGPUAccess = 1,
            },
        },
    };
    require(reinterpret_cast<decltype(&D3DKMTCreateSynchronizationObject2)>(load("D3DKMTCreateSynchronizationObject2"))(&create), "GL backing create fence");
    fence->object = create.hSyncObject;
    fence->completed = static_cast<const volatile UINT64*>(create.Info.MonitoredFence.FenceValueCPUVirtualAddress);
    if (fence->completed == nullptr || reinterpret_cast<std::uintptr_t>(fence->completed) % alignof(UINT64) != 0) {
      throw std::runtime_error("GL backing returned an invalid CPU fence mapping");
    }
    OBJECT_ATTRIBUTES attributes{.Length = sizeof(OBJECT_ATTRIBUTES)};
    HANDLE handle = nullptr;
    require(reinterpret_cast<decltype(&D3DKMTShareObjects)>(load("D3DKMTShareObjects"))(1, &fence->object, &attributes, GENERIC_ALL, &handle), "GL backing share fence");
    const std::unique_ptr<void, decltype([](HANDLE owned) { CloseHandle(owned); })> owned_handle(handle);
    semaphore = std::make_unique<OpenGLSemaphore>(owned_handle.get());
  }
};

struct ReShadeFence {
  struct Native {
    reshade::api::device* device = nullptr;
    reshade::api::fence fence = {};
    ~Native() {
      if (fence != 0) {
        device->destroy_fence(fence);
      }
    }
  };
  std::shared_ptr<Native> native;
  reshade::api::command_queue* queue = nullptr;
  std::uint64_t value = 0;
  explicit ReShadeFence(reshade::api::device* device) {
    // The host must retain the ReShade device until the fence is destroyed.
    native = std::make_shared<Native>();
    native->device = device;
    if (!native->device->create_fence(0, reshade::api::fence_flags::none, &native->fence)) {
      throw std::runtime_error("ReShade device::create_fence failed");
    }
  }
};

// Native device discovery, binding validity, and module registration.
struct QueueContext {
  D3DKMT_HANDLE device = 0;
  D3DKMT_HANDLE context = 0;
  std::array<D3DKMT_HANDLE, 16> contexts{};
  std::size_t context_count = 0;
};
struct NativeBinding {
  const QueueContext CONTEXT;
  const std::shared_ptr<std::atomic_bool> VALID = std::make_shared<std::atomic_bool>(true);
};
// Each module owns its device bindings; no STL ownership is transferred through
// cross-addon shared state.
static data::ParallelFlatHashMap<IUnknown*, NativeBinding, std::shared_mutex> native_device_contexts;

struct NativeDiscoveryCapture {
  QueueContext binding;
  bool ambiguous = false;
};

struct __declspec(uuid("D9A8F82B-A79C-458B-B027-925F516BDA37")) NativeDiscoveryHooks {
  std::shared_mutex mutex;
  bool installed = false;
  decltype(&D3DKMTGetDeviceState) get_state = nullptr;
  decltype(&D3DKMTGetContextSchedulingPriority) get_priority = nullptr;
  decltype(&D3DKMTSetContextSchedulingPriority) set_priority = nullptr;
  NativeDiscoveryCapture* (*begin_capture)(NativeDiscoveryCapture*) = nullptr;
  void (*end_capture)(NativeDiscoveryCapture*, NativeDiscoveryCapture*) = nullptr;
  bool installation_failed = false;
};
static cross_addon::Shared<NativeDiscoveryHooks> shared_data;
static bool minhook_initialized = false;
static bool attached = false;
static thread_local NativeDiscoveryCapture* active_discovery_capture = nullptr;
// Kept independently of consumer registration for process-lifetime callbacks.
static NativeDiscoveryHooks* discovery_owner = nullptr;

static NTSTATUS APIENTRY OnDiscoveryContextSet(const D3DKMT_SETCONTEXTSCHEDULINGPRIORITY* args) {
  auto* capture = active_discovery_capture;
  if (capture == nullptr) return discovery_owner->set_priority(args);
  const auto context = args->hContext;
  const auto status = discovery_owner->set_priority(args);
  if (status >= 0) {
    auto& binding = capture->binding;
    for (std::size_t index = 0; index < binding.context_count; ++index) {
      if (binding.contexts[index] == context) return status;
    }
    if (binding.context_count == binding.contexts.size() || context == 0) {
      capture->ambiguous = true;
    } else {
      binding.contexts[binding.context_count++] = context;
    }
  }
  return status;
}

static NTSTATUS APIENTRY OnDiscoveryState(D3DKMT_GETDEVICESTATE* args) {
  auto* capture = active_discovery_capture;
  if (capture == nullptr) return discovery_owner->get_state(args);
  const auto device = args->hDevice;
  const auto status = discovery_owner->get_state(args);
  if (status >= 0) {
    capture->ambiguous |= device == 0 || (capture->binding.device != 0 && capture->binding.device != device);
    capture->binding.device = device;
  }
  return status;
}

static NTSTATUS APIENTRY OnDiscoveryPriority(D3DKMT_GETCONTEXTSCHEDULINGPRIORITY* args) {
  auto* capture = active_discovery_capture;
  if (capture == nullptr) return discovery_owner->get_priority(args);
  const auto context = args->hContext;
  const auto status = discovery_owner->get_priority(args);
  if (status >= 0) {
    capture->ambiguous |= context == 0 || (capture->binding.context != 0 && capture->binding.context != context);
    capture->binding.context = context;
  }
  return status;
}

// Run at device initialization, outside DllMain. Native priority queries may flush.
template <typename NativeDevice>
  requires(std::is_same_v<NativeDevice, IDirect3DDevice9Ex> || std::is_same_v<NativeDevice, ID3D10Device>)
[[nodiscard]] bool TrackDevice(NativeDevice* device) {
  if (device == nullptr) return false;
  assert(internal::attached);
  if (!internal::attached) {
    reshade::log::message(reshade::log::level::error, "utils::gpu_fence discovery requires module attachment");
    assert(false && "Discovery requires module attachment");
    return false;
  }
  auto* hooks = internal::shared_data.data;
  if (hooks == nullptr) {
    reshade::log::message(reshade::log::level::error, "utils::gpu_fence failed to allocate discovery owner");
    assert(false && "Discovery owner allocation failed");
    return false;
  }
  std::unique_lock lock(hooks->mutex);
  if (hooks->installation_failed) {
    reshade::log::message(reshade::log::level::error, "utils::gpu_fence native discovery installation previously failed");
    return false;
  }
  if (!hooks->installed) {
    try {
      auto* native = GetModuleHandleW(L"win32u.dll");
      if (native == nullptr) throw std::runtime_error("win32u.dll is not loaded");
      hooks->get_state = reinterpret_cast<decltype(hooks->get_state)>(GetProcAddress(native, "NtGdiDdDDIGetDeviceState"));
      hooks->get_priority = reinterpret_cast<decltype(hooks->get_priority)>(GetProcAddress(native, "NtGdiDdDDIGetContextSchedulingPriority"));
      hooks->set_priority = reinterpret_cast<decltype(hooks->set_priority)>(GetProcAddress(native, "NtGdiDdDDISetContextSchedulingPriority"));
      if (hooks->get_state == nullptr || hooks->get_priority == nullptr || hooks->set_priority == nullptr) {
        throw std::runtime_error("native discovery exports are missing");
      }
      if (!platform::PinModule(reinterpret_cast<const void*>(&internal::OnDiscoveryState))) {
        throw std::system_error(static_cast<int>(GetLastError()), std::system_category(), "Pin native discovery owner");
      }
      internal::discovery_owner = hooks;
      // All consumers must access the hook owner's TLS, not their own module's.
      hooks->begin_capture = [](NativeDiscoveryCapture* capture) {
        return std::exchange(active_discovery_capture, capture);
      };
      hooks->end_capture = [](NativeDiscoveryCapture* capture, NativeDiscoveryCapture* previous) {
        if (active_discovery_capture != capture) {
          reshade::log::message(reshade::log::level::error, "utils::gpu_fence discovery capture ended out of order or on another thread");
          assert(false && "Invalid discovery capture nesting");
          return;
        }
        active_discovery_capture = previous;
      };
      if (!internal::minhook_initialized) {
        minhook::Initialize();
        internal::minhook_initialized = true;
      }
      const std::array functions{
          minhook::Function(hooks->get_state, internal::OnDiscoveryState, &hooks->get_state),
          minhook::Function(hooks->get_priority, internal::OnDiscoveryPriority, &hooks->get_priority),
          minhook::Function(hooks->set_priority, internal::OnDiscoveryContextSet, &hooks->set_priority)};
      for (const auto& function : functions) {
        minhook::Create(function);
      }
      for (const auto& function : functions) {
        minhook::QueueEnable(function);
      }
      minhook::ApplyQueued();
      hooks->installed = true;
    } catch (const std::exception& error) {
      // MinHook failures can leave live patches. Preserve their pinned owner's
      // trampoline pointers instead of rewriting them on another device's retry.
      hooks->installation_failed = true;
      reshade::log::message(reshade::log::level::error, error.what());
      assert(false && "Native discovery installation failed");
      return false;
    }
  }
  IUnknown* identity = nullptr;
  if (FAILED(device->QueryInterface(IID_PPV_ARGS(&identity)))) return false;
  auto owner = std::shared_ptr<IUnknown>(identity, [](IUnknown* owned) { owned->Release(); });
  if (internal::native_device_contexts.contains(identity)) return false;
  internal::NativeDiscoveryCapture capture;
  HRESULT state = E_FAIL;
  HRESULT priority_status = E_FAIL;
  INT priority = 0;
  {
    struct CaptureRegistration {
      internal::NativeDiscoveryHooks* hooks;
      internal::NativeDiscoveryCapture* capture;
      internal::NativeDiscoveryCapture* previous;
      ~CaptureRegistration() { hooks->end_capture(capture, previous); }
    } registration{.hooks = hooks, .capture = &capture, .previous = hooks->begin_capture(&capture)};
    if constexpr (std::is_same_v<NativeDevice, IDirect3DDevice9Ex>) {
      D3DDEVICE_CREATION_PARAMETERS creation{};
      if (FAILED(device->GetCreationParameters(&creation))) return false;
      state = device->CheckDeviceState(creation.hFocusWindow);
      priority_status = device->GetGPUThreadPriority(&priority);
      if (SUCCEEDED(priority_status)) {
        priority_status = device->SetGPUThreadPriority(priority);
      }
    } else {
      IDXGIDevice* dxgi = nullptr;
      if (FAILED(device->QueryInterface(IID_PPV_ARGS(&dxgi)))) return false;
      const auto owned_dxgi = std::shared_ptr<IDXGIDevice>(dxgi, [](auto* owned) { owned->Release(); });
      state = device->GetDeviceRemovedReason();
      priority_status = owned_dxgi->GetGPUThreadPriority(&priority);
      if (SUCCEEDED(priority_status)) {
        priority_status = owned_dxgi->SetGPUThreadPriority(priority);
      }
    }
  }
  if (FAILED(state) || FAILED(priority_status) || capture.ambiguous
      || capture.binding.device == 0 || capture.binding.context == 0 || capture.binding.context_count == 0) return false;
  bool primary_observed = false;
  for (std::size_t index = 0; index < capture.binding.context_count; ++index) {
    primary_observed |= capture.binding.contexts[index] == capture.binding.context;
  }
  if (!primary_observed) return false;
  internal::native_device_contexts.emplace(identity, internal::NativeBinding{
                                                         .CONTEXT = capture.binding,
                                                     });
  return true;
}

// Paired with TrackDevice at device teardown or before Reset/context
// replacement, after retiring GPU uses. Old fences remain invalid after rediscovery.
inline bool UntrackDevice(IUnknown* device) {
  if (device == nullptr) return false;
  IUnknown* identity = nullptr;
  if (FAILED(device->QueryInterface(IID_PPV_ARGS(&identity)))) return false;
  bool invalidated = false;
  internal::native_device_contexts.erase_if(identity, [&invalidated](const auto& entry) {
    const auto& [native_device, binding] = entry;
    binding.VALID->store(false);
    invalidated = true;
    return true;
  });
  identity->Release();
  return invalidated;
}

static void OnInitDevice(reshade::api::device* device) {
  bool initialized = false;
  switch (device->get_api()) {
    case reshade::api::device_api::d3d9: {
      IDirect3DDevice9Ex* native = nullptr;
      if (FAILED(reinterpret_cast<IUnknown*>(device->get_native())->QueryInterface(IID_PPV_ARGS(&native)))) return;
      initialized = TrackDevice(native);
      native->Release();
      break;
    }
    case reshade::api::device_api::d3d10:
      initialized = TrackDevice(reinterpret_cast<ID3D10Device*>(device->get_native()));
      break;
    default: return;
  }
  if (!initialized) {
    reshade::log::message(reshade::log::level::warning, "utils::gpu_fence native device binding unavailable");
  }
}

static void OnDestroyDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d9
      || device->get_api() == reshade::api::device_api::d3d10) {
    (void)UntrackDevice(reinterpret_cast<IUnknown*>(device->get_native()));
  }
}
}  // namespace internal

// Externally serialize operations and retire GPU work before destruction.
// D3D9Ex/D3D10 devices are implicit submitters; other devices only create fences.
template <typename T>
concept QueueSubmitter = std::is_same_v<T, reshade::api::command_queue>
                         || std::is_same_v<T, IDirect3DDevice9Ex>
                         || std::is_same_v<T, ID3D10Device>
                         || std::is_same_v<T, ID3D11DeviceContext>
                         || std::is_same_v<T, ID3D12CommandQueue>;

class Fence {
  // Owns native fence state and destination imports, not device registration.
  // Callers retire GPU uses first; destruction joins CPU workers before release.
  // These friends require the complete private state below; member operations
  // must remain fence-only while free operations coordinate a destination/source.
  template <QueueSubmitter Submitter>
  friend std::uint64_t QueueSignal(Submitter* source, Fence* fence, std::function<void()> callback);
  template <QueueSubmitter Submitter>
  friend bool QueueWait(Submitter* destination, Fence* fence, std::uint64_t value);

 private:
  std::unique_ptr<void, decltype([](HANDLE handle) {
                    if (CloseHandle(handle) == FALSE) {
                      const auto error = GetLastError();
                      reshade::log::message(reshade::log::level::error,
                                            ("utils::gpu_fence shared handle close Win32 error=" + std::to_string(error)).c_str());
                      assert(false && "Shared fence handle close failed");
                    }
                  })>
      shared_handle;
  std::variant<std::unique_ptr<internal::D3DKMTFence>,
               std::unique_ptr<internal::D3D11Fence>,
               std::unique_ptr<internal::D3D12Fence>,
               std::unique_ptr<internal::OpenGLFence>,
               std::unique_ptr<internal::ReShadeFence>>
      backend;
  // One interface per destination device, shared by its queues. Imports are
  // released before the source backend; callers retire all GPU uses first.
  // Native fence interfaces retain their device; KMT imports retain binding_owner.
  std::map<IUnknown*, std::variant<std::shared_ptr<internal::D3DKMTFence::External>,
                                   std::shared_ptr<ID3D11Fence>,
                                   std::shared_ptr<ID3D12Fence>>>
      imports_by_device;
  reshade::api::device* api_device = nullptr;
  // A ReShade GL device can own several queues/contexts. Each import belongs to
  // the exact queue context, including when those contexts share GL objects.
  std::map<HGLRC, std::unique_ptr<internal::OpenGLSemaphore>> imports_by_gl_context;

  struct CallbackDelivery {
    std::shared_mutex mutex;
    std::condition_variable_any condition;
    struct Pending {
      std::uint64_t value;
      std::function<void()> callback;
    };
    std::deque<Pending> pending;
    bool stopping = false;
    std::thread worker;
  };
  std::shared_ptr<CallbackDelivery> callback_delivery;

  template <typename NativeDevice>
    requires(std::is_same_v<NativeDevice, IDirect3DDevice9Ex> || std::is_same_v<NativeDevice, ID3D10Device>)
  void Initialize(NativeDevice* device) {
    if (device == nullptr) throw std::invalid_argument("Fence requires a device");
    IUnknown* identity = nullptr;
    if (FAILED(device->QueryInterface(IID_PPV_ARGS(&identity)))) {
      throw std::runtime_error("Native device identity unavailable");
    }
    const std::shared_ptr<IUnknown> binding_owner(identity, [](IUnknown* owned) { owned->Release(); });
    internal::QueueContext association;
    std::shared_ptr<std::atomic_bool> binding_valid;
    internal::native_device_contexts.if_contains(identity, [&](const auto& entry) {
      const auto& [native_device, binding] = entry;
      association = binding.CONTEXT;
      binding_valid = binding.VALID;
    });
    if (association.device == 0 || association.context == 0) {
      throw std::runtime_error("Missing verified native device submission association");
    }
    auto implementation = std::make_unique<internal::D3DKMTFence>();
    if (!implementation->Initialize(association.device, association.context, binding_owner)) {
      throw std::runtime_error("KMT fence creation failed");
    }
    implementation->fence->binding_valid = std::move(binding_valid);
    if (implementation->fence->binding_valid != nullptr && !implementation->fence->binding_valid->load()) {
      throw std::runtime_error("Native fence binding was invalidated");
    }
    for (std::size_t index = 0; index < association.context_count; ++index) {
      if (association.contexts[index] == association.context) continue;
      auto joined = std::make_unique<internal::D3DKMTFence>();
      if (!joined->Initialize(association.device, association.contexts[index], binding_owner)) {
        throw std::runtime_error("KMT context retirement marker creation failed");
      }
      implementation->fence->joined_fences.push_back(joined->fence);
      joined->fence->binding_valid = implementation->fence->binding_valid;
      implementation->joined_contexts.push_back(std::move(joined));
    }
    backend = std::move(implementation);
  }
  void Initialize(ID3D11Device* device) {
    if (device == nullptr) throw std::invalid_argument("Fence requires a device");
    ID3D11DeviceContext* context = nullptr;
    device->GetImmediateContext(&context);
    std::shared_ptr<ID3D11DeviceContext> owned_context(context, [](auto* owned) { owned->Release(); });
    backend = std::make_unique<internal::D3D11Fence>(owned_context.get());
  }
  void Initialize(ID3D12Device* device) {
    if (device == nullptr) throw std::invalid_argument("Fence requires a device");
    backend = std::make_unique<internal::D3D12Fence>(device);
  }

 public:
  template <typename NativeDevice>
    requires(std::is_same_v<NativeDevice, IDirect3DDevice9Ex>
             || std::is_same_v<NativeDevice, ID3D10Device>
             || std::is_same_v<NativeDevice, ID3D11Device>
             || std::is_same_v<NativeDevice, ID3D12Device>)
  explicit Fence(NativeDevice* device) {
    Initialize(device);
  }
  explicit Fence(reshade::api::device* device) : api_device(device) {
    if (device == nullptr) throw std::invalid_argument("Fence requires a device");
    switch (device->get_api()) {
      case reshade::api::device_api::d3d9: {
        IDirect3DDevice9Ex* native = nullptr;
        if (FAILED(reinterpret_cast<IUnknown*>(device->get_native())->QueryInterface(IID_PPV_ARGS(&native)))) {
          throw std::runtime_error("D3D9 fences require D3D9Ex");
        }
        const std::shared_ptr<IDirect3DDevice9Ex> owned(native, [](auto* value) { value->Release(); });
        Initialize(owned.get());
        break;
      }
      case reshade::api::device_api::d3d10:
        Initialize(reinterpret_cast<ID3D10Device*>(device->get_native()));
        break;
      case reshade::api::device_api::d3d11:
        Initialize(reinterpret_cast<ID3D11Device*>(device->get_native()));
        break;
      case reshade::api::device_api::d3d12:
        Initialize(reinterpret_cast<ID3D12Device*>(device->get_native()));
        break;
      case reshade::api::device_api::opengl:
        backend = std::make_unique<internal::OpenGLFence>();
        break;
      case reshade::api::device_api::vulkan:
        backend = std::make_unique<internal::ReShadeFence>(device);
        break;
      default: throw std::runtime_error("Unsupported fence backend");
    }
  }
  Fence(const Fence&) = delete;
  Fence& operator=(const Fence&) = delete;
  Fence(Fence&&) = delete;
  Fence& operator=(Fence&&) = delete;

  // Retire outside DllMain, before addon unload. Cancellation does not retire GPU work.
  // A callback may not destroy its own fence or race other users of the fence.
  // GL contexts/DCs must remain alive and available to this thread until destruction
  // returns. Imports bind their owning contexts internally and restore the caller's
  // ReShade-tracked wglMakeCurrent binding. Under a WGL callback, all imports must
  // already belong to the current context: cross-context rebinding is not safe.
  ~Fence() {
    if (callback_delivery != nullptr) {
      // Cancel CPU delivery; the caller is responsible for retiring GPU work.
      {
        std::unique_lock lock(callback_delivery->mutex);
        callback_delivery->stopping = true;
      }
      if (callback_delivery->worker.get_id() == std::this_thread::get_id()) {
        reshade::log::message(reshade::log::level::error, "utils::gpu_fence destruction from its own callback");
        assert(false && "Fence callback cannot destroy its own fence");
        // Contract violation: the worker retains delivery state until it exits.
        callback_delivery->worker.detach();
        return;
      }
      callback_delivery->condition.notify_all();
      if (callback_delivery->worker.joinable()) {
        callback_delivery->worker.join();
      }
    }
  }
  [[nodiscard]] std::uint64_t GetCompletedValue() const {
    return std::visit([&](const auto& implementation) -> std::uint64_t {
      std::uint64_t completed = 0;
      if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::ReShadeFence>>) {
        if (implementation->native == nullptr) throw std::runtime_error("Invalid fence");
        completed = implementation->native->device->get_completed_fence_value(implementation->native->fence);
      } else {
        if (implementation->fence == nullptr) throw std::runtime_error("Invalid fence");
        completed = implementation->fence->GetCompletedValue();
      }
      return completed;
    },
                      backend);
  }
  [[nodiscard]] bool IsComplete(std::uint64_t value) const { return GetCompletedValue() >= value; }
  [[nodiscard]] bool IsBusy() const {
    const auto completed = GetCompletedValue();
    return std::visit([completed](const auto& implementation) {
      return completed < implementation->value;
    },
                      backend);
  }
};

// Returns an automatically allocated GPU point, or NO_SIGNAL on rejected/failed submission.
// Callers submit pending API work first and retain resources after a failed signal.
// Optional callbacks execute FIFO on a worker after completion, never under a lock.
// Destruction cancels pending callbacks and joins delivery; serialize submission/destruction.
// Delivery may precede this call's return. Callbacks must not throw, destroy their
// fence, or race submission; capture dependencies must outlive delivery/cancellation.
// Backend completion values are preserved, including UINT64_MAX. Callbacks are
// threshold notifications, not a guarantee of successful GPU execution.
// Callback exceptions are logged and asserted; NDEBUG builds continue later callbacks.
// Query exceptions stop delivery; submission exceptions propagate. GL signals its
// imported monitored fence on the application context; completion queries and CPU
// callback delivery use the native mapping without binding or creating GL contexts.
template <QueueSubmitter Submitter>
[[nodiscard]] std::uint64_t QueueSignal(Submitter* source, Fence* fence, std::function<void()> callback) {
  if (source == nullptr || fence == nullptr) throw std::invalid_argument("QueueSignal requires a source and fence");
  if (fence->callback_delivery != nullptr) {
    std::shared_lock lock(fence->callback_delivery->mutex);
    if (fence->callback_delivery->stopping) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence callback delivery has stopped");
      return NO_SIGNAL;
    }
  }
  if constexpr (std::is_same_v<Submitter, reshade::api::command_queue>) {
    switch (source->get_device()->get_api()) {
      case reshade::api::device_api::d3d9: {
        IDirect3DDevice9Ex* device = nullptr;
        if (FAILED(reinterpret_cast<IUnknown*>(source->get_native())->QueryInterface(IID_PPV_ARGS(&device)))) {
          throw std::invalid_argument("D3D9 submission requires D3D9Ex");
        }
        const std::unique_ptr<IDirect3DDevice9Ex, decltype([](IDirect3DDevice9Ex* native) { native->Release(); })> owned(device);
        return QueueSignal(owned.get(), fence, std::move(callback));
      }
      case reshade::api::device_api::d3d10:
        return QueueSignal(reinterpret_cast<ID3D10Device*>(source->get_native()), fence, std::move(callback));
      case reshade::api::device_api::d3d11:
        return QueueSignal(reinterpret_cast<ID3D11DeviceContext*>(source->get_native()), fence, std::move(callback));
      case reshade::api::device_api::d3d12:
        return QueueSignal(reinterpret_cast<ID3D12CommandQueue*>(source->get_native()), fence, std::move(callback));
      default:
        if (fence->api_device != source->get_device()) throw std::invalid_argument("Fence belongs to another device");
        if (auto* implementation = std::get_if<std::unique_ptr<internal::ReShadeFence>>(&fence->backend)) {
          if ((*implementation)->queue != source && (*implementation)->value != NO_SIGNAL
              && !source->wait((*implementation)->native->fence, (*implementation)->value)) {
            reshade::log::message(reshade::log::level::error, "utils::gpu_fence Vulkan queue-switch ordering wait failed");
            assert(false && "Vulkan queue-switch ordering wait failed");
            return NO_SIGNAL;
          }
          (*implementation)->queue = source;
        }
        break;
    }
  } else {
    const auto require_query = [](HRESULT result, const char* operation) {
      if (FAILED(result)) {
        throw std::runtime_error(std::string(operation) + " HRESULT=" + std::to_string(result));
      }
    };
    const bool matches = std::visit([&](auto& implementation) {
      if constexpr (std::is_same_v<Submitter, ID3D12CommandQueue>) {
        if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3D12Fence>>) {
#ifndef NDEBUG
          // Explicit GetNext contracts, not private-data markers: Streamline's
          // StreamlineRetrieveBaseInterface and ReShade's retrieval interface.
          // See sl.interposer/d3d12/d3d12Device.cpp and ReShade d3d12_device.cpp.
          const auto unwrap = [&](ID3D12Device* device) {
            std::unique_ptr<ID3D12Device, decltype([](ID3D12Device* owned) { owned->Release(); })> owned(device);
            constexpr GUID retrievals[]{
                {0xADEC44E2, 0x61F0, 0x45C3, {0xAD, 0x9F, 0x1B, 0x37, 0x37, 0x92, 0x84, 0xFF}},
                {0x7F2C9A11, 0x3B4E, 0x4D6A, {0x81, 0x2F, 0x5E, 0x9C, 0xD3, 0x7A, 0x1B, 0x42}},
            };
            for (;;) {
              bool unwrapped = false;
              for (const auto& retrieval : retrievals) {
                ID3D12Device* next = nullptr;
                const auto result = owned->QueryInterface(retrieval, reinterpret_cast<void**>(&next));
                if (result == E_NOINTERFACE) continue;
                require_query(result, "D3D12 device unwrap QueryInterface");
                assert(next != nullptr && next != owned.get() && "Device retrieval must advance to its downstream interface");
                owned.reset(next);
                unwrapped = true;
                break;
              }
              if (!unwrapped) return owned;
            }
          };
          ID3D12Device* device = nullptr;
          require_query(implementation->fence->GetDevice(IID_PPV_ARGS(&device)), "D3D12 source fence GetDevice");
          const auto owned = unwrap(device);
          ID3D12Device* queue_device = nullptr;
          require_query(source->GetDevice(IID_PPV_ARGS(&queue_device)), "D3D12 source queue GetDevice");
          const auto owned_queue_device = unwrap(queue_device);
          assert(owned.get() == owned_queue_device.get() && "D3D12 signal queue and fence must belong to the same device");
#endif
          return true;
        } else {
          return false;
        }
      } else if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3D11Fence>>
                           && std::is_same_v<Submitter, ID3D11DeviceContext>) {
        return implementation->context.get() == source;
      } else if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3DKMTFence>>) {
        IUnknown* identity = nullptr;
        require_query(source->QueryInterface(IID_PPV_ARGS(&identity)), "KMT source QueryInterface IUnknown");
        const bool same = implementation->fence->binding_owner.get() == identity;
        identity->Release();
        return same;
      } else {
        return false;
      }
    },
                                    fence->backend);
    if (!matches) throw std::invalid_argument("QueueSignal source does not own this fence timeline");
  }
  return std::visit([&](auto& implementation) -> std::uint64_t {
    std::unique_lock<std::shared_mutex> delivery_lock;
    bool callback_reserved = false;
    std::uint64_t completion = NO_SIGNAL;

    // Prepare delivery before accepting GPU work. Allocation failures must
    // not leave a submitted point without its requested callback.
    try {
      if (callback) {
        if (fence->callback_delivery == nullptr) {
          fence->callback_delivery = std::make_shared<Fence::CallbackDelivery>();
        }
        if (!fence->callback_delivery->worker.joinable()) {
          fence->callback_delivery->worker = std::thread([fence, delivery = fence->callback_delivery]() {
            try {
              std::unique_lock lock(delivery->mutex);
              while (true) {
                delivery->condition.wait(lock, [delivery]() {
                  return delivery->stopping || !delivery->pending.empty();
                });
                if (delivery->stopping) return;
                if (fence->GetCompletedValue() < delivery->pending.front().value) {
                  delivery->condition.wait_for(lock, std::chrono::milliseconds(1), [delivery]() {
                    return delivery->stopping;
                  });
                  continue;
                }
                auto completed_callback = std::move(delivery->pending.front().callback);
                delivery->pending.pop_front();
                lock.unlock();

                // Both invocation and capture destruction run outside the lock.
                try {
                  completed_callback();
                } catch (const std::exception& error) {
                  reshade::log::message(reshade::log::level::error, error.what());
                  assert(false && "Fence callback must not throw");
                } catch (...) {
                  reshade::log::message(reshade::log::level::error, "utils::gpu_fence CPU callback threw");
                  assert(false && "Fence callback must not throw");
                }
                completed_callback = {};
                lock.lock();
              }
            } catch (...) {
              reshade::log::message(reshade::log::level::error, "utils::gpu_fence completion delivery worker threw");
              assert(false && "Fence callback delivery failed");
              // Stop CPU delivery; this does not establish GPU retirement.
              std::unique_lock lock(delivery->mutex);
              delivery->stopping = true;
            }
          });
        }
      }
      if (fence->callback_delivery != nullptr) {
        delivery_lock = std::unique_lock(fence->callback_delivery->mutex);
        if (fence->callback_delivery->stopping) {
          reshade::log::message(reshade::log::level::error, "utils::gpu_fence callback delivery has stopped");
          return NO_SIGNAL;
        }
        if (callback) {
          // Allocate before submission; the worker cannot observe this entry
          // until its actual fence point has been assigned below.
          fence->callback_delivery->pending.push_back({.value = NO_SIGNAL});
          fence->callback_delivery->pending.back().callback = std::move(callback);
          callback_reserved = true;
        }
      }

      // Submit with the reservation hidden from the delivery worker.
      if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3D12Fence>>
                    && std::is_same_v<Submitter, ID3D12CommandQueue>) {
        completion = implementation->QueueFence(source);
      } else if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3D12Fence>>) {
        throw std::invalid_argument("D3D12 fence requires a D3D12 submission queue");
      } else if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::ReShadeFence>>) {
        // ReShade owns Vulkan submission, including its immediate-list flush.
        if (implementation->value < std::numeric_limits<std::uint64_t>::max() - 1
            && implementation->queue->signal(implementation->native->fence, implementation->value + 1)) {
          completion = ++implementation->value;
        }
      } else if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::OpenGLFence>>) {
        auto* gl = implementation.get();
        assert(gl->get_current() == gl->producer && gl->get_dc() == gl->dc);
        if (gl->get_current() != gl->producer || gl->get_dc() != gl->dc) {
          throw std::invalid_argument("GL signal requires its producer context/DC");
        }
        if (gl->value >= std::numeric_limits<std::uint64_t>::max() - 1) {
          reshade::log::message(reshade::log::level::error, "utils::gpu_fence GL timeline exhausted");
        } else {
          // SignalSemaphoreEXT implicitly flushes the producer stream.
          gl->semaphore->Submit(true, gl->value + 1);
          completion = ++gl->value;
        }
      } else {
        completion = implementation->QueueFence();
      }
    } catch (...) {
      reshade::log::message(reshade::log::level::error,
                            "utils::gpu_fence signal or required retirement tracking threw");
      assert(false && "Fence signal or required retirement tracking threw");
      // Roll back only this reservation, preserving earlier callbacks.
      // Move captures out so unwinding destroys them after unlocking.
      if (callback_reserved) {
        callback = std::move(fence->callback_delivery->pending.back().callback);
        fence->callback_delivery->pending.pop_back();
      }
      if (delivery_lock.owns_lock()) {
        delivery_lock.unlock();
      }
      throw;
    }

    // Commit the accepted point, or withdraw a rejected submission's callback.
    if (callback_reserved) {
      if (completion != NO_SIGNAL) {
        fence->callback_delivery->pending.back().value = completion;
      } else {
        callback = std::move(fence->callback_delivery->pending.back().callback);
        fence->callback_delivery->pending.pop_back();
      }
    }
    if (delivery_lock.owns_lock()) {
      delivery_lock.unlock();
    }
    if (completion == NO_SIGNAL) {
      reshade::log::message(reshade::log::level::error, "utils::gpu_fence backend signal failed");
      return NO_SIGNAL;
    }
    if (fence->callback_delivery != nullptr) {
      fence->callback_delivery->condition.notify_one();
    }
    return completion;
  },
                    fence->backend);
}

template <QueueSubmitter Submitter>
[[nodiscard]] std::uint64_t QueueSignal(Submitter* source, Fence* fence) {
  return QueueSignal(source, fence, {});
}

// Enqueues a GPU dependency without blocking the CPU. False means setup or
// submission failed; callers must not submit dependent work after rejection.
// GL timelines are native monitored fences from construction. Export does not
// require the producer context current; GL consumers import on their own context.
// GL waits require the destination queue's context current. Retire GPU uses and
// destroy the fence before its importing contexts/DCs; destruction binds those
// contexts internally, so they must not be current on another thread. Serialize
// setup with submission, retirement and completion observation.
// Vulkan-local fences use ReShade for same-device GPU waits. Cross-device and
// cross-API Vulkan interoperability is not implemented and returns false.
template <QueueSubmitter Submitter>
[[nodiscard]] bool QueueWait(Submitter* destination, Fence* fence, std::uint64_t value) {
  if (destination == nullptr || fence == nullptr) {
    throw std::invalid_argument("QueueWait requires a destination and fence");
  }
  const auto succeeded = [](HRESULT result, const char* operation) {
    if (FAILED(result)) {
      reshade::log::message(reshade::log::level::error,
                            (std::string("utils::gpu_fence ") + operation + " HRESULT=" + std::to_string(result)).c_str());
      assert(false && "Required GPU fence wait operation failed");
    }
    return SUCCEEDED(result);
  };
  const auto export_handle = [&]() {
    if (fence->shared_handle != nullptr) return true;
    HANDLE handle = nullptr;
    const bool exported = std::visit([&](const auto& implementation) -> bool {
      if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3D12Fence>>) {
        ID3D12Device* device = nullptr;
        if (!succeeded(implementation->fence->GetDevice(IID_PPV_ARGS(&device)), "Fence export GetDevice")) return false;
        const std::shared_ptr<ID3D12Device> owned(device, [](auto* native) { native->Release(); });
        return succeeded(device->CreateSharedHandle(implementation->fence.get(), nullptr, GENERIC_ALL, nullptr, &handle),
                         "Fence export CreateSharedHandle");
      } else if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3D11Fence>>) {
        return succeeded(implementation->fence->CreateSharedHandle(nullptr, GENERIC_ALL, nullptr, &handle), "D3D11 CreateSharedHandle");
      } else if constexpr (std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::D3DKMTFence>>
                           || std::is_same_v<std::decay_t<decltype(implementation)>, std::unique_ptr<internal::OpenGLFence>>) {
        const auto share = reinterpret_cast<decltype(&D3DKMTShareObjects)>(
            GetProcAddress(GetModuleHandleW(L"gdi32.dll"), "D3DKMTShareObjects"));
        if (share == nullptr) return false;
        OBJECT_ATTRIBUTES attributes{.Length = sizeof(OBJECT_ATTRIBUTES)};
        const auto result = share(1, &implementation->fence->object, &attributes, GENERIC_ALL, &handle);
        if (result < 0) {
          reshade::log::message(reshade::log::level::error,
                                ("utils::gpu_fence KMT share NTSTATUS=" + std::to_string(result)).c_str());
          return false;
        }
        return true;
      } else {
        return false;
      }
    }, fence->backend);
    if (exported) {
      fence->shared_handle.reset(handle);
    }
    return exported;
  };
  if constexpr (std::is_same_v<Submitter, reshade::api::command_queue>) {
    switch (destination->get_device()->get_api()) {
      case reshade::api::device_api::d3d9: {
        IDirect3DDevice9Ex* device = nullptr;
        if (!succeeded(reinterpret_cast<IUnknown*>(destination->get_native())->QueryInterface(IID_PPV_ARGS(&device)), "QueryInterface D3D9Ex")) return false;
        const std::unique_ptr<IDirect3DDevice9Ex, decltype([](IDirect3DDevice9Ex* native) { native->Release(); })> owned(device);
        return QueueWait(owned.get(), fence, value);
      }
      case reshade::api::device_api::d3d10:
        return QueueWait(reinterpret_cast<ID3D10Device*>(destination->get_native()), fence, value);
      case reshade::api::device_api::d3d11:
        return QueueWait(reinterpret_cast<ID3D11DeviceContext*>(destination->get_native()), fence, value);
      case reshade::api::device_api::d3d12:
        return QueueWait(reinterpret_cast<ID3D12CommandQueue*>(destination->get_native()), fence, value);
      case reshade::api::device_api::opengl: {
        // ReShade's GL command queue native object is its HGLRC, not the
        // share-group device's original context.
        auto* const context = reinterpret_cast<HGLRC>(static_cast<std::uintptr_t>(destination->get_native()));
        auto found = fence->imports_by_gl_context.find(context);
        if (found == fence->imports_by_gl_context.end()) {
          if (!export_handle()) return false;
          auto imported = std::make_unique<internal::OpenGLSemaphore>(fence->shared_handle.get());
          assert(imported->context == context && "GL wait requires the destination queue context current");
          auto [position, inserted] = fence->imports_by_gl_context.try_emplace(context, std::move(imported));
          found = position;
        }
        const auto& [owning_context, imported] = *found;
        imported->Submit(false, value);
        return true;
      }
      case reshade::api::device_api::vulkan: {
        if (fence->api_device == destination->get_device()) {
          if (auto* local = std::get_if<std::unique_ptr<internal::ReShadeFence>>(&fence->backend)) {
            if (destination->wait((*local)->native->fence, value)) return true;
            reshade::log::message(reshade::log::level::error, "utils::gpu_fence Vulkan queue wait failed");
            assert(false && "Required Vulkan GPU fence wait failed");
          }
        }
        return false;
      }
      default:
        reshade::log::message(reshade::log::level::error, "utils::gpu_fence unsupported queue wait backend");
        assert(false && "Unsupported GPU wait backend");
        return false;
    }
  } else {
    IUnknown* identity = nullptr;
    if constexpr (std::is_same_v<Submitter, ID3D12CommandQueue>) {
      if (!succeeded(destination->GetDevice(IID_PPV_ARGS(&identity)), "D3D12 destination device identity")) return false;
    } else if constexpr (std::is_same_v<Submitter, ID3D11DeviceContext>) {
      ID3D11Device* device = nullptr;
      destination->GetDevice(&device);
      const std::unique_ptr<ID3D11Device, decltype([](ID3D11Device* native) { native->Release(); })> owned_device(device);
      if (!succeeded(device->QueryInterface(IID_PPV_ARGS(&identity)), "D3D11 destination device identity")) return false;
    } else {
      if (!succeeded(destination->QueryInterface(IID_PPV_ARGS(&identity)), "QueryInterface destination device identity")) return false;
    }
    const std::unique_ptr<IUnknown, decltype([](IUnknown* native) { native->Release(); })> owned(identity);
    auto found = fence->imports_by_device.find(identity);
    if (found == fence->imports_by_device.end()) {
      std::variant<std::shared_ptr<internal::D3DKMTFence::External>,
                   std::shared_ptr<ID3D11Fence>,
                   std::shared_ptr<ID3D12Fence>>
          imported;
      if (!export_handle()) return false;
      auto* const handle = fence->shared_handle.get();
      if constexpr (std::is_same_v<Submitter, ID3D12CommandQueue>) {
        ID3D12Device* device = nullptr;
        if (!succeeded(destination->GetDevice(IID_PPV_ARGS(&device)), "D3D12 queue GetDevice")) return false;
        const std::shared_ptr<ID3D12Device> owned_device(device, [](auto* native) { native->Release(); });
        ID3D12Fence* opened = nullptr;
        if (!succeeded(device->OpenSharedHandle(handle, IID_PPV_ARGS(&opened)), "D3D12 OpenSharedHandle")) return false;
        imported = std::shared_ptr<ID3D12Fence>(opened, [](auto* native) { native->Release(); });
      } else if constexpr (std::is_same_v<Submitter, ID3D11DeviceContext>) {
        ID3D11Device* device = nullptr;
        destination->GetDevice(&device);
        const std::shared_ptr<ID3D11Device> owned_device(device, [](auto* native) { native->Release(); });
        ID3D11Device5* device5 = nullptr;
        if (!succeeded(device->QueryInterface(IID_PPV_ARGS(&device5)), "QueryInterface D3D11Device5")) return false;
        const std::shared_ptr<ID3D11Device5> owned_device5(device5, [](auto* native) { native->Release(); });
        ID3D11Fence* opened = nullptr;
        if (!succeeded(device5->OpenSharedFence(handle, IID_PPV_ARGS(&opened)), "D3D11 OpenSharedFence")) return false;
        imported = std::shared_ptr<ID3D11Fence>(opened, [](auto* native) { native->Release(); });
      } else {
        internal::QueueContext context;
        std::shared_ptr<std::atomic_bool> valid;
        internal::native_device_contexts.if_contains(identity, [&](const auto& entry) {
          const auto& [device, association] = entry;
          context = association.CONTEXT;
          valid = association.VALID;
        });
        if (valid == nullptr || !valid->load()) return false;
        identity->AddRef();
        const std::shared_ptr<IUnknown> binding_owner(identity, [](IUnknown* native) { native->Release(); });
        auto kmt = std::make_shared<internal::D3DKMTFence::External>(handle, context.device, context.context, binding_owner);
        if (kmt->object == 0) return false;
        kmt->binding_valid = std::move(valid);
        for (std::size_t index = 0; index < context.context_count; ++index) {
          if (context.contexts[index] != context.context) {
            kmt->additional_contexts.push_back(context.contexts[index]);
          }
        }
        imported = std::move(kmt);
      }
      // Publish ownership before submitting a GPU wait. No queue is retained.
      auto [position, inserted] = fence->imports_by_device.try_emplace(identity, std::move(imported));
      found = position;
    }
    const auto& [device, imported] = *found;
    if constexpr (std::is_same_v<Submitter, ID3D12CommandQueue>) {
      return succeeded(destination->Wait(std::get<std::shared_ptr<ID3D12Fence>>(imported).get(), value), "D3D12 Wait");
    } else if constexpr (std::is_same_v<Submitter, ID3D11DeviceContext>) {
      ID3D11DeviceContext4* context4 = nullptr;
      if (!succeeded(destination->QueryInterface(IID_PPV_ARGS(&context4)), "QueryInterface D3D11DeviceContext4")) return false;
      const std::unique_ptr<ID3D11DeviceContext4, decltype([](ID3D11DeviceContext4* native) { native->Release(); })> owned_context(context4);
      return succeeded(context4->Wait(std::get<std::shared_ptr<ID3D11Fence>>(imported).get(), value), "D3D11 Wait");
    } else {
      return std::get<std::shared_ptr<internal::D3DKMTFence::External>>(imported)->EnqueueGPUWaitExternal(value);
    }
  }
}

inline bool Use(DWORD reason) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return true;
      if (!internal::shared_data.RegisterModule()) {
        reshade::log::message(reshade::log::level::error, "utils::gpu_fence module registration failed");
        assert(false && "Fence module registration failed");
        return false;
      }

      // Device bindings are module-local; do not elect a single event owner.
      reshade::register_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::register_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      internal::attached = true;
      break;
    case DLL_PROCESS_DETACH:
      if (!internal::attached) return true;
      reshade::unregister_event<reshade::addon_event::init_device>(internal::OnInitDevice);
      reshade::unregister_event<reshade::addon_event::destroy_device>(internal::OnDestroyDevice);
      // Consumer detach does not remove the process-lifetime discovery hooks.
      internal::shared_data.UnregisterModule();
      internal::attached = false;
      break;
  }
  return true;
}

}  // namespace renodx::utils::gpu_fence