// ---- Created with 3Dmigoto v1.3.16 on Wed Jul 31 20:56:36 2024
//UI, overworld

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 materialColor : packoffset(c0) = {1,1,1,1};
  bool maskFlag : packoffset(c1) = false;
  bool ignoreVtxColorFlag : packoffset(c1.y) = false;
  float greyScaleRatio : packoffset(c1.z) = {0};
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

  r0.xyzw = sTex.Sample(__smpsTex_s, v2.xy).xyzw;
  r1.x = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.xyz = r1.xxx + -r0.xyz;
  r1.w = 0;
  r0.xyzw = greyScaleRatio * r1.xyzw + r0.xyzw;
  r1.w = r0.w;
  r1.x = 1;
  r0.xyzw = maskFlag ? r1.xxxw : r0.xyzw;
  r1.xyzw = ignoreVtxColorFlag ? float4(1,1,1,1) : v0.xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.x = r0.w * materialColor.w + -0.00392156886;
  r0.xyzw = materialColor.xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw;
  r0.x = cmp(r1.x < 0);
  if (r0.x != 0) discard;
  
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); // 2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits; //Ratio of UI:Game brightness
    o0.rgb = renodx::math::SafePow(o0.rgb, 1/2.2); //Inverse 2.2 gamma
  
  return;
}