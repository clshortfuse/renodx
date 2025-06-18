/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x0A67EFF4),  // bloom
    CustomShaderEntry(0xA380E737),  // tonemap+scale
    CustomShaderEntry(0xF1FC454C),  // tonemap
    CustomShaderEntry(0xEF7E426D),  // tonemap la
    CustomShaderEntry(0xF3C7B934),  // output
};

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Zelda : Echoes of Wisdom";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      // renodx::mods::swapchain::use_resource_cloning = true;

      // renodx::mods::swapchain::SetUseHDR10(true);
      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_addon(h_module);
      break;
  }

  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}
