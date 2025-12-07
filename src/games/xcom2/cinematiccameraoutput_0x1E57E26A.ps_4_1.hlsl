#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Oct  2 00:35:07 2025

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 SceneShadowsAndDesaturation : packoffset(c6);
  float4 SceneInverseHighLights : packoffset(c7);
  float4 SceneMidTones : packoffset(c8);
  float4 SceneScaledLuminanceWeights : packoffset(c9);
  float4 SceneColorize : packoffset(c10);
  float4 GammaColorScaleAndInverse : packoffset(c11);
  float4 GammaOverlayColor : packoffset(c12);
  float4 RenderTargetExtent : packoffset(c13);
  float4 ImageAdjustments1 : packoffset(c14);
  float4 ImageAdjustments2 : packoffset(c15);
  float4 ImageAdjustments3 : packoffset(c16);
  float InverseGamma : packoffset(c17);
  float3 ColorScale : packoffset(c17.y);
  float4 OverlayColor : packoffset(c18);
}

SamplerState SceneColorTexture_s : register(s0);
SamplerState ColorGradingLUT_s : register(s1);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> ColorGradingLUT : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = SceneColorTexture.Sample(SceneColorTexture_s, v0.xy).xyz;
  r1.xyzw = ColorScale.zzxy * r0.zzxy;
  r0.xyzw = -r0.zzxy * ColorScale.zzxy + OverlayColor.zzxy;
  r0.xyzw = OverlayColor.wwww * r0.xyzw + r1.xyzw;
  const float3 linear_untonemapped = r0.zwy;
  r1.x = 1 + ImageAdjustments2.x;
  r2.xyzw = r0.yyzw * r1.xxxx + -ImageAdjustments2.yyyy;
  r2.xyzw = r2.xyzw * float4(6.19999981,6.19999981,6.19999981,6.19999981) + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = r0.yyzw * r1.xxxx + ImageAdjustments2.yyyy;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.xyzw = r3.xyzw * r2.xyzw;
  r2.xyzw = r0.yyzw * float4(6.19999981,6.19999981,6.19999981,6.19999981) + float4(1.70000005,1.70000005,1.70000005,1.70000005);
  r0.xyzw = r0.xyzw * r2.xyzw + float4(0.0599999987,0.0599999987,0.0599999987,0.0599999987);
  r0.xyzw = r1.xyzw / r0.xyzw;
  r1.xyw = float3(14.9998999,0.9375,0.05859375) * r0.xwz;
  r0.x = floor(r1.x);
  r1.x = r0.x * 0.0625 + r1.w;
  r1.xyzw = float4(0.001953125,0.03125,0.064453125,0.03125) + r1.xyxy;
  r0.x = r0.y * 15 + -r0.x;
  r0.yzw = ColorGradingLUT.Sample(ColorGradingLUT_s, r1.zw).xyz;
  r1.xyz = ColorGradingLUT.Sample(ColorGradingLUT_s, r1.xy).xyz;
  r0.yzw = -r1.xyz + r0.yzw;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz); 
    o0.xyz = renodx::draw::ToneMapPass(linear_untonemapped, o0.xyz);
    o0.xyz = renodx::effects::ApplyFilmGrain(
        o0.xyz,
        v0.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f);
    o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  } else {
    o0.xyz = saturate(o0.xyz);
  }
  return;
}