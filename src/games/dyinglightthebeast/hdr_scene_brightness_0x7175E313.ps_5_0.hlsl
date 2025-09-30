#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Sep 22 01:48:40 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  const float scene_brightness = cb0[0].x;

  r0.xy = (uint2)v0.xy;
  r0.zw = float2(0, 0);
  r0.xyzw = t0.Load(r0.xyz).xyzw;
  r1.x = t1.Load(float4(0, 0, 0, 0)).x;
  r0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.rgb *= scene_brightness;
  }
#if 1  // brings down midtones to match SDR when their exposure is the same (only interiors)
  else {
    float3 tonemapped = renodx::tonemap::dice::BT709(r0.rgb, 1.f, 0.025f);
    float mid_gray_ratio = renodx::color::y::from::BT709(renodx::tonemap::dice::BT709(0.18f.xxx, 1.f, 0.025f)) / 0.18f;
    r0.rgb = lerp(tonemapped, r0.rgb * mid_gray_ratio, saturate(renodx::color::y::from::BT709(tonemapped)));
  }
#endif

  o0.xyz = r0.xyz;

  return;
}
