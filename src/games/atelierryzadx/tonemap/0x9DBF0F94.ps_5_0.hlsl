#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:46 2025

cbuffer _Globals : register(b0)
{
  float4 fChromaAberraParam : packoffset(c0) = {0,0,1,0};
  int nChromaAberraTypeIndex : packoffset(c1) = {0};
  float fBloomWeight : packoffset(c1.y) = {0.5};
  float fLensFlareWeight : packoffset(c1.z) = {0.300000012};
  float2 SimulateHDRParams : packoffset(c2);
  float fSaturationScaleEx : packoffset(c2.z) = {1};
  float3 vColorScale : packoffset(c3) = {1,1,1};
  float3 vSaturationScale : packoffset(c4) = {1,1,1};
  float2 vScreenSize : packoffset(c5) = {1280,720};
  float4 vSpotParams : packoffset(c6) = {640,360,300,400};
  float fLimbDarkening : packoffset(c7) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c7.y) = {0};
  float fGamma : packoffset(c7.z) = {1};
}

SamplerState smplZ_s : register(s0);
SamplerState smplScene_s : register(s1);
SamplerState smplAdaptedLumCur_s : register(s2);
SamplerState smplBloom_s : register(s3);
SamplerState smplFlare_s : register(s4);
Texture2D<float4> smplZ_Tex : register(t0);
Texture2D<float4> smplScene_Tex : register(t1);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t2);
Texture2D<float4> smplBloom_Tex : register(t3);
Texture2D<float4> smplFlare_Tex : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0, 0, 1.000000, 0},
                              { 0, 1.000000, 0, 0},
                              { 1.000000, 0, 0, 0},
                              { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 1.000000, 0, 0},
                              { 1.000000, 0, 0, 0},
                              { 1.000000, 0, 1.000000, 0},
                              { 1.000000, 0, 1.000000, 0},
                              { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r1.x = cmp(fChromaAberraParam.x != 0.000000);
  if (r1.x != 0) {
    r1.xy = -fChromaAberraParam.xy * float2(-0.166666672,-0.166666672) + v1.xy;
    r1.z = smplZ_Tex.Sample(smplZ_s, v1.xy).x;
    r1.z = fChromaAberraParam.z + r1.z;
    r2.xy = nChromaAberraTypeIndex + int2(1,2);
    r1.w = nChromaAberraTypeIndex;
    r3.xyz = icb[r2.x+0].xyz + -icb[r1.w+0].xyz;
    r2.yzw = icb[r2.y+0].xyz + -icb[r2.x+0].xyz;
    r4.xyz = r0.xyz;
    r5.xyz = float3(1,1,1);
    r6.xy = r1.xy;
    r3.w = 1;
    while (true) {
      r4.w = cmp(3 < (int)r3.w);
      if (r4.w != 0) break;
      r4.w = smplZ_Tex.Sample(smplZ_s, r6.xy).x;
      r4.w = cmp(r1.z < r4.w);
      r7.xyz = smplScene_Tex.Sample(smplScene_s, r6.xy).xyz;
      if (r4.w != 0) {
        r4.w = (int)r3.w;
        r5.w = cmp(r4.w < 1.5);
        if (r5.w != 0) {
          r5.w = 0.666666687 * r4.w;
          r8.xyz = r5.www * r3.xyz + icb[r1.w+0].xyz;
        } else {
          r4.w = r4.w * 0.666666687 + -1;
          r8.xyz = r4.www * r2.yzw + icb[r2.x+0].xyz;
        }
        r4.xyz = r7.xyz * r8.xyz + r4.xyz;
        r5.xyz = r8.xyz + r5.xyz;
      }
      r6.xy = fChromaAberraParam.xy * float2(-0.166666672,-0.166666672) + r6.xy;
      r3.w = (int)r3.w + 1;
    }
    r0.xyz = r4.xyz / r5.xyz;
  }
  r1.x = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur_s, float2(0.25,0.5)).x;
  r1.yzw = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyz;
  r1.yzw = fBloomWeight * r1.yzw;
  r0.xyz = r0.xyz * r1.xxx + r1.yzw;
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