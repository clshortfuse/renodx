#include "../common.hlsli"

float3 ApplyCapcomExponentialToneMap(
    float3 color,
    float curve_contrast,
    float linear_begin,
    float curve_toe,
    float max_nit,
    float linear_start,
    float display_max_nit_sub_contrast_factor,
    float contrast_factor,
    float mul_linear_start_contrast_factor,
    float inverse_linear_begin,
    float mad_linear_start_contrast_factor,
    float is_hdr_mode) {
  bool match_sdr = TONE_MAP_TYPE == 3.f;

  // Vanilla follows the game's output mode; Match SDR always applies the curve.
  [branch]
  if (!match_sdr
      && (TONE_MAP_TYPE != 0.f || is_hdr_mode != 0.f)) {
    return color;
  }

  float3 t = color * inverse_linear_begin;  // color / linear_begin
  float3 toe_smooth = smoothstep(0.f, linear_begin, color);
  float3 linear_value = mad(curve_contrast, color, mad_linear_start_contrast_factor);

  [branch]
  if (match_sdr) {
    return lerp(t * linear_begin, linear_value, toe_smooth);
  }

  float3 toe_value = pow(t, curve_toe) * linear_begin;
  float3 shoulder_weight = select(color < linear_start, 0.f, 1.f);
  float3 shoulder_value = max_nit
                          - exp2(mad(contrast_factor, color, mul_linear_start_contrast_factor))
                                * display_max_nit_sub_contrast_factor;

  float3 toe_linear_value = lerp(toe_value, linear_value, toe_smooth);
  return mad(shoulder_weight, shoulder_value - linear_value, toe_linear_value);
}

void ApplyCapcomExponentialToneMap(
    float in_r,
    float in_g,
    float in_b,
    out float out_r,
    out float out_g,
    out float out_b,
    float curve_contrast,
    float linear_begin,
    float curve_toe,
    float max_nit,
    float linear_start,
    float display_max_nit_sub_contrast_factor,
    float contrast_factor,
    float mul_linear_start_contrast_factor,
    float inverse_linear_begin,
    float mad_linear_start_contrast_factor,
    float is_hdr_mode) {
  float3 color = ApplyCapcomExponentialToneMap(
      float3(in_r, in_g, in_b),
      curve_contrast,
      linear_begin,
      curve_toe,
      max_nit,
      linear_start,
      display_max_nit_sub_contrast_factor,
      contrast_factor,
      mul_linear_start_contrast_factor,
      inverse_linear_begin,
      mad_linear_start_contrast_factor,
      is_hdr_mode);
  out_r = color.r;
  out_g = color.g;
  out_b = color.b;
}

float3 NormalizeBlackFloor(float3 graded, float3 source, float3 lut_black) {
  // Separate the common neutral floor from the LUT's residual black tint.
  const float black_floor = max(renodx::math::Min(lut_black), 0.f);
  const float3 neutral_floor = black_floor;
  const float3 black_tint = lut_black - neutral_floor;
  // Smooth energy weighting localizes removal without per-pixel channel-winner seams.
  const float floor_energy = dot(neutral_floor, neutral_floor);
  const float floor_weight = renodx::math::DivideSafe(
      floor_energy,
      floor_energy + dot(source, source) + dot(black_tint, black_tint),
      0.f);
  // Bound one scalar removal to shared lift, preserving RGB differences and staying above source.
  const float common_lift = max(renodx::math::Min(graded - source), 0.f);
  const float floor_remove = min(black_floor * floor_weight, common_lift);

  return graded - floor_remove;
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
  float3 lutCoordinates = mad(lutEncoded, lutScale, lutOffset);
  float3 correctedColor = renodx::color::acescct::Decode(
      tTextureMap0.SampleLevel(TrilinearClamp, lutCoordinates, 0.f).rgb);

  [branch]
  if (fTextureBlendRate > 0.0f) {
    float3 blendColor = renodx::color::acescct::Decode(
        tTextureMap1.SampleLevel(TrilinearClamp, lutCoordinates, 0.f).rgb);
    correctedColor = lerp(correctedColor, blendColor, fTextureBlendRate);
  }

  [branch]
  if (fTextureBlendRate2 > 0.0f) {
    float3 lutEncoded2 = renodx::color::acescct::Encode(correctedColor);
    float3 blendColor2 = renodx::color::acescct::Decode(
        tTextureMap2.SampleLevel(TrilinearClamp, mad(lutEncoded2, lutScale, lutOffset), 0.f).rgb);
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

  [branch]
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
      const float3 color_scaled = NormalizeBlackFloor(color_output, color_input, lut_black);
      color_output = lerp(color_output, color_scaled, COLOR_GRADE_LUT_SCALING);
    }
  }

  return max(0, color_output);
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
  [branch]
  if (!enabled) {
    _1802 = _1573;
    _1803 = _1574;
    _1804 = _1575;
    return;
  }

  const float3 input = float3(_1573, _1574, _1575);
  float3 correctedColor = input;
  [branch]
  if (COLOR_GRADE_LUT_STRENGTH != 0.f) {
    correctedColor = lerp(
        input,
        ApplyColorGradingLUTs(
            input,
            fTextureBlendRate,
            fTextureBlendRate2,
            fTextureSize,
            fOneMinusTextureInverseSize,
            fHalfTextureInverseSize,
            tTextureMap0,
            tTextureMap1,
            tTextureMap2,
            TrilinearClamp),
        COLOR_GRADE_LUT_STRENGTH);
  }

  const float3 transformedColor = mul(float4(correctedColor, 1.f), fColorMatrix).rgb;
  _1802 = transformedColor.r;
  _1803 = transformedColor.g;
  _1804 = transformedColor.b;
}
