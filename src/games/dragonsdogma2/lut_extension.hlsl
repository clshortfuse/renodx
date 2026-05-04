#include "./shared.h"

#ifndef LUT_EXTENSION_HLSL_
#define LUT_EXTENSION_HLSL_

#ifndef LUT_EXTENSION_SAMPLE
#error "Define LUT_EXTENSION_SAMPLE(color) before including lut_extension.hlsl"
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_HARDCODED
#define CUSTOM_HDR_LUT_SHOULDER_HARDCODED 1
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_START
#define CUSTOM_HDR_LUT_SHOULDER_START 0.49f
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_SLOPE
#define CUSTOM_HDR_LUT_SHOULDER_SLOPE 0.34f
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_Y
#define CUSTOM_HDR_LUT_SHOULDER_Y 0.145f
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT
#define CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT 20.f
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_PER_CHANNEL
#define CUSTOM_HDR_LUT_SHOULDER_PER_CHANNEL 1
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_PER_CHANNEL_HARDCODED
#define CUSTOM_HDR_LUT_SHOULDER_PER_CHANNEL_HARDCODED 1
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_START_R
#define CUSTOM_HDR_LUT_SHOULDER_START_R CUSTOM_HDR_LUT_SHOULDER_START
#endif
#ifndef CUSTOM_HDR_LUT_SHOULDER_START_G
#define CUSTOM_HDR_LUT_SHOULDER_START_G CUSTOM_HDR_LUT_SHOULDER_START
#endif
#ifndef CUSTOM_HDR_LUT_SHOULDER_START_B
#define CUSTOM_HDR_LUT_SHOULDER_START_B CUSTOM_HDR_LUT_SHOULDER_START
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_SLOPE_R
#define CUSTOM_HDR_LUT_SHOULDER_SLOPE_R CUSTOM_HDR_LUT_SHOULDER_SLOPE
#endif
#ifndef CUSTOM_HDR_LUT_SHOULDER_SLOPE_G
#define CUSTOM_HDR_LUT_SHOULDER_SLOPE_G CUSTOM_HDR_LUT_SHOULDER_SLOPE
#endif
#ifndef CUSTOM_HDR_LUT_SHOULDER_SLOPE_B
#define CUSTOM_HDR_LUT_SHOULDER_SLOPE_B CUSTOM_HDR_LUT_SHOULDER_SLOPE
#endif

#ifndef CUSTOM_HDR_LUT_SHOULDER_Y_R
#define CUSTOM_HDR_LUT_SHOULDER_Y_R CUSTOM_HDR_LUT_SHOULDER_Y
#endif
#ifndef CUSTOM_HDR_LUT_SHOULDER_Y_G
#define CUSTOM_HDR_LUT_SHOULDER_Y_G CUSTOM_HDR_LUT_SHOULDER_Y
#endif
#ifndef CUSTOM_HDR_LUT_SHOULDER_Y_B
#define CUSTOM_HDR_LUT_SHOULDER_Y_B CUSTOM_HDR_LUT_SHOULDER_Y
#endif



float SampleLUTLuminanceCurve(float x) {
  float3 y = LUT_EXTENSION_SAMPLE(float3(x, x, x));
  return renodx::color::y::from::BT709(y);
}

float4 EstimateLUTShoulderParams(float y_limit) {
  const float kEpsilon = 1e-6f;
  const float kSearchSteps = 8.f;

  float y_anchor_cap = clamp(y_limit, 0.5f, 2.0f);
  float x2 = clamp(y_anchor_cap * 0.25f, 0.24f, 0.50f);
  float x1 = x2 * 0.5f;
  float x0 = x1 * 0.5f;
  float x3 = min(x2 * 2.f, max(y_anchor_cap * 0.95f, x2 * 1.01f));

  float f0 = SampleLUTLuminanceCurve(x0);
  float f1 = SampleLUTLuminanceCurve(x1);
  float f2 = SampleLUTLuminanceCurve(x2);
  float f3 = SampleLUTLuminanceCurve(x3);

  float s01 = (f1 - f0) / (x1 - x0);
  float s12 = (f2 - f1) / (x2 - x1);
  float s23 = (f3 - f2) / (x3 - x2);
  float score01 = abs(s12 - s01);
  float score12 = abs(s23 - s12);

  float kMidB = x2;
  float f_mid_b = f2;
  float m_mid = s12;

  bool use_early_mid = (score01 <= score12) && (s01 > kEpsilon);
  if (use_early_mid) {
    kMidB = x1;
    f_mid_b = f1;
    m_mid = s01;
  }

  m_mid = max(m_mid, 0.f);
  if (m_mid <= kEpsilon) {
    return float4(0.f, 0.f, 0.f, 0.f);
  }

  float y_cap = max(y_limit, kMidB * 2.f);
  float kSearchGrowth = pow(y_cap / kMidB, 1.f / kSearchSteps);

  float t_prev = kMidB;
  float t_curr = t_prev * kSearchGrowth;
  float f_curr = SampleLUTLuminanceCurve(t_curr);
  float slope_prev = (f_curr - f_mid_b) / max(t_curr - t_prev, kEpsilon);

  float t_noise = t_curr * kSearchGrowth;
  float f_noise = SampleLUTLuminanceCurve(t_noise);
  float slope_noise_ref = (f_noise - f_curr) / max(t_noise - t_curr, kEpsilon);
  float slope_noise = abs(slope_noise_ref - slope_prev);
  float kSlopeDropThreshold = saturate(0.04f + 2.5f * renodx::math::DivideSafe(slope_noise, m_mid, 0.f));
  float kConcavityThreshold = max(0.002f, 0.75f * renodx::math::DivideSafe(slope_noise, (t_curr - t_prev), 0.f));

  float shoulder_start = x2;
  float y_shoulder = f2;
  bool found = false;

#define shoulder_step \
  if (!found && t_curr < y_limit) {                                                               \
    float t_next = t_curr * kSearchGrowth;                                                        \
    float f_next = SampleLUTLuminanceCurve(t_next);                                               \
    float slope_curr = (f_next - f_curr) / max(t_next - t_curr, kEpsilon);                       \
    float concavity = (slope_curr - slope_prev) / max(t_curr - t_prev, kEpsilon);                \
    if (slope_curr < (m_mid * (1.f - kSlopeDropThreshold)) && concavity < -kConcavityThreshold) { \
      shoulder_start = t_curr;                                                                    \
      y_shoulder = f_curr;                                                                        \
      found = true;                                                                               \
    } else {                                                                                      \
      t_prev = t_curr;                                                                            \
      t_curr = t_next;                                                                            \
      f_curr = f_next;                                                                            \
      slope_prev = slope_curr;                                                                    \
    }                                                                                             \
  }

  shoulder_step
  shoulder_step
  shoulder_step
  shoulder_step
  shoulder_step
  shoulder_step
  shoulder_step
  shoulder_step

#undef shoulder_step

  return float4(shoulder_start, m_mid, y_shoulder, found ? 1.f : 0.f);
}

float SampleLUTCurveChannel(float x, int channel) {
  float3 y = LUT_EXTENSION_SAMPLE(float3(x, x, x));
  if (channel == 0) return y.r;
  if (channel == 1) return y.g;
  return y.b;
}

float4 EstimateLUTShoulderParamsChannel(float x_limit, int channel) {
  const float kEpsilon = 1e-6f;
  const float kSearchSteps = 8.f;

  float x_anchor_cap = clamp(x_limit, 0.5f, 2.0f);
  float x2 = clamp(x_anchor_cap * 0.25f, 0.24f, 0.50f);
  float x1 = x2 * 0.5f;
  float x0 = x1 * 0.5f;
  float x3 = min(x2 * 2.f, max(x_anchor_cap * 0.95f, x2 * 1.01f));

  float f0 = SampleLUTCurveChannel(x0, channel);
  float f1 = SampleLUTCurveChannel(x1, channel);
  float f2 = SampleLUTCurveChannel(x2, channel);
  float f3 = SampleLUTCurveChannel(x3, channel);

  float s01 = (f1 - f0) / (x1 - x0);
  float s12 = (f2 - f1) / (x2 - x1);
  float s23 = (f3 - f2) / (x3 - x2);
  float score01 = abs(s12 - s01);
  float score12 = abs(s23 - s12);

  float kMidB = x2;
  float f_mid_b = f2;
  float m_mid = s12;

  bool use_early_mid = (score01 <= score12) && (s01 > kEpsilon);
  if (use_early_mid) {
    kMidB = x1;
    f_mid_b = f1;
    m_mid = s01;
  }

  m_mid = max(m_mid, 0.f);
  if (m_mid <= kEpsilon) {
    return float4(0.f, 0.f, 0.f, 0.f);
  }

  float x_cap = max(x_limit, kMidB * 2.f);
  float kSearchGrowth = pow(x_cap / kMidB, 1.f / kSearchSteps);

  float x_prev = kMidB;
  float x_curr = x_prev * kSearchGrowth;
  float f_curr = SampleLUTCurveChannel(x_curr, channel);
  float slope_prev = (f_curr - f_mid_b) / max(x_curr - x_prev, kEpsilon);

  float x_noise = x_curr * kSearchGrowth;
  float f_noise = SampleLUTCurveChannel(x_noise, channel);
  float slope_noise_ref = (f_noise - f_curr) / max(x_noise - x_curr, kEpsilon);
  float slope_noise = abs(slope_noise_ref - slope_prev);
  float kSlopeDropThreshold = saturate(0.04f + 2.5f * renodx::math::DivideSafe(slope_noise, m_mid, 0.f));
  float kConcavityThreshold = max(0.002f, 0.75f * renodx::math::DivideSafe(slope_noise, (x_curr - x_prev), 0.f));

  float shoulder_start = x2;
  float y_shoulder = f2;
  bool found = false;

#define shoulder_step_channel \
  if (!found && x_curr < x_limit) {                                                               \
    float x_next = x_curr * kSearchGrowth;                                                        \
    float f_next = SampleLUTCurveChannel(x_next, channel);                                        \
    float slope_curr = (f_next - f_curr) / max(x_next - x_curr, kEpsilon);                       \
    float concavity = (slope_curr - slope_prev) / max(x_curr - x_prev, kEpsilon);                \
    if (slope_curr < (m_mid * (1.f - kSlopeDropThreshold)) && concavity < -kConcavityThreshold) { \
      shoulder_start = x_curr;                                                                    \
      y_shoulder = f_curr;                                                                        \
      found = true;                                                                               \
    } else {                                                                                      \
      x_prev = x_curr;                                                                            \
      x_curr = x_next;                                                                            \
      f_curr = f_next;                                                                            \
      slope_prev = slope_curr;                                                                    \
    }                                                                                             \
  }

  shoulder_step_channel
  shoulder_step_channel
  shoulder_step_channel
  shoulder_step_channel
  shoulder_step_channel
  shoulder_step_channel
  shoulder_step_channel
  shoulder_step_channel

#undef shoulder_step_channel

  return float4(shoulder_start, m_mid, y_shoulder, found ? 1.f : 0.f);
}

float3 SampleHDRLUTShoulderExtendedPerChannel(float3 untonemapped) {
  float3 base = LUT_EXTENSION_SAMPLE(untonemapped);
  const float kEpsilon = 1e-6f;
  const float kMidB = 0.36f;
  float3 x_in = max(untonemapped, 0.f);
  float3 out_color = base;

  if (max(x_in.r, max(x_in.g, x_in.b)) <= kMidB) {
    return base;
  }

  if (x_in.r > kMidB) {
#if CUSTOM_HDR_LUT_SHOULDER_PER_CHANNEL_HARDCODED
    float start_r = CUSTOM_HDR_LUT_SHOULDER_START_R;
    float slope_r = max(CUSTOM_HDR_LUT_SHOULDER_SLOPE_R, 0.f);
    float y_r = max(CUSTOM_HDR_LUT_SHOULDER_Y_R, 0.f);
    if (x_in.r > start_r && slope_r > kEpsilon) {
      out_color.r = max(y_r + slope_r * (x_in.r - start_r), 0.f);
    }
#else
    float4 pr = EstimateLUTShoulderParamsChannel(CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT, 0);
    if (x_in.r > pr.x && pr.y > kEpsilon) {
      out_color.r = max(pr.z + pr.y * (x_in.r - pr.x), 0.f);
    }
#endif
  }

  if (x_in.g > kMidB) {
#if CUSTOM_HDR_LUT_SHOULDER_PER_CHANNEL_HARDCODED
    float start_g = CUSTOM_HDR_LUT_SHOULDER_START_G;
    float slope_g = max(CUSTOM_HDR_LUT_SHOULDER_SLOPE_G, 0.f);
    float y_g = max(CUSTOM_HDR_LUT_SHOULDER_Y_G, 0.f);
    if (x_in.g > start_g && slope_g > kEpsilon) {
      out_color.g = max(y_g + slope_g * (x_in.g - start_g), 0.f);
    }
#else
    float4 pg = EstimateLUTShoulderParamsChannel(CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT, 1);
    if (x_in.g > pg.x && pg.y > kEpsilon) {
      out_color.g = max(pg.z + pg.y * (x_in.g - pg.x), 0.f);
    }
#endif
  }

  if (x_in.b > kMidB) {
#if CUSTOM_HDR_LUT_SHOULDER_PER_CHANNEL_HARDCODED
    float start_b = CUSTOM_HDR_LUT_SHOULDER_START_B;
    float slope_b = max(CUSTOM_HDR_LUT_SHOULDER_SLOPE_B, 0.f);
    float y_b = max(CUSTOM_HDR_LUT_SHOULDER_Y_B, 0.f);
    if (x_in.b > start_b && slope_b > kEpsilon) {
      out_color.b = max(y_b + slope_b * (x_in.b - start_b), 0.f);
    }
#else
    float4 pb = EstimateLUTShoulderParamsChannel(CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT, 2);
    if (x_in.b > pb.x && pb.y > kEpsilon) {
      out_color.b = max(pb.z + pb.y * (x_in.b - pb.x), 0.f);
    }
#endif
  }

  return out_color;
}

float3 SampleHDRLUTShoulderExtended(float3 untonemapped) {
  float3 base = LUT_EXTENSION_SAMPLE(untonemapped);
  const float kEpsilon = 1e-6f;
  const float kMidB = 0.36f;

  float y_input = renodx::color::y::from::BT709(untonemapped);
  if (y_input <= kMidB) {
    return base;
  }

#if CUSTOM_HDR_LUT_SHOULDER_HARDCODED
  const float shoulder_start = CUSTOM_HDR_LUT_SHOULDER_START;
  const float m_mid = max(CUSTOM_HDR_LUT_SHOULDER_SLOPE, 0.f);
  const float y_shoulder = max(CUSTOM_HDR_LUT_SHOULDER_Y, 0.f);
  if (y_input <= shoulder_start || m_mid <= kEpsilon) {
    return base;
  }
#else
  float4 params = EstimateLUTShoulderParams(CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT);
  float shoulder_start = params.x;
  float m_mid = params.y;
  float y_shoulder = params.z;
  if (y_input <= shoulder_start || m_mid <= kEpsilon) {
    return base;
  }
#endif

  float y_extended = max(y_shoulder + m_mid * (y_input - shoulder_start), 0.f);
  float y_base = renodx::color::y::from::BT709(base);
  float scale = y_extended / max(y_base, kEpsilon);
  return base * scale;
}

float4 LUTShoulderSelfCheckColor() {
  float4 measured = EstimateLUTShoulderParams(CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT);
  float3 hardcoded = float3(
      CUSTOM_HDR_LUT_SHOULDER_START,
      CUSTOM_HDR_LUT_SHOULDER_SLOPE,
      CUSTOM_HDR_LUT_SHOULDER_Y);
  float3 abs_error = abs(hardcoded - measured.xyz);
  float3 scaled_error = saturate(abs_error / float3(0.05f, 0.05f, 0.03f));
  return float4(scaled_error, measured.w > 0.5f ? 1.f : 0.f);
}

float4 LUTShoulderCalibrateColor() {
  float4 shoulder_params = EstimateLUTShoulderParams(CUSTOM_HDR_LUT_SHOULDER_SCAN_LIMIT);
  return float4(shoulder_params.rgb, 1.f);
}

#endif  // LUT_EXTENSION_HLSL_
