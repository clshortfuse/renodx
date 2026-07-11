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
  unrealengine::filmtonemap::Config film_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  return ApplyToneCurve(untonemapped, film_params);
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
  unrealengine::filmtonemap::Config film_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  float3 vanilla = unrealengine::filmtonemap::ApplyToneCurve(untonemapped, film_params);
  return ApplyToneCurveExtended(untonemapped, vanilla, film_params);
}

float3 ApplyToneCurveExtended(
    float3 untonemapped, float3 vanilla,
    float FilmSlope, float FilmToe, float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  unrealengine::filmtonemap::Config film_params = config::Create(FilmSlope, FilmToe, FilmShoulder, FilmBlackClip, FilmWhiteClip);
  return ApplyToneCurveExtended(untonemapped, vanilla, film_params);
}

}  // extended

}  // filmtonemap

}  // unrealengine

float3 ApplyToneCurveExtendedWithHermite(
    float3 untonemapped_rrt_prebluecorrect_ap1, float FilmSlope, float FilmToe,
    float FilmShoulder, float FilmBlackClip, float FilmWhiteClip) {
  float film_black_clip = FilmBlackClip;
  if (OVERRIDE_BLACK_CLIP) film_black_clip = 0.f;
  unrealengine::filmtonemap::Config film_params =
      unrealengine::filmtonemap::config::Create(FilmSlope, FilmToe, FilmShoulder, film_black_clip, FilmWhiteClip);

  float3 vanilla = unrealengine::filmtonemap::ApplyToneCurve(untonemapped_rrt_prebluecorrect_ap1, film_params);
  float3 tonemapped_prebluecorrect_ap1 =
      unrealengine::filmtonemap::extended::ApplyToneCurveExtended(untonemapped_rrt_prebluecorrect_ap1, vanilla, film_params);

  // Correct Hue/Chroma source colors

  float3 bt709_vanilla = renodx::color::bt709::from::AP1(vanilla);
  // Reinhard Piecewise Per-Channel to variable peak (default 5) on the extended color
  float3 bt709_per_ch = renodx::color::bt709::from::AP1(renodx::tonemap::ReinhardPiecewise(tonemapped_prebluecorrect_ap1, RENODX_TONE_MAP_PER_CH_PEAK, 0.18f));
  float3 bt709_hue_and_chrominance_source = bt709_per_ch;

  // Lerp Extended with vanilla based on ingame slider to dimm the scene
  // UE games are extremely bright, and lerping torwards vanilla helps reduce average picture brightness
  // Note: Vanilla is not clipped SDR

  // tonemapped_prebluecorrect_ap1 = lerp(
  //     vanilla,
  //     tonemapped_prebluecorrect_ap1,
  //     saturate(vanilla / 0.2f));

  tonemapped_prebluecorrect_ap1 = lerp(tonemapped_prebluecorrect_ap1,
                                       vanilla,
                                       saturate(lerp(0.75f, 0.f, saturate(BLEND_FACTOR))));

  // Map hue and chroma using the reference colors above on the final image
  // Mostly used for Max Channel displaymap to simulate blowout
  // LMS per-ch displaymapping can do just fine with no chroma/blowout, and just a bit of hue correction
  float3 bt709_tonemapped_prebluecorrect = renodx::color::bt709::from::AP1(tonemapped_prebluecorrect_ap1);

  float hue_shift_strength = RENODX_TONE_MAP_HUE_SHIFT;
  float chroma_correct_strength = RENODX_TONE_MAP_CHROMA_CORRECT_BLOWOUT;

  tonemapped_prebluecorrect_ap1 = renodx::color::ap1::from::BT709(HueAndChrominanceOKLab(bt709_tonemapped_prebluecorrect, bt709_hue_and_chrominance_source, saturate(hue_shift_strength), saturate(chroma_correct_strength), 1.0f));

  return tonemapped_prebluecorrect_ap1;
}

#endif  // INCLUDE_FILMTONEMAP