#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 12:47:41 2025

cbuffer _Globals : register(b0)
{
  float fFXAAEdgeThreshold : packoffset(c0) = {0.5};
  float fFXAAEdgeThresholdMin : packoffset(c0.y) = {0.5};
  float fFXAAEdgeSharpness : packoffset(c0.z) = {8};
  float fFXAAPixelRange : packoffset(c0.w) = {2};
  float4 vRecipScreenSize : packoffset(c1) = {0.000781250012,0.00138888892,0.000390625006,0.000694444461};
  float4 fChromaAberraParam : packoffset(c2) = {0,0,1,0};
  int nChromaAberraTypeIndex : packoffset(c3) = {0};
  float4 vViewInfo : packoffset(c4);
  float fDistantBlurZThreshold : packoffset(c5);
  float fFar : packoffset(c5.y);
  float fDistantBlurIntensity : packoffset(c5.z);
  float fKIDSDOFType : packoffset(c5.w) = {0};
  float fBloomWeight : packoffset(c6) = {0.5};
  float fLensFlareWeight : packoffset(c6.y) = {0.300000012};
  float2 SimulateHDRParams : packoffset(c6.z);
  float fSaturationScaleEx : packoffset(c7) = {1};
  float4 vLightShaftPower : packoffset(c8);
  float3 vColorScale : packoffset(c9) = {1,1,1};
  float3 vSaturationScale : packoffset(c10) = {1,1,1};
  float2 vScreenSize : packoffset(c11) = {1280,720};
  float4 vSpotParams : packoffset(c12) = {640,360,300,400};
  float fLimbDarkening : packoffset(c13) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c13.y) = {0};
  float fGamma : packoffset(c13.z) = {1};
}

SamplerState smplScene_s : register(s0);
SamplerState smplZ_s : register(s1);
SamplerState smplAdaptedLumCur_s : register(s2);
SamplerState smplBlurFront_s : register(s3);
SamplerState smplDOFMerge_s : register(s4);
SamplerState smplBlurBack_s : register(s5);
SamplerState smplBlurHexFront_s : register(s6);
SamplerState smplBlurHexBack_s : register(s7);
SamplerState smplBloom_s : register(s8);
SamplerState smplFlare_s : register(s9);
SamplerState smplLightShaftLinWork2_s : register(s10);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplZ_Tex : register(t1);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t2);
Texture2D<float4> smplBlurFront_Tex : register(t3);
Texture2D<float4> smplDOFMerge_Tex : register(t4);
Texture2D<float4> smplBlurBack_Tex : register(t5);
Texture2D<float4> smplBlurHexFront_Tex : register(t6);
Texture2D<float4> smplBlurHexBack_Tex : register(t7);
Texture2D<float4> smplBloom_Tex : register(t8);
Texture2D<float4> smplFlare_Tex : register(t9);
Texture2D<float4> smplLightShaftLinWork2_Tex : register(t10);


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

  r0.xy = float2(1,1) / vRecipScreenSize.xy;
  r0.zw = fFXAAPixelRange / r0.xy;
  r0.xy = float2(2,2) / r0.xy;
  r1.xy = cmp(v2.xy < float2(0,0));
  r1.z = (int)r1.y | (int)r1.x;
  r2.xy = cmp(float2(1,1) < v2.xy);
  r1.z = (int)r1.z | (int)r2.x;
  r1.z = (int)r2.y | (int)r1.z;
  r1.zw = r1.zz ? v1.xy : v2.xy;
  r3.xyz = smplScene_Tex.Sample(smplScene_s, r1.zw).xyz;
  r1.z = dot(r3.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r2.zw = cmp(v3.wz < float2(0,0));
  r1.xy = (int2)r1.xy | (int2)r2.zw;
  r1.x = (int)r2.x | (int)r1.x;
  r3.xy = cmp(float2(1,1) < v3.wz);
  r1.xy = (int2)r1.xy | (int2)r3.xy;
  r4.xw = v2.xy;
  r4.yz = v3.wz;
  r1.xw = r1.xx ? v1.xy : r4.xy;
  r5.xyz = smplScene_Tex.Sample(smplScene_s, r1.xw).xyz;
  r1.x = dot(r5.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r1.y = (int)r2.y | (int)r1.y;
  r1.yw = r1.yy ? v1.xy : r4.zw;
  r4.xyz = smplScene_Tex.Sample(smplScene_s, r1.yw).xyz;
  r1.y = dot(r4.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r1.w = (int)r2.z | (int)r2.w;
  r1.w = (int)r3.y | (int)r1.w;
  r1.w = (int)r3.x | (int)r1.w;
  r2.xy = r1.ww ? v1.xy : v3.zw;
  r2.xyz = smplScene_Tex.Sample(smplScene_s, r2.xy).xyz;
  r1.w = dot(r2.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r2.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r3.x = dot(r2.xyz, float3(0.222014993,0.706655025,0.0713300034));
  r3.z = min(r1.z, r1.x);
  r1.y = 0.00260416674 + r1.y;
  r3.yw = max(r1.zy, r1.xw);
  r4.x = min(r1.y, r1.w);
  r3.y = max(r3.w, r3.y);
  r3.z = min(r4.x, r3.z);
  r3.w = fFXAAEdgeThreshold * r3.y;
  r4.x = min(r3.z, r3.x);
  r3.w = max(fFXAAEdgeThresholdMin, r3.w);
  r3.x = max(r3.y, r3.x);
  r1.xz = r1.xw + -r1.yz;
  r1.y = r3.x + -r4.x;
  r1.y = cmp(r1.y >= r3.w);
  r4.x = r1.x + r1.z;
  r4.y = r1.x + -r1.z;
  r1.x = dot(r4.xy, r4.xy);
  r1.x = rsqrt(r1.x);
  r1.xz = r4.xy * r1.xx;
  r3.xw = -r1.xz * r0.zw + v1.xy;
  r4.xy = cmp(r3.xw < float2(0,0));
  r1.w = (int)r4.y | (int)r4.x;
  r4.xy = cmp(float2(1,1) < r3.xw);
  r1.w = (int)r1.w | (int)r4.x;
  r1.w = (int)r4.y | (int)r1.w;
  r3.xw = r1.ww ? v1.xy : r3.xw;
  r4.xyzw = smplScene_Tex.Sample(smplScene_s, r3.xw).xyzw;
  r0.zw = r1.xz * r0.zw + v1.xy;
  r3.xw = cmp(r0.zw < float2(0,0));
  r1.w = (int)r3.w | (int)r3.x;
  r3.xw = cmp(float2(1,1) < r0.zw);
  r1.w = (int)r1.w | (int)r3.x;
  r1.w = (int)r3.w | (int)r1.w;
  r0.zw = r1.ww ? v1.xy : r0.zw;
  r5.xyzw = smplScene_Tex.Sample(smplScene_s, r0.zw).xyzw;
  r0.z = min(abs(r1.x), abs(r1.z));
  r0.z = fFXAAEdgeSharpness * r0.z;
  r0.zw = r1.xz / r0.zz;
  r0.zw = max(float2(-2,-2), r0.zw);
  r0.zw = min(float2(2,2), r0.zw);
  r1.xz = -r0.zw * r0.xy + v1.xy;
  r3.xw = cmp(r1.xz < float2(0,0));
  r1.w = (int)r3.w | (int)r3.x;
  r3.xw = cmp(float2(1,1) < r1.xz);
  r1.w = (int)r1.w | (int)r3.x;
  r1.w = (int)r3.w | (int)r1.w;
  r1.xz = r1.ww ? v1.xy : r1.xz;
  r6.xyzw = smplScene_Tex.Sample(smplScene_s, r1.xz).xyzw;
  r0.xy = r0.zw * r0.xy + v1.xy;
  r0.zw = cmp(r0.xy < float2(0,0));
  r0.z = (int)r0.w | (int)r0.z;
  r1.xz = cmp(float2(1,1) < r0.xy);
  r0.z = (int)r0.z | (int)r1.x;
  r0.z = (int)r1.z | (int)r0.z;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xyzw = smplScene_Tex.Sample(smplScene_s, r0.xy).xyzw;
  if (r1.y != 0) {
    r1.xyzw = r5.xyzw + r4.xyzw;
    r0.xyzw = r6.xyzw + r0.xyzw;
    r4.xyzw = float4(0.25,0.25,0.25,0.25) * r1.xyzw;
    r2.xyzw = r0.xyzw * float4(0.25,0.25,0.25,0.25) + r4.xyzw;
    r0.x = dot(r2.xyz, float3(0.222014993,0.706655025,0.0713300034));
    r0.y = cmp(r0.x < r3.z);
    r0.x = cmp(r3.y < r0.x);
    r0.x = (int)r0.x | (int)r0.y;
    r0.yzw = float3(0.5,0.5,0.5) * r1.xyz;
    r2.xyz = r0.xxx ? r0.yzw : r2.xyz;
  }
  r0.x = cmp(fChromaAberraParam.x != 0.000000);
  if (r0.x != 0) {
    r0.xy = -fChromaAberraParam.xy * float2(-0.166666672,-0.166666672) + v1.xy;
    r0.z = smplZ_Tex.Sample(smplZ_s, v1.xy).x;
    r0.z = fChromaAberraParam.z + r0.z;
    r1.xy = nChromaAberraTypeIndex + int2(1,2);
    r0.w = nChromaAberraTypeIndex;
    r3.xyz = icb[r1.x+0].xyz + -icb[r0.w+0].xyz;
    r1.yzw = icb[r1.y+0].xyz + -icb[r1.x+0].xyz;
    r4.xyz = r2.xyz;
    r5.xyz = float3(1,1,1);
    r6.xy = r0.xy;
    r3.w = 1;
    while (true) {
      r4.w = cmp(3 < (int)r3.w);
      if (r4.w != 0) break;
      r4.w = smplZ_Tex.Sample(smplZ_s, r6.xy).x;
      r4.w = cmp(r0.z < r4.w);
      r7.xyz = smplScene_Tex.Sample(smplScene_s, r6.xy).xyz;
      if (r4.w != 0) {
        r4.w = (int)r3.w;
        r5.w = cmp(r4.w < 1.5);
        if (r5.w != 0) {
          r5.w = 0.666666687 * r4.w;
          r8.xyz = r5.www * r3.xyz + icb[r0.w+0].xyz;
        } else {
          r4.w = r4.w * 0.666666687 + -1;
          r8.xyz = r4.www * r1.yzw + icb[r1.x+0].xyz;
        }
        r4.xyz = r7.xyz * r8.xyz + r4.xyz;
        r5.xyz = r8.xyz + r5.xyz;
      }
      r6.xy = fChromaAberraParam.xy * float2(-0.166666672,-0.166666672) + r6.xy;
      r3.w = (int)r3.w + 1;
    }
    r2.xyz = r4.xyz / r5.xyz;
  }
  r0.x = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur_s, float2(0.25,0.5)).x;
  r0.yzw = r2.xyz * r0.xxx;
  r1.x = smplDOFMerge_Tex.Sample(smplDOFMerge_s, v1.xy).w;
  r1.y = cmp(fKIDSDOFType == 0.000000);
  if (r1.y != 0) {
    r1.y = cmp(r1.x < 0.5);
    if (r1.y == 0) {
      r1.yzw = smplBlurBack_Tex.Sample(smplBlurBack_s, v1.xy).xyz;
      r3.x = -0.5 + r1.x;
      r3.x = r3.x * -2 + 1;
      r3.x = max(0, r3.x);
      r3.x = 9.99999975e-06 + r3.x;
      r3.x = 1 / r3.x;
      r3.x = -1 + r3.x;
      r3.x = saturate(0.25 * r3.x);
      r1.yzw = -r2.xyz * r0.xxx + r1.yzw;
      r0.yzw = r3.xxx * r1.yzw + r0.yzw;
    }
    r3.xyzw = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyzw;
    r1.y = -0.5 + r3.w;
    r1.y = abs(r1.y) * -2 + 1;
    r1.y = max(0, r1.y);
    r1.y = 9.99999975e-06 + r1.y;
    r1.y = 1 / r1.y;
    r1.y = -1 + r1.y;
    r1.y = saturate(0.25 * r1.y);
    r3.xyz = r3.xyz + -r0.yzw;
    r1.yzw = r1.yyy * r3.xyz + r0.yzw;
  } else {
    r3.x = cmp(fKIDSDOFType == 1.000000);
    if (r3.x != 0) {
      r3.x = cmp(r1.x < 0.5);
      if (r3.x == 0) {
        r3.xyz = smplBlurHexBack_Tex.Sample(smplBlurHexBack_s, v1.xy).xyz;
        r1.x = -0.5 + r1.x;
        r1.x = r1.x * -2 + 1;
        r1.x = max(0, r1.x);
        r1.x = 9.99999975e-06 + r1.x;
        r1.x = 1 / r1.x;
        r1.x = -1 + r1.x;
        r1.x = saturate(0.25 * r1.x);
        r3.xyz = -r2.xyz * r0.xxx + r3.xyz;
        r0.yzw = r1.xxx * r3.xyz + r0.yzw;
      }
      r3.xyzw = smplBlurHexFront_Tex.Sample(smplBlurHexFront_s, v1.xy).xyzw;
      r1.x = -0.5 + r3.w;
      r1.x = abs(r1.x) * -2 + 1;
      r1.x = max(0, r1.x);
      r1.x = 9.99999975e-06 + r1.x;
      r1.x = 1 / r1.x;
      r1.x = -1 + r1.x;
      r1.x = saturate(0.25 * r1.x);
      r3.xyz = r3.xyz + -r0.yzw;
      r1.yzw = r1.xxx * r3.xyz + r0.yzw;
    } else {
      r1.x = smplZ_Tex.Sample(smplZ_s, v1.xy).x;
      r1.x = vViewInfo.z + r1.x;
      r1.x = -vViewInfo.w / r1.x;
      r1.x = -fDistantBlurZThreshold + r1.x;
      r3.x = fFar + -fDistantBlurZThreshold;
      r1.x = saturate(r1.x / r3.x);
      r1.x = saturate(fDistantBlurIntensity * r1.x);
      r1.x = sqrt(r1.x);
      r3.xyz = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyz;
      r3.xyz = -r2.xyz * r0.xxx + r3.xyz;
      r1.yzw = r1.xxx * r3.xyz + r0.yzw;
    }
  }
  r0.xyz = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyz;
  r0.xyz = r0.xyz * fBloomWeight + r1.yzw;
  r1.xyz = smplFlare_Tex.Sample(smplFlare_s, v1.xy).xyz;
  r0.xyz = r1.xyz * fLensFlareWeight + r0.xyz;
  r1.xyz = smplLightShaftLinWork2_Tex.Sample(smplLightShaftLinWork2_s, v1.xy).xyz;
  r0.xyz = r1.xyz * vLightShaftPower.xyz + r0.xyz;
  r1.xyz = vColorScale.xyz * r0.xyz;
  r0.w = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz * vColorScale.xyz + -r0.www;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r0.www;
  r1.xy = v1.xy * vScreenSize.xy + -vSpotParams.xy;
  r0.w = dot(r1.xy, r1.xy);
  r1.x = sqrt(r0.w);
  r1.x = -vSpotParams.z + r1.x;
  r1.y = cmp(0 >= r1.x);
  r1.x = saturate(vSpotParams.w / r1.x);
  r1.x = r1.y ? 1 : r1.x;
  r0.w = fLimbDarkening + r0.w;
  r0.w = fLimbDarkening / r0.w;
  r0.w = r0.w * r0.w;
  r1.yzw = r0.www * r0.xyz;
  r1.xyz = r1.yzw * r1.xxx;
  r0.w = 1 + -fLimbDarkeningWeight;
  r1.xyz = fLimbDarkeningWeight * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  
  PreTonemap(r0.xyz, SimulateHDRParams.x);

  r1.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r3.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r0.xyz = r0.xyz * r3.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r0.xyz;
  r0.xyz = SimulateHDRParams.xxx * r0.xyz;

  PostTonemap(r0.xyz, fGamma);

  r0.xyz = log2(r0.xyz);
  r0.xyz = fGamma * r0.xyz;
  r0.xyz = exp2(r0.xyz);

  PreSaturationScaleEx(r0.xyz, fGamma, fSaturationScaleEx);

  r0.w = cmp(fSaturationScaleEx == 1.000000);
  r1.x = cmp(1 < fSaturationScaleEx);
  r1.y = min(r0.y, r0.z);
  r1.y = min(r1.y, r0.x);
  r1.z = max(r0.y, r0.z);
  r1.z = max(r1.z, r0.x);
  r1.y = r1.z + r1.y;
  r1.y = -r1.y * 0.5 + 1;
  r1.z = -1 + fSaturationScaleEx;
  r1.y = r1.y * r1.z + 1;
  r1.x = r1.x ? r1.y : fSaturationScaleEx;
  r1.y = dot(r0.xyz, float3(0.298909992,0.586610019,0.114480004));
  r3.xyz = -r1.yyy + r0.xyz;
  r1.xyz = r1.xxx * r3.xyz + r1.yyy;
  r2.xyz = r0.www ? r0.xyz : r1.xyz;
  o0.xyzw = r2.xyzw;
  
  OutColorAdjustments(o0, fSaturationScaleEx);

  return;
}