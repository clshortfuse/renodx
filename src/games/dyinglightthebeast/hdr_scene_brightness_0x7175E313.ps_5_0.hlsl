#include "./common.hlsli"

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

  float autoexposure = t1.Load(int3(0, 0, 0)).x;

  float3 scene_original = r0.rgb;

#if 1  // slightly reduce autoexposure strength for higher values
  if (USE_CUSTOM_AUTOEXPOSURE != 0.f) {
    float y = renodx::color::y::from::BT709(r0.rgb * autoexposure);
    // from 0.18 - 1.18 luminance, ramp down autoexposure strength
    float t = saturate(y - 0.18f);
    float strength = lerp(1.f, 0.95f, t * t * t);  // lower from 100% -> 95%
    autoexposure = lerp(1.f, autoexposure, strength);
  }
#endif

  float3 scene_exposed = autoexposure * scene_original;

  o0.w = r0.w;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    scene_exposed *= scene_brightness;
  }

  o0.xyz = scene_exposed;

  return;
}
