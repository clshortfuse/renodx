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

SamplerState PA_LINEAR_BORDER_FILTER_0000_s : register(s0);
SamplerState PA_POINT_CLAMP_FILTER_s : register(s1);
SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s2);
Texture2D<float4> texColor : register(t0);
Texture2D<float4> texColor1 : register(t1);
Texture2D<float4> texBlured : register(t2);


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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_UI_VISIBLE < 0.5f) {
    o0 = float4(0, 0, 0, 0);
    return;
  }

  r0.xy = float2(-0.5,-0.5) + w1.xy;
  r0.z = cmp(2 == nOperate[0]);
  if (r0.z != 0) {
    r0.zw = -vecParam[0].xy + r0.xy;
    r0.zw = r0.zw * r0.zw;
    r0.z = r0.z + r0.w;
    r0.w = vecParam[0].z * vecParam[0].z;
    r0.z = cmp(r0.w < r0.z);
    if (r0.z != 0) discard;
  } else {
    r0.zw = cmp(int2(1,3) == nOperate[0]);
    r1.xy = cmp(r0.xy < vecParam[0].xy);
    r1.x = (int)r1.y | (int)r1.x;
    r1.yz = cmp(vecParam[0].zw < r0.xy);
    r1.x = (int)r1.y | (int)r1.x;
    r1.x = (int)r1.z | (int)r1.x;
    r0.z = r0.z ? r1.x : 0;
    r1.x = ~(int)r0.z;
    if (r0.z != 0) discard;
    r0.z = r0.w ? r1.x : 0;
    r1.xy = -vecParam[0].xy + r0.xy;
    r0.w = dot(r1.xy, r1.xy);
    r0.w = rsqrt(r0.w);
    r1.xy = r1.xy * r0.ww;
    r0.w = 1 + -abs(r1.x);
    r0.w = sqrt(r0.w);
    r1.z = abs(r1.x) * -0.0187292993 + 0.0742610022;
    r1.z = r1.z * abs(r1.x) + -0.212114394;
    r1.z = r1.z * abs(r1.x) + 1.57072878;
    r1.w = r1.z * r0.w;
    r1.w = r1.w * -2 + 3.14159274;
    r1.x = cmp(r1.x < -r1.x);
    r1.x = r1.x ? r1.w : 0;
    r0.w = r1.z * r0.w + r1.x;
    r1.x = cmp(0 < r1.y);
    r1.y = ~(int)r1.x;
    r1.x = r0.z ? r1.x : 0;
    r1.z = cmp(-r0.w < vecParam[0].z);
    r1.z = r1.z ? 6.283184 : 0;
    r1.z = r1.z + -r0.w;
    r1.z = cmp(vecParam[0].w < r1.z);
    r1.x = r1.z ? r1.x : 0;
    if (r1.x != 0) discard;
    r0.z = r0.z ? r1.y : 0;
    r1.x = cmp(r0.w < vecParam[0].z);
    r1.x = r1.x ? 6.283184 : 0;
    r0.w = r1.x + r0.w;
    r0.w = cmp(vecParam[0].w < r0.w);
    r0.z = r0.w ? r0.z : 0;
    if (r0.z != 0) discard;
  }
  r0.z = cmp(isUseTexture == 0);
  r0.w = cmp(isDepthCheck != 0);
  r0.z = (int)r0.w | (int)r0.z;
  if (r0.z != 0) discard;
  r0.z = texColor.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, v1.xy, 0).w;
  r0.xy = -vecParam[2].xy + r0.xy;
  r0.xy = r0.xy / vecParam[2].zw;
  r1.xy = vecParam[3].zw + -vecParam[3].xy;
  r0.xy = r0.xy * r1.xy + vecParam[3].xy;
  r0.x = texColor1.Sample(PA_POINT_CLAMP_FILTER_s, r0.xy).w;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.x = nOperate[3] ? r0.x : r0.z;
  r0.x = isUseTexture ? r0.x : v2.w;
  r0.y = log2(v2.w);
  r0.y = 2.20000005 * r0.y;
  r0.y = exp2(r0.y);
  r0.y = r0.x * r0.y;
  r0.x = nOperate[1] ? r0.x : r0.y;
  r0.y = globalAlpha * r0.x;
  r0.x = r0.x * globalAlpha + -0.00100000005;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xz = v0.xy * invScreenSize.xy + invScreenSize.zw;
  r0.xzw = texBlured.SampleLevel(PA_LINEAR_BORDER_FILTER_0000_s, r0.xz, 0).xyz;
  r0.y = saturate(2.5 * r0.y);
  r1.xy = log2(v1.xy);
  r1.xy = float2(10,10) * r1.xy;
  r1.xy = exp2(r1.xy);
  r0.y = -r1.x + r0.y;
  r1.xz = float2(1,1) + -v1.xy;
  r1.xz = log2(r1.xz);
  r1.xz = float2(10,10) * r1.xz;
  r1.xz = exp2(r1.xz);
  r0.y = -r1.x + r0.y;
  r0.y = r0.y + -r1.y;
  o0.w = r0.y + -r1.z;
  o0.xyz = hdrDisplayDimmer * r0.xzw;
  return;
}