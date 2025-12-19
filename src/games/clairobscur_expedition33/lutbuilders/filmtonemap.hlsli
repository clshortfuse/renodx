#include "../shared.h"

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

#define FILMTONECURVE_GENERATOR(T)                                                                                                                                        \
  T ApplyToneCurve(T untonemapped, const Config p) {                                                                                                                      \
    T untonemapped_log = log2(untonemapped) * 0.3010300099849701f;                                                                                                        \
                                                                                                                                                                          \
    /* Straight */                                                                                                                                                        \
    T straight_curve = p.FilmSlope * (untonemapped_log + p.log_mid_anchor);                                                                                               \
                                                                                                                                                                          \
    /* Construct Toe and blend with Straight */                                                                                                                           \
    T toe_offset = untonemapped_log - p.log_toe_threshold;                                                                                                                \
    T toe_curve =                                                                                                                                                         \
        select((untonemapped_log < p.log_toe_threshold),                                                                                                                  \
               (((p.toe_width * 2.f) / (exp2((toe_offset * 1.4426950216293335f) * ((p.FilmSlope * -2.f) / p.toe_width)) + 1.f)) - p.FilmBlackClip),                       \
               straight_curve);                                                                                                                                           \
                                                                                                                                                                          \
    /* Construct Shoulder and blend with Straight */                                                                                                                      \
    T shoulder_offset = untonemapped_log - p.log_shoulder_threshold;                                                                                                      \
    T shoulder_curve =                                                                                                                                                    \
        select((untonemapped_log > p.log_shoulder_threshold),                                                                                                             \
               ((1.f + p.FilmWhiteClip) - ((p.shoulder_width * 2.f) / (exp2((shoulder_offset * 1.4426950216293335f) * ((p.FilmSlope * 2.f) / p.shoulder_width)) + 1.f))), \
               straight_curve);                                                                                                                                           \
                                                                                                                                                                          \
    /* Blend between Toe and Shoulder */                                                                                                                                  \
    T t_linear = saturate(toe_offset / (p.log_shoulder_threshold - p.log_toe_threshold));                                                                                 \
    T t_blend = select((p.log_shoulder_threshold < p.log_toe_threshold), (1.f - t_linear), t_linear);                                                                     \
    T film_tonemapped = (((t_blend * t_blend) * (shoulder_curve - toe_curve)) * (3.f - (t_blend * 2.f))) + toe_curve;                                                     \
                                                                                                                                                                          \
    return film_tonemapped;                                                                                                                                               \
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

#define FILMTONECURVE_EXTENDED_GENERATOR(T)                                  \
  T ApplyToneCurveExtended(T untonemapped, T vanilla, const Config p) {      \
    /* Evaluate Filmic at pivot */                                           \
    float pivot_input = 0.18f; /* tonemapper is centered around 0.18*/       \
    float y_offset = 0.18f;                                                  \
    float pivot_slope = ComputeFilmicSlopeAtInput(p, pivot_input);           \
                                                                             \
    /* Linear HDR tail anchored at (pivot_input, pivot_output) */            \
    T extended_tail = pivot_slope * (untonemapped - pivot_input) + y_offset; \
                                                                             \
    /* use vanilla below pivot, extended after*/                             \
    return select(untonemapped < (T)pivot_input, vanilla, extended_tail);    \
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

  if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {  // use luminance tonemap up to 0.18f
    float y_in = renodx::color::y::from::AP1(untonemapped_rrt_prebluecorrect_ap1);
    float y_out = unrealengine::filmtonemap::ApplyToneCurve(y_in, film_params);
    float3 vanilla_lum = renodx::color::correct::Luminance(untonemapped_rrt_prebluecorrect_ap1, y_in, y_out);

    vanilla_lum = lerp(vanilla_lum, vanilla, saturate(vanilla_lum / 0.18f));

    if (CUSTOM_COLOR_GRADE_SATURATION_CORRECTION != 1.f) {
      vanilla_lum = renodx::color::ap1::from::BT709(renodx::color::correct::Chrominance(
          renodx::color::bt709::from::AP1(vanilla_lum),
          renodx::color::bt709::from::AP1(vanilla), 1.f - CUSTOM_COLOR_GRADE_SATURATION_CORRECTION));
    }
    vanilla = vanilla_lum;
  }

#if 1
  tonemapped_prebluecorrect_ap1 = lerp(
      vanilla,
      lerp(tonemapped_prebluecorrect_ap1, vanilla, 0.2f),
      saturate(vanilla / 0.5f));
#else
  float lum_vanilla = renodx::color::y::from::AP1(vanilla);
  float lum_hdr = renodx::color::y::from::AP1(tonemapped_prebluecorrect_ap1);
  float blended_lum = lerp(lum_hdr, lum_vanilla, 0.2f);
  blended_lum = lerp(lum_vanilla, blended_lum, saturate(lum_vanilla / 0.75f));
  tonemapped_prebluecorrect_ap1 = renodx::color::correct::Luminance(tonemapped_prebluecorrect_ap1, lum_hdr, blended_lum);
#endif

  float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION) peak_ratio = renodx::color::correct::Gamma(peak_ratio, true);
  tonemapped_prebluecorrect_ap1 = renodx::tonemap::HermiteSplinePerChannelRolloff(max(0, tonemapped_prebluecorrect_ap1), peak_ratio, 100.f);

  return tonemapped_prebluecorrect_ap1;
}
