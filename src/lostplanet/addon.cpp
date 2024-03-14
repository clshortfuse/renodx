/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x7EC02107.h>
#include <embed/0x98F668B5.h>
#include <embed/0xB2AD4F48.h>
#include <embed/0xC1C7045A.h>

#include "./shared.h"

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"
#include "../common/UserSettingUtil.hpp"
#include "../common/shaderReplaceMod.hpp"
#include "../common/swapChainUpgradeMod.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Lost Planet";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Lost Planet";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0xB2AD4F48),  // fullscreen
  CustomShaderEntry(0x7EC02107),  // output
  CustomShaderEntry(0xC1C7045A),  // matrix
  CustomShaderEntry(0x98F668B5)   // clamper
};

ShaderInjectData shaderInjection;

// clang-format off
UserSettingUtil::UserSettings userSettings = {
  {
    "toneMapType", new UserSettingUtil::UserSetting{
      "toneMapType",
      &shaderInjection.toneMapType,
      UserSettingUtil::UserSettingValueType::integer,
      2.f,
      "Tone Mapper",
      "Tone Mapping",
      "Sets the tone mapper type",
      {"Vanilla", "None", "ACES", "OpenDRT"}
    }
  }, {
    "toneMapPeakNits",  new UserSettingUtil::UserSetting{
      "toneMapPeakNits",
      &shaderInjection.toneMapPeakNits,
      UserSettingUtil::UserSettingValueType::floating,
      1000.f,
      "Peak Brightness",
      "Tone Mapping",
      "Sets the value of peak white in nits",
      {},
      48.f, 4000.f
    }
  }, {
    "toneMapGameNits", new UserSettingUtil::UserSetting{
      "toneMapGameNits",
      &shaderInjection.toneMapGameNits,
      UserSettingUtil::UserSettingValueType::floating,
      203.f,
      "Game Brightness",
      "Tone Mapping",
      "Sets the value of 100%% white in nits",
      {},
      48.f, 500.f
    }
  }, {
    "toneMapUINits", new UserSettingUtil::UserSetting{
      "toneMapUINits",
      &shaderInjection.toneMapUINits,
      UserSettingUtil::UserSettingValueType::floating,
      203.f,
      "UI Brightness",
      "Tone Mapping",
      "Sets the brightness of UI and HUD elements in nits",
      {},
      48.f, 500.f
    }
  }, {
    "colorGradeHighlights", new UserSettingUtil::UserSetting{
      "colorGradeHighlights",
      &shaderInjection.colorGradeHighlights,
      UserSettingUtil::UserSettingValueType::floating,
      50.f,
      "Highlights",
      "Color Grading",
      "",
      {},
      0.f, 100.f,
      "%.f",
      nullptr,
      [](float value) { return value * 0.02f; }
    }
  }, {
    "colorGradeShadows", new UserSettingUtil::UserSetting{
      "colorGradeShadows",
      &shaderInjection.colorGradeShadows,
      UserSettingUtil::UserSettingValueType::floating,
      50.f,
      "Shadows",
      "Color Grading",
      "",
      {},
      0.f, 100.f,
      "%.f",
      nullptr,
      [](float value) { return value * 0.02f; }
    }
  }, {
    "colorGradeContrast", new UserSettingUtil::UserSetting{
      "colorGradeContrast",
      &shaderInjection.colorGradeContrast,
      UserSettingUtil::UserSettingValueType::floating,
      50.f,
      "Contrast",
      "Color Grading",
      "",
      {},
      0.f, 100.f,
      "%.f",
      nullptr,
      [](float value) { return value * 0.02f; }
    }
  }, {
    "colorGradeSaturation", new UserSettingUtil::UserSetting{
      "colorGradeSaturation",
      &shaderInjection.colorGradeSaturation,
      UserSettingUtil::UserSettingValueType::floating,
      50.f,
      "Saturation",
      "Color Grading",
      "",
      {},
      0.f, 100.f,
      "%.f",
      nullptr,
      [](float value) { return value * 0.02f; }
    }
  }
};

// clang-format on

static void onPresetOff() {
  userSettings.find("toneMapType")->second->set(0)->write();
  userSettings.find("toneMapPeakNits")->second->set(203)->write();
  userSettings.find("toneMapGameNits")->second->set(203)->write();
  userSettings.find("toneMapUINits")->second->set(203)->write();
  userSettings.find("colorGradeHighlights")->second->set(50)->write();
  userSettings.find("colorGradeShadows")->second->set(50)->write();
  userSettings.find("colorGradeContrast")->second->set(50)->write();
  userSettings.find("colorGradeSaturation")->second->set(50)->write();
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;
      // Most in-game buffers can be RGBA16 except one
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_unorm, reshade::api::format::r16g16b16a16_float, 0}
      // );
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      break;
  }

  // Upgrade backbuffer
  UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);

  SwapChainUpgradeMod::use(fdwReason);

  ShaderReplaceMod::use(fdwReason, &customShaders, &shaderInjection);

  return TRUE;
}
