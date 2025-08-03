/*
 * Copyright (C) 2025 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"

namespace {

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 0.f,
        .label = "FPS Limit",
        .min = 0.f,
        .max = 480.f,
    },
};

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "FPS Limiter";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX FPS Limiter";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::utils::settings::use_presets = false;
      renodx::utils::settings::global_name = "FPSLimiter";

      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings);
  renodx::utils::swapchain::Use(fdw_reason);

  return TRUE;
}
