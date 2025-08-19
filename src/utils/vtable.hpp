/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <concepts>
#include <ranges>

#include <detours.h>

#include "./log.hpp"

namespace renodx::utils::vtable {

// Function name, real function pointer, hook function pointer
using HookItem = std::tuple<const char*, void**, void*>;

template <std::ranges::range Hooks>
  requires std::convertible_to<std::ranges::range_value_t<Hooks>, HookItem>
static bool Hook(HMODULE module, const Hooks& hooks) {
  bool any_hooked = false;

  if (module == nullptr) {
    log::e("vtable::Hook(Module not loaded.)");
    return false;
  }

  bool transaction_running = false;
  for (const auto& [function_name, real, hook] : hooks) {
    FARPROC proc = GetProcAddress(module, function_name);
    if (proc == nullptr) {
      log::e("vtable::Hook(Failed to find ", function_name, ")");
      continue;
    }

    assert(*real == nullptr);  // Ensure real pointer is not already set

    *real = reinterpret_cast<void*>(proc);

    assert(*real == (void*)proc);

    if (!transaction_running) {
      if (DetourTransactionBegin() != NO_ERROR) {
        log::e("vtable::Hook(Detour transaction begin failed for", function_name, ")");
        continue;
      }
      if (DetourUpdateThread(GetCurrentThread()) != NO_ERROR) {
        log::e("vtable::Hook(Detour update thread failed for", function_name, ")");
        DetourTransactionAbort();
        continue;
      }
      transaction_running = true;
    }
    if (DetourAttach(reinterpret_cast<void**>(real), hook) != NO_ERROR) {
      log::e("vtable::Hook(Detour attach failed for", function_name, ")");
      DetourTransactionAbort();
      transaction_running = false;
      continue;
    }
    log::d(
        "vtable::Hook(", function_name, "hooked with ",
        log::AsPtr(proc), " => ", log::AsPtr(hook),
        " (", log::AsPtr(*(void**)real),
        " ) (", log::AsPtr(real), ")",
        ")");

    any_hooked = true;
  }

  if (transaction_running) {
    if (DetourTransactionCommit() != NO_ERROR) {
      log::e("vtable::Hook(Detour transaction commit failed.)");
      DetourTransactionAbort();
    }
  }

  return any_hooked;
}

template <std::ranges::range Hooks>
  requires std::convertible_to<std::ranges::range_value_t<Hooks>, HookItem>
static void Unhook(HMODULE module, const Hooks& hooks) {
  if (module == nullptr) {
    log::w("vtable::Unhook(DLL already loaded)");
  }

  for (const auto& [function_name, real, hook] : hooks) {
    if (hook == nullptr) {
      log::w("vtable::Unhook(Invalid hook tuple for ", function_name, ")");
      continue;
    }
    if (*real == nullptr) {
      log::w("vtable::Unhook(", function_name, " not hooked, skipping)");
      continue;
    }
    if (DetourTransactionBegin() != NO_ERROR) {
      log::e("vtable::Unhook(Detour transaction begin failed for ", function_name, ")");
      continue;
    }
    if (DetourUpdateThread(GetCurrentThread()) != NO_ERROR) {
      log::e("vtable::Unhook(Detour update thread failed for ", function_name, ")");
      continue;
    }
    if (DetourDetach(reinterpret_cast<void**>(real), hook) != NO_ERROR) {
      log::e("vtable::Unhook(Detour detach failed for ", function_name, ")");
      continue;
    }
    if (DetourTransactionCommit() != NO_ERROR) {
      log::e("vtable::Unhook(Detour transaction commit failed for ", function_name, ")");
      continue;
    }
    *real = nullptr;
    log::i("vtable::Unhook(", function_name, " unhooked successfully)");
  }
}

}  // namespace renodx::utils::vtable