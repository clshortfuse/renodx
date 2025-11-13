#ifndef FILMIC_LUTBUILDER_HLSLI
#define FILMIC_LUTBUILDER_HLSLI

#include "./CBuffers_LUTbuilder.hlsli"
#include "./colorgradingLUT.hlsli"
#include "./lutbuildercommon.hlsli"

/// Unreal Engine Filmic ToneMap based on ACES approximation with customizable parameters
#define UNREALFILMIC_GENERATOR(T)                                                                                                                                                                                                                                                            \
  T ApplyUnrealFilmicToneMapCurve(T untonemapped) {                                                                                                                                                                                                                                          \
    float film_black_clip = FilmBlackClip;                                                                                                                                                                                                                                                   \
    if (OVERRIDE_BLACK_CLIP && RENODX_TONE_MAP_TYPE == 3.f) {                                                                                                                                                                                                                                \
      film_black_clip = 0.f;                                                                                                                                                                                                                                            \
    }                                                                                                                                                                                                                                                                                        \
    float film_white_clip = FilmWhiteClip;                                                                                                                                                                                                                                                   \
                                                                                                                                                                                                                                                                                             \
    T _1007_1008_1009 = log2(untonemapped) * 0.3010300099849701f;                                                                                                                                                                                                                            \
    float _976 = (film_black_clip + 1.0f) - FilmToe;                                                                                                                                                                                                                                         \
    float _978 = film_white_clip + 1.0f;                                                                                                                                                                                                                                                     \
    float _980 = _978 - FilmShoulder;                                                                                                                                                                                                                                                        \
    float _998;                                                                                                                                                                                                                                                                              \
    if (FilmToe > 0.800000011920929f) {                                                                                                                                                                                                                                                      \
      _998 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);                                                                                                                                                                                                         \
    } else {                                                                                                                                                                                                                                                                                 \
      float _989 = (film_black_clip + 0.18000000715255737f) / _976;                                                                                                                                                                                                                          \
      _998 = (-0.7447274923324585f - ((log2(_989 / (2.0f - _989)) * 0.3465735912322998f) * (_976 / FilmSlope)));                                                                                                                                                                             \
    }                                                                                                                                                                                                                                                                                        \
    float _1001 = ((1.0f - FilmToe) / FilmSlope) - _998;                                                                                                                                                                                                                                     \
    float _1003 = (FilmShoulder / FilmSlope) - _1001;                                                                                                                                                                                                                                        \
    T _1013_1014_1015 = FilmSlope * (_1007_1008_1009 + _1001);                                                                                                                                                                                                                               \
    float _1016 = _976 * 2.0f;                                                                                                                                                                                                                                                               \
    float _1018 = (FilmSlope * -2.0f) / _976;                                                                                                                                                                                                                                                \
    T _1019_1020_1021 = _1007_1008_1009 - _998;                                                                                                                                                                                                                                              \
    float _1040 = _980 * 2.0f;                                                                                                                                                                                                                                                               \
    float _1042 = (FilmSlope * 2.0f) / _980;                                                                                                                                                                                                                                                 \
    T _1067_1068_1069 = select((_1007_1008_1009 < _998), ((_1016 / (exp2((_1019_1020_1021 * 1.4426950216293335f) * _1018) + 1.0f)) - film_black_clip), _1013_1014_1015);                                                                                                                     \
    float _1076 = _1003 - _998;                                                                                                                                                                                                                                                              \
    T _1080_1081_1082 = saturate(_1019_1020_1021 / _1076);                                                                                                                                                                                                                                   \
    bool _1083 = (_1003 < _998);                                                                                                                                                                                                                                                             \
    T _1087_1088_1089 = select(_1083, (1.0f - _1080_1081_1082), _1080_1081_1082);                                                                                                                                                                                                            \
    T _1108_1109_1110 = (((_1087_1088_1089 * _1087_1088_1089) * (select((_1007_1008_1009 > _1003), (_978 - (_1040 / (exp2(((_1007_1008_1009 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1013_1014_1015) - _1067_1068_1069)) * (3.0f - (_1087_1088_1089 * 2.0f))) + _1067_1068_1069; \
                                                                                                                                                                                                                                                                                             \
    return _1108_1109_1110;                                                                                                                                                                                                                                                                  \
  }
UNREALFILMIC_GENERATOR(float)
UNREALFILMIC_GENERATOR(float3)
UNREALFILMIC_GENERATOR(float4)
#undef UNREALFILMIC_GENERATOR

float3 ApplyACES(float3 untonemapped_ap1) {
#if 1
  const float ACES_MID = 0.1f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }

  const float EXPOSURE_SCALE = (1.62f);  // UE Filmic with default params matches ACES with 1.62x exposure (found using Desmos)
  const float MID_GRAY_SCALE = ApplyUnrealFilmicToneMapCurve(0.18f / EXPOSURE_SCALE) / (ACES_MID);

  aces_max /= MID_GRAY_SCALE;
  aces_min /= MID_GRAY_SCALE;

  untonemapped_ap1 *= EXPOSURE_SCALE;  // adjust exposure to match UE defaults, then allow midgray matching to adjust further based on parameters

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

  tonemapped_ap1 *= MID_GRAY_SCALE;

#else  // use ReinhardPiecewiseExtended instead of ACES
  const float EXPOSURE_SCALE = (1.f);  // Narkowicz, which UE filmic is based on, adjusts exposure by 0.8x
  const float MID_GRAY_SCALE = ApplyUnrealFilmicToneMapCurve(0.18f / EXPOSURE_SCALE) / (0.18f);
  float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    peak_ratio = renodx::color::correct::Gamma(peak_ratio, true);
  }
  peak_ratio /= MID_GRAY_SCALE;

  untonemapped_ap1 *= EXPOSURE_SCALE;
  float3 tonemapped_ap1 = renodx::tonemap::HermiteSplinePerChannelRolloff(untonemapped_ap1, peak_ratio, 100.f);
  tonemapped_ap1 *= MID_GRAY_SCALE;
#endif

  return tonemapped_ap1;
}

float3 ApplyPostToneMapDesaturation(float3 tonemapped) {
  float grayscale = renodx::color::y::from::AP1(tonemapped);
  return max(0.f, lerp(grayscale, tonemapped, 0.93f));
}

float3 LerpToneMapStrength(float3 tonemapped, float3 preRRT) {
  preRRT = min(100.f, preRRT);  // prevents artifacts during night vision
  return lerp(preRRT, tonemapped, ToneCurveAmount);
}

// AP1 -> AP0 -> Blue Corrected AP0 -> AP1
float3 ApplyBlueCorrectionPre(float3 untonemapped_ap1) {
  float r = untonemapped_ap1.r, g = untonemapped_ap1.g, b = untonemapped_ap1.b;

  float corrected_r = ((mad(0.061360642313957214f, b, mad(-4.540197551250458e-09f, g, (r * 0.9386394023895264f))) - r) * BlueCorrection) + r;
  float corrected_g = ((mad(0.169205904006958f, b, mad(0.8307942152023315f, g, (r * 6.775371730327606e-08f))) - g) * BlueCorrection) + g;
  float corrected_b = (mad(-2.3283064365386963e-10f, g, (r * -9.313225746154785e-10f)) * BlueCorrection) + b;

  return float3(corrected_r, corrected_g, corrected_b);
}

float3 ApplyBlueCorrectionPost(float3 tonemapped) {
  float _1131 = tonemapped.r, _1132 = tonemapped.g, _1133 = tonemapped.b;
  // return tonemapped;

  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * BlueCorrection) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * BlueCorrection) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * BlueCorrection) + _1133;
  return float3(_1149, _1150, _1151);
}

float3 CorrectChrominanceAP1(float3 original_color_ap1, float3 chrominance_reference_color_ap1, float strength = 1.f, float clamp_chrominance_loss = 0.f) {
  if (strength == 0.f) return original_color_ap1;

  float3 original_color_bt709 = renodx::color::bt709::from::AP1(original_color_ap1);
  float3 chrominance_reference_color_bt709 = renodx::color::bt709::from::AP1(chrominance_reference_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Chrominance(
      original_color_bt709,
      chrominance_reference_color_bt709,
      strength,
      clamp_chrominance_loss);

  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  corrected_color_ap1 = max(0, corrected_color_ap1);

  return corrected_color_ap1;
}

float3 CorrectHueAP1(float3 original_color_ap1, float3 hue_reference_color_ap1, float strength = 1.f, float clamp_chrominance_loss = 0.f) {
  if (strength == 0.f) return original_color_ap1;

  float3 original_color_bt709 = renodx::color::bt709::from::AP1(original_color_ap1);
  float3 hue_reference_color_bt709 = renodx::color::bt709::from::AP1(hue_reference_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(
      original_color_bt709,
      hue_reference_color_bt709,
      strength,
      0u);

  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  corrected_color_ap1 = max(0, corrected_color_ap1);

  return corrected_color_ap1;
}

// ACES with
// Mid-Gray Matching with Unreal Filmic
// Output Display Transform
float3 ACESMidGrayMatchedODT(float3 untonemapped_ap1_rrt) {
  // RRT + ODT with midgray match
  float3 hdr_tonemapped_ap1 = ApplyACES(untonemapped_ap1_rrt);

  return hdr_tonemapped_ap1;
}

void ApplyFilmToneMapWithBlueCorrect(float untonemapped_r, float untonemapped_g, float untonemapped_b,
                                     inout float tonemapped_r, inout float tonemapped_g, inout float tonemapped_b) {
  float3 untonemapped_ap1 = float3(untonemapped_r, untonemapped_g, untonemapped_b);
  renodx::color::grade::Config cg_config = CreateColorGradingConfig();
  float y = renodx::color::y::from::AP1(untonemapped_ap1);
  float3 hue_reference_color = untonemapped_ap1;

  float3 untonemapped_ap1_graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_ap1, y, cg_config, 0.18f);

  float3 tonemapped_ap1;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    tonemapped_ap1 = untonemapped_ap1_graded;
  } else if (RENODX_TONE_MAP_TYPE == 2.f) {  // ACES
    float3 RRT_AP1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1_graded));
    float3 ACES_AP1 = ACESMidGrayMatchedODT(RRT_AP1);
    tonemapped_ap1 = ACES_AP1;

  } else {  // Vanilla+ and UE Filmic

    float3 untonemapped_prebluecorrect_ap1 = ApplyBlueCorrectionPre(untonemapped_ap1_graded);
    float3 untonemapped_rrt_prebluecorrect_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_prebluecorrect_ap1));

    float3 tonemapped_prebluecorrect_ap1 = ApplyUnrealFilmicToneMapCurve(untonemapped_rrt_prebluecorrect_ap1);

    if (RENODX_TONE_MAP_TYPE != 4.f) {  // Vanilla+
      float3 hdr_tonemapped_prebluecorrect_ap1 = ACESMidGrayMatchedODT(untonemapped_rrt_prebluecorrect_ap1);

      const float hdr_blend_factor = saturate(renodx::color::y::from::AP1(tonemapped_prebluecorrect_ap1));
      tonemapped_prebluecorrect_ap1 = lerp(tonemapped_prebluecorrect_ap1, hdr_tonemapped_prebluecorrect_ap1, hdr_blend_factor);
    }

    tonemapped_prebluecorrect_ap1 = ApplyPostToneMapDesaturation(tonemapped_prebluecorrect_ap1);
    tonemapped_prebluecorrect_ap1 = LerpToneMapStrength(tonemapped_prebluecorrect_ap1, untonemapped_ap1_graded);
    tonemapped_ap1 = ApplyBlueCorrectionPost(tonemapped_prebluecorrect_ap1);
    tonemapped_ap1 = max(0, tonemapped_ap1);

    if (RENODX_TONE_MAP_PER_CHANNEL == 0.f && RENODX_TONE_MAP_TYPE != 4.f) {
      float3 hue_corrected_ap1 = CorrectHueAP1(tonemapped_ap1, hue_reference_color);
      const float hue_corrected_blend_factor = saturate(renodx::color::y::from::AP1(tonemapped_ap1) / 0.6f);
      tonemapped_ap1 = lerp(hue_corrected_ap1, tonemapped_ap1, hue_corrected_blend_factor);
    }
  }

  tonemapped_ap1 = max(0, tonemapped_ap1);

  tonemapped_ap1 = ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(tonemapped_ap1, hue_reference_color, y, cg_config);

  tonemapped_r = tonemapped_ap1.r, tonemapped_g = tonemapped_ap1.g, tonemapped_b = tonemapped_ap1.b;

  return;
}

#endif // FILMIC_LUTBUILDER_HLSLI