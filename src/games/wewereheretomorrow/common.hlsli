#ifndef SRC_GAMES_WEWEREHERETOMORROW_COMMON_HLSLI_
#define SRC_GAMES_WEWEREHERETOMORROW_COMMON_HLSLI_

#include "./shared.h"

static const float MID_GRAY = 0.18f;

// Luminance the vanilla LUT produces for a neutral gray scene value. This is the game's own tonemap curve.
float VanillaGrayCurve(Texture3D<float4> lut, SamplerState lut_sampler, float4 lut_params, float gray) {
  float coord = saturate(log2(max(0.f, gray * 5.55555582f + 0.0479959995f)) * 0.0734997839f + 0.386036009f);
  coord = coord * lut_params.y * lut_params.x + 0.5f * lut_params.x;
  return renodx::color::y::from::BT709(lut.SampleLevel(lut_sampler, float3(coord, coord, coord), 0).xyz);
}

// untonemapped: linear scene color after post exposure, input of the vanilla grading LUT.
// graded_sdr: vanilla LUT result (tonemap + grade). lut / lut_sampler / lut_params (cb1[6]): the vanilla LUT.
float3 ToneMapLut(float3 untonemapped, float3 graded_sdr, Texture3D<float4> lut, SamplerState lut_sampler, float4 lut_params) {
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
        RENODX_TONE_MAP_BLOWOUT,
        100.f,
        1.f,
        1.f,
        1,
        vanilla_cone * (max(0.01f, RENODX_PSYCHOV_CONE_RESPONSE)),
        float3(MID_GRAY, MID_GRAY, MID_GRAY),
        float3(vanilla_mid_gray_out, vanilla_mid_gray_out, vanilla_mid_gray_out),
        saturate(RENODX_PSYCHOV_GAMUT_COMPRESSION),
        1,
        1.f,
        clamp(RENODX_PSYCHOV_COMPRESSION, 0.f, 2.f),
        (int)RENODX_PSYCHOV_SOURCE_BOUNDARY);
  } else {
    tonemapped = renodx::draw::ToneMapPass(untonemapped, graded_sdr, neutral_sdr);
  }
  return renodx::draw::RenderIntermediatePass(tonemapped);
}

#endif  // SRC_GAMES_WEWEREHERETOMORROW_COMMON_HLSLI_
