/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define DEBUG_LEVEL_0

#include <embed/0x2C2D0899.h>
#include <embed/0x5DAD9473.h>
#include <embed/0x311E0BDA.h>
#include <embed/0x2AC7F89E.h>
#include <embed/0x7527C8AD.h>
#include <embed/0xF3B4727D.h>
#include <embed/0x8D4B625A.h>
#include <embed/0x978BFB09.h>
#include <embed/0xB6B56605.h>
#include <embed/0xF01CCC7E.h>

#include "./shared.h"

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"
#include "../common/shaderReplaceMod.hpp"
#include "../common/swapChainUpgradeMod.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Batman: Arkham Knight";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Batman: Arkham Knight";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0x2C2D0899),
  CustomShaderEntry(0x5DAD9473),
  CustomShaderEntry(0x311E0BDA),
  CustomShaderEntry(0x2AC7F89E),
  CustomShaderEntry(0x7527C8AD),
  CustomShaderEntry(0xF3B4727D),
  CustomShaderEntry(0x8D4B625A),
  CustomShaderEntry(0x978BFB09),
  CustomShaderEntry(0xB6B56605),
  CustomShaderEntry(0xF01CCC7E)
};

ShaderInjectData shaderInjection;

struct {
  int toneMapperEnum = 2u;
  float gamePeakWhite = 1000.f;
  float gamePaperWhite = 203.f;
  float uiPaperWhite = 203.f;
} userSettings;

static void updateInjection() {
  shaderInjection.toneMapperEnum = static_cast<float>(userSettings.toneMapperEnum);
  shaderInjection.gamePeakWhite = userSettings.gamePeakWhite;
  shaderInjection.gamePaperWhite = userSettings.gamePaperWhite;
  shaderInjection.uiPaperWhite = userSettings.uiPaperWhite;
}

static void on_register_overlay(reshade::api::effect_runtime* runtime) {
  bool settingsChanged = false;

  static const char* toneMapperEnums[] = {
    "Vanilla",
    "None",
    "ACES"
  };
  settingsChanged |= ImGui::SliderInt(
    "Tone Mapper",
    &userSettings.toneMapperEnum,
    0,
    2,
    toneMapperEnums[userSettings.toneMapperEnum],
    ImGuiSliderFlags_NoInput
  );

  settingsChanged |= ImGui::SliderFloat(
    "Peak Brightness",
    &userSettings.gamePeakWhite,
    48.f,
    4000.f,
    "%.0f"
  );
  ImGui::SetItemTooltip("Adjusts the peak brightness in nits.");

  settingsChanged |= ImGui::SliderFloat(
    "Game Brightness",
    &userSettings.gamePaperWhite,
    48.f,
    500.f,
    "%.0f"
  );
  ImGui::SetItemTooltip("Adjusts the brightness of 100%% white in nits.");

  settingsChanged |= ImGui::SliderFloat(
    "UI Brightness",
    &userSettings.uiPaperWhite,
    48.f,
    500.f,
    "%.0f"
  );
  ImGui::SetItemTooltip("Adjusts the peak brightness of the UI in nits.");

  if (settingsChanged) {
    updateInjection();
  }
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;
      updateInjection();
      reshade::register_overlay("RenoDX", on_register_overlay);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_overlay("RenoDX", on_register_overlay);
      reshade::unregister_addon(hModule);
      break;
  }

  SwapChainUpgradeMod::use(fdwReason);
  ShaderReplaceMod::use(fdwReason, &customShaders, &shaderInjection);

  return TRUE;
}
