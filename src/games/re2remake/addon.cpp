/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <embed/0x314A98A7.h>  // Tonemap + Postfx
#include <embed/0x30D8372F.h>  // Tonemap + Postfx - Vignette off
#include <embed/0xAF0777E5.h>  // BT.2020 + PQ Encoding

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x314A98A7),  // Tonemap + Postfx
    CustomShaderEntry(0x30D8372F),  // Tonemap + Postfx - Vignette off
    CustomShaderEntry(0xAF0777E5),  // BT.2020 + PQ Encoding
};

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Resident Evil 2 Remake";

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