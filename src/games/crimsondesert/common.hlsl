#include "./shared.h"
#include "./psycho_test11_custom.hlsl"
#include "./macleod_boynton.hlsli"
#include "./lilium_rcas.hlsl"

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
  // float y_highlighted = HDRBoost(y_contrasted, config.highlights - 1.f, mid_gray);
  // float y_highlighted = renodx::color::grade::Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = renodx::color::grade::Shadows(y_highlighted, config.shadows, mid_gray, 1.f);
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

// float3 PreTonemapSliders(float3 untonemapped, float mid_gray = 0.18f) {
//   // if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped;

//   renodx::color::grade::Config config = renodx::color::grade::config::Create();
//   config.exposure = RENODX_TONE_MAP_EXPOSURE;
//   config.contrast = RENODX_TONE_MAP_CONTRAST;
//   config.flare = RENODX_TONE_MAP_FLARE;
//   config.shadows = RENODX_TONE_MAP_SHADOWS;
//   config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;

//   float y = renodx::color::y::from::BT709(untonemapped);
//   float3 outputColor = ApplyExposureContrastFlareHighlightsShadowsByLuminance(untonemapped, y, config, mid_gray);
//   return outputColor;
// }

// float3 PostTonemapSliders(float3 hdr_color) {
//   renodx::color::grade::Config config = renodx::color::grade::config::Create();
//   config.saturation = RENODX_TONE_MAP_SATURATION;
//   config.blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
//   config.dechroma = RENODX_TONE_MAP_BLOWOUT;
//   config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

//   float y = renodx::color::y::from::BT709(hdr_color);
//   hdr_color = ApplySaturationBlowoutHighlightSaturation(hdr_color, y, config);
//   //hdr_color = ApplyPerChannelBlowoutHueShift(hdr_color, 0.5f);
//   return hdr_color;
// }

// decode_type: 0 = PQ, 1 = sRGB, 2 = Gamma 2.2, 3 = Linear
float3 CustomPostProcessing(float3 color, float2 uv, Texture2D<float4> texture, SamplerState sampler, int decode_type, float pq_scaling = 100.f) {
  if (CUSTOM_SHARPENING_TYPE == 1) {
    color = ApplyRCAS(color, uv, texture, sampler, decode_type, pq_scaling);
  }
  if (CUSTOM_FILM_GRAIN_TYPE == 1) {
    color = renodx::effects::ApplyFilmGrain(color, uv, CUSTOM_RANDOM, CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  }
  return color;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 GammaCorrectionByLuminosity(float3 color, bool pow_to_srgb = false, float gamma = 2.2f) {
  float lumin_in = LuminosityFromBT709(color);
  float lumin_out = renodx::color::correct::GammaSafe(lumin_in, pow_to_srgb, gamma);
  float3 color_out = renodx::color::correct::Luminance(color, lumin_in, lumin_out);
  return color_out;
}

float3 CustomTonemap(float3 untonemapped_bt709, float mid_gray_scale = 1.f) {
  float calculated_peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  const float white_clip = 100.f;
  int white_curve_mode = 1;

  if (RENODX_GAMMA_CORRECTION > 0.f) {
    calculated_peak = RENODX_GAMMA_CORRECTION == 1.f ? renodx::color::correct::GammaSafe(calculated_peak, true) : GammaCorrectionByLuminosity(calculated_peak, true).x;
  }

  float3 output_color = untonemapped_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    float contrast = RENODX_TONE_MAP_CONTRAST;
    float saturation = RENODX_TONE_MAP_SATURATION;

    output_color = psychotm_test11(
        //output_color * 1.1539f,  // mid-gray adjusted
        output_color,
        calculated_peak,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        contrast / saturation,
        1.0,
        RENODX_TONE_MAP_BLOWOUT,
        white_clip,
        RENODX_TONE_MAP_HUE_RESTORE,  // hue_restore
        RENODX_TONE_MAP_ADAPTATION_CONTRAST,   // adaptation_contrast
        white_curve_mode,
        saturation,  // cone_response_exponent
        mid_gray_scale
    );
  }


  if (RENODX_GAMMA_CORRECTION > 0.f) {
    output_color = RENODX_GAMMA_CORRECTION == 1.f ? renodx::color::correct::GammaSafe(output_color) : GammaCorrectionByLuminosity(output_color);
  }

  return output_color;
}

float3 CustomTonemapSDR(float3 untonemapped_bt709, float mid_gray_scale) {
  //return renodx::tonemap::Reinhard(untonemapped_bt709);
  const float white_clip = 100.f;
  const int white_curve_mode = 1;
  float calculated_peak = 1.f;
  calculated_peak = CUSTOM_SDR_BLACK_CRUSH_FIX == 1 ? renodx::color::correct::GammaSafe(calculated_peak) : calculated_peak;
  
  float3 output_color = untonemapped_bt709;
  if (RENODX_TONE_MAP_TYPE == 1.f) {
    float contrast = RENODX_TONE_MAP_CONTRAST;
    float saturation = RENODX_TONE_MAP_SATURATION;

    output_color = psychotm_test11(
        // output_color * 1.1539f,  // mid-gray adjusted
        output_color,
        calculated_peak,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        contrast / saturation,
        1.0,
        RENODX_TONE_MAP_BLOWOUT,
        white_clip,
        RENODX_TONE_MAP_HUE_RESTORE,          // hue_restore
        RENODX_TONE_MAP_ADAPTATION_CONTRAST,  // adaptation_contrast
        white_curve_mode,
        saturation,  // cone_response_exponent
        mid_gray_scale
    );
    // float lumin_in = renodx::color::y::from::BT709(output_color);
    // float lumin_out = renodx::tonemap::ReinhardExtended(lumin_in, 4.f, calculated_peak);
    // output_color = renodx::color::correct::Luminance(output_color, lumin_in, lumin_out);

    // float scale = ComputeReinhardSmoothClampScale(output_color, 0.18f, calculated_peak, 4.f);
    // output_color *= scale;

    //output_color = renodx::tonemap::ReinhardExtended(output_color, 4.f, calculated_peak);

    //output_color = renodx::tonemap::ReinhardExtended(output_color, 4.f, calculated_peak);
  }

  return output_color;
}

float3 SampleSDRLUT(float3 color, SamplerState TrilinearClamp, Texture3D SrcLUT) {
  //color = renodx::color::pq::EncodeSafe(mul(renodx::color::AP1_TO_AP0_MAT, color), 100.f);  // Mimic first LUT
  color = renodx::color::pq::EncodeSafe(color, 100.f); // encode for lutbuilder input
  float4 _66 = SrcLUT.SampleLevel(TrilinearClamp, float3(((color.x * 0.984375f) + 0.0078125f), ((color.y * 0.984375f) + 0.0078125f), ((color.z * 0.984375f) + 0.0078125f)), 0.0f);
  _66.xyz = renodx::color::pq::DecodeSafe(_66.xyz, 100.f); // decode so it's linear out
  return _66.xyz;
}

float3 UpgradeToneMapMaxChannel(
    float3 color_untonemapped,
    float3 color_tonemapped,
    float3 color_tonemapped_graded,
    float post_process_strength = 1.f,
    float auto_correction = 1.f) {
  float ratio = 1.f;

  float max_untonemapped = renodx::math::Max(color_untonemapped);
  float max_tonemapped = renodx::math::Max(color_tonemapped);
  float max_tonemapped_graded = renodx::math::Max(color_tonemapped_graded);

  if (max_untonemapped < max_tonemapped) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    ratio = max_untonemapped / max_tonemapped;
  } else {
    float max_delta = max_untonemapped - max_tonemapped;
    max_delta = max(0, max_delta);  // Cleans up NaN
    const float max_new = max_tonemapped_graded + max_delta;

    const bool max_valid = (max_tonemapped_graded > 0);  // Cleans up NaN and ignore black
    ratio = max_valid ? (max_new / max_tonemapped_graded) : 0;
  }
  float auto_correct_ratio = lerp(1.f, ratio, saturate(max_untonemapped));
  ratio = lerp(ratio, auto_correct_ratio, auto_correction);

  float3 color_scaled = color_tonemapped_graded * ratio;

  return lerp(color_untonemapped, color_scaled, post_process_strength);
}

float3 ProcessGameOutput(float3 color, bool is_sdr) {
  if (!is_sdr) {
    color = renodx::color::srgb::Encode(color);
  }
  else {
    color = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::EncodeSafe(color, RENODX_DIFFUSE_WHITE_NITS);
  }
  return color;
}

float3 NakaRushton(float3 x, float3 peak = 1.0f, float3 anchor_in = 0.18f, float3 anchor_out = 0.18f, float cone_response_exponent = 1.f) {
  float3 peak_minus_anchor_out = peak - anchor_out;
  float3 n = cone_response_exponent * peak / peak_minus_anchor_out;
  float3 a_n = pow(anchor_in, n);
  float3 x_n = pow(x, n);
  float3 x_n_anchor_out = x_n * anchor_out;
  float3 num = peak * x_n_anchor_out;
  float3 den = mad(a_n, peak_minus_anchor_out, x_n_anchor_out);
  return num / den;
}