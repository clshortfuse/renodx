#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 18:40:43 2025

SamplerState g_xFilteredClamp_s : register(s5);
Texture2D<float4> g_xYPlane : register(t0);
Texture2D<float4> g_xUPlane : register(t1);
Texture2D<float4> g_xVPlane : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : Texcoords0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  r0.x = g_xUPlane.Sample(g_xFilteredClamp_s, v0.xy).x;
  r0.y = -0.5 + r0.x;
  r0.w = g_xVPlane.Sample(g_xFilteredClamp_s, v0.xy).x;
  r0.z = -0.5 + r0.w;
  r0.w = g_xYPlane.Sample(g_xFilteredClamp_s, v0.xy).x;
  r0.w = -0.0625 + r0.w;
  r0.x = 1.16429996 * r0.w;
  o0.y = dot(float3(1,-0.213,-0.532999992), r0.xyz);
  o0.z = dot(float2(1,2.11199999), r0.xy);
  o0.x = dot(float2(1,1.79299998), r0.xz);
  
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  
  return;
}