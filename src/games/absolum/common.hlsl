#include "./shared.h"
//#include "./lilium_rcas.hlsl"

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 1.0f, float output_max = 100.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return saturate(color);
  }
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float3 ToneMapMaxCLLClip(float3 color, float rolloff_start = 0.75f, float output_max = 1.f, float white_clip = 100.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);
  float white_clip_log = log2(white_clip);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max), white_clip_log);
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
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
  //float rgb_max = renodx::color::y::from::BT709(color); // by luminance for testing
  float rgb_max_log = log2(rgb_max);
  float tonemap_peak_log = log2(tonemap_peak);

  float tonemapped_log = renodx::tonemap::ReinhardPiecewiseExtended(rgb_max_log, log2(white_clip), tonemap_peak_log, log2(rolloff_start));
  float tonemapped = exp2(tonemapped_log);

  float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
  return color * scale;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return 1.f;
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

void GamutCompression(inout float3 color, inout float compression_scale) {
  color = renodx::color::bt709::clamp::AP1(color);
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  float grayscale = renodx::color::y::from::BT709(gamma_color.rgb);
  compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, grayscale);
  gamma_color = renodx::color::correct::GamutCompress(gamma_color, grayscale, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
  color = renodx::color::bt709::clamp::BT709(color);
}

void GamutDecompression(inout float3 color, float compression_scale) {
  color = renodx::color::bt709::clamp::BT709(color);
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  gamma_color = renodx::color::correct::GamutDecompress(gamma_color, compression_scale);
  color = renodx::color::gamma::DecodeSafe(gamma_color);
}

float HDRBoost(float color, float power = 0.20f, float normalization_point = 0.02f) {
  const float smoothing = power * 2.f;

  float boosted = max(color, lerp(color, normalization_point * pow(color / normalization_point, 1.f + power), renodx::tonemap::Reinhard(color, smoothing)));
  // float highlight_compression_scale = saturate(pow(saturate((color - highlight_compression_start) / (highlight_compression_peak - highlight_compression_start)), highlight_compression_curve));
  // float smoothed = lerp(boosted, color, highlight_compression_scale);
  return boosted;
  //return smoothed;
}

float3 HDRBoost(float3 color, float power = 0.20f, float normalization_point = 0.02f) {
  return float3(
      HDRBoost(color.r, power, normalization_point),
      HDRBoost(color.g, power, normalization_point),
      HDRBoost(color.b, power, normalization_point)
  );
}

float3 ApplyHDRBoost(float3 color, float power = 0.20f, int mode = 0, float normalization_point = 0.02f) {

  color = max(0, renodx::color::bt2020::from::BT709(color));

  if (mode == 0) {  // Per Channel
    //color = HDRBoost(color, power, normalization_point);
    //color = renodx::tonemap::ReinhardPiecewiseExtended(color, HDRBoost(100.f, power, normalization_point), 100.f, 1.f);
    //color = ToneMapMaxCLLClip(color, 1.f, 100.f, HDRBoost(100.f, power, normalization_point));
  } 
  else if (mode == 1) {  // By Luminance
    float y_in = renodx::color::y::from::BT709(color);
    float y_out = HDRBoost(y_in, power, normalization_point);
    //float y_out = BoostHDR(y_in, 10.f, power, 0.18f);
    //y_out = exp2(renodx::tonemap::ExponentialRollOff(log2(y_out), log2(1.f), log2(100.f), log2(HDRBoost(100.f, power, normalization_point))));
    color = renodx::color::correct::Luminance(color, y_in, y_out);
    // color = ToneMapMaxCLLClip(color, 1.f, 100.f, HDRBoost(100.f, power, normalization_point));
    //color = NeuTwoMaxCLL(color, 100.f, HDRBoost(100.f, power, normalization_point));
    //color = HermiteSplineMaxCLL(color, 100.f, HDRBoost(100.f, power, normalization_point));
    //color = ReinhardPiecewiseExtendedMaxCLL(color, 100.f, HDRBoost(100.f, power, normalization_point));
  }

  color = renodx::color::bt709::from::BT2020(color);
  return color;
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
  y_shadowed = max(0, y_shadowed); //clamp to prevent artifacts

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
      //perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(exp2(y) / (10000.f / 100.f), (1.f - config.dechroma))));
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

// float3 ApplyPerChannelBlowoutHueShiftHueClip(float3 untonemapped, float mid_gray = 0.18f, float sdr_max = 1.f) {
//   if (RENODX_SWAP_CHAIN_OUTPUT_PRESET == 0.f) return untonemapped;
  
//   float max_clip = 100.f;
//   float3 color = untonemapped;

//   color = max(0, renodx::color::bt2020::from::BT709(color));

//   if (SCENE_GRADE_PER_CHANNEL_BLOWOUT > 0.f && RENODX_SWAP_CHAIN_OUTPUT_PRESET != 0.f) {
//     max_clip = SCENE_GRADE_PER_CHANNEL_BLOWOUT;
//     float calculated_peak = max_clip + (sdr_max - 1.f);
//     calculated_peak = max(calculated_peak, 1.f);

//     // float calculated_peak_log = log2(calculated_peak);
//     // float mid_gray_log = log2(mid_gray);
//     // float3 untonemapped_log = log2(color);

//     //untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

//     float3 graded_color = renodx::tonemap::ReinhardPiecewise(color, calculated_peak, mid_gray);
//     //float3 graded_color = renodx::tonemap::HermiteSplinePerChannelRolloff(color, calculated_peak, 100.f);
//     color = renodx::color::correct::Chrominance(color, graded_color, 1.f, 0.f, 1);
//     color = renodx::color::correct::Hue(color, graded_color, SCENE_GRADE_PER_CHANNEL_HUE_SHIFT, 1);
//   }
//   if (SCENE_GRADE_HUE_CLIP > 0.f) {
//     float3 hue_clipped_color = renodx::tonemap::ExponentialRollOff(color, 1.75f, 2.f);
//     color = renodx::color::correct::Hue(color, hue_clipped_color, SCENE_GRADE_HUE_CLIP, 0);
//   }
//   color = renodx::color::bt709::from::BT2020(color);
//   return color;
// }


float3 PreTonemapSliders(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped;
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = RENODX_TONE_MAP_FLARE;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

  float y = renodx::color::y::from::BT709(untonemapped);
  float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config);
  outputColor = ApplyHDRBoost(outputColor, CUSTOM_HDR_BOOST, 1, 0.04f);
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

// PsychoTM Beta4 (With N2 Per-Channel -- Neutral) [displaymap only]
// Basically N2 "By Luminosity"
float3 psychotm_test4_onlymap(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float hue_restore = 0.f) {
  const float kEps = 1e-6f;
  float3 bt2020 = renodx::color::bt2020::from::BT709(bt709_linear_input * 1.f);  // Used to be exposure, hardcoded to 1.f
  static const float3x3 XYZ_TO_LMS_2006 = renodx::color::XYZ_TO_STOCKMAN_SHARP_LMS_MAT;
  static const float3x3 XYZ_FROM_LMS_2006 = renodx::math::Invert3x3(XYZ_TO_LMS_2006);

  // Match BT709WithBT2020 slider behavior for brightness-domain controls.
  float3 midgray_xyz = renodx::color::xyz::from::BT2020(0.18f);
  float3 midgray_lms = mul(XYZ_TO_LMS_2006, midgray_xyz);
  float mid_gray_luminosity = 1.55f * midgray_lms.x + midgray_lms.y;

  float3 color_xyz = renodx::color::xyz::from::BT2020(bt2020);
  float3 color_lms = mul(XYZ_TO_LMS_2006, color_xyz);
  float current_luminosity = 1.55f * color_lms.x + color_lms.y;
  float luminosity = current_luminosity;

  float luminosity_scale = renodx::math::DivideSafe(luminosity, current_luminosity, 1.f);
  bt2020 *= luminosity_scale;

  // Fixed white basis: D65.
  float3 lms_raw = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(bt2020));
  float3 lms_white = mul(XYZ_TO_LMS_2006, renodx::color::xyz::from::BT2020(1.f));
  float vstar_white = 1.55f * lms_white.x + lms_white.y;
  float3 midgray_lms_anchor = lms_white * 0.18f;

  float3 lms_raw_source = lms_raw;

  float3 lms = lms_raw;

  // // Fixed white curve: Naka-Rushton to peak, per LMS channel (inline equation).
  // float3 lms_peak = lms_white * peak_value;
  // float exponent_tone = max(cone_response_exponent, kEps);
  // float3 p = max(lms_peak, kEps.xxx);
  // float3 g = clamp(midgray_lms_anchor, kEps.xxx, p - kEps.xxx);
  // float3 n = exponent_tone * p / max(p - g, kEps.xxx);
  // float3 sign_lms = float3(
  //     lms.x < 0.f ? -1.f : 1.f,
  //     lms.y < 0.f ? -1.f : 1.f,
  //     lms.z < 0.f ? -1.f : 1.f);
  // float3 ax_lms = abs(lms);
  // float3 sigma_n = pow(g, n - 1.f) * (p - g);
  // float3 x_n = pow(ax_lms, n);
  // float3 y = p * (x_n / max(x_n + sigma_n, kEps.xxx));
  // float3 lms_toned = sign_lms * y;

  // Trying out Per-Channel N2 in LMS
  float3 lms_peak = lms_white * peak_value;
  float3 peak = max(lms_peak, kEps.xxx);
  float3 sign_lms = float3(
      lms.x < 0.f ? -1.f : 1.f,
      lms.y < 0.f ? -1.f : 1.f,
      lms.z < 0.f ? -1.f : 1.f);
  float3 abs_lms = abs(lms);
  float3 n2_lms = renodx::tonemap::neutwo::PerChannel(abs_lms, peak);
  float3 lms_toned = sign_lms * n2_lms;

  // Inline hue-preserve after tonemap.
  if (hue_restore > 0.f) {
    float vstar_source = 1.55f * lms.x + lms.y;
    float vstar_target = 1.55f * lms_toned.x + lms_toned.y;
    float3 lms_white_source = lms_white * renodx::math::DivideSafe(vstar_source, vstar_white, 0.f);
    float3 lms_white_target = lms_white * renodx::math::DivideSafe(vstar_target, vstar_white, 0.f);
    float3 dir_source = lms - lms_white_source;
    float3 dir_target = lms_toned - lms_white_target;
    float len_source = length(dir_source);
    float len_target = length(dir_target);
    if (len_source > 0.f && len_target > 0.f) {
      float chroma_scale = renodx::math::DivideSafe(len_target, len_source, 0.f);
      float3 lms_hue_preserved = lms_white_target + dir_source * chroma_scale;
      lms_toned = lerp(lms_toned, lms_hue_preserved, hue_restore);
    }
  }

  float3 bt2020_toned = renodx::color::bt2020::from::XYZ(mul(XYZ_FROM_LMS_2006, lms_toned));
  // bt2020_toned = BT2020MapAnyToBoundsLMS(bt2020_toned, 0.f);
  return renodx::color::bt709::from::BT2020(bt2020_toned);
}

float3 DisplayMap(float3 color) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

   float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;              // Normalizes peak
   float diffuse_white_nits = config.graphics_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness

   float tonemap_peak = RENODX_SWAP_CHAIN_OUTPUT_PRESET == 0.f ? 1.f : peak_nits / diffuse_white_nits;

   if (config.gamma_correction > 0.f) {
     tonemap_peak = renodx::color::correct::GammaSafe(tonemap_peak, config.gamma_correction > 0.f, abs(RENODX_GAMMA_CORRECTION) == 1.f ? 2.2f : 2.4f);
   }
   
   float3 outputColor = color;
   if (RENODX_TONE_MAP_TYPE == 1.f) {
     outputColor = psychotm_test4_onlymap(color, tonemap_peak);
  }

  return outputColor;
}

float3 ApplyRenoDXPostProcessing(float3 color, float2 TEXCOORD) {
  float3 outputColor = color;
  outputColor = renodx::effects::ApplyFilmGrain(
      outputColor,
      float2(TEXCOORD.x, TEXCOORD.y),
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  return outputColor;
}

float3 CustomTonemap(float3 untonemapped) {
  untonemapped = renodx::color::srgb::DecodeSafe(untonemapped);
  if (RENODX_TONE_MAP_TYPE == 0) {
    return saturate(untonemapped);
  }
  untonemapped = PreTonemapSliders(untonemapped);
  untonemapped = PostTonemapSliders(untonemapped);
  float3 tonemapped = DisplayMap(untonemapped);
  return tonemapped;
}