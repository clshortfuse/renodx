/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <include/reshade.hpp>

#include "./dlss/nvngx.hpp"
#include "./dlss/streamline_v2.hpp"
#include "./iat_hook.hpp"
#include "./log.hpp"
#include "./platform.hpp"
#include "./vtable.hpp"

namespace renodx::utils::dlss_hook {

namespace internal {

static bool attached = false;
}  // namespace internal

std::string streamline_interposer_file_path;
std::string nvngx_dlss_file_path;

static decltype(&GetModuleHandleA) real_GetModuleHandleA = nullptr;
static HMODULE WINAPI HookGetModuleHandleA(LPCSTR lpModuleName) {
  auto* ret = real_GetModuleHandleA(lpModuleName);
  if (lpModuleName == nullptr || ret == nullptr) return ret;
  utils::log::d("HookGetModuleHandleA: ", lpModuleName);
  return ret;
}

static decltype(&GetModuleHandleW) real_GetModuleHandleW = nullptr;
static HMODULE WINAPI HookGetModuleHandleW(LPCWSTR lpModuleName) {
  auto* ret = real_GetModuleHandleW(lpModuleName);
  if (lpModuleName == nullptr || ret == nullptr) return ret;

  std::string lpModuleNameStr;
  if (lpModuleName != nullptr) {
    int len = WideCharToMultiByte(CP_UTF8, 0, lpModuleName, -1, nullptr, 0, nullptr, nullptr);
    if (len > 0) {
      lpModuleNameStr.resize(len - 1);
      WideCharToMultiByte(CP_UTF8, 0, lpModuleName, -1, lpModuleNameStr.data(), len, nullptr, nullptr);
    }
  }

  utils::log::d("HookGetModuleHandleW: ", lpModuleNameStr);
  return ret;
}

static decltype(&LoadLibraryA) real_LoadLibraryA = nullptr;
static HMODULE WINAPI HookLoadLibraryA(LPCSTR lpLibFileName) {
  auto* ret = real_LoadLibraryA(lpLibFileName);
  if (lpLibFileName == nullptr || ret == nullptr) return ret;
  utils::log::d("HookLoadLibraryA: ", lpLibFileName);
  return ret;

  if (std::filesystem::path(lpLibFileName).filename() == "sl.interposer.dll") {
    utils::vtable::Hook(ret, streamline::v2::INTERPOSER_HOOKS);
  } else if (std::filesystem::path(lpLibFileName).filename() == "nvngx_dlss.dll") {
    utils::vtable::Hook(ret, dlss::nvngx::DLSS_HOOKS);
  }
  return ret;
}

static decltype(&LoadLibraryExA) real_LoadLibraryExA = nullptr;
static HMODULE WINAPI HookLoadLibraryExA(LPCSTR lpLibFileName, HANDLE hFile, DWORD dwFlags) {
  auto* ret = real_LoadLibraryExA(lpLibFileName, hFile, dwFlags);
  if (lpLibFileName == nullptr || ret == nullptr) return ret;

  utils::log::d("HookLoadLibraryExA: ", lpLibFileName);
  return ret;

  if (std::filesystem::path(lpLibFileName).filename() == "sl.interposer.dll") {
    utils::vtable::Hook(ret, streamline::v2::INTERPOSER_HOOKS);
  } else if (std::filesystem::path(lpLibFileName).filename() == "nvngx_dlss.dll") {
    utils::vtable::Hook(ret, dlss::nvngx::DLSS_HOOKS);
  }

  return ret;
}

static decltype(&LoadLibraryW) real_LoadLibraryW = nullptr;
static HMODULE WINAPI HookLoadLibraryW(LPCWSTR lpLibFileName) {
  auto* ret = real_LoadLibraryW(lpLibFileName);
  if (lpLibFileName == nullptr || ret == nullptr) return ret;

  std::string lpLibFileNameStr;
  if (lpLibFileName != nullptr) {
    int len = WideCharToMultiByte(CP_UTF8, 0, lpLibFileName, -1, nullptr, 0, nullptr, nullptr);
    if (len > 0) {
      lpLibFileNameStr.resize(len - 1);
      WideCharToMultiByte(CP_UTF8, 0, lpLibFileName, -1, lpLibFileNameStr.data(), len, nullptr, nullptr);
    }
  }

  utils::log::d("HookLoadLibraryW: ", lpLibFileNameStr);
  return ret;
  if (std::filesystem::path(lpLibFileNameStr).filename() == "sl.interposer.dll") {
    utils::vtable::Hook(ret, streamline::v2::INTERPOSER_HOOKS);
  } else if (std::filesystem::path(lpLibFileNameStr).filename() == "nvngx_dlss.dll") {
    utils::vtable::Hook(ret, dlss::nvngx::DLSS_HOOKS);
  }

  return ret;
}

static decltype(&LoadLibraryExW) real_LoadLibraryExW = nullptr;
static HMODULE WINAPI HookLoadLibraryExW(LPCWSTR lpLibFileName, HANDLE hFile, DWORD dwFlags) {
  auto* ret = real_LoadLibraryExW(lpLibFileName, hFile, dwFlags);
  if (lpLibFileName == nullptr || ret == nullptr) return ret;

  std::string lpLibFileNameStr;
  if (lpLibFileName != nullptr) {
    int len = WideCharToMultiByte(CP_UTF8, 0, lpLibFileName, -1, nullptr, 0, nullptr, nullptr);
    if (len > 0) {
      lpLibFileNameStr.resize(len - 1);
      WideCharToMultiByte(CP_UTF8, 0, lpLibFileName, -1, lpLibFileNameStr.data(), len, nullptr, nullptr);
    }
  }

  utils::log::d("HookLoadLibraryExW: ", lpLibFileNameStr);
  return ret;
  if (std::filesystem::path(lpLibFileNameStr).filename() == "sl.interposer.dll") {
    utils::vtable::Hook(ret, streamline::v2::INTERPOSER_HOOKS);
  } else if (std::filesystem::path(lpLibFileNameStr).filename() == "nvngx_dlss.dll") {
    utils::vtable::Hook(ret, dlss::nvngx::DLSS_HOOKS);
  }

  return ret;
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (internal::attached) return;
      internal::attached = true;
      utils::log::i("utils::dlss_hook attached.");

      {
#ifndef NDEBUG
        assert(IsDebuggerPresent());
        renodx::utils::iat_hook::PatchIAT("kernel32.dll", (void*)&LoadLibraryA, (void*)&HookLoadLibraryA, (void**)&real_LoadLibraryA, "LoadLibraryA");
        renodx::utils::iat_hook::PatchIAT("kernel32.dll", (void*)&LoadLibraryExA, (void*)&HookLoadLibraryExA, (void**)&real_LoadLibraryExA, "LoadLibraryExA");
        renodx::utils::iat_hook::PatchIAT("kernel32.dll", (void*)&LoadLibraryW, (void*)&HookLoadLibraryW, (void**)&real_LoadLibraryW, "LoadLibraryW");
        renodx::utils::iat_hook::PatchIAT("kernel32.dll", (void*)&LoadLibraryExW, (void*)&HookLoadLibraryExW, (void**)&real_LoadLibraryExW, "LoadLibraryExW");
#endif
        auto* sl_interposer = utils::platform::FindModule(streamline_interposer_file_path);
        if (sl_interposer != nullptr) {
          utils::vtable::Hook(sl_interposer, streamline::v2::INTERPOSER_HOOKS);
          reshade::register_event<reshade::addon_event::init_device>(streamline::v2::OnInitDevice);
          reshade::register_event<reshade::addon_event::init_command_queue>(streamline::v2::OnInitCommandQueue);
        } else {
          utils::log::w("Streamline interposer not found: ", streamline_interposer_file_path.c_str());
        }
        auto* nvngx_dlss = utils::platform::FindModule(nvngx_dlss_file_path);
        if (nvngx_dlss != nullptr) {
          utils::vtable::Hook(nvngx_dlss, dlss::nvngx::DLSS_HOOKS);
        } else {
          utils::log::w("NVNGX DLSS not found: ", nvngx_dlss_file_path.c_str());
        }
      }

      break;

    case DLL_PROCESS_DETACH:
      if (!internal::attached) return;
      internal::attached = false;
      // utils::vtable::Unhook(streamline_interposer_file_path.c_str(), streamline::v2::INTERPOSER_HOOKS);
      // utils::vtable::Unhook(nvngx_dlss_file_path.c_str(), dlss::nvngx::DLSS_HOOKS);
      // internal::attached = false;
      break;
    default:
      break;
  }
}

}  // namespace renodx::utils::dlss_hook