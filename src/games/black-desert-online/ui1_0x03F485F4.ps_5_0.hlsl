// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 26 21:03:05 2025

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  int nOperate[8] : packoffset(c0);
  float4 vecParam[4] : packoffset(c8);
  float playerPosX : packoffset(c12);
  float playerPosY : packoffset(c12.y);
  bool isDepthCheck : packoffset(c12.z) = false;
  bool isUseTexture : packoffset(c12.w) = true;
  bool isTAAUI : packoffset(c13) = false;
  bool useTexRoseWarFogMap : packoffset(c13.y) = false;
  bool isReveal : packoffset(c13.z) = true;
  float4x4 matTransform : packoffset(c14);
  float4x4 matWorldTransform : packoffset(c18);
  float fUIDyeSpecularExp : packoffset(c22);
  float fUIDyeEnvRate : packoffset(c22.y);
  float3 vecViewDirection : packoffset(c23);
  float fColorValueMin : packoffset(c23.w);
  float fColorValueMax : packoffset(c24);
}

cbuffer UIConst : register(b2)
{
  float4 invScreenSize : packoffset(c0);
  float3 vecViewPosition : packoffset(c1);
  float elapsedTime : packoffset(c1.w);
  float globalAlpha : packoffset(c2) = {1};
  float hdrDisplayDimmer : packoffset(c2.y) = {1};
  float animatedColorIntensity : packoffset(c2.z) = {1};
  float fDynamicResolution : packoffset(c2.w) = {1};
  float2 viewportJitter : packoffset(c3) = {0,0};
  float2 UIConstFloatDummy0 : packoffset(c3.z);
}

cbuffer InGameUIConst : register(b3)
{
  float4 vecTargetSize : packoffset(c0);
  float4 vecTargetColor : packoffset(c1);
  float3 worldPos : packoffset(c2);
  bool isDepthCull : packoffset(c2.w);
  float targetRenderRate : packoffset(c3);
  float targetRotation : packoffset(c3.y);
  float2 InGameUIConstFloatDummy1 : packoffset(c3.z);
}

SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s0);
SamplerState PA_LINEAR_FILTER_s : register(s1);
Texture2D<float4> texColor : register(t0);
Texture2D<float4> texDepth : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : COLOR0,
  float3 v3 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_UI_VISIBLE < 0.5f) {
    o0 = float4(0, 0, 0, 0);
    return;
  }

  r0.xy = v0.xy * invScreenSize.xy + invScreenSize.zw;
  r0.xy = fDynamicResolution * r0.xy;
  r0.zw = viewportJitter.xy * invScreenSize.xy + r0.xy;
  r0.x = texDepth.Sample(PA_LINEAR_FILTER_s, r0.xy).x;
  r1.xyzw = texDepth.Gather(PA_LINEAR_FILTER_s, r0.zw).xyzw;
  r0.yz = -invScreenSize.xy + r0.zw;
  r2.xyzw = texDepth.Gather(PA_LINEAR_FILTER_s, r0.yz).xyzw;
  r0.y = r1.x + r1.y;
  r0.y = r0.y + r1.z;
  r0.y = r0.y + r1.w;
  r0.y = r0.y + r2.x;
  r0.y = r0.y + r2.y;
  r0.y = r0.y + r2.z;
  r0.y = r0.y + r2.w;
  r0.xy = float2(10,1.25) * r0.xy;
  r0.x = isTAAUI ? r0.y : abs(r0.x);
  r0.yzw = worldPos.xyz + -vecViewPosition.xyz;
  r0.y = dot(r0.yzw, r0.yzw);
  r0.y = sqrt(r0.y);
  r0.x = r0.x + -r0.y;
  r0.x = 50 + r0.x;
  r0.x = saturate(0.0120000001 * r0.x);
  r1.xyzw = texColor.Sample(PA_LINEAR_CLAMP_FILTER_s, v1.xy).xyzw;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.w = r1.w * r0.x;
  r2.x = targetRenderRate + targetRenderRate;
  r2.xyz = r2.xxx * r1.xyz;
  r3.w = targetRenderRate * r1.w;
  r0.xyz = r1.xyz;
  r3.xyz = r3.www * r2.xyz;
  r0.xyzw = isDepthCull ? r0.xyzw : r3.xyzw;
  o0.xyz = hdrDisplayDimmer * r0.xyz;
  o0.w = r0.w;
  return;
}