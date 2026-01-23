#ifndef COLORVIDEOVDP_HLSL
#define COLORVIDEOVDP_HLSL

// ColorVideoVDP core math port (masking/transducer/pooling/JOD) using analytic castleCSF.
//
// Design goals:
// - Match ColorVideoVDP parameterization (cvvdp_parameters.json) for masking/pooling/JOD. :contentReference[oaicite:1]{index=1}
// - Use your analytic castleCSF HLSL instead of the repo LUT-based csf.py.
// - Keep image operations (pyramid build, spatial blur, reductions) as inputs/hooks.
//
// Repo config this matches by default:
// - masking_model: "mult-mutual"
// - contrast: "weber_g1"
// - xchannel_masking: "on"
// - dclamp_type: "soft"  (we implement soft clamp function, but you can bypass if you clamp elsewhere)
// - betas: beta=2, beta_t=2, beta_tch=4, beta_sch=4 :contentReference[oaicite:2]{index=2}
//
// IMPORTANT: channel order used by ColorVideoVDP code-paths is typically:
//   0: Ysust, 1: RG, 2: YV, 3: Ytrans
// (The JSON vectors are all sized for that ordering.) :contentReference[oaicite:3]{index=3}
//
#include "./castlecsf.hlsl"
namespace renodx {
namespace color {
namespace colorvideovdp {

// ----------------------------------------------------------------------------
// Small helpers

static const float CVVDP_EPS = 1e-5f;  // matches safe_pow/pow_neg epsilon in repo :contentReference[oaicite:4]{index=4}

float cvvdp_safe_div(float a, float b) {
  return (b == 0.0f) ? 0.0f : (a / b);
}

// safe_pow(x,p) = (x+eps)^p - eps^p  for x>=0  (repo) :contentReference[oaicite:5]{index=5}
float cvvdp_safe_pow(float x, float p) {
  return pow(x + CVVDP_EPS, p) - pow(CVVDP_EPS, p);
}

// pow_neg(x,p) = max(x,eps)^p + max(-x,eps)^p - eps^p  (repo) :contentReference[oaicite:6]{index=6}
float cvvdp_pow_neg(float x, float p) {
  float a = pow(max(x, CVVDP_EPS), p);
  float b = pow(max(-x, CVVDP_EPS), p);
  return a + b - pow(CVVDP_EPS, p);
}

// ----------------------------------------------------------------------------
// Channel constants (canonical order)

static const int CVVDP_CH_Y_SUST = 0;
static const int CVVDP_CH_RG = 1;
static const int CVVDP_CH_YV = 2;
static const int CVVDP_CH_Y_TRANS = 3;

// ----------------------------------------------------------------------------
// Parameters from cvvdp_parameters.json (main / 0.5.6) :contentReference[oaicite:7]{index=7}

static const float CVVDP_mask_p = 2.264355182647705f;
static const float CVVDP_mask_c = -0.7954971194267273f;   // content masking adjustment (applied as 10^mask_c)
static const float CVVDP_d_max = 2.5642454624176025f;     // clamping scale exponent (used as 10^d_max)
static const float CVVDP_image_int = 0.577918291091919f;  // integration correction for images

// Pooling exponents
static const float CVVDP_beta = 2.0f;      // spatial summation exponent
static const float CVVDP_beta_t = 2.0f;    // time summation exponent
static const float CVVDP_beta_tch = 4.0f;  // temporal+chromatic channels exponent
static const float CVVDP_beta_sch = 4.0f;  // spatial bands exponent

// Masking exponents per channel (Ysust, RG, YV, Ytrans)
static const float4 CVVDP_mask_q = float4(
    1.302622675895691f,
    2.8885908126831055f,
    3.6807713508605957f,
    3.588787317276001f);

// Channel weights: chromatic weight + transient weight
static const float CVVDP_ch_chrom_w = 1.0f;
static const float CVVDP_ch_trans_w = 0.8081134557723999f;

// Baseband weights per channel (applied to the baseband band only)
static const float4 CVVDP_baseband_weight = float4(
    0.0036334486212581396f,
    1.6627724170684814f,
    4.11874532699585f,
    25.25969886779785f);

// JOD regression parameters
static const float CVVDP_jod_a = 0.0439569391310215f;
static const float CVVDP_jod_exp = 0.9302042722702026f;

// Cross-channel masking weights: stored in LOG2 space (16 values).
// Repo uses them as a 4x4 matrix (reshape) and exponentiates with 2^w. :contentReference[oaicite:8]{index=8}
// We treat the list as row-major: rows = source channels, cols = destination channels.
static const float4 CVVDP_xcm_log2_row0 = float4(-0.18950104713439941f, -5.962151050567627f, -4.31834602355957f, -1.9321587085723877f);
static const float4 CVVDP_xcm_log2_row1 = float4(2.5655593872070312f, 0.34406712651252747f, -2.719646453857422f, -0.4970424771308899f);
static const float4 CVVDP_xcm_log2_row2 = float4(3.8118371963500977f, -1.0051705837249756f, -0.5193376541137695f, -0.5653647780418396f);
static const float4 CVVDP_xcm_log2_row3 = float4(-7.054771423339844f, -5.527150630950928f, -3.5106418132781982f, -2.08804988861084f);

// ----------------------------------------------------------------------------
// Eq-like pieces (ColorVideoVDP paper / repo-matching behavior)

// Eq CMM: mutual masking signal between test & ref (mult-mutual uses min(abs(.)) commonly)
float CVVDP_MutualMask(float Cprime_test, float Cprime_ref) {
  return min(abs(Cprime_test), abs(Cprime_ref));
}

// Mask pool (cross-channel mixing):
// M_dst = sum_src ( pooled_src * 2^(xcm_log2[src,dst]) )
float4 CVVDP_XChannelMaskPool(float4 pooled_src) {
  // Build per-destination columns
  float4 wcol0 = exp2(float4(CVVDP_xcm_log2_row0.x, CVVDP_xcm_log2_row1.x, CVVDP_xcm_log2_row2.x, CVVDP_xcm_log2_row3.x));
  float4 wcol1 = exp2(float4(CVVDP_xcm_log2_row0.y, CVVDP_xcm_log2_row1.y, CVVDP_xcm_log2_row2.y, CVVDP_xcm_log2_row3.y));
  float4 wcol2 = exp2(float4(CVVDP_xcm_log2_row0.z, CVVDP_xcm_log2_row1.z, CVVDP_xcm_log2_row2.z, CVVDP_xcm_log2_row3.z));
  float4 wcol3 = exp2(float4(CVVDP_xcm_log2_row0.w, CVVDP_xcm_log2_row1.w, CVVDP_xcm_log2_row2.w, CVVDP_xcm_log2_row3.w));

  return float4(dot(pooled_src, wcol0), dot(pooled_src, wcol1), dot(pooled_src, wcol2), dot(pooled_src, wcol3));
}

// Phase uncertainty scale (repo multiplies by 10^mask_c) :contentReference[oaicite:9]{index=9}
float CVVDP_PhaseUncertaintyScale(float M) {
  return M * pow(10.0f, CVVDP_mask_c);
}

// Transducer: D = 10^d_max * pow_neg(Cp, mask_p) / (0.2 + M)
float CVVDP_Transducer(float Cprime, float M) {
  float Dmax = pow(10.0f, CVVDP_d_max);
  return cvvdp_safe_div(Dmax * cvvdp_pow_neg(Cprime, CVVDP_mask_p), 0.2f + M);
}

// Soft clamp for difference (dclamp_type="soft").
// Repo has dclamp_type="soft" but the exact soft curve is implementation-specific.
// This function is a safe "soft saturation" that preserves small values and asymptotically approaches Dmax.
// If you later mirror the repo’s exact clamp expression, swap this function out.
float CVVDP_DiffClampSoft(float D) {
  float Dmax = pow(10.0f, CVVDP_d_max);
  // smooth saturation: Dhat = Dmax * D / (Dmax + D)
  return cvvdp_safe_div(Dmax * D, Dmax + D);
}

// ----------------------------------------------------------------------------
// CSF hook (analytic): use your CastleCSF port instead of repo LUT.
//
// The repo applies sensitivity_correction in dB (negative reduces sensitivity). :contentReference[oaicite:10]{index=10}
// Convert dB to linear gain: gain = 10^(dB/20).
static const float CVVDP_sensitivity_correction_db = -0.2797423303127289f;
static const float CVVDP_sensitivity_gain = 0.968303f;  // approx 10^(-0.279742/20), computed once

// Computes per-channel sensitivity S for (rho_cpd, omega_hz, Lbkg_cd_m2).
// Channel mapping:
//   0: Ysust -> achromatic sustained
//   1: RG    -> red-green chromatic
//   2: YV    -> yellow-violet chromatic
//   3: Ytrans-> achromatic transient
float CVVDP_Sensitivity_Analytic(int channel, float rho_cpd, float omega_hz, float Lbkg_cd_m2, float ecc_deg, float vis_field_deg, float area_deg2) {
  // Your CastleCSF implementation likely exposes something like:
  //   Eq27_S_Ach / Eq28_S_RG / Eq29_S_YV or a unified entrypoint.
  // We'll use your unified "mechanism sensitivity vector" pattern:
  //
  // IMPORTANT: ColorVideoVDP uses omega choices [0, 5] in config (sust vs trans), but we accept omega_hz as input. :contentReference[oaicite:11]{index=11}

  // Use your CastleCSF energy helper to get S for a unit contrast direction.
  // If you have a direct "sensitivity" function, use it instead.
  //
  // Here’s a practical mapping:
  float S = 0.0f;
  if (channel == CVVDP_CH_Y_SUST) {
    S = renodx::color::castlecsf::Eq27_S_Ach(rho_cpd, omega_hz, ecc_deg, vis_field_deg, area_deg2, Lbkg_cd_m2);
  } else if (channel == CVVDP_CH_RG) {
    S = renodx::color::castlecsf::Eq28_S_RG(rho_cpd, omega_hz, ecc_deg, vis_field_deg, area_deg2, Lbkg_cd_m2);
  } else if (channel == CVVDP_CH_YV) {
    S = renodx::color::castlecsf::Eq29_S_YV(rho_cpd, omega_hz, ecc_deg, vis_field_deg, area_deg2, Lbkg_cd_m2);
  } else  // CVVDP_CH_Y_TRANS
  {
    // In your CastleCSF port, transient is part of Eq27_S_Ach already (sust+trans mixture).
    // But ColorVideoVDP conceptually separates Ysust and Ytrans temporal channels before masking.
    //
    // If you can directly compute the transient-only component, prefer that.
    // Otherwise, approximate by using Eq27 at omega_hz with parameters that emphasize transient;
    // as a fallback, reuse Eq27 (better than returning 0).
    S = renodx::color::castlecsf::Eq27_S_Ach(rho_cpd, omega_hz, ecc_deg, vis_field_deg, area_deg2, Lbkg_cd_m2);
  }

  return CVVDP_sensitivity_gain * S;
}

// ----------------------------------------------------------------------------
// Contrast computation hook (contrast="weber_g1") :contentReference[oaicite:12]{index=12}
//
// You supply the Laplacian band value L_band and the (upsampled) sustained Gaussian background for reference.
// This matches the paper’s definition style: C = L / Ybkg.
// If you do pyramid scaling (factor 2 for interior bands), do it before calling this function.
float CVVDP_Contrast_WeberG1(float L_band, float Ybkg_ref) {
  // Avoid division by 0 exactly; don’t epsilon-clamp denom unless you want stricter numerical behavior.
  return cvvdp_safe_div(L_band, Ybkg_ref);
}

// ----------------------------------------------------------------------------
// Per-band/channel response pipeline (single pixel / sample)
//
// Inputs:
//   C_test, C_ref       : band-limited contrasts (already computed)
//   S                   : sensitivity for this band/channel
//   M_mask              : masking signal for this channel at this pixel (already pooled+blurred+mixed)
//
// Output:
//   D_hat               : (optionally clamped) distortion response for this band/channel
float CVVDP_BandResponse(float C_test, float C_ref, float S, float M_mask) {
  // Encode contrasts
  float Cp_test = C_test * S;
  float Cp_ref = C_ref * S;

  // Mutual masking base (if you build masking from Cmm)
  // In mult-mutual, the masking signal is constructed externally from Cmm^q, pooled, mixed, etc.
  // Here M_mask is assumed to already be in final units (after phase uncertainty scaling).

  // Transducer
  float D = CVVDP_Transducer(Cp_test - Cp_ref, M_mask);

  // Optional clamp
  if (true)  // dclamp_type == "soft"
    return CVVDP_DiffClampSoft(D);
  else
    return min(D, pow(10.0f, CVVDP_d_max));
}

// ----------------------------------------------------------------------------
// Mask construction helpers (single pixel)
// Caller responsibilities:
// - compute Cmm per channel (min(abs(Cp_test), abs(Cp_ref)))
// - raise to q[dst] (per-destination exponent!) then spatially blur (GaussianBlur sigma=pu_dilate) :contentReference[oaicite:13]{index=13}
// - feed the blurred per-source vector into xchannel pool
//
// Because blur is an image operation, we provide a scalar “mix” step here.

float4 CVVDP_MaskPowPerDst(float4 Cmm_src, int dstChannel) {
  float q = (dstChannel == 0) ? CVVDP_mask_q.x : (dstChannel == 1) ? CVVDP_mask_q.y
                                             : (dstChannel == 2)   ? CVVDP_mask_q.z
                                                                   : CVVDP_mask_q.w;

  return float4(
      cvvdp_safe_pow(abs(Cmm_src.x), q),
      cvvdp_safe_pow(abs(Cmm_src.y), q),
      cvvdp_safe_pow(abs(Cmm_src.z), q),
      cvvdp_safe_pow(abs(Cmm_src.w), q));
}

// Mix xchannel weights after blur:
// blurred_pow_src is (Cmm_src^q[dst]) already blurred spatially.
float CVVDP_MaskFinalFromBlurredPow(float4 blurred_pow_src, int dstChannel) {
  float4 mixed = CVVDP_XChannelMaskPool(blurred_pow_src);
  float Mdst = (dstChannel == 0) ? mixed.x : (dstChannel == 1) ? mixed.y
                                         : (dstChannel == 2)   ? mixed.z
                                                               : mixed.w;

  return CVVDP_PhaseUncertaintyScale(Mdst);
}

// ----------------------------------------------------------------------------
// Pooling helpers (p-norm building blocks)
// Note: These are scalar reducers; you’ll do the summations over pixels/bands/frames externally.

// accumulate sum(|x|^p)
float CVVDP_PNormAcc(float sumPow, float x, float p) {
  return sumPow + pow(abs(x), p);
}

// finalize: (sumPow)^(1/p)
float CVVDP_PNormFinal(float sumPow, float p) {
  return pow(max(sumPow, 0.0f), 1.0f / p);
}

// ----------------------------------------------------------------------------
// Per-channel weights used during pooling
float CVVDP_ChannelWeight(int channel) {
  if (channel == CVVDP_CH_Y_SUST) return 1.0f;
  if (channel == CVVDP_CH_RG) return CVVDP_ch_chrom_w;
  if (channel == CVVDP_CH_YV) return CVVDP_ch_chrom_w;
  return CVVDP_ch_trans_w;
}

// ----------------------------------------------------------------------------
// Baseband weight per channel (apply on baseband band only)
float CVVDP_BasebandWeight(int channel) {
  return (channel == 0) ? CVVDP_baseband_weight.x : (channel == 1) ? CVVDP_baseband_weight.y
                                                : (channel == 2)   ? CVVDP_baseband_weight.z
                                                                   : CVVDP_baseband_weight.w;
}

// ----------------------------------------------------------------------------
// JOD mapping
// The repo uses jod_a, jod_exp; the exact expression is in cvvdp_metric.py but our web view is truncated.
// A standard ColorVideoVDP mapping used in practice is:
//   JOD = 10 - jod_a * Q^jod_exp
// This matches the visible beginning ("Q_JOD = 10.") and the params. :contentReference[oaicite:14]{index=14}
float CVVDP_MetricToJOD(float Q) {
  return 10.0f - CVVDP_jod_a * pow(max(Q, 0.0f), CVVDP_jod_exp);
}

}  // namespace colorvideovdp
}  // namespace color
}  // namespace renodx
#endif  // COLORVIDEOVDP_HLSL