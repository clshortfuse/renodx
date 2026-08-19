#ifndef INCLUDE_FILMTONEMAP
#define INCLUDE_FILMTONEMAP

#include "../shared.h"
#include "./lutbuildercommon.hlsli"

namespace unrealengine {

namespace filmtonemap {

struct Config {
  // UE parameters
  float FilmSlope;
  float FilmToe;
  float FilmShoulder;
  float FilmBlackClip;
  float FilmWhiteClip;

  // Derived values
  float toe_width;
  float shoulder_width;

  float log_toe_threshold;
  float log_mid_anchor;
  float log_shoulder_threshold;
};

namespace config {

Config Create(
    float FilmSlope,
    float FilmToe,
    float FilmShoulder,
    float FilmBlackClip,
    float FilmWhiteClip) {
  Config p;
  p.FilmSlope = FilmSlope;
  p.FilmToe = FilmToe;
  p.FilmShoulder = FilmShoulder;
  p.FilmBlackClip = FilmBlackClip;
  p.FilmWhiteClip = FilmWhiteClip;

  p.toe_width = (FilmBlackClip + 1.0f) - FilmToe;
  p.shoulder_width = (FilmWhiteClip + 1.0f) - FilmShoulder;
  if (FilmToe > 0.8) {
    p.log_toe_threshold = (((0.82 - FilmToe) / FilmSlope) - 0.7447274923324585f);
  } else {
    float toe_norm = (FilmBlackClip + 0.18) / p.toe_width;
    p.log_toe_threshold = (-0.7447274923324585f - ((log2(toe_norm / (2.0f - toe_norm)) * 0.3465735912322998f) * (p.toe_width / FilmSlope)));
  }

  p.log_mid_anchor = ((1.0f - FilmToe) / FilmSlope) - p.log_toe_threshold;
  p.log_shoulder_threshold = (FilmShoulder / FilmSlope) - p.log_mid_anchor;

  return p;
}

}  // config

#define FILMTONECURVE_GENERATOR(T)                                                                                                                                                      \
  T ApplyToneCurve(T untonemapped, const Config p) {                                                                                                                                    \
    T untonemapped_log = log2(untonemapped) * 0.3010300099849701f;                                                                                                                      \
                                                                                                                                                                                        \
    /* Straight */                                                                                                                                                                      \
    T straight_curve = p.FilmSlope * (untonemapped_log + p.log_mid_anchor);                                                                                                             \
                                                                                                                                                                                        \
    /* Construct Toe and blend with Straight */                                                                                                                                         \
    T toe_offset = untonemapped_log - p.log_toe_threshold;                                                                                                                              \
    T toe_curve =                                                                                                                                                                       \
        renodx::math::Select((untonemapped_log < p.log_toe_threshold),                                                                                                                  \
                             (((p.toe_width * 2.f) / (exp2((toe_offset * 1.4426950216293335f) * ((p.FilmSlope * -2.f) / p.toe_width)) + 1.f)) - p.FilmBlackClip),                       \
                             straight_curve);                                                                                                                                           \
                                                                                                                                                                                        \
    /* Construct Shoulder and blend with Straight */                                                                                                                                    \
    T shoulder_offset = untonemapped_log - p.log_shoulder_threshold;                                                                                                                    \
    T shoulder_curve =                                                                                                                                                                  \
        renodx::math::Select((untonemapped_log > p.log_shoulder_threshold),                                                                                                             \
                             ((1.f + p.FilmWhiteClip) - ((p.shoulder_width * 2.f) / (exp2((shoulder_offset * 1.4426950216293335f) * ((p.FilmSlope * 2.f) / p.shoulder_width)) + 1.f))), \
                             straight_curve);                                                                                                                                           \
                                                                                                                                                                                        \
    /* Blend between Toe and Shoulder */                                                                                                                                                \
    T t_linear = saturate(toe_offset / (p.log_shoulder_threshold - p.log_toe_threshold));                                                                                               \
    T t_blend = renodx::math::Select((p.log_shoulder_threshold < p.log_toe_threshold), (1.f - t_linear), t_linear);                                                                     \
    T film_tonemapped = (((t_blend * t_blend) * (shoulder_curve - toe_curve)) * (3.f - (t_blend * 2.f))) + toe_curve;                                                                   \
                                                                                                                                                                                        \
    return film_tonemapped;                                                                                                                                                             \
  }
FILMTONECURVE_GENERATOR(float)
FILMTONECURVE_GENERATOR(float3)
#undef FILMTONECURVE_GENERATOR

float3 ApplyToneCurve(
    float3 untonemapped,
    float FilmSlope, float FilmToe, float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  unrealengine::filmtonemap::Config filmic_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  return ApplyToneCurve(untonemapped, filmic_params);
}

namespace extended {

float ComputeFilmicSlopeAtInput(const Config p, float x) {
  // Scale epsilon with x so it works for very small or big inputs
  float eps = max(x * (1.0f / 1024.0f), 1e-5f);

  float y_minus = ApplyToneCurve(x - eps, p);
  float y_plus = ApplyToneCurve(x + eps, p);

  return (y_plus - y_minus) / (2.0f * eps);
}

#define FILMTONECURVE_EXTENDED_GENERATOR(T)                                             \
  T ApplyToneCurveExtended(T untonemapped, T vanilla, const Config p) {                 \
    /* Evaluate Filmic at pivot */                                                      \
    float pivot_input = 0.18f; /* tonemapper is centered around 0.18*/                  \
    float y_offset = 0.18f;                                                             \
    float pivot_slope = ComputeFilmicSlopeAtInput(p, pivot_input);                      \
                                                                                        \
    /* Linear HDR tail anchored at (pivot_input, pivot_output) */                       \
    T extended_tail = pivot_slope * (untonemapped - pivot_input) + y_offset;            \
                                                                                        \
    /* use vanilla below pivot, extended after*/                                        \
    return renodx::math::Select(untonemapped < (T)pivot_input, vanilla, extended_tail); \
  }
FILMTONECURVE_EXTENDED_GENERATOR(float)
FILMTONECURVE_EXTENDED_GENERATOR(float3)
#undef FILMTONECURVE_EXTENDED_GENERATOR

float3 ApplyToneCurveExtended(
    float3 untonemapped,
    float FilmSlope, float FilmToe, float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  unrealengine::filmtonemap::Config filmic_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  float3 vanilla = unrealengine::filmtonemap::ApplyToneCurve(untonemapped, filmic_params);
  return ApplyToneCurveExtended(untonemapped, vanilla, filmic_params);
}

float3 ApplyToneCurveExtended(
    float3 untonemapped, float3 vanilla,
    float FilmSlope, float FilmToe, float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  unrealengine::filmtonemap::Config filmic_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  return ApplyToneCurveExtended(untonemapped, vanilla, filmic_params);
}

}  // extended

}  // filmtonemap

}  // unrealengine

// input: blue-corrected AP1 linear
// output: blue-corrected AP1 linear
float3 ApplyExtendedToneCurveMaxChannel(
    float3 tonemapped_blue_corrected_ap1,
    float3 vanilla_blue_corrected_ap1,
    float blue_correction) {
  // Max Channel display mapping uses this reference to simulate hue/chroma blowout.
  float3 bt709_hue_and_chrominance_source = BT709FromBlueCorrectedAP1(
      renodx::tonemap::ReinhardPiecewise(tonemapped_blue_corrected_ap1, RENODX_TONE_MAP_PER_CH_PEAK, 0.18f),
      blue_correction);

  // UE games are extremely bright, and lerping toward vanilla helps reduce average picture brightness.
  tonemapped_blue_corrected_ap1 = lerp(
      tonemapped_blue_corrected_ap1,
      vanilla_blue_corrected_ap1,
      saturate(lerp(0.75f, 0.f, saturate(BLEND_FACTOR))));

  float3 bt709_tonemapped = BT709FromBlueCorrectedAP1(tonemapped_blue_corrected_ap1, blue_correction);
  return BlueCorrectedAP1FromBT709(
      HueAndChrominance(
          bt709_tonemapped,
          bt709_hue_and_chrominance_source,
          saturate(RENODX_TONE_MAP_HUE_SHIFT),
          saturate(RENODX_TONE_MAP_CHROMA_CORRECT_BLOWOUT),
          1.f),
      blue_correction);
}

// input: blue-corrected AP1 linear
// output: blue-corrected AP1 linear
float3 ApplyExtendedToneCurveAP1(
    float3 tonemapped_blue_corrected_ap1,
    float3 vanilla_blue_corrected_ap1) {
  return lerp(
      tonemapped_blue_corrected_ap1,
      vanilla_blue_corrected_ap1,
      saturate(lerp(0.75f, 0.f, saturate(BLEND_FACTOR))));
}

// input: white-normalized LMS linear
// output: white-normalized LMS linear
float3 ApplyExtendedToneCurveLMS(
    float3 untonemapped_lms_normalized,
    unrealengine::filmtonemap::Config filmic_params) {
  // LMS goes really wide when ran through a filmic tm
  // So we sanitize the input and output with max(1e-7f,)
  untonemapped_lms_normalized = max(untonemapped_lms_normalized, 1e-7f);

  // AP1 clamp is needed to prevent NaNs. Emulates RRT clamping behavior.
  float3 clamped_ap1 = clamp(
      renodx::color::ap1::from::LMS(
          untonemapped_lms_normalized * RENODX_BT709_LMS_WHITE),
      0.f,
      renodx::math::FLT16_MAX);
  float3 curve_input_lms_normalized =
      renodx::color::lms::from::AP1(clamped_ap1) / RENODX_BT709_LMS_WHITE;
  float3 vanilla_lms_normalized = unrealengine::filmtonemap::ApplyToneCurve(
      curve_input_lms_normalized,
      filmic_params);
  float3 tonemapped_lms_normalized = unrealengine::filmtonemap::extended::ApplyToneCurveExtended(
      curve_input_lms_normalized,
      vanilla_lms_normalized,
      filmic_params);

  tonemapped_lms_normalized = max(tonemapped_lms_normalized, 1e-7f);

  return RestorePsychoHueAndCompressLMS(
      curve_input_lms_normalized,
      lerp(
          tonemapped_lms_normalized,
          vanilla_lms_normalized,
          saturate(lerp(0.75f, 0.f, saturate(BLEND_FACTOR)))),
      RENODX_TONE_MAP_HUE_RESTORE);
}

// input: RRT value in blue-corrected AP1 linear
// output: blue-corrected AP1 linear
float3 ApplyToneCurveExtendedWithHermite(
    float3 untonemapped_rrt_blue_corrected_ap1,
    float blue_correction,
    float FilmSlope,
    float FilmToe,
    float FilmShoulder,
    float FilmBlackClip,
    float FilmWhiteClip) {
  float filmic_black_clip = FilmBlackClip;
  if (OVERRIDE_BLACK_CLIP) filmic_black_clip = 0.f;
  unrealengine::filmtonemap::Config filmic_params =
      unrealengine::filmtonemap::config::Create(FilmSlope, FilmToe, FilmShoulder, filmic_black_clip, FilmWhiteClip);

  float3 vanilla_blue_corrected_ap1 = unrealengine::filmtonemap::ApplyToneCurve(
      untonemapped_rrt_blue_corrected_ap1,
      filmic_params);
  float3 tonemapped_blue_corrected_ap1 = unrealengine::filmtonemap::extended::ApplyToneCurveExtended(
      untonemapped_rrt_blue_corrected_ap1,
      vanilla_blue_corrected_ap1,
      filmic_params);

  if (RENODX_TONE_MAP_SCALING == 0.f) {
    return ApplyExtendedToneCurveMaxChannel(
        tonemapped_blue_corrected_ap1,
        vanilla_blue_corrected_ap1,
        blue_correction);
  }
  return ApplyExtendedToneCurveAP1(
      tonemapped_blue_corrected_ap1,
      vanilla_blue_corrected_ap1);
}

#endif  // INCLUDE_FILMTONEMAP