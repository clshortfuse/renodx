#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 29 15:53:32 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0,0,0,0);
  r1.xy = v1.xy;
  r1.z = 0;
  while (true) {
    r1.w = cmp((int)r1.z >= 6);
    if (r1.w != 0) break;
    r2.xy = r1.xy * cb0[7].xy + cb0[7].zw;
    r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
    r0.xyzw = r2.xyzw + r0.xyzw;
    r1.xy = w1.xy + r1.xy;
    r1.z = (int)r1.z + 1;
  }

  
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.xyzw = float4(0.166666672, 0.166666672, 0.166666672, 0.166666672) * r0.xyzw;  // vanilla
  }
  else {
    o0.xyzw = float4(CUSTOM_SUN_SHAFTS, CUSTOM_SUN_SHAFTS, CUSTOM_SUN_SHAFTS, CUSTOM_SUN_SHAFTS) * r0.xyzw;  // reduce transparency
  }
  return;
}