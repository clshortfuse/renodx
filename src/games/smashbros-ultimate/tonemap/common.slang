#version 450

#include "../shared.h"

precise const float EXPOSURE = 1.3703000545501708984375;
const float VANILLA_MID_GRAY = 0.18f;

// clang-format off
static struct TonemapConfig {
  float4 untonemapped_bt709;
  float4 tonemapped_bt709;
  float4 graded_bt709;
  float rScale;
} TONEMAP_CONFIG;
// clang-format on

float3 ApplyReinhardPiecewiseByLuminance(float3 color, float peak_white = 1.f, float shoulder = 0.0001f) {
  float y_in = renodx::color::y::from::BT709(color);
  float y_out = renodx::tonemap::ReinhardPiecewise(y_in, peak_white, shoulder);
  color = renodx::color::correct::Luminance(color, y_in, y_out);

  return color;
}

// Smoothly clamp x to 1.0

float ColorGradeSmoothClamp(float x) {
  const float u = 0.525;

  float q = (2.0 - u - 1.0 / u + x * (2.0 + 2.0 / u - x / u)) / 4.0;

  return (abs(1.0 - x) < u) ? q : saturate(x);
}

// Approximate SDR color grading with an HDR image

/* void ColorGradeHdr(float3 rgbHdr)
{
  // Find the maximum component

  float gMax = max3(rgbHdr.r, rgbHdr.g, rgbHdr.b);
  gMax = max(gMax, 1e-6);

  // Clamp HDR to 0-1 range, and calculate scale for re-expansion

  float gClamped = ColorGradeSmoothClamp(gMax);
  float rScale = gClamped / gMax;

  // Perform standard SDR color grading

  float3 rgbGraded = ColorGrade(rgbHdr * rScale);

  // Re-expand to HDR

  return rgbGrade / rScale;
} */

void ColorGradeHdr(float3 rgbHdr) {
  // Find the maximum component
  // float gMax = max3(rgbHdr.r, rgbHdr.g, rgbHdr.b);
  float gMax = max(max(rgbHdr.r, rgbHdr.g), rgbHdr.b);
  gMax = max(gMax, 1e-6);

  // Clamp HDR to 0-1 range, and calculate scale for re-expansion

  float gClamped = ColorGradeSmoothClamp(gMax);
  float rScale = gClamped / gMax;

  TONEMAP_CONFIG.rScale = rScale;
}

void TonemapVanilla(inout float4 vanillaColor) {
  TONEMAP_CONFIG.untonemapped_bt709 = vanillaColor;
  /* if (RENODX_TONE_MAP_TYPE) {
    // vanillaColor.rgb = ApplyReinhardPiecewiseByLuminance(vanillaColor.rgb);
    vanillaColor.rgb = renodx::color::gamma::EncodeSafe(vanillaColor.rgb);
    ColorGradeHdr(TONEMAP_CONFIG.untonemapped_bt709.rgb);
    vanillaColor.rgb *= TONEMAP_CONFIG.rScale;
    vanillaColor.rgb = renodx::color::gamma::DecodeSafe(vanillaColor.rgb);
  }
  TONEMAP_CONFIG.tonemapped_bt709 = vanillaColor; */
}

void ApplyTonemap(inout float4 vanillaColor, float4 untonemapped, sampler3D lutTexture, float lerpFactor) {
  TONEMAP_CONFIG.graded_bt709 = vanillaColor;
  if (RENODX_TONE_MAP_TYPE) {
    untonemapped.rgb = renodx::color::gamma::EncodeSafe(untonemapped.rgb);
    untonemapped.rgb *= EXPOSURE;
    untonemapped.rgb = renodx::color::gamma::DecodeSafe(untonemapped.rgb);

    vanillaColor.rgb = renodx::draw::ToneMapPass(TONEMAP_CONFIG.untonemapped_bt709.rgb, saturate(vanillaColor.rgb));

    vanillaColor.rgb = renodx::color::correct::GamutCompress(vanillaColor.rgb);
  } else {
    vanillaColor.rgb = saturate(vanillaColor.rgb);
  }
  vanillaColor.rgb = renodx::draw::RenderIntermediatePass(vanillaColor.rgb);
  vanillaColor.a = clamp(vanillaColor.a, 0, 1);
}
