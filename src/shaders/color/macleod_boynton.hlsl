#ifndef SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_
#define SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_

#include "./rgb.hlsl"

namespace renodx {
namespace color {

namespace macleod_boynton {
// Generic MacLeod-Boynton algebra over an explicitly chosen LMS basis.
//
// Formulation:
//   l = Lw / (Lw + Mw)
//   s = Sw / (Lw + Mw)
//   y = Lw + Mw
//
// The caller is responsible for choosing:
// - the underlying LMS basis
// - the LMS weights used to form (Lw, Mw, Sw)
// - any white anchor or RGB<->LMS matrices
//

//
// Reference data:
// CVRL functions: http://www.cvrl.org/cvrlfunctions.htm
// CVRL MacLeod-Boynton coordinates: http://www.cvrl.org/ccs.htm

// Stockman-Sharpe LMS instantiated in MacLeod-Boynton coordinates using the
// repo's CIE 170-2 weighting constants.
// These weights are fixed observer-basis coefficients:
// - they weigh LMS to form weighted LMS / MB coordinates,
// - they carry a physiological achromatic axis tied to Yf / L+M-style
//   bookkeeping,
// - they are not adaptation, gain-control, or bleaching parameters.
// Source direction:
// - CVRL/CIE physiological functions are linear transformations of the
//   Stockman-Sharpe cone fundamentals.
// - Yf is the correct luminance/luminosity axis for this LMS basis; MB carries
//   the weighted L+M term that matches that observer construction.

static const float3x3 LMS_TO_XYZ_MAT = renodx::color::STOCKMAN_CVRL_LMS_TO_XYZ_2DEG_FIT;
static const float3x3 XYZ_TO_LMS_MAT = renodx::color::STOCKMAN_CVRL_XYZ_TO_LMS_2DEG_FIT;
static const float3 LMS_WEIGHTS = renodx::color::CIE1702_MB_CIE_WEIGHTS;

static const float3x3 LMS_TO_LMS_WEIGHTED_MAT = float3x3(
    LMS_WEIGHTS.x, 0.f, 0.f,
    0.f, LMS_WEIGHTS.y, 0.f,
    0.f, 0.f, LMS_WEIGHTS.z);

static const float3x3 LMS_WEIGHTED_TO_LMS_MAT = float3x3(
    1.f / LMS_WEIGHTS.x, 0.f, 0.f,
    0.f, 1.f / LMS_WEIGHTS.y, 0.f,
    0.f, 0.f, 1.f / LMS_WEIGHTS.z);

static const float3x3 XYZ_TO_LMS_WEIGHTED_MAT = float3x3(
    mul(LMS_TO_LMS_WEIGHTED_MAT, XYZ_TO_LMS_MAT));

static const float3x3 BT709_TO_LMS_WEIGHTED_MAT =
    mul(XYZ_TO_LMS_WEIGHTED_MAT, renodx::color::BT709_TO_XYZ_MAT);

static const float3x3 BT2020_TO_LMS_WEIGHTED_MAT =
    mul(XYZ_TO_LMS_WEIGHTED_MAT, renodx::color::BT2020_TO_XYZ_MAT);

static const float3x3 LMS_WEIGHTED_TO_XYZ_MAT =
    mul(LMS_TO_XYZ_MAT, LMS_WEIGHTED_TO_LMS_MAT);

static const float3x3 LMS_WEIGHTED_TO_BT709_MAT =
    mul(renodx::color::XYZ_TO_BT709_MAT, LMS_WEIGHTED_TO_XYZ_MAT);

static const float3x3 LMS_WEIGHTED_TO_BT2020_MAT =
    mul(renodx::color::XYZ_TO_BT2020_MAT, LMS_WEIGHTED_TO_XYZ_MAT);

float3 WeighLMS(float3 lms, float3 lms_weights = CIE1702_MB_CIE_WEIGHTS) {
  return lms * lms_weights;
}

float3 UnweighLMS(float3 lms_weighted, float3 lms_weights = CIE1702_MB_CIE_WEIGHTS) {
  return lms_weighted / lms_weights;
}

float3x3 LMSWeightMatrix(float3 lms_weights = CIE1702_MB_CIE_WEIGHTS) {
  return float3x3(
      lms_weights.x, 0.f, 0.f,
      0.f, lms_weights.y, 0.f,
      0.f, 0.f, lms_weights.z);
}

float3x3 LMSUnweightMatrix(float3 lms_weights = CIE1702_MB_CIE_WEIGHTS) {
  return float3x3(
      1.f / lms_weights.x, 0.f, 0.f,
      0.f, 1.f / lms_weights.y, 0.f,
      0.f, 0.f, 1.f / lms_weights.z);
}

float3x3 RGBToWeightedLMSMatrix(float3x3 xyz_to_lms, float3x3 rgb_to_xyz, float3 lms_weights = CIE1702_MB_CIE_WEIGHTS) {
  return mul(LMSWeightMatrix(lms_weights), mul(xyz_to_lms, rgb_to_xyz));
}

float3x3 WeightedLMSToRGBMatrix(float3x3 lms_to_xyz, float3x3 xyz_to_rgb, float3 lms_weights = CIE1702_MB_CIE_WEIGHTS) {
  return mul(xyz_to_rgb, mul(lms_to_xyz, LMSUnweightMatrix(lms_weights)));
}

// Reconstruct weighted LMS from MB chromaticity plus the carried MB scale term.
float3 WeightedLMSFromMacleodBoynton(float2 mb, float l_plus_m) {
  return float3(mb.x, (1.f - mb.x), mb.y) * l_plus_m;
}

float3 WeightedLMSFromMacleodBoynton(float3 mb) {
  return WeightedLMSFromMacleodBoynton(mb.xy, mb.z);
}

float2 WhiteChromaticityFromWeightedLMS(float3 lms_weighted_white) {
  float y_mb = lms_weighted_white.x + lms_weighted_white.y;
  y_mb = max(y_mb, 0);

  float inv = renodx::math::DivideSafe(1.f, y_mb, 0.f);
  return float2(lms_weighted_white.x * inv, lms_weighted_white.z * inv);
}

float3 WhiteFromWeightedLMS(float3 lms_weighted_white) {
  return float3(WhiteChromaticityFromWeightedLMS(lms_weighted_white), 1.f);
}

namespace from {
// Convert weighted LMS into MB as (l, s, y), where y is the carried L+M term.
float3 WeightedLMS(float3 weighted_lms) {
  float weighted_l = weighted_lms.x;
  float weighted_m = weighted_lms.y;
  float y_mb = weighted_l + weighted_m;
  y_mb = max(y_mb, 0);

  float inv = renodx::math::DivideSafe(1.f, y_mb, 0.f);
  return float3(weighted_l * inv, weighted_lms.z * inv, y_mb);
}

float3 LMS(float3 lms, float3 lms_weights = CIE1702_MB_CIE_WEIGHTS) {
  return from::WeightedLMS(macleod_boynton::WeighLMS(lms, lms_weights));
}

float3 BT709(float3 bt709) {
  return from::WeightedLMS(mul(BT709_TO_LMS_WEIGHTED_MAT, bt709));
}

float3 BT2020(float3 bt2020) {
  return from::WeightedLMS(mul(BT2020_TO_LMS_WEIGHTED_MAT, bt2020));
}

float3 XYZ(float3 xyz) {
  return from::WeightedLMS(mul(XYZ_TO_LMS_WEIGHTED_MAT, xyz));
}

float2 XY(float2 xy, float Y = 1.f) {
  return from::XYZ(renodx::color::xyz::from::xyY(float3(xy, Y))).xy;
}

float2 D65XY() {
  return from::XY(renodx::color::WHITE_POINT_D65);
}

}  // namespace from

}  // namespace macleod_boynton

namespace lms {
namespace from {

float3 MacLeodBoynton(float2 mb, float l_plus_m) {
  return macleod_boynton::WeightedLMSFromMacleodBoynton(mb, l_plus_m) / macleod_boynton::LMS_WEIGHTS;
}

float3 MacLeodBoynton(float3 mb_3) {
  return from::MacLeodBoynton(mb_3.xy, mb_3.z);
}

}  // namespace from
}  // namespace lms

namespace bt709 {
namespace from {
float3 MacLeodBoynton(float2 mb, float l_plus_m) {
  return mul(macleod_boynton::LMS_WEIGHTED_TO_BT709_MAT,
             macleod_boynton::WeightedLMSFromMacleodBoynton(mb, l_plus_m));
}

float3 MacLeodBoynton(float3 mb_3) {
  return bt709::from::MacLeodBoynton(mb_3.xy, mb_3.z);
}
}  // namespace from
}  // namespace bt709

namespace bt2020 {
namespace from {
float3 MacLeodBoynton(float2 mb, float l_plus_m) {
  return mul(macleod_boynton::LMS_WEIGHTED_TO_BT2020_MAT,
             macleod_boynton::WeightedLMSFromMacleodBoynton(mb, l_plus_m));
}

float3 MacLeodBoynton(float3 mb_3) {
  return bt2020::from::MacLeodBoynton(mb_3.xy, mb_3.z);
}
}  // namespace from
}  // namespace bt2020

}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_MACLEOD_BOYNTON_HLSL_
