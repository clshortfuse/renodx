/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define IMGUI_DISABLE_INCLUDE_IMCONFIG_H
#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include <embed/0x298A6BB0.h>
#include <embed/0x5DF649A9.h>
#include <embed/0x61DBBA5C.h>
#include <embed/0x71F27445.h>
#include <embed/0x745E34E1.h>
#include <embed/0x97CA5A85.h>
#include <embed/0xA61F2FEE.h>
#include <embed/0xB489149F.h>
#include <embed/0xC783FBA1.h>
#include <embed/0xC83E64DF.h>
#include <embed/0xCBFFC2A3.h>
#include <embed/0xD2BBEBD9.h>
#include <embed/0xDE517511.h>
#include <embed/0xE57907C4.h>

#include <filesystem>
#include <fstream>
#include <random>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "../../external/reshade/deps/imgui/imgui.h"
#include "../../external/reshade/include/reshade.hpp"

#include "../common/shaderReplaceMod.hpp"
#include "./cp2077.h"

extern "C" __declspec(dllexport) const char* NAME = "RenoDX - CP2077";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for Cyberpunk2077";

static ShaderReplaceMod::CustomShaders customShaders = {
  {0x298A6BB0, {0x298A6BB0, _0x298A6BB0, sizeof(_0x298A6BB0)}},
  {0x5DF649A9, {0x5DF649A9, _0x5DF649A9, sizeof(_0x5DF649A9)}},
  {0x61DBBA5C, {0x61DBBA5C, _0x61DBBA5C, sizeof(_0x61DBBA5C)}},
  {0x71F27445, {0x71F27445, _0x71F27445, sizeof(_0x71F27445)}},
  {0x745E34E1, {0x745E34E1, _0x745E34E1, sizeof(_0x745E34E1)}},
  {0x97CA5A85, {0x97CA5A85, _0x97CA5A85, sizeof(_0x97CA5A85)}},
  {0xA61F2FEE, {0xA61F2FEE, _0xA61F2FEE, sizeof(_0xA61F2FEE)}},
  {0xB489149F, {0xB489149F, _0xB489149F, sizeof(_0xB489149F)}},
  {0xC783FBA1, {0xC783FBA1, _0xC783FBA1, sizeof(_0xC783FBA1)}},
  {0xC83E64DF, {0xC83E64DF, _0xC83E64DF, sizeof(_0xC83E64DF)}},
  {0xCBFFC2A3, {0xCBFFC2A3, _0xCBFFC2A3, sizeof(_0xCBFFC2A3)}},
  {0xD2BBEBD9, {0xD2BBEBD9, _0xD2BBEBD9, sizeof(_0xD2BBEBD9)}},
  {0xDE517511, {0xDE517511, _0xDE517511, sizeof(_0xDE517511)}},
  {0xE57907C4, {0xE57907C4, _0xE57907C4, sizeof(_0xE57907C4)}}
};

ShaderInjectData shaderInjectData;

static struct UserInjectData {
  int presetIndex = 1;
  int toneMapperType = static_cast<int>(TONE_MAPPER_TYPE__ACES);
  float toneMapperPeakNits = 550.f;
  float toneMapperPaperWhite = 203.f;
  int toneMapperColorSpace = 1;
  int toneMapperWhitePoint = 1;
  float toneMapperHighlights = 50.f;
  float toneMapperShadows = 90.f;
  float toneMapperExposure = 1.f;
  float toneMapperContrast = 60.f;
  float toneMapperDechroma = 50.f;
  int colorGradingWorkflow = 1;
  float colorGradingStrength = 100.f;
  float colorGradingScene = 100.f;
  int colorGradingScaling = 2;
  float colorGradingSaturation = 50.f;
  float colorGradingCorrection = 50.f;
  int colorGradingGamma = 1;
  float effectBloom = 50.f;
  float effectVignette = 50.f;
  float effectFilmGrain = 50.f;
  float debugValue00 = 1.f;
  float debugValue01 = 1.f;
  float debugValue02 = 1.f;
  float debugValue03 = 1.f;
} userInjectData;

static void updateShaderData() {
  shaderInjectData.toneMapperType = static_cast<float>(userInjectData.toneMapperType);
  shaderInjectData.toneMapperPeakNits = userInjectData.toneMapperPeakNits;
  shaderInjectData.toneMapperPaperWhite = userInjectData.toneMapperPaperWhite;
  shaderInjectData.toneMapperColorSpace = static_cast<float>(userInjectData.toneMapperColorSpace);
  shaderInjectData.toneMapperWhitePoint = static_cast<float>(userInjectData.toneMapperWhitePoint - 1);
  shaderInjectData.toneMapperHighlights = userInjectData.toneMapperHighlights * 0.02f;
  shaderInjectData.toneMapperShadows = userInjectData.toneMapperShadows * 0.02f;
  shaderInjectData.toneMapperExposure = userInjectData.toneMapperExposure;
  shaderInjectData.toneMapperContrast = userInjectData.toneMapperContrast * 0.02f;
  shaderInjectData.toneMapperDechroma = userInjectData.toneMapperDechroma * 0.02f;

  shaderInjectData.colorGradingWorkflow = static_cast<float>(userInjectData.colorGradingWorkflow - 1);
  shaderInjectData.colorGradingStrength = userInjectData.colorGradingStrength * 0.01f;
  shaderInjectData.colorGradingScene = userInjectData.colorGradingScene * 0.01f;
  shaderInjectData.colorGradingScaling = static_cast<float>(userInjectData.colorGradingScaling);
  shaderInjectData.colorGradingSaturation = userInjectData.colorGradingSaturation * 0.02f;
  shaderInjectData.colorGradingCorrection = userInjectData.colorGradingCorrection * 0.01f;
  shaderInjectData.colorGradingGamma = static_cast<float>(userInjectData.colorGradingGamma);

  shaderInjectData.effectBloom = userInjectData.effectBloom * 0.02f;
  shaderInjectData.effectVignette = userInjectData.effectVignette * 0.02f;
  shaderInjectData.effectFilmGrain = userInjectData.effectFilmGrain * 0.02f;
  shaderInjectData.debugValue00 = userInjectData.debugValue00;
  shaderInjectData.debugValue01 = userInjectData.debugValue01;
  shaderInjectData.debugValue02 = userInjectData.debugValue02;
  shaderInjectData.debugValue03 = userInjectData.debugValue03;
}

static const char* presetStrings[] = {
  "Off",
  "Preset #1",
  "Preset #2",
  "Preset #3",
};

static const char* toneMapperTypeStrings[] = {
  "None",
  "Vanilla",
  "ACES 1.3",
  "OpenDRT"
};

static const char* toneMapperColorSpaceStrings[] = {
  "BT.709",
  "BT.2020",
  "AP1"
};

static const char* toneMapperWhitePointStrings[] = {
  "D60",
  "Vanilla",
  "D65"
};

static const char* colorGradingWorkflowStrings[] = {
  "Before Tonemapping",
  "Vanilla",
  "After Tonemapping",
};

static const char* colorGradingScalingStrings[] = {
  "None",
  "Vanilla",
  "Custom"
};

static const char* colorGradingGammaStrings[] = {
  "Vanilla",
  "Menus Only",
  "Always"
};

static void load_settings(
  reshade::api::effect_runtime* runtime = nullptr,
  const char* section = "renodx-cp2077-preset1"
) {
  UserInjectData newData = {};
  reshade::get_config_value(runtime, section, "toneMapperType", newData.toneMapperType);
  reshade::get_config_value(runtime, section, "toneMapperPeakNits", newData.toneMapperPeakNits);
  reshade::get_config_value(runtime, section, "toneMapperPaperWhite", newData.toneMapperPaperWhite);
  reshade::get_config_value(runtime, section, "toneMapperColorSpace", newData.toneMapperColorSpace);
  reshade::get_config_value(runtime, section, "toneMapperWhitePoint", newData.toneMapperWhitePoint);
  reshade::get_config_value(runtime, section, "toneMapperHighlights", newData.toneMapperHighlights);
  reshade::get_config_value(runtime, section, "toneMapperShadows", newData.toneMapperShadows);
  reshade::get_config_value(runtime, section, "toneMapperExposure", newData.toneMapperExposure);
  reshade::get_config_value(runtime, section, "toneMapperContrast", newData.toneMapperContrast);
  reshade::get_config_value(runtime, section, "toneMapperDechroma", newData.toneMapperDechroma);

  reshade::get_config_value(runtime, section, "colorGradingWorkflow", newData.colorGradingWorkflow);
  reshade::get_config_value(runtime, section, "colorGradingStrength", newData.colorGradingStrength);
  reshade::get_config_value(runtime, section, "colorGradingScene", newData.colorGradingScene);
  reshade::get_config_value(runtime, section, "colorGradingScaling", newData.colorGradingScaling);
  reshade::get_config_value(runtime, section, "colorGradingSaturation", newData.colorGradingSaturation);
  reshade::get_config_value(runtime, section, "colorGradingCorrection", newData.colorGradingCorrection);
  reshade::get_config_value(runtime, section, "colorGradingGamma", newData.colorGradingGamma);
  reshade::get_config_value(runtime, section, "effectBloom", newData.effectBloom);
  reshade::get_config_value(runtime, section, "effectVignette", newData.effectVignette);
  reshade::get_config_value(runtime, section, "effectFilmGrain", newData.effectFilmGrain);
  userInjectData.toneMapperType = newData.toneMapperType;
  userInjectData.toneMapperPeakNits = newData.toneMapperPeakNits;
  userInjectData.toneMapperPaperWhite = newData.toneMapperPaperWhite;
  userInjectData.toneMapperColorSpace = newData.toneMapperColorSpace;
  userInjectData.toneMapperWhitePoint = newData.toneMapperWhitePoint;
  userInjectData.toneMapperHighlights = newData.toneMapperHighlights;
  userInjectData.toneMapperShadows = newData.toneMapperShadows;
  userInjectData.toneMapperExposure = newData.toneMapperExposure;
  userInjectData.toneMapperContrast = newData.toneMapperContrast;
  userInjectData.toneMapperDechroma = newData.toneMapperDechroma;

  userInjectData.colorGradingWorkflow = newData.colorGradingWorkflow;
  userInjectData.colorGradingStrength = newData.colorGradingStrength;
  userInjectData.colorGradingScene = newData.colorGradingScene;
  userInjectData.colorGradingScaling = newData.colorGradingScaling;
  userInjectData.colorGradingSaturation = newData.colorGradingSaturation;
  userInjectData.colorGradingCorrection = newData.colorGradingCorrection;
  userInjectData.colorGradingGamma = newData.colorGradingGamma;

  userInjectData.effectBloom = newData.effectBloom;
  userInjectData.effectVignette = newData.effectVignette;
  userInjectData.effectFilmGrain = newData.effectFilmGrain;
}

static void save_settings(reshade::api::effect_runtime* runtime, char* section = "renodx-cp2077-preset1") {
  reshade::set_config_value(runtime, section, "toneMapperType", userInjectData.toneMapperType);
  reshade::set_config_value(runtime, section, "toneMapperPeakNits", userInjectData.toneMapperPeakNits);
  reshade::set_config_value(runtime, section, "toneMapperPaperWhite", userInjectData.toneMapperPaperWhite);
  reshade::set_config_value(runtime, section, "toneMapperColorSpace", userInjectData.toneMapperColorSpace);
  reshade::set_config_value(runtime, section, "toneMapperWhitePoint", userInjectData.toneMapperWhitePoint);
  reshade::set_config_value(runtime, section, "toneMapperHighlights", userInjectData.toneMapperHighlights);
  reshade::set_config_value(runtime, section, "toneMapperShadows", userInjectData.toneMapperShadows);
  reshade::set_config_value(runtime, section, "toneMapperExposure", userInjectData.toneMapperExposure);
  reshade::set_config_value(runtime, section, "toneMapperContrast", userInjectData.toneMapperContrast);
  reshade::set_config_value(runtime, section, "toneMapperDechroma", userInjectData.toneMapperDechroma);

  reshade::set_config_value(runtime, section, "colorGradingWorkflow", userInjectData.colorGradingWorkflow);
  reshade::set_config_value(runtime, section, "colorGradingStrength", userInjectData.colorGradingStrength);
  reshade::set_config_value(runtime, section, "colorGradingScene", userInjectData.colorGradingScene);
  reshade::set_config_value(runtime, section, "colorGradingScaling", userInjectData.colorGradingScaling);
  reshade::set_config_value(runtime, section, "colorGradingSaturation", userInjectData.colorGradingSaturation);
  reshade::set_config_value(runtime, section, "colorGradingCorrection", userInjectData.colorGradingCorrection);
  reshade::set_config_value(runtime, section, "colorGradingGamma", userInjectData.colorGradingGamma);
  reshade::set_config_value(runtime, section, "effectBloom", userInjectData.effectBloom);
  reshade::set_config_value(runtime, section, "effectVignette", userInjectData.effectVignette);
  reshade::set_config_value(runtime, section, "effectFilmGrain", userInjectData.effectFilmGrain);
}

// @see https://pthom.github.io/imgui_manual_online/manual/imgui_manual.html
static void on_register_overlay(reshade::api::effect_runtime* runtime) {
  bool updateShaders = false;
  bool updateShadersOrPreset = false;

  bool changedPreset = ImGui::SliderInt(
    "Preset",
    &userInjectData.presetIndex,
    0,
    (sizeof(presetStrings) / sizeof(char*)) - 1,
    presetStrings[userInjectData.presetIndex],
    ImGuiSliderFlags_NoInput
  );
  if (changedPreset) {
    switch (userInjectData.presetIndex) {
      case 0:
        userInjectData.toneMapperType = 1;
        userInjectData.toneMapperPeakNits = 1000.f;
        userInjectData.toneMapperPaperWhite = 203.f;
        userInjectData.toneMapperColorSpace = 1;
        userInjectData.toneMapperWhitePoint = 1;
        userInjectData.toneMapperExposure = 1.f;
        userInjectData.toneMapperContrast = 50.f;
        userInjectData.toneMapperHighlights = 50.f;
        userInjectData.toneMapperShadows = 50.f;
        userInjectData.toneMapperDechroma = 50.f;
        userInjectData.colorGradingWorkflow = 1;
        userInjectData.colorGradingStrength = 100.f;
        userInjectData.colorGradingScene = 100.f;
        userInjectData.colorGradingScaling = 1;
        userInjectData.colorGradingSaturation = 50.f;
        userInjectData.colorGradingCorrection = 50.f;
        userInjectData.colorGradingGamma = 0;
        userInjectData.effectBloom = 50.f;
        userInjectData.effectVignette = 50.f;
        userInjectData.effectFilmGrain = 0.f;
        break;
      case 1:
        load_settings(runtime);
        break;
      case 2:
        load_settings(runtime, "renodx-cp2077-preset2");
        break;
      case 3:
        load_settings(runtime, "renodx-cp2077-preset3");
        break;
    }
    updateShaders = true;
  }

  ImGui::BeginDisabled(userInjectData.presetIndex == 0);
  ImGui::SeparatorText("HDR Tone Mapping");
  {
    updateShadersOrPreset |= ImGui::SliderInt(
      "Tone Mapper",
      &userInjectData.toneMapperType,
      0,
      (sizeof(toneMapperTypeStrings) / sizeof(char*)) - 1,
      toneMapperTypeStrings[userInjectData.toneMapperType],
      ImGuiSliderFlags_NoInput
    );

    if (ImGui::BeginChild("Customize", ImVec2(-FLT_MIN, ImGui::GetTextLineHeightWithSpacing() * 8), ImGuiChildFlags_Border | ImGuiChildFlags_ResizeY)) {
      if (userInjectData.toneMapperType >= 2) {
        updateShadersOrPreset |= ImGui::SliderFloat(
          "Peak Nits",
          &userInjectData.toneMapperPeakNits,
          48.f,
          4000.f,
          "%.0f"
        );
      }

      if (userInjectData.toneMapperType >= 2) {
        updateShadersOrPreset |= ImGui::SliderFloat(
          "Paper White",
          &userInjectData.toneMapperPaperWhite,
          48.f,
          500.f,
          "%.0f"
        );
        ImGui::SetItemTooltip("Adjusts the brightness of 100%% white.");
      }

      if (userInjectData.toneMapperType >= 2) {
        updateShadersOrPreset |= ImGui::SliderInt(
          "Color Space",
          &userInjectData.toneMapperColorSpace,
          0,
          (sizeof(toneMapperColorSpaceStrings) / sizeof(char*)) - 1,
          toneMapperColorSpaceStrings[userInjectData.toneMapperColorSpace],
          ImGuiSliderFlags_NoInput
        );
        ImGui::SetItemTooltip("Configures workspace color space used by tone mapping.");
      }

      if (userInjectData.toneMapperType != 0) {
        updateShadersOrPreset |= ImGui::SliderInt(
          "White Point",
          &userInjectData.toneMapperWhitePoint,
          0,
          (sizeof(toneMapperWhitePointStrings) / sizeof(char*)) - 1,
          toneMapperWhitePointStrings[userInjectData.toneMapperWhitePoint],
          ImGuiSliderFlags_NoInput
        );
      }

      if (userInjectData.toneMapperType >= 2) {
        updateShadersOrPreset |= ImGui::SliderFloat(
          "Highlights",
          &userInjectData.toneMapperHighlights,
          0.f,
          100.f,
          "%.0f"
        );

        updateShadersOrPreset |= ImGui::SliderFloat(
          "Shadows",
          &userInjectData.toneMapperShadows,
          0.f,
          100.f,
          "%.0f"
        );
        ImGui::SetItemTooltip("Adjusts brightness of shadows.");

        updateShadersOrPreset |= ImGui::SliderFloat(
          "Exposure",
          &userInjectData.toneMapperExposure,
          0.f,
          10.f,
          "%.2f"
        );
        ImGui::SetItemTooltip("Input scaling factor before passing to tone mapper.");
      }

      if (userInjectData.toneMapperType == 2 || userInjectData.toneMapperType == 3) {
        updateShadersOrPreset |= ImGui::SliderFloat("Contrast", &userInjectData.toneMapperContrast, 0.f, 100.f, "%.0f");
        ImGui::SetItemTooltip("Adjusts contrast during tone mapping.");
      }

      if (userInjectData.toneMapperType == 3) {
        updateShadersOrPreset |= ImGui::SliderFloat("Dechroma", &userInjectData.toneMapperDechroma, 0.f, 100.f, "%.0f");
        ImGui::SetItemTooltip("Adjusts tone mapper's dechroma strength.");
      }
    }
    ImGui::EndChild();
  }

  ImGui::SeparatorText("Color Grading");
  {
    updateShadersOrPreset |= ImGui::SliderInt(
      "Workflow",
      &userInjectData.colorGradingWorkflow,
      0,
      (sizeof(colorGradingWorkflowStrings) / sizeof(char*)) - 1,
      colorGradingWorkflowStrings[userInjectData.colorGradingWorkflow],
      ImGuiSliderFlags_NoInput
    );
    ImGui::SetItemTooltip("Modifies order of when color grading is applied.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Scene Adjustments",
      &userInjectData.colorGradingScene,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Modifies the strength of the per scene adjustments.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "LUT Strength",
      &userInjectData.colorGradingStrength,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Modifies the strength of the LUT application.");

    updateShadersOrPreset |= ImGui::SliderInt(
      "LUT Scaling",
      &userInjectData.colorGradingScaling,
      0,
      (sizeof(colorGradingScalingStrings) / sizeof(char*)) - 1,
      colorGradingScalingStrings[userInjectData.colorGradingScaling]
    );
    ImGui::SetItemTooltip("Enables the game's original LUT scaling.\n\n(Requires Rendering/LUT/Size to be 48 in the env)");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Correction",
      &userInjectData.colorGradingCorrection,
      0,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Sets the strength of the correction applied to clamped color grading LUTs.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Saturation",
      &userInjectData.colorGradingSaturation,
      0,
      100.f,
      "%.0f"
    );

    updateShadersOrPreset |= ImGui::SliderInt(
      "2.2 Gamma",
      &userInjectData.colorGradingGamma,
      0,
      (sizeof(colorGradingGammaStrings) / sizeof(char*)) - 1,
      colorGradingGammaStrings[userInjectData.colorGradingGamma]
    );
    ImGui::SetItemTooltip("Rescales sRGB's piecewise EOTF to 2.2 gamma");
  }

  ImGui::SeparatorText("Effects");
  {
    updateShadersOrPreset |= ImGui::SliderFloat(
      "Bloom",
      &userInjectData.effectBloom,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Controls the strength of the bloom effect.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Vignette",
      &userInjectData.effectVignette,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Controls the strength of the vignette effect.");

    updateShadersOrPreset |= ImGui::SliderFloat(
      "Film Grain",
      &userInjectData.effectFilmGrain,
      0.f,
      100.f,
      "%.0f"
    );
    ImGui::SetItemTooltip("Controls the strength of the custom perceptual film grain.");
  }

  ImGui::EndDisabled();

#ifdef DEBUG_SLIDERS
  ImGui::SeparatorText("Debug Tools");
  {
    updateShaders |= ImGui::SliderFloat(
      "Debug Value 00",
      &userInjectData.debugValue00,
      0.f,
      2.f,
      "%.2f"
    );

    updateShaders |= ImGui::SliderFloat(
      "Debug Value 01",
      &userInjectData.debugValue01,
      0.f,
      2.f,
      "%.2f"
    );
    updateShaders |= ImGui::SliderFloat(
      "Debug Value 02",
      &userInjectData.debugValue02,
      0.f,
      2.f,
      "%.2f"
    );
    updateShaders |= ImGui::SliderFloat(
      "Debug Value 03",
      &userInjectData.debugValue03,
      0.f,
      2.f,
      "%.2f"
    );
  }
#endif

  if (updateShaders || updateShadersOrPreset) {
    updateShaderData();
  }
  if (!changedPreset && updateShadersOrPreset) {
    switch (userInjectData.presetIndex) {
      case 1:
        save_settings(runtime, "renodx-cp2077-preset1");
        break;
      case 2:
        save_settings(runtime, "renodx-cp2077-preset2");
        break;
      case 3:
        save_settings(runtime, "renodx-cp2077-preset3");
        break;
    }
  }
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD fdwReason, LPVOID) {
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(hModule)) return FALSE;

      load_settings();
      updateShaderData();

      reshade::register_overlay("RenoDX", on_register_overlay);
      break;
    case DLL_PROCESS_DETACH:

      reshade::unregister_overlay("RenoDX", on_register_overlay);

      reshade::unregister_addon(hModule);
      break;
  }

  ShaderReplaceMod::use(fdwReason, &customShaders, &shaderInjectData);

  return TRUE;
}
