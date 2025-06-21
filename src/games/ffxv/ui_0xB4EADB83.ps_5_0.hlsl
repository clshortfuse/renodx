// ---- Created with 3Dmigoto v1.3.16 on Fri May 30 00:38:52 2025
#include "shared.h"
cbuffer MenuHDRParam : register(b0)
{
  float HDRSaturation : packoffset(c0);
  float HDRLuminance : packoffset(c0.y);
}

SamplerState g_samp0_s : register(s0);
Texture2D<float4> g_samp0Texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : COLOR1,
  float2 v3 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = g_samp0Texture.Sample(g_samp0_s, v3.xy).x;
  r0.x = v1.w * r0.x;
  o0.w = r0.x * 1.33333337 + v2.w;
  o0.xyz = v2.xyz + v1.xyz;

  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    float3 color = o0.rgb * o0.w; 
    float y = renodx::color::y::from::BT709(color);

    if (y > 1.0) {
      float scale = rcp(y);
      color *= scale;
    }

    o0.rgb = color / o0.w;  
  }
  return;
}