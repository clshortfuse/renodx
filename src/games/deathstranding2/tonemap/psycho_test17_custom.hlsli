#include "../shared.h"

#ifndef RENODX_DEATHSTRANDING2_TONEMAP_PSYCHO_TEST17_HLSLI_
#define RENODX_DEATHSTRANDING2_TONEMAP_PSYCHO_TEST17_HLSLI_

namespace renodx_custom {
namespace tonemap {
namespace psycho {

float psycho24_AutoCompressionFromCenteredReferenceRange(
    float anchor_out_yf,
    float peak_yf) {
  static const float kReferenceCenteredRangeSideCount = 2.f;
  static const float kReferenceSimultaneousRangeLog10 = 3.7f;
  static const float kMinAutoCompression = 1.f;

  float peak_over_anchor = peak_yf / anchor_out_yf;
  float reference_one_side_range_log10 =
      kReferenceSimultaneousRangeLog10 / kReferenceCenteredRangeSideCount;
  float actual_above_adaptation_range_log10 = log10(peak_over_anchor);
  return max(reference_one_side_range_log10 / actual_above_adaptation_range_log10,
             kMinAutoCompression);
}

float psycho24_ComputePeakCompressionRolloff(
    float color,
    float anchor,
    float peak) {
  float compression_power = psycho24_AutoCompressionFromCenteredReferenceRange(anchor, peak);
  float anchor_over_peak = anchor / peak;
  float compression_slope_norm = 1.f - pow(anchor_over_peak, compression_power);
  float compression_input = pow(max(color / anchor, 0.f), compression_power / compression_slope_norm);
  float compression_white_offset = pow(peak / anchor, compression_power) - 1.f;

  return pow(compression_input / (compression_input + compression_white_offset),
             rcp(compression_power));
}

float3 psycho24_ComputePeakCompressionRolloff(
    float3 color_lms,
    float3 anchor_lms,
    float3 peak_lms) {
  float compression_power = psycho24_AutoCompressionFromCenteredReferenceRange(
      renodx::color::yf::from::LMS(anchor_lms),
      renodx::color::yf::from::LMS(peak_lms));
  float3 anchor_over_peak = anchor_lms / peak_lms;
  float3 compression_slope_norm = 1.f - pow(anchor_over_peak, compression_power);
  float3 compression_input = pow(
      max(color_lms / anchor_lms, 0.f),
      compression_power / compression_slope_norm);
  float3 compression_white_offset = pow(peak_lms / anchor_lms, compression_power) - 1.f;

  return pow(compression_input / (compression_input + compression_white_offset),
             rcp(compression_power));
}

float3 psycho17_ScalePurityMBAdaptive(
    float3 lms_input,
    float purity_scale,
    float3 lms_adaptive_state,
    float eps = 1e-7f) {
  if (abs(purity_scale - 1.f) <= eps) return lms_input;

  float3 lms_relative = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeLMS(
      lms_input,
      lms_adaptive_state);
  float3 mb = renodx::color::macleod_boynton::from::LMS(lms_relative);
  float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float2 mb_scaled = mb_white + (mb.xy - mb_white) * purity_scale;

  return renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeLMS(
      renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb.z)),
      lms_adaptive_state);
}

float3 psycho17_ApplyPurityFromLMS(
    float3 lms_source,
    float3 lms_target,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f) {
  float3 mb_source = renodx::color::macleod_boynton::from::LMS(lms_source);
  float3 mb_target = renodx::color::macleod_boynton::from::LMS(lms_target);
  float2 mb_white = renodx::color::macleod_boynton::from::D65XY();

  float2 source_offset = mb_source.xy - mb_white;
  float2 target_offset = mb_target.xy - mb_white;
  float src_radius = length(source_offset);
  float tgt_radius = length(target_offset);
  if (tgt_radius <= eps) return lms_target;

  float transfer_scale = src_radius / max(tgt_radius, eps);
  float no_purity_loss_scale = max(transfer_scale, 1.f);
  transfer_scale = lerp(transfer_scale, no_purity_loss_scale, clamp_purity_loss);
  float scale = lerp(1.f, transfer_scale, amount);
  float2 mb_scaled = mb_white + target_offset * scale;
  return renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb_target.z));
}

float3 psycho17_ApplyPurityFromBT2020(
    float3 bt2020_source,
    float3 bt2020_target,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f,
    bool compress_gamut = false) {
  if (amount <= 0.f) return bt2020_source;

  float3 lms_target = renodx::color::lms::from::BT2020(bt2020_target);
  float3 lms_source = renodx::color::lms::from::BT2020(bt2020_source);
  float3 lms_out = psycho17_ApplyPurityFromLMS(
      lms_source,
      lms_target,
      amount,
      clamp_purity_loss,
      eps);
  if (compress_gamut) {
    lms_out = renodx::tonemap::psychov::psycho17_GamutCompressLMSBoundAdaptive(
        lms_out,
        1.f.xxx,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }
  return renodx::color::bt2020::from::LMS(lms_out);
}

float3 psycho17_RestoreHueAdaptive(
    float3 lms_source,
    float3 lms_target,
    float3 lms_adaptive_state,
    float amount,
    bool weight_by_purity_loss = true,
    float eps = 1e-7f) {
  if (amount <= 0.f) return lms_target;

  float3 lms_source_relative_weighted =
      renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(
          lms_source,
          lms_adaptive_state);
  float3 lms_target_relative_weighted =
      renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(
          lms_target,
          lms_adaptive_state);

  float3 mb_source = renodx::color::macleod_boynton::from::WeightedLMS(lms_source_relative_weighted);
  float3 mb_target = renodx::color::macleod_boynton::from::WeightedLMS(lms_target_relative_weighted);
  float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f.xxx);

  float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
  float2 target_offset = mb_target.xy - mb_adapted_bg.xy;
  float src2 = dot(source_offset, source_offset);
  float tgt2 = dot(target_offset, target_offset);
  if (src2 <= eps || tgt2 <= eps) return lms_target;

  float target_t_clip = renodx::tonemap::psychov::psycho17_RayExitTCIE1702(
      mb_adapted_bg.xy,
      target_offset);
  float hue_sensitivity =
      renodx::tonemap::psychov::psycho17_AdaptiveHueSensitivityFromTClip(target_t_clip);
  float purity_loss_weight = 1.f;
  if (weight_by_purity_loss) {
    float source_t_clip = renodx::tonemap::psychov::psycho17_RayExitTCIE1702(
        mb_adapted_bg.xy,
        source_offset);
    float source_purity_signal =
        renodx::tonemap::psychov::psycho17_HueRelativePuritySignalFromTClip(source_t_clip);
    float target_purity_signal =
        renodx::tonemap::psychov::psycho17_HueRelativePuritySignalFromTClip(target_t_clip);
    purity_loss_weight = source_purity_signal > eps
                             ? saturate(target_purity_signal / source_purity_signal)
                             : 1.f;
  }

  float restore_weight = amount * hue_sensitivity * purity_loss_weight;
  if (restore_weight <= 0.f) return lms_target;

  float inv_target_radius = rsqrt(tgt2);
  float target_radius = tgt2 * inv_target_radius;
  float inv_source_radius = rsqrt(src2);
  float2 source_dir = source_offset * inv_source_radius;
  float2 target_dir = target_offset * inv_target_radius;
  float2 blended_dir = lerp(target_dir, source_dir, restore_weight);
  float blended_len2 = dot(blended_dir, blended_dir);
  if (blended_len2 > eps) {
    blended_dir *= rsqrt(blended_len2);
  } else {
    blended_dir = target_dir;
  }

  float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
  float3 mb_restored = float3(mb_restored_xy, mb_target.z);
  float3 lms_restored_relative_weighted =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);

  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(
          lms_restored_relative_weighted,
          lms_adaptive_state));
}

float AnchoredPowerContrastSmootherStep(float t) {
  return t * t * t * (t * (t * 6.f - 15.f) + 10.f);
}

float ApplyAnchoredPowerContrast(
    float x,
    float contrast,
    float anchor_in = 0.18f,
    float anchor_out = 0.18f,
    float flare = 0.f,
    float contrast_highlights = 1.f,
    float contrast_shadows = 1.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  if (contrast == 1.f && flare == 0.f
      && contrast_highlights == 1.f && contrast_shadows == 1.f
      && highlights == 1.f && shadows == 1.f) {
    return x / anchor_in * anchor_out;
  }

  float normalized = x / anchor_in;
  float contrasted_normalized = normalized;
  if (contrast != 1.f || flare != 0.f) {
    float flare_ratio = renodx::math::DivideSafe(normalized + flare, normalized, 1.f);
    contrasted_normalized = pow(normalized, contrast * flare_ratio);
  }

  if (contrast_highlights != 1.f) {
    float highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    contrasted_normalized += highlight_distance
                             * (pow(1.f + highlight_distance * highlight_distance,
                                    (contrast_highlights - 1.f) / 2.f)
                                - 1.f);
  }

  if (contrast_shadows != 1.f) {
    float shadow_distance = max(1.f - contrasted_normalized, 0.f);
    contrasted_normalized *= pow(
        1.f + shadow_distance * shadow_distance * shadow_distance,
        contrast_shadows - 1.f);
  }

  float contrasted = contrasted_normalized * anchor_out;

  if (highlights != 1.f) {
    float t = saturate(log2(contrasted / anchor_out) / log2(1.f / anchor_out));
    t = AnchoredPowerContrastSmootherStep(t);
    if (highlights > 1.f) {
      contrasted = lerp(contrasted, anchor_out * pow(contrasted / anchor_out, highlights), t);
    } else {
      float compressed = anchor_out * pow(contrasted / anchor_out, 2.f - highlights);
      contrasted = renodx::math::DivideSafe(
          contrasted * contrasted,
          lerp(contrasted, compressed, t),
          contrasted);
    }
  }

  if (shadows != 1.f) {
    float ratio = max(renodx::math::DivideSafe(contrasted, anchor_out, 0.f), 0.f);
    float base_term = contrasted * anchor_out;
    float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
    float shadow_floor = anchor_out / 16.f;
    float t = saturate(log2(contrasted / anchor_out) / log2(shadow_floor / anchor_out));
    t = AnchoredPowerContrastSmootherStep(t);
    if (shadows > 1.f) {
      float raised = contrasted
                     * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
      float reference = contrasted * (1.f + base_scale);
      contrasted += (raised - reference) * t;
    } else {
      float lowered = contrasted
                      * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
      float reference = contrasted * (1.f - base_scale);
      contrasted += (lowered - reference) * t;
    }
  }

  return contrasted;
}

namespace config17 {

struct Config {
  bool apply_tonemap;
  float peak_value;
  float exposure;
  float gamma;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float contrast_highlights;
  float contrast_shadows;
  float purity_scale;
  float purity_highlights;
  float dechroma;
  float adaptation_contrast;
  float bleaching_intensity;
  float mid_gray;
  bool pre_gamut_compress;
  bool post_gamut_compress;
  float hue_emulation;
};

Config Create(
    bool apply_tonemap = true,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float gamma = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float contrast_highlights = 1.f,
    float contrast_shadows = 1.f,
    float purity_scale = 1.f,
    float purity_highlights = 1.f,
    float dechroma = 0.f,
    float adaptation_contrast = 1.f,
    float bleaching_intensity = 1.f,
    float mid_gray = 0.18f,
    bool pre_gamut_compress = true,
    bool post_gamut_compress = true,
    float hue_emulation = 0.f) {
  const Config psycho17_config = {
    apply_tonemap,
    peak_value,
    exposure,
    gamma,
    highlights,
    shadows,
    contrast,
    flare,
    contrast_highlights,
    contrast_shadows,
    purity_scale,
    purity_highlights,
    dechroma,
    adaptation_contrast,
    bleaching_intensity,
    mid_gray,
    pre_gamut_compress,
    post_gamut_compress,
    hue_emulation
  };
  return psycho17_config;
}

}  // namespace config17

float3 ApplyTest17BT2020(
    float3 color_bt2020,
    float3 color_hue_shift_source_bt2020,
    config17::Config psycho_config) {
  const float kEps = 1e-7f;

  float3 midgray_lms = renodx::color::lms::from::BT2020(psycho_config.mid_gray.xxx);

  float3 color_lms_raw = renodx::color::lms::from::BT2020(color_bt2020);
  if (psycho_config.pre_gamut_compress) {
    color_lms_raw = renodx::tonemap::psychov::psycho17_GamutCompressLMSBoundAdaptive(
        color_lms_raw,
        midgray_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }
  color_lms_raw = max(color_lms_raw, 0.f);

  float3 color_lms = color_lms_raw;
  float lum_original = renodx::color::yf::from::LMS(color_lms_raw);

  if (psycho_config.bleaching_intensity != 0.f) {
    const float kHalfBleachTrolands = 20000.f;

    float adapted_lum = max(lum_original, psycho_config.mid_gray);
    float3 lms_adapted_unit = renodx::color::lms::from::BT2020(adapted_lum.xxx);
    float3 lms_signal_unit = color_lms;

    float3 stimulus_nits = max(lms_adapted_unit, 0.f) * 100.f;
    float3 stimulus_trolands = stimulus_nits * 4.f;
    float3 availability_raw = 1.f / (1.f + stimulus_trolands / max(kHalfBleachTrolands, kEps));
    float3 availability = lerp(1.f, availability_raw, psycho_config.bleaching_intensity);
    color_lms = lms_signal_unit * max(availability, 0.f);
  }

  if (psycho_config.apply_tonemap) {
    float3 lms_peak_unit = renodx::color::lms::from::BT2020(psycho_config.peak_value.xxx);
    color_lms = lms_peak_unit
                * psycho24_ComputePeakCompressionRolloff(
                    color_lms,
                    midgray_lms,
                    lms_peak_unit);

    color_lms *= renodx::math::DivideSafe(lum_original, renodx::color::yf::from::LMS(color_lms), 1.f);
  }

  if (psycho_config.adaptation_contrast != 1.f || psycho_config.hue_emulation != 0.f) {
    float3 source_lms = color_lms;
    if (psycho_config.adaptation_contrast != 1.f) {
      float3 lms_sigma_unit = max(midgray_lms, kEps.xxx);
      float exponent = max(psycho_config.adaptation_contrast, kEps);

      float3 ax = abs(color_lms);
      float3 ax_n = pow(ax, exponent);
      float3 s_n = pow(lms_sigma_unit, exponent);
      float3 response_target = ax_n / max(ax_n + s_n, kEps.xxx);
      float3 response_baseline = ax / max(ax + lms_sigma_unit, kEps.xxx);
      float3 gain = response_target / max(response_baseline, kEps.xxx);
      float3 sign_raw = float3(
          color_lms.x < 0.f ? -1.f : 1.f,
          color_lms.y < 0.f ? -1.f : 1.f,
          color_lms.z < 0.f ? -1.f : 1.f);
      color_lms = sign_raw * (ax * gain);
    }

    if (psycho_config.hue_emulation != 0.f) {
      source_lms = lerp(
          source_lms,
          renodx::color::lms::from::BT2020(color_hue_shift_source_bt2020),
          psycho_config.hue_emulation);
    }

    color_lms = psycho17_RestoreHueAdaptive(
        source_lms,
        color_lms,
        midgray_lms,
        1.f,
        false);
  }

  if (psycho_config.exposure != 1.f
      || psycho_config.gamma != 1.f
      || psycho_config.highlights != 1.f
      || psycho_config.shadows != 1.f
      || psycho_config.contrast != 1.f
      || psycho_config.contrast_highlights != 1.f
      || psycho_config.contrast_shadows != 1.f
      || psycho_config.flare != 0.f
      || psycho_config.purity_scale != 1.f
      || psycho_config.dechroma != 0.f
      || psycho_config.purity_highlights != 0.f) {
    float midgray_lum = renodx::color::yf::from::LMS(midgray_lms);
    float lum_target = lum_original;

    lum_target *= psycho_config.exposure;
    if (psycho_config.gamma != 1.f) {
      lum_target = select(lum_target < 1.f, pow(lum_target, psycho_config.gamma), lum_target);
    }

    lum_target = ApplyAnchoredPowerContrast(
        lum_target,
        psycho_config.contrast,
        midgray_lum,
        midgray_lum,
        psycho_config.flare,
        psycho_config.contrast_highlights,
        psycho_config.contrast_shadows,
        psycho_config.highlights,
        psycho_config.shadows);

    float lum_scale = renodx::math::DivideSafe(lum_target, lum_original, 1.f);
    color_lms *= lum_scale;

    float purity_scale = psycho_config.purity_scale;

    if (psycho_config.dechroma != 0.f) {
      purity_scale *= lerp(
          1.f,
          0.f,
          saturate(pow(lum_target / (10000.f / 100.f), 1.f - psycho_config.dechroma)));
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
      color_lms = psycho17_ScalePurityMBAdaptive(color_lms, purity_scale, midgray_lms, kEps);
    }
  }

  if (psycho_config.post_gamut_compress) {
    color_lms = renodx::tonemap::psychov::psycho17_GamutCompressLMSBoundAdaptive(
        color_lms,
        midgray_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }

  color_bt2020 = renodx::color::bt2020::from::LMS(color_lms);

  if (psycho_config.apply_tonemap) {
    color_bt2020 = max(color_bt2020, 0.f.xxx);
    float max_channel = renodx::math::Max(color_bt2020);
    float compressed_max_channel = psycho_config.peak_value
                                   * psycho24_ComputePeakCompressionRolloff(
                                       max_channel,
                                       psycho_config.mid_gray,
                                       psycho_config.peak_value);
    color_bt2020 *= renodx::math::DivideSafe(compressed_max_channel, max_channel, 0.f);
  }

  return color_bt2020;
}

}  // namespace psycho
}  // namespace tonemap
}  // namespace renodx_custom

#endif  // RENODX_DEATHSTRANDING2_TONEMAP_PSYCHO_TEST17_HLSLI_