#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jan 16 00:58:53 2026

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float4 offsets[16];
    float weights[16];
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

  r0.xyzw = float4(0,0,0,0);
  r1.x = 0;
  while (true) {
    r1.y = cmp((int)r1.x >= 15);
    if (r1.y != 0) break;
    r1.yz = g_data.offsets[r1.x].xy + v1.xy;
    r2.xyzw = g_source_texture.Sample(g_source_sampler_s, r1.yz).xyzw;
    r0.xyzw = g_data.weights[r1.x] * r2.xyzw + r0.xyzw;
    r1.x = (int)r1.x + 1;
  }
  o0.xyzw = r0.xyzw;

  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.xyz = ToneMapMaxCLL(o0.xyz);
  o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  
  return;
}