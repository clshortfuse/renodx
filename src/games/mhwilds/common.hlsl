#include "./shared.h"

float3 AP1toAP0(float3 color) {
  float _387 = mad(color.b, 0.1638689935207367f, mad(color.g, 0.1406790018081665f, (color.r * 0.6954519748687744f)));
  float _390 = mad(color.b, 0.0955343022942543f, mad(color.g, 0.8596709966659546f, (color.r * 0.04479460045695305f)));
  float _393 = mad(color.b, 1.0015000104904175f, mad(color.g, 0.004025210160762072f, (color.r * -0.00552588002756238f)));
  return float3(_387, _390, _393);
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return 1.f;
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  // color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
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

// float3 NeutwoMaxCLL(float3 color, float tonemap_peak, float white_clip) {
//   float rgb_max = renodx::math::Max(color);
//   float rgb_max_log = log2(rgb_max);
//   float tonemap_peak_log = log2(tonemap_peak);

//   float tonemapped_log = renodx::tonemap::Neutwo(rgb_max_log, tonemap_peak_log, log2(white_clip));
//   float tonemapped = exp2(tonemapped_log);

//   float scale = renodx::math::DivideSafe(tonemapped, rgb_max, 1.f);
//   return color * scale;
// }

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

// float HDRBoost(float color, float power = 0.20f, float normalization_point = 0.02f) {
//   const float smoothing = abs(power) * 2.f;

//   float target = normalization_point * pow(color / normalization_point, 1.f + power);
//   float blended = lerp(color, target, renodx::tonemap::Reinhard(color, smoothing));
//   return (power >= 0.f) ? max(color, blended) : min(color, blended);
//   // float highlight_compression_scale = saturate(pow(saturate((color - highlight_compression_start) / (highlight_compression_peak - highlight_compression_start)), highlight_compression_curve));
//   // float smoothed = lerp(blended, color, highlight_compression_scale);
//   // return smoothed;
// }

// float3 HDRBoost(float3 color, float power = 0.20f, float normalization_point = 0.02f) {
//   return float3(
//       HDRBoost(color.r, power, normalization_point),
//       HDRBoost(color.g, power, normalization_point),
//       HDRBoost(color.b, power, normalization_point)
//   );
// }

// float3 ApplyHDRBoost(float3 color, float power = 0.20f, int mode = 0, float normalization_point = 0.02f) {
//   if (power == 0.f) return color;

//   color = max(0, renodx::color::bt2020::from::BT709(color));

//   if (mode == 0) {  // Per Channel
//     color = HDRBoost(color, power, normalization_point);
//   } 
//   else if (mode == 1) {  // By Luminance
//     float y_in = renodx::color::y::from::BT709(color);
//     float y_out = HDRBoost(y_in, power, normalization_point);
//     color = renodx::color::correct::Luminance(color, y_in, y_out);
//   }

//   color = renodx::color::bt709::from::BT2020(color);
//   return color;
// }

float NR(float x, float sigma, float n) {
  float ax = abs(x);
  float xn = pow(max(ax, 0.0f), n);
  float sn = pow(max(sigma, 1e-6f), n);
  float r = xn / (xn + sn);
  return (x < 0.0f) ? -r : r;
}

float NR_inv(float r, float sigma, float n) {
  float ar = abs(r);
  float rc = min(ar, 1.0f - 1e-6f);
  float denom = max(1.0f - rc, 1e-6f);
  float x = sigma * pow(rc / denom, 1.0f / n);
  return (r < 0.0f) ? -x : x;
}

// CVVDP-style chroma plateau, but with a cone-domain Naka-Rushton stage.
// The NR semi-saturation is anchored to CastleCSF achromatic sensitivity
// at the adapting background (heuristic tie between detectability and cone gain).
float3 CastleDechroma_CVVDPStyle_NakaRushton(
    float3 rgb_lin,
    float Lbkg_nits = 100.f,
    float diffuse_white = 100.f,
    float nr_n = 1.00f,
    float nr_response_at_thr = 0.18f) {
  // --------------------------------------------------------------------------
  // 1) Convert stimulus + background to LMS and apply cone-domain NR
  // --------------------------------------------------------------------------
  float3x3 XYZ_TO_LMS_2006 = float3x3(
      0.185082982238733f, 0.584081279463687f, -0.0240722415044404f,
      -0.134433056469973f, 0.405752392775348f, 0.0358252602217631f,
      0.000789456671966863f, -0.000912281325916184f, 0.0198490812339463f);

  float3x3 XYZ_TO_LMS_PROPOSED_2023 = float3x3(
      0.185083290265044, 0.584080232530060, -0.0240724126371618,
      -0.134432464433222, 0.405751419882862, 0.0358251078084051,
      0.000789395399878065, -0.000912213029667692, 0.0198489810108856);

  XYZ_TO_LMS_2006 = XYZ_TO_LMS_PROPOSED_2023;

  const float3x3 LMS_TO_XYZ_2006 = renodx::math::Invert3x3(XYZ_TO_LMS_2006);
  const float3x3 BT709_TO_XYZ = renodx::color::BT709_TO_XYZ_MAT;
  const float3x3 XYZ_TO_BT709 = renodx::color::XYZ_TO_BT709_MAT;
  float3x3 BT709_TO_LMS = mul(XYZ_TO_LMS_2006, BT709_TO_XYZ);

  float3 stim_nits = rgb_lin * diffuse_white;
  float3 lms_stim = mul(BT709_TO_LMS, stim_nits);

  float3 lms_bg = mul(BT709_TO_LMS, float3(1, 1, 1) * Lbkg_nits);

  // CastleCSF sensitivity at background (achromatic) -> contrast threshold proxy.
  const float rho = 1.0f;
  const float omega = 0.0f;
  const float ecc = 0.0f;
  const float vis_field = 0.0f;
  const float area = 3.14159265358979323846f;
  float S_ach = renodx::color::castlecsf::Eq27_29_MechSens(rho, omega, ecc, vis_field, area, Lbkg_nits).x;
  float c_thr = 1.0f / max(S_ach, 1e-6f);

  float r_target = clamp(nr_response_at_thr, 1e-3f, 0.999f);
  float sigma_scale = pow((1.0f - r_target) / r_target, 1.0f / max(nr_n, 1e-3f));
  float x_ref = 1.0f + c_thr;

  // Contrast-domain NR: normalize by background LMS so neutral stays neutral.
  float sigma_rel = max(x_ref * sigma_scale, 1e-6f);
  float3 lms_rel = lms_stim / max(abs(lms_bg), float3(1e-6f, 1e-6f, 1e-6f));

  float3 lms_rel_nr = float3(
      NR(lms_rel.x, sigma_rel, nr_n),
      NR(lms_rel.y, sigma_rel, nr_n),
      NR(lms_rel.z, sigma_rel, nr_n));
  float bg_rel_nr = NR(1.0f, sigma_rel, nr_n);

  float3 lms_stim_nr = lms_rel_nr * lms_bg;
  float3 lms_bg_nr = bg_rel_nr.xxx * lms_bg;

  // Test output
  float luminance_in = renodx::color::y::from::BT709(rgb_lin);
  float3 testout = mul(XYZ_TO_BT709, mul(LMS_TO_XYZ_2006, lms_stim_nr)) / diffuse_white;
  float luminance_out = renodx::color::y::from::BT709(testout);
  return testout * luminance_in / luminance_out;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
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
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);
  //float y_highlighted = HDRBoost(y_contrasted, config.highlights - 1.f, mid_gray);
  //float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);

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
    
    if (config.dechroma != 0.f) {
      // perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
      //  perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(exp2(y) / (10000.f / 100.f), (1.f - config.dechroma))));
      color = CastleDechroma_CVVDPStyle_NakaRushton(color, lerp(1.f, 10000.f, saturate(1.f - pow(config.dechroma, 0.0144f))));
    }

    float3 perceptual_new = renodx::color::oklab::from::BT709(color);


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
  // if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped;

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

  // if (CUSTOM_TONE_MAP_PARAMETERS == 0) {
  //   config.swap_chain_scaling_nits = renodx::color::correct::GammaSafe(config.swap_chain_scaling_nits);
  // }

  float peak_nits = config.peak_white_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes peak
  float diffuse_white_nits = config.swap_chain_scaling_nits / renodx::color::srgb::REFERENCE_WHITE;  // Normalizes game brightness | swap chain scaling nits because of use in shared.h

  //peak_nits = renodx::color::correct::GammaSafe(peak_nits);
  //diffuse_white_nits = renodx::color::correct::GammaSafe(diffuse_white_nits);

  color = max(0, renodx::color::bt2020::from::BT709(color));
  float tonemap_peak = peak_nits / diffuse_white_nits;

  if (CUSTOM_TONE_MAP_PARAMETERS == 0) {
    tonemap_peak = renodx::color::correct::GammaSafe(tonemap_peak, true);
  }

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    white_clip = max(100.f, white_clip);
    outputColor = renodx::tonemap::neutwo::MaxChannel(color, tonemap_peak, white_clip);
  }

  outputColor = renodx::color::bt709::from::BT2020(outputColor);

  if (CUSTOM_TONE_MAP_PARAMETERS == 0) {
    outputColor = renodx::color::correct::GammaSafe(outputColor);
  }

  return outputColor;
}

float3 SDRDisplayMap(float3 color, float white_clip) {
  renodx::draw::Config config = renodx::draw::BuildConfig();  // Pulls config values

  float peak = 1.f;

  if (CUSTOM_TONE_MAP_PARAMETERS == 1) {
    peak = renodx::color::correct::GammaSafe(peak, false);
  }

  color = max(0, renodx::color::bt2020::from::BT709(color));

  float3 outputColor = color;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    white_clip = max(20.f, white_clip);
    outputColor = renodx::tonemap::neutwo::MaxChannel(color, peak, white_clip);
  }

  outputColor = renodx::color::bt709::from::BT2020(outputColor);
  return outputColor;
}