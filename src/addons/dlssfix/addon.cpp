/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#ifndef NDEBUG
#define DEBUG_LEVEL_1
#endif

#include <format>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../utils/dlss_hook.hpp"
#include "../../utils/settings.hpp"

namespace {

renodx::utils::settings::Settings settings = {};

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "DLSS Fix";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX DLSS Fix";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      // {
      //   uint32_t load_from_dll_main = 0;
      //   reshade::get_config_value(nullptr, "ADDON", "LoadFromDllMain", load_from_dll_main);
      //   if (load_from_dll_main == 0) {
      //     load_from_dll_main = 1;
      //     reshade::set_config_value(nullptr, "ADDON", "LoadFromDllMain", load_from_dll_main);
      //     reshade::log::message(reshade::log::level::warning,
      //                           "LoadFromDllMain not found in config, changing to 1 (true).");
      //   } else {
      //     reshade::log::message(
      //         reshade::log::level::debug,
      //         std::format("LoadFromDllMain found in config, value: {}", load_from_dll_main).c_str());
      //   }
      // }

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

      renodx::utils::dlss_hook::Use(fdw_reason);

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::utils::resource::Use(fdw_reason);

  return TRUE;
}
