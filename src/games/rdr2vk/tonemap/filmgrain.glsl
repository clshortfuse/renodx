/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#ifndef SRC_GAMES_RDR2_TONEMAP_FILMGRAIN_GLSL_
#define SRC_GAMES_RDR2_TONEMAP_FILMGRAIN_GLSL_

// Regular BT.709 film grain from src/shaders/effects.hlsl.
vec3 ApplyFilmGrain(vec3 color, vec2 xy, float seed, float strength, float reference_white) {
  float y = max(0.0, dot(color, vec3(0.2126390059, 0.7151686788, 0.0721923154)));
  float adjusted_color_y = y * (1.0 / reference_white);
  float density = adjusted_color_y * 3.0;
  if (density <= 0.0) return color;

  // Bartleson graininess as a function of film density.
  float bof_d_over_c = 0.880 - (0.736 * density) - (0.003 * pow(density, 7.6));
  float graininess = pow(10.0, bof_d_over_c);
  float random_number = fract(sin(dot(xy + vec2(seed), vec2(12.9898, 78.233))) * 43758.5453);
  float random_factor = (random_number * 2.0) - 1.0;
  float boost = 1.667;
  float y_change = random_factor * graininess * strength * boost;
  return color * (1.0 + y_change);
}

#endif  // SRC_GAMES_RDR2_TONEMAP_FILMGRAIN_GLSL_