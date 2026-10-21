/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <stdexcept>
#include <string>
#include <system_error>
#include <type_traits>

#include <MinHook.h>

namespace renodx::utils::minhook {

// A borrowed descriptor, not an RAII owner. Keep original storage alive until
// removal; target remains the entry address while *original becomes a trampoline.
struct Function {
  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
                 && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Function(FunctionPointer target, FunctionPointer replacement, FunctionPointer* original)
      : target(reinterpret_cast<void*>(target)),
        replacement(reinterpret_cast<void*>(replacement)),
        original(reinterpret_cast<void**>(original)) {}

  void* target;
  void* replacement;
  void** original;
};

namespace internal {
class ErrorCategory final : public std::error_category {
 public:
  const char* name() const noexcept override { return "minhook"; }
  std::string message(int value) const override {
    return MH_StatusToString(static_cast<MH_STATUS>(value));
  }
};

inline void ThrowIfFailed(MH_STATUS status, const char* operation) {
  static const ErrorCategory CATEGORY;
  if (status != MH_OK) {
    throw std::system_error(static_cast<int>(status), CATEGORY, operation);
  }
}
}  // namespace internal

// Initialization belongs to the caller's linked backend, not the whole process.
// Do not mix raw MinHook lifecycle calls with independently owned wrapper users.
inline void Initialize() {
  internal::ThrowIfFailed(MH_Initialize(), "MH_Initialize");
}

// Requires every callback to have retired; also disables/removes remaining hooks.
// Pinned process-lifetime owners should not call this during consumer unregister.
inline void Uninitialize() {
  internal::ThrowIfFailed(MH_Uninitialize(), "MH_Uninitialize");
}

inline void Create(const Function& function) {
  if (function.target == nullptr || function.replacement == nullptr || function.original == nullptr) {
    throw std::invalid_argument("invalid minhook function");
  }
  internal::ThrowIfFailed(MH_CreateHook(function.target, function.replacement, function.original), "MH_CreateHook");
}

inline void Enable(const Function& function) {
  if (function.target == nullptr) throw std::invalid_argument("minhook target is null");
  internal::ThrowIfFailed(MH_EnableHook(function.target), "MH_EnableHook");
}

// Redirects future entries only. Existing callbacks may still need the trampoline.
inline void Disable(const Function& function) {
  if (function.target == nullptr) throw std::invalid_argument("minhook target is null");
  internal::ThrowIfFailed(MH_DisableHook(function.target), "MH_DisableHook");
}

// Queue/apply callers must serialize the entire sequence with every other user
// of this linked backend. ApplyQueued applies ALL pending requests in that
// instance, not just this caller's requests. Failures are not atomic rollback:
// queued requests or already-applied patches can remain after an exception.
inline void QueueEnable(const Function& function) {
  if (function.target == nullptr) throw std::invalid_argument("minhook target is null");
  internal::ThrowIfFailed(MH_QueueEnableHook(function.target), "MH_QueueEnableHook");
}

inline void QueueDisable(const Function& function) {
  if (function.target == nullptr) throw std::invalid_argument("minhook target is null");
  internal::ThrowIfFailed(MH_QueueDisableHook(function.target), "MH_QueueDisableHook");
}

inline void ApplyQueued() {
  internal::ThrowIfFailed(MH_ApplyQueued(), "MH_ApplyQueued");
}

// Caller must first establish callback quiescence. No implicit destructor calls.
inline void Remove(const Function& function) {
  if (function.target == nullptr || function.original == nullptr) {
    throw std::invalid_argument("invalid minhook function");
  }
  internal::ThrowIfFailed(MH_RemoveHook(function.target), "MH_RemoveHook");
  *function.original = nullptr;
}

}  // namespace renodx::utils::minhook