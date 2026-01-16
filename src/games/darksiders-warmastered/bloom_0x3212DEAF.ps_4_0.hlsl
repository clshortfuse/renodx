#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 14 15:05:00 2026

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float bloomScale;
    float middleGray;
    float minToneMapMult;
    float maxToneMapMult;
  } g_data : packoffset(c0);

}

SamplerState s0_sampler_s : register(s0);
SamplerState s1_sampler_s : register(s1);
SamplerState s2_sampler_s : register(s2);
Texture2D<float4> s0_texture : register(t0);
Texture2D<float4> s1_texture : register(t1);
Texture2D<float4> s2_texture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s2_texture.Sample(s2_sampler_s, float2(0.5, 0.5)).xyzw;
  //r0 = saturate(r0);
  r0.x = 0.00100000005 + r0.x;

  //r0.x = g_data.middleGray / r0.x;
  r0.x = renodx::math::SafeDivision(g_data.middleGray, r0.x);

  r0.x = max(g_data.minToneMapMult, r0.x);
  r0.x = min(g_data.maxToneMapMult, r0.x);
  r1.xyzw = s0_texture.Sample(s0_sampler_s, v1.xy).xyzw;

  // float3 linear_color = renodx::color::srgb::DecodeSafe(r1.xyz);
  // //float3 linear_color = r1.xyz;
  // float compression_scale;
  // GamutCompression(linear_color, compression_scale);
  // //r1.xyz = linear_color;
  // r1.xyz = renodx::color::srgb::EncodeSafe(linear_color);

  r1.xyz = r1.xyz * r0.xxx;
  r0.xyzw = s1_texture.Sample(s1_sampler_s, v1.xy).xyzw;
  //r0 = saturate(r0);
  //r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyzw = (g_data.bloomScale * CUSTOM_BLOOM) * r0.xyzw + r1.xyzw;

  // float3 linear_output = renodx::color::srgb::DecodeSafe(o0.xyz);
  // //float3 linear_output = o0.xyz;
  // GamutDecompression(linear_output, compression_scale);
  // // linear_output = renodx::color::correct::Hue(linear_output, linear_color, 0.75f, 0);
  // // o0.xyz = linear_output;
  // //linear_output = renodx::color::correct::Hue(linear_output, renodx::tonemap::ExponentialRollOff(linear_output, 0.75f, 2.f), 1.f);
  // o0.xyz = renodx::color::srgb::EncodeSafe(linear_output);
  return;
}