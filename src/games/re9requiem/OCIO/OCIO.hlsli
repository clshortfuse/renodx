#include "../common.hlsli"

namespace renodx_custom {
namespace tonemap {
namespace aces {

renodx::tonemap::aces::ODTConfig CreateODTConfig(
    float min_y,
    float max_y,
    float mid_y,
    bool stable_peak_exp_shift = false,
    float exp_shift_max_reference = 1000.f,
    float exp_shift_min_reference = 0.0001f) {
  renodx::tonemap::aces::ODTConfig config = renodx::tonemap::aces::CreateODTConfig(min_y, max_y);

  if (mid_y != 4.8f) {
    renodx::tonemap::aces::ODTConfig exp_shift_config;

    // derive exp-shift from a fixed reference curve so peak changes are stable
    const bool use_stable_reference =
        stable_peak_exp_shift && (exp_shift_max_reference != max_y || exp_shift_min_reference != min_y);
    if (use_stable_reference) {
      exp_shift_config = renodx::tonemap::aces::CreateODTConfig(exp_shift_min_reference, exp_shift_max_reference);
    } else {
      exp_shift_config = config;
    }
    float exp_shift = log2(renodx::tonemap::aces::InvSSTS(mid_y, exp_shift_config)) - log2(0.18f);
    float shift_log10 = exp_shift * log10(2.f);

    config.y_min.x -= shift_log10;
    config.y_mid.x -= shift_log10;
    config.y_max.x -= shift_log10;
  }

  return config;
}

}  // namespace aces
}  // namespace tonemap
}  // namespace renodx

namespace renodx_custom {
namespace tonemap {
namespace psycho {

float psycho17_RayExitTCIE1702(float2 origin, float2 direction) {
  return renodx::color::gamut::RayExitTCIE1702(origin, direction);
}

float psycho17_HueRelativePuritySignalFromTClip(float t_clip) {
  return saturate(renodx::math::DivideSafe(1.f, t_clip, 0.f));
}

float psycho17_AdaptiveHueSensitivityFromTClip(float t_clip) {
  static const float kMeanD65RayDistance = 0.20139844f;
  static const float kMaxD65RayDistance = 1.02634534f;
  static const float kMinSensitivity = 0.35f;

  float long_ray_weight = saturate(renodx::math::DivideSafe(
      t_clip - kMeanD65RayDistance,
      kMaxD65RayDistance - kMeanD65RayDistance,
      0.f));
  return lerp(1.f, kMinSensitivity, long_ray_weight);
}

float3 psycho17_ToAdaptiveRelativeLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(lms_input, current_adaptive_state_lms, 0.f.xxx);
}

float3 psycho17_FromAdaptiveRelativeLMS(float3 lms_relative, float3 current_adaptive_state_lms) {
  return lms_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 psycho17_ToAdaptiveRelativeWeightedLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho17_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 psycho17_GamutCompressLMSBoundAdaptive(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float3 lms_weighted_relative = psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, current_adaptive_state_lms);
  float3 lms_weighted_relative_out =
      renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
          lms_weighted_relative,
          current_adaptive_state_lms,
          bound_rgb_to_lms_weighted_mat,
          strength);
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho17_FromAdaptiveRelativeWeightedLMS(lms_weighted_relative_out, current_adaptive_state_lms));
}

float3 psycho17_ScalePurityMBAdaptive(
    float3 lms_input,
    float purity_scale,
    float3 lms_adaptive_state,
    float eps = 1e-7f) {
  if (abs(purity_scale - 1.f) <= eps) return lms_input;

  float3 lms_relative = psycho17_ToAdaptiveRelativeLMS(lms_input, lms_adaptive_state);
  float3 mb = renodx::color::macleod_boynton::from::LMS(lms_relative);
  float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float2 mb_scaled = mb_white + (mb.xy - mb_white) * purity_scale;

  return psycho17_FromAdaptiveRelativeLMS(
      renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb.z)),
      lms_adaptive_state);
}

float3 psycho17_RestoreHueAdaptiveCore(
    float3 lms_source,
    float3 lms_target,
    float3 lms_adaptive_state,
    float amount,
    bool weight_by_purity_gain,
    bool use_adaptive_hue_sensitivity,
    float eps = 1e-7f) {
  if (amount <= 0.f) return lms_target;

  float3 lms_source_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(lms_source, lms_adaptive_state);
  float3 lms_target_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(lms_target, lms_adaptive_state);

  float3 mb_source = renodx::color::macleod_boynton::from::WeightedLMS(lms_source_relative_weighted);
  float3 mb_target = renodx::color::macleod_boynton::from::WeightedLMS(lms_target_relative_weighted);
  float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f.xxx);

  float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
  float2 target_offset = mb_target.xy - mb_adapted_bg.xy;
  float src2 = dot(source_offset, source_offset);
  float tgt2 = dot(target_offset, target_offset);
  if (src2 <= eps || tgt2 <= eps) return lms_target;

  float target_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, target_offset);
  float restore_weight = amount;
  if (use_adaptive_hue_sensitivity) {
    restore_weight *= psycho17_AdaptiveHueSensitivityFromTClip(target_t_clip);
  }
  if (weight_by_purity_gain) {
    float source_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, source_offset);
    float source_purity_signal = psycho17_HueRelativePuritySignalFromTClip(source_t_clip);
    float target_purity_signal = psycho17_HueRelativePuritySignalFromTClip(target_t_clip);
    restore_weight *= target_purity_signal > eps ? saturate(source_purity_signal / target_purity_signal) : 1.f;
  }
  if (restore_weight <= 0.f) return lms_target;

  float target_radius = sqrt(tgt2);
  float2 source_dir = source_offset * rsqrt(src2);
  float2 target_dir = target_offset * rsqrt(tgt2);
  float2 blended_dir = lerp(target_dir, source_dir, restore_weight);
  float blended_len2 = dot(blended_dir, blended_dir);
  blended_dir = (blended_len2 > eps) ? (blended_dir * rsqrt(blended_len2)) : target_dir;

  float3 mb_restored = float3(mb_adapted_bg.xy + blended_dir * target_radius, mb_target.z);
  float3 lms_restored_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);

  return renodx::color::macleod_boynton::UnweighLMS(
      psycho17_FromAdaptiveRelativeWeightedLMS(lms_restored_relative_weighted, lms_adaptive_state));
}

float3 psycho17_RestoreHueAdaptiveWeightByPurityGain(
    float3 lms_source,
    float3 lms_target,
    float3 lms_adaptive_state,
    float amount,
    bool weight_by_purity_gain = true,
    bool use_adaptive_hue_sensitivity = true,
    float eps = 1e-7f) {
  return psycho17_RestoreHueAdaptiveCore(
      lms_source,
      lms_target,
      lms_adaptive_state,
      amount,
      weight_by_purity_gain,
      use_adaptive_hue_sensitivity,
      eps);
}

float3 psycho17_ApplyPurityAndHueFromBT2020(
    float3 bt2020_source,
    float3 bt2020_target,
    float purity_amount = 1.f,
    float hue_amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f,
    bool compress_gamut = true,
    bool use_adaptive_hue_sensitivity = false) {
  if (purity_amount <= 0.f && hue_amount <= 0.f) return bt2020_target;

  float3 midgray_lms = renodx::color::lms::from::BT2020(0.18f.xxx);
  float3 source_lms = renodx::color::lms::from::BT2020(bt2020_source);
  float3 target_lms = renodx::color::lms::from::BT2020(bt2020_target);

  if (hue_amount > 0.f) {
    target_lms = psycho17_RestoreHueAdaptiveWeightByPurityGain(
        source_lms,
        target_lms,
        midgray_lms,
        hue_amount,
        false,
        use_adaptive_hue_sensitivity,
        eps);
  }

  if (purity_amount > 0.f) {
    float3 source_mb = renodx::color::macleod_boynton::from::LMS(psycho17_ToAdaptiveRelativeLMS(source_lms, midgray_lms));
    float3 target_mb = renodx::color::macleod_boynton::from::LMS(psycho17_ToAdaptiveRelativeLMS(target_lms, midgray_lms));
    float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
    float source_radius = length(source_mb.xy - mb_white);
    float target_radius = length(target_mb.xy - mb_white);
    float purity_scale = target_radius > eps ? lerp(1.f, source_radius / target_radius, saturate(purity_amount)) : 1.f;
    purity_scale = lerp(purity_scale, max(purity_scale, 1.f), saturate(clamp_purity_loss));
    target_lms = psycho17_ScalePurityMBAdaptive(target_lms, purity_scale, midgray_lms, eps);
  }

  if (compress_gamut) {
    target_lms = psycho17_GamutCompressLMSBoundAdaptive(
        target_lms,
        midgray_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }
  return renodx::color::bt2020::from::LMS(target_lms);
}

float psycho17_Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {
    float b = mid_gray * pow(x / mid_gray, 2.f - highlights);
    float t = min(x, 1.f);
    return min(x, renodx::math::DivideSafe(x * x, lerp(x, b, t), x));
  }
}

float psycho17_Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  float base_term = x * mid_gray;
  float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float psycho17_ContrastAndFlare(
    float x,
    float contrast,
    float contrast_highlights,
    float contrast_shadows,
    float flare,
    float mid_gray = 0.18f) {
  if (contrast == 1.f && flare == 0.f && contrast_highlights == 1.f && contrast_shadows == 1.f) return x;
  float x_normalized = x / mid_gray;
  float split_contrast = (x < mid_gray) ? contrast_shadows : contrast_highlights;
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  return pow(x_normalized, contrast * split_contrast * flare_ratio) * mid_gray;
}

namespace config17 {

struct Config {
  bool apply_tonemap;
  float exposure;
  float gamma;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float flare_lms;
  float contrast_highlights;
  float contrast_shadows;
  float purity_scale;
  float purity_highlights;
  float dechroma;
  float adaptation_contrast;
  float bleaching_intensity;
  float mid_gray;
  bool post_gamut_compress;
  float hue_emulation;
};

Config Create(
    bool apply_tonemap = true,
    float exposure = 1.f,
    float gamma = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float flare_lms = 0.f,
    float contrast_highlights = 1.f,
    float contrast_shadows = 1.f,
    float purity_scale = 1.f,
    float purity_highlights = 0.f,
    float dechroma = 0.f,
    float adaptation_contrast = 1.f,
    float bleaching_intensity = 0.f,
    float mid_gray = 0.18f,
    bool post_gamut_compress = true,
    float hue_emulation = 0.f) {
  Config psycho17_config = {
    apply_tonemap,
    exposure,
    gamma,
    highlights,
    shadows,
    contrast,
    flare,
    flare_lms,
    contrast_highlights,
    contrast_shadows,
    purity_scale,
    purity_highlights,
    dechroma,
    adaptation_contrast,
    bleaching_intensity,
    mid_gray,
    post_gamut_compress,
    hue_emulation
  };
  return psycho17_config;
}

}  // namespace config17

float3 ApplyPreToneMapColorGradeBT2020(float3 color_bt2020, config17::Config psycho_config) {
  float3 midgray_lms = renodx::color::lms::from::BT2020(psycho_config.mid_gray.xxx);
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  float lum_original = renodx::color::yf::from::LMS(color_lms);
  float lum_target = lum_original * psycho_config.exposure;

  if (psycho_config.gamma != 1.f) {
    lum_target = select(lum_target < 1.f, pow(lum_target, psycho_config.gamma), lum_target);
  }
  if (psycho_config.highlights != 1.f) {
    lum_target = psycho17_Highlights(lum_target, psycho_config.highlights, renodx::color::yf::from::LMS(midgray_lms));
  }
  if (psycho_config.shadows != 1.f) {
    lum_target = psycho17_Shadows(lum_target, psycho_config.shadows, renodx::color::yf::from::LMS(midgray_lms));
  }
  if (psycho_config.contrast != 1.f || psycho_config.contrast_highlights != 1.f || psycho_config.contrast_shadows != 1.f || psycho_config.flare != 0.f) {
    lum_target = psycho17_ContrastAndFlare(
        lum_target,
        psycho_config.contrast,
        psycho_config.contrast_highlights,
        psycho_config.contrast_shadows,
        psycho_config.flare,
        renodx::color::yf::from::LMS(midgray_lms));
  }

  color_lms *= renodx::math::DivideSafe(lum_target, lum_original, 1.f);

  if (psycho_config.bleaching_intensity != 0.f) {
    const float kHalfBleachTrolands = 20000.f;
    float3 stimulus_trolands = max(color_lms, 0.f.xxx) * 100.f * 4.f;
    float3 availability = lerp(1.f.xxx, 1.f.xxx / (1.f.xxx + stimulus_trolands / kHalfBleachTrolands), psycho_config.bleaching_intensity);
    color_lms *= max(availability, 0.f.xxx);
  }

  if (psycho_config.adaptation_contrast != 1.f || psycho_config.flare_lms != 0.f) {
    float3 lms_sigma_unit = max(midgray_lms, 1e-7f.xxx);
    float3 ax = abs(color_lms);
    float3 exponent = max(psycho_config.adaptation_contrast, 1e-7f).xxx;
    if (psycho_config.flare_lms != 0.f) {
      float3 x_normalized = renodx::math::DivideSafe(ax, lms_sigma_unit, 0.f.xxx);
      exponent *= max(renodx::math::DivideSafe(x_normalized + psycho_config.flare_lms, x_normalized, 1.f.xxx), 1e-7f.xxx);
    }
    float3 ax_n = pow(ax, exponent);
    float3 s_n = pow(lms_sigma_unit, exponent);
    float3 response_target = ax_n / max(ax_n + s_n, 1e-7f.xxx);
    float3 response_baseline = ax / max(ax + lms_sigma_unit, 1e-7f.xxx);
    color_lms = sign(color_lms) * (ax * response_target / max(response_baseline, 1e-7f.xxx));
  }

  return renodx::color::bt2020::from::LMS(color_lms);
}

float3 ApplyPostToneMapColorGradeBT2020(
    float3 color_bt2020,
    float3 hue_emulation_source_bt2020,
    float lum_target,
    config17::Config psycho_config) {
  if (psycho_config.hue_emulation == 0.f
      && psycho_config.purity_scale == 1.f
      && psycho_config.dechroma == 0.f
      && psycho_config.purity_highlights == 0.f
      && !psycho_config.post_gamut_compress) {
    return color_bt2020;
  }

  float3 midgray_lms = renodx::color::lms::from::BT2020(psycho_config.mid_gray.xxx);
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);

  if (psycho_config.hue_emulation != 0.f) {
    color_lms = psycho17_RestoreHueAdaptiveWeightByPurityGain(
        renodx::color::lms::from::BT2020(hue_emulation_source_bt2020),
        color_lms,
        midgray_lms,
        psycho_config.hue_emulation,
        true,
        false);
  }

  float purity_scale = psycho_config.purity_scale;
  if (psycho_config.dechroma != 0.f) {
    purity_scale *= lerp(1.f, 0.f, saturate(pow(lum_target / (10000.f / 100.f), (1.f - psycho_config.dechroma))));
  }
  if (psycho_config.purity_highlights != 0.f) {
    float percent_max = saturate(lum_target * 100.f / 10000.f);
    float blowout_change = pow(1.f - percent_max, 100.f * abs(psycho_config.purity_highlights));
    if (psycho_config.purity_highlights < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    purity_scale *= blowout_change;
  }
  if (purity_scale != 1.f) {
    color_lms = psycho17_ScalePurityMBAdaptive(color_lms, purity_scale, midgray_lms, 1e-7f);
  }
  if (psycho_config.post_gamut_compress) {
    color_lms = psycho17_GamutCompressLMSBoundAdaptive(
        color_lms,
        midgray_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }

  return renodx::color::bt2020::from::LMS(color_lms);
}

}  // namespace psycho
}  // namespace tonemap
}  // namespace renodx_custom

renodx_custom::tonemap::psycho::config17::Config CreatePsycho17Config() {
  return renodx_custom::tonemap::psycho::config17::Create(
      false,
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_GAMMA,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      0.f,
      0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
      RENODX_TONE_MAP_CONTRAST_SHADOWS,
      RENODX_TONE_MAP_SATURATION,
      -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
      RENODX_TONE_MAP_DECHROMA,
      RENODX_TONE_MAP_ADAPTATION_CONTRAST,
      0.f,
      0.18f,
      false,
      RENODX_TONE_MAP_HUE_RETENTION);
}

// User grading -> ACES -> 2.2 EOTF emulation -> apply per channel purity onto luminance curve -> grain -> diffuse white scale + PQ encode
float3 ApplyToneMapEncodePQ(float3 untonemapped_ap1, float cbuffer_peak_nits, float cbuffer_diffuse_white_nits, float2 uv) {
  untonemapped_ap1 = renodx::tonemap::aces::RRT(mul(renodx::color::AP1_TO_AP0_MAT, untonemapped_ap1));

  float untonemapped_lum = YfFromAP1(untonemapped_ap1);
  renodx_custom::tonemap::psycho::config17::Config psycho17_config = CreatePsycho17Config();
  untonemapped_ap1 = renodx::color::ap1::from::BT2020(
      renodx_custom::tonemap::psycho::ApplyPreToneMapColorGradeBT2020(renodx::color::bt2020::from::AP1(untonemapped_ap1), psycho17_config));

  float3 tonemapped_bt2020;

  // In order to change ACES_MID, we use The Academy's exp-shift system
  // The curve is built around 4.8 ACES_MID however, so changing it causes the curve to break
  // Values other than 4.8 make it so that increasing peak causes midtones to compress and vice-versa
  // We fix this by basing the exp-shifted curve on reference ACES_MAX and ACES_MIN values
  // We then scale brightness like SDR as a linear scalar
  // ACES_MAX and ACES_MIN are pre-adjusted in order to account for the post-tonemap diffuse white scalar which we define as `10.f * ACES_MID`
  float ACES_MID;
  float EXP_SHIFT_REFERENCE_MAX;
  float EXP_SHIFT_REFERENCE_MIN;
  if (TONE_MAP_ACES_MID_GRAY == 0.f) {
    ACES_MID = 4.8f;
    EXP_SHIFT_REFERENCE_MAX = 48.f;
    EXP_SHIFT_REFERENCE_MIN = 0.02f;
  } else if (TONE_MAP_ACES_MID_GRAY == 1.f) {
    ACES_MID = 10.f;
    EXP_SHIFT_REFERENCE_MAX = 100.f;
    EXP_SHIFT_REFERENCE_MIN = 0.02f;
  } else {
    ACES_MID = 15.f;
    EXP_SHIFT_REFERENCE_MAX = 1000.f;
    EXP_SHIFT_REFERENCE_MIN = 0.0001f;
  }
  const float ACES_DIFFUSE = ACES_MID * 10.f;
  const float ACES_MIN = 0.0001f;
  float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
  float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    aces_min /= 3.f;
  }

  renodx::tonemap::aces::ODTConfig ODT_config = renodx_custom::tonemap::aces::CreateODTConfig(aces_min * ACES_DIFFUSE, aces_max * ACES_DIFFUSE, ACES_MID, true, EXP_SHIFT_REFERENCE_MAX, EXP_SHIFT_REFERENCE_MIN);

  float3 tonemapped_ap1 = renodx::tonemap::aces::ODTToneMap(untonemapped_ap1, ODT_config) / ACES_DIFFUSE;
  float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
  }

  tonemapped_bt2020 = renodx::color::bt2020::from::BT709(tonemapped_bt709);

  if (RENODX_TONE_MAP_SCALING == 0.f) {
    float tonemapped_perch_yf = renodx::color::yf::from::BT2020(tonemapped_bt2020);

    float untonemapped_yf = YfFromAP1(untonemapped_ap1);
    float tonemapped_lum_yf = renodx::tonemap::aces::ODTToneMap(untonemapped_yf, ODT_config) / ACES_DIFFUSE;
    if (RENODX_GAMMA_CORRECTION == 1.f) {
      tonemapped_lum_yf = renodx::color::correct::GammaSafe(tonemapped_lum_yf);
    }
    tonemapped_bt2020 = max(0, renodx::color::correct::Luminance(tonemapped_bt2020, tonemapped_perch_yf, tonemapped_lum_yf));
  }

  float3 hue_emulation_source_bt2020 = tonemapped_bt2020;
  if (psycho17_config.hue_emulation > 0.f) {
    hue_emulation_source_bt2020 = renodx::color::bt2020::from::AP1(untonemapped_ap1 * 0.1f / 0.18f);
  }
  tonemapped_bt2020 = renodx_custom::tonemap::psycho::ApplyPostToneMapColorGradeBT2020(
      tonemapped_bt2020,
      hue_emulation_source_bt2020,
      untonemapped_lum,
      psycho17_config);

  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    tonemapped_bt2020 = renodx::effects::ApplyFilmGrain(
        tonemapped_bt2020, uv, CUSTOM_RANDOM, CUSTOM_GRAIN_STRENGTH * 0.06f,
        1.f, false, renodx::color::BT2020_TO_XYZ_MAT);
  }

  return renodx::color::pq::EncodeSafe(tonemapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
}
