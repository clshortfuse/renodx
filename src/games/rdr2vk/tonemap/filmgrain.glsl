#ifndef SRC_GAMES_INDYGREATCIRCLE_INCLUDE_FILMGRAIN_GLSL_
#define SRC_GAMES_INDYGREATCIRCLE_INCLUDE_FILMGRAIN_GLSL_

float GetLuminanceBT2020(vec3 color) {
  return dot(color, vec3(0.2627002120, 0.6779980715, 0.0593017165));
}

// https://web.archive.org/web/20080211204527/http://lumina.sourceforge.net/Tutorials/Noise.html
float Generate(vec2 uv) {
  return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float RandomGenerate(vec2 uv) {
  return Generate(uv);
}

// Bartleson
// https://www.imaging.org/common/uploaded%20files/pdfs/Papers/2003/PICS-0-287/8583.pdf
float ComputeFilmGraininess(float density) {
  if (density <= 0.0) {
    return 0.0;  // Because luminance can be negative, pow can be unsafe
  }
  float bof_d_over_c = 0.880 - (0.736 * density) - (0.003 * pow(density, 7.6));
  return pow(10.0, bof_d_over_c);
}

vec3 ApplyFilmGrainBT2020(vec3 color_bt2020, vec2 xy, float seed, float strength, float reference_white, bool debug) {
  float random_number = Generate(xy + seed);

  // Film grain is based on film density
  // Film works in negative, meaning black has no density
  // The greater the film density (lighter), more perceived grain
  // Simplified, grain scales with Y
  // Scaling is not linear

  color_bt2020 = max(vec3(0.0), color_bt2020);
  float color_y = GetLuminanceBT2020(color_bt2020);

  float adjusted_color_y = color_y * (1.0 / reference_white);

  // Ideal film density matches 0-3. Skip emulating film stock
  // https://www.mr-alvandi.com/technique/measuring-film-speed.html
  float density = adjusted_color_y * 3.0;

  float graininess = ComputeFilmGraininess(density);
  float random_factor = (random_number * 2.0) - 1.0;
  float boost = 1.667;  // Boost max to 0.05

  float y_change = random_factor * graininess * strength * boost;
  vec3 output_color = color_bt2020 * (1.0 + y_change);

  if (debug) {
    // Output visualization
    output_color = vec3(abs(y_change));
  }

  return output_color;
}

vec3 ApplyFilmGrainBT2020(vec3 color, vec2 xy, float seed, float strength, float reference_white) {
  return ApplyFilmGrainBT2020(color, xy, seed, strength, reference_white, false);
}

vec3 ApplyFilmGrainBT2020(vec3 color, vec2 xy, float seed, float strength) {
  return ApplyFilmGrainBT2020(color, xy, seed, strength, 1.0, false);
}

#endif  // SRC_GAMES_INDYGREATCIRCLE_INCLUDE_FILMGRAIN_GLSL_
