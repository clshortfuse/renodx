#include "../common/tonemap.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);  // blur/bloom?
Texture2D<float4> t1 : register(t1);  // render
Texture2D<float4> t2 : register(t2);  // 1x1 gray?
Texture2D<float4> t3 : register(t3);  // first-hand hand on alpha

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb2 : register(b2) {
  float4 cb2[5];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.Sample(s1_s, v1.xy).xyz;

  const float3 renderInput = r0.xyz;

  r0.w = t3.Sample(s3_s, v1.xy).w;

  const float handMask = r0.w;

  r0.w = r0.w * 255 + -4;
  r0.w = cmp(abs(r0.w) < 0.25);
  r1.xy = cb2[4].zw * v1.xy;
  r1.xyz = t0.Sample(s0_s, r1.xy).xyz;
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r0.w = t2.Sample(s2_s, v1.xy).x;
  r1.w = 0.00100000005 + r0.w;
  r1.w = cb2[1].z / r1.w;
  r2.x = cmp(r1.w < cb2[1].y);
  r1.w = r2.x ? cb2[1].y : r1.w;
  r2.x = cmp(cb2[1].x < r1.w);
  r1.w = r2.x ? cb2[1].x : r1.w;

  r0.xyz = r1.xyz * injectedData.fxBloom + r0.xyz;
  r0.xyz = r0.xyz * r1.www;  // Hand glow?
  const float3 untonemapped = r0.xyz;

  // Hable
  // ((x * (a * x + c * b) + d * e) / (x * (a * x + b) + d * f)) - e / f;
  // Modified
  // ((2x * (a * x + c * b) + d * e) / (2x * (a * x + b) + d * f)) - e / f;
  // float A = 0.30;      // Shoulder Strength
  // float B = 0.50;      // Linear Strength
  // float C = 0.10;      // Linear Angle
  // float D = 0.20;      // Toe Strength
  // float E = cb2[1].w;  // Toe Numerator (commonly 0.02)
  // float F = 0.30;      // Toe Denominator
  // float W = 5.6;
  // C * B = 0.05;

  if (injectedData.toneMapType == 0.f) {
    // r1.xyz = r0.xyz + r0.xyz;
    // r2.xyz = r0.xyz * 0.30f + 0.05f;               // (x * a + c * b)
    // r3.xy = float2(0.20f, 3.333333f) * cb2[1].ww;  // d*e, e/f
    // r2.xyz = r1.xyz * r2.xyz + r3.xxx;             // 2x * (x * a + c * b) + (d * e)
    // r0.xyz = r0.xyz * 0.30f + 0.5f;                // (x * a + b)
    // r0.xyz = r1.xyz * r0.xyz + 0.06f;              // 2x * ((x * a + b) + (d * f)
    // r0.xyz = r2.xyz / r0.xyz;                      // ((x * (a * x + c * b) + d * e) / (x * (a * x + b) + d * f))
    // r0.xyz = -cb2[1].www * 3.333333f + r0.xyz;     // r0.xyz - (e / f);

    // r1.x = cb2[1].w * 0.20f + 19.3759995;  // (2x * (x * a + c * b) + (d * e) )
    // r1.x = r1.x * 0.0408563502 + -r3.y;    // r1.x / (24.476) - (e / f)
    // r1.x = 1 / r1.x;                       // rcp
    // r1.xyz = r1.xxx * r0.xyz;              // toneMap / tonemap(white)

    r1.xyz = toneMapCurve(untonemapped, 0.30f, 0.50f, 0.10f, 0.20f, cb2[1].w, 0.30f)
           / toneMapCurve(5.6f, 0.30f, 0.50f, 0.10f, 0.20f, cb2[1].w, 0.30f);
  } else {
    r1.xyz = untonemapped;
  }

  r0.x = dot(r1.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
  r1.w = 0;
  r1.xyzw = r1.xyzw + -r0.xxxx;
  r1.xyzw = cb2[2].xxxx * r1.xyzw + r0.xxxx;
  r2.xyzw = r0.xxxx * cb2[3].xyzw + -r1.xyzw;
  r1.xyzw = cb2[3].wwww * r2.xyzw + r1.xyzw;
  r1.xyzw = cb2[2].wwww * r1.xyzw + -r0.wwww;
  o0.xyzw = cb2[2].zzzz * r1.xyzw + r0.wwww;
  return;
}
