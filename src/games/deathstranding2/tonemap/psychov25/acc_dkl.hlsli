#ifndef SRC_SHADERS_COLOR_ACC_DKL_HLSL_
#define SRC_SHADERS_COLOR_ACC_DKL_HLSL_

#include "./stockman.hlsli"

namespace renodx {
namespace color {

namespace acc {
// Generic ACC algebra:
// - lms_white defines the opponent matrix coefficients (mc1, mc2)
// - lms_background defines the operating point that LMS is delta'd against
// - matrix overloads allow a fully folded fast path when white/background are fixed
// - weighted/unweighted LMS use the same algebra; the separate entry points make
//   the caller's basis choice explicit
static const float EPSILON = 1e-6f;

float3 SafeLMSWhite(float3 lms_white = 1) {
  return max(abs(lms_white), EPSILON.xxx);
}

float2 ParamsFromLMSWhite(float3 lms_white = 1) {
  float3 white = SafeLMSWhite(lms_white);
  return float2(
      renodx::math::DivideSafe(white.x, white.y, 0),
      renodx::math::DivideSafe(white.x + white.y, white.z, 0));
}

float2 ParamsFromWeightedLMSWhite(float3 lms_weighted_white = 1) {
  return ParamsFromLMSWhite(lms_weighted_white);
}

float3x3 LMSDeltaToACCMatrix(float3 lms_white = 1) {
  float2 acc_params = ParamsFromLMSWhite(lms_white);
  float mc1 = acc_params.x;
  float mc2 = acc_params.y;

  return float3x3(
      1.00000000f, 1.00000000f, 0.00000000f,
      1.00000000f, -mc1, 0.00000000f,
      -1.00000000f, -1.00000000f, mc2);
}

float3x3 WeightedLMSDeltaToACCMatrix(float3 lms_weighted_white = 1) {
  return LMSDeltaToACCMatrix(lms_weighted_white);
}

float3x3 ACCToLMSDeltaMatrix(float3 lms_white = 1) {
  float2 acc_params = ParamsFromLMSWhite(lms_white);
  float mc1 = acc_params.x;
  float mc2 = acc_params.y;

  float inv_lm = renodx::math::DivideSafe(1.f, 1.f + mc1, 0);
  float inv_s = renodx::math::DivideSafe(1.f, mc2, 0);

  return float3x3(
      mc1 * inv_lm, inv_lm, 0.00000000f,
      inv_lm, -inv_lm, 0.00000000f,
      inv_s, 0.00000000f, inv_s);
}

float3x3 ACCToWeightedLMSDeltaMatrix(float3 lms_weighted_white = 1) {
  return ACCToLMSDeltaMatrix(lms_weighted_white);
}

float3 BiasFromLMSBackground(float3x3 lms_delta_to_acc_mat, float3 lms_background = 0) {
  return -mul(lms_delta_to_acc_mat, lms_background);
}

namespace from {
float3 LMSDelta(float3 delta_lms, float3 lms_white = 1) {
  return mul(LMSDeltaToACCMatrix(lms_white), delta_lms);
}

float3 LMSDelta(float3 delta_lms, float3x3 lms_delta_to_acc_mat) {
  return mul(lms_delta_to_acc_mat, delta_lms);
}

float3 WeightedLMSDelta(float3 delta_lms_weighted, float3 lms_weighted_white = 1) {
  return mul(WeightedLMSDeltaToACCMatrix(lms_weighted_white), delta_lms_weighted);
}

float3 WeightedLMSDelta(float3 delta_lms_weighted, float3x3 weighted_lms_delta_to_acc_mat) {
  return mul(weighted_lms_delta_to_acc_mat, delta_lms_weighted);
}

float3 LMS(float3 lms, float3 lms_white = 1, float3 lms_background = 0) {
  return LMSDelta(lms - lms_background, lms_white);
}

float3 LMS(float3 lms, float3x3 lms_to_acc_mat, float3 acc_bias = 0) {
  return mul(lms_to_acc_mat, lms) + acc_bias;
}

float3 WeightedLMS(float3 lms_weighted, float3 lms_weighted_white = 1,
                   float3 lms_weighted_background = 0) {
  return WeightedLMSDelta(lms_weighted - lms_weighted_background, lms_weighted_white);
}

float3 WeightedLMS(float3 lms_weighted, float3x3 weighted_lms_to_acc_mat, float3 acc_bias = 0) {
  return mul(weighted_lms_to_acc_mat, lms_weighted) + acc_bias;
}
}  // namespace from

namespace to {
float3 LMSDelta(float3 acc_value, float3 lms_white = 1) {
  return mul(ACCToLMSDeltaMatrix(lms_white), acc_value);
}

float3 LMSDelta(float3 acc_value, float3x3 acc_to_lms_delta_mat) {
  return mul(acc_to_lms_delta_mat, acc_value);
}

float3 WeightedLMSDelta(float3 acc_value, float3 lms_weighted_white = 1) {
  return mul(ACCToWeightedLMSDeltaMatrix(lms_weighted_white), acc_value);
}

float3 WeightedLMSDelta(float3 acc_value, float3x3 acc_to_weighted_lms_delta_mat) {
  return mul(acc_to_weighted_lms_delta_mat, acc_value);
}

float3 LMS(float3 acc_value, float3 lms_white = 1, float3 lms_background = 0) {
  return LMSDelta(acc_value, lms_white) + lms_background;
}

float3 LMS(float3 acc_value, float3x3 acc_to_lms_delta_mat, float3 lms_background = 0) {
  return mul(acc_to_lms_delta_mat, acc_value) + lms_background;
}

float3 WeightedLMS(float3 acc_value, float3 lms_weighted_white = 1,
                   float3 lms_weighted_background = 0) {
  return WeightedLMSDelta(acc_value, lms_weighted_white) + lms_weighted_background;
}

float3 WeightedLMS(float3 acc_value, float3x3 acc_to_weighted_lms_delta_mat,
                   float3 lms_weighted_background = 0) {
  return mul(acc_to_weighted_lms_delta_mat, acc_value) + lms_weighted_background;
}
}  // namespace to
}  // namespace acc

namespace dkl {
namespace from {
float3 LMSDelta(float3 delta_lms, float3 lms_white = 1) {
  return acc::from::LMSDelta(delta_lms, lms_white);
}

float3 LMSDelta(float3 delta_lms, float3x3 lms_delta_to_dkl_mat) {
  return acc::from::LMSDelta(delta_lms, lms_delta_to_dkl_mat);
}

float3 WeightedLMSDelta(float3 delta_lms_weighted, float3 lms_weighted_white = 1) {
  return acc::from::WeightedLMSDelta(delta_lms_weighted, lms_weighted_white);
}

float3 WeightedLMSDelta(float3 delta_lms_weighted, float3x3 weighted_lms_delta_to_dkl_mat) {
  return acc::from::WeightedLMSDelta(delta_lms_weighted, weighted_lms_delta_to_dkl_mat);
}

float3 LMS(float3 lms, float3 lms_white = 1, float3 lms_background = 0) {
  return acc::from::LMS(lms, lms_white, lms_background);
}

float3 LMS(float3 lms, float3x3 lms_to_dkl_mat, float3 dkl_bias = 0) {
  return acc::from::LMS(lms, lms_to_dkl_mat, dkl_bias);
}

float3 WeightedLMS(float3 lms_weighted, float3 lms_weighted_white = 1,
                   float3 lms_weighted_background = 0) {
  return acc::from::WeightedLMS(lms_weighted, lms_weighted_white, lms_weighted_background);
}

float3 WeightedLMS(float3 lms_weighted, float3x3 weighted_lms_to_dkl_mat, float3 dkl_bias = 0) {
  return acc::from::WeightedLMS(lms_weighted, weighted_lms_to_dkl_mat, dkl_bias);
}
}  // namespace from

namespace to {
float3 LMSDelta(float3 dkl_value, float3 lms_white = 1) {
  return acc::to::LMSDelta(dkl_value, lms_white);
}

float3 LMSDelta(float3 dkl_value, float3x3 dkl_to_lms_delta_mat) {
  return acc::to::LMSDelta(dkl_value, dkl_to_lms_delta_mat);
}

float3 WeightedLMSDelta(float3 dkl_value, float3 lms_weighted_white = 1) {
  return acc::to::WeightedLMSDelta(dkl_value, lms_weighted_white);
}

float3 WeightedLMSDelta(float3 dkl_value, float3x3 dkl_to_weighted_lms_delta_mat) {
  return acc::to::WeightedLMSDelta(dkl_value, dkl_to_weighted_lms_delta_mat);
}

float3 LMS(float3 dkl_value, float3 lms_white = 1, float3 lms_background = 0) {
  return acc::to::LMS(dkl_value, lms_white, lms_background);
}

float3 LMS(float3 dkl_value, float3x3 dkl_to_lms_delta_mat, float3 lms_background = 0) {
  return acc::to::LMS(dkl_value, dkl_to_lms_delta_mat, lms_background);
}

float3 WeightedLMS(float3 dkl_value, float3 lms_weighted_white = 1,
                   float3 lms_weighted_background = 0) {
  return acc::to::WeightedLMS(dkl_value, lms_weighted_white, lms_weighted_background);
}

float3 WeightedLMS(float3 dkl_value, float3x3 dkl_to_weighted_lms_delta_mat,
                   float3 lms_weighted_background = 0) {
  return acc::to::WeightedLMS(dkl_value, dkl_to_weighted_lms_delta_mat, lms_weighted_background);
}
}  // namespace to
}  // namespace dkl

namespace stockman {
namespace acc {
// Concrete Stockman ACC uses Stockman D65 as the white that defines the matrix.
// The optional background remains caller-controlled and defaults to zero delta.
float3 LMSWhite() {
  return renodx::color::lms::from::WhiteD65();
}

float2 Params() {
  return renodx::color::acc::ParamsFromLMSWhite(LMSWhite());
}

float3x3 LMSDeltaToACCMatrix() {
  return renodx::color::acc::LMSDeltaToACCMatrix(LMSWhite());
}

float3x3 ACCToLMSDeltaMatrix() {
  return renodx::color::acc::ACCToLMSDeltaMatrix(LMSWhite());
}

float3x3 LMSD65ToACCMatrix() {
  return renodx::color::acc::LMSDeltaToACCMatrix(1);
}

float3x3 ACCToLMSD65Matrix() {
  return renodx::color::acc::ACCToLMSDeltaMatrix(1);
}

namespace from {
float3 LMSDelta(float3 delta_lms) {
  return renodx::color::acc::from::LMSDelta(delta_lms, stockman::acc::LMSDeltaToACCMatrix());
}

float3 LMS(float3 lms_abs, float3 lms_background = 0) {
  return renodx::color::acc::from::LMS(
      lms_abs,
      stockman::acc::LMSDeltaToACCMatrix(),
      renodx::color::acc::BiasFromLMSBackground(
          stockman::acc::LMSDeltaToACCMatrix(),
          lms_background));
}

float3 BT709(float3 bt709, float3 lms_background = 0) {
  return LMS(lms::from::BT709(bt709), lms_background);
}

float3 BT2020(float3 bt2020, float3 lms_background = 0) {
  return LMS(lms::from::BT2020(bt2020), lms_background);
}

float3 LMSD65(float3 lms_d65, float3 lms_background = 0) {
  return renodx::color::acc::from::LMS(
      lms_d65,
      stockman::acc::LMSD65ToACCMatrix(),
      renodx::color::acc::BiasFromLMSBackground(
          stockman::acc::LMSD65ToACCMatrix(),
          lms_background));
}
}  // namespace from

namespace to {
float3 LMSDelta(float3 acc_value) {
  return renodx::color::acc::to::LMSDelta(acc_value, stockman::acc::ACCToLMSDeltaMatrix());
}

float3 LMS(float3 acc_value, float3 lms_background = 0) {
  return renodx::color::acc::to::LMS(
      acc_value,
      stockman::acc::ACCToLMSDeltaMatrix(),
      lms_background);
}

float3 BT709(float3 acc_value, float3 lms_background = 0) {
  return bt709::from::LMS(LMS(acc_value, lms_background));
}

float3 BT2020(float3 acc_value, float3 lms_background = 0) {
  return bt2020::from::LMS(LMS(acc_value, lms_background));
}

float3 LMSD65(float3 acc_value, float3 lms_background = 0) {
  return renodx::color::acc::to::LMS(
      acc_value,
      stockman::acc::ACCToLMSD65Matrix(),
      lms_background);
}
}  // namespace to
}  // namespace acc

namespace dkl {
namespace from {
float3 LMSDelta(float3 delta_lms) {
  return acc::from::LMSDelta(delta_lms);
}

float3 LMS(float3 lms_abs, float3 lms_background = 0) {
  return acc::from::LMS(lms_abs, lms_background);
}

float3 BT709(float3 bt709, float3 lms_background = 0) {
  return acc::from::BT709(bt709, lms_background);
}

float3 BT2020(float3 bt2020, float3 lms_background = 0) {
  return acc::from::BT2020(bt2020, lms_background);
}

float3 LMSD65(float3 lms_d65, float3 lms_background = 0) {
  return acc::from::LMSD65(lms_d65, lms_background);
}
}  // namespace from

namespace to {
float3 LMSDelta(float3 dkl_value) {
  return acc::to::LMSDelta(dkl_value);
}

float3 LMS(float3 dkl_value, float3 lms_background = 0) {
  return acc::to::LMS(dkl_value, lms_background);
}

float3 BT709(float3 dkl_value, float3 lms_background = 0) {
  return acc::to::BT709(dkl_value, lms_background);
}

float3 BT2020(float3 dkl_value, float3 lms_background = 0) {
  return acc::to::BT2020(dkl_value, lms_background);
}

float3 LMSD65(float3 dkl_value, float3 lms_background = 0) {
  return acc::to::LMSD65(dkl_value, lms_background);
}
}  // namespace to
}  // namespace dkl
}  // namespace stockman

}  // namespace color
}  // namespace renodx

#endif  // SRC_SHADERS_COLOR_ACC_DKL_HLSL_
