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

float GetUnrealFilmicMidGrayScale() {
  const float untonemapped = 0.18f;
  float _1007 = log2(untonemapped) * 0.3010300099849701f;
  float _976 = (FilmBlackClip + 1.0f) - FilmToe;
  float _978 = FilmWhiteClip + 1.0f;
  float _980 = _978 - FilmShoulder;
  float _998;
  if (FilmToe > 0.800000011920929f) {
    _998 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _989 = (FilmBlackClip + 0.18000000715255737f) / _976;
    _998 = (-0.7447274923324585f - ((log2(_989 / (2.0f - _989)) * 0.3465735912322998f) * (_976 / FilmSlope)));
  }
  float _1001 = ((1.0f - FilmToe) / FilmSlope) - _998;
  float _1003 = (FilmShoulder / FilmSlope) - _1001;
  float _1013 = FilmSlope * (_1007 + _1001);
  float _1016 = _976 * 2.0f;
  float _1018 = (FilmSlope * -2.0f) / _976;
  float _1019 = _1007 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = (FilmSlope * 2.0f) / _980;
  float _1067 = select((_1007 < _998), ((_1016 / (exp2((_1019 * 1.4426950216293335f) * _1018) + 1.0f)) - FilmBlackClip), _1013);
  float _1076 = _1003 - _998;
  float _1080 = saturate(_1019 / _1076);
  bool _1083 = (_1003 < _998);
  float _1087 = select(_1083, (1.0f - _1080), _1080);
  float _1108 = (((_1087 * _1087) * (select((_1007 > _1003), (_978 - (_1040 / (exp2(((_1007 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1013) - _1067)) * (3.0f - (_1087 * 2.0f))) + _1067;

  return _1108 / 0.1f;  // 0.162 is roughly the default output mid-gray value for Unreal Engine's filmic tonemapper
}

float3 ApplyACES(float3 untonemapped_ap1) {
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  untonemapped_ap1 *= GetUnrealFilmicMidGrayScale();
  untonemapped_ap1 = mul(renodx::tonemap::aces::DarkToDim(mul(untonemapped_ap1, renodx::color::AP1_TO_XYZ_MAT)), renodx::color::XYZ_TO_AP1_MAT);
  

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  }
  // aces_max /= mid_gray_scale;
  // aces_min /= mid_gray_scale;

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODT(untonemapped_ap1, aces_min * 48.f, aces_max * 48.f, renodx::color::IDENTITY_MAT) / 48.f;

  // tonemapped_ap1 *= mid_gray_scale;

  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
  tonemapped_ap1 = renodx::color::ap1::from::BT709(tonemapped_bt709);

  return tonemapped_ap1;
}

float3 ApplyPostToneMapDesaturation(float3 tonemapped) {
  float grayscale = renodx::color::y::from::AP1(tonemapped);
  return max(0.f, lerp(grayscale, tonemapped, 0.93f));
}

float3 ApplyUnrealFilmicToneMap(float3 untonemapped) {
  float film_black_clip = FilmBlackClip;
  if (OVERRIDE_BLACK_CLIP && RENODX_TONE_MAP_TYPE == 3.f) {
    float target_black_nits = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION) target_black_nits = renodx::color::correct::Gamma(target_black_nits, true);
    film_black_clip = target_black_nits * -1.f;
  }
  float film_white_clip = FilmWhiteClip;

  float _1007 = log2(untonemapped.r) * 0.3010300099849701f;
  float _1008 = log2(untonemapped.g) * 0.3010300099849701f;
  float _1009 = log2(untonemapped.b) * 0.3010300099849701f;
  float _976 = (film_black_clip + 1.0f) - FilmToe;
  float _978 = film_white_clip + 1.0f;
  float _980 = _978 - FilmShoulder;
  float _998;
  if (FilmToe > 0.800000011920929f) {
    _998 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _989 = (film_black_clip + 0.18000000715255737f) / _976;
    _998 = (-0.7447274923324585f - ((log2(_989 / (2.0f - _989)) * 0.3465735912322998f) * (_976 / FilmSlope)));
  }
  float _1001 = ((1.0f - FilmToe) / FilmSlope) - _998;
  float _1003 = (FilmShoulder / FilmSlope) - _1001;
  float _1013 = FilmSlope * (_1007 + _1001);
  float _1014 = FilmSlope * (_1008 + _1001);
  float _1015 = FilmSlope * (_1009 + _1001);
  float _1016 = _976 * 2.0f;
  float _1018 = (FilmSlope * -2.0f) / _976;
  float _1019 = _1007 - _998;
  float _1020 = _1008 - _998;
  float _1021 = _1009 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = (FilmSlope * 2.0f) / _980;
  float _1067 = select((_1007 < _998), ((_1016 / (exp2((_1019 * 1.4426950216293335f) * _1018) + 1.0f)) - film_black_clip), _1013);
  float _1068 = select((_1008 < _998), ((_1016 / (exp2((_1020 * 1.4426950216293335f) * _1018) + 1.0f)) - film_black_clip), _1014);
  float _1069 = select((_1009 < _998), ((_1016 / (exp2((_1021 * 1.4426950216293335f) * _1018) + 1.0f)) - film_black_clip), _1015);
  float _1076 = _1003 - _998;
  float _1080 = saturate(_1019 / _1076);
  float _1081 = saturate(_1020 / _1076);
  float _1082 = saturate(_1021 / _1076);
  bool _1083 = (_1003 < _998);
  float _1087 = select(_1083, (1.0f - _1080), _1080);
  float _1088 = select(_1083, (1.0f - _1081), _1081);
  float _1089 = select(_1083, (1.0f - _1082), _1082);
  float _1108 = (((_1087 * _1087) * (select((_1007 > _1003), (_978 - (_1040 / (exp2(((_1007 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1013) - _1067)) * (3.0f - (_1087 * 2.0f))) + _1067;
  float _1109 = (((_1088 * _1088) * (select((_1008 > _1003), (_978 - (_1040 / (exp2(((_1008 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1014) - _1068)) * (3.0f - (_1088 * 2.0f))) + _1068;
  float _1110 = (((_1089 * _1089) * (select((_1009 > _1003), (_978 - (_1040 / (exp2(((_1009 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1015) - _1069)) * (3.0f - (_1089 * 2.0f))) + _1069;

  return float3(_1108, _1109, _1110);
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

  float3 untonemapped = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_pre_grade, untonemapped_lum, cg_config);

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // ACES
    tonemapped = ApplyACES(untonemapped);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    tonemapped = LerpToneMapStrength(untonemapped, float3(preRRT_r, preRRT_g, preRRT_b));
    r = tonemapped.r, g = tonemapped.g, b = tonemapped.b;
    return;
  } else {
    tonemapped = ApplyUnrealFilmicToneMap(untonemapped);
    tonemapped = ApplyBlueCorrection(tonemapped);
    if (RENODX_TONE_MAP_TYPE == 3.f) {  // Vanilla+
      tonemapped = lerp(tonemapped, ApplyACES(untonemapped), tonemapped);
    }
  }
  tonemapped = ApplyPostToneMapDesaturation(tonemapped);
  
  tonemapped = renodx::color::ap1::from::BT709(ApplySaturationBlowoutHueCorrectionHighlightSaturation(renodx::color::bt709::from::AP1(tonemapped), renodx::color::bt709::from::AP1(untonemapped_pre_grade), untonemapped_lum, cg_config));

  tonemapped = LerpToneMapStrength(tonemapped, float3(preRRT_r, preRRT_g, preRRT_b));

  r = tonemapped.r, g = tonemapped.g, b = tonemapped.b;
}

float3 ToneMapForLUT(inout float r, inout float g, inout float b) {
  float3 tonemapped = float3(r, g, b);
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    tonemapped = ToneMapMaxCLL(tonemapped);
  }
  r = saturate(tonemapped.r), g = saturate(tonemapped.g), b = saturate(tonemapped.b);
  return tonemapped;
}

float3 RestoreSaturationLoss(float3 color_input, float3 clamped, float3 color_output) {
  float3 perceptual_in = renodx::color::oklab::from::BT709(color_input);
  float3 perceptual_clamped = renodx::color::oklab::from::BT709(clamped);
  float3 perceptual_out = renodx::color::oklab::from::BT709(color_output);

  float chroma_in = distance(perceptual_in.yz, 0);
  float chroma_clamped = distance(perceptual_clamped.yz, 0);
  float chroma_out = distance(perceptual_out.yz, 0);
  float chroma_loss = renodx::math::DivideSafe(chroma_in, chroma_clamped, 0.f);
  float chroma_new = chroma_out * chroma_loss;

  perceptual_out.yz *= lerp(1.f, renodx::math::DivideSafe(chroma_new, chroma_out, 1.f), 1.f);

  return renodx::color::bt709::from::OkLab(perceptual_out);
}

void LUTUpgradeToneMap(float3 untonemapped, float3 displaymapped_unclamped_gamut, float3 displaymapped_clamped_gamut, inout float r, inout float g, inout float b) {
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 upgraded = renodx::tonemap::UpgradeToneMap(untonemapped, displaymapped_unclamped_gamut, float3(r, g, b), 1.f);
    // upgraded = RestoreSaturationLoss(displaymapped_unclamped_gamut, displaymapped_clamped_gamut, upgraded);

    r = upgraded.r, g = upgraded.g, b = upgraded.b;
  }
}
