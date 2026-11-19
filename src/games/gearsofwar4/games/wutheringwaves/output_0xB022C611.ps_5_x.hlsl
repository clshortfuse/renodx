#include "../../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jun 12 15:20:21 2025
Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[87];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0: TEXCOORD0,
    linear noperspective float2 w0: TEXCOORD3,
    linear noperspective float4 v1: TEXCOORD1,
    linear noperspective float4 v2: TEXCOORD2,
    float2 v3: TEXCOORD4,
    float4 v4: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = w0.xy * cb0[48].xy + cb0[48].zw;
  r0.zw = cb0[47].zw * r0.xy;
  r1.x = v2.w * 543.309998 + v2.z;
  r1.y = sin(r1.x);
  r1.y = 493013.f * r1.y;
  r2.x = frac(r1.y);

  // r1.y = cmp(0 < cb0[76].x);
  // Add branch for performance if grain is off
  [branch]
  if (0 < cb0[76].x) {
    r1.xz = float2(33.9900017, 66.9899979) + r1.xx;
    r1.xz = sin(r1.xz);
    r1.xz = r1.xz * float2(493013, 493013) + float2(7.17700005, 14.2989998);
    r2.yz = frac(r1.xz);
    r1.xzw = r2.xyz + -r2.xxx;
    r1.xzw = cb0[76].xxx * r1.xzw + r2.xxx;
    r1.xyz = r1.xzw;
  } else {
    r1.xyz = r2.xxx;
  }

  // r1.xyz = r1.yyy ? r1.xzw : r2.xxx;

  r1.w = -r1.x * r1.x + 1;
  r1.w = cb0[75].z * r1.w;
  r0.xy = -r0.xy * cb0[47].zw + v2.xy;
  r0.xy = r1.ww * r0.xy + r0.zw;
  r0.zw = max(cb0[53].xy, r0.xy);
  r0.zw = min(cb0[53].zw, r0.zw);
  r2.xyz = t0.Sample(s0_s, r0.zw).xyz;
  r2.xyz = cb0[69].xyz * r2.xyz;
  r0.xy = cb0[68].xy * r0.xy + cb0[68].zw;
  r0.xy = max(cb0[60].xy, r0.xy);
  r0.xy = min(cb0[60].zw, r0.xy);
  r0.xyz = t1.Sample(s1_s, r0.xy).xyz;
  r0.xyz = r2.xyz * v1.xxx + r0.xyz;
  r2.xy = cb0[73].xy * float2(2, 2) + v1.zw;
  r2.xy = float2(-1, -1) + r2.xy;
  r2.xy = cb0[71].xx * r2.xy;
  r2.xy = cb0[71].zw * r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r1.w = saturate(cb0[72].w);
  r1.w = r1.w * 9 + 1;
  r0.w = r0.w * r1.w + 1;
  r0.w = rcp(r0.w);
  r0.w = r0.w * r0.w;
  r2.xyz = float3(1, 1, 1) + -cb0[72].xyz;
  r2.xyz = r0.www * r2.xyz + cb0[72].xyz;
  r0.xyz = r2.xyz * r0.xyz;

  float3 untonemapped = max(0, r0.xyz);
  [branch]
  if (asint(cb0[86].y) != 0) {
    r2.xyz = r0.xyz * float3(1.36000001, 1.36000001, 1.36000001) + float3(0.0469999984, 0.0469999984, 0.0469999984);
    r2.xyz = r2.xyz * r0.xyz;
    r3.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + float3(0.560000002, 0.560000002, 0.560000002);
    r3.xyz = r0.xyz * r3.xyz + float3(0.140000001, 0.140000001, 0.140000001);
    // r0.xyz = saturate(r2.xyz / r3.xyz);
    r0.xyz = (r2.xyz / r3.xyz);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r0.xyz = saturate(r0.xyz);
    }
  }
  [branch]
  if (asint(cb0[86].z) != 0) {
    r2.xyz = float3(-0.195050001, -0.195050001, -0.195050001) + r0.xyz;
    r2.xyz = float3(-0.163980007, -0.163980007, -0.163980007) / r2.xyz;
    r2.xyz = float3(1.00495005, 1.00495005, 1.00495005) + r2.xyz;
    // r3.xyz = cmp(float3(0.600000024, 0.600000024, 0.600000024) >= r0.xyz);
    // r3.xyz = r3.xyz ? float3(1, 1, 1) : 0;
    r3.xyz = (float3(0.600000024, 0.600000024, 0.600000024) >= r0.xyz) ? float3(1, 1, 1) : 0;
    r4.xyz = -r2.xyz + r0.xyz;
    // r0.xyz = saturate(r3.xyz * r4.xyz + r2.xyz);
    r0.xyz = (r3.xyz * r4.xyz + r2.xyz);
    if (RENODX_TONE_MAP_TYPE == 0) {
      r0.xyz = saturate(r0.xyz);
    }
  }
  [branch]
  if (asint(cb0[86].w) != 0) {
    r2.xyz = cb0[37].yyy * r0.xyz;
    r2.xyz = cb0[37].www * cb0[37].zzz + r2.xyz;
    r3.xy = cb0[38].xx * cb0[38].yz;
    r2.xyz = r0.xyz * r2.xyz + r3.xxx;
    r3.xzw = r0.xyz * cb0[37].yyy + cb0[37].zzz;
    r3.xyz = r0.xyz * r3.xzw + r3.yyy;
    r2.xyz = r2.xyz / r3.xyz;
    r0.w = cb0[38].y / cb0[38].z;
    // r0.xyz = saturate(r2.xyz + -r0.www);
    r0.xyz = (r2.xyz + -r0.www);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r0.xyz = saturate(r0.xyz);
    }
  }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = max(0, r0.xyz);
    r0.xyz = renodx::tonemap::UpgradeToneMap(
        untonemapped,
        renodx::tonemap::renodrt::NeutralSDR(r0.xyz),  // Intentional
        r0.xyz, 1.f);
  }

  r0.xyz = float3(0.00266771927, 0.00266771927, 0.00266771927) + r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953));
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.xyz = t2.Sample(s2_s, r0.xyz).xyz;
  r0.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.xyz;
  // o0.w = saturate(dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114)));
  o0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.w = saturate(o0.w);
  }
  r0.xyz = r1.xyz * float3(0.00390625, 0.00390625, 0.00390625) + r0.xyz;
  r0.xyz = float3(-0.001953125, -0.001953125, -0.001953125) + r0.xyz;
  [branch]
  if (asint(cb0[86].x) != 0) {
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
    r1.xyz = r1.xyz / cb0[85].www;
    r1.xyz =
        max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r1.xyz);
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
  return;
}
