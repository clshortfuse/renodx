#ifndef SRC_GAMES_CODCOLDWAR_COLDWAR_HDR_COMMON_HLSL_
#define SRC_GAMES_CODCOLDWAR_COLDWAR_HDR_COMMON_HLSL_

#include "./shared.h"

// This file intentionally does not include the full RenoDX HLSL library.
// The addon still uses RenoDX for settings, custom shader replacement and
// constant injection, while the injected values are consumed directly here.
// This makes SM6.1 live compilation much simpler and makes every control testable.

static const float COLDWAR_REFERENCE_WHITE_NITS = 203.0f;
static const float COLDWAR_PQ_M1 = 0.1593017578125f;
static const float COLDWAR_PQ_M2 = 78.84375f;
static const float COLDWAR_PQ_C1 = 0.8359375f;
static const float COLDWAR_PQ_C2 = 18.8515625f;
static const float COLDWAR_PQ_C3 = 18.6875f;

float3 ColdWarPQEncodeNormalized(float3 linear_10000_nits) {
  float3 color = max(linear_10000_nits, 0.0f);
  float3 p = pow(color, COLDWAR_PQ_M1);
  float3 numerator = COLDWAR_PQ_C1 + COLDWAR_PQ_C2 * p;
  float3 denominator = 1.0f + COLDWAR_PQ_C3 * p;
  return pow(numerator / max(denominator, 1e-8f), COLDWAR_PQ_M2);
}

float3 ColdWarPQDecodeNormalized(float3 pq) {
  float3 color = max(pq, 0.0f);
  float3 p = pow(color, 1.0f / COLDWAR_PQ_M2);
  float3 numerator = max(p - COLDWAR_PQ_C1, 0.0f);
  float3 denominator = max(COLDWAR_PQ_C2 - COLDWAR_PQ_C3 * p, 1e-8f);
  return pow(numerator / denominator, 1.0f / COLDWAR_PQ_M1);
}

float3 ColdWarPQEncodeNits(float3 nits) {
  return ColdWarPQEncodeNormalized(max(nits, 0.0f) / 10000.0f);
}

float3 ColdWarPQDecodeNits(float3 pq) {
  return ColdWarPQDecodeNormalized(pq) * 10000.0f;
}

float3 ColdWarBT709ToBT2020(float3 color) {
  return float3(
      dot(color, float3(0.627404034f, 0.329283029f, 0.043313090f)),
      dot(color, float3(0.069097340f, 0.919540405f, 0.011362314f)),
      dot(color, float3(0.016391449f, 0.088013276f, 0.895595312f)));
}

float3 ColdWarBT2020ToBT709(float3 color) {
  return float3(
      dot(color, float3( 1.660491002f, -0.587641139f, -0.072849863f)),
      dot(color, float3(-0.124550475f,  1.132899897f, -0.008349422f)),
      dot(color, float3(-0.018150763f, -0.100578898f,  1.118729661f)));
}

float3 ColdWarBT709ToAP1(float3 color) {
  return float3(
      dot(color, float3(0.613132422f, 0.339538016f, 0.047416696f)),
      dot(color, float3(0.070124381f, 0.916394011f, 0.013451524f)),
      dot(color, float3(0.020587658f, 0.109574572f, 0.869785404f)));
}

float3 ColdWarAP1ToBT709(float3 color) {
  return float3(
      dot(color, float3( 1.704858676f, -0.621716022f, -0.083299372f)),
      dot(color, float3(-0.130076824f,  1.140735775f, -0.010559802f)),
      dot(color, float3(-0.023964073f, -0.128975508f,  1.153014019f)));
}

float3 ColdWarSRGBToLinear(float3 encoded) {
  encoded = max(encoded, 0.0f);
  float3 low = encoded / 12.92f;
  float3 high = pow((encoded + 0.055f) / 1.055f, 2.4f);
  return float3(
      encoded.r <= 0.04045f ? low.r : high.r,
      encoded.g <= 0.04045f ? low.g : high.g,
      encoded.b <= 0.04045f ? low.b : high.b);
}

float ColdWarLuminance(float3 color) {
  int processor = (int)(RENODX_TONE_MAP_HUE_PROCESSOR + 0.5f);
  if (processor == 1) return dot(color, float3(0.2627f, 0.6780f, 0.0593f));
  if (processor == 2) return dot(color, float3(0.25f, 0.70f, 0.05f));
  return dot(color, float3(0.2126f, 0.7152f, 0.0722f));
}

float3 ColdWarToWorking(float3 bt2020) {
  int space = (int)(RENODX_TONE_MAP_WORKING_COLOR_SPACE + 0.5f);
  if (space == 0) return ColdWarBT2020ToBT709(bt2020);
  if (space == 2) return ColdWarBT709ToAP1(ColdWarBT2020ToBT709(bt2020));
  return bt2020;
}

float3 ColdWarFromWorking(float3 working) {
  int space = (int)(RENODX_TONE_MAP_WORKING_COLOR_SPACE + 0.5f);
  if (space == 0) return ColdWarBT709ToBT2020(working);
  if (space == 2) return ColdWarBT709ToBT2020(ColdWarAP1ToBT709(working));
  return working;
}

float3 ColdWarRotateHue(float3 color, float amount) {
  // YIQ rotation. Slider midpoint (0.5) is neutral.
  float angle = (amount - 0.5f) * 0.70f;
  float c = cos(angle);
  float s = sin(angle);
  float y = dot(color, float3(0.299f, 0.587f, 0.114f));
  float i = dot(color, float3(0.596f, -0.275f, -0.321f));
  float q = dot(color, float3(0.212f, -0.523f, 0.311f));
  float i2 = i * c - q * s;
  float q2 = i * s + q * c;
  return float3(
      y + 0.956f * i2 + 0.621f * q2,
      y - 0.272f * i2 - 0.647f * q2,
      y - 1.106f * i2 + 1.703f * q2);
}

float3 ColdWarApplyGamma(float3 color) {
  int mode = (int)(RENODX_GAMMA_CORRECTION + 0.5f);
  if (mode == 1) return pow(max(color, 0.0f), 1.10f);
  if (mode == 2) return pow(max(color, 0.0f), 1.20f);
  return color;
}

float3 ColdWarGrade(float3 color) {
  float3 original = max(color, 0.0f);
  float3 graded = original * max(RENODX_TONE_MAP_EXPOSURE, 0.0f);

  float luma = max(ColdWarLuminance(graded), 1e-6f);
  float shadow_weight = saturate(1.0f - luma);
  float highlight_weight = saturate((luma - 0.18f) / max(luma + 0.82f, 1e-6f));

  float shadow_scale = lerp(1.0f, RENODX_TONE_MAP_SHADOWS, shadow_weight);
  float highlight_scale = lerp(1.0f, RENODX_TONE_MAP_HIGHLIGHTS, highlight_weight);
  graded *= shadow_scale * highlight_scale;

  // Contrast is centered on scene-relative 18% gray.
  graded = max((graded - 0.18f) * RENODX_TONE_MAP_CONTRAST + 0.18f, 0.0f);

  luma = max(ColdWarLuminance(graded), 0.0f);
  graded = lerp(luma.xxx, graded, RENODX_TONE_MAP_SATURATION);

  float hs = saturate((luma - 1.0f) / max(luma + 1.0f, 1e-6f));
  float highlight_sat = lerp(1.0f, RENODX_TONE_MAP_HIGHLIGHT_SATURATION, hs);
  luma = max(ColdWarLuminance(graded), 0.0f);
  graded = lerp(luma.xxx, graded, highlight_sat);

  // Blowout progressively removes chroma in very bright highlights.
  float blowout = saturate(RENODX_TONE_MAP_BLOWOUT) * hs;
  luma = max(ColdWarLuminance(graded), 0.0f);
  graded = lerp(graded, luma.xxx, blowout);

  // Flare is a controlled veiling-light compensation.
  graded += RENODX_TONE_MAP_FLARE * 0.02f * (1.0f - exp(-max(luma, 0.0f)));

  graded = max(ColdWarRotateHue(graded, RENODX_TONE_MAP_HUE_SHIFT), 0.0f);
  graded = ColdWarApplyGamma(graded);

  // Hue correction restores the original RGB ratios at the new luminance.
  float original_luma = max(ColdWarLuminance(original), 1e-6f);
  float graded_luma = max(ColdWarLuminance(graded), 0.0f);
  float3 hue_preserved = original * (graded_luma / original_luma);
  graded = lerp(graded, hue_preserved, saturate(RENODX_TONE_MAP_HUE_CORRECTION));

  return lerp(original, max(graded, 0.0f), saturate(RENODX_COLOR_GRADE_STRENGTH));
}

float ColdWarACESScalar(float x) {
  x = max(x, 0.0f);
  return saturate((x * (2.51f * x + 0.03f)) / (x * (2.43f * x + 0.59f) + 0.14f));
}

float ColdWarRenoShoulderScalar(float x, float peak_scene) {
  x = max(x, 0.0f);
  peak_scene = max(peak_scene, 1.0001f);
  if (x <= 1.0f) return x;
  float shoulder = peak_scene - 1.0f;
  return 1.0f + shoulder * (1.0f - exp(-(x - 1.0f) / shoulder));
}

float3 ColdWarApplyToneCurve(float3 color, float peak_scene) {
  int type = (int)(RENODX_TONE_MAP_TYPE + 0.5f);
  if (type == 0 || type == 1) return color;

  bool per_channel = RENODX_TONE_MAP_PER_CHANNEL >= 0.5f;
  if (per_channel) {
    if (type == 2) {
      return float3(ColdWarACESScalar(color.r), ColdWarACESScalar(color.g), ColdWarACESScalar(color.b)) * peak_scene;
    }
    return float3(
        ColdWarRenoShoulderScalar(color.r, peak_scene),
        ColdWarRenoShoulderScalar(color.g, peak_scene),
        ColdWarRenoShoulderScalar(color.b, peak_scene));
  }

  float luma = max(ColdWarLuminance(color), 1e-6f);
  float mapped_luma = luma;
  if (type == 2) mapped_luma = ColdWarACESScalar(luma) * peak_scene;
  else mapped_luma = ColdWarRenoShoulderScalar(luma, peak_scene);
  return color * (mapped_luma / luma);
}

float3 ColdWarClampInSelectedSpace(float3 bt2020, int selected_space, float upper_limit, bool use_upper_limit) {
  if (selected_space < 0) return bt2020;

  float3 working = bt2020;
  if (selected_space == 0) working = ColdWarBT2020ToBT709(bt2020);
  else if (selected_space == 2) working = ColdWarBT709ToAP1(ColdWarBT2020ToBT709(bt2020));

  working = max(working, 0.0f);
  if (use_upper_limit) working = min(working, upper_limit);

  if (selected_space == 0) return ColdWarBT709ToBT2020(working);
  if (selected_space == 2) return ColdWarBT709ToBT2020(ColdWarAP1ToBT709(working));
  return working;
}

float3 ColdWarToneMapBT2020(float3 linear_bt2020) {
  // Candidate convention: 1.0 == 10,000 nits. Convert to scene-relative units
  // where 1.0 == Game Brightness so Reno-style controls behave predictably.
  linear_bt2020 = max(linear_bt2020, 0.0f);
  float diffuse_nits = max(RENODX_DIFFUSE_WHITE_NITS, 1.0f);
  float peak_nits = max(RENODX_PEAK_WHITE_NITS, diffuse_nits);
  float peak_scene = max(peak_nits / diffuse_nits, 1.0f);

  float3 scene_bt2020 = linear_bt2020 * (10000.0f / diffuse_nits);
  float3 working = max(ColdWarToWorking(scene_bt2020), 0.0f);
  working = ColdWarGrade(working);
  working = ColdWarApplyToneCurve(working, peak_scene);
  float3 result_bt2020 = ColdWarFromWorking(working);

  int gamut_clamp = (int)round(RENODX_TONE_MAP_CLAMP_COLOR_SPACE);
  result_bt2020 = ColdWarClampInSelectedSpace(result_bt2020, gamut_clamp, peak_scene, false);

  int peak_clamp = (int)round(RENODX_TONE_MAP_CLAMP_PEAK);
  if (peak_clamp >= 0) {
    result_bt2020 = ColdWarClampInSelectedSpace(result_bt2020, peak_clamp, peak_scene, true);
  }

  // Always respect the actual display peak in native-HDR output units.
  float3 output = max(result_bt2020, 0.0f) * (diffuse_nits / 10000.0f);
  float peak_normalized = peak_nits / 10000.0f;
  return min(output, peak_normalized);
}

float ColdWarUIBrightnessScale() {
  return max(RENODX_GRAPHICS_WHITE_NITS, 1.0f) / COLDWAR_REFERENCE_WHITE_NITS;
}

float3 ColdWarApplyOutputPeak(float3 linear_10000_nits) {
  float peak = max(RENODX_PEAK_WHITE_NITS, 1.0f) / 10000.0f;
  return min(max(linear_10000_nits, 0.0f), peak);
}

#endif
