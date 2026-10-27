/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <detours.h>
#include <Windows.h>
#include <TlHelp32.h>

#include <atomic>
#include <concepts>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <ranges>
#include <memory>
#include <stdexcept>
#include <system_error>
#include <type_traits>
#include <vector>

#include <include/reshade.hpp>

namespace renodx::utils::detour {

// A batch enlists threads if any hook requests it. Enlistment is best-effort:
// inaccessible threads and threads created after the snapshot are not covered.
enum class ThreadPolicy : std::uint8_t {
  ENLIST_EXISTING_THREADS,
  // Caller guarantees no concurrent execution through affected code while patched.
  // This does not by itself make installation/removal under loader lock safe.
  CALLER_GUARANTEES_QUIESCENCE,
};

struct Function {
  Function() = default;

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Function(FunctionPointer* original, FunctionPointer replacement,
           ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS)
      : Function(reinterpret_cast<void**>(original), reinterpret_cast<void*>(replacement), thread_policy) {}

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Function(void** original, FunctionPointer replacement,
           ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS)
      : Function(original, reinterpret_cast<void*>(replacement), thread_policy) {}

  Function(void** original, void* replacement,
           ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS)
      : original(original), replacement(replacement), thread_policy(thread_policy) {}

  void** original = nullptr;
  void* replacement = nullptr;
  ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS;
};

struct Export {
  Export() = default;

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Export(const char* name, FunctionPointer* original, FunctionPointer replacement,
         ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS)
      : Export(name, reinterpret_cast<void**>(original), reinterpret_cast<void*>(replacement), thread_policy) {}

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Export(const char* name, void** original, FunctionPointer replacement,
         ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS)
      : Export(name, original, reinterpret_cast<void*>(replacement), thread_policy) {}

  Export(const char* name, void** original, void* replacement,
         ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS)
      : name(name), original(original), replacement(replacement), thread_policy(thread_policy) {}

  const char* name = nullptr;
  void** original = nullptr;
  void* replacement = nullptr;
  ThreadPolicy thread_policy = ThreadPolicy::ENLIST_EXISTING_THREADS;
};

struct ExportInstallResult {
  std::size_t requested = 0u;
  std::size_t installed = 0u;
  std::size_t already_installed = 0u;
  std::size_t missing = 0u;
  std::size_t failed = 0u;
  std::error_code error;

  [[nodiscard]] std::size_t Active() const {
    return installed + already_installed;
  }

  [[nodiscard]] bool Complete() const {
    return requested != 0u && Active() == requested;
  }
};

namespace internal {

enum class Operation : std::uint8_t {
  INSTALL,
  UNINSTALL,
};

inline void ThrowIfFailed(LONG error, const char* operation) {
  if (error != NO_ERROR) {
    throw std::system_error(static_cast<int>(error), std::system_category(), operation);
  }
}

class Transaction {
 public:
  explicit Transaction(Operation requested_operation, bool enlist_threads)
      : operation(requested_operation) {
    if (enlist_threads) {
      auto snapshot = std::shared_ptr<void>(CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0), [](void* owned) {
        if (owned != INVALID_HANDLE_VALUE) CloseHandle(owned);
      });
      if (snapshot.get() == INVALID_HANDLE_VALUE) {
        ThrowIfFailed(static_cast<LONG>(GetLastError()), "CreateToolhelp32Snapshot");
      }
      THREADENTRY32 entry{.dwSize = sizeof(THREADENTRY32)};
      DWORD first_denied_thread = 0;
      unsigned int denied_threads = 0;
      constexpr DWORD thread_access = THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT | THREAD_SET_CONTEXT | THREAD_QUERY_INFORMATION;
      if (Thread32First(snapshot.get(), &entry) != FALSE) {
        do {
          if (entry.th32OwnerProcessID != GetCurrentProcessId() || entry.th32ThreadID == GetCurrentThreadId()) continue;
          HANDLE thread_handle = OpenThread(thread_access, FALSE, entry.th32ThreadID);
          if (thread_handle == nullptr) {
            const DWORD error = GetLastError();
            if (error == ERROR_INVALID_PARAMETER) continue;
            if (error == ERROR_ACCESS_DENIED) {
              if (denied_threads == 0) {
                first_denied_thread = entry.th32ThreadID;
              }
              ++denied_threads;
              continue;
            }
            ThrowIfFailed(static_cast<LONG>(error), "OpenThread");
          }
          threads.push_back(std::shared_ptr<void>(thread_handle, [](void* owned) { CloseHandle(owned); }));
        } while (Thread32Next(snapshot.get(), &entry) != FALSE);
      }
      if (const DWORD error = GetLastError(); error != ERROR_NO_MORE_FILES) {
        ThrowIfFailed(static_cast<LONG>(error), "Thread32First/Thread32Next");
      }
      // No threads have been suspended yet: logging here cannot wait on a lock
      // held by a thread suspended by this transaction. Restricted threads remain
      // uncoordinated, matching the compatibility policy used before enlistment.
      if (denied_threads != 0) {
        static std::atomic_uint warning_count = 0;
        if (const auto warning = warning_count.fetch_add(1, std::memory_order_relaxed); warning < 8) {
          char message[512];
          std::snprintf(message, sizeof(message),
                        "utils::detour %s: OpenThread error=5 (Access is denied), access=0x%08lX; "
                        "skipping %u thread(s), first_thread_id=%lu. Continuing without coordinating these threads.%s",
                        (operation == Operation::INSTALL ? "install" : "uninstall"), thread_access,
                        denied_threads, first_denied_thread,
                        (warning == 7 ? " Further access-denied warnings suppressed." : ""));
          if (const auto module = reshade::internal::get_reshade_module_handle(); module != nullptr) {
            const auto logger = reinterpret_cast<void (*)(void*, int, const char*)>(GetProcAddress(module, "ReShadeLogMessage"));
            if (logger != nullptr) {
              logger(reshade::internal::get_current_module_handle(),
                     static_cast<int>(reshade::log::level::warning), message);
            } else {
              OutputDebugStringA(message);
            }
          } else {
            OutputDebugStringA(message);
          }
        }
      }
    }
    ThrowIfFailed(DetourTransactionBegin(), "DetourTransactionBegin");
    is_active = true;
    const LONG update_thread_error = DetourUpdateThread(GetCurrentThread());
    if (update_thread_error != NO_ERROR) {
      Rollback();
      ThrowIfFailed(update_thread_error, "DetourUpdateThread");
    }
    for (const auto& thread : threads) {
      const auto enlisted = DetourUpdateThread(thread.get());
      if (enlisted != NO_ERROR) {
        Rollback();
        ThrowIfFailed(enlisted, "DetourUpdateThread");
      }
    }
  }

  Transaction(const Transaction&) = delete;
  Transaction& operator=(const Transaction&) = delete;
  Transaction(Transaction&&) = delete;
  Transaction& operator=(Transaction&&) = delete;

  ~Transaction() {
    Rollback();
  }

  void Queue(const Function& function) {
    if (operation == Operation::INSTALL) {
      ThrowIfFailed(DetourAttach(function.original, function.replacement), "DetourAttach");
    } else {
      ThrowIfFailed(DetourDetach(function.original, function.replacement), "DetourDetach");
    }
  }

  void Commit() {
    const LONG commit_error = DetourTransactionCommit();
    is_active = false;
    ThrowIfFailed(commit_error, "DetourTransactionCommit");
  }

 private:
  void Rollback() {
    if (!is_active) return;
    is_active = false;
    (void)DetourTransactionAbort();
  }

  Operation operation;
  bool is_active = false;
  std::vector<std::shared_ptr<void>> threads;
};

template <std::ranges::forward_range Functions>
  requires std::same_as<std::ranges::range_value_t<Functions>, Function>
void ApplyTransaction(Operation operation, const Functions& functions) {
  if (std::ranges::empty(functions)) {
    throw std::invalid_argument("detour function range is empty");
  }

  bool enlist_threads = false;
  for (const Function& function : functions) {
    if (function.original == nullptr
        || *function.original == nullptr
        || function.replacement == nullptr) {
      throw std::invalid_argument("invalid detour function");
    }
    enlist_threads |= function.thread_policy != ThreadPolicy::CALLER_GUARANTEES_QUIESCENCE;
  }

  Transaction transaction(operation, enlist_threads);
  for (const Function& function : functions) {
    transaction.Queue(function);
  }
  transaction.Commit();
}

}  // namespace internal

/// Installs all detours in one atomic operation.
/// @throws std::invalid_argument If the range is empty or contains an invalid detour.
/// @throws std::system_error If Detours cannot complete the operation.
template <std::ranges::forward_range Functions>
  requires std::same_as<std::ranges::range_value_t<Functions>, Function>
void Install(const Functions& functions) {
  internal::ApplyTransaction(internal::Operation::INSTALL, functions);
}

/// Uninstalls all detours in one atomic operation.
/// @throws std::invalid_argument If the range is empty or contains an invalid detour.
/// @throws std::system_error If Detours cannot complete the operation.
template <std::ranges::forward_range Functions>
  requires std::same_as<std::ranges::range_value_t<Functions>, Function>
void Uninstall(const Functions& functions) {
  internal::ApplyTransaction(internal::Operation::UNINSTALL, functions);
}

/// Resolves and installs all available named exports in one atomic operation.
/// Missing exports are reported without preventing available exports from being installed.
/// @throws std::invalid_argument If the module or an export definition is invalid.
template <std::ranges::forward_range Exports>
  requires std::same_as<std::ranges::range_value_t<Exports>, Export>
ExportInstallResult Install(HMODULE module, const Exports& exports) {
  if (module == nullptr) {
    throw std::invalid_argument("detour export module is null");
  }
  if (std::ranges::empty(exports)) {
    throw std::invalid_argument("detour export range is empty");
  }

  ExportInstallResult result = {};
  for (const Export& export_function : exports) {
    ++result.requested;
    if (export_function.name == nullptr
        || export_function.original == nullptr
        || export_function.replacement == nullptr) {
      throw std::invalid_argument("invalid detour export");
    }
  }

  std::vector<Function> functions;
  std::vector<void**> resolved_originals;
  for (const Export& export_function : exports) {
    if (*export_function.original != nullptr) {
      ++result.already_installed;
      continue;
    }

    const FARPROC address = GetProcAddress(module, export_function.name);
    if (address == nullptr) {
      ++result.missing;
      continue;
    }

    *export_function.original = reinterpret_cast<void*>(address);
    functions.emplace_back(export_function.original, export_function.replacement, export_function.thread_policy);
    resolved_originals.push_back(export_function.original);
  }

  if (functions.empty()) return result;

  try {
    Install(functions);
  } catch (const std::system_error& error) {
    for (void** original : resolved_originals) {
      *original = nullptr;
    }
    result.failed = functions.size();
    result.error = error.code();
    return result;
  }
  result.installed = functions.size();
  return result;
}

/// Uninstalls all active named-export detours in one atomic operation.
/// @throws std::invalid_argument If an export definition is invalid.
/// @throws std::system_error If Detours cannot complete the operation.
template <std::ranges::forward_range Exports>
  requires std::same_as<std::ranges::range_value_t<Exports>, Export>
void Uninstall(const Exports& exports) {
  if (std::ranges::empty(exports)) {
    throw std::invalid_argument("detour export range is empty");
  }

  std::vector<Function> functions;
  std::vector<void**> active_originals;
  for (const Export& export_function : exports) {
    if (export_function.name == nullptr
        || export_function.original == nullptr
        || export_function.replacement == nullptr) {
      throw std::invalid_argument("invalid detour export");
    }
    if (*export_function.original == nullptr) continue;

    functions.emplace_back(export_function.original, export_function.replacement, export_function.thread_policy);
    active_originals.push_back(export_function.original);
  }

  if (functions.empty()) return;

  Uninstall(functions);
  for (void** original : active_originals) {
    *original = nullptr;
  }
}

}  // namespace renodx::utils::detour