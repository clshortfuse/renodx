#include "./common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[43];
}
cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r1.rgb = renodx::color::gamma::EncodeSafe(r0.rgb, 2.4f);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
  r0.w = -1 + r0.w;
  r0.w = cb0[1].x * r0.w + 1;
  r0.w = cb0[0].w * r0.w;
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  r1.xyz = cb0[0].xyz * r0.xyz;
  r0.xy = cb1[42].xy * v1.xy;
  r2.xy = (uint2)r0.xy;
  r2.zw = float2(0, 0);
  r2.xyzw = t0.Load(r2.xyzw).xyzw;
  r0.rgb = renodx::color::gamma::EncodeSafe(r2.rgb, 2.4f);
  r0.xyz = r0.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r3.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r2.xyz;
  r4.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r2.xyz);
  r2.xyz = r4.xyz ? r3.xyz : r0.xyz;
  r3.xyzw = t2.Sample(s1_s, v1.xy).xyzw;
  r0.r = renodx::color::gamma::EncodeSafe(r3.r, 2.4f);
  r0.x = r0.x * 1.05499995 + -0.0549999997;
  r0.y = 12.9200001 * r3.x;
  r0.z = cmp(0.00313080009 >= r3.x);
  r0.x = r0.z ? r0.y : r0.x;
  r0.y = cb0[1].y + -r0.x;
  r0.x = cmp(cb0[1].y >= r0.x);
  r0.x = r0.x ? 1.000000 : 0;
  r0.y = saturate(r0.y / cb0[1].z);
  r0.x = r0.x * r0.y;
  r1.w = r0.w * r0.x;
  r0.xyzw = -r2.xyzw + r1.xyzw;
  r0.xyzw = r1.wwww * r0.xyzw + r2.xyzw;
  o0.w = r0.w;
  o0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  return;
}
