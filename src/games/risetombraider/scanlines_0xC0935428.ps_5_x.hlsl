#include "./shared.h"

cbuffer GammaBuffer : register(b10) {
  float4 gammaValue : packoffset(c0);
}

SamplerState Sampler0_s : register(s0);
Texture2D<float4> InstanceTexture0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  const float4 icb[] = { { 0, 7.000000, 15.000000, 0 },
                         { 3.000000, 4.000000, 12.000000, 0 },
                         { 15.000000, 8.000000, 0, 0 },
                         { 12.000000, 11.000000, 3.000000, 0 },
                         { 10.000000, 13.000000, 5.000000, 0 },
                         { 14.000000, 9.000000, 1.000000, 0 },
                         { 5.000000, 2.000000, 10.000000, 0 },
                         { 1.000000, 6.000000, 14.000000, 0 },
                         { 7.000000, 0, 8.000000, 0 },
                         { 4.000000, 3.000000, 11.000000, 0 },
                         { 8.000000, 15.000000, 7.000000, 0 },
                         { 11.000000, 12.000000, 4.000000, 0 },
                         { 13.000000, 10.000000, 2.000000, 0 },
                         { 9.000000, 14.000000, 6.000000, 0 },
                         { 2.000000, 5.000000, 13.000000, 0 },
                         { 6.000000, 1.000000, 9.000000, 0 } };
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)v0.xy;
  r0.y = (uint)r0.y << 2;
  r0.xy = (int2)r0.xy & int2(3, 12);
  r0.x = (int)r0.x + (int)r0.y;
  r0.x = icb[r0.x + 0].x + 0.5;
  r0.x = r0.x * 0.0625 + -0.5;
  r0.y = 0.454545468 * gammaValue.x;
  r1.xyzw = InstanceTexture0.Sample(Sampler0_s, v2.xy).xyzw;
  if (CUSTOM_FILM_GRAIN_TYPE == 2.f) {
    r1.rgb = renodx::effects::ApplyFilmGrain(
        r1.rgb,
        v2.xy,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);
  }

  float3 original = r1.rgb;

  // r1.xyz = max(float3(0,0,0), r1.xyz);
  o0.w = r1.w;
  // r1.xyz = log2(r1.xyz);
  // r0.yzw = r1.xyz * r0.yyy;
  // r0.yzw = exp2(r0.yzw);

  o0.rgb = original;
  return;
  if (!CUSTOM_SCAN_LINES) {
    o0.rgb = original;
    return;
  }

  r0.yzw = renodx::math::SignPow(r1.xyz, r0.y);

  // r0.xyz = saturate(r0.xxx * float3(0.00390625,0.00390625,0.00390625) + r0.yzw);
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  // o0.xyz = exp2(r0.xyz);

  o0.xyz = renodx::math::SignPow(r0.x * 0.00390625 + r0.yzw, 2.2f);

  // Scanlines
  o0.rgb = lerp(original, o0.rgb, CUSTOM_SCAN_LINES);
  return;
}
