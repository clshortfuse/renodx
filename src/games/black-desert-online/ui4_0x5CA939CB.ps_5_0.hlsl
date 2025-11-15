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

SamplerState PA_POINT_CLAMP_FILTER_s : register(s0);
SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s1);
SamplerState PA_LINEAR_FILTER_s : register(s2);
Texture2D<float4> texColor : register(t0);
Texture2D<float4> texColor1 : register(t1);
Texture2D<float4> texDepth : register(t2);
Texture2D<float4> texRoseWarFogMap : register(t3);


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
  float4 r0,r1,r2,r3,r4;
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
  r1.xyzw = texColor.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, v1.xy, 0).xyzw;
  r0.z = texRoseWarFogMap.SampleLevel(PA_POINT_CLAMP_FILTER_s, v1.xy, 0).x;
  r0.z = min(1, r0.z);
  r2.xyz = r1.xyz * r0.zzz;
  r1.xyz = useTexRoseWarFogMap ? r2.xyz : r1.xyz;
  r0.xy = -vecParam[2].xy + r0.xy;
  r0.xy = r0.xy / vecParam[2].zw;
  r0.zw = vecParam[3].zw + -vecParam[3].xy;
  r0.xy = r0.xy * r0.zw + vecParam[3].xy;
  r0.xyzw = texColor1.Sample(PA_POINT_CLAMP_FILTER_s, r0.xy).xyzw;
  r2.xyz = r1.xyz * r0.xyz;
  r0.x = r0.w * r0.w;
  r2.w = r1.w * r0.x;
  r0.xyzw = nOperate[3] ? r2.xyzw : r1.xyzw;
  r0.xyzw = isUseTexture ? r0.xyzw : v2.xyzw;
  r1.xyz = v2.xyz * r0.xyz;
  r2.x = log2(v2.w);
  r2.x = 2.20000005 * r2.x;
  r2.x = exp2(r2.x);
  r1.w = r2.x * r0.w;
  r2.xyz = v2.xyz + r0.xyz;
  r3.xy = cmp(nOperate[1] == int2(1,2));
  r4.xyz = -v2.xyz + r0.xyz;
  r3.yzw = r3.yyy ? r4.xyz : r0.xyz;
  r0.xyz = r3.xxx ? r2.xyz : r3.yzw;
  r0.xyzw = nOperate[1] ? r0.xyzw : r1.xyzw;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.x = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r1.xyz = r1.xxx * float3(2,2,2) + r0.xyz;
  r2.xyz = r0.xyz * animatedColorIntensity + r0.xyz;
  r3.xyz = r0.xyz + r0.xyz;
  r1.w = 4 * elapsedTime;
  r1.w = sin(r1.w);
  r1.w = 1 + r1.w;
  r3.xyz = r3.xyz * r1.www;
  r3.xyz = r3.xyz * animatedColorIntensity + r0.xyz;
  r2.xyz = nOperate[6] ? r2.xyz : r3.xyz;
  r0.xyz = nOperate[4] ? r2.xyz : r0.xyz;
  r0.xyz = nOperate[5] ? r1.xyz : r0.xyz;
  r1.x = cmp(1 < vecParam[1].w);
  r1.yzw = vecParam[1].www * r0.xyz;
  r0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  r0.w = globalAlpha * r0.w;
  r1.x = nOperate[2];
  r1.x = cmp(-0.5 < r1.x);
  if (r1.x != 0) {
    r1.x = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
    r1.y = 0.200000003 * r1.x;
    r1.zw = cmp(nOperate[2] == int2(1,2));
    r2.xyz = float3(2,0.266000003,0.266000003) * r0.xyz;
    r2.xyz = r1.www ? r2.xyz : r0.xyz;
    r1.yzw = r1.zzz ? r1.yyy : r2.xyz;
    r0.xyz = nOperate[2] ? r1.yzw : r1.xxx;
  }
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  if (isDepthCheck != 0) {
    r1.xy = v0.xy * invScreenSize.xy + invScreenSize.zw;
    r1.xy = fDynamicResolution * r1.xy;
    r1.zw = viewportJitter.xy * invScreenSize.xy + r1.xy;
    r2.xyzw = texDepth.Gather(PA_LINEAR_FILTER_s, r1.zw).xyzw;
    r1.zw = -invScreenSize.xy + r1.zw;
    r3.xyzw = texDepth.Gather(PA_LINEAR_FILTER_s, r1.zw).xyzw;
    r1.z = r2.x + r2.y;
    r1.z = r1.z + r2.z;
    r1.z = r1.z + r2.w;
    r1.z = r1.z + r3.x;
    r1.z = r1.z + r3.y;
    r1.z = r1.z + r3.z;
    r1.z = r1.z + r3.w;
    r1.z = 1.25 * r1.z;
    r1.x = texDepth.SampleLevel(PA_LINEAR_FILTER_s, r1.xy, 0).x;
    r1.x = 10 * r1.x;
    r1.x = isTAAUI ? r1.z : abs(r1.x);
    r1.yzw = -vecViewPosition.xyz + vecParam[1].xyz;
    r1.y = dot(r1.yzw, r1.yzw);
    r1.y = sqrt(r1.y);
    r1.x = r1.x + -r1.y;
    r1.x = 80 + r1.x;
    r1.x = saturate(0.0110999998 * r1.x);
    o0.w = r1.x * r0.w;
  } else {
    o0.w = r0.w;
  }
  o0.xyz = hdrDisplayDimmer * r0.xyz;
  return;
}