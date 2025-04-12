#include "../common.hlsli"
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy * cb0[2].xy + cb0[2].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = 1 / cb1[0].x;
  r0.x = r0.w + -r0.x;
  // clang-format off
  r0.x = saturate(+1.#INF * r0.x);  // r0.x = saturate(inf * r0.x);
  // clang-format on
  r1.x = cb1[0].x;
  r1.y = 1;
  r0.yz = v2.xy * r1.xy;
  r0.zw = frac(r0.yz);
  r0.y = floor(r0.y);
  r1.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.z = cmp(0.100000001 >= r1.y);
  r0.z = r0.z ? -1 : -0;
  r0.z = r1.x + r0.z;
  r0.z = 1 + r0.z;
  r0.z = saturate(r1.z + -r0.z);
  r0.x = saturate(r0.z * r0.x + r1.x);
  r0.zw = float2(0.0250000004, -1) + cb1[0].zy;
  r0.yw = r0.yw / cb1[0].xx;
  r0.y = cmp(r0.w >= r0.y);
  r0.y = r0.y ? 1.000000 : 0;
  r0.w = r1.y + -r0.z;
  r0.z = cb1[0].z + -r0.z;
  r0.z = 1 / r0.z;
  r0.z = saturate(r0.w * r0.z);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = -r0.w * r0.z + 1;
  r0.x = r0.y * r0.z + r0.x;
  r1.xyzw = v1.xyzw * v1.xyzw;
  o0.xyzw = r1.xyzw * r0.xxxx;

  o0.rgb = UIScale(o0.rgb);
  return;
}
