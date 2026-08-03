#include "../common.hlsli"

#ifndef CALLISTO_LUT_COUNT
#define CALLISTO_LUT_COUNT 0
#endif

#ifndef CALLISTO_LUT_EXPLICIT_LOD
#define CALLISTO_LUT_EXPLICIT_LOD 0
#endif

// Reconstructed from the decompiled per-channel arithmetic. The master and
// tonal-band values are combined exactly where the original shader uses them.
float3 ApplyColorGradeBand(
    float luma,
    float3 chroma,
    float4 color_saturation,
    float4 color_contrast,
    float4 color_gamma,
    float4 color_gain,
    float4 color_offset,
    float4 color_saturation_tonal_range,
    float4 color_contrast_tonal_range,
    float4 color_gamma_tonal_range,
    float4 color_gain_tonal_range,
    float4 color_offset_tonal_range) {
  float4 saturation = color_saturation * color_saturation_tonal_range;
  float4 contrast = color_contrast * color_contrast_tonal_range;
  float4 gamma = color_gamma * color_gamma_tonal_range;
  float4 gain = color_gain * color_gain_tonal_range;

  float3 corrected = max(mad(chroma, saturation.xyz * saturation.w, luma.xxx), 0.f);
  corrected = pow(corrected * (1.f / 0.18f), contrast.xyz * contrast.w) * 0.18f;
  corrected = pow(corrected, 1.f / (gamma.xyz * gamma.w));
  corrected = mad(
      corrected,
      gain.xyz * gain.w,
      (color_offset.xyz + color_offset_tonal_range.xyz) + (color_offset.w + color_offset_tonal_range.w));
  return corrected;
}

float3 ColorCorrectAll(float3 ungraded, const uint4 cb0_m[70]) {
  float luma = renodx::color::y::from::AP1(ungraded);
  float3 chroma = ungraded - luma;

  float4 color_saturation = asfloat(cb0_m[48]);
  float4 color_contrast = asfloat(cb0_m[49]);
  float4 color_gamma = asfloat(cb0_m[50]);
  float4 color_gain = asfloat(cb0_m[51]);
  float4 color_offset = asfloat(cb0_m[52]);

  float4 color_saturation_shadows = asfloat(cb0_m[53]);
  float4 color_contrast_shadows = asfloat(cb0_m[54]);
  float4 color_gamma_shadows = asfloat(cb0_m[55]);
  float4 color_gain_shadows = asfloat(cb0_m[56]);
  float4 color_offset_shadows = asfloat(cb0_m[57]);

  float4 color_saturation_midtones = asfloat(cb0_m[58]);
  float4 color_contrast_midtones = asfloat(cb0_m[59]);
  float4 color_gamma_midtones = asfloat(cb0_m[60]);
  float4 color_gain_midtones = asfloat(cb0_m[61]);
  float4 color_offset_midtones = asfloat(cb0_m[62]);

  float4 color_saturation_highlights = asfloat(cb0_m[63]);
  float4 color_contrast_highlights = asfloat(cb0_m[64]);
  float4 color_gamma_highlights = asfloat(cb0_m[65]);
  float4 color_gain_highlights = asfloat(cb0_m[66]);
  float4 color_offset_highlights = asfloat(cb0_m[67]);

  float color_correction_shadows_max = asfloat(cb0_m[68].x);
  float color_correction_highlights_min = asfloat(cb0_m[68].y);

  float shadow_position = saturate(luma / color_correction_shadows_max);
  float shadow_weight = 1.f - shadow_position * shadow_position * mad(shadow_position, -2.f, 3.f);

  float highlight_position = saturate(
      (luma - color_correction_highlights_min) / (1.f - color_correction_highlights_min));
  float highlight_weight = highlight_position * highlight_position * mad(highlight_position, -2.f, 3.f);
  float midtone_weight = 1.f - shadow_weight - highlight_weight;

  float3 shadows = ApplyColorGradeBand(
      luma,
      chroma,
      color_saturation,
      color_contrast,
      color_gamma,
      color_gain,
      color_offset,
      color_saturation_shadows,
      color_contrast_shadows,
      color_gamma_shadows,
      color_gain_shadows,
      color_offset_shadows);
  float3 midtones = ApplyColorGradeBand(
      luma,
      chroma,
      color_saturation,
      color_contrast,
      color_gamma,
      color_gain,
      color_offset,
      color_saturation_midtones,
      color_contrast_midtones,
      color_gamma_midtones,
      color_gain_midtones,
      color_offset_midtones);
  float3 highlights = ApplyColorGradeBand(
      luma,
      chroma,
      color_saturation,
      color_contrast,
      color_gamma,
      color_gain,
      color_offset,
      color_saturation_highlights,
      color_contrast_highlights,
      color_gamma_highlights,
      color_gain_highlights,
      color_offset_highlights);

  float3 graded = shadows * shadow_weight
                  + midtones * midtone_weight
                  + highlights * highlight_weight;
  return lerp(ungraded, graded, RENODX_COLOR_GRADE_STRENGTH);
}

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

static const float3x3 CALLISTO_AP1_TO_BT2020_MAT = float3x3(
    1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f,
    -0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f,
    -0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f);

static const float3x3 CALLISTO_BT2020_TO_AP1_MAT = float3x3(
    0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f,
    0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f,
    0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f);

#if CALLISTO_LUT_COUNT >= 1
float3 SamplePackedLUT(
    Texture2D<float4> lut_texture,
    SamplerState lut_sampler,
    float2 lower_uv,
    float2 upper_uv,
    float blue_fraction) {
#if CALLISTO_LUT_EXPLICIT_LOD
  float3 lower = lut_texture.SampleLevel(lut_sampler, lower_uv, 0.f).rgb;
  float3 upper = lut_texture.SampleLevel(lut_sampler, upper_uv, 0.f).rgb;
#else
  float3 lower = lut_texture.Sample(lut_sampler, lower_uv).rgb;
  float3 upper = lut_texture.Sample(lut_sampler, upper_uv).rgb;
#endif
  return lerp(lower, upper, blue_fraction);
}
#endif

float3 SampleColorGradingLUTs(
    float3 color_bt2020,
    float3 lut_weights
#if CALLISTO_LUT_COUNT >= 1
    ,
    Texture2D<float4> lut_1, SamplerState sampler_1
#endif
#if CALLISTO_LUT_COUNT >= 2
    ,
    Texture2D<float4> lut_2, SamplerState sampler_2
#endif
) {
  float3 blended_bt2020 = color_bt2020 * lut_weights.x;

#if CALLISTO_LUT_COUNT >= 1
  static const float LUT_SIZE = 64.f;
  float3 encoded = renodx::color::pq::Encode(color_bt2020, 100.f);
  float3 lut_coordinates = mad(saturate(encoded), (LUT_SIZE - 1.f) / LUT_SIZE, 0.5f / LUT_SIZE);
  float blue_position = mad(lut_coordinates.b, LUT_SIZE, -0.5f);
  float blue_slice = floor(blue_position);
  float blue_fraction = blue_position - blue_slice;
  float2 lower_uv = float2((blue_slice + lut_coordinates.r) / LUT_SIZE, lut_coordinates.g);
  float2 upper_uv = lower_uv + float2(1.f / LUT_SIZE, 0.f);

  blended_bt2020 += SamplePackedLUT(lut_1, sampler_1, lower_uv, upper_uv, blue_fraction) * lut_weights.y;
#endif
#if CALLISTO_LUT_COUNT >= 2
  blended_bt2020 += SamplePackedLUT(lut_2, sampler_2, lower_uv, upper_uv, blue_fraction) * lut_weights.z;
#endif

  return blended_bt2020;
}

float3 ApplyColorGradingLUTs(
    float3 color_ap1,
    float3 lut_weights
#if CALLISTO_LUT_COUNT >= 1
    ,
    Texture2D<float4> lut_1, SamplerState sampler_1
#endif
#if CALLISTO_LUT_COUNT >= 2
    ,
    Texture2D<float4> lut_2, SamplerState sampler_2
#endif
) {
  float3 color_bt2020 = max(mul(CALLISTO_AP1_TO_BT2020_MAT, color_ap1), 0.f);
  float3 graded_bt2020 = SampleColorGradingLUTs(
      color_bt2020,
      lut_weights
#if CALLISTO_LUT_COUNT >= 1
      ,
      lut_1, sampler_1
#endif
#if CALLISTO_LUT_COUNT >= 2
      ,
      lut_2, sampler_2
#endif
  );

  if (RENODX_COLOR_GRADE_SCALING != 0.f) {
    float3 lut_black = SampleColorGradingLUTs(
        0.f,
        lut_weights
#if CALLISTO_LUT_COUNT >= 1
        ,
        lut_1, sampler_1
#endif
#if CALLISTO_LUT_COUNT >= 2
        ,
        lut_2, sampler_2
#endif
    );

    float lut_black_yf = renodx::color::yf::from::BT2020(lut_black);
    if (lut_black_yf > 0.f) {
      float3 lut_mid = SampleColorGradingLUTs(
          max(lut_black_yf, 0.0035f),
          lut_weights
#if CALLISTO_LUT_COUNT >= 1
          ,
          lut_1, sampler_1
#endif
#if CALLISTO_LUT_COUNT >= 2
          ,
          lut_2, sampler_2
#endif
      );

      float3 unclamped_gamma = Unclamp(
          sqrt(max(graded_bt2020, 0.f)),
          sqrt(max(lut_black, 0.f)),
          sqrt(max(lut_mid, 0.f)),
          sqrt(color_bt2020));
      float3 unclamped_bt2020 = unclamped_gamma * unclamped_gamma;

      graded_bt2020 = renodx::color::bt2020::from::BT709(
          renodx::lut::RecolorUnclamped(
              renodx::color::bt709::from::BT2020(graded_bt2020),
              renodx::color::bt709::from::BT2020(unclamped_bt2020),
              RENODX_COLOR_GRADE_SCALING));
    }
  }

  float3 output_ap1 = max(mul(CALLISTO_BT2020_TO_AP1_MAT, graded_bt2020), 0.f);

  return lerp(color_ap1, output_ap1, RENODX_COLOR_GRADE_STRENGTH);
}

float3 ApplyAnchoredAdaptationContrast(
    float3 color,
    float contrast,
    float3 anchor_in = 0.18f,
    float3 anchor_out = 0.18f,
    float flare = 0.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  float3 ax = max(0, color);
  float3 normalized = ax / anchor_in;
  float3 flare_ratio = renodx::math::DivideSafe(normalized + flare, normalized, 1.f);
  float3 exponent = contrast * flare_ratio;

  float3 ax_n = pow(ax, exponent);
  float3 s_n = pow(anchor_in, exponent);
  float3 response_target = ax_n / (ax_n + s_n);
  float3 response_baseline = ax / (ax + anchor_in);
  float3 gain = renodx::math::DivideSafe(response_target, response_baseline, 0.f);

  float3 contrasted_normalized = ax * gain / anchor_in;

  if (highlights != 1.f) {
    float3 highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    contrasted_normalized += highlight_distance * (pow(1.f + highlight_distance * highlight_distance, (highlights - 1.f) / 2.f) - 1.f);
  }

  if (shadows != 1.f) {
    float3 shadow_distance = max(1.f - contrasted_normalized, 0.f);
    contrasted_normalized *= pow(1.f + shadow_distance * shadow_distance * shadow_distance, shadows - 1.f);
  }

  return (contrasted_normalized * anchor_out);
}

// GT/Uchimura without its asymptotic shoulder. The original toe is preserved,
// while the middle linear segment continues indefinitely with slope `a`.
#define GT_TONEMAP_UNCAPPED_GENERATOR(T)                           \
  T GTTonemapUncapped(T x,                                         \
                      float a = 1.f,                               \
                      float m = 0.22f,                             \
                      float c = 1.33f,                             \
                      float b = 0.f) {                             \
    T toe_weight = 1.f - smoothstep(0.f, m, x);                    \
    T toe = m * pow(x / m, c) + b;                                 \
    T linear_segment = m + a * (x - m);                            \
    return toe * toe_weight + linear_segment * (1.f - toe_weight); \
  }

GT_TONEMAP_UNCAPPED_GENERATOR(float)
GT_TONEMAP_UNCAPPED_GENERATOR(float3)
#undef GT_TONEMAP_UNCAPPED_GENERATOR

float3 ApplyGTToneMap(float3 untonemapped, float P, float a, float m, float l, float c) {
  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {  // Vanilla
    tonemapped = renodx::tonemap::GTTonemap(untonemapped, P, a, m, l, c);
  } else {  // Vanilla+
    tonemapped = GTTonemapUncapped(untonemapped, a, m, c);
    tonemapped = ApplyAnchoredAdaptationContrast(tonemapped, RENODX_TONE_MAP_CONTRAST, 0.18f, 0.18f, RENODX_TONE_MAP_FLARE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS);
    tonemapped = renodx::color::bt709::clamp::BT2020(tonemapped);
  }

  return tonemapped;
}
