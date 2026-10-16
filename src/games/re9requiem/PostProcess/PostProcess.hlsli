#include "../common.hlsli"

// very slightly different from actual acescc encode
float3 EncodeColorCorrectLutValue(float3 value) {
  return ((log2(select((value < 3.0517578125e-05f), ((value * 0.5f) + 1.52587890625e-05f), value)) * 0.05707760155200958f) + 0.5547950267791748f);
  // return renodx::color::acescc::Encode(value);
}

float3 DecodeColorCorrectLutValue(float3 value) {
  // return renodx::color::acescc::Decode(value);
  return max(exp2((value * 17.520000457763672f) + -9.720000267028809f), 0.0f);
}

float3 SampleColorCorrectLut(
    Texture3D<float4> textureMap,
    SamplerState trilinearClamp,
    float3 lutEncoded,
    float fTextureSize,
    float lutScale,
    float lutOffset) {
  return textureMap.SampleLevel(trilinearClamp, lutEncoded * lutScale + lutOffset, 0.0f).rgb;
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
  float3 lutEncoded = EncodeColorCorrectLutValue(color_input);
  float3 correctedColor = DecodeColorCorrectLutValue(
      SampleColorCorrectLut(
          tTextureMap0,
          TrilinearClamp,
          lutEncoded,
          fTextureSize,
          lutScale,
          lutOffset));

  if (fTextureBlendRate > 0.0f) {
    float3 blendColor = DecodeColorCorrectLutValue(
        SampleColorCorrectLut(
            tTextureMap1,
            TrilinearClamp,
            lutEncoded,
            fTextureSize,
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
              fTextureSize,
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
            fTextureSize,
            lutScale,
            lutOffset));
    correctedColor = lerp(correctedColor, blendColor2, fTextureBlendRate2);
  }

  return correctedColor;
}

float3 CompensateGradingZeroInputOffset(
    float3 graded,
    float3 source,
    float3 grading_zero_output,
    float half_weight_stops = 1.f) {
  // Split the grading output at zero into a shared RGB offset and its unequal-channel residual.
  const float common_offset = max(renodx::math::Min(grading_zero_output), 0.f);
  const float3 channel_residual = grading_zero_output - common_offset;

  // Express the relative linear-light RMS source level in units of the chosen half-weight level.
  const float source_magnitude = sqrt(dot(source, source) / 3.f);
  const float source_to_common_offset = renodx::math::DivideSafe(source_magnitude, common_offset, 0.f);
  const float source_half_weight_units = source_to_common_offset * exp2(half_weight_stops);
  // Approximate exp2(-x), matching x = 0, 1, and 2 exactly at weights 1, 1/2, and 1/4.
  const float source_release_denominator = 1.f + 0.5f * source_half_weight_units * (1.f + source_half_weight_units);

  // Reduce compensation when the zero-input output contains unequal-channel structure; never subtract that residual.
  const float common_offset_squared_magnitude = 3.f * common_offset * common_offset;
  // Combine source release and the relative squared RGB residual weight into one division.
  const float compensation_weight = renodx::math::DivideSafe(
      common_offset_squared_magnitude,
      source_release_denominator
          * (common_offset_squared_magnitude + dot(channel_residual, channel_residual)),
      0.f);

  // Subtract one bounded scalar, preserving channel differences and keeping every channel at or above its source.
  const float removable_common_offset = max(renodx::math::Min(graded - source), 0.f);
  const float offset_compensation = min(common_offset * compensation_weight, removable_common_offset);

  return graded - offset_compensation;
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

    [branch]
    if (renodx::math::Min(lut_black) > 0.f) {
      const float3 color_scaled = CompensateGradingZeroInputOffset(color_output, color_input, lut_black, 1.f);
      color_output = lerp(color_output, color_scaled, COLOR_GRADE_LUT_SCALING);
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
    float fTextureSize,
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
