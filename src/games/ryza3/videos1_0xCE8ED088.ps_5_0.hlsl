// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 31 20:56:52 2024
// Videos 1

#include "./shared.h"


cbuffer _Globals : register(b0)
{
  float HdrRangeInv : packoffset(c0) = {1};
  float fAlphaRate : packoffset(c0.y) = {1};
}

SamplerState __smpsTex_s : register(s0);
Texture2D<float4> sTex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sTex.Sample(__smpsTex_s, v2.xy).xyzw;
  r0.xyzw = v0.xyzw * r0.xyzw;
  o0.xyzw = HdrRangeInv * r0.xyzw;
  
 //     o0.rgb = renodx::color::correct::PowerGammaCorrect(o0.rgb); //2.2 gamma correction
    
 //   o0.rgb *= injectedData.toneMapGameNits / 80.f; //Using paper white saling, the movies are too bright for bt2446a
  
  return;
}