/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

// #include <embed/0xA59B718D.h>  // Tonemap + Postfx

// #include <embed/0x6AB2B106.h>  // BT.2020 + PQ Encoding
// #include <embed/.h>  // HDR Calibration Menu + BT.2020 + PQ Encoding

#include <embed/shaders.h>

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xA59B718D),  // Tonemap + Postfx

    CustomShaderEntry(0x6AB2B106),  // BT.2020 + PQ Encoding
    // CustomShaderEntry(),  // HDR Calibration Menu + BT.2020 + PQ Encoding
};

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Devil May Cry 5";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}