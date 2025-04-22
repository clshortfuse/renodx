#include "./include/CBuffer_CGlobalShaderParameterProvider.hlsl"
#include "./include/CBuffer_CPostFxHDRBloomEffectsParameterProvider.hlsl"
#include "./shared.h"

float3 BT709ToRRTSAT(float3 color_bt709) {
  // sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
  const float3x3 ACESInputMat = {
    { 0.59719, 0.35458, 0.04823 },
    { 0.07600, 0.90834, 0.01566 },
    { 0.02840, 0.13383, 0.83777 }
  };

  float3 rrt_sat = mul(ACESInputMat, color_bt709);
  return rrt_sat;
}

float3 ODTSATToBT709(float3 color_odt_sat) {
  // ODT_SAT => XYZ => D60_2_D65 => sRGB
  const float3x3 ACESOutputMat = {
    { 1.60475, -0.53108, -0.07367 },
    { -0.10208, 1.10813, -0.00605 },
    { -0.00327, -0.07276, 1.07602 }
  };
  float3 color_bt709 = mul(ACESOutputMat, color_odt_sat);
  return color_bt709;
}

/// Log encode a float3 color for LUT sampling
/// Applies: log2(x) * (1/17) + 0.527878284
float3 LogEncodeLUT(float3 color) {
  return log2(color) * 0.0588235296 + 0.527878284;
}

/// Inverse log encoding for LUT values
/// Applies: exp2((x - 0.527878284) / (1/17))
float3 LogDecodeLUT(float3 encoded) {
  return exp2(encoded * 17 - 8.97393131);
}

float3 LUTCorrectBlack(float3 lut_input_color_bt709, float3 lut_output_color_ap1, Texture3D<float4> ColorRemap0VolumeSampler, SamplerState Clamp_s) {
  if (RENODX_COLOR_GRADE_SCALING) {
    float3 min_black = LogDecodeLUT(ColorRemap0VolumeSampler.SampleLevel(Clamp_s, LogEncodeLUT((0.f).xxx) + (0.5f / 32.f), 0.0f).rgb);

    float lut_min_y = (renodx::color::y::from::AP1(max(0, min_black)));
    if (RENODX_GAMMA_CORRECTION) lut_min_y = renodx::color::correct::Gamma(lut_min_y);
    if (lut_min_y > 0) {
      float3 lut_output_color_bt709 = renodx::color::bt709::from::AP1(lut_output_color_ap1);

      float3 corrected_black = renodx::lut::CorrectBlack(max(0, lut_input_color_bt709), max(0, lut_output_color_bt709), lut_min_y, 1.f);
      float3 corrected_black_rrtsat = renodx::color::ap1::from::BT709(corrected_black);

      lut_output_color_ap1 = lerp(lut_output_color_ap1, corrected_black_rrtsat, RENODX_COLOR_GRADE_SCALING);
    }
  }

  return lut_output_color_ap1;
}

float3 ApplyVanillaGammaCorrection(float3 log_encoded_color) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 r0 = log_encoded_color;
    r0.xyz = HDRTVContrast.xxx * r0.xyz + HDRTVContrast.yyy;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(1, 1, 1) + r0.xyz;
    r0.xyz = rcp(r0.xyz);
    r0.xyz = r0.xyz * HDRTVContrast.zzz + HDRTVContrast.www;
    return r0;
  } else {
    return log_encoded_color;
  }
}

float3 ApplyUserColorGrading(float3 ungraded_ap1) {
  return renodx::color::ap1::from::BT709(
      renodx::color::grade::UserColorGrading(
          renodx::color::bt709::from::AP1(ungraded_ap1),
          RENODX_TONE_MAP_EXPOSURE,
          RENODX_TONE_MAP_HIGHLIGHTS,
          RENODX_TONE_MAP_SHADOWS,
          RENODX_TONE_MAP_CONTRAST,
          RENODX_TONE_MAP_SATURATION,
          RENODX_TONE_MAP_BLOWOUT,
          0.f));
}

float3 ApplyVanillaToneMap(float3 untonemapped_ap1) {
  float4 r0;
  float3 r1, r2;

  r0.rgb = untonemapped_ap1;

  r0.xyz = HDRTVExposureAdjustment * r0.xyz;
  r0.w = 89.6254959 * HDRReferenceWhiteNits;
  r1.x = HDRReferenceWhiteNits * 0.152480766 + -0.103982367;
  r1.y = -HDRReferenceWhiteNits * 0.0260881726 + 93.2124939;
  r0.xyz = log2(abs(r0.xyz));
  r2.xyz = float3(1.32000005, 1.32000005, 1.32000005) * r0.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * r0.www;
  r0.xyz = float3(1.02960002, 1.02960002, 1.02960002) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * r1.xxx + r1.yyy;
  r0.xyz = r2.xyz / r0.xyz;

  return r0.rgb;
}

float3 SaturationAP1(float3 color_ap1, float saturation, float blowout = 0.f) {
  float3 color_bt709 = renodx::color::bt709::from::AP1(max(0, color_ap1));

  color_bt709 = renodx::color::grade::UserColorGrading(
      color_bt709,
      1.f,  // exposure
      1.f,  // highlights
      1.f,  // shadows
      1.f,  // contrast
      saturation,
      blowout,
      0.f);

  return renodx::color::ap1::from::BT709(color_bt709);
}

float3 HueCorrectAP1(float3 incorrect_color_ap1, float3 correct_color_ap1, float hue_correct_strength = 0.5f) {
  float3 incorrect_color_bt709 = renodx::color::bt709::from::AP1(incorrect_color_ap1);
  float3 correct_color_bt709 = renodx::color::bt709::from::AP1(correct_color_ap1);

  float3 corrected_color_bt709 = renodx::color::correct::Hue(incorrect_color_bt709, correct_color_bt709, hue_correct_strength, 2u);
  float3 corrected_color_ap1 = renodx::color::ap1::from::BT709(corrected_color_bt709);
  return corrected_color_ap1;
}

float3 TonemapByLuminance(float3 untonemapped_ap1) {
  float y = renodx::color::y::from::AP1(untonemapped_ap1);
  float num = y * (y + 0.0206166003f);
  // num -= 7.45694997e-05f; // remove black clip
  float denom = y * (0.983796f * y + 0.433679014f) + 0.246179f;
  float y_mapped = num / denom;
  float scale = y > 0 ? y_mapped / y : 0;
  float3 tonemapped_ap1 = untonemapped_ap1 * scale;

  tonemapped_ap1 = max(0, SaturationAP1(tonemapped_ap1, 22.f, .99f)); // increase saturation in midtones and shadows

  float blend_brightness_ratio = 0.613478879269;
  float tonemapped_y = renodx::color::y::from::AP1(tonemapped_ap1);
  tonemapped_ap1 = lerp(tonemapped_ap1, untonemapped_ap1 * blend_brightness_ratio, saturate(tonemapped_y));
  tonemapped_ap1 = ApplyUserColorGrading(tonemapped_ap1);

  float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION) peak_nits = renodx::color::correct::GammaSafe(peak_nits, true);
  tonemapped_ap1 = renodx::tonemap::ExponentialRollOff(tonemapped_ap1, 0.1f, peak_nits);

  return tonemapped_ap1;
}

float3 TonemapByChannel(float3 untonemapped_ap1) {
  float3 x = max(0, untonemapped_ap1);

  float3 num = x * (x + 0.0206166003f);
  // num -= 7.45694997e-05f; // remove black clip
  float3 denom = x * (0.983796f * x + 0.433679014f) + 0.246179f;
  float3 tonemapped = num / denom;
  tonemapped = max(0, HueCorrectAP1(tonemapped, untonemapped_ap1));

  float blend_brightness_ratio = 0.613478879269;
  tonemapped = lerp(tonemapped, untonemapped_ap1 * blend_brightness_ratio, saturate(tonemapped));
  tonemapped = ApplyUserColorGrading(tonemapped);

  tonemapped = renodx::tonemap::ExponentialRollOff(tonemapped, 0.f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  return tonemapped;
}

float3 ApplyUserToneMap(float3 untonemapped_ap1) {
  float3 tonemapped_ap1;
  if (RENODX_TONE_MAP_TYPE == 2.f) {  // Vanilla+
    tonemapped_ap1 = TonemapByLuminance(untonemapped_ap1);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    tonemapped_ap1 = ApplyUserColorGrading(untonemapped_ap1);
  } else {  // Vanilla
    return ApplyVanillaToneMap(untonemapped_ap1);
  }

  if (RENODX_GAMMA_CORRECTION) {
    float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
    tonemapped_ap1 = renodx::color::ap1::from::BT709(tonemapped_bt709);
  }

  tonemapped_ap1 *= RENODX_DIFFUSE_WHITE_NITS;
  return tonemapped_ap1;
}

float3 ApplyUserDisplayMap(float3 untonemapped_ap1) {
  float3 display_mapped_ap1;
  if (RENODX_TONE_MAP_TYPE == 2.f) {
    untonemapped_ap1 = ApplyUserColorGrading(untonemapped_ap1);
    float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION) peak_nits = renodx::color::correct::GammaSafe(peak_nits, true);
    display_mapped_ap1 = renodx::tonemap::ExponentialRollOff(untonemapped_ap1, 0.1f, peak_nits);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {  // None
    display_mapped_ap1 = ApplyUserColorGrading(untonemapped_ap1);
  } else {  // Vanilla
    return untonemapped_ap1 * HDRTVExposureAdjustment;
  }

  if (RENODX_GAMMA_CORRECTION) {
    float3 display_mapped_bt709 = renodx::color::bt709::from::AP1(display_mapped_ap1);
    display_mapped_bt709 = renodx::color::correct::GammaSafe(display_mapped_bt709);
    display_mapped_ap1 = renodx::color::ap1::from::BT709(display_mapped_bt709);
  }

  display_mapped_ap1 *= RENODX_DIFFUSE_WHITE_NITS;
  return display_mapped_ap1;
}
