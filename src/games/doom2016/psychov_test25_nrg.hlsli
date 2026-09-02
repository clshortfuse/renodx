#ifndef SRC_GAMES_DOOM2016_PSYCHOV_TEST25_NRG_HLSLI_
#define SRC_GAMES_DOOM2016_PSYCHOV_TEST25_NRG_HLSLI_

namespace renodx {
namespace color {

namespace stockman {
namespace acc {

// Concrete Stockman ACC for this shader-local path.
// The white point is locked to D65 and the optional background is exposed for
// compatibility with existing ACC conversion helpers.

namespace from {
float3 LMSD65(float3 lms_d65, float3 lms_background = 0) {
  float3 lms_delta = lms_d65 - lms_background;
  return float3(
      lms_delta.x + lms_delta.y,
      lms_delta.x - lms_delta.y,
      -lms_delta.x - lms_delta.y + 2.f * lms_delta.z);
}

float3 LMS(float3 lms_abs, float3 lms_background = 0) {
  return LMSD65(lms_abs, lms_background);
}
}  // namespace from

namespace to {
float3 LMSD65(float3 acc_value, float3 lms_background = 0) {
  float3 lms_delta = float3(
      0.5f * (acc_value.x + acc_value.y),
      0.5f * (acc_value.x - acc_value.y),
      0.5f * (acc_value.x + acc_value.z));
  return lms_delta + lms_background;
}

float3 LMS(float3 acc_value, float3 lms_background = 0) {
  return LMSD65(acc_value, lms_background);
}
}  // namespace to

}  // namespace acc
}  // namespace stockman

}  // namespace color
}  // namespace renodx

namespace renodx {
namespace tonemap {
namespace nrg {

static const int NRG_TEST5_ENERGY_BT2020_ABS_SUM = 0;
static const int NRG_TEST5_ENERGY_LMS_D65_ABS_SUM = 1;
static const int NRG_TEST5_ENERGY_ACC_A = 2;

float ComputeAbsSum(float3 v) {
  return abs(v.x) + abs(v.y) + abs(v.z);
}

float NRGTest5ScalarInputUnit(
    float3 bt2020_linear,
    int energy_mode = NRG_TEST5_ENERGY_ACC_A) {
  const float kEps = 1e-6f;
  const float kScalarWhiteUnits = 3.f;

  float3 lms_d65 = renodx::color::lms::from::BT2020(bt2020_linear)
                    / max(renodx::color::lms::from::WhiteD65(1.f), kEps.xxx);
  if (energy_mode == NRG_TEST5_ENERGY_ACC_A) {
    float acc_white = abs(renodx::color::stockman::acc::from::LMSD65(
        float3(1.f, 1.f, 1.f)).x);
    return abs(renodx::color::stockman::acc::from::LMSD65(lms_d65).x)
           / max(acc_white, kEps);
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
  const float peak_ref = max(peak, kEps);

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
  const float peak_ref = max(peak, kEps);

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

}  // namespace nrg
}  // namespace tonemap
}  // namespace renodx

#endif  // SRC_GAMES_DOOM2016_PSYCHOV_TEST25_NRG_HLSLI_
