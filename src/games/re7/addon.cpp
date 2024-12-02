/*
 * Copyright (C) 2024 Musa Haji
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/0xAD20915B.h>  // Tonemap + Postfx - main

#include <embed/0x52248E59.h>  // BT.2020 + PQ Encoding
#include <embed/0x664875D1.h>  // BT.2020 + PQ Encoding - Calibration Menu

#include "../../mods/shader.hpp"
#include "../../utils/settings.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xAD20915B),  // Tonemap + Postfx - main

    CustomShaderEntry(0x52248E59),  // BT.2020 + PQ Encoding
    CustomShaderEntry(0x664875D1),  // BT.2020 + PQ Encoding - Calibration Menu
};

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Resident Evil 7";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:

      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::expected_constant_buffer_space = 9;

      if (!reshade::register_addon(h_module)) return FALSE;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}