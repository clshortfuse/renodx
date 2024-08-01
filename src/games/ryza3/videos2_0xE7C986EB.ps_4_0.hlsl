// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 31 20:56:54 2024
// Videos 2
#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float vATest : packoffset(c0);
}



SamplerState smp_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -vATest + v1.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyzw = tex.Sample(smp_s, v2.xy).xyzw;
  o0.xyz = v1.xyz * r0.xyz;
  o0.w = v1.w;
  
    o0.rgb = renodx::color::correct::PowerGammaCorrect(o0.rgb); //2.2 gamma correction
    
    o0.rgb *= injectedData.toneMapGameNits / 80.f; //Using paper white saling, the movies are too bright for bt2446a
  
  return;
}