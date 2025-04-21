#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 14:49:30 2025

cbuffer CGlobalShaderParameterProvider : register(b0) {
  float4 BurnColor : packoffset(c0);
  float4 BurnParams : packoffset(c1);
  float4 BurnParams2 : packoffset(c2);
  float4 BurnParams3 : packoffset(c3);
  float4 BurnParams4 : packoffset(c4);
  float4 BurnParams5 : packoffset(c5);
  float4 CascadedShadowScaleOffsetTile0 : packoffset(c6);
  float4 CascadedShadowScaleOffsetTile1 : packoffset(c7);
  float4 WindSimParams : packoffset(c8);
  float4 WindDirection : packoffset(c9);
  float4 PrevWindSimParams : packoffset(c10);
  float4 PrevWindDirection : packoffset(c11);
  float Time : packoffset(c12);
  float Time_Previous : packoffset(c12.y);
  float UITime : packoffset(c12.z);
  float NormalizedTimeOfDay : packoffset(c12.w);
  float FireGlowEV : packoffset(c13);
  float BurnSpeedScale : packoffset(c13.y);
  float BurnlineMaskScale : packoffset(c13.z);
  float BurnlineMaskInfluence : packoffset(c13.w);
  float WorldSpaceProgressionMaskScale : packoffset(c14);
  float WorldSpaceProgressionMaskInfluence : packoffset(c14.y);
  float MaskTransitionSpeedModifier : packoffset(c14.z);
  float GlowMaskScale : packoffset(c14.w);
  float FireGlowMaskInfluence : packoffset(c15);
  float CenterBurnlineWidth : packoffset(c15.y);
  float TransitionToBurnlineWidth : packoffset(c15.z);
  float DissolveCutoffPoint : packoffset(c15.w);
  float DissolveBlendDistance : packoffset(c16);
  float WetnessFactor : packoffset(c16.y);
  float DirtFactor : packoffset(c16.z);
  float IronSightFactor : packoffset(c16.w);
  float3 DeprecatedShaderColor : packoffset(c17);
  float HDRReferenceWhiteNits : packoffset(c17.w);
  bool SCRGB : packoffset(c18);
  bool Isolate0 : packoffset(c18.y);
  bool Isolate1 : packoffset(c18.z);
  bool Isolate2 : packoffset(c18.w);
  bool Isolate3 : packoffset(c19);
}

cbuffer CSceneFireUiPrimitiveParameterProvider : register(b1) {
  float DistanceFieldFloatArray[12] : packoffset(c0);
  float BordersSizeFloatArray[8] : packoffset(c12);
  float4x4 Transform : packoffset(c20);
  float4x4 UVTransform : packoffset(c24);
  float4 BinkUVTransforms : packoffset(c28);
  float4 BackgroundColor : packoffset(c29);
  float4 BordersColor : packoffset(c30);
  float4 ColorAdd : packoffset(c31);
  float4 ColorAdjustment : packoffset(c32);
  float4 ColorMultiplier : packoffset(c33);
  float4 ColorTransparent : packoffset(c34);
  float4 ScissorRect : packoffset(c35);
  float2 ViewportScaleXY : packoffset(c36);
  float TextureAddress : packoffset(c36.z);
  float Desaturation : packoffset(c36.w);
  float LinePercentage : packoffset(c37);
  float TexHeight : packoffset(c37.y);
  float TexRatio : packoffset(c37.z);
  float TextWidth : packoffset(c37.w);
  float PrimGroupTime : packoffset(c38);
  float UIHDRValue : packoffset(c38.y);
  float UIModeEx : packoffset(c38.z);
}

SamplerState Wrap_s : register(s0);
SamplerState Clamp_s : register(s1);
SamplerState Mirror_s : register(s2);
Texture2D<float4> DiffuseSampler0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    uint v3: SV_IsFrontFace0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -ScissorRect.xy + v0.xy;
  r0.zw = ScissorRect.zw + -v0.xy;
  r0.xy = min(r0.xy, r0.zw);
  r0.x = min(r0.x, r0.y);
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = cmp(TextureAddress == 3.000000);
  if (r0.x != 0) {
    r0.xyzw = DiffuseSampler0.Sample(Clamp_s, v2.zw).xyzw;
  } else {
    r1.x = cmp(TextureAddress == 2.000000);
    if (r1.x != 0) {
      r0.xyzw = DiffuseSampler0.Sample(Mirror_s, v2.zw).xyzw;
    } else {
      r0.xyzw = DiffuseSampler0.Sample(Wrap_s, v2.zw).xyzw;
    }
  }
  r1.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r3.xyz = log2(abs(r0.xyz));
  r3.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r0.xyz = r1.xyz ? r2.xyz : r3.xyz;
  r1.xyzw = v1.xyzw * r0.xyzw;
  r0.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r1.xyz);
  r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r1.xyz;
  r3.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + abs(r1.xyz);
  r3.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r3.xyz;
  r3.xyz = log2(r3.xyz);
  r3.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r3.xyz;
  r2.x = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.xyz = r2.xxx + -r0.xyz;
  r1.xyz = Desaturation * r2.xyz + r0.xyz;
  r2.xyzw = ColorMultiplier.xyzw * r1.xyzw;
  r0.x = cmp(0 < r0.w);
  r1.xyzw = r1.xyzw * ColorMultiplier.xyzw + ColorAdd.xyzw;
  r0.xyzw = r0.xxxx ? r1.xyzw : r2.xyzw;
  r1.x = -1 + r0.w;
  r1.x = ColorTransparent.w * r1.x + 1;
  r1.yzw = -ColorTransparent.xyz + r0.xyz;
  r1.xyz = r1.xxx * r1.yzw + ColorTransparent.xyz;

  if (RENODX_TONE_MAP_TYPE != 0 && RENODX_GAMMA_CORRECTION) r1.rgb = renodx::color::correct::GammaSafe(r1.rgb);  // gamma correct UI

  if (SCRGB != 0) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r1.w = 0.0125000002 * HDRReferenceWhiteNits;
    } else {
      r1.w = RENODX_GRAPHICS_WHITE_NITS / 80.f;
    }
    r0.xyz = r1.xyz * r1.www;
  } else {
    r2.x = dot(r1.xyz, float3(0.753832996, 0.198596999, 0.047569599));
    r2.y = dot(r1.xyz, float3(0.0457439013, 0.941776991, 0.0124787996));
    r2.z = dot(r1.xyz, float3(-0.00121032004, 0.0176017992, 0.983609021));
    r1.xyz = max(float3(0, 0, 0), r2.xyz);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r1.xyz = log2(r1.xyz);
      r1.xyz = r1.xyz * float3(0.0588235296, 0.0588235296, 0.0588235296) + float3(0.527878284, 0.527878284, 0.527878284);
      r1.xyz = r1.xyz * float3(-3, -3, -3) + float3(1.14705884, 1.14705884, 1.14705884);
      r1.xyz = exp2(r1.xyz);
      r1.xyz = float3(1, 1, 1) + r1.xyz;
      r1.xyz = rcp(r1.xyz);
      r1.xyz = r1.xyz * float3(2.11813974, 2.11813974, 2.11813974) + float3(-0.658908367, -0.658908367, -0.658908367);
      r1.xyz = r1.xyz * float3(17, 17, 17) + float3(-8.97393131, -8.97393131, -8.97393131);
      r1.xyz = exp2(r1.xyz);

      r1.xyz = HDRReferenceWhiteNits * r1.xyz;
    } else {
      r1.xyz = RENODX_GRAPHICS_WHITE_NITS * r1.xyz;
    }

    r1.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r1.xyz;
    r1.xyz = log2(abs(r1.xyz));
    r1.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyzw = r1.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
    r1.xy = r2.xz / r2.yw;
    r1.xy = log2(r1.xy);
    r1.xy = float2(78.84375, 78.84375) * r1.xy;
    r0.xy = exp2(r1.xy);
    r1.xy = r1.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
    r1.x = r1.x / r1.y;
    r1.x = log2(r1.x);
    r1.x = 78.84375 * r1.x;
    r0.z = exp2(r1.x);
  }
  o0.xyzw = r0.xyzw;
  return;
}
