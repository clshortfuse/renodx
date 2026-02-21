#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Jan 13 16:10:09 2026

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float Intensity;
    float Luminance;
  } g_data : packoffset(c0);

}

SamplerState Tex0_sampler_s : register(s0);
Texture2D<float4> Tex0_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = Tex0_texture.Sample(Tex0_sampler_s, v2.zw).xyzw;
  r1.xyzw = Tex0_texture.Sample(Tex0_sampler_s, v2.xy).xyzw;
  r1.xyz = float3(0.352941185,0.352941185,0.352941185) * r1.xyz;
  r2.xyzw = Tex0_texture.Sample(Tex0_sampler_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * float3(0.294117659,0.294117659,0.294117659) + r1.xyz;
  r0.xyz = r0.xyz * float3(0.352941185,0.352941185,0.352941185) + r1.xyz;
  r0.xyz = r2.xyz + -r0.xyz;
  r0.xyz = g_data.Intensity * r0.xyz;
  r0.x = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r0.x = max(-g_data.Luminance, r0.x);
  r0.x = min(g_data.Luminance, r0.x);
  o0.xyz = r2.xyz + (r0.xxx * CUSTOM_SHARPENING);
  o0.w = 1;
  return;
}