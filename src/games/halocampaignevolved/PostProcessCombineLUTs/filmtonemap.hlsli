#ifndef RENODX_UNREAL_LUT_BUILDER_FILM_TONE_MAP_HLSLI_
#define RENODX_UNREAL_LUT_BUILDER_FILM_TONE_MAP_HLSLI_

#include "./config.hlsli"

namespace unrealengine {
namespace lutbuilder {
namespace filmtonemap {

#define FILM_TONE_CURVE_GENERATOR(T)                                                                                                                            \
  T ApplyToneCurve(T untonemapped, const FilmToneMapConfig config) {                                                                                            \
    float toe_width = (config.black_clip + 1.f) - config.toe;                                                                                                   \
    float shoulder_width = (config.white_clip + 1.f) - config.shoulder;                                                                                         \
    float log_toe_threshold;                                                                                                                                    \
    if (config.toe > 0.8f) {                                                                                                                                    \
      log_toe_threshold = ((0.82f - config.toe) / config.slope) - 0.7447274923324585f;                                                                          \
    } else {                                                                                                                                                    \
      float toe_normalized = (config.black_clip + 0.18f) / toe_width;                                                                                           \
      log_toe_threshold = -0.7447274923324585f - ((log2(toe_normalized / (2.f - toe_normalized)) * 0.3465735912322998f) * (toe_width / config.slope));          \
    }                                                                                                                                                           \
    float log_mid_anchor = ((1.f - config.toe) / config.slope) - log_toe_threshold;                                                                             \
    float log_shoulder_threshold = (config.shoulder / config.slope) - log_mid_anchor;                                                                           \
                                                                                                                                                                \
    T untonemapped_log = log2(untonemapped) * 0.3010300099849701f;                                                                                              \
    T straight_curve = config.slope * (untonemapped_log + log_mid_anchor);                                                                                      \
                                                                                                                                                                \
    T toe_offset = untonemapped_log - log_toe_threshold;                                                                                                        \
    T toe_curve = select(                                                                                                                                       \
        untonemapped_log < log_toe_threshold,                                                                                                                   \
        ((toe_width * 2.f) / (exp2((toe_offset * 1.4426950216293335f) * ((config.slope * -2.f) / toe_width)) + 1.f)) - config.black_clip,                       \
        straight_curve);                                                                                                                                        \
                                                                                                                                                                \
    T shoulder_offset = untonemapped_log - log_shoulder_threshold;                                                                                              \
    T shoulder_curve = select(                                                                                                                                  \
        untonemapped_log > log_shoulder_threshold,                                                                                                              \
        (1.f + config.white_clip) - ((shoulder_width * 2.f) / (exp2((shoulder_offset * 1.4426950216293335f) * ((config.slope * 2.f) / shoulder_width)) + 1.f)), \
        straight_curve);                                                                                                                                        \
                                                                                                                                                                \
    T blend_linear = saturate(toe_offset / (log_shoulder_threshold - log_toe_threshold));                                                                       \
    T blend = select(log_shoulder_threshold < log_toe_threshold, 1.f - blend_linear, blend_linear);                                                             \
    return (((blend * blend) * (shoulder_curve - toe_curve)) * (3.f - (blend * 2.f))) + toe_curve;                                                              \
  }
FILM_TONE_CURVE_GENERATOR(float)
FILM_TONE_CURVE_GENERATOR(float3)
#undef FILM_TONE_CURVE_GENERATOR

// Combined AP1 -> AP0 blue-correction -> AP1 transform from the decompiled LUT builder.
float3 ApplyBlueCorrection(float3 untonemapped_ap1, const FilmToneMapConfig config) {
  float r = untonemapped_ap1.r;
  float g = untonemapped_ap1.g;
  float b = untonemapped_ap1.b;

  return float3(
      ((mad(0.061360642313957214f, b, mad(-4.540197551250458e-09f, g, r * 0.9386394023895264f)) - r) * config.blue_correction) + r,
      ((mad(0.169205904006958f, b, mad(0.8307942152023315f, g, r * 6.775371730327606e-08f)) - g) * config.blue_correction) + g,
      (mad(-2.3283064365386963e-10f, g, r * -9.313225746154785e-10f) * config.blue_correction) + b);
}

// The RenoDX ACES RRT consumes AP0 and returns its AP1 rendering space.
float3 ApplyRRT(float3 blue_corrected_ap1) {
  return renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, blue_corrected_ap1));
}

float3 ApplyPostToneMapDesaturation(float3 tonemapped_ap1) {
  float luminance = renodx::color::y::from::AP1(tonemapped_ap1);
  return max(0.f, lerp(luminance, tonemapped_ap1, 0.93f));
}

float3 ApplyToneCurveAmount(
    float3 tonemapped_ap1,
    float3 blue_corrected_ap1,
    const FilmToneMapConfig config) {
  return lerp(blue_corrected_ap1, tonemapped_ap1, config.tone_curve_amount);
}

// Combined inverse blue-correction transform from the decompiled LUT builder.
float3 ApplyInverseBlueCorrection(float3 tonemapped_ap1, const FilmToneMapConfig config) {
  float r = tonemapped_ap1.r;
  float g = tonemapped_ap1.g;
  float b = tonemapped_ap1.b;

  return float3(
      ((mad(-0.06537103652954102f, b, mad(1.451815478503704e-06f, g, r * 1.065374732017517f)) - r) * config.blue_correction) + r,
      ((mad(-0.20366770029067993f, b, mad(1.2036634683609009f, g, r * -2.57161445915699e-07f)) - g) * config.blue_correction) + g,
      ((mad(0.9999996423721313f, b, mad(2.0954757928848267e-08f, g, r * 1.862645149230957e-08f)) - b) * config.blue_correction) + b);
}

float3 ApplyVanilla(float3 untonemapped_ap1, const FilmToneMapConfig config) {
  float3 blue_corrected_ap1 = ApplyBlueCorrection(untonemapped_ap1, config);
  float3 rrt_ap1 = ApplyRRT(blue_corrected_ap1);
  float3 tonemapped_ap1 = ApplyToneCurve(rrt_ap1, config);
  tonemapped_ap1 = ApplyPostToneMapDesaturation(tonemapped_ap1);
  tonemapped_ap1 = ApplyToneCurveAmount(tonemapped_ap1, blue_corrected_ap1, config);
  return ApplyInverseBlueCorrection(tonemapped_ap1, config);
}

namespace extended {

float ComputeFilmicSlopeAtInput(const FilmToneMapConfig config, float input) {
  float epsilon = max(input * (1.f / 1024.f), 1e-5f);
  return (ApplyToneCurve(input + epsilon, config) - ApplyToneCurve(input - epsilon, config)) / (2.f * epsilon);
}

#define FILM_TONE_CURVE_EXTENDED_GENERATOR(T)                                    \
  T ApplyToneCurve(T untonemapped, T vanilla, const FilmToneMapConfig config) {  \
    const float pivot_input = 0.18f;                                             \
    const float pivot_output = 0.18f;                                            \
    float pivot_slope = ComputeFilmicSlopeAtInput(config, pivot_input);          \
    T extended_tail = pivot_slope * (untonemapped - pivot_input) + pivot_output; \
    return select(untonemapped < (T)pivot_input, vanilla, extended_tail);        \
  }
FILM_TONE_CURVE_EXTENDED_GENERATOR(float)
FILM_TONE_CURVE_EXTENDED_GENERATOR(float3)
#undef FILM_TONE_CURVE_EXTENDED_GENERATOR

}  // namespace extended

float3 ApplyExtended(float3 untonemapped_ap1, const FilmToneMapConfig config) {
  FilmToneMapConfig hdr_config = config;
  if (RENODX_TONE_MAP_OVERRIDE_BLACK_CLIP != 0.f) hdr_config.black_clip = 0.f;

  float3 blue_corrected_ap1 = ApplyBlueCorrection(untonemapped_ap1, hdr_config);
  float3 rrt_ap1 = ApplyRRT(blue_corrected_ap1);
  float3 vanilla_ap1 = ApplyToneCurve(rrt_ap1, hdr_config);
  float3 tonemapped_ap1 = extended::ApplyToneCurve(rrt_ap1, vanilla_ap1, hdr_config);
  tonemapped_ap1 = lerp(tonemapped_ap1, vanilla_ap1, 0.5f);

  float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION != 0.f) peak_ratio = renodx::color::correct::Gamma(peak_ratio, true);
  tonemapped_ap1 = renodx::tonemap::neutwo::PerChannel(max(0.f, tonemapped_ap1), peak_ratio, 100.f);

  tonemapped_ap1 = ApplyPostToneMapDesaturation(tonemapped_ap1);
  tonemapped_ap1 = ApplyToneCurveAmount(tonemapped_ap1, blue_corrected_ap1, hdr_config);
  tonemapped_ap1 = ApplyInverseBlueCorrection(tonemapped_ap1, hdr_config);
  return tonemapped_ap1;
}

}  // namespace filmtonemap
}  // namespace lutbuilder
}  // namespace unrealengine

#endif  // RENODX_UNREAL_LUT_BUILDER_FILM_TONE_MAP_HLSLI_