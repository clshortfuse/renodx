#ifndef SRC_GAMES_RVTHEREYET_COMMON_HLSLI_
#define SRC_GAMES_RVTHEREYET_COMMON_HLSLI_

#include "./shared.h"

static const float MID_GRAY = 0.18f;
// Scene luminance above which the RenoDRT toe correction fades out (vanilla is near white here)
static const float TOE_PIVOT = 0.5f;

// Vanilla log encoding of the scene color that indexes the grading LUT
static const float LUT_LOG_OFFSET = 0.002667719265f;
static const float LUT_LOG_SCALE = 0.0714285746f;
static const float LUT_LOG_BIAS = 0.610726953f;
// The shader scales the LUT result before writing it
static const float LUT_OUTPUT_SCALE = 1.05f;

// Vanilla LUT result as linear light. The game stores the clipped, sRGB encoded LUT result.
float3 VanillaLutLinear(float3 lut_sample) {
  return renodx::color::srgb::DecodeSafe(saturate(lut_sample * LUT_OUTPUT_SCALE));
}

// Luminance the vanilla LUT produces for a neutral gray scene value. This is the game's own tonemap curve.
float VanillaGrayCurve(Texture3D<float4> lut, SamplerState lut_sampler, float2 lut_params, float gray) {
  float coord = saturate(log2(gray + LUT_LOG_OFFSET) * LUT_LOG_SCALE + LUT_LOG_BIAS);
  coord = coord * lut_params.x + lut_params.y;
  return renodx::color::y::from::BT709(VanillaLutLinear(lut.SampleLevel(lut_sampler, float3(coord, coord, coord), 0).xyz));
}

// untonemapped: linear scene color after exposure and bloom, input of the vanilla grading LUT.
// graded_sdr_encoded: vanilla LUT result as written by the game (tonemap + grade, sRGB encoded, scaled).
// lut / lut_sampler / lut_params (cb0[62].zw: scale, bias): the vanilla LUT.
float3 ToneMapLut(float3 untonemapped, float3 graded_sdr_encoded, Texture3D<float4> lut, SamplerState lut_sampler, float2 lut_params) {
  const float3 graded_sdr = renodx::color::srgb::DecodeSafe(saturate(graded_sdr_encoded));

  // Neutral SDR is the vanilla tonemap without the color grade: the LUT gray curve at the pixel luminance.
  // The delta between graded and neutral then isolates the grade, and the HDR tonemapper replaces the vanilla curve.
  const float untonemapped_y = renodx::color::y::from::BT709(untonemapped);
  const float3 neutral_sdr = untonemapped
                             * renodx::math::DivideSafe(VanillaGrayCurve(lut, lut_sampler, lut_params, untonemapped_y), untonemapped_y, 1.f);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_PSYCHOV30) {
    // Anchor PsychoV to the vanilla curve level and local slope (x * V'(x) / V(x)) at mid gray
    const float vanilla_mid_gray_out = VanillaGrayCurve(lut, lut_sampler, lut_params, MID_GRAY);
    const float slope = (VanillaGrayCurve(lut, lut_sampler, lut_params, MID_GRAY * 1.1f)
                         - VanillaGrayCurve(lut, lut_sampler, lut_params, MID_GRAY * 0.9f))
                        / (MID_GRAY * 0.2f);
    const float vanilla_cone = max(0.01f, MID_GRAY * slope / max(vanilla_mid_gray_out, 1e-5f));

    float peak_value = max(1.f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) {
      peak_value = renodx::color::correct::Gamma(peak_value, true, 2.2f);
    } else if (RENODX_GAMMA_CORRECTION == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) {
      peak_value = renodx::color::correct::Gamma(peak_value, true, 2.4f);
    }

    tonemapped = renodx::tonemap::psychov::psychotm_test30(
        renodx::draw::ComputeUntonemappedGraded(untonemapped, graded_sdr, neutral_sdr),
        peak_value,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        0.f,
        100.f,
        1.f,
        1.f,
        1,
        vanilla_cone * (max(0.01f, RENODX_PSYCHOV_CONE_RESPONSE)),
        float3(MID_GRAY, MID_GRAY, MID_GRAY),
        float3(vanilla_mid_gray_out, vanilla_mid_gray_out, vanilla_mid_gray_out),
        saturate(RENODX_PSYCHOV_GAMUT_COMPRESSION),
        (int)RENODX_PSYCHOV_GAMUT_MODE,
        1.f,
        clamp(RENODX_PSYCHOV_COMPRESSION, 0.f, 2.f),
        (int)RENODX_PSYCHOV_SOURCE_BOUNDARY);

    // psychotm_test30 has no blowout input (that slot is a placeholder), so apply it as the RenoDRT dechroma
    tonemapped = renodx::color::grade::UserColorGrading(tonemapped, 1.f, 1.f, 1.f, 1.f, 1.f, RENODX_TONE_MAP_BLOWOUT, 0.f);
  } else {
    tonemapped = renodx::draw::ToneMapPass(renodx::draw::ComputeUntonemappedGraded(untonemapped, graded_sdr, neutral_sdr));

    // RenoDRT is nearly linear below white. Follow the vanilla toe there so shadows keep the game's contrast.
    if (untonemapped_y < TOE_PIVOT) {
      tonemapped *= min(1.f,
                        (VanillaGrayCurve(lut, lut_sampler, lut_params, untonemapped_y) / max(untonemapped_y, 1e-5f))
                            / (VanillaGrayCurve(lut, lut_sampler, lut_params, TOE_PIVOT) / TOE_PIVOT));
    }
  }
  return renodx::draw::RenderIntermediatePass(tonemapped);
}

#endif  // SRC_GAMES_RVTHEREYET_COMMON_HLSLI_
