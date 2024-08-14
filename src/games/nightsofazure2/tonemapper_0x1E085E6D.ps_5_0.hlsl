// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 11 16:49:28 2024
// Main tonemapper for DoF on

#include "./shared.h"
#include "./tonemapper.hlsl" //Include our custom tonemapper

cbuffer _Globals : register(b0)
{
  float fFXAAEdgeThresholdMin : packoffset(c0) = {0.5};
  float fFXAAEdgeThreshold : packoffset(c0.y) = {0.5};
  float fFXAAEdgeSharpness : packoffset(c0.z) = {8};
  float fFXAAPixelRange : packoffset(c0.w) = {2};
  float4 vRecipScreenSize : packoffset(c1) = {0.000781250012,0.00138888892,0.000390625006,0.000694444461};
  float4 vViewInfo : packoffset(c2);
  float fDistantBlurZThreshold : packoffset(c3);
  float fFar : packoffset(c3.y);
  float fDistantBlurIntensity : packoffset(c3.z);
  float2 SimulateHDRParams : packoffset(c4);
  float fKIDSToneCurveType : packoffset(c4.z) = {0.100000001};
  float fKIDSDOFType : packoffset(c4.w) = {0};
  float fBloomWeight : packoffset(c5) = {0.5};
  float fStarWeight : packoffset(c5.y) = {0.800000012};
  float fLensFlareWeight : packoffset(c5.z) = {0.300000012};
  float4 vLightShaftPower : packoffset(c6);
  float3 vColorScale : packoffset(c7) = {1,1,1};
  float3 vSaturationScale : packoffset(c8) = {1,1,1};
  float2 vScreenSize : packoffset(c9) = {1280,720};
  float4 vSpotParams : packoffset(c10) = {640,360,300,400};
  float fLimbDarkening : packoffset(c11) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c11.y) = {0};
  float fGamma : packoffset(c11.z) = {1};
}

SamplerState smplScene_s : register(s0);
SamplerState smplZ_s : register(s1);
SamplerState smplBlurFront_s : register(s2);
SamplerState smplAdaptedLumCur_s : register(s3);
SamplerState smplDOFMerge_s : register(s4);
SamplerState smplBlurBack_s : register(s5);
SamplerState smplBlurHexFront_s : register(s6);
SamplerState smplBlurHexBack_s : register(s7);
SamplerState smplBloom_s : register(s8);
SamplerState smplStar_s : register(s9);
SamplerState smplFlare_s : register(s10);
SamplerState smplLightShaftLinWork2_s : register(s11);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplZ_Tex : register(t1);
Texture2D<float4> smplBlurFront_Tex : register(t2);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t3);
Texture2D<float4> smplDOFMerge_Tex : register(t4);
Texture2D<float4> smplBlurBack_Tex : register(t5);
Texture2D<float4> smplBlurHexFront_Tex : register(t6);
Texture2D<float4> smplBlurHexBack_Tex : register(t7);
Texture2D<float4> smplBloom_Tex : register(t8);
Texture2D<float4> smplStar_Tex : register(t9);
Texture2D<float4> smplFlare_Tex : register(t10);
Texture2D<float4> smplLightShaftLinWork2_Tex : register(t11);


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

  r0.xyz = smplScene_Tex.Sample(smplScene_s, v1.xy).xyz;

  //fxaa
  r1.xy = smplScene_Tex.Sample(smplScene_s, v2.xy).xy;
  r1.zw = smplScene_Tex.Sample(smplScene_s, v2.zw).xy;
  r2.xy = smplScene_Tex.Sample(smplScene_s, v3.xy).xy;
  r2.zw = smplScene_Tex.Sample(smplScene_s, v3.zw).xy;
  r0.w = r0.y * 1.9632107 + r0.x;
  r3.z = r1.y * 1.9632107 + r1.x;
  r3.w = r1.w * 1.9632107 + r1.z;
  r3.y = r2.y * 1.9632107 + r2.x;
  r3.x = r2.w * 1.9632107 + r2.z;
  r1.xy = min(r3.zy, r3.wx);
  r1.x = min(r1.x, r1.y);
  r1.x = min(r1.x, r0.w);
  r1.yz = max(r3.zy, r3.wx);
  r1.y = max(r1.y, r1.z);
  r0.w = max(r1.y, r0.w);
  r1.y = r0.w + -r1.x;
  r1.z = fFXAAEdgeThreshold * r0.w;
  r1.z = max(fFXAAEdgeThresholdMin, r1.z);
  r1.y = cmp(r1.y < r1.z);
  r2.xyzw = r3.yzzw + r3.xwyx;
  r1.zw = r2.xz + -r2.yw;
  r2.x = dot(r1.zw, r1.zw);
  r2.x = max(1.00000001e-07, r2.x);
  r2.x = sqrt(r2.x);
  r1.zw = r1.zw / r2.xx;
  r2.x = min(abs(r1.z), abs(r1.w));
  r2.x = r2.x * fFXAAEdgeSharpness + 0.00100000005;
  r2.xy = r1.zw / r2.xx;
  r2.xy = max(-fFXAAPixelRange, r2.xy);
  r2.xy = min(fFXAAPixelRange, r2.xy);
  r2.zw = vRecipScreenSize.xy * fFXAAPixelRange;
  r3.xy = vRecipScreenSize.zw * r1.zw;
  r3.zw = r2.xy * r2.zw;
  r2.xyzw = v1.xyxy + -r3.xyzw;
  r3.xyzw = v1.xyxy + r3.xyzw;
  r4.xyz = smplScene_Tex.Sample(smplScene_s, r2.xy).xyz;
  r5.xyz = smplScene_Tex.Sample(smplScene_s, r3.xy).xyz;
  r2.xyz = smplScene_Tex.Sample(smplScene_s, r2.zw).xyz;
  r3.xyz = smplScene_Tex.Sample(smplScene_s, r3.zw).xyz;
  if (r1.y == 0) {
    r1.yzw = r5.xyz + r4.xyz;
    r4.xyz = float3(0.5,0.5,0.5) * r1.yzw;
    r2.xyz = r3.xyz + r2.xyz;
    r2.xyz = float3(0.25,0.25,0.25) * r2.xyz;
    r1.yzw = r1.yzw * float3(0.25,0.25,0.25) + r2.xyz;
    r2.x = r1.z * 1.9632107 + r1.y;
    r1.x = cmp(r2.x < r1.x);
    r0.w = cmp(r0.w < r2.x);
    r0.w = (int)r0.w | (int)r1.x;
    r0.xyz = r0.www ? r4.xyz : r1.yzw;
  }
  r0.w = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur_s, float2(0.25,0.5)).x;
  r0.xyz = r0.xyz * r0.www;
  r0.w = smplDOFMerge_Tex.Sample(smplDOFMerge_s, v1.xy).w;
  r1.xy = cmp(fKIDSDOFType == float2(0,0));
  if (r1.x != 0) {
    r2.xyzw = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyzw;
    r3.xyzw = smplBlurBack_Tex.Sample(smplBlurBack_s, v1.xy).xyzw;
    r1.x = cmp(r0.w < 0.5);
    r1.z = -0.5 + r0.w;
    r1.z = abs(r1.z) * -2 + 1;
    r1.z = max(0, r1.z);
    r1.z = 9.99999975e-06 + r1.z;
    r1.z = 1 / r1.z;
    r1.z = -1 + r1.z;
    r1.z = saturate(0.25 * r1.z);
    r3.xyzw = r1.xxxx ? r0.xyzw : r3.xyzw;
    r3.xyzw = r3.xyzw + -r0.xyzw;
    r3.xyzw = r1.zzzz * r3.xyzw + r0.xyzw;
    r1.x = -0.5 + r2.w;
    r1.x = abs(r1.x) * -2 + 1;
    r1.x = max(0, r1.x);
    r1.x = 9.99999975e-06 + r1.x;
    r1.x = 1 / r1.x;
    r1.x = -1 + r1.x;
    r1.x = saturate(0.25 * r1.x);
    r2.xyzw = -r3.xyzw + r2.xyzw;
    r2.xyzw = r1.xxxx * r2.xyzw + r3.xyzw;
    o0.w = r2.w;
  } else {
    r1.x = cmp(fKIDSDOFType == 1.000000);
    if (r1.x != 0) {
      r3.xyzw = smplBlurHexFront_Tex.Sample(smplBlurHexFront_s, v1.xy).xyzw;
      r4.xyzw = smplBlurHexBack_Tex.Sample(smplBlurHexBack_s, v1.xy).xyzw;
      r1.x = cmp(r0.w < 0.5);
      r1.z = -0.5 + r0.w;
      r1.z = abs(r1.z) * -2 + 1;
      r1.z = max(0, r1.z);
      r1.z = 9.99999975e-06 + r1.z;
      r1.z = 1 / r1.z;
      r1.z = -1 + r1.z;
      r1.z = saturate(0.25 * r1.z);
      r4.xyzw = r1.xxxx ? r0.xyzw : r4.xyzw;
      r4.xyzw = r4.xyzw + -r0.xyzw;
      r4.xyzw = r1.zzzz * r4.xyzw + r0.xyzw;
      r1.x = -0.5 + r3.w;
      r1.x = abs(r1.x) * -2 + 1;
      r1.x = max(0, r1.x);
      r1.x = 9.99999975e-06 + r1.x;
      r1.x = 1 / r1.x;
      r1.x = -1 + r1.x;
      r1.x = saturate(0.25 * r1.x);
      r3.xyzw = -r4.xyzw + r3.xyzw;
      r2.xyzw = r1.xxxx * r3.xyzw + r4.xyzw;
      o0.w = r2.w;
    } else {
      r1.x = smplZ_Tex.Sample(smplZ_s, v1.xy).x;
      r1.x = vViewInfo.z + r1.x;
      r1.x = -vViewInfo.w / r1.x;
      r1.x = -fDistantBlurZThreshold + r1.x;
      r1.z = fFar + -fDistantBlurZThreshold;
      r1.x = saturate(r1.x / r1.z);
      r1.x = saturate(fDistantBlurIntensity * r1.x);
      r1.x = sqrt(r1.x);
      r3.xyzw = smplBlurFront_Tex.Sample(smplBlurFront_s, v1.xy).xyzw;
      r3.xyzw = r3.xyzw + -r0.xyzw;
      r2.xyzw = r1.xxxx * r3.xyzw + r0.xyzw;
      o0.w = r2.w;
    }
  } //fxaa end
    if (injectedData.bloom){  
  r0.xyz = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyz;
  r0.xyz = r0.xyz * (fBloomWeight * injectedData.fxBloom) + r2.xyz;
    }
  r1.xzw = smplStar_Tex.Sample(smplStar_s, v1.xy).xyz;
  r0.xyz = r1.xzw * fStarWeight + r0.xyz;
  
  r1.xzw = smplFlare_Tex.Sample(smplFlare_s, v1.xy).xyz;
  r0.xyz = r1.xzw * fLensFlareWeight + r0.xyz;
  
  r1.xzw = smplLightShaftLinWork2_Tex.Sample(smplLightShaftLinWork2_s, v1.xy).xyz;
  r0.xyz = r1.xzw * vLightShaftPower.xyz + r0.xyz;
  
  r1.xzw = vColorScale.xyz * r0.xyz;
  r0.w = dot(r1.xzw, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz * vColorScale.xyz + -r0.www;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r0.www;
  r1.xz = v1.xy * vScreenSize.xy + -vSpotParams.xy;
  r0.w = dot(r1.xz, r1.xz);
  r1.x = sqrt(r0.w);
  r1.x = -vSpotParams.z + r1.x;
  r1.z = cmp(0 >= r1.x);
  r1.x = saturate(vSpotParams.w / r1.x);
  r1.x = r1.z ? 1 : r1.x;
  r0.w = fLimbDarkening + r0.w;
  r0.w = fLimbDarkening / r0.w;
  r0.w = r0.w * r0.w;
  r2.xyz = r0.www * r0.xyz;
  r1.xzw = r2.xyz * r1.xxx;
  r0.w = 1 + -fLimbDarkeningWeight;
  r1.xzw = fLimbDarkeningWeight * r1.xzw;
  r0.xyz = r0.xyz * r0.www + r1.xzw;
  
    float3 untonemapped = r0.rgb;
  //hable
  r1.xzw = r0.xyz * SimulateHDRParams.xxx + float3(1,1,1);
  r2.xyz = float3(1,1,1) + r0.xyz;
  r1.xzw = r1.xzw / r2.xyz;
  r1.xzw = r1.xzw * r0.xyz;
  r2.xy = cmp(fKIDSToneCurveType < float2(0.300000012,0.200000003));
  r3.xyzw = r2.yyyy ? float4(0.219999999,0.300000012,0.0299999993,0.00200000009) : float4(0.150000006,0.5,0.0500000007,0.00400000019);
  r4.xyz = r3.xxx * r0.xyz + r3.zzz;
  r4.xyz = r0.xyz * r4.xyz + r3.www;
  r3.xyz = r3.xxx * r0.xyz + r3.yyy;
  r3.xyz = r0.xyz * r3.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r3.xyz = r4.xyz / r3.xyz;
  r0.w = r2.y ? -0.0333000012 : -0.0670000017;
  r2.yzw = r3.xyz + r0.www;
  r0.xyz = r2.xxx ? r2.yzw : r0.xyz;
  r0.xyz = SimulateHDRParams.xxx * r0.xyz;
  r0.xyz = r1.yyy ? r1.xzw : r0.xyz;
 // r0.xyz = log2(r0.xyz);
 // r0.xyz = fGamma * r0.xyz;
 // o0.xyz = exp2(r0.xyz);
 //original tonemapper end   
    float3 vanillaColor = r0.xyz;
    
    //second hable run for midgray
    r0.rgb = (0.18f, 0.18f, 0.18f);
    
    r1.xzw = r0.xyz * SimulateHDRParams.xxx + float3(1, 1, 1);
    r2.xyz = float3(1, 1, 1) + r0.xyz;
    r1.xzw = r1.xzw / r2.xyz;
    r1.xzw = r1.xzw * r0.xyz;
    r2.xy = cmp(fKIDSToneCurveType < float2(0.300000012, 0.200000003));
    r3.xyzw = r2.yyyy ? float4(0.219999999, 0.300000012, 0.0299999993, 0.00200000009) : float4(0.150000006, 0.5, 0.0500000007, 0.00400000019);
    r4.xyz = r3.xxx * r0.xyz + r3.zzz;
    r4.xyz = r0.xyz * r4.xyz + r3.www;
    r3.xyz = r3.xxx * r0.xyz + r3.yyy;
    r3.xyz = r0.xyz * r3.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
    r3.xyz = r4.xyz / r3.xyz;
    r0.w = r2.y ? -0.0333000012 : -0.0670000017;
    r2.yzw = r3.xyz + r0.www;
    r0.xyz = r2.xxx ? r2.yzw : r0.xyz;
    r0.xyz = SimulateHDRParams.xxx * r0.xyz;
    r0.xyz = r1.yyy ? r1.xzw : r0.xyz;
    
    float3 vanMidGray = r0.rgb;
 // second hable run end
    
    float3 outputColor;
    
    outputColor = applyUserTonemap(untonemapped, vanillaColor, renodx::color::y::from::BT709(vanMidGray)); //Apply our custom tonemapper from tonemapper.hlsl
    
    outputColor = renodx::math::SafePow(outputColor, fGamma); //fGamma first [inverse 2.2]
    
    o0.rgb = outputColor;
    
  return;
}