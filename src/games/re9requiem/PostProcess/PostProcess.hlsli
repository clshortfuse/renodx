#include "../common.hlsli"

float3 EncodeColorCorrectLutValue(float3 value) {
  return ((log2(select((value < 3.0517578125e-05f), ((value * 0.5f) + 1.52587890625e-05f), value)) * 0.05707760155200958f) + 0.5547950267791748f);
}

float3 DecodeColorCorrectLutValue(float3 value) {
  return max(exp2((value * 17.520000457763672f) + -9.720000267028809f), 0.0f);
}

float3 SampleColorCorrectLut(
    Texture3D<float4> textureMap,
    SamplerState trilinearClamp,
    float3 lutEncoded,
    float lutScale,
    float lutOffset) {
  float4 sampleValue = textureMap.SampleLevel(trilinearClamp, lutEncoded * lutScale + lutOffset, 0.0f);
  return sampleValue.rgb;
}

float3 SampleAndBlendLUTs(
    float3 color_input,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fOneMinusTextureInverseSize,
    float fHalfTextureInverseSize,
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp) {
  const float lutScale = fOneMinusTextureInverseSize;
  const float lutOffset = fHalfTextureInverseSize;
  float3 lutEncoded = EncodeColorCorrectLutValue(color_input);
  float3 correctedColor = DecodeColorCorrectLutValue(
      SampleColorCorrectLut(
          tTextureMap0,
          TrilinearClamp,
          lutEncoded,
          lutScale,
          lutOffset));

  if (fTextureBlendRate > 0.0f) {
    float3 blendColor = DecodeColorCorrectLutValue(
        SampleColorCorrectLut(
            tTextureMap1,
            TrilinearClamp,
            lutEncoded,
            lutScale,
            lutOffset));
    correctedColor = lerp(correctedColor, blendColor, fTextureBlendRate);

    if (fTextureBlendRate2 > 0.0f) {
      float3 lutEncoded2 = EncodeColorCorrectLutValue(correctedColor);
      float3 blendColor2 = DecodeColorCorrectLutValue(
          SampleColorCorrectLut(
              tTextureMap2,
              TrilinearClamp,
              lutEncoded2,
              lutScale,
              lutOffset));
      correctedColor = lerp(correctedColor, blendColor2, fTextureBlendRate2);
    }
  } else if (fTextureBlendRate2 > 0.0f) {
    float3 lutEncoded2 = EncodeColorCorrectLutValue(correctedColor);
    float3 blendColor2 = DecodeColorCorrectLutValue(
        SampleColorCorrectLut(
            tTextureMap2,
            TrilinearClamp,
            lutEncoded2,
            lutScale,
            lutOffset));
    correctedColor = lerp(correctedColor, blendColor2, fTextureBlendRate2);
  }

  return correctedColor;
}

float3 ApplyColorGradingLUTs(
    float3 color_input,
    float fTextureBlendRate,
    float fTextureBlendRate2,
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
          renodx::math::DivideSafe(LuminosityFromAP1(unclamped_linear), LuminosityFromAP1(color_output), 1.f),
          COLOR_GRADE_LUT_SCALING);
    }
  }

  return color_output;
}

void ApplyColorCorrectTexturePass(
    bool _365,
    uint cPassEnabled,
    float _1573,
    float _1574,
    float _1575,
    float fTextureBlendRate,
    float fTextureBlendRate2,
    float fOneMinusTextureInverseSize,
    float fHalfTextureInverseSize,
    row_major float4x4 fColorMatrix,
    Texture3D<float4> tTextureMap0,
    Texture3D<float4> tTextureMap1,
    Texture3D<float4> tTextureMap2,
    SamplerState TrilinearClamp,
    inout float _1802,
    inout float _1803,
    inout float _1804) {
  if (_365 && (bool)((cPassEnabled & 4) != 0)) {
    float3 correctedColor = ApplyColorGradingLUTs(
        float3(_1573, _1574, _1575),
        fTextureBlendRate,
        fTextureBlendRate2,
        fOneMinusTextureInverseSize,
        fHalfTextureInverseSize,
        tTextureMap0,
        tTextureMap1,
        tTextureMap2,
        TrilinearClamp);

    _1802 = mad(correctedColor.z, (fColorMatrix[2].x), mad(correctedColor.y, (fColorMatrix[1].x), (correctedColor.x * (fColorMatrix[0].x)))) + (fColorMatrix[3].x);
    _1803 = mad(correctedColor.z, (fColorMatrix[2].y), mad(correctedColor.y, (fColorMatrix[1].y), (correctedColor.x * (fColorMatrix[0].y)))) + (fColorMatrix[3].y);
    _1804 = mad(correctedColor.z, (fColorMatrix[2].z), mad(correctedColor.y, (fColorMatrix[1].z), (correctedColor.x * (fColorMatrix[0].z)))) + (fColorMatrix[3].z);
  } else {
    _1802 = _1573;
    _1803 = _1574;
    _1804 = _1575;
  }
}
