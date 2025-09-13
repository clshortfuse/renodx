// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 31 23:18:00 2025
#include "./common.hlsl"

SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_texture : register(t0);


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

  if (!CUSTOM_SPRITES_DRAW) discard;

  r0.x = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(-1, 0)).w;
  r0.x = max(9.99999972e-010, r0.x);
  r0.y = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(1, 0)).w;
  r0.x = max(r0.x, r0.y);
  r0.y = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(0, -1)).w;
  r0.x = max(r0.x, r0.y);
  r0.y = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(0, 1)).w;
  r0.x = max(r0.x, r0.y);
  r0.w = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(-2, 0)).w;
  r0.w = max(9.99999972e-010, r0.w);
  r1.x = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(2, 0)).w;
  r0.w = max(r1.x, r0.w);
  r1.x = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(0, -2)).w;
  r0.w = max(r1.x, r0.w);
  r1.x = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(0, 2)).w;
  r0.y = max(r1.x, r0.w);
  r0.w = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(-1, -1)).w;
  r0.w = max(9.99999972e-010, r0.w);
  r1.x = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(1, -1)).w;
  r0.w = max(r1.x, r0.w);
  r1.x = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(-1, 1)).w;
  r0.w = max(r1.x, r0.w);
  r1.x = g_texture.SampleLevel(g_sampler_s, v2.xy, 0, int2(1, 1)).w;
  r0.z = max(r1.x, r0.w);
  r0.xyz = float3(0.899999976,0.600000024,0.800000012) * r0.xyz;
  r0.w = g_texture.SampleLevel(g_sampler_s, v2.xy, 0).w;
  r1.x = max(9.99999972e-010, r0.w);
  r1.yzw = v1.xyz * r0.www;
  r1.yzw = v1.www * r1.yzw;
  r0.x = max(r1.x, r0.x);
  r0.x = max(r0.x, r0.y);
  r0.x = max(r0.x, r0.z);
  o0.xyz = r1.yzw / r0.xxx;
  o0.w = v1.w * r0.x;

  return;
}