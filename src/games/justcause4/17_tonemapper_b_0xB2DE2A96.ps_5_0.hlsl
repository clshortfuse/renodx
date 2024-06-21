#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t9 : register(t9);
Texture3D<float4> t10 : register(t10);

SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb0 : register(b0) {
  float4 cb0[17];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float4 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[12].xy * v1.xy;
  r0.xy = min(cb0[12].zw, r0.xy);
  r0.zw = cb0[13].xy * v1.xy;
  r0.zw = min(cb0[13].zw, r0.zw);
  r1.xy = cb0[15].xy * v1.xy;
  r1.xy = min(cb0[15].zw, r1.xy);
  r2.xyz = t1.Sample(s2_s, r0.zw).xyz;
  r3.xyz = t3.Sample(s2_s, r0.zw).xyz;
  r1.xyz = t4.Sample(s2_s, r1.xy).xyz;
  r0.xyz = t0.Sample(s2_s, r0.xy).xyz;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = cb0[11].zzz * r2.xyz + r0.xyz;
  r2.xyz = t9.Sample(s3_s, v1.xy).xyz;
  r2.xyz = r2.xyz * cb0[2].zzz + cb0[2].yyy;
  r1.xyz = r2.xyz * r1.xyz * injectedData.fxLensFlare;
  r1.xyz = r3.xyz * cb0[2].xxx * injectedData.fxBloom + r1.xyz;
  r0.xyz = r0.xyz * cb0[1].xxx + r1.xyz;
  r0.w = cmp(cb0[11].y == 0.000000);
  if (r0.w != 0) {
    r1.xyz = t8.Sample(s2_s, v1.xy).xyz;
    r1.xyz = float3(-1, -1, -1) + r1.xyz;
    r1.xyz = cb0[1].yyy * r1.xyz + float3(1, 1, 1);
    r1.xyz = lerp(1.f, r1.xyz, injectedData.fxVignette) * r0.xyz;
  } else {
    r2.xy = v1.xy * float2(2, 2) + float2(-1, -1);
    r2.xy = abs(r2.xy) * float2(0.5, 0.5) + float2(0.5, 0.5);
    r2.xy = float2(1, 1) + -r2.xy;
    r2.xyz = t8.Sample(s2_s, r2.xy).xyz;
    r2.xyz = r2.xyz * r2.xyz + float3(-1, -1, -1);
    r2.xyz = cb0[1].yyy * r2.xyz + float3(1, 1, 1);
    r1.xyz = lerp(1.f, r2.xyz, injectedData.fxVignette) * r0.xyz;
  }

  float3 untonemapped = r1.xyz * 0.5f;

  float vanillaMidGray = 0.18f;

  float renoDRTContrast = 1.0f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = 0.5f;
  float renoDRTSaturation = 1.0f;
  float renoDRTHighlights = 1.0f;

  ToneMapParams tmParams = buildToneMapParams(
    injectedData.toneMapType,
    injectedData.toneMapPeakNits,
    injectedData.toneMapGameNits,
    injectedData.toneMapGammaCorrection,  // -1 == srgb
    injectedData.colorGradeExposure,
    injectedData.colorGradeHighlights,
    injectedData.colorGradeShadows,
    injectedData.colorGradeContrast,
    injectedData.colorGradeSaturation,
    vanillaMidGray,
    vanillaMidGray * 100.f,
    renoDRTHighlights,
    renoDRTShadows,
    renoDRTContrast,
    renoDRTSaturation,
    renoDRTDechroma,
    renoDRTFlare
  );
  LUTParams lutParams = buildLUTParams(
    s2_s,
    injectedData.colorGradeLUTStrength,
    injectedData.colorGradeLUTScaling,
    TONE_MAP_LUT_TYPE__2_0,
    TONE_MAP_LUT_TYPE__2_0,
    16.f
  );

  if (injectedData.toneMapType == 0.f) {
    r0.xyz = cb0[8].xxx * r1.xyz;
    r0.xyz = cb0[8].zzz * cb0[8].yyy + r0.xyz;
    r2.xy = cb0[9].xy * cb0[8].ww;
    r0.xyz = r1.xyz * r0.xyz + r2.xxx;
    r2.xzw = cb0[8].xxx * r1.xyz + cb0[8].yyy;
    r1.xyz = r1.xyz * r2.xzw + r2.yyy;
    r0.xyz = r0.xyz / r1.xyz;
    r0.w = cb0[9].x / cb0[9].y;
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = cb0[3].www * r0.xyz;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r0.xyz = min(float3(1, 1, 1), r0.xyz);
    r1.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r0.xyz = saturate(cb0[0].xyz * r0.xyz);
    r0.xyz = sqrt(r0.xyz);
    r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
    r0.xyz = t10.Sample(s2_s, r0.xyz).xyz;
    r0.xyz = r0.xyz * r0.xyz;
  } else {
    r0.xyz = toneMap(untonemapped, tmParams, lutParams, t10);
  }

  if (injectedData.toneMapGammaCorrection) {
    r0.xyz = gammaCorrectSafe(r0.xyz);
  }
  r0.xyz = r0.xyz * cb0[10].xxx + cb0[10].yyy;
  r0.w = r0.w / r1.x;
  r0.w = cb0[11].w * r0.w;
  r1.xyz = r0.xyz * r0.www;
  r0.xyz = cb0[16].xxx ? r1.xyz : r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.w = sqrt(r0.w);
  o0.xyz = r0.xyz;
  o0.rgb *= injectedData.toneMapGameNits / 80.f;

  return;
}
