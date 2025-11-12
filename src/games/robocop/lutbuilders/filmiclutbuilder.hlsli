#include "./lutbuildercommon.hlsli"

cbuffer _RootShaderParameters : register(b0) {
  float4 LUTWeights[2] : packoffset(c005.x);
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float4 OverlayColor : packoffset(c013.x);
  float3 ColorScale : packoffset(c014.x);
  float4 ColorSaturation : packoffset(c015.x);
  float4 ColorContrast : packoffset(c016.x);
  float4 ColorGamma : packoffset(c017.x);
  float4 ColorGain : packoffset(c018.x);
  float4 ColorOffset : packoffset(c019.x);
  float4 ColorSaturationShadows : packoffset(c020.x);
  float4 ColorContrastShadows : packoffset(c021.x);
  float4 ColorGammaShadows : packoffset(c022.x);
  float4 ColorGainShadows : packoffset(c023.x);
  float4 ColorOffsetShadows : packoffset(c024.x);
  float4 ColorSaturationMidtones : packoffset(c025.x);
  float4 ColorContrastMidtones : packoffset(c026.x);
  float4 ColorGammaMidtones : packoffset(c027.x);
  float4 ColorGainMidtones : packoffset(c028.x);
  float4 ColorOffsetMidtones : packoffset(c029.x);
  float4 ColorSaturationHighlights : packoffset(c030.x);
  float4 ColorContrastHighlights : packoffset(c031.x);
  float4 ColorGammaHighlights : packoffset(c032.x);
  float4 ColorGainHighlights : packoffset(c033.x);
  float4 ColorOffsetHighlights : packoffset(c034.x);
  float LUTSize : packoffset(c035.x);
  float WhiteTemp : packoffset(c035.y);
  float WhiteTint : packoffset(c035.z);
  float ColorCorrectionShadowsMax : packoffset(c035.w);
  float ColorCorrectionHighlightsMin : packoffset(c036.x);
  float ColorCorrectionHighlightsMax : packoffset(c036.y);
  float BlueCorrection : packoffset(c036.z);
  float ExpandGamut : packoffset(c036.w);
  float ToneCurveAmount : packoffset(c037.x);
  float FilmSlope : packoffset(c037.y);
  float FilmToe : packoffset(c037.z);
  float FilmShoulder : packoffset(c037.w);
  float FilmBlackClip : packoffset(c038.x);
  float FilmWhiteClip : packoffset(c038.y);
  uint bUseMobileTonemapper : packoffset(c038.z);
  uint bIsTemperatureWhiteBalance : packoffset(c038.w);
  float3 MappingPolynomial : packoffset(c039.x);
  float3 InverseGamma : packoffset(c040.x);
  uint OutputDevice : packoffset(c040.w);
  uint OutputGamut : packoffset(c041.x);
  float OutputMaxLuminance : packoffset(c041.y);
};

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    // value = max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), x));
    return max(x,
               lerp(x, mid_gray * pow(x / mid_gray, highlights),
                    renodx::tonemap::ExponentialRollOff(x, 1.f, 1.1f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1.f
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

// highlights
#if 0
  // const float highlights = 1 + (sign(config.highlights - 1) * pow(abs(config.highlights - 1), 10.f));
  // float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);
#else
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
#endif
  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

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

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturationAP1(float3 tonemapped, float3 hue_reference_color, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(renodx::color::bt709::from::AP1(color));

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(renodx::color::bt709::from::AP1(hue_reference_color));

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

    color = renodx::color::ap1::from::BT709(color);
    color = max(0, color);
  }
  return color;
}

/// Unreal Engine Filmic ToneMap based on ACES approximation with customizable parameters
#define UNREALFILMIC_GENERATOR(T)                                                                                                                                                                                                                                                            \
  T ApplyUnrealFilmicToneMapCurve(T untonemapped) {                                                                                                                                                                                                                                          \
    float film_black_clip = FilmBlackClip;                                                                                                                                                                                                                                                   \
    if (OVERRIDE_BLACK_CLIP && RENODX_TONE_MAP_TYPE == 3.f) {                                                                                                                                                                                                                                \
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

float3 ApplyUnrealFilmicToneMapByLuminance(float3 untonemapped, float3 preRRT) {
  float untonemapped_lum = renodx::color::y::from::AP1(untonemapped);
  float4 tonemaps = ApplyUnrealFilmicToneMapCurve(float4(untonemapped, untonemapped_lum));
  float3 channel_tonemapped = tonemaps.xyz;
  float3 luminance_tonemapped = renodx::color::correct::Luminance(untonemapped, untonemapped_lum, tonemaps.a, 1.f);

  // blue correction has a massive effect on the final result, so we include before chrominance correction
  channel_tonemapped = ApplyPostToneMapDesaturation(channel_tonemapped);
  channel_tonemapped = LerpToneMapStrength(channel_tonemapped, preRRT);
  channel_tonemapped = ApplyBlueCorrectionPost(channel_tonemapped);

  luminance_tonemapped = ApplyPostToneMapDesaturation(luminance_tonemapped);
  luminance_tonemapped = LerpToneMapStrength(luminance_tonemapped, preRRT);

  // added max(0, color) as negatives are clamped later but we need to clamp early for chrominance correction
  return renodx::color::correct::ChrominanceOKLab(luminance_tonemapped, max(0, channel_tonemapped));
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

renodx::color::grade::Config CreateColorGradingConfig() {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = RENODX_TONE_MAP_HUE_CORRECTION;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  return cg_config;
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
    tonemapped_ap1 = untonemapped_ap1;
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

/// Piecewise linear + exponential compression to a target value starting from a specified number.
/// https://www.ea.com/frostbite/news/high-dynamic-range-color-grading-and-display-in-frostbite
#define EXPONENTIALROLLOFF_GENERATOR(T)                                                                            \
  T ExponentialRollOffExtended(T input, float rolloff_start = 0.20f, float output_max = 1.f, float clip = 100.f) { \
    T rolloff_size = output_max - rolloff_start;                                                                   \
    T overage = -max((T)0, input - rolloff_start);                                                                 \
    T clip_size = rolloff_start - clip;                                                                            \
    T rolloff_value = (T)1.0f - exp(overage / rolloff_size);                                                       \
    T clip_value = (T)1.0f - exp(clip_size / rolloff_size);                                                        \
    T new_overage = mad(rolloff_size, rolloff_value / clip_value, overage);                                        \
    return input + new_overage;                                                                                    \
  }
EXPONENTIALROLLOFF_GENERATOR(float)
EXPONENTIALROLLOFF_GENERATOR(float3)
#undef EXPONENTIALROLLOFF_GENERATOR

/// Applies Exponential Roll-Off Extended tonemapping by luminance.
float3 LUTToneMap(float3 untonemapped, float rolloff_start = 0.5f, float output_max = 1.f) {
  float clip = 100.f;
  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = exp2(ExponentialRollOffExtended(
      log2(y_in),
      log2(rolloff_start),
      log2(output_max),
      log2(clip)));
  float3 tonemapped = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

  return tonemapped;
}

float ComputeGamutCompressionScale(float3 color) {
  float gamut_compression_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float grayscale = renodx::color::y::from::BT709(color);
    gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(color.rgb, grayscale);
    color = renodx::color::correct::GamutCompress(color, grayscale, gamut_compression_scale);
  }
  return gamut_compression_scale;
}

float ComputeMaxChannelScale(float3 color) {
  float channel_compression_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    channel_compression_scale = renodx::math::Max(color.r, color.g, color.b, 1.f);
  }
  return channel_compression_scale;
}

float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture) {
  float gamut_compression_scale = 1.f;

  if (CUSTOM_LUT_GAMUT_RESTORATION != 0.f) {
    const float grayscale = (renodx::color::y::from::BT709(max(0, color_srgb)));  // have to clamp negatives before for some reason
    gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(color_srgb, grayscale);
    color_srgb = renodx::color::correct::GamutCompress(color_srgb, grayscale, gamut_compression_scale);
  }

  float max_channel = 1.f;
  {
    max_channel = ComputeMaxChannelScale(color_srgb);
  }
  color_srgb /= max_channel;

  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float _992 = (((lerp(_966.x, _973.x, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.r));
  float _993 = (((lerp(_966.y, _973.y, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.g));
  float _994 = (((lerp(_966.z, _973.z, _961)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * color_srgb.b));

  float3 lutted_srgb = float3(_992, _993, _994);

  {
    lutted_srgb *= max_channel;
    lutted_srgb = renodx::color::correct::GamutDecompress(lutted_srgb, gamut_compression_scale);
  }

  return lutted_srgb;
}

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = SamplePacked1DLut(lut_input_color, lut_config.lut_sampler, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lut_black = SamplePacked1DLut(float3(0, 0, 0), lut_config.lut_sampler, lut_texture);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_mid = SamplePacked1DLut(renodx::lut::ConvertInput(0.18f, lut_config), lut_config.lut_sampler, lut_texture);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // account for EOTF emulation in inputs
        lut_output_color = renodx::lut::ConvertInput(GammaCorrectByLuminance(color_output), lut_config);
        lut_black = renodx::lut::ConvertInput(GammaCorrectByLuminance(renodx::lut::LinearOutput(lut_black, lut_config)), lut_config);
        lut_mid = renodx::lut::ConvertInput(GammaCorrectByLuminance(renodx::lut::LinearOutput(lut_mid, lut_config)), lut_config);
      }

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_mid, lut_config),
          renodx::lut::ConvertInput(color_input, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);

      if (RENODX_GAMMA_CORRECTION != 0.f) {  // inverse EOTF emulation
        unclamped_linear = GammaCorrectByLuminance(unclamped_linear, true);
      }

      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  } else {
  }

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = LUTToneMap(color_lut_input);
    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);

  } else {
    color_output = renodx::color::srgb::DecodeSafe(SamplePacked1DLut(renodx::color::srgb::Encode(saturate(color_lut_input)), lut_sampler, lut_texture));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}
