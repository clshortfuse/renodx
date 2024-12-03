/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x2F362206.h>  // Tonemap + Postfx
#include <embed/0x16906EB5.h>  // Tonemap + Postfx - No Vignette

#include <embed/0x1405D21D.h>  // BT.2020 + PQ Encoding

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x2F362206),  // Tonemap + Postfx
    CustomShaderEntry(0x16906EB5),  // Tonemap + Postfx - No Vignette

    CustomShaderEntry(0x1405D21D),  // BT.2020 + PQ Encoding
};

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Resident Evil Village";

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