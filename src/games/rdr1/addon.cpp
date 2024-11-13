/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <embed/0x4EAF2BC7.h>  // PostFX
#include <embed/0xEEEE53C5.h>  // PostFX - Optics

#include <embed/0xCCC43328.h>  // PostFX - Aiming
#include <embed/0xE93AD74D.h>  // PostFX - Aiming + Optics

#include <embed/0x632ABCB2.h>  // PostFX - Cutscene DoF + Optics
#include <embed/0x9761FB07.h>  // PostFX - Cutscene DoF

#include <embed/0xE033AAAD.h>  // Mini Eye Adaptation

// #include <embed/0x56F79BAD.h>  // PQ Encoding

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x4EAF2BC7),  // PostFX
    CustomShaderEntry(0xEEEE53C5),  // PostFX - Optics

    CustomShaderEntry(0xCCC43328),  // PostFX - Aiming
    CustomShaderEntry(0xE93AD74D),  // PostFX - Aiming + Optics

    CustomShaderEntry(0x9761FB07),  // PostFX - Cutscene DoF
    CustomShaderEntry(0x632ABCB2),  // PostFX - Cutscene DoF + Optics

    CustomShaderEntry(0xE033AAAD),  // Mini Eye Adaptation

    // CustomShaderEntry(0x56F79BAD),  // PQ Encoding
};

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Red Dead Redemption";

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