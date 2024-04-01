/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x4D868A70.h>
#include <embed/0x8DAE8683.h>
#include <embed/0x93269875.h>
#include <embed/0x9F3842A8.h>
#include <embed/0xC3126A03.h>
#include <embed/0xC6FA129B.h>
#include <embed/0xE3729F07.h>
#include <embed/0xF6E7E494.h>
#include <embed/0xBEB7EB31.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../common/shaderReplaceMod.hpp"
#include "../common/swapChainUpgradeMod.hpp"
#include "../common/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Hi-Fi Rush";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Hi-Fi Rush";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0xC3126A03),
  CustomShaderEntry(0xF6E7E494),
  CustomShaderEntry(0xC6FA129B),
  CustomShaderEntry(0x9F3842A8),
  CustomShaderEntry(0x93269875),
  CustomShaderEntry(0xE3729F07),
  CustomShaderEntry(0x8DAE8683),
  CustomShaderEntry(0x4D868A70),
  CustomShaderEntry(0xBEB7EB31)
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
    .labels = {"Vanilla", "None", "ACES", "OpenDRT" }
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
  },
  new UserSettingUtil::UserSetting {
    .key = "fxBloom",
    .binding = &shaderInjection.fxBloom,
    .defaultValue = 50.f,
    .label = "Bloom",
    .section = "Effects",
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
  UserSettingUtil::updateUserSetting("fxBloom", 50.f);
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::b8g8r8a8_typeless, reshade::api::format::r16g16b16a16_typeless}
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
