// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 09 23:17:54 2025
#include "./common.hlsl"

SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_texture_y : register(t0);
Texture2D<float4> g_texture_uv : register(t1);


// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy * float2(1,0.5) + float2(0,0.5);
  r0.x = g_texture_uv.Sample(g_sampler_s, r0.xy).x;
  r0.x = -0.5 + r0.x;
  r0.xy = float2(1.59599996,0.813000023) * r0.xx;
  r0.zw = float2(1,0.5) * v2.xy;
  r0.z = g_texture_uv.Sample(g_sampler_s, r0.zw).x;
  r0.z = -0.5 + r0.z;
  r0.y = r0.z * -0.39199999 + -r0.y;
  r0.z = 2.01699996 * r0.z;
  r0.w = g_texture_y.Sample(g_sampler_s, v2.xy).x;
  r0.w = -0.0625 + r0.w;
  r1.y = r0.w * 1.16400003 + r0.y;
  r1.x = r0.w * 1.16400003 + r0.x;
  r1.z = r0.w * 1.16400003 + r0.z;

  r1.xyz = Mov_Do(r1.xyz);
  
  r0.xyz = v1.xyz * r1.xyz;

  r0.w = 1;
  o0 = r0;
  return;
}