#include "./shared.h"

#ifndef LUT_EXTENSION_HLSL_
#define LUT_EXTENSION_HLSL_

#ifndef LUT_EXTENSION_SAMPLE
#error "Define LUT_EXTENSION_SAMPLE(color) before including lut_extension.hlsl"
#endif

// Generic black-box LUT shoulder extension.
//
// Include contract:
//   #define LUT_EXTENSION_SAMPLE(color) YourLUTSampleFunction((color), ...) -
//   YourLUTSampleFunction can be anything, as long as it's linear in/out
//   #include "lut_extension.hlsl"
//   #undef LUT_EXTENSION_SAMPLE
//
// Runtime helpers:
//   SampleHDRLUTShoulderExtended(color)           - luminance-preserving
//   shoulder extension SampleHDRLUTShoulderExtendedPerChannel(color) -
//   independent RGB shoulder extension DrawLUTShoulderDebug(pixel, background)
//   - calibration/debug overlay

// Minimal calibration tutorial:
// 1. Wire the include into the game shader.
//    Define LUT_EXTENSION_SAMPLE(color) so it calls the game's HDR LUT sampler,
//    include this file, then call SampleHDRLUTShoulderExtended(color) where the
//    shader previously sampled the LUT directly.
//
// 2. Enable the debug overlay while calibrating. COMPILING WILL TAKE A LONG
// TIME WITH DEBUG ON
//    Set LUT_EXTENSION_DEBUG=1 and LUT_EXTENSION_DEBUG_VERBOSE=1, then draw
//    DrawLUTShoulderDebug(pixel_position, output_color).
//    LUT_EXTENSION_DEBUG_GRAPHS=1 is optional and slower, but useful when the
//    numbers are unclear.
//
// 3. Find the measured shoulder values.
//    In the overlay, the "measured" row is the normal slope-drop detector:
//      measured in    -> candidate shoulder input start
//      slope          -> extension slope to keep highlights growing after the
//      LUT shoulder out            -> LUT output at the shoulder start found ->
//      1 means the detector found a clear shoulder; 0 means it did not
//    If "found" is 0, do not blindly trust the measured row. Use the graph/bend
//    detector, or tune manually.
//
// 4. Check the bend detector.
//    The "bend" row is a second detector for very smooth shoulders:
//      bend start     -> alternate shoulder input start
//      accel          -> how quickly the curve starts bending downward; more
//      negative is a stronger signal amount         -> current downward bend
//      amount; negative means highlight compression signal         -> 0..1
//      strength of this detector
//    The "tuning pick" row shows whether the overlay prefers measured or
//    assisted. Assisted uses bend start when it looks earlier/better than the
//    measured slope-drop start.
//
// 5. Choose the values to hardcode.
//    Usually start from the "assisted" row when bend signal is non-zero and the
//    graph looks correct. Otherwise use the "measured" row if found=1. Look for
//    a start near the visible beginning of highlight compression, a positive
//    slope, and an output value close to the LUT curve at that input.
//
// 6. Sanity-check the analysis.
//    confidence should be reasonably high, nondecrease should be 1, and peak
//    out should keep increasing up to the scan limit. If nondecrease is 0, the
//    LUT is not monotonic over the tested range and extension may need
//    per-channel values or manual tuning. If slope min/max/avg are extreme,
//    check the graph for noisy samples.
//
// 7. Hardcode the final params.
//    Set LUT_EXTENSION_SHOULDER to float3(start, slope, out). If RGB channels
//    need different values, override LUT_EXTENSION_SHOULDER_START_RGB,
//    LUT_EXTENSION_SHOULDER_SLOPE_RGB, and LUT_EXTENSION_SHOULDER_OUTPUT_RGB.
//    Keep LUT_EXTENSION_SHOULDER_HARDCODED=1 for the production path.
//
// 8. Disable calibration UI for release.
//    Set LUT_EXTENSION_DEBUG=0, LUT_EXTENSION_DEBUG_VERBOSE=0, and
//    LUT_EXTENSION_DEBUG_GRAPHS=0 before shipping. This avoids compiling the
//    expensive analysis/graph overlay while keeping the fast hardcoded
//    extension.
//
// 9. Validate visually.
//    Compare SDR-white, bright UI, bloom, and high-intensity highlights. The
//    extension should restore highlight headroom without lifting midtones or
//    causing hue shifts. If hue shifts appear, test
//    SampleHDRLUTShoulderExtendedPerChannel(color), but prefer the
//    luminance-preserving path by default.

// Debug compile controls. Graphs and verbose analysis are intentionally opt-in
// to avoid heavy production shader compile times.
#ifndef LUT_EXTENSION_DEBUG
#ifdef NDEBUG
#define LUT_EXTENSION_DEBUG 0
#else
#define LUT_EXTENSION_DEBUG 1
#endif
#endif

#ifndef LUT_EXTENSION_DEBUG_GRAPHS
#define LUT_EXTENSION_DEBUG_GRAPHS 0
#endif

#ifndef LUT_EXTENSION_DEBUG_VERBOSE
#define LUT_EXTENSION_DEBUG_VERBOSE 0
#endif

// Shoulder fitting controls. Hardcoded params are the fast production path;
// disabling this allows the shader to measure black-box LUTs at runtime for
// calibration/testing.
#ifndef LUT_EXTENSION_SHOULDER_HARDCODED
#define LUT_EXTENSION_SHOULDER_HARDCODED 1
#endif

#ifndef LUT_EXTENSION_SHOULDER_SCAN_LIMIT
#define LUT_EXTENSION_SHOULDER_SCAN_LIMIT 20.f
#endif

// x = input start, y = extension slope, z = LUT output at start.
#ifndef LUT_EXTENSION_SHOULDER
#define LUT_EXTENSION_SHOULDER float3(0.32f, 0.255266f, 0.068658f)
#endif

#ifndef LUT_EXTENSION_SHOULDER_START_RGB
#define LUT_EXTENSION_SHOULDER_START_RGB                                       \
  float3((LUT_EXTENSION_SHOULDER).x, (LUT_EXTENSION_SHOULDER).x,               \
         (LUT_EXTENSION_SHOULDER).x)
#endif

#ifndef LUT_EXTENSION_SHOULDER_SLOPE_RGB
#define LUT_EXTENSION_SHOULDER_SLOPE_RGB                                       \
  float3((LUT_EXTENSION_SHOULDER).y, (LUT_EXTENSION_SHOULDER).y,               \
         (LUT_EXTENSION_SHOULDER).y)
#endif

#ifndef LUT_EXTENSION_SHOULDER_OUTPUT_RGB
#define LUT_EXTENSION_SHOULDER_OUTPUT_RGB                                      \
  float3((LUT_EXTENSION_SHOULDER).z, (LUT_EXTENSION_SHOULDER).z,               \
         (LUT_EXTENSION_SHOULDER).z)
#endif

float4 GetLUTShoulderParams() {
  float3 shoulder = LUT_EXTENSION_SHOULDER;
  return float4(shoulder, LUT_EXTENSION_SHOULDER_HARDCODED ? 1.f : 0.f);
}

void GetLUTShoulderParamsRGB(out float3 start, out float3 slope,
                             out float3 output_at_start) {
  start = LUT_EXTENSION_SHOULDER_START_RGB;
  slope = LUT_EXTENSION_SHOULDER_SLOPE_RGB;
  output_at_start = LUT_EXTENSION_SHOULDER_OUTPUT_RGB;
}

float SampleLUTLuminanceCurve(float x) {
  float3 lut_output = LUT_EXTENSION_SAMPLE(float3(x, x, x));
  return renodx::color::y::from::BT709(lut_output);
}

float SampleLUTCurveChannel(float x, int channel) {
  float3 lut_output = LUT_EXTENSION_SAMPLE(float3(x, x, x));
  if (channel == 0)
    return lut_output.r;
  if (channel == 1)
    return lut_output.g;
  return lut_output.b;
}

float SampleLUTCurve(float x, int channel) {
  return channel < 0 ? SampleLUTLuminanceCurve(x)
                     : SampleLUTCurveChannel(x, channel);
}

float4 EstimateLUTShoulderParamsCurve(float x_limit, int channel) {
  const float kEpsilon = 1e-6f;
  const float kSearchSteps = 8.f;

  float x_anchor_cap = clamp(x_limit, 0.5f, 2.0f);
  float x2 = clamp(x_anchor_cap * 0.25f, 0.24f, 0.50f);
  float x1 = x2 * 0.5f;
  float x0 = x1 * 0.5f;
  float x3 = min(x2 * 2.f, max(x_anchor_cap * 0.95f, x2 * 1.01f));

  float f0 = SampleLUTCurve(x0, channel);
  float f1 = SampleLUTCurve(x1, channel);
  float f2 = SampleLUTCurve(x2, channel);
  float f3 = SampleLUTCurve(x3, channel);

  float s01 = (f1 - f0) / (x1 - x0);
  float s12 = (f2 - f1) / (x2 - x1);
  float s23 = (f3 - f2) / (x3 - x2);
  float score01 = abs(s12 - s01);
  float score12 = abs(s23 - s12);

  float mid_input_anchor = x2;
  float mid_output_anchor = f2;
  float mid_slope = s12;

  bool use_early_mid = (score01 <= score12) && (s01 > kEpsilon);
  if (use_early_mid) {
    mid_input_anchor = x1;
    mid_output_anchor = f1;
    mid_slope = s01;
  }

  mid_slope = max(mid_slope, 0.f);
  if (mid_slope <= kEpsilon) {
    return float4(0.f, 0.f, 0.f, 0.f);
  }

  float x_cap = max(x_limit, mid_input_anchor * 2.f);
  float kSearchGrowth = pow(x_cap / mid_input_anchor, 1.f / kSearchSteps);

  float x_prev = mid_input_anchor;
  float x_curr = x_prev * kSearchGrowth;
  float f_curr = SampleLUTCurve(x_curr, channel);
  float slope_prev =
      (f_curr - mid_output_anchor) / max(x_curr - x_prev, kEpsilon);

  float x_noise = x_curr * kSearchGrowth;
  float f_noise = SampleLUTCurve(x_noise, channel);
  float slope_noise_ref = (f_noise - f_curr) / max(x_noise - x_curr, kEpsilon);
  float slope_noise = abs(slope_noise_ref - slope_prev);
  float kSlopeDropThreshold = saturate(
      0.04f + 2.5f * renodx::math::DivideSafe(slope_noise, mid_slope, 0.f));
  float kConcavityThreshold =
      max(0.002f, 0.75f * renodx::math::DivideSafe(slope_noise,
                                                   (x_curr - x_prev), 0.f));

  float shoulder_start = x2;
  float shoulder_output = f2;
  bool found = false;

#define lut_extension_shoulder_step                                            \
  if (!found && x_curr < x_limit) {                                            \
    float x_next = x_curr * kSearchGrowth;                                     \
    float f_next = SampleLUTCurve(x_next, channel);                            \
    float slope_curr = (f_next - f_curr) / max(x_next - x_curr, kEpsilon);     \
    float concavity =                                                          \
        (slope_curr - slope_prev) / max(x_curr - x_prev, kEpsilon);            \
    if (slope_curr < (mid_slope * (1.f - kSlopeDropThreshold)) &&              \
        concavity < -kConcavityThreshold) {                                    \
      shoulder_start = x_curr;                                                 \
      shoulder_output = f_curr;                                                \
      found = true;                                                            \
    } else {                                                                   \
      x_prev = x_curr;                                                         \
      x_curr = x_next;                                                         \
      f_curr = f_next;                                                         \
      slope_prev = slope_curr;                                                 \
    }                                                                          \
  }

  lut_extension_shoulder_step lut_extension_shoulder_step
      lut_extension_shoulder_step lut_extension_shoulder_step
          lut_extension_shoulder_step lut_extension_shoulder_step
              lut_extension_shoulder_step lut_extension_shoulder_step

#undef lut_extension_shoulder_step

      return float4(shoulder_start, mid_slope, shoulder_output,
                    found ? 1.f : 0.f);
}

float4 EstimateLUTShoulderParams(float x_limit) {
  return EstimateLUTShoulderParamsCurve(x_limit, -1);
}

float4 EstimateLUTShoulderParamsChannel(float x_limit, int channel) {
  return EstimateLUTShoulderParamsCurve(x_limit, channel);
}

float LUTCurveSlope(float x0, float x1) {
  return renodx::math::DivideSafe(
      SampleLUTLuminanceCurve(x1) - SampleLUTLuminanceCurve(x0), x1 - x0, 0.f);
}

float4 EstimateLUTToeParams() {
  const float kEpsilon = 1e-6f;
  float y0 = SampleLUTLuminanceCurve(0.000f);
  float y1 = SampleLUTLuminanceCurve(0.010f);
  float y2 = SampleLUTLuminanceCurve(0.020f);
  float y3 = SampleLUTLuminanceCurve(0.040f);
  float y4 = SampleLUTLuminanceCurve(0.080f);
  float y5 = SampleLUTLuminanceCurve(0.160f);
  float y6 = SampleLUTLuminanceCurve(0.320f);

  float s01 = (y1 - y0) / 0.010f;
  float s12 = (y2 - y1) / 0.010f;
  float s23 = (y3 - y2) / 0.020f;
  float s34 = (y4 - y3) / 0.040f;
  float s45 = (y5 - y4) / 0.080f;
  float s56 = (y6 - y5) / 0.160f;

  float mid_slope = max(max(s34, s45), max(s56, kEpsilon));
  float threshold = mid_slope * 0.75f;

  float toe_start = 0.f;
  float toe_slope = s01;
  float toe_y = y0;
  float found = 0.f;

  if (found == 0.f && s01 >= threshold) {
    toe_start = 0.000f;
    toe_slope = s01;
    toe_y = y0;
    found = 1.f;
  }
  if (found == 0.f && s12 >= threshold) {
    toe_start = 0.010f;
    toe_slope = s12;
    toe_y = y1;
    found = 1.f;
  }
  if (found == 0.f && s23 >= threshold) {
    toe_start = 0.020f;
    toe_slope = s23;
    toe_y = y2;
    found = 1.f;
  }
  if (found == 0.f && s34 >= threshold) {
    toe_start = 0.040f;
    toe_slope = s34;
    toe_y = y3;
    found = 1.f;
  }
  if (found == 0.f && s45 >= threshold) {
    toe_start = 0.080f;
    toe_slope = s45;
    toe_y = y4;
    found = 1.f;
  }

  return float4(toe_start, toe_slope, toe_y, found);
}

float4 EstimateLUTMidGrayParams() {
  float y009 = SampleLUTLuminanceCurve(0.090f);
  float y018 = SampleLUTLuminanceCurve(0.180f);
  float y036 = SampleLUTLuminanceCurve(0.360f);
  float mid_slope = (y036 - y009) / 0.270f;
  float local_contrast =
      renodx::math::DivideSafe(mid_slope * 0.180f, y018, 0.f);
  return float4(0.180f, mid_slope, y018, local_contrast);
}

float4 EstimateLUTPeakParams(float x_limit) {
  float x0 = 1.000f;
  float x1 = min(2.000f, x_limit);
  float x2 = min(4.000f, x_limit);
  float x3 = min(8.000f, x_limit);
  float x4 = min(16.000f, x_limit);
  float x5 = x_limit;

  float y0 = SampleLUTLuminanceCurve(x0);
  float y1 = SampleLUTLuminanceCurve(x1);
  float y2 = SampleLUTLuminanceCurve(x2);
  float y3 = SampleLUTLuminanceCurve(x3);
  float y4 = SampleLUTLuminanceCurve(x4);
  float y5 = SampleLUTLuminanceCurve(x5);

  float peak_x = x0;
  float peak_y = y0;
  if (y1 > peak_y) {
    peak_x = x1;
    peak_y = y1;
  }
  if (y2 > peak_y) {
    peak_x = x2;
    peak_y = y2;
  }
  if (y3 > peak_y) {
    peak_x = x3;
    peak_y = y3;
  }
  if (y4 > peak_y) {
    peak_x = x4;
    peak_y = y4;
  }
  if (y5 > peak_y) {
    peak_x = x5;
    peak_y = y5;
  }

  float end_slope = renodx::math::DivideSafe(y5 - y4, max(x5 - x4, 1e-6f), 0.f);
  float outputs_are_non_decreasing =
      (y1 >= y0 && y2 >= y1 && y3 >= y2 && y4 >= y3 && y5 >= y4) ? 1.f : 0.f;
  return float4(peak_x, peak_y, end_slope, outputs_are_non_decreasing);
}

float4 EstimateLUTSlopeStats(float x_limit) {
  float x00 = 0.000f;
  float x01 = 0.010f;
  float x02 = 0.020f;
  float x03 = 0.040f;
  float x04 = 0.080f;
  float x05 = 0.160f;
  float x06 = 0.320f;
  float x07 = 0.500f;
  float x08 = 0.750f;
  float x09 = 1.000f;
  float x10 = min(1.500f, x_limit);
  float x11 = min(2.000f, x_limit);
  float x12 = min(3.000f, x_limit);
  float x13 = min(5.000f, x_limit);
  float x14 = min(10.000f, x_limit);
  float x15 = x_limit;

  float y00 = SampleLUTLuminanceCurve(x00);
  float y01 = SampleLUTLuminanceCurve(x01);
  float y02 = SampleLUTLuminanceCurve(x02);
  float y03 = SampleLUTLuminanceCurve(x03);
  float y04 = SampleLUTLuminanceCurve(x04);
  float y05 = SampleLUTLuminanceCurve(x05);
  float y06 = SampleLUTLuminanceCurve(x06);
  float y07 = SampleLUTLuminanceCurve(x07);
  float y08 = SampleLUTLuminanceCurve(x08);
  float y09 = SampleLUTLuminanceCurve(x09);
  float y10 = SampleLUTLuminanceCurve(x10);
  float y11 = SampleLUTLuminanceCurve(x11);
  float y12 = SampleLUTLuminanceCurve(x12);
  float y13 = SampleLUTLuminanceCurve(x13);
  float y14 = SampleLUTLuminanceCurve(x14);
  float y15 = SampleLUTLuminanceCurve(x15);

  float s01 = renodx::math::DivideSafe(y01 - y00, x01 - x00, 0.f);
  float s02 = renodx::math::DivideSafe(y02 - y01, x02 - x01, 0.f);
  float s03 = renodx::math::DivideSafe(y03 - y02, x03 - x02, 0.f);
  float s04 = renodx::math::DivideSafe(y04 - y03, x04 - x03, 0.f);
  float s05 = renodx::math::DivideSafe(y05 - y04, x05 - x04, 0.f);
  float s06 = renodx::math::DivideSafe(y06 - y05, x06 - x05, 0.f);
  float s07 = renodx::math::DivideSafe(y07 - y06, x07 - x06, 0.f);
  float s08 = renodx::math::DivideSafe(y08 - y07, x08 - x07, 0.f);
  float s09 = renodx::math::DivideSafe(y09 - y08, x09 - x08, 0.f);
  float s10 = renodx::math::DivideSafe(y10 - y09, max(x10 - x09, 1e-6f), 0.f);
  float s11 = renodx::math::DivideSafe(y11 - y10, max(x11 - x10, 1e-6f), 0.f);
  float s12 = renodx::math::DivideSafe(y12 - y11, max(x12 - x11, 1e-6f), 0.f);
  float s13 = renodx::math::DivideSafe(y13 - y12, max(x13 - x12, 1e-6f), 0.f);
  float s14 = renodx::math::DivideSafe(y14 - y13, max(x14 - x13, 1e-6f), 0.f);
  float s15 = renodx::math::DivideSafe(y15 - y14, max(x15 - x14, 1e-6f), 0.f);

  float min_slope =
      min(min(min(s01, s02), min(s03, s04)), min(min(s05, s06), min(s07, s08)));
  min_slope = min(min_slope, min(min(min(s09, s10), min(s11, s12)),
                                 min(s13, min(s14, s15))));
  float max_slope =
      max(max(max(s01, s02), max(s03, s04)), max(max(s05, s06), max(s07, s08)));
  max_slope = max(max_slope, max(max(max(s09, s10), max(s11, s12)),
                                 max(s13, max(s14, s15))));
  float avg_slope = (s01 + s02 + s03 + s04 + s05 + s06 + s07 + s08 + s09 + s10 +
                     s11 + s12 + s13 + s14 + s15) /
                    15.f;
  float outputs_are_non_decreasing =
      (y01 >= y00 && y02 >= y01 && y03 >= y02 && y04 >= y03 && y05 >= y04 &&
       y06 >= y05 && y07 >= y06 && y08 >= y07 && y09 >= y08 && y10 >= y09 &&
       y11 >= y10 && y12 >= y11 && y13 >= y12 && y14 >= y13 && y15 >= y14)
          ? 1.f
          : 0.f;
  return float4(min_slope, max_slope, avg_slope, outputs_are_non_decreasing);
}

float4 EstimateLUTBendDetectorParams(float x_limit) {
  float x0 = 0.180f;
  float x1 = 0.240f;
  float x2 = 0.320f;
  float x3 = 0.430f;
  float x4 = 0.580f;
  float x5 = 0.780f;
  float x6 = 1.050f;
  float x7 = min(1.410f, x_limit);
  float x8 = min(1.900f, x_limit);
  float x9 = min(2.560f, x_limit);

  float y0 = SampleLUTLuminanceCurve(x0);
  float y1 = SampleLUTLuminanceCurve(x1);
  float y2 = SampleLUTLuminanceCurve(x2);
  float y3 = SampleLUTLuminanceCurve(x3);
  float y4 = SampleLUTLuminanceCurve(x4);
  float y5 = SampleLUTLuminanceCurve(x5);
  float y6 = SampleLUTLuminanceCurve(x6);
  float y7 = SampleLUTLuminanceCurve(x7);
  float y8 = SampleLUTLuminanceCurve(x8);
  float y9 = SampleLUTLuminanceCurve(x9);

  float s01 = renodx::math::DivideSafe(y1 - y0, x1 - x0, 0.f);
  float s12 = renodx::math::DivideSafe(y2 - y1, x2 - x1, 0.f);
  float s23 = renodx::math::DivideSafe(y3 - y2, x3 - x2, 0.f);
  float s34 = renodx::math::DivideSafe(y4 - y3, x4 - x3, 0.f);
  float s45 = renodx::math::DivideSafe(y5 - y4, x5 - x4, 0.f);
  float s56 = renodx::math::DivideSafe(y6 - y5, x6 - x5, 0.f);
  float s67 = renodx::math::DivideSafe(y7 - y6, max(x7 - x6, 1e-6f), 0.f);
  float s78 = renodx::math::DivideSafe(y8 - y7, max(x8 - x7, 1e-6f), 0.f);
  float s89 = renodx::math::DivideSafe(y9 - y8, max(x9 - x8, 1e-6f), 0.f);

  float c012 = renodx::math::DivideSafe(s12 - s01, 0.5f * (x2 - x0), 0.f);
  float c123 = renodx::math::DivideSafe(s23 - s12, 0.5f * (x3 - x1), 0.f);
  float c234 = renodx::math::DivideSafe(s34 - s23, 0.5f * (x4 - x2), 0.f);
  float c345 = renodx::math::DivideSafe(s45 - s34, 0.5f * (x5 - x3), 0.f);
  float c456 = renodx::math::DivideSafe(s56 - s45, 0.5f * (x6 - x4), 0.f);
  float c567 =
      renodx::math::DivideSafe(s67 - s56, max(0.5f * (x7 - x5), 1e-6f), 0.f);
  float c678 =
      renodx::math::DivideSafe(s78 - s67, max(0.5f * (x8 - x6), 1e-6f), 0.f);
  float c789 =
      renodx::math::DivideSafe(s89 - s78, max(0.5f * (x9 - x7), 1e-6f), 0.f);

  float j0 = renodx::math::DivideSafe(c123 - c012, 0.5f * (x3 - x0), 0.f);
  float j1 = renodx::math::DivideSafe(c234 - c123, 0.5f * (x4 - x1), 0.f);
  float j2 = renodx::math::DivideSafe(c345 - c234, 0.5f * (x5 - x2), 0.f);
  float j3 = renodx::math::DivideSafe(c456 - c345, 0.5f * (x6 - x3), 0.f);
  float j4 =
      renodx::math::DivideSafe(c567 - c456, max(0.5f * (x7 - x4), 1e-6f), 0.f);
  float j5 =
      renodx::math::DivideSafe(c678 - c567, max(0.5f * (x8 - x5), 1e-6f), 0.f);
  float j6 =
      renodx::math::DivideSafe(c789 - c678, max(0.5f * (x9 - x6), 1e-6f), 0.f);

  float mid_slope = max(max(s01, s12), 1e-6f);
  float candidate_x = x2;
  float candidate_acceleration = 0.f;
  float candidate_bend_amount = 0.f;
  float found = 0.f;

#define bend_detector_candidate(TEST_X, TEST_SLOPE, TEST_BEND_AMOUNT,          \
                                TEST_ACCELERATION)                             \
  if ((TEST_ACCELERATION) < candidate_acceleration &&                          \
      (TEST_BEND_AMOUNT) < -0.001f && (TEST_SLOPE) < mid_slope * 1.02f) {      \
    candidate_x = (TEST_X);                                                    \
    candidate_acceleration = (TEST_ACCELERATION);                              \
    candidate_bend_amount = (TEST_BEND_AMOUNT);                                \
    found = 1.f;                                                               \
  }

  bend_detector_candidate(x2, s23, c234, j0)
      bend_detector_candidate(x3, s34, c345, j1)
          bend_detector_candidate(x4, s45, c456, j2)
              bend_detector_candidate(x5, s56, c567, j3)
                  bend_detector_candidate(x6, s67, c678, j4)
                      bend_detector_candidate(x7, s78, c789, j5)

#undef bend_detector_candidate

                          float signal =
                              saturate(-candidate_acceleration * 0.25f) * found;
  return float4(candidate_x, candidate_acceleration, candidate_bend_amount,
                signal);
}

float4 EstimateLUTBendAssistedShoulderParams(float x_limit) {
  float4 shoulder = EstimateLUTShoulderParams(x_limit);
  float4 bend_detector = EstimateLUTBendDetectorParams(x_limit);
  bool use_bend_detector = bend_detector.w > 0.05f && bend_detector.x > 0.18f &&
                           (shoulder.w < 0.5f || bend_detector.x < shoulder.x);
  if (use_bend_detector) {
    float start = bend_detector.x;
    return float4(start, max(shoulder.y, 0.f), SampleLUTLuminanceCurve(start),
                  1.f);
  }
  return shoulder;
}

float4 EstimateLUTBendAssistedShoulderParamsPrecomputed(float4 shoulder,
                                                        float4 bend_detector) {
  bool use_bend_detector = bend_detector.w > 0.05f && bend_detector.x > 0.18f &&
                           (shoulder.w < 0.5f || bend_detector.x < shoulder.x);
  if (use_bend_detector) {
    float start = bend_detector.x;
    return float4(start, max(shoulder.y, 0.f), SampleLUTLuminanceCurve(start),
                  1.f);
  }
  return shoulder;
}

struct LUTCurveAnalysis {
  float4 toe; // x = toe input, y = slope, z = output luminance, w = found
  float4 mid; // x = mid-gray input, y = slope, z = output luminance, w = local
              // contrast ratio
  float4 shoulder; // x = shoulder input, y = slope, z = output luminance, w =
                   // found
  float4 shoulder_assisted; // x = selected shoulder input, y = slope, z =
                            // output luminance, w = found
  float4 bend_detector; // x = bend start input, y = bend acceleration, z = bend
                        // amount, w = signal
  float4 peak; // x = brightest tested input, y = brightest output, z = end
               // slope, w = tested outputs are non-decreasing
  float4 slope_stats; // x = minimum slope, y = maximum slope, z = average
                      // slope, w = tested outputs are non-decreasing
  float4
      active_shoulder; // x = active input start, y = active slope, z = active
                       // output at start, w = hardcoded params enabled
  float confidence;
};

LUTCurveAnalysis AnalyzeLUTCurve(float x_limit) {
  LUTCurveAnalysis analysis;
  analysis.toe = EstimateLUTToeParams();
  analysis.mid = EstimateLUTMidGrayParams();
  analysis.shoulder = EstimateLUTShoulderParams(x_limit);
  analysis.bend_detector = EstimateLUTBendDetectorParams(x_limit);
  analysis.shoulder_assisted = EstimateLUTBendAssistedShoulderParamsPrecomputed(
      analysis.shoulder, analysis.bend_detector);
  analysis.peak = EstimateLUTPeakParams(x_limit);
  analysis.slope_stats = EstimateLUTSlopeStats(x_limit);
  analysis.active_shoulder = GetLUTShoulderParams();
  analysis.confidence = saturate(
      0.25f * analysis.toe.w + 0.25f * analysis.shoulder_assisted.w +
      0.25f * analysis.slope_stats.w + 0.15f * saturate(analysis.mid.y * 4.f) +
      0.10f * analysis.bend_detector.w);
  return analysis;
}

#if LUT_EXTENSION_DEBUG

#if LUT_EXTENSION_DEBUG_GRAPHS

float LUTGraphInputToPixelX(float input_x, float origin_x, float width) {
  const float x_min = 0.01f;
  const float x_max = LUT_EXTENSION_SHOULDER_SCAN_LIMIT;
  float graph_x = saturate((log2(max(input_x, x_min)) - log2(x_min)) /
                           (log2(x_max) - log2(x_min)));
  return origin_x + width * graph_x;
}

float LUTGraphInputToPixelXRange(float input_x, float origin_x, float width,
                                 float x_min, float x_max) {
  float graph_x = saturate((log2(max(input_x, x_min)) - log2(x_min)) /
                           (log2(x_max) - log2(x_min)));
  return origin_x + width * graph_x;
}

void DrawLUTInputTick(inout renodx::canvas::Context canvas, float2 origin,
                      float2 size, float input_x, uint tick_color,
                      float opacity) {
  float tick_pixel_x = LUTGraphInputToPixelX(input_x, origin.x, size.x);
  renodx::canvas::SetColor(canvas, tick_color, opacity, 1.f);
  renodx::canvas::FillRect(canvas, float2(tick_pixel_x - 0.5f, origin.y),
                           float2(tick_pixel_x + 0.5f, origin.y + size.y));
}

void DrawLUTInputTickRange(inout renodx::canvas::Context canvas, float2 origin,
                           float2 size, float input_x, uint tick_color,
                           float opacity, float x_min, float x_max) {
  float tick_pixel_x =
      LUTGraphInputToPixelXRange(input_x, origin.x, size.x, x_min, x_max);
  renodx::canvas::SetColor(canvas, tick_color, opacity, 1.f);
  renodx::canvas::FillRect(canvas, float2(tick_pixel_x - 0.5f, origin.y),
                           float2(tick_pixel_x + 0.5f, origin.y + size.y));
}

void DrawLUTInputTicks(inout renodx::canvas::Context canvas, float2 origin,
                       float2 size) {
  // Input reference ticks. 0.18 is mid-gray, 1.0 is SDR white, and higher
  // values are HDR stops.
  DrawLUTInputTick(canvas, origin, size, 0.18f, 0x3f88c5, 0.45f);
  DrawLUTInputTick(canvas, origin, size, 0.50f, 0x506070, 0.35f);
  DrawLUTInputTick(canvas, origin, size, 1.00f, 0xd8dde3, 0.50f);
  DrawLUTInputTick(canvas, origin, size, 2.00f, 0x506070, 0.35f);
  DrawLUTInputTick(canvas, origin, size, 4.00f, 0x506070, 0.35f);
  DrawLUTInputTick(canvas, origin, size, 8.00f, 0x506070, 0.35f);
  DrawLUTInputTick(canvas, origin, size, 16.00f, 0x506070, 0.35f);
}

void DrawLUTInputTicksRange(inout renodx::canvas::Context canvas, float2 origin,
                            float2 size, float x_min, float x_max) {
  // Same reference ticks as the full-range graphs, remapped to the graph's
  // local input range.
  DrawLUTInputTickRange(canvas, origin, size, 0.18f, 0x3f88c5, 0.45f, x_min,
                        x_max);
  DrawLUTInputTickRange(canvas, origin, size, 0.50f, 0x506070, 0.35f, x_min,
                        x_max);
  DrawLUTInputTickRange(canvas, origin, size, 1.00f, 0xd8dde3, 0.50f, x_min,
                        x_max);
  DrawLUTInputTickRange(canvas, origin, size, 2.00f, 0x506070, 0.35f, x_min,
                        x_max);
  DrawLUTInputTickRange(canvas, origin, size, 4.00f, 0x506070, 0.35f, x_min,
                        x_max);
  DrawLUTInputTickRange(canvas, origin, size, 8.00f, 0x506070, 0.35f, x_min,
                        x_max);
  DrawLUTInputTickRange(canvas, origin, size, 16.00f, 0x506070, 0.35f, x_min,
                        x_max);
}

// Draws the raw LUT luminance response used for shoulder calibration.
//
// Graph mapping:
// - X axis is scene-linear gray input on a logarithmic scale from 0.01 to
// LUT_EXTENSION_SHOULDER_SCAN_LIMIT.
//   This gives more horizontal space to the toe/midrange while still showing
//   HDR values above 1.0.
// - Y axis is linear BT.709 luminance from LUT_EXTENSION_SAMPLE(float3(x, x,
// x)), normalized to analysis.peak.y.
//   Because X is log and Y is linear, a neutral linear response will look like
//   an upward curve here.
//
// Colors:
// - Green curve: sampled LUT output luminance.
// - Thin vertical ticks: important input references. Blue is 0.18 mid-gray,
// white is 1.0, gray is 0.5/2/4/8/16.
// - Yellow vertical line: analysis.shoulder.x, the normal slope-drop shoulder
// detector.
// - Red vertical line: analysis.shoulder_assisted.x, which can prefer the bend
// detector.
//
// Use this graph to see actual output headroom and where the LUT begins to
// compress highlights.
void DrawLUTCurvePlot(inout renodx::canvas::Context canvas,
                      LUTCurveAnalysis analysis, float2 origin, float2 size) {
  float2 pixel = canvas.position;
  float2 local = pixel - origin;
  if (local.x < 0.f || local.y < 0.f || local.x > size.x || local.y > size.y) {
    return;
  }

  renodx::canvas::SetColor(canvas, 0x101418, 0.82f, 1.f);
  renodx::canvas::FillRect(canvas, origin, origin + size);
  DrawLUTInputTicks(canvas, origin, size);

  float graph_x = saturate(local.x / max(size.x, 1.f));
  float sample_x = pow(
      2.f, lerp(log2(0.01f), log2(LUT_EXTENSION_SHOULDER_SCAN_LIMIT), graph_x));
  float sample_y = SampleLUTLuminanceCurve(sample_x);
  float graph_y = saturate(sample_y / max(analysis.peak.y, 1e-3f));
  float curve_pixel_y = origin.y + size.y * (1.f - graph_y);

  renodx::canvas::SetColor(canvas, 0x3df58f, 1.f, 1.f);
  if (abs(pixel.y - curve_pixel_y) <= 1.5f) {
    renodx::canvas::FillRect(canvas, pixel - 1.f, pixel + 1.f);
  }

  float shoulder_graph_x =
      saturate((log2(max(analysis.shoulder.x, 0.01f)) - log2(0.01f)) /
               (log2(LUT_EXTENSION_SHOULDER_SCAN_LIMIT) - log2(0.01f)));
  float shoulder_pixel_x = origin.x + size.x * shoulder_graph_x;
  renodx::canvas::SetColor(canvas, 0xffd166, 0.9f, 1.f);
  renodx::canvas::FillRect(canvas, float2(shoulder_pixel_x - 1.f, origin.y),
                           float2(shoulder_pixel_x + 1.f, origin.y + size.y));

  float assisted_graph_x =
      saturate((log2(max(analysis.shoulder_assisted.x, 0.01f)) - log2(0.01f)) /
               (log2(LUT_EXTENSION_SHOULDER_SCAN_LIMIT) - log2(0.01f)));
  float assisted_pixel_x = origin.x + size.x * assisted_graph_x;
  renodx::canvas::SetColor(canvas, 0xef476f, 0.9f, 1.f);
  renodx::canvas::FillRect(canvas, float2(assisted_pixel_x - 1.f, origin.y),
                           float2(assisted_pixel_x + 1.f, origin.y + size.y));
}

// Draws the same LUT response as a log-input/log-output graph.
//
// Graph mapping:
// - X axis is the same logarithmic scene-linear input scale as
// DrawLUTCurvePlot.
// - Y axis is logarithmic output luminance. This removes the misleading
// exponential look caused by
//   log-input/linear-output plotting and makes toe/mid/shoulder behavior easier
//   to judge visually.
//
// Colors:
// - Cyan curve: sampled LUT output luminance in log output space.
// - Gray diagonal: visual guide for a proportional response where output rises
// at the same rate as input.
//   This is a rate-of-change guide, not an input/output target. Following it
//   means output grows at a roughly proportional rate; flattening away from it
//   near the top is the highlight shoulder.
// - Thin vertical ticks: important input references. Blue is 0.18 mid-gray,
// white is 1.0, gray is 0.5/2/4/8/16.
// - Yellow vertical line: analysis.shoulder.x, the normal measured shoulder
// start.
// - Red vertical line: analysis.shoulder_assisted.x, the assisted shoulder
// start.
//
// Use this graph to judge whether the tonemapper is neutral, has a filmic S
// curve, and where the shoulder visibly starts bending away from the reference
// line.
void DrawLUTSCurvePlot(inout renodx::canvas::Context canvas,
                       LUTCurveAnalysis analysis, float2 origin, float2 size) {
  float2 pixel = canvas.position;
  float2 local = pixel - origin;
  if (local.x < 0.f || local.y < 0.f || local.x > size.x || local.y > size.y) {
    return;
  }

  renodx::canvas::SetColor(canvas, 0x101418, 0.82f, 1.f);
  renodx::canvas::FillRect(canvas, origin, origin + size);
  DrawLUTInputTicks(canvas, origin, size);

  const float x_min = 0.01f;
  const float x_max = LUT_EXTENSION_SHOULDER_SCAN_LIMIT;
  const float y_floor = 0.0005f;
  float y_min = max(SampleLUTLuminanceCurve(x_min), y_floor);
  float y_max = max(analysis.peak.y, y_min * 1.01f);
  float log_y_min = log2(y_min);
  float log_y_max = log2(y_max);

  float graph_x = saturate(local.x / max(size.x, 1.f));
  float sample_x = pow(2.f, lerp(log2(x_min), log2(x_max), graph_x));
  float sample_y = max(SampleLUTLuminanceCurve(sample_x), y_floor);
  float graph_y = saturate((log2(sample_y) - log_y_min) /
                           max(log_y_max - log_y_min, 1e-3f));
  float curve_pixel_y = origin.y + size.y * (1.f - graph_y);

  float reference_pixel_y = origin.y + size.y * (1.f - graph_x);
  renodx::canvas::SetColor(canvas, 0x506070, 0.55f, 1.f);
  if (abs(pixel.y - reference_pixel_y) <= 0.75f) {
    renodx::canvas::FillRect(canvas, pixel - 0.5f, pixel + 0.5f);
  }

  renodx::canvas::SetColor(canvas, 0x61dafb, 1.f, 1.f);
  if (abs(pixel.y - curve_pixel_y) <= 1.5f) {
    renodx::canvas::FillRect(canvas, pixel - 1.f, pixel + 1.f);
  }

  float shoulder_graph_x =
      saturate((log2(max(analysis.shoulder.x, x_min)) - log2(x_min)) /
               (log2(x_max) - log2(x_min)));
  float shoulder_pixel_x = origin.x + size.x * shoulder_graph_x;
  renodx::canvas::SetColor(canvas, 0xffd166, 0.9f, 1.f);
  renodx::canvas::FillRect(canvas, float2(shoulder_pixel_x - 1.f, origin.y),
                           float2(shoulder_pixel_x + 1.f, origin.y + size.y));

  float assisted_graph_x =
      saturate((log2(max(analysis.shoulder_assisted.x, x_min)) - log2(x_min)) /
               (log2(x_max) - log2(x_min)));
  float assisted_pixel_x = origin.x + size.x * assisted_graph_x;
  renodx::canvas::SetColor(canvas, 0xef476f, 0.9f, 1.f);
  renodx::canvas::FillRect(canvas, float2(assisted_pixel_x - 1.f, origin.y),
                           float2(assisted_pixel_x + 1.f, origin.y + size.y));
}

// Draws the local log/log slope of the LUT curve.
//
// Graph mapping:
// - X axis is scene-linear input from 0.18 mid-gray to
// LUT_EXTENSION_SHOULDER_SCAN_LIMIT.
//   The toe is intentionally skipped because tiny dark-value LUT differences
//   make log derivatives noisy.
// - Y axis is local log-output/log-input slope. A value near 1 means
// proportional growth; values below 1
//   mean compression. The shoulder is easier to see here because it appears as
//   the slope curve falling.
//
// Colors:
// - Purple curve: local slope of the LUT response.
// - Gray horizontal line: slope 1.0, proportional growth reference.
// - Thin vertical ticks: important input references. Blue is 0.18 mid-gray,
// white is 1.0, gray is 0.5/2/4/8/16.
// - Yellow vertical line: analysis.shoulder.x, the normal measured shoulder
// start.
// - Red vertical line: analysis.shoulder_assisted.x, the assisted shoulder
// start.
void DrawLUTSlopePlot(inout renodx::canvas::Context canvas,
                      LUTCurveAnalysis analysis, float2 origin, float2 size) {
  float2 pixel = canvas.position;
  float2 local = pixel - origin;
  if (local.x < 0.f || local.y < 0.f || local.x > size.x || local.y > size.y) {
    return;
  }

  renodx::canvas::SetColor(canvas, 0x101418, 0.82f, 1.f);
  renodx::canvas::FillRect(canvas, origin, origin + size);

  const float x_min = 0.18f;
  const float x_max = LUT_EXTENSION_SHOULDER_SCAN_LIMIT;
  const float y_floor = 0.0005f;
  DrawLUTInputTicksRange(canvas, origin, size, x_min, x_max);
  float graph_x = saturate(local.x / max(size.x, 1.f));
  float prev_graph_x =
      saturate(graph_x - renodx::math::DivideSafe(1.f, max(size.x, 1.f), 0.f));
  float next_graph_x =
      saturate(graph_x + renodx::math::DivideSafe(1.f, max(size.x, 1.f), 0.f));
  float prev_x = pow(2.f, lerp(log2(x_min), log2(x_max), prev_graph_x));
  float next_x = pow(2.f, lerp(log2(x_min), log2(x_max), next_graph_x));
  float prev_y = max(SampleLUTLuminanceCurve(prev_x), y_floor);
  float next_y = max(SampleLUTLuminanceCurve(next_x), y_floor);
  float local_slope = renodx::math::DivideSafe(
      log2(next_y) - log2(prev_y), log2(next_x) - log2(prev_x), 0.f);
  float graph_y = saturate(local_slope * 0.5f);
  float curve_pixel_y = origin.y + size.y * (1.f - graph_y);

  float reference_pixel_y = origin.y + size.y * 0.5f;
  renodx::canvas::SetColor(canvas, 0x506070, 0.65f, 1.f);
  if (abs(pixel.y - reference_pixel_y) <= 0.75f) {
    renodx::canvas::FillRect(canvas, pixel - 0.5f, pixel + 0.5f);
  }

  renodx::canvas::SetColor(canvas, 0xb46cff, 1.f, 1.f);
  if (abs(pixel.y - curve_pixel_y) <= 1.5f) {
    renodx::canvas::FillRect(canvas, pixel - 1.f, pixel + 1.f);
  }

  float shoulder_pixel_x = LUTGraphInputToPixelXRange(
      analysis.shoulder.x, origin.x, size.x, x_min, x_max);
  renodx::canvas::SetColor(canvas, 0xffd166, 0.9f, 1.f);
  renodx::canvas::FillRect(canvas, float2(shoulder_pixel_x - 1.f, origin.y),
                           float2(shoulder_pixel_x + 1.f, origin.y + size.y));

  float assisted_pixel_x = LUTGraphInputToPixelXRange(
      analysis.shoulder_assisted.x, origin.x, size.x, x_min, x_max);
  renodx::canvas::SetColor(canvas, 0xef476f, 0.9f, 1.f);
  renodx::canvas::FillRect(canvas, float2(assisted_pixel_x - 1.f, origin.y),
                           float2(assisted_pixel_x + 1.f, origin.y + size.y));
}

#endif

#if LUT_EXTENSION_DEBUG_VERBOSE

// Draws the full LUT shoulder calibration overlay.
//
// Text readout:
// - active: shoulder params currently used by the runtime extension path.
// - measured: shoulder params found by the slope-drop detector.
// - assisted: shoulder params after optional bend-detector assistance.
// - bend detector: candidate start input, bend acceleration, bend amount, and
// signal.
// - slope stats: min/max/average local slope and whether sampled outputs are
// non-decreasing.
// - hardcoded enabled: 1 means active params come from LUT_EXTENSION_SHOULDER,
// 0 means runtime analysis.
float3 DrawLUTShoulderDebug(float2 pixel_position, float3 background) {
  LUTCurveAnalysis analysis =
      AnalyzeLUTCurve(LUT_EXTENSION_SHOULDER_SCAN_LIMIT);
  bool use_assisted = analysis.bend_detector.w > 0.05f &&
                      analysis.bend_detector.x > 0.18f &&
                      (analysis.shoulder.w < 0.5f ||
                       analysis.bend_detector.x < analysis.shoulder.x);

  renodx::canvas::Context canvas = renodx::canvas::CreateContext(
      pixel_position, float2(24.f, 24.f), float2(12.f, 17.f), background, 1.f,
      float3(0.749f, 0.812f, 0.800f), 1.f, 1.f);

  renodx::canvas::SetColor(canvas, 0x3df58f, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, 'L', 'U', 'T', ' ', 'C', 'U', 'R', 'V', 'E');
  renodx::canvas::NewLine(canvas);

  renodx::canvas::SetColor(canvas, 0xd8dde3, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, 'a', 'c', 't', 'i', 'v', 'e', ' ', 'i', 'n',
                           ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.active_shoulder.x, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 's', 'l', 'o', 'p', 'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.active_shoulder.y, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'o', 'u', 't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.active_shoulder.z, 1.f, 6.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'm', 'e', 'a', 's', 'u', 'r', 'e', 'd', ' ',
                           'i', 'n', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.shoulder.x, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 's', 'l', 'o', 'p', 'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.shoulder.y, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'o', 'u', 't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.shoulder.z, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'f', 'o', 'u', 'n', 'd', ':', ' ');
  if (analysis.shoulder.w < 0.5f) {
    renodx::canvas::SetColor(canvas, 0xef476f, 1.f, 1.f);
  }
  renodx::canvas::DrawFloat(canvas, analysis.shoulder.w, 1.f, 1.f, false,
                            false);
  renodx::canvas::SetColor(canvas, 0xd8dde3, 1.f, 1.f);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'a', 's', 's', 'i', 's', 't', 'e', 'd', ' ',
                           'i', 'n', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.shoulder_assisted.x, 1.f, 6.f,
                            false, false);
  renodx::canvas::DrawText(canvas, ' ', 's', 'l', 'o', 'p', 'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.shoulder_assisted.y, 1.f, 6.f,
                            false, false);
  renodx::canvas::DrawText(canvas, ' ', 'o', 'u', 't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.shoulder_assisted.z, 1.f, 6.f,
                            false, false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'b', 'e', 'n', 'd', ' ', 's', 't', 'a', 'r',
                           't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.bend_detector.x, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'a', 'c', 'c', 'e', 'l', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.bend_detector.y, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'a', 'm', 'o', 'u', 'n', 't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.bend_detector.z, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 's', 'i', 'g', 'n', 'a', 'l', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.bend_detector.w, 1.f, 3.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 't', 'o', 'e', ' ', 'i', 'n', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.toe.x, 1.f, 6.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 's', 'l', 'o', 'p', 'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.toe.y, 1.f, 6.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 'o', 'u', 't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.toe.z, 1.f, 6.f, false, false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'm', 'i', 'd', ' ', 'i', 'n', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.mid.x, 1.f, 6.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 's', 'l', 'o', 'p', 'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.mid.y, 1.f, 6.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 'o', 'u', 't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.mid.z, 1.f, 6.f, false, false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'p', 'e', 'a', 'k', ' ', 'i', 'n', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.peak.x, 1.f, 6.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 'o', 'u', 't', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.peak.y, 1.f, 6.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 'e', 'n', 'd', ' ', 's', 'l', 'o', 'p',
                           'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.peak.z, 1.f, 6.f, false, false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 's', 'l', 'o', 'p', 'e', ' ', 'm', 'i', 'n',
                           ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.slope_stats.x, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'm', 'a', 'x', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.slope_stats.y, 1.f, 6.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'a', 'v', 'g', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.slope_stats.z, 1.f, 6.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'c', 'o', 'n', 'f', 'i', 'd', 'e', 'n', 'c',
                           'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.confidence, 1.f, 3.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'n', 'o', 'n', 'd', 'e', 'c', 'r', 'e',
                           'a', 's', 'e', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.slope_stats.w, 1.f, 1.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'h', 'a', 'r', 'd', 'c', 'o', 'd', 'e',
                           'd', ':', ' ');
  renodx::canvas::DrawFloat(canvas, analysis.active_shoulder.w, 1.f, 1.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  float3 shoulder_start_rgb;
  float3 shoulder_slope_rgb;
  float3 shoulder_output_rgb;
  GetLUTShoulderParamsRGB(shoulder_start_rgb, shoulder_slope_rgb,
                          shoulder_output_rgb);

  renodx::canvas::DrawText(canvas, 'R', 'G', 'B', ' ', 's', 't', 'a', 'r', 't',
                           ' ', 'R', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_start_rgb.r, 1.f, 5.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'G', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_start_rgb.g, 1.f, 5.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'B', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_start_rgb.b, 1.f, 5.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'R', 'G', 'B', ' ', 's', 'l', 'o', 'p', 'e',
                           ' ', 'R', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_slope_rgb.r, 1.f, 5.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'G', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_slope_rgb.g, 1.f, 5.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'B', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_slope_rgb.b, 1.f, 5.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'R', 'G', 'B', ' ', 'o', 'u', 't', ' ', 'R',
                           ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_output_rgb.r, 1.f, 5.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'G', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_output_rgb.g, 1.f, 5.f, false,
                            false);
  renodx::canvas::DrawText(canvas, ' ', 'B', ':', ' ');
  renodx::canvas::DrawFloat(canvas, shoulder_output_rgb.b, 1.f, 5.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 't', 'u', 'n', 'i', 'n', 'g', ' ', 'p', 'i',
                           'c', 'k', ':', ' ');
  if (use_assisted) {
    renodx::canvas::SetColor(canvas, 0xef476f, 1.f, 1.f);
    renodx::canvas::DrawText(canvas, 'a', 's', 's', 'i', 's', 't');
  } else {
    renodx::canvas::SetColor(canvas, 0xffd166, 1.f, 1.f);
    renodx::canvas::DrawText(canvas, 'm', 'e', 'a', 's', 'u', 'r', 'e', 'd');
  }
  renodx::canvas::SetColor(canvas, 0xd8dde3, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, ' ', 'Y', 'e', 'l', '=', 'm', 'e', 'a', 's',
                           'u', 'r', 'e', 'd');
  renodx::canvas::DrawText(canvas, ' ', 'R', 'e', 'd', '=', 'a', 's', 's', 'i',
                           's', 't', 'e', 'd');
  renodx::canvas::NewLine(canvas);

#if LUT_EXTENSION_DEBUG_GRAPHS
  renodx::canvas::DrawText(canvas, 'r', 'a', 'w', ' ', 'c', 'u', 'r', 'v', 'e',
                           ':', ' ');
  renodx::canvas::DrawText(canvas, 'l', 'o', 'g', ' ', 'i', 'n');
  renodx::canvas::DrawText(canvas, '/', 'l', 'i', 'n', ' ', 'o', 'u', 't', ' ',
                           'g', 'r', 'e', 'e', 'n', '=');
  renodx::canvas::DrawText(canvas, 'c', 'u', 'r', 'v', 'e');
  renodx::canvas::NewLine(canvas);
  renodx::canvas::DrawText(canvas, 's', '-', 'c', 'u', 'r', 'v', 'e', ':', ' ',
                           'l', 'o', 'g', ' ', 'i', 'n');
  renodx::canvas::DrawText(canvas, '/', 'l', 'o', 'g', ' ', 'o', 'u', 't', ' ',
                           'c', 'y', 'a', 'n', '=');
  renodx::canvas::DrawText(canvas, 'c', 'u', 'r', 'v', 'e', ' ');
  renodx::canvas::DrawText(canvas, 'g', 'r', 'a', 'y', '=', 'r', 'a', 't', 'e');
  renodx::canvas::NewLine(canvas);
  renodx::canvas::DrawText(canvas, 's', 'l', 'o', 'p', 'e', ':', ' ');
  renodx::canvas::DrawText(canvas, 'p', 'u', 'r', 'p', 'l', 'e', '=');
  renodx::canvas::DrawText(canvas, 'l', 'o', 'c', 'a', 'l', ' ', 's', 'l', 'o',
                           'p', 'e');
  renodx::canvas::DrawText(canvas, ' ', 'g', 'r', 'a', 'y', '=', '1');
  renodx::canvas::NewLine(canvas);

  DrawLUTCurvePlot(canvas, analysis, float2(24.f, 310.f), float2(360.f, 88.f));
  DrawLUTSCurvePlot(canvas, analysis, float2(24.f, 416.f), float2(360.f, 88.f));
  DrawLUTSlopePlot(canvas, analysis, float2(24.f, 522.f), float2(360.f, 88.f));
#else
  renodx::canvas::SetColor(canvas, 0xffd166, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, 'g', 'r', 'a', 'p', 'h', 's', ' ', 'o', 'f',
                           'f');
  renodx::canvas::DrawText(canvas, ' ', 'L', 'U', 'T', '_', 'E', 'X', 'T', 'E',
                           'N', 'S');
  renodx::canvas::DrawText(canvas, 'I', 'O', 'N', '_', 'D', 'E', 'B', 'U', 'G');
  renodx::canvas::DrawText(canvas, '_', 'G', 'R', 'A', 'P', 'H', 'S', '=', '0');
  renodx::canvas::NewLine(canvas);
#endif

  return renodx::canvas::GetOutput(canvas).rgb;
}

#else

// Fast debug path for iteration builds. This avoids graphs and the full wall of
// text.
float3 DrawLUTShoulderDebug(float2 pixel_position, float3 background) {
  renodx::canvas::Context canvas = renodx::canvas::CreateContext(
      pixel_position, float2(24.f, 24.f), float2(12.f, 17.f), background, 1.f,
      float3(0.749f, 0.812f, 0.800f), 1.f, 1.f);

  renodx::canvas::SetColor(canvas, 0x101418, 0.88f, 1.f);
  renodx::canvas::FillRect(canvas, float2(16.f, 16.f), float2(388.f, 136.f));

  renodx::canvas::SetColor(canvas, 0xffd166, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, 'L', 'U', 'T', ' ', 'D', 'E', 'B', 'U', 'G',
                           ' ', 'F', 'A', 'S', 'T');
  renodx::canvas::NewLine(canvas);

  renodx::canvas::SetColor(canvas, 0xd8dde3, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, 'v', 'e', 'r', 'b', 'o', 's', 'e', ':');
  renodx::canvas::DrawFloat(canvas, LUT_EXTENSION_DEBUG_VERBOSE, 1.f, 0.f,
                            false, false);
  renodx::canvas::DrawText(canvas, ' ', 'g', 'r', 'a', 'p', 'h', 's', ':');
  renodx::canvas::DrawFloat(canvas, LUT_EXTENSION_DEBUG_GRAPHS, 1.f, 0.f, false,
                            false);
  renodx::canvas::NewLine(canvas);

  renodx::canvas::DrawText(canvas, 'a', 'c', 't', 'i', 'v', 'e', ' ', 'i', 'n',
                           ':');
  float4 shoulder_params = GetLUTShoulderParams();
  renodx::canvas::DrawFloat(canvas, shoulder_params.x, 1.f, 5.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 's', 'l', 'o', 'p', 'e', ':');
  renodx::canvas::DrawFloat(canvas, shoulder_params.y, 1.f, 5.f, false, false);
  renodx::canvas::DrawText(canvas, ' ', 'o', 'u', 't', ':');
  renodx::canvas::DrawFloat(canvas, shoulder_params.z, 1.f, 5.f, false, false);
  renodx::canvas::NewLine(canvas);

  return renodx::canvas::GetOutput(canvas).rgb;
}

#endif

#else

// Keep DrawLUTShoulderDebug available to every shader even when the expensive
// graph/debug code is not compiled. When LUT_EXTENSION_DEBUG is 0, this
// lightweight fallback draws only a warning box instead of compiling the graph
// sampling, slope plotting, and LUT analysis UI.
float3 DrawLUTShoulderDebug(float2 pixel_position, float3 background) {
  renodx::canvas::Context canvas = renodx::canvas::CreateContext(
      pixel_position, float2(24.f, 24.f), float2(12.f, 17.f), background, 1.f,
      float3(0.749f, 0.812f, 0.800f), 1.f, 1.f);

  renodx::canvas::SetColor(canvas, 0x101418, 0.88f, 1.f);
  renodx::canvas::FillRect(canvas, float2(16.f, 16.f), float2(388.f, 88.f));

  renodx::canvas::SetColor(canvas, 0xffd166, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, 'L', 'U', 'T', ' ', 'D', 'E', 'B', 'U', 'G');
  renodx::canvas::NewLine(canvas);

  renodx::canvas::SetColor(canvas, 0xd8dde3, 1.f, 1.f);
  renodx::canvas::DrawText(canvas, 'L', 'U', 'T', '_', 'E', 'X', 'T', 'E', 'N',
                           'S');
  renodx::canvas::DrawText(canvas, 'I', 'O', 'N', '_', 'D', 'E', 'B', 'U', 'G');
  renodx::canvas::NewLine(canvas);
  renodx::canvas::DrawText(canvas, 'i', 's', ' ', '0', ' ', '-', ' ', 'g', 'r',
                           'a', 'p', 'h');
  renodx::canvas::DrawText(canvas, ' ', 'U', 'I', ' ', 'n', 'o', 't', ' ', 'c',
                           'o', 'm', 'p', 'i', 'l', 'e', 'd');

  return renodx::canvas::GetOutput(canvas).rgb;
}

#endif

float3 SampleHDRLUTShoulderExtendedPerChannel(float3 untonemapped) {
  float3 base = LUT_EXTENSION_SAMPLE(untonemapped);
  const float kEpsilon = 1e-6f;
  const float kMidB = 0.36f;
  float3 x_in = max(untonemapped, 0.f);
  float3 out_color = base;

  if (max(x_in.r, max(x_in.g, x_in.b)) <= kMidB) {
    return base;
  }

#if LUT_EXTENSION_SHOULDER_HARDCODED
  float3 start;
  float3 slope;
  float3 output_at_start;
  GetLUTShoulderParamsRGB(start, slope, output_at_start);
  slope = max(slope, 0.f);
  output_at_start = max(output_at_start, 0.f);
  float3 extended = max(output_at_start + slope * (x_in - start), 0.f);
  float3 use_extended = step(start, x_in) * step(kEpsilon, slope);
  return lerp(out_color, extended, use_extended);
#else
  if (x_in.r > kMidB) {
    float4 pr =
        EstimateLUTShoulderParamsChannel(LUT_EXTENSION_SHOULDER_SCAN_LIMIT, 0);
    if (x_in.r > pr.x && pr.y > kEpsilon) {
      out_color.r = max(pr.z + pr.y * (x_in.r - pr.x), 0.f);
    }
  }

  if (x_in.g > kMidB) {
    float4 pg =
        EstimateLUTShoulderParamsChannel(LUT_EXTENSION_SHOULDER_SCAN_LIMIT, 1);
    if (x_in.g > pg.x && pg.y > kEpsilon) {
      out_color.g = max(pg.z + pg.y * (x_in.g - pg.x), 0.f);
    }
  }

  if (x_in.b > kMidB) {
    float4 pb =
        EstimateLUTShoulderParamsChannel(LUT_EXTENSION_SHOULDER_SCAN_LIMIT, 2);
    if (x_in.b > pb.x && pb.y > kEpsilon) {
      out_color.b = max(pb.z + pb.y * (x_in.b - pb.x), 0.f);
    }
  }

  return out_color;
#endif
}

float3 SampleHDRLUTShoulderExtended(float3 untonemapped) {
  float3 base = LUT_EXTENSION_SAMPLE(untonemapped);
  float3 out_color = base;
  const float kEpsilon = 1e-6f;
  const float kMidB = 0.36f;

  float input_luminance = renodx::color::y::from::BT709(untonemapped);
  float shoulder_start = 0.f;
  float extension_slope = 0.f;
  float shoulder_output = 0.f;

  if (input_luminance > kMidB) {
#if LUT_EXTENSION_SHOULDER_HARDCODED
    float4 shoulder_params = GetLUTShoulderParams();
    shoulder_start = shoulder_params.x;
    extension_slope = max(shoulder_params.y, 0.f);
    shoulder_output = max(shoulder_params.z, 0.f);
#else
    float4 params = EstimateLUTBendAssistedShoulderParams(
        LUT_EXTENSION_SHOULDER_SCAN_LIMIT);
    shoulder_start = params.x;
    extension_slope = params.y;
    shoulder_output = params.z;
#endif

    if (input_luminance > shoulder_start && extension_slope > kEpsilon) {
      float extended_luminance =
          max(shoulder_output +
                  extension_slope * (input_luminance - shoulder_start),
              0.f);
      float base_luminance = renodx::color::y::from::BT709(base);
      float scale = extended_luminance / max(base_luminance, kEpsilon);
      out_color = base * scale;
    }
  }

  return out_color;
}

float4 LUTShoulderSelfCheckColor() {
  float4 measured =
      EstimateLUTShoulderParams(LUT_EXTENSION_SHOULDER_SCAN_LIMIT);
  float3 hardcoded = GetLUTShoulderParams().xyz;
  float3 abs_error = abs(hardcoded - measured.xyz);
  float3 scaled_error = saturate(abs_error / float3(0.05f, 0.05f, 0.03f));
  return float4(scaled_error, measured.w > 0.5f ? 1.f : 0.f);
}

float4 LUTShoulderCalibrateColor() {
  float4 shoulder_params =
      EstimateLUTShoulderParams(LUT_EXTENSION_SHOULDER_SCAN_LIMIT);
  return float4(shoulder_params.rgb, 1.f);
}

#endif // LUT_EXTENSION_HLSL_
