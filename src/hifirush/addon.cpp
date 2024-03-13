/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0xF6E7E494.h>

#include "./shared.h"

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"
#include "../common/shaderReplaceMod.hpp"
#include "../common/swapChainUpgradeMod.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Hi-Fi Rush";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Hi-Fi Rush";

ShaderReplaceMod::CustomShaders customShaders = {
  // CustomShaderEntry(0xC3126A03),
  CustomShaderEntry(0xF6E7E494)
  // CustomShaderEntry(0xBEB7EB31)
};

ShaderInjectData shaderInjection;

struct {
  int toneMapperEnum = 0u;
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

      SwapChainUpgradeMod::upgradeResourceViews = false;

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_overlay("RenoDX", on_register_overlay);
      reshade::unregister_addon(hModule);
      break;
  }

  SwapChainUpgradeMod::use(fdwReason);

  ShaderReplaceMod::use(fdwReason, &customShaders);

  return TRUE;
}
