// ---- Created with 3Dmigoto v1.3.16 on Tue Jul 23 02:31:55 2024
// Blur effect in menu -- prolly an effect shader
#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 materialColor : packoffset(c0) = {1,1,1,1};
  bool ignoreVtxColorFlag : packoffset(c1) = false;
  float2 fScreenInfo : packoffset(c1.y) = {0.000781250012,0.00138888892};
}

SamplerState __smpsTex_s : register(s0);
SamplerState __smpsGaussianBlur_s : register(s1);
Texture2D<float4> sTex : register(t0);
Texture2D<float4> sGaussianBlur : register(t1);


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

  r0.x = sTex.Sample(__smpsTex_s, v2.xy).w;
  r0.y = ignoreVtxColorFlag ? 1 : v0.w;
  r0.x = r0.y * r0.x;
  r0.y = r0.x * materialColor.w + -0.00392156886;
  r0.x = materialColor.w * r0.x;
  o0.w = r0.x;
  r0.x = cmp(r0.y < 0);
  if (r0.x != 0) discard;
  r0.xy = floor(v1.xy);
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = fScreenInfo.xy * r0.xy;
  r0.xyz = sGaussianBlur.Sample(__smpsGaussianBlur_s, r0.xy).xyz;
  o0.xyz = r0.xyz;
    
 //   o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
 //   o0.rgb *= injectedData.toneMapUINits / 80.f; //Added ui slider
  return;
}