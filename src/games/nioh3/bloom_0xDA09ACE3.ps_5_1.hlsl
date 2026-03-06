// ---- Created with 3Dmigoto v1.3.16 on Thu Mar  5 20:58:49 2026

#include "./common.hlsl"

cbuffer cbComposite : register(b2) {
  float4 g_vSceneTexSize : packoffset(c0);
  float4 g_vCompositeInfo : packoffset(c1);
  float4 g_vSun2dInfo : packoffset(c2);
  float4 g_vEtcEffect : packoffset(c3);
  float4 g_vBloomInfo : packoffset(c4);
  float4 g_vLimbDarkenningInfo : packoffset(c5);
  float4 g_vFxaaParams : packoffset(c6);
  float4 g_vGammaCorrection : packoffset(c7);
  float4 g_vRadialBlurCenter : packoffset(c8);
  float4 g_vRadialBlurInfo : packoffset(c9);
  float4 g_vFxaaQualityParams : packoffset(c10);
  float4 g_vCompositeLastViewport : packoffset(c11);
  float4 g_vMaxUV : packoffset(c12);
  float4 g_vMinUV : packoffset(c13);
  float4 g_vP2V : packoffset(c14);
  float4x4 g_mV2W : packoffset(c15);
  float4 g_vDramaticHdrLutInfo0[2] : packoffset(c19);
  float4 g_vDramaticHdrLutInfo1[2] : packoffset(c21);
  float4 g_vDrawFixParams : packoffset(c23);
  float4 g_vDistortionParams : packoffset(c24);
  float4 g_vVerticalLimbDarkenningTopInfo : packoffset(c25);
  float4 g_vVerticalLimbDarkenningBottomInfo : packoffset(c26);
}

SamplerState sampleLinear_s : register(s7);
Texture2D<float4> g_tBloomMap : register(t1);
Texture2D<float4> g_tExposureScaleInfo : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1;
  r0.z = g_vBloomInfo.z;
  r0.xyzw = g_vBloomInfo.xyxy * r0.xxzz;
  r1.x = g_vBloomInfo.z;
  r1.zw = float2(-1, 0);
  r2.xyzw = r0.xyzy * r1.xxzx + v1.xyxy;
  r0.xyzw = r0.xwzw * r1.xwzw + v1.xyxy;
  r1.xyz = g_tBloomMap.SampleLevel(sampleLinear_s, r2.xy, 0).xyz;
  r2.xyz = g_tBloomMap.SampleLevel(sampleLinear_s, r2.zw, 0).xyz;
  r2.xyz = min(float3(65024, 65024, 65024), r2.xyz);
  r1.xyz = min(float3(65024, 65024, 65024), r1.xyz);
  r1.xyz = r1.xyz + r2.xyz;
  r2.xyz = g_tBloomMap.SampleLevel(sampleLinear_s, v1.xy, 0).xyz;
  r2.xyz = min(float3(65024, 65024, 65024), r2.xyz);
  r1.xyz = r2.xyz * float3(2, 2, 2) + r1.xyz;
  r2.xyz = g_tBloomMap.SampleLevel(sampleLinear_s, r0.xy, 0).xyz;
  r0.xyz = g_tBloomMap.SampleLevel(sampleLinear_s, r0.zw, 0).xyz;
  r0.xyz = min(float3(65024, 65024, 65024), r0.xyz);
  r2.xyz = min(float3(65024, 65024, 65024), r2.xyz);
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.w = cmp(g_vCompositeInfo.z < 0);
  r1.x = g_tExposureScaleInfo.Load(float4(1, 0, 0, 0)).x;
  r0.w = r0.w ? r1.x : 1;
  r0.w = g_vBloomInfo.w * r0.w;

  // Bloom strength
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = r0.xyz * (r0.w * saturate(FX_BLOOM_STRENGTH));  // Bloom Strength
  } else {
    r0.xyz = r0.xyz * r0.www;
  }
  o0.xyz = float3(0.166666672, 0.166666672, 0.166666672) * r0.xyz;
  o0.w = 1;
  return;
}
