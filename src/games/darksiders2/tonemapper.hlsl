#include "./common.hlsl"

cbuffer $Globals : register(b0) {
  float pMinToneMapMult : packoffset(c000.x);
  float pMaxToneMapMult : packoffset(c000.y);
  float pMiddleGray : packoffset(c000.z);
  float pBloomScale : packoffset(c000.w);
  float4 pToneMapValues1 : packoffset(c001.x);
  float4 pToneMapValues2 : packoffset(c002.x);
};

float VanillaTonemapper1(float color) {
  float _44 = color * 0.30000001192092896f;
  return pToneMapValues2.w * exp2(log2((((color * 0.753000020980835f) + 0.029999999329447746f) * _44) / ((((color * 0.7290000319480896f) + 0.5899999737739563f) * _44) + 0.14000000059604645f)) * 0.6666666865348816f);
}

float3 VanillaTonemapper1(float3 color) {
    return float3(
        VanillaTonemapper1(color.r),
        VanillaTonemapper1(color.g),
        VanillaTonemapper1(color.b)
    );
}

float3 CustomTonemap1(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE == 0) {
    return saturate(VanillaTonemapper1(untonemapped));
  }
  // return untonemapped;
  // untonemapped = min(0.f, untonemapped);
  // untonemapped = saturate(untonemapped);

  float3 untonemapped_linear = renodx::color::gamma::DecodeSafe(untonemapped);
  untonemapped_linear = PreTonemapSliders(untonemapped_linear);
  untonemapped = renodx::color::gamma::EncodeSafe(untonemapped_linear);

  float mid_gray = 0.18f;
  float mid_gray_tonemapped = VanillaTonemapper1(mid_gray);
  float mid_gray_scale = mid_gray_tonemapped / mid_gray;
  float3 untonemapped_midgray_scaled = untonemapped * mid_gray_scale;
  float3 untonemapped_migray_scaled_linear = renodx::color::gamma::DecodeSafe(untonemapped_midgray_scaled);

  float untonemapped_y = renodx::color::y::from::BT709(untonemapped);
  float tonemapped_bt709_y = VanillaTonemapper1(untonemapped_y);
  float3 tonemapped_bt709_lum = renodx::color::correct::Luminance(untonemapped, untonemapped_y, tonemapped_bt709_y);
  float3 tonemapped_bt709_ch = VanillaTonemapper1(untonemapped);
  
  float3 tonemapped_bt709_lum_linear = renodx::color::gamma::DecodeSafe(tonemapped_bt709_lum);
  float3 tonemapped_bt709_ch_linear = renodx::color::gamma::DecodeSafe(tonemapped_bt709_ch);
  float tonemapped_bt709_y_linear = renodx::color::gamma::DecodeSafe(tonemapped_bt709_y);

  // float tonemapper_strength = SCENE_GRADE_SHADOW_STRENGTH;
  // if (tonemapped_bt709_y > mid_gray_tonemapped) tonemapper_strength = SCENE_GRADE_HIGHLIGHT_STRENGTH;
  // tonemapped_bt709_lum_linear = lerp(tonemapped_bt709_lum_linear, untonemapped_migray_scaled_linear, saturate(tonemapper_strength));

  float3 hdr_color = lerp(tonemapped_bt709_lum_linear, untonemapped_migray_scaled_linear, saturate(tonemapped_bt709_y_linear));
  hdr_color = renodx::color::correct::Chrominance(hdr_color, tonemapped_bt709_ch_linear, 1.f, 1.f);
  hdr_color = renodx::color::correct::Hue(hdr_color, tonemapped_bt709_ch_linear, RENODX_TONE_MAP_HUE_CORRECTION, 1);

  return renodx::color::gamma::EncodeSafe(hdr_color);
}