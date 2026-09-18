#ifndef RENODX_SHADERS_TONEMAP_PSYCHOV_TEST22_HLSL_
#define RENODX_SHADERS_TONEMAP_PSYCHOV_TEST22_HLSL_

#include "../../color.hlsl"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx {
namespace tonemap {
namespace psychov {

// Shared numerical guards for this experimental tone mapper.
static const float PSYCHO22_EPSILON = 1e-6f;

// Auto-compression reference.
// Simultaneous luminance dynamic range is stimulus- and method-dependent.
// The constants below document the published values considered for the
// automatic compression reference:
//   - Kunkel & Reinhard, APGV 2010, doi:10.1145/1836248.1836251:
//       ~3.7 log10 units under their adapted test conditions.
//   - Jiang & Fairchild, JIST 2021,
//       doi:10.2352/J.ImagingSci.Technol.2021.65.5.050401:
//       direct bright/dark simultaneous measurements on an Apple Pro Display
//       XDR setup reported ~3.3 log10 units for the average observer and
//       3.47 log10 units for OBS1 at 1600 cd/m^2, 3.4 deg stimulus size.
//       Their spatial-frequency fit reports DRmax values of 3.24 log10 at
//       452 cd/m^2 and 3.40 log10 at 1600 cd/m^2. The display apparatus used
//       diffuse white = 50 cd/m^2 and peak luminance = 1600 cd/m^2.
//
// Default choice:
//   Use Kunkel/Reinhard's 3.7 value as the conservative reference. A larger
//   reference range increases auto h on low-headroom displays, reducing the
//   symmetric curve's OFF/shadow-side bending. Use the Jiang/Fairchild average
//   value if a more direct-display, glare-inclusive target is desired.
//
// Model choice:
//   For a neutral static curve, treat the adapted/background state as the log
//   midpoint of the chosen total range. This assigns half the log range above
//   adaptation and half below adaptation. This is a neutral log-domain prior,
//   not a claim that biological ON/OFF pathways are exactly symmetric.
//
// For the slope-normalized shoulder below, the deep OFF-side slope ratio is:
//   S_shadow / contrast = 1 / (1 - pow(anchor_out / peak, h))
// Auto compression solves:
//   h = (reference_range_log10 / 2) / log10(peak / anchor_out)
// which is equivalent to choosing:
//   pow(anchor_out / peak, h) = pow(10, -(reference_range_log10 / 2))
// The implied OFF-side slope ratio is therefore computed from the selected
// reference range rather than from a separate decimal tolerance.
static const float PSYCHO22_REFERENCE_KUNKEL_REINHARD_2010_LOG10 = 3.7f;
static const float PSYCHO22_REFERENCE_JIANG_FAIRCHILD_2021_AVERAGE_LOG10 = 3.3f;
static const float PSYCHO22_REFERENCE_JIANG_FAIRCHILD_2021_OBS1_LOG10 = 3.47f;
static const float PSYCHO22_REFERENCE_JIANG_FAIRCHILD_2021_FIT_452_LOG10 = 3.24f;
static const float PSYCHO22_REFERENCE_JIANG_FAIRCHILD_2021_FIT_1600_LOG10 = 3.40f;
static const float PSYCHO22_REFERENCE_SIMULTANEOUS_RANGE_LOG10 =
    PSYCHO22_REFERENCE_KUNKEL_REINHARD_2010_LOG10;
static const float PSYCHO22_REFERENCE_CENTERED_RANGE_SIDE_COUNT = 2.f;
static const float PSYCHO22_HEADROOM_RATIO_FALLBACK = 1.f;
static const float PSYCHO22_MIN_AUTO_COMPRESSION = 1.f;
static const float PSYCHO22_MIN_MANUAL_COMPRESSION = 1e-6f;
static const float PSYCHO22_AUTO_COMPRESSION_SENTINEL = 0.f;

float psycho22_YfFromLMS(float3 lms) {
  float3 weighted_lms = renodx::color::macleod_boynton::WeighLMS(lms);
  return max(weighted_lms.x + weighted_lms.y, PSYCHO22_EPSILON);
}

float psycho22_AutoCompressionFromCenteredReferenceRange(float anchor_out_yf, float peak_yf) {
  float peak_over_anchor = renodx::math::DivideSafe(
      max(peak_yf, PSYCHO22_EPSILON),
      max(anchor_out_yf, PSYCHO22_EPSILON),
      PSYCHO22_HEADROOM_RATIO_FALLBACK);

  peak_over_anchor = max(peak_over_anchor, 1.f + PSYCHO22_EPSILON);

  float reference_one_side_range_log10 =
      PSYCHO22_REFERENCE_SIMULTANEOUS_RANGE_LOG10 /
      PSYCHO22_REFERENCE_CENTERED_RANGE_SIDE_COUNT;

  float actual_above_adaptation_range_log10 =
      max(log10(peak_over_anchor), PSYCHO22_EPSILON);

  float h =
      reference_one_side_range_log10 /
      actual_above_adaptation_range_log10;

  return max(h, PSYCHO22_MIN_AUTO_COMPRESSION);
}

float3 psycho22_ToAdaptiveRelativeWeightedLMS(float3 lms_input, float3 current_adaptive_state_lms) {
  return renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(lms_input),
      current_adaptive_state_lms,
      0.f.xxx);
}

float3 psycho22_FromAdaptiveRelativeWeightedLMS(
    float3 lms_weighted_relative,
    float3 current_adaptive_state_lms) {
  return lms_weighted_relative * max(current_adaptive_state_lms, 1e-6f.xxx);
}

float3 psycho22_GamutCompressAdaptiveRelativeWeightedLMSBound(
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

float3 psycho22_AdaptiveRelativeWeightedNeutral() {
  // In psycho22_ToAdaptiveRelativeWeightedLMS():
  //   adapted background LMS -> WeighLMS(adapted) / adapted = LMS_WEIGHTS
  return renodx::color::macleod_boynton::WeighLMS(1.f.xxx);
}

float3 psycho22_ACCFromAdaptiveRelativeWeightedDelta(float3 delta_lms_w) {
  float3 neutral_w = psycho22_AdaptiveRelativeWeightedNeutral();

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

float psycho22_PurpleComplementaryGateFromACC(float3 acc) {
  float rg = acc.y;
  float yv = acc.z;

  float chroma = max(length(acc.yz), 1e-6f);

  float rg_pos = saturate(rg / chroma);
  float yv_pos = saturate(yv / chroma);

  float mixed = saturate(
      min(abs(rg), abs(yv)) / max(max(abs(rg), abs(yv)), 1e-6f));

  return saturate(2.f * rg_pos * yv_pos * mixed);
}

float3 psycho22_ApplyAdaptiveMBPurity(
    float3 lms_input,
    float3 adaptive_neutral_lms,
    float purity_delta) {
  if (abs(purity_delta - 1.f) <= 1e-5f) {
    return lms_input;
  }

  float3 relative_weighted =
      psycho22_ToAdaptiveRelativeWeightedLMS(
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
          purity_delta);

  float3 relative_weighted_out =
      renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
          float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(
      psycho22_FromAdaptiveRelativeWeightedLMS(
          relative_weighted_out,
          adaptive_neutral_lms));
}

// psychov-22
//
// Objective:
// psychov-22 first targets the observer-side bend of the scene:
// - what state the eye adapts to,
// - how the scene is converted to contrast around that adapted state,
// - how the response is shaped around that adapted state,
// - which nonlinear curve applies at each stage.
// The human observer is not a linear gain system, so the first job of this
// test is to model how a cone/adaptation/opponent/normalization cascade bends
// scene light before any device mapping is considered.
//
// psychov-22 therefore treats the problem as two coupled but distinct systems:
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
//    observers. The transform should therefore be understood as an
//    average-observer receptor basis unless those filters are modeled
//    explicitly.
//    Reference: CVRL background hub; "Macular and lens pigments"
//    (http://www.cvrl.org/background.htm,
//     http://www.cvrl.org/database/text/intros/intromaclens.htm).
//    MacLeod-Boynton is important here: it is not itself the cortical flow,
//    but a weighted cone-chromaticity representation in an equal-luminance
//    plane with a separately carried achromatic scale term. In implementation notation:
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
//      CIE / CVRL physiological functions; Psychtoolbox LMSToMacBoyn; the
//      stockman_macleod_boynton.hlsl wiring.
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
//    the background responses L0 / M0 / S0 in Mantiuk et al. For this model, the
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
//    anchor. In color/bleaching.hlsl this is implemented as
//    per-cone attenuation of LMS deltas around a white-at-achromatic-level
//    anchor, so availability -> 0 drives the response toward equal white at the
//    same carried achromatic level. That is the rendering interpretation of the "intensely bright tends
//    to bleach to white" behavior.
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
//    - The final white-relative application used here is the rendering
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
//    Split increments and decrements around the adapted/background state with
//    half-wave rectification before the pooled gain stage. The split is around
//    adaptation, not diffuse white. Modern retina work also shows that ON and
//    OFF-pathway nonlinearities can cancel in natural images, yielding a more
//    linear effective response than a single static saturating curve would
//    suggest. For this file, ON/OFF therefore constrains where the adapted
//    neutral lies and why the OFF side should remain close to the requested
//    contrast slope; it is not used as a hard branch in the default curve.
//    References: Schiller (1992); Yu, Turner, Baudin & Rieke,
//    eLife 2022, 11:e70611, doi:10.7554/eLife.70611.
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
//    valid out-of-hull destination. Diffuse/reference white, adapted neutral,
//    and display peak are separate anchors. ITU-R BT.2408's HDR Reference White
//    framing is the practical video reference for keeping diffuse white below
//    specular/display peak.
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
// 7b) Smooth auto-compression heuristic:
//    The compression shoulder remains a single smooth, slope-normalized curve
//    centered on the adapted state. When compression == 0, h is derived from
//    the selected simultaneous-range reference above:
//      one side around adaptation = reference_range_log10 / 2
//      h = (reference_range_log10 / 2) / log10(peak / anchor_out)
//    This is equivalent to choosing:
//      pow(anchor_out / peak, h) = pow(10, -(reference_range_log10 / 2))
//    and, for this slope-normalized curve:
//      S_shadow = contrast / (1 - pow(anchor_out / peak, h))
//    Therefore the OFF/shadow-side slope error is derived from the selected
//    reference range instead of from a separate tolerance constant. Manual
//    compression values remain exact; only compression == 0 enables auto mode.
//    References: Kunkel & Reinhard, APGV 2010, doi:10.1145/1836248.1836251;
//    Jiang & Fairchild, JIST 2021,
//    doi:10.2352/J.ImagingSci.Technol.2021.65.5.050401.
//
// Mermaid source map of model inputs, derived states, and outputs:
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
// Implementation scope:
// - The caller supplies the adapted source state and desired output background
//   state. Neutral defaults are 0.18 / 0.18 so ordinary non-adapting content is
//   not moved by the adaptation anchors.
// - The receptor basis is an average-observer, mainly foveal Stockman / CVRL
//   basis with standard prereceptoral lens and macular filtering folded into
//   the functions; it is not a personalized observer model.
// - Scalar defaults are normalized rendering controls, not fitted physiological
//   constants.
// - Device-hull mapping remains separate from the observer-domain response.

float3 psychotm_test22(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,                           // linear scaling
    float highlights = 1.f,                         // LMS highlight grade
    float shadows = 1.f,                            // LMS shadow grade
    float contrast = 1.f,                           // purity-retaining contrast
    float purity_scale = 1.f,                       // purity-contrast
    float bleaching_intensity = 1.f,                // reserved
    float clip_point = 100.f,                       // reserved
    float hue_restore = 1.f,                        // reserved
    float adaptation_contrast = 1.f,                // deprecated, use contrast+purity
    int white_curve_mode = 0,                       // deprecated
    float cone_response_exponent = 1.f,             // simplified contrast+purity scale
    float3 current_adaptive_state_bt709 = 0.18f,    // anchor-in
    float3 current_background_state_bt709 = 0.18f,  // anchor-out
    float gamut_compression = 1.f,                  // gamut compression lerp
    int gamut_compression_mode = 1,                 // BT709/BT2020
    float adaptive_normalization = 1.f,             // deprecated
    float compression = 1.f                         // curve-to-white pow; 0 = auto
) {
  float legacy_response_scale = cone_response_exponent * adaptation_contrast;
  contrast *= legacy_response_scale;
  purity_scale *= legacy_response_scale;

  float3 lms_in = renodx::color::lms::from::BT709(bt709_linear_input * exposure);
  float3 lms_peak = renodx::color::lms::from::BT709(float(peak_value).xxx);
  float3 current_adaptive_state_lms = renodx::color::lms::from::BT709(current_adaptive_state_bt709);
  float3 desired_background_state_lms = renodx::color::lms::from::BT709(current_background_state_bt709);

  float3 lms_cones = lms_in;

  // Stage 1 intentionally leaves luminosity and bleaching neutral.
  // Shadows, highlights, purity, contrast, and compression are handled in LMS below.
  float3 anchor_in = max(current_adaptive_state_lms, 1e-6f.xxx);
  float3 anchor_out = max(desired_background_state_lms, 1e-6f.xxx);

  // ---------------------------------------------------------------------------
  // Anchor-matched adapted-D65 response:
  //   input == anchor_in maps to anchor_out for any compression shoulder.
  // ---------------------------------------------------------------------------

  float contrast_power = max(contrast, 1e-6f);

  // ---------------------------------------------------------------------------
  // PsychoV17-style highlight / shadow controls, applied per LMS cone.
  // This keeps the test22 all-LMS path instead of scaling LMS by a Yf ratio.
  // ---------------------------------------------------------------------------

  float3 graded_lms = abs(lms_cones);
  if (highlights != 1.f) {
    float3 ratio_abs = abs(renodx::math::DivideSafe(graded_lms, anchor_in, 0.f.xxx));
    if (highlights > 1.f) {
      graded_lms = max(
          graded_lms,
          lerp(
              graded_lms,
              anchor_in * pow(ratio_abs, highlights),
              graded_lms));
    } else {
      graded_lms = min(
          graded_lms,
          renodx::math::DivideSafe(
              graded_lms,
              1.f + anchor_in * pow(ratio_abs, 2.f - highlights) - graded_lms,
              graded_lms));
    }
  }
  if (shadows != 1.f) {
    float3 ratio_abs = abs(renodx::math::DivideSafe(graded_lms, anchor_in, 0.f.xxx));
    if (shadows > 1.f) {
      graded_lms = max(
          graded_lms,
          graded_lms * (1.f + renodx::math::DivideSafe(graded_lms * anchor_in, pow(ratio_abs, shadows), 0.f.xxx)));
    } else {
      graded_lms = clamp(
          graded_lms * (1.f - renodx::math::DivideSafe(graded_lms * anchor_in, pow(ratio_abs, 2.f - shadows), 0.f.xxx)),
          0.f.xxx,
          graded_lms);
    }
  }

  // ---------------------------------------------------------------------------
  // Purity delta:
  // Apply purity to cone magnitudes before the anchor-matched contrast curve.
  //
  // purity_delta = purity / contrast
  //
  // If contrast == purity, no purity math is applied.
  // If purity > contrast, increase MB purity before saturation.
  // If purity < contrast, reduce MB purity before saturation.
  // ---------------------------------------------------------------------------

  float purity_delta =
      renodx::math::DivideSafe(
          max(purity_scale, 1e-6f),
          contrast_power,
          1.f);

  float3 contrast_input =
      psycho22_ApplyAdaptiveMBPurity(
          graded_lms,
          anchor_in,
          purity_delta);

  float3 response_source_lms = renodx::math::CopySign(
      contrast_input,
      lms_cones);

  // ---------------------------------------------------------------------------
  // Compression / saturation shoulder with slope-normalized contrast.
  //
  // Manual path, compatibility default:
  //   compression > 0: h = compression
  //
  // Auto path:
  //   compression == 0:
  //     h = (PSYCHO22_REFERENCE_SIMULTANEOUS_RANGE_LOG10 / 2)
  //         / log10(peak / anchor_out)
  //
  // Auto uses the selected simultaneous-range reference as a centered, neutral
  // static-curve heuristic: half of the log span above adaptation, half below
  // adaptation. This keeps the single smooth curve while raising h for
  // low-headroom SDR, so the OFF/shadow side remains close to contrast_power
  // without a hard ON/OFF branch.
  //
  // Curve:
  //   n = contrast / (1 - pow(anchor_out / peak, h))
  //   q = pow(input / anchor_in, n * h)
  //   saturated = peak * pow(q / (q + pow(peak / anchor_out, h) - 1), 1 / h)
  //
  // Shadow-side asymptotic log slope:
  //   S_shadow = contrast / (1 - pow(anchor_out / peak, h))
  //
  // Auto implied OFF-side slope ratio:
  //   S_shadow / contrast =
  //     1 / (1 - pow(10, -(PSYCHO22_REFERENCE_SIMULTANEOUS_RANGE_LOG10 / 2)))
  // ---------------------------------------------------------------------------

  float h = compression;
  if (compression == PSYCHO22_AUTO_COMPRESSION_SENTINEL) {
    h = psycho22_AutoCompressionFromCenteredReferenceRange(
        psycho22_YfFromLMS(anchor_out),
        psycho22_YfFromLMS(lms_peak));
  }

  h = max(h, PSYCHO22_MIN_MANUAL_COMPRESSION);
  float h_rcp = rcp(h);

  float3 anchor_over_peak = anchor_out / max(lms_peak, PSYCHO22_EPSILON.xxx);
  float3 slope_norm = 1.f - pow(max(anchor_over_peak, PSYCHO22_EPSILON.xxx), h);
  float3 n = contrast_power / max(slope_norm, PSYCHO22_EPSILON.xxx);

  float3 q =
      pow(
          max(contrast_input / anchor_in, PSYCHO22_EPSILON.xxx),
          n * h);

  float3 shoulder =
      pow(max(lms_peak / anchor_out, PSYCHO22_EPSILON.xxx), h) - 1.f;

  float3 saturated =
      lms_peak * pow(q / max(q + shoulder, PSYCHO22_EPSILON.xxx), h_rcp);

  float3 display_scaled =
      renodx::math::CopySign(
          saturated,
          response_source_lms);

  float3 display_scaled_relative_weighted = psycho22_ToAdaptiveRelativeWeightedLMS(
      display_scaled,
      current_adaptive_state_lms);

  float3 source_relative_w =
      psycho22_ToAdaptiveRelativeWeightedLMS(
          response_source_lms,
          current_adaptive_state_lms);

  float3 neutral_w = psycho22_AdaptiveRelativeWeightedNeutral();
  float neutral_yf = max(neutral_w.x + neutral_w.y, 1e-6f);
  float2 mb_neutral_xy = neutral_w.xz * rcp(neutral_yf);

  // -----------------------------------------------------------------------------
  // psychov17-style hue restore.
  // Restores MB hue direction, not max-channel LMS direction.
  // Keeps display target radius and MB.y carrier.
  // -----------------------------------------------------------------------------

  {
    float2 source_offset =
        source_relative_w.xz
            * renodx::math::DivideSafe(
                1.f,
                max(source_relative_w.x + source_relative_w.y, 0.f),
                0.f)
        - mb_neutral_xy;

    float target_y =
        max(display_scaled_relative_weighted.x + display_scaled_relative_weighted.y, 0.f);

    float2 target_offset =
        display_scaled_relative_weighted.xz
            * renodx::math::DivideSafe(1.f, target_y, 0.f)
        - mb_neutral_xy;

    float target_radius2 = dot(target_offset, target_offset);
    float target_radius = target_radius2 * rsqrt(max(target_radius2, 1e-7f));

    float2 blended_offset = lerp(
        target_offset,
        source_offset * (target_radius * rsqrt(max(dot(source_offset, source_offset), 1e-7f))),
        0.5f);

    blended_offset *= target_radius * rsqrt(max(dot(blended_offset, blended_offset), 1e-7f));

    // Keep display target radius and y_MB; only replace hue direction.
    display_scaled_relative_weighted =
        renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
            float3(
                mb_neutral_xy + blended_offset,
                target_y));
  }

  // -----------------------------------------------------------------------------
  // M-cone crosstalk as MB hue-direction bias.
  // Apply after NR-to-white + v17 MB hue restore.
  // Does NOT rebuild max-channel magnitude.
  // Does NOT transfer L/S into M directly.
  // Does NOT move neutral/white.
  // -----------------------------------------------------------------------------

  {
    float3 source_acc =
        psycho22_ACCFromAdaptiveRelativeWeightedDelta(
            source_relative_w - neutral_w)
        / neutral_yf;

    // Source-side cone drive decides whether M-bias is plausible.
    float3 drive =
        abs(response_source_lms) / max(current_adaptive_state_lms, 1e-6f.xxx);

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
        psycho22_PurpleComplementaryGateFromACC(source_acc);

    float spectral_confidence =
        1.f - max(cone_complementary_gate, acc_complementary_gate);

    // L/M overlap is closer than S/M. S gets only a very small bias.
    // Also require some M participation for L-bias so extreme pure-L does not
    // over-rotate.
    float lm_share = renodx::math::DivideSafe(
        drive.y,
        max(drive.x + drive.y, 1e-6f),
        0.f);

    float l_bias =
        saturate(l_over_m / max(drive.x, 1e-6f))
        * saturate(lm_share / 0.25f);

    float s_bias = 0.15f * saturate(s_over_m / max(drive.z, 1e-6f));

    float m_bias_weight =
        spectral_confidence * (0.12f * l_bias + 0.025f * s_bias);

    float target_y =
        max(display_scaled_relative_weighted.x + display_scaled_relative_weighted.y, 0.f);

    float2 target_offset =
        display_scaled_relative_weighted.xz
            * renodx::math::DivideSafe(1.f, target_y, 0.f)
        - mb_neutral_xy;

    float target_radius2 = dot(target_offset, target_offset);
    float target_radius = target_radius2 * rsqrt(max(target_radius2, 1e-7f));

    // Pure-M weighted LMS maps to MB.xy = 0.
    float2 m_offset = -mb_neutral_xy;

    float2 bent_offset = lerp(
        target_offset,
        m_offset * (target_radius * rsqrt(max(dot(m_offset, m_offset), 1e-7f))),
        saturate(m_bias_weight));

    bent_offset *= target_radius * rsqrt(max(dot(bent_offset, bent_offset), 1e-7f));

    // Preserve target radius and y_MB. Only bend hue direction.
    display_scaled_relative_weighted =
        renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
            float3(
                mb_neutral_xy + bent_offset,
                target_y));
  }

  if (gamut_compression != 0.f) {
    if (gamut_compression_mode == 0) {
      display_scaled_relative_weighted = psycho22_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    } else if (gamut_compression_mode == 1) {
      display_scaled_relative_weighted = psycho22_GamutCompressAdaptiveRelativeWeightedLMSBound(
          display_scaled_relative_weighted,
          current_adaptive_state_lms,
          renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
          gamut_compression);
    }
  }
  // Scale back from first-site adaptation;
  return renodx::color::bt709::from::LMS(
      renodx::color::macleod_boynton::UnweighLMS(
          psycho22_FromAdaptiveRelativeWeightedLMS(
              display_scaled_relative_weighted,
              current_adaptive_state_lms)));
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_PSYCHOV_TEST22_HLSL_
