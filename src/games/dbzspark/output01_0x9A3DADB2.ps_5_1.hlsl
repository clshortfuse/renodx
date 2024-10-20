// ---- Created with 3Dmigoto v1.3.16 on Fri Oct 18 16:48:44 2024
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

  r0.xy = w0.xy * cb0[44].zw + cb0[44].xy;
  r1.xyzw = cmp(float4(0, 0, 0, 0) < r0.xyxy);
  r2.xyzw = cmp(r0.xyxy < float4(0, 0, 0, 0));
  r1.xyzw = (int4)-r1.xyzw + (int4)r2.xyzw;
  r1.xyzw = (int4)r1.xyzw;
  r2.xyzw = saturate(-cb0[42].zzzz + abs(r0.xyxy));
  r1.xyzw = r2.xyzw * r1.xyzw;
  r1.xyzw = -r1.xyzw * cb0[42].xxyy + r0.xyxy;
  r1.xyzw = r1.xyzw * cb0[45].zwzw + cb0[45].xyxy;
  r1.xyzw = r1.xyzw * cb0[10].xyxy + cb0[10].zwzw;
  r1.xyzw = cb0[9].zwzw * r1.xyzw;
  r1.xyzw = max(cb0[15].xyxy, r1.xyzw);
  r1.xyzw = min(cb0[15].zwzw, r1.xyzw);
  r2.x = t0.Sample(s0_s, r1.xy).x;
  r2.y = t0.Sample(s0_s, r1.zw).y;
  r0.zw = max(cb0[15].xy, v0.xy);
  r0.zw = min(cb0[15].zw, r0.zw);
  r2.z = t0.Sample(s0_s, r0.zw).z;
  r1.xyz = cb1[136].www * r2.xyz;
  r1.xyz = cb0[40].xyz * r1.xyz;
  r2.x = t2[0].val[0 / 4];
  r2.y = t2[0].val[0 / 4 + 1];
  r2.z = t2[0].val[0 / 4 + 2];
  r0.zw = v0.xy * cb0[32].xy + cb0[32].zw;
  r0.zw = max(cb0[33].xy, r0.zw);
  r0.zw = min(cb0[33].zw, r0.zw);
  r3.xyz = t1.Sample(s1_s, r0.zw).xyz;
  r3.xyz = cb1[136].www * r3.xyz;
  r0.xy = r0.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
  r0.xyz = t3.Sample(s2_s, r0.xy).xyz;
  r0.xyz = r0.xyz * cb0[41].xyz + float3(1, 1, 1);
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = r1.xyz * r2.xyz + r0.xyz;
  r0.xyz = v1.xxx * r0.xyz;
  r1.xy = cb0[43].xx * v1.zw;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + r0.w;
  r0.w = rcp(r0.w);
  r0.w = r0.w * r0.w;
  untonemapped = r0.xyz;

  r0.xyz = r0.xyz * r0.www;
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
  post_lut = r0.xyz;

  float3 lut_input = renodx::color::pq::Encode(untonemapped, 100.f);
  post_lut = renodx::lut::Sample(t4, s3_s, lut_input, 32.f);
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
  o0.xyz = r0.xyz;
  o0.rgb = post_lut;

  o0.w = 0;
  return;
}