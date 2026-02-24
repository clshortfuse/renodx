#include "../common.hlsli"

// START DECLARATIONS ---------------------------------------------------------------------------------------

Texture3D<float4> tTextureMap0 : register(t6);

Texture3D<float4> tTextureMap1 : register(t7);

Texture3D<float4> tTextureMap2 : register(t8);

cbuffer TonemapParam : register(b1) {
  float contrast : packoffset(c000.x);
  float linearBegin : packoffset(c000.y);
  float linearLength : packoffset(c000.z);
  //   float toe : packoffset(c000.w);
  float ORIGINAL_toe : packoffset(c000.w);
  //   float maxNit : packoffset(c001.x);
  float ORIGINAL_maxNit : packoffset(c001.x);
  //   float linearStart : packoffset(c001.y);
  float ORIGINAL_linearStart : packoffset(c001.y);
  float displayMaxNitSubContrastFactor : packoffset(c001.z);
  float contrastFactor : packoffset(c001.w);
  float mulLinearStartContrastFactor : packoffset(c002.x);
  float invLinearBegin : packoffset(c002.y);
  float madLinearStartContrastFactor : packoffset(c002.z);
  //   float tonemapParam_isHDRMode : packoffset(c002.w);
  float ORIGINAL_tonemapParam_isHDRMode : packoffset(c002.w);
  float useDynamicRangeConversion : packoffset(c003.x);
  float useHuePreserve : packoffset(c003.y);
  float exposureScale : packoffset(c003.z);
  float kneeStartNit : packoffset(c003.w);
  float knee : packoffset(c004.x);
  float curve_HDRip : packoffset(c004.y);
  float curve_k2 : packoffset(c004.z);
  float curve_k4 : packoffset(c004.w);
  row_major float4x4 RGBToXYZViaCrosstalkMatrix : packoffset(c005.x);
  row_major float4x4 XYZToRGBViaCrosstalkMatrix : packoffset(c009.x);
  float tonemapGraphScale : packoffset(c013.x);
  float offsetEVCurveStart : packoffset(c013.y);
  float offsetEVCurveRange : packoffset(c013.z);
};

cbuffer LDRPostProcessParam : register(b2) {
  float fHazeFilterStart : packoffset(c000.x);
  float fHazeFilterInverseRange : packoffset(c000.y);
  float fHazeFilterHeightStart : packoffset(c000.z);
  float fHazeFilterHeightInverseRange : packoffset(c000.w);
  float4 fHazeFilterUVWOffset : packoffset(c001.x);
  float fHazeFilterScale : packoffset(c002.x);
  float fHazeFilterBorder : packoffset(c002.y);
  float fHazeFilterBorderFade : packoffset(c002.z);
  float fHazeFilterDepthDiffBias : packoffset(c002.w);
  uint fHazeFilterAttribute : packoffset(c003.x);
  uint fHazeFilterReductionResolution : packoffset(c003.y);
  uint fHazeFilterReserved1 : packoffset(c003.z);
  uint fHazeFilterReserved2 : packoffset(c003.w);
  float fDistortionCoef : packoffset(c004.x);
  float fRefraction : packoffset(c004.y);
  float fRefractionCenterRate : packoffset(c004.z);
  float fGradationStartOffset : packoffset(c004.w);
  float fGradationEndOffset : packoffset(c005.x);
  uint aberrationEnable : packoffset(c005.y);
  uint distortionType : packoffset(c005.z);
  float fCorrectCoef : packoffset(c005.w);
  uint aberrationBlurEnable : packoffset(c006.x);
  float fBlurNoisePower : packoffset(c006.y);
  float2 LensDistortion_Reserve : packoffset(c006.z);
  float4 fOptimizedParam : packoffset(c007.x);
  float2 fNoisePower : packoffset(c008.x);
  float2 fNoiseUVOffset : packoffset(c008.z);
  float fNoiseDensity : packoffset(c009.x);
  float fNoiseContrast : packoffset(c009.y);
  float fBlendRate : packoffset(c009.z);
  float fReverseNoiseSize : packoffset(c009.w);
  float fTextureSize : packoffset(c010.x);
  float fTextureBlendRate : packoffset(c010.y);
  float fTextureBlendRate2 : packoffset(c010.z);
  float fTextureInverseSize : packoffset(c010.w);
  float fHalfTextureInverseSize : packoffset(c011.x);
  float fOneMinusTextureInverseSize : packoffset(c011.y);
  float fColorCorrectTextureReserve : packoffset(c011.z);
  float fColorCorrectTextureReserve2 : packoffset(c011.w);
  row_major float4x4 fColorMatrix : packoffset(c012.x);
  float4 cvdR : packoffset(c016.x);
  float4 cvdG : packoffset(c017.x);
  float4 cvdB : packoffset(c018.x);
  float4 ColorParam : packoffset(c019.x);
  float Levels_Rate : packoffset(c020.x);
  float Levels_Range : packoffset(c020.y);
  uint Blend_Type : packoffset(c020.z);
  float ImagePlane_Reserve : packoffset(c020.w);
  float4 cbRadialColor : packoffset(c021.x);
  float2 cbRadialScreenPos : packoffset(c022.x);
  float2 cbRadialMaskSmoothstep : packoffset(c022.z);
  float2 cbRadialMaskRate : packoffset(c023.x);
  float cbRadialBlurPower : packoffset(c023.z);
  float cbRadialSharpRange : packoffset(c023.w);
  uint cbRadialBlurFlags : packoffset(c024.x);
  float cbRadialReserve0 : packoffset(c024.y);
  float cbRadialReserve1 : packoffset(c024.z);
  float cbRadialReserve2 : packoffset(c024.w);
};

// clang-format off
cbuffer CBControl : register(b3) {
  float3 CBControl_reserve : packoffset(c000.x);
  uint cPassEnabled : packoffset(c000.w);
  row_major float4x4 fOCIOTransformMatrix : packoffset(c001.x);
  struct RGCParam {
    float CyanLimit;
    float MagentaLimit;
    float YellowLimit;
    float CyanThreshold;
    float MagentaThreshold;
    float YellowThreshold;
    float RollOff;
    uint EnableReferenceGamutCompress;
    float InvCyanSTerm;
    float InvMagentaSTerm;
    float InvYellowSTerm;
    float InvRollOff;
  } cbControlRGCParam: packoffset(c005.x);
};
// clang-format on

SamplerState TrilinearClamp : register(s9, space32);

static float maxNit = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_maxNit : renodx::math::FLT32_MAX;
static float linearStart = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_linearStart : renodx::math::FLT32_MAX;
static float toe = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_toe : 1.f;

static float tonemapParam_isHDRMode = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_tonemapParam_isHDRMode : 0.f;

// END DECLARATIONS ---------------------------------------------------------------------------------------

// float3 BlendLUTs(float3 color) {
//   const float lut_scale = 1.f - fTextureInverseSize;
//   const float lut_offset = fTextureInverseSize * 0.5f;
//   float3 color_encoded = renodx::color::acescct::Encode(color);

//   float3 output;
//   if (TONE_MAP_TYPE == 0.f) {
//     output = tTextureMap0.SampleLevel(TrilinearClamp, color_encoded * lut_scale + lut_offset, 0.f).rgb;
//     output = renodx::color::acescct::Decode(output);
//   } else {
//     output = renodx::lut::SampleTetrahedral(tTextureMap0, color_encoded, (uint)fTextureSize).rgb;
//     output = renodx::color::acescct::Decode(output);
//   }

//   [branch]
//   if (fTextureBlendRate > 0.f) {
//     float3 lut1;
//     if (TONE_MAP_TYPE == 0.f) {
//       lut1 = tTextureMap1.SampleLevel(TrilinearClamp, color_encoded * lut_scale + lut_offset, 0.f).rgb;
//       lut1 = renodx::color::acescct::Decode(lut1);
//     } else {
//       lut1 = renodx::lut::SampleTetrahedral(tTextureMap1, color_encoded, (uint)fTextureSize).rgb;
//       lut1 = renodx::color::acescct::Decode(lut1);
//     }
//     output = lerp(output.rgb, lut1, fTextureBlendRate);
//   }

//   [branch]
//   if (fTextureBlendRate2 > 0.f) {
//     // missing lut scale and offset for some reason
//     float3 lut2 = tTextureMap2.SampleLevel(TrilinearClamp, renodx::color::acescct::Encode(output), 0.f).rgb;
//     lut2 = renodx::color::acescct::Decode(lut2);
//     output = lerp(output, lut2, fTextureBlendRate2);
//   }

//   return output;
// }

float3 BlendLUTs(float3 color) {
  const float lut_scale = 1.f - fTextureInverseSize;
  const float lut_offset = fTextureInverseSize * 0.5f;

  float3 color_encoded = renodx::color::acescct::Encode(color);
  float3 lut_uv = color_encoded * lut_scale + lut_offset;

  float3 output = tTextureMap0.SampleLevel(TrilinearClamp, lut_uv, 0.f).rgb;
  output = max(0.f, renodx::color::acescct::Decode(output));

  [branch]
  if (fTextureBlendRate > 0.f) {
    float3 lut1 = tTextureMap1.SampleLevel(TrilinearClamp, lut_uv, 0.f).rgb;
    lut1 = max(0.f, renodx::color::acescct::Decode(lut1));
    output = lerp(output, lut1, fTextureBlendRate);
  }

  [branch]
  if (fTextureBlendRate2 > 0.f) {
    float3 output_encoded = renodx::color::acescct::Encode(output);
    float3 lut2_uv = output_encoded * lut_scale + lut_offset;
    float3 lut2 = tTextureMap2.SampleLevel(TrilinearClamp, lut2_uv, 0.f).rgb;
    lut2 = max(0.f, renodx::color::acescct::Decode(lut2));
    output = lerp(output, lut2, fTextureBlendRate2);
  }

  return output;
}

float3 ApplyColorGradingLUTs(float3 color_input) {
  float3 color_output = BlendLUTs(color_input);

  if (COLOR_GRADE_LUT_SCALING > 0.f) {
    float3 lut_black = BlendLUTs(0.f);

    float lut_black_y = renodx::color::y::from::AP1(lut_black);
    if (lut_black_y > 0.f) {
      float3 lut_mid = BlendLUTs(lut_black_y);

      float3 unclamped_gamma = Unclamp(
          renodx::color::gamma::EncodeSafe(color_output),
          renodx::color::gamma::EncodeSafe(lut_black),
          renodx::color::gamma::EncodeSafe(lut_mid),
          renodx::color::gamma::EncodeSafe(color_input));

      float3 unclamped_linear = renodx::color::gamma::DecodeSafe(unclamped_gamma);

      color_output *= lerp(1.f, renodx::math::DivideSafe(LuminosityFromAP1(unclamped_linear), LuminosityFromAP1(color_output), 1.f), COLOR_GRADE_LUT_SCALING);
    }
  }

  return color_output;
}

void ApplyColorGrading(float r_in, float g_in, float b_in,
                       inout float r_out, inout float g_out, inout float b_out) {
  float3 working_color = float3(r_in, g_in, b_in);

  if ((cPassEnabled & 4) != 0) {
    if (COLOR_GRADE_LUT_STRENGTH > 0.f) {
      float3 lutted = ApplyColorGradingLUTs(working_color);
      working_color = lerp(working_color, lutted, COLOR_GRADE_LUT_STRENGTH);
    }

    {  // color matrix
      working_color.r = mad(working_color.b, fColorMatrix[2].x, mad(working_color.g, fColorMatrix[1].x, (working_color.r * fColorMatrix[0].x))) + fColorMatrix[3].x;
      working_color.g = mad(working_color.b, fColorMatrix[2].y, mad(working_color.g, fColorMatrix[1].y, (working_color.r * fColorMatrix[0].y))) + fColorMatrix[3].y;
      working_color.b = mad(working_color.b, fColorMatrix[2].z, mad(working_color.g, fColorMatrix[1].z, (working_color.r * fColorMatrix[0].z))) + fColorMatrix[3].z;
    }
  }

  r_out = working_color.r, g_out = working_color.g, b_out = working_color.b;
  return;
}

float3 ApplyCustomGrading(float3 ungraded, float3 untonemapped, float2 uv) {
  float3 graded = ungraded;

  float3 ungraded_bt2020 = renodx::color::bt2020::from::AP1(ungraded);

  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_GAMMA,                                // float gamma;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_DECHROMA,                              // float dechroma;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    0.f,                                                  // float hue_emulation;
    0.f                                                   // float purity_emulation;
  };

  float luminosity = LuminosityFromBT2020LuminanceNormalized(ungraded_bt2020);
  float3 graded_bt2020 = ApplyLuminosityGrading(ungraded_bt2020, luminosity, cg_config, 0.14f);
  graded_bt2020 = ApplyHueAndPurityGrading(graded_bt2020, ungraded_bt2020, luminosity, cg_config);

  if (CUSTOM_GRAIN_STRENGTH > 0.f) {
    graded_bt2020 = renodx::color::bt2020::from::BT709(renodx::effects::ApplyFilmGrain(
        renodx::color::bt709::from::BT2020(graded_bt2020),
        uv,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.01f));
  }

  graded = renodx::color::ap1::from::BT2020(graded_bt2020);

  return graded;
}
