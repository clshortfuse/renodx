// ---- Created with 3Dmigoto v1.3.16 on Sat Oct 12 19:43:23 2024
// Tonemapper -- All effects on
// 

#include "./shared.h"
#include "./tonemapper.hlsl"

cbuffer _Globals : register(b0) {
  float4 vTexUVOffset : packoffset(c0);
  int nSceneID : packoffset(c1);
  float fExposure : packoffset(c1.y);
  float2 vReverseZParam : packoffset(c1.z) = { 1, 0 };
  float4 vViewInfo : packoffset(c2);
  float fDistantBlurZThreshold : packoffset(c3);
  float fFar : packoffset(c3.y);
  float fDistantBlurIntensity : packoffset(c3.z);
  float fBloomWeight : packoffset(c3.w);
  float4 vLightShaftPower : packoffset(c4);
  float4 vColorScale : packoffset(c5);
  float4 vSaturationScale : packoffset(c6);
  float4 vScreen : packoffset(c7);
  float4 vSpotParams : packoffset(c8);
  float fLimbDarkening : packoffset(c9);
  float fLimbDarkeningWeight : packoffset(c9.y);
  float fToneMapInvWhitePoint : packoffset(c9.z);
}

SamplerState smplAdaptedLumLast_s : register(s0);
SamplerState smplDepth_s : register(s1);
SamplerState smplBlur_s : register(s2);
SamplerState smplBloom_s : register(s3);
SamplerState smplLightShaftLinWork2_s : register(s4);
SamplerState smplFXAA_s : register(s5);
Texture2D<float4> smplAdaptedLumLast_Tex : register(t0);
Texture2D<float4> smplDepth_Tex : register(t1);
Texture2D<float4> smplBlur_Tex : register(t2);
Texture2D<float4> smplBloom_Tex : register(t3);
Texture2D<float4> smplLightShaftLinWork2_Tex : register(t4);
Texture2D<float4> smplFXAA_Tex : register(t5);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * vTexUVOffset.zw + vTexUVOffset.xy;
  r0.z = smplDepth_Tex.Sample(smplDepth_s, r0.xy).x;
  r1.xyzw = smplFXAA_Tex.Sample(smplFXAA_s, r0.xy).xyzw;
  r0.x = vReverseZParam.x * r0.z + vReverseZParam.y;
  r0.x = vViewInfo.z + -r0.x;
  r0.x = vViewInfo.w / r0.x;
  r0.x = -fDistantBlurZThreshold + r0.x;
  r0.y = fFar + -fDistantBlurZThreshold;
  r0.x = saturate(r0.x / r0.y);
  r0.x = saturate(fDistantBlurIntensity * r0.x);
  r0.x = sqrt(r0.x);
  r0.y = nSceneID;
  r0.y = 0.5 + r0.y;
  r2.x = 0.5 * r0.y;
  r2.y = 0.5;

  r0.y = smplAdaptedLumLast_Tex.Sample(smplAdaptedLumLast_s, r2.xy).x;
  // r2.xyz = max(float3(0, 0, 0), r1.xyz); //709 clamp
  r2.rgb = r1.rgb;  // Rewrite of above with no max/clamp

  r2.xyz = fExposure * r2.xyz;
  r1.xyz = r2.xyz * r0.yyy;

  r2.xyzw = smplBlur_Tex.Sample(smplBlur_s, v1.xy).xyzw;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r0.xyzw = r0.xxxx * r2.xyzw + r1.xyzw;

  if (injectedData.fxBloom) {  // Enable/disable bloom
    r1.xyz = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyz;
    r0.xyz = r1.xyz * (fBloomWeight * injectedData.fxBloom) + r0.xyz;  // Control Bloom Strength
  }

  o0.w = r0.w;
  r1.xyz = smplLightShaftLinWork2_Tex.Sample(smplLightShaftLinWork2_s, v1.xy).xyz;
  r0.xyz = r1.xyz * vLightShaftPower.xyz + r0.xyz;
  r0.w = dot(float3(0.298909992, 0.586610019, 0.114480004), r0.xyz);
  r0.xyz = r0.xyz * vColorScale.xyz + -r0.www;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r0.www;
  r1.xy = v1.xy * vScreen.xy + -vSpotParams.xy;
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

  r0.xyz = r0.xyz * r0.www + r1.xyz;  // Untonemapped
  float3 untonemapped = r0.rgb;
  // r0.xyz = max(float3(0,0,0), r0.xyz); // Clamp

  // vanilla tonemapper, hable
  r1.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.0299999993, 0.0299999993, 0.0299999993);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009, 0.00200000009, 0.00200000009);
  r2.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.300000012, 0.300000012, 0.300000012);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0333000012, -0.0333000012, -0.0333000012) + r0.xyz;
  r0.rgb = fToneMapInvWhitePoint * r0.xyz;
  float3 vanillaColor = r0.rgb;

  // Second hable run for midGray
  r0.rgb = (0.18f, 0.18f, 0.18f);

  r1.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.0299999993, 0.0299999993, 0.0299999993);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009, 0.00200000009, 0.00200000009);
  r2.xyz = r0.xyz * float3(0.219999999, 0.219999999, 0.219999999) + float3(0.300000012, 0.300000012, 0.300000012);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0333000012, -0.0333000012, -0.0333000012) + r0.xyz;
  r0.rgb = fToneMapInvWhitePoint * r0.xyz;

  float3 vanMidGray = r0.rgb;

  o0.rgb = applyUserTonemap(untonemapped.rgb, vanillaColor, renodx::color::y::from::BT709(vanMidGray));
  // o0.rgb = fast_reinhard(untonemapped.rgb, injectedData.toneMapPeakNits / injectedData.toneMapGameNits, 0, vanMidGray.r);

  o0.xyz = renodx::color::correct::GammaSafe(o0.xyz);                   // sRGB -> pow2.2
  o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;  // scale output by gamenits / ui nits -- will restore in the final shader
  o0.xyz = renodx::color::correct::GammaSafe(o0.xyz, true);             // pow2.2 -> sRGB

  return;
}
