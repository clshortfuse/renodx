#include "./shared.h"

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

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 untonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_correction_strength != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.hue_correction_strength != 0.f) {
      float3 perceptual_old = renodx::color::oklab::from::BT709(untonemapped);

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

float3 BT709GamutCompressBT2020(float3 color) {
  // clamp to AP1
  color = max(0, renodx::color::ap1::from::BT709(color));
  color = renodx::color::bt2020::from::AP1(color);

  // compress to BT.2020 in gamma space
  float3 gamma_color = renodx::color::gamma::EncodeSafe(color);
  float grayscale = renodx::color::y::from::BT2020(gamma_color.rgb);
  float compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, grayscale);
  gamma_color = renodx::color::correct::GamutCompress(gamma_color, grayscale, compression_scale);

  // back to BT.709 linear
  color = renodx::color::gamma::DecodeSafe(gamma_color);
  color = renodx::color::bt709::from::BT2020(color);

  return color;
}

float3 HueAndChrominanceOKLab(
    float3 incorrect_color,
    float3 chrominance_reference_color,
    float3 hue_reference_color,
    float hue_correct_strength = 1.f,
    float clamp_chrominance_loss = 0.f,
    float highlight_saturation = 1.f) {
  if (hue_correct_strength == 0.f && highlight_saturation == 1.f)
    return renodx::color::correct::ChrominanceOKLab(incorrect_color, chrominance_reference_color, 1.f, clamp_chrominance_loss);

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 hue_lab = renodx::color::oklab::from::BT709(hue_reference_color);
  float3 chrominance_lab = renodx::color::oklab::from::BT709(chrominance_reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 hue_ab = hue_lab.yz;

  // Always use chrominance magnitude from chrominance reference
  float target_chrominance = length(chrominance_lab.yz);

  // Compute blended hue direction
  float2 blended_ab_dir = normalize(lerp(normalize(incorrect_ab), normalize(hue_ab), hue_correct_strength));

  // Compute current chrominance (magnitude of the a–b vector)
  float current_chrominance = length(incorrect_ab);

  // Compute chrominance ratio and scale, with clamping
  float chrominance_ratio = renodx::math::DivideSafe(target_chrominance, current_chrominance, 1.f);
  float scale = chrominance_ratio;
  float t = 1.0f - step(1.0f, scale);  // t = 1 when scale < 1, 0 when scale >= 1
  scale = lerp(scale, 1.0f, t * clamp_chrominance_loss);

  // Apply chrominance magnitude from chrominance_reference_color, with clamping
  float2 final_ab = blended_ab_dir * current_chrominance * scale;

  incorrect_lab.yz = final_ab;

  if (highlight_saturation != 1.f) {
    highlight_saturation = -1.f * (highlight_saturation - 1.f);
    float y = renodx::color::y::from::BT709(incorrect_color);

    float percent_max = saturate(y * 100.f / 10000.f);
    // positive = 1 to 0, negative = 1 to 2
    float blowout_strength = 100.f;
    float blowout_change = pow(1.f - percent_max, blowout_strength * abs(highlight_saturation));
    if (highlight_saturation < 0) {
      blowout_change = (2.f - blowout_change);
    }

    incorrect_lab.yz *= blowout_change;
  }

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.5f, float output_max = 1.f, float white_clip = 100.f) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 0.f);

  return scale;
}

float3 InverseReinhardScalablePiecewise(float3 color, float channel_max = 1.f, float shoulder = 0.18f) {
  float channel_min = 0.f;
  float exposure = (channel_max * (channel_min * shoulder + channel_min - shoulder))
                   / (shoulder * (shoulder - channel_max));

  float3 numerator = -channel_max * (channel_min * color + channel_min - color);
  float3 denominator = (exposure * (channel_max - color));
  float3 inversed = renodx::math::DivideSafe(numerator, denominator, renodx::math::FLT16_MAX);

  return lerp(color, inversed, step(shoulder, color));
}

void ApplyToneMap(inout bool hdr_enabled,
                  float3 untonemapped_sdr,
                  float3 untonemapped_hdr,
                  inout float output_r, inout float output_g, inout float output_b,
                  float CB1_m2_x,
                  float _515, float _516, float _517, float _519, float _520, float _521, float _522,
                  float _808) {
  float _875, _876, _877;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _875 = hdr_enabled ? (CB1_m2_x * (((mad(untonemapped_hdr.r, mad(_515, untonemapped_hdr.r, _519), _520) / mad(untonemapped_hdr.r, mad(_515, untonemapped_hdr.r, _516), _521)) - _522) * _808)) : clamp(_517 * ((mad(untonemapped_sdr.r, mad(_515, untonemapped_sdr.r, _519), _520) / mad(untonemapped_sdr.r, mad(_515, untonemapped_sdr.r, _516), _521)) - _522), 0.0f, 1.0f);
    _876 = hdr_enabled ? (CB1_m2_x * (_808 * ((mad(mad(_515, untonemapped_hdr.g, _519), untonemapped_hdr.g, _520) / mad(mad(_515, untonemapped_hdr.g, _516), untonemapped_hdr.g, _521)) - _522))) : clamp(_517 * ((mad(mad(_515, untonemapped_sdr.g, _519), untonemapped_sdr.g, _520) / mad(mad(_515, untonemapped_sdr.g, _516), untonemapped_sdr.g, _521)) - _522), 0.0f, 1.0f);
    _877 = hdr_enabled ? (CB1_m2_x * (_808 * ((mad(mad(_515, untonemapped_hdr.b, _519), untonemapped_hdr.b, _520) / mad(mad(_515, untonemapped_hdr.b, _516), untonemapped_hdr.b, _521)) - _522))) : clamp(_517 * ((mad(mad(_515, untonemapped_sdr.b, _519), untonemapped_sdr.b, _520) / mad(mad(_515, untonemapped_sdr.b, _516), untonemapped_sdr.b, _521)) - _522), 0.0f, 1.0f);
  } else {
    float3 hdr_tonemap = untonemapped_sdr;

    hdr_enabled = false;  // use SDR tonemapper
    _875 = hdr_enabled ? (CB1_m2_x * (((mad(untonemapped_hdr.r, mad(_515, untonemapped_hdr.r, _519), _520) / mad(untonemapped_hdr.r, mad(_515, untonemapped_hdr.r, _516), _521)) - _522) * _808)) : _517 * ((mad(untonemapped_sdr.r, mad(_515, untonemapped_sdr.r, _519), _520) / mad(untonemapped_sdr.r, mad(_515, untonemapped_sdr.r, _516), _521)) - _522);
    _876 = hdr_enabled ? (CB1_m2_x * (_808 * ((mad(mad(_515, untonemapped_hdr.g, _519), untonemapped_hdr.g, _520) / mad(mad(_515, untonemapped_hdr.g, _516), untonemapped_hdr.g, _521)) - _522))) : _517 * ((mad(mad(_515, untonemapped_sdr.g, _519), untonemapped_sdr.g, _520) / mad(mad(_515, untonemapped_sdr.g, _516), untonemapped_sdr.g, _521)) - _522);
    _877 = hdr_enabled ? (CB1_m2_x * (_808 * ((mad(mad(_515, untonemapped_hdr.b, _519), untonemapped_hdr.b, _520) / mad(mad(_515, untonemapped_hdr.b, _516), untonemapped_hdr.b, _521)) - _522))) : _517 * ((mad(mad(_515, untonemapped_sdr.b, _519), untonemapped_sdr.b, _520) / mad(mad(_515, untonemapped_sdr.b, _516), untonemapped_sdr.b, _521)) - _522);

    float3 ch_tonemap = float3(_875, _876, _877);

    float mid_gray = hdr_enabled ? (CB1_m2_x * (_808 * ((mad(mad(_515, 0.18, _519), 0.18, _520) / mad(mad(_515, 0.18, _516), 0.18, _521)) - _522))) : _517 * ((mad(mad(_515, 0.18, _519), 0.18, _520) / mad(mad(_515, 0.18, _516), 0.18, _521)) - _522);
    float3 untonemapped_mid_gray_shifted = untonemapped_sdr * mid_gray / 0.18f;

    const float highlight_saturation = 1.f;
    if (RENODX_TONE_MAP_PER_CHANNEL) {
      hdr_tonemap = lerp(ch_tonemap, untonemapped_mid_gray_shifted, saturate(renodx::color::y::from::BT709(ch_tonemap)));
      hdr_tonemap = HueAndChrominanceOKLab(hdr_tonemap, ch_tonemap, untonemapped_mid_gray_shifted, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_BLOWOUT_RESTORATION, highlight_saturation);
    } else {
      float y_in = renodx::color::y::from::BT709(untonemapped_sdr);
      float y_out = hdr_enabled ? (CB1_m2_x * (_808 * ((mad(mad(_515, y_in, _519), y_in, _520) / mad(mad(_515, y_in, _516), y_in, _521)) - _522))) : _517 * ((mad(mad(_515, y_in, _519), y_in, _520) / mad(mad(_515, y_in, _516), y_in, _521)) - _522);
      float3 lum_tonemap = renodx::color::correct::Luminance(untonemapped_sdr, y_in, y_out, 1.f);

      // 0 - (midgray * 1.5): lum tonemap
      // (midgray * 1.5) - 1: ch tonemap
      //                  >1: untonemapped mid gray shifted
      lum_tonemap = lerp(lum_tonemap, ch_tonemap, saturate(renodx::color::y::from::BT709(lum_tonemap) / (mid_gray * 1.5f)));
      hdr_tonemap = lerp(lum_tonemap, untonemapped_mid_gray_shifted, saturate(renodx::color::y::from::BT709(lum_tonemap)));
      hdr_tonemap = HueAndChrominanceOKLab(hdr_tonemap, ch_tonemap, untonemapped_mid_gray_shifted, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_BLOWOUT_RESTORATION, highlight_saturation);

      float3 gamma_color = renodx::color::gamma::EncodeSafe(hdr_tonemap);
      gamma_color = renodx::color::correct::GamutCompress(gamma_color, renodx::color::y::from::BT709(gamma_color));
      hdr_tonemap = renodx::color::gamma::DecodeSafe(gamma_color);
    }
    hdr_tonemap = max(0, hdr_tonemap);

    _875 = hdr_tonemap.r, _876 = hdr_tonemap.g, _877 = hdr_tonemap.b;
  }
  output_r = _875, output_g = _876, output_b = _877;
  return;
}

#define DECODE_LUT_GENERATOR(T)                                                               \
  T DecodeLUT(T encoded, float linear_scale, float exp_scale, float exp_mul, float exp_sub) { \
    T threshold = linear_scale * 0.0031308f;                                                  \
    T lin = encoded / linear_scale;                                                           \
    T exp = exp2(log2((encoded + exp_sub) / exp_mul) / exp_scale);                            \
    /* 0 if encoded < threshold, 1 if encoded >= threshold */                                 \
    return lerp(lin, exp, step(threshold, encoded));                                          \
  }
DECODE_LUT_GENERATOR(float)
DECODE_LUT_GENERATOR(float3)

#define ENCODE_LUT_GENERATOR(T)                                                                    \
  T EncodeLUT(T color_linear, float linear_scale, float exp_scale, float exp_mul, float exp_sub) { \
    T lin = color_linear * linear_scale;                                                           \
    T exp = mad(exp_mul, pow(color_linear, exp_scale), -exp_sub);                                  \
    /* lin if < threshold, exp if >= threshold */                                                  \
    return lerp(lin, exp, step(0.0031308f, color_linear));                                         \
  }
ENCODE_LUT_GENERATOR(float)
ENCODE_LUT_GENERATOR(float3)

void EncodeForLUT(inout bool skip_encoding, float linear_r, float linear_g, float linear_b,
                  float linear_scale, float exp_scale, float exp_mul, float exp_sub,
                  inout float encoded_r, inout float encoded_g, inout float encoded_b) {
  if (RENODX_TONE_MAP_TYPE != 0.f) skip_encoding = false;  // use SDR code path

  float3 encoded;
  float3 color_linear = float3(linear_r, linear_g, linear_b);
  if (USE_SRGB_LUT_ENCODING) {
    encoded = skip_encoding ? color_linear : renodx::color::srgb::EncodeSafe(color_linear);
  } else {
    encoded = skip_encoding ? color_linear : EncodeLUT(color_linear, linear_scale, exp_scale, exp_mul, exp_sub);
  }
  encoded_r = encoded.r, encoded_g = encoded.g, encoded_b = encoded.b;
  return;
}

void PrepareForLUT(inout float r, inout float g, inout float b, inout float3 color_sdr, inout float3 color_hdr, inout float max_channel) {
  color_hdr = float3(r, g, b);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    max_channel = 1.f;
    float3 untonemapped_linear = renodx::color::srgb::DecodeSafe(color_hdr);
#if 1
    float y_in = renodx::color::y::from::BT709(untonemapped_linear);
    float y_out = renodx::tonemap::ReinhardPiecewiseExtended(y_in, 100.f, 1.f, 0.3f);

    float3 tonemapped = renodx::color::correct::Luminance(untonemapped_linear, y_in, y_out);
#else
    float3 tonemapped = untonemapped_linear * ComputeReinhardSmoothClampScale(untonemapped_linear, 0.3f, 1.f, 100.f);
#endif

    tonemapped = renodx::color::srgb::Encode(saturate(tonemapped));

    color_sdr = tonemapped;
    r = tonemapped.r, g = tonemapped.g, b = tonemapped.b;
  }
  return;
}

void UpgradeLUTOutput(float3 color_hdr, float3 color_sdr, inout float color_processed_r, inout float color_processed_g, inout float color_processed_b) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color_hdr_linear = renodx::color::srgb::DecodeSafe(color_hdr);
    float3 color_sdr_linear = renodx::color::srgb::DecodeSafe(color_sdr);
    float3 color_processed_linear = renodx::color::srgb::DecodeSafe(float3(color_processed_r, color_processed_g, color_processed_b));
    // float3 color_processed_linear = (float3(color_processed_r, color_processed_g, color_processed_b));
    float3 upgraded = renodx::color::srgb::EncodeSafe(renodx::tonemap::UpgradeToneMap(color_hdr_linear, color_sdr_linear, color_processed_linear, RENODX_COLOR_GRADE_STRENGTH));
    color_processed_r = upgraded.r, color_processed_g = upgraded.g, color_processed_b = upgraded.b;
    // color_processed_r = color_processed_linear.r, color_processed_g = color_processed_linear.g, color_processed_b = color_processed_linear.b;
  }
  return;
}

float3 ApplyHermiteSplineByMaxChannel(float3 input, float diffuse_nits, float peak_nits) {
  const float peak_ratio = peak_nits / diffuse_nits;
  float white_clip = max(RENODX_TONE_MAP_WHITE_CLIP, peak_ratio * 1.5f);  // safeguard to prevent artifacts

  float max_channel = renodx::math::Max(input.r, input.g, input.b);

  float max_pq = renodx::color::pq::Encode(max_channel, diffuse_nits);
  float target_white_pq = renodx::color::pq::Encode(peak_nits, 1.f);
  float max_white_pq = renodx::color::pq::Encode(white_clip, diffuse_nits);
  float target_black_pq = renodx::color::pq::Encode(0.0001f, 1.f);
  float min_black_pq = renodx::color::pq::Encode(0.f, 1.f);

  float scaled_pq = renodx::tonemap::HermiteSplineRolloff(max_pq, target_white_pq, max_white_pq, target_black_pq, min_black_pq);

  float mapped_max = renodx::color::pq::Decode(scaled_pq, diffuse_nits);
  mapped_max = min(mapped_max, peak_ratio);

  float scale = renodx::math::DivideSafe(mapped_max, max_channel, 0.f);
  return input * scale;
}

float3 ApplyGammaCorrectionByLuminance(float3 color_input, bool pow_to_srgb = false) {
  float y_in = renodx::color::y::from::BT709(color_input);
  float y_out = renodx::color::correct::Gamma(max(0, y_in), pow_to_srgb);
  float3 color_output = renodx::color::correct::Luminance(color_input, y_in, y_out);

  return color_output;
}

float3 ApplyDisplayMap(float3 undisplaymapped) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.hue_correction_strength = 0.f;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    undisplaymapped = ApplyGammaCorrectionByLuminance(undisplaymapped);
  }

  float y = renodx::color::y::from::BT709(undisplaymapped);
  float3 displaymapped = ApplyExposureContrastFlareHighlightsShadowsByLuminance(undisplaymapped, y, cg_config, 0.18f);
  displaymapped = ApplySaturationBlowoutHueCorrectionHighlightSaturation(displaymapped, undisplaymapped, y, cg_config);

  // float3 gamma_color = renodx::color::gamma::EncodeSafe(displaymapped);
  // gamma_color = renodx::color::correct::GamutCompress(gamma_color, renodx::color::y::from::BT709(gamma_color));
  // displaymapped = renodx::color::gamma::DecodeSafe(gamma_color);

  if (RENODX_TONE_MAP_TYPE == 2.f) {
    displaymapped = renodx::color::bt709::from::BT2020(ApplyHermiteSplineByMaxChannel(
        renodx::color::bt2020::from::BT709(displaymapped),
        RENODX_DIFFUSE_WHITE_NITS,
        RENODX_PEAK_WHITE_NITS));
  }

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    displaymapped = ApplyGammaCorrectionByLuminance(displaymapped, true);
  }

  return displaymapped;
}

float3 ScaleScene(float3 color) {
  if (RENODX_GAMMA_CORRECTION) {
    color = renodx::color::correct::GammaSafe(color);
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
    color = renodx::color::correct::GammaSafe(color, true);
  } else {
    color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  }
  return color;
}

float3 ApplyGrain(float3 color, float2 texcoord) {
  if (CUSTOM_GRAIN_STRENGTH != 0.f) {
    color = renodx::effects::ApplyFilmGrain(
        color,
        texcoord,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }
  return color;
}

float3 FinalizeTonemap(float3 color, float2 texcoord) {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    color = renodx::color::srgb::DecodeSafe(color);
    color = ApplyDisplayMap(color);
    color = ApplyGrain(color, texcoord);
    color = ScaleScene(color);
  }
  return color;
}
float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 ch = renodx::color::correct::GammaSafe(incorrect_color);

  const float y_in = max(0, renodx::color::y::from::BT709(incorrect_color));
  const float y_out = renodx::color::correct::Gamma(y_in);

  float3 lum = renodx::color::correct::Luminance(incorrect_color, y_in, y_out);

  // use chrominance from per channel gamma correction
  float3 result = renodx::color::correct::ChrominanceOKLab(lum, ch, 1.f, 1.f);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);

    corrected_color = BT709GamutCompressBT2020(corrected_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}
