#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 18:40:34 2025

cbuffer RadialClipParams : register(b0)
{
  float g_fClipStartRadius : packoffset(c0);
  float g_fClipEndRadius : packoffset(c0.y);
  float2 g_fClipCentre : packoffset(c0.z);
}

SamplerState g_xTrilinearWrap_s : register(s2);
Texture2D<float4> g_xTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : Texcoords0,
  float4 v1 : Colour0,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_xTexture.Sample(g_xTrilinearWrap_s, v0.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xy = -g_fClipCentre.xy + v2.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = -g_fClipStartRadius + r1.x;
  r1.y = g_fClipEndRadius + -g_fClipStartRadius;
  r1.x = saturate(r1.x / r1.y);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r1.x = cmp(0.00392156886 >= r0.w);
  if (r1.x != 0) discard;
  o0.xyzw = r0.xyzw;
  
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  
  return;
}