// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 11 19:29:58 2024
// Main UI Shader, gameplay, world, start menu

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 materialColor : packoffset(c0) = {1,1,1,1};
  bool maskFlag : packoffset(c1) = false;
  bool ignoreVtxColorFlag : packoffset(c1.y) = false;
  float HdrRangeInv : packoffset(c1.z) = {1};
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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1;
  r1.xyzw = sTex.Sample(__smpsTex_s, v2.xy).xyzw;
  r0.w = r1.w;
  r0.xyzw = maskFlag ? r0.xxxw : r1.xyzw;
  r1.xyzw = ignoreVtxColorFlag ? float4(1,1,1,1) : v0.xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = materialColor.xyzw * r0.xyzw;
  o0.xyz = HdrRangeInv * r0.xyz;
  o0.w = r0.w;
    
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); // 2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits; //Ratio of UI:Game brightness
    o0.rgb = renodx::math::SafePow(o0.rgb, 1/2.2); //Inverse 2.2 gamma
    
  return;
}