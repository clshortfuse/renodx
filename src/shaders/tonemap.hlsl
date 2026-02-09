#ifndef SRC_SHADERS_TONEMAP_HLSL_
#define SRC_SHADERS_TONEMAP_HLSL_

#include "./colorcorrect.hlsl"
#include "./colorgrade.hlsl"
#include "./lut.hlsl"
#include "./tonemap/aces.hlsl"
#include "./tonemap/daniele.hlsl"
#include "./tonemap/dice.hlsl"
#include "./tonemap/frostbite.hlsl"
#include "./tonemap/hermite_spline.hlsl"
#include "./tonemap/reinhard.hlsl"
#include "./tonemap/reno_drt.hlsl"
#include "./tonemap/neutwo.hlsl"

namespace renodx {
namespace tonemap {

float ApplyCurve(float x, float a, float b, float c, float d, float e, float f) {
  float numerator = mad(x, mad(a, x, c * b), d * e);  // x * (a * x + c * b) + d * e
  float denominator = mad(x, mad(a, x, b), d * f);    // x * (a * x + b) + d * f
  return (numerator / denominator) - (e / f);
}

float3 ApplyCurve(float3 x, float a, float b, float c, float d, float e, float f) {
  float3 numerator = mad(x, mad(a, x, c * b), d * e);  // x * (a * x + c * b) + d * e
  float3 denominator = mad(x, mad(a, x, b), d * f);    // x * (a * x + b) + d * f
  return (numerator / denominator) - (e / f);
}

// https://www.glowybits.com/blog/2016/12/21/ifl_iss_hdr_1/
float SmoothClamp(float x) {
  const float u = 0.525;
  float q = (2.0 - u - 1.0 / u + x * (2.0 + 2.0 / u - x / u)) / 4.0;
  return (abs(1.0 - x) < u) ? q : saturate(x);
}

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_GENERATOR(T)                                                 \
  T ExponentialRollOff(T input, float rolloff_start = 0.20f, float output_max = 1.0f) { \
    T rolloff_size = output_max - rolloff_start;                                        \
    T overage = -max((T)0, input - rolloff_start);                                      \
    T rolloff_value = (T)1.0f - exp(overage / rolloff_size);                            \
    T new_overage = mad(rolloff_size, rolloff_value, overage);                          \
    return input + new_overage;                                                         \
  }

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_CLIP_GENERATOR(T)                                         \
  T ExponentialRollOff(T input, float rolloff_start, float output_max, float clip) { \
    T rolloff_size = output_max - rolloff_start;                                     \
    T overage = -max((T)0, input - rolloff_start);                                   \
    T clip_size = rolloff_start - clip;                                              \
    T rolloff_value = (T)1.0f - exp(overage / rolloff_size);                         \
    T clip_value = (T)1.0f - exp(clip_size / rolloff_size);                          \
    T new_overage = mad(rolloff_size, rolloff_value / clip_value, overage);          \
    return input + new_overage;                                                      \
  }

EXPONENTIALROLLOFF_GENERATOR(float)
EXPONENTIALROLLOFF_GENERATOR(float3)
EXPONENTIALROLLOFF_CLIP_GENERATOR(float)
EXPONENTIALROLLOFF_CLIP_GENERATOR(float3)
#undef EXPONENTIALROLLOFF_GENERATOR
#undef EXPONENTIALROLLOFF_CLIP_GENERATOR

// Narkowicz
float3 ACESFittedBT709(float3 color) {
  color *= 0.6f;
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  return clamp((color * (a * color + b)) / (color * (c * color + d) + e), 0.0f, 1.0f);
}

// Stephen Hill
float3 ACESFittedAP1(float3 color) {
  // sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
  const float3x3 ACESInputMat = {
    { 0.59719, 0.35458, 0.04823 },
    { 0.07600, 0.90834, 0.01566 },
    { 0.02840, 0.13383, 0.83777 }
  };

  // ODT_SAT => XYZ => D60_2_D65 => sRGB
  const float3x3 ACESOutputMat = {
    { 1.60475, -0.53108, -0.07367 },
    { -0.10208, 1.10813, -0.00605 },
    { -0.00327, -0.07276, 1.07602 }
  };

  color = mul(ACESInputMat, color);

  float3 a = color * (color + 0.0245786f) - 0.000090537f;
  float3 b = color * (0.983729f * color + 0.4329510f) + 0.238081f;
  color = a / b;

  color = mul(ACESOutputMat, color);

  color = saturate(color);
  return color;
}

// Uchimura 2018, "Practical HDR and Wide Color Techniques in Gran Turismo SPORT"
// https://www.desmos.com/calculator/gslcdxvipg
// http://cdn2.gran-turismo.com/data/www/pdi_publications/PracticalHDRandWCGinGTS.pdf
#define GTTONEMAP_GENERATOR(T)                \
  T GTTonemap(T x,                            \
              float P = 1.f,                  \
              float a = 1.f,                  \
              float m = 0.22f,                \
              float l = 0.4f,                 \
              float c = 1.33f,                \
              float b = 0.f) {                \
    float l0 = ((P - m) * l) / a;             \
    float L0 = m - (m / a);                   \
    float L1 = m + (1.0f - m) / a;            \
                                              \
    T S0 = m + l0;                            \
    T S1 = m + a * l0;                        \
    T C2 = (a * P) / (P - S1);                \
    T CP = -C2 / P;                           \
                                              \
    T w0 = 1.0f - smoothstep(0.0f, m, x);     \
    T w2 = step(m + l0, x);                   \
    T w1 = 1.0f - w0 - w2;                    \
                                              \
    T T_ = m * pow(x / m, c) + b;             \
    T S_ = P - (P - S1) * exp(CP * (x - S0)); \
    T L_ = m + a * (x - m);                   \
                                              \
    return T_ * w0 + L_ * w1 + S_ * w2;       \
  }

GTTONEMAP_GENERATOR(float)
GTTONEMAP_GENERATOR(float3)
#undef GTTONEMAP_GENERATOR

// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting
// http://filmicworlds.com/blog/filmic-tonemapping-operators/

// Hejl & Burgess-Dawson Filmic
float3 HejlDawson(float3 color) {
  color = max(0, color - 0.004f);
  color = (color * (6.2f * color + 0.5f)) / (color * (6.2f * color + 1.7f) + 0.06f);
  return pow(color, 2.2f);
}

namespace uncharted2 {
static const float A = 0.22;  // Shoulder Strength
static const float B = 0.30;  // Linear Strength
static const float C = 0.10;  // Linear Angle
static const float D = 0.20;  // Toe Strength
static const float E = 0.01;  // Toe Numerator
static const float F = 0.30;  // Toe Denominator
static const float W = 11.2;  // Linear White
float BT709(float x, float linear_white = W) {
  return ApplyCurve(x, A, B, C, D, E, F)
         / ApplyCurve(linear_white, A, B, C, D, E, F);
}

float3 BT709(float3 x, float linear_white = W) {
  return ApplyCurve(x, A, B, C, D, E, F)
         / ApplyCurve(linear_white, A, B, C, D, E, F);
}

namespace extended {
float3 BT709(float3 x, float linear_white = W) {
  float3 numerator = mad(x, mad(A, x, C * B), D * E);  // x * (a * x + c * b) + d * e
  float3 denominator = mad(x, mad(A, x, B), D * F);    // x * (a * x + b) + d * f

  float numerator_white = mad(linear_white, mad(A, linear_white, C * B), D * E);
  float denominator_white = mad(linear_white, mad(A, linear_white, B), D * F);

  float e_over_f = E / F;

  float3 curve_x = (numerator / denominator) - e_over_f;
  float curve_white = (numerator_white / denominator_white) - e_over_f;
  float curve_white_inverse = 1.f / curve_white;

  float3 value = curve_x * curve_white_inverse;

  // Use Cardono's Method to solve for point of peak velocity (2nd derivative = 0)
  // 2B^{2}D(E-CF)+2AD(E-F)(-DF+3Ax^{2})+2ABx(3D(E-CF)+A(-1+C)x^{2}) = 0
  float a_0 = 2 * B * B * D * (E - C * F) - 2 * A * D * D * F * (E - F);
  float a_1 = 6 * A * B * D * (E - C * F);
  float a_2 = 6 * A * A * D * (E - F);
  float a_3 = 2 * A * A * B * (C - 1);

  float a_3_rcp = 1.f / a_3;  // Helper

  // float p = (3 * a_1 * a_3 - a_2 * a_2) / (3 * a_3 * a_3);
  float p = (3 * a_1 * a_3 - a_2 * a_2) * (1.f / 3.f) * (a_3_rcp * a_3_rcp);

  // float q = (27 * a_0 * a_3 * a_3 - 9 * a_1 * a_2 * a_3 + 2 * a_2 * a_2 * a_2) / (27 * a_3 * a_3 * a_3);
  float q = (27 * a_0 * a_3 * a_3 - 9 * a_1 * a_2 * a_3 + 2 * a_2 * a_2 * a_2) * (1.f / 27.f) * (a_3_rcp * a_3_rcp * a_3_rcp);

  // float delta = pow((q / 2), 2) + pow((p / 3), 3);
  float delta = (q * q) / 4.f + (p * p * p) / 27.f;

  float z;
  [branch]
  if (delta >= 0.0f) {
    // float z = pow(sqrt(delta) - q / 2.f, 1.f / 3.f) - pow(sqrt(delta) + q / 2.f, 1.f / 3.f);
    // Δ ≥ 0 → one real root, cube‑root form
    float sqrt_delta = sqrt(delta);
    z = pow(-q / 2.f + sqrt_delta, 1.f / 3.f) + pow(-q / 2.f - sqrt_delta, 1.f / 3.f);
  } else {
    // Δ < 0 → three real roots, use cosine form
    // usually ta k e k=0 root
    // float theta = acos((-q / 2.0f) / sqrt(-pow(p / 3.0f, 3)));
    // float r = 2.0f * sqrt(-p / 3.0f);

    // p is always negative here
    float positive_p_over_3 = -p / 3.f;

    float theta = acos((-q / 2.0f) * rsqrt(positive_p_over_3 * positive_p_over_3 * positive_p_over_3));
    float r = 2.0f * sqrt(positive_p_over_3);

    z = r * cos(theta / 3.0f);
  }

  // float peak_velocity = z - a_2 / (3 * a_3);
  float peak_velocity_point = (z - a_2) * (1.f / 3.f) * a_3_rcp;

  // If no toe, use initial velocity
  peak_velocity_point = max(0, peak_velocity_point);

  float peak_velocity_value_numerator = mad(peak_velocity_point, mad(A, peak_velocity_point, C * B), D * E);
  float peak_velocity_value_denominator = mad(peak_velocity_point, mad(A, peak_velocity_point, B), D * F);
  float peak_velocity_value_denominator_rcp = 1.f / peak_velocity_value_denominator;

  float peak_velocity_value_base = peak_velocity_value_numerator * peak_velocity_value_denominator_rcp;

  // Evaluate first derivative to get velocity (skip [E/F, W] normalization)
  // R\left(x\right)=\frac{(2Ax+CB)D_{r}\left(x\right)-(2Ax+B)N_{r}\left(x\right)}{D_{r}\left(x\right)^{2}}
  // R\left(x\right)=\frac{(2Ax+CB)-(2Ax+B)F\left(x\right)}{D_{r}\left(x\right)}
  float peak_velocity_unscaled = ((2 * A * peak_velocity_point + C * B)
                                  - ((2 * A * peak_velocity_point + B) * peak_velocity_value_base))
                                 * peak_velocity_value_denominator_rcp;

  float peak_velocity = peak_velocity_unscaled * curve_white_inverse;

  float curve_peak = peak_velocity_value_base - e_over_f;
  float value_peak = curve_peak * curve_white_inverse;

  // Use point slope form (y = y1 + m(x - x1)) to extend curve linearly beyond peak velocity

  float m = peak_velocity;
  float3 x_0 = value;
  float x1 = peak_velocity_point;
  float y1 = value_peak;
  float3 extended_value = y1 + m * (x_0 - x1);

  return renodx::math::Select(value > peak_velocity_point, extended_value, value);
}
}
}  // namespace uncharted2

namespace unity {
static const float A = 0.20;   // Shoulder Strength
static const float B = 0.29;   // Linear Strength
static const float C = 0.24;   // Linear Angle
static const float D = 0.272;  // Toe Strength
static const float E = 0.02;   // Toe Numerator
static const float F = 0.03;   // Toe Denominator
// Neutral
float3 BT709(float3 x) {
  float3 r0, r1, r2 = x;
  r0.xyz = x.xyz;
  r1.xyz = float3(1.31338608, 1.31338608, 1.31338608) * r0.xyz;
  r2.xyz = r0.xyz * float3(0.262677222, 0.262677222, 0.262677222) + float3(0.0695999935, 0.0695999935, 0.0695999935);
  r2.xyz = r1.xyz * r2.xyz + float3(0.00543999998, 0.00543999998, 0.00543999998);
  r0.xyz = r0.xyz * float3(0.262677222, 0.262677222, 0.262677222) + float3(0.289999992, 0.289999992, 0.289999992);
  r0.xyz = r1.xyz * r0.xyz + float3(0.0816000104, 0.0816000104, 0.0816000104);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = float3(-0.0666666627, -0.0666666627, -0.0666666627) + r0.xyz;
  r0.xyz = float3(1.31338608, 1.31338608, 1.31338608) * r0.xyz;
  return r0.xyz;
}
}  // namespace unity

struct Config {
  float type;
  float peak_nits;
  float game_nits;
  float gamma_correction;
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float saturation;
  float mid_gray_value;
  float mid_gray_nits;
  float reno_drt_highlights;
  float reno_drt_shadows;
  float reno_drt_contrast;
  float reno_drt_saturation;
  float reno_drt_dechroma;
  float reno_drt_flare;
  float hue_correction_type;
  float hue_correction_strength;
  float3 hue_correction_color;
  float reno_drt_hue_correction_method;
  float reno_drt_tone_map_method;
  float reno_drt_working_color_space;
  bool reno_drt_per_channel;
  float reno_drt_blowout;
  float reno_drt_clamp_color_space;
  float reno_drt_clamp_peak;
  float reno_drt_white_clip;
};

float3 UpgradeToneMap(
    float3 color_untonemapped,
    float3 color_tonemapped,
    float3 color_tonemapped_graded,
    float post_process_strength = 1.f,
    float auto_correction = 0.f) {
  float ratio = 1.f;

  float y_untonemapped = renodx::color::y::from::BT709(color_untonemapped);
  float y_tonemapped = renodx::color::y::from::BT709(color_tonemapped);
  float y_tonemapped_graded = renodx::color::y::from::BT709(color_tonemapped_graded);

  if (y_untonemapped < y_tonemapped) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    ratio = y_untonemapped / y_tonemapped;
  } else {
    float y_delta = y_untonemapped - y_tonemapped;
    y_delta = max(0, y_delta);  // Cleans up NaN
    const float y_new = y_tonemapped_graded + y_delta;

    const bool y_valid = (y_tonemapped_graded > 0);  // Cleans up NaN and ignore black
    ratio = y_valid ? (y_new / y_tonemapped_graded) : 0;
  }
  float auto_correct_ratio = lerp(1.f, ratio, saturate(y_untonemapped));
  ratio = lerp(ratio, auto_correct_ratio, auto_correction);

  float3 color_scaled = color_tonemapped_graded * ratio;
  // Match hue
  color_scaled = renodx::color::correct::Hue(color_scaled, color_tonemapped_graded);
  return lerp(color_untonemapped, color_scaled, post_process_strength);
}

namespace config {
namespace type {
static const float VANILLA = 0.f;
static const float NONE = 1.f;
static const float ACES = 2.f;
static const float RENODRT = 3.f;
}  // namespace type

namespace hue_correction_type {
static const float INPUT = 0.f;
static const float CLAMPED = 1.f;
static const float CUSTOM = 2.f;
}  // namespace hue_correction_type

Config Create(
    float type = config::type::VANILLA,
    float peak_nits = 203.f,
    float game_nits = 203.f,
    float gamma_correction = 0.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float saturation = 1.f,
    float mid_gray_value = 0.18f,
    float mid_gray_nits = 18.f,
    float reno_drt_highlights = 1.f,
    float reno_drt_shadows = 1.f,
    float reno_drt_contrast = 1.f,
    float reno_drt_saturation = 1.f,
    float reno_drt_dechroma = 0.5f,
    float reno_drt_flare = 0.f,
    float hue_correction_type = config::hue_correction_type::INPUT,
    float hue_correction_strength = 1.f,
    float3 hue_correction_color = 0.f,
    float reno_drt_hue_correction_method = renodrt::config::hue_correction_method::OKLAB,
    float reno_drt_tone_map_method = renodrt::config::tone_map_method::DANIELE,
    float reno_drt_working_color_space = 0.f,
    bool reno_drt_per_channel = false,
    float reno_drt_blowout = 0.f,
    float reno_drt_clamp_color_space = 2.f,
    float reno_drt_clamp_peak = 1.f,
    float reno_drt_white_clip = 100.f) {
  const Config tm_config = {
    type,
    peak_nits,
    game_nits,
    gamma_correction,
    exposure,
    highlights,
    shadows,
    contrast,
    saturation,
    mid_gray_value,
    mid_gray_nits,
    reno_drt_highlights,
    reno_drt_shadows,
    reno_drt_contrast,
    reno_drt_saturation,
    reno_drt_dechroma,
    reno_drt_flare,
    hue_correction_type,
    hue_correction_strength,
    hue_correction_color,
    reno_drt_hue_correction_method,
    reno_drt_tone_map_method,
    reno_drt_working_color_space,
    reno_drt_per_channel,
    reno_drt_blowout,
    reno_drt_clamp_color_space,
    reno_drt_clamp_peak,
    reno_drt_white_clip
  };
  return tm_config;
}

float3 ApplyRenoDRT(float3 color, Config tm_config) {
  float reno_drt_max = (tm_config.peak_nits / tm_config.game_nits);
  [branch]
  if (tm_config.gamma_correction != 0) {
    reno_drt_max = renodx::color::correct::Gamma(
        reno_drt_max,
        tm_config.gamma_correction > 0.f,
        abs(tm_config.gamma_correction) == 1.f ? 2.2f : 2.4f);
  } else {
    // noop
  }

  renodrt::Config reno_drt_config = renodrt::config::Create();
  reno_drt_config.nits_peak = reno_drt_max * 100.f;
  reno_drt_config.mid_gray_value = 0.18f;
  reno_drt_config.mid_gray_nits = tm_config.mid_gray_nits;
  reno_drt_config.exposure = tm_config.exposure;
  reno_drt_config.highlights = tm_config.reno_drt_highlights;
  reno_drt_config.shadows = tm_config.reno_drt_shadows;
  reno_drt_config.contrast = tm_config.reno_drt_contrast;
  reno_drt_config.saturation = tm_config.reno_drt_saturation;
  reno_drt_config.dechroma = tm_config.reno_drt_dechroma;
  reno_drt_config.flare = tm_config.reno_drt_flare;
  reno_drt_config.hue_correction_strength = tm_config.hue_correction_strength;
  reno_drt_config.hue_correction_type = renodrt::config::hue_correction_type::CUSTOM;
  if (tm_config.hue_correction_type == config::hue_correction_type::CUSTOM) {
    reno_drt_config.hue_correction_source = tm_config.hue_correction_color;
  } else if (tm_config.hue_correction_type == config::hue_correction_type::CLAMPED) {
    reno_drt_config.hue_correction_source = tm_config.hue_correction_color;
  } else {
    reno_drt_config.hue_correction_source = color;
  }
  reno_drt_config.hue_correction_method = tm_config.reno_drt_hue_correction_method;
  reno_drt_config.tone_map_method = tm_config.reno_drt_tone_map_method;
  reno_drt_config.working_color_space = tm_config.reno_drt_working_color_space;
  reno_drt_config.per_channel = tm_config.reno_drt_per_channel;
  reno_drt_config.blowout = tm_config.reno_drt_blowout;
  reno_drt_config.clamp_color_space = tm_config.reno_drt_clamp_color_space;
  reno_drt_config.clamp_peak = tm_config.reno_drt_clamp_peak;
  reno_drt_config.white_clip = tm_config.reno_drt_white_clip;

  return renodrt::BT709(color, reno_drt_config);
}

float3 ApplyACES(float3 color, Config tm_config) {
  static const float ACES_MID_GRAY = 0.10f;
  static const float ACES_MIN = 0.0001f;
  const float mid_gray_scale = (tm_config.mid_gray_value / ACES_MID_GRAY);

  float aces_min = ACES_MIN / tm_config.game_nits;
  float aces_max = (tm_config.peak_nits / tm_config.game_nits);

  [branch]
  if (tm_config.gamma_correction != 0.f) {
    aces_max = renodx::color::correct::Gamma(
        aces_max,
        tm_config.gamma_correction > 0.f,
        abs(tm_config.gamma_correction) == 1.f ? 2.2f : 2.4f);
    aces_min = renodx::color::correct::Gamma(
        aces_min,
        tm_config.gamma_correction > 0.f,
        abs(tm_config.gamma_correction) == 1.f ? 2.2f : 2.4f);
  } else {
    // noop
  }
  aces_max /= mid_gray_scale;
  aces_min /= mid_gray_scale;

  color = renodx::tonemap::aces::RGCAndRRTAndODT(color, aces_min * 48.f, aces_max * 48.f);
  color /= 48.f;
  color *= mid_gray_scale;

  return color;
}

float3 Apply(float3 untonemapped, Config tm_config) {
  float3 color = untonemapped;

  [branch]
  if (tm_config.type == config::type::RENODRT) {
    tm_config.reno_drt_highlights *= tm_config.highlights;
    tm_config.reno_drt_shadows *= tm_config.shadows;
    tm_config.reno_drt_contrast *= tm_config.contrast;
    tm_config.reno_drt_saturation *= tm_config.saturation;
    color = ApplyRenoDRT(color, tm_config);
  } else {
    color = renodx::color::grade::UserColorGrading(
        color,
        tm_config.exposure,
        tm_config.highlights,
        tm_config.shadows,
        tm_config.contrast,
        tm_config.saturation);
    [branch]
    if (tm_config.type == config::type::ACES) {
      color = ApplyACES(color, tm_config);
    } else {
    }
  }
  return color;
}

struct DualToneMap {
  float3 color_hdr;
  float3 color_sdr;
};

DualToneMap ApplyToneMaps(float3 color_input, Config hdr_config, Config sdr_config) {
  DualToneMap dual_tone_map;
  dual_tone_map.color_hdr = Apply(color_input, hdr_config);
  dual_tone_map.color_sdr = Apply(color_input, sdr_config);
  return dual_tone_map;
}

DualToneMap ApplyToneMaps(float3 color_input, Config tm_config) {
  Config sdr_config = tm_config;
  sdr_config.reno_drt_highlights /= tm_config.highlights;
  sdr_config.reno_drt_shadows /= tm_config.shadows;
  sdr_config.reno_drt_contrast /= tm_config.contrast;
  sdr_config.gamma_correction = 0;
  sdr_config.peak_nits = 100.f;
  sdr_config.game_nits = 100.f;

  tm_config.hue_correction_type = config::hue_correction_type::INPUT;
  return ApplyToneMaps(color_input, tm_config, sdr_config);
}

#define TONE_MAP_FUNCTION_GENERATOR(textureType)                                                                \
  float3 Apply(float3 color_input, Config tm_config, renodx::lut::Config lut_config, textureType lut_texture) { \
    [branch]                                                                                                    \
    if (lut_config.strength == 0.f || tm_config.type == 1.f) {                                                  \
      return Apply(color_input, tm_config);                                                                     \
    } else {                                                                                                    \
      DualToneMap tone_maps = ApplyToneMaps(color_input, tm_config);                                            \
      float3 color_hdr = tone_maps.color_hdr;                                                                   \
      float3 color_sdr = tone_maps.color_sdr;                                                                   \
                                                                                                                \
      float previous_lut_config_strength = lut_config.strength;                                                 \
      lut_config.strength = 1.f;                                                                                \
      float3 color_lut;                                                                                         \
      if (                                                                                                      \
          lut_config.type_input == lut::config::type::SRGB                                                      \
          || lut_config.type_input == lut::config::type::GAMMA_2_4                                              \
          || lut_config.type_input == lut::config::type::GAMMA_2_2                                              \
          || lut_config.type_input == lut::config::type::GAMMA_2_0) {                                           \
        color_lut = renodx::lut::Sample(lut_texture, lut_config, color_sdr);                                    \
      } else {                                                                                                  \
        color_lut = min(1.f, renodx::lut::Sample(lut_texture, lut_config, color_hdr));                          \
      }                                                                                                         \
                                                                                                                \
      [branch]                                                                                                  \
      if (tm_config.type == config::type::VANILLA) {                                                            \
        return lerp(color_input, color_lut, previous_lut_config_strength);                                      \
      } else {                                                                                                  \
        return UpgradeToneMap(color_hdr, color_sdr, color_lut, previous_lut_config_strength);                   \
      }                                                                                                         \
    }                                                                                                           \
  }

TONE_MAP_FUNCTION_GENERATOR(Texture2D<float4>);
TONE_MAP_FUNCTION_GENERATOR(Texture2D<float3>);
TONE_MAP_FUNCTION_GENERATOR(Texture3D<float4>);
TONE_MAP_FUNCTION_GENERATOR(Texture3D<float3>);

#undef TONE_MAP_FUNCTION_GENERATOR

}  // namespace config
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_SHADERS_TONEMAP_HLSL_
