#include "./shared.h"

// Writes to bloom texture

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0) { float4 cb0[10]; }

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(16, 16, 1)] void main(uint2 vThreadID
                                  : SV_DispatchThreadID) {
  const float4 icb[] = {
    {0.200000, 0, 0, 0},
    {0.420000, 0, 0, 0},
    {0.520000, 0, 0, 0},
    {0.580000, 0, 0, 0},
    {0.810000, 0, 0, 0},
    {0.900000, 0, 0, 0}
  };
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xy = (int2)vThreadID.xy;
  r0.xy = r0.xy / cb0[6].xy;
  r0.zw = float2(1, 1) / cb0[6].xy;
  r0.xy = r0.zw * float2(0.5, 0.5) + r0.xy;
  r1.xz = float2(0, 0);
  r1.yw = float2(0.5, 2.5) * cb0[7].yy;
  r2.xy = r1.zy + r0.xy;
  r2.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r3.xz = float2(0, 0);
  r3.yw = float2(2.5, 6.5) * cb0[7].yy;
  r3.xyzw = r3.xyzw + r0.xyxy;
  r4.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
  r4.xyzw = float4(0.129032254, 0.129032254, 0.129032254, 0.129032254) * r4.xyzx;
  r2.xyzw = r2.xyzx * float4(0.309677422, 0.309677422, 0.309677422, 0.309677422) + r4.xyzw;
  r4.xz = float2(0, 0);
  r4.yw = float2(4.5, 6.5) * cb0[7].yy;
  r3.xy = r4.zy + r0.xy;
  r5.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
  r2.xyzw = r5.xyzx * float4(0.0580645166, 0.0580645166, 0.0580645166, 0.0580645166) + r2.xyzw;
  r3.xyz = t0.SampleLevel(s0_s, r3.zw, 0).xyz;
  r2.xyzw = r3.xyzx * float4(0.0032258064, 0.0032258064, 0.0032258064, 0.0032258064) + r2.xyzw;
  r1.xyzw = -r1.xyzw + r0.xyxy;
  r3.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  r2.xyzw = r3.xyzx * float4(0.309677422, 0.309677422, 0.309677422, 0.309677422) + r2.xyzw;
  r1.xyz = t0.SampleLevel(s0_s, r1.zw, 0).xyz;
  r1.xyzw = r1.xyzx * float4(0.129032254, 0.129032254, 0.129032254, 0.129032254) + r2.xyzw;
  r2.xyzw = -r4.xyzw + r0.xyxy;
  r3.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r1.xyzw = r3.xyzx * float4(0.0580645166, 0.0580645166, 0.0580645166, 0.0580645166) + r1.xyzw;
  r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
  r1.xyzw = r2.xyzx * float4(0.0032258064, 0.0032258064, 0.0032258064, 0.0032258064) + r1.xyzw;
  r2.xyzw = float4(1, 1, 1, 1) + -r0.xyxy;
  r3.xy = -cb0[9].yz * float2(0.5, 0.5) + r0.xy;
  r3.z = dot(r3.xy, r3.xy);
  r3.z = rsqrt(r3.z);
  r3.xy = r3.xy * r3.zz;
  r3.zw = float2(0.0700000003, 0.0700000003) * r3.xy;
  r4.xy = r3.xy * float2(0.48999998, 0.48999998) + r2.zw;
  r5.x = t0.SampleLevel(s0_s, r4.xy, 0).x;
  r4.zw = r3.xy * float2(0.0139999995, 0.0139999995) + r4.xy;
  r5.y = t0.SampleLevel(s0_s, r4.zw, 0).y;
  r4.xy = r3.xy * float2(0.027999999, 0.027999999) + r4.xy;
  r5.z = t0.SampleLevel(s0_s, r4.xy, 0).z;
  r4.xy = -r3.xy * float2(0.200000003, 0.200000003) + r0.xy;
  r6.x = t0.SampleLevel(s0_s, r4.xy, 0).x;
  r4.zw = r3.xy * float2(0.0160000008, 0.0160000008) + r4.xy;
  r6.y = t0.SampleLevel(s0_s, r4.zw, 0).y;
  r3.xy = r3.xy * float2(0.0320000015, 0.0320000015) + r4.xy;
  r6.z = t0.SampleLevel(s0_s, r3.xy, 0).z;
  r4.xyz = r6.xyz + r5.xyz;
  r2.xyzw = r2.xyzw + -r0.xyxy;
  r5.xyz = r4.xyz;
  r3.x = 0;
  while (true) {
    r3.y = cmp((int)r3.x >= 6);
    if (r3.y != 0) break;
    r6.xyzw = icb[r3.x + 0].xxxx * r2.xyzw + r0.xyxy;
    r3.y = icb[r3.x + 0].x * 2 + -1;
    r6.xyzw = r3.zwzw * r3.yyyy + r6.xyzw;
    r7.xyzw = r6.zwzw + -r0.xyxy;
    r8.x = t0.SampleLevel(s0_s, r6.zw, 0).x;
    r6.xyzw = r7.xyzw * float4(0.0199999996, 0.0199999996, 0.0399999991, 0.0399999991) + r6.xyzw;
    r8.y = t0.SampleLevel(s0_s, r6.xy, 0).y;
    r8.z = t0.SampleLevel(s0_s, r6.zw, 0).z;
    r5.xyz = r8.xyz + r5.xyz;
    r3.x = (int)r3.x + 1;
  }
  r2.xyzw = r5.xyzx;
  r2.xyzw = float4(0.166666672, 0.166666672, 0.166666672, 0.166666672) * r2.xyzw;
  r3.xyz = t3.SampleLevel(s0_s, r0.xy, 0).xyz;
  r3.xyzw = r3.xyzx * float4(8, 8, 8, 8) + float4(0.75, 0.75, 0.75, 0.75);
  r2.xyzw = r3.xyzw * r2.xyzw;
  r2.xyzw = cb0[9].xxxx * r2.xyzw;  // Actual lens flare
  r1.xyzw = r1.xyzw * float4(2.75, 2.75, 2.75, 2.75) + r2.xyzw;
  r2.xyz = t1.SampleLevel(s0_s, r0.xy, 0).xyz;
  r1.xyzw = r1.xyzw * cb0[8].xxxx * CUSTOM_LENS_FLARE + r2.xyzx * CUSTOM_BLOOM;  // Blurred Lens Flare + Bloom
  r2.xy = -r0.zw * float2(1, 0) + r0.xy;
  r2.xyz = t1.SampleLevel(s0_s, r2.xy, 0).xyz;
  r2.x = dot(r2.xyz, float3(1, 1, 1));
  r2.yz = r0.zw * float2(1, 0) + r0.xy;
  r2.yzw = t1.SampleLevel(s0_s, r2.yz, 0).xyz;
  r2.y = dot(r2.yzw, float3(1, 1, 1));
  r2.zw = -r0.zw * float2(0, 1) + r0.xy;
  r3.xyz = t1.SampleLevel(s0_s, r2.zw, 0).xyz;
  r2.z = dot(r3.xyz, float3(1, 1, 1));
  r0.zw = r0.zw * float2(0, 1) + r0.xy;
  r3.xyz = t1.SampleLevel(s0_s, r0.zw, 0).xyz;
  r0.z = dot(r3.xyz, float3(1, 1, 1));
  r3.x = r2.x + -r2.y;
  r3.y = r2.z + -r0.z;
  r3.z = 0.0500000007;
  r0.z = dot(r3.xyz, r3.xyz);
  r0.z = rsqrt(r0.z);
  r0.zw = r3.xy * r0.zz;
  r0.zw = float2(0.125, 0.125) * r0.zw;
  r2.x = -r0.z * r0.z + 1;
  r2.x = r0.w * r0.w + r2.x;
  r2.x = 3 * r2.x;
  r2.y = saturate(dot(r1.wyz, float3(0.333000004, 0.333000004, 0.333000004)));
  r0.xy = r0.xy * float2(3, 3) + r0.zw;
  r0.xyz = t3.SampleLevel(s1_s, r0.xy, r2.x).xyz;  // Kaleidoscope lens flare
  r0.xyzw = r0.xyzx * r0.xyzx;
  r0.xyzw = r0.xyzw * r2.yyyy;
  r0.xyzw = r0.xyzw * float4(10, 10, 10, 10) + float4(1, 1, 1, 1);
  r2.xy = vThreadID.xy;
  r2.zw = float2(0, 0);
  r2.xyz = t2.Load(r2.xyz).xyz;  // Cross Lens Flare
  r0.xyzw = r1.xyzw * r0.xyzw + r2.xyzx * CUSTOM_LENS_FLARE;
  // No code for instruction (needs manual fix):
  // store_uav_typed u0.xyzw, vThreadID.xyyy, r0.xyzw
  u0[vThreadID.xy] = r0.xyzw;
  return;
}
