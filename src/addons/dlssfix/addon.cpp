/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#ifndef NDEBUG
#define DEBUG_LEVEL_1
#endif

#include <cstring>
#include <filesystem>
#include <sstream>
#include <string>
#include <vector>
#include <windows.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../utils/dlss_hook.hpp"
#include "../../utils/settings.hpp"

namespace {

renodx::utils::settings::Settings settings = {};
bool initialized = false;

std::filesystem::path GetModulePath(HMODULE h_module) {
  wchar_t path[MAX_PATH] = L"";
  GetModuleFileNameW(h_module, path, ARRAYSIZE(path));
  return path;
}

std::vector<std::string> ReadConfigArray(const char* section, const char* key) {
  size_t value_size = 0;
  if (!reshade::get_config_value(nullptr, section, key, nullptr, &value_size) || value_size == 0) {
    return {};
  }

  std::string raw_value(value_size, '\0');
  if (!reshade::get_config_value(nullptr, section, key, raw_value.data(), &value_size)) {
    return {};
  }

  std::vector<std::string> values;
  for (size_t offset = 0; offset < raw_value.size();) {
    const auto* entry = raw_value.c_str() + offset;
    size_t entry_size = std::strlen(entry);
    if (entry_size == 0) break;

    values.emplace_back(entry);
    offset += entry_size + 1;
  }

  return values;
}

bool HasLoadFromDllMainEntry(HMODULE h_module) {
  const auto module_file = GetModulePath(h_module).filename();

  for (const auto& value : ReadConfigArray("ADDON", "LoadFromDllMain")) {
    if (lstrcmpiW(std::filesystem::path(value).filename().wstring().c_str(), module_file.wstring().c_str()) == 0) {
      return true;
    }
  }

  return false;
}

extern "C" IMAGE_DOS_HEADER __ImageBase;

void SetupPinnedModule() {
  static bool setup_pinned_module = false;

  if (setup_pinned_module) return;

  HMODULE h_module = nullptr;
  auto ret = GetModuleHandleExW(
      GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
      reinterpret_cast<LPCWSTR>(&__ImageBase),
      &h_module);
  if (ret == 0 || h_module == nullptr) {
    std::stringstream s;
    s << "Failed to pin addon module: " << std::hex << GetLastError();
    reshade::log::message(reshade::log::level::error, s.str().c_str());

    ret = GetModuleHandleExW(
        GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS,
        reinterpret_cast<LPCWSTR>(&__ImageBase),
        &h_module);

    if (ret == 0 || h_module == nullptr) {
      std::stringstream fallback;
      fallback << "Failed to increment addon module ref count: " << std::hex << GetLastError();
      reshade::log::message(reshade::log::level::error, fallback.str().c_str());
      return;
    }

    reshade::log::message(reshade::log::level::warning, "Incremented addon module ref count to avoid unload.");
  } else {
    reshade::log::message(reshade::log::level::info, "Pinned addon module to avoid unload.");
  }

  setup_pinned_module = true;
}

void ConfigureDlssHook() {
  renodx::utils::settings::use_presets = false;
  renodx::utils::settings::global_name = "RENODX-DLSSFIX";
  renodx::utils::dlss_hook::nvngx_dlss_file_path = renodx::utils::settings::ReadGlobalString("DLSSPath");
  renodx::utils::dlss_hook::streamline_interposer_file_path =
      renodx::utils::settings::ReadGlobalString("StreamlinePath");

  if (renodx::utils::dlss_hook::nvngx_dlss_file_path.empty()) {
    renodx::utils::dlss_hook::nvngx_dlss_file_path = "nvngx_dlss.dll";
    renodx::utils::settings::WriteGlobalString("DLSSPath", renodx::utils::dlss_hook::nvngx_dlss_file_path);
  }
  if (renodx::utils::dlss_hook::streamline_interposer_file_path.empty()) {
    renodx::utils::dlss_hook::streamline_interposer_file_path = "sl.interposer.dll";
    renodx::utils::settings::WriteGlobalString("StreamlinePath",
                                               renodx::utils::dlss_hook::streamline_interposer_file_path);
  }
}

void DetectLoadMode(HMODULE h_module) {
  static bool checked_load_mode = false;

  if (checked_load_mode) return;
  checked_load_mode = true;

  const auto module_file = GetModulePath(h_module).filename().string();

  const bool streamline_loaded = renodx::utils::platform::IsModuleLoaded(renodx::utils::dlss_hook::streamline_interposer_file_path);
  const bool dlss_loaded = renodx::utils::platform::IsModuleLoaded(renodx::utils::dlss_hook::nvngx_dlss_file_path);

  if (HasLoadFromDllMainEntry(h_module)) {
    std::stringstream s;
    s << module_file << " is listed in ADDON.LoadFromDllMain.";
    reshade::log::message(reshade::log::level::info, s.str().c_str());
    return;
  }

  std::stringstream s;
  s << module_file << " is not listed in ADDON.LoadFromDllMain";

  if (streamline_loaded || dlss_loaded) {
    s << " and ";

    if (streamline_loaded) {
      s << std::filesystem::path(renodx::utils::dlss_hook::streamline_interposer_file_path).filename().string();
    }

    if (streamline_loaded && dlss_loaded) {
      s << ", ";
    }

    if (dlss_loaded) {
      s << std::filesystem::path(renodx::utils::dlss_hook::nvngx_dlss_file_path).filename().string();
    }

    s << " is already loaded. Add " << module_file << " to ADDON.LoadFromDllMain for reliable early hooks.";
  } else {
    s << ". Early DLSS hooks are not guaranteed for this session.";
  }

  reshade::log::message(reshade::log::level::warning, s.str().c_str());
}

void AttachAddon(HMODULE h_module) {
  if (initialized) return;

  ConfigureDlssHook();
  DetectLoadMode(h_module);
  SetupPinnedModule();

  renodx::utils::dlss_hook::Use(DLL_PROCESS_ATTACH);
  renodx::utils::settings::Use(DLL_PROCESS_ATTACH, &settings);
  renodx::utils::resource::Use(DLL_PROCESS_ATTACH);
  initialized = true;
}

void DetachAddon() {
  if (!initialized) return;

  renodx::utils::settings::Use(DLL_PROCESS_DETACH, &settings);
  renodx::utils::resource::Use(DLL_PROCESS_DETACH);
  renodx::utils::dlss_hook::Use(DLL_PROCESS_DETACH);
  initialized = false;
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "DLSS Fix";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX DLSS Fix";
extern "C" __declspec(dllexport) bool AddonInit(HMODULE addon_module, HMODULE) {
  AttachAddon(addon_module);
  return true;
}

extern "C" __declspec(dllexport) void AddonUninit(HMODULE, HMODULE) {
  // Keep the add-on resident across ReShade unload cycles.
  // Actual teardown only matters on process termination.
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      AttachAddon(h_module);
      break;
    case DLL_PROCESS_DETACH:
      if (lpv_reserved != nullptr) {
        DetachAddon();
        reshade::unregister_addon(h_module);
      }
      break;
  }

  return TRUE;
}
