#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 13 18:40:17 2025

cbuffer _Globals : register(b0)
{
  float2 SimulateHDRParams : packoffset(c0);
  float fBloomWeight : packoffset(c0.z) = {0.5};
  float fStarWeight : packoffset(c0.w) = {0.800000012};
  float fLensFlareWeight : packoffset(c1) = {0.300000012};
  float fSaturationScaleEx : packoffset(c1.y) = {1};
  float3 vColorScale : packoffset(c2) = {1,1,1};
  float3 vSaturationScale : packoffset(c3) = {1,1,1};
  float2 vScreenSize : packoffset(c4) = {1280,720};
  float4 vSpotParams : packoffset(c5) = {640,360,300,400};
  float fLimbDarkening : packoffset(c6) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c6.y) = {0};
  float fGamma : packoffset(c6.z) = {1};
}

SamplerState smplScene_s : register(s0);
SamplerState smplAdaptedLumCur_s : register(s1);
SamplerState smplEffectScene_s : register(s2);
SamplerState smplBloom_s : register(s3);
SamplerState smplStar_s : register(s4);
SamplerState smplFlare_s : register(s5);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t1);
Texture2D<float4> smplEffectScene_Tex : register(t2);
Texture2D<float4> smplBloom_Tex : register(t3);
Texture2D<float4> smplStar_Tex : register(t4);
Texture2D<float4> smplFlare_Tex : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = smplEffectScene_Tex.Sample(smplEffectScene_s, v1.xy).xyzw;
  
  PostEffectsSample(r0.xyzw, SimulateHDRParams, fGamma);

  r1.xyz = max(float3(0,0,0), r0.xyz);
  r2.xyz = r1.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r2.xyz = r1.xyz * r2.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r3.xyz = r1.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r3.xyz = r1.xyz * r3.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = -r1.xyz + r0.xyz;
  r1.xyz = r2.xyz / r3.xyz;
  r1.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r1.xyz;
  r1.xyz = float3(2.49262953,2.49262953,2.49262953) * r1.xyz;
  r1.xyz = min(float3(1,1,1), r1.xyz);
  r1.xyz = r1.xyz * SimulateHDRParams.yyy + float3(0.0333000012,0.0333000012,0.0333000012);
  r2.xyz = r1.xyz * float3(0.0599999987,0.0599999987,0.0599999987) + float3(-0.00200000009,-0.00200000009,-0.00200000009);
  r3.xyz = r1.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(-0.219999999,-0.219999999,-0.219999999);
  r1.xyz = r1.xyz * float3(0.300000012,0.300000012,0.300000012) + float3(-0.0299999993,-0.0299999993,-0.0299999993);
  r2.xyz = r3.xyz * r2.xyz;
  r3.xyz = r3.xyz + r3.xyz;
  r2.xyz = float3(4,4,4) * r2.xyz;
  r2.xyz = r1.xyz * r1.xyz + -r2.xyz;
  r2.xyz = sqrt(r2.xyz);
  r1.xyz = -r2.xyz + -r1.xyz;
  r1.xyz = r1.xyz / r3.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r1.x = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur_s, float2(0.25,0.5)).x;
  r2.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * r1.xxx;
  o0.w = r2.w;

  PreEffectsBlend(r0.xyz);

  r0.xyz = r1.xyz * r0.www + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyz;
  r0.xyz = r1.xyz * fBloomWeight + r0.xyz;
  r1.xyz = smplStar_Tex.Sample(smplStar_s, v1.xy).xyz;
  r0.xyz = r1.xyz * fStarWeight + r0.xyz;
  r1.xyz = smplFlare_Tex.Sample(smplFlare_s, v1.xy).xyz;
  r0.xyz = r1.xyz * fLensFlareWeight + r0.xyz;
  r1.xyz = vColorScale.xyz * r0.xyz;
  r0.w = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz * vColorScale.xyz + -r0.www;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r0.www;
  r1.xy = v1.xy * vScreenSize.xy + -vSpotParams.xy;
  r0.w = dot(r1.xy, r1.xy);
  r1.x = fLimbDarkening + r0.w;
  r0.w = sqrt(r0.w);
  r0.w = -vSpotParams.z + r0.w;
  r1.x = fLimbDarkening / r1.x;
  r1.x = r1.x * r1.x;
  r1.xyz = r1.xxx * r0.xyz;
  r1.w = cmp(0 >= r0.w);
  r0.w = saturate(vSpotParams.w / r0.w);
  r0.w = r1.w ? 1 : r0.w;
  r1.xyz = r1.xyz * r0.www;
  r1.xyz = fLimbDarkeningWeight * r1.xyz;
  r0.w = 1 + -fLimbDarkeningWeight;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  
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
  r0.w = min(r0.y, r0.z);
  r0.w = min(r0.x, r0.w);
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r0.w = r1.x + r0.w;
  r0.w = -r0.w * 0.5 + 1;
  r1.x = -1 + fSaturationScaleEx;
  r0.w = r0.w * r1.x + 1;
  r1.x = cmp(1 < fSaturationScaleEx);
  r0.w = r1.x ? r0.w : fSaturationScaleEx;
  r1.x = dot(r0.xyz, float3(0.298909992,0.586610019,0.114480004));
  r1.yzw = -r1.xxx + r0.xyz;
  r1.xyz = r0.www * r1.yzw + r1.xxx;
  r0.w = cmp(fSaturationScaleEx == 1.000000);
  o0.xyz = r0.www ? r0.xyz : r1.xyz;
  
  OutColorAdjustments(o0, fSaturationScaleEx);

  return;
}