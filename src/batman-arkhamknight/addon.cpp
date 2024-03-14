/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x3A4E0B90.h>
#include <embed/0x978BFB09.h>
#include <embed/0xB6B56605.h>
#include <embed/0xF01CCC7E.h>

#include "./shared.h"

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"
#include "../common/UserSettingUtil.hpp"
#include "../common/shaderReplaceMod.hpp"
#include "../common/swapChainUpgradeMod.hpp"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Batman: Arkham Knight";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Batman: Arkham Knight";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0x978BFB09),
  CustomShaderEntry(0xB6B56605),
  CustomShaderEntry(0xF01CCC7E),
  CustomShaderEntry(0x3A4E0B90)
};

ShaderInjectData shaderInjection;

// clang-format off
UserSettingUtil::UserSettings userSettings = {
  new UserSettingUtil::UserSetting {
    .key = "toneMapType",
    .binding = &shaderInjection.toneMapType,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 2.f,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "None", "ACES", "OpenDRT"}
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapPeakNits",
    .binding = &shaderInjection.toneMapPeakNits,
    .defaultValue = 1000.f,
    .label = "Peak Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of peak white in nits",
    .min = 48.f,
    .max = 4000.f
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapGameNits",
    .binding = &shaderInjection.toneMapGameNits,
    .defaultValue = 203.f,
    .label = "Game Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the value of 100%% white in nits",
    .min = 48.f,
    .max = 500.f
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapUINits",
    .binding = &shaderInjection.toneMapUINits,
    .defaultValue = 203.f,
    .label = "UI Brightness",
    .section = "Tone Mapping",
    .tooltip = "Sets the brightness of UI and HUD elements in nits",
    .min = 48.f,
    .max = 500.f
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeHighlights",
    .binding = &shaderInjection.colorGradeHighlights,
    .defaultValue = 50.f,
    .label = "Highlights",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeShadows",
    .binding = &shaderInjection.colorGradeShadows,
    .defaultValue = 50.f,
    .label = "Shadows",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeContrast",
    .binding = &shaderInjection.colorGradeContrast,
    .defaultValue = 50.f,
    .label = "Contrast",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  },
  new UserSettingUtil::UserSetting {
    .key = "colorGradeSaturation",
    .binding = &shaderInjection.colorGradeSaturation,
    .defaultValue = 50.f,
    .label = "Saturation",
    .section = "Color Grading",
    .max = 100.f,
    .parse = [](float value) { return value * 0.02f; }
  }
};

// clang-format on

static void onPresetOff() {
  UserSettingUtil::updateUserSetting("toneMapType", 0.f);
  UserSettingUtil::updateUserSetting("toneMapPeakNits", 203.f);
  UserSettingUtil::updateUserSetting("toneMapGameNits", 203.f);
  UserSettingUtil::updateUserSetting("toneMapUINits", 203.f);
  UserSettingUtil::updateUserSetting("colorGradeHighlights", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeShadows", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeContrast", 50.f);
  UserSettingUtil::updateUserSetting("colorGradeSaturation", 50.f);
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_unorm, reshade::api::format::r16g16b16a16_float, 3}
      );

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(hModule);
      break;
  }

  UserSettingUtil::use(fdwReason, &userSettings, &onPresetOff);

  SwapChainUpgradeMod::use(fdwReason);

  ShaderReplaceMod::use(fdwReason, &customShaders, &shaderInjection);

  return TRUE;
}
