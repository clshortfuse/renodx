#include "./common.hlsl"

Texture2DArray<float4> t0 : register(t0);
cbuffer cb1 : register(b1) {
  float4 cb1[43];
}
cbuffer cb0 : register(b0) {
  float4 cb0[6];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5, -0.5) + v1.xy;
  r0.x = dot(r0.xy, cb0[2].xy);
  r0.x = 0.5 + r0.x;
  r0.y = -cb0[4].w + r0.x;
  r0.x = -cb0[3].w + r0.x;
  r0.z = cb0[5].w + -cb0[4].w;
  r0.y = saturate(r0.y / r0.z);
  r1.xyzw = cb0[4].wxyz + -cb0[3].wxyz;
  r0.x = saturate(r0.x / r1.x);
  r0.xzw = r0.xxx * r1.yzw + cb0[3].xyz;
  r1.xyz = cb0[5].xyz + -r0.xzw;
  r0.xyz = r0.yyy * r1.xyz + r0.xzw;
  r0.w = cb0[0].w;
  r0.xyzw = float4(1, 1, 1, 1) + -r0.xyzw;
  r1.xy = cb1[42].xy * v1.xy;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(0, 0);
  r1.xyzw = t0.Load(r1.xyzw).xyzw;
  r1.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
  r2.xyzw = float4(1, 1, 1, 1) + -r1.xyzw;
  r0.xyzw = -r2.xyzw * r0.xyzw + -r1.xyzw;
  r0.xyzw = float4(1, 1, 1, 1) + r0.xyzw;
  r0.xyzw = cb0[0].wwww * r0.xyzw + r1.xyzw;
  o0.w = r0.w;
  o0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  return;
}
