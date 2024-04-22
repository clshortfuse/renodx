/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x84B99833.h>
#include <embed/0xE41360A3.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../common/shaderReplaceMod.hpp"
#include "../../common/swapChainUpgradeMod.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Sea of Thieves";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Sea of Thieves";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0x84B99833),
  CustomShaderEntry(0xE41360A3)
};

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      break;
  }

  ShaderReplaceMod::use(fdwReason, &customShaders);

  return TRUE;
}
