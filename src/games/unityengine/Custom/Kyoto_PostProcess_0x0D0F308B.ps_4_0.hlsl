#include "../common.hlsli"

cbuffer _Globals : register(b0){
  float4 unity_ColorSpaceGrey : packoffset(c0);
  float4 unity_ColorSpaceDouble : packoffset(c1);
  float4 unity_ColorSpaceDielectricSpec : packoffset(c2);
  float4 unity_ColorSpaceLuminance : packoffset(c3);
  float4 unity_Lightmap_HDR : packoffset(c4);
  float4 unity_DynamicLightmap_HDR : packoffset(c5);
  float _WhiteLevel : packoffset(c6);
  float _MidLevel : packoffset(c6.y);
  float _GrayLevel : packoffset(c6.z);
  float _BlackLevel : packoffset(c6.w);
  float _ExposureAdjustment : packoffset(c7);
  float4 _OffsetInfos : packoffset(c8);
  float _BloomIntensity : packoffset(c9);
  float _FlareIntensity : packoffset(c9.y);
  float _FlareBlendUp : packoffset(c9.z);
  float _FlareBlendDown : packoffset(c9.w);
  float2 _FringeIntensity : packoffset(c10);
  float _MaxValue : packoffset(c10.z);
  float _TemporalRatio : packoffset(c10.w);
  float4 _TemporalOffset : packoffset(c11);
  float4x4 _ToPrevViewProjCombined : packoffset(c12);
  float4 _CameraDepthTexture_TexelSize : packoffset(c16);
  float4 _Toe : packoffset(c17);
  float4 _Shoulder : packoffset(c18);
  float _K : packoffset(c19);
  float _Crossover : packoffset(c19.y);
  float _DirtIntensity : packoffset(c19.z);
  float _DirtLightIntensity : packoffset(c19.w);
}

SamplerState _MainTex_s : register(s0);
SamplerState _AdditiveTexture_s : register(s1);
SamplerState _DirtTexture_s : register(s2);
SamplerState _TonemappingLut_s : register(s3);
Texture2D<float4> _MainTex : register(t0);
Texture2D<float4> _AdditiveTexture : register(t1);
Texture2D<float4> _DirtTexture : register(t2);
Texture2D<float4> _TonemappingLut : register(t3);

float vanillaReinhard(float x){
  return saturate((x / (1 + x)) * 1.05f);
}

float3 vanillaReinhard(float3 color) {
  float3 output;
  output.r = vanillaReinhard(color.r);
  output.g = vanillaReinhard(color.g);
  output.b = vanillaReinhard(color.b);
  return output;
}

float vanillaReinhardExtended(float x) {
  return x > 0.3938 ? x * 0.540490890505 + 0.0838184841337 : vanillaReinhard(x);
}

float3 vanillaReinhardExtended(float3 color) {
  float3 output;
  output.r = vanillaReinhardExtended(color.r);
  output.g = vanillaReinhardExtended(color.g);
  output.b = vanillaReinhardExtended(color.b);
  return output;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _DirtTexture.Sample(_DirtTexture_s, v1.xy).xyzw;
  r1.xyzw = _AdditiveTexture.Sample(_AdditiveTexture_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = _DirtLightIntensity * r0.xyz;
  r1.xyz = r1.xyz * _BloomIntensity * CUSTOM_BLOOM + r0.xyz;
  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.xyzw = _FringeIntensity.xxyy * r0.xyzw;
  r0.xyzw = r0.xyzw * float4(0.5,0.5,0.5,0.5) + float4(0.5,0.5,0.5,0.5);
  r2.xyzw = _MainTex.Sample(_MainTex_s, r0.xy).xyzw;
  r0.xyzw = _MainTex.Sample(_MainTex_s, r0.zw).xyzw;
  r2.y = r0.y;
  r0.xyzw = _MainTex.Sample(_MainTex_s, v1.xy).xyzw;
  r2.zw = r0.zw;
  r0.xyzw = r2.xyzw * _ExposureAdjustment + r1.xyzw;
  o0.w = r0.w;
  float compression_scale;
  float max_channel_scale;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(vanillaReinhard(r0.xyz));
  } else {
    r0.xyz = vanillaReinhardExtended(r0.xyz);
    r0.xyz = CorrectHueAndChrominanceOKLAB(r0.xyz, vanillaReinhard(r0.xyz), RENODX_TONE_MAP_SDRIFY, RENODX_TONE_MAP_SDRIFY);
    GamutCompression(r0.xyz, compression_scale);
    NeutwoMaxCh(r0.xyz, max_channel_scale);
  }
  r0.w = 0.5;
  r1.xyzw = _TonemappingLut.Sample(_TonemappingLut_s, r0.xw).xyzw;
  o0.x = r1.x;
  r1.xyzw = _TonemappingLut.Sample(_TonemappingLut_s, r0.yw).xyzw;
  r0.xyzw = _TonemappingLut.Sample(_TonemappingLut_s, r0.zw).xyzw;
  o0.z = r0.z;
  o0.y = r1.y;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    NeutwoMaxChInverse(o0.xyz, max_channel_scale);
    GamutDecompression(o0.xyz, compression_scale);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}