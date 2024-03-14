/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x7EC02107.h>
#include <embed/0x98F668B5.h>
#include <embed/0xC1C7045A.h>

#include "./shared.h"

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"
#include "../common/shaderReplaceMod.hpp"
#include "../common/swapChainUpgradeMod.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Lost Planet";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Lost Planet";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0x7EC02107),  // output
  CustomShaderEntry(0xC1C7045A),  // matrix
  CustomShaderEntry(0x98F668B5)   // clamper
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

      // Most in-game buffers can be RGBA16 except one
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_unorm, reshade::api::format::r16g16b16a16_float, 0}
      );
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_overlay("RenoDX", on_register_overlay);
      reshade::unregister_addon(hModule);
      break;
  }

  // Upgrade backbuffer
  SwapChainUpgradeMod::use(fdwReason);

  ShaderReplaceMod::use(fdwReason, &customShaders, &shaderInjection);

  return TRUE;
}
