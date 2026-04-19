#include "./shared.h"
#include "./macleod_boynton.hlsli"

#ifndef RENODX_PRAGMATA_PSYCHO_TEST17_HLSLI_
#define RENODX_PRAGMATA_PSYCHO_TEST17_HLSLI_

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

float psycho17_HueRelativePuritySignalFromMB(float2 mb_xy, float2 mb_anchor) {
  float2 direction = mb_xy - mb_anchor;
  if (dot(direction, direction) <= renodx::color::gamut::MB_NEAR_WHITE_EPSILON) {
    return 0.f;
  }

  return psycho17_HueRelativePuritySignalFromTClip(
      psycho17_RayExitTCIE1702(mb_anchor, direction));
}

float psycho17_HueRelativePuritySignalFromMB(float3 mb, float2 mb_anchor) {
  if (!(mb.z > renodx::color::gamut::EPSILON)) {
    return 0.f;
  }

  return psycho17_HueRelativePuritySignalFromMB(mb.xy, mb_anchor);
}

float psycho17_HueRelativePuritySignal(float3 lms_input, float2 mb_anchor) {
  float3 lms_weighted = renodx::color::macleod_boynton::WeighLMS(max(lms_input, 0.f));
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(lms_weighted);
  if (!(mb.z > renodx::color::gamut::EPSILON)) {
    return 0.f;
  }

  return psycho17_HueRelativePuritySignalFromMB(mb, mb_anchor);
}

float psycho17_D65HueSensitivity(float2 mb_xy) {
  float2 mb_white = renodx::color::macleod_boynton::from::D65XY();
  float2 direction = mb_xy - mb_white;
  if (dot(direction, direction) <= renodx::color::gamut::MB_NEAR_WHITE_EPSILON) {
    return 1.f;
  }

  return psycho17_AdaptiveHueSensitivityFromTClip(
      psycho17_RayExitTCIE1702(mb_white, direction));
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
  float3 lms_weighted_relative =
      psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, current_adaptive_state_lms);
  float3 lms_weighted_relative_out =
      renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
          lms_weighted_relative,
          current_adaptive_state_lms,
          bound_rgb_to_lms_weighted_mat,
          strength);
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho17_FromAdaptiveRelativeWeightedLMS(
          lms_weighted_relative_out,
          current_adaptive_state_lms));
}

float3 psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
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

float psycho17_AdaptiveHueSensitivity(float2 mb_xy, float2 mb_anchor) {
  float2 direction = mb_xy - mb_anchor;
  if (dot(direction, direction) <= renodx::color::gamut::MB_NEAR_WHITE_EPSILON) {
    return 1.f;
  }

  return psycho17_AdaptiveHueSensitivityFromTClip(
      psycho17_RayExitTCIE1702(mb_anchor, direction));
}

float3 psycho17_ComputeReinhardScale(float3 peak = 1.f, float minimum = 0.f, float3 gray_in = 0.18f, float3 gray_out = 0.18f) {
  //  s = (p * y - p * m) / (x * p - x * y)

  float3 num = peak * (gray_out - minimum);  // p * (y - m)
  float3 den = gray_in * (peak - gray_out);  // x * (p - y)

  return num / den;
}

float3 psycho17_ReinhardPiecewise(float3 x, float3 x_max = 1.f, float3 shoulder = 0.18f) {
  const float x_min = 0.f;
  float3 exposure = psycho17_ComputeReinhardScale(x_max, x_min, shoulder, shoulder);
  float3 tonemapped = mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);

  return lerp(x, tonemapped, step(shoulder, x));
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
    bool compress_gamut = true) {
  if (amount <= 0.f) return bt2020_target;

  float3 lms_target = renodx::color::lms::from::BT2020(bt2020_target);
  float3 lms_source = renodx::color::lms::from::BT2020(bt2020_source);
  float3 lms_out = psycho17_ApplyPurityFromLMS(
      lms_source,
      lms_target,
      amount,
      clamp_purity_loss,
      eps);

  if (compress_gamut) {
    lms_out = psycho17_GamutCompressLMSBoundAdaptive(
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
    bool use_adaptive_hue_sensitivity = true,
    float eps = 1e-7f) {
  if (amount <= 0.f) return lms_target;

  float3 lms_source_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(
      lms_source,
      lms_adaptive_state);
  float3 lms_target_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(
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

  float target_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, target_offset);
  float hue_sensitivity = use_adaptive_hue_sensitivity
                              ? psycho17_AdaptiveHueSensitivityFromTClip(target_t_clip)
                              : 1.f;
  float purity_loss_weight = 1.f;
  if (weight_by_purity_loss) {
    float source_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, source_offset);
    float source_purity_signal = psycho17_HueRelativePuritySignalFromTClip(source_t_clip);
    float target_purity_signal = psycho17_HueRelativePuritySignalFromTClip(target_t_clip);
    purity_loss_weight = source_purity_signal > eps ? saturate(target_purity_signal / source_purity_signal) : 1.f;
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
  float3 lms_restored_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);

  return renodx::color::macleod_boynton::UnweighLMS(
      psycho17_FromAdaptiveRelativeWeightedLMS(
          lms_restored_relative_weighted,
          lms_adaptive_state));
}

// Direct MB hue transfer in LMS domain (matches CorrectHueAndPurityMB geometry).
float3 psycho17_RestoreHueFromLMS(
    float3 lms_source,
    float3 lms_target,
    float amount,
    float eps = 1e-7f) {
  if (amount <= 0.f) return lms_target;

  float target_t = lms_target.x + lms_target.y;
  if (target_t <= eps) return lms_target;

  float hue_blend = saturate(amount);
  if (hue_blend <= 0.f) return lms_target;

  float2 white = renodx_custom::color::macleod_boynton::MB_White_D65();
  float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(lms_target) - white;
  float2 source_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(lms_source) - white;

  float target_len_sq = dot(target_direction, target_direction);
  float source_len_sq = dot(source_direction, source_direction);

  if (target_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON &&
      source_len_sq < renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    return lms_target;
  }

  float2 target_unit = (target_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                           ? target_direction * rsqrt(target_len_sq)
                           : float2(0.f, 0.f);
  float2 source_unit = (source_len_sq > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON)
                           ? source_direction * rsqrt(source_len_sq)
                           : target_unit;
  if (target_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    target_unit = source_unit;
  }

  float2 blended_unit = lerp(target_unit, source_unit, hue_blend);
  float blended_len_sq = dot(blended_unit, blended_unit);
  if (blended_len_sq <= renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
    blended_unit = (hue_blend >= 0.5f) ? source_unit : target_unit;
    blended_len_sq = dot(blended_unit, blended_unit);
  }
  blended_unit *= rsqrt(max(blended_len_sq, 1e-20f));

  float seed_len = sqrt(max(target_len_sq, 0.f));
  if (seed_len <= 1e-6f) {
    seed_len = sqrt(max(source_len_sq, 0.f));
  }
  seed_len = max(seed_len, 1e-6f);

  return renodx_custom::color::macleod_boynton::LMS_From_MB_T(
      white + blended_unit * seed_len, target_t);
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

  const float2 mb_white = renodx_custom::color::macleod_boynton::MB_White_D65();
  float applied_purity_strength = saturate(purity_amount);
  float purity_loss_clamp = saturate(clamp_purity_loss);
  float target_purity01 = 0.f;
  float source_purity01 = 0.f;
  bool has_purity_pair = false;
  if (applied_purity_strength > 0.f && purity_loss_clamp > 0.f) {
    target_purity01 = Purity01FromBT2020MB(
        bt2020_target, mb_white, eps);
    source_purity01 = Purity01FromBT2020MB(
        bt2020_source, mb_white, eps);
    has_purity_pair = true;
    float transferred_purity01 = lerp(target_purity01, source_purity01, applied_purity_strength);
    float no_purity_loss01 = max(transferred_purity01, target_purity01);
    transferred_purity01 = lerp(transferred_purity01, no_purity_loss01, purity_loss_clamp);

    float purity_span01 = source_purity01 - target_purity01;
    if (abs(purity_span01) > eps) {
      applied_purity_strength =
          saturate((transferred_purity01 - target_purity01) / purity_span01);
    } else {
      applied_purity_strength = 0.f;
    }
  }

  float applied_hue_strength = saturate(hue_amount);
  if (applied_hue_strength > 0.f && use_adaptive_hue_sensitivity) {
    float3 target_lms = mul(
        renodx_custom::color::macleod_boynton::XYZ_TO_LMS_2006,
        mul(renodx::color::BT2020_TO_XYZ_MAT, bt2020_target));
    float2 target_direction = renodx_custom::color::macleod_boynton::MB_From_LMS(target_lms) - mb_white;
    if (dot(target_direction, target_direction) > renodx_custom::color::macleod_boynton::MB_NEAR_WHITE_EPSILON) {
      float target_t_clip = psycho17_RayExitTCIE1702(mb_white, target_direction);
      applied_hue_strength *= psycho17_AdaptiveHueSensitivityFromTClip(target_t_clip);
    }
  }

  float3 bt2020_out;
  if (applied_hue_strength <= 0.f) {
    if (!has_purity_pair) {
      target_purity01 = Purity01FromBT2020MB(
          bt2020_target, mb_white, eps);
      source_purity01 = Purity01FromBT2020MB(
          bt2020_source, mb_white, eps);
      has_purity_pair = true;
    }
    float applied_purity01 = lerp(target_purity01, source_purity01, applied_purity_strength);
    bt2020_out = renodx_custom::color::macleod_boynton::ApplyBT2020(
                     bt2020_target, applied_purity01, 1.f, mb_white, eps)
                     .rgbOut;
  } else {
    bt2020_out = CorrectHueAndPurityMB_BT2020(
        bt2020_target,
        bt2020_source,
        applied_hue_strength,
        applied_purity_strength,
        1.f,
        mb_white,
        eps);
  }

  if (!compress_gamut) {
    return bt2020_out;
  }

  float3 lms_out = psycho17_GamutCompressLMSBoundAdaptive(
      renodx::color::lms::from::BT2020(bt2020_out),
      1.f.xxx,
      renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
      1.f);
  return renodx::color::bt2020::from::LMS(lms_out);
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
float3 psychotm_test17(
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
    float adaptation_contrast = 1.f,
    int white_curve_mode = 0,
    float cone_response_exponent = 1.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float gamut_compression = 1.f,
    int gamut_compression_mode = 1,
    float adaptive_normalization = 1.f) {
  float3 bt709_scene = bt709_linear_input * exposure;

  float3 lms_in = renodx::color::lms::from::BT709(bt709_scene);
  float3 lms_peak = renodx::color::lms::from::BT709(float(peak_value).xxx);
  float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(current_adaptive_state_bt709);
  float3 desired_background_state_lms = renodx::color::lms::from::BT709(current_background_state_bt709);
  float3 lms_working = lms_in;
  if (true) {
    // noop
  } else if (gamut_compression == 0) {
    lms_working = psycho17_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        renodx::color::macleod_boynton::LMS_TO_LMS_WEIGHTED_MAT,
        1.f);
  } else if (gamut_compression_mode == 0) {
    lms_working = psycho17_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
        1.f);
  } else {
    lms_working = psycho17_GamutCompressLMSBoundAdaptive(
        lms_in,
        current_adaptive_state_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }

  float yf_input = renodx::color::yf::from::LMS(lms_working);
  float yf_midgray = renodx::color::yf::from::BT709(0.18f);
  float yf_target = yf_input;

  // Stage 1: apply UI highlight/shadow/contrast controls in luminosity space.
  if (highlights != 1.f) {
    yf_target = renodx::color::grade::Highlights(yf_target, highlights, yf_midgray);
  }
  if (shadows != 1.f) {
    yf_target = renodx::color::grade::Shadows(yf_target, shadows, yf_midgray);
  }
  if (contrast != 1.f) {
    yf_target = renodx::color::grade::ContrastSafe(yf_target, contrast, yf_midgray);
  }

  float yf_scale = renodx::math::DivideSafe(yf_target, yf_input, 1.f);

  float3 lms_graded = lms_working * yf_scale;
  if (purity_scale != 1.f) {
    float3 lms_graded_relative = psycho17_ToAdaptiveRelativeLMS(
        lms_graded,
        current_adaptive_state_lms);
    float3 mb = renodx::color::macleod_boynton::from::LMS(lms_graded_relative);
    float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
    float2 mb_scaled = lerp(mb_white, mb.xy, purity_scale);
    lms_graded = psycho17_FromAdaptiveRelativeLMS(
        renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb.z)),
        current_adaptive_state_lms);
  }

  float3 lms_cones = lms_graded;

  // if (bleaching_intensity != 0.f) {
  //   float3 availability = 1.f.xxx / (1.f.xxx + (peak_value / current_adaptive_state_lms));
  //   availability = lerp(1.f.xxx, availability, bleaching_intensity);

  //   float input_energy = lms_cones.x + lms_cones.y + lms_cones.z;
  //   float white_y = current_adaptive_state_lms.x + current_adaptive_state_lms.y + current_adaptive_state_lms.z;
  //   float3 white_at_y = current_adaptive_state_lms * (input_energy / white_y);
  //   float3 delta = (lms_cones - white_at_y) * availability;
  //   lms_cones = max(0, white_at_y + delta);
  // }

  // Naka-Rushton is scale-equivariant if input, peak, and anchors are all
  // normalized by the same adaptive LMS state, so keep the absolute-LMS form.
  float3 display_scaled = renodx::tonemap::NakaRushton(
      lms_cones,
      lms_peak,
      current_adaptive_state_lms,
      desired_background_state_lms,
      cone_response_exponent);
  float3 display_scaled_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(
      display_scaled,
      current_adaptive_state_lms);

  if (hue_restore > 0.f) {
    float3 lms_cones_relative_weighted = psycho17_ToAdaptiveRelativeWeightedLMS(
        lms_cones,
        current_adaptive_state_lms);
    float3 mb_source =
        renodx::color::macleod_boynton::from::WeightedLMS(lms_cones_relative_weighted);
    float3 mb_display_target =
        renodx::color::macleod_boynton::from::WeightedLMS(display_scaled_relative_weighted);
    float3 mb_adapted_bg = renodx::color::macleod_boynton::from::LMS(1.f.xxx);

    float2 source_offset = mb_source.xy - mb_adapted_bg.xy;
    float2 display_target_offset = mb_display_target.xy - mb_adapted_bg.xy;
    float src2 = dot(source_offset, source_offset);
    float display_tgt2 = dot(display_target_offset, display_target_offset);
    if (src2 > 1e-7 && display_tgt2 > 1e-7) {
      float inv_target_radius = rsqrt(display_tgt2);
      float target_radius = display_tgt2 * inv_target_radius;
      float source_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, source_offset);
      float display_t_clip = psycho17_RayExitTCIE1702(mb_adapted_bg.xy, display_target_offset);
      // Scale hue restoration by purity loss relative to the adapted neutral anchor.
      float source_purity_signal = psycho17_HueRelativePuritySignalFromTClip(source_t_clip);
      float display_purity_signal = psycho17_HueRelativePuritySignalFromTClip(display_t_clip);
      float purity_signal_loss = saturate(display_purity_signal / source_purity_signal);
      float hue_sensitivity = psycho17_AdaptiveHueSensitivityFromTClip(display_t_clip);
      float restore_weight = 1.f * hue_sensitivity * hue_restore * purity_signal_loss;
      if (restore_weight > 0.f) {
        float inv_source_radius = rsqrt(src2);
        float2 source_dir = source_offset * inv_source_radius;
        float2 display_target_dir = display_target_offset * inv_target_radius;
        float2 blended_dir = lerp(display_target_dir, source_dir, restore_weight);
        float blended_len2 = dot(blended_dir, blended_dir);
        if (blended_len2 > 1e-7) {
          blended_dir *= rsqrt(blended_len2);
        } else {
          blended_dir = display_target_dir;
        }

        // Keep display-scaled chroma radius and y_MB; only replace hue direction.
        float2 mb_restored_xy = mb_adapted_bg.xy + blended_dir * target_radius;
        float3 mb_restored = float3(mb_restored_xy, mb_display_target.z);
        display_scaled_relative_weighted =
            renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb_restored);
      }
    }
  }

  if (gamut_compression != 0.f) {
    if (gamut_compression_mode == 0) {
      display_scaled_relative_weighted = psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    } else if (gamut_compression_mode == 1) {
      display_scaled_relative_weighted = psycho17_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    }
  }
  // Scale back from first-site adaptation;
  float3 final_bt709 = renodx::color::bt709::from::LMS(
      renodx::color::macleod_boynton::UnweighLMS(
          psycho17_FromAdaptiveRelativeWeightedLMS(
              display_scaled_relative_weighted,
              current_adaptive_state_lms)));
  return final_bt709;
}

float psycho17_Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1
    float b = mid_gray * pow(x / mid_gray, 2.f - highlights);
    float t = min(x, 1.f);
    return min(x, renodx::math::DivideSafe(x * x, lerp(x, b, t), x));
  }
}

float psycho17_Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1
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

  const float x_normalized = x / mid_gray;
  const float split_contrast = (x < mid_gray) ? contrast_shadows : contrast_highlights;
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  float exponent = contrast * split_contrast * flare_ratio;
  return pow(x_normalized, exponent) * mid_gray;
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
  float flare_lms;
  float contrast_highlights;
  float contrast_shadows;
  float purity_scale;
  float purity_highlights;
  float dechroma;
  float adaptation_contrast;
  float bleaching_intensity;
  float clip_point;
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
    float flare_lms = 0.f,
    float contrast_highlights = 1.f,
    float contrast_shadows = 1.f,
    float purity_scale = 1.f,
    float purity_highlights = 1.f,
    float dechroma = 0.f,
    float adaptation_contrast = 1.f,
    float bleaching_intensity = 0.f,
    float clip_point = 100.f,
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
    flare_lms,
    contrast_highlights,
    contrast_shadows,
    purity_scale,
    purity_highlights,
    dechroma,
    adaptation_contrast,
    bleaching_intensity,
    clip_point,
    mid_gray,
    pre_gamut_compress,
    post_gamut_compress,
    hue_emulation
  };
  return psycho17_config;
}

}  // namespace config17

float3 ApplyTest17BT2020(float3 color_bt2020, float3 color_hue_shift_source_bt2020, config17::Config psycho_config) {
  const float kEps = 1e-7f;
  float clip_point = psycho_config.clip_point;

  float3 midgray_lms = renodx::color::lms::from::BT2020(psycho_config.mid_gray.xxx);

  float3 color_lms_raw = renodx::color::lms::from::BT2020(color_bt2020);
  if (psycho_config.pre_gamut_compress) {
    color_lms_raw = psycho17_GamutCompressLMSBoundAdaptive(
        color_lms_raw,
        midgray_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }

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
    color_lms = psycho17_ReinhardPiecewise(color_lms, lms_peak_unit, midgray_lms);

    color_lms *= renodx::math::DivideSafe(
        lum_original,
        renodx::color::yf::from::LMS(color_lms),
        1.f);
  }

  if (psycho_config.adaptation_contrast != 1.f || psycho_config.hue_emulation != 0.f || psycho_config.flare_lms != 0.f) {
    float3 source_lms = color_lms;
    if (psycho_config.adaptation_contrast != 1.f || psycho_config.flare_lms != 0.f) {
      float3 lms_sigma_unit = max(midgray_lms, kEps.xxx);
      float exponent_base = max(psycho_config.adaptation_contrast, kEps);

      float3 ax = abs(color_lms);
      float3 exponent = exponent_base.xxx;
      if (psycho_config.flare_lms != 0.f) {
        float3 x_normalized = renodx::math::DivideSafe(ax, lms_sigma_unit, 0.f.xxx);
        float3 flare_ratio = renodx::math::DivideSafe(
            x_normalized + psycho_config.flare_lms,
            x_normalized,
            1.f.xxx);
        exponent *= max(flare_ratio, kEps.xxx);
      }

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
      source_lms = lerp(source_lms, renodx::color::lms::from::BT2020(color_hue_shift_source_bt2020), psycho_config.hue_emulation);
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

    if (psycho_config.highlights != 1.f) {
      lum_target = psycho17_Highlights(lum_target, psycho_config.highlights, midgray_lum);
    }

    if (psycho_config.shadows != 1.f) {
      lum_target = psycho17_Shadows(lum_target, psycho_config.shadows, midgray_lum);
    }

    if (psycho_config.contrast != 1.f
        || psycho_config.contrast_highlights != 1.f
        || psycho_config.contrast_shadows != 1.f
        || psycho_config.flare != 0.f) {
      lum_target = psycho17_ContrastAndFlare(
          lum_target,
          psycho_config.contrast,
          psycho_config.contrast_highlights,
          psycho_config.contrast_shadows,
          psycho_config.flare,
          midgray_lum);
    }

    float lum_scale = renodx::math::DivideSafe(lum_target, lum_original, 1.f);
    clip_point *= lum_scale;
    color_lms *= lum_scale;

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
      color_lms = psycho17_ScalePurityMBAdaptive(color_lms, purity_scale, midgray_lms, kEps);
    }
  }

  if (psycho_config.post_gamut_compress) {
    color_lms = psycho17_GamutCompressLMSBoundAdaptive(
        color_lms,
        midgray_lms,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }

  color_bt2020 = renodx::color::bt2020::from::LMS(color_lms);

  if (psycho_config.apply_tonemap) {
    color_bt2020 = renodx::tonemap::neutwo::MaxChannel(
        max(color_bt2020, 0.f.xxx),
        psycho_config.peak_value,
        clip_point);
  }

  return color_bt2020;
}

}  // namespace psycho
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_PSYCHO_TEST17_HLSLI_
