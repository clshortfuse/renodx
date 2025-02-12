#include "../shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb 11 11:37:42 2025
Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[97];
}

// 3Dmigoto declarations
#define cmp -

void main(linear noperspective float2 w0: TEXCOORD0,
          linear noperspective float2 v0: TEXCOORD3,
          linear noperspective float4 v1: TEXCOORD1,
          linear noperspective float4 v2: TEXCOORD2, float2 v3: TEXCOORD4,
          float4 v4: SV_POSITION0, out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb0[48].xy + cb0[48].zw;
  r0.xy = cb0[47].zw * r0.xy;
  r0.z = v2.w * 543.309998 + v2.z;
  r0.w = sin(r0.z);
  r0.w = 493013.f * r0.w;
  r1.x = frac(r0.w);

  // r0.w = cmp(0 < cb0[76].x);
  // Add branch for performance if grain is off
  [branch]
  if (0 < cb0[76].x) {
    r2.xy = float2(33.9900017, 66.9899979) + r0.zz;
    r2.xy = sin(r2.xy);
    r2.xy = r2.xy * float2(493013, 493013) + float2(7.17700005, 14.2989998);
    r1.yz = frac(r2.xy);
    r1.yzw = r1.xyz + -r1.xxx;
    r1.yzw = cb0[76].xxx * r1.yzw + r1.xxx;
    r1.xyz = r1.yzw;
  } else {
    r1.xyz = r1.xxx;
  }
  // r1.xyz = r0.www ? r1.yzw : r1.xxx;

  // r2.yw = cb0[96].zz * cb0[95].xy;

  r2.yw = cb0[96].zz * cb0[95].xy;

  // r0.z = cmp(cb0[96].x == 0.000000);
  // r2.xz = r0.zz ? r2.yw : cb0[95].xy;
  r2.xz = (cb0[96].x == 0.f) ? r2.yw : cb0[95].xy;

  // r3.xyzw = v0.xyzw * cb0[92].zwzw + cb0[92].xyxy;
  r3.xyzw = v0.xyxy * cb0[92].zwzw + cb0[92].xyxy;

  // r4.xyzw = cmp(float4(0,0,0,0) < r3.zwzw);
  // r5.xyzw = cmp(r3.zwzw < float4(0,0,0,0));
  // r4.xyzw = (int4)-r4.xyzw + (int4)r5.xyzw;
  // r4.xyzw = (int4)r4.xyzw;

  r4.xyzw = sign(r3.zwzw);

  r5.xyzw = saturate(-cb0[95].zzzz + abs(r3.zwzw));
  r4.xyzw = r5.xyzw * r4.xyzw;
  r2.xyzw = -r4.ywxz * r2.ywxz + r3.ywxz;

  // r0.z = cmp(0 < cb0[96].x);
  bool r0zb = 0 < cb0[96].x;

  // r3.xy = -cb0[96].ww * float2(0.400000006, 0.200000003) + r2.xy;
  // r2.xy = r0.zz ? r3.xy : r2.xy;

  if (0 < cb0[96].x) {
    r2.xy = -cb0[96].ww * float2(0.400000006, 0.200000003) + r2.xy;
  }

  r2.xyzw = r2.zxwy * cb0[93].zwzw + cb0[93].xyxy;
  r2.xyzw = r2.xyzw * cb0[48].xyxy + cb0[48].zwzw;
  r2.xyzw = cb0[47].zwzw * r2.xyzw;
  r3.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r4.x = t0.Sample(s0_s, r2.xy).x;
  r4.y = t0.Sample(s0_s, r2.zw).y;
  r0.w = dot(r3.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.w = -cb0[96].y + r0.w;
  r0.w = saturate(10 * r0.w);
  r1.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.w * r0.w;
  r4.z = r3.z;
  r2.xyz = r4.xyz + -r3.xyz;
  r2.xyz = r0.www * r2.xyz + r3.xyz;
  r2.xyz = r2.xyz + -r4.xyz;
  r2.xyz = cb0[96].xxx * r2.xyz + r4.xyz;
  // r2.xyz = r0.zzz ? r2.xyz : r4.xyz;
  r2.xyz = (0 < cb0[96].x) ? r2.xyz : r4.xyz;

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
  [branch]
  if (asint(cb0[86].y) != 0) {
    r2.xyz = r0.xyz * float3(1.36000001, 1.36000001, 1.36000001) + float3(0.0469999984, 0.0469999984, 0.0469999984);
    r2.xyz = r2.xyz * r0.xyz;
    r3.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + float3(0.560000002, 0.560000002, 0.560000002);
    r3.xyz = r0.xyz * r3.xyz + float3(0.140000001, 0.140000001, 0.140000001);
    // r0.xyz = saturate(r2.xyz / r3.xyz);
    r0.xyz = (r2.xyz / r3.xyz);
    if (RENODX_TONE_MAP_TYPE == 0) {
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
    if (RENODX_TONE_MAP_TYPE == 0) {
      r0.xyz = saturate(r0.xyz);
    }
  }
  r0.xyz = float3(0.00266771927, 0.00266771927, 0.00266771927) + r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953));
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.xyz = t2.Sample(s2_s, r0.xyz).xyz;
  r0.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.xyz;
  // o0.w = saturate(dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114)));
  o0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  if (RENODX_TONE_MAP_TYPE == 0) {
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
