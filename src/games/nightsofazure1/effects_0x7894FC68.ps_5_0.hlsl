// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 11 19:29:54 2024
// Cursed effect shader that is griefing us
// Might be able to skip via a copy

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 f4GammaParam : packoffset(c0);
}

SamplerState smplScene_s : register(s0);
Texture2D<float4> smplScene_Tex : register(t0);


// 3Dmigoto declarations
#define cmp -

// Vanilla shader
/*  
void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;
    

    
    

   
  r0.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;
  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = f4GammaParam.xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = f4GammaParam.www * r1.xyz + r0.xyz;
  o0.w = 1;
*/

// shortfuse's fix -- copy/sample the input; and return 1.f alpha
// We don't need pow, breaks our 2020 and goes negative


float4 main(float4 v0 : SV_Position0, float2 v1 : TEXCOORD0) : SV_Target0
{
    return float4(smplScene_Tex.Sample(smplScene_s, v1.xy).xyz, 1.f);
    
    
}


