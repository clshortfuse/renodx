// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 15 20:33:00 2026

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float _g_LUTColourIntensity : packoffset(c0);
  float _gm_AlphaRefValue : packoffset(c1);
  bool _gm_AlphaTestEnabled : packoffset(c2);
  float4 _gm_FogColour : packoffset(c3);
  bool _gm_PS_FogEnabled : packoffset(c4);
  float _gm_pPreMultiplyAlpha : packoffset(c5);
}

SamplerState sampler__g_LUTColourTexture_s : register(s0);
SamplerState sampler__gm_BaseTexture_s : register(s1);
Texture2D<float4> texture__g_LUTColourTexture : register(t0);
Texture2D<float4> texture__gm_BaseTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float2 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float4 o3 : SV_Target3)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yw = float2(0,0);
  r1.xyzw = texture__gm_BaseTexture.Sample(sampler__gm_BaseTexture_s, v1.xy).xyzw;

  // RenoDX: the upgraded scene surface exceeds 1.0 where sprites blend additively and
  // goes negative under subtractive blends. Negatives are floored as RGBA8 did.
  // Vanilla clamps to the original RGBA8 range. HDR rolls off the max channel above
  // 0.5 linear for a smooth LUT proxy that preserves RGB ratios.
  r1.w = saturate(r1.w);
  r1.rgb = max(0.f, r1.rgb);
  float3 untonemapped = renodx::color::srgb::DecodeSafe(r1.rgb);
  float3 neutral_sdr = renodx::tonemap::c_infinity_rolloff::MaxChannel(untonemapped, 1.f, 0.5f, 1.f);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.rgb = saturate(r1.rgb);
  } else {
    r1.rgb = renodx::color::srgb::EncodeSafe(neutral_sdr);
  }

  r2.xyzw = r1.xyzz * float4(64,64,64,64) + float4(-0.5,-0.5,-0.5,-0.5);
  r2.xyzw = floor(r2.xyzw);
  r3.xyzw = float4(1,1,1,1) + r2.xyzw;
  r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
  r3.xyzw = min(float4(63,63,63,63), r3.xyzw);
  r3.zw = float2(1,0.125) * r3.zw;
  r3.zw = floor(r3.zw);
  r2.z = 0.125 * r3.z;
  r2.z = floor(r2.z);
  r0.z = 8 * r2.z;
  r0.zw = r3.zw + -r0.zw;
  r0.zw = r3.xy * float2(0.015625,0.015625) + r0.zw;
  r0.zw = float2(0.125,0.125) * r0.zw;
  r3.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r0.zw).xyzw;
  r4.xyzw = float4(0,1,1,1) + r2.xyww;
  r4.xyzw = max(float4(0,0,0,0), r4.xyzw);
  r4.xyzw = min(float4(63,63,63,63), r4.xyzw);
  r0.zw = float2(1,0.125) * r4.zw;
  r0.zw = floor(r0.zw);
  r2.z = 0.125 * r0.z;
  r2.z = floor(r2.z);
  r0.x = 8 * r2.z;
  r0.xy = r0.zw + -r0.xy;
  r0.xy = r4.xy * float2(0.015625,0.015625) + r0.xy;
  r0.xy = float2(0.125,0.125) * r0.xy;
  r0.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r0.xy).xyzw;
  r3.xyz = r3.xyz + -r0.xyz;
  r4.xyz = r1.xyz * float3(64,64,64) + float3(0.5,0.5,0.5);
  r4.xyz = frac(r4.xyz);
  r0.xyz = r4.xxx * r3.xyz + r0.xyz;
  r3.xyzw = float4(1,0,1,1) + r2.xyww;
  r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
  r3.xyzw = min(float4(63,63,63,63), r3.xyzw);
  r3.zw = float2(1,0.125) * r3.zw;
  r3.zw = floor(r3.zw);
  r0.w = 0.125 * r3.z;
  r0.w = floor(r0.w);
  r5.z = 8 * r0.w;
  r5.yw = float2(0,0);
  r3.zw = -r5.zw + r3.zw;
  r3.xy = r3.xy * float2(0.015625,0.015625) + r3.zw;
  r3.xy = float2(0.125,0.125) * r3.xy;
  r3.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r3.xy).xyzw;
  r6.xyzw = float4(0,0,1,1) + r2.xyww;
  r6.xyzw = max(float4(0,0,0,0), r6.xyzw);
  r6.xyzw = min(float4(63,63,63,63), r6.xyzw);
  r5.zw = float2(1,0.125) * r6.zw;
  r5.zw = floor(r5.zw);
  r0.w = 0.125 * r5.z;
  r0.w = floor(r0.w);
  r5.x = 8 * r0.w;
  r5.xy = r5.zw + -r5.xy;
  r5.xy = r6.xy * float2(0.015625,0.015625) + r5.xy;
  r5.xy = float2(0.125,0.125) * r5.xy;
  r5.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r5.xy).xyzw;
  r3.xyz = -r5.xyz + r3.xyz;
  r3.xyz = r4.xxx * r3.xyz + r5.xyz;
  r0.xyz = -r3.xyz + r0.xyz;
  r0.xyz = r4.yyy * r0.xyz + r3.xyz;
  r3.xyzw = float4(1,1,0,0) + r2.xyww;
  r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
  r3.xyzw = min(float4(63,63,63,63), r3.xyzw);
  r3.zw = float2(1,0.125) * r3.zw;
  r3.zw = floor(r3.zw);
  r0.w = 0.125 * r3.z;
  r0.w = floor(r0.w);
  r5.z = 8 * r0.w;
  r5.yw = float2(0,0);
  r3.zw = -r5.zw + r3.zw;
  r3.xy = r3.xy * float2(0.015625,0.015625) + r3.zw;
  r3.xy = float2(0.125,0.125) * r3.xy;
  r3.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r3.xy).xyzw;
  r6.xyzw = float4(0,1,0,0) + r2.xyww;
  r6.xyzw = max(float4(0,0,0,0), r6.xyzw);
  r6.xyzw = min(float4(63,63,63,63), r6.xyzw);
  r5.zw = float2(1,0.125) * r6.zw;
  r5.zw = floor(r5.zw);
  r0.w = 0.125 * r5.z;
  r0.w = floor(r0.w);
  r5.x = 8 * r0.w;
  r5.xy = r5.zw + -r5.xy;
  r5.xy = r6.xy * float2(0.015625,0.015625) + r5.xy;
  r5.xy = float2(0.125,0.125) * r5.xy;
  r5.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r5.xy).xyzw;
  r3.xyz = -r5.xyz + r3.xyz;
  r3.xyz = r4.xxx * r3.xyz + r5.xyz;
  r5.xyzw = float4(1,0,0,0) + r2.xyww;
  r2.xyzw = max(float4(0,0,0,0), r2.xyww);
  r2.xyzw = min(float4(63,63,63,63), r2.xyzw);
  r5.xyzw = max(float4(0,0,0,0), r5.xyzw);
  r5.xyzw = min(float4(63,63,63,63), r5.xyzw);
  r5.zw = float2(1,0.125) * r5.zw;
  r5.zw = floor(r5.zw);
  r0.w = 0.125 * r5.z;
  r0.w = floor(r0.w);
  r6.z = 8 * r0.w;
  r6.yw = float2(0,0);
  r5.zw = -r6.zw + r5.zw;
  r5.xy = r5.xy * float2(0.015625,0.015625) + r5.zw;
  r5.xy = float2(0.125,0.125) * r5.xy;
  r5.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r5.xy).xyzw;
  r2.zw = float2(1,0.125) * r2.zw;
  r2.zw = floor(r2.zw);
  r0.w = 0.125 * r2.z;
  r0.w = floor(r0.w);
  r6.x = 8 * r0.w;
  r2.zw = r2.zw + -r6.xy;
  r2.xy = r2.xy * float2(0.015625,0.015625) + r2.zw;
  r2.xy = float2(0.125,0.125) * r2.xy;
  r2.xyzw = texture__g_LUTColourTexture.Sample(sampler__g_LUTColourTexture_s, r2.xy).xyzw;
  r5.xyz = r5.xyz + -r2.xyz;
  r2.xyz = r4.xxx * r5.xyz + r2.xyz;
  r3.xyz = r3.xyz + -r2.xyz;
  r2.xyz = r4.yyy * r3.xyz + r2.xyz;
  r0.xyz = -r2.xyz + r0.xyz;
  r0.xyz = r4.zzz * r0.xyz + r2.xyz;
  r0.w = cmp(0 < _gm_pPreMultiplyAlpha);
  r0.w = r0.w ? r1.w : 1;
  r0.xyz = r0.xyz * r0.www + -r1.xyz;
  r1.xyz = _g_LUTColourIntensity * r0.xyz + r1.xyz;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 graded_sdr = renodx::color::srgb::DecodeSafe(r1.rgb);
    r1.rgb = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(untonemapped, graded_sdr, neutral_sdr));
  }

  r0.xyzw = v0.xyzw * r1.xyzw;
  o0.xyzw = r0.xyzw;
  o1.xyzw = r0.xyzw;
  o2.xyzw = r0.xyzw;
  o3.xyzw = r0.xyzw;
  return;
}
