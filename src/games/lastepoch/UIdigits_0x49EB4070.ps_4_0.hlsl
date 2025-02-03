#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[1];
}
cbuffer cb0 : register(b0) {
  float4 cb0[30];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: COLOR1,
    float4 v3: TEXCOORD0,
    float4 v4: TEXCOORD1,
    float4 v5: TEXCOORD2,
    float4 v6: TEXCOORD3,
    float2 v7: TEXCOORD4,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v6.xy).xyzw;
  r0.x = saturate(r0.w * v7.x + -v7.y);
  r1.xyz = cb0[18].xyz * cb0[18].www;
  r1.w = cb0[18].w;
  r0.xyzw = r1.xyzw * r0.xxxx;
  r1.x = cb1[0].y + -cb0[29].y;
  r1.x = min(cb0[29].z, r1.x);
  r1.x = r1.x / cb0[29].z;
  r1.x = -0.0500000007 + r1.x;
  r1.x = saturate(2.22222233 * r1.x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = -r1.y * r1.x + 1;
  r2.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r1.yz = saturate(r2.ww * v4.xx + -v4.zy);
  r1.z = r1.z * r1.x;
  r2.xyzw = -v2.xyzw + v1.xyzw;
  r2.xyzw = r1.yyyy * r2.xyzw + v2.xyzw;
  r3.xyzw = r2.xyzw * r1.zzzz;
  r1.y = -r2.w * r1.z + 1;
  r0.xyzw = r0.xyzw * r1.yyyy + r3.xyzw;
  r0.xyzw = v6.zzzz * r0.xyzw;
  o0.w = r0.w * r1.x;
  o0.xyz = r0.xyz;
  o0.rgb = UIScale(o0.rgb);
  return;
}
