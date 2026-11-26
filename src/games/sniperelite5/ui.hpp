/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstdint>

#include <deps/imgui/imgui.h>

// Sniper Elite 5 brass and bone palette, sampled from the key art.
namespace sniperelite5_ui {

// Accent used for every setting tint and status markers.
constexpr ImU32 BRASS = IM_COL32(214, 170, 98, 255);
constexpr ImU32 OFF_WHITE = IM_COL32(236, 230, 205, 255);

// 0xRRGGBB value for Setting::tint, which recolors sliders, buttons and section headers to the accent hue.
constexpr uint32_t TINT_BRASS = 0xD6AA62;

inline ImU32 WithAlpha(ImU32 color, float alpha) {
  const float scaled = static_cast<float>((color >> IM_COL32_A_SHIFT) & 0xFF) * std::clamp(alpha, 0.f, 1.f);
  return (color & ~IM_COL32_A_MASK) | (static_cast<ImU32>(scaled) << IM_COL32_A_SHIFT);
}

}  // namespace sniperelite5_ui
