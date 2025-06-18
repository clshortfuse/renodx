/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x30D8372F.h>  // Tonemap + Postfx - No Vignette
#include <embed/0x314A98A7.h>  // Tonemap + Postfx
#include <embed/0x52248E59.h>  // BT.2020 + PQ Encoding
#include <embed/0x664875D1.h>  // HDR Calibration Menu + BT.2020 + PQ Encoding

#include <include/reshade.hpp>
#include "../../mods/shader.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x314A98A7),  // Tonemap + Postfx
    CustomShaderEntry(0x30D8372F),  // Tonemap + Postfx - No Vignette
    CustomShaderEntry(0x52248E59),  // BT.2020 + PQ Encoding
    CustomShaderEntry(0x664875D1),  // HDR Calibration Menu + BT.2020 + PQ Encoding
};

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Resident Evil 3 Remake";

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