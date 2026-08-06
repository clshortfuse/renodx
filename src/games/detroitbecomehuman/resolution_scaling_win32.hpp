/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "resolution_scaling.hpp"

#if defined(_WIN64)

#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <detours.h>
#include <TlHelp32.h>
#include <Windows.h>

#include <atomic>
#include <bit>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <mutex>
#include <span>
#include <vector>

namespace renodx::games::detroitbecomehuman::resolution_scaling {

enum class RuntimeCallContext {
  kLoaderLockMayBeHeld,
  kOutsideLoaderLock,
};

enum class ControllerResult {
  kSuccess,
  kNoChange,
  kAlreadyArmed,
  kNotArmed,
  kUnsafeCallContext,
  kUnsupportedExecutable,
  kInvalidModule,
  kCodeSignatureMismatch,
  kObjectUnavailable,
  kMemoryRejected,
  kScaleRejected,
  kHookInstallFailed,
  kHookRemoveFailed,
};

struct ControllerSnapshot {
  bool armed = false;
  bool override_active = false;
  float target_scale = 1.f;
  float serialized_scale = 1.f;
  PixelExtent last_base_extent = {};
  PixelExtent last_render_extent = {};
  std::uint64_t rejected_updates = 0u;
};

namespace detail {

[[nodiscard]] inline bool IsReadableProtection(DWORD protection) noexcept {
  if ((protection & (PAGE_GUARD | PAGE_NOACCESS)) != 0u) return false;
  switch (protection & 0xFFu) {
    case PAGE_READONLY:
    case PAGE_READWRITE:
    case PAGE_WRITECOPY:
    case PAGE_EXECUTE_READ:
    case PAGE_EXECUTE_READWRITE:
    case PAGE_EXECUTE_WRITECOPY:
      return true;
    default:
      return false;
  }
}

[[nodiscard]] inline bool IsWritableProtection(DWORD protection) noexcept {
  if ((protection & (PAGE_GUARD | PAGE_NOACCESS)) != 0u) return false;
  switch (protection & 0xFFu) {
    case PAGE_READWRITE:
    case PAGE_WRITECOPY:
    case PAGE_EXECUTE_READWRITE:
    case PAGE_EXECUTE_WRITECOPY:
      return true;
    default:
      return false;
  }
}

[[nodiscard]] inline bool IsExecutableProtection(DWORD protection) noexcept {
  if ((protection & (PAGE_GUARD | PAGE_NOACCESS)) != 0u) return false;
  switch (protection & 0xFFu) {
    case PAGE_EXECUTE:
    case PAGE_EXECUTE_READ:
    case PAGE_EXECUTE_READWRITE:
    case PAGE_EXECUTE_WRITECOPY:
      return true;
    default:
      return false;
  }
}

[[nodiscard]] inline bool IsAccessibleRange(
    std::uintptr_t address,
    std::size_t size,
    bool require_write,
    bool require_execute = false) noexcept {
  if (address == 0u || size == 0u
      || size - 1u > std::numeric_limits<std::uintptr_t>::max() - address) {
    return false;
  }

  MEMORY_BASIC_INFORMATION memory = {};
  if (VirtualQuery(
          reinterpret_cast<const void*>(address),
          &memory,
          sizeof(memory))
      != sizeof(memory)) {
    return false;
  }
  if (memory.State != MEM_COMMIT || !IsReadableProtection(memory.Protect)
      || (require_write && !IsWritableProtection(memory.Protect))
      || (require_execute && !IsExecutableProtection(memory.Protect))) {
    return false;
  }

  const auto region_begin = reinterpret_cast<std::uintptr_t>(memory.BaseAddress);
  if (region_begin > std::numeric_limits<std::uintptr_t>::max() - memory.RegionSize) {
    return false;
  }
  const auto region_end = region_begin + memory.RegionSize;
  return address >= region_begin && address + size <= region_end;
}

[[nodiscard]] inline bool CopyFromProcessMemory(
    const void* source,
    void* destination,
    std::size_t size) noexcept {
#if defined(_MSC_VER)
  __try {
    std::memcpy(destination, source, size);
    return true;
  } __except (EXCEPTION_EXECUTE_HANDLER) {
    return false;
  }
#else
  std::memcpy(destination, source, size);
  return true;
#endif
}

[[nodiscard]] inline bool ReadPointer(
    std::uintptr_t address,
    std::uintptr_t* output) noexcept {
  return output != nullptr
         && IsAccessibleRange(address, sizeof(*output), false)
         && CopyFromProcessMemory(
             reinterpret_cast<const void*>(address), output, sizeof(*output));
}

[[nodiscard]] inline bool ReadFloat(
    std::uintptr_t address,
    float* output) noexcept {
  return output != nullptr
         && IsAccessibleRange(address, sizeof(*output), false)
         && CopyFromProcessMemory(
             reinterpret_cast<const void*>(address), output, sizeof(*output));
}

class SharedSrwLockGuard {
 public:
  explicit SharedSrwLockGuard(SRWLOCK* lock) noexcept : lock_(lock) {
    AcquireSRWLockShared(lock_);
  }
  SharedSrwLockGuard(const SharedSrwLockGuard&) = delete;
  SharedSrwLockGuard& operator=(const SharedSrwLockGuard&) = delete;
  ~SharedSrwLockGuard() { ReleaseSRWLockShared(lock_); }

 private:
  SRWLOCK* lock_;
};

class ExclusiveSrwLockGuard {
 public:
  explicit ExclusiveSrwLockGuard(SRWLOCK* lock) noexcept : lock_(lock) {
    AcquireSRWLockExclusive(lock_);
  }
  ExclusiveSrwLockGuard(const ExclusiveSrwLockGuard&) = delete;
  ExclusiveSrwLockGuard& operator=(const ExclusiveSrwLockGuard&) = delete;
  ~ExclusiveSrwLockGuard() { ReleaseSRWLockExclusive(lock_); }

 private:
  SRWLOCK* lock_;
};

class ProcessThreadEnrollment {
 public:
  ProcessThreadEnrollment() = default;
  ProcessThreadEnrollment(const ProcessThreadEnrollment&) = delete;
  ProcessThreadEnrollment& operator=(const ProcessThreadEnrollment&) = delete;
  ~ProcessThreadEnrollment() {
    for (const HANDLE thread : threads_) CloseHandle(thread);
  }

  [[nodiscard]] bool Capture() noexcept {
    const DWORD process_id = GetCurrentProcessId();
    const DWORD current_thread_id = GetCurrentThreadId();
    const HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0u);
    if (snapshot == INVALID_HANDLE_VALUE) return false;

    THREADENTRY32 entry = {.dwSize = sizeof(entry)};
    if (Thread32First(snapshot, &entry) == FALSE) {
      const DWORD error = GetLastError();
      CloseHandle(snapshot);
      return error == ERROR_NO_MORE_FILES;
    }

    bool succeeded = true;
    do {
      const auto role = ClassifyProcessThread(
          process_id,
          current_thread_id,
          entry.th32OwnerProcessID,
          entry.th32ThreadID);
      if (role != ProcessThreadRole::kOther) continue;

      constexpr DWORD kRequiredAccess =
          THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT | THREAD_SET_CONTEXT
          | THREAD_QUERY_INFORMATION | THREAD_QUERY_LIMITED_INFORMATION
          | SYNCHRONIZE;
      const HANDLE thread =
          OpenThread(kRequiredAccess, FALSE, entry.th32ThreadID);
      if (thread == nullptr) {
        // A thread can exit between Thread32Next and OpenThread. No live thread
        // remains to enlist in that case; every other error is fail-closed.
        if (GetLastError() == ERROR_INVALID_PARAMETER) continue;
        succeeded = false;
        break;
      }
      const DWORD owner_process_id = GetProcessIdOfThread(thread);
      const DWORD wait_result = WaitForSingleObject(thread, 0u);
      if (owner_process_id != process_id || wait_result == WAIT_FAILED) {
        CloseHandle(thread);
        succeeded = false;
        break;
      }
      if (wait_result == WAIT_OBJECT_0) {
        CloseHandle(thread);
        continue;
      }
      try {
        threads_.push_back(thread);
      } catch (...) {
        CloseHandle(thread);
        succeeded = false;
        break;
      }
    } while (Thread32Next(snapshot, &entry) != FALSE);

    if (succeeded && GetLastError() != ERROR_NO_MORE_FILES) succeeded = false;
    CloseHandle(snapshot);
    return succeeded;
  }

  [[nodiscard]] bool EnlistAll() const noexcept {
    if (DetourUpdateThread(GetCurrentThread()) != NO_ERROR) return false;
    for (const HANDLE thread : threads_) {
      const DWORD wait_result = WaitForSingleObject(thread, 0u);
      if (wait_result == WAIT_OBJECT_0) continue;
      if (wait_result == WAIT_FAILED || DetourUpdateThread(thread) != NO_ERROR) {
        return false;
      }
    }
    return true;
  }

 private:
  std::vector<HANDLE> threads_;
};

}  // namespace detail

class RuntimeController {
 public:
  RuntimeController() = default;
  RuntimeController(const RuntimeController&) = delete;
  RuntimeController& operator=(const RuntimeController&) = delete;
  ~RuntimeController() = default;

  [[nodiscard]] ControllerResult Arm(
      HMODULE main_module,
      const ExecutableIdentity& identity,
      RuntimeCallContext context = RuntimeCallContext::kOutsideLoaderLock) {
    std::scoped_lock lock(mutex_);
    if (context != RuntimeCallContext::kOutsideLoaderLock) {
      return ControllerResult::kUnsafeCallContext;
    }
    if (!IsExactSupportedBuild(identity)) {
      return ControllerResult::kUnsupportedExecutable;
    }
    if (armed_) return ControllerResult::kAlreadyArmed;

    const auto module_base = reinterpret_cast<std::uintptr_t>(main_module);
    if (!ValidateLoadedImage(module_base)) {
      return ControllerResult::kInvalidModule;
    }
    if (!ValidateCode(module_base)) {
      return ControllerResult::kCodeSignatureMismatch;
    }

    const auto function = ResolveImageAddress(
        module_base,
        kSupportedImageSize,
        kRuntimeUpdateFunctionRva,
        kRuntimeUpdatePrologue.size());
    const auto options_slot = ResolveImageAddress(
        module_base,
        kSupportedImageSize,
        kGraphicOptionsGlobalSlotRva,
        sizeof(std::uintptr_t));
    const auto renderer_slot = ResolveImageAddress(
        module_base,
        kSupportedImageSize,
        kRendererGlobalsSlotRva,
        sizeof(std::uintptr_t));
    if (!function.has_value() || !options_slot.has_value()
        || !renderer_slot.has_value()) {
      return ControllerResult::kInvalidModule;
    }

    std::uintptr_t root = 0u;
    std::uintptr_t renderer = 0u;
    if (!detail::ReadPointer(options_slot.value(), &root)
        || !detail::ReadPointer(renderer_slot.value(), &renderer)
        || root == 0u || renderer == 0u) {
      return ControllerResult::kObjectUnavailable;
    }
    if (!ValidateRuntimeObjects(root, renderer)) {
      return ControllerResult::kMemoryRejected;
    }

    float serialized_scale = 0.f;
    if (!detail::ReadFloat(root + kSerializedScaleOffset, &serialized_scale)
        || !IsSaneScale(serialized_scale)) {
      return ControllerResult::kScaleRejected;
    }

    module_base_ = module_base;
    options_slot_address_ = options_slot.value();
    renderer_slot_address_ = renderer_slot.value();
    target_function_ =
        reinterpret_cast<RuntimeUpdateFunction>(function.value());
    trampoline_ = target_function_;
    hook_phase_.store(
        HookLifecyclePhase::kRunning, std::memory_order_release);
    target_scale_bits_.store(
        std::bit_cast<std::uint32_t>(1.f), std::memory_order_release);
    serialized_scale_bits_.store(
        std::bit_cast<std::uint32_t>(serialized_scale),
        std::memory_order_release);
    rejected_updates_.store(0u, std::memory_order_relaxed);

    bool attach_succeeded = false;
    {
      detail::ExclusiveSrwLockGuard lifecycle_guard(&hook_lifecycle_lock_);
      auto* expected = static_cast<RuntimeController*>(nullptr);
      if (active_controller_.compare_exchange_strong(
              expected, this, std::memory_order_acq_rel)) {
        attach_succeeded = AttachHookLocked();
        if (!attach_succeeded) {
          expected = this;
          active_controller_.compare_exchange_strong(
              expected, nullptr, std::memory_order_acq_rel);
        }
      }
    }
    if (!attach_succeeded) {
      ResetStateLocked();
      return ControllerResult::kHookInstallFailed;
    }

    armed_ = true;
    return ControllerResult::kSuccess;
  }

  [[nodiscard]] ControllerResult Apply(
      float requested_scale,
      RuntimeCallContext context) {
    if (context != RuntimeCallContext::kOutsideLoaderLock) {
      return ControllerResult::kUnsafeCallContext;
    }
    if (!IsSaneScale(requested_scale)) {
      return ControllerResult::kScaleRejected;
    }

    std::scoped_lock lock(mutex_);
    if (!armed_) return ControllerResult::kNotArmed;
    const float current = std::bit_cast<float>(
        target_scale_bits_.load(std::memory_order_acquire));
    const auto decision = DecideScaleRequest(requested_scale, current);
    if (decision == ScaleRequestDecision::kReject) {
      return ControllerResult::kScaleRejected;
    }
    if (decision == ScaleRequestDecision::kNoChange) {
      return ControllerResult::kNoChange;
    }
    target_scale_bits_.store(
        std::bit_cast<std::uint32_t>(requested_scale),
        std::memory_order_release);
    return ControllerResult::kSuccess;
  }

  // Native TAA must honor the user's serialized scale. Closing first prevents
  // an already-entered hook from publishing an SR extent after native restore.
  [[nodiscard]] ControllerResult Shutdown(RuntimeCallContext context) {
    if (context != RuntimeCallContext::kOutsideLoaderLock) {
      return ControllerResult::kUnsafeCallContext;
    }
    std::scoped_lock lock(mutex_);
    if (!armed_) return ControllerResult::kNotArmed;

    target_scale_bits_.store(
        serialized_scale_bits_.load(std::memory_order_acquire),
        std::memory_order_release);
    hook_phase_.store(
        HookLifecyclePhase::kClosingAttached, std::memory_order_release);

    {
      // Drain every hook that can still use the Detours trampoline before the
      // detach transaction frees it. Calls redirected while this exclusive
      // lock is held wait in RuntimeUpdateHook until the original entry is
      // restored below.
      detail::ExclusiveSrwLockGuard lifecycle_guard(&hook_lifecycle_lock_);
      if (!DetachHookLocked()) {
        const auto restore_result = RestoreSerializedDimensionsLocked();
        hook_phase_.store(
            HookLifecyclePhase::kRunning, std::memory_order_release);
        (void)restore_result;
        return ControllerResult::kHookRemoveFailed;
      }
      hook_phase_.store(
          HookLifecyclePhase::kDetachedDraining, std::memory_order_release);
    }

    ControllerResult restore_result = ControllerResult::kObjectUnavailable;
    {
      // Any call redirected immediately before detach now invokes the restored
      // original entry and exits before this second exclusive acquisition.
      detail::ExclusiveSrwLockGuard lifecycle_guard(&hook_lifecycle_lock_);
      restore_result = RestoreSerializedDimensionsLocked();
      active_controller_.store(nullptr, std::memory_order_release);
      armed_ = false;
      ResetStateLocked();
    }
    return restore_result;
  }

  [[nodiscard]] ControllerSnapshot GetSnapshot() const {
    std::scoped_lock lock(mutex_);
    const float target_scale = std::bit_cast<float>(
        target_scale_bits_.load(std::memory_order_acquire));
    return ControllerSnapshot{
        .armed = armed_,
        .override_active =
            armed_
            && !ScalesMatch(
                target_scale,
                std::bit_cast<float>(serialized_scale_bits_.load(
                    std::memory_order_acquire))),
        .target_scale = target_scale,
        .serialized_scale = std::bit_cast<float>(
            serialized_scale_bits_.load(std::memory_order_acquire)),
        .last_base_extent = {
            last_base_width_.load(std::memory_order_relaxed),
            last_base_height_.load(std::memory_order_relaxed),
        },
        .last_render_extent = {
            last_render_width_.load(std::memory_order_relaxed),
            last_render_height_.load(std::memory_order_relaxed),
        },
        .rejected_updates = rejected_updates_.load(std::memory_order_relaxed),
    };
  }

 private:
  using RuntimeUpdateFunction = void (*)(void*);

  static void RuntimeUpdateHook(void* root_object) {
    detail::SharedSrwLockGuard lifecycle_guard(&hook_lifecycle_lock_);
    auto* controller = active_controller_.load(std::memory_order_acquire);
    if (controller == nullptr) return;

    const auto phase =
        controller->hook_phase_.load(std::memory_order_acquire);
    const auto original =
        SelectHookOriginalRoute(phase) == HookOriginalRoute::kOriginalEntry
            ? controller->target_function_
            : controller->trampoline_;
    if (original != nullptr) original(root_object);
    if (ShouldPublishHookPostUpdate(
            controller->hook_phase_.load(std::memory_order_acquire))) {
      controller->ApplyPostUpdate(root_object);
    }
  }

  void ApplyPostUpdate(void* root_object) noexcept {
    const auto root = reinterpret_cast<std::uintptr_t>(root_object);
    std::uintptr_t expected_root = 0u;
    std::uintptr_t renderer = 0u;
    if (root == 0u
        || !detail::ReadPointer(options_slot_address_, &expected_root)
        || expected_root != root
        || !detail::ReadPointer(renderer_slot_address_, &renderer)
        || renderer == 0u || !ValidateRuntimeObjects(root, renderer)) {
      rejected_updates_.fetch_add(1u, std::memory_order_relaxed);
      return;
    }

    PixelExtent base = {};
    PixelExtent observed = {};
    float serialized_scale = 0.f;
    if (!ReadRuntimeValues(root, &base, &observed, &serialized_scale)) {
      rejected_updates_.fetch_add(1u, std::memory_order_relaxed);
      return;
    }
    serialized_scale_bits_.store(
        std::bit_cast<std::uint32_t>(serialized_scale),
        std::memory_order_release);

    const float target_scale = std::bit_cast<float>(
        target_scale_bits_.load(std::memory_order_acquire));
    const auto update =
        CalculateRuntimeDimensionUpdate(base, observed, target_scale);
    if (!update.has_value()) {
      rejected_updates_.fetch_add(1u, std::memory_order_relaxed);
      return;
    }
    PublishRuntimeDimensions(root, renderer, base, update.value());
  }

  [[nodiscard]] ControllerResult RestoreSerializedDimensionsLocked() noexcept {
    std::uintptr_t root = 0u;
    std::uintptr_t renderer = 0u;
    if (!detail::ReadPointer(options_slot_address_, &root)
        || !detail::ReadPointer(renderer_slot_address_, &renderer)
        || root == 0u || renderer == 0u || !ValidateRuntimeObjects(root, renderer)) {
      return ControllerResult::kObjectUnavailable;
    }

    PixelExtent base = {};
    PixelExtent observed = {};
    float serialized_scale = 0.f;
    if (!ReadRuntimeValues(root, &base, &observed, &serialized_scale)) {
      return ControllerResult::kMemoryRejected;
    }
    const auto update =
        CalculateRuntimeDimensionUpdate(base, observed, serialized_scale);
    if (!update.has_value()) return ControllerResult::kScaleRejected;

    target_scale_bits_.store(
        std::bit_cast<std::uint32_t>(serialized_scale),
        std::memory_order_release);
    serialized_scale_bits_.store(
        std::bit_cast<std::uint32_t>(serialized_scale),
        std::memory_order_release);
    PublishRuntimeDimensions(root, renderer, base, update.value());
    return update->changed ? ControllerResult::kSuccess
                           : ControllerResult::kNoChange;
  }

  [[nodiscard]] static bool ReadRuntimeValues(
      std::uintptr_t root,
      PixelExtent* base,
      PixelExtent* observed,
      float* serialized_scale) noexcept {
    if (base == nullptr || observed == nullptr || serialized_scale == nullptr) {
      return false;
    }
#if defined(_MSC_VER)
    __try {
      base->width = *reinterpret_cast<const std::uint32_t*>(
          root + kBaseWidthOffset);
      base->height = *reinterpret_cast<const std::uint32_t*>(
          root + kBaseHeightOffset);
      observed->width = *reinterpret_cast<const std::uint32_t*>(
          root + kRenderWidthOffset);
      observed->height = *reinterpret_cast<const std::uint32_t*>(
          root + kRenderHeightOffset);
      *serialized_scale = *reinterpret_cast<const float*>(
          root + kSerializedScaleOffset);
      return IsSaneScale(*serialized_scale);
    } __except (EXCEPTION_EXECUTE_HANDLER) {
      return false;
    }
#else
    std::memcpy(base, reinterpret_cast<const void*>(root + kBaseWidthOffset), sizeof(*base));
    std::memcpy(observed, reinterpret_cast<const void*>(root + kRenderWidthOffset), sizeof(*observed));
    std::memcpy(serialized_scale, reinterpret_cast<const void*>(root + kSerializedScaleOffset), sizeof(*serialized_scale));
    return IsSaneScale(*serialized_scale);
#endif
  }

  void PublishRuntimeDimensions(
      std::uintptr_t root,
      std::uintptr_t renderer,
      PixelExtent base,
      const RuntimeDimensionUpdate& update) noexcept {
#if defined(_MSC_VER)
    __try {
      InterlockedExchange(
          reinterpret_cast<volatile LONG*>(root + kRenderWidthOffset),
          static_cast<LONG>(update.target.width));
      InterlockedExchange(
          reinterpret_cast<volatile LONG*>(root + kRenderHeightOffset),
          static_cast<LONG>(update.target.height));
      InterlockedExchange(
          reinterpret_cast<volatile LONG*>(renderer + kRendererWidthOffset),
          static_cast<LONG>(update.target.width));
      InterlockedExchange(
          reinterpret_cast<volatile LONG*>(renderer + kRendererHeightOffset),
          static_cast<LONG>(update.target.height));
      if (update.changed) {
        InterlockedExchange8(
            reinterpret_cast<volatile CHAR*>(
                root + kRuntimeDirtyObservedFlagOffset),
            static_cast<CHAR>(1));
      }
    } __except (EXCEPTION_EXECUTE_HANDLER) {
      rejected_updates_.fetch_add(1u, std::memory_order_relaxed);
      return;
    }
#else
    std::memcpy(reinterpret_cast<void*>(root + kRenderWidthOffset), &update.target, sizeof(update.target));
    std::memcpy(reinterpret_cast<void*>(renderer + kRendererWidthOffset), &update.target, sizeof(update.target));
    if (update.changed) {
      *reinterpret_cast<std::uint8_t*>(
          root + kRuntimeDirtyObservedFlagOffset) = 1u;
    }
#endif
    last_base_width_.store(base.width, std::memory_order_relaxed);
    last_base_height_.store(base.height, std::memory_order_relaxed);
    last_render_width_.store(update.target.width, std::memory_order_relaxed);
    last_render_height_.store(update.target.height, std::memory_order_relaxed);
  }

  [[nodiscard]] bool AttachHookLocked() noexcept {
    detail::ProcessThreadEnrollment enrollment;
    if (trampoline_ == nullptr || !enrollment.Capture()
        || DetourTransactionBegin() != NO_ERROR) {
      return false;
    }
    if (!enrollment.EnlistAll()
        || DetourAttach(
               reinterpret_cast<PVOID*>(&trampoline_),
               reinterpret_cast<PVOID>(&RuntimeUpdateHook))
               != NO_ERROR) {
      DetourTransactionAbort();
      return false;
    }
    if (DetourTransactionCommit() != NO_ERROR) {
      return false;
    }
    return true;
  }

  [[nodiscard]] bool DetachHookLocked() noexcept {
    detail::ProcessThreadEnrollment enrollment;
    if (trampoline_ == nullptr || !enrollment.Capture()
        || DetourTransactionBegin() != NO_ERROR) {
      return false;
    }
    if (!enrollment.EnlistAll()
        || DetourDetach(
               reinterpret_cast<PVOID*>(&trampoline_),
               reinterpret_cast<PVOID>(&RuntimeUpdateHook))
               != NO_ERROR) {
      DetourTransactionAbort();
      return false;
    }
    if (DetourTransactionCommit() != NO_ERROR) {
      return false;
    }
    return true;
  }

  void ResetStateLocked() noexcept {
    module_base_ = 0u;
    options_slot_address_ = 0u;
    renderer_slot_address_ = 0u;
    target_function_ = nullptr;
    trampoline_ = nullptr;
    hook_phase_.store(
        HookLifecyclePhase::kRunning, std::memory_order_release);
    target_scale_bits_.store(
        std::bit_cast<std::uint32_t>(1.f), std::memory_order_release);
    serialized_scale_bits_.store(
        std::bit_cast<std::uint32_t>(1.f), std::memory_order_release);
    last_base_width_.store(0u, std::memory_order_relaxed);
    last_base_height_.store(0u, std::memory_order_relaxed);
    last_render_width_.store(0u, std::memory_order_relaxed);
    last_render_height_.store(0u, std::memory_order_relaxed);
    rejected_updates_.store(0u, std::memory_order_relaxed);
  }

  [[nodiscard]] static bool ValidateRuntimeObjects(
      std::uintptr_t root,
      std::uintptr_t renderer) noexcept {
    return root % alignof(void*) == 0u && renderer % alignof(void*) == 0u
           && detail::IsAccessibleRange(
               root + kRuntimeDirtyObservedFlagOffset,
               sizeof(std::uint8_t),
               true)
           && detail::IsAccessibleRange(
               root + kBaseWidthOffset,
               kRenderHeightOffset - kBaseWidthOffset + sizeof(std::uint32_t),
               true)
           && detail::IsAccessibleRange(
               root + kSerializedScaleOffset, sizeof(float), false)
           && detail::IsAccessibleRange(
               renderer + kRendererWidthOffset,
               kRendererHeightOffset - kRendererWidthOffset
                   + sizeof(std::uint32_t),
               true);
  }

  [[nodiscard]] static bool ValidateLoadedImage(std::uintptr_t module_base) {
    if (!detail::IsAccessibleRange(
            module_base, sizeof(IMAGE_DOS_HEADER), false)) {
      return false;
    }
    IMAGE_DOS_HEADER dos = {};
    if (!detail::CopyFromProcessMemory(
            reinterpret_cast<const void*>(module_base), &dos, sizeof(dos))
        || dos.e_magic != IMAGE_DOS_SIGNATURE || dos.e_lfanew <= 0) {
      return false;
    }
    const auto nt_address = CheckedAdd(
        module_base, static_cast<std::uintptr_t>(dos.e_lfanew));
    if (!nt_address.has_value()
        || !detail::IsAccessibleRange(
            nt_address.value(), sizeof(IMAGE_NT_HEADERS64), false)) {
      return false;
    }
    IMAGE_NT_HEADERS64 nt = {};
    if (!detail::CopyFromProcessMemory(
            reinterpret_cast<const void*>(nt_address.value()),
            &nt,
            sizeof(nt))) {
      return false;
    }
    return nt.Signature == IMAGE_NT_SIGNATURE
           && nt.FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64
           && nt.FileHeader.TimeDateStamp == kSupportedPeTimestamp
           && nt.OptionalHeader.Magic == IMAGE_NT_OPTIONAL_HDR64_MAGIC
           && nt.OptionalHeader.SizeOfImage == kSupportedImageSize;
  }

  [[nodiscard]] static bool ValidateCode(std::uintptr_t module_base) {
    const auto prologue = ResolveImageAddress(
        module_base,
        kSupportedImageSize,
        kRuntimeUpdateFunctionRva,
        kRuntimeUpdatePrologue.size());
    const auto scale_load = ResolveImageAddress(
        module_base,
        kSupportedImageSize,
        kRuntimeScaleLoadRva,
        kRuntimeScaleLoad.size());
    const auto renderer_store = ResolveImageAddress(
        module_base,
        kSupportedImageSize,
        kRendererStoreSequenceRva,
        kRendererStoreSequence.size());
    const auto call_site = ResolveImageAddress(
        module_base,
        kSupportedImageSize,
        kRuntimeUpdateCallSiteRva,
        kRuntimeUpdateCallSite.size());
    if (!prologue.has_value() || !scale_load.has_value()
        || !renderer_store.has_value() || !call_site.has_value()
        || !detail::IsAccessibleRange(
            prologue.value(), kRuntimeUpdatePrologue.size(), false, true)
        || !detail::IsAccessibleRange(
            scale_load.value(), kRuntimeScaleLoad.size(), false, true)
        || !detail::IsAccessibleRange(
            renderer_store.value(), kRendererStoreSequence.size(), false, true)
        || !detail::IsAccessibleRange(
            call_site.value(), kRuntimeUpdateCallSite.size(), false, true)) {
      return false;
    }
    return ValidateKnownCode({
                                 .runtime_update_prologue = {
                                     reinterpret_cast<const std::uint8_t*>(prologue.value()),
                                     kRuntimeUpdatePrologue.size()},
                                 .runtime_scale_load = {reinterpret_cast<const std::uint8_t*>(scale_load.value()), kRuntimeScaleLoad.size()},
                                 .renderer_store_sequence = {reinterpret_cast<const std::uint8_t*>(renderer_store.value()), kRendererStoreSequence.size()},
                                 .runtime_update_call_site = {reinterpret_cast<const std::uint8_t*>(call_site.value()), kRuntimeUpdateCallSite.size()},
                             })
        .Succeeded();
  }

  mutable std::mutex mutex_;
  bool armed_ = false;
  std::uintptr_t module_base_ = 0u;
  std::uintptr_t options_slot_address_ = 0u;
  std::uintptr_t renderer_slot_address_ = 0u;
  RuntimeUpdateFunction target_function_ = nullptr;
  RuntimeUpdateFunction trampoline_ = nullptr;
  std::atomic<HookLifecyclePhase> hook_phase_ = HookLifecyclePhase::kRunning;
  std::atomic_uint32_t target_scale_bits_ =
      std::bit_cast<std::uint32_t>(1.f);
  std::atomic_uint32_t serialized_scale_bits_ =
      std::bit_cast<std::uint32_t>(1.f);
  std::atomic_uint32_t last_base_width_ = 0u;
  std::atomic_uint32_t last_base_height_ = 0u;
  std::atomic_uint32_t last_render_width_ = 0u;
  std::atomic_uint32_t last_render_height_ = 0u;
  std::atomic_uint64_t rejected_updates_ = 0u;

  inline static SRWLOCK hook_lifecycle_lock_ = SRWLOCK_INIT;
  inline static std::atomic<RuntimeController*> active_controller_ = nullptr;
};

}  // namespace renodx::games::detroitbecomehuman::resolution_scaling

#endif  // defined(_WIN64)
