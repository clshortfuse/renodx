#ifndef PSYCHOV_CUSTOMTEST30_HLSLI_
#define PSYCHOV_CUSTOMTEST30_HLSLI_

#include "../common.hlsli"

/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

namespace renodx {
namespace tonemap {
namespace psychov {

// PsychoV30: selected Mean-A2 / physiological-Yf response
// =========================================================
//
// Signal contract
// ---------------
// Input and output are direct linear-light BT.709 RGB with D65 white.
// `peak_value` expresses display peak in reference-white-relative units.
// The target volume is the normalized linear BT.709 RGB cube for mode 0 or
// the normalized linear BT.2020 RGB cube for every other mode. Output remains
// represented as linear BT.709 even when the constrained target is BT.2020.
//
// Scientific basis and engineering stages
// ---------------------------------------
// - RGB is transformed to the Stockman/CVRL two-degree LMS basis.
// - The achromatic coordinate is physiological Yf from the
//   Stockman-Sharpe LMS-to-XfYfZf transform:
//
//       Yf = cL * L + cM * M
//
//   Yf is the relative observer coordinate formed by weighted L and M cone
//   responses.
// - Purity is direct LMS interpolation toward the adapting neutral while
//   retaining the adaptation-relative Yf coordinate. It does not require
//   MacLeod-Boynton coordinates or short-wave weighting.
// - CIE 170-2 weighted MacLeod-Boynton chromaticity is isolated to the signed
//   fallback's source-boundary continuation. Its metric remains a successor
//   candidate for replacement by a coordinate consistent with the A2 path.
// - Adaptation-relative cone ratios are consistent with the early-cone
//   background-normalization framework discussed by Stockman and Brainard.
// - The finite endpoint, Mean-A2 direction, and locked-direction target-cube
//   projection are the rendering-response and device-mapping stages.
//
// Positive-cone response
// ----------------------
// Let q_i = LMS_i / anchor_in_i, P_i = peak_value * D65_LMS_i,
// p = contrast * cone_response_exponent, and
// k_i = pow(anchor_out_i / P_i, h). Test30 evaluates:
//
//   beta_i = p * h / (1 - k_i)
//   e_i    = 1 / (1 + (1 / k_i - 1) * pow(q_i, -beta_i))
//   u_i    = pow(e_i, 1 / h)
//
// The conceptual response is P_i * u_i. The reciprocal form remains finite
// when the corresponding positive power overflows. It preserves
// anchor_in -> anchor_out, has
// adaptation-point logarithmic slope p, approaches zero as q -> 0, and
// approaches selected peak white as q -> infinity.
//
// Mean-A2 direction
// -----------------
// A2 denotes this shader's internal orthonormal cone-opponent plane. For
// normalized cone load u:
//
//   X  = (uL - uM) / sqrt(2)
//   C0 = (uL + uM + uS) / sqrt(3)
//   Z  = (2 * uS - uL - uM) / sqrt(6)
//
// Source A2 direction comes from adaptation-relative q; response A2 direction
// comes from peak-relative post-G u. Normalizing and adding the two directions
// gives their exact angular bisector. Test30 retains the response A2 radius
// and C0, replacing direction only.
//
// Exact target solve
// ------------------
// With D65 Yf fractions alphaL + alphaM = 1, the normalized physiological
// coordinate represented by (X, C0, Z) is:
//
//   A = C0 / sqrt(3) + (alphaL - alphaM) * X / sqrt(2)
//       - Z / sqrt(6)
//
// Target RGB is affine in A, X, and Z. Locking the authored A2 direction and
// scaling (X, Z) by s makes all lower/upper RGB-cube planes and the response
// Yf ceiling linear inequalities in (C0, s). The feasible set is a convex
// polygon. Segment projection uses
//
//   distance^2 = delta_C0^2 + (X^2 + Z^2) * delta_s^2
//
// which is exactly Euclidean distance in the original (X, C0, Z) coordinate
// under the locked direction. Full compression analytically finds the nearest
// point inside this fixed-direction model's four-edge feasible polygon.
//
// Cone states containing zero or negative values use the separately documented
// signed linear-A2 fallback with analytic target RGB-cube ray support.
//
// PsychoV research record
// =======================
//
// This record is carried forward through PsychoV tests so each successor keeps
// the scientific rationale, source attribution, selected implementation, and
// next research directions beside the shader that ships. Test30 extends the
// Test17-Test25 record with Mean-A2 response authoring and an exact
// fixed-direction device-cube projection.
//
// Research objective and system boundary
// --------------------------------------
// PsychoV studies two coupled systems:
//
// 1. Observer-side organization: receptor coordinates, adaptation-relative
//    cone state, achromatic and opponent coordinates, response shaping, and
//    visibility/gain mechanisms supported by vision research.
// 2. Device-hull mapping: a joint tone, direction, and target-volume solve
//    constrained by display primaries, white, reference-white scale, and peak.
//
// Test30's selected rendering pipeline is:
//
//   linear-light BT.709
//     -> Stockman/CVRL LMS
//     -> scalar physiological-Yf grading
//     -> adaptation-relative LMS purity
//     -> adaptation-relative common cone power
//     -> anchor-matched finite per-cone G
//     -> Mean-A2 direction with post-G radius and C0
//     -> exact fixed-direction target RGB-cube/Yf projection
//     -> linear-light BT.709 representation
//
// The caller supplies the current adaptation and desired output-background
// anchors. The runtime signal is reference-white-relative. Absolute retinal
// scale, local/temporal adaptation estimation, visibility thresholds, and
// cortical gain form explicit successor-test research directions below.
//
// 1) Receptor basis and observer coordinates
// ------------------------------------------
// Brainard's Colorimetry chapter supplies the cone-stage/color-match
// foundation. Stockman and Brainard build on that receptor basis for
// first-site and second-site adaptation. Test30 transforms linear-light
// BT.709 through XYZ to the Stockman/CVRL two-degree LMS fit.
//
// Sources:
//   https://color2.psych.upenn.edu/brainard/papers/Brainard_Stockman_Colorimetry.pdf
//   https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//
// The published Stockman-Sharpe fundamentals include standard prereceptoral
// lens and macular filtering for an average, mainly foveal two-degree observer.
// CVRL documents the ocular-media and macular-pigment filters, their strong
// short-wavelength absorption, and their observer variation. Successor tests
// can expose age, field size, eccentricity, lens, and macular assumptions when
// personalized observer transforms become an input.
//
// Sources:
//   http://www.cvrl.org/background.htm
//   http://www.cvrl.org/database/text/intros/intromaclens.htm
//
// Test30's selected positive-cone path carries physiological Yf:
//
//   physiological Yf = cL * L + cM * M
//
// where cL and cM come directly from the Yf row of the base
// Stockman-Sharpe LMS-to-XfYfZf transform. The selected purity and response
// stages operate directly in LMS and Yf and do not use an S-cone weight.
//
// The signed fallback separately retains CIE 170-2 weighted
// MacLeod-Boynton chromaticity for source-boundary continuation:
//
//   l    = Lw / (Lw + Mw)
//   s    = Sw / (Lw + Mw)
//
// MacLeod-Boynton (1979) supplies the classic weighted-cone chromaticity
// construction. CVRL/CIE physiological data and repository constants supply
// the exact coefficients used here. Psychtoolbox documents a practical
// CIE-based LMS-to-MacLeod-Boynton implementation. Webster and Leonard use a
// modified MB framework for adaptation norms. Mantiuk et al. describe a
// practical LMS scaling whose L+M sum carries an achromatic coordinate.
//
// Sources:
//   http://www.cvrl.org/ciexyzpr.htm
//   https://psychtoolbox.org/docs/LMSToMacBoyn
//   MacLeod & Boynton, JOSA 1979, doi:10.1364/JOSA.69.001183
//   Webster & Leonard, JOSA A 2008, doi:10.1364/JOSAA.25.002817
//   https://pmc.ncbi.nlm.nih.gov/articles/PMC2657039/
//   https://www.cl.cam.ac.uk/~rkm38/pdfs/mantiuk2020practical_csf.pdf
//
// 2) Early cone adaptation
// ------------------------
// Stockman and Brainard express first-site L-cone contrast as
//
//   C_L = delta_L / (L_b + L_0)
//
// with corresponding M- and S-cone forms. Equivalently, the background sets
// the cone gain:
//
//   g_L = 1 / (L_b + L_0)
//   g_L * (L - L_b) = delta_L / (L_b + L_0)
//
// Test30 receives caller-authored adaptation LMS as `anchor_in` and uses
// q_i = LMS_i / anchor_in_i as its static background-relative state. This
// preserves the architecture of cone-specific normalization while keeping
// adaptation policy in the caller. A successor with image/retinal context can
// estimate L_b, M_b, S_b and semi-saturation L_0, M_0, S_0 over space and time.
//
// Stockman et al. describe first-site regulation across light levels and the
// transition toward bleaching-supported high-light sensitivity regulation.
// Source: JOV 2006, doi:10.1167/6.11.5.
//
// Webster and Leonard distinguish a response norm, the adapting level that
// leaves white judgments unbiased, from a perceptual norm, the stimulus that
// appears white. Their experiments found close tracking between these norms.
// PsychoV uses adapted-background reference for the directly carried cone
// state and retains response/perceptual norms as higher-level interpretations
// of the current neutral coding state.
// Source: JOSA A 2008, doi:10.1364/JOSAA.25.002817.
//
// CVRL documents observing-condition and chromatic-adaptation dependence in
// physiological luminosity functions, while cone spectral sensitivities stay
// stable through ordinary adaptation levels. This supports carrying Yf with
// the current adapted observer state.
// Source: http://www.cvrl.org/database/text/intros/introvl.htm
//
// 2a) Dim cone-noise extension
// ----------------------------
// Cone-mediated detection reaches a quantal/transduction-noise regime before
// rod-dominated vision. Approximate De Vries-Rose behavior gives threshold
// cone contrast a log-log slope near -0.5 against retinal illuminance. Higher
// adaptation levels approach Weber-like behavior, where threshold contrast is
// approximately constant relative to background. A calibrated successor can
// use retinal illuminance and cone-specific noise to attenuate scene
// differences below this visibility floor before postreceptoral processing.
//
// Stockman and Brainard discuss the range where cone-contrast coordinates
// approach Weber behavior. Angueyra and Rieke measure primate-cone
// phototransduction noise and its contribution to the dim-light threshold.
// Sources:
//   https://color2.psych.upenn.edu/brainard/papers/Stockman_Brainard_ColorVision.pdf
//   Angueyra & Rieke, Nature Neuroscience 2013, doi:10.1038/nn.3534
//   https://pmc.ncbi.nlm.nih.gov/articles/PMC3815624/
//
// 2b) High-light bleaching extension
// -----------------------------------
// A retinal-illuminance-calibrated successor can represent steady-state cone
// pigment availability with the Rushton-Henry form
//
//   p_available(I) = 1 / (1 + I / I0)
//
// and the complementary bleached fraction
//
//   p_bleached(I) = I / (I + I0),  I0 approximately 10^4.3 Td.
//
// Physiological placement follows adaptation-state definition and precedes
// postreceptoral opponent response and pooled gain. A rendering realization
// can apply availability to cone excursions around the adapted-white anchor,
// approaching equal white at the carried achromatic level as availability
// approaches zero. Test30's selected highlight endpoint is the finite-G
// equation documented above; the bleaching equations remain a calibrated
// successor path tied to retinal units.
//
// Sources:
//   Stockman et al., JOV 2006, doi:10.1167/6.11.5
//   Stockman et al., JOV 2018, doi:10.1167/18.6.12
//   Rushton & Henry, Vision Research 1968,
//     doi:10.1016/0042-6989(68)90040-0
//   http://www.cvrl.org/database/text/intros/introbleaches.htm
//
// 3) Background-normalized opponent organization
// ------------------------------------------------
// Test30 applies adaptation-relative purity directly in LMS, then constructs
// A2 as an orthonormal decomposition of the three adaptation/peak-normalized
// cone loads. A2 supplies an exact Euclidean metric and sixfold cone-axis
// geometry for Mean-A2 direction authoring and target projection. The signed
// fallback still uses weighted MacLeod-Boynton chromaticity for one
// source-boundary trace; this is not part of the selected positive path and
// should be revisited alongside a fitted ACC/DKL or A2-consistent fallback.
//
// 4) Saturating response research
// -------------------------------
// Michaelis-Menten/Naka-Rushton response families provide receptor and
// early-cortical contrast models; supersaturating forms capture additional
// cortical response shapes. Peirce analyzes how saturating and supersaturating
// contrast response functions affect visual-cortex interpretation.
// Source: Peirce, JOV 2007, doi:10.1167/7.6.13.
//
// Test30 selects the anchor-preserving finite per-cone G above. Its reciprocal
// parameterization fixes the caller's input/output anchor, logarithmic slope,
// and selected peak endpoint. This creates a controlled rendering response for
// direct comparison with future fitted receptor or cortical response models.
//
// 5) ON/OFF response research
// ---------------------------
// Retinal ON and OFF channels separate increments and decrements around an
// adapted background. Schiller reviews their parallel visual-system roles.
// Yu, Turner, Baudin, and Rieke show that cone adaptation and downstream
// nonlinearities can combine unexpectedly for natural-image structure,
// motivating natural-image validation of any explicit polarity split.
//
// Rahimi-Nasrabadi et al. validate an ONOFF image algorithm on calibrated
// grayscale images and propose color extension through a scalar lightness
// dimension. PsychoV's scalar-Yf highlight/shadow grade follows the analogous
// engineering principle of applying polarity-shaped grades to one achromatic
// coordinate while retaining cone ratios.
//
// Sources:
//   Schiller, Trends Neurosci 1992,
//     doi:10.1016/0166-2236(92)90017-3
//   Yu et al., eLife 2022, doi:10.7554/eLife.70611
//   Rahimi-Nasrabadi et al., Cell Reports 2021,
//     doi:10.1016/j.celrep.2021.108692
//
// Test30's automatic finite-G curve uses a centered static log-range prior.
// A successor ON/OFF stage can fit separate increment/decrement responses and
// preserve the same adaptation anchor and device-hull coupling.
//
// 6) Pooled divisive gain research
// --------------------------------
// Divisive normalization models pooled neural response as a channel drive
// divided by a semi-saturated measure of neighboring/population activity.
// This supplies a research path for coupled achromatic/opponent energy,
// spatial context, and contrast-dependent gain after polarity processing.
//
// Sources:
//   Heeger, Visual Neuroscience 1992,
//     doi:10.1017/S0952523800009640
//   Carandini & Heeger, Nature Reviews Neuroscience 2012,
//     doi:10.1038/nrn3136
//   Bun & Horwitz, Color Research & Application 2023,
//     doi:10.1002/col.22903
//
// A successor implementation can add fitted pooling neighborhoods and
// semi-saturation constants after a selected opponent/ON-OFF stage. Test30
// supplies a static per-pixel response baseline for that comparison.
//
// 7) Unified device-hull tone and gamut mapping
// ---------------------------------------------
// Display mapping is constrained by the complete target RGB volume. In
// normalized target coordinates this is
//
//   0 <= R,G,B <= 1.
//
// Lower and upper channel planes, faces, edges, corners, and neutral-axis
// capacity participate in one device-hull problem. High-purity directions can
// reach a target face at a lower achromatic level than D65, so a joint solve
// trades radial opponent distance and achromatic coordinate according to the
// selected metric. ITU-R BT.2408 supplies the practical HDR Reference White
// framing that keeps reference/diffuse white distinct from display peak.
// Source: https://www.itu.int/pub/R-REP-BT.2408
//
// Test30 fixes the Mean-A2 authored direction and projects exactly in the full
// orthonormal (X,C0,Z) metric over the resulting convex target-cube/Yf polygon.
// This extends Test25's numerical ray support into an analytic nearest-point
// solve for the selected direction. BT.709 and BT.2020 modes share the same
// D65 cone normalization and use their respective complete RGB cubes.
//
// A successor sectional solve can search multiple directions within the
// active cone-axis sextant, include a fitted postreceptoral metric, and compare
// face/edge/interior candidates. Mean-A2 remains the preferred authored
// trajectory candidate and Test30 remains the exact fixed-direction baseline.
//
// 7a) Hue-objective research inside the hull solve
// ------------------------------------------------
// Mizokami et al. and O'Neil et al. study a functional account of the Abney
// effect based on an equivalent Gaussian spectral peak. For short and medium
// wavelengths, the equivalent-peak parameter can provide a hue objective as
// purity changes. A future spectral precomputation can map weighted-LMS/MB
// chromaticity to mu_eq and evaluate mu_eq alongside A2/ACC direction during
// target-hull optimization while carrying Yf separately.
//
// Sources:
//   Mizokami et al., JOV 2006, doi:10.1167/6.9.12
//   O'Neil et al., JOSA A 2012, doi:10.1364/JOSAA.29.00A165
//
// 7b) Simultaneous-range auto-compression
// ---------------------------------------
// `compression == 0` uses a static centered simultaneous-range reference:
//
//   side_range = reference_range_log10 / 2
//   h = max(side_range / log10(peak_Yf / anchor_Yf), 1)
//
// Kunkel and Reinhard report approximately 3.7 log10 units under their adapted
// test conditions. Jiang and Fairchild directly measured bright/dark
// simultaneous range on an Apple Pro Display XDR: approximately 3.3 log10 for
// the average observer and 3.47 for one observer at 1600 cd/m^2 with a
// 3.4-degree stimulus. Their fitted maxima were approximately 3.24 at
// 452 cd/m^2 and 3.40 at 1600 cd/m^2. These condition-dependent measurements
// motivate future display-, surround-, field-size-, and glare-aware range
// selection. Test30 keeps 3.7 as its static baseline for direct continuity
// with Test22-Test25.
//
// Sources:
//   Kunkel & Reinhard, APGV 2010, doi:10.1145/1836248.1836251
//   Jiang & Fairchild, JIST 2021,
//     doi:10.2352/J.ImagingSci.Technol.2021.65.5.050401
//
static const float PSYCHO30_EPSILON = 1e-6f;
static const float PSYCHO30_EPSILON2 = PSYCHO30_EPSILON * PSYCHO30_EPSILON;
static const float PSYCHO30_MAX_FINITE_INPUT = 65504.f;
static const float PSYCHO30_AUTO_COMPRESSION_SENTINEL = 0.f;
static const float PSYCHO30_LARGE_SUPPORT = 1e20f;
// Kunkel/Reinhard report approximately 3.7 log10 units under their adapted
// simultaneous-range test conditions. Test30 treats half that total range as
// the range above adaptation and half as the range below adaptation.
// Jiang/Fairchild report stimulus- and display-dependent simultaneous values.
static const float PSYCHO30_REFERENCE_SIMULTANEOUS_RANGE_LOG10 = 3.7f;
static const float PSYCHO30_HIGHLIGHT_GRADE_REFERENCE_WHITE = 1.f;
static const float PSYCHO30_SHADOW_GRADE_RANGE_STOPS = 4.f;

static const float3x3 PSYCHO30_BT709_TO_LMS_MAT = mul(
    renodx::color::STOCKMAN_CVRL_XYZ_TO_LMS_2DEG_FIT,
    renodx::color::BT709_TO_XYZ_MAT);
static const float3x3 PSYCHO30_LMS_TO_BT709_MAT = mul(
    renodx::color::XYZ_TO_BT709_MAT,
    renodx::color::STOCKMAN_CVRL_LMS_TO_XYZ_2DEG_FIT);
static const float3x3 PSYCHO30_LMS_TO_BT2020_MAT = mul(
    renodx::color::XYZ_TO_BT2020_MAT,
    renodx::color::STOCKMAN_CVRL_LMS_TO_XYZ_2DEG_FIT);

static const float3 PSYCHO30_SOURCE_YF_COEFFICIENTS = mul(
    renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1],
    PSYCHO30_BT709_TO_LMS_MAT);
static const float3 PSYCHO30_SOURCE_YF_POSITIVE_COEFFICIENTS = max(
    PSYCHO30_SOURCE_YF_COEFFICIENTS,
    float3(0.f, 0.f, 0.f));
static const float3 PSYCHO30_SOURCE_YF_WEIGHTS =
    PSYCHO30_SOURCE_YF_POSITIVE_COEFFICIENTS
    / max(
        PSYCHO30_SOURCE_YF_POSITIVE_COEFFICIENTS.x
            + PSYCHO30_SOURCE_YF_POSITIVE_COEFFICIENTS.y
            + PSYCHO30_SOURCE_YF_POSITIVE_COEFFICIENTS.z,
        PSYCHO30_EPSILON);

// BT.709 and BT.2020 share D65. These alpha values partition normalized Yf
// between the L and M cone loads and sum to one.
static const float3 PSYCHO30_D65_WHITE_LMS = mul(
    PSYCHO30_BT709_TO_LMS_MAT,
    float3(1.f, 1.f, 1.f));
static const float PSYCHO30_D65_WHITE_YF = dot(
    renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1],
    PSYCHO30_D65_WHITE_LMS);
static const float PSYCHO30_D65_ALPHA_L =
    renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1][0]
    * PSYCHO30_D65_WHITE_LMS.x
    / PSYCHO30_D65_WHITE_YF;
static const float PSYCHO30_D65_ALPHA_M =
    renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1][1]
    * PSYCHO30_D65_WHITE_LMS.y
    / PSYCHO30_D65_WHITE_YF;
static const float PSYCHO30_D65_ALPHA_DELTA =
    PSYCHO30_D65_ALPHA_L - PSYCHO30_D65_ALPHA_M;
// Direct target basis at fixed normalized physiological coordinate A:
//
//   target_rgb = A + X * A2_X_RGB + Z * A2_Z_RGB
//
// These are the symbolic inverse orthonormal-cone transform followed by the
// selected LMS-to-RGB matrix; they avoid reconstructing LMS per pixel.
static const float3 PSYCHO30_BT709_A2_X_RGB = mul(
    PSYCHO30_LMS_TO_BT709_MAT,
    float3(
        sqrt(2.f) * PSYCHO30_D65_ALPHA_M
            * PSYCHO30_D65_WHITE_LMS.x,
        -sqrt(2.f) * PSYCHO30_D65_ALPHA_L
            * PSYCHO30_D65_WHITE_LMS.y,
        rsqrt(2.f)
            * (PSYCHO30_D65_ALPHA_M
               - PSYCHO30_D65_ALPHA_L)
            * PSYCHO30_D65_WHITE_LMS.z));
static const float3 PSYCHO30_BT709_A2_Z_RGB = mul(
    PSYCHO30_LMS_TO_BT709_MAT,
    float3(
        0.f,
        0.f,
        sqrt(6.f) * 0.5f * PSYCHO30_D65_WHITE_LMS.z));
static const float3 PSYCHO30_BT2020_A2_X_RGB = mul(
    PSYCHO30_LMS_TO_BT2020_MAT,
    float3(
        sqrt(2.f) * PSYCHO30_D65_ALPHA_M
            * PSYCHO30_D65_WHITE_LMS.x,
        -sqrt(2.f) * PSYCHO30_D65_ALPHA_L
            * PSYCHO30_D65_WHITE_LMS.y,
        rsqrt(2.f)
            * (PSYCHO30_D65_ALPHA_M
               - PSYCHO30_D65_ALPHA_L)
            * PSYCHO30_D65_WHITE_LMS.z));
static const float3 PSYCHO30_BT2020_A2_Z_RGB = mul(
    PSYCHO30_LMS_TO_BT2020_MAT,
    float3(
        0.f,
        0.f,
        sqrt(6.f) * 0.5f * PSYCHO30_D65_WHITE_LMS.z));

// Anchor-preserving, slope-normalized finite endpoint. In scalar form, with
// q=x/anchor, k=(anchor/peak)^h, beta=h/(1-k):
//
//   F(x) = peak * [1 + (1/k - 1) * q^(-beta)]^(-1/h)
//
// Thus F(anchor)=anchor, dF/dx at the anchor is one, F(0)=0, and the positive
// asymptote is `peak`. MeanA2Response fuses the common cone power into beta.
float psycho30_FiniteEndpoint(
    float x,
    float anchor,
    float peak,
    float h) {
  bool uniform_response = h == 1.f;
  float anchor_power = uniform_response
                           ? anchor / peak
                           : pow(anchor / peak, h);
  anchor_power = max(anchor_power, 1e-37f);
  float slope_normalization = max(1.f - anchor_power, PSYCHO30_EPSILON);
  float normalized_input = max(x / anchor, 0.f);
  if (!(normalized_input > 0.f)) return 0.f;

  float encoded = rcp(
      1.f
      + (rcp(anchor_power) - 1.f)
            * pow(normalized_input, -h / slope_normalization));
  return peak
         * (uniform_response
                ? encoded
                : pow(max(encoded, 0.f), rcp(h)));
}

// Automatic h centers the chosen simultaneous log10 range around adaptation:
//
//   h = max((reference_range / 2) / log10(peak_yf / anchor_yf), 1)
//
// Manual positive h is passed through unchanged by the public entry point.
float psycho30_AutoCompressionPower(float anchor_yf, float peak_yf) {
  float above_adaptation_range = log10(peak_yf / anchor_yf);
  return max(
      (PSYCHO30_REFERENCE_SIMULTANEOUS_RANGE_LOG10 * 0.5f)
          / above_adaptation_range,
      1.f);
}

// Preserve positive source-total bookkeeping while retaining the source RGB
// direction as far as its first lower RGB-cube boundary. This keeps finite
// signed/wide-gamut inputs defined by one direction-preserving boundary trace.
float3 psycho30_AnchorSourcePositiveTotalToYf(float3 source_rgb) {
  float source_total = dot(
      max(source_rgb, float3(0.f, 0.f, 0.f)),
      PSYCHO30_SOURCE_YF_WEIGHTS);
  if (!(source_total > PSYCHO30_EPSILON)
      || isnan(source_total)
      || isinf(source_total)) {
    return float3(0.f, 0.f, 0.f);
  }

  [branch]
  if (all(source_rgb >= float3(0.f, 0.f, 0.f))) {
    return mul(PSYCHO30_BT709_TO_LMS_MAT, source_rgb);
  }

  float3 residual = source_rgb - source_total;
  float3 lower_fraction = renodx::math::Select(
      residual < float3(
          -PSYCHO30_EPSILON,
          -PSYCHO30_EPSILON,
          -PSYCHO30_EPSILON),
      source_total / max(-residual, float3(PSYCHO30_EPSILON, PSYCHO30_EPSILON, PSYCHO30_EPSILON)),
      float3(
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT));
  float boundary_fraction = min(1.f, renodx::math::Min(lower_fraction));
  float3 bounded_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      source_total + residual * boundary_fraction);
  float bounded_yf = renodx::color::yf::from::LMS(bounded_lms);
  return bounded_yf > PSYCHO30_EPSILON
                 && !isnan(bounded_yf)
                 && !isinf(bounded_yf)
             ? bounded_lms
                   * (source_total * PSYCHO30_D65_WHITE_YF / bounded_yf)
             : PSYCHO30_D65_WHITE_LMS * source_total;
}

// Keep the custom source inside the positive AP1 gamut cone, then trace any
// remaining non-physical cone response toward same-Yf D65 until LMS is valid.
float3 psycho30_ClampSourceAP1ToPositiveLMS(float3 source_bt709) {
  float3 source_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      renodx::color::bt709::clamp::AP1(source_bt709));
  if (all(source_lms >= float3(0.f, 0.f, 0.f))) {
    return source_lms;
  }

  float source_yf = renodx::color::yf::from::LMS(source_lms);
  if (!(source_yf > PSYCHO30_EPSILON)
      || isnan(source_yf)
      || isinf(source_yf)) {
    return float3(0.f, 0.f, 0.f);
  }

  float3 neutral_lms = PSYCHO30_D65_WHITE_LMS
                       * (source_yf / PSYCHO30_D65_WHITE_YF);
  float3 residual = source_lms - neutral_lms;
  float3 lower_fraction = renodx::math::Select(
      residual < float3(
          -PSYCHO30_EPSILON,
          -PSYCHO30_EPSILON,
          -PSYCHO30_EPSILON),
      neutral_lms
          / max(
              -residual,
              float3(
                  PSYCHO30_EPSILON,
                  PSYCHO30_EPSILON,
                  PSYCHO30_EPSILON)),
      float3(
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT));
  float boundary_fraction = min(1.f, renodx::math::Min(lower_fraction));
  return max(
      neutral_lms + residual * boundary_fraction,
      float3(0.f, 0.f, 0.f));
}

float psycho30_GradeQuinticUnitRamp(float t) {
  t = saturate(t);
  return t * t * t * (t * (t * 6.f - 15.f) + 10.f);
}

float psycho30_HighlightsScalar(
    float x,
    float highlights,
    float adapted_anchor_yf) {
  if (highlights == 1.f) return x;

  float t = 0.f;
  if (x > adapted_anchor_yf) {
    t = saturate(
        log2(x / adapted_anchor_yf)
        / log2(
            PSYCHO30_HIGHLIGHT_GRADE_REFERENCE_WHITE
            / adapted_anchor_yf));
  }
  t = psycho30_GradeQuinticUnitRamp(t);

  float ratio = max(
      x / adapted_anchor_yf,
      PSYCHO30_EPSILON);
  if (highlights > 1.f) {
    return lerp(
        x,
        adapted_anchor_yf * pow(ratio, highlights),
        t);
  }

  float compressed = adapted_anchor_yf * pow(ratio, 2.f - highlights);
  return renodx::math::DivideSafe(
      x * x,
      lerp(x, compressed, t),
      x);
}

float psycho30_ShadowsScalar(
    float x,
    float shadows,
    float adapted_anchor_yf) {
  if (shadows == 1.f) return x;

  float ratio = max(x / adapted_anchor_yf, 0.f);
  float base_term = x * adapted_anchor_yf;
  float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
  float shadow_floor = adapted_anchor_yf
                       * exp2(-PSYCHO30_SHADOW_GRADE_RANGE_STOPS);
  float t = x > shadow_floor
                ? saturate(
                      log2(x / adapted_anchor_yf)
                      / log2(shadow_floor / adapted_anchor_yf))
                : 1.f;
  t = psycho30_GradeQuinticUnitRamp(t);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(max(ratio, PSYCHO30_EPSILON), shadows), 0.f));
    return x + (raised - x * (1.f + base_scale)) * t;
  }

  float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(max(ratio, PSYCHO30_EPSILON), 2.f - shadows), 0.f));
  return x + (lowered - x * (1.f - base_scale)) * t;
}

// Direct LMS interpolation toward the adapting neutral at fixed
// adaptation-relative physiological Yf. The selected purity path does not
// require MacLeod-Boynton coordinates or an S-cone weight.
float3 psycho30_ApplyAdaptiveLMSPurity(
    float3 input_lms,
    float3 adaptive_lms,
    float purity_delta) {
  if (abs(purity_delta - 1.f) <= 1e-5f) return input_lms;

  float relative_yf = max(
      renodx::color::yf::from::LMS(input_lms / adaptive_lms),
      0.f);
  if (!(relative_yf > 0.f)) return float3(0.f, 0.f, 0.f);

  float neutral_scale = relative_yf
                        / renodx::color::yf::from::LMS(
                            float3(1.f, 1.f, 1.f));
  return lerp(
      adaptive_lms * neutral_scale,
      input_lms,
      purity_delta);
}

// Signed-fallback MacLeod-Boynton coordinate helpers. The selected positive
// path does not call this block.
float2 psycho30_AdaptiveNeutralMB() {
  float lm_weight_sum =
      renodx::color::CIE1702_MB_CIE_WEIGHTS.x
      + renodx::color::CIE1702_MB_CIE_WEIGHTS.y;
  return float2(
             renodx::color::CIE1702_MB_CIE_WEIGHTS.x,
             renodx::color::CIE1702_MB_CIE_WEIGHTS.z)
         / lm_weight_sum;
}

float3 psycho30_LMSFromYfOpponent(
    float yf,
    float rg,
    float bv,
    float3 anchor_lms) {
  float2 neutral_mb = psycho30_AdaptiveNeutralMB();
  float lm_anchor_mix = mad(
      anchor_lms.x,
      neutral_mb.x,
      anchor_lms.y * (1.f - neutral_mb.x));
  float denominator =
      (yf - (anchor_lms.x - anchor_lms.y) * rg)
      / lm_anchor_mix;
  float3 relative_weighted = float3(
      neutral_mb.x * denominator + rg,
      (1.f - neutral_mb.x) * denominator - rg,
      neutral_mb.y * denominator + bv);
  return relative_weighted * anchor_lms
         / renodx::color::CIE1702_MB_CIE_WEIGHTS;
}

float3 psycho30_LMSFromPhysicalYfMB(
    float yf,
    float2 mb,
    float3 anchor_lms) {
  float2 neutral_mb = psycho30_AdaptiveNeutralMB();
  float2 offset = mb - neutral_mb;
  float lm_anchor_mix = mad(
      anchor_lms.x,
      neutral_mb.x,
      anchor_lms.y * (1.f - neutral_mb.x));
  float anchor_delta = anchor_lms.x - anchor_lms.y;
  float relative_denominator = renodx::math::DivideSafe(
      yf,
      lm_anchor_mix + anchor_delta * offset.x,
      0.f);
  return psycho30_LMSFromYfOpponent(
      yf,
      relative_denominator * offset.x,
      relative_denominator * offset.y,
      anchor_lms);
}

float3 psycho30_TargetRGBFromLMS(
    float3 lms,
    int target_gamut_mode) {
  float3 target_rgb;
  [branch]
  if (target_gamut_mode == 0) {
    target_rgb = mul(PSYCHO30_LMS_TO_BT709_MAT, lms);
  } else {
    target_rgb = mul(PSYCHO30_LMS_TO_BT2020_MAT, lms);
  }
  return target_rgb;
}

float psycho30_TargetNeutralYfLimit(
    float target_rgb_peak,
    float3 anchor_lms,
    int target_gamut_mode) {
  float anchor_yf = renodx::color::yf::from::LMS(anchor_lms);
  if (!(anchor_yf > PSYCHO30_EPSILON)) return 0.f;
  float3 rgb_per_yf = psycho30_TargetRGBFromLMS(
                          anchor_lms,
                          target_gamut_mode)
                      / anchor_yf;
  float max_rgb_per_yf = renodx::math::Max(rgb_per_yf);
  return all(rgb_per_yf >= float3(
                 -PSYCHO30_EPSILON,
                 -PSYCHO30_EPSILON,
                 -PSYCHO30_EPSILON))
                 && max_rgb_per_yf > PSYCHO30_EPSILON
             ? target_rgb_peak / max_rgb_per_yf
             : 0.f;
}

// Weighted MacLeod-Boynton chromaticity is retained only for the signed
// fallback's source-boundary continuation.
float2 psycho30_MBFromRelativeLMS(
    float3 relative_lms,
    out uint valid) {
  const float3 weights = renodx::color::CIE1702_MB_CIE_WEIGHTS;
  float yf = renodx::color::yf::from::LMS(relative_lms);
  valid = yf > PSYCHO30_EPSILON
                  && !isnan(yf)
                  && !isinf(yf)
                  && !any(isnan(relative_lms))
                  && !any(isinf(relative_lms))
              ? 1u
              : 0u;
  if (valid == 0u) {
    return psycho30_AdaptiveNeutralMB();
  }
  float inverse_yf = rcp(yf);
  return float2(
      relative_lms.x * weights.x * inverse_yf,
      relative_lms.z * weights.z * inverse_yf);
}

float3 psycho30_ApplySignedConeResponseFallback(
    float3 source_relative_lms,
    float response_power) {
  if (abs(response_power - 1.f) <= PSYCHO30_EPSILON) {
    return source_relative_lms;
  }
  return sign(source_relative_lms)
         * pow(
             abs(source_relative_lms),
             float3(response_power, response_power, response_power));
}

// Build the selected response coordinate directly from normalized response u:
// source q authors one A2 direction, finite-G u authors the other direction
// and supplies radius, C0, and normalized physiological Yf. Equal normalized
// direction weights form the exact angular midpoint when both are defined.
float3 psycho30_MeanA2Response(
    float3 input_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float3 peak_lms,
    float response_power,
    float response_h,
    out float response_yf,
    out uint valid) {
  float3 source_q = input_lms / anchor_in_lms;
  valid = all(source_q > float3(0.f, 0.f, 0.f)) ? 1u : 0u;
  if (valid == 0u) {
    response_yf = 0.f;
    return float3(0.f, 0.f, 0.f);
  }

  bool uniform_response = response_h == 1.f;
  float3 anchor_power;
  [branch]
  if (uniform_response) {
    anchor_power = anchor_out_lms / peak_lms;
  } else {
    anchor_power = pow(
        anchor_out_lms / peak_lms,
        float3(response_h, response_h, response_h));
  }
  anchor_power = max(
      anchor_power,
      float3(1e-37f, 1e-37f, 1e-37f));
  float3 slope_normalization = max(
      float3(1.f, 1.f, 1.f) - anchor_power,
      float3(
          PSYCHO30_EPSILON,
          PSYCHO30_EPSILON,
          PSYCHO30_EPSILON));
  float3 input_exponent = response_power * response_h / slope_normalization;
  float3 encoded = rcp(
      float3(1.f, 1.f, 1.f)
      + (rcp(anchor_power) - float3(1.f, 1.f, 1.f))
            * pow(source_q, -input_exponent));
  float3 response_u;
  [branch]
  if (uniform_response) {
    response_u = encoded;
  } else {
    float inverse_response_h = rcp(response_h);
    response_u = pow(
        max(encoded, float3(0.f, 0.f, 0.f)),
        float3(
            inverse_response_h,
            inverse_response_h,
            inverse_response_h));
  }
  float2 source_a2 = float2(
      (source_q.x - source_q.y) * rsqrt(2.f),
      (2.f * source_q.z - source_q.x - source_q.y)
          * rsqrt(6.f));
  float2 response_a2 = float2(
      (response_u.x - response_u.y) * rsqrt(2.f),
      (2.f * response_u.z - response_u.x - response_u.y)
          * rsqrt(6.f));
  float2 authored_a2 = response_a2;
  float source_radius2 = dot(source_a2, source_a2);
  float response_radius2 = dot(response_a2, response_a2);

  if (source_radius2 > PSYCHO30_EPSILON2
      && response_radius2 > PSYCHO30_EPSILON2) {
    float inverse_source_radius = rsqrt(source_radius2);
    float inverse_response_radius = rsqrt(response_radius2);
    float response_radius = response_radius2 * inverse_response_radius;
    float2 mean_direction = source_a2 * inverse_source_radius
                            + response_a2 * inverse_response_radius;
    float mean_radius2 = dot(mean_direction, mean_direction);
    if (mean_radius2 > PSYCHO30_EPSILON2) {
      authored_a2 = mean_direction
                    * rsqrt(mean_radius2)
                    * response_radius;
    }
  }

  response_yf = PSYCHO30_D65_ALPHA_L * response_u.x
                + PSYCHO30_D65_ALPHA_M * response_u.y;
  float3 desired_ortho = float3(
      authored_a2.x,
      (response_u.x + response_u.y + response_u.z) * rsqrt(3.f),
      authored_a2.y);
  return desired_ortho;
}

float2 psycho30_ClosestPointOnScaleSegment(
    float desired_c0,
    float desired_rho2,
    float2 segment_start,
    float2 segment_end) {
  float2 segment = segment_end - segment_start;
  float denominator = segment.x * segment.x
                      + desired_rho2 * segment.y * segment.y;
  if (!(denominator > PSYCHO30_EPSILON2)) return segment_start;
  float numerator = (desired_c0 - segment_start.x) * segment.x
                    + desired_rho2 * (1.f - segment_start.y) * segment.y;
  float t = saturate(numerator / denominator);
  return segment_start + segment * t;
}

// Exact nearest point for the fixed authored A2 direction. The RGB cube and
// A<=response_yf ceiling become a four-edge convex polygon in (C0, radial
// scale). `desired_rho2` in the segment metric preserves ordinary Euclidean
// distance in (X,C0,Z).
// For radial target RGB r, n=max(-r), and p=max(r), feasibility is exactly:
//
//   scale * n <= A <= 1 - scale * p
//   0 <= A <= min(response_yf, 1)
float3 psycho30_YfCeilingSolve(
    float3 desired_coord,
    float response_yf,
    int target_gamut_mode,
    out uint valid) {
  valid = !any(isnan(desired_coord))
                  && !any(isinf(desired_coord))
                  && !isnan(response_yf)
                  && !isinf(response_yf)
              ? 1u
              : 0u;
  if (valid == 0u) return float3(0.f, 0.f, 0.f);

  float max_a = saturate(response_yf);
  float radial_yf = PSYCHO30_D65_ALPHA_DELTA
                        * desired_coord.x * rsqrt(2.f)
                    - desired_coord.z * rsqrt(6.f);
  float desired_a = desired_coord.y * rsqrt(3.f) + radial_yf;
  float3 radial_rgb;
  [branch]
  if (target_gamut_mode == 0) {
    radial_rgb = desired_coord.x * PSYCHO30_BT709_A2_X_RGB
                 + desired_coord.z * PSYCHO30_BT709_A2_Z_RGB;
  } else {
    radial_rgb = desired_coord.x * PSYCHO30_BT2020_A2_X_RGB
                 + desired_coord.z * PSYCHO30_BT2020_A2_Z_RGB;
  }
  float3 desired_target_rgb = desired_a + radial_rgb;
  if (desired_a >= 0.f
      && desired_a <= max_a
      && all(desired_target_rgb >= float3(
                 -PSYCHO30_EPSILON,
                 -PSYCHO30_EPSILON,
                 -PSYCHO30_EPSILON))
      && all(desired_target_rgb <= float3(
                 1.f + PSYCHO30_EPSILON,
                 1.f + PSYCHO30_EPSILON,
                 1.f + PSYCHO30_EPSILON))) {
    return desired_coord;
  }

  float desired_rho2 = dot(desired_coord.xz, desired_coord.xz);
  if (!(desired_rho2 > PSYCHO30_EPSILON2)) {
    return float3(
        0.f,
        clamp(desired_coord.y, 0.f, sqrt(3.f) * max_a),
        0.f);
  }

  float positive_pressure = renodx::math::Max(radial_rgb);
  float negative_pressure = -renodx::math::Min(radial_rgb);
  if (!(positive_pressure > 0.f)
      || !(negative_pressure > 0.f)) {
    valid = 0u;
    return float3(0.f, 0.f, 0.f);
  }

  float inverse_positive = rcp(positive_pressure);
  float inverse_negative = rcp(negative_pressure);
  float inverse_pressure_sum = rcp(
      positive_pressure + negative_pressure);
  float apex_a = negative_pressure * inverse_pressure_sum;
  float upper_a = min(max_a, apex_a);
  float max_a_scale = min(
      max_a * inverse_negative,
      (1.f - max_a) * inverse_positive);
  float upper_scale = min(
      max_a * inverse_negative,
      inverse_pressure_sum);
  float2 vertex0 = float2(0.f, 0.f);
  float2 vertex1 = float2(sqrt(3.f) * max_a, 0.f);
  float2 vertex2 = float2(
      sqrt(3.f) * (max_a - radial_yf * max_a_scale),
      max_a_scale);
  float2 vertex3 = float2(
      sqrt(3.f) * (upper_a - radial_yf * upper_scale),
      upper_scale);
  float2 best_c0_scale = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex0,
      vertex1);
  float2 best_delta = best_c0_scale - float2(desired_coord.y, 1.f);
  float best_cost = best_delta.x * best_delta.x
                    + desired_rho2 * best_delta.y * best_delta.y;

  float2 candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex1,
      vertex2);
  float2 candidate_delta = candidate - float2(desired_coord.y, 1.f);
  float candidate_cost = candidate_delta.x * candidate_delta.x
                         + desired_rho2 * candidate_delta.y * candidate_delta.y;
  if (candidate_cost < best_cost) {
    best_c0_scale = candidate;
    best_cost = candidate_cost;
  }

  candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex2,
      vertex3);
  candidate_delta = candidate - float2(desired_coord.y, 1.f);
  candidate_cost = candidate_delta.x * candidate_delta.x
                   + desired_rho2 * candidate_delta.y * candidate_delta.y;
  if (candidate_cost < best_cost) {
    best_c0_scale = candidate;
    best_cost = candidate_cost;
  }

  candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex0,
      vertex3);
  candidate_delta = candidate - float2(desired_coord.y, 1.f);
  candidate_cost = candidate_delta.x * candidate_delta.x
                   + desired_rho2 * candidate_delta.y * candidate_delta.y;
  if (candidate_cost < best_cost) {
    best_c0_scale = candidate;
  }

  float3 solved_coord = float3(
      desired_coord.x * max(best_c0_scale.y, 0.f),
      best_c0_scale.x,
      desired_coord.z * max(best_c0_scale.y, 0.f));
  valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
  return valid != 0u ? solved_coord : float3(0.f, 0.f, 0.f);
}

float2 psycho30_LinearA2Opponent(
    float3 lms,
    float3 anchor_lms) {
  float3 q = lms / anchor_lms;
  return float2(
      (q.x - q.y) * rsqrt(2.f),
      (2.f * q.z - q.x - q.y) * rsqrt(6.f));
}

float3 psycho30_LMSFromLinearA2Opponent(
    float2 opponent,
    float physical_yf,
    float3 anchor_lms) {
  float difference = sqrt(2.f) * opponent.x;
  float a_l = renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1][0]
              * anchor_lms.x;
  float a_m = renodx::color::STOCKMAN_SHARP_LMS_TO_XFYFZF_MAT[1][1]
              * anchor_lms.y;
  float q_m = (physical_yf - a_l * difference) / (a_l + a_m);
  float q_l = q_m + difference;
  float q_s = 0.5f * (sqrt(6.f) * opponent.y + q_l + q_m);
  return float3(q_l, q_m, q_s) * anchor_lms;
}

float psycho30_LinearA2TargetSupport(
    float2 direction,
    float clip_magnitude,
    float physical_yf,
    float3 anchor_lms,
    int target_gamut_mode,
    float target_rgb_peak) {
  if (!(clip_magnitude > PSYCHO30_EPSILON)) return 0.f;

  float3 neutral_target = psycho30_TargetRGBFromLMS(
      psycho30_LMSFromLinearA2Opponent(
          float2(0.f, 0.f),
          physical_yf,
          anchor_lms),
      target_gamut_mode);
  if (any(isnan(neutral_target))
      || any(isinf(neutral_target))
      || any(neutral_target < float3(0.f, 0.f, 0.f))
      || any(neutral_target > float3(
                 target_rgb_peak,
                 target_rgb_peak,
                 target_rgb_peak))) {
    return 0.f;
  }

  float3 unit_target = psycho30_TargetRGBFromLMS(
      psycho30_LMSFromLinearA2Opponent(
          direction,
          physical_yf,
          anchor_lms),
      target_gamut_mode);
  float3 delta_target = unit_target - neutral_target;
  if (any(isnan(delta_target)) || any(isinf(delta_target))) return 0.f;

  float3 upper_support = renodx::math::Select(
      delta_target > float3(
          PSYCHO30_EPSILON,
          PSYCHO30_EPSILON,
          PSYCHO30_EPSILON),
      (float3(target_rgb_peak, target_rgb_peak, target_rgb_peak) - neutral_target)
          / max(
              delta_target,
              float3(
                  PSYCHO30_EPSILON,
                  PSYCHO30_EPSILON,
                  PSYCHO30_EPSILON)),
      float3(
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT));
  float3 lower_support = renodx::math::Select(
      delta_target < float3(
          -PSYCHO30_EPSILON,
          -PSYCHO30_EPSILON,
          -PSYCHO30_EPSILON),
      neutral_target
          / max(
              -delta_target,
              float3(
                  PSYCHO30_EPSILON,
                  PSYCHO30_EPSILON,
                  PSYCHO30_EPSILON)),
      float3(
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT,
          PSYCHO30_LARGE_SUPPORT));
  return max(
      min(
          clip_magnitude,
          min(
              renodx::math::Min(upper_support),
              renodx::math::Min(lower_support))),
      0.f);
}

float psycho30_Cross2(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

float psycho30_RaySegmentRadius(
    float2 origin,
    float2 direction,
    float2 a,
    float2 b) {
  float2 edge = b - a;
  float denominator = psycho30_Cross2(direction, edge);
  if (abs(denominator) <= PSYCHO30_EPSILON) return PSYCHO30_LARGE_SUPPORT;
  float2 ao = a - origin;
  float t = psycho30_Cross2(ao, edge) / denominator;
  float u = psycho30_Cross2(ao, direction) / denominator;
  return t >= 0.f && u >= 0.f && u <= 1.f
             ? t
             : PSYCHO30_LARGE_SUPPORT;
}

float psycho30_TransformedSourceClipLinearA2Magnitude(
    float2 source_mb,
    float response_power,
    float3 response_anchor_ratio,
    float physical_yf,
    float3 anchor_lms) {
  float2 neutral_mb = psycho30_AdaptiveNeutralMB();
  float2 source_offset = source_mb - neutral_mb;
  float source_radius2 = dot(source_offset, source_offset);
  if (!(source_radius2 > PSYCHO30_EPSILON2)) return 0.f;

  float2 vertices[3];
  [unroll]
  for (int channel = 0; channel < 3; ++channel) {
    float3 primary_lms = float3(
        PSYCHO30_BT709_TO_LMS_MAT[0][channel],
        PSYCHO30_BT709_TO_LMS_MAT[1][channel],
        PSYCHO30_BT709_TO_LMS_MAT[2][channel]);
    uint primary_valid;
    vertices[channel] = psycho30_MBFromRelativeLMS(
        primary_lms / anchor_lms,
        primary_valid);
  }
  float2 source_direction = source_offset * rsqrt(source_radius2);
  float source_boundary_radius = min(
      psycho30_RaySegmentRadius(
          neutral_mb,
          source_direction,
          vertices[0],
          vertices[1]),
      min(
          psycho30_RaySegmentRadius(
              neutral_mb,
              source_direction,
              vertices[1],
              vertices[2]),
          psycho30_RaySegmentRadius(
              neutral_mb,
              source_direction,
              vertices[2],
              vertices[0])));
  if (!(source_boundary_radius < PSYCHO30_LARGE_SUPPORT)) return 0.f;

  float2 boundary_mb = neutral_mb
                       + source_direction * max(source_boundary_radius, 0.f);
  const float3 weights = renodx::color::CIE1702_MB_CIE_WEIGHTS;
  float m_fraction = 1.f - boundary_mb.x;
  if (!(boundary_mb.x > PSYCHO30_EPSILON)
      || !(m_fraction > PSYCHO30_EPSILON)
      || !(boundary_mb.y > PSYCHO30_EPSILON)) {
    return 0.f;
  }
  float inverse_m_fraction = rcp(m_fraction);
  float2 response_ratio = exp2(
      log2(max(
          float2(
              boundary_mb.x * weights.y * inverse_m_fraction / weights.x,
              boundary_mb.y * weights.y * inverse_m_fraction / weights.z),
          float2(PSYCHO30_EPSILON, PSYCHO30_EPSILON)))
      * response_power);
  response_ratio *= float2(
      response_anchor_ratio.x / response_anchor_ratio.y,
      response_anchor_ratio.z / response_anchor_ratio.y);
  float lm_ratio = (weights.x / weights.y) * response_ratio.x;
  float sm_ratio = (weights.z / weights.y) * response_ratio.y;
  float inverse_denominator = rcp(1.f + lm_ratio);
  float2 response_boundary_mb = float2(
      lm_ratio * inverse_denominator,
      sm_ratio * inverse_denominator);
  float3 boundary_lms = psycho30_LMSFromPhysicalYfMB(
      physical_yf,
      response_boundary_mb,
      anchor_lms);
  return length(psycho30_LinearA2Opponent(boundary_lms, anchor_lms));
}

float psycho30_NeutwoWithClip(
    float x,
    float peak,
    float clip,
    float h) {
  x = max(x, 0.f);
  peak = max(peak, 0.f);
  if (!(peak > PSYCHO30_EPSILON)) return 0.f;
  clip = max(clip, peak);
  if (clip <= peak * (1.f + PSYCHO30_EPSILON)) return min(x, peak);
  float q = saturate(x / clip);
  float k = saturate(peak / clip);
  float qh = pow(max(q, 0.f), h);
  float kh = max(pow(max(k, PSYCHO30_EPSILON), h), 1e-37f);
  float denominator = pow(
      max(qh * (1.f - kh) + kh, 1e-37f),
      rcp(h));
  return peak * q / max(denominator, PSYCHO30_EPSILON);
}

// Defined-domain fallback for signed adaptation-relative LMS containing a zero
// or negative cone value.
// It uses sign-preserving cone power, linear A2 direction authoring, scalar Yf
// compression, weighted-MB source-boundary continuation, and analytic
// intersections with all lower and upper selected-target RGB-cube planes.
// This is an engineering continuity and full-strength target containment path.
float3 psycho30_LinearA2Fallback(
    float3 input_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    int target_gamut_mode,
    float target_rgb_peak,
    float response_power,
    float response_h,
    float target_compression_strength) {
  float3 source_q = input_lms / anchor_in_lms;
  float3 response_lms = anchor_out_lms
                        * psycho30_ApplySignedConeResponseFallback(
                            source_q,
                            response_power);

  float2 source_opponent = psycho30_LinearA2Opponent(
      input_lms,
      anchor_in_lms);
  float2 response_opponent = psycho30_LinearA2Opponent(
      response_lms,
      anchor_in_lms);
  float source_radius2 = dot(source_opponent, source_opponent);
  float response_radius2 = dot(response_opponent, response_opponent);
  float3 authored_lms = response_lms;
  if (source_radius2 > PSYCHO30_EPSILON2
      && response_radius2 > PSYCHO30_EPSILON2) {
    float inverse_source_radius = rsqrt(source_radius2);
    float inverse_response_radius = rsqrt(response_radius2);
    float response_radius = response_radius2 * inverse_response_radius;
    float2 midpoint = source_opponent * inverse_source_radius
                      + response_opponent * inverse_response_radius;
    float midpoint_length2 = dot(midpoint, midpoint);
    if (midpoint_length2 > PSYCHO30_EPSILON2) {
      authored_lms = psycho30_LMSFromLinearA2Opponent(
          midpoint * rsqrt(midpoint_length2) * response_radius,
          max(renodx::color::yf::from::LMS(response_lms), 0.f),
          anchor_in_lms);
    }
  }

  float neutral_yf_limit = psycho30_TargetNeutralYfLimit(
      target_rgb_peak,
      anchor_in_lms,
      target_gamut_mode);
  if (!(neutral_yf_limit > PSYCHO30_EPSILON)) {
    return float3(0.f, 0.f, 0.f);
  }
  float anchor_out_yf = renodx::color::yf::from::LMS(anchor_out_lms);
  float target_yf = psycho30_FiniteEndpoint(
      max(renodx::color::yf::from::LMS(response_lms), 0.f),
      anchor_out_yf,
      neutral_yf_limit,
      response_h);

  uint authored_mb_valid;
  float2 authored_mb = psycho30_MBFromRelativeLMS(
      authored_lms / anchor_in_lms,
      authored_mb_valid);
  if (authored_mb_valid == 0u) {
    return psycho30_LMSFromYfOpponent(
        target_yf,
        0.f,
        0.f,
        anchor_in_lms);
  }

  float3 desired_lms = psycho30_LMSFromPhysicalYfMB(
      target_yf,
      authored_mb,
      anchor_in_lms);
  float2 desired_opponent = psycho30_LinearA2Opponent(
      desired_lms,
      anchor_in_lms);
  float desired_magnitude2 = dot(desired_opponent, desired_opponent);
  if (!(desired_magnitude2 > PSYCHO30_EPSILON2)) {
    return psycho30_LMSFromYfOpponent(
        target_yf,
        0.f,
        0.f,
        anchor_in_lms);
  }

  float inverse_desired_magnitude = rsqrt(desired_magnitude2);
  float desired_magnitude = desired_magnitude2 * inverse_desired_magnitude;
  float2 direction = desired_opponent * inverse_desired_magnitude;
  float source_clip_magnitude = max(
      psycho30_TransformedSourceClipLinearA2Magnitude(
          psycho30_MBFromRelativeLMS(source_q, authored_mb_valid),
          response_power,
          anchor_out_lms / anchor_in_lms,
          target_yf,
          anchor_in_lms),
      desired_magnitude);
  float target_support = psycho30_LinearA2TargetSupport(
      direction,
      source_clip_magnitude,
      target_yf,
      anchor_in_lms,
      target_gamut_mode,
      target_rgb_peak);
  float compressed_magnitude = min(
      psycho30_NeutwoWithClip(
          desired_magnitude,
          target_support,
          max(source_clip_magnitude, target_support),
          response_h),
      target_support);
  return psycho30_LMSFromLinearA2Opponent(
      direction * lerp(desired_magnitude, compressed_magnitude, target_compression_strength),
      target_yf,
      anchor_in_lms);
}

float3 psychotm_test30(
    // Direct linear-light BT.709 RGB.
    // Configuration values are trusted; only the input color is sanitized.
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,              // display peak / reference white
    float exposure = 1.f,                           // linear-light multiplier
    float highlights = 1.f,                         // scalar-Yf highlight grade
    float shadows = 1.f,                            // scalar-Yf shadow grade
    float contrast = 1.f,                           // factor in common cone power p
    float purity_scale = 1.f,                       // adaptation-relative LMS purity
    float bleaching_intensity = 1.f,                // positional compatibility placeholder
    float clip_point = 100.f,                       // positional compatibility placeholder
    float hue_restore = 1.f,                        // positional compatibility placeholder
    float encoded_response_power = 1.f,             // positional compatibility placeholder
    int white_curve_mode = 0,                       // positional compatibility placeholder
    float cone_response_exponent = 1.f,             // second factor in cone power p
    float3 current_adaptive_state_bt709 = 0.18f,    // input anchor
    float3 current_background_state_bt709 = 0.18f,  // output anchor
    float gamut_compression = 1.f,                  // target-projection strength
    int gamut_compression_mode = 1,                 // 0 = BT.709, nonzero = BT.2020
    float adaptive_normalization = 1.f,             // positional compatibility placeholder
    float compression = 0.f) {                      // positive manual h; 0 = auto
  // -------------------------------------------------------------------------
  // Source signal and signed-domain policy.
  // -------------------------------------------------------------------------
  float3 sanitized_input = renodx::math::ZeroNaN(bt709_linear_input);
  sanitized_input = renodx::math::Select(
      isinf(sanitized_input),
      renodx::math::CopySign(
          float3(
              PSYCHO30_MAX_FINITE_INPUT,
              PSYCHO30_MAX_FINITE_INPUT,
              PSYCHO30_MAX_FINITE_INPUT),
          sanitized_input),
      sanitized_input);
  float3 exposed_input = sanitized_input * exposure;

  float3 anchored_lms = psycho30_AnchorSourcePositiveTotalToYf(exposed_input);
  if (all(anchored_lms == float3(0.f, 0.f, 0.f))) {
    return float3(0.f, 0.f, 0.f);
  }

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_background_state_bt709);

  // -------------------------------------------------------------------------
  // Observer-basis controls: scalar physiological-Yf grading followed by
  // adaptation-relative LMS purity. These precede the finite cone response.
  // -------------------------------------------------------------------------
  float3 graded_lms = anchored_lms;
  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    graded_lms = abs(anchored_lms);
    float graded_yf = max(
        renodx::color::yf::from::LMS(graded_lms),
        PSYCHO30_EPSILON);
    float adapted_anchor_yf = renodx::color::yf::from::LMS(anchor_in_lms);
    float graded_yf_out = psycho30_HighlightsScalar(
        graded_yf,
        highlights,
        adapted_anchor_yf);
    graded_yf_out = psycho30_ShadowsScalar(
        graded_yf_out,
        shadows,
        adapted_anchor_yf);
    graded_lms *= renodx::math::DivideSafe(
        graded_yf_out,
        graded_yf,
        1.f);
    graded_lms = renodx::math::CopySign(graded_lms, anchored_lms);
  }

  float response_scale = cone_response_exponent;
  float response_power = contrast * response_scale;
  float purity_delta = renodx::math::DivideSafe(
      purity_scale,
      contrast,
      1.f);
  float3 response_input_lms = psycho30_ApplyAdaptiveLMSPurity(
      graded_lms,
      anchor_in_lms,
      purity_delta);

  // -------------------------------------------------------------------------
  // Positive finite-G response and Mean-A2 direction authoring.
  // -------------------------------------------------------------------------
  float target_rgb_peak = peak_value;
  float3 target_peak_lms = PSYCHO30_D65_WHITE_LMS * target_rgb_peak;
  float response_h = compression;
  [branch]
  if (compression == PSYCHO30_AUTO_COMPRESSION_SENTINEL) {
    response_h = psycho30_AutoCompressionPower(
        renodx::color::yf::from::LMS(anchor_out_lms),
        psycho30_TargetNeutralYfLimit(
            target_rgb_peak,
            anchor_in_lms,
            gamut_compression_mode));
  }

  float response_yf;
  uint response_valid;
  float3 desired_coord = psycho30_MeanA2Response(
      response_input_lms,
      anchor_in_lms,
      anchor_out_lms,
      target_peak_lms,
      response_power,
      response_h,
      response_yf,
      response_valid);
  [branch]
  if (response_valid == 0u) {
    // Signed cone states use the separate defined-domain path.
    float3 fallback_lms = psycho30_LinearA2Fallback(
        response_input_lms,
        anchor_in_lms,
        anchor_out_lms,
        gamut_compression_mode,
        target_rgb_peak,
        response_power,
        response_h,
        gamut_compression);
    float3 fallback_bt709 = mul(
        PSYCHO30_LMS_TO_BT709_MAT,
        fallback_lms);
    return !any(isnan(fallback_bt709)) && !any(isinf(fallback_bt709))
               ? fallback_bt709
               : float3(0.f, 0.f, 0.f);
  }

  // -------------------------------------------------------------------------
  // Device mapping: exact fixed-direction projection into the selected
  // normalized RGB cube with the post-response physiological-Yf ceiling.
  // -------------------------------------------------------------------------
  float target_compression_weight = gamut_compression;
  float3 selected_coord = desired_coord;
  if (target_compression_weight != 0.f) {
    uint solve_valid;
    float3 solved_coord = psycho30_YfCeilingSolve(
        desired_coord,
        response_yf,
        gamut_compression_mode,
        solve_valid);
    if (solve_valid == 0u) return float3(0.f, 0.f, 0.f);
    selected_coord = target_compression_weight == 1.f
                         ? solved_coord
                         : lerp(
                               desired_coord,
                               solved_coord,
                               target_compression_weight);
  }

  // Direct inverse A2/Yf basis to linear BT.709. This is algebraically the
  // normalized cone-coordinate inverse plus LMS-to-BT.709 matrix product.
  float output_a = selected_coord.y * rsqrt(3.f)
                   + PSYCHO30_D65_ALPHA_DELTA
                         * selected_coord.x * rsqrt(2.f)
                   - selected_coord.z * rsqrt(6.f);
  float3 output_bt709 = peak_value
                        * (output_a
                           + selected_coord.x * PSYCHO30_BT709_A2_X_RGB
                           + selected_coord.z * PSYCHO30_BT709_A2_Z_RGB);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : float3(0.f, 0.f, 0.f);
}

static const int PSYCHO30_TARGET_GAMUT_BT709 = 0;
static const int PSYCHO30_TARGET_GAMUT_BT2020 = 1;
static const int PSYCHO30_TARGET_GAMUT_DISPLAY_P3 = 3;

#ifndef PSYCHO30_CUSTOM_SKIP_SANITIZATION
#define PSYCHO30_CUSTOM_SKIP_SANITIZATION 0
#endif

static const int PSYCHO30_CUSTOM_GAMUT_MAPPING_EXACT_PROJECTION = 0;
static const int PSYCHO30_CUSTOM_GAMUT_MAPPING_SOFT_RADIAL = 1;
static const float PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE = 0.9f;
// (0, 1] guarantees monotonic containment; 1 is the firmest valid response.
static const float PSYCHO30_CUSTOM_GAMUT_COMPRESSION_FIRMNESS = 0.65f;
static const float PSYCHO30_CUSTOM_GAMUT_COMPRESSION_EXP2_SCALE = PSYCHO30_CUSTOM_GAMUT_COMPRESSION_FIRMNESS / log(2.f);

static const float3x3 PSYCHO30_LMS_TO_DISPLAY_P3_MAT = mul(
    renodx::color::XYZ_TO_DISPLAYP3_MAT,
    renodx::color::STOCKMAN_CVRL_LMS_TO_XYZ_2DEG_FIT);
static const float3 PSYCHO30_DISPLAY_P3_A2_X_RGB = mul(
    PSYCHO30_LMS_TO_DISPLAY_P3_MAT,
    float3(
        sqrt(2.f) * PSYCHO30_D65_ALPHA_M
            * PSYCHO30_D65_WHITE_LMS.x,
        -sqrt(2.f) * PSYCHO30_D65_ALPHA_L
            * PSYCHO30_D65_WHITE_LMS.y,
        rsqrt(2.f)
            * (PSYCHO30_D65_ALPHA_M
               - PSYCHO30_D65_ALPHA_L)
            * PSYCHO30_D65_WHITE_LMS.z));
static const float3 PSYCHO30_DISPLAY_P3_A2_Z_RGB = mul(
    PSYCHO30_LMS_TO_DISPLAY_P3_MAT,
    float3(0.f, 0.f, sqrt(6.f) * 0.5f * PSYCHO30_D65_WHITE_LMS.z));

// Streamlined Test30 variant. Anchored tonal grading replaces the original
// scalar-Yf highlights/shadows, common cone power, and finite-G response. Its
// output anchor is also the exact C-infinity shoulder anchor. The resulting
// per-cone response still supplies Test30's Mean-A2 direction/radius and exact
// fixed-direction target-cube projection.
float3 psycho30_CustomCInfinityTransition(float3 position) {
  position = saturate(position);
  return rcp(1.f + exp2((1.f - 2.f * position) / (position * (1.f - position))));
}

float3 psycho30_ApplyAnchoredTonalGrading(
    float3 color,
    float3 anchor_in, float3 anchor_out,
    float contrast, float flare,
    float highlight_contrast, float shadow_contrast,
    float highlights, float shadows) {
  [branch]
  if (contrast == 1.f && flare == 0.f
      && highlight_contrast == 1.f && shadow_contrast == 1.f
      && highlights == 1.f && shadows == 1.f
      && all(anchor_in == anchor_out)) {
    return color;
  }

  float3 normalized = color / anchor_in;
  float3 graded_normalized = normalized;

  // Power contrast below the anchor and bounded log-domain contrast above it.
  // Flare increases only the deep-shadow exponent.
  [branch]
  if (contrast != 1.f || flare > 0.f) {
    float3 exponent = contrast;

    [branch]
    if (flare > 0.f) {
      float3 shadow_distance = saturate(1.f - normalized);
      float3 flat_shadow_weight = exp2(-normalized / shadow_distance);
      exponent *= mad(flat_shadow_weight, flare / (normalized + flare), 1.f);
    }

    float3 input_stops = log2(normalized);
    float3 highlight_stops = max(input_stops, 0.f);
    float3 output_highlight_stops = highlight_stops;

    [branch]
    if (contrast != 1.f) {
      float3 displacement = (contrast - 1.f) * highlight_stops;
      float3 displacement_magnitude = abs(displacement);
      output_highlight_stops += displacement / mad(displacement_magnitude, exp2(-1.f / displacement_magnitude), 1.f);
    }

    graded_normalized = exp2(mad(exponent, min(input_stops, 0.f), output_highlight_stops));
  }

  [branch]
  if (highlight_contrast != 1.f) {
    float3 distance = max(graded_normalized - 1.f, 0.f);
    float3 distance_squared = distance * distance;
    float3 flat_distance = (1.f + distance_squared) * exp2(-1.f / distance_squared);
    graded_normalized += distance * (pow(1.f + flat_distance, 0.5f * (highlight_contrast - 1.f)) - 1.f);
  }

  [branch]
  if (shadow_contrast != 1.f) {
    float3 distance = saturate(1.f - graded_normalized);
    float3 distance_squared = distance * distance;
    float3 flat_distance = distance_squared * distance * exp2(1.f - 1.f / distance_squared);
    graded_normalized *= pow(1.f + flat_distance, 1.f - shadow_contrast);
  }

  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    static const float TONAL_OFFSET_START_STOPS = 1.f;
    static const float TONAL_OFFSET_END_STOPS = 8.f;
    static const float TONAL_OFFSET_INVERSE_RANGE_STOPS = 1.f / (TONAL_OFFSET_END_STOPS - TONAL_OFFSET_START_STOPS);

    float3 tonal_stops = log2(graded_normalized);
    float3 tonal_displacement = 0.f;

    [branch]
    if (highlights != 1.f) {
      float adjustment = highlights - 1.f;
      float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      float3 weight = psycho30_CustomCInfinityTransition(
          (tonal_stops - TONAL_OFFSET_START_STOPS)
          * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    [branch]
    if (shadows != 1.f) {
      float adjustment = shadows - 1.f;
      float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      float3 weight = psycho30_CustomCInfinityTransition(
          (-TONAL_OFFSET_START_STOPS - tonal_stops)
          * TONAL_OFFSET_INVERSE_RANGE_STOPS);
      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    graded_normalized *= exp2(tonal_displacement);
  }

  return graded_normalized * anchor_out;
}

// Shared grading stage for the grading-only and complete tonemap paths.
float3 psycho30_GradeCustomLMS(
    float3 grading_source_lms,
    float3 anchor_in_lms,
    float3 anchor_out_lms,
    float highlights,
    float shadows,
    float contrast,
    float flare,
    float highlight_contrast,
    float shadow_contrast,
    float purity_scale,
    float highlight_saturation,
    float dechroma,
    float sdr_eotf_emulation,
    out float3 tonal_input_lms) {
  tonal_input_lms = grading_source_lms;
  [branch]
  if (purity_scale != 1.f || highlight_saturation != 1.f || dechroma != 0.f) {
    float effective_purity_scale = purity_scale;

    // Author the highlight controls in the same adaptation-relative Yf
    // coordinate used by the corrected LMS purity interpolation.
    [branch]
    if (dechroma != 0.f || highlight_saturation != 1.f) {
      static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
      static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
      static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

      float source_relative_yf = max(renodx::color::yf::from::LMS(grading_source_lms / anchor_in_lms), 0.f);
      float neutral_relative_yf = renodx::color::yf::from::LMS(float3(1.f, 1.f, 1.f));
      float luminance_from_neutral = max(source_relative_yf, neutral_relative_yf) / neutral_relative_yf;
      float rolloff_position = saturate(log2(luminance_from_neutral) * INVERSE_HIGHLIGHT_RANGE_STOPS);
      float rolloff_position_squared = rolloff_position * rolloff_position;
      float rolloff = rolloff_position_squared * rolloff_position
                      * mad(rolloff_position, mad(6.f, rolloff_position, -15.f), 10.f);

      if (dechroma != 0.f) {
        effective_purity_scale *= mad(-dechroma, rolloff, 1.f);
      }

      if (highlight_saturation != 1.f) {
        float highlight_rolloff = rolloff * rolloff
                                  * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff,
                                        1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
        effective_purity_scale *= mad(highlight_saturation - 1.f,
                                      highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
      }
    }

    tonal_input_lms = psycho30_ApplyAdaptiveLMSPurity(
        grading_source_lms, anchor_in_lms, effective_purity_scale);
  }
  tonal_input_lms = max(tonal_input_lms, 0.f);

  // Grade the three physical LMS cone components independently after purity.
  // Physiological Yf is not used by the tonal grading stage.
  if (sdr_eotf_emulation != 0.f) {
    tonal_input_lms = renodx::color::correct::GammaSafe(
                          tonal_input_lms / PSYCHO30_D65_WHITE_LMS)
                      * PSYCHO30_D65_WHITE_LMS;
  }

  return psycho30_ApplyAnchoredTonalGrading(
      tonal_input_lms,
      anchor_in_lms,
      anchor_out_lms,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      highlights,
      shadows);
}

float3 psycho30_ApplyAnchoredCInfinityShoulder(
    float3 color,
    float3 peak,
    float3 anchor,
    float compression_strength) {
  float3 shoulder_range = peak - anchor;
  float3 distance_from_anchor = max(color - anchor, 0.f);
  float3 flat_weight = exp2(-shoulder_range / (compression_strength * distance_from_anchor));
  float3 response_denominator = mad(distance_from_anchor, flat_weight, shoulder_range);
  return mad(shoulder_range, distance_from_anchor / response_denominator, color - distance_from_anchor);
}

// Construct Test30's orthonormal response coordinate from the precomputed
// nonnegative per-cone response. A source weight of 0 selects the response
// direction; 1 reproduces Test30's exact source/response angular midpoint.
float3 psycho30_MeanA2ResponseFromCustomResponse(
    float3 source_q,
    float3 response_u,
    float source_direction_weight,
    out float response_yf,
    out uint valid) {
  valid = all(source_q >= float3(0.f, 0.f, 0.f))
                  && all(response_u >= float3(0.f, 0.f, 0.f))
                  && !any(isnan(source_q))
                  && !any(isinf(source_q))
                  && !any(isnan(response_u))
                  && !any(isinf(response_u))
              ? 1u
              : 0u;
  if (valid == 0u) {
    response_yf = 0.f;
    return float3(0.f, 0.f, 0.f);
  }

  float2 source_a2 = float2(
      (source_q.x - source_q.y) * rsqrt(2.f),
      (2.f * source_q.z - source_q.x - source_q.y) * rsqrt(6.f));
  float2 response_a2 = float2(
      (response_u.x - response_u.y) * rsqrt(2.f),
      (2.f * response_u.z - response_u.x - response_u.y) * rsqrt(6.f));
  float2 authored_a2 = response_a2;
  float source_radius2 = dot(source_a2, source_a2);
  float response_radius2 = dot(response_a2, response_a2);

  if (source_radius2 > PSYCHO30_EPSILON2
      && response_radius2 > PSYCHO30_EPSILON2) {
    float inverse_response_radius = rsqrt(response_radius2);
    float response_radius = response_radius2 * inverse_response_radius;
    float2 mean_direction = mad(
        source_a2,
        rsqrt(source_radius2) * source_direction_weight,
        response_a2 * inverse_response_radius);
    float mean_radius2 = dot(mean_direction, mean_direction);
    if (mean_radius2 > PSYCHO30_EPSILON2) {
      authored_a2 = mean_direction
                    * rsqrt(mean_radius2)
                    * response_radius;
    }
  }

  response_yf = PSYCHO30_D65_ALPHA_L * response_u.x
                + PSYCHO30_D65_ALPHA_M * response_u.y;
  return float3(
      authored_a2.x,
      (response_u.x + response_u.y + response_u.z) * rsqrt(3.f),
      authored_a2.y);
}

// Preserve the custom path's authored A2 direction and desired physiological
// A while smoothly reducing radius against all six target RGB-cube planes.
// The response Yf remains an upper A ceiling. Working in scale space avoids
// direction normalization and keeps the common below-knee path division-free.
float3 psycho30_ApplyCustomSoftRadialGamutCompression(
    float3 desired_coord,
    float response_yf,
    int target_gamut_mode,
    out uint valid) {
  valid = !any(isnan(desired_coord))
                  && !any(isinf(desired_coord))
                  && !isnan(response_yf)
                  && !isinf(response_yf)
              ? 1u
              : 0u;
  if (valid == 0u) return float3(0.f, 0.f, 0.f);

  float radial_yf = PSYCHO30_D65_ALPHA_DELTA
                        * desired_coord.x * rsqrt(2.f)
                    - desired_coord.z * rsqrt(6.f);
  float desired_a = desired_coord.y * rsqrt(3.f) + radial_yf;
  float mapped_a = clamp(desired_a, 0.f, saturate(response_yf));
  float3 radial_rgb;
  [branch]
  if (target_gamut_mode == PSYCHO30_TARGET_GAMUT_BT709) {
    radial_rgb = desired_coord.x * PSYCHO30_BT709_A2_X_RGB
                 + desired_coord.z * PSYCHO30_BT709_A2_Z_RGB;
  } else if (target_gamut_mode == PSYCHO30_TARGET_GAMUT_DISPLAY_P3) {
    radial_rgb = desired_coord.x * PSYCHO30_DISPLAY_P3_A2_X_RGB
                 + desired_coord.z * PSYCHO30_DISPLAY_P3_A2_Z_RGB;
  } else {
    radial_rgb = desired_coord.x * PSYCHO30_BT2020_A2_X_RGB
                 + desired_coord.z * PSYCHO30_BT2020_A2_Z_RGB;
  }

  float positive_pressure = renodx::math::Max(radial_rgb);
  float negative_pressure = -renodx::math::Min(radial_rgb);
  if (positive_pressure
          <= PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE * (1.f - mapped_a)
      && negative_pressure
             <= PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE * mapped_a) {
    return float3(
        desired_coord.x,
        sqrt(3.f) * (mapped_a - radial_yf),
        desired_coord.z);
  }

  float support_scale = PSYCHO30_LARGE_SUPPORT;
  if (positive_pressure > PSYCHO30_EPSILON) {
    support_scale = min(
        support_scale,
        (1.f - mapped_a) / positive_pressure);
  }
  if (negative_pressure > PSYCHO30_EPSILON) {
    support_scale = min(
        support_scale,
        mapped_a / negative_pressure);
  }
  if (!(support_scale < PSYCHO30_LARGE_SUPPORT)) {
    return float3(
        desired_coord.x,
        sqrt(3.f) * (mapped_a - radial_yf),
        desired_coord.z);
  }

  support_scale = max(support_scale, 0.f);
  float knee_scale =
      PSYCHO30_CUSTOM_GAMUT_COMPRESSION_KNEE * support_scale;
  float headroom = support_scale - knee_scale;
  float excess = 1.f - knee_scale;
  float headroom_per_excess = headroom * rcp(excess);
  float flat_weight = exp2(-PSYCHO30_CUSTOM_GAMUT_COMPRESSION_EXP2_SCALE * headroom_per_excess);
  float mapped_scale = knee_scale + headroom * rcp(headroom_per_excess + flat_weight);
  mapped_scale = clamp(
      mapped_scale,
      0.f,
      min(1.f, support_scale));

  float2 mapped_a2 = desired_coord.xz * mapped_scale;
  float mapped_c0 = sqrt(3.f)
                    * (mapped_a - radial_yf * mapped_scale);
  float3 mapped_coord = float3(mapped_a2.x, mapped_c0, mapped_a2.y);
  valid = !any(isnan(mapped_coord)) && !any(isinf(mapped_coord)) ? 1u : 0u;
  return valid != 0u ? mapped_coord : float3(0.f, 0.f, 0.f);
}

// The original Test30 solve keeps its BT.709/BT.2020 behavior unchanged.
// This custom-only copy extends the corrected solve to Display P3.
float3 psycho30_CustomYfCeilingSolve(
    float3 desired_coord,
    float response_yf,
    int target_gamut_mode,
    out uint valid) {
  if (target_gamut_mode != PSYCHO30_TARGET_GAMUT_DISPLAY_P3) {
    return psycho30_YfCeilingSolve(
        desired_coord,
        response_yf,
        target_gamut_mode,
        valid);
  }

  valid = !any(isnan(desired_coord))
                  && !any(isinf(desired_coord))
                  && !isnan(response_yf)
                  && !isinf(response_yf)
              ? 1u
              : 0u;
  if (valid == 0u) return float3(0.f, 0.f, 0.f);

  float max_a = saturate(response_yf);
  float radial_yf = PSYCHO30_D65_ALPHA_DELTA
                        * desired_coord.x * rsqrt(2.f)
                    - desired_coord.z * rsqrt(6.f);
  float desired_a = desired_coord.y * rsqrt(3.f) + radial_yf;
  float3 radial_rgb =
      desired_coord.x * PSYCHO30_DISPLAY_P3_A2_X_RGB
      + desired_coord.z * PSYCHO30_DISPLAY_P3_A2_Z_RGB;
  float3 desired_target_rgb = desired_a + radial_rgb;
  if (desired_a >= 0.f
      && desired_a <= max_a
      && all(desired_target_rgb >= float3(
                 -PSYCHO30_EPSILON,
                 -PSYCHO30_EPSILON,
                 -PSYCHO30_EPSILON))
      && all(desired_target_rgb <= float3(
                 1.f + PSYCHO30_EPSILON,
                 1.f + PSYCHO30_EPSILON,
                 1.f + PSYCHO30_EPSILON))) {
    return desired_coord;
  }

  float desired_rho2 = dot(desired_coord.xz, desired_coord.xz);
  if (!(desired_rho2 > PSYCHO30_EPSILON2)) {
    return float3(
        0.f,
        clamp(desired_coord.y, 0.f, sqrt(3.f) * max_a),
        0.f);
  }

  float positive_pressure = renodx::math::Max(radial_rgb);
  float negative_pressure = -renodx::math::Min(radial_rgb);
  if (!(positive_pressure > 0.f)
      || !(negative_pressure > 0.f)) {
    valid = 0u;
    return float3(0.f, 0.f, 0.f);
  }

  float inverse_positive = rcp(positive_pressure);
  float inverse_negative = rcp(negative_pressure);
  float inverse_pressure_sum = rcp(
      positive_pressure + negative_pressure);
  float apex_a = negative_pressure * inverse_pressure_sum;
  float upper_a = min(max_a, apex_a);
  float max_a_scale = min(
      max_a * inverse_negative,
      (1.f - max_a) * inverse_positive);
  float upper_scale = min(
      max_a * inverse_negative,
      inverse_pressure_sum);
  float2 vertex0 = float2(0.f, 0.f);
  float2 vertex1 = float2(sqrt(3.f) * max_a, 0.f);
  float2 vertex2 = float2(
      sqrt(3.f) * (max_a - radial_yf * max_a_scale),
      max_a_scale);
  float2 vertex3 = float2(
      sqrt(3.f) * (upper_a - radial_yf * upper_scale),
      upper_scale);
  float2 best_c0_scale = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex0,
      vertex1);
  float2 best_delta = best_c0_scale - float2(desired_coord.y, 1.f);
  float best_cost = best_delta.x * best_delta.x
                    + desired_rho2 * best_delta.y * best_delta.y;

  float2 candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex1,
      vertex2);
  float2 candidate_delta = candidate - float2(desired_coord.y, 1.f);
  float candidate_cost = candidate_delta.x * candidate_delta.x
                         + desired_rho2 * candidate_delta.y * candidate_delta.y;
  if (candidate_cost < best_cost) {
    best_c0_scale = candidate;
    best_cost = candidate_cost;
  }

  candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex2,
      vertex3);
  candidate_delta = candidate - float2(desired_coord.y, 1.f);
  candidate_cost = candidate_delta.x * candidate_delta.x
                   + desired_rho2 * candidate_delta.y * candidate_delta.y;
  if (candidate_cost < best_cost) {
    best_c0_scale = candidate;
    best_cost = candidate_cost;
  }

  candidate = psycho30_ClosestPointOnScaleSegment(
      desired_coord.y,
      desired_rho2,
      vertex0,
      vertex3);
  candidate_delta = candidate - float2(desired_coord.y, 1.f);
  candidate_cost = candidate_delta.x * candidate_delta.x
                   + desired_rho2 * candidate_delta.y * candidate_delta.y;
  if (candidate_cost < best_cost) {
    best_c0_scale = candidate;
  }

  float3 solved_coord = float3(
      desired_coord.x * max(best_c0_scale.y, 0.f),
      best_c0_scale.x,
      desired_coord.z * max(best_c0_scale.y, 0.f));
  valid = !any(isnan(solved_coord)) && !any(isinf(solved_coord)) ? 1u : 0u;
  return valid != 0u ? solved_coord : float3(0.f, 0.f, 0.f);
}

// Grading-only Custom Test30 path. Input and output are direct linear-light
// BT.709; only the exposure, adaptation-relative LMS purity, and anchored LMS
// tonal-grade stages are applied.
float3 psychograde_custom_test30(
    float3 bt709_linear_input,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float highlight_contrast = 1.f,
    float shadow_contrast = 1.f,
    float purity_scale = 1.f,
    float highlight_saturation = 1.f,
    float dechroma = 0.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f) {
#if PSYCHO30_CUSTOM_SKIP_SANITIZATION
  float3 source_bt709 = bt709_linear_input * exposure;
#else
  float3 finite_input = renodx::math::ZeroNaN(bt709_linear_input);
  finite_input = renodx::math::Select(
      isinf(finite_input),
      renodx::math::CopySign(
          float3(
              PSYCHO30_MAX_FINITE_INPUT,
              PSYCHO30_MAX_FINITE_INPUT,
              PSYCHO30_MAX_FINITE_INPUT),
          finite_input),
      finite_input);
  float3 source_bt709 = finite_input * exposure;
#endif
  float3 source_lms = psycho30_ClampSourceAP1ToPositiveLMS(source_bt709);
  if (all(source_lms == float3(0.f, 0.f, 0.f))) {
    return float3(0.f, 0.f, 0.f);
  }

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_background_state_bt709);
  float3 tonal_input_lms;
  float3 graded_lms = psycho30_GradeCustomLMS(
      source_lms,
      anchor_in_lms,
      anchor_out_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      0.f,
      tonal_input_lms);

  float3 output_bt709 = mul(PSYCHO30_LMS_TO_BT709_MAT, graded_lms);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : float3(0.f, 0.f, 0.f);
}

float3 psychotm_custom_test30(
    float3 bt709_linear_input,
    float peak_value = 1000.f / 203.f,
    float exposure = 1.f,
    float highlights = 1.f,
    float shadows = 1.f,
    float contrast = 1.f,
    float flare = 0.f,
    float highlight_contrast = 1.f,
    float shadow_contrast = 1.f,
    float purity_scale = 1.f,
    float highlight_saturation = 1.f,
    float dechroma = 0.f,
    float3 current_adaptive_state_bt709 = 0.18f,
    float3 current_background_state_bt709 = 0.18f,
    float sdr_eotf_emulation = 0.f,
    float gamut_compression = 1.f,
    int gamut_compression_mode = PSYCHO30_TARGET_GAMUT_BT2020,
    float compression = 1.5f,
    float mean_a2_source_weight = 1.f,
    int gamut_mapping_method = PSYCHO30_CUSTOM_GAMUT_MAPPING_SOFT_RADIAL) {
#if PSYCHO30_CUSTOM_SKIP_SANITIZATION
  float3 source_bt709 = bt709_linear_input * exposure;
#else
  // Sanitize non-finite values before the independent AP1/LMS gamut policy.
  float3 finite_input = renodx::math::ZeroNaN(bt709_linear_input);
  finite_input = renodx::math::Select(
      isinf(finite_input),
      renodx::math::CopySign(
          float3(
              PSYCHO30_MAX_FINITE_INPUT,
              PSYCHO30_MAX_FINITE_INPUT,
              PSYCHO30_MAX_FINITE_INPUT),
          finite_input),
      finite_input);
  float3 source_bt709 = finite_input * exposure;
#endif
  float3 source_lms = psycho30_ClampSourceAP1ToPositiveLMS(source_bt709);
  if (all(source_lms == float3(0.f, 0.f, 0.f))) {
    return float3(0.f, 0.f, 0.f);
  }

  float3 anchor_in_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_adaptive_state_bt709);
  float3 anchor_out_lms = mul(
      PSYCHO30_BT709_TO_LMS_MAT,
      current_background_state_bt709);
  float3 target_peak_lms = PSYCHO30_D65_WHITE_LMS * peak_value;

  // Preserve the pre-tonal LMS state for Test30's source-direction authoring.
  float3 tonal_input_lms;
  float3 graded_lms = psycho30_GradeCustomLMS(
      source_lms,
      anchor_in_lms,
      anchor_out_lms,
      highlights,
      shadows,
      contrast,
      flare,
      highlight_contrast,
      shadow_contrast,
      purity_scale,
      highlight_saturation,
      dechroma,
      sdr_eotf_emulation,
      tonal_input_lms);
  float3 response_lms = psycho30_ApplyAnchoredCInfinityShoulder(
      graded_lms,
      target_peak_lms,
      anchor_out_lms,
      compression);

  float3 source_q = tonal_input_lms / anchor_in_lms;
  float3 response_u = response_lms / target_peak_lms;
  float response_yf;
  uint response_valid;
  float3 desired_coord = psycho30_MeanA2ResponseFromCustomResponse(
      source_q,
      response_u,
      mean_a2_source_weight,
      response_yf,
      response_valid);
  if (response_valid == 0u) return float3(0.f, 0.f, 0.f);

  float3 selected_coord = desired_coord;
  if (gamut_compression != 0.f) {
    uint solve_valid;
    float3 solved_coord;
    [branch]
    if (gamut_mapping_method == PSYCHO30_CUSTOM_GAMUT_MAPPING_EXACT_PROJECTION) {
      solved_coord = psycho30_CustomYfCeilingSolve(
          desired_coord,
          response_yf,
          gamut_compression_mode,
          solve_valid);
    } else {
      solved_coord = psycho30_ApplyCustomSoftRadialGamutCompression(
          desired_coord,
          response_yf,
          gamut_compression_mode,
          solve_valid);
    }
    if (solve_valid == 0u) return float3(0.f, 0.f, 0.f);
    selected_coord = gamut_compression == 1.f
                         ? solved_coord
                         : lerp(
                               desired_coord,
                               solved_coord,
                               gamut_compression);
  }

  float output_a = selected_coord.y * rsqrt(3.f) + PSYCHO30_D65_ALPHA_DELTA * selected_coord.x * rsqrt(2.f) - selected_coord.z * rsqrt(6.f);
  float3 output_bt709 = peak_value * (output_a + selected_coord.x * PSYCHO30_BT709_A2_X_RGB + selected_coord.z * PSYCHO30_BT709_A2_Z_RGB);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709))
             ? output_bt709
             : float3(0.f, 0.f, 0.f);
}

}  // namespace psychov
}  // namespace tonemap
}  // namespace renodx

#endif  // PSYCHOV_CUSTOMTEST30_HLSLI_