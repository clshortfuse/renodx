/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define DEBUG_LEVEL_0

#include <embed/0x552A4A60.h>
#include <embed/0x72B31CDE.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"
#include "../common/mods.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Sea of Stars";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Sea of Stars";

shaderreplacemod::CustomShaders customShaders = {
  {0x552A4A60, {0x552A4A60, _0x552A4A60, sizeof(_0x552A4A60)}},
  {0x72B31CDE, {0x72B31CDE, _0x72B31CDE, sizeof(_0x72B31CDE)}}
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

  swapchainmod::use(fdwReason);
  shaderreplacemod::use(fdwReason, &customShaders);

  return TRUE;
}
