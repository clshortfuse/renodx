/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstdint>

#include <deps/imgui/imgui.h>

// Awesome Mix overlay colors shared by the custom settings in addon.cpp.
namespace guardians_ui {

// Accent used for every setting tint and active status markers.
constexpr ImU32 NEBULA_GLOW = IM_COL32(150, 96, 228, 255);
constexpr ImU32 OFF_WHITE = IM_COL32(244, 238, 255, 255);

// 0xRRGGBB value for Setting::tint, which recolors sliders, buttons and section headers to the accent hue.
constexpr uint32_t TINT_VIOLET = 0x9660E4;

inline ImU32 WithAlpha(ImU32 color, float alpha) {
  const float scaled = static_cast<float>((color >> IM_COL32_A_SHIFT) & 0xFF) * std::clamp(alpha, 0.f, 1.f);
  return (color & ~IM_COL32_A_MASK) | (static_cast<ImU32>(scaled) << IM_COL32_A_SHIFT);
}

}  // namespace guardians_ui
