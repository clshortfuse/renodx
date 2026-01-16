#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jan 16 00:58:53 2026

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float4 weights;
    float4 offsets;
  } g_data : packoffset(c0);

}

SamplerState g_source_sampler_s : register(s0);
Texture2D<float4> g_source_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_data.offsets.xzxw + v1.xyxy;
  r1.xyzw = g_source_texture.Sample(g_source_sampler_s, r0.zw).xyzw;
  r0.xyzw = g_source_texture.Sample(g_source_sampler_s, r0.xy).xyzw;

  // r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  // r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  // r1.xyz = ToneMapMaxCLL(r1.xyz);
  // r0.xyz = ToneMapMaxCLL(r0.xyz);
  // r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  // r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);

  r1.xyzw = g_data.weights.yyyy * r1.xyzw;
  r0.xyzw = g_data.weights.xxxx * r0.xyzw + r1.xyzw;
  r1.xyzw = g_data.offsets.yzyw + v1.xyxy;
  r2.xyzw = g_source_texture.Sample(g_source_sampler_s, r1.xy).xyzw;
  r1.xyzw = g_source_texture.Sample(g_source_sampler_s, r1.zw).xyzw;

  // r2.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  // r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  // r2.xyz = ToneMapMaxCLL(r2.xyz);
  // r1.xyz = ToneMapMaxCLL(r1.xyz);
  // r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
  // r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);

  r0.xyzw = g_data.weights.zzzz * r2.xyzw + r0.xyzw;
  o0.xyzw = g_data.weights.wwww * r1.xyzw + r0.xyzw;

  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.xyz = ToneMapMaxCLL(o0.xyz);
  o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);

  return;
}