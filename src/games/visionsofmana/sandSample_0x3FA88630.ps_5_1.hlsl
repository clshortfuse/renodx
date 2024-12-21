// ---- Created with 3Dmigoto v1.3.16 on Sat Oct 12 04:28:27 2024
// Sandland part 1 sample

#include "./common.hlsl"
#include "./shared.h"

Texture3D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[136];
}

cbuffer cb0 : register(b0) {
  float4 cb0[68];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0 : TEXCOORD0,
    linear noperspective float2 w0 : TEXCOORD3,
    linear noperspective float3 v1 : TEXCOORD1,
    linear noperspective float4 v2 : TEXCOORD2,
    float2 v3 : TEXCOORD4,
    float4 v4 : SV_POSITION0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.w * 543.309998 + v2.z;
  r0.x = sin(r0.x);
  r0.x = 493013 * r0.x;
  r0.x = frac(r0.x);
  r0.yzw = t0.Sample(s0_s, v0.xy).xyz;
  r0.yzw = cb1[135].zzz * r0.yzw;
  r1.x = dot(r0.yzw, float3(0.300000012, 0.589999974, 0.109999999));
  r1.yz = cb0[37].yz * v0.xy;
  r1.yz = floor(r1.yz);
  r1.yz = (uint2)r1.yz;
  r1.yz = (int2)r1.yz & int2(1, 1);
  r1.yz = (uint2)r1.yz;
  r2.xy = r1.yz * float2(2, 2) + float2(-1, -1);
  r3.x = cb0[38].x * r2.x;
  r3.y = 0;
  r1.yz = v0.xy + r3.xy;
  r1.yzw = t0.Sample(s0_s, r1.yz).xyz;
  r3.xyz = cb1[135].zzz * r1.yzw;
  r2.z = 0;
  r2.zw = r2.zy * cb0[38].xy + v0.xy;
  r4.xyz = t0.Sample(s0_s, r2.zw).xyz;
  r5.xyz = cb1[135].zzz * r4.xyz;
  r3.x = dot(r3.xyz, float3(0.300000012, 0.589999974, 0.109999999));
  r3.y = dot(r5.xyz, float3(0.300000012, 0.589999974, 0.109999999));
  r5.xyz = ddx_fine(r0.yzw);
  r5.xyz = -r5.xyz * r2.xxx + r0.yzw;
  r6.xyz = ddy_fine(r0.yzw);
  r6.xyz = -r6.xyz * r2.yyy + r0.yzw;
  r2.z = ddx_fine(r1.x);
  r3.z = -r2.z * r2.x + r1.x;
  r2.x = ddy_fine(r1.x);
  r3.w = -r2.x * r2.y + r1.x;
  r2.xyzw = -r3.xyzw + r1.xxxx;
  r2.xy = max(abs(r2.xz), abs(r2.yw));
  r1.x = max(r2.x, r2.y);
  r1.x = saturate(-v1.x * r1.x + 1);
  r1.x = cb0[62].y * -r1.x;
  r1.yzw = r1.yzw * cb1[135].zzz + r5.xyz;
  r1.yzw = r4.xyz * cb1[135].zzz + r1.yzw;
  r1.yzw = r1.yzw + r6.xyz;
  r1.yzw = -r0.yzw * float3(4, 4, 4) + r1.yzw;
  r0.yzw = r1.yzw * r1.xxx + r0.yzw;
  r1.xy = cb0[58].zw * v0.xy + cb0[59].xy;
  r1.xy = max(cb0[50].zw, r1.xy);
  r1.xy = min(cb0[51].xy, r1.xy);
  r1.xyz = t1.Sample(s1_s, r1.xy).xyz;
  r1.xyz = cb1[135].zzz * r1.xyz;
  r2.xy = w0.xy * cb0[67].zw + cb0[67].xy;
  r2.xy = r2.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
  r2.xyz = t2.Sample(s2_s, r2.xy).xyz;
  r2.xyz = r2.xyz * cb0[66].xyz + cb0[61].xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.yzw = r0.yzw * cb0[60].xyz + r1.xyz;
  r0.yzw = v1.xxx * r0.yzw;
  r1.xy = cb0[62].xx * v1.yz;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = 1 + r1.x;
  r1.x = rcp(r1.x);
  r1.x = r1.x * r1.x;

  // r0.yzw = r0.yzw * r1.xxx + float3(0.00266771927, 0.00266771927, 0.00266771927);
  // r0.yzw = log2(r0.yzw);
  // r0.yzw = saturate(r0.yzw * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953));
  // r0.yzw = r0.yzw * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  // r0.yzw = t3.Sample(s3_s, r0.yzw).xyz;
  // r1.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.yzw;

  float3 untonemapped = r0.yzw * r1.x;
  // o0.rgb = untonemapped.rgb;
  // o0.w = 1.f;
  // return;
  float3 lut_input = renodx::color::pq::Encode(max(0, untonemapped), 100.f);
  float3 sampled = renodx::lut::Sample(t3, s3_s, lut_input);
  // float3 post_lut = renodx::color::bt2020::from::PQ(sampled, 100.f);
  float3 post_lut = sampled;

  // float3 lut_input = renodx::color::pq::Encode(max(0, untonemapped), 100.f);
  // float3 sampled = renodx::lut::Sample(t3, s3_s, lut_input);
  // float3 post_lut = renodx::color::pq::Decode(sampled, 100.f);
  r0.yzw = post_lut;

  // float3 lut_input = renodx::color::pq::Encode(untonemapped, 100.f);
  // float3 sampled = renodx::lut::Sample(t3, s3_s, lut_input);
  // float3 post_lut = renodx::color::pq::Decode(sampled, 100.f);

  o0.w = saturate(dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114)));
  r0.x = r0.x * 0.00390625 + -0.001953125;
  r0.xyz = r0.yzw * float3(1.04999995, 1.04999995, 1.04999995) + r0.xxx;

  if (cb0[65].x != 0) {
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
    r1.xyz = r1.xyz / cb0[64].www;
    r1.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r1.xyz);
    r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r1.xyz = max(float3(0.00313066994, 0.00313066994, 0.00313066994), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    o0.xyz = min(r2.xyz, r1.xyz);
  } else {
    o0.xyz = r0.xyz;
  }

  o0.rgb = post_lut.rgb;
  o0.w = 1.f;

  o0.rgb = scalePaperWhite(o0.rgb);
}
