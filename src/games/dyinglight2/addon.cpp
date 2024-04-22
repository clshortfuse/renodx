/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x3E36DA5B.h>
#include <embed/0x80C96448.h>
#include <embed/0xA7F77A42.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"
#include "./shared.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - Dying Light 2";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Dying Light 2";

ShaderReplaceMod::CustomShaders customShaders = {
  CustomShaderEntry(0xA7F77A42),
  CustomShaderEntry(0x80C96448),
  CustomShaderEntry(0x3E36DA5B)
};

ShaderInjectData shaderInjection;

// clang-format off
UserSettingUtil::UserSettings userSettings = {
  new UserSettingUtil::UserSetting {
    .key = "toneMapType",
    .binding = &shaderInjection.toneMapType,
    .valueType = UserSettingUtil::UserSettingValueType::integer,
    .defaultValue = 2.f,
    .canReset = false,
    .label = "Tone Mapper",
    .section = "Tone Mapping",
    .tooltip = "Sets the tone mapper type",
    .labels = {"Vanilla", "None", "ACES", "RenoDX" }
  },
  new UserSettingUtil::UserSetting {
    .key = "toneMapPeakNits",
    .binding = &shaderInjection.toneMapPeakNits,
    .defaultValue = 1000.f,
    .canReset = false,
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
      ShaderReplaceMod::expectedConstantBufferIndex = 6;
      UserSettingUtil::useRenoDXHelper = true;
      // SwapChainUpgradeMod::upgradeOnPresent = true;


      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 0}
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 1}
      // );
      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 4}
      // );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 0}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 1}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 2}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 3}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 4}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 5}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 6}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 7}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 8}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 9}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 10}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 11}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 12}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 13}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 14}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 15}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 16}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 17}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 18}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 19}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 20}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 21}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 22}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 23}
      );
      SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 24}
      );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r10g10b10a2_typeless, reshade::api::format::r16g16b16a16_typeless}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_unorm_srgb, reshade::api::format::r16g16b16a16_float}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 2}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 3}  // UI Only
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 4}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 5}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 6}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 7}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 8}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 9}
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 10}  // async compute
      // );

      // SwapChainUpgradeMod::swapChainUpgradeTargets.push_back(
      //   {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_typeless, 11}
      // );

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
