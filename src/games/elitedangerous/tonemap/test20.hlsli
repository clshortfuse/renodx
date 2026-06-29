#ifndef RENODX_ELITEDANGEROUS_PSYCHOV_TEST20_HLSL_
#define RENODX_ELITEDANGEROUS_PSYCHOV_TEST20_HLSL_

#include "../common.hlsli"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx {
namespace tonemap {
namespace psychovtest20 {

float psycho20_RayExitTCIE1702(float2 origin, float2 direction) {
  return renodx::color::gamut::RayExitTCIE1702(origin, direction);
}

float psycho20_HueRelativePuritySignalFromTClip(float t_clip) {
  return saturate(renodx::math::DivideSafe(1.f, t_clip, 0.f));
}

float psycho20_AdaptiveHueSensitivityFromTClip(float t_clip) {
  // Angular statistics of renodx::color::gamut::RayExitTCIE1702()
  // from D65 MB white using unit-length rays over [0, 2π).
  //
  // These are raw MB l/s distances to the 7-edge CIE170-2 fast hull,
  // not perceptual JND units.
  static const float kMedianD65RayDistance = 0.15273703f;
  static const float kMaxD65RayDistance = 1.02636748f;

  // Tuning floor: long-ray hues are downweighted but not disabled.
  // Not derived from the CIE170-2 hull statistics.
  static const float kLongRayMinHueSensitivity = 0.35f;

  float long_ray_weight = saturate(renodx::math::DivideSafe(
      t_clip - kMedianD65RayDistance,
      kMaxD65RayDistance - kMedianD65RayDistance,
      0.f));

  return lerp(1.f, kLongRayMinHueSensitivity, long_ray_weight);
}

float psycho20_HueRelativePuritySignalFromMB(float2 mb_xy, float2 mb_anchor) {
  float2 direction = mb_xy - mb_anchor;
  if (dot(direction, direction) <= renodx::color::gamut::MB_NEAR_WHITE_EPSILON) {
    return 0.f;
  }

  return psycho20_HueRelativePuritySignalFromTClip(
      psycho20_RayExitTCIE1702(mb_anchor, direction));
}

float psycho20_HueRelativePuritySignalFromMB(float3 mb, float2 mb_anchor) {
  if (!(mb.z > renodx::color::gamut::EPSILON)) {
    return 0.f;
  }

  return psycho20_HueRelativePuritySignalFromMB(mb.xy, mb_anchor);
}

float psycho20_HueRelativePuritySignal(float3 lms_input, float2 mb_anchor) {
  float3 lms_weighted = renodx::color::macleod_boynton::WeighLMS(max(lms_input, 0.f));
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(lms_weighted);
  if (!(mb.z > renodx::color::gamut::EPSILON)) {
    return 0.f;
  }

  return psycho20_HueRelativePuritySignalFromMB(mb, mb_anchor);
}

float psycho20_D65HueSensitivity(float2 mb_xy) {
  float2 mb_white = renodx::color::macleod_boynton::from::D65XY();
  float2 direction = mb_xy - mb_white;
  if (dot(direction, direction) <= renodx::color::gamut::MB_NEAR_WHITE_EPSILON) {
    return 1.f;
  }

  return psycho20_AdaptiveHueSensitivityFromTClip(
      psycho20_RayExitTCIE1702(mb_white, direction));
}

float3 psycho20_ToAdaptiveRelativeLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(lms_input, current_adaptive_state_lms, 0.f.xxx);
}

float3 psycho20_FromAdaptiveRelativeLMS(float3 lms_relative, float3 current_adaptive_state_lms) {
  return lms_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 psycho20_ToAdaptiveRelativeWeightedLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho20_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 psycho20_GamutCompressLMSBoundAdaptive(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  float3 lms_weighted_relative =
      psycho20_ToAdaptiveRelativeWeightedLMS(lms_input, current_adaptive_state_lms);
  float3 lms_weighted_relative_out =
      renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
          lms_weighted_relative,
          current_adaptive_state_lms,
          bound_rgb_to_lms_weighted_mat,
          strength);
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho20_FromAdaptiveRelativeWeightedLMS(
          lms_weighted_relative_out,
          current_adaptive_state_lms));
}

float3 psycho20_GamutCompressAdaptiveRelativeWeightedLMSBound(
    float3 lms_weighted_relative_input,
    float3 current_adaptive_state_lms,
    float3x3 bound_rgb_to_lms_weighted_mat,
    float strength) {
  return renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
      lms_weighted_relative_input,
      current_adaptive_state_lms,
      bound_rgb_to_lms_weighted_mat,
      strength);
}

float psycho20_AdaptiveHueSensitivity(float2 mb_xy, float2 mb_anchor) {
  float2 direction = mb_xy - mb_anchor;
  if (dot(direction, direction) <= renodx::color::gamut::MB_NEAR_WHITE_EPSILON) {
    return 1.f;
  }

  return psycho20_AdaptiveHueSensitivityFromTClip(
      psycho20_RayExitTCIE1702(mb_anchor, direction));
}

float psycho20_AvailabilityFromRelativeDrive(float relative_drive, float knee_ratio) {
  return 1.f / (1.f + relative_drive / knee_ratio);
}

float psycho20_BleachAvailabilityFromClipPoint(float stimulus_level,
                                               float clip_level) {
  float normalized_stimulus = renodx::math::DivideSafe(
      max(stimulus_level, 0.f),
      max(clip_level, 1e-6f),
      0.f);
  float raw_availability =
      psycho20_AvailabilityFromRelativeDrive(
          normalized_stimulus,
          1.f);

  // Remap the classical 1 / (1 + x) availability so clip_point means
  // "fully bleached here" while keeping the same Rushton-Henry-shaped arrival.
  return saturate((raw_availability - 0.5f) / 0.5f);
}

float3 psycho20_AdaptiveRelativeWeightedNeutral() {
  // In psycho20_ToAdaptiveRelativeWeightedLMS():
  //   adapted background LMS -> WeighLMS(adapted) / adapted = LMS_WEIGHTS
  return renodx::color::macleod_boynton::WeighLMS(1.f.xxx);
}

float3 psycho20_ACCFromAdaptiveRelativeWeightedDelta(float3 delta_lms_w) {
  float3 neutral_w = psycho20_AdaptiveRelativeWeightedNeutral();

  float mc1 = renodx::math::DivideSafe(neutral_w.x, neutral_w.y, 0.f);
  float mc2 = renodx::math::DivideSafe(neutral_w.x + neutral_w.y, neutral_w.z, 0.f);

  // CastleCSF-style ACC:
  // Ach = ΔLw + ΔMw
  // RG  = ΔLw - mc1 * ΔMw
  // YV  = -ΔLw - ΔMw + mc2 * ΔSw
  return float3(
      delta_lms_w.x + delta_lms_w.y,
      delta_lms_w.x - mc1 * delta_lms_w.y,
      -delta_lms_w.x - delta_lms_w.y + mc2 * delta_lms_w.z);
}

float3 psycho20_AdaptiveRelativeWeightedDeltaFromACC(float3 acc) {
  float3 neutral_w = psycho20_AdaptiveRelativeWeightedNeutral();

  float mc1 = renodx::math::DivideSafe(neutral_w.x, neutral_w.y, 0.f);
  float mc2 = renodx::math::DivideSafe(neutral_w.x + neutral_w.y, neutral_w.z, 1.f);

  float ach = acc.x;
  float rg = acc.y;
  float yv = acc.z;

  // Invert:
  // ach = dL + dM
  // rg  = dL - mc1*dM
  // yv  = -ach + mc2*dS
  float inv_lm = rcp(1.f + mc1);

  float dM = (ach - rg) * inv_lm;
  float dL = ach - dM;
  float dS = (yv + ach) / mc2;

  return float3(dL, dM, dS);
}

float psycho20_LengthSafe(float2 v) {
  return sqrt(max(dot(v, v), 0.f));
}

float2 psycho20_NormalizeSafe2(float2 v, float2 fallback) {
  float len2 = dot(v, v);
  return (len2 > 1e-12f) ? (v * rsqrt(len2)) : fallback;
}

float psycho20_LMRatioFromAdaptiveRelativeWeightedLMS(float3 lms_w) {
  float lm = max(lms_w.x + lms_w.y, 1e-6f);
  return lms_w.x / lm;
}

float psycho20_LMDominanceNoS(float3 delta_w) {
  float3 abs_delta = abs(delta_w);
  float sum_delta = abs_delta.x + abs_delta.y + abs_delta.z + 1e-6f;

  float lm_share = (abs_delta.x + abs_delta.y) / sum_delta;
  float s_share = abs_delta.z / sum_delta;

  // L/M-dominant and S-low.
  // This is a cone-dominance proxy for warm/spectral-ish compression.
  return saturate(lm_share * (1.f - s_share));
}

float psycho20_MixedOpponentChroma(float2 acc_chroma) {
  float rg = abs(acc_chroma.x);
  float yv = abs(acc_chroma.y);

  return saturate(min(rg, yv) / max(max(rg, yv), 1e-6f));
}

float3 psycho20_BoundLMSByDisplayPeak(
    float3 lms,
    float peak_value,
    int gamut_compression_mode) {
  float3 rgb_bound_space;

  if (gamut_compression_mode == 1) {
    // BT.2020 display bound
    rgb_bound_space = renodx::color::bt2020::from::LMS(lms);
  } else {
    // BT.709 display bound
    rgb_bound_space = renodx::color::bt709::from::LMS(lms);
  }

  float max_rgb = max(max(rgb_bound_space.r, rgb_bound_space.g), rgb_bound_space.b);

  float scale = 1.f;
  if (max_rgb > peak_value) {
    scale = peak_value / max(max_rgb, 1e-6f);
  }

  return lms * scale;
}

float3 psycho20_DisplayRGBFromLMS(float3 lms, int output_gamut_mode) {
  return (output_gamut_mode == 1)
             ? renodx::color::bt2020::from::LMS(lms)
             : renodx::color::bt709::from::LMS(lms);
}

float3 psycho20_DisplayLMSFromRGB(float3 rgb, int output_gamut_mode) {
  return (output_gamut_mode == 1)
             ? renodx::color::lms::from::BT2020(rgb)
             : renodx::color::lms::from::BT709(rgb);
}

float psycho20_RayExitRGBBox1D(float origin, float direction, float peak) {
  static const float kEps = 1e-6f;
  static const float kInf = 3.402823466e+38f;

  if (direction > kEps) {
    return (peak - origin) / direction;  // upper face
  }

  if (direction < -kEps) {
    return -origin / direction;  // lower face
  }

  return kInf;
}

float psycho20_RayExitRGBBox(float3 rgb_origin, float3 rgb_direction, float peak) {
  float t_r = psycho20_RayExitRGBBox1D(rgb_origin.r, rgb_direction.r, peak);
  float t_g = psycho20_RayExitRGBBox1D(rgb_origin.g, rgb_direction.g, peak);
  float t_b = psycho20_RayExitRGBBox1D(rgb_origin.b, rgb_direction.b, peak);

  return max(0.f, min(t_r, min(t_g, t_b)));
}

// Computes the selected RGB-cube intersection for the LMS hue/path that maps
// current_adaptive_state_lms -> desired_background_state_lms.
//
// This is not D65 peak white. It is the per-pixel LMS point where this LMS path
// first hits the selected output RGB cube.
float3 psycho20_DisplayHullPeakLMSForNR(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    float3 desired_background_state_lms,
    float peak_value,
    int output_gamut_mode,
    float3 fallback_white_lms_peak) {
  static const float kEps = 1e-6f;
  static const float kInf = 3.402823466e+38f;

  float3 relative_input = float3(
      renodx::math::DivideSafe(lms_input.x, current_adaptive_state_lms.x, 1.f),
      renodx::math::DivideSafe(lms_input.y, current_adaptive_state_lms.y, 1.f),
      renodx::math::DivideSafe(lms_input.z, current_adaptive_state_lms.z, 1.f));

  float3 ray_origin_lms = desired_background_state_lms;
  float3 ray_target_lms = desired_background_state_lms * relative_input;
  float3 ray_direction_lms = ray_target_lms - ray_origin_lms;

  if (dot(ray_direction_lms, ray_direction_lms) <= 1e-12f) {
    return fallback_white_lms_peak;
  }

  float3 rgb_origin = psycho20_DisplayRGBFromLMS(ray_origin_lms, output_gamut_mode);
  float3 rgb_direction = psycho20_DisplayRGBFromLMS(ray_direction_lms, output_gamut_mode);

  float t_peak = psycho20_RayExitRGBBox(rgb_origin, rgb_direction, peak_value);

  if (!(t_peak > 0.f) || !(t_peak < kInf)) {
    return fallback_white_lms_peak;
  }

  float3 hull_peak_lms = ray_origin_lms + ray_direction_lms * t_peak;

  // The existing per-channel NR equation requires peak > anchor_out per channel.
  // If the ray is moving downward in a cone channel, keep the normal white peak
  // for that channel rather than feeding an invalid per-channel peak.
  return float3(
      (hull_peak_lms.x > desired_background_state_lms.x + kEps) ? hull_peak_lms.x : fallback_white_lms_peak.x,
      (hull_peak_lms.y > desired_background_state_lms.y + kEps) ? hull_peak_lms.y : fallback_white_lms_peak.y,
      (hull_peak_lms.z > desired_background_state_lms.z + kEps) ? hull_peak_lms.z : fallback_white_lms_peak.z);
}

float psycho20_ScalarNR(
    float x,
    float peak,
    float anchor_in,
    float anchor_out,
    float cone_response_exponent,
    float highlights) {
  float h = max(highlights, 1e-6f);
  float h_rcp = rcp(h);

  float peak_minus_anchor_out = max(peak - anchor_out, 1e-6f);
  float n = cone_response_exponent * peak / peak_minus_anchor_out;

  float q = pow(
      max(abs(x) / max(anchor_in, 1e-6f), 1e-6f),
      n * h);

  float shoulder = pow(
                       max(peak / max(anchor_out, 1e-6f), 1e-6f),
                       h)
                   - 1.f;

  return peak * pow(q / max(q + shoulder, 1e-6f), h_rcp);
}

// Dominant cone drive relative to adapted LMS.
// Implemented in weighted LMS form for consistency with the MB/observer basis.
// The weights cancel in the ratio, which is intended: this is cone-relative
// drive, not Yf/luminance energy. This lets S-dominant blue bleach when S is
// strongly driven relative to adapted S.
float psycho20_DominantConeDriveWeighted(
    float3 lms_input,
    float3 current_adaptive_state_lms) {
  float3 weighted_lms =
      renodx::color::macleod_boynton::WeighLMS(abs(lms_input));

  float3 weighted_adapted =
      renodx::color::macleod_boynton::WeighLMS(
          max(current_adaptive_state_lms, 1e-6f.xxx));

  float3 drive = weighted_lms / max(weighted_adapted, 1e-6f.xxx);

  return max(drive.x, max(drive.y, drive.z));
}

// Rushton-like bleaching amount from dominant cone drive.
// Uses the old 203*4 troland approximation scale, but driven by the dominant
// cone response rather than Yf/luminance.
float psycho20_DominantConeBleachMix(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    float bleaching_intensity) {
  float drive = psycho20_DominantConeDriveWeighted(
      lms_input,
      current_adaptive_state_lms);

  float adapted_max_cone = max(
      current_adaptive_state_lms.x,
      max(current_adaptive_state_lms.y, current_adaptive_state_lms.z));

  float stimulus_trolands = drive * adapted_max_cone * 203.f * 4.f;

  float bleach = stimulus_trolands / max(stimulus_trolands + 20000.f, 1e-6f);

  return saturate(bleach * bleaching_intensity);
}

float3 psycho20_NRLongFormWithPeak(
    float3 lms_input,
    float3 contrast,
    float3 lms_peak,
    float3 anchor_out,
    float cone_response_exponent,
    float highlights) {
  float h = max(highlights, 1e-6f);
  float h_rcp = rcp(h);

  float3 anchor_out_safe = max(anchor_out, 1e-6f.xxx);
  float3 lms_peak_safe = max(lms_peak, anchor_out_safe + 1e-6f.xxx);

  float3 peak_minus_anchor_out = lms_peak_safe - anchor_out_safe;

  float3 n =
      cone_response_exponent * lms_peak_safe / peak_minus_anchor_out;

  float3 q = pow(
      max(contrast, 1e-6f.xxx),
      n * h);

  float3 shoulder = pow(
                        max(lms_peak_safe / anchor_out_safe, 1e-6f.xxx),
                        h)
                    - 1.f;

  float3 saturated =
      lms_peak_safe * pow(q / max(q + shoulder, 1e-6f.xxx), h_rcp);

  return renodx::math::CopySign(saturated, lms_input);
}

float psycho20_MaxChannelMagnitudeFromLMS(
    float3 lms,
    float3 lms_white) {
  float3 relative = lms / max(lms_white, 1e-6f.xxx);

  return max(
      max(abs(relative.x), abs(relative.y)),
      abs(relative.z));
}

float3 psycho20_MaxChannelDirectionFromLMS(
    float3 lms,
    float3 lms_white) {
  float3 relative = lms / max(lms_white, 1e-6f.xxx);

  float m = max(
      max(abs(relative.x), abs(relative.y)),
      abs(relative.z));

  return relative / max(m, 1e-6f);
}

float psycho20_PurpleComplementaryGateFromACC(float3 acc) {
  float rg = acc.y;
  float yv = acc.z;

  float chroma = max(length(acc.yz), 1e-6f);

  float rg_pos = saturate(rg / chroma);
  float yv_pos = saturate(yv / chroma);

  float mixed = saturate(
      min(abs(rg), abs(yv)) / max(max(abs(rg), abs(yv)), 1e-6f));

  return saturate(2.f * rg_pos * yv_pos * mixed);
}

float3 psycho20_MConeCrosstalkDirectionFromLMS(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    float3 source_acc,
    float3 lms_white,
    float strength) {
  float3 drive =
      abs(lms_input) / max(current_adaptive_state_lms, 1e-6f.xxx);

  float l_over_m = max(drive.x - drive.y, 0.f);
  float s_over_m = max(drive.z - drive.y, 0.f);

  static const float kLMConfusion = 0.35f;
  static const float kSMConfusion = 0.20f;

  float m_support =
      kLMConfusion * l_over_m + kSMConfusion * s_over_m;

  float purple_gate = psycho20_PurpleComplementaryGateFromACC(source_acc);
  float spectral_confidence = 1.f - purple_gate;

  float3 bent_drive = drive;
  bent_drive.y += saturate(strength) * spectral_confidence * m_support;

  // Direction only: preserve dominant-cone magnitude.
  float old_max = max(drive.x, max(drive.y, drive.z));
  float new_max = max(bent_drive.x, max(bent_drive.y, bent_drive.z));

  bent_drive *= renodx::math::DivideSafe(old_max, new_max, 1.f);

  float3 bent_lms =
      renodx::math::CopySign(
          bent_drive * current_adaptive_state_lms,
          lms_input);

  return psycho20_MaxChannelDirectionFromLMS(
      bent_lms,
      lms_white);
}

float3 psycho20_ApplyAdaptiveMBPurity(
    float3 lms_input,
    float3 adaptive_neutral_lms,
    float purity_scale) {
  if (abs(purity_scale - 1.f) <= 1e-5f) {
    return lms_input;
  }

  float3 relative_weighted =
      psycho20_ToAdaptiveRelativeWeightedLMS(
          lms_input,
          adaptive_neutral_lms);

  float3 mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          relative_weighted);

  float3 mb_neutral =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx);

  float2 mb_scaled_xy =
      lerp(
          mb_neutral.xy,
          mb.xy,
          purity_scale);

  float3 relative_weighted_out =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(
      psycho20_FromAdaptiveRelativeWeightedLMS(
          relative_weighted_out,
          adaptive_neutral_lms));
}

float3 psycho20_SaturateToPeak(
    float3 x,
    float3 peak,
    float3 anchor_out,
    float highlights) {
  float h = max(highlights, 1e-6f);
  float h_rcp = rcp(h);

  float3 peak_minus_anchor =
      max(peak - anchor_out, 1e-6f.xxx);

  float3 x_safe =
      max(x, 1e-6f.xxx);

  float3 denominator =
      pow(
          pow(x_safe, h) + pow(peak_minus_anchor, h),
          h_rcp);

  return peak * x_safe / max(denominator, 1e-6f.xxx);
}

// psychov-14
//
// Objective:
// psychov-14 first targets the observer-side bend of the scene:
// - what state the eye adapts to,
// - how the scene is converted to contrast around that adapted state,
// - how the response is shaped around that adapted state,
// - which nonlinear curve applies at each stage.
// The human observer is not a linear gain system, so the first job of this
// test is to model how a cone/adaptation/opponent/normalization cascade bends
// scene light before any device mapping is considered.
//
// psychov-14 therefore treats the problem as two coupled but distinct systems:
// - observer flow: approximate the ordered flow of the human cone visual
//   pathway with a literature-backed cascade, so each stage in the code
//   corresponds to a recognizable stage in human vision rather than an
//   arbitrary tone curve,
// - device-hull mapping: tonemap the observer-domain result into the display's
//   luminance / gamut hull as plausibly as possible.
// Tonemapping itself remains a device-hull problem, not an eye model, but the
// observer model decides which scene differences remain perceptually important
// enough to preserve when the device hull forces compression.
//
// Intended human-flow model and supporting references:
// 1) Receptor basis:
//    Stockman-Sharpe LMS with CIE 170-2 physiological luminance Yf / weighted
//    LMS bookkeeping, not CIE 1931 Y.
//    Reference split:
//    - Brainard, "Colorimetry" (chapter 10): the cone stage / color match
//      foundation. Chapter 11 explicitly points back to this chapter when it
//      says "The first stage of color vision is now well understood (see
//      Chap. 10)." For psychov, this is the source for step 1:
//      scene RGB/XYZ -> absolute cone excitations L, M, S.
//    - Stockman & Brainard (chapter 11): builds on that receptor basis for
//      first-site and second-site adaptation.
//    Sources:
//    https://color2.psych.upenn.edu/brainard/papers/Brainard_Stockman_Colorimetry.pdf
//    https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//    CVRL background notes that cone signals are formed only after
//    prereceptoral filtering by the ocular media and macular pigment, both of
//    which absorb mainly at short wavelengths and vary substantially across
//    observers. The current repo plumbing should therefore be understood as an
//    average-observer receptor basis unless those filters are modeled
//    explicitly.
//    Reference: CVRL background hub; "Macular and lens pigments"
//    (http://www.cvrl.org/background.htm,
//     http://www.cvrl.org/database/text/intros/intromaclens.htm).
//    MacLeod-Boynton is important here: it is not itself the cortical flow,
//    but a weighted cone-chromaticity representation in an equal-luminance
//    plane with a separately carried achromatic scale term. In repo notation:
//      l = Lw / (Lw + Mw)
//      s = Sw / (Lw + Mw)
//      y = Lw + Mw
//    The weights here are fixed observer-transform coefficients used to form
//    weighted LMS, Yf-like achromatic response, and MB coordinates from LMS.
//    They are not adaptation, gain, or bleaching terms. CVRL describes the
//    CIE physiological functions as linear transformations of the Stockman &
//    Sharpe cone fundamentals, and Mantiuk et al. describe a practical LMS
//    scaling "so that the sum of L and M cone responses corresponds to
//    luminance". That is the math role of the weights in this stage.
//    Reference: MacLeod & Boynton (1979, doi:10.1364/JOSA.69.001183); modern
//    CIE 170-2 implementations replace ad hoc weights with standardized
//    physiological cone-fundamental / luminance weights.
//    Citation split for the weights used in this file:
//    - Explicit CIE 170-2 / physiological-weight usage:
//      CIE / CVRL physiological functions; Psychtoolbox LMSToMacBoyn; this
//      repo's stockman_macleod_boynton.hlsl wiring.
//    - Classic or modified MacLeod-Boynton without an explicit CIE 170-2
//      coefficient claim:
//      MacLeod & Boynton (1979); Webster & Leonard (2008).
//    - LMS scaled so the achromatic term is L+M, but without an explicit
//      CIE 170-2 MacLeod-Boynton coefficient claim:
//      Mantiuk et al. (2020).
//    So classic MB, modified MB, and plain L+M-scaled LMS should not be cited
//    as if they automatically justify the exact CIE 170-2 coefficients used
//    here.
//    Sources:
//    http://www.cvrl.org/ciexyzpr.htm
//    https://psychtoolbox.org/docs/LMSToMacBoyn
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC2657039/
//    https://www.cl.cam.ac.uk/~rkm38/pdfs/mantiuk2020practical_csf.pdf
// 2) Early cone adaptation:
//    Maintain an adapting background state (L0, M0, S0, Yf0), then express the
//    stimulus relative to that background before any postreceptoral transform.
//    Chapter split:
//    - chapter 10 gives the absolute cone excitations,
//    - chapter 11 then defines how those cone excitations depend on the
//      adapting background and are converted to a contrast representation.
//    Source-backed first-site math is cone-specific contrast / gain control,
//    not a rule that every adapted background is mapped to one fixed output
//    level. Stockman & Brainard write the first-site cone contrast for the
//    L-cone as:
//      C_L = ΔL / (L_b + L_0)
//    with analogous forms for M and S. Equivalently, a background-dependent
//    gain g_L = 1 / (L_b + L_0) acts on the increment:
//      g_L * (L - L_b) = ΔL / (L_b + L_0)
//    Thus the observer is approximately normalizing cone signals by the
//    adapted background, not forcing all backgrounds to one arbitrary response
//    value. First-site adaptation is also not complete or instantaneous, and
//    later second-site adaptation further reshapes postreceptoral signals.
//    References: Stockman & Brainard (2010); Stockman et al. (JOV 2006,
//    doi:10.1167/6.11.5).
//    Webster & Leonard (2008) add an important structural point, but their
//    terms need to stay separate. Their "response norm" is the adapting level
//    that does not bias white judgments, while their "perceptual norm" is the
//    stimulus that appears white. Those psychophysical norms tracked each
//    other closely in their experiments, but they are not the same term as the
//    background cone excitations L_b / M_b / S_b in Stockman & Brainard or
//    the background responses L0 / M0 / S0 in Mantiuk et al. For psychov, the
//    directly modeled early state is therefore best named the adapted
//    background reference (L0, M0, S0, optional Yf0), while Webster's
//    response-norm / perceptual-norm language remains useful as higher-level
//    interpretation of why that adapted reference acts as the current neutral
//    coding state. Webster & Leonard also argue that steady uniform-field
//    chromatic adaptation appeared to arise largely at early stages affected
//    by adaptation.
//    Source:
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC2657039/
//    CVRL further notes that luminosity functions are strongly dependent on
//    chromatic adaptation and observing conditions, whereas cone spectral
//    sensitivities remain fixed until photopigment bleaching becomes
//    significant. That is the reason to keep Yf / luminosity bookkeeping tied
//    to the adapted observer state rather than treating a single photometric Y
//    curve as condition-invariant.
//    Reference: CVRL "Luminosity functions"
//    (http://www.cvrl.org/database/text/intros/introvl.htm).
// 2a) Dim cone-noise regime:
//    Before true rod-dominated vision, cone-mediated detection can already be
//    limited by quantal / transduction noise. In this dim-but-still-cone
//    regime, threshold cone contrast follows approximately De Vries-Rose
//    behavior: in log-log space, threshold contrast decreases with retinal
//    illuminance with slope near -0.5. At higher light levels the system moves
//    toward Weber-like behavior, where threshold contrast is roughly constant
//    relative to the adapted background. This matters for psychov because
//    weak scene differences can disappear into a cone-noise-limited threshold
//    floor before rod vision becomes dominant.
//    Reference direction:
//    - Stockman & Brainard (2010): cone-contrast space is most useful when
//      first-site adaptation is in the Weber regime, and less useful when
//      adaptation falls short of Weber's law at lower levels.
//    - Angueyra & Rieke (2013): primate cone photoreceptors exhibit measurable
//      phototransduction noise, giving a photoreceptor-level source for the
//      dim-light threshold floor.
//    Sources:
//    https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC3815624/
// 2b) High-light bleaching:
//    At sufficiently high retinal illuminance, reduce per-cone pigment
//    availability with a Rushton-Henry-style law in trolands:
//      p(I) = 1 / (1 + I / I0)
//    This is the complementary "available pigment" form of the more commonly
//    cited fraction-bleached law:
//      p_bleached(I) = I / (I + I0)
//    with I0 ~ 10^4.3 Td for cones.
//    Then apply that availability to cone excursions around an adapted white
//    anchor. In the current repo bleaching helper this is implemented as
//    per-cone attenuation of LMS deltas around a white-at-achromatic-level
//    anchor, so availability -> 0 drives the response toward equal white at the
//    same carried achromatic level. That is the desired "intensely bright tends
//    to bleach to white" behavior for this test.
//    Source and attribution:
//    - Stockman et al. (JOV 2006, doi:10.1167/6.11.5): high-light sensitivity
//      regulation is maintained mainly by photopigment bleaching.
//    - Stockman et al. (JOV 2018, 18(6):12): appendix states the steady-state
//      bleaching law p = I / (I + I0), I0 = 10^4.3 Td, citing Rushton & Henry
//      (1968).
//    - CVRL "Bleaching": bleaching reduces effective pigment concentration and
//      narrows spectral sensitivity without changing lambda_max; in cones this
//      matters enough to affect chromatic adaptation and color matching, so a
//      pure scalar availability model is only a first-order approximation.
//      (http://www.cvrl.org/database/text/intros/introbleaches.htm)
//    - The final white-relative application used here is the repo's rendering
//      interpretation of that availability law for color signals; see
//      color/bleaching.hlsl for the exact helper.
//    Placement in the overall flow:
//    - bleaching belongs inside the observer model,
//    - after the adapting background state is defined,
//    - before postreceptoral opponent encoding and pooled cortical gain,
//    - and therefore before any device-hull tonemapping / gamut compression.
// 3) Background-normalized opponent drive:
//    Convert cone-domain responses into ACC / DKL-style opponent coordinates
//    using a background-referenced, weighted-LMS achromatic axis.
//    Reference direction: derive postreceptoral opponent coordinates from the
//    adapted cone-domain state and keep this stage clearly separated from the
//    receptor / adaptation math above.
//    Important distinction: MacLeod-Boynton describes chromaticity on the
//    equal-luminance plane, while ACC / DKL are opponent combinations of cone
//    increments around a background. MB is therefore the right place to carry
//    hue / gamut geometry and achromatic Yf bookkeeping; ACC / DKL is the
//    better place to describe postreceptoral opponent response and gain.
// 4) Saturating contrast response:
//    Use a Michaelis-Menten / Naka-Rushton-like nonlinearity for receptor or
//    early cortical contrast response. A supersaturating variant may be needed
//    later for some cortical fits.
//    Reference: Peirce (JOV 2007, doi:10.1167/7.6.13).
// 5) ON/OFF separation:
//    Split increments and decrements with half-wave rectification before the
//    pooled gain stage.
//    Reference: Schiller (1992).
// 6) Pooled cortical gain:
//    Apply divisive normalization, potentially with energy-like pooling across
//    achromatic and chromatic channels.
//    Reference: Heeger (1992); Carandini & Heeger (2012); Bun & Horwitz
//    (2023); Li et al. (2022).
// 7) Device-hull tonemapping / gamut mapping:
//    Map the observer-domain result into the display hull in a space that keeps
//    enough achromatic and chromatic contrast / JND energy to preserve the
//    scene plausibly on the target device. White is one valid attractor when
//    bleaching or the achromatic optimum dominates, but it is not the only
//    valid out-of-hull destination.
//    Inference for RGB display hulls:
//    - many device hulls can produce more total achromatic output by combining
//      primaries than they can produce at the same brightness with a high-purity
//      chromatic excursion,
//    - therefore an out-of-hull observer response may need to trade chromatic
//      shape / purity toward the achromatic axis if that is what the device
//      hull allows,
//    - the preferred mapping is not blind clipping to white, but the in-hull
//      point that preserves the most plausible observer-domain contrast energy.
//    Engineering direction inferred from the sources above:
//    - use MB / weighted-LMS to carry achromatic Yf and hue geometry,
//    - use ACC / opponent space to judge postreceptoral contrast structure,
//    - construct or project to a display hull in that combined space rather
//      than clipping in RGB.
//    Coupling constraint:
//    - hue preservation and device-hull compression are not independent steps,
//    - a hue change applied after hull compression can push the result back out
//      of the device hull,
//    - therefore hue-preserving motion should either be solved inside the hull
//      projection itself or followed by another explicit in-hull reprojection.
//    Reference direction: MacLeod-Boynton / CIE 170-2 geometry;
//    repo weighted-LMS / MB geometry plus the device-hull notes above.
// 7a) Optional hue model inside the device-hull solve:
//    If gamut compression or display desaturation bends hue in a way that
//    looks wrong, the hull solve can preserve hue by an "equivalent Gaussian
//    peak" proxy rather than by preserving a raw opponent angle. The idea is
//    that at short and medium wavelengths, perceived hue can behave more like a
//    constant spectral peak of an equivalent Gaussian than a constant cone
//    ratio when purity changes.
//    Practical form:
//    - offline, map weighted LMS / MB chromaticities to an equivalent Gaussian
//      peak parameter mu_eq using a spectral forward model,
//    - online, preserve mu_eq during gamut compression / display mapping while
//      carrying Yf separately,
//    - do not apply an unconstrained post-hoc hue shift after final hull
//      compression unless the result is reprojected back into the device hull.
//    This is not a separate chronological eye stage after stage 7. It is an
//    optional hue objective used inside the device-hull mapping stage.
//    Reference: Mizokami et al. (JOV 2006, doi:10.1167/6.9.12);
//    O'Neil et al. (JOSAA 2012, doi:10.1364/JOSAA.29.00A165).
//
// Mermaid source map of planned psychov inputs, derived states, and outputs:
// ```mermaid
// flowchart TB
//   classDef raw fill:#223041,stroke:#7aa2d2,color:#e8f0ff
//   classDef func fill:#3c2a4d,stroke:#b48ef7,color:#f5ecff
//   classDef state fill:#294436,stroke:#77c79a,color:#effff5
//   classDef out fill:#5a3a1f,stroke:#f2bc6b,color:#fff6e8
//
//   subgraph inputs["Raw inputs / assumptions"]
//     direction TB
//     rgb["Scene-linear R / G / B"]:::raw
//     src_color["Source colorimetry\nprimaries + white + RGB->XYZ/LMS"]:::raw
//     abs_scale["Absolute scene scale\nscene-linear -> nits"]:::raw
//     local_bg["Adaptation drivers\nrolling average + local background"]:::raw
//     scene_range["Late image context\nluminance range / percentile span"]:::raw
//     retinal["Retinal context\npupil area + trolands"]:::raw
//     observer_basis["Observer basis assumptions\nStockman/CVRL LMS + lens/macula"]:::raw
//     display["Display/device context\nprimaries + white + peak + black + hull"]:::raw
//   end
//
//   subgraph pipeline["Observer pipeline"]
//     direction TB
//     src_to_lms["RGB -> receptor LMS"]:::func
//     abs_lms["Absolute cone-energy state\nL, M, S"]:::state
//     adapt_fn["Estimate adapted background reference"]:::func
//     adapt["Adapted background reference\nL0, M0, S0, optional Yf0"]:::state
//     cone_contrast_fn["Form per-cone background-relative signal"]:::func
//     cone_contrast["Per-cone contrast state\nDeltaL/(Lb+L0), DeltaM/(Mb+M0), DeltaS/(Sb+S0)"]:::state
//     bleach_fn["Apply per-cone bleaching availability"]:::func
//     bleach["Bleaching availability state"]:::state
//     cone_nl_fn["Apply per-cone Naka-Rushton"]:::func
//     cone_nl["Per-cone nonlinear response"]:::state
//     noise_fn["Apply dim cone-noise threshold"]:::func
//     noise_floor["Visibility-limited cone response"]:::state
//     weighted_basis_fn["Optional weighted LMS / Yf / MB transform"]:::func
//     weighted_basis["Observer-summary basis state"]:::state
//     opponent_fn["Recombine to opponent / achromatic channels"]:::func
//     opponent["Opponent / achromatic response"]:::state
//     onoff_fn["Split ON / OFF pathways"]:::func
//     onoff["ON / OFF responses"]:::state
//     late_gain_fn["Apply late polarity / range gain"]:::func
//     late_gain["Late polarity / range-gated response"]:::state
//     pool_fn["Apply pooling / divisive normalization"]:::func
//     pooled["Pooled / normalized response"]:::state
//     observer_out["Observer-domain response"]:::state
//   end
//
//   subgraph device_map["Device-hull mapping"]
//     direction TB
//     hue_obj_fn["Optional hue objective\nMB / ACC / mu_eq"]:::func
//     hue_obj["Hue-preserving objective state"]:::state
//     hull_fn["Solve device-hull tone + gamut mapping"]:::func
//     hull["Display-hull output"]:::out
//   end
//
//   rgb --> src_to_lms
//   src_color --> src_to_lms
//   observer_basis --> src_to_lms
//   src_to_lms --> abs_lms
//   abs_scale --> abs_lms
//
//   abs_lms --> adapt_fn --> adapt
//   local_bg --> adapt_fn
//   retinal --> adapt_fn
//
//   abs_lms --> cone_contrast_fn --> cone_contrast
//   adapt --> cone_contrast_fn
//
//   abs_lms --> bleach_fn --> bleach
//   adapt --> bleach_fn
//   retinal --> bleach_fn
//
//   cone_contrast --> cone_nl_fn --> cone_nl
//   bleach --> cone_nl_fn
//
//   cone_nl --> noise_fn --> noise_floor
//   retinal --> noise_fn
//
//   cone_nl --> weighted_basis_fn --> weighted_basis
//
//   noise_floor --> opponent_fn --> opponent
//   weighted_basis --> opponent_fn
//   adapt --> opponent_fn
//
//   opponent --> onoff_fn --> onoff
//   onoff --> late_gain_fn --> late_gain
//   scene_range --> late_gain_fn
//   late_gain --> pool_fn --> pooled --> observer_out
//
//   observer_out --> hue_obj_fn --> hue_obj
//   observer_out --> hull_fn
//   hue_obj --> hull_fn
//   display --> hull_fn
//   hull_fn --> hull
// ```
//
// Current implementation status:
// - This file currently implements the stage-3 to stage-6 scaffold plus a
//   first-pass receptor front end:
//   absolute Stockman LMS -> explicit adapted background reference input ->
//   per-cone bleaching availability -> local receptor Naka-Rushton ->
//   cone-contrast coding -> weighted-LMS ACC placeholder.
// - The full planned early-cone model is still incomplete:
//   rolling scene / local surround adaptation plumbing and dim-light noise
//   thresholding are not wired into test14 yet.
// - The device-hull tonemapping stage is also not wired into test14 yet.
// - The intended receptor basis should be read as an average-observer, mainly
//   foveal Stockman / CVRL basis with prereceptoral lens and macular filtering
//   already folded into the standard functions, not a personalized observer
//   model with explicit lens / macular / eccentricity variation.
// - The adapted background is now an explicit input with a default
//   diffuse-gray proxy, but the caller still needs to supply a real rolling
//   scene / local surround estimate before this can count as a complete
//   adaptation model.
// - The scalar defaults below are unit-normalized test settings and are not
//   yet fitted to a specific physiology dataset.
// - The optional Abney / equivalent-Gaussian hue stage is not implemented yet;
//   if used later, it should be bounded because the Gaussian account works best
//   at short and medium wavelengths and breaks down toward yellow / red.
//
// Secondary seminar notes (useful framing, not primary citation):
// - "Bright lights ... bleach the cones" and make them less sensitive, with
//   slow recovery. This supports the placement of bleaching in the observer
//   model before device mapping.
// - "Gamut ... is the technical container." This supports treating tonemapping
//   as a device-hull problem distinct from the eye model.
// - Diffuse white and peak luminance were discussed separately, which supports
//   keeping display white / diffuse white as explicit anchors in the hull solve.
// Source: "Mythbusting: Colour, Camera, Cinema" (Colorist Society,
// Camerimage 2024 panel with Andrew Stockman / Charles Poynton / Dirk Meier),
// YouTube transcript dated January 13, 2025.
// Ordered summary:
//   scene RGB
//   -> absolute Stockman LMS (chapter 10 receptor basis)
//   -> early cone adaptation (chapter 11 first-site background L0/M0/S0/Yf0)
//   -> high-light bleaching
//   -> opponent drive
//   -> saturating response / ON-OFF / pooled gain
//   -> observer-domain result
//   -> device-hull mapping

float3 psychotm_test20(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float purity_scale = 1.f,
    float bleaching_intensity = 1.f,
    float clip_point = 100.f,
    float hue_restore = 1.f,
    float adaptation_contrast = 1.f,  // deprecated, use contrast+purity
    int white_curve_mode = 0,
    float cone_response_exponent = 1.f,  // deprecated, use contrast+purity
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float gamut_compression = 1.f,
    int gamut_compression_mode = 1,
    float adaptive_normalization = 1.f) {
  purity_scale *= cone_response_exponent * adaptation_contrast;
  contrast *= cone_response_exponent * adaptation_contrast;

  // bt709_linear_input = float3(100.f, 0.f, 0.f);
  // peak_value = 8.f;
  float3 bt709_scene = bt709_linear_input * exposure;

  float3 lms_in = renodx::color::lms::from::BT709(bt709_scene);
  float3 lms_peak = renodx::color::lms::from::BT709(float(peak_value).xxx);
  float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(current_adaptive_state_bt709);
  float3 desired_background_state_lms = renodx::color::lms::from::BT709(current_background_state_bt709);
  float3 lms_working = lms_in;
  if (true) {
    // noop
  } else if (gamut_compression == 0) {
    lms_working = psycho20_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        renodx::color::macleod_boynton::LMS_TO_LMS_WEIGHTED_MAT,
        1.f);
  } else if (gamut_compression_mode == 0) {
    lms_working = psycho20_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
        1.f);
  } else {
    lms_working = psycho20_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }

  float yf_input = renodx::color::yf::from::LMS(lms_working);
  float yf_target = yf_input;

  // Stage 1 intentionally leaves luminosity controls mostly neutral for now.
  // Contrast is handled below as adapted-LMS cone contrast:
  //   out * pow(abs(x) / in, contrast)
  // Highlights are handled only by the saturation-to-peak function.
  // Shadows are disabled while the behavior is still being evaluated.

  if (false && shadows != 1.f) {
    float yf_midgray =
        renodx::color::yf::from::LMS(desired_background_state_lms);

    yf_target =
        renodx::color::grade::Shadows(
            yf_target,
            shadows,
            yf_midgray);
  }

  float yf_scale =
      renodx::math::DivideSafe(
          yf_target,
          yf_input,
          1.f);

  float3 lms_graded =
      lms_working * yf_scale;

  float3 lms_cones = lms_graded;

  float3 display_scaled = lms_cones;

  {
    float3 anchor_in = current_adaptive_state_lms;
    float3 anchor_out = desired_background_state_lms;

    float3 peak_minus_anchor_out = lms_peak - anchor_out;
    float3 n = contrast * lms_peak / peak_minus_anchor_out;

    float h = highlights;
    float h_rcp = rcp(h);

    float3 q = pow(abs(lms_cones) / anchor_in, n * h);
    float3 shoulder = pow(lms_peak / anchor_out, h) - 1.f;

    float3 saturated = lms_peak * pow(q / (q + shoulder), h_rcp);

    display_scaled = renodx::math::CopySign(saturated, lms_cones);
  }

  float3 display_scaled_relative_weighted = psycho20_ToAdaptiveRelativeWeightedLMS(
      display_scaled,
      current_adaptive_state_lms);

  // -----------------------------------------------------------------------------
  // psychov17-style hue restore.
  // Restores MB hue direction, not max-channel LMS direction.
  // Keeps display target radius and MB.y carrier.
  // -----------------------------------------------------------------------------

  if (hue_restore > 0.f) {
    float3 lms_cones_relative_weighted =
        psycho20_ToAdaptiveRelativeWeightedLMS(
            lms_cones,
            current_adaptive_state_lms);

    float3 mb_source =
        renodx::color::macleod_boynton::from::WeightedLMS(
            lms_cones_relative_weighted);

    float3 mb_display_target =
        renodx::color::macleod_boynton::from::WeightedLMS(
            display_scaled_relative_weighted);

    float3 mb_adapted_bg =
        renodx::color::macleod_boynton::from::LMS(1.f.xxx);

    float2 source_offset =
        mb_source.xy - mb_adapted_bg.xy;

    float2 display_target_offset =
        mb_display_target.xy - mb_adapted_bg.xy;

    float src2 = dot(source_offset, source_offset);
    float display_tgt2 = dot(display_target_offset, display_target_offset);

    if (src2 > 1e-7f && display_tgt2 > 1e-7f) {
      float inv_target_radius = rsqrt(display_tgt2);
      float target_radius = display_tgt2 * inv_target_radius;

      float source_t_clip =
          psycho20_RayExitTCIE1702(
              mb_adapted_bg.xy,
              source_offset);

      float display_t_clip =
          psycho20_RayExitTCIE1702(
              mb_adapted_bg.xy,
              display_target_offset);

      float source_purity_signal =
          psycho20_HueRelativePuritySignalFromTClip(source_t_clip);

      float display_purity_signal =
          psycho20_HueRelativePuritySignalFromTClip(display_t_clip);

      // This is the v17 behavior.
      float purity_signal_loss = saturate(
          renodx::math::DivideSafe(
              display_purity_signal,
              source_purity_signal,
              1.f));

      float hue_sensitivity =
          psycho20_AdaptiveHueSensitivityFromTClip(display_t_clip);

      float restore_weight = hue_sensitivity * hue_restore * purity_signal_loss;
      restore_weight = hue_restore * 0.5;

      if (restore_weight > 0.f) {
        float inv_source_radius = rsqrt(src2);

        float2 source_dir =
            source_offset * inv_source_radius;

        float2 display_target_dir =
            display_target_offset * inv_target_radius;

        float2 blended_dir =
            lerp(display_target_dir, source_dir, saturate(restore_weight));

        float blended_len2 = dot(blended_dir, blended_dir);
        if (blended_len2 > 1e-7f) {
          blended_dir *= rsqrt(blended_len2);
        } else {
          blended_dir = display_target_dir;
        }

        // Keep display target radius and y_MB; only replace hue direction.
        float2 mb_restored_xy =
            mb_adapted_bg.xy + blended_dir * target_radius;

        float3 mb_restored =
            float3(mb_restored_xy, mb_display_target.z);

        display_scaled_relative_weighted =
            renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
                mb_restored);
      }
    }
  }

  // -----------------------------------------------------------------------------
  // M-cone crosstalk as MB hue-direction bias.
  // Apply after NR-to-white + v17 MB hue restore.
  // Does NOT rebuild max-channel magnitude.
  // Does NOT transfer L/S into M directly.
  // Does NOT move neutral/white.
  // -----------------------------------------------------------------------------

  {
    float3 neutral_w = psycho20_AdaptiveRelativeWeightedNeutral();

    float3 source_relative_w =
        psycho20_ToAdaptiveRelativeWeightedLMS(
            lms_cones,
            current_adaptive_state_lms);

    float3 target_relative_w = display_scaled_relative_weighted;

    float neutral_yf = max(neutral_w.x + neutral_w.y, 1e-6f);

    float3 source_acc =
        psycho20_ACCFromAdaptiveRelativeWeightedDelta(
            source_relative_w - neutral_w)
        / neutral_yf;

    // Source-side cone drive decides whether M-bias is plausible.
    float3 drive =
        abs(lms_cones) / max(current_adaptive_state_lms, 1e-6f.xxx);

    float l_over_m = max(drive.x - drive.y, 0.f);
    float s_over_m = max(drive.z - drive.y, 0.f);

    // Suppress L+S mixed/complementary cases: magenta/purple.
    float ls_mixed_share =
        renodx::math::DivideSafe(
            min(l_over_m, s_over_m),
            max(l_over_m + s_over_m, 1e-6f),
            0.f);

    float cone_complementary_gate =
        smoothstep(0.02f, 0.15f, ls_mixed_share);

    float acc_complementary_gate =
        psycho20_PurpleComplementaryGateFromACC(source_acc);

    float complementary_gate =
        max(cone_complementary_gate, acc_complementary_gate);

    float spectral_confidence = 1.f - complementary_gate;

    // L/M overlap is closer than S/M. S gets only a very small bias.
    // Also require some M participation for L-bias so extreme pure-L does not
    // over-rotate.
    float lm_share = renodx::math::DivideSafe(
        drive.y,
        max(drive.x + drive.y, 1e-6f),
        0.f);

    float l_bias = saturate(l_over_m / max(drive.x, 1e-6f)) * saturate(lm_share / 0.25f);

    float s_bias = 0.15f * saturate(s_over_m / max(drive.z, 1e-6f));

    float m_bias_weight = spectral_confidence * (0.12f * l_bias + 0.025f * s_bias);

    // Do nothing for neutral source or neutral target.
    float3 mb_source =
        renodx::color::macleod_boynton::from::WeightedLMS(source_relative_w);

    float3 mb_target =
        renodx::color::macleod_boynton::from::WeightedLMS(target_relative_w);

    float3 mb_neutral =
        renodx::color::macleod_boynton::from::LMS(1.f.xxx);

    float2 source_offset =
        mb_source.xy - mb_neutral.xy;

    float2 target_offset =
        mb_target.xy - mb_neutral.xy;

    float source_radius2 = dot(source_offset, source_offset);
    float target_radius2 = dot(target_offset, target_offset);

    if (source_radius2 > 1e-7f && target_radius2 > 1e-7f && m_bias_weight > 0.f) {
      float target_radius = sqrt(target_radius2);

      float2 target_dir =
          target_offset * rsqrt(target_radius2);

      // Pure M direction in MB plane.
      // WeightedLMS pure-M is [0, M_weight, 0].
      float3 mb_m =
          renodx::color::macleod_boynton::from::WeightedLMS(
              float3(0.f, renodx::color::CIE1702_MB_CIE_WEIGHTS.y, 0.f));

      float2 m_offset =
          mb_m.xy - mb_neutral.xy;

      float m_offset2 = dot(m_offset, m_offset);

      if (m_offset2 > 1e-7f) {
        float2 m_dir =
            m_offset * rsqrt(m_offset2);

        float2 bent_dir =
            lerp(target_dir, m_dir, saturate(m_bias_weight));

        float bent_len2 = dot(bent_dir, bent_dir);
        if (bent_len2 > 1e-7f) {
          bent_dir *= rsqrt(bent_len2);
        } else {
          bent_dir = target_dir;
        }

        // Preserve target radius and y_MB. Only bend hue direction.
        float2 mb_bent_xy =
            mb_neutral.xy + bent_dir * target_radius;

        float3 mb_bent =
            float3(mb_bent_xy, mb_target.z);

        display_scaled_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_bent);
      }
    }
  }

  if (gamut_compression != 0.f) {
    if (gamut_compression_mode == 0) {
      display_scaled_relative_weighted = psycho20_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    } else if (gamut_compression_mode == 1) {
      display_scaled_relative_weighted = psycho20_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    }
  }
  // Scale back from first-site adaptation;
  float3 final_bt709 = renodx::color::bt709::from::LMS(
      renodx::color::macleod_boynton::UnweighLMS(
          psycho20_FromAdaptiveRelativeWeightedLMS(
              display_scaled_relative_weighted,
              current_adaptive_state_lms)));
  return final_bt709;
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_ELITEDANGEROUS_PSYCHOV_TEST20_HLSL_
