#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 01 21:53:48 2026

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  uint HDRPQCurve : packoffset(c4);
  float HDRPQLerp : packoffset(c4.y);
  float HDRContrast : packoffset(c4.z);
  float HDRPaperWhiteNits : packoffset(c4.w);
  float HDRMaxSceneValue2084 : packoffset(c5);
  float HDRWhiteScaleInverse : packoffset(c5.y);
  float HDRHableAsymptote : packoffset(c5.z);
  float HDRMaxTVNits2084 : packoffset(c5.w);
  float HDRBrightness : packoffset(c6);
  float UILevel : packoffset(c6.y);
  int ColorSpaceRotateVersion : packoffset(c6.z);
  float HDRUseML : packoffset(c6.w);
  float HDRUseMLLuminance : packoffset(c7);
  float4 HDRMLControlPointsPx : packoffset(c8);
  float4 HDRMLControlPointsPy : packoffset(c9);
  float3x3 CustomColourRotate : packoffset(c10);
  float4 HDRGamut_XExp_Amnt_YExpStart_ZExpEnd_WExpInvRange : packoffset(c13);
  float4 CalibrationGraphTopLeftBottomRight : packoffset(c14);
}

SamplerState UITextureSampler_s : register(s0);
SamplerState SceneTextureSampler_s : register(s1);
Texture2D<float4> UITexture : register(t0);
Texture2D<float4> SceneTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (GEARSRELOADED_CUSTOM_HDR_ENABLED) {
    float4 ui = UITexture.SampleLevel(UITextureSampler_s, v0.xy, 0);
    float3 ui_bt709 = pow(saturate(ui.rgb), 2.2f);
    float3 ui_bt2020 = mul(float3x3(
        0.627403975f, 0.329281986f, 0.0433136001f,
        0.0690969974f, 0.919539988f, 0.0113612004f,
        0.0163915996f, 0.088013202f, 0.895595014f), ui_bt709);
    float3 ui_rotated = mul(CustomColourRotate, ui_bt709);
    float gamut_amount = saturate((max(ui_bt709.r, max(ui_bt709.g, ui_bt709.b))
        - HDRGamut_XExp_Amnt_YExpStart_ZExpEnd_WExpInvRange.y)
        * HDRGamut_XExp_Amnt_YExpStart_ZExpEnd_WExpInvRange.w);
    ui_bt2020 = lerp(ui_bt2020, ui_rotated, gamut_amount);
    float3 scene_nits = renodx::color::pq::DecodeSafe(
        SceneTexture.SampleLevel(SceneTextureSampler_s, v0.xy, 0).rgb, 1.f);

    // Preserve the game's translucent-UI background dimming and gamma-2.2
    // premultiplied composition. UI white is independent of scene paper white.
    if (ui.a > 0.f && ui.a < 1.f) {
      float scene_luminance = dot(scene_nits, float3(0.2627f, 0.678f, 0.0593f));
      float ui_level = GEARSRELOADED_HDR_UI_NITS / GEARSRELOADED_HDR_PAPER_WHITE_NITS;
      float background_scale = ui_level / (1.f + scene_luminance / ui_level);
      scene_nits *= lerp(1.f, background_scale, ui.a);
    }
    float3 composed = pow(max(scene_nits, 0.f) / 10000.f, 1.f / 2.2f) * (1.f - ui.a)
        + pow(max(ui_bt2020, 0.f) * (GEARSRELOADED_HDR_UI_NITS / 10000.f), 1.f / 2.2f);
    float3 output_nits = min(pow(max(composed, 0.f), 2.2f) * 10000.f, GEARSRELOADED_HDR_PEAK_NITS);
    o0 = float4(renodx::color::pq::EncodeSafe(output_nits, 1.f), 0.f);
    return;
  }

  r0.xyz = SceneTexture.SampleLevel(SceneTextureSampler_s, v0.xy, 0).xyz;
  r1.xyzw = UITexture.SampleLevel(UITextureSampler_s, v0.xy, 0).xyzw;
  r1.xyz = saturate(r1.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.x = dot(float3(0.627403975,0.329281986,0.0433136001), r1.xyz);
  r2.y = dot(float3(0.0690969974,0.919539988,0.0113612004), r1.xyz);
  r2.z = dot(float3(0.0163915996,0.088013202,0.895595014), r1.xyz);
  r3.xyz = CustomColourRotate._m01_m11_m21 * r1.yyy;
  r3.xyz = CustomColourRotate._m00_m10_m20 * r1.xxx + r3.xyz;
  r3.xyz = CustomColourRotate._m02_m12_m22 * r1.zzz + r3.xyz;
  r0.w = max(r1.x, r1.y);
  r0.w = max(r0.w, r1.z);
  r0.w = -HDRGamut_XExp_Amnt_YExpStart_ZExpEnd_WExpInvRange.y + r0.w;
  r0.w = saturate(HDRGamut_XExp_Amnt_YExpStart_ZExpEnd_WExpInvRange.w * r0.w);
  r1.xyz = r3.xyz + -r2.xyz;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r1.xyz = HDRPaperWhiteNits * r1.xyz;
  r1.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r2.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = r2.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r2.xyz = r2.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r2.xyz = r3.xyz / r2.xyz;
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(78.84375,78.84375,78.84375) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  if (HDRPQCurve != 0) {
    r0.w = cmp(HDRPQCurve == 1);
    if (r0.w != 0) {
      r3.xyz = float3(0.170288086,0.170288086,0.170288086) * r1.xyz;
      r3.xyz = exp2(r3.xyz);
      r4.xyz = r3.xyz * float3(16.2421875,16.2421875,16.2421875) + float3(0.8359375,0.8359375,0.8359375);
      r3.xyz = r3.xyz * float3(16.078125,16.078125,16.078125) + float3(1,1,1);
      r3.xyz = r4.xyz / r3.xyz;
      r3.xyz = log2(r3.xyz);
      r3.xyz = float3(84.375,84.375,84.375) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
    } else {
      r0.w = cmp(HDRPQCurve == 2);
      r1.xyz = float3(0.171569824,0.171569824,0.171569824) * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r4.xyz = r1.xyz * float3(16.71875,16.71875,16.71875) + float3(0.84375,0.84375,0.84375);
      r1.xyz = r1.xyz * float3(16.5625,16.5625,16.5625) + float3(1,1,1);
      r1.xyz = r4.xyz / r1.xyz;
      r1.xyz = log2(r1.xyz);
      r1.xyz = float3(82.53125,82.53125,82.53125) * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r3.xyz = r0.www ? r1.xyz : 0;
    }
    r0.w = 1 + -HDRPQLerp;
    r1.xyz = HDRPQLerp * r3.xyz;
    r1.xyz = r2.xyz * r0.www + r1.xyz;
  } else {
    r1.xyz = min(float3(1,1,1), r2.xyz);
  }
  r0.w = 0.5 * HDRMaxTVNits2084;
  r2.xyz = -HDRMaxTVNits2084 * float3(0.5,0.5,0.5) + r1.xyz;
  r2.w = -HDRMaxTVNits2084 * 0.5 + HDRMaxSceneValue2084;
  r2.xyz = r2.xyz / r2.www;
  r3.xyz = r2.xyz * r2.xyz;
  r4.xyz = r3.xyz * r2.xyz;
  r5.xyz = float3(3,3,3) * r3.xyz;
  r6.xyz = r4.xyz * float3(2,2,2) + -r5.xyz;
  r6.xyz = float3(1,1,1) + r6.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + r4.xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = r4.xyz * float3(-2,-2,-2) + r5.xyz;
  r2.xyz = r2.xyz * r2.www;
  r2.xyz = r6.xyz * r0.www + r2.xyz;
  r2.xyz = r3.xyz * HDRMaxTVNits2084 + r2.xyz;
  r3.xyz = cmp(r1.xyz < r0.www);
  r2.xyz = r3.xyz ? r1.xyz : r2.xyz;
  r1.xyz = cmp(HDRMaxSceneValue2084 < r1.xyz);
  r1.xyz = r1.xyz ? HDRMaxTVNits2084 : r2.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r1.xyz;
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r1.xyz = -r1.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r1.xyz = r2.xyz / r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(6.27739477,6.27739477,6.27739477) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.0126833133,0.0126833133,0.0126833133) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r2.xyz = float3(-0.8359375,-0.8359375,-0.8359375) + r0.xyz;
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r0.xyz = -r0.xyz * float3(18.6875,18.6875,18.6875) + float3(18.8515625,18.8515625,18.8515625);
  r0.xyz = r2.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(6.27739477,6.27739477,6.27739477) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(10000,10000,10000) * r0.xyz;
  r0.w = cmp(0 < r1.w);
  r2.x = cmp(r1.w < 1);
  r0.w = r0.w ? r2.x : 0;
  if (r0.w != 0) {
    r0.w = dot(r0.xyz, float3(0.262699991,0.677999973,0.0593000017));
    r0.w = r0.w / UILevel;
    r0.w = 1 + r0.w;
    r0.w = 1 / r0.w;
    r0.w = r0.w * UILevel + -1;
    r0.w = r1.w * r0.w + 1;
    r0.xyz = r0.xyz * r0.www;
  }
  r0.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = UILevel * r1.xyz;
  r1.xyz = float3(1,1,1) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.454545468,0.454545468,0.454545468) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r0.w = 1 + -r1.w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(1,1,1) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = rcp(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 0;
  return;
}