#include "./shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 14:49:54 2025

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

cbuffer CScenePrimitiveParameterProvider : register(b1) {
  float4x4 Transform : packoffset(c0);
  float4 BinkUVTransforms : packoffset(c4);
  float4 ScissorRect : packoffset(c5);
  float4 ColorAdd : packoffset(c6);
  float4 ColorAdjustment : packoffset(c7);
  float4 ColorMultiplier : packoffset(c8);
  float TextureAddress : packoffset(c9);
  float Desaturation : packoffset(c9.y);
  float HDRFactor : packoffset(c9.z);
  float OutputOnlyAlpha : packoffset(c9.w);
  float UseAlpha : packoffset(c10);
}

SamplerState Wrap_s : register(s0);
SamplerState Clamp_s : register(s1);
SamplerState Mirror_s : register(s2);
Texture2D<float4> DiffuseSampler0 : register(t0);
Texture2D<float4> CRSampler : register(t1);
Texture2D<float4> CBSampler : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float2 v3: TEXCOORD2,
    uint v4: SV_IsFrontFace0,
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
    r0.y = DiffuseSampler0.Sample(Clamp_s, v1.xy).w;
  } else {
    r0.z = cmp(TextureAddress == 2.000000);
    if (r0.z != 0) {
      r0.y = DiffuseSampler0.Sample(Mirror_s, v1.xy).w;
    } else {
      r0.y = DiffuseSampler0.Sample(Wrap_s, v1.xy).w;
    }
  }
  r0.y = saturate(r0.y * 1.16438353 + -0.0730593577);
  if (r0.x != 0) {
    r0.x = CRSampler.Sample(Clamp_s, v1.zw).w;
    r0.z = CBSampler.Sample(Clamp_s, v1.zw).w;
  } else {
    r0.w = cmp(TextureAddress == 2.000000);
    if (r0.w != 0) {
      r0.x = CRSampler.Sample(Mirror_s, v1.zw).w;
    } else {
      r0.x = CRSampler.Sample(Wrap_s, v1.zw).w;
    }
    if (r0.w != 0) {
      r0.z = CBSampler.Sample(Mirror_s, v1.zw).w;
    } else {
      r0.z = CBSampler.Sample(Wrap_s, v1.zw).w;
    }
  }
  r0.xyw = r0.xxx * float3(1.40199995, -0.714139998, 0) + r0.yyy;
  r0.xyz = r0.zzz * float3(0, -0.344139993, 1.77199996) + r0.xyw;
  r0.xyz = float3(-0.700999975, 0.529139996, -0.885999978) + r0.xyz;
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r0.xyz);
  r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + abs(r0.xyz);
  r0.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r1.xyz = v2.xyz * r0.xyz;
  r0.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.xyz = -v2.xyz * r0.xyz + r0.www;
  r0.xyz = Desaturation * r0.xyz + r1.xyz;
  r0.w = v2.w;
  r0.xyzw = r0.xyzw * ColorMultiplier.xyzw + ColorAdd.xyzw;
  r1.x = saturate(OutputOnlyAlpha);
  r1.yzw = r0.www + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r0.w = -1 + r0.w;
  o0.w = UseAlpha * r0.w + 1;
  if (SCRGB != 0) {
    if (RENODX_TONE_MAP_TYPE) {
      r0.w = 0.0125000002 * HDRReferenceWhiteNits;
    } else {
      r0.w = RENODX_DIFFUSE_WHITE_NITS / 80.f;
    }
    o0.xyz = r0.xyz * r0.www;
  } else {
    if (RENODX_TONE_MAP_TYPE) {
      r0.w = HDRReferenceWhiteNits + HDRReferenceWhiteNits;
      r1.xyz = float3(1.00010002, 1.00010002, 1.00010002) + -r0.xyz;
      r1.xyz = r0.xyz / r1.xyz;
      r1.w = 10000 / r0.w;
      r2.xy = float2(9.99999975e-05, -0.999899983) + r1.ww;
      r1.w = r2.x / r2.y;
      r2.x = 0.5 * r1.w;
      r2.y = -0.5 + r1.w;
      r2.x = r2.x / r2.y;
      r2.x = 1 + -r2.x;
      r2.yzw = r1.www * r0.xyz;
      r3.xyz = r1.www + -r0.xyz;
      r2.yzw = r2.yzw / r3.xyz;
      r2.xyz = r2.xxx + r2.yzw;
      r0.xyz = cmp(float3(0.5, 0.5, 0.5) < r0.xyz);
      r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
    } else {
      r0.w = RENODX_GRAPHICS_WHITE_NITS;
    }
    r1.x = dot(r0.xyz, float3(0.627399981, 0.329299986, 0.0432999991));
    r1.y = dot(r0.xyz, float3(0.0691, 0.919499993, 0.0114000002));
    r1.z = dot(r0.xyz, float3(0.0164000001, 0.0879999995, 0.895600021));
    r0.xyz = r1.xyz * r0.www;
    r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
    r0.xyz = log2(abs(r0.xyz));
    r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r1.xyzw = r0.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
    r0.xy = r1.xz / r1.yw;
    r0.xy = log2(r0.xy);
    r0.xy = float2(78.84375, 78.84375) * r0.xy;
    o0.xy = exp2(r0.xy);
    r0.xy = r0.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
    r0.x = r0.x / r0.y;
    r0.x = log2(r0.x);
    r0.x = 78.84375 * r0.x;
    o0.z = exp2(r0.x);
  }
  return;
}
