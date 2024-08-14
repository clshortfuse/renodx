// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 31 20:18:32 2024
// Final shader in the game's shader order
// simple texture sample that scales up the entire game's brightness
// We will be moving paper white + handle the UI here

#include "./shared.h"

SamplerState smplScene_s : register(s0);
Texture2D<float4> smplScene_Tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
    
    
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f);
    o0.rgb *= injectedData.toneMapGameNits;
    o0.rgb /= 80.f;
    
    
  return;
}