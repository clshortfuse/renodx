#include "./uncharted2extended.hlsli"
#include "./common.hlsl"

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

float Uncharted2Tonemap1(float color) {
  float _42;
  float _43;
  float _44;
  float _45;
  float _52;
  float _62;
  float _69;
  float _79;
  float _88;

  _42 = color * CustomPixelConsts_112.x;
  _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  return ((max(0.0f, (((((_42 + _45) * color) + _52) / (((_42 + CustomPixelConsts_112.y) * color) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);
}

float Uncharted2Tonemap2(float color) {
    float _120, _123, _130, _140, _147, _157, _166;

  _120 = color * CustomPixelConsts_176.x;
  _123 = CustomPixelConsts_176.z * CustomPixelConsts_176.y;
  _130 = CustomPixelConsts_192.x * CustomPixelConsts_192.y;
  _140 = CustomPixelConsts_192.x * CustomPixelConsts_192.z;
  _147 = CustomPixelConsts_192.y / CustomPixelConsts_192.z;
  _157 = CustomPixelConsts_176.x * 11.199999809265137f;
  _166 = max(0.0f, (((((_157 + _123) * 11.199999809265137f) + _130) / (((_157 + CustomPixelConsts_176.y) * 11.199999809265137f) + _140)) - _147));
  return (max(0.0f, (((((_120 + _123) * color) + _130) / (((_120 + CustomPixelConsts_176.y) * color) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;
}

float3 Uncharted2Tonemap1(float3 color) {
  float3 outputColor;
  outputColor.x = Uncharted2Tonemap1(color.x);
  outputColor.y = Uncharted2Tonemap1(color.y);
  outputColor.z = Uncharted2Tonemap1(color.z);
  return outputColor;
}

float3 Uncharted2Tonemap2(float3 color) {
  float3 outputColor;
  outputColor.x = Uncharted2Tonemap2(color.x);
  outputColor.y = Uncharted2Tonemap2(color.y);
  outputColor.z = Uncharted2Tonemap2(color.z);
  return outputColor;
}

float3 Uncharted2Extended1(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE < 2) {
    return Uncharted2Tonemap1(untonemapped);
  }

  float A = CustomPixelConsts_112.x, B = CustomPixelConsts_112.y, C = CustomPixelConsts_112.z, D = CustomPixelConsts_128.x, E = CustomPixelConsts_128.y, F = CustomPixelConsts_128.z;
  const float W = 11.199999809265137f;

  float coeffs[6] = { A, B, C, D, E, F };
  float white_precompute = CustomPixelConsts_256.y / renodx::tonemap::ApplyCurve(W, A, B, C, D, E, F);
  Uncharted2::Config::Uncharted2ExtendedConfig uc2_config = Uncharted2::Config::CreateUncharted2ExtendedConfig(coeffs, white_precompute);

  float3 outputColor = Uncharted2::ApplyExtended(untonemapped, uc2_config);

  return outputColor;
}

float3 Uncharted2Extended2(float3 untonemapped) {
  if (RENODX_TONE_MAP_TYPE < 2) {
    return Uncharted2Tonemap2(untonemapped);
  }

  float A = CustomPixelConsts_176.x, B = CustomPixelConsts_176.y, C = CustomPixelConsts_176.z, D = CustomPixelConsts_192.x, E = CustomPixelConsts_192.y, F = CustomPixelConsts_192.z;
  const float W = 11.199999809265137f;

  float coeffs[6] = { A, B, C, D, E, F };
  float white_precompute = CustomPixelConsts_272.y / renodx::tonemap::ApplyCurve(W, A, B, C, D, E, F);
  Uncharted2::Config::Uncharted2ExtendedConfig uc2_config = Uncharted2::Config::CreateUncharted2ExtendedConfig(coeffs, white_precompute);

  float3 outputColor = Uncharted2::ApplyExtended(untonemapped, uc2_config);

  return outputColor;
}

float3 CustomUpgradeToneMap(float3 untonemapped, float3 tonemapped_bt709_ch, float3 tonemapped_bt709_lum, float mid_gray, float max_value) {
  float3 outputColor;
  if (RENODX_TONE_MAP_TYPE == 1.f) return tonemapped_bt709_ch;
  // else if (RENODX_TONE_MAP_TYPE > 1) outputColor.w = max_value;
  // else outputColor.w = 1.f;

  float mid_gray_scale = mid_gray / 0.18f;
  float3 untonemapped_midgray = untonemapped * mid_gray_scale;
  float untonemapped_midgray_y = renodx::color::y::from::BT709(untonemapped_midgray);
  float tonemap_strength;

  if (untonemapped_midgray_y < mid_gray) tonemap_strength = CUSTOM_SCENE_GRADE_TOE_STRENGTH; 
  else tonemap_strength = CUSTOM_SCENE_GRADE_SHOULDER_STRENGTH;

  if (RENODX_TONE_MAP_TYPE == 0.f) return lerp(untonemapped_midgray, tonemapped_bt709_ch, tonemap_strength);

  float3 tonemapped_bt709 = lerp(tonemapped_bt709_ch, tonemapped_bt709_lum, CUSTOM_SCENE_GRADE_SATURATION_CORRECTION);
  
  tonemapped_bt709 = lerp(untonemapped_midgray, tonemapped_bt709, tonemap_strength);

  float untonemapped_y = renodx::color::y::from::BT709(untonemapped);
  float tonemapped_bt709_ch_y = renodx::color::y::from::BT709(tonemapped_bt709_ch);
  float tonemapped_bt709_lum_y = renodx::color::y::from::BT709(tonemapped_bt709_lum);
  float tonemapped_bt709_y = renodx::color::y::from::BT709(tonemapped_bt709);

  outputColor.xyz = tonemapped_bt709;
  float3 hdr_reference_color = outputColor.xyz;
  outputColor.xyz = renodx::color::correct::Chrominance(outputColor.xyz, lerp(tonemapped_bt709, tonemapped_bt709_ch, saturate(tonemapped_bt709_ch_y / mid_gray)), 1.f, 1.f, 1);
  
  outputColor.xyz = ApplyPerChannelBlowoutHueShift(outputColor.xyz, mid_gray, max_value);

  return outputColor;
}