#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 11 03:31:25 2025

cbuffer CB_PerFrame : register(b13) {
  float4 gCameraFadeAlpha : packoffset(c0);
  float4 gCameraFadeShadow : packoffset(c1);
  float4 gColorControl : packoffset(c2);
  float3 cBoostCol : packoffset(c3);
  float cHdrControl : packoffset(c3.w);
  float gAOControl : packoffset(c4);
}

cbuffer CB_PS_PostFinal : register(b7) {
  float4 cMiscTerms : packoffset(c0);
  float4 cTint : packoffset(c1);
  float4 cBloomWeights : packoffset(c2);
  float4 cExtractTerms : packoffset(c3);
  float4 cNoiseTerms : packoffset(c4);
  float4 cNoiseOffsets : packoffset(c5);
  float3 cLevelsScale : packoffset(c6);
  float3 cLevelsBias : packoffset(c7);
  float3 cLevelsGamma : packoffset(c8);
  float4 cNightVisionTerms : packoffset(c9);
  float4 cDebugShadedBrightness : packoffset(c10);
  bool bPost : packoffset(c11);
  bool bBloom : packoffset(c11.y);
  bool bNoise : packoffset(c11.z);
  bool bNoiseLum : packoffset(c11.w);
  bool bWaves : packoffset(c12);
}

SamplerState sSceneTexPoint_s : register(s0);
SamplerState sBloom_s : register(s1);
SamplerState sNoise1_s : register(s2);
SamplerState sTonemap_s : register(s4);
Texture2D<float4> sSceneTexPoint : register(t0);
Texture2D<float4> sTonemap : register(t1);
Texture2D<float4> sBloom : register(t2);
Texture2D<float4> sNoise1 : register(t3);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = sSceneTexPoint.Sample(sSceneTexPoint_s, v1.zw).xzy;
  if (bWaves != 0) {
    r1.xy = cMiscTerms.zw + v1.zw;
    r0.x = sSceneTexPoint.Sample(sSceneTexPoint_s, r1.xy).x;
    r1.xy = -cMiscTerms.zw + v1.zw;
    r0.y = sSceneTexPoint.Sample(sSceneTexPoint_s, r1.xy).z;
  }
  r0.w = cmp(cHdrControl < 0);
  r1.xyz = r0.www ? r0.xzy : float3(1, 1, 1);
  r0.xyz = r1.xyz * r0.xzy;
  r0.w = sTonemap.Sample(sTonemap_s, float2(0, 0)).x;  // exposure, used by sonar
  r0.xyz = r0.xyz * r0.www;
  if (bBloom != 0) {
    r1.xyz = sBloom.Sample(sBloom_s, v1.xy).xyz;
    r1.xyz = cBloomWeights.xxx * r1.xyz + r0.xyz; // sonar, lowering ruins visibility
    r0.xyz = gColorControl.zzz * r1.xyz;
  }
  if (RENODX_TONE_MAP_TYPE == 0) {
    r0.rgb = clamp(r0.rgb, 0, cExtractTerms.w);
  } else {
    r0.rgb = renodx::color::grade::UserColorGrading(
        r0.rgb,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT);
  }
  if (bPost != 0) {
    if (bNoise != 0) {
      r1.zw = cNoiseTerms.xy * v1.zw;
      r1.xy = v1.zw;
      r2.xy = cNoiseTerms.xy;
      r2.zw = float2(0.5, 0.5);
      r1.xyzw = r1.xyzw * r2.xyzw + cNoiseOffsets.xyzw;
      r2.xyz = sNoise1.Sample(sNoise1_s, r1.xy).xyz;
      r1.xyz = sNoise1.Sample(sNoise1_s, r1.zw).xyz;
      r1.xyz = r2.xyz + r1.xyz;
      r1.xyz = r1.xyz * cNoiseTerms.zzz + -cNoiseTerms.zzz;
      r1.yz = bNoiseLum ? r1.xx : r1.yz;
      r0.xyz = r1.xyz * CUSTOM_NOISE + r0.xyz;
    }

    float3 tintInputColor = r0.rgb;

    r0.w = dot(r0.xyz, float3(0.300000012, 0.600000024, 0.100000001));
    r1.xyz = r0.xyz + -r0.www;
    r1.xyz = cTint.www * r1.xyz + r0.www;
    r1.xyz = r1.xyz * cMiscTerms.xxx + cMiscTerms.yyy;
    r0.xyz = cTint.xyz * r1.xyz;

    r0.rgb = lerp(tintInputColor, r0.rgb, CUSTOM_LUT_STRENGTH);
  }
  r0.xyz = (r0.xyz * cLevelsScale.xyz + cLevelsBias.xyz);
  r0.rgb = max(0, r0.rgb);  // sonar goggles break otherwise
  if (RENODX_TONE_MAP_TYPE == 0) r0.rgb = min(1, r0.rgb);
  r0.rgb = pow(r0.rgb, cLevelsGamma.rgb); // can't hardcode to 2.2, sonar changes value

  // fix luminance calculation
  o0.w = renodx::color::y::from::BT709(r0.rgb);  // o0.w = renodx::color::y::from::BT601(r0.xyz);
  o0.xyz = r0.xyz;
  return;
}
