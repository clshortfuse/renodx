#ifndef RENODX_SHADERS_TONEMAP_PSYCHOV_TEST25_HLSL_
#define RENODX_SHADERS_TONEMAP_PSYCHOV_TEST25_HLSL_

#include "../common.hlsli"
#include "./nrg.hlsli"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx {
namespace tonemap {
namespace psychov {

// Psycho25 current implementation
// -------------------------------
// 1. Test24 grading and adaptive-MB purity are retained.
// 2. Anchor-matched per-cone contrast uses sign-preserving powers, retaining
//    signed cone ratios through authored hue and device-hull work. The
//    compression-derived power encodes a cone-response state whose adapted
//    origin is exactly one. Encoded-response power acts before the rational
//    shoulder.
// 3. Per-channel compression defines the raw adaptive-MB hue shift.
// 4. Graph hue authoring uses the numerical sextant peak-search and local
//    graph-inversion solve at 50% amplitude. Fast60 is the lower-cost direct
//    angular midpoint between the source and raw per-channel-compressed
//    adaptive-MB directions. Cone-axis pins remain zeros because the raw
//    per-channel hue shift itself is zero on those axes.
// 5. The actual-peak compressed adaptive-MB radius and carried achromatic
//    scale are retained while only the direction is changed.
// 6. With gamut compression disabled, the retained per-cone LMS rolloff is the
//    output shoulder and supplies the compression path toward adapted white.
// 7. With either target-plane class enabled, per-cone output compression is
//    bypassed.
//    The actual-peak per-cone result supplies adaptive-MB magnitude and radius.
//    A separate compressed direction, whose neutral endpoint is scaled by
//    `guidance_peak_scale`, supplies the hue trajectory guide.
//    Normalization discards carried scale while preserving the physical radius
//    and guided direction without applying either per-cone curve as the final
//    output compressor.
// 8. The trajectory-guided adaptive-MB direction supplies one device-hull
//    ray. Primary enforcement uses the selected target RGB lower planes; peak
//    enforcement uses its upper planes. The two plane classes are independent.
//    With peak enforcement disabled, output follows the authored scalar Yf
//    after any requested primary correction. Linear BT.709 return values may
//    be negative when they represent valid colors inside a wider selected
//    target.
// 9. Selected-target lower-plane feasibility is solved against a same-hue
//    reference radius no smaller than the current physical trajectory or its
//    uncompressed post-contrast source. A C1 radial shoulder begins at 90% of
//    the selected-target lower-plane boundary instead of activating only after
//    a channel becomes negative. Reusing that scale over the outer trajectory
//    preserves its inward-to-white gradient instead of projecting every
//    outside point onto the same gamut boundary. The scale releases smoothly
//    toward the physical path near neutral so blue can keep gaining channel
//    value without turning gray, with a smooth current-trajectory containment
//    cap for signed inputs. This is a direction constraint, not a second
//    output compression curve.
// 10. Reference and Reduced Max-White smoothly turn the authored direction
//    back toward the pre-contrast source direction as the physical radius
//    collapses. They do not retain a nonzero radius: chromatic highlights can
//    become lighter and converge on white without first rotating through an
//    unrelated hue.
// 11. Reference2 is an experimental Graph-authoritative variant of Reference.
//    It retains the six-section direction without the post-Graph source-
//    direction recovery or Reference's same-Yf radial contraction. After the
//    scalar upper-plane shoulder, lower-plane pressure lifts the complete
//    selected-target RGB result smoothly toward peak D65 white. Quadratic
//    pressure moves an outside trajectory progressively inward instead of
//    flattening it onto a target wall without creating an aggressive Yf hump
//    at first contact. The result is then reprojected onto the Graph-
//    authored adaptive-MB hue while retaining its raised Yf and reduced radius.
//    The physical per-cone radius still converges to peak D65 white.
// 12. Linear MB Pullback is a diagnostic lower-plane mode. It retains the
//    Graph/Fast60-authored adaptive-MB direction and actual-peak radius while
//    feasible, then linearly reduces only that radius to the first selected-
//    target lower-plane intersection. It has no custom reference radius,
//    shoulder, neutral release, or source-direction recovery.
// 13. Target RGB Clip is a literal comparison path. It runs the same physical
//    per-cone and authored-hue result without target-hull mapping, transforms
//    it to the selected linear BT.709 or BT.2020 RGB space, and clamps each
//    component directly to [0, peak]. It adds no sectional gamut curve.
// 14. Experimental post-compression is independent of hull selection. Modes
//    1-8 branch from the common post-contrast LMS state before the physical
//    per-cone shoulder, Graph/Fast60 hue authoring, or target-hull solve.
//    Direct target-RGB per-channel and max-channel shoulders can be compared
//    with adaptive-MB hard pullback, adaptive soft compression, RenoDX fixed-
//    D65 soft compression, and source-MB-direction variants. Source BT.709
//    Residual retains the default coupled path and replaces only its final
//    linear-BT.709 residual direction. PsychoV17 Gamut instead retains
//    Test25's physical per-cone shoulder and authored hue, bypasses Test25's
//    coupled target-hull solve, then applies PsychoV17's final adaptive-
//    relative weighted-LMS target-primary compression. PsychoV17 Gamut +
//    Neutwo Max retains that physical/hue trajectory for target-RGB direction,
//    derives magnitude from the unbounded post-contrast signal after the same
//    gamut map, then uses one anchor-normalized max-channel Neutwo peak map.
//    PsychoV17
//    Gamut + NRG White instead retains the completed output's ACC-A scalar
//    metric while moving an over-peak selected-target RGB result from its hue
//    wall toward peak D65 white. None of these options changes the default
//    coupled path. These remain comparison probes rather than candidate
//    device-volume mappings: common-scale max-channel modes can terminate on
//    a colored wall.
// 15. Sectional White Volume is an experimental coupled-hull alternative. It
//    retains the physical per-cone Yf and Graph/Fast60 six-section direction,
//    measures their selected-target RGB displacement from the same-Yf D65
//    axis, and applies one globally smooth L8 cube-occupancy response. Lower
//    primary and upper peak planes participate in the same cross-sectional
//    solve. There is no separate hue-wall handoff, white-spill pass, or final
//    component clamp. The inherited physical per-cone endpoint still requires
//    every positive hue trajectory to converge to peak D65 white.
// 16. Reference3 is an experimental target-hue-triangle volume map. The
//    selected linear RGB cube is decomposed exactly into one triangle per hue:
//    black, the max/min target-channel hue-rim point, and peak D65 white.
//    Physical per-cone Yf and Graph/Fast60 direction supply the preferred
//    point before legacy lower/upper hull passes. Smooth positive barycentric
//    weights place an outside point inside its exact target triangle, while
//    quadratic lower/upper pressure moves increasingly invalid points toward
//    white. Active cube-edge changes come only from target geometry; there is
//    no authored hue- or level-segment handoff.
//
// 17. Canonical Cylinder is an experimental star-volume map. It normalizes
//    authored adaptive-MB radius by the exact selected-target six-plane radial
//    support at each hue/Yf, making every target a unit q-cylinder. Outside
//    occupancy is passed through a pivot/contrast/generalized-Neutwo pressure
//    response and split between inward q contraction and upward motion toward
//    peak D65 white. The target support is re-evaluated at the raised Yf before
//    reconstructing the final radius. In-gamut q <= 1 points are exact identity.
// 18. Adaptive Contrast Fit is an experimental post-ideal lost-contrast fit.
//    It first completes Test25's ordinary physical/MIDPOINT result, then fits
//    that point to the exact selected-target six-plane adaptive-MB radial
//    support at the same physical Yf. Lost adaptive-MB radius contributes only
//    above the adapted Yf, while genuine lost achromatic Yf contributes
//    separately. Their bounded pressure advances one later state on Test25's
//    own per-cone/MIDPOINT trajectory, then reapplies the exact target fit. No
//    straight target-RGB interpolation to white is used.
//
// Device-hull implementation:
// Peak and RGB-gamut constraints are one device-hull problem. For normalized
// BT.709 output, the complete target is the cube 0 <= R,G,B <= 1, not a
// per-channel move toward white followed by an unrelated gamut constraint.
// With both plane classes enabled, the gamut-active branch evaluates this full
// cube along the numerically solved adaptive-MB trajectory. White is one
// possible intermediate in-hull result, but peak D65 white is the required
// endpoint of every positive hue trajectory. A hue may travel along cube faces
// while clipping, but it must not terminate on a colored face. The restored
// source record and longer-term hull plan
// below distinguish this ray solve from a future sectional optimization over
// multiple candidate points.
// In wide-target mode, the result remains represented as linear BT.709 until
// the caller converts it for output. Negative BT.709 components are therefore
// valid when the represented color is inside the selected wider target.

static const float PSYCHO25_EPSILON = 1e-6f;
static const float PSYCHO25_PI = 3.14159265358979323846f;
static const float PSYCHO25_TWO_PI = 6.2831853071795864769f;
static const float PSYCHO25_LARGE = 1e20f;
static const float PSYCHO25_MAX_FINITE_INPUT = 65504.f;
static const float PSYCHO25_LOWER_PLANE_COMPRESSION_KNEE = 0.9f;
static const float PSYCHO25_LOWER_PLANE_NEUTRAL_RELEASE_FRACTION = 0.75f;
static const float PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON = 1e-5f;
static const float PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER = 256.f;
static const float PSYCHO25_SECTIONAL_VOLUME_POWER = 8.f;
static const float PSYCHO25_WHITE_LIFT_PRESSURE_EPSILON = 1e-7f;

// Auto-compression reference.
// Simultaneous luminance dynamic range is stimulus- and method-dependent.
// Published values considered for the automatic compression reference:
//   - Kunkel & Reinhard, APGV 2010, doi:10.1145/1836248.1836251:
//       ~3.7 log10 units under their adapted test conditions.
//   - Jiang & Fairchild, JIST 2021,
//       doi:10.2352/J.ImagingSci.Technol.2021.65.5.050401:
//       direct bright/dark simultaneous measurements on an Apple Pro Display
//       XDR setup reported ~3.3 log10 units for the average observer and
//       3.47 log10 units for OBS1 at 1600 cd/m^2, 3.4 degree stimulus size.
//       Their spatial-frequency fit reports DRmax values of 3.24 log10 at
//       452 cd/m^2 and 3.40 log10 at 1600 cd/m^2. The display apparatus used
//       diffuse white = 50 cd/m^2 and peak luminance = 1600 cd/m^2.
//
// Default choice:
//   Kunkel/Reinhard's 3.7 value is the conservative reference. A larger
//   reference range increases auto h on low-headroom displays, reducing the
//   symmetric curve's OFF/shadow-side bending. Jiang/Fairchild's average is a
//   possible direct-display, glare-inclusive alternative.
//
// Model choice:
//   For a neutral static curve, the adapted/background state is treated as the
//   log midpoint of the selected total range. Half of the log range is above
//   adaptation and half below. This is a neutral log-domain prior, not a claim
//   that biological ON/OFF pathways are exactly symmetric.
//
// For the slope-normalized compression below, the deep OFF-side slope ratio is:
//   S_shadow / contrast = 1 / (1 - pow(anchor_out / peak, h))
// Auto compression solves:
//   h = (reference_range_log10 / 2) / log10(peak / anchor_out)
// which is equivalent to choosing:
//   pow(anchor_out / peak, h) = pow(10, -(reference_range_log10 / 2))
// The implied OFF-side slope ratio is therefore derived from the selected
// reference range rather than from an independent decimal tolerance.
static const float PSYCHO25_REFERENCE_SIMULTANEOUS_RANGE_LOG10 = 3.7f;
static const float PSYCHO25_REFERENCE_CENTERED_RANGE_SIDE_COUNT = 2.f;
// Target-relative neutral Yf endpoint for target-plane hue guidance. Scale 1
// exactly matches the regular physical per-channel endpoint.
static const float PSYCHO25_MIN_GUIDANCE_PEAK_SCALE = 1.f;
static const float PSYCHO25_DEFAULT_GUIDANCE_PEAK_SCALE = 1.f;
static const float PSYCHO25_MIN_AUTO_COMPRESSION = 1.f;
static const float PSYCHO25_MIN_MANUAL_COMPRESSION = 1e-6f;
static const float PSYCHO25_AUTO_COMPRESSION_SENTINEL = 0.f;
static const float PSYCHO25_UPPER_PLANE_SHOULDER_POWER_MATCH_COMPRESSION = 0.f;

// RenoDX v4 grading masks are applied to scalar Yf rather than independently
// to L, M, and S. This keeps the adapted anchor fixed and prevents the
// highlight/shadow controls from rotating adaptive-MB hue.
static const float PSYCHO25_HIGHLIGHT_GRADE_REFERENCE_WHITE = 1.f;
static const float PSYCHO25_SHADOW_GRADE_RANGE_STOPS = 4.f;

// Numerical Graph searches each cone-axis-bounded interval and inverts the
// transformed hue field. Fast60 bypasses these constants and searches.
static const uint PSYCHO25_HUE_PEAK_SCAN_INTERVALS = 6u;
static const uint PSYCHO25_HUE_PEAK_REFINE_ITERATIONS = 12u;
static const uint PSYCHO25_HUE_INVERSE_BRACKET_INTERVALS = 16u;
static const uint PSYCHO25_HUE_INVERSE_ITERATIONS = 18u;
static const float PSYCHO25_HUE_REVERSAL_AXIS_SLOPE_LIMIT = -6.f;
static const float PSYCHO25_HUE_ORDER_DERIVATIVE_PROBE_DIVISOR = 64.f;
static const float PSYCHO25_HUE_ORDER_SAFETY = 0.9f;

static const float PSYCHO25_HUE_AMPLITUDE = 0.5f;
static const int PSYCHO25_HUE_METHOD_GRAPH = 0;
static const int PSYCHO25_HUE_METHOD_FAST_60 = 1;
static const int PSYCHO25_HULL_METHOD_REFERENCE_SCALE = 0;
static const int PSYCHO25_HULL_METHOD_REDUCED_MAX_WHITE = 1;
static const int PSYCHO25_HULL_METHOD_LINEAR_MB_PULLBACK = 2;
static const int PSYCHO25_HULL_METHOD_TARGET_RGB_CLIP = 3;
static const int PSYCHO25_HULL_METHOD_SECTIONAL_WHITE_VOLUME = 4;
static const int PSYCHO25_HULL_METHOD_REFERENCE2 = 5;
static const int PSYCHO25_HULL_METHOD_REFERENCE3 = 6;
static const int PSYCHO25_HULL_METHOD_CANONICAL_CYLINDER = 7;
static const int PSYCHO25_HULL_METHOD_CANONICAL_YF_CONE = 8;
// Canonical-cylinder experimental defaults. The target RGB cube is reduced to
// q = rho / rho_max(theta, Yf); outside pressure is then redirected both
// inward in q and upward toward peak D65 white before converting back through
// the exact target radial support at the raised Yf.
static const float PSYCHO25_CANONICAL_CYLINDER_DEFAULT_PIVOT = 0.45f;
static const float PSYCHO25_CANONICAL_CYLINDER_DEFAULT_CONTRAST = 1.4f;
static const float PSYCHO25_CANONICAL_CYLINDER_DEFAULT_H = 2.f;
static const float PSYCHO25_CANONICAL_CYLINDER_DEFAULT_TRADE = 0.5f;
// Yf-cone variant: exponent controlling how quickly gamut pressure is allowed
// to become whiteward/achromatic motion. k=2 gives 1% whiteward pressure at
// 10% of target peak, 25% at 50%, and 81% at 90%.
static const float PSYCHO25_CANONICAL_YF_CONE_DEFAULT_BIAS_POWER = 2.f;
static const int PSYCHO25_POST_COMPRESSION_NONE = 0;
static const int PSYCHO25_POST_COMPRESSION_DIRECT = 1;
static const int PSYCHO25_POST_COMPRESSION_PER_CHANNEL = 2;
static const int PSYCHO25_POST_COMPRESSION_MAX_CHANNEL = 3;
static const int PSYCHO25_POST_COMPRESSION_ADAPTIVE_MB_HARD_MAX = 4;
static const int PSYCHO25_POST_COMPRESSION_ADAPTIVE_MB_SOFT_MAX = 5;
static const int PSYCHO25_POST_COMPRESSION_FIXED_D65_SOFT_MAX = 6;
static const int PSYCHO25_POST_COMPRESSION_SOURCE_MB_PER_CHANNEL = 7;
static const int PSYCHO25_POST_COMPRESSION_SOURCE_MB_SOFT_MAX = 8;
static const int PSYCHO25_POST_COMPRESSION_SOURCE_BT709_RESIDUAL = 9;
static const int PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT = 10;
static const int PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT_NEUTWO_MAX = 11;
static const int PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT_NRG_WHITE = 12;
static const int PSYCHO25_POST_COMPRESSION_ADAPTIVE_CONTRAST_FIT = 13;
static const int PSYCHO25_UPPER_HULL_PIVOT_BLACK = 0;
static const int PSYCHO25_UPPER_HULL_PIVOT_ADAPTED_OUTPUT = 1;
static const float PSYCHO25_REFERENCE_SOURCE_DIRECTION_OCCUPANCY = 0.8f;
static const float PSYCHO25_REDUCED_MAX_WHITE_SOURCE_DIRECTION_OCCUPANCY = 1.f;
static const float PSYCHO25_SOURCE_HUE_SUPPORT_FRACTION = 0.25f;
static const float PSYCHO25_SOURCE_DIRECTION_BLEND_POWER = 2.f;
static const int PSYCHO25_GAMUT_ENFORCEMENT_NONE = 0;
static const int PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES = 1;
static const int PSYCHO25_GAMUT_ENFORCEMENT_PEAK = 2;
static const int PSYCHO25_GAMUT_ENFORCEMENT_FULL =
    PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES
    | PSYCHO25_GAMUT_ENFORCEMENT_PEAK;
static const int PSYCHO25_GAMUT_ENFORCEMENT_LEGACY = -1;
static const int PSYCHO25_INPUT_PRESTEP_NONE = 0;
static const int PSYCHO25_INPUT_PRESTEP_POSITIVE_LMS = 1;
static const int PSYCHO25_INPUT_PRESTEP_CIE1702 = 2;
static const int PSYCHO25_INPUT_PRESTEP_CIE1702_ABSOLUTE_YF = 3;
static const int PSYCHO25_OBSERVER_GAMUT_NONE = 0;
static const int PSYCHO25_OBSERVER_GAMUT_CIE1702 = 1;

struct Psycho25HueSection {
  float start;
  float end;
  float midpoint;
  float source_unwrapped;
  uint index;
};

struct Psycho25HueGeometry {
  float peak_angle;
  float peak_shift;
  float axis_slope;
  float maximum_ordered_amplitude;
  uint active;
};

struct Psycho25ConeResponseState {
  float3 encoded_response;
  float3 compression_exponent;
  float3 input_response_exponent;
  float3 encoded_peak_offset;
};

struct Psycho25ConeResponseParameters {
  float3 anchor_out;
  float3 compression_exponent;
  float3 input_response_exponent;
  float3 encoded_peak_offset;
  float encoded_response_power;
  float inverse_compression_power;
};

struct Psycho25HueEvaluationContext {
  Psycho25ConeResponseParameters guidance_cone_response;
  float3 current_adaptive_state_lms;
  float3 anchor_in;
  float3 anchor_out;
  float3 guidance_lms_peak;
  float2 adapted_neutral_mb;
  float source_radius;
  float source_target_yf;
  float contrast_power;
  int observer_gamut_mode;
};

struct Psycho25AdaptiveMBTrajectory {
  float3 authored_mb;
  uint hue_applied;
};

float psycho25_Cross2(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

float psycho25_PositiveHueAngle(float angle) {
  angle -= PSYCHO25_TWO_PI * floor(angle / PSYCHO25_TWO_PI);
  return angle < 0.f ? angle + PSYCHO25_TWO_PI : angle;
}

float psycho25_SignedYfFromLMS(float3 lms) {
  float3 weighted_lms =
      renodx::color::macleod_boynton::WeighLMS(lms);
  return weighted_lms.x + weighted_lms.y;
}

float psycho25_YfFromLMS(float3 lms) {
  return max(
      psycho25_SignedYfFromLMS(lms),
      PSYCHO25_EPSILON);
}

// Map a signed LMS input onto its D65-relative CIE 170-2 hue ray while
// retaining the absolute-L/M Yf magnitude already used by Test25 grading.
// This is not radiant energy: Yf is the weighted L+M coordinate and excludes
// S. Signed L+M supplies the source ray when defined; its absolute-LMS ray is
// the fallback when the signed denominator is degenerate.
float3 psycho25_AlignInputToCIE1702Hue(float3 lms_input) {
  float3 lms_weighted =
      renodx::color::macleod_boynton::WeighLMS(lms_input);
  float3 lms_weighted_absolute = abs(lms_weighted);
  float absolute_yf =
      lms_weighted_absolute.x + lms_weighted_absolute.y;
  if (!(absolute_yf > PSYCHO25_EPSILON)) {
    return 0.f.xxx;
  }

  float signed_yf = lms_weighted.x + lms_weighted.y;
  float2 source_ls = abs(signed_yf) > PSYCHO25_EPSILON
      ? float2(lms_weighted.x, lms_weighted.z) / signed_yf
      : float2(lms_weighted_absolute.x, lms_weighted_absolute.z)
          / absolute_yf;
  float2 white_ls = renodx::color::gamut::CIE1702WhiteChromaticity();
  float2 direction = source_ls - white_ls;
  float t_final = 1.f;
  if (dot(direction, direction)
      > renodx::color::gamut::MB_NEAR_WHITE_EPSILON) {
    t_final = min(
        1.f,
        renodx::color::gamut::RayExitTCIE1702PreciseD(direction));
  }

  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          white_ls + t_final * direction,
          absolute_yf));
}

float3 psycho25_ApplyInputPreStep(float3 lms_input, int input_pre_step) {
  if (input_pre_step == PSYCHO25_INPUT_PRESTEP_POSITIVE_LMS) {
    return max(lms_input, 0.f.xxx);
  }
  if (input_pre_step == PSYCHO25_INPUT_PRESTEP_CIE1702) {
    return renodx::color::gamut::GamutCompressLMSPrecise(lms_input);
  }
  if (input_pre_step == PSYCHO25_INPUT_PRESTEP_CIE1702_ABSOLUTE_YF) {
    return psycho25_AlignInputToCIE1702Hue(lms_input);
  }
  return lms_input;
}

float3 psycho25_ApplyObserverGamutCompression(
    float3 contrast_lms,
    int observer_gamut_mode) {
  if (observer_gamut_mode == PSYCHO25_OBSERVER_GAMUT_CIE1702) {
    return renodx::color::gamut::GamutCompressLMSPrecise(contrast_lms);
  }
  return contrast_lms;
}

// Apply the optional fixed-observer constraint to actual LMS immediately
// after independent per-cone contrast. Graph candidates use this same stage,
// so an observer-invalid candidate cannot define the authored hue field.
float3 psycho25_ApplyContrastResponse(
    float3 lms_input,
    float3 anchor_in,
    float3 anchor_out,
    float contrast_power,
    int observer_gamut_mode) {
  float3 contrast_lms = anchor_out
      * renodx::math::SignPow(
          lms_input / anchor_in,
          contrast_power);
  return psycho25_ApplyObserverGamutCompression(
      contrast_lms,
      observer_gamut_mode);
}

float psycho25_GradeQuinticUnitRamp(float t) {
  t = saturate(t);
  return t * t * t * (t * (t * 6.f - 15.f) + 10.f);
}

Psycho25ConeResponseParameters psycho25_PrepareConeResponseParameters(
    float3 anchor_out,
    float3 lms_peak,
    float contrast_power,
    float compression_power,
    float encoded_response_power) {
  Psycho25ConeResponseParameters parameters;
  parameters.anchor_out = max(anchor_out, PSYCHO25_EPSILON.xxx);
  float3 anchor_over_peak = parameters.anchor_out / lms_peak;
  float3 anchor_peak_power = pow(
      anchor_over_peak,
      compression_power);
  float3 compression_slope_norm = 1.f - anchor_peak_power;
  parameters.compression_exponent = compression_power
                                    / compression_slope_norm;
  parameters.encoded_response_power = max(
      encoded_response_power,
      PSYCHO25_EPSILON);
  parameters.input_response_exponent = max(
                                           contrast_power,
                                           PSYCHO25_EPSILON)
                                       * parameters.compression_exponent
                                       * parameters.encoded_response_power;
  // (peak / anchor)^h - 1 == 1 / (anchor / peak)^h - 1.
  parameters.encoded_peak_offset = rcp(anchor_peak_power) - 1.f;
  parameters.inverse_compression_power = rcp(compression_power);
  return parameters;
}

// Scalar RenoDX v4 highlight grade.
// highlights > 1 increases highlights; highlights < 1 reduces them.
// The adapted anchor is an exact fixed point.
float psycho25_HighlightsScalarV4(
    float x,
    float highlights,
    float adapted_anchor_yf) {
  if (highlights == 1.f) return x;

  float t = 0.f;
  if (x > adapted_anchor_yf) {
    float reference_range_log2 = log2(
        PSYCHO25_HIGHLIGHT_GRADE_REFERENCE_WHITE
        / max(adapted_anchor_yf, PSYCHO25_EPSILON));
    t = saturate(
        log2(x / max(adapted_anchor_yf, PSYCHO25_EPSILON))
        / max(reference_range_log2, PSYCHO25_EPSILON));
  }
  t = psycho25_GradeQuinticUnitRamp(t);

  float ratio = max(
      x / max(adapted_anchor_yf, PSYCHO25_EPSILON),
      PSYCHO25_EPSILON);
  if (highlights > 1.f) {
    return lerp(
        x,
        adapted_anchor_yf * pow(ratio, highlights),
        t);
  }

  float b = adapted_anchor_yf * pow(ratio, 2.f - highlights);
  return renodx::math::DivideSafe(x * x, lerp(x, b, t), x);
}

// Scalar RenoDX v4 shadow grade.
// shadows > 1 brightens shadows; shadows < 1 darkens them.
// The adapted anchor is an exact fixed point; the mask reaches full strength
// at the deep-shadow reference.
float psycho25_ShadowsScalarV4(
    float x,
    float shadows,
    float adapted_anchor_yf) {
  if (shadows == 1.f) return x;

  float ratio = max(
      renodx::math::DivideSafe(x, adapted_anchor_yf, 0.f),
      0.f);
  float base_term = x * adapted_anchor_yf;
  float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
  float shadow_floor =
      adapted_anchor_yf * exp2(-PSYCHO25_SHADOW_GRADE_RANGE_STOPS);

  float t = 1.f;
  if (x > shadow_floor) {
    t = saturate(
        log2(x / max(adapted_anchor_yf, PSYCHO25_EPSILON))
        / log2(
            shadow_floor
            / max(adapted_anchor_yf, PSYCHO25_EPSILON)));
  }
  t = psycho25_GradeQuinticUnitRamp(t);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(max(ratio, PSYCHO25_EPSILON), shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return x + (raised - reference) * t;
  }

  float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(max(ratio, PSYCHO25_EPSILON), 2.f - shadows), 0.f));
  float reference = x * (1.f - base_scale);
  return x + (lowered - reference) * t;
}

float psycho25_AutoCompressionFromCenteredReferenceRange(
    float anchor_out_yf,
    float peak_yf) {
  float peak_over_anchor = peak_yf / anchor_out_yf;

  float reference_one_side_range_log10 =
      PSYCHO25_REFERENCE_SIMULTANEOUS_RANGE_LOG10
      / PSYCHO25_REFERENCE_CENTERED_RANGE_SIDE_COUNT;
  float actual_above_adaptation_range_log10 = log10(peak_over_anchor);
  return max(
      reference_one_side_range_log10
          / actual_above_adaptation_range_log10,
      PSYCHO25_MIN_AUTO_COMPRESSION);
}

float psycho25_ResolveGuidancePeakYf(
    float target_peak_yf,
    float guidance_peak_scale) {
  return target_peak_yf
         * max(guidance_peak_scale, PSYCHO25_MIN_GUIDANCE_PEAK_SCALE);
}

float3 psycho25_ToAdaptiveRelativeWeightedLMS(
    float3 lms_input,
    float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho25_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative
         * max(current_adaptive_state_lms, PSYCHO25_EPSILON.xxx);
}

float3 psycho25_LMSFromAdaptiveMB(
    float3 mb,
    float3 current_adaptive_state_lms) {
  float3 relative_weighted =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(mb);
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho25_FromAdaptiveRelativeWeightedLMS(
          relative_weighted,
          current_adaptive_state_lms));
}

float3 psycho25_ApplyAdaptiveMBPurity(
    float3 lms_input,
    float3 adaptive_neutral_lms,
    float purity_delta) {
  if (abs(purity_delta - 1.f) <= 1e-5f) return lms_input;

  float3 relative_weighted =
      psycho25_ToAdaptiveRelativeWeightedLMS(
          lms_input,
          adaptive_neutral_lms);
  float3 mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          relative_weighted);
  float3 mb_neutral =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_delta);
  float3 relative_weighted_out =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          float3(mb_scaled_xy, mb.z));
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho25_FromAdaptiveRelativeWeightedLMS(
          relative_weighted_out,
          adaptive_neutral_lms));
}

float2 psycho25_AdaptiveMBDirection(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    float2 adapted_neutral_mb) {
  float3 relative_weighted =
      psycho25_ToAdaptiveRelativeWeightedLMS(
          lms_input,
          current_adaptive_state_lms);
  float3 mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          relative_weighted);
  float2 offset = mb.xy - adapted_neutral_mb;
  float radius2 = dot(offset, offset);
  if (radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) return 0.f.xx;
  return offset * rsqrt(radius2);
}

float2 psycho25_IsolatedConeDisplacementAxis(
    float3 current_adaptive_state_lms,
    float2 adapted_neutral_mb,
    uint cone_index) {
  float3 displaced_lms = current_adaptive_state_lms;
  if (cone_index == 0u) {
    displaced_lms.x *= 2.f;
  } else if (cone_index == 1u) {
    displaced_lms.y *= 2.f;
  } else {
    displaced_lms.z *= 2.f;
  }
  return psycho25_AdaptiveMBDirection(
      displaced_lms,
      current_adaptive_state_lms,
      adapted_neutral_mb);
}

Psycho25HueSection psycho25_HuePinIntervalForAngle(
    float source_hue_angle,
    float2 axis_l,
    float2 axis_m,
    float2 axis_s) {
  // The raw per-cone field is exactly zero on each isolated-cone axis and its
  // antipode. These rays delimit inversion intervals so every cone-axis pin is
  // retained without a separate dominance-order topology.
  float pin_l = psycho25_PositiveHueAngle(atan2(axis_l.y, axis_l.x));
  float pin_m = psycho25_PositiveHueAngle(atan2(axis_m.y, axis_m.x));
  float pin_s = psycho25_PositiveHueAngle(atan2(axis_s.y, axis_s.x));
  float pin_minus_l = psycho25_PositiveHueAngle(pin_l + PSYCHO25_PI);
  float pin_minus_m = psycho25_PositiveHueAngle(pin_m + PSYCHO25_PI);
  float pin_minus_s = psycho25_PositiveHueAngle(pin_s + PSYCHO25_PI);

  float angle = psycho25_PositiveHueAngle(source_hue_angle);
  Psycho25HueSection interval;
  if (angle >= pin_l || angle < pin_minus_m) {
    interval.start = pin_l;
    interval.end = pin_minus_m + PSYCHO25_TWO_PI;
    interval.source_unwrapped = angle < pin_minus_m
                                    ? angle + PSYCHO25_TWO_PI
                                    : angle;
    interval.index = 0u;
  } else if (angle < pin_s) {
    interval.start = pin_minus_m;
    interval.end = pin_s;
    interval.source_unwrapped = angle;
    interval.index = 1u;
  } else if (angle < pin_minus_l) {
    interval.start = pin_s;
    interval.end = pin_minus_l;
    interval.source_unwrapped = angle;
    interval.index = 2u;
  } else if (angle < pin_m) {
    interval.start = pin_minus_l;
    interval.end = pin_m;
    interval.source_unwrapped = angle;
    interval.index = 3u;
  } else if (angle < pin_minus_s) {
    interval.start = pin_m;
    interval.end = pin_minus_s;
    interval.source_unwrapped = angle;
    interval.index = 4u;
  } else {
    interval.start = pin_minus_s;
    interval.end = pin_l;
    interval.source_unwrapped = angle;
    interval.index = 5u;
  }
  interval.midpoint = 0.5f * (interval.start + interval.end);
  return interval;
}

Psycho25HueEvaluationContext psycho25_PrepareHueEvaluationContext(
    Psycho25ConeResponseParameters guidance_cone_response,
    float3 current_adaptive_state_lms,
    float3 anchor_in,
    float3 anchor_out,
    float3 guidance_lms_peak,
    float2 adapted_neutral_mb,
    float source_radius,
    float source_target_yf,
    float contrast_power,
    int observer_gamut_mode = PSYCHO25_OBSERVER_GAMUT_NONE) {
  Psycho25HueEvaluationContext context;
  context.guidance_cone_response = guidance_cone_response;
  context.current_adaptive_state_lms = current_adaptive_state_lms;
  context.anchor_in = anchor_in;
  context.anchor_out = anchor_out;
  context.guidance_lms_peak = guidance_lms_peak;
  context.adapted_neutral_mb = adapted_neutral_mb;
  context.source_radius = source_radius;
  context.source_target_yf = source_target_yf;
  context.contrast_power = contrast_power;
  context.observer_gamut_mode = observer_gamut_mode;
  return context;
}

float3x3 psycho25_WeightedLMSToRGBMatrix(
    int gamut_mode) {
  return gamut_mode == 0
             ? renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT709_MAT
             : renodx::color::macleod_boynton::LMS_WEIGHTED_TO_BT2020_MAT;
}

float3 psycho25_TargetRGBFromLMS(
    float3 lms,
    int gamut_mode) {
  return mul(
      psycho25_WeightedLMSToRGBMatrix(gamut_mode),
      renodx::color::macleod_boynton::WeighLMS(lms));
}

    float3 psycho25_LMSFromTargetRGB(
        float3 target_rgb,
        int gamut_mode) {
      return gamut_mode == 0
         ? renodx::color::lms::from::BT709(target_rgb)
         : renodx::color::lms::from::BT2020(target_rgb);
    }

float psycho25_TargetLowerPlaneBoundaryFraction(
    float3 candidate_target_rgb,
    float3 neutral_target_rgb) {
  float boundary_fraction = PSYCHO25_LARGE;
  if (candidate_target_rgb.x < neutral_target_rgb.x) {
    boundary_fraction = min(
        boundary_fraction,
        neutral_target_rgb.x
            / (neutral_target_rgb.x - candidate_target_rgb.x));
  }
  if (candidate_target_rgb.y < neutral_target_rgb.y) {
    boundary_fraction = min(
        boundary_fraction,
        neutral_target_rgb.y
            / (neutral_target_rgb.y - candidate_target_rgb.y));
  }
  if (candidate_target_rgb.z < neutral_target_rgb.z) {
    boundary_fraction = min(
        boundary_fraction,
        neutral_target_rgb.z
            / (neutral_target_rgb.z - candidate_target_rgb.z));
  }
  return boundary_fraction;
}

  float3 psycho25_PullBackAdaptiveMBToTargetLowerPlanes(
    float3 candidate_mb,
    float2 adapted_neutral_mb,
    float3 current_adaptive_state_lms,
    int target_gamut_mode) {
    float3 neutral_lms = psycho25_LMSFromAdaptiveMB(
      float3(adapted_neutral_mb, candidate_mb.z),
      current_adaptive_state_lms);
    float3 candidate_lms = psycho25_LMSFromAdaptiveMB(
      candidate_mb,
      current_adaptive_state_lms);
    float boundary_fraction = psycho25_TargetLowerPlaneBoundaryFraction(
      psycho25_TargetRGBFromLMS(candidate_lms, target_gamut_mode),
      psycho25_TargetRGBFromLMS(neutral_lms, target_gamut_mode));
    candidate_mb.xy = lerp(
      adapted_neutral_mb,
      candidate_mb.xy,
      saturate(boundary_fraction));
    return candidate_mb;
  }

float psycho25_CompressTargetLowerPlaneRadius(
    float boundary_fraction) {
  float knee = PSYCHO25_LOWER_PLANE_COMPRESSION_KNEE
               * boundary_fraction;
  float headroom = boundary_fraction - knee;
  float excess = max(1.f - knee, 0.f);
  return 1.f - excess
         + renodx::math::DivideSafe(
             headroom * excess,
             headroom + excess,
             0.f);
}

float psycho25_SmoothPositive(float value) {
  float smooth_length = sqrt(
      value * value
      + PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON
        * PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON);
  float normalized_value = value / smooth_length;
  return 0.5f
         * value
         * normalized_value
         * (1.f + normalized_value);
}

float psycho25_IntersectTargetPlaneSupports(float a, float b) {
  float normalization = max(a, b);
  float normalized_a = a / normalization;
  float normalized_b = b / normalization;
  float denominator = normalization * pow(pow(normalized_a, PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER) + pow(normalized_b, PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER), rcp(PSYCHO25_HULL_SUPPORT_INTERSECTION_POWER));
  return a * b / denominator;
}

float psycho25_IntersectTargetPlaneSupports(float3 support) {
  return psycho25_IntersectTargetPlaneSupports(
      support.x,
      psycho25_IntersectTargetPlaneSupports(
          support.y,
          support.z));
}

float3 psycho25_LiftTargetRGBTowardWhite(
    float3 candidate_lms,
    float white_level,
    int target_gamut_mode) {
  float3 candidate_target_rgb = psycho25_TargetRGBFromLMS(
    candidate_lms,
    target_gamut_mode);
  float3 white_target_rgb = white_level.xxx;

  // For q = lerp(candidate, white, t), each negative channel requires
  // t >= -candidate / (white - candidate). SmoothPositiveMajorant is strictly
  // no smaller than max(required, 0), and the bounded transform retains that
  // conservative property. The union is smooth across active target planes
  // and remains at least as large as every channel's required lift.
  float3 required_lift = -candidate_target_rgb / max(
    white_target_rgb - candidate_target_rgb,
    PSYCHO25_EPSILON.xxx);
  float3 smooth_positive_majorant = 0.5f * (
    required_lift
    + sqrt(
      required_lift * required_lift
      + PSYCHO25_WHITE_LIFT_PRESSURE_EPSILON
      * PSYCHO25_WHITE_LIFT_PRESSURE_EPSILON));
  float3 channel_lift = smooth_positive_majorant / (
    1.f + smooth_positive_majorant - required_lift);
  float minimum_white_lift = 1.f
    - (1.f - channel_lift.x)
    * (1.f - channel_lift.y)
    * (1.f - channel_lift.z);

  // The minimum lift lands an outside point on its limiting lower plane.
  // For fixed-ray occupancy s and t = 1 - 1/s, multiplying the remaining
  // displacement by 1 - t^2 maps the result to occupancy 1 - t^2 inside that
  // plane. It leaves the boundary with zero first-order inward motion, then
  // converges to white as pressure grows instead of flattening the outside
  // trajectory onto a target wall. The scalar residual keeps the selected-
  // target D65-relative direction intact; the Reference2 wrapper below
  // restores the exact Graph-authored adaptive-MB hue after the move.
  float white_residual = (1.f - minimum_white_lift)
      * (1.f - minimum_white_lift * minimum_white_lift);
  float3 output_target_rgb = white_target_rgb
    + white_residual * (candidate_target_rgb - white_target_rgb);
  return psycho25_LMSFromTargetRGB(
    output_target_rgb,
    target_gamut_mode);
}

float3 psycho25_LiftTargetRGBTowardWhitePreservingAdaptiveMBHue(
    float3 candidate_lms,
    float3 current_adaptive_state_lms,
    float white_level,
    int target_gamut_mode) {
  float3 lifted_lms = psycho25_LiftTargetRGBTowardWhite(
      candidate_lms,
      white_level,
      target_gamut_mode);
  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float3 lifted_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              lifted_lms,
              current_adaptive_state_lms));
  float2 candidate_direction = psycho25_AdaptiveMBDirection(
      candidate_lms,
      current_adaptive_state_lms,
      adapted_neutral_mb);
  float2 output_mb_xy = adapted_neutral_mb
      + candidate_direction
        * length(lifted_mb.xy - adapted_neutral_mb);
  float output_yf = psycho25_YfFromLMS(lifted_lms);
  float output_mb_scale = renodx::math::DivideSafe(
      output_yf,
      output_mb_xy.x * current_adaptive_state_lms.x
      + (1.f - output_mb_xy.x) * current_adaptive_state_lms.y,
      0.f);
  return psycho25_LMSFromAdaptiveMB(
      float3(output_mb_xy, output_mb_scale),
      current_adaptive_state_lms);
}

float3 psycho25_CompressTargetHueTriangleVolume(
  float3 preferred_lms,
  float peak_value,
  int target_gamut_mode) {
  float safe_peak = max(peak_value, PSYCHO25_EPSILON);
  float3 preferred_target_rgb = psycho25_TargetRGBFromLMS(
    preferred_lms,
    target_gamut_mode);
  float minimum_channel = min(
    preferred_target_rgb.x,
    min(preferred_target_rgb.y, preferred_target_rgb.z));
  float maximum_channel = max(
    preferred_target_rgb.x,
    max(preferred_target_rgb.y, preferred_target_rgb.z));
  float channel_range = maximum_channel - minimum_channel;

  // For target RGB x, C = peak * (x - min(x)) / (max(x) - min(x))
  // is the exact hue-rim point with min(C)=0 and max(C)=peak. The raw
  // barycentric weights reproduce every in-cube point exactly:
  //   x = black_weight * 0 + hue_weight * C + white_weight * peak.xxx.
  float3 hue_rim_target_rgb = safe_peak
    * (preferred_target_rgb - minimum_channel.xxx)
    / max(channel_range, PSYCHO25_EPSILON);
  float3 raw_weights = float3(
    1.f - maximum_channel / safe_peak,
    channel_range / safe_peak,
    minimum_channel / safe_peak);

  // Smoothly project invalid barycentric coordinates into the target
  // triangle. This is effectively identity for positive in-volume weights
  // and evaluates every simplex face together without authored section tests.
  float3 positive_weights = float3(
    psycho25_SmoothPositive(raw_weights.x),
    psycho25_SmoothPositive(raw_weights.y),
    psycho25_SmoothPositive(raw_weights.z));
  float3 contained_weights = positive_weights
    / max(
      positive_weights.x + positive_weights.y + positive_weights.z,
      PSYCHO25_EPSILON);

  // Negative black weight means an upper-plane violation; negative white
  // weight means a lower-plane violation. The squared pressure has zero slope
  // at first contact, then approaches one under extreme pressure. Moving the
  // contained point toward the triangle's white vertex makes white—not a dark
  // target wall—the terminal fallback for either class of violation.
  float upper_pressure = psycho25_SmoothPositive(-raw_weights.x);
  float lower_pressure = psycho25_SmoothPositive(-raw_weights.z);
  float upper_white_weight = upper_pressure * upper_pressure
    / (1.f + upper_pressure * upper_pressure);
  float lower_white_weight = lower_pressure * lower_pressure
    / (1.f + lower_pressure * lower_pressure);
  float pressure_white_weight = 1.f
    - (1.f - upper_white_weight) * (1.f - lower_white_weight);
  contained_weights = lerp(
    contained_weights,
    float3(0.f, 0.f, 1.f),
    pressure_white_weight);

  float3 output_target_rgb = contained_weights.y * hue_rim_target_rgb
    + contained_weights.z * safe_peak.xxx;
  return psycho25_LMSFromTargetRGB(
    output_target_rgb,
    target_gamut_mode);
}

float psycho25_TargetLowerPlaneRadiusForDirection(
    float2 direction,
    float2 adapted_neutral_mb,
    float3 current_adaptive_state_lms,
    int target_gamut_mode) {
  float3 neutral_lms = psycho25_LMSFromAdaptiveMB(
      float3(adapted_neutral_mb, 1.f),
      current_adaptive_state_lms);
  float3 unit_radius_lms = psycho25_LMSFromAdaptiveMB(
      float3(adapted_neutral_mb + direction, 1.f),
      current_adaptive_state_lms);
  float3 neutral_target_rgb = psycho25_TargetRGBFromLMS(
      neutral_lms,
      target_gamut_mode);
  float3 direction_target_rgb = psycho25_TargetRGBFromLMS(
      unit_radius_lms - neutral_lms,
      target_gamut_mode);
  float3 lower_support = neutral_target_rgb / (float3(psycho25_SmoothPositive(-direction_target_rgb.x), psycho25_SmoothPositive(-direction_target_rgb.y), psycho25_SmoothPositive(-direction_target_rgb.z)) + PSYCHO25_HULL_SMOOTH_SUPPORT_EPSILON);
  return psycho25_IntersectTargetPlaneSupports(lower_support);
}

  float3 psycho25_CompressSectionalWhiteVolume(
    float3 preferred_lms,
    float3 current_adaptive_state_lms,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement) {
    const bool enforce_gamut_primaries =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
    const bool enforce_gamut_peak =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;
    if (!enforce_gamut_primaries && !enforce_gamut_peak) {
    return preferred_lms;
    }

    // Hold the preferred physical result's Yf fixed and measure its selected-
    // target RGB displacement from the D65 axis at that same Yf. Scaling this
    // displacement therefore changes only the target-RGB color direction and
    // magnitude, not the already-authored achromatic response.
    float preferred_yf = psycho25_YfFromLMS(preferred_lms);
    float3 neutral_lms = current_adaptive_state_lms
      * renodx::math::DivideSafe(
        preferred_yf,
        psycho25_YfFromLMS(current_adaptive_state_lms),
        0.f);
    float3 neutral_target_rgb = psycho25_TargetRGBFromLMS(
      neutral_lms,
      target_gamut_mode);
    float3 preferred_target_rgb = psycho25_TargetRGBFromLMS(
      preferred_lms,
      target_gamut_mode);
    float3 target_displacement = preferred_target_rgb - neutral_target_rgb;

    // Each normalized occupancy is zero when its plane is not approached and
    // one where the uncompressed displacement reaches that plane. Their L8 norm
    // is a smooth conservative union of all enabled cube faces: it is never
    // smaller than any individual occupancy, including at face/edge ties.
    float3 lower_occupancy = 0.f.xxx;
    float3 upper_occupancy = 0.f.xxx;
    if (enforce_gamut_primaries) {
    lower_occupancy = max(-target_displacement, 0.f.xxx)
      / max(neutral_target_rgb, PSYCHO25_EPSILON.xxx);
    }
    if (enforce_gamut_peak) {
    upper_occupancy = max(target_displacement, 0.f.xxx)
      / max(
        peak_value.xxx - neutral_target_rgb,
        PSYCHO25_EPSILON.xxx);
    }
    float3 lower_occupancy_power = pow(
      lower_occupancy,
      PSYCHO25_SECTIONAL_VOLUME_POWER.xxx);
    float3 upper_occupancy_power = pow(
      upper_occupancy,
      PSYCHO25_SECTIONAL_VOLUME_POWER.xxx);
    float occupancy_power_sum =
      lower_occupancy_power.x
      + lower_occupancy_power.y
      + lower_occupancy_power.z
      + upper_occupancy_power.x
      + upper_occupancy_power.y
      + upper_occupancy_power.z;

    // One global saturation response replaces a black-to-wall/white handoff.
    // It is nearly identity inside the cube, maps a single-face occupancy of one
    // to pow(2, -1/8), and asymptotically approaches every active boundary from
    // inside without a final component clamp.
    float displacement_scale = pow(
      1.f + occupancy_power_sum,
      -rcp(PSYCHO25_SECTIONAL_VOLUME_POWER));
    return psycho25_LMSFromTargetRGB(
      neutral_target_rgb + target_displacement * displacement_scale,
      target_gamut_mode);
  }

float3 psycho25_LMSFromHueDirectionAndYf(
    float2 direction,
    float source_radius,
    float source_target_yf,
    float3 current_adaptive_state_lms,
    float2 adapted_neutral_mb) {
  float3 candidate = psycho25_LMSFromAdaptiveMB(
      float3(adapted_neutral_mb + direction * source_radius, 1.f),
      current_adaptive_state_lms);
  float candidate_yf = psycho25_YfFromLMS(candidate);
  return candidate * renodx::math::DivideSafe(source_target_yf, candidate_yf, 1.f);
}


// Exact selected-target radial support at one adaptive-MB hue and physical Yf.
// Test25's adaptation-relative MB reconstruction makes target RGB a linear-
// fractional function of radius rather than a simple affine ray. Each enabled
// RGB cube face still has one closed-form scalar intersection, so no per-pixel
// search or LUT is required.
float psycho25_TargetRadialSupportAtYf(
    float2 direction,
    float target_yf,
    float3 current_adaptive_state_lms,
    float2 adapted_neutral_mb,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement) {
  const bool enforce_gamut_primaries =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
  const bool enforce_gamut_peak =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;
  if (!enforce_gamut_primaries && !enforce_gamut_peak) {
    return PSYCHO25_LARGE;
  }

  // Along an adaptive-MB radial line
  //   l(r) = l0 + r*dl, s(r) = s0 + r*ds,
  // the adaptation-relative weighted-LMS numerator is affine in r. Restoring
  // absolute LMS and then fixing physical Yf divides by the affine L+M term,
  // so each target RGB channel is a linear-fractional function:
  //
  //   RGB_i(r) = target_yf * (N0_i + r*N1_i) / (D0 + r*D1).
  //
  // Intersecting RGB_i(r) with a lower plane 0 or upper plane peak therefore
  // has one closed-form positive root. This is exact for Test25's adaptive-MB
  // construction and avoids a per-pixel binary search.
  float3 relative_weighted_zero = float3(
      adapted_neutral_mb.x,
      1.f - adapted_neutral_mb.x,
      adapted_neutral_mb.y);
  float3 relative_weighted_delta = float3(
      direction.x,
      -direction.x,
      direction.y);
  float3 physical_weighted_zero =
      relative_weighted_zero * current_adaptive_state_lms;
  float3 physical_weighted_delta =
      relative_weighted_delta * current_adaptive_state_lms;
  float denominator_zero =
      physical_weighted_zero.x + physical_weighted_zero.y;
  float denominator_delta =
      physical_weighted_delta.x + physical_weighted_delta.y;

  float3x3 weighted_lms_to_target_rgb =
      psycho25_WeightedLMSToRGBMatrix(target_gamut_mode);
  float3 numerator_zero = mul(
      weighted_lms_to_target_rgb,
      physical_weighted_zero);
  float3 numerator_delta = mul(
      weighted_lms_to_target_rgb,
      physical_weighted_delta);

  float support = PSYCHO25_LARGE;

  if (enforce_gamut_primaries) {
    // target_yf*(N0 + r*N1) = 0
    float3 lower_denominator = target_yf * numerator_delta;
    float3 lower_numerator = -target_yf * numerator_zero;

    if (abs(lower_denominator.x) > PSYCHO25_EPSILON) {
      float radius = lower_numerator.x / lower_denominator.x;
      if (radius > 0.f
          && denominator_zero + radius * denominator_delta
              > PSYCHO25_EPSILON) {
        support = min(support, radius);
      }
    }
    if (abs(lower_denominator.y) > PSYCHO25_EPSILON) {
      float radius = lower_numerator.y / lower_denominator.y;
      if (radius > 0.f
          && denominator_zero + radius * denominator_delta
              > PSYCHO25_EPSILON) {
        support = min(support, radius);
      }
    }
    if (abs(lower_denominator.z) > PSYCHO25_EPSILON) {
      float radius = lower_numerator.z / lower_denominator.z;
      if (radius > 0.f
          && denominator_zero + radius * denominator_delta
              > PSYCHO25_EPSILON) {
        support = min(support, radius);
      }
    }
  }

  if (enforce_gamut_peak) {
    // target_yf*(N0 + r*N1) = peak*(D0 + r*D1)
    float3 upper_denominator =
        target_yf * numerator_delta - peak_value * denominator_delta;
    float3 upper_numerator =
        peak_value * denominator_zero - target_yf * numerator_zero;

    if (abs(upper_denominator.x) > PSYCHO25_EPSILON) {
      float radius = upper_numerator.x / upper_denominator.x;
      if (radius > 0.f
          && denominator_zero + radius * denominator_delta
              > PSYCHO25_EPSILON) {
        support = min(support, radius);
      }
    }
    if (abs(upper_denominator.y) > PSYCHO25_EPSILON) {
      float radius = upper_numerator.y / upper_denominator.y;
      if (radius > 0.f
          && denominator_zero + radius * denominator_delta
              > PSYCHO25_EPSILON) {
        support = min(support, radius);
      }
    }
    if (abs(upper_denominator.z) > PSYCHO25_EPSILON) {
      float radius = upper_numerator.z / upper_denominator.z;
      if (radius > 0.f
          && denominator_zero + radius * denominator_delta
              > PSYCHO25_EPSILON) {
        support = min(support, radius);
      }
    }
  }

  return max(support, 0.f);
}

// Bounded generalized-Neutwo pressure response used only after the canonical
// target occupancy exceeds one. `pivot` is measured in excess occupancy
// q - 1, `contrast` controls pressure gain, and `h` controls the shoulder.
float psycho25_CanonicalCylinderPressure(
    float occupancy,
    float pivot,
    float contrast,
    float h) {
  float excess = max(occupancy - 1.f, 0.f);
  if (excess <= PSYCHO25_EPSILON) return 0.f;

  float safe_pivot = max(pivot, PSYCHO25_EPSILON);
  float safe_contrast = max(contrast, PSYCHO25_EPSILON);
  float safe_h = max(h, PSYCHO25_EPSILON);
  float normalized_excess = excess / safe_pivot;

  // Equivalent generalized-Neutwo forms chosen by magnitude avoid inf/inf
  // when stress inputs produce extremely large target occupancy.
  if (normalized_excess >= 1.f) {
    float inverse_power = pow(
        normalized_excess,
        -safe_contrast * safe_h);
    return pow(1.f + inverse_power, -rcp(safe_h));
  }
  float z = pow(normalized_excess, safe_contrast);
  return z / pow(1.f + pow(z, safe_h), rcp(safe_h));
}

// Canonical-cylinder device-volume experiment.
//
// 1) Convert the authored midpoint/Graph point to (theta, rho, Yf).
// 2) Normalize radius by the exact selected-target support:
//      q = rho / rho_max(theta, Yf).
// 3) Keep every q <= 1 point exactly unchanged.
// 4) For q > 1, map excess pressure to w in [0,1), then move both inward in
//    canonical q and upward toward peak D65 white.
// 5) Re-evaluate rho_max at the raised Yf and reconstruct the same adaptive-MB
//    hue direction with rho_out = q_out * rho_max(theta, Yf_out).
//
// `trade` selects the balance: 0 = inward-first, 1 = upward/white-first.
float3 psycho25_CompressCanonicalCylinderVolume(
    float3 preferred_lms,
    float3 current_adaptive_state_lms,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement,
    float pressure_pivot,
    float pressure_contrast,
    float pressure_h,
    float pressure_trade) {
  const bool enforce_gamut_primaries =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
  const bool enforce_gamut_peak =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;
  // This experiment is defined on the complete target RGB cube. Keep the
  // independent lower-only / upper-only diagnostics on their existing paths
  // rather than implicitly turning either one into full six-plane enforcement.
  if (!enforce_gamut_primaries || !enforce_gamut_peak) {
    return preferred_lms;
  }

  float preferred_yf = psycho25_YfFromLMS(preferred_lms);
  float target_peak_yf = psycho25_YfFromLMS(
      psycho25_LMSFromTargetRGB(peak_value.xxx, target_gamut_mode));
  if (!(preferred_yf > PSYCHO25_EPSILON)
      || !(target_peak_yf > PSYCHO25_EPSILON)) {
    return 0.f.xxx;
  }

  // At or above the target's D65 peak cross-section the only full-cube point
  // is peak white. This also avoids dividing by a vanishing radial support.
  if (preferred_yf >= target_peak_yf * (1.f - PSYCHO25_EPSILON)) {
    return psycho25_LMSFromTargetRGB(peak_value.xxx, target_gamut_mode);
  }

  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float3 preferred_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              preferred_lms,
              current_adaptive_state_lms));
  float2 preferred_offset = preferred_mb.xy - adapted_neutral_mb;
  float preferred_radius2 = dot(preferred_offset, preferred_offset);
  if (preferred_radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) {
    // A neutral point only needs peak containment, already handled above.
    return preferred_lms;
  }

  float preferred_radius = sqrt(preferred_radius2);
  float2 direction = preferred_offset / preferred_radius;
  float radial_support = psycho25_TargetRadialSupportAtYf(
      direction,
      preferred_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);
  if (radial_support >= PSYCHO25_LARGE * 0.5f) {
    return preferred_lms;
  }
  if (radial_support <= PSYCHO25_EPSILON) {
    return psycho25_LMSFromTargetRGB(peak_value.xxx, target_gamut_mode);
  }

  float occupancy = preferred_radius / radial_support;
  if (occupancy <= 1.f) {
    return preferred_lms;
  }

  float pressure = psycho25_CanonicalCylinderPressure(
      occupancy,
      pressure_pivot,
      pressure_contrast,
      pressure_h);
  float residual = max(1.f - pressure, 0.f);
  float trade = saturate(pressure_trade);

  // Exact viewer mapping:
  //   trade=0: q contracts rapidly while Yf rises slowly.
  //   trade=1: Yf rises rapidly while q contracts slowly.
  float inward_power = exp2(2.f - 4.f * trade);
  float upward_power = exp2(-2.f + 4.f * trade);
  float output_occupancy = pow(residual, inward_power);
  float preferred_y = saturate(preferred_yf / target_peak_yf);
  float output_y = 1.f
      - (1.f - preferred_y) * pow(residual, upward_power);
  if (output_y >= 1.f - PSYCHO25_EPSILON) {
    return psycho25_LMSFromTargetRGB(peak_value.xxx, target_gamut_mode);
  }
  float output_yf = output_y * target_peak_yf;

  float output_support = psycho25_TargetRadialSupportAtYf(
      direction,
      output_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);
  float output_radius = output_occupancy * max(output_support, 0.f);
  return psycho25_LMSFromHueDirectionAndYf(
      direction,
      output_radius,
      output_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb);
}


// Canonical Yf-cone device-volume experiment.
//
// This variant keeps the same exact star-volume occupancy as Canonical
// Cylinder, but Yf controls *where gamut pressure is spent*:
//   - all pressure participates in radial containment;
//   - only pressure weighted by pow(Yf / peakYf, bias_power) can raise Yf.
//
// Consequently, dark saturated colors are pulled inward toward the target
// radial support without being spuriously lifted toward peak white. As Yf
// approaches target peak, the same out-of-volume pressure progressively turns
// into whiteward motion and every positive hue can still converge on peak D65.
float3 psycho25_CompressCanonicalYfConeVolume(
    float3 preferred_lms,
    float3 current_adaptive_state_lms,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement,
    float pressure_pivot,
    float pressure_contrast,
    float pressure_h,
    float yf_bias_power) {
  const bool enforce_gamut_primaries =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
  const bool enforce_gamut_peak =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;
  if (!enforce_gamut_primaries || !enforce_gamut_peak) {
    return preferred_lms;
  }

  float preferred_yf = psycho25_YfFromLMS(preferred_lms);
  float target_peak_yf = psycho25_YfFromLMS(
      psycho25_LMSFromTargetRGB(peak_value.xxx, target_gamut_mode));
  if (!(preferred_yf > PSYCHO25_EPSILON)
      || !(target_peak_yf > PSYCHO25_EPSILON)) {
    return 0.f.xxx;
  }
  if (preferred_yf >= target_peak_yf * (1.f - PSYCHO25_EPSILON)) {
    return psycho25_LMSFromTargetRGB(peak_value.xxx, target_gamut_mode);
  }

  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float3 preferred_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              preferred_lms,
              current_adaptive_state_lms));
  float2 preferred_offset = preferred_mb.xy - adapted_neutral_mb;
  float preferred_radius2 = dot(preferred_offset, preferred_offset);
  if (preferred_radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) {
    return preferred_lms;
  }

  float preferred_radius = sqrt(preferred_radius2);
  float2 direction = preferred_offset / preferred_radius;
  float radial_support = psycho25_TargetRadialSupportAtYf(
      direction,
      preferred_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);
  if (radial_support >= PSYCHO25_LARGE * 0.5f) {
    return preferred_lms;
  }
  if (radial_support <= PSYCHO25_EPSILON) {
    return 0.f.xxx;
  }

  float occupancy = preferred_radius / radial_support;
  if (occupancy <= 1.f) {
    return preferred_lms;
  }

  float pressure = psycho25_CanonicalCylinderPressure(
      occupancy,
      pressure_pivot,
      pressure_contrast,
      pressure_h);

  float preferred_y = saturate(preferred_yf / target_peak_yf);
  float safe_yf_bias_power = max(yf_bias_power, PSYCHO25_EPSILON);
  float white_bias = pow(preferred_y, safe_yf_bias_power);

  // Full gamut pressure contracts canonical radius. Dark colors therefore
  // spend essentially all of their correction budget radially.
  float radial_residual = max(1.f - pressure, 0.f);
  float output_occupancy = radial_residual;

  // Only the Yf-weighted part of pressure may move the point upward. This is
  // the conical bias: whiteward motion vanishes toward black and increases
  // continuously toward peak.
  float white_pressure = pressure * white_bias;
  float output_y = preferred_y
      + (1.f - preferred_y) * white_pressure;
  if (output_y >= 1.f - PSYCHO25_EPSILON) {
    return psycho25_LMSFromTargetRGB(peak_value.xxx, target_gamut_mode);
  }
  float output_yf = output_y * target_peak_yf;

  // The target cross-section changes after Yf motion, so convert the canonical
  // occupancy back through the exact radial support at the new Yf.
  float output_support = psycho25_TargetRadialSupportAtYf(
      direction,
      output_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);
  float output_radius = output_occupancy * max(output_support, 0.f);
  return psycho25_LMSFromHueDirectionAndYf(
      direction,
      output_radius,
      output_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb);
}

Psycho25ConeResponseState psycho25_BuildConeResponseState(
    float3 contrast_lms,
    Psycho25ConeResponseParameters parameters) {
  float3 contrast_ratio = contrast_lms / parameters.anchor_out;

  Psycho25ConeResponseState state;
  state.compression_exponent = parameters.compression_exponent;
  state.input_response_exponent = parameters.input_response_exponent;
  state.encoded_peak_offset = parameters.encoded_peak_offset;
    state.encoded_response = renodx::math::SignPow(
      contrast_ratio,
      parameters.compression_exponent
          * parameters.encoded_response_power);
  return state;
}

Psycho25ConeResponseState psycho25_BuildConeResponseState(
    float3 contrast_lms,
    float3 anchor_out,
    float3 lms_peak,
    float contrast_power,
    float compression_power,
    float encoded_response_power) {
  return psycho25_BuildConeResponseState(
      contrast_lms,
      psycho25_PrepareConeResponseParameters(
          anchor_out,
          lms_peak,
          contrast_power,
          compression_power,
          encoded_response_power));
}

float3 psycho25_CompressionRolloffSignedPerCone(
    float3 signed_contrast_lms,
    Psycho25ConeResponseParameters parameters) {
  Psycho25ConeResponseState response_state =
      psycho25_BuildConeResponseState(
          signed_contrast_lms,
          parameters);
    return renodx::math::SignPow(
      response_state.encoded_response
          / (abs(response_state.encoded_response)
              + response_state.encoded_peak_offset),
      parameters.inverse_compression_power);
}

float3 psycho25_CompressionRolloffPerCone(
    float3 contrast_lms,
    float3 anchor_out,
    float3 lms_peak,
    float contrast_power,
    float compression_power,
    float encoded_response_power) {
  return psycho25_CompressionRolloffSignedPerCone(
      contrast_lms,
      psycho25_PrepareConeResponseParameters(
          anchor_out,
          lms_peak,
          contrast_power,
          compression_power,
          encoded_response_power));
}

float psycho25_CompressionRolloffScalar(
    float input_value,
    float anchor_out,
    float peak_value,
    float compression_power) {
  if (input_value <= 0.f) return 0.f;
  float anchor_over_peak = anchor_out / peak_value;
  float anchor_peak_power = pow(
      anchor_over_peak,
      compression_power);
  float compression_slope_norm = 1.f - anchor_peak_power;
  float encoded_peak_offset = rcp(anchor_peak_power) - 1.f;
  float input_response_power = compression_power
                 / compression_slope_norm;
  float log_offset_over_input = log(max(encoded_peak_offset, 1e-30f))
                - input_response_power
                    * log(input_value / anchor_out);
  float normalized_response = rcp(
    1.f + exp(clamp(log_offset_over_input, -80.f, 80.f)));
  return peak_value * pow(
    normalized_response,
      rcp(compression_power));
}

float3 psycho25_ApplyPostTargetCompression(
    float3 target_rgb,
    float3 anchor_target_rgb,
    float peak_value,
    float compression_power,
    int gamut_enforcement,
  int post_compression_mode) {
  const bool enforce_gamut_primaries =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
  const bool enforce_gamut_peak =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;
  if (enforce_gamut_primaries) {
    target_rgb = max(target_rgb, 0.f.xxx);
  }
  if (!enforce_gamut_peak) return target_rgb;

  if (post_compression_mode == PSYCHO25_POST_COMPRESSION_PER_CHANNEL
      || post_compression_mode
          == PSYCHO25_POST_COMPRESSION_SOURCE_MB_PER_CHANNEL) {
    float3 positive_rgb = max(target_rgb, 0.f.xxx);
    float3 safe_anchor = clamp(
        anchor_target_rgb,
        PSYCHO25_EPSILON.xxx,
        (peak_value - PSYCHO25_EPSILON).xxx);
    float3 compressed_rgb = float3(
        psycho25_CompressionRolloffScalar(
            positive_rgb.x,
            safe_anchor.x,
            peak_value,
            compression_power),
        psycho25_CompressionRolloffScalar(
            positive_rgb.y,
            safe_anchor.y,
            peak_value,
            compression_power),
        psycho25_CompressionRolloffScalar(
            positive_rgb.z,
            safe_anchor.z,
            peak_value,
            compression_power));
    return min(target_rgb, 0.f.xxx) + compressed_rgb;
  }

  float max_target_channel = max(
      abs(target_rgb.x),
      max(abs(target_rgb.y), abs(target_rgb.z)));
  if (max_target_channel <= PSYCHO25_EPSILON) return target_rgb;
  float anchor_max_channel = max(
      abs(anchor_target_rgb.x),
      max(abs(anchor_target_rgb.y), abs(anchor_target_rgb.z)));
  float compressed_max_channel = psycho25_CompressionRolloffScalar(
      max_target_channel,
      clamp(
          anchor_max_channel,
          PSYCHO25_EPSILON,
          peak_value - PSYCHO25_EPSILON),
      peak_value,
      compression_power);
  return target_rgb * (compressed_max_channel / max_target_channel);
}

float3 psycho25_RestoreSourceAdaptiveMBDirection(
    float3 candidate_lms,
    float3 source_lms,
    float3 current_adaptive_state_lms) {
  float3 candidate_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              candidate_lms,
              current_adaptive_state_lms));
  float3 source_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              source_lms,
              current_adaptive_state_lms));
  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float2 candidate_offset = candidate_mb.xy - adapted_neutral_mb;
  float2 source_offset = source_mb.xy - adapted_neutral_mb;
  float candidate_radius2 = dot(candidate_offset, candidate_offset);
  float source_radius2 = dot(source_offset, source_offset);
  if (candidate_radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON
      || source_radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) {
    return candidate_lms;
  }

  candidate_mb.xy = adapted_neutral_mb
      + source_offset * rsqrt(source_radius2) * sqrt(candidate_radius2);
  return psycho25_LMSFromAdaptiveMB(
      candidate_mb,
      current_adaptive_state_lms);
}

  float3 psycho25_RestoreSourceBT709ResidualDirection(
    float3 candidate_lms,
    float3 source_lms,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement) {
    float3 candidate_bt709 = renodx::color::bt709::from::LMS(candidate_lms);
    float3 source_bt709 = renodx::color::bt709::from::LMS(source_lms);
    float candidate_y = renodx::color::y::from::BT709(candidate_bt709);
    float source_y = renodx::color::y::from::BT709(source_bt709);
    float3 candidate_residual = candidate_bt709 - candidate_y.xxx;
    float3 source_residual = source_bt709 - source_y.xxx;
    float candidate_residual2 = dot(candidate_residual, candidate_residual);
    float source_residual2 = dot(source_residual, source_residual);
    if (candidate_residual2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON
      || source_residual2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) {
    return candidate_lms;
    }

    float3 neutral_target_rgb = psycho25_TargetRGBFromLMS(
      renodx::color::lms::from::BT709(candidate_y.xxx),
      target_gamut_mode);
    float3 candidate_target_rgb = psycho25_TargetRGBFromLMS(
      renodx::color::lms::from::BT709(
        candidate_y.xxx
        + source_residual
          * sqrt(candidate_residual2 / source_residual2)),
      target_gamut_mode);
    float3 target_residual = candidate_target_rgb - neutral_target_rgb;
    float residual_scale = 1.f;
    if ((gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0) {
    float3 lower_support = neutral_target_rgb
      / max(-target_residual, PSYCHO25_EPSILON.xxx);
    residual_scale = min(
      residual_scale,
      min(lower_support.x, min(lower_support.y, lower_support.z)));
    }
    if ((gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0) {
    float3 upper_support = (peak_value.xxx - neutral_target_rgb)
      / max(target_residual, PSYCHO25_EPSILON.xxx);
    residual_scale = min(
      residual_scale,
      min(upper_support.x, min(upper_support.y, upper_support.z)));
    }
    return psycho25_LMSFromTargetRGB(
      neutral_target_rgb + target_residual * saturate(residual_scale),
      target_gamut_mode);
  }

float3 psycho25_GamutCompressLMSBoundAdaptive(
    float3 lms_input,
    float3 current_adaptive_state_lms,
    int target_gamut_mode,
    float strength) {
  float3 lms_weighted_relative =
      psycho25_ToAdaptiveRelativeWeightedLMS(
          lms_input,
          current_adaptive_state_lms);
  float3 lms_weighted_relative_out =
      renodx::color::gamut::GamutCompressWeightedLMSCoreRGBBoundFromAdaptiveWeightedInput(
          lms_weighted_relative,
          current_adaptive_state_lms,
          target_gamut_mode == 0
              ? renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT
              : renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
          strength);
  return renodx::color::macleod_boynton::UnweighLMS(
      psycho25_FromAdaptiveRelativeWeightedLMS(
          lms_weighted_relative_out,
          current_adaptive_state_lms));
}


bool psycho25_TargetRGBInsideEnabledHull(
    float3 target_rgb,
    float peak_value,
    int gamut_enforcement) {
  if ((gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0
      && min(target_rgb.x, min(target_rgb.y, target_rgb.z)) < 0.f) {
    return false;
  }
  if ((gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0
      && max(target_rgb.x, max(target_rgb.y, target_rgb.z)) > peak_value) {
    return false;
  }
  return true;
}

// Bounded adaptation-relative ACHROMATIC contrast used only as a scalar
// bookkeeping metric after the ideal PsychoV result has been completed.
//
// The previous RMS-per-cone metric allowed chromatic loss to masquerade as a
// white/brightness deficit. Extremely saturated reds could therefore drift too
// far toward white simply because a legal fit removed adaptive-MB radius.
//
// Instead, the post-fit white budget is now driven only by Yf:
//
//   A(Yf) = (Yf - Yf_adapt) / (abs(Yf) + abs(Yf_adapt))
//
// This stays finite at black, is explicitly aligned with PsychoV's weighted
// LMS/Yf achromatic axis, and does not convert chromatic loss into white.
float psycho25_AchromaticYfContrast(
    float3 lms,
    float3 current_adaptive_state_lms) {
  float signal_yf = psycho25_SignedYfFromLMS(lms);
  float adapt_yf = psycho25_SignedYfFromLMS(current_adaptive_state_lms);
  float safe_adapt_yf = max(abs(adapt_yf), PSYCHO25_EPSILON);
  return (signal_yf - adapt_yf)
      / (abs(signal_yf) + safe_adapt_yf);
}

// Exact same-adaptive-MB-hue fit of a completed PsychoV point into the enabled
// selected-target RGB planes.
//
// The preferred physical Yf is retained whenever that Yf has a nonempty target
// cross-section. Only adaptive-MB radius is shortened, using the exact
// closed-form six-plane support already used by Test25:
//
//   rho_out = min(rho_ideal, rho_max(theta, Yf))
//
// No low-Y support approximation is used. In particular, rho_max does NOT
// collapse toward zero merely because Yf approaches black; black is reached by
// Yf -> 0 while chromaticity may remain saturated. If upper planes are enabled
// and Yf reaches the target D65 peak cross-section, peak white is the only
// legal full-cube point.
float3 psycho25_ExactAdaptiveMBTargetFit(
    float3 ideal_lms,
    float3 current_adaptive_state_lms,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement) {
  if (gamut_enforcement == PSYCHO25_GAMUT_ENFORCEMENT_NONE) {
    return ideal_lms;
  }

  float3 ideal_target_rgb = psycho25_TargetRGBFromLMS(
      ideal_lms,
      target_gamut_mode);
  if (psycho25_TargetRGBInsideEnabledHull(
          ideal_target_rgb,
          peak_value,
          gamut_enforcement)) {
    return ideal_lms;
  }

  const bool enforce_gamut_primaries =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
  const bool enforce_gamut_peak =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;

  float ideal_yf = psycho25_SignedYfFromLMS(ideal_lms);
  if (!(ideal_yf > PSYCHO25_EPSILON)) {
    if (enforce_gamut_primaries) {
      return 0.f.xxx;
    }
    // Without lower-plane enforcement there is no positive-Yf ray constraint.
    // Apply only the enabled upper planes as a numerical target-space fallback.
    float3 target_rgb = ideal_target_rgb;
    if (enforce_gamut_peak) {
      target_rgb = min(target_rgb, peak_value.xxx);
    }
    return psycho25_LMSFromTargetRGB(target_rgb, target_gamut_mode);
  }

  float3 target_peak_lms = psycho25_LMSFromTargetRGB(
      peak_value.xxx,
      target_gamut_mode);
  float target_peak_yf = psycho25_SignedYfFromLMS(target_peak_lms);
  if (enforce_gamut_peak
      && ideal_yf >= target_peak_yf * (1.f - PSYCHO25_EPSILON)) {
    return target_peak_lms;
  }

  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float3 ideal_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              ideal_lms,
              current_adaptive_state_lms));
  float2 ideal_offset = ideal_mb.xy - adapted_neutral_mb;
  float ideal_radius2 = dot(ideal_offset, ideal_offset);

  // Neutral points have no radial degree of freedom. If one is still outside,
  // only the enabled target planes can resolve it.
  if (ideal_radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) {
    float3 target_rgb = ideal_target_rgb;
    if (enforce_gamut_primaries) {
      target_rgb = max(target_rgb, 0.f.xxx);
    }
    if (enforce_gamut_peak) {
      target_rgb = min(target_rgb, peak_value.xxx);
    }
    return psycho25_LMSFromTargetRGB(target_rgb, target_gamut_mode);
  }

  float ideal_radius = sqrt(ideal_radius2);
  float2 direction = ideal_offset / ideal_radius;
  float radial_support = psycho25_TargetRadialSupportAtYf(
      direction,
      ideal_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);

  if (radial_support >= PSYCHO25_LARGE * 0.5f
      || ideal_radius <= radial_support) {
    return ideal_lms;
  }

  float3 legal_lms = psycho25_LMSFromHueDirectionAndYf(
      direction,
      max(radial_support, 0.f),
      ideal_yf,
      current_adaptive_state_lms,
      adapted_neutral_mb);

  // Exact support should already be legal. This final clamp covers only
  // floating-point residue at a target plane.
  float3 legal_target_rgb = psycho25_TargetRGBFromLMS(
      legal_lms,
      target_gamut_mode);
  if (enforce_gamut_primaries) {
    legal_target_rgb = max(legal_target_rgb, 0.f.xxx);
  }
  if (enforce_gamut_peak) {
    legal_target_rgb = min(legal_target_rgb, peak_value.xxx);
  }
  return psycho25_LMSFromTargetRGB(
      legal_target_rgb,
      target_gamut_mode);
}

// Post-ideal lost-contrast fit.
//
// 1) Complete Test25's ordinary physical/MIDPOINT result.
// 2) Fit that result to the exact selected-target six-plane support while
//    retaining its adaptive-MB hue and Yf whenever the cross-section exists.
// 3) Measure only the bounded ACHROMATIC contrast lost by that legal fit:
//
//        dA = max(A_ideal - A_legal, 0),
//
//    where A is the Yf-based adaptation-relative contrast above.
// 4) Convert dA to a bounded Neutwo-like pressure.
// 5) Permit that pressure to become whiteward motion only in proportion to the
//    square of physical Yf / target-peak Yf.
//
// Thus gamut fitting itself does not repower LMS ratios. Lost chromatic radius
// does not become white. Near black, the whiteward term vanishes quadratically
// and the exact same-hue legal result is retained. At high Yf, lost achromatic
// contrast may be spent along the legal point -> peak-D65-white segment, which
// remains inside the convex target RGB cube.
float3 psycho25_ApplyAdaptiveContrastFitLinearWhiteLegacy(
    float3 ideal_lms,
    float3 current_adaptive_state_lms,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement) {
  if (gamut_enforcement == PSYCHO25_GAMUT_ENFORCEMENT_NONE) {
    return ideal_lms;
  }

  float3 legal_lms = psycho25_ExactAdaptiveMBTargetFit(
      ideal_lms,
      current_adaptive_state_lms,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);

  float ideal_contrast = psycho25_AchromaticYfContrast(
      ideal_lms,
      current_adaptive_state_lms);
  float legal_contrast = psycho25_AchromaticYfContrast(
      legal_lms,
      current_adaptive_state_lms);
  float lost_contrast = max(ideal_contrast - legal_contrast, 0.f);
  if (lost_contrast <= PSYCHO25_EPSILON) {
    return legal_lms;
  }

  const bool enforce_gamut_peak =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;
  if (!enforce_gamut_peak) {
    // Without an upper hull there is no defined target-white destination for
    // the lost achromatic budget. Keep the exact same-hue fit.
    return legal_lms;
  }

  float3 target_peak_lms = psycho25_LMSFromTargetRGB(
      peak_value.xxx,
      target_gamut_mode);
  float peak_contrast = psycho25_AchromaticYfContrast(
      target_peak_lms,
      current_adaptive_state_lms);
  float available_contrast = max(
      peak_contrast - legal_contrast,
      PSYCHO25_EPSILON);
  float normalized_loss = lost_contrast / available_contrast;

  // h=2 generalized-Neutwo occupancy: bounded [0,1), identity-like for small
  // normalized loss and asymptotic under extreme out-of-hull stress.
  float loss_pressure = normalized_loss
      * rsqrt(1.f + normalized_loss * normalized_loss);

  float legal_yf = max(psycho25_SignedYfFromLMS(legal_lms), 0.f);
  float target_peak_yf = max(
      psycho25_SignedYfFromLMS(target_peak_lms),
      PSYCHO25_EPSILON);
  float yf_fraction = saturate(legal_yf / target_peak_yf);
  float white_pressure = loss_pressure * yf_fraction * yf_fraction;

  float3 legal_target_rgb = psycho25_TargetRGBFromLMS(
      legal_lms,
      target_gamut_mode);
  float3 output_target_rgb = lerp(
      legal_target_rgb,
      peak_value.xxx,
      white_pressure);

  // Both endpoints are legal target-cube points, so this convex interpolation
  // is legal by construction. Clamp only for floating-point residue.
  if ((gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0) {
    output_target_rgb = max(output_target_rgb, 0.f.xxx);
  }
  output_target_rgb = min(output_target_rgb, peak_value.xxx);
  return psycho25_LMSFromTargetRGB(
      output_target_rgb,
      target_gamut_mode);
}

float3 psycho25_ApplyIndependentPostCompression(
    float3 contrast_lms,
    float3 source_lms,
    float3 anchor_out,
    float3 current_adaptive_state_lms,
    float peak_value,
    float compression_power,
    int target_gamut_mode,
    int gamut_enforcement,
    int post_compression_mode) {
  if (post_compression_mode == PSYCHO25_POST_COMPRESSION_DIRECT) {
    return contrast_lms;
  }

  float3 post_lms = contrast_lms;
  if (post_compression_mode
          == PSYCHO25_POST_COMPRESSION_SOURCE_MB_PER_CHANNEL
      || post_compression_mode
          == PSYCHO25_POST_COMPRESSION_SOURCE_MB_SOFT_MAX) {
    post_lms = psycho25_RestoreSourceAdaptiveMBDirection(
        post_lms,
        source_lms,
        current_adaptive_state_lms);
  }

  const bool enforce_gamut_primaries =
      (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
  if (enforce_gamut_primaries) {
    if (post_compression_mode
        == PSYCHO25_POST_COMPRESSION_ADAPTIVE_MB_HARD_MAX) {
      float3 post_mb =
          renodx::color::macleod_boynton::from::WeightedLMS(
              psycho25_ToAdaptiveRelativeWeightedLMS(
                  post_lms,
                  current_adaptive_state_lms));
      post_mb = psycho25_PullBackAdaptiveMBToTargetLowerPlanes(
          post_mb,
          renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy,
          current_adaptive_state_lms,
          target_gamut_mode);
      post_lms = psycho25_LMSFromAdaptiveMB(
          post_mb,
          current_adaptive_state_lms);
    } else if (post_compression_mode
                   == PSYCHO25_POST_COMPRESSION_ADAPTIVE_MB_SOFT_MAX
               || post_compression_mode
                   == PSYCHO25_POST_COMPRESSION_SOURCE_MB_SOFT_MAX) {
      // Match PsychoV17's final device-map helper: adaptive-relative weighted
      // LMS, the selected target-primary triangle, and strength 1.
      post_lms = psycho25_GamutCompressLMSBoundAdaptive(
          post_lms,
          current_adaptive_state_lms,
          target_gamut_mode,
          1.f);
    } else if (post_compression_mode
               == PSYCHO25_POST_COMPRESSION_FIXED_D65_SOFT_MAX) {
      post_lms = target_gamut_mode == 0
          ? renodx::color::gamut::GamutCompressLMSBoundBT709(post_lms, 1.f)
          : renodx::color::gamut::GamutCompressLMSBoundBT2020(post_lms, 1.f);
    }
  }

  float3 post_target_rgb = psycho25_TargetRGBFromLMS(
      post_lms,
      target_gamut_mode);
  post_target_rgb = psycho25_ApplyPostTargetCompression(
      post_target_rgb,
      psycho25_TargetRGBFromLMS(anchor_out, target_gamut_mode),
      peak_value,
      compression_power,
      gamut_enforcement,
      post_compression_mode);
  return psycho25_LMSFromTargetRGB(
      post_target_rgb,
      target_gamut_mode);
}

float psycho25_EvaluateRawPerChannelHueShift(
    float source_hue_angle,
    Psycho25HueEvaluationContext context) {
  float2 source_direction =
      float2(cos(source_hue_angle), sin(source_hue_angle));
  float3 candidate_source_lms =
      psycho25_LMSFromHueDirectionAndYf(
          source_direction,
          context.source_radius,
          context.source_target_yf,
          context.current_adaptive_state_lms,
          context.adapted_neutral_mb);

  float3 contrast_lms = psycho25_ApplyContrastResponse(
      candidate_source_lms,
      context.anchor_in,
      context.anchor_out,
      context.contrast_power,
      context.observer_gamut_mode);
  float3 candidate_guidance_lms = context.guidance_lms_peak
      * psycho25_CompressionRolloffSignedPerCone(
          contrast_lms,
          context.guidance_cone_response);
  float2 compressed_direction =
      psycho25_AdaptiveMBDirection(
        candidate_guidance_lms,
          context.current_adaptive_state_lms,
          context.adapted_neutral_mb);
  if (dot(compressed_direction, compressed_direction)
      <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) return 0.f;

  return atan2(
      psycho25_Cross2(source_direction, compressed_direction),
      dot(source_direction, compressed_direction));
}

Psycho25HueGeometry psycho25_FindHueGeometry(
    Psycho25HueSection section,
    Psycho25HueEvaluationContext context) {
  float step = (section.end - section.start)
               / float(PSYCHO25_HUE_PEAK_SCAN_INTERVALS);

  float best_angle = section.midpoint;
  float best_shift = psycho25_EvaluateRawPerChannelHueShift(
      best_angle,
      context);
  float best_magnitude = abs(best_shift);

  [loop]
  for (uint scan = 0u;
       scan <= PSYCHO25_HUE_PEAK_SCAN_INTERVALS;
       ++scan) {
    if (scan == PSYCHO25_HUE_PEAK_SCAN_INTERVALS / 2u) continue;
    float angle = section.start + step * float(scan);
    float shift = psycho25_EvaluateRawPerChannelHueShift(
        angle,
        context);
    if (abs(shift) > best_magnitude) {
      best_angle = angle;
      best_shift = shift;
      best_magnitude = abs(shift);
    }
  }

  float lo = max(section.start, best_angle - step);
  float hi = min(section.end, best_angle + step);
  static const float golden = 0.6180339887498948482f;
  float x1 = hi - golden * (hi - lo);
  float x2 = lo + golden * (hi - lo);
  float shift1 = psycho25_EvaluateRawPerChannelHueShift(x1, context);
  float shift2 = psycho25_EvaluateRawPerChannelHueShift(x2, context);
  float y1 = abs(shift1);
  float y2 = abs(shift2);

  [loop]
  for (uint iteration = 0u;
       iteration < PSYCHO25_HUE_PEAK_REFINE_ITERATIONS;
       ++iteration) {
    if (y1 < y2) {
      lo = x1;
      x1 = x2;
      y1 = y2;
      shift1 = shift2;
      x2 = lo + golden * (hi - lo);
      shift2 = psycho25_EvaluateRawPerChannelHueShift(x2, context);
      y2 = abs(shift2);
    } else {
      hi = x2;
      x2 = x1;
      y2 = y1;
      shift2 = shift1;
      x1 = hi - golden * (hi - lo);
      shift1 = psycho25_EvaluateRawPerChannelHueShift(x1, context);
      y1 = abs(shift1);
    }
  }

  float refined_angle = y1 >= y2 ? x1 : x2;
  float refined_shift = y1 >= y2 ? shift1 : shift2;
  if (abs(refined_shift) > best_magnitude) {
    best_angle = refined_angle;
    best_shift = refined_shift;
    best_magnitude = abs(refined_shift);
  }

  float peak_offset = best_angle - section.midpoint;
  Psycho25HueGeometry geometry;
  geometry.peak_angle = best_angle;
  geometry.peak_shift = best_shift;
  geometry.active = best_magnitude > PSYCHO25_EPSILON ? 1u : 0u;
  geometry.axis_slope = geometry.active != 0u
                            ? (abs(peak_offset) > PSYCHO25_EPSILON
                                   ? best_shift / peak_offset
                                   : (best_shift < 0.f ? -PSYCHO25_LARGE : PSYCHO25_LARGE))
                            : -2.2f;
  geometry.maximum_ordered_amplitude = 1.f;
  if (geometry.active != 0u
      && abs(peak_offset) > PSYCHO25_EPSILON
      && section.index == 2u) {
    // The raw +S-to--L field can form a sharp Yf- and purity-dependent cusp.
    // Its amplitude-1 endpoint remains available, but the authored field must
    // not fold hue phase. Probe both cusp sides and cap only this pin interval's
    // effective amplitude with margin. For the oblique inverse
    //   x = t - (1 - A) r(t) / s, y = x + A r(t),
    // the ordered-phase coefficient is A - (1 - A) / s.
    geometry.axis_slope = min(
        geometry.axis_slope,
        PSYCHO25_HUE_REVERSAL_AXIS_SLOPE_LIMIT);
    float derivative_step = max(
        step / PSYCHO25_HUE_ORDER_DERIVATIVE_PROBE_DIVISOR,
        PSYCHO25_EPSILON);
    float left_angle = max(section.start, best_angle - derivative_step);
    float right_angle = min(section.end, best_angle + derivative_step);
    float left_shift = psycho25_EvaluateRawPerChannelHueShift(
        left_angle,
        context);
    float right_shift = psycho25_EvaluateRawPerChannelHueShift(
        right_angle,
        context);
    float left_derivative = renodx::math::DivideSafe(
        best_shift - left_shift,
        best_angle - left_angle,
        0.f);
    float right_derivative = renodx::math::DivideSafe(
        right_shift - best_shift,
        right_angle - best_angle,
        0.f);
    float minimum_raw_derivative = min(left_derivative, right_derivative);
    if (minimum_raw_derivative < -PSYCHO25_EPSILON) {
      float maximum_raw_coefficient = PSYCHO25_HUE_ORDER_SAFETY
                                      / -minimum_raw_derivative;
      float inverse_axis_slope = 1.f / geometry.axis_slope;
      geometry.maximum_ordered_amplitude = saturate(
          (maximum_raw_coefficient + inverse_axis_slope)
          / (1.f + inverse_axis_slope));
    }
  }
  return geometry;
}

float psycho25_ForwardMappedHue(
    float curve_parameter,
    float amplitude,
    float axis_slope,
    Psycho25HueEvaluationContext context) {
  float shift = psycho25_EvaluateRawPerChannelHueShift(
      curve_parameter,
      context);
  // The graph-space operation has the closed form
  //   x' = x - (1 - A) * y / slope, y' = A * y.
  // Inversion needs only X; the final consumed shift is its direct Y form.
  return curve_parameter - (1.f - amplitude) * shift / axis_slope;
}

float psycho25_SolveSextantHueShift(
    Psycho25HueSection section,
    Psycho25HueGeometry geometry,
    float amplitude,
    Psycho25HueEvaluationContext context) {
  if (amplitude <= PSYCHO25_EPSILON || geometry.active == 0u) return 0.f;
  if (min(
          section.source_unwrapped - section.start,
          section.end - section.source_unwrapped)
      <= PSYCHO25_EPSILON) return 0.f;

  if (amplitude >= 1.f - PSYCHO25_EPSILON) {
    return psycho25_EvaluateRawPerChannelHueShift(
        section.source_unwrapped,
        context);
  }

  // The oblique graph transform can make mapped X locally nonmonotonic even
  // when the final hue phase remains ordered. A whole-interval bisection then
  // changes between distant roots under tiny input perturbations. Bracket all
  // sign-changing roots at a fixed resolution and invert the one nearest the
  // requested source phase, which is the local branch connected to the
  // amplitude-1 identity transform.
  float lo = section.start;
  float hi = section.end;
  float lo_value = psycho25_ForwardMappedHue(
                       lo,
                       amplitude,
                       geometry.axis_slope,
                       context)
                   - section.source_unwrapped;
  float best_distance = PSYCHO25_LARGE;
  float previous_parameter = lo;
  float previous_value = lo_value;
  [loop]
  for (uint scan = 1u;
       scan <= PSYCHO25_HUE_INVERSE_BRACKET_INTERVALS;
       ++scan) {
    float parameter = lerp(
        section.start,
        section.end,
        float(scan) / float(PSYCHO25_HUE_INVERSE_BRACKET_INTERVALS));
    float value = psycho25_ForwardMappedHue(
                      parameter,
                      amplitude,
                      geometry.axis_slope,
                      context)
                  - section.source_unwrapped;
    if (previous_value * value <= 0.f) {
      float estimate_fraction = saturate(renodx::math::DivideSafe(
          -previous_value,
          value - previous_value,
          0.5f));
      float estimated_parameter = lerp(
          previous_parameter,
          parameter,
          estimate_fraction);
      float distance = abs(
          estimated_parameter - section.source_unwrapped);
      if (distance < best_distance) {
        lo = previous_parameter;
        hi = parameter;
        lo_value = previous_value;
        best_distance = distance;
      }
    }
    previous_parameter = parameter;
    previous_value = value;
  }

  [loop]
  for (uint iteration = 0u;
       iteration < PSYCHO25_HUE_INVERSE_ITERATIONS;
       ++iteration) {
    float midpoint = 0.5f * (lo + hi);
    float midpoint_value = psycho25_ForwardMappedHue(
                               midpoint,
                               amplitude,
                               geometry.axis_slope,
                               context)
                           - section.source_unwrapped;
    if ((lo_value < 0.f) == (midpoint_value < 0.f)) {
      lo = midpoint;
      lo_value = midpoint_value;
    } else {
      hi = midpoint;
    }
  }

  float curve_parameter = 0.5f * (lo + hi);
  float raw_shift = psycho25_EvaluateRawPerChannelHueShift(
      curve_parameter,
      context);
  return amplitude * raw_shift;
}

Psycho25AdaptiveMBTrajectory psycho25_BuildAdaptiveMBTrajectory(
  float3 physical_magnitude_lms,
  float3 guidance_direction_lms,
    float3 direction_source_lms,
    float3 current_adaptive_state_lms,
    float3 anchor_in,
    float3 anchor_out,
    float3 guidance_lms_peak,
    float contrast_power,
    Psycho25ConeResponseParameters guidance_cone_response,
    int hue_method,
    int observer_gamut_mode = PSYCHO25_OBSERVER_GAMUT_NONE) {
  float3 magnitude_relative_weighted =
      psycho25_ToAdaptiveRelativeWeightedLMS(
        physical_magnitude_lms,
          current_adaptive_state_lms);
  float3 magnitude_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          magnitude_relative_weighted);
  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  Psycho25AdaptiveMBTrajectory trajectory;
  trajectory.authored_mb = magnitude_mb;
  trajectory.hue_applied = 0u;

  float3 source_relative_weighted =
      psycho25_ToAdaptiveRelativeWeightedLMS(
          direction_source_lms,
          current_adaptive_state_lms);
  float3 source_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          source_relative_weighted);
  float3 compressed_direction_relative_weighted =
      psycho25_ToAdaptiveRelativeWeightedLMS(
        guidance_direction_lms,
          current_adaptive_state_lms);
  float3 compressed_direction_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          compressed_direction_relative_weighted);

  float2 magnitude_offset = magnitude_mb.xy - adapted_neutral_mb;
  float2 source_offset = source_mb.xy - adapted_neutral_mb;
  float2 compressed_direction_offset =
      compressed_direction_mb.xy - adapted_neutral_mb;
  float magnitude_radius2 = dot(magnitude_offset, magnitude_offset);
  float source_radius2 = dot(source_offset, source_offset);
  float compressed_direction_radius2 = dot(
      compressed_direction_offset,
      compressed_direction_offset);
  if (magnitude_radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON
      || source_radius2 <= PSYCHO25_EPSILON * PSYCHO25_EPSILON
      || compressed_direction_radius2
          <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) {
    return trajectory;
  }

  float magnitude_radius = sqrt(magnitude_radius2);
  float source_radius = sqrt(source_radius2);
  float2 source_direction = source_offset / source_radius;
  if (hue_method == PSYCHO25_HUE_METHOD_FAST_60) {
    // The fixed approximately 60-degree hue-graph assumption reduces the 50%
    // operation to the angular midpoint between the source and current raw
    // per-channel-compressed directions. Normalizing their linear midpoint is
    // exact for equal-weight unit directions and avoids all graph searches.
    float2 compressed_direction = compressed_direction_offset
                    * rsqrt(compressed_direction_radius2);
    float2 output_direction = lerp(
        source_direction,
        compressed_direction,
        1.f - PSYCHO25_HUE_AMPLITUDE);
    float output_direction2 = dot(output_direction, output_direction);
    if (output_direction2
        <= PSYCHO25_EPSILON * PSYCHO25_EPSILON) return trajectory;
    output_direction *= rsqrt(output_direction2);
    trajectory.authored_mb = float3(
        adapted_neutral_mb + output_direction * magnitude_radius,
        magnitude_mb.z);
    trajectory.hue_applied = 1u;
    return trajectory;
  }

  float source_hue_angle = atan2(source_direction.y, source_direction.x);
  Psycho25HueEvaluationContext context = psycho25_PrepareHueEvaluationContext(
      guidance_cone_response,
      current_adaptive_state_lms,
      anchor_in,
      anchor_out,
      guidance_lms_peak,
      adapted_neutral_mb,
      source_radius,
      psycho25_YfFromLMS(direction_source_lms),
      contrast_power,
      observer_gamut_mode);

    float2 axis_l = psycho25_IsolatedConeDisplacementAxis(
      current_adaptive_state_lms,
      adapted_neutral_mb,
      0u);
    float2 axis_m = psycho25_IsolatedConeDisplacementAxis(
      current_adaptive_state_lms,
      adapted_neutral_mb,
      1u);
    float2 axis_s = psycho25_IsolatedConeDisplacementAxis(
      current_adaptive_state_lms,
      adapted_neutral_mb,
      2u);
    Psycho25HueSection section = psycho25_HuePinIntervalForAngle(
      source_hue_angle,
      axis_l,
      axis_m,
      axis_s);
    Psycho25HueGeometry geometry = psycho25_FindHueGeometry(
      section,
      context);
    float hue_shift = psycho25_SolveSextantHueShift(
      section,
      geometry,
      min(
        PSYCHO25_HUE_AMPLITUDE,
        geometry.maximum_ordered_amplitude),
      context);
  float output_hue_angle = source_hue_angle + hue_shift;
  float2 output_direction =
      float2(cos(output_hue_angle), sin(output_hue_angle));
  trajectory.authored_mb = float3(
      adapted_neutral_mb + output_direction * magnitude_radius,
      magnitude_mb.z);
  trajectory.hue_applied = 1u;
  return trajectory;
}

// Both output branches use the same prepared cone-response state. The direct
// branch returns its saturation shoulder; the gamut-active branch retains only
// its graph-solved adaptive-MB trajectory before target-plane
// compression.
float3 psycho25_ApplyPhysicalPerConePath(
    float3 desired_lms,
    float3 direction_source_lms,
    float3 current_adaptive_state_lms,
    float3 anchor_in,
    float3 anchor_out,
    float3 physical_lms_peak,
    float contrast_power,
    Psycho25ConeResponseParameters physical_cone_response,
    int hue_method,
    int observer_gamut_mode = PSYCHO25_OBSERVER_GAMUT_NONE) {
  float3 physical_compressed_lms = physical_lms_peak
                                   * psycho25_CompressionRolloffSignedPerCone(
                                       desired_lms,
                                       physical_cone_response);
  Psycho25AdaptiveMBTrajectory trajectory =
      psycho25_BuildAdaptiveMBTrajectory(
          physical_compressed_lms,
          physical_compressed_lms,
          direction_source_lms,
          current_adaptive_state_lms,
          anchor_in,
          anchor_out,
          physical_lms_peak,
          contrast_power,
          physical_cone_response,
          hue_method,
          observer_gamut_mode);
  if (trajectory.hue_applied == 0u) return physical_compressed_lms;
  float3 authored_lms = psycho25_LMSFromAdaptiveMB(
      trajectory.authored_mb,
      current_adaptive_state_lms);
  return authored_lms * renodx::math::DivideSafe(
      psycho25_YfFromLMS(physical_compressed_lms),
      psycho25_YfFromLMS(authored_lms),
      1.f);
}


// Post-ideal contrast fit that follows Test25's own physical/MIDPOINT path.
//
// The exact same-hue target fit first removes only the adaptive-MB radius that
// the selected RGB cube cannot represent at the completed physical Yf. The
// removed chromatic fraction is NOT treated as equal-energy white. Instead it
// contributes to a trajectory-advance pressure only on the high side of the
// adapted state:
//
//   chroma_loss = (rho_ideal - rho_legal) / rho_ideal
//   yf_gate     = saturate((Yf_legal - Yf_adapt) / (Yf_peak - Yf_adapt))
//
// Genuine lost achromatic Yf contrast contributes independently. Their smooth
// union is bounded with the h=2 Neutwo response, then converted to one later
// post-contrast magnitude. Test25's per-cone shoulder and Graph/Fast60 authoring
// are re-evaluated ONCE at that later state, after which the exact six-plane fit
// is applied again. Thus red follows the same authored red->white trajectory
// instead of a straight target-RGB lerp to white. At/below adaptation, chroma
// loss alone cannot create whiteward motion.
float3 psycho25_ApplyAdaptiveContrastFit(
    float3 ideal_lms,
    float3 desired_lms,
    float3 direction_source_lms,
    float3 current_adaptive_state_lms,
    float3 anchor_in,
    float3 anchor_out,
    float3 target_lms_peak,
    float contrast_power,
    Psycho25ConeResponseParameters target_cone_response,
    int hue_method,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement,
    int observer_gamut_mode = PSYCHO25_OBSERVER_GAMUT_NONE) {
  if (gamut_enforcement == PSYCHO25_GAMUT_ENFORCEMENT_NONE) {
    return ideal_lms;
  }

  float3 legal_lms = psycho25_ExactAdaptiveMBTargetFit(
      ideal_lms,
      current_adaptive_state_lms,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);

  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float3 ideal_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              ideal_lms,
              current_adaptive_state_lms));
  float3 legal_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              legal_lms,
              current_adaptive_state_lms));
  float ideal_radius = length(ideal_mb.xy - adapted_neutral_mb);
  float legal_radius = length(legal_mb.xy - adapted_neutral_mb);
  float chroma_loss_fraction = saturate(
      renodx::math::DivideSafe(
          max(ideal_radius - legal_radius, 0.f),
          ideal_radius,
          0.f));

  float3 target_peak_lms = psycho25_LMSFromTargetRGB(
      peak_value.xxx,
      target_gamut_mode);
  float legal_yf = max(psycho25_SignedYfFromLMS(legal_lms), 0.f);
  float adapt_yf = psycho25_SignedYfFromLMS(current_adaptive_state_lms);
  float target_peak_yf = max(
      psycho25_SignedYfFromLMS(target_peak_lms),
      adapt_yf + PSYCHO25_EPSILON);
  float high_side_yf = saturate(
      renodx::math::DivideSafe(
          legal_yf - adapt_yf,
          target_peak_yf - adapt_yf,
          0.f));
  float chroma_pressure = chroma_loss_fraction * high_side_yf;

  float ideal_achromatic = psycho25_AchromaticYfContrast(
      ideal_lms,
      current_adaptive_state_lms);
  float legal_achromatic = psycho25_AchromaticYfContrast(
      legal_lms,
      current_adaptive_state_lms);
  float peak_achromatic = psycho25_AchromaticYfContrast(
      target_peak_lms,
      current_adaptive_state_lms);
  float lost_achromatic = max(
      ideal_achromatic - legal_achromatic,
      0.f);
  float achromatic_pressure = saturate(
      renodx::math::DivideSafe(
          lost_achromatic,
          max(peak_achromatic - legal_achromatic, PSYCHO25_EPSILON),
          0.f));

  // Smooth union of chromatic and achromatic pressure. Chromatic pressure is
  // already Yf-weighted above, so saturated near-black colors do not advance.
  float raw_pressure = 1.f
      - (1.f - chroma_pressure) * (1.f - achromatic_pressure);
  if (raw_pressure <= PSYCHO25_EPSILON) {
    return legal_lms;
  }

  float trajectory_pressure = raw_pressure
      * rsqrt(1.f + raw_pressure * raw_pressure);
  float trajectory_scale = rcp(max(
      1.f - trajectory_pressure,
      PSYCHO25_EPSILON));

  // desired_lms is already post-contrast. To keep the source state used by
  // Graph/Fast60 consistent with that later contrast magnitude, invert the
  // scalar contrast power for the pre-contrast direction source.
  float safe_contrast_power = max(
      contrast_power,
      PSYCHO25_EPSILON);
  float source_scale = pow(
      trajectory_scale,
      rcp(safe_contrast_power));

  float3 advanced_ideal_lms = psycho25_ApplyPhysicalPerConePath(
      desired_lms * trajectory_scale,
      direction_source_lms * source_scale,
      current_adaptive_state_lms,
      anchor_in,
      anchor_out,
      target_lms_peak,
      contrast_power,
      target_cone_response,
      hue_method,
      observer_gamut_mode);

  return psycho25_ExactAdaptiveMBTargetFit(
      advanced_ideal_lms,
      current_adaptive_state_lms,
      peak_value,
      target_gamut_mode,
      gamut_enforcement);
}

float3 psycho25_CompressTargetHull(
    float3 desired_lms,
    float3 direction_source_lms,
    float3 current_adaptive_state_lms,
    float3 anchor_in,
    float3 anchor_out,
    float3 target_lms_peak,
    float3 guidance_lms_peak,
    float contrast_power,
    float upper_plane_shoulder_power,
    Psycho25ConeResponseParameters target_cone_response,
    Psycho25ConeResponseParameters guidance_cone_response,
    float peak_value,
    int target_gamut_mode,
    int gamut_enforcement,  // independent lower/upper target-plane bitmask
    int hue_method,
    int hull_method,
    int upper_hull_pivot,
    float canonical_pressure_pivot,
    float canonical_pressure_contrast,
    float canonical_pressure_h,
    float canonical_pressure_trade,
    float canonical_yf_bias_power,
    int observer_gamut_mode = PSYCHO25_OBSERVER_GAMUT_NONE) {
  const bool enforce_gamut_primaries = (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0;
  const bool enforce_gamut_peak = (gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0;
  float3 desired_weighted_lms =
      renodx::color::macleod_boynton::WeighLMS(desired_lms);
  float desired_yf = desired_weighted_lms.x + desired_weighted_lms.y;

  // Every nonblack color satisfying the selected target's lower RGB planes has
  // positive Yf. A nonpositive-Yf direction therefore intersects those planes
  // only at the origin. Without primary enforcement, this signed stress case
  // has no stable positive-Yf hull ray, so retain the direct physical path
  // instead of implicitly imposing lower planes.
  if (desired_yf <= PSYCHO25_EPSILON) {
    if (enforce_gamut_primaries) {
      return 0.f.xxx;
    }
    return psycho25_ApplyPhysicalPerConePath(
        desired_lms,
        direction_source_lms,
        current_adaptive_state_lms,
        anchor_in,
        anchor_out,
        target_lms_peak,
        contrast_power,
        target_cone_response,
        hue_method,
        observer_gamut_mode);
  }

  float anchor_out_yf = psycho25_YfFromLMS(anchor_out);
  float target_peak_yf = psycho25_SignedYfFromLMS(target_lms_peak);

  // Keep magnitude/radius tied to the real target peak, but derive the
  // compressed hue direction from the target-relative neutral guidance
  // endpoint. At the 1x default this is exactly the physical endpoint and
  // per-channel response. Carried scale is discarded before upper-plane
  // support.
  float3 physical_compressed_lms = target_lms_peak
                                   * psycho25_CompressionRolloffSignedPerCone(
                                       desired_lms,
                                       target_cone_response);
  float3 guidance_direction_lms =
      guidance_lms_peak
      * psycho25_CompressionRolloffSignedPerCone(
          desired_lms,
          guidance_cone_response);
  Psycho25AdaptiveMBTrajectory trajectory =
      psycho25_BuildAdaptiveMBTrajectory(
          physical_compressed_lms,
          guidance_direction_lms,
          direction_source_lms,
          current_adaptive_state_lms,
          anchor_in,
          anchor_out,
          guidance_lms_peak,
          contrast_power,
          guidance_cone_response,
          hue_method,
          observer_gamut_mode);
  float3 safe_adaptive_state_lms = max(
      current_adaptive_state_lms,
      PSYCHO25_EPSILON.xxx);
  float authored_yf = psycho25_YfFromLMS(physical_compressed_lms);
  if (authored_yf <= PSYCHO25_EPSILON) {
    if (enforce_gamut_primaries) {
      return 0.f.xxx;
    }
    return psycho25_ApplyPhysicalPerConePath(
        desired_lms,
        direction_source_lms,
        current_adaptive_state_lms,
        anchor_in,
        anchor_out,
        target_lms_peak,
        contrast_power,
        target_cone_response,
        hue_method,
        observer_gamut_mode);
  }

  float2 adapted_neutral_mb =
      renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float2 authored_offset =
      trajectory.authored_mb.xy - adapted_neutral_mb;
  float authored_radius2 = dot(authored_offset, authored_offset);
  float authored_radius = sqrt(authored_radius2);
  float2 authored_direction = authored_offset * rsqrt(
      authored_radius2 + PSYCHO25_EPSILON * PSYCHO25_EPSILON);
  float3 source_mb =
      renodx::color::macleod_boynton::from::WeightedLMS(
          psycho25_ToAdaptiveRelativeWeightedLMS(
              direction_source_lms,
              current_adaptive_state_lms));

    if ((hull_method == PSYCHO25_HULL_METHOD_REFERENCE_SCALE
      || hull_method == PSYCHO25_HULL_METHOD_REDUCED_MAX_WHITE)
      && enforce_gamut_primaries) {
    // Independent cone shoulders eventually make every positive source
    // approach LMS white. As that physical radius disappears, turn its
    // direction continuously toward the pre-contrast source direction so
    // saturated blue cannot rotate through an unrelated purple direction.
    // Keep the physical radius itself unchanged so the result can continue
    // through light blue to white. This is one smooth trajectory rather than
    // a level- or hue-segmented correction.
    float2 source_offset = source_mb.xy - adapted_neutral_mb;
    float source_radius2 = dot(source_offset, source_offset);
    float source_radius = sqrt(source_radius2);
    float2 source_direction = source_offset * rsqrt(
        source_radius2 + PSYCHO25_EPSILON * PSYCHO25_EPSILON);
    float source_radius_support =
        psycho25_TargetLowerPlaneRadiusForDirection(
            source_direction,
            adapted_neutral_mb,
            current_adaptive_state_lms,
            target_gamut_mode);
    float source_direction_occupancy =
        hull_method == PSYCHO25_HULL_METHOD_REFERENCE_SCALE
            ? PSYCHO25_REFERENCE_SOURCE_DIRECTION_OCCUPANCY
            : PSYCHO25_REDUCED_MAX_WHITE_SOURCE_DIRECTION_OCCUPANCY;
    float source_direction_support_radius = source_direction_occupancy
        * source_radius_support
        * renodx::math::DivideSafe(
            source_radius,
            sqrt(
                source_radius2
                + source_radius_support * source_radius_support),
            0.f);
    float radius_normalization = max(
        max(authored_radius, source_direction_support_radius),
        PSYCHO25_EPSILON);
    float authored_weight = pow(
        authored_radius / radius_normalization,
        PSYCHO25_SOURCE_DIRECTION_BLEND_POWER);
    float source_direction_support_weight = pow(
        source_direction_support_radius / radius_normalization,
        PSYCHO25_SOURCE_DIRECTION_BLEND_POWER);
    float source_hue_support =
        PSYCHO25_SOURCE_HUE_SUPPORT_FRACTION * source_radius_support;
    float source_hue_confidence = renodx::math::DivideSafe(
        source_radius2,
        source_radius2 + source_hue_support * source_hue_support,
        0.f);
    float source_collapse_weight = renodx::math::DivideSafe(
        source_direction_support_weight,
        authored_weight + source_direction_support_weight,
        0.f);
    float source_direction_weight = 1.f
        - (1.f - source_hue_confidence)
          * (1.f - source_collapse_weight);
    float2 combined_direction = lerp(
        authored_direction,
        source_direction,
        source_direction_weight);
    combined_direction *= rsqrt(
        dot(combined_direction, combined_direction)
        + PSYCHO25_EPSILON * PSYCHO25_EPSILON);
    authored_direction = combined_direction;
    authored_offset = authored_direction * authored_radius;
    trajectory.authored_mb.xy = adapted_neutral_mb + authored_offset;
  }

  if (hull_method == PSYCHO25_HULL_METHOD_LINEAR_MB_PULLBACK
      && enforce_gamut_primaries
      && authored_radius > PSYCHO25_EPSILON) {
    // Diagnostic path: retain the Graph/Fast60-authored adaptive-MB direction
    // and actual-peak physical radius until the candidate crosses a selected-
    // target lower plane, then pull that radius straight back to the first
    // intersection. There is no reference radius, knee, neutral release,
    // smooth support intersection, or source-direction recovery.
    trajectory.authored_mb = psycho25_PullBackAdaptiveMBToTargetLowerPlanes(
        trajectory.authored_mb,
        adapted_neutral_mb,
        current_adaptive_state_lms,
        target_gamut_mode);
    authored_offset = trajectory.authored_mb.xy - adapted_neutral_mb;
    authored_radius = length(authored_offset);
  }

  // Normalization removes the trajectory guide's carried scale. Only its
    // adaptive-MB direction and radius survive into the legacy cube ray. The
    // final direction is normalized only after source retention or linear
    // pullback so the later physical-Yf scale cannot inherit a stale x
    // coordinate.
    float trajectory_yf_for_normalization = trajectory.authored_mb.z * (
      trajectory.authored_mb.x * safe_adaptive_state_lms.x
      + (1.f - trajectory.authored_mb.x) * safe_adaptive_state_lms.y);
  float3 unit_yf_lms = psycho25_LMSFromAdaptiveMB(
      float3(
          trajectory.authored_mb.xy,
        renodx::math::DivideSafe(
          trajectory.authored_mb.z,
          trajectory_yf_for_normalization,
          0.f)),
      current_adaptive_state_lms);
  float3 neutral_lms = current_adaptive_state_lms
                       / psycho25_YfFromLMS(current_adaptive_state_lms);

  if (hull_method == PSYCHO25_HULL_METHOD_CANONICAL_CYLINDER) {
    return psycho25_CompressCanonicalCylinderVolume(
        unit_yf_lms * authored_yf,
        current_adaptive_state_lms,
        peak_value,
        target_gamut_mode,
        gamut_enforcement,
        canonical_pressure_pivot,
        canonical_pressure_contrast,
        canonical_pressure_h,
        canonical_pressure_trade);
  }

  if (hull_method == PSYCHO25_HULL_METHOD_CANONICAL_YF_CONE) {
    return psycho25_CompressCanonicalYfConeVolume(
        unit_yf_lms * authored_yf,
        current_adaptive_state_lms,
        peak_value,
        target_gamut_mode,
        gamut_enforcement,
        canonical_pressure_pivot,
        canonical_pressure_contrast,
        canonical_pressure_h,
        canonical_yf_bias_power);
  }

  if (hull_method == PSYCHO25_HULL_METHOD_SECTIONAL_WHITE_VOLUME) {
    // The per-cone response supplies white convergence, the Graph/Fast60
    // trajectory supplies its curved 50% six-section hue direction, and this
    // one cross-sectional map contracts only the same-Yf radial displacement.
    // No fixed-source recovery, second tone curve, or wall-to-white post pass
    // is applied afterward.
    return psycho25_CompressSectionalWhiteVolume(
        unit_yf_lms * authored_yf,
        current_adaptive_state_lms,
        peak_value,
        target_gamut_mode,
        gamut_enforcement);
  }

  if (hull_method == PSYCHO25_HULL_METHOD_REFERENCE3
      && enforce_gamut_primaries
      && enforce_gamut_peak) {
    return psycho25_CompressTargetHueTriangleVolume(
          unit_yf_lms * authored_yf,
          peak_value,
          target_gamut_mode);
  }

  // The function returns a linear BT.709 representation even when the selected
  // target hull is BT.2020. Negative BT.709 components are valid for colors
  // outside BT.709 but inside BT.2020, so lower-plane feasibility must be
  // evaluated in the selected target RGB space. Reference and Reduced Max-
  // White solve against a same-authored hue reference no nearer the adaptive
  // neutral than either the physical trajectory or its uncompressed post-
  // contrast input. Reference2 leaves this same-Yf radial stage untouched;
  // its lower-plane correction lifts the completed candidate toward D65 white.
  if (enforce_gamut_primaries
      && (hull_method == PSYCHO25_HULL_METHOD_REFERENCE_SCALE
        || hull_method == PSYCHO25_HULL_METHOD_REDUCED_MAX_WHITE)
      && authored_radius > PSYCHO25_EPSILON) {
    float3 neutral_target_rgb = psycho25_TargetRGBFromLMS(
        neutral_lms,
        target_gamut_mode);

    // Fixed-Yf LMS interpolation is not exactly adaptive-MB radial
    // interpolation. Apply the smooth shoulder to the current ray as the final
    // target-plane safeguard.
    float3 current_target_rgb = psycho25_TargetRGBFromLMS(
        unit_yf_lms,
        target_gamut_mode);
    float current_boundary_fraction =
        psycho25_TargetLowerPlaneBoundaryFraction(
            current_target_rgb,
            neutral_target_rgb);
    float current_radius_scale =
        psycho25_CompressTargetLowerPlaneRadius(
            current_boundary_fraction);

    authored_direction = authored_offset / authored_radius;
    float containment_reference_radius = max(
      authored_radius,
      length(source_mb.xy - adapted_neutral_mb));
    float3 reference_lms = psycho25_LMSFromAdaptiveMB(
      float3(
        adapted_neutral_mb
          + authored_direction * containment_reference_radius,
        1.f),
      current_adaptive_state_lms);
    reference_lms /= psycho25_YfFromLMS(reference_lms);
    float3 reference_target_rgb = psycho25_TargetRGBFromLMS(
      reference_lms,
      target_gamut_mode);

    // Find the selected-target lower-plane boundary along the complete
    // neutral-to-reference ray even while the reference remains in gamut.
    // A boundary fraction above one means the current reference is inside.
    float reference_boundary_fraction =
      psycho25_TargetLowerPlaneBoundaryFraction(
        reference_target_rgb,
        neutral_target_rgb);

    // Compress a unit input ray with a rational shoulder whose value and
    // first derivative both match identity at the knee. The output approaches
    // the exact lower-plane boundary asymptotically rather than changing
    // behavior when a target channel first crosses zero.
    float reference_radius_scale = psycho25_CompressTargetLowerPlaneRadius(
      reference_boundary_fraction);

    float trajectory_fraction =
      authored_radius / containment_reference_radius;
    float release_progress = saturate(
      trajectory_fraction
      / PSYCHO25_LOWER_PLANE_NEUTRAL_RELEASE_FRACTION);
    float neutral_scale = min(1.f, 4.f * reference_radius_scale);
    float release_weight = 1.f - release_progress;
    float radius_scale = min(
      lerp(
        reference_radius_scale,
        neutral_scale,
        release_weight * release_weight),
      current_radius_scale);

    unit_yf_lms = lerp(neutral_lms, unit_yf_lms, radius_scale);
  }

  // With peak planes disabled, retain the no-gamut trajectory's authored Yf.
  // Primary enforcement may still reduce adaptive-MB chrominance to fit the
  // selected target's nonnegative RGB half-spaces.
  if (!enforce_gamut_peak) {
    float3 candidate_lms = unit_yf_lms * authored_yf;
    if ((hull_method != PSYCHO25_HULL_METHOD_REFERENCE2
        && hull_method != PSYCHO25_HULL_METHOD_REFERENCE3)
        || !enforce_gamut_primaries) {
      return candidate_lms;
    }
    float3 candidate_target_rgb = psycho25_TargetRGBFromLMS(
        candidate_lms,
        target_gamut_mode);
    float white_level = max(
        peak_value,
        max(
            candidate_target_rgb.x,
            max(candidate_target_rgb.y, candidate_target_rgb.z)));
    return psycho25_LiftTargetRGBTowardWhitePreservingAdaptiveMBHue(
        candidate_lms,
      current_adaptive_state_lms,
        white_level,
        target_gamut_mode);
  }

  float3 unit_target_rgb = psycho25_TargetRGBFromLMS(
      unit_yf_lms,
      target_gamut_mode);

  float max_target_channel = max(
      unit_target_rgb.x,
      max(unit_target_rgb.y, unit_target_rgb.z));
  float directional_yf_limit = peak_value / max_target_channel;
  float shoulder_input_yf = enforce_gamut_primaries
                                ? desired_yf
                                : authored_yf;

  if (upper_hull_pivot == PSYCHO25_UPPER_HULL_PIVOT_ADAPTED_OUTPUT) {
    // Experimental adapted-output pivot. Express the authored candidate as a
    // displacement from the output/background anchor, measure how much of the
    // available per-channel upper-plane headroom that displacement occupies,
    // then apply the selected scalar shoulder power over the
    // adapted-Yf-to-peak range. Scaling the complete LMS displacement keeps
    // the anchor exact and avoids turning signed target RGB into a channel
    // clamp.
    float3 candidate_lms = unit_yf_lms * shoulder_input_yf;
    float3 candidate_target_rgb = psycho25_TargetRGBFromLMS(
        candidate_lms,
        target_gamut_mode);
    float3 anchor_target_rgb = psycho25_TargetRGBFromLMS(
        anchor_out,
        target_gamut_mode);
    float3 target_headroom = peak_value.xxx - anchor_target_rgb;
    float upper_occupancy = 0.f;
    if (candidate_target_rgb.x > anchor_target_rgb.x) {
      upper_occupancy = max(
        upper_occupancy,
        (candidate_target_rgb.x - anchor_target_rgb.x)
          / target_headroom.x);
    }
    if (candidate_target_rgb.y > anchor_target_rgb.y) {
      upper_occupancy = max(
        upper_occupancy,
        (candidate_target_rgb.y - anchor_target_rgb.y)
          / target_headroom.y);
    }
    if (candidate_target_rgb.z > anchor_target_rgb.z) {
      upper_occupancy = max(
        upper_occupancy,
        (candidate_target_rgb.z - anchor_target_rgb.z)
          / target_headroom.z);
    }
    if (upper_occupancy <= PSYCHO25_EPSILON) {
      return hull_method == PSYCHO25_HULL_METHOD_REFERENCE2
        && enforce_gamut_primaries
      ? psycho25_LiftTargetRGBTowardWhitePreservingAdaptiveMBHue(
        candidate_lms,
        current_adaptive_state_lms,
        peak_value,
        target_gamut_mode)
      : candidate_lms;
    }

    float centered_input_yf = anchor_out_yf
                              + upper_occupancy
                    * (target_peak_yf - anchor_out_yf);
    float centered_output_yf = psycho25_CompressionRolloffScalar(
        centered_input_yf,
        anchor_out_yf,
      target_peak_yf,
        upper_plane_shoulder_power);
    float output_occupancy = (centered_output_yf - anchor_out_yf)
                 / (target_peak_yf - anchor_out_yf);
    float displacement_scale = output_occupancy / upper_occupancy;
    float3 output_lms = anchor_out
                        + (candidate_lms - anchor_out) * displacement_scale;
    return hull_method == PSYCHO25_HULL_METHOD_REFERENCE2
        && enforce_gamut_primaries
        ? psycho25_LiftTargetRGBTowardWhitePreservingAdaptiveMBHue(
          output_lms,
          current_adaptive_state_lms,
          peak_value,
          target_gamut_mode)
      : output_lms;
  }

  float normalized_input = shoulder_input_yf
      * renodx::math::DivideSafe(
        target_peak_yf,
          directional_yf_limit,
          1.f);
  float normalized_output = psycho25_CompressionRolloffScalar(
      normalized_input,
      anchor_out_yf,
      target_peak_yf,
      upper_plane_shoulder_power);
  float output_yf = normalized_output
                    * renodx::math::DivideSafe(
                        directional_yf_limit,
              target_peak_yf,
                        1.f);
  float3 output_lms = unit_yf_lms * output_yf;
  return hull_method == PSYCHO25_HULL_METHOD_REFERENCE2
      && enforce_gamut_primaries
    ? psycho25_LiftTargetRGBTowardWhitePreservingAdaptiveMBHue(
        output_lms,
      current_adaptive_state_lms,
        peak_value,
        target_gamut_mode)
    : output_lms;
}

// psychov-25 research source record and device-hull plan
// ------------------------------------------------------
//
// Objective:
// PsychoV first targets the observer-side bend of the scene:
// - what state the eye adapts to,
// - how the scene is converted to contrast around that adapted state,
// - how the response is shaped around that adapted state,
// - which nonlinear curve applies at each stage.
// The human observer is not a linear gain system, so the observer model decides
// which scene differences remain important when the display hull forces
// compression. Tonemapping itself remains a device-hull problem, not an eye
// model.
//
// The design therefore distinguishes two coupled systems:
// - observer flow: a literature-backed receptor/adaptation/opponent roadmap;
// - device-hull mapping: a joint tone, hue, and gamut solve over the complete
//   display hull.
//
// Current Test25 implementation status:
// - implemented: relative scene-linear BT.709 -> Stockman/CVRL LMS,
//   weighted-LMS/Yf/adaptive-MB bookkeeping, caller-provided adaptation
//   anchors, scalar-Yf grading, adaptive-MB purity, anchor-matched contrast,
//   a retained no-gamut per-cone rolloff, a numerical 50% hue-graph solve,
//   actual-trajectory selected-target
//   lower-plane containment, a physical no-gamut trajectory guide,
//   independently selectable target lower-plane and upper-plane support, and
//   one scalar peak shoulder over the resulting device-hull ray when requested;
// - planned or not implemented: absolute retinal calibration, adaptation-state
//   estimation, calibrated cone-noise thresholds, absolute photopigment
//   bleaching,
//   ACC/DKL response,
//   explicit ON/OFF splitting, pooled cortical gain, equivalent-Gaussian hue,
//   and a wider sectional optimization over multiple in-sextant hull points.
//
// Rahimi-Nasrabadi et al. (Cell Reports 2021,
// doi:10.1016/j.celrep.2021.108692) validated their ONOFF image algorithm on
// calibrated grayscale images and suggested applying it to color through the
// lightness dimension. Test25 therefore keeps highlight/shadow grading on
// scalar Yf rather than independently grading L, M, and S. This citation does
// not make the current per-cone display rolloff a biological ON/OFF model.
//
// Research basis and intended human-flow model:
//
// 1) Receptor basis — implemented as a relative rendering basis.
//    Stockman-Sharpe LMS with CIE 170-2 physiological luminance Yf / weighted
//    LMS bookkeeping, not CIE 1931 Y.
//
//    Reference split:
//    - Brainard, "Colorimetry" (chapter 10): the cone stage / color-match
//      foundation. Chapter 11 explicitly points back to this chapter when it
//      says, "The first stage of color vision is now well understood (see
//      Chap. 10)." This supports scene RGB/XYZ -> cone excitations L, M, S.
//    - Stockman & Brainard (chapter 11): builds on that receptor basis for
//      first-site and second-site adaptation.
//    Sources:
//    https://color2.psych.upenn.edu/brainard/papers/Brainard_Stockman_Colorimetry.pdf
//    https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//
//    CVRL notes that cone signals are formed only after prereceptoral filtering
//    by ocular media and macular pigment. Both absorb mainly at short
//    wavelengths and vary substantially across observers. The transform is an
//    average-observer receptor basis unless those filters are modeled
//    explicitly.
//    References: CVRL background hub; "Macular and lens pigments":
//    http://www.cvrl.org/background.htm
//    http://www.cvrl.org/database/text/intros/intromaclens.htm
//
//    MacLeod-Boynton is not itself the cortical flow. It is a weighted
//    cone-chromaticity representation in an equal-luminance plane with a
//    separately carried achromatic scale term. In implementation notation:
//      l = Lw / (Lw + Mw)
//      s = Sw / (Lw + Mw)
//      y = Lw + Mw
//    The fixed observer-transform coefficients form weighted LMS, the Yf-like
//    achromatic response, and MB coordinates from LMS. They are not adaptation,
//    gain, or bleaching terms. CVRL describes the CIE physiological functions
//    as linear transforms of the Stockman & Sharpe cone fundamentals. Mantiuk
//    et al. describe practical LMS scaling so that L+M corresponds to
//    luminance. This is the mathematical role of the weights at this stage.
//
//    Reference: MacLeod & Boynton (1979),
//    doi:10.1364/JOSA.69.001183; modern CIE 170-2 implementations replace ad
//    hoc weights with standardized physiological cone-fundamental/luminance
//    weights.
//
//    Citation split for the coefficients used by the RenoDX transform:
//    - explicit CIE 170-2 / physiological-weight usage: CIE/CVRL
//      physiological functions, Psychtoolbox LMSToMacBoyn, and the repository
//      Stockman/MacLeod-Boynton shader wiring;
//    - classic or modified MB without an explicit CIE 170-2 coefficient claim:
//      MacLeod & Boynton (1979), Webster & Leonard (2008);
//    - LMS scaled so the achromatic term is L+M, without an explicit CIE 170-2
//      MB coefficient claim: Mantiuk et al. (2020).
//    Classic MB, modified MB, and plain L+M-scaled LMS must not be cited as if
//    they automatically justify the exact CIE 170-2 coefficients used here.
//    Sources:
//    http://www.cvrl.org/ciexyzpr.htm
//    https://psychtoolbox.org/docs/LMSToMacBoyn
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC2657039/
//    https://www.cl.cam.ac.uk/~rkm38/pdfs/mantiuk2020practical_csf.pdf
//
// 2) Early cone adaptation — caller-provided anchors are implemented;
//    adaptation estimation and a fitted physiological response are not.
//    Maintain an adapting background state (L0, M0, S0, Yf0), then express the
//    stimulus relative to that background before a postreceptoral transform.
//    Chapter 10 gives absolute cone excitations; chapter 11 defines how they
//    depend on the adapting background and become a contrast representation.
//
//    Source-backed first-site math is cone-specific contrast/gain control, not
//    a rule that every adapted background maps to one fixed output level.
//    Stockman & Brainard write first-site L-cone contrast as:
//      C_L = delta_L / (L_b + L_0)
//    with analogous forms for M and S. Equivalently:
//      g_L = 1 / (L_b + L_0)
//      g_L * (L - L_b) = delta_L / (L_b + L_0)
//    Thus the observer approximately normalizes cone signals by the adapted
//    background. First-site adaptation is neither complete nor instantaneous;
//    later second-site adaptation further reshapes postreceptoral signals.
//    References: Stockman & Brainard (2010); Stockman et al. (JOV 2006,
//    doi:10.1167/6.11.5).
//
//    Webster & Leonard (2008) distinguish their "response norm," the adapting
//    level that does not bias white judgments, from their "perceptual norm," the
//    stimulus that appears white. Those norms tracked closely in their
//    experiments, but neither is the same term as Stockman & Brainard's
//    background cone excitations or Mantiuk et al.'s background responses. The
//    directly modeled early state is best called the adapted background
//    reference; response/perceptual norms are higher-level interpretations of
//    why that reference acts as the current neutral coding state.
//    Source: https://pmc.ncbi.nlm.nih.gov/articles/PMC2657039/
//
//    CVRL further notes that luminosity functions depend strongly on chromatic
//    adaptation and observing conditions, whereas cone spectral sensitivities
//    remain fixed until photopigment bleaching becomes significant. This is why
//    Yf bookkeeping remains tied to the adapted observer state rather than a
//    condition-invariant photometric curve.
//    Reference: CVRL "Luminosity functions":
//    http://www.cvrl.org/database/text/intros/introvl.htm
//
// 2a) Dim cone-noise regime — research plan, not implemented.
//    Before rod-dominated vision, cone-mediated detection can already be
//    limited by quantal/transduction noise. In this dim-but-still-cone regime,
//    threshold cone contrast follows approximately De Vries-Rose behavior: in
//    log-log space, threshold contrast falls with retinal illuminance at slope
//    near -0.5. At higher levels the system approaches Weber-like behavior,
//    where threshold contrast is roughly constant relative to the background.
//    Weak scene differences may therefore disappear into a cone-noise-limited
//    floor before rod vision dominates.
//    Reference direction:
//    - Stockman & Brainard (2010): cone-contrast space is most useful when
//      first-site adaptation is in the Weber regime and less useful where
//      adaptation falls short of Weber's law;
//    - Angueyra & Rieke (2013): primate cone photoreceptors exhibit measurable
//      phototransduction noise.
//    Sources:
//    https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//    https://pmc.ncbi.nlm.nih.gov/articles/PMC3815624/
// 2b) High-light bleaching — research plan, not implemented.
//    At sufficiently high retinal illuminance, a Rushton-Henry-style law in
//    trolands describes per-cone pigment availability:
//      p_available(I) = 1 / (1 + I / I0)
//    This complements the commonly cited fraction-bleached law:
//      p_bleached(I) = I / (I + I0)
//    with I0 approximately 10^4.3 Td for cones.
//
//    A rendering interpretation can apply availability to cone excursions
//    around an adapted-white anchor so availability -> 0 approaches equal
//    white at the carried achromatic level. That interpretation must not be
//    confused with the current per-cone display rolloff.
//    Sources and attribution:
//    - Stockman et al. (JOV 2006, doi:10.1167/6.11.5): high-light sensitivity
//      regulation is maintained mainly by photopigment bleaching;
//    - Stockman et al. (JOV 2018, 18(6):12): appendix gives
//      p = I / (I + I0), I0 = 10^4.3 Td, citing Rushton & Henry (1968);
//    - CVRL "Bleaching":
//      http://www.cvrl.org/database/text/intros/introbleaches.htm
//    Physiological bleaching still belongs after the adapted background is
//    defined and before postreceptoral opponent encoding, pooled gain, and
//    device-hull mapping.
//
// 3) Background-normalized opponent drive — research plan beyond adaptive MB.
//    Convert cone-domain responses into ACC/DKL-style opponent coordinates
//    using a background-referenced weighted-LMS achromatic axis. MacLeod-
//    Boynton describes chromaticity on an equal-luminance plane, whereas ACC /
//    DKL are opponent combinations of cone increments around a background. MB
//    therefore carries hue/device geometry and achromatic Yf bookkeeping here;
//    ACC/DKL remains the planned space for postreceptoral response and gain.
//
// 4) Saturating contrast response — current rolloff is an engineering curve.
//    A future receptor/early-cortical stage may use a Michaelis-Menten or
//    Naka-Rushton-like nonlinearity. Some cortical fits may need a
//    supersaturating variant.
//    Reference: Peirce (JOV 2007, doi:10.1167/7.6.13).
//
// 5) ON/OFF separation — research constraint, not an explicit Test25 split.
//    Split increments and decrements around the adapted/background state with
//    half-wave rectification before pooled gain. The split is around
//    adaptation, not diffuse white. Modern retina work also shows that ON/OFF
//    nonlinearities can cancel in natural images, producing a more linear
//    effective response than a single static saturating curve suggests. ON/OFF
//    therefore constrains the neutral and OFF-side slope; it does not require a
//    hard branch in the default curve.
//    References: Schiller (1992); Yu, Turner, Baudin & Rieke,
//    eLife 2022, 11:e70611, doi:10.7554/eLife.70611.
//
// 6) Pooled cortical gain — research plan, not implemented.
//    A full observer stage still requires background-referenced opponency,
//    ON/OFF separation, and fitted divisive gain parameters.
//    References: Heeger (1992); Carandini & Heeger (2012); Bun & Horwitz
//    (2023); Li et al. (2022).
//
// 7) Unified device-hull tonemapping and gamut mapping — active design plan.
//    Map the observer-domain result into the display hull while retaining the
//    most plausible achromatic and opponent contrast structure the device can
//    represent. Diffuse/reference white, adapted neutral, and display peak are
//    distinct anchors. ITU-R BT.2408's HDR Reference White framing is the
//    practical video reference for keeping diffuse white below specular/display
//    peak.
//
//    Full normalized BT.709 hull:
//    - peak 1.0 and BT.709 constraints together define 0 <= R,G,B <= 1;
//    - this is one RGB cube, not a per-channel-to-white operation followed by a
//      separate gamut constraint;
//    - Test25 runtime units generalize the upper planes to `peak_value`, so the
//      equivalent hull is 0 <= R,G,B <= peak_value in the selected target RGB
//      basis;
//    - the primary triangle is only the chromaticity-plane projection of part
//      of this geometry. It does not describe upper faces or complete
//      constant-scale cross-sections of the cube;
//    - lower and upper channel faces, cube edges/corners, and relevant LMS
//      bounds must be considered inside each cone-axis sextant;
//    - BT.709 is the primary normalized design target. BT.2020 is a generalized
//      target-mode extension, not a reason to weaken the BT.709 formulation.
//
//    Sextant constraint:
//    - isolated L/M/S displacement axes and their antipodes establish the six
//      sections independently of any white rolloff or RGB target;
//    - per-cone compression may supply one candidate interior hue objective,
//      but it is not required to discover the sections and is not the hull;
//    - the final solve must examine the complete target cross-section within
//      the active sextant and LMS bounds, rather than assuming radial motion to
//      adapted neutral is always optimal.
//
//    Device-hull inference:
//    - many display hulls can produce more total achromatic output by combining
//      primaries than at the same level with a high-purity excursion;
//    - an out-of-hull observer response may therefore trade chromatic shape
//      toward the achromatic axis when the complete hull demands it;
//    - the preferred result is not blind clipping to white, but the face, edge,
//      corner, or interior point that best preserves observer-domain contrast
//      structure;
//    - white is one valid destination when bleaching or an achromatic optimum
//      dominates, not the mandatory destination of gamut compression.
//
//    Engineering direction inferred from the sources above:
//    - use weighted LMS / MB to carry achromatic Yf and cone-axis geometry;
//    - use an opponent representation to judge postreceptoral contrast;
//    - construct and solve the full display hull in that combined state rather
//      than first collapsing channels toward white and then clipping in RGB.
//
//    Coupling constraint:
//    - hue, tone, and device-hull compression are not independent steps;
//    - a hue change after hull compression can push the result out of hull;
//    - hue-preserving motion must be solved inside the hull projection or be
//      followed by explicit in-hull reprojection;
//    - the current complete-cube ray support proves containment with one scalar
//      shoulder, but it is a partial implementation of the full sectional
//      optimization rather than proof that its one authored direction is the
//      globally preferred observer-domain trade.
//    Reference direction: MacLeod-Boynton/CIE 170-2 geometry, repository
//    weighted-LMS/MB transforms, and the device-hull notes above.
//
// 7a) Optional hue objective inside the device-hull solve — research plan.
//    If display compression bends hue incorrectly, the solve may preserve an
//    "equivalent Gaussian peak" proxy rather than a raw opponent angle. At
//    short and medium wavelengths, perceived hue can behave more like a
//    constant spectral peak of an equivalent Gaussian than a constant cone
//    ratio as purity changes.
//    Practical form:
//    - offline, map weighted-LMS/MB chromaticities to an equivalent-Gaussian
//      peak parameter mu_eq using a spectral forward model;
//    - online, preserve mu_eq inside device-hull mapping while carrying Yf
//      separately;
//    - do not apply an unconstrained post-hoc hue shift after containment.
//    This is an optional hull objective, not a chronological eye stage.
//    References: Mizokami et al. (JOV 2006, doi:10.1167/6.9.12);
//    O'Neil et al. (JOSAA 2012, doi:10.1364/JOSAA.29.00A165).
//
// 7b) Smooth auto-compression heuristic — currently implemented per cone.
//    `compression == 0` derives h from the simultaneous-range reference above:
//      one side around adaptation = reference_range_log10 / 2
//      h = (reference_range_log10 / 2) / log10(peak / anchor_out)
//      pow(anchor_out / peak, h) = pow(10, -(reference_range_log10 / 2))
//      S_shadow = contrast / (1 - pow(anchor_out / peak, h))
//    The OFF/shadow slope error is derived from the selected reference range.
//    Manual positive compression values remain exact. References: Kunkel &
//    Reinhard, APGV 2010, doi:10.1145/1836248.1836251; Jiang & Fairchild,
//    JIST 2021, doi:10.2352/J.ImagingSci.Technol.2021.65.5.050401.
//
// Current Test25 implementation map:
// ```mermaid
// flowchart LR
//   rgb["Scene-linear BT.709"] --> lms["Stockman/CVRL LMS"]
//   lms --> grade["Scalar-Yf highlights/shadows"]
//   grade --> purity["Adaptive-MB purity"]
//   purity --> contrast["Anchor-matched per-cone contrast"]
//   contrast --> branch{"Gamut compression enabled?"}
//   branch -->|No| rolloff["Retained per-cone LMS shoulder"]
//   rolloff --> fallback["Numerical hue-graph solve"]
//   branch -->|Yes| authored["Graph-solved trajectory direction"]
//   authored --> direction["Continuous source-direction recovery"]
//   direction --> planes["Physical radius + selected target planes"]
//   planes --> scalar["One scalar shoulder over directional Yf support"]
//   fallback --> output["BT.709-linear result"]
//   scalar --> output
// ```
//
// Research roadmap and source-state map:
// ```mermaid
// flowchart TB
//   subgraph inputs["Raw inputs / assumptions"]
//     rgb2["Scene-linear RGB"]
//     colorimetry["Input RGB basis / white / RGB-to-LMS"]
//     absolute["Absolute scene scale / retinal context"]
//     background["Adaptation drivers / local background"]
//     scene_range["Late image context / range"]
//     observer["Stockman/CVRL observer assumptions"]
//     display["Display primaries / white / peak / black / full hull"]
//   end
//   subgraph observer_flow["Observer roadmap"]
//     receptor["Receptor LMS"]
//     adapt["Adapted background reference"]
//     cone_contrast["Per-cone background-relative response"]
//     bleaching["Bleaching availability"]
//     noise["Dim cone-noise visibility floor"]
//     opponent["Opponent / achromatic response"]
//     onoff["ON / OFF response"]
//     gain["Pooled divisive normalization"]
//     observer_out["Observer-domain response"]
//   end
//   subgraph device_map["Joint device-hull mapping"]
//     hue_objective["Hue objective: MB / ACC / mu_eq"]
//     sextants["Cone-axis sextants + LMS bounds"]
//     cube["Full target RGB cube cross-sections"]
//     hull_solve["Joint tone / hue / gamut solve"]
//     hull_output["Display-hull output"]
//   end
//   rgb2 --> receptor
//   colorimetry --> receptor
//   observer --> receptor
//   absolute --> receptor
//   receptor --> adapt
//   background --> adapt
//   receptor --> cone_contrast
//   adapt --> cone_contrast
//   cone_contrast --> bleaching --> noise --> opponent --> onoff --> gain
//   scene_range --> gain
//   gain --> observer_out
//   observer_out --> hue_objective
//   observer_out --> hull_solve
//   hue_objective --> hull_solve
//   sextants --> hull_solve
//   display --> cube --> hull_solve --> hull_output
// ```
//
// Implementation scope:
// - The caller supplies the adapted source state and desired output background
//   state. Neutral defaults are 0.18/0.18, so ordinary non-adapting content is
//   not moved by the anchors.
// - The receptor basis is an average-observer, mainly foveal Stockman/CVRL
//   basis with standard prereceptoral filtering folded into its functions. It
//   is not a personalized observer model.
// - Scalar defaults are normalized rendering controls, not fitted
//   physiological constants.
// - Conceptually, observer response and device mapping remain distinct. The
//   current `psycho25_CompressTargetHull` combines authored hue, selected
//   target-plane support, and scalar compression because they must remain
//   coupled in practice.
// - Reference and Reduced Max-White derive a bounded direction-support scale
//   from the pre-contrast source as independent cone shoulders approach LMS
//   white. For source radius r_s and selected-target lower-plane support R_s:
//     q_s = rho R_s r_s / sqrt(r_s^2 + R_s^2),
//   with rho = 0.8 for Reference and 1 for Reduced Max-White. A quadratic
//   collapse weight turns direction continuously toward the source as the
//   physical authored radius vanishes. The output radius remains the physical
//   radius, so chromatic highlights can still converge on white. The ordinary
//   target solve supplies lower-plane correction and max-channel upper-plane
//   support. No hue-sector branch, source gamut, output channel clamp, active
//   limiting-face branch, retained radius, or segmented Yf range is introduced.

// Public API contract:
// - `bt709_linear_input` is always scene/display-linear BT.709 RGB. Target
//   gamut mode does not change this input conversion.
// - The return value is also represented as linear BT.709 RGB. A BT.2020
//   target may require negative BT.709 components; callers must convert to the
//   target RGB space before applying target-space channel limits.
// - `peak_value` is the upper RGB-channel plane in units relative to the
//   caller's reference white. A 100-nit peak / 100-nit reference-white test
//   therefore uses 1. Runtime target containment is
//   0 <= target RGB <= peak_value. The caller must provide a positive peak
//   whose D65 LMS and Yf values are strictly above the output/background
//   anchor; invalid display configurations are not clamped or repaired.
// - `gamut_compression_mode`: 0 = BT.709 target, 1 = BT.2020 target.
// - Solved hue evaluation always carries the measured adaptive-MB radius.
//   No source gamut is declared, inferred, or used as a normalization bound.
// - Hue authoring defaults to the numerical graph solve. `hue_method` selects
//   the Fast60 comparison path, which uses the normalized 50% adaptive-MB
//   midpoint and skips peak search plus inverse graph solving.
// - `hull_method` defaults to the reference-scale path, whose source-direction
//   recovery uses 80% of its bounded target-relative support as the physical
//   radius approaches white. Reduced Max-White raises that direction-support
//   factor to 100%; neither mode retains a radius floor. Linear MB Pullback
//   instead preserves the
//   authored adaptive-MB direction and pulls its radius straight back to the
//   first selected-target lower plane, with no lower-plane shoulder or custom
//   radius construction. Target RGB Clip bypasses target-hull mapping and
//   directly clamps the result in the selected linear BT.709 or BT.2020 RGB
//   cube.
// - `hull_method == PSYCHO25_HULL_METHOD_CANONICAL_CYLINDER` selects the
//   experimental canonical-cylinder map. It treats the authored adaptive-MB
//   trajectory as the preferred point, computes exact selected-target radial
//   support at its hue/Yf, forms q = rho/rho_max, leaves q <= 1 unchanged, and
//   redirects q > 1 both inward and upward toward target peak D65 white. The
//   four `canonical_pressure_*` controls match the interactive experiment:
//   pivot = excess-occupancy scale, contrast = pressure exponent, h = bounded
//   generalized-Neutwo shoulder, trade = 0 inward-first to 1 upward-first.
//   The experiment is defined only for full lower+upper cube enforcement;
//   partial plane modes remain on their existing diagnostic paths.
// - `post_compression_mode` selects an independent experiment. Modes Direct
//   through Source MB Soft branch from the common post-contrast LMS signal and
//   bypass physical per-cone output compression, Graph/Fast60 hue authoring,
//   and coupled target-hull mapping. Direct applies no device constraint.
//   Per-Channel and Max-Channel apply one
//   selected-target RGB shoulder. Adaptive MB Hard, Adaptive MB Soft, and
//   Fixed D65 Soft first apply their named lower-plane mapper and then the
//   max-channel shoulder. Source MB variants first restore the pre-contrast
//   adaptive-MB direction while retaining post-contrast radius and carried
//   coordinate. Source BT709 Residual retains the normal coupled Reference
//   result's relative luminance and linear-BT.709 residual magnitude, replaces
//   only that residual direction with the source direction, and shortens it
//   uniformly when selected-target containment requires it. The compatibility
//   default is None.
//   PsychoV17 Gamut + Neutwo Max retains the physical/hue direction but derives
//   scalar magnitude from the common unbounded post-contrast signal after the
//   same primary map. One anchor-normalized Neutwo shoulder is its peak map.
// - `PSYCHO25_POST_COMPRESSION_ADAPTIVE_CONTRAST_FIT` keeps Test25's completed
//   physical/MIDPOINT result as the ideal point, fits it to the exact enabled
//   selected-target six-plane support at the same adaptive-MB hue/Yf, then
//   measures only bounded adaptation-relative Yf contrast lost by that fit.
//   Lost chromatic radius is weighted by position above adapted Yf, genuine
//   lost achromatic Yf is added independently, and their bounded pressure
//   advances one later Test25 per-cone/MIDPOINT state before exact refitting.
//   No straight RGB-to-white interpolation is used; near black chroma loss
//   alone produces no trajectory advance.
// - `upper_hull_pivot` defaults to the existing black-origin constant-ratio
//   peak ray. The experimental adapted-output mode instead applies the peak
//   shoulder to target-channel headroom measured from `anchor_out`, keeping
//   that adapted output/background state as the exact geometric pivot.
// - `compression`: positive = manual shoulder h; 0 = automatic h derived from
//   the centered simultaneous-range reference. Manual h parameterizes both
//   the no-gamut per-cone fallback and target-plane trajectory guide. Automatic
//   h is resolved against each path's respective peak. Whenever any target
//   plane is enabled, the direction guide uses a neutral endpoint of
//   `target_peak_yf * guidance_peak_scale`; the real target peak remains
//   unchanged for physical magnitude, radius, and upper-plane containment.
// - `guidance_peak_scale`: target-relative neutral Yf endpoint multiplier for
//   target-plane hue guidance. It defaults to 1, is clamped to at least 1,
//   and is ignored when no target planes are active. At 1x the guide is the
//   regular physical per-channel shoulder.
// - `upper_plane_shoulder_power`: positive = independent upper-plane scalar
//   shoulder h; 0 = match the resolved `compression` h. It has no effect when
//   target peak/upper-plane enforcement is disabled.
// - `gamut_compression`: <= epsilon selects the retained per-cone LMS fallback;
//   > epsilon selects both target-plane classes under legacy enforcement.
//   Intermediate strength values are intentionally not a blend between two
//   compressors.
// - `gamut_enforcement` independently selects target primary/lower-plane and
//   target peak/upper-plane enforcement. With peak enforcement disabled, the
//   gamut branch retains the authored Yf instead of imposing an RGB-channel
//   peak. The legacy default follows `gamut_compression`: disabled maps to no
//   target planes and enabled maps to both plane classes.
// - `cone_response_exponent` remains the response multiplier over the direct
//   adapted-LMS contrast and purity controls. `encoded_response_power` is an
//   adapted-anchor-preserving power in the compression-encoded response
//   domain.
// - `input_pre_step` optionally retains signed LMS, clamps to positive LMS,
//   clips to CIE 170-2, or aligns the signed MB hue ray to CIE 170-2 while
//   retaining absolute Yf.
// - `observer_gamut_mode` is independent of `input_pre_step` and selected
//   target gamut. CIE 170-2 mode constrains actual LMS immediately after
//   per-cone contrast, before the physical/guidance shoulders and hue graph.
//   It projects to the exact CIE 170-2 MacLeod-Boynton boundary along the
//   fixed D65-relative hue ray while carrying nonnegative weighted L+M. The
//   graph applies the same constraint to each candidate contrast response.
//   None is the compatibility default.
// - `clip_point`, `hue_restore`, `white_curve_mode`, `adaptive_normalization`,
//   `bleaching_intensity`, `highlight_saturation`, and `gamut_hue_restore`
//   are retained for source compatibility but ignored.
float3 psychotm_test25(
    float3 bt709_linear_input,                      // linear BT.709 RGB
    float peak_value = 1000.f / 203.f,              // target RGB upper plane
    float exposure = 1.f,                           // linear scaling
    float highlights = 1.f,                         // scalar-Yf highlight grade
    float shadows = 1.f,                            // scalar-Yf shadow grade
    float contrast = 1.f,                           // anchor-matched contrast
    float purity_scale = 1.f,                       // adaptive-MB purity/contrast
    float bleaching_intensity = 1.f,                // ignored
    float clip_point = 100.f,                       // ignored
    float hue_restore = 1.f,                        // ignored
    float encoded_response_power = 1.f,             // encoded-domain power
    int white_curve_mode = 0,                       // ignored
    float cone_response_exponent = 1.f,             // contrast/purity response
    float3 current_adaptive_state_bt709 = 0.18f,    // input/adaptation anchor
    float3 current_background_state_bt709 = 0.18f,  // output/background anchor
    float gamut_compression = 1.f,                  // 0 per-cone; >0 legacy full hull
    int gamut_compression_mode = 1,                 // target: BT.709/BT.2020
    float adaptive_normalization = 1.f,             // ignored
    float compression = 0.f,                        // shoulder h; 0 = auto
    float highlight_saturation = 1.f,               // ignored
    float gamut_hue_restore = 0.f,                  // ignored
    int hue_method = PSYCHO25_HUE_METHOD_GRAPH,
    int hull_method = PSYCHO25_HULL_METHOD_REFERENCE_SCALE,
    int gamut_enforcement = PSYCHO25_GAMUT_ENFORCEMENT_LEGACY,
    int upper_hull_pivot = PSYCHO25_UPPER_HULL_PIVOT_BLACK,
    float upper_plane_shoulder_power = PSYCHO25_UPPER_PLANE_SHOULDER_POWER_MATCH_COMPRESSION,
    float guidance_peak_scale = PSYCHO25_DEFAULT_GUIDANCE_PEAK_SCALE,
    int input_pre_step = PSYCHO25_INPUT_PRESTEP_NONE,
    int observer_gamut_mode = PSYCHO25_OBSERVER_GAMUT_NONE,
    int post_compression_mode = PSYCHO25_POST_COMPRESSION_NONE,
    float canonical_pressure_pivot = PSYCHO25_CANONICAL_CYLINDER_DEFAULT_PIVOT,
    float canonical_pressure_contrast = PSYCHO25_CANONICAL_CYLINDER_DEFAULT_CONTRAST,
    float canonical_pressure_h = PSYCHO25_CANONICAL_CYLINDER_DEFAULT_H,
    float canonical_pressure_trade = PSYCHO25_CANONICAL_CYLINDER_DEFAULT_TRADE,
    float canonical_yf_bias_power = PSYCHO25_CANONICAL_YF_CONE_DEFAULT_BIAS_POWER) {
  float response_scale = cone_response_exponent;
  contrast *= response_scale;
  purity_scale *= response_scale;
  float safe_encoded_response_power = encoded_response_power;

  // The synthetic EXR stress chart contains binary16 infinities. Letting those
  // enter the LMS matrices creates NaNs, which bypass gamut/peak comparisons
  // and are later displayed at the presenter's safety clamp. Preserve their
  // signs at the largest finite binary16 value; map undefined NaNs to black.
  float3 exposed_bt709 = bt709_linear_input * exposure;
  float3 finite_bt709_input = renodx::math::ZeroNaN(exposed_bt709);
  finite_bt709_input = renodx::math::Select(
      isinf(finite_bt709_input),
      renodx::math::CopySign(65504.f.xxx, finite_bt709_input),
      finite_bt709_input);
  float3 lms_in =
      renodx::color::lms::from::BT709(finite_bt709_input);
  lms_in = psycho25_ApplyInputPreStep(lms_in, input_pre_step);
  float3 target_lms_peak =
      renodx::color::lms::from::BT709(float(peak_value).xxx);
  float3 current_adaptive_state_lms =
      renodx::color::lms::from::BT709(current_adaptive_state_bt709);
  float3 desired_background_state_lms =
      renodx::color::lms::from::BT709(current_background_state_bt709);

  // -------------------------------------------------------------------------
  // Anchor-matched adapted-D65 response.
  // input == anchor_in maps to anchor_out for any compression setting.
  // Test25 accepts these states from the caller; it does not estimate retinal
  // adaptation or bleaching internally.
  // -------------------------------------------------------------------------
  float3 anchor_in = current_adaptive_state_lms;
  float3 anchor_out = desired_background_state_lms;
  float contrast_power = contrast;

  // -------------------------------------------------------------------------
  // Achromatic highlight/shadow controls.
  // The ONOFF source is luminance-only. Evaluating the grading curves once on
  // Yf and applying a scalar gain to the complete LMS vector avoids an
  // unsupported independent L/M/S grade and its resulting hue rotation.
  // Cone signs are retained through authored hue and target containment.
  // -------------------------------------------------------------------------
  float3 graded_lms = abs(lms_in);
  float graded_yf = psycho25_YfFromLMS(graded_lms);
  float adapted_anchor_yf = psycho25_YfFromLMS(anchor_in);
  float graded_yf_out = psycho25_HighlightsScalarV4(
      graded_yf,
      highlights,
      adapted_anchor_yf);
  graded_yf_out = psycho25_ShadowsScalarV4(
      graded_yf_out,
      shadows,
      adapted_anchor_yf);
  graded_lms *= renodx::math::DivideSafe(
      graded_yf_out,
      graded_yf,
      1.f);
  graded_lms = renodx::math::CopySign(graded_lms, lms_in);

  // -------------------------------------------------------------------------
  // Purity delta in adaptive MB:
  //   purity_delta = purity / contrast
  // contrast == purity: no purity change.
  // purity > contrast: increase radius from adapted neutral.
  // purity < contrast: reduce radius toward adapted neutral.
  // -------------------------------------------------------------------------
  float purity_delta = renodx::math::DivideSafe(purity_scale, contrast_power, 1.f);
  float3 contrast_input = psycho25_ApplyAdaptiveMBPurity(
      graded_lms,
      anchor_in,
      purity_delta);

  // -------------------------------------------------------------------------
  // Anchor-matched contrast remains explicit before display compression so
  // source adaptive-MB direction/radius and the current rolloff-derived hue
  // field can be evaluated separately. The optional observer-gamut stage is
  // applied here, after contrast rather than as an input pre-step, and to the
  // corresponding post-contrast state of every numerical hue-graph candidate.
  // -------------------------------------------------------------------------
  float3 contrast_lms = psycho25_ApplyContrastResponse(
      contrast_input,
      anchor_in,
      anchor_out,
      contrast_power,
      observer_gamut_mode);

  // -------------------------------------------------------------------------
  // Display-compression shoulder parameter.
  // Positive `compression` is manual h; zero selects the centered-range auto
  // value. The helpers implement the slope-normalized formula documented
  // above. This resolved h parameterizes the no-gamut per-cone fallback and
  // the real-peak magnitude in target-plane mode. An automatic direction guide
  // resolves h again against its target-relative guidance endpoint; a positive
  // manual h remains shared. The upper-plane scalar shoulder matches the real-peak h by
  // default but can use its own positive h for diagnosis.
  // Its slope-normalized power first encodes an adapted cone-response state.
  // Sign-preserving encoded-response power is applied in that domain before
  // the rational shoulder generates the channel scale. Hue authoring carries
  // the measured adaptive-MB radius in both comparison modes.
  // -------------------------------------------------------------------------
  float target_compression_power = compression;
  if (compression == PSYCHO25_AUTO_COMPRESSION_SENTINEL) {
    target_compression_power =
        psycho25_AutoCompressionFromCenteredReferenceRange(
            psycho25_YfFromLMS(anchor_out),
            psycho25_YfFromLMS(target_lms_peak));
  }
  target_compression_power = max(
      target_compression_power,
      PSYCHO25_MIN_MANUAL_COMPRESSION);
  float resolved_upper_plane_shoulder_power = upper_plane_shoulder_power;
  if (upper_plane_shoulder_power
      == PSYCHO25_UPPER_PLANE_SHOULDER_POWER_MATCH_COMPRESSION) {
    resolved_upper_plane_shoulder_power = target_compression_power;
  }
  resolved_upper_plane_shoulder_power = max(
      resolved_upper_plane_shoulder_power,
      PSYCHO25_MIN_MANUAL_COMPRESSION);

  // -------------------------------------------------------------------------
  // Coupled authored-hue and device-hull stage. With any target plane active,
  // the per-cone guide uses a target-relative neutral Yf endpoint. At the 1x
  // default this is the same endpoint as regular per-channel compression. The
  // configured target peak remains the
  // actual upper cube plane. Numerical mode solves the hue graph; Fast60 uses
  // its direct angular midpoint with the source. Both retain the actual-peak
  // physical radius and discard carried scale before target support is solved.
  // Enabled target lower planes constrain adaptive-MB chrominance. Enabled
  // upper planes define one directional Yf limit, and one scalar shoulder maps
  // into it. This remains a single hull-ray solve, not the planned sectional
  // optimization over multiple candidate points.
  // -------------------------------------------------------------------------
  int normalized_target_gamut_mode = gamut_compression_mode == 0 ? 0 : 1;
  const bool use_psychov17_gamut = post_compression_mode
          == PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT
      || post_compression_mode
        == PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT_NEUTWO_MAX
      || post_compression_mode
        == PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT_NRG_WHITE;
  const bool use_psychov17_neutwo_peak = post_compression_mode
      == PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT_NEUTWO_MAX;
  const bool use_psychov17_nrg_white = post_compression_mode
      == PSYCHO25_POST_COMPRESSION_PSYCHOV17_GAMUT_NRG_WHITE;
  const bool use_adaptive_contrast_fit = post_compression_mode
      == PSYCHO25_POST_COMPRESSION_ADAPTIVE_CONTRAST_FIT;
  int resolved_gamut_enforcement = gamut_enforcement < 0
                                       ? (gamut_compression <= PSYCHO25_EPSILON
                                              ? PSYCHO25_GAMUT_ENFORCEMENT_NONE
                                              : PSYCHO25_GAMUT_ENFORCEMENT_FULL)
                                       : gamut_enforcement & PSYCHO25_GAMUT_ENFORCEMENT_FULL;
  Psycho25ConeResponseParameters target_cone_response =
      psycho25_PrepareConeResponseParameters(
          anchor_out,
          target_lms_peak,
          contrast_power,
          target_compression_power,
          safe_encoded_response_power);
  float3 signed_direction_source_lms = contrast_input;
  float3 output_lms;
  if (post_compression_mode >= PSYCHO25_POST_COMPRESSION_DIRECT
      && post_compression_mode <= PSYCHO25_POST_COMPRESSION_SOURCE_MB_SOFT_MAX
      && resolved_gamut_enforcement != PSYCHO25_GAMUT_ENFORCEMENT_NONE) {
    // Post experiments deliberately branch before every physical per-cone,
    // Graph/Fast60, and coupled-hull output operation. The optional observer
    // constraint remains an independent earlier stage through contrast_lms.
    output_lms = psycho25_ApplyIndependentPostCompression(
        contrast_lms,
        signed_direction_source_lms,
        anchor_out,
        current_adaptive_state_lms,
        peak_value,
        target_compression_power,
        normalized_target_gamut_mode,
        resolved_gamut_enforcement,
        post_compression_mode);
  } else if (resolved_gamut_enforcement
                 == PSYCHO25_GAMUT_ENFORCEMENT_NONE
             || use_psychov17_gamut
             || use_adaptive_contrast_fit) {
    // No-gamut mode retains the direct per-channel LMS compressor. The
    // PsychoV17 option deliberately starts from this same complete Test25
    // physical/hue result before its separate final primary-gamut map.
    output_lms = psycho25_ApplyPhysicalPerConePath(
        contrast_lms,
        signed_direction_source_lms,
        current_adaptive_state_lms,
        anchor_in,
        anchor_out,
        target_lms_peak,
        contrast_power,
        target_cone_response,
        hue_method,
        observer_gamut_mode);
  } else if (hull_method == PSYCHO25_HULL_METHOD_TARGET_RGB_CLIP) {
    // Clip remains the literal component-clamp comparison applied to the
    // ordinary physical/Graph result. It is intentionally distinct from the
    // independent post-contrast experiments above.
    output_lms = psycho25_ApplyPhysicalPerConePath(
        contrast_lms,
        signed_direction_source_lms,
        current_adaptive_state_lms,
        anchor_in,
        anchor_out,
        target_lms_peak,
        contrast_power,
        target_cone_response,
        hue_method,
        observer_gamut_mode);
    float3 post_target_rgb = psycho25_TargetRGBFromLMS(
        output_lms,
        normalized_target_gamut_mode);
    if ((resolved_gamut_enforcement
         & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0) {
      post_target_rgb = max(post_target_rgb, 0.f.xxx);
    }
    if ((resolved_gamut_enforcement
         & PSYCHO25_GAMUT_ENFORCEMENT_PEAK) != 0) {
      post_target_rgb = min(post_target_rgb, peak_value.xxx);
    }
    output_lms = psycho25_LMSFromTargetRGB(
        post_target_rgb,
        normalized_target_gamut_mode);
  } else {
    // Target-plane mode uses the requested primary and/or peak constraints.
    // The per-channel curve remains the direct output compressor only in the
    // disabled branch above. Here the complete no-gamut result supplies only
    // the adaptive-MB trajectory; its scale is discarded before target-plane
    // correction, so it is not a second output curve. Guidance direction and
    // its cone-response state remain separate from physical target magnitude.
    float target_peak_yf = psycho25_SignedYfFromLMS(target_lms_peak);
    float resolved_guidance_peak_yf = psycho25_ResolveGuidancePeakYf(
      target_peak_yf,
      guidance_peak_scale);
    float3 guidance_lms_peak =
      target_lms_peak * (resolved_guidance_peak_yf / target_peak_yf);
    float guidance_compression_power = target_compression_power;
    if (compression == PSYCHO25_AUTO_COMPRESSION_SENTINEL) {
      guidance_compression_power =
          psycho25_AutoCompressionFromCenteredReferenceRange(
              psycho25_YfFromLMS(anchor_out),
              resolved_guidance_peak_yf);
    }
    Psycho25ConeResponseParameters guidance_cone_response =
        psycho25_PrepareConeResponseParameters(
            anchor_out,
            guidance_lms_peak,
            contrast_power,
            guidance_compression_power,
            safe_encoded_response_power);
    output_lms = psycho25_CompressTargetHull(
        contrast_lms,
        signed_direction_source_lms,
        current_adaptive_state_lms,
        anchor_in,
        anchor_out,
        target_lms_peak,
        guidance_lms_peak,
        contrast_power,
        resolved_upper_plane_shoulder_power,
        target_cone_response,
        guidance_cone_response,
        peak_value,
        normalized_target_gamut_mode,
        resolved_gamut_enforcement,
        hue_method,
        hull_method,
        upper_hull_pivot,
        canonical_pressure_pivot,
        canonical_pressure_contrast,
        canonical_pressure_h,
        canonical_pressure_trade,
        canonical_yf_bias_power,
        observer_gamut_mode);
  }

  if (post_compression_mode
      == PSYCHO25_POST_COMPRESSION_SOURCE_BT709_RESIDUAL) {
    output_lms = psycho25_RestoreSourceBT709ResidualDirection(
        output_lms,
        signed_direction_source_lms,
        peak_value,
        normalized_target_gamut_mode,
        resolved_gamut_enforcement);
  } else if (use_adaptive_contrast_fit) {
    output_lms = psycho25_ApplyAdaptiveContrastFit(
        output_lms,
        contrast_lms,
        signed_direction_source_lms,
        current_adaptive_state_lms,
        anchor_in,
        anchor_out,
        target_lms_peak,
        contrast_power,
        target_cone_response,
        hue_method,
        peak_value,
        normalized_target_gamut_mode,
        resolved_gamut_enforcement,
        observer_gamut_mode);
  } else if (use_psychov17_gamut) {
    if (gamut_compression != 0.f) {
      // Match PsychoV17's final device map exactly on the completed physical
      // output before any experiment-specific peak operation.
      output_lms = psycho25_GamutCompressLMSBoundAdaptive(
          output_lms,
          current_adaptive_state_lms,
          normalized_target_gamut_mode,
          gamut_compression);
    }
    if (use_psychov17_neutwo_peak) {
      // Retain the physical/Graph trajectory as direction so positive hue rays
      // still converge to white. Derive only scalar magnitude from the
      // unbounded post-contrast signal after the same PsychoV17 primary map;
      // applying Neutwo directly to the already bounded physical magnitude
      // would cap neutral at peak/sqrt(2).
      float3 target_rgb = psycho25_TargetRGBFromLMS(
          output_lms,
          normalized_target_gamut_mode);
      float3 magnitude_lms = contrast_lms;
      if (gamut_compression != 0.f) {
        magnitude_lms = psycho25_GamutCompressLMSBoundAdaptive(
            magnitude_lms,
            current_adaptive_state_lms,
            normalized_target_gamut_mode,
            gamut_compression);
      }
      float3 magnitude_target_rgb = psycho25_TargetRGBFromLMS(
          magnitude_lms,
          normalized_target_gamut_mode);
      if ((resolved_gamut_enforcement
           & PSYCHO25_GAMUT_ENFORCEMENT_PRIMARIES) != 0) {
        target_rgb = max(target_rgb, 0.f.xxx);
        magnitude_target_rgb = max(magnitude_target_rgb, 0.f.xxx);
      }
      float direction_max_channel = renodx::math::Max(abs(target_rgb));
      float magnitude_max_channel = renodx::math::Max(
          abs(magnitude_target_rgb));
      float3 anchor_target_rgb = psycho25_TargetRGBFromLMS(
          anchor_out,
          normalized_target_gamut_mode);
      float anchor_max_channel = min(
          renodx::math::Max(abs(anchor_target_rgb)),
          peak_value - PSYCHO25_EPSILON);
      float anchor_input_max = renodx::tonemap::inverse::Neutwo(
          anchor_max_channel,
          peak_value);
        float mapped_max_channel = renodx::tonemap::Neutwo(
          magnitude_max_channel * renodx::math::DivideSafe(
            anchor_input_max,
            anchor_max_channel,
            1.f),
          peak_value);
        target_rgb *= renodx::math::DivideSafe(
          mapped_max_channel,
          direction_max_channel,
          1.f);
      output_lms = psycho25_LMSFromTargetRGB(
          target_rgb,
          normalized_target_gamut_mode);
    } else if (use_psychov17_nrg_white) {
        // Retain the completed output's ACC-A scalar metric while replacing an
        // over-peak selected-target RGB point with an in-cube point between its
        // max-channel hue wall and peak D65 white. ACC-A here is an engineering
        // scalar metric inherited from NRG Test7, not radiometric energy.
        float3 target_rgb = max(
          psycho25_TargetRGBFromLMS(
            output_lms,
            normalized_target_gamut_mode),
          0.f.xxx);
        float max_target_channel = max(
          target_rgb.x,
          max(target_rgb.y, target_rgb.z));
        if (max_target_channel > peak_value) {
        float3 target_bt2020 = normalized_target_gamut_mode == 0
          ? renodx::color::bt2020::from::BT709(target_rgb)
          : target_rgb;
        float3 hue_wall_target_rgb = target_rgb
          * (peak_value / max_target_channel);
        float3 hue_wall_bt2020 = normalized_target_gamut_mode == 0
          ? renodx::color::bt2020::from::BT709(hue_wall_target_rgb)
          : hue_wall_target_rgb;
        float scalar_output_raw;
        target_bt2020 = renodx::tonemap::nrg::NRGTest7SolveWhiteSpillByScalarAccA(
          hue_wall_bt2020,
          peak_value,
          renodx::tonemap::nrg::NRGTest7ScalarAccARaw(
            target_bt2020,
            peak_value),
          scalar_output_raw);
        target_rgb = normalized_target_gamut_mode == 0
          ? renodx::color::bt709::from::BT2020(target_bt2020)
          : target_bt2020;
        }
        output_lms = psycho25_LMSFromTargetRGB(
          target_rgb,
          normalized_target_gamut_mode);
    }
  }

  return renodx::color::bt709::from::LMS(output_lms);
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_PSYCHOV_TEST25_HLSL_
