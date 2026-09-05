/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <detours.h>
#include <Windows.h>

#include <concepts>
#include <cstdint>
#include <ranges>
#include <stdexcept>
#include <system_error>
#include <type_traits>

namespace renodx::utils::detour {

struct Item {
  Item() = default;

  template <typename Function>
    requires std::is_pointer_v<Function> && std::is_function_v<std::remove_pointer_t<Function>>
  Item(Function* original, Function replacement)
      : Item(reinterpret_cast<void**>(original), reinterpret_cast<void*>(replacement)) {}

  Item(void** original, void* replacement)
      : original(original), replacement(replacement) {}

  void** original = nullptr;
  void* replacement = nullptr;
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

  void Queue(const Item& item) {
    if (operation == Operation::INSTALL) {
      ThrowIfFailed(DetourAttach(item.original, item.replacement), "DetourAttach");
    } else {
      ThrowIfFailed(DetourDetach(item.original, item.replacement), "DetourDetach");
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

template <std::ranges::forward_range Items>
  requires std::same_as<std::ranges::range_value_t<Items>, Item>
void ApplyTransaction(Operation operation, const Items& items) {
  if (std::ranges::empty(items)) {
    throw std::invalid_argument("detour item range is empty");
  }

  for (const Item& item : items) {
    if (item.original == nullptr
        || *item.original == nullptr
        || item.replacement == nullptr) {
      throw std::invalid_argument("invalid detour item");
    }
  }

  Transaction transaction(operation);
  for (const Item& item : items) {
    transaction.Queue(item);
  }
  transaction.Commit();
}

}  // namespace internal

/// Installs all detours in one atomic operation.
/// @throws std::invalid_argument If the range is empty or contains an invalid detour.
/// @throws std::system_error If Detours cannot complete the operation.
template <std::ranges::forward_range Items>
  requires std::same_as<std::ranges::range_value_t<Items>, Item>
void Install(const Items& items) {
  internal::ApplyTransaction(internal::Operation::INSTALL, items);
}

/// Uninstalls all detours in one atomic operation.
/// @throws std::invalid_argument If the range is empty or contains an invalid detour.
/// @throws std::system_error If Detours cannot complete the operation.
template <std::ranges::forward_range Items>
  requires std::same_as<std::ranges::range_value_t<Items>, Item>
void Uninstall(const Items& items) {
  internal::ApplyTransaction(internal::Operation::UNINSTALL, items);
}

}  // namespace renodx::utils::detour