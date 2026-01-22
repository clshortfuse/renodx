
#include "./shared.h"

#ifdef USE_CBUFFER_SLOT_B2
cbuffer TonemapParam : register(b2) {
#else
cbuffer TonemapParam : register(b4) {
#endif
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  float toe : packoffset(c000.w);
  float maxNit : packoffset(c001.x);
  float linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
  float tonemapParam_isHDRMode : packoffset(c002.w);
  float useDynamicRangeConversion : packoffset(c003.x);
  float useHuePreserve : packoffset(c003.y);
  float exposureScale : packoffset(c003.z);
  float kneeStartNit : packoffset(c003.w);
  float knee : packoffset(c004.x);
  float curve_HDRip : packoffset(c004.y);
  float curve_k2 : packoffset(c004.z);
  float curve_k4 : packoffset(c004.w);
  row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
  row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
  float tonemapGraphScale : packoffset(c013.x);
  float offsetEVCurveStart : packoffset(c013.y);
  float offsetEVCurveRange : packoffset(c013.z);
};

struct CustomTonemapParam {
  float contrast;
  float linearBegin;
  float linearLength;
  float toe;
  float maxNit;
  float linearStart;
  float displayMaxNitSubContrastFactor;
  float contrastFactor;
  float mulLinearStartContrastFactor;
  float invLinearBegin;
  float madLinearStartContrastFactor;
};

/*
  // Vanilla values
  const float invLinearBegin = 20.f;
  const float linearBegin = 0.05f;
  const float linearStart = 1.70833f;
  const float contrast = 0.3f;
  const float madLinearStartContrastFactor = 0.035f;
  const float toe = 1.f;
  const float maxNit = 10.f;
  const float contrastFactor = -0.0457877f;
  const float mulLinearStartContrastFactor = 0.0782207f;
  const float displayMaxNitSubContrastFactor = 9.4525f;
*/

// Calculate mulLinearStartContrastFactor to maintain curve continuity at linearStart
// when madLinearStartContrastFactor is adjusted
float CalculateMulLinearStartContrastFactor(
  float madLinearStartContrastFactor_adjusted,
  float contrast_val,
  float linearStart_val,
  float maxNit_val,
  float contrastFactor_val,
  float displayMaxNitSubContrastFactor_val
) {
  float contrast_output = (contrast_val * linearStart_val) + madLinearStartContrastFactor_adjusted;
  float highlight_numerator = maxNit_val - contrast_output;
  return log2(highlight_numerator / displayMaxNitSubContrastFactor_val) - (contrastFactor_val * linearStart_val);
}

// Allow overriding the peak nits; all dependent factors are recomputed from it.
float3 VanillaSDRTonemapper(float3 color, float peak = maxNit, bool is_sdr = false) {

 CustomTonemapParam params;
 params.contrast = contrast;
 params.linearBegin = linearBegin;
  params.linearLength = linearLength;
  params.toe = toe;
  params.maxNit = maxNit;
  params.linearStart = linearStart;
  params.displayMaxNitSubContrastFactor = displayMaxNitSubContrastFactor;
  params.contrastFactor = contrastFactor;
  params.invLinearBegin = invLinearBegin;
  params.madLinearStartContrastFactor = madLinearStartContrastFactor;
  params.mulLinearStartContrastFactor = mulLinearStartContrastFactor;

  bool custom_params = CUSTOM_TONE_MAP_PARAMETERS == 1.f;
  if (custom_params && RENODX_TONE_MAP_TYPE != 0.f) {
    params.contrast *= 1.3f;
    // params.toe *= 2.0f;
    params.madLinearStartContrastFactor = renodx::math::FLT_EPSILON;
    //params.madLinearStartContrastFactor *= 0.20f;
    //params.toe *= 1.2f;
  }
  if (custom_params || (peak != maxNit)) {
    params.maxNit = peak;
    params.linearStart = peak;
    params.mulLinearStartContrastFactor = CalculateMulLinearStartContrastFactor(
        params.madLinearStartContrastFactor,
        params.contrast,
        params.linearStart,
        params.maxNit,
        params.contrastFactor,
        params.displayMaxNitSubContrastFactor
    );
  }

  float _2956;
  float _2965;
  float _2974;
  float _3045;
  float _3046;
  float _3047;
  float _2948 = params.invLinearBegin * color.r;
    if (!(color.r >= params.linearBegin)) {
      _2956 = ((_2948 * _2948) * (3.0f - (_2948 * 2.0f)));
    } else {
      _2956 = 1.0f;
    }
    float _2957 = params.invLinearBegin * color.g;
    if (!(color.g >= params.linearBegin)) {
      _2965 = ((_2957 * _2957) * (3.0f - (_2957 * 2.0f)));
    } else {
      _2965 = 1.0f;
    }
    float _2966 = params.invLinearBegin * color.b;
    if (!(color.b >= params.linearBegin)) {
      _2974 = ((_2966 * _2966) * (3.0f - (_2966 * 2.0f)));
    } else {
      _2974 = 1.0f;
    }
    float _2983 = select((color.r < params.linearStart), 0.0f, 1.0f);
    float _2984 = select((color.g < params.linearStart), 0.0f, 1.0f);
    float _2985 = select((color.b < params.linearStart), 0.0f, 1.0f);
    _3045 = (((((params.contrast * color.r) + params.madLinearStartContrastFactor) * (_2956 - _2983)) + (((pow(_2948, params.toe)) * (1.0f - _2956)) * params.linearBegin)) + ((params.maxNit - (exp2((params.contrastFactor * color.r) + params.mulLinearStartContrastFactor) * params.displayMaxNitSubContrastFactor)) * _2983));
    _3046 = (((((params.contrast * color.g) + params.madLinearStartContrastFactor) * (_2965 - _2984)) + (((pow(_2957, params.toe)) * (1.0f - _2965)) * params.linearBegin)) + ((params.maxNit - (exp2((params.contrastFactor * color.g) + params.mulLinearStartContrastFactor) * params.displayMaxNitSubContrastFactor)) * _2984));
    _3047 = (((((params.contrast * color.b) + params.madLinearStartContrastFactor) * (_2974 - _2985)) + (((pow(_2966, params.toe)) * (1.0f - _2974)) * params.linearBegin)) + ((params.maxNit - (exp2((params.contrastFactor * color.b) + params.mulLinearStartContrastFactor) * params.displayMaxNitSubContrastFactor)) * _2985));

  return float3(_3045, _3046, _3047);
}

float3 HermiteSplineMaxCLL(float3 color, float tonemap_peak, float white_clip) {
  float rgb_max = renodx::math::Max(color);
  float rgb_max_log = log2(rgb_max);
  float tonemap_peak_log = log2(tonemap_peak);

  float tonemapped_log = renodx::tonemap::HermiteSplineRolloff(rgb_max_log, tonemap_peak_log, log2(white_clip));
  float tonemapped = exp2(tonemapped_log);

  float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
  return color * scale;
}

float3 ReinhardPiecewiseExtendedMaxCLL(float3 color, float rolloff_start, float tonemap_peak, float white_clip) {
  float rgb_max = renodx::math::Max(color);
  // float rgb_max = renodx::color::y::from::BT709(color); // by luminance for testing
  float rgb_max_log = log2(rgb_max);
  float tonemap_peak_log = log2(tonemap_peak);

  float tonemapped_log = renodx::tonemap::ReinhardPiecewiseExtended(rgb_max_log, log2(white_clip), tonemap_peak_log, log2(rolloff_start));
  float tonemapped = exp2(tonemapped_log);

  float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
  return color * scale;
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
  float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = renodx::color::grade::Shadows(y_highlighted, config.shadows, mid_gray);
  y_shadowed = max(0, y_shadowed);  // clamp to prevent artifacts

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHighlightSaturation(float3 tonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
      // perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(exp2(y) / (10000.f / 100.f), (1.f - config.dechroma))));
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

float3 PreTonemapSliders(float3 untonemapped, float mid_gray = 0.18f) {
  //if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped;

  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config, mid_gray);
  return outputColor;
}

float3 PostTonemapSliders(float3 hdr_color) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  float y = renodx::color::y::from::BT709(hdr_color);
  return ApplySaturationBlowoutHighlightSaturation(hdr_color, y, config);
}

float3 DisplayMap(float3 color, float white_clip) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
  float diffuse_white_nits = config.diffuse_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness

  color = max(0, renodx::color::bt2020::from::BT709(color));
  float tonemap_peak = peak_nits / diffuse_white_nits;

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    white_clip = min(500.f, max(100.f, white_clip));
    outputColor = HermiteSplineMaxCLL(color, peak_nits, white_clip);
  }

  outputColor = renodx::color::bt709::from::BT2020(outputColor);

  return outputColor;
}

float3 CustomTonemap(float3 untonemapped) {
  bool is_sdr = (tonemapParam_isHDRMode == 0.f);
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped);
  untonemapped_bt709 = PreTonemapSliders(untonemapped_bt709);

  // Roll off grading sliders to not clip
  float white_clip = 100.f;
  white_clip = max(100.f, PreTonemapSliders(white_clip).x);
  if (white_clip != 100.f) untonemapped_bt709 = ReinhardPiecewiseExtendedMaxCLL(untonemapped_bt709, 4.f, 100.f, white_clip);

  if (is_sdr) {
    
    float3 output_color = renodx::color::bt709::from::AP1(VanillaSDRTonemapper(renodx::color::ap1::from::BT709(untonemapped_bt709)));
    return renodx::color::ap1::from::BT709(output_color);
  }
  else if (RENODX_TONE_MAP_TYPE == 0.f) {
    return untonemapped;
  }

  float per_channel_peak = 20.f;
  float by_luminance_peak = 100.f;

  float y_in = renodx::color::y::from::BT709(untonemapped_bt709);
  float y_out = VanillaSDRTonemapper(y_in, by_luminance_peak).x;
  float3 tonemapped_bt709_lum = renodx::color::correct::Luminance(untonemapped_bt709, y_in, y_out);

  float3 tonemapped_bt2020_ch = VanillaSDRTonemapper(renodx::color::bt2020::from::BT709(untonemapped_bt709), per_channel_peak);
  float3 tonemapped_bt709_ch = renodx::color::bt709::from::BT2020(tonemapped_bt2020_ch);

  //tonemapped_bt709_ch = lerp(tonemapped_bt709_ch, tonemapped_bt709_lum, CUSTOM_SATURATION_CORRECTION);

  float3 hdr_color_bt709 = renodx::color::correct::Chrominance(tonemapped_bt709_lum, tonemapped_bt709_ch, 1.f, 0.f, 1);
  hdr_color_bt709 = renodx::color::correct::Hue(hdr_color_bt709, tonemapped_bt709_ch, 1, 1);

  hdr_color_bt709 = PostTonemapSliders(hdr_color_bt709);

  return renodx::color::ap1::from::BT709(hdr_color_bt709);
}