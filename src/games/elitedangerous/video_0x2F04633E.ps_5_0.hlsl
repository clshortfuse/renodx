#include "./common.hlsli"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[1];
}

void main(
    float2 v0: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s0_s, v0.xy).x;
  r0.x = -0.5 + r0.x;
  r0.xy = float2(0.391000003, 2.01799989) * r0.xx;
  r0.z = t0.Sample(s0_s, v0.xy).x;
  r0.z = -0.0625 + r0.z;
  r0.x = r0.z * 1.16400003 + -r0.x;
  r0.y = r0.z * 1.16400003 + r0.y;
  r1.z = log2(max(0, r0.y));  // clamp negatives
  r0.y = t2.Sample(s0_s, v0.xy).x;
  r0.y = -0.5 + r0.y;
  r0.x = -r0.y * 0.813000023 + r0.x;
  r0.y = 1.59599996 * r0.y;
  r0.y = r0.z * 1.16400003 + r0.y;
  r1.x = log2(max(0, r0.y));  // clamp negatives
  r1.y = log2(max(0, r0.x));  // clamp negatives
  r0.xyz = cb2[0].xxx * r1.xyz;
  r0.w = 1 / 2.2f;  // r0.w = 1 / cb2[0].y;
  r0.xyz = r0.www * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;

  o0.rgb = GameScale(o0.rgb);
  return;
}
