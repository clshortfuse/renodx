// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 17 13:24:14 2024
#include "./shared.h"

Texture3D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

struct t2_t {
  float val[4];
};
StructuredBuffer<t2_t> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[137];
}

cbuffer cb0 : register(b0) {
  float4 cb0[47];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0 : TEXCOORD0,
                                     linear noperspective float2 w0 : TEXCOORD3,
                                                                      linear noperspective float4 v1 : TEXCOORD1,
                                                                                                       linear noperspective float4 v2 : TEXCOORD2,
                                                                                                                                        float2 v3 : TEXCOORD4,
                                                                                                                                                    float4 v4 : SV_POSITION0,
                                                                                                                                                                out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 untonemapped, post_lut;

  r0.xy = max(cb0[15].xy, v0.xy);
  r0.xy = min(cb0[15].zw, r0.xy);
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.xyz = cb1[136].www * r0.xyz;
  r0.xyz = cb0[40].xyz * r0.xyz;
  r1.x = t2[0].val[0 / 4];
  r1.y = t2[0].val[0 / 4 + 1];
  r1.z = t2[0].val[0 / 4 + 2];
  r2.xy = v0.xy * cb0[32].xy + cb0[32].zw;
  r2.xy = max(cb0[33].xy, r2.xy);
  r2.xy = min(cb0[33].zw, r2.xy);
  r2.xyz = t1.Sample(s1_s, r2.xy).xyz;
  r2.xyz = cb1[136].www * r2.xyz;
  r3.xy = w0.xy * cb0[44].zw + cb0[44].xy;
  r3.xy = r3.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
  r3.xyz = t3.Sample(s2_s, r3.xy).xyz;
  r3.xyz = r3.xyz * cb0[41].xyz + float3(1, 1, 1);
  r2.xyz = r3.xyz * r2.xyz;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  r0.xyz = v1.xxx * r0.xyz;
  untonemapped = r0.xyz;

  if (injectedData.toneMapType != 0.f) {
    float3 lut_input = renodx::color::pq::Encode(untonemapped, 100.f);
    post_lut = renodx::lut::Sample(t4, s3_s, lut_input, 32.f);
  } else {
    r0.xyz = float3(0.00999999978, 0.00999999978, 0.00999999978) * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
    r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
    r0.xyz = rcp(r0.xyz);
    r0.xyz = r1.xyz * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
    r0.xyz = t4.Sample(s3_s, r0.xyz).xyz;
  }

  r0.w = v2.w * 543.309998 + v2.z;
  r0.w = sin(r0.w);
  r0.w = 493013 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * 0.00390625 + -0.001953125;
  r0.xyz = r0.xyz * float3(1.25, 1.25, 1.25) + r0.www;
  if (cb0[46].z != 0) {
    r1.xyz = log2(r0.xyz);
    r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
    r1.xyz = r2.xyz / r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(10000, 10000, 10000) * r1.xyz;
    r1.xyz = r1.xyz / cb0[46].yyy;
    r1.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r1.xyz);
    r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r1.xyz = max(float3(0.00313066994, 0.00313066994, 0.00313066994), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r0.xyz = min(r2.xyz, r1.xyz);
  }
  if (injectedData.toneMapType != 0.f) {
    o0.xyz = post_lut;
  } else {
    o0.xyz = r0.xyz;
  }

  o0.w = 0;
  return;
}