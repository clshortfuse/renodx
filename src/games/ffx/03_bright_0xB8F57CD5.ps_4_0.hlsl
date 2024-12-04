#include "./common.hlsl"
#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 globalColorMask : packoffset(c0) = {1,1,1,1};
  float4 globalColorMaskN : packoffset(c1) = {0,0,0,0};
  float g_brightPara : packoffset(c2) = {1};
}

SamplerState g_BrightTexState_s : register(s0);
Texture2D<float4> g_BrightTex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1,-1) + float2(0,1);
  r0.xyzw = g_BrightTex.Sample(g_BrightTexState_s, r0.xy).xyzw;
  // o0.xyz = g_brightPara + r0.xyz;
  o0.rgb = r0.rgb;
  o0.w = r0.w;
  o0.w = saturate(o0.w);

  o0.rgb = ToneMap(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  // o0.rgb = FinalizeOutput(r0.xyz);
  
  return;
}