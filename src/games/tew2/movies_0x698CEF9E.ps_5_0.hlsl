// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 22:01:40 2024
// Movies, Intro Movies 1

#include "./shared.h"

SamplerState binky_samp_state_s : register(s0);
SamplerState binkcr_samp_state_s : register(s1);
SamplerState binkcb_samp_state_s : register(s2);
Texture2D<float4> binky_samp : register(t0);
Texture2D<float4> binkcr_samp : register(t1);
Texture2D<float4> binkcb_samp : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = binkcb_samp.Sample(binkcb_samp_state_s, v0.xy, int2(0, 0)).x;
  r0.xyz = float3(0,-0.391448975,2.01782227) * r0.xxx;
  r0.w = binkcr_samp.Sample(binkcr_samp_state_s, v0.xy, int2(0, 0)).x;
  r0.xyz = r0.www * float3(1.59579468,-0.813476563,0) + r0.xyz;
  r0.w = binky_samp.Sample(binky_samp_state_s, v0.xy, int2(0, 0)).x;
  r0.xyz = r0.www * float3(1.16412354,1.16412354,1.16412354) + r0.xyz;
  o0.xyz = float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz;
  o0.w = 1;
    
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
    
    o0.rgb *= injectedData.toneMapGameNits / 80.f; //Using paper white saling, the movies are too bright for bt2446a
    
  return;
}