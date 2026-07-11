// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 24 17:15:32 2024
// Not movies, gamma is shared between movies and game


#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s1_s, v1.xy).x;
  r0.x = -0.501960814 + r0.x;
  r0.xy = float2(0.391000003,2.01799989) * r0.xx;
  r0.z = t0.Sample(s0_s, v1.xy).x;
  r0.z = -0.0627451017 + r0.z;
  r0.x = r0.z * 1.16438353 + -r0.x;
  r0.y = r0.z * 1.16438353 + r0.y;
  o0.z = v0.z * r0.y;
  r0.y = t2.Sample(s2_s, v1.xy).x;
  r0.y = -0.501960814 + r0.y;
  r0.x = -r0.y * 0.813000023 + r0.x;
  r0.y = 1.59599996 * r0.y;
  r0.y = r0.z * 1.16438353 + r0.y;
  o0.xy = v0.xy * r0.yx;
  o0.w = v0.w;
    
    //o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);
  return;
}