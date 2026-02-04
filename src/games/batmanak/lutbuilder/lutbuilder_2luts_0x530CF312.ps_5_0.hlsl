#include "./lutbuilder.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb  3 23:58:22 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[17];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = float2(-0.001953125, -0.03125) + v0.xy;
  r1.x = 16 * r0.x;
  r0.y = frac(r1.x);
  r0.w = -r0.y * 0.0625 + r0.x;
  r0.xyz = cb0[14].xxx * r0.yzw;
  r0.xyz = float3(1.06666672, 1.06666672, 1.06666672) * r0.xyz;
  r0.w = 0;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyzw = cb0[15].xxxx * r1.xyzw + r0.xyzw;
  r1.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r0.xyzw = cb0[16].xxxx * r1.xyzw + r0.xyzw;
  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = saturate(-cb0[6].xyz + r1.xyz);
  r1.xyz = cb0[7].xyz * r1.xyz;
  r1.xyz = ConditionalMax(float3(9.99999994e-09, 9.99999994e-09, 9.99999994e-09), r1.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = cb0[8].xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.w = dot(r1.xyz, cb0[9].xyz);
  r1.xyz = r1.xyz * cb0[6].www + r1.www;
  r1.xyz = r1.xyz * cb0[11].xyz + cb0[12].xyz;
  r1.xyz = cb0[10].xyz * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r1.xyz;
  r0.xyz = exp2(r1.xyz);
  r0.xyzw = ConditionalMax(float4(9.99999994e-09, 9.99999994e-09, 9.99999994e-09, 9.99999994e-09), r0.xyzw);
  r0.xyzw = log2(r0.xyzw);
  r1.x = 2.20000005 * cb0[11].w;
  r0.xyzw = r1.xxxx * r0.xyzw;
  o0.xyzw = exp2(r0.xyzw);

  o0.rgb = ConditionalSaturate(o0.rgb);  // originally rgba8_unorm

  return;
}
