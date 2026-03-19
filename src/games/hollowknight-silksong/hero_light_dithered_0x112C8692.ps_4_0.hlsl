#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Mar 18 21:34:56 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: TEXCOORD0,
    float4 v3: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  // r1.xyzw = r0.wxyz * v1.wxyz + float4(-0.00999999978, -0.5, -0.5, -0.5);
  // Fast alpha skips below 0.01 which is too low
  float alpha_clamp = 0.0001f;

  r1.xyzw = r0.wxyz * v1.wxyz + float4(-alpha_clamp, -0.5, -0.5, -0.5);
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r2.xy = v3.xy / v3.ww;
  r2.xy = float2(1, 1) + r2.xy;
  r2.x = 0.5 * r2.x;
  r2.z = -r2.y * 0.5 + 1;
  r2.xyzw = t1.Sample(s1_s, r2.xz).xyzw;
  r1.xyz = r1.yzw * float3(2, 2, 2) + r2.xyz;
  r2.xyz = r0.xyz * float3(2, 2, 2) + r2.xyz;
  r2.xyz = float3(-1, -1, -1) + r2.xyz;
  r3.xyz = cmp(float3(0.5, 0.5, 0.5) < r0.xyz);
  r0.xyz = r3.xyz ? r1.xyz : r2.xyz;

  // InterleavedGradientNoise
  // https://bartwronski.com/2016/10/30/dithering-part-three-real-world-2d-quantization-dithering/
  // https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare/
  r1.x = dot(v0.xy, float2(0.0671105608, 0.00583714992));
  r1.x = frac(r1.x);
  r1.x = 52.9829178 * r1.x;
  r1.x = frac(r1.x);
  r1.x = r1.x * 0.00392156886 + -0.00196078443;

  o0.xyz = r1.xxx + r0.xyz;
  o0.w = r1.x + r0.w;

  o0.w *= CUSTOM_HERO_LIGHT;
  return;
}
