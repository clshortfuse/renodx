// Found in Like a Dragon Ishin
// UE 4.27 HDR10 Ini HDR

#include "./composite.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Fri Feb 13 03:12:15 2026

cbuffer _Globals : register(b0) {
  float3 InverseGamma : packoffset(c0);
  float4 ColorMatrixR_ColorCurveCd1 : packoffset(c1);
  float4 ColorMatrixG_ColorCurveCd3Cm3 : packoffset(c2);
  float4 ColorMatrixB_ColorCurveCm2 : packoffset(c3);
  float4 ColorCurve_Cm0Cd0_Cd2_Ch0Cm1_Ch3 : packoffset(c4);
  float4 ColorCurve_Ch1_Ch2 : packoffset(c5);
  float4 ColorShadow_Luma : packoffset(c6);
  float4 ColorShadow_Tint1 : packoffset(c7);
  float4 ColorShadow_Tint2 : packoffset(c8);
  float FilmSlope : packoffset(c9);
  float FilmToe : packoffset(c9.y);
  float FilmShoulder : packoffset(c9.z);
  float FilmBlackClip : packoffset(c9.w);
  float FilmWhiteClip : packoffset(c10);
  uint OutputDevice : packoffset(c10.y);
  uint OutputGamut : packoffset(c10.z);
  float UILevel : packoffset(c10.w);
}

SamplerState UISampler_s : register(s0);
SamplerState SceneSampler_s : register(s1);
SamplerState ColorSpaceLUTSampler_s : register(s2);
Texture2D<float4> UITexture : register(t0);
Texture2D<float4> SceneTexture : register(t1);
Texture3D<float4> ColorSpaceLUT : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = UITexture.Sample(UISampler_s, v0.xy).xyzw;
  r1.xyz = SceneTexture.Sample(SceneSampler_s, v0.xy).xyz;

  if (HandleUICompositing(r0, r1, o0, v0.xy, SceneTexture, SceneSampler_s)) {
    return;
  }

  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r2.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.xyz = ColorSpaceLUT.SampleLevel(ColorSpaceLUTSampler_s, r0.xyz, 0).xyz;
  r0.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r1.xyz = r2.xyz / r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(10000, 10000, 10000) * r1.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r0.xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r0.xyz = -r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = UILevel * r0.xyz;
  r1.w = cmp(0 < r0.w);
  r2.x = cmp(r0.w < 1);
  r1.w = r1.w ? r2.x : 0;
  if (r1.w != 0) {
    r1.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
    r1.w = r1.w / UILevel;
    r1.w = 1 + r1.w;
    r1.w = 1 / r1.w;
    r1.w = r1.w * UILevel + -1;
    r1.w = r0.w * r1.w + 1;
    r1.xyz = r1.xyz * r1.www;
  }
  r0.w = 1 + -r0.w;
  r0.xyz = float3(10000, 10000, 10000) * r0.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
  return;
}
