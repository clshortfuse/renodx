/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstdint>

#include <deps/imgui/imgui.h>

// Panel colors for the Shadow and Sonic Generations settings in addon.cpp.
namespace sonic_ui {

struct Palette {
  // Accent used for status markers and the active state.
  ImU32 glow;
  ImU32 off_white;
  // 0xRRGGBB value for Setting::tint, which recolors sliders, buttons and section headers.
  uint32_t tint;
};

constexpr Palette SHADOW = {IM_COL32(224, 16, 26, 255), IM_COL32(255, 240, 238, 255), 0xE0101A};
constexpr Palette SONIC = {IM_COL32(30, 91, 255, 255), IM_COL32(238, 244, 255, 255), 0x1E5BFF};

inline ImU32 WithAlpha(ImU32 color, float alpha) {
  const float scaled = static_cast<float>((color >> IM_COL32_A_SHIFT) & 0xFF) * std::clamp(alpha, 0.f, 1.f);
  return (color & ~IM_COL32_A_MASK) | (static_cast<ImU32>(scaled) << IM_COL32_A_SHIFT);
}

}  // namespace sonic_ui
