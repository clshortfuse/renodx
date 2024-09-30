#ifndef SRC_SHADERS_EFFECTS_HLSL_
#define SRC_SHADERS_EFFECTS_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"
#include "./random.hlsl"

namespace renodx {
namespace effects {
namespace internal {

// This is an attempt to replicate Kodak Vision 5242 with (0,3) range:
// Should be channel independent (R/G/B), but just using R curve for now
// Reference target is actually just luminance * 2.046f;
// (0, 0)
// (0.5, 0.22)
// (1.5, 1.08)
// (2.5, 2.01)
// (3.0, 2.3)
float ComputeFilmDensity(float luminance) {
  const float scaled_x = luminance * 3.0f;
  float result = 3.386477f + (0.08886645f - 3.386477f) / pow(1.f + (scaled_x / 2.172591f), 2.240936f);
  return result;
}

// Bartleson
// https://www.imaging.org/common/uploaded%20files/pdfs/Papers/2003/PICS-0-287/8583.pdf
float ComputeFilmGraininess(float density) {
  if (density <= 0) {
    return 0;  // Because Luminance can be negative, pow can be unsafe
  }
  float bof_d_over_c = 0.880f - (0.736f * density) - (0.003f * pow(density, 7.6f));
  return pow(10.f, bof_d_over_c);
}
}  // namespace internal

float3 ApplyFilmGrain(float3 color, float2 xy, float seed, float strength, float reference_white = 1.f, bool debug = false) {
  const float random_number = renodx::random::Generate(xy + seed);

  // Film grain is based on film density
  // Film works in negative, meaning black has no density
  // The greater the film density (lighter), more perceived grain
  // Simplified, grain scales with Y

  // Scaling is not not linear

  const float3 signs = renodx::math::Sign(color);
  color = abs(color);
  float color_y = renodx::color::y::from::BT709(color);

  const float adjusted_color_y = color_y * (1.f / reference_white);

  // Emulate density from a chosen film stock (Removed)
  // float density = computeFilmDensity(adjustedColorY);

  // Ideal film density matches 0-3. Skip emulating film stock
  // https://www.mr-alvandi.com/technique/measuring-film-speed.html
  const float density = adjusted_color_y * 3.f;

  const float graininess = internal::ComputeFilmGraininess(density);
  const float random_factor = (random_number * 2.f) - 1.f;
  const float boost = 1.667f;  // Boost max to 0.05

  const float y_change = random_factor * graininess * strength * boost;
  float3 output_color = signs * color * (1.f + y_change);

  if (debug) {
    // Output Visualization
    output_color = abs(y_change);
  }

  return output_color;
}
}  // namespace effects
}  // namespace renodx

#endif  // SRC_SHADERS_EFFECTS_HLSL_
