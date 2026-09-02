#include "../common.hlsli"

#ifdef TONE_MAP_PARAM_CBUFFER_REGISTER
cbuffer TonemapParam : register(TONE_MAP_PARAM_CBUFFER_REGISTER) {
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
  //   float madLinearStartContrastFactor : packoffset(c002.z);
  float madLinearStartContrastFactor : packoffset(c002.z);

  float tonemapParam_isHDRMode : packoffset(c002.w);

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
};

static float maxNit = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_maxNit : renodx::math::FLT32_MAX;
static float linearStart = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_linearStart : renodx::math::FLT32_MAX;
static float toe = (TONE_MAP_TYPE == 0.f) ? ORIGINAL_toe : 1.f;

float3 ApplyCapcomExponentialToneMap(float3 color) {
  if (tonemapParam_isHDRMode == 0.f || (TONE_MAP_APPLY_PRE_TONE_MAP_CURVE && TONE_MAP_TYPE)) {
    float3 t = color * invLinearBegin;  // color / linearBegin

    float3 toeSmooth = select(color < linearBegin, t * t * (3.f - 2.f * t), 1.f);  // smoothstep(0, linearBegin, color)

    float3 shoulderWeight = select(color < linearStart, 0.f, 1.f);

    float3 toeValue = pow(t, toe) * linearBegin;

    float3 linearValue = contrast * color + madLinearStartContrastFactor;

    float3 shoulderValue = maxNit - exp2(contrastFactor * color + mulLinearStartContrastFactor) * displayMaxNitSubContrastFactor;

    color = ((1.f - toeSmooth) * toeValue)
            + ((toeSmooth - shoulderWeight) * linearValue)
            + (shoulderWeight * shoulderValue);
  }

  return color;
}

void ApplyCapcomExponentialToneMap(float in_r, float in_g, float in_b, out float out_r, out float out_g, out float out_b) {
  float3 color = ApplyCapcomExponentialToneMap(float3(in_r, in_g, in_b));
  out_r = color.r, out_g = color.g, out_b = color.b;
}

float3 PrintPostProcessCbuffers(float3 color, float2 uv) {
  const float2 text_origin = float2(0.01f, 0.15f);
  const float2 glyph_size = float2(0.006f, 0.012f);
  const float line_height = 1.15f;
  const float text_alpha = 0.95f;
  const float text_intensity = 1.0f;
  const float3 header_color = float3(1.0f, 0.85f, 0.25f);
  const float3 body_color = float3(1.0f, 1.0f, 1.0f);

  renodx::canvas::Context context = renodx::canvas::CreateContext(
      uv,
      text_origin,
      glyph_size,
      color,
      text_intensity,
      body_color,
      text_alpha,
      text_intensity,
      renodx::canvas::MODE_NORMAL,
      0.0f,
      line_height);

  renodx::canvas::SetColor(context, header_color, text_alpha, text_intensity);
  DrawLabel(context, 'T', 'o', 'n', 'e', 'm', 'a', 'p', 'P', 'a', 'r', 'a', 'm');
  renodx::canvas::NewLine(context);
  renodx::canvas::SetColor(context, body_color, text_alpha, text_intensity);

  DrawFloatRow(context, tonemapParam_isHDRMode, 'i', 's', 'H', 'D', 'R', 'M', 'o', 'd', 'e');
  DrawFloatRow(context, invLinearBegin, 'i', 'n', 'v', 'L', 'i', 'n', 'e', 'a', 'r', 'B', 'e', 'g');
  DrawFloatRow(context, linearBegin, 'l', 'i', 'n', 'e', 'a', 'r', 'B', 'e', 'g', 'i', 'n');
  DrawFloatRow(context, linearStart, 'l', 'i', 'n', 'e', 'a', 'r', 'S', 't', 'a', 'r', 't');
  DrawFloatRow(context, toe, 't', 'o', 'e');
  DrawFloatRow(context, contrast, 'c', 'o', 'n', 't', 'r', 'a', 's', 't');
  DrawFloatRow(context, madLinearStartContrastFactor, 'm', 'a', 'd', 'S', 't', 'a', 'r', 't', 'C', 'F');
  DrawFloatRow(context, maxNit, 'm', 'a', 'x', 'N', 'i', 't');
  DrawFloatRow(context, contrastFactor, 'c', 'o', 'n', 't', 'r', 'a', 's', 't', 'F', 'a', 'c');
  DrawFloatRow(context, mulLinearStartContrastFactor, 'm', 'u', 'l', 'S', 't', 'a', 'r', 't', 'C', 'F');
  DrawFloatRow(context, displayMaxNitSubContrastFactor, 'd', 'i', 's', 'p', 'M', 'a', 'x', 'S', 'u', 'b');

  return renodx::canvas::GetOutput(context).rgb;
}
#endif  // TONE_MAP_PARAM_CBUFFER_REGISTER

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 SampleAndBlendLUTs(
    float3 color_input,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fTextureSize,
    float fOneMinusTextureInverseSize,
    float fHalfTextureInverseSize,
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp) {
  const float lutScale = fOneMinusTextureInverseSize;
  const float lutOffset = fHalfTextureInverseSize;
  float3 lutEncoded = renodx::color::acescct::Encode(color_input);
  float3 correctedColor = renodx::color::acescct::Decode(
      tTextureMap0.SampleLevel(TrilinearClamp, lutEncoded * lutScale + lutOffset, 0.f).rgb);

  if (fTextureBlendRate > 0.0f) {
    float3 blendColor = renodx::color::acescct::Decode(
        tTextureMap1.SampleLevel(TrilinearClamp, lutEncoded * lutScale + lutOffset, 0.f).rgb);
    correctedColor = lerp(correctedColor, blendColor, fTextureBlendRate);

    if (fTextureBlendRate2 > 0.0f) {
      float3 lutEncoded2 = renodx::color::acescct::Encode(correctedColor);
      float3 blendColor2 = renodx::color::acescct::Decode(
          tTextureMap2.SampleLevel(TrilinearClamp, lutEncoded2 * lutScale + lutOffset, 0.f).rgb);
      correctedColor = lerp(correctedColor, blendColor2, fTextureBlendRate2);
    }
  } else if (fTextureBlendRate2 > 0.0f) {
    float3 lutEncoded2 = renodx::color::acescct::Encode(correctedColor);
    float3 blendColor2 = renodx::color::acescct::Decode(
        tTextureMap2.SampleLevel(TrilinearClamp, lutEncoded2 * lutScale + lutOffset, 0.f).rgb);
    correctedColor = lerp(correctedColor, blendColor2, fTextureBlendRate2);
  }

  return correctedColor;
}

float3 ApplyColorGradingLUTs(
    float3 color_input,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fTextureSize,
    float fOneMinusTextureInverseSize,
    float fHalfTextureInverseSize,
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp) {
  float3 color_output = SampleAndBlendLUTs(
      color_input,
      fTextureBlendRate,
      fTextureBlendRate2,
      fTextureSize,
      fOneMinusTextureInverseSize,
      fHalfTextureInverseSize,
      tTextureMap0,
      tTextureMap1,
      tTextureMap2,
      TrilinearClamp);

  if (COLOR_GRADE_LUT_SCALING > 0.f) {
    float3 lut_black = SampleAndBlendLUTs(
        0.f,
        fTextureBlendRate,
        fTextureBlendRate2,
        fTextureSize,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp);

    float lut_black_y = renodx::color::y::from::AP1(lut_black);
    if (lut_black_y > 0.f) {
      float3 lut_mid = SampleAndBlendLUTs(
          lut_black,
          fTextureBlendRate,
          fTextureBlendRate2,
          fTextureSize,
          fOneMinusTextureInverseSize,
          fHalfTextureInverseSize,
          tTextureMap0,
          tTextureMap1,
          tTextureMap2,
          TrilinearClamp);

      float3 unclamped_gamma = Unclamp(
          renodx::color::srgb::EncodeSafe(color_output),
          renodx::color::srgb::EncodeSafe(lut_black),
          renodx::color::srgb::EncodeSafe(lut_mid),
          renodx::color::srgb::EncodeSafe(color_input));

      float3 unclamped_linear = renodx::color::srgb::DecodeSafe(unclamped_gamma);

      color_output *= lerp(
          1.f,
          renodx::math::DivideSafe(YfFromAP1(unclamped_linear), YfFromAP1(color_output), 1.f),
          COLOR_GRADE_LUT_SCALING);
    }
  }

  return color_output;
}

void ApplyColorCorrectTexturePass(
    bool enabled,
    float _1573,
    float _1574,
    float _1575,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fTextureSize,
    float fOneMinusTextureInverseSize,
    float fHalfTextureInverseSize,
    row_major float4x4 fColorMatrix,
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp,
    out float _1802,
    out float _1803,
    out float _1804) {
  if (enabled) {
    float3 input = float3(_1573, _1574, _1575);
    float3 correctedColor = ApplyColorGradingLUTs(
        input,
        fTextureBlendRate,
        fTextureBlendRate2,
        fTextureSize,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp);
    correctedColor = lerp(input, correctedColor, COLOR_GRADE_LUT_STRENGTH);

    _1802 = mad(correctedColor.z, (fColorMatrix[2].x), mad(correctedColor.y, (fColorMatrix[1].x), (correctedColor.x * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
    _1803 = mad(correctedColor.z, (fColorMatrix[2].y), mad(correctedColor.y, (fColorMatrix[1].y), (correctedColor.x * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
    _1804 = mad(correctedColor.z, (fColorMatrix[2].z), mad(correctedColor.y, (fColorMatrix[1].z), (correctedColor.x * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
  } else {
    _1802 = _1573;
    _1803 = _1574;
    _1804 = _1575;
  }
}
