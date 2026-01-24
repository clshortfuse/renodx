// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 10:20:16 2026
#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
  
  // Godrays intensity: 0=Off, 1=Vanilla, 2=2x, 3=3x
  if (GODRAYS_INTENSITY == 0) {
    r0.xyz = 0;  // Off
  } else if (GODRAYS_INTENSITY == 2) {
    r0.xyz *= 2.0f;  // 2x
  } else if (GODRAYS_INTENSITY == 3) {
    r0.xyz *= 3.0f;  // 3x
  }
  // GODRAYS_INTENSITY == 1 is vanilla (no change)
  
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}