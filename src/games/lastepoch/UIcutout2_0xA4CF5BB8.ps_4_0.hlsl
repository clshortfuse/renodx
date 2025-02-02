#include "./common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[1];
}
cbuffer cb0 : register(b0) {
  float4 cb0[12];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    float4 v4: TEXCOORD3,
    float3 v5: TEXCOORD4,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[0].yy * cb0[8].zy + v1.zw;
  r0.zw = float2(0.300000012, 0.300000012) + r0.xy;
  r1.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.xyzw = cb0[10].xyzw * r0.xyzw;
  r1.y = -cb0[8].x + v1.y;
  r1.x = v1.x;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.x = cb1[0].x + v2.x;
  r1.y = -cb0[8].x + v2.y;
  r1.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = cb0[11].xyzw * r1.xyzw;
  r2.xyzw = r1.xyzw * r0.xyzw;
  r2.xyzw = r2.xyzw * float4(5, 5, 5, 5) + r1.xyzw;
  r1.xyzw = r2.xyzw * r1.wwww;
  r1.xyzw = cb0[11].wwww * r1.xyzw;
  r0.xyzw = r1.xyzw * float4(2, 2, 2, 2) + r0.xyzw;
  r1.xyzw = t3.Sample(s3_s, v2.zw).xyzw;
  o0.w = r1.w * r0.w;
  o0.xyz = r0.xyz;
  o0.rgb = UIScale(o0.rgb);
  return;
}
