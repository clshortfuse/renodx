// ---- Created with 3Dmigoto v1.3.16 on Mon Sep 23 18:14:58 2024
// Ingame open world UI

#include "./shared.h"

Texture2D<float4> t0 : register(t0);

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

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xyzw = v0.xyzw * r0.xyzw;
  
    //o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); // 2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits; //Ratio of UI:Game brightness
    //o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2); //Inverse 2.2 gamma   
    
  return;
}