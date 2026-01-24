// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 24 03:28:04 2026
#include "../shared.h"

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.xy = r0.xy + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = -1 + r0.x;
  r0.y = cb0[3].y + -1;
  r0.x = saturate(r0.x / r0.y);
  r0.x = log2(r0.x);
  r0.x = cb0[3].z * r0.x;
  r0.x = exp2(r0.x);
  r0.xyzw = cb0[6].xyzw * r0.xxxx;
  
  // Godrays intensity: 0=Off, 1=Vanilla, 2=2x, 3=3x
  if (GODRAYS_INTENSITY == 0) {
    r0.xyzw = 0;  // Off
  } else if (GODRAYS_INTENSITY == 2) {
    r0.xyzw *= 2.0f;  // 2x
  } else if (GODRAYS_INTENSITY == 3) {
    r0.xyzw *= 3.0f;  // 3x
  }
  // GODRAYS_INTENSITY == 1 is vanilla (no change)
  
  o0.xyzw = w1 * r0.xyzw;  
  return;
}