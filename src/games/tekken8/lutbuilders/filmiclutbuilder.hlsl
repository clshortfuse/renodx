#include "./lutbuildercommon.hlsl"

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
  float4 PolarisToneCurveCoef0 : packoffset(c035.x);
  float4 PolarisToneCurveCoef1 : packoffset(c036.x);
  float LUTSize : packoffset(c037.x);
  float WhiteTemp : packoffset(c037.y);
  float WhiteTint : packoffset(c037.z);
  float ColorCorrectionShadowsMax : packoffset(c037.w);
  float ColorCorrectionHighlightsMin : packoffset(c038.x);
  float ColorCorrectionHighlightsMax : packoffset(c038.y);
  float BlueCorrection : packoffset(c038.z);
  float ExpandGamut : packoffset(c038.w);
  float ToneCurveAmount : packoffset(c039.x);
  float FilmSlope : packoffset(c039.y);
  float FilmToe : packoffset(c039.z);
  float FilmShoulder : packoffset(c039.w);
  float FilmBlackClip : packoffset(c040.x);
  float FilmWhiteClip : packoffset(c040.y);
  uint bUseMobileTonemapper : packoffset(c040.z);
  uint bIsTemperatureWhiteBalance : packoffset(c040.w);
  float3 MappingPolynomial : packoffset(c041.x);
  float3 InverseGamma : packoffset(c042.x);
  uint OutputDevice : packoffset(c042.w);
  uint OutputGamut : packoffset(c043.x);
  float OutputMaxLuminance : packoffset(c043.y);
};

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  float shadow_mask = 1.f;
  if (config.shadows < 1.f) shadow_mask = mid_gray;

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

/// Unreal Engine Filmic ToneMap based on ACES approximation with customizable parameters
#define UNREALFILMIC_GENERATOR(T)                                                                                                                                                                                                                                                            \
  T ApplyUnrealFilmicToneMap(T untonemapped) {                                                                                                                                                                                                                                               \
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
  preRRT = min(100.f, preRRT);  // prevents artifacts during night vision
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

  // blue correction has a massive effect on the final result, so we include before chrominance correction
  channel_tonemapped = ApplyPostToneMapDesaturation(channel_tonemapped);
  channel_tonemapped = LerpToneMapStrength(channel_tonemapped, preRRT);
  channel_tonemapped = ApplyBlueCorrection(channel_tonemapped);

  luminance_tonemapped = ApplyPostToneMapDesaturation(luminance_tonemapped);
  luminance_tonemapped = LerpToneMapStrength(luminance_tonemapped, preRRT);

  // added max(0, color) as negatives are clamped later but we need to clamp early for chrominance correction
  return renodx::color::correct::ChrominanceOKLab(luminance_tonemapped, max(0, channel_tonemapped));
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

void ApplyFilmicToneMap(
    inout float r,
    inout float g,
    inout float b,
    float preRRT_r,
    float preRRT_g,
    float preRRT_b) {
  float _827 = preRRT_r, _828 = preRRT_g, _829 = preRRT_b;
  float3 tonemapped;
  float3 untonemapped_pre_grade = float3(r, g, b);

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

  r = tonemapped.r, g = tonemapped.g, b = tonemapped.b;
  return;
}

float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture) {
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

float3 GamutDecompress(float3 color, float grayscale, float saturation_scale) {
  return lerp(grayscale, color, 1.f / saturation_scale);
}

// This might be confusing syntax
float3 GamutDecompress(float3 color, float saturation_scale) {
  float grayscale = renodx::color::y::from::BT709(color);
  return GamutDecompress(color, grayscale, saturation_scale);
}

float3 GamutCompress(float3 color, float grayscale, float saturation_scale) {
  return lerp(grayscale, color, saturation_scale);
}

float ComputeGamutCompressionScale(float3 color, float grayscale) {
  // Desaturate (move towards grayscale) until no channel is below 0
  float lowest_negative_channel = min(0.f, min(color.r, min(color.g, color.b)));
  float distance = grayscale - lowest_negative_channel;

  float ratio = renodx::math::DivideSafe(-lowest_negative_channel, distance, 0.f);

  // if grayscale is 0, ratio is 0 via DivideSafe, so no change
  // if minchannel is 0, ratio is 0, so no change
  float saturation_scale = 1.f - ratio;
  return saturation_scale;
}

float ComputeGamutCompressionScale(float3 color) {
  float grayscale = renodx::color::y::from::BT709(color);
  return ComputeGamutCompressionScale(color, grayscale);
}

float3 GamutCompress(float3 color, float grayscale) {
  return lerp(grayscale, color, ComputeGamutCompressionScale(color, grayscale));
}

float3 GamutCompress(float3 color) {
  return GamutCompress(color, renodx::color::y::from::BT709(color));
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 1.f;

  float3 color_input_unclamped = color_input;

  float compression_scale = 1.f;
  const float perceptual_gamma = 2.2f;
  if (lut_config.recolor != 0.f) {
    float grayscale = renodx::color::gamma::EncodeSafe(renodx::color::y::from::BT709((color_input)), perceptual_gamma);
    color_input = renodx::color::gamma::EncodeSafe(color_input, perceptual_gamma);
    compression_scale = ComputeGamutCompressionScale(color_input, grayscale);
    color_input = GamutCompress(color_input, grayscale, compression_scale);
    color_input = renodx::color::gamma::DecodeSafe(color_input, perceptual_gamma);
  }

  float3 lut_input_color = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lut_output_color = SamplePacked1DLut(lut_input_color, lut_config.lut_sampler, lut_texture);
  float3 color_output = renodx::lut::LinearOutput(lut_output_color, lut_config);
  [branch] if (lut_config.scaling != 0.f) {
    float3 lut_black = SamplePacked1DLut(float3(0, 0, 0), lut_config.lut_sampler, lut_texture);
    float3 lut_black_linear = renodx::lut::LinearOutput(lut_black, lut_config);
    float lut_black_y = max(0, renodx::color::y::from::BT709(lut_black_linear));
    if (lut_black_y > 0.f) {
      float3 lut_black_pivot = SamplePacked1DLut(renodx::lut::ConvertInput(lut_black_y, lut_config), lut_config.lut_sampler, lut_texture);  // set midpoint based on black to avoid black crush
      float lut_shift = (renodx::color::y::from::BT709(renodx::lut::LinearOutput(lut_black_pivot, lut_config)) + lut_black_y) / lut_black_y;

      float3 unclamped_gamma = Unclamp(
          renodx::lut::GammaOutput(lut_output_color, lut_config),
          renodx::lut::GammaOutput(lut_black, lut_config),
          renodx::lut::GammaOutput(lut_black_pivot, lut_config),
          renodx::lut::ConvertInput(color_input * lut_shift, lut_config));

      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  }
  else {
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::color::gamma::EncodeSafe(color_output, perceptual_gamma);
    color_output = (GamutDecompress(color_output, compression_scale));
    color_output = renodx::color::gamma::DecodeSafe(color_output, perceptual_gamma);
  }

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
#if 1
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
#else
    float3 color = color_lut_input;
    float max_channel = renodx::math::Max(color.r, color.g, color.b);
    max_channel = max(1e-6, max_channel);

    // Clamp HDR to 0-1 range, and calculate scale for re-expansion
    const float u = 0.525;
    float q = (2.0 - u - 1.0 / u + max_channel * (2.0 + 2.0 / u - max_channel / u)) / 4.0;
    float clamped = (abs(1.0 - max_channel) < u) ? q : saturate(max_channel);
    float scale = clamped / max_channel;

    color *= scale;
    color = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color);
    color /= scale;
    color_output = color;
#endif
  } else {
    color_output = renodx::color::srgb::DecodeSafe(SamplePacked1DLut(renodx::color::srgb::Encode(saturate(color_lut_input)), lut_sampler, lut_texture));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }

  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}
