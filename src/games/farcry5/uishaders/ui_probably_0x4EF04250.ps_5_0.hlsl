#include "../shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 14:49:32 2025

cbuffer CGlobalShaderParameterProvider : register(b0)
{
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

cbuffer CScenePrimitiveParameterProvider : register(b1)
{
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



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -ScissorRect.xy + v0.xy;
  r0.zw = ScissorRect.zw + -v0.xy;
  r0.xy = min(r0.xy, r0.zw);
  r0.x = min(r0.x, r0.y);
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = dot(v1.xyz, float3(0.298999995,0.587000012,0.114));
  r0.xyz = -v1.xyz + r0.xxx;
  r0.xyz = Desaturation * r0.xyz + v1.xyz;
  r0.w = v1.w;
  r0.xyzw = r0.xyzw * ColorMultiplier.xyzw + ColorAdd.xyzw;
  r1.x = saturate(OutputOnlyAlpha);
  r1.yzw = r0.www + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r0.w = -1 + r0.w;
  o0.w = UseAlpha * r0.w + 1;
  if (SCRGB != 0) {
    o0.xyz = r0.xyz;
  } else {
    r1.x = dot(r0.xyz, float3(0.753832996,0.198596999,0.047569599));
    r1.y = dot(r0.xyz, float3(0.0457439013,0.941776991,0.0124787996));
    r1.z = dot(r0.xyz, float3(-0.00121032004,0.0176017992,0.983609021));
    r0.xyz = max(float3(0, 0, 0), r1.xyz);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r0.xyz = log2(r0.xyz);
      r0.xyz = r0.xyz * float3(0.0588235296,0.0588235296,0.0588235296) + float3(0.527878284,0.527878284,0.527878284);
      r0.xyz = r0.xyz * float3(-3,-3,-3) + float3(1.14705884,1.14705884,1.14705884);
      r0.xyz = exp2(r0.xyz);
      r0.xyz = float3(1,1,1) + r0.xyz;
      r0.xyz = rcp(r0.xyz);
      r0.xyz = r0.xyz * float3(2.11813974,2.11813974,2.11813974) + float3(-0.658908367,-0.658908367,-0.658908367);
      r0.xyz = r0.xyz * float3(17,17,17) + float3(-8.97393131,-8.97393131,-8.97393131);
      r0.xyz = exp2(r0.xyz);
      r0.xyz = HDRReferenceWhiteNits * r0.xyz;
    } else {
      r0.rgb *= RENODX_GRAPHICS_WHITE_NITS;
    }
    r0.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r0.xyz;
    r0.xyz = log2(abs(r0.xyz));
    r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r1.xyzw = r0.xxyy * float4(18.8515625,18.6875,18.8515625,18.6875) + float4(0.8359375,1,0.8359375,1);
    r0.xy = r1.xz / r1.yw;
    r0.xy = log2(r0.xy);
    r0.xy = float2(78.84375,78.84375) * r0.xy;
    o0.xy = exp2(r0.xy);
    r0.xy = r0.zz * float2(18.8515625,18.6875) + float2(0.8359375,1);
    r0.x = r0.x / r0.y;
    r0.x = log2(r0.x);
    r0.x = 78.84375 * r0.x;
    o0.z = exp2(r0.x);
  }
  return;
}