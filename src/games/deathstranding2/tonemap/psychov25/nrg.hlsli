#ifndef RENODX_SHADERS_TONEMAP_NRG_HLSL_
#define RENODX_SHADERS_TONEMAP_NRG_HLSL_

#include "../common.hlsli"
#include "./acc_dkl.hlsli"
#include "./bleaching.hlsli"
#include "./stockman.hlsli"

namespace renodx {
namespace tonemap {
namespace nrg {

static const int NRG_BLEACH_MODEL_SCALAR = 0;
static const int NRG_BLEACH_MODEL_PER_CONE = 1;
static const int NRG_TEST5_ENERGY_BT2020_ABS_SUM = 0;
static const int NRG_TEST5_ENERGY_LMS_D65_ABS_SUM = 1;
static const int NRG_TEST5_ENERGY_ACC_A = 2;
static const int NRG_TEST6_CURVE_RH = 0;
static const int NRG_TEST6_CURVE_NR = 1;
// Wider blend to avoid abrupt dark/bright branch flicker around the adaptation anchor.
static const float NRG_TEST6_SIGN_BLEND_WIDTH = 0.08f;
// Test5 target: reach max chroma at 25% RH/Yf-relative progress.
static const float NRG_TEST5_P_WALL = 0.25f;
// CastleCSF uses absolute luminance units (cd/m^2).
// For this test path, scene values are mapped into [min_nits, max_nits]
// where max_nits scales with peak.
static const float NRG_TEST6_CASTLE_MIN_NITS = 0.005f;
static const float NRG_TEST6_CASTLE_BASE_NITS = 100.f;  // max_nits when peak == 1
static const float NRG_TEST6_CASTLE_BACKGROUND_NITS = 5.f;
static const float NRG_TEST6_CASTLE_RHO_CPD = 1.f;
static const float NRG_TEST6_CASTLE_OMEGA_HZ = 0.f;
static const float NRG_TEST6_CASTLE_ECC_DEG = 0.f;
static const float NRG_TEST6_CASTLE_VIS_FIELD_DEG = 0.f;
static const float NRG_TEST6_CASTLE_AREA_DEG2 = 3.14159265f;

// Anchored Rushton-Henry scalar response for NRGTest4.
// Uses RH availability in relative-drive space, normalized so:
// - y(gray_anchor) = gray_anchor
// - y(infinity) -> peak
float NRGTest4ScalarRushtonHenryToPeak(float x_unit, float peak) {
  const float kEps = 1e-6f;
  const float kGrayAnchorDefault = 0.18f;

  float p = max(peak, kEps);
  float g = min(kGrayAnchorDefault, p * 0.5f);
  g = max(g, kEps);

  float relative_drive = max(renodx::math::DivideSafe(max(x_unit, 0.f), g, 0.f), 0.f);
  float knee_ratio = max(renodx::math::DivideSafe(p, g, 0.f) - 1.f, kEps);

  float availability =
      renodx::color::bleaching::rushton_henry::AvailabilityFromRelativeDrive(
          relative_drive,
          knee_ratio);
  float availability_at_gray =
      renodx::color::bleaching::rushton_henry::AvailabilityFromRelativeDrive(
          1.f,
          knee_ratio);

  float drive_out = relative_drive * availability;
  float drive_out_normalized =
      renodx::math::DivideSafe(drive_out, availability_at_gray, 0.f);

  float y = g * drive_out_normalized;
  return min(max(y, 0.f), p);
}

bool IntersectLinearBoundedInterval(
    float x0,
    float dx,
    float min_value,
    float max_value,
    inout float k_lo,
    inout float k_hi) {
  const float kSlopeEps = 1e-8f;
  if (abs(dx) <= kSlopeEps) {
    return x0 >= min_value && x0 <= max_value;
  }

  float t0 = renodx::math::DivideSafe(min_value - x0, dx, 0.f);
  float t1 = renodx::math::DivideSafe(max_value - x0, dx, 0.f);
  float t_min = min(t0, t1);
  float t_max = max(t0, t1);

  k_lo = max(k_lo, t_min);
  k_hi = min(k_hi, t_max);
  return k_hi >= k_lo;
}

float ComputeAbsSum(float3 v) {
  return abs(v.x) + abs(v.y) + abs(v.z);
}

float NRGTest6PeakWhiteNits(float peak) {
  const float kEps = 1e-6f;
  float peak_ref = max(peak, kEps);
  return max(NRG_TEST6_CASTLE_BASE_NITS * peak_ref, NRG_TEST6_CASTLE_MIN_NITS + kEps);
}

float3 NRGTest6StimulusNits(float3 bt2020_linear, float peak) {
  const float kEps = 1e-6f;
  float peak_ref = max(peak, kEps);
  float white_nits = NRGTest6PeakWhiteNits(peak_ref);
  float3 scene_unit = saturate(bt2020_linear / peak_ref);
  return lerp(NRG_TEST6_CASTLE_MIN_NITS.xxx, white_nits.xxx, scene_unit);
}

float NRGTest6BackgroundYCdM2(
    float peak,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS) {
  float white_nits = NRGTest6PeakWhiteNits(peak);
  return clamp(background_nits, NRG_TEST6_CASTLE_MIN_NITS, white_nits);
}

float NRGTest6JNDScalarRaw(
    float3 bt2020_linear,
    float peak,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS) {
  const float kEps = 1e-6f;
  float peak_ref = max(peak, kEps);
  float Y0_cd_m2 = NRGTest6BackgroundYCdM2(peak_ref, background_nits);

  // Match CastleCSFOld's relative-drive convention:
  // delta is background-relative LMS contrast, then CastleCSF converts to ACC/DKL internally.
  float3 stimulus_nits = NRGTest6StimulusNits(bt2020_linear, peak_ref);
  float3 lms_stimulus = renodx::color::lms::from::BT2020(stimulus_nits);
  float3 xyz_background = renodx::color::xyz::from::xyY(float3(0.31272f, 0.32903f, max(Y0_cd_m2, 1e-4f)));
  float3 lms_background = renodx::color::lms::from::XYZ(xyz_background);
  float3 delta_lms_relative = (lms_stimulus - lms_background) / max(abs(lms_background), kEps.xxx);

  float4 energy = renodx::color::castlecsf::CastleCSF_Energy(
      delta_lms_relative,
      max(Y0_cd_m2, 1e-4f),
      NRG_TEST6_CASTLE_RHO_CPD,
      NRG_TEST6_CASTLE_OMEGA_HZ,
      NRG_TEST6_CASTLE_ECC_DEG,
      NRG_TEST6_CASTLE_VIS_FIELD_DEG,
      NRG_TEST6_CASTLE_AREA_DEG2);

  return max(energy.w, 0.f);
}

float NRGTest6SignedAchromaticContrast(
    float3 bt2020_linear,
    float peak = 1.f,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS) {
  const float kEps = 1e-6f;
  float peak_ref = max(peak, kEps);
  float3 stimulus_nits = NRGTest6StimulusNits(bt2020_linear, peak_ref);
  float3 lms_stimulus = renodx::color::lms::from::BT2020(stimulus_nits);
  float Y0_cd_m2 = NRGTest6BackgroundYCdM2(peak_ref, background_nits);
  float3 xyz_background = renodx::color::xyz::from::xyY(float3(0.31272f, 0.32903f, max(Y0_cd_m2, 1e-4f)));
  float3 lms_background = renodx::color::lms::from::XYZ(xyz_background);

  float achromatic_stimulus = lms_stimulus.x + lms_stimulus.y;
  float achromatic_background = lms_background.x + lms_background.y;
  return renodx::math::DivideSafe(
      achromatic_stimulus - achromatic_background,
      max(abs(achromatic_background), kEps),
      0.f);
}

float NRGTest6JNDPeakZeroRaw(
    float3 bt2020_linear,
    float peak,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS) {
  const float kEps = 1e-6f;
  float peak_ref = max(peak, kEps);
  float Y0_cd_m2 = NRGTest6BackgroundYCdM2(peak_ref, background_nits);

  float3 lms_stimulus = renodx::color::lms::from::BT2020(
      NRGTest6StimulusNits(bt2020_linear, peak_ref));
  float3 lms_black = renodx::color::lms::from::BT2020(
      NRGTest6StimulusNits(0, peak_ref));
  float3 lms_background = renodx::color::lms::from::XYZ(
      renodx::color::xyz::from::xyY(float3(0.31272f, 0.32903f, max(Y0_cd_m2, 1e-4f))));

  float3 delta_lms_relative = (lms_stimulus - lms_black) / max(abs(lms_background), kEps.xxx);
  float4 energy = renodx::color::castlecsf::CastleCSF_Energy(
      delta_lms_relative,
      max(Y0_cd_m2, 1e-4f),
      NRG_TEST6_CASTLE_RHO_CPD,
      NRG_TEST6_CASTLE_OMEGA_HZ,
      NRG_TEST6_CASTLE_ECC_DEG,
      NRG_TEST6_CASTLE_VIS_FIELD_DEG,
      NRG_TEST6_CASTLE_AREA_DEG2);
  return max(energy.w, 0.f);
}

void NRGTest6PerceptualDetailBudgetRaw(
    float peak,
    float background_nits,
    out float detail_budget_dark_raw,
    out float detail_budget_bright_raw,
    out float detail_budget_max_raw) {
  const float kEps = 1e-6f;
  float peak_ref = max(peak, kEps);

  // Available perceptual range around the adaptation point:
  // - dark side: adaptation -> minimum display luminance
  // - bright side: adaptation -> peak white
  detail_budget_dark_raw = max(
      NRGTest6JNDScalarRaw(0, peak_ref, background_nits),
      kEps);
  detail_budget_bright_raw = max(
      NRGTest6JNDScalarRaw(peak_ref.xxx, peak_ref, background_nits),
      kEps);
  detail_budget_max_raw = max(detail_budget_dark_raw, detail_budget_bright_raw);
}

float NRGTest6CurveBudgetUnit(
    float budget_unit,
    int curve_mode = NRG_TEST6_CURVE_RH) {
  float x = saturate(budget_unit);
  if (curve_mode == NRG_TEST6_CURVE_NR) {
    return saturate(renodx::tonemap::NakaRushton(
        x,
        1.f,
        0.18f,
        0.18f,
        1.f));
  }
  // Default: feed budget-normalized magnitude into the same RH line used by NRGTest4.
  return NRGTest4ScalarRushtonHenryToPeak(x, 1.f);
}

float NRGTest6CurveBudgetUnitAnchored(
    float budget_unit,
    int curve_mode = NRG_TEST6_CURVE_RH) {
  const float kEps = 1e-6f;
  float x = saturate(budget_unit);
  float y0 = NRGTest6CurveBudgetUnit(0.f, curve_mode);
  float y1 = NRGTest6CurveBudgetUnit(1.f, curve_mode);
  float y = NRGTest6CurveBudgetUnit(x, curve_mode);
  return saturate(renodx::math::DivideSafe(y - y0, max(y1 - y0, kEps), 0.f));
}

float3 SolveLineByJNDScalar(
    float3 start_bt2020,
    float3 end_bt2020,
    float peak,
    float target_scalar_raw,
    out float scalar_out_raw,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS) {
  const float kEps = 1e-6f;
  const int kIterations = 16;
  float peak_ref = max(peak, kEps);

  float scalar_start = NRGTest6JNDPeakZeroRaw(start_bt2020, peak_ref, background_nits);
  float scalar_end = NRGTest6JNDPeakZeroRaw(end_bt2020, peak_ref, background_nits);
  bool increasing = scalar_end >= scalar_start;

  if ((increasing && target_scalar_raw <= scalar_start + kEps) || (!increasing && target_scalar_raw >= scalar_start - kEps)) {
    scalar_out_raw = scalar_start;
    return start_bt2020;
  }
  if ((increasing && target_scalar_raw >= scalar_end - kEps) || (!increasing && target_scalar_raw <= scalar_end + kEps)) {
    scalar_out_raw = scalar_end;
    return end_bt2020;
  }

  float lo = 0.f;
  float hi = 1.f;

  [unroll]
  for (int i = 0; i < kIterations; ++i) {
    float mid = 0.5f * (lo + hi);
    float3 sample_bt2020 = lerp(start_bt2020, end_bt2020, mid);
    float scalar_sample = NRGTest6JNDPeakZeroRaw(sample_bt2020, peak_ref, background_nits);
    if ((increasing && scalar_sample < target_scalar_raw) || (!increasing && scalar_sample > target_scalar_raw)) {
      lo = mid;
    } else {
      hi = mid;
    }
  }

  float t = 0.5f * (lo + hi);
  float3 bt2020_out = lerp(start_bt2020, end_bt2020, t);
  scalar_out_raw = NRGTest6JNDPeakZeroRaw(bt2020_out, peak_ref, background_nits);
  return bt2020_out;
}

float3 BlendChromaAndWhiteSpillJND(
    float3 bt2020_chroma,
    float3 bt2020_chroma_max,
    float peak,
    float scalar_output_raw,
    float scalar_chroma_max,
    float scalar_white_raw,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS) {
  float scalar_final_raw;
  float3 bt2020_spill = SolveLineByJNDScalar(
      bt2020_chroma_max,
      peak.xxx,
      peak,
      scalar_output_raw,
      scalar_final_raw,
      background_nits);

  float wall_width = max(0.02f * scalar_white_raw, 1e-6f);
  float wall_mix = smoothstep(
      scalar_chroma_max - wall_width,
      scalar_chroma_max + wall_width,
      scalar_output_raw);

  return lerp(bt2020_chroma, bt2020_spill, wall_mix);
}

// Find first in-gamut point on the line from bt2020_input toward neutral white (peak,peak,peak):
//   p(t) = bt2020_input + t * (white - bt2020_input), t in [0,1]
// We return t_lo (entry point from out-of-gamut side), which is guaranteed to exist
// because t=1 is always white and in gamut.
float SolveBT2020BoundaryTowardWhite(
    float3 bt2020_input,
    float peak,
    out float3 out_bt2020) {
  float3 white = peak.xxx;
  float3 delta = white - bt2020_input;

  float t_lo = 0.f;
  float t_hi = 1.f;
  if (!IntersectLinearBoundedInterval(bt2020_input.x, delta.x, 0.f, peak, t_lo, t_hi) || !IntersectLinearBoundedInterval(bt2020_input.y, delta.y, 0.f, peak, t_lo, t_hi) || !IntersectLinearBoundedInterval(bt2020_input.z, delta.z, 0.f, peak, t_lo, t_hi)) {
    out_bt2020 = white;
    return 1.f;
  }

  out_bt2020 = bt2020_input + delta * t_lo;
  return t_lo;
}

float3 ComputeBT2020ChromaMaxFromInput(float3 bt2020_linear, float peak_ref, float kEps) {
  float3 bt2020_chroma_max;

  float max_channel = max(max(bt2020_linear.x, bt2020_linear.y), bt2020_linear.z);
  bool use_bt2020_hue_boundary = all(bt2020_linear >= 0) && max_channel > kEps;
  if (use_bt2020_hue_boundary) {
    float3 bt2020_hue_unit = bt2020_linear / max_channel;
    bt2020_chroma_max = bt2020_hue_unit * peak_ref;
  } else {
    // Signed/out-of-gamut input:
    // preserve usable hue direction from positive BT.2020 components.
    float3 bt2020_positive = max(bt2020_linear, 0);
    float positive_max = max(max(bt2020_positive.x, bt2020_positive.y), bt2020_positive.z);
    if (positive_max > kEps) {
      float3 bt2020_hue_unit = bt2020_positive / positive_max;
      bt2020_chroma_max = bt2020_hue_unit * peak_ref;
    } else {
      SolveBT2020BoundaryTowardWhite(
          bt2020_linear,
          peak_ref,
          bt2020_chroma_max);
    }
  }

  return bt2020_chroma_max;
}

// Solve t in out = lerp(bt2020_start, peak_white, t) such that
// abs-sum energy in BT.2020 channel space matches target_scalar_raw.
float3 SolveWhiteSpillByEnergy(
    float3 bt2020_start,
    float peak,
    float target_scalar_raw,
    out float scalar_out_raw) {
  const float kEps = 1e-6f;

  float scalar_start = ComputeAbsSum(bt2020_start);

  float3 bt2020_white = peak.xxx;
  float scalar_white = ComputeAbsSum(bt2020_white);

  if (target_scalar_raw <= scalar_start + kEps) {
    scalar_out_raw = scalar_start;
    return bt2020_start;
  }
  if (target_scalar_raw >= scalar_white - kEps) {
    scalar_out_raw = scalar_white;
    return bt2020_white;
  }

  float t = saturate(renodx::math::DivideSafe(
      target_scalar_raw - scalar_start,
      scalar_white - scalar_start,
      0.f));
  float3 bt2020_out = lerp(bt2020_start, bt2020_white, t);
  scalar_out_raw = ComputeAbsSum(bt2020_out);
  return bt2020_out;
}

// Smooth blend across the chroma wall to avoid a visible derivative kink
// at the handoff between \"scale-to-max-chroma\" and \"spill-to-white\".
float3 BlendChromaAndWhiteSpill(
    float3 bt2020_chroma,
    float3 bt2020_chroma_max,
    float peak,
    float scalar_output_raw,
    float scalar_chroma_max) {
  float scalar_final_raw;
  float3 bt2020_spill = SolveWhiteSpillByEnergy(
      bt2020_chroma_max,
      peak,
      scalar_output_raw,
      scalar_final_raw);

  float scalar_white = 3.f * max(peak, 1e-6f);
  float wall_width = max(0.02f * scalar_white, 1e-6f);
  float wall_mix = smoothstep(
      scalar_chroma_max - wall_width,
      scalar_chroma_max + wall_width,
      scalar_output_raw);

  return lerp(bt2020_chroma, bt2020_spill, wall_mix);
}

float3 FastInputLMSEnergyGray(float3 bt709_linear) {
  float3 lms = renodx::color::lms::from::BT709(bt709_linear);
  float3 lms_white = renodx::color::lms::from::WhiteD65(1.f);

  float3 lms_norm = lms / lms_white;
  float scalar_raw = abs(lms_norm.x) + abs(lms_norm.y) + abs(lms_norm.z);
  float scalar_input = scalar_raw / 3.f;
  return scalar_input.xxx;
}

float3 NeutwoBT709WhiteForEnergy(float3 bt709_linear, float peak = 1.f) {
  const float kEps = 1e-6f;
  const float kType7WhiteUnits = 3.f;
  const float kChromaCurve = 1.5f;

  float3 lms = renodx::color::lms::from::BT709(bt709_linear);
  float3 lms_white = renodx::color::lms::from::WhiteD65(1.f);

  float3 lms_norm_input = lms / lms_white;
  float scalar_input_raw = abs(lms_norm_input.x) + abs(lms_norm_input.y) + abs(lms_norm_input.z);
  float scalar_input = scalar_input_raw / kType7WhiteUnits;

  float peak_ref = max(peak, kEps);
  float scalar_peak = peak_ref;
  float scalar_output = renodx::tonemap::Neutwo(scalar_input, scalar_peak);

  float3 lms_d65 = lms / renodx::color::lms::from::WhiteD65(1.f);
  float3 acc_input = renodx::color::stockman::acc::from::LMSD65(lms_d65);
  float t = saturate(scalar_output / scalar_peak);
  float chroma_scale = 1.f - pow(t, kChromaCurve);
  float2 acc_chroma_out = acc_input.yz * chroma_scale;

  float3 lms_white_target_d65 = scalar_output.xxx;
  float3 acc_white = renodx::color::stockman::acc::from::LMSD65(lms_white_target_d65);

  float3 acc_out = float3(acc_white.x, acc_chroma_out.x, acc_chroma_out.y);
  float3 lms_out_d65 = renodx::color::stockman::acc::to::LMSD65(acc_out);
  float3 lms_out = lms_out_d65 * renodx::color::lms::from::WhiteD65(1.f);

  float3 lms_norm_scalar = lms_out / lms_white;
  float scalar_out_raw = abs(lms_norm_scalar.x) + abs(lms_norm_scalar.y) + abs(lms_norm_scalar.z);
  float scalar_target_raw = scalar_output * kType7WhiteUnits;
  float scalar_match_scale = scalar_target_raw / max(scalar_out_raw, kEps);
  lms_out *= scalar_match_scale;

  return renodx::color::bt709::from::LMS(lms_out);
}

float3 NRGTest2(float3 bt709_linear, float peak = 1.f) {
  const float kEps = 1e-6f;
  const float kUnits = 1.f;
  const float strength = 0.18f * peak;
  float peak_ref = max(peak, kEps);

  float3 lms = renodx::color::lms::from::BT709(bt709_linear);
  float3 lms_white = renodx::color::lms::from::WhiteE(1.f);

  float3 lms_norm_input = lms / lms_white;
  float scalar_raw_input = lms_norm_input.x + lms_norm_input.y + lms_norm_input.z;
  float scalar_input = scalar_raw_input / kUnits;

  float3 lms_peak = lms_white * peak_ref;
  float3 lms_norm_peak = lms_peak / lms_white;
  float scalar_raw_peak = lms_norm_peak.x + lms_norm_peak.y + lms_norm_peak.z;
  float scalar_peak = scalar_raw_peak / kUnits;
  float scalar_output = renodx::tonemap::Neutwo(scalar_input, scalar_peak);

  float scalar_input_raw = scalar_input * kUnits;
  float scalar_output_raw = scalar_output * kUnits;

  float3 lms_gray = lms_white * strength;
  float3 lms_gray_in = lms_gray * scalar_input_raw;
  float3 lms_gray_out = lms_gray * scalar_output_raw;
  float3 lms_chroma = lms - lms_gray_in;
  float available_white = saturate(renodx::math::DivideSafe(
      scalar_peak - scalar_output,
      scalar_peak,
      0.f));

  float3 lms_out = lms_gray_out + lms_chroma * available_white;
  float3 lms_norm_out = lms_out / lms_white;
  float scalar_out_raw = lms_norm_out.x + lms_norm_out.y + lms_norm_out.z;
  lms_out *= renodx::math::DivideSafe(scalar_output_raw, scalar_out_raw, 0.f);

  lms_norm_out = lms_out / lms_white;
  scalar_out_raw = lms_norm_out.x + lms_norm_out.y + lms_norm_out.z;
  lms_out *= renodx::math::DivideSafe(scalar_output_raw, scalar_out_raw, 0.f);

  float3 bt709_out = renodx::color::bt709::from::LMS(lms_out);
  float3 bt2020_out = renodx::color::bt2020::from::BT709(bt709_out);
  bt2020_out = clamp(bt2020_out, 0.f, peak_ref.xxx);
  return renodx::color::bt709::from::BT2020(bt2020_out);
}

float3 NRGTest3BT2020(float3 bt2020_linear, float peak = 1.f) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;  // BT.2020 abs-sum: white@1 = 3, white@peak = 3*peak.
  float peak_ref = max(peak, kEps);

  // Scalar units in BT.2020:
  // white@1 = 3, peak(8) = 24.
  float scalar_input_raw = ComputeAbsSum(bt2020_linear);
  float scalar_input_unit = scalar_input_raw / kScalarWhiteUnits;
  float scalar_output_unit = renodx::tonemap::NakaRushton(
      scalar_input_unit,
      peak_ref,
      0.18f,
      0.18f,
      1.f);
  float scalar_output_raw = scalar_output_unit * kScalarWhiteUnits;
  float3 bt2020_chroma_max = ComputeBT2020ChromaMaxFromInput(bt2020_linear, peak_ref, kEps);

  float scalar_chroma_max = ComputeAbsSum(bt2020_chroma_max);
  if (scalar_chroma_max <= kEps) {
    // Degenerate case: boundary is black. Move on black->white by scalar budget.
    float scalar_final_raw;
    return SolveWhiteSpillByEnergy(
        0,
        peak_ref,
        scalar_output_raw,
        scalar_final_raw);
  }

  // Chroma budget does NOT pass through Neutwo; only E_in does.
  float scalar_chroma = min(scalar_output_raw, scalar_chroma_max);
  float chroma_scale = renodx::math::DivideSafe(
      scalar_chroma,
      scalar_chroma_max,
      0.f);
  float3 bt2020_chroma = bt2020_chroma_max * chroma_scale;
  return BlendChromaAndWhiteSpill(
      bt2020_chroma,
      bt2020_chroma_max,
      peak_ref,
      scalar_output_raw,
      scalar_chroma_max);
}

float3 NRGTest3(float3 bt709_linear, float peak = 1.f) {
  float3 bt2020_linear = renodx::color::bt2020::from::BT709(bt709_linear);
  float3 bt2020_out = NRGTest3BT2020(bt2020_linear, peak);
  return renodx::color::bt709::from::BT2020(bt2020_out);
}

float3 NRGTest4BT2020(float3 bt2020_linear, float peak = 1.f) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;  // BT.2020 abs-sum: white@1 = 3, white@peak = 3*peak.
  float peak_ref = max(peak, kEps);

  // Scalar units in BT.2020:
  // white@1 = 3, peak(8) = 24.
  float scalar_input_raw = ComputeAbsSum(bt2020_linear);
  float scalar_input_unit = scalar_input_raw / kScalarWhiteUnits;
  float scalar_output_unit = NRGTest4ScalarRushtonHenryToPeak(scalar_input_unit, peak_ref);
  float scalar_output_raw = scalar_output_unit * kScalarWhiteUnits;
  float3 bt2020_chroma_max = ComputeBT2020ChromaMaxFromInput(bt2020_linear, peak_ref, kEps);

  float scalar_chroma_max = ComputeAbsSum(bt2020_chroma_max);
  if (scalar_chroma_max <= kEps) {
    // Degenerate case: boundary is black. Move on black->white by scalar budget.
    float scalar_final_raw;
    return SolveWhiteSpillByEnergy(
        0,
        peak_ref,
        scalar_output_raw,
        scalar_final_raw);
  }

  // Chroma budget does NOT pass through Rushton-Henry; only E_in does.
  float scalar_chroma = min(scalar_output_raw, scalar_chroma_max);
  float chroma_scale = renodx::math::DivideSafe(
      scalar_chroma,
      scalar_chroma_max,
      0.f);
  float3 bt2020_chroma = bt2020_chroma_max * chroma_scale;
  return BlendChromaAndWhiteSpill(
      bt2020_chroma,
      bt2020_chroma_max,
      peak_ref,
      scalar_output_raw,
      scalar_chroma_max);
}

float3 NRGTest4(float3 bt709_linear, float peak = 1.f) {
  float3 bt2020_linear = renodx::color::bt2020::from::BT709(bt709_linear);
  float3 bt2020_out = NRGTest4BT2020(bt2020_linear, peak);
  return renodx::color::bt709::from::BT2020(bt2020_out);
}

float NRGTest5ScalarInputUnit(
    float3 bt2020_linear,
    int energy_mode = NRG_TEST5_ENERGY_ACC_A) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;

  float3 lms_d65 = renodx::color::lms::from::BT2020(bt2020_linear) / max(renodx::color::lms::from::WhiteD65(1.f), 1e-6f.xxx);
  if (energy_mode == NRG_TEST5_ENERGY_ACC_A) {
    float3 acc = renodx::color::stockman::acc::from::LMSD65(lms_d65);
    float acc_white = max(abs(renodx::color::stockman::acc::from::LMSD65(float3(1, 1, 1)).x), kEps);
    return abs(acc.x) / acc_white;
  }

  if (energy_mode == NRG_TEST5_ENERGY_LMS_D65_ABS_SUM) {
    return ComputeAbsSum(lms_d65) / kScalarWhiteUnits;
  }

  return ComputeAbsSum(bt2020_linear) / kScalarWhiteUnits;
}

float NRGTest7ScalarAccARaw(
    float3 bt2020_linear,
    float peak = 1.f) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;
  float peak_ref = max(peak, kEps);

  float scalar_unit = NRGTest5ScalarInputUnit(
      max(bt2020_linear, 0),
      NRG_TEST5_ENERGY_ACC_A);
  return scalar_unit * kScalarWhiteUnits;
}

float3 NRGTest7SolveWhiteSpillByScalarAccA(
    float3 bt2020_start,
    float peak,
    float target_scalar_raw,
    out float scalar_out_raw) {
  const float kEps = 1e-6f;
  const int kIterations = 16;
  const float kScalarWhiteUnits = 3.f;
  float peak_ref = max(peak, kEps);

  float3 bt2020_white = peak_ref.xxx;
  float scalar_start = NRGTest7ScalarAccARaw(bt2020_start, peak_ref);
  float scalar_white = kScalarWhiteUnits * peak_ref;
  float scalar_target = clamp(target_scalar_raw, scalar_start, scalar_white);

  if (scalar_target <= scalar_start + kEps) {
    scalar_out_raw = scalar_start;
    return bt2020_start;
  }
  if (scalar_target >= scalar_white - kEps) {
    scalar_out_raw = scalar_white;
    return bt2020_white;
  }

  float lo = 0.f;
  float hi = 1.f;
  [unroll]
  for (int i = 0; i < kIterations; ++i) {
    float mid = 0.5f * (lo + hi);
    float3 sample = lerp(bt2020_start, bt2020_white, mid);
    float scalar_mid = NRGTest7ScalarAccARaw(sample, peak_ref);
    if (scalar_mid < scalar_target) {
      lo = mid;
    } else {
      hi = mid;
    }
  }

  float t = 0.5f * (lo + hi);
  float3 out_bt2020 = lerp(bt2020_start, bt2020_white, t);
  scalar_out_raw = NRGTest7ScalarAccARaw(out_bt2020, peak_ref);
  return out_bt2020;
}

float3 NRGTest7BlendChromaAndWhiteSpillNeutwoClipHueWall(
    float3 bt2020_chroma,
    float3 bt2020_chroma_max,
    float peak,
    float scalar_output_raw,
    float scalar_chroma_max,
    float start_ratio = 1.f,
    float shape = 1.f) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;
  float peak_ref = max(peak, kEps);
  float scalar_white_raw = kScalarWhiteUnits * peak_ref;

  float scalar_start = scalar_chroma_max * saturate(start_ratio);
  float scalar_overdrive = max(scalar_output_raw - scalar_start, 0.f);
  float scalar_headroom = max(scalar_white_raw - scalar_start, kEps);
  float scalar_overdrive_unit = scalar_overdrive / scalar_headroom;

  // Per-hue clip from wall capacity in ACC-A scalar units.
  // low wall -> clip near 1 (faster white), high wall -> clip near 2 (slower white)
  float clip_hue = 1.f + saturate(renodx::math::DivideSafe(scalar_chroma_max, max(scalar_white_raw, kEps), 0.f));

  float white_mix = saturate(renodx::tonemap::Neutwo(
      scalar_overdrive_unit,
      1.f,
      clip_hue));
  if (abs(shape - 1.f) > 1e-6f) {
    white_mix = pow(max(white_mix, 0.f), max(shape, 1e-6f));
  }

  float scalar_spill_raw;
  float3 bt2020_spill = NRGTest7SolveWhiteSpillByScalarAccA(
      bt2020_chroma_max,
      peak_ref,
      scalar_output_raw,
      scalar_spill_raw);
  return lerp(bt2020_chroma, bt2020_spill, white_mix);
}

float3 NRGTest5BT2020(
    float3 bt2020_linear,
    float peak = 1.f,
    int energy_mode = NRG_TEST5_ENERGY_ACC_A) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;  // BT.2020 abs-sum: white@1 = 3, white@peak = 3*peak.
  float peak_ref = max(peak, kEps);

  // Test5 keeps Test4's robust hue geometry, but allows alternate scalar energy drives.
  float scalar_input_unit = NRGTest5ScalarInputUnit(bt2020_linear, energy_mode);
  float scalar_output_unit = NRGTest4ScalarRushtonHenryToPeak(scalar_input_unit, peak_ref);
  float scalar_output_raw = scalar_output_unit * kScalarWhiteUnits;
  float3 bt2020_chroma_max = ComputeBT2020ChromaMaxFromInput(bt2020_linear, peak_ref, kEps);

  float scalar_chroma_max = ComputeAbsSum(bt2020_chroma_max);
  if (scalar_chroma_max <= kEps) {
    // Degenerate hue: move on neutral axis by RH scalar percent.
    return (scalar_output_raw / kScalarWhiteUnits).xxx;
  }

  float scalar_white_raw = kScalarWhiteUnits * peak_ref;
  float p = saturate(renodx::math::DivideSafe(
      scalar_output_raw,
      scalar_white_raw,
      0.f));

  float p_wall = clamp(NRG_TEST5_P_WALL, 1e-4f, 0.9999f);
  if (p <= p_wall) {
    // Stage 1: black -> max chroma (at p_wall).
    float chroma_t = saturate(renodx::math::DivideSafe(p, p_wall, 0.f));
    return bt2020_chroma_max * chroma_t;
  }

  // Stage 2: max chroma -> white. Max chroma is only present at p == p_wall.
  float white_t = saturate(renodx::math::DivideSafe(
      p - p_wall,
      1.f - p_wall,
      0.f));
  return lerp(bt2020_chroma_max, peak_ref.xxx, white_t);
}

float3 NRGTest5(
    float3 bt709_linear,
    float peak = 1.f,
    int energy_mode = NRG_TEST5_ENERGY_ACC_A) {
  float3 bt2020_linear = renodx::color::bt2020::from::BT709(bt709_linear);
  float3 bt2020_out = NRGTest5BT2020(bt2020_linear, peak, energy_mode);
  return renodx::color::bt709::from::BT2020(bt2020_out);
}

float3 NRGTest6BT2020(
    float3 bt2020_linear,
    float peak = 1.f,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS,
    int curve_mode = NRG_TEST6_CURVE_RH) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;  // Virtual spill pressure only; final targets stay <= white JND.
  float peak_ref = max(peak, kEps);
  // Test4 geometry, but scalar is total JND from black->color normalized by black->peak.
  float scalar_peak_raw = max(
      NRGTest6JNDPeakZeroRaw(peak_ref.xxx, peak_ref, background_nits),
      kEps);
  float scalar_input_raw = NRGTest6JNDPeakZeroRaw(bt2020_linear, peak_ref, background_nits);
  float scalar_input_unit = scalar_input_raw * peak_ref / scalar_peak_raw;
  float scalar_output_unit = curve_mode == NRG_TEST6_CURVE_NR
                                 ? renodx::tonemap::NakaRushton(scalar_input_unit, peak_ref, 0.18f, 0.18f, 1.f)
                                 : NRGTest4ScalarRushtonHenryToPeak(scalar_input_unit, peak_ref);
  float scalar_output_raw = scalar_output_unit * scalar_peak_raw / peak_ref;
  float scalar_white_raw = scalar_peak_raw;

  float3 bt2020_chroma_max = ComputeBT2020ChromaMaxFromInput(bt2020_linear, peak_ref, kEps);
  float scalar_chroma_max = NRGTest6JNDPeakZeroRaw(bt2020_chroma_max, peak_ref, background_nits);
  if (scalar_chroma_max <= kEps) {
    float scalar_final_raw;
    return SolveLineByJNDScalar(
        0,
        peak_ref.xxx,
        peak_ref,
        scalar_output_raw,
        scalar_final_raw,
        background_nits);
  }

  // Apply extra spill pressure in a virtual scalar domain, but remap the result
  // back into the physically reachable JND interval [scalar_chroma_max, scalar_peak_raw].
  float scalar_headroom = max(scalar_peak_raw - scalar_chroma_max, 0.f);
  if (scalar_headroom > kEps) {
    float scalar_output_virtual = scalar_output_raw * kScalarWhiteUnits;
    float scalar_overflow = max(scalar_output_virtual - scalar_chroma_max, 0.f);
    if (scalar_overflow > kEps) {
      float scalar_overflow_norm = saturate(renodx::math::DivideSafe(
          scalar_overflow,
          max(scalar_peak_raw * (kScalarWhiteUnits - 1.f), kEps),
          0.f));
      float scalar_spill_target = lerp(scalar_chroma_max, scalar_peak_raw, scalar_overflow_norm);
      scalar_output_raw = max(scalar_output_raw, scalar_spill_target);
    }
  }

  float scalar_chroma = min(scalar_output_raw, scalar_chroma_max);
  float scalar_chroma_raw;
  float3 bt2020_chroma = SolveLineByJNDScalar(
      0,
      bt2020_chroma_max,
      peak_ref,
      scalar_chroma,
      scalar_chroma_raw,
      background_nits);

  return BlendChromaAndWhiteSpillJND(
      bt2020_chroma,
      bt2020_chroma_max,
      peak_ref,
      scalar_output_raw,
      scalar_chroma_max,
      scalar_white_raw,
      background_nits);
}

float3 NRGTest6(
    float3 bt709_linear,
    float peak = 1.f,
    float background_nits = NRG_TEST6_CASTLE_BACKGROUND_NITS,
    int curve_mode = NRG_TEST6_CURVE_RH) {
  float3 bt2020_linear = renodx::color::bt2020::from::BT709(bt709_linear);
  float3 bt2020_out = NRGTest6BT2020(bt2020_linear, peak, background_nits, curve_mode);
  return renodx::color::bt709::from::BT2020(bt2020_out);
}

float3 NRGTest7HueClipBT2020(float3 bt2020_linear, float peak = 1.f) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;
  float peak_ref = max(peak, kEps);

  // ACC-A scalar drive -> Neutwo white curve.
  float scalar_input_unit = NRGTest5ScalarInputUnit(
      max(bt2020_linear, 0),
      NRG_TEST5_ENERGY_ACC_A);
  float scalar_output_unit = renodx::tonemap::Neutwo(
      max(scalar_input_unit, 0.f),
      peak_ref);
  float scalar_output_raw = scalar_output_unit * kScalarWhiteUnits;

  // Max-hue anchor in BT.2020, then transition toward white.
  float3 bt2020_chroma_max = ComputeBT2020ChromaMaxFromInput(bt2020_linear, peak_ref, kEps);
  float scalar_chroma_max = NRGTest7ScalarAccARaw(bt2020_chroma_max, peak_ref);
  if (scalar_chroma_max <= kEps) {
    float scalar_final_raw;
    return NRGTest7SolveWhiteSpillByScalarAccA(
        0,
        peak_ref,
        scalar_output_raw,
        scalar_final_raw);
  }

  float scalar_chroma = min(scalar_output_raw, scalar_chroma_max);
  float chroma_scale = renodx::math::DivideSafe(
      scalar_chroma,
      scalar_chroma_max,
      0.f);
  float3 bt2020_chroma = bt2020_chroma_max * chroma_scale;

  return NRGTest7BlendChromaAndWhiteSpillNeutwoClipHueWall(
      bt2020_chroma,
      bt2020_chroma_max,
      peak_ref,
      scalar_output_raw,
      scalar_chroma_max,
      1.f,
      1.f);
}

float3 NRGTest7HueClip(float3 bt709_linear, float peak = 1.f) {
  float3 bt2020_linear = renodx::color::bt2020::from::BT709(bt709_linear);
  float3 bt2020_out = NRGTest7HueClipBT2020(bt2020_linear, peak);
  return renodx::color::bt709::from::BT2020(bt2020_out);
}

float3 BT709TEST7(float3 bt709_linear,
                  float display_peak = 1.f,
                  int mode = NRG_BLEACH_MODEL_SCALAR) {
  if (mode == NRG_BLEACH_MODEL_PER_CONE) {
    return NeutwoBT709WhiteForEnergy(bt709_linear, display_peak);
  }
  return FastInputLMSEnergyGray(bt709_linear);
}

float3 BT2020TEST7(float3 bt2020_linear,
                   float display_peak_bt2020 = 1.f,
                   int mode = NRG_BLEACH_MODEL_SCALAR) {
  float3 bt709 = renodx::color::bt709::from::BT2020(bt2020_linear);
  float3 out_bt709 = BT709TEST7(bt709, display_peak_bt2020, mode);
  return renodx::color::bt2020::from::BT709(out_bt709);
}

}  // namespace nrg
}  // namespace tonemap
}  // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_NRG_HLSL_
