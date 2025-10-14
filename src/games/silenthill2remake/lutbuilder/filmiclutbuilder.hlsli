#include "./lutbuildercommon.hlsli"

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(hue_reference_color);

      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);

      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, config.hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, 0);

      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

/// Unreal Engine Filmic ToneMap based on ACES approximation with customizable parameters
/// Uses select() as it is from the SM6 version
#define UNREALFILMIC_GENERATOR(T)                                                                                                                                                                                                                                                            \
  T ApplyUnrealFilmicToneMap(T untonemapped) {                                                                                                                                                                                                                                               \
    float film_black_clip = FilmBlackClip;                                                                                                                                                                                                                                                   \
    if (OVERRIDE_BLACK_CLIP && RENODX_TONE_MAP_TYPE == 3.f && is_hdr) {                                                                                                                                                                                                                                \
      float target_black_nits = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;                                                                                                                                                                                                                         \
      if (RENODX_GAMMA_CORRECTION) target_black_nits = renodx::color::correct::Gamma(target_black_nits, true);                                                                                                                                                                               \
      film_black_clip = target_black_nits * -1.f;                                                                                                                                                                                                                                            \
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
  const float MID_GRAY_SCALE = ApplyUnrealFilmicToneMap(0.18f / EXPOSURE_SCALE) / (ACES_MID);

  aces_max /= MID_GRAY_SCALE;
  aces_min /= MID_GRAY_SCALE;

  untonemapped_ap1 *= EXPOSURE_SCALE;  // adjust exposure to match UE defaults, then allow midgray matching to adjust further based on parameters

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

  tonemapped_ap1 *= MID_GRAY_SCALE;

#else  // use ReinhardPiecewiseExtended instead of ACES
  const float EXPOSURE_SCALE = (0.8f);  // Narkowicz, which UE filmic is based on, adjusts exposure by 0.8x
  const float MID_GRAY_SCALE = ApplyUnrealFilmicToneMap(0.18f / EXPOSURE_SCALE) / (0.18f);
  float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    peak_ratio = renodx::color::correct::Gamma(peak_ratio, true);
  }
  peak_ratio /= MID_GRAY_SCALE;

  untonemapped_ap1 *= EXPOSURE_SCALE;
  float3 tonemapped_ap1 = renodx::tonemap::ReinhardPiecewiseExtended(untonemapped_ap1, 100.f, peak_ratio, 0.5f);
  tonemapped_ap1 *= MID_GRAY_SCALE;
#endif

  return tonemapped_ap1;
}

float3 ApplyPostToneMapDesaturation(float3 tonemapped) {
  float grayscale = renodx::color::y::from::AP1(tonemapped);
  return max(0.f, lerp(grayscale, tonemapped, 0.93f));
}

float3 LerpToneMapStrength(float3 tonemapped, float3 preRRT) {
  preRRT = min(100.f, preRRT);  // prevented artifacts during night vision in Robocop
  return lerp(preRRT, tonemapped, ToneCurveAmount);
}

float3 ApplyBlueCorrection(float3 tonemapped) {
  float _1131 = tonemapped.r, _1132 = tonemapped.g, _1133 = tonemapped.b;
  // return tonemapped;

  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * BlueCorrection) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * BlueCorrection) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * BlueCorrection) + _1133;
  return float3(_1149, _1150, _1151);
}

float3 ApplyUnrealFilmicToneMapByLuminance(float3 untonemapped, float3 preRRT) {
  float untonemapped_lum = renodx::color::y::from::AP1(untonemapped);
  float4 tonemaps = ApplyUnrealFilmicToneMap(float4(untonemapped, untonemapped_lum));
  float3 channel_tonemapped = tonemaps.xyz;
  float3 luminance_tonemapped = renodx::color::correct::Luminance(untonemapped, untonemapped_lum, tonemaps.a, 1.f);
  luminance_tonemapped = ApplyPostToneMapDesaturation(luminance_tonemapped);
  luminance_tonemapped = LerpToneMapStrength(luminance_tonemapped, preRRT);

  // blue correction has a massive effect on the final result, so we include before chrominance correction
  channel_tonemapped = ApplyPostToneMapDesaturation(channel_tonemapped);
  channel_tonemapped = LerpToneMapStrength(channel_tonemapped, preRRT);
  channel_tonemapped = ApplyBlueCorrection(channel_tonemapped);

  channel_tonemapped = renodx::color::bt709::from::AP1(max(0, channel_tonemapped));
  luminance_tonemapped = renodx::color::bt709::from::AP1(max(0, luminance_tonemapped));

  float3 final = renodx::color::correct::ChrominanceOKLab(luminance_tonemapped, channel_tonemapped);

  return renodx::color::ap1::from::BT709(final);
}

float3 ApplyVanillaToneMap(float3 untonemapped, float3 preRRT) {
  float3 tonemapped;
  if (RENODX_TONE_MAP_PER_CHANNEL || RENODX_TONE_MAP_TYPE == 4.f) {
    tonemapped = ApplyUnrealFilmicToneMap(untonemapped);
    tonemapped = ApplyPostToneMapDesaturation(tonemapped);
    tonemapped = LerpToneMapStrength(tonemapped, preRRT);
    tonemapped = ApplyBlueCorrection(tonemapped);
  } else {
    tonemapped = ApplyUnrealFilmicToneMapByLuminance(untonemapped, preRRT);
  }
  return tonemapped;
}

float3 ApplyVanillaToneMapSDR(float3 untonemapped, float3 preRRT) {
  float3 tonemapped = ApplyUnrealFilmicToneMap(untonemapped);
  tonemapped = ApplyPostToneMapDesaturation(tonemapped);
  tonemapped = LerpToneMapStrength(tonemapped, preRRT);
  tonemapped = ApplyBlueCorrection(tonemapped);

  return tonemapped;
}

void ApplyFilmicToneMap(
    float input_r,
    float input_g,
    float input_b,
    float preRRT_r,
    float preRRT_g,
    float preRRT_b,
    inout float output_r,
    inout float output_g,
    inout float output_b) {
  float _827 = preRRT_r, _828 = preRRT_g, _829 = preRRT_b;
  float3 tonemapped;
  float3 untonemapped_pre_grade = float3(input_r, input_g, input_b);

  if (!is_hdr) {  // if SDR, just apply vanilla tone map with no grading
    tonemapped = ApplyVanillaToneMapSDR(untonemapped_pre_grade, float3(preRRT_r, preRRT_g, preRRT_b));
    output_r = tonemapped.r, output_g = tonemapped.g, output_b = tonemapped.b;
    return;
  }

  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  float untonemapped_lum = renodx::color::y::from::AP1(untonemapped_pre_grade);
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  float3 untonemapped = untonemapped_pre_grade;
  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_pre_grade, untonemapped_lum, cg_config);
  }

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // ACES
    tonemapped = ApplyACES(untonemapped);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    tonemapped = LerpToneMapStrength(untonemapped, float3(preRRT_r, preRRT_g, preRRT_b));
  } else {
    tonemapped = ApplyVanillaToneMap(untonemapped, float3(preRRT_r, preRRT_g, preRRT_b));
    if (RENODX_TONE_MAP_TYPE == 3.f) {  // run the same steps on ACES but without desaturation and blue correction
      float3 hdr_tonemapped = ApplyACES(untonemapped);
      hdr_tonemapped = LerpToneMapStrength(hdr_tonemapped, float3(preRRT_r, preRRT_g, preRRT_b));
      const float blend_factor = renodx::color::y::from::AP1(tonemapped);
      tonemapped = lerp(tonemapped, hdr_tonemapped, saturate(blend_factor));
    }
  }

  tonemapped = max(0, tonemapped);

  if (RENODX_TONE_MAP_TYPE != 4.f && RENODX_TONE_MAP_TYPE != 0.f) {
    tonemapped = renodx::color::ap1::from::BT709(ApplySaturationBlowoutHueCorrectionHighlightSaturation(renodx::color::bt709::from::AP1(tonemapped), renodx::color::bt709::from::AP1(LerpToneMapStrength(untonemapped, float3(preRRT_r, preRRT_g, preRRT_b))), untonemapped_lum, cg_config));
  }

  output_r = tonemapped.r, output_g = tonemapped.g, output_b = tonemapped.b;
  return;
}
