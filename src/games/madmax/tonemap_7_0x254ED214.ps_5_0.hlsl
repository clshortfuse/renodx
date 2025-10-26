#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Mon Apr 28 11:33:21 2025

cbuffer cbConsts : register(b1)
{
  float4 Consts[15] : packoffset(c0);
}

SamplerState SceneTexture_s : register(s0);
SamplerState BloomTexture_s : register(s3);
SamplerState SecondaryBloomTexture_s : register(s4);
SamplerState LensDirtTexture_s : register(s6);
SamplerState FilmGrainTexture_s : register(s8);
SamplerState EdgeFadeTexture_s : register(s9);
SamplerState ColorCorrectionTexture_s : register(s10);
SamplerState ColorCorrectionTextureFade_s : register(s11);
Texture2D<float4> SceneTexture : register(t0);
Texture2D<float4> BloomTexture : register(t3);
Texture2D<float4> SecondaryBloomTexture : register(t4);
Texture2D<float4> LensDirtTexture : register(t6);
Texture2D<float4> FilmGrainTexture : register(t8);
Texture2D<float4> EdgeFadeTexture : register(t9);
Texture3D<float4> ColorCorrectionTexture : register(t10);
Texture3D<float4> ColorCorrectionTextureFade : register(t11);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = Consts[9].xyzw * v1.xyxy;
  r1.xyz = LensDirtTexture.Sample(LensDirtTexture_s, r0.zw).xyz;
  r1.xyz = r1.xyz * Consts[12].www + float3(1, 1, 1);
  r2.xyz = SecondaryBloomTexture.Sample(SecondaryBloomTexture_s, r0.xy).xyz * CUSTOM_BLOOM;
  r2.xyz = Consts[3].yyy * r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = BloomTexture.Sample(BloomTexture_s, r0.xy).xyz * CUSTOM_BLOOM;
  r0.xyz = SceneTexture.Sample(SceneTexture_s, r0.xy).xyz;
  r1.xyz = r2.xyz * Consts[3].xxx + r1.xyz;
  r2.xyz = EdgeFadeTexture.Sample(EdgeFadeTexture_s, v1.xy).xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r0.xyz * Consts[2].xxx + r1.xyz;

  float3 hdr_color = r0.rgb;
  float3 hdr_color_tm = HermiteSplineRolloff(r0.rgb);

  r0.xyz = max(float3(1.00000001e-07,1.00000001e-07,1.00000001e-07), r0.xyz);
  r1.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.0500000007,0.0500000007,0.0500000007);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
  r2.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.5,0.5,0.5);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0666666701,-0.0666666701,-0.0666666701) + r0.xyz;
  r0.xyz = Consts[1].xyz * r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r0.xyz = min(float3(1,1,1), r0.xyz);
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r1.xyz = ColorCorrectionTextureFade.Sample(ColorCorrectionTextureFade_s, r0.xyz).xyz;
  r0.xyz = ColorCorrectionTexture.Sample(ColorCorrectionTexture_s, r0.xyz).xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.w = 1 + -Consts[1].w;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  //r1.xy = v1.xy * float2(16,8) + Consts[3].zw;
  //r0.w = FilmGrainTexture.Sample(FilmGrainTexture_s, r1.xy).x;
  //r0.w = -0.5 + r0.w;
  //r0.xyz = r0.www * float3(0.0179999992,0.0179999992,0.0179999992) + r0.xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  o0.w = sqrt(r0.w);

  float3 sdr_color = o0.rgb;
  o0.rgb = ToneMapPass(hdr_color, sdr_color, hdr_color_tm, v1);
  return;
}