#ifndef CASTLE_CSF_HLSL
#define CASTLE_CSF_HLSL

#include "../math.hlsl"
#include "./rgb.hlsl"

namespace renodx {
namespace color {
namespace castlecsf {

// ============================================================================
// castleCSF / CastleCSF — “33 equations = 33 functions” HLSL layout
//
// Intent:
// - Provide one HLSL function per PDF equation: Eq01_... through Eq33_...
// - Use MATLAB files as the authoritative reference for syntax/branches:
//     CSF_base.get_lum_dep()
//     CSF_stelaCSF_lum_peak (achromatic sustained/transient + ecc drop)
//     CSF_castleCSF_chrom   (chromatic spatial + ecc drop)
//     CSF_castleCSF         (parameter defaults for ach/rg/yv + ecc_drop params)
//
// Notes:
// - Eccentricity math is included (Eq25/Eq26) exactly as in MATLAB:
//     alpha = min(1, abs(vis_field-180)/90)
//     ecc_drop   = alpha*ecc_drop + (1-alpha)*ecc_drop_nasal
//     ecc_drop_f = alpha*ecc_drop_f + (1-alpha)*ecc_drop_f_nasal
//     a = ecc_drop + rho*ecc_drop_f
//     S *= 10^(-a*ecc)
//   If you pass ecc=0, it collapses to 1 as desired.
// - “Safe divide” here is EXACT (denom == 0), as requested.
//   We do NOT treat tiny denoms as zero.
// - Luminance-domain clamps (lum>=1e-6) remain, because log/pow on <=0 is undefined.
// ============================================================================

// ----------------------------------------------------------------------------
// Parameters (from MATLAB get_default_par)
// ----------------------------------------------------------------------------

// --- ACH parameters (from CSF_stelaCSF_lum_peak.get_default_par) ---
static const float ach_Smax_p0 = 56.4947f;
static const float ach_Smax_p1 = 7.54726f;
static const float ach_Smax_p2 = 0.144532f;
static const float ach_Smax_p3 = 5.58341e-07f;
static const float ach_Smax_p4 = 9.66862e+09f;

static const float ach_fmax_p0 = 1.78119f;
static const float ach_fmax_p1 = 91.5718f;
static const float ach_fmax_p2 = 0.256682f;

static const float ach_bw = 0.000213047f;
static const float ach_a = 0.100207f;

static const float ach_A0 = 157.103f;
static const float ach_f0 = 0.702338f;

// Transient Smax is power law: scale * Y^exp  (CSF_base.get_lum_dep case 2)
static const float ach_trans_Smax_p0 = 0.193434f;  // exponent
static const float ach_trans_Smax_p1 = 2748.09f;   // scale

static const float ach_trans_fmax = 0.000316696f;  // treated as rho_m (peak freq) for truncation
static const float ach_trans_bw = 2.6761f;
static const float ach_trans_a = 0.000241177f;

static const float ach_trans_A0 = 3.81611f;
static const float ach_trans_f0 = 3.01389f;

// Temporal (ach)
static const float ach_sigma_trans = 0.0844836f;
static const float ach_sigma_sust = 10.5795f;
static const float ach_omega_trans_sl = 2.41482f;
static const float ach_omega_trans_c = 4.7036f;

// Eccentricity drop (ach) — from CSF_castleCSF.get_default_par()
static const float ach_ecc_drop = 0.0239853f;
static const float ach_ecc_drop_nasal = 0.0400662f;
static const float ach_ecc_drop_f = 0.0189038f;
static const float ach_ecc_drop_f_nasal = 0.00813619f;

// --- RG chromatic params (from CSF_castleCSF_chrom.get_default_par('rg')) ---
static const float rg_Smax_p0 = 681.434f;
static const float rg_Smax_p1 = 38.0038f;
static const float rg_Smax_p2 = 0.480386f;

static const float rg_fmax = 0.0178364f;
static const float rg_bw = 2.42104f;

static const float rg_A0 = 2816.44f;
static const float rg_f0 = 0.0711058f;

static const float rg_sigma_sust = 16.4325f;
static const float rg_beta_sust = 1.15591f;

// Eccentricity drop (rg) — from CSF_castleCSF.get_default_par()
static const float rg_ecc_drop = 0.0591402f;
static const float rg_ecc_drop_nasal = 2.89615e-05f;
static const float rg_ecc_drop_f = 0.0f;  // 2.04986e-69f
static const float rg_ecc_drop_f_nasal = 0.18108f;

// --- YV chromatic params ---
static const float yv_Smax_p0 = 166.683f;
static const float yv_Smax_p1 = 62.8974f;
static const float yv_Smax_p2 = 0.41193f;

static const float yv_fmax = 0.00425753f;
static const float yv_bw = 2.68197f;

static const float yv_A0 = 2.82789e+07f;
static const float yv_f0 = 0.000635093f;

static const float yv_sigma_sust = 7.15012f;
static const float yv_beta_sust = 0.969123f;

// Eccentricity drop (yv) — from CSF_castleCSF.get_default_par()
static const float yv_ecc_drop = 0.00356865f;
static const float yv_ecc_drop_nasal = 0.0f;  // MATLAB: ~5e-141 → FP32 zero
static const float yv_ecc_drop_f = 0.00806631f;
static const float yv_ecc_drop_f_nasal = 0.0110662f;

// ----------------------------------------------------------------------------
// shared constants
static const float CSF_LN10 = 2.302585092994046f;

// ----------------------------------------------------------------------------
// EXACT safe divide (only treats denom == 0 as unsafe)
float SafeDiv0(float num, float den, float fallback_value) {
  return (den == 0.0f) ? fallback_value : (num / den);
}

// log10/pow10 helpers (avoid name collisions with HLSL log10)
float csf_log10(float x) {
  return log(x) / log(10.0f);
}
float csf_pow10(float x) {
  return exp(x * CSF_LN10);
}

// ============================================================================
// Eq.(01) — LMS background luminance proxy (paper plumbing; used by Eq06)
// Here: Y_LMS = L0 + M0 (matches MATLAB usage in CSF_castleCSF.csf)
// ============================================================================
float Eq01_Y_LMS(float3 lms_bg) {
  return (lms_bg.x + lms_bg.y);
}

#if 0
// ============================================================================
// Eq.(02) — L cone excitation spectral integral (stub; offline)
// Eq.(03) — M cone excitation spectral integral (stub; offline)
// Eq.(04) — S cone excitation spectral integral (stub; offline)
// ============================================================================
float Eq02_L_fromSpectrum(/*...*/) { return 0.0f; }
float Eq03_M_fromSpectrum(/*...*/) { return 0.0f; }
float Eq04_S_fromSpectrum(/*...*/) { return 0.0f; }

// ============================================================================
// Eq.(12) — Alternative normalized sensitivity form (stub; paper algebra)
// ============================================================================
float Eq12_AltNormalizedForm(/*...*/) { return 0.0f; }
#endif

// ============================================================================
// Eq.(05) — Opponent/ACC transform: ΔD = M * ΔLMS
// MATLAB (CSF_castleCSF): M_lms2acc constructed from D65 LMS ratios (mc1, mc2)
// ============================================================================
float3 Eq05_LMS_to_ACC(float3 delta_lms, float mc1, float mc2) {
  // [  1,   1,   0 ]
  // [  1, -mc1,  0 ]
  // [ -1,  -1, mc2 ]
  return float3(
      delta_lms.x + delta_lms.y,
      delta_lms.x - mc1 * delta_lms.y,
      -delta_lms.x - delta_lms.y + mc2 * delta_lms.z);
}

// ============================================================================
// Eq.(06) — Opponent contrast: ΔC = |ΔD| / Y_LMS
// NOTE: safe divide is EXACT (Y_LMS==0 only).
// ============================================================================
float3 Eq06_ACC_to_DeltaC(float3 delta_acc, float Y_LMS) {
  float denom = Y_LMS;  // may be 0 in degenerate cases
  float3 num = abs(delta_acc);
  return float3(
      SafeDiv0(num.x, denom, 0.0f),
      SafeDiv0(num.y, denom, 0.0f),
      SafeDiv0(num.z, denom, 0.0f));
}

// ============================================================================
// Eq.(07) — Detection energy: E = || S ⊙ ΔC ||_2
// ============================================================================
float Eq07_Energy(float3 S_mech, float3 deltaC) {
  return length(S_mech * deltaC);
}

// ============================================================================
// Eq.(08) — Contrast scaling: ΔC = t * ΔĈ
// ============================================================================
float3 Eq08_ScaleContrast(float3 deltaC_hat, float t) {
  return deltaC_hat * t;
}

// ============================================================================
// Eq.(09) — Energy scaling: E = t * Ê
// ============================================================================
float Eq09_ScaleEnergy(float E_hat, float t) {
  return E_hat * t;
}

// ============================================================================
// Eq.(10) — Normalize contrast direction: ΔĈ = ΔC / E
// ============================================================================
float3 Eq10_NormalizeDeltaC(float3 deltaC, float E) {
  return (E == 0.0f) ? 0.0f.xxx : (deltaC / E);
}

// ============================================================================
// Eq.(11) — Normalize LMS increments (algebraic helper; typically unused at runtime)
// ============================================================================
float3 Eq11_NormalizeDeltaLMS(float3 delta_lms, float E) {
  return (E == 0.0f) ? 0.0f.xxx : (delta_lms / E);
}

// ============================================================================
// Eq.(13) — Sustained temporal response: exp(-|ω|^β / σ)
// MATLAB: exp(-(abs(omega).^beta)./sigma)
// ============================================================================
float Eq13_R_sust(float omega, float sigma, float beta) {
  return exp(-pow(abs(omega), beta) / sigma);
}

// ============================================================================
// Eq.(14) — Ach transient temporal response (Gaussian in warped ω)
// MATLAB: exp(-(abs(abs(ω)^β - ω0^β)^2)/σ)
// ============================================================================
float Eq14_R_trans_ach(float omega, float omega0, float sigma, float beta) {
  float w = abs(omega);
  float d = abs(pow(w, beta) - pow(omega0, beta));
  return exp(-(d * d) / sigma);
}

// ============================================================================
// Eq.(15) — Transient center frequency: ω0(Y) = log10(Y)*sl + c
// MATLAB: omega0 = log10(lum).*sl + c
// ============================================================================
float Eq15_omega0(float lum_cd_m2, float sl, float c) {
  lum_cd_m2 = max(lum_cd_m2, 1e-6f);
  return csf_log10(lum_cd_m2) * sl + c;
}

// ============================================================================
// Eq.(16) — Log-parabola peak: 10^(-(log10(ρ)-log10(ρm))^2 / (2^bw))
// MATLAB: 10.^(-(log10(f)-log10(f_max)).^2 ./ (2.^bw))
// ============================================================================
float Eq16_log_parabola(float rho, float rho_m, float bw) {
  rho = max(rho, 1e-6f);
  rho_m = max(rho_m, 1e-6f);
  float d = csf_log10(rho) - csf_log10(rho_m);
  return csf_pow10(-(d * d) / pow(2.0f, bw));
}

// ============================================================================
// Eq.(17) — Achromatic truncation floor: if ρ<ρm and lp<(1-a) => lp=(1-a)
// MATLAB: truncation in csf_achrom()
// ============================================================================
float Eq17_trunc_ach(float rho, float rho_m, float bw, float a) {
  float lp = Eq16_log_parabola(rho, rho_m, bw);
  float floorVal = 1.0f - a;
  if ((rho < rho_m) && (lp < floorVal)) lp = floorVal;
  return lp;
}

// ============================================================================
// Eq.(18) — Chromatic low-frequency clamp: l=1 for ρ<fmax else log-parabola
// MATLAB (CSF_castleCSF_chrom.csf_chrom): if f<f_max then S_lp=1
// ============================================================================
float Eq18_chrom_lowfreq_clamp(float rho, float fmax, float bw) {
  if (rho < fmax) return 1.0f;
  return Eq16_log_parabola(rho, fmax, bw);
}

// ============================================================================
// Eq.(19) — Spatial summation constant: Ac(ρ)=A0 / (1 + (ρ/f0)^2)
// ============================================================================
float Eq19_Ac(float rho, float A0, float f0) {
  float t = rho / f0;
  return A0 / (1.0f + t * t);
}

// ============================================================================
// Eq.(20) — Area pooling term: sqrt(Ac / (1 + Ac/area)) * ρ
// MATLAB: sqrt(Ac ./ (1 + Ac./area)) .* rho
// ============================================================================
float Eq20_area_pool(float rho, float area, float Ac) {
  return sqrt(Ac / (1.0f + Ac / area)) * rho;
}

// ============================================================================
// Eq.(21) — Ach sustained Smax(lum): lum_dep_5 (CSF_base.get_lum_dep case 5)
//
// MATLAB reference:
//   Smax = p0 * (1 + p1/L)^(-p2) * (1 - (1 + p3/L)^(-p4))
//
// IMPORTANT (GPU float32 numerical stability):
// Direct pow(1+x, -p4) can collapse to 1 when x is tiny and p4 is huge.
// We preserve MATLAB math via exp(-p4 * log(1+x)) with log1p-style handling.
// ============================================================================
float Eq21_Smax_ach_sust(float lum, float p0, float p1, float p2, float p3, float p4) {
  lum = max(lum, 1e-6f);

  float term1 = pow(1.0f + p1 / lum, -p2);

  float x = p3 / lum;
  float log1px;
  if (abs(x) < 1e-4f) {
    log1px = x - 0.5f * x * x;  // log(1+x) ≈ x - x^2/2
  } else {
    log1px = log(1.0f + x);
  }

  float powTerm = exp(-p4 * log1px);
  float term2 = 1.0f - powTerm;

  return p0 * term1 * term2;
}

// ============================================================================
// Eq.(22) — Chromatic Smax(lum): lum_dep_3 (CSF_base.get_lum_dep case 3)
// ============================================================================
float Eq22_Smax_chrom(float lum, float p0, float p1, float p2) {
  lum = max(lum, 1e-6f);
  return p0 * pow(1.0f + p1 / lum, -p2);
}

// ============================================================================
// Eq.(23) — Ach transient Smax(lum): POWER LAW (CSF_base.get_lum_dep case 2)
// v = scale * lum^exp
// ============================================================================
float Eq23_Smax_ach_trans(float lum, float expP, float scaleP) {
  lum = max(lum, 1e-6f);
  return scaleP * pow(lum, expP);
}

// ============================================================================
// Eq.(24) — Ach sustained peak freq ρm(lum): lum_dep_3 (same form as Eq22)
// ============================================================================
float Eq24_rho_m_ach_sust(float lum, float p0, float p1, float p2) {
  return Eq22_Smax_chrom(lum, p0, p1, p2);
}

// ============================================================================
// Eq.(26) — Visual-field blending coefficient alpha
// MATLAB: alpha = min(1, abs(vis_field-180)/90)
// ============================================================================
float Eq26_alpha(float vis_field_deg) {
  return min(1.0f, abs(vis_field_deg - 180.0f) / 90.0f);
}

// ============================================================================
// Eq.(25) — Eccentricity drop factor (window-of-visibility extension)
// MATLAB:
//   ecc_drop   = alpha*ecc_drop + (1-alpha)*ecc_drop_nasal
//   ecc_drop_f = alpha*ecc_drop_f + (1-alpha)*ecc_drop_f_nasal
//   a = ecc_drop + rho*ecc_drop_f
//   S *= 10.^(-a.*ecc)
// ============================================================================
float Eq25_ecc_factor(float ecc_deg, float rho_cpd, float alpha,
                      float ecc_drop, float ecc_drop_nasal,
                      float ecc_drop_f, float ecc_drop_f_nasal) {
  float d0 = lerp(ecc_drop_nasal, ecc_drop, alpha);
  float df = lerp(ecc_drop_f_nasal, ecc_drop_f, alpha);
  float a = d0 + rho_cpd * df;
  return csf_pow10(-a * ecc_deg);
}

// ============================================================================
// Eq.(30) — Spatial CSF builders (mechanism spatial sensitivities)
// (Grouped here as the “Eq30” family; still one equation label.)
// ============================================================================
float Eq30_S_ach_sust_spatial(float rho, float area, float lum) {
  float Smax = Eq21_Smax_ach_sust(lum, ach_Smax_p0, ach_Smax_p1, ach_Smax_p2, ach_Smax_p3, ach_Smax_p4);
  float rho_m = Eq24_rho_m_ach_sust(lum, ach_fmax_p0, ach_fmax_p1, ach_fmax_p2);
  float l = Eq17_trunc_ach(rho, rho_m, ach_bw, ach_a);

  float Ac = Eq19_Ac(rho, ach_A0, ach_f0);
  float pool = Eq20_area_pool(rho, area, Ac);

  return Smax * l * pool;
}

float Eq30_S_ach_trans_spatial(float rho, float area, float lum) {
  float Smax = Eq23_Smax_ach_trans(lum, ach_trans_Smax_p0, ach_trans_Smax_p1);  // exp, scale
  float l = Eq17_trunc_ach(rho, ach_trans_fmax, ach_trans_bw, ach_trans_a);

  float Ac = Eq19_Ac(rho, ach_trans_A0, ach_trans_f0);
  float pool = Eq20_area_pool(rho, area, Ac);

  return Smax * l * pool;
}

float Eq30_S_chrom_spatial(float rho, float area, float lum,
                           float Smax_p0, float Smax_p1, float Smax_p2,
                           float fmax, float bw, float A0, float f0) {
  float Smax = Eq22_Smax_chrom(lum, Smax_p0, Smax_p1, Smax_p2);
  float l = Eq18_chrom_lowfreq_clamp(rho, fmax, bw);

  float Ac = Eq19_Ac(rho, A0, f0);
  float pool = Eq20_area_pool(rho, area, Ac);

  return (Smax * l) * pool;
}

// ============================================================================
// Eq.(27) — Full achromatic mechanism sensitivity (sust + trans, temporal weighted)
// MATLAB (CSF_stelaCSF_lum_peak): S = R_sust*S_sust + R_trans*S_trans
// plus eccentricity drop factor (Eq25/Eq26)
// ============================================================================
float Eq27_S_Ach(float rho, float omega, float ecc, float vis_field, float area, float lum) {
  float Rsa = Eq13_R_sust(omega, ach_sigma_sust, 1.3314f);

  float omega0 = Eq15_omega0(lum, ach_omega_trans_sl, ach_omega_trans_c);
  float Rta = Eq14_R_trans_ach(omega, omega0, ach_sigma_trans, 0.1898f);

  float Ss = Eq30_S_ach_sust_spatial(rho, area, lum);
  float St = Eq30_S_ach_trans_spatial(rho, area, lum);

  float S = Rsa * Ss + Rta * St;

  float alpha = Eq26_alpha(vis_field);
  S *= Eq25_ecc_factor(ecc, rho, alpha,
                       ach_ecc_drop, ach_ecc_drop_nasal,
                       ach_ecc_drop_f, ach_ecc_drop_f_nasal);
  return S;
}

// ============================================================================
// Eq.(28) — Full RG mechanism sensitivity (chrom spatial * sustained temporal)
// MATLAB (CSF_castleCSF_chrom): S = R_sust * S_sust; then ecc drop
// ============================================================================
float Eq28_S_RG(float rho, float omega, float ecc, float vis_field, float area, float lum) {
  float Ssp = Eq30_S_chrom_spatial(rho, area, lum,
                                   rg_Smax_p0, rg_Smax_p1, rg_Smax_p2,
                                   rg_fmax, rg_bw, rg_A0, rg_f0);

  float Rt = Eq13_R_sust(omega, rg_sigma_sust, rg_beta_sust);
  float S = Ssp * Rt;

  float alpha = Eq26_alpha(vis_field);
  S *= Eq25_ecc_factor(ecc, rho, alpha,
                       rg_ecc_drop, rg_ecc_drop_nasal,
                       rg_ecc_drop_f, rg_ecc_drop_f_nasal);
  return S;
}

// ============================================================================
// Eq.(29) — Full YV mechanism sensitivity (chrom spatial * sustained temporal)
// ============================================================================
float Eq29_S_YV(float rho, float omega, float ecc, float vis_field, float area, float lum) {
  float Ssp = Eq30_S_chrom_spatial(rho, area, lum,
                                   yv_Smax_p0, yv_Smax_p1, yv_Smax_p2,
                                   yv_fmax, yv_bw, yv_A0, yv_f0);

  float Rt = Eq13_R_sust(omega, yv_sigma_sust, yv_beta_sust);
  float S = Ssp * Rt;

  float alpha = Eq26_alpha(vis_field);
  S *= Eq25_ecc_factor(ecc, rho, alpha,
                       yv_ecc_drop, yv_ecc_drop_nasal,
                       yv_ecc_drop_f, yv_ecc_drop_f_nasal);
  return S;
}

// ============================================================================
// Eq.(31) — Stimulus geometry conversion (disc etc.) — not used in your path
// Included as labeled identity.
// ============================================================================
float Eq31_GeometryAdjust(float S /*, float area_or_sigma*/) {
  return S;
}

// ============================================================================
// “Eq pack” — mechanism sensitivity vector (Ach, RG, YV)
// ============================================================================
float3 Eq27_29_MechSens(float rho, float omega, float ecc, float vis_field, float area, float lum) {
  return float3(
      Eq27_S_Ach(rho, omega, ecc, vis_field, area, lum),
      Eq28_S_RG(rho, omega, ecc, vis_field, area, lum),
      Eq29_S_YV(rho, omega, ecc, vis_field, area, lum));
}

// ============================================================================
// CastleCSF detection energy (runtime entrypoint)
//
// Inputs:
//   delta_lms      : LMS increments (ΔL, ΔM, ΔS) [contrast probe direction]
//   Y0_cd_m2       : background luminance in cd/m^2 (model luminance input)
//   rho            : spatial frequency (cpd)
//   omega          : temporal frequency (Hz)
//   ecc            : eccentricity (deg)
//   vis_field      : orientation in visual field (deg). MATLAB default is 0.
//                    Ecc blending uses abs(vis_field-180)/90.
//   area           : stimulus area (deg^2)
//
// Output:
//   float4: (W_Ach, W_RG, W_YV, E)
// ============================================================================
float4 CastleCSF_Energy(
    float3 delta_lms,
    float Y0_cd_m2,
    float rho,
    float omega,
    float ecc,
    float vis_field,
    float area) {
  // Stockman 2deg 2006 LMS matrix
  float3x3 XYZ_TO_LMS_2006 = float3x3(
      0.185082982238733f, 0.584081279463687f, -0.0240722415044404f,
      -0.134433056469973f, 0.405752392775348f, 0.0358252602217631f,
      0.000789456671966863f, -0.000912281325916184f, 0.0198490812339463f);

  // Modified Stockman & Sharpe for LCD LED
  float3x3 XYZ_TO_LMS_WUERGER_2020 = float3x3(
      0.187596268556126, 0.585168649077728, -0.026384263306304,
      -0.133397430663221, 0.405505777260049, 0.034502127690364,
      0.000244379021663, -0.000542995890619, 0.019406849066323);

  XYZ_TO_LMS_2006 = XYZ_TO_LMS_WUERGER_2020;

  // D65 xy
  float2 WHITE_POINT_D65 = float2(0.31272f, 0.32903f);

  // D65 XYZ at Y=1
  float3 D65_XYZ = renodx::color::xyz::from::xyY(float3(WHITE_POINT_D65, 1.f));
  float3 LMS_WHITE = mul(XYZ_TO_LMS_2006, D65_XYZ);

  // MATLAB uses mc1 = Lw/Mw, mc2 = (Lw+Mw)/Sw
  float mc1 = SafeDiv0(LMS_WHITE.x, LMS_WHITE.y, 0.0f);
  float mc2 = SafeDiv0(LMS_WHITE.x + LMS_WHITE.y, LMS_WHITE.z, 0.0f);

  // Background LMS from xyY(D65, Y0)
  float3 xyz_bg = renodx::color::xyz::from::xyY(float3(WHITE_POINT_D65, Y0_cd_m2));
  float3 lms_bg = mul(XYZ_TO_LMS_2006, xyz_bg);

  // Eq.(01): Y_LMS = L0 + M0
  float Y_LMS = Eq01_Y_LMS(lms_bg);

  // Eq.(05): ΔACC
  float3 delta_acc = Eq05_LMS_to_ACC(delta_lms, mc1, mc2);

  // Eq.(06): ΔC
  float3 deltaC = Eq06_ACC_to_DeltaC(delta_acc, Y_LMS);

  // Eq.(27)-(29): mechanism sensitivities
  float3 S = Eq27_29_MechSens(rho, omega, ecc, vis_field, area, Y0_cd_m2);

  // Eq.(07): energy (and weights)
  float3 w = S * deltaC;
  float E = length(w);

  return float4(w, E);
}

// Alias for CastleCSF_Energy
float4 ComputeSensitivity(
    float3 delta_lms,
    float Y0_cd_m2,
    float rho,
    float omega,
    float ecc,
    float vis_field,
    float area) {
  return CastleCSF_Energy(delta_lms, Y0_cd_m2, rho, omega, ecc, vis_field, area);
}

}  // namespace castlecsf
}  // namespace color
}  // namespace renodx
#endif  // CASTLE_CSF_HLSL