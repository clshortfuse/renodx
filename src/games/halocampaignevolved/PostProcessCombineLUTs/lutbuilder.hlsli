#ifndef RENODX_UNREAL_LUT_BUILDER_HLSLI_
#define RENODX_UNREAL_LUT_BUILDER_HLSLI_

#include "../common.hlsli"
#include "./colorcorrectall.hlsli"
#include "./config.hlsli"
#include "./filmtonemap.hlsli"
#include "./usergrading.hlsli"

namespace unrealengine {
namespace lutbuilder {

namespace outputdevice {
static const int SRGB = 0;
static const int REC709 = 1;
static const int EXPLICIT_GAMMA = 2;
static const int ACES_1000_NIT_ST2084 = 3;
static const int ACES_2000_NIT_ST2084 = 4;
static const int ACES_1000_NIT_SCRGB = 5;
static const int ACES_2000_NIT_SCRGB = 6;
static const int LINEAR_EXR = 7;
static const int NO_TONE_CURVE = 8;
static const int WITH_TONE_CURVE = 9;
}  // namespace outputdevice

namespace outputgamut {
static const int SRGB_D65 = 0;
static const int P3_D65 = 1;
static const int BT2020_D65 = 2;
static const int ACES_AP0_D60 = 3;
static const int ACESCG_AP1_D60 = 4;
}  // namespace outputgamut

float3 WorkingToAP1(float3 color_working, const OutputConfig config) {
  return mul(
      float3x3(
          config.working_to_ap1_row_0,
          config.working_to_ap1_row_1,
          config.working_to_ap1_row_2),
      color_working);
}

float3 AP1ToOutputGamut(float3 color_ap1, int output_gamut) {
  if (output_gamut == outputgamut::P3_D65) {
    return mul(
        float3x3(
            1.3792141675949097f, -0.30886411666870117f, -0.0703500509262085f,
            -0.06933490186929703f, 1.08229660987854f, -0.012961871922016144f,
            -0.0021590073592960835f, -0.0454593189060688f, 1.0476183891296387f),
        color_ap1);
  }
  if (output_gamut == outputgamut::BT2020_D65) {
    return renodx::color::bt2020::from::AP1(color_ap1);
  }
  if (output_gamut == outputgamut::ACES_AP0_D60) {
    return mul(renodx::color::AP1_TO_AP0_MAT, color_ap1);
  }
  if (output_gamut == outputgamut::ACESCG_AP1_D60) return color_ap1;

  // outputgamut::SRGB_D65 and unknown values use sRGB / BT.709 D65.
  return renodx::color::bt709::from::AP1(color_ap1);
}

float3 WorkingToOutputGamut(float3 color_working, const OutputConfig config) {
  float3 color_ap1 = WorkingToAP1(color_working, config);
  return AP1ToOutputGamut(color_ap1, config.output_gamut);
}

float3 EncodeRec709Safe(float3 color) {
  float3 signs = sign(color);
  color = abs(color);
  return signs * min(color * 4.5f, (pow(max(color, 0.018f), 0.45f) * 1.099f) - 0.099f);
}

float3 ApplyEOTFEmulation(float3 color_ap1) {
  if (RENODX_GAMMA_CORRECTION == 0.f) return color_ap1;

  float3 color_bt709 = renodx::color::bt709::from::AP1(color_ap1);
  color_bt709 = renodx::color::correct::GammaSafe(color_bt709);
  return renodx::color::ap1::from::BT709(color_bt709);
}

// ColorCorrectAll -> film tone map where required -> post grade
// -> OutputDevice/OutputGamut dispatch. The result is ready for either a
// compute-shader UAV write or a pixel-shader return.
bool TryApplyCustomLUTBuilder(
    float3 ungraded_ap1,
    const Config config,
    out float4 output) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return false;

  float3 graded_ap1 = ColorCorrectAll(ungraded_ap1, config.color_correction);

  float3 color_working;
  if ((config.output.output_device != outputdevice::LINEAR_EXR) && (config.output.output_device != outputdevice::NO_TONE_CURVE)) {
    graded_ap1 = ApplyUserGradingAP1(graded_ap1);

    float3 tonemapped_ap1 = filmtonemap::ApplyExtended(graded_ap1, config.film);
    color_working = mul(
        float3x3(
            config.output.working_from_ap1_row_0,
            config.output.working_from_ap1_row_1,
            config.output.working_from_ap1_row_2),
        tonemapped_ap1);
    float3 mapping_scale = mad(
        config.post_grade.mapping_polynomial.x,
        color_working,
        config.post_grade.mapping_polynomial.y);
    color_working = mad(
        mapping_scale,
        color_working,
        config.post_grade.mapping_polynomial.z);
    color_working *= config.post_grade.color_scale;
  } else {
    color_working = mul(
        float3x3(
            config.output.working_from_ap1_row_0,
            config.output.working_from_ap1_row_1,
            config.output.working_from_ap1_row_2),
        graded_ap1);
    color_working *= config.post_grade.color_scale;
  }
  color_working = lerp(color_working, config.post_grade.overlay_color.rgb, config.post_grade.overlay_color.a);

  float3 output_color;
  if (config.output.output_device == outputdevice::LINEAR_EXR) {  // OutputDevice 7
    // Linear EXR is stored as output-gamut PQ in the generated LUT.
    output_color = WorkingToOutputGamut(color_working, config.output);
    output_color = renodx::color::pq::EncodeSafe(output_color);

  } else if (config.output.output_device == outputdevice::NO_TONE_CURVE) {  // OutputDevice 8
    output_color = color_working;

  } else if (config.output.output_device == outputdevice::WITH_TONE_CURVE) {  // OutputDevice 9
    output_color = WorkingToOutputGamut(color_working, config.output);

  } else if ((config.output.output_device >= outputdevice::ACES_1000_NIT_ST2084) && (config.output.output_device <= outputdevice::ACES_2000_NIT_SCRGB)) {  // OutputDevices 3-6
    float3 color_ap1 = WorkingToAP1(color_working, config.output);
    // The scRGB formats also use PQ-encoded AP1 as their generated-LUT storage
    // representation. Their later output pass decodes and converts it to scRGB.
    if ((config.output.output_device == outputdevice::ACES_1000_NIT_SCRGB) || (config.output.output_device == outputdevice::ACES_2000_NIT_SCRGB)) {  // OutputDevices 5-6
      output_color = renodx::color::pq::EncodeSafe(color_ap1, RENODX_DIFFUSE_WHITE_NITS);
    } else {  // OutputDevices 3-4
      color_ap1 = ApplyEOTFEmulation(color_ap1);
      output_color = AP1ToOutputGamut(color_ap1, config.output.output_gamut);
      output_color = renodx::color::pq::EncodeSafe(output_color, RENODX_DIFFUSE_WHITE_NITS);
    }

  } else {  // OutputDevices 0-2 and unknown values
    // color_working = renodx::math::SignPow(color_working, config.post_grade.inverse_gamma); // skip in HDR

    if (config.output.output_device == outputdevice::SRGB) {  // OutputDevice 0
      output_color = color_working;
      if (config.output.working_is_srgb == 0) {
        output_color = WorkingToOutputGamut(output_color, config.output);
      }
      output_color = renodx::color::srgb::EncodeSafe(output_color);
    } else if (config.output.output_device == outputdevice::REC709) {  // OutputDevice 1
      output_color = WorkingToOutputGamut(color_working, config.output);
      output_color = EncodeRec709Safe(output_color);
    } else {  // OutputDevice 2 and unknown values
      // outputdevice::EXPLICIT_GAMMA and unknown values use explicit gamma mapping.
      output_color = WorkingToOutputGamut(color_working, config.output);
      output_color = renodx::math::SignPow(output_color, config.output.inverse_gamma);
    }

#if 0
    if (RENODX_GAMMA_CORRECTION == 0.f) {
      output_color = renodx::color::srgb::DecodeSafe(output_color);
    } else if (RENODX_GAMMA_CORRECTION == 1.f) {
      output_color = renodx::color::gamma::DecodeSafe(output_color);
    }

    output_color = renodx::color::pq::EncodeSafe(output_color, RENODX_DIFFUSE_WHITE_NITS);
#endif
  }

  output = float4(output_color * (1.f / 1.05f), 0.f);
  return true;
}

}  // namespace lutbuilder
}  // namespace unrealengine

#endif  // RENODX_UNREAL_LUT_BUILDER_HLSLI_