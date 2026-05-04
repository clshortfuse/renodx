/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <Windows.h>
#include <wrl/client.h>

#include <cstdint>
#include <format>
#include <vector>

#include <include/reshade.hpp>

namespace renodx::utils::iat_hook {

namespace internal {

static bool is_primary_hook = false;

static bool attached = false;
}  // namespace internal

static bool PatchIAT(const char* moduleName, void* function, void* hook, void** trampoline, const char* functionName = nullptr) {
  HMODULE hModule = GetModuleHandle(nullptr);  // Current module (exe or DLL)
  if (!hModule) return false;
  if (trampoline && *trampoline != nullptr) {
    // Already hooked, do not patch again
    reshade::log::message(reshade::log::level::warning,
                          std::format("PatchIAT: {} already hooked", functionName ? functionName : "<unknown>").c_str());
    return false;
  }

  auto* dosHeader = reinterpret_cast<PIMAGE_DOS_HEADER>(hModule);
  auto* ntHeaders = reinterpret_cast<PIMAGE_NT_HEADERS>(
      reinterpret_cast<BYTE*>(hModule) + dosHeader->e_lfanew);

  auto* importDesc = reinterpret_cast<PIMAGE_IMPORT_DESCRIPTOR>(
      reinterpret_cast<BYTE*>(hModule) + ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);

  for (; importDesc->Name; ++importDesc) {
    const char* dllName = reinterpret_cast<const char*>(
        reinterpret_cast<BYTE*>(hModule) + importDesc->Name);
    if (_stricmp(dllName, moduleName) != 0) continue;

    auto* thunk = reinterpret_cast<PIMAGE_THUNK_DATA>(
        reinterpret_cast<BYTE*>(hModule) + importDesc->FirstThunk);

    for (; thunk->u1.Function; ++thunk) {
      auto* funcPtr = reinterpret_cast<FARPROC*>(&thunk->u1.Function);
      if (*funcPtr == reinterpret_cast<FARPROC>(function)) {
        if (trampoline) *trampoline = reinterpret_cast<void*>(*funcPtr);

        DWORD oldProtect;
        if (VirtualProtect(funcPtr, sizeof(void*), PAGE_READWRITE, &oldProtect)) {
          *funcPtr = reinterpret_cast<FARPROC>(hook);
          VirtualProtect(funcPtr, sizeof(void*), oldProtect, &oldProtect);
          reshade::log::message(
              reshade::log::level::info,
              std::format("PatchIAT: Successfully hooked {} in {}", functionName ? functionName : "<unknown>", moduleName ? moduleName : "<unknown>").c_str());
          return true;
        } else {
          if (trampoline) *trampoline = nullptr;
          reshade::log::message(
              reshade::log::level::error,
              std::format("PatchIAT: VirtualProtect failed for {} in {}", functionName ? functionName : "<unknown>", moduleName ? moduleName : "<unknown>").c_str());
          return false;
        }
      }
    }
  }
  reshade::log::message(
      reshade::log::level::error,
      std::format("PatchIAT: Could not find {} in {}", functionName ? functionName : "<unknown>", moduleName ? moduleName : "<unknown>").c_str());
  return false;
}

static bool UnpatchIAT(const char* moduleName, void* hook, void* original, const char* functionName = nullptr) {
  HMODULE hModule = GetModuleHandle(nullptr);  // Current module (exe or DLL)
  if (!hModule) return false;
  if (original == nullptr) return false;

  auto* dosHeader = reinterpret_cast<PIMAGE_DOS_HEADER>(hModule);
  auto* ntHeaders = reinterpret_cast<PIMAGE_NT_HEADERS>(
      reinterpret_cast<BYTE*>(hModule) + dosHeader->e_lfanew);

  auto* importDesc = reinterpret_cast<PIMAGE_IMPORT_DESCRIPTOR>(
      reinterpret_cast<BYTE*>(hModule) + ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);

  for (; importDesc->Name; ++importDesc) {
    const char* dllName = reinterpret_cast<const char*>(
        reinterpret_cast<BYTE*>(hModule) + importDesc->Name);
    if (_stricmp(dllName, moduleName) != 0) continue;

    auto* thunk = reinterpret_cast<PIMAGE_THUNK_DATA>(
        reinterpret_cast<BYTE*>(hModule) + importDesc->FirstThunk);

    for (; thunk->u1.Function; ++thunk) {
      FARPROC* funcPtr = reinterpret_cast<FARPROC*>(&thunk->u1.Function);
      // Restore if currently hooked
      if (*funcPtr == reinterpret_cast<FARPROC>(hook)) {
        DWORD oldProtect;
        if (VirtualProtect(funcPtr, sizeof(void*), PAGE_READWRITE, &oldProtect)) {
          *funcPtr = reinterpret_cast<FARPROC>(original);
          VirtualProtect(funcPtr, sizeof(void*), oldProtect, &oldProtect);
          reshade::log::message(
              reshade::log::level::info,
              std::format("UnpatchIAT: Successfully unhooked {} in {}", functionName ? functionName : "<unknown>", moduleName ? moduleName : "<unknown>").c_str());
          return true;
        } else {
          reshade::log::message(
              reshade::log::level::error,
              std::format("UnpatchIAT: VirtualProtect failed for {} in {}", functionName ? functionName : "<unknown>", moduleName ? moduleName : "<unknown>").c_str());
          return false;
        }
      }
    }
  }
  reshade::log::message(
      reshade::log::level::error,
      std::format("UnpatchIAT: Could not find {} in {}", functionName ? functionName : "<unknown>", moduleName ? moduleName : "<unknown>").c_str());
  return false;
}

using CustomHooks = std::vector<std::tuple<std::string, FARPROC, void**, void*>>;

static CustomHooks hooks;

static decltype(&GetProcAddress) real_GetProcAddress = nullptr;
static FARPROC WINAPI HookGetProcAddress(HMODULE hModule, LPCSTR lpProcName) {
  FARPROC ret = real_GetProcAddress(hModule, lpProcName);
  if (lpProcName == nullptr || ret == nullptr) return ret;

  // If lpProcName is an ordinal (not a string), skip hooking
  if ((uintptr_t)lpProcName < 0x10000) return ret;

  // Abstracted hook resolver for functions
  auto resolve_hook = [&](const char* name, FARPROC real_func, void** real_func_ptr, void* hook_func) -> FARPROC {
    if (strcmp(lpProcName, name) == 0) {
      if (*real_func_ptr == nullptr) {
        *real_func_ptr = (void*)ret;
      }
      return (FARPROC)hook_func;
    }
    return nullptr;
  };

  FARPROC hook = nullptr;

  for (const auto& [name, real_func, real_func_ptr, hook_func] : hooks) {
    hook = resolve_hook(name.c_str(), real_func, real_func_ptr, hook_func);
    if (hook) return hook;
  }

  reshade::log::message(reshade::log::level::debug, std::format("utils::iat_hook::GetProcAddress() - {} not hooked", lpProcName).c_str());

  return ret;
}

static void PerformIATHooks() {
  PatchIAT("kernel32.dll", (void*)&GetProcAddress, (void*)&HookGetProcAddress, (void**)&real_GetProcAddress, "GetProcAddress");
}

static void PerformIATUnhooks() {
  UnpatchIAT("kernel32.dll", reinterpret_cast<void*>(&HookGetProcAddress), reinterpret_cast<void*>(real_GetProcAddress), "GetProcAddress");
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      reshade::log::message(reshade::log::level::info, "utils::iat_hook attached.");
      PerformIATHooks();
      break;

    case DLL_PROCESS_DETACH:
      if (!internal::attached) return;
      internal::attached = false;
      PerformIATUnhooks();
      break;
  }
}

}  // namespace renodx::utils::iat_hook