#include "./lutbuildercommon.hlsli"

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_008x : packoffset(c008.x);
  float cb0_008y : packoffset(c008.y);
  float cb0_008z : packoffset(c008.z);
  float cb0_008w : packoffset(c008.w);
  float cb0_009x : packoffset(c009.x);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
  float cb0_012x : packoffset(c012.x);
  float cb0_012y : packoffset(c012.y);
  float cb0_012z : packoffset(c012.z);
  float cb0_013x : packoffset(c013.x);
  float cb0_013y : packoffset(c013.y);
  float cb0_013z : packoffset(c013.z);
  float cb0_013w : packoffset(c013.w);
  float cb0_014x : packoffset(c014.x);
  float cb0_014y : packoffset(c014.y);
  float cb0_014z : packoffset(c014.z);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
  float cb0_016w : packoffset(c016.w);
  float cb0_017x : packoffset(c017.x);
  float cb0_017y : packoffset(c017.y);
  float cb0_017z : packoffset(c017.z);
  float cb0_017w : packoffset(c017.w);
  float cb0_018x : packoffset(c018.x);
  float cb0_018y : packoffset(c018.y);
  float cb0_018z : packoffset(c018.z);
  float cb0_018w : packoffset(c018.w);
  float cb0_019x : packoffset(c019.x);
  float cb0_019y : packoffset(c019.y);
  float cb0_019z : packoffset(c019.z);
  float cb0_019w : packoffset(c019.w);
  float cb0_020x : packoffset(c020.x);
  float cb0_020y : packoffset(c020.y);
  float cb0_020z : packoffset(c020.z);
  float cb0_020w : packoffset(c020.w);
  float cb0_021x : packoffset(c021.x);
  float cb0_021y : packoffset(c021.y);
  float cb0_021z : packoffset(c021.z);
  float cb0_021w : packoffset(c021.w);
  float cb0_022x : packoffset(c022.x);
  float cb0_022y : packoffset(c022.y);
  float cb0_022z : packoffset(c022.z);
  float cb0_022w : packoffset(c022.w);
  float cb0_023x : packoffset(c023.x);
  float cb0_023y : packoffset(c023.y);
  float cb0_023z : packoffset(c023.z);
  float cb0_023w : packoffset(c023.w);
  float cb0_024x : packoffset(c024.x);
  float cb0_024y : packoffset(c024.y);
  float cb0_024z : packoffset(c024.z);
  float cb0_024w : packoffset(c024.w);
  float cb0_025x : packoffset(c025.x);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_026x : packoffset(c026.x);
  float cb0_026y : packoffset(c026.y);
  float cb0_026z : packoffset(c026.z);
  float cb0_026w : packoffset(c026.w);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_027w : packoffset(c027.w);
  float cb0_028x : packoffset(c028.x);
  float cb0_028y : packoffset(c028.y);
  float cb0_028z : packoffset(c028.z);
  float cb0_028w : packoffset(c028.w);
  float cb0_029x : packoffset(c029.x);
  float cb0_029y : packoffset(c029.y);
  float cb0_029z : packoffset(c029.z);
  float cb0_029w : packoffset(c029.w);
  float cb0_030x : packoffset(c030.x);
  float cb0_030y : packoffset(c030.y);
  float cb0_030z : packoffset(c030.z);
  float cb0_030w : packoffset(c030.w);
  float cb0_031x : packoffset(c031.x);
  float cb0_031y : packoffset(c031.y);
  float cb0_031z : packoffset(c031.z);
  float cb0_031w : packoffset(c031.w);
  float cb0_032x : packoffset(c032.x);
  float cb0_032y : packoffset(c032.y);
  float cb0_032z : packoffset(c032.z);
  float cb0_032w : packoffset(c032.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
  float cb0_035x : packoffset(c035.x);
  float cb0_035y : packoffset(c035.y);
  float cb0_035z : packoffset(c035.z);
  float cb0_035w : packoffset(c035.w);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038z : packoffset(c038.z);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
  int cb0_041x : packoffset(c041.x);
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
  float film_black_clip = cb0_037w;
  float film_toe = cb0_037y;
  float film_white_clip = cb0_038x;
  float film_shoulder = cb0_037z;
  float film_slope = cb0_037x;

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

float3 ApplyUnrealFilmicToneMap(float3 untonemapped) {
  float film_black_clip = cb0_037w;
  float film_toe = cb0_037y;
  float film_white_clip = cb0_038x;
  float film_shoulder = cb0_037z;
  float film_slope = cb0_037x;

  if (OVERRIDE_BLACK_CLIP && RENODX_TONE_MAP_TYPE == 3.f) {
    float target_black_nits = 0.0001f / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION) target_black_nits = renodx::color::correct::Gamma(target_black_nits, true);
    film_black_clip = target_black_nits * -1.f;
  }

  float _1007 = log2(untonemapped.r) * 0.3010300099849701f;
  float _1008 = log2(untonemapped.g) * 0.3010300099849701f;
  float _1009 = log2(untonemapped.b) * 0.3010300099849701f;
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
  float _1014 = film_slope * (_1008 + _1001);
  float _1015 = film_slope * (_1009 + _1001);
  float _1016 = _976 * 2.0f;
  float _1018 = (film_slope * -2.0f) / _976;
  float _1019 = _1007 - _998;
  float _1020 = _1008 - _998;
  float _1021 = _1009 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = (film_slope * 2.0f) / _980;
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
  float tone_map_curve = cb0_036w;

  preRRT = min(100.f, preRRT);  // prevents artifacts during night vision
  return lerp(preRRT, tonemapped, tone_map_curve);
}

float3 Applyblue_correction(float3 tonemapped) {
  float blue_correction = cb0_036y;
  float _1131 = tonemapped.r, _1132 = tonemapped.g, _1133 = tonemapped.b;

  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * blue_correction) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * blue_correction) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * blue_correction) + _1133;
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

  float3 untonemapped = untonemapped_pre_grade;
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    untonemapped = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped_pre_grade, untonemapped_lum, cg_config);
  }

  if (RENODX_TONE_MAP_TYPE == 2.f) {  // ACES
    tonemapped = ApplyACES(untonemapped);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    tonemapped = LerpToneMapStrength(untonemapped, float3(preRRT_r, preRRT_g, preRRT_b));
  } else {
    tonemapped = ApplyUnrealFilmicToneMap(untonemapped);
    tonemapped = ApplyPostToneMapDesaturation(tonemapped);
    tonemapped = LerpToneMapStrength(tonemapped, float3(preRRT_r, preRRT_g, preRRT_b));
    tonemapped = Applyblue_correction(tonemapped);

    if (RENODX_TONE_MAP_TYPE == 3.f) {  // run the same steps on ACES but without desaturation and blue correction
      float3 hdr_tonemapped = ApplyACES(untonemapped);
      hdr_tonemapped = LerpToneMapStrength(hdr_tonemapped, float3(preRRT_r, preRRT_g, preRRT_b));
      const float blend_factor = renodx::color::y::from::AP1(tonemapped);
      tonemapped = lerp(tonemapped, hdr_tonemapped, saturate(blend_factor));
    }
  }
  if (RENODX_TONE_MAP_TYPE != 4.f) {
    tonemapped = renodx::color::ap1::from::BT709(ApplySaturationBlowoutHueCorrectionHighlightSaturation(renodx::color::bt709::from::AP1(tonemapped), renodx::color::bt709::from::AP1(float3(preRRT_r, preRRT_g, preRRT_b)), untonemapped_lum, cg_config));
  }

  r = tonemapped.r, g = tonemapped.g, b = tonemapped.b;
  return;
}

float3 SamplePacked1DLut(
    float3 color_srgb,
    SamplerState lut_sampler,
    Texture2D<float4> lut_texture,
    bool use_lut_weight_z = false) {
  const float lut_weights_x = cb0_005x;
  const float lut_weights_y = cb0_005y;
  const float lut_weights_z = cb0_005z;

  color_srgb = saturate(color_srgb);

  float _952 = (color_srgb.g * 0.9375f) + 0.03125f;
  float _959 = color_srgb.b * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((color_srgb.r * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = lut_texture.Sample(lut_sampler, float2(_963, _952));
  float4 _973 = lut_texture.Sample(lut_sampler, float2((_963 + 0.0625f), _952));
  float3 lutted_srgb;

  [flatten] if (use_lut_weight_z) {
    lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_z)));
  }
  else {
    lutted_srgb = (((lerp(_966.rgb, _973.rgb, _961)) * (lut_weights_y)) + ((lut_weights_x)*color_srgb.rgb));
  }
  return lutted_srgb;
}

float3 SampleLUTSRGBInSRGBOut(Texture2D<float4> lut_texture, SamplerState lut_sampler, float3 color_input, bool use_lut_weight_z = false) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.recolor = 0.f;

  float3 lutInputColor = renodx::lut::ConvertInput(color_input, lut_config);
  float3 lutOutputColor = SamplePacked1DLut(lutInputColor, lut_sampler, lut_texture, use_lut_weight_z);
  float3 color_output = renodx::lut::LinearOutput(lutOutputColor, lut_config);
  [branch] if (lut_config.scaling != 0.f) {
    float3 lutBlack = SamplePacked1DLut(renodx::lut::ConvertInput(0, lut_config), lut_sampler, lut_texture, use_lut_weight_z);
    float3 lutBlackLinear = renodx::lut::LinearOutput(lutBlack, lut_config);
    float lutBlackY = renodx::color::y::from::BT709(lutBlackLinear);
    if (lutBlackY > 0.f) {
      float3 lutMid = renodx::lut::SampleColor(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_config, lut_texture) + lutBlack; // set midpoint based on black to avoid black crush
      float lutShift = renodx::color::y::from::BT709(SamplePacked1DLut(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_sampler, lut_texture) / lutBlack);
      //float3 lutMid = SamplePacked1DLut(renodx::lut::ConvertInput(lutBlackY, lut_config), lut_sampler, lut_texture, use_lut_weight_z);  // use lutBlackY instead of 0.18 to avoid black crush
      //float lutShift = (renodx::color::y::from::BT709(renodx::lut::LinearOutput(lutMid, lut_config)) + lutBlackY) / lutBlackY;          // galaxy brain
      // float3 lutShift = (renodx::lut::LinearOutput(lutMid, lut_config) + lutBlackLinear) / lutBlackLinear;  // galaxy brain

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

void SampleLUTUpgradeToneMap(float3 color_lut_input, SamplerState lut_sampler, Texture2D<float4> lut_texture_1, Texture2D<float4> lut_texture_2, inout float output_r, inout float output_g, inout float output_b) {
  float3 color_output = color_lut_input;

  if (RENODX_TONE_MAP_TYPE != 4.f) {
    float3 color_lut_input_tonemapped = ToneMapMaxCLL(color_lut_input);
    float3 lutted_1 = SampleLUTSRGBInSRGBOut(lut_texture_1, lut_sampler, color_lut_input_tonemapped);
    float3 lutted_2 = SampleLUTSRGBInSRGBOut(lut_texture_2, lut_sampler, color_lut_input_tonemapped, true);
    float3 lutted = lutted_1 + lutted_2;
    color_output = renodx::tonemap::UpgradeToneMap(color_lut_input, color_lut_input_tonemapped, lutted, CUSTOM_LUT_STRENGTH);
  } else {
    color_output = renodx::color::srgb::DecodeSafe(
        SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler, lut_texture_1) + SamplePacked1DLut(renodx::color::srgb::EncodeSafe(color_lut_input), lut_sampler, lut_texture_2, true));
    color_output = lerp(color_lut_input, color_output, CUSTOM_LUT_STRENGTH);
  }
  output_r = color_output.r, output_g = color_output.g, output_b = color_output.b;
}