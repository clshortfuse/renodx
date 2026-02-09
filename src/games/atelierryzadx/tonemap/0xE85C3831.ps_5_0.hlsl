#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 13 18:40:18 2025

cbuffer _Globals : register(b0)
{
  float4 vViewInfo : packoffset(c0);
  float fDistantBlurZThreshold : packoffset(c1);
  float fFar : packoffset(c1.y);
  float fDistantBlurIntensity : packoffset(c1.z);
  float2 SimulateHDRParams : packoffset(c2);
  float fKIDSDOFType : packoffset(c2.z) = {0};
  float fBloomWeight : packoffset(c2.w) = {0.5};
  float fStarWeight : packoffset(c3) = {0.800000012};
  float fLensFlareWeight : packoffset(c3.y) = {0.300000012};
  float fSaturationScaleEx : packoffset(c3.z) = {1};
  float3 vColorScale : packoffset(c4) = {1,1,1};
  float3 vSaturationScale : packoffset(c5) = {1,1,1};
  float2 vScreenSize : packoffset(c6) = {1280,720};
  float4 vSpotParams : packoffset(c7) = {640,360,300,400};
  float fLimbDarkening : packoffset(c8) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c8.y) = {0};
  float fGamma : packoffset(c8.z) = {1};
}

SamplerState smplScene_s : register(s0);
SamplerState smplAdaptedLumCur_s : register(s1);
SamplerState smplZ_s : register(s2);
SamplerState smplBlurFront_s : register(s3);
SamplerState smplDOFMerge_s : register(s4);
SamplerState smplBlurBack_s : register(s5);
SamplerState smplBlurHexFront_s : register(s6);
SamplerState smplBlurHexBack_s : register(s7);
SamplerState smplEffectScene_s : register(s8);
SamplerState smplBloom_s : register(s9);
SamplerState smplStar_s : register(s10);
SamplerState smplFlare_s : register(s11);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t1);
Texture2D<float4> smplZ_Tex : register(t2);
Texture2D<float4> smplBlurFront_Tex : register(t3);
Texture2D<float4> smplDOFMerge_Tex : register(t4);
Texture2D<float4> smplBlurBack_Tex : register(t5);
Texture2D<float4> smplBlurHexFront_Tex : register(t6);
Texture2D<float4> smplBlurHexBack_Tex : register(t7);
Texture2D<float4> smplEffectScene_Tex : register(t8);
Texture2D<float4> smplBloom_Tex : register(t9);
Texture2D<float4> smplStar_Tex : register(t10);
Texture2D<float4> smplFlare_Tex : register(t11);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r1.x = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur_s, float2(0.25,0.5)).x;
  r1.yzw = r1.xxx * r0.xyz;
  r2.x = smplDOFMerge_Tex.Sample(smplDOFMerge_s, v1.xy).w;
  r2.y = cmp(fKIDSDOFType == 0.000000);
  if (r2.y != 0) {
    r2.y = cmp(r2.x < 0.5);
    if (r2.y == 0) {
      r2.yzw = smplBlurBack_Tex.Sample(smplBlurBack_s, v1.xy).xyz;
      r3.x = -0.5 + r2.x;
      r3.x = abs(r3.x) * -2 + 1;
      r3.x = max(0, r3.x);
      r3.x = 9.99999975e-06 + r3.x;
      r3.x = 1 / r3.x;
      r3.x = -1 + r3.x;
      r3.x = saturate(0.25 * r3.x);
      r2.yzw = -r0.xyz * r1.xxx + r2.yzw;
      r1.yzw = r3.xxx * r2.yzw + r1.yzw;
    }
    r3.xyzw = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyzw;
    r2.y = -0.5 + r3.w;
    r2.y = abs(r2.y) * -2 + 1;
    r2.y = max(0, r2.y);
    r2.y = 9.99999975e-06 + r2.y;
    r2.y = 1 / r2.y;
    r2.y = -1 + r2.y;
    r2.y = saturate(0.25 * r2.y);
    r3.xyz = r3.xyz + -r1.yzw;
    r2.yzw = r2.yyy * r3.xyz + r1.yzw;
  } else {
    r3.x = cmp(fKIDSDOFType == 1.000000);
    if (r3.x != 0) {
      r3.x = cmp(r2.x < 0.5);
      if (r3.x == 0) {
        r3.xyz = smplBlurHexBack_Tex.Sample(smplBlurHexBack_s, v1.xy).xyz;
        r2.x = -0.5 + r2.x;
        r2.x = abs(r2.x) * -2 + 1;
        r2.x = max(0, r2.x);
        r2.x = 9.99999975e-06 + r2.x;
        r2.x = 1 / r2.x;
        r2.x = -1 + r2.x;
        r2.x = saturate(0.25 * r2.x);
        r3.xyz = -r0.xyz * r1.xxx + r3.xyz;
        r1.yzw = r2.xxx * r3.xyz + r1.yzw;
      }
      r3.xyzw = smplBlurHexFront_Tex.Sample(smplBlurHexFront_s, v1.xy).xyzw;
      r2.x = -0.5 + r3.w;
      r2.x = abs(r2.x) * -2 + 1;
      r2.x = max(0, r2.x);
      r2.x = 9.99999975e-06 + r2.x;
      r2.x = 1 / r2.x;
      r2.x = -1 + r2.x;
      r2.x = saturate(0.25 * r2.x);
      r3.xyz = r3.xyz + -r1.yzw;
      r2.yzw = r2.xxx * r3.xyz + r1.yzw;
    } else {
      r2.x = smplZ_Tex.Sample(smplZ_s, v1.xy).x;
      r2.x = vViewInfo.z + r2.x;
      r2.x = -vViewInfo.w / r2.x;
      r2.x = -fDistantBlurZThreshold + r2.x;
      r3.x = fFar + -fDistantBlurZThreshold;
      r2.x = saturate(r2.x / r3.x);
      r2.x = saturate(fDistantBlurIntensity * r2.x);
      r2.x = sqrt(r2.x);
      r3.xyz = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyz;
      r0.xyz = -r0.xyz * r1.xxx + r3.xyz;
      r2.yzw = r2.xxx * r0.xyz + r1.yzw;
    }
  }
  r1.xyzw = smplEffectScene_Tex.Sample(smplEffectScene_s, v1.xy).xyzw;

  PostEffectsSample(r1.xyzw, SimulateHDRParams, fGamma);

  r0.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r3.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r3.xyz = r0.xyz * r3.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r4.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r0.xyz = r0.xyz * r4.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r3.xyz / r0.xyz;
  r0.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r0.xyz;
  r0.xyz = float3(2.49262953,2.49262953,2.49262953) * r0.xyz;
  r0.xyz = min(float3(1,1,1), r0.xyz);
  r0.xyz = r0.xyz * SimulateHDRParams.yyy + float3(0.0333000012,0.0333000012,0.0333000012);
  r3.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(-0.219999999,-0.219999999,-0.219999999);
  r4.xyz = r0.xyz * float3(0.300000012,0.300000012,0.300000012) + float3(-0.0299999993,-0.0299999993,-0.0299999993);
  r0.xyz = r0.xyz * float3(0.0599999987,0.0599999987,0.0599999987) + float3(-0.00200000009,-0.00200000009,-0.00200000009);
  r0.xyz = r0.xyz * r3.xyz;
  r0.xyz = float3(4,4,4) * r0.xyz;
  r0.xyz = r4.xyz * r4.xyz + -r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r0.xyz = -r4.xyz + -r0.xyz;
  r3.xyz = r3.xyz + r3.xyz;
  r0.xyz = r0.xyz / r3.xyz;
  r0.xyz = r0.xyz + r1.xyz;

  PreEffectsBlend(r0.xyz);

  r0.xyz = r2.yzw * r1.www + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyz;
  r0.xyz = r1.xyz * fBloomWeight + r0.xyz;
  r1.xyz = smplStar_Tex.Sample(smplStar_s, v1.xy).xyz;
  r0.xyz = r1.xyz * fStarWeight + r0.xyz;
  r1.xyz = smplFlare_Tex.Sample(smplFlare_s, v1.xy).xyz;
  r0.xyz = r1.xyz * fLensFlareWeight + r0.xyz;
  r1.xyz = vColorScale.xyz * r0.xyz;
  r1.x = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz * vColorScale.xyz + -r1.xxx;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r1.xxx;
  r1.xy = v1.xy * vScreenSize.xy + -vSpotParams.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.y = sqrt(r1.x);
  r1.y = -vSpotParams.z + r1.y;
  r1.z = cmp(0 >= r1.y);
  r1.y = saturate(vSpotParams.w / r1.y);
  r1.y = r1.z ? 1 : r1.y;
  r1.x = fLimbDarkening + r1.x;
  r1.x = fLimbDarkening / r1.x;
  r1.x = r1.x * r1.x;
  r1.xzw = r1.xxx * r0.xyz;
  r1.xyz = r1.xzw * r1.yyy;
  r1.w = 1 + -fLimbDarkeningWeight;
  r1.xyz = fLimbDarkeningWeight * r1.xyz;
  r0.xyz = r0.xyz * r1.www + r1.xyz;
  
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