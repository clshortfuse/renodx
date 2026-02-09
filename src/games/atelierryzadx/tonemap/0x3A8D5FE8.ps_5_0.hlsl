#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 13 18:40:11 2025

cbuffer _Globals : register(b0)
{
  float fFXAAEdgeThresholdMin : packoffset(c0) = {0.5};
  float fFXAAEdgeThreshold : packoffset(c0.y) = {0.5};
  float fFXAAEdgeSharpness : packoffset(c0.z) = {8};
  float fFXAAPixelRange : packoffset(c0.w) = {2};
  float4 vRecipScreenSize : packoffset(c1) = {0.000781250012,0.00138888892,0.000390625006,0.000694444461};
  float2 SimulateHDRParams : packoffset(c2);
  float fSaturationScaleEx : packoffset(c2.z) = {1};
  float fGamma : packoffset(c2.w) = {1};
}

SamplerState smplScene_s : register(s0);
Texture2D<float4> smplScene_Tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r1.xy = smplScene_Tex.Sample(smplScene_s, v2.xy).xy;
  r1.zw = smplScene_Tex.Sample(smplScene_s, v2.zw).xy;
  r2.xy = smplScene_Tex.Sample(smplScene_s, v3.xy).xy;
  r2.zw = smplScene_Tex.Sample(smplScene_s, v3.zw).xy;
  r3.x = r0.y * 1.9632107 + r0.x;
  r4.z = r1.y * 1.9632107 + r1.x;
  r4.w = r1.w * 1.9632107 + r1.z;
  r4.y = r2.y * 1.9632107 + r2.x;
  r4.x = r2.w * 1.9632107 + r2.z;
  r1.xy = min(r4.zy, r4.wx);
  r1.x = min(r1.x, r1.y);
  r1.x = min(r3.x, r1.x);
  r1.yz = max(r4.zy, r4.wx);
  r1.y = max(r1.y, r1.z);
  r1.y = max(r3.x, r1.y);
  r1.z = r1.y + -r1.x;
  r1.w = fFXAAEdgeThreshold * r1.y;
  r1.w = max(fFXAAEdgeThresholdMin, r1.w);
  r1.z = cmp(r1.z < r1.w);
  r2.xyzw = r4.yzzw + r4.xwyx;
  r2.xy = r2.xz + -r2.yw;
  r1.w = dot(r2.xy, r2.xy);
  r1.w = max(1.00000001e-07, r1.w);
  r1.w = sqrt(r1.w);
  r2.xy = r2.xy / r1.ww;
  r1.w = min(abs(r2.x), abs(r2.y));
  r1.w = r1.w * fFXAAEdgeSharpness + 0.00100000005;
  r2.zw = r2.xy / r1.ww;
  r2.zw = max(-fFXAAPixelRange, r2.zw);
  r2.zw = min(fFXAAPixelRange, r2.zw);
  r3.xy = vRecipScreenSize.xy * fFXAAPixelRange;
  r4.xy = vRecipScreenSize.zw * r2.xy;
  r4.zw = r3.xy * r2.zw;
  r2.xyzw = v1.xyxy + -r4.xyzw;
  r3.xyzw = v1.xyxy + r4.xyzw;
  r4.xyz = smplScene_Tex.Sample(smplScene_s, r2.xy).xyz;
  r5.xyz = smplScene_Tex.Sample(smplScene_s, r3.xy).xyz;
  r2.xyz = smplScene_Tex.Sample(smplScene_s, r2.zw).xyz;
  r3.xyz = smplScene_Tex.Sample(smplScene_s, r3.zw).xyz;
  if (r1.z == 0) {
    r4.xyz = r5.xyz + r4.xyz;
    r5.xyz = float3(0.5,0.5,0.5) * r4.xyz;
    r2.xyz = r3.xyz + r2.xyz;
    r2.xyz = float3(0.25,0.25,0.25) * r2.xyz;
    r2.xyz = r4.xyz * float3(0.25,0.25,0.25) + r2.xyz;
    r1.z = r2.y * 1.9632107 + r2.x;
    r1.x = cmp(r1.z < r1.x);
    r1.y = cmp(r1.y < r1.z);
    r1.x = (int)r1.y | (int)r1.x;
    r0.xyz = r1.xxx ? r5.xyz : r2.xyz;
  }

  PreTonemap(r0.xyz, SimulateHDRParams.x);

  r1.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r2.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r0.xyz;
  r0.xyz = SimulateHDRParams.xxx * r0.xyz;

  PostTonemap(r0.xyz, fGamma);

  r0.xyz = log2(r0.xyz);
  r0.xyz = fGamma * r0.xyz;
  r0.xyz = exp2(r0.xyz);

  PreSaturationScaleEx(r0.xyz, fGamma, fSaturationScaleEx);

  r1.x = cmp(fSaturationScaleEx == 1.000000);
  r1.y = cmp(1 < fSaturationScaleEx);
  r1.z = min(r0.y, r0.z);
  r1.z = min(r1.z, r0.x);
  r1.w = max(r0.y, r0.z);
  r1.w = max(r1.w, r0.x);
  r1.z = r1.w + r1.z;
  r1.z = -r1.z * 0.5 + 1;
  r1.w = -1 + fSaturationScaleEx;
  r1.z = r1.z * r1.w + 1;
  r1.y = r1.y ? r1.z : fSaturationScaleEx;
  r1.z = dot(r0.xyz, float3(0.298909992,0.586610019,0.114480004));
  r2.xyz = -r1.zzz + r0.xyz;
  r1.yzw = r1.yyy * r2.xyz + r1.zzz;
  o0.xyz = r1.xxx ? r0.xyz : r1.yzw;
  o0.w = r0.w;
  
  OutColorAdjustments(o0, fSaturationScaleEx);

  return;
}