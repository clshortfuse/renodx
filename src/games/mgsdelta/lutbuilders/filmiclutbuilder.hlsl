#include "./lutbuildercommon.hlsl"

static const uint LUT_WEIGHT_DEFAULT = 0;
static const uint LUT_WEIGHT_X_Y = 0;
static const uint LUT_WEIGHT_Z = 1;
static const uint LUT_WEIGHT_W = 2;

cbuffer _RootShaderParameters : register(b0) {
  float4 LUTWeights[2] : packoffset(c005.x);
  float4 ACESMinMaxData : packoffset(c008.x);
  float4 ACESMidData : packoffset(c009.x);
  float4 ACESCoefsLow_0 : packoffset(c010.x);
  float4 ACESCoefsHigh_0 : packoffset(c011.x);
  float ACESCoefsLow_4 : packoffset(c012.x);
  float ACESCoefsHigh_4 : packoffset(c012.y);
  float ACESSceneColorMultiplier : packoffset(c012.z);
  float ACESGamutCompression : packoffset(c012.w);
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

// float3 ApplyHueShift(float3 color, float3 hue_shift_color){
//   return renodx::color::correct::Hue(color, hue_shift_color, config.hue_shift_strength);
// }

float GetUnrealFilmicMidGrayScale() {
  float film_black_clip = FilmBlackClip;
  float film_toe = FilmToe;
  float film_white_clip = FilmWhiteClip;
  float film_shoulder = FilmShoulder;
  float film_slope = FilmSlope;

  const float untonemapped = 0.18f;

  float _1007 = log2(untonemapped) * 0.3010300099849701f;
  float _976 = (film_black_clip + 1.0f) - film_toe;
  float _978 = film_white_clip + 1.0f;
  float _980 = _978 - film_shoulder;
  float _998;
  if (film_toe > 0.800000011920929f) {
    _998 = (((0.8199999928474426f - film_toe) / film_slope) + -0.7447274923324585f);
  } else {
    float _989 = (film_black_clip + 0.18000000715255737f) / _976;
    _998 = (-0.7447274923324585f - ((log2(_989 / (2.0f - _989)) * 0.3465735912322998f) * (_976 / film_slope)));
  }
  float _1001 = ((1.0f - film_toe) / film_slope) - _998;
  float _1003 = (film_shoulder / film_slope) - _1001;
  float _1013 = film_slope * (_1007 + _1001);
  float _1016 = _976 * 2.0f;
  float _1018 = (film_slope * -2.0f) / _976;
  float _1019 = _1007 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = (film_slope * 2.0f) / _980;
  float _1067 = select((_1007 < _998), ((_1016 / (exp2((_1019 * 1.4426950216293335f) * _1018) + 1.0f)) - film_black_clip), _1013);
  float _1076 = _1003 - _998;
  float _1080 = saturate(_1019 / _1076);
  bool _1083 = (_1003 < _998);
  float _1087 = select(_1083, (1.0f - _1080), _1080);
  float _1108 = (((_1087 * _1087) * (select((_1007 > _1003), (_978 - (_1040 / (exp2(((_1007 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1013) - _1067)) * (3.0f - (_1087 * 2.0f))) + _1067;

  return _1108 / 0.162f;  // 0.162 is roughly the default output mid-gray value for Unreal Engine's filmic tonemapper
}

float3 ApplyACES(float3 untonemapped_ap1) {
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  const float mid_gray_scale = GetUnrealFilmicMidGrayScale();

  untonemapped_ap1 *= 1.62;  // set up midgray to match UE defaults, then allow midgray matching to adjust further based on parameters

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }
  aces_max /= mid_gray_scale;
  aces_min /= mid_gray_scale;

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

  tonemapped_ap1 *= mid_gray_scale;

  return tonemapped_ap1;
}

float3 ApplyPostToneMapDesaturation(float3 tonemapped) {
  float grayscale = renodx::color::y::from::AP1(tonemapped);
  return max(0.f, lerp(grayscale, tonemapped, 0.93f));
}

// Unreal Engine Filmic ToneMap based on ACES approximation with customizable parameters
#define UNREALFILMIC_GENERATOR(T)                                                                                                                                                                                                                                                            \
  T ApplyUnrealFilmicToneMap(T untonemapped) {                                                                                                                                                                                                                                               \
    float film_black_clip = FilmBlackClip;                                                                                                                                                                                                                                                   \
    float film_toe = FilmToe;                                                                                                                                                                                                                                                                \
    float film_white_clip = FilmWhiteClip;                                                                                                                                                                                                                                                   \
    float film_shoulder = FilmShoulder;                                                                                                                                                                                                                                                      \
    float film_slope = FilmSlope;                                                                                                                                                                                                                                                            \
    if (OVERRIDE_BLACK_CLIP && RENODX_TONE_MAP_TYPE == 3.f) {                                                                                                                                                                                                                                \
      float target_black_nits = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;                                                                                                                                                                                                                         \
      if (RENODX_GAMMA_CORRECTION) target_black_nits = renodx::color::correct::Gamma(target_black_nits, true);                                                                                                                                                                               \
      film_black_clip = target_black_nits * -1.f;                                                                                                                                                                                                                                            \
    }                                                                                                                                                                                                                                                                                        \
    T _1007_1008_1009 = log2(untonemapped) * 0.3010300099849701f;                                                                                                                                                                                                                            \
    float _976 = (film_black_clip + 1.0f) - film_toe;                                                                                                                                                                                                                                        \
    float _978 = film_white_clip + 1.0f;                                                                                                                                                                                                                                                     \
    float _980 = _978 - film_shoulder;                                                                                                                                                                                                                                                       \
    float _998;                                                                                                                                                                                                                                                                              \
    if (film_toe > 0.800000011920929f) {                                                                                                                                                                                                                                                     \
      _998 = (((0.8199999928474426f - film_toe) / film_slope) + -0.7447274923324585f);                                                                                                                                                                                                       \
    } else {                                                                                                                                                                                                                                                                                 \
      float _989 = (film_black_clip + 0.18000000715255737f) / _976;                                                                                                                                                                                                                          \
      _998 = (-0.7447274923324585f - ((log2(_989 / (2.0f - _989)) * 0.3465735912322998f) * (_976 / film_slope)));                                                                                                                                                                            \
    }                                                                                                                                                                                                                                                                                        \
    float _1001 = ((1.0f - film_toe) / film_slope) - _998;                                                                                                                                                                                                                                   \
    float _1003 = (film_shoulder / film_slope) - _1001;                                                                                                                                                                                                                                      \
    T _1013_1014_1015 = film_slope * (_1007_1008_1009 + _1001);                                                                                                                                                                                                                              \
    float _1016 = _976 * 2.0f;                                                                                                                                                                                                                                                               \
    float _1018 = (film_slope * -2.0f) / _976;                                                                                                                                                                                                                                               \
    T _1019_1020_1021 = _1007_1008_1009 - _998;                                                                                                                                                                                                                                              \
    float _1040 = _980 * 2.0f;                                                                                                                                                                                                                                                               \
    float _1042 = (film_slope * 2.0f) / _980;                                                                                                                                                                                                                                                \
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

float3 LerpToneMapStrength(float3 tonemapped, float3 preRRT) {
  float tone_map_curve = ToneCurveAmount;

  preRRT = min(100.f, preRRT);  // prevents artifacts during night vision
  return lerp(preRRT, tonemapped, tone_map_curve);
}

float3 ApplyBlueCorrection(float3 tonemapped) {
  float blue_correction = BlueCorrection;
  float _1131 = tonemapped.r, _1132 = tonemapped.g, _1133 = tonemapped.b;

  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * blue_correction) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * blue_correction) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * blue_correction) + _1133;
  return float3(_1149, _1150, _1151);
}

float3 ApplyUnrealFilmicToneMapByLuminance(float3 untonemapped) {
  float untonemapped_lum = renodx::color::y::from::AP1(untonemapped);
  float4 tonemaps = ApplyUnrealFilmicToneMap(float4(untonemapped, untonemapped_lum));
  float3 channel_tonemapped = tonemaps.xyz;
  float3 luminance_tonemapped = renodx::color::correct::Luminance(untonemapped, untonemapped_lum, tonemaps.a, 1.f);

  return renodx::color::correct::ChrominanceOKLab(luminance_tonemapped, channel_tonemapped);
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

  return renodx::color::correct::ChrominanceOKLab(luminance_tonemapped, channel_tonemapped);
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
  if (RENODX_TONE_MAP_TYPE != 4.f) {
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
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    tonemapped = renodx::color::ap1::from::BT709(ApplySaturationBlowoutHueCorrectionHighlightSaturation(renodx::color::bt709::from::AP1(tonemapped), renodx::color::bt709::from::AP1(LerpToneMapStrength(untonemapped, float3(preRRT_r, preRRT_g, preRRT_b))), untonemapped_lum, cg_config));
  }

  r = tonemapped.r, g = tonemapped.g, b = tonemapped.b;
  return;
}

float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture,
    uint lut_weight = LUT_WEIGHT_DEFAULT) {
  const float lut_weights_x = LUTWeights[0].x;
  const float lut_weights_y = LUTWeights[0].y;
  const float lut_weights_z = LUTWeights[0].z;
  const float lut_weights_w = LUTWeights[0].w;

  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float3 lutted_srgb;

  switch (lut_weight) {
    case LUT_WEIGHT_X_Y: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_y)) + ((lut_weights_x)*color_srgb.rgb));
      break;
    }
    case LUT_WEIGHT_Z: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_z)));
      break;
    }
    case LUT_WEIGHT_W: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_w)));
      break;
    }
    default: {
      lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_y)) + ((lut_weights_x)*color_srgb.rgb));
      break;
    }
  }
  return lutted_srgb;
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input, uint lut_weight = LUT_WEIGHT_DEFAULT) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = SamplePacked1DLut(lutInputColor, lut_sampler, lut_texture, lut_weight);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch]
  if (lut_config.scaling != 0.f) {
    float3 lutBlack = SamplePacked1DLut(renodx::lut::ConvertInput(0, lut_config), lut_sampler, lut_texture, lut_weight);
    float3 lutBlackLinear = renodx::lut::LinearOutput(lutBlack, lut_config);
    float lutBlackY = renodx::color::y::from::BT709(lutBlackLinear);
    if (lutBlackY > 0.f) {
      float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_config, lut_texture) + lutBlack;  // set midpoint based on black to avoid black crush
      float lutShift = renodx::color::y::from::BT709(SamplePacked1DLut(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_sampler, lut_texture, lut_weight) / lutBlack);
      float3 unclamped_gamma = renodx::lut::Unclamp(
          renodx::lut::GammaOutput(lutOutputColor, lut_config),
          renodx::lut::GammaOutput(lutBlack, lut_config),
          renodx::lut::GammaOutput(lutMid, lut_config),
          1.f,  // renodx::lut::GammaOutput(lutWhite, lut_config), // not adjusting whites, just lowering blacks
          renodx::lut::ConvertInput(color_input * lutShift, lut_config));
      float3 unclamped_linear = renodx::lut::LinearUnclampedOutput(unclamped_gamma, lut_config);
      float3 recolored = renodx::lut::RecolorUnclamped(color_output, unclamped_linear, lut_config.scaling);
      color_output = recolored;
    }
  }
  if (lut_config.recolor != 0.f) {
    color_output = renodx::lut::RestoreSaturationLoss(color_input, color_output, lut_config);
  }

  return color_output;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted = SampleLUTSRGBInSRGBOut(lut_texture, lut_sampler, color_lut_input_tonemapped);
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler, lut_texture));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler_1, SamplerState lut_sampler_2, Texture2D<float4> lut_texture_1, Texture2D<float4> lut_texture_2, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted_1 = SampleLUTSRGBInSRGBOut(lut_texture_1, lut_sampler_1, color_lut_input_tonemapped);
    float3 lutted_2 = SampleLUTSRGBInSRGBOut(lut_texture_2, lut_sampler_2, color_lut_input_tonemapped, LUT_WEIGHT_Z);
    float3 lutted = lutted_1 + lutted_2;
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(
        SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_1, lut_texture_1)
        + SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_2, lut_texture_2, LUT_WEIGHT_Z));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler_1, SamplerState lut_sampler_2, SamplerState lut_sampler_3, Texture2D<float4> lut_texture_1, Texture2D<float4> lut_texture_2, Texture2D<float4> lut_texture_3, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted_1 = SampleLUTSRGBInSRGBOut(lut_texture_1, lut_sampler_1, color_lut_input_tonemapped);
    float3 lutted_2 = SampleLUTSRGBInSRGBOut(lut_texture_2, lut_sampler_2, color_lut_input_tonemapped, LUT_WEIGHT_Z);
    float3 lutted_3 = SampleLUTSRGBInSRGBOut(lut_texture_3, lut_sampler_3, color_lut_input_tonemapped, LUT_WEIGHT_W);
    float3 lutted = lutted_1 + lutted_2 + lutted_3;
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(
        SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_1, lut_texture_1)
        + SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_2, lut_texture_2, LUT_WEIGHT_Z)
        + SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler_3, lut_texture_3, LUT_WEIGHT_W));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}
