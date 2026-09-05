/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <detours.h>
#include <Windows.h>

#include <concepts>
#include <cstddef>
#include <cstdint>
#include <ranges>
#include <stdexcept>
#include <system_error>
#include <type_traits>
#include <vector>

namespace renodx::utils::detour {

struct Function {
  Function() = default;

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Function(FunctionPointer* original, FunctionPointer replacement)
      : Function(reinterpret_cast<void**>(original), reinterpret_cast<void*>(replacement)) {}

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Function(void** original, FunctionPointer replacement)
      : Function(original, reinterpret_cast<void*>(replacement)) {}

  Function(void** original, void* replacement)
      : original(original), replacement(replacement) {}

  void** original = nullptr;
  void* replacement = nullptr;
};

struct Export {
  Export() = default;

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Export(const char* name, FunctionPointer* original, FunctionPointer replacement)
      : Export(name, reinterpret_cast<void**>(original), reinterpret_cast<void*>(replacement)) {}

  template <typename FunctionPointer>
    requires std::is_pointer_v<FunctionPointer>
             && std::is_function_v<std::remove_pointer_t<FunctionPointer>>
  Export(const char* name, void** original, FunctionPointer replacement)
      : Export(name, original, reinterpret_cast<void*>(replacement)) {}

  Export(const char* name, void** original, void* replacement)
      : name(name), original(original), replacement(replacement) {}

  const char* name = nullptr;
  void** original = nullptr;
  void* replacement = nullptr;
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
  explicit Transaction(Operation requested_operation)
      : operation(requested_operation) {
    ThrowIfFailed(DetourTransactionBegin(), "DetourTransactionBegin");
    is_active = true;

    const LONG update_thread_error = DetourUpdateThread(GetCurrentThread());
    if (update_thread_error != NO_ERROR) {
      Rollback();
      ThrowIfFailed(update_thread_error, "DetourUpdateThread");
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
};

template <std::ranges::forward_range Functions>
  requires std::same_as<std::ranges::range_value_t<Functions>, Function>
void ApplyTransaction(Operation operation, const Functions& functions) {
  if (std::ranges::empty(functions)) {
    throw std::invalid_argument("detour function range is empty");
  }

  for (const Function& function : functions) {
    if (function.original == nullptr
        || *function.original == nullptr
        || function.replacement == nullptr) {
      throw std::invalid_argument("invalid detour function");
    }
  }

  Transaction transaction(operation);
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
    functions.emplace_back(export_function.original, export_function.replacement);
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

    functions.emplace_back(export_function.original, export_function.replacement);
    active_originals.push_back(export_function.original);
  }

  if (functions.empty()) return;

  Uninstall(functions);
  for (void** original : active_originals) {
    *original = nullptr;
  }
}

}  // namespace renodx::utils::detour