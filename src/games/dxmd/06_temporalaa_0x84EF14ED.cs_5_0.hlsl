// Temporal AA

#include "./shared.h"

groupshared struct {
  float val[1];
} g2[100];

groupshared struct {
  float val[1];
} g1[100];

groupshared struct {
  float val[1];
} g0[100];

Texture2D<float4> t0 : register(t0);  // black?
Texture2D<float4> t1 : register(t1);  // untonemapped
Texture2D<float4> t2 : register(t2);  // blue?
Texture2D<float4> t3 : register(t3);  // previous frame

SamplerState s0_s : register(s0);

cbuffer cb11 : register(b11) {
  float4 cb11[2];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(8, 8, 1)] void main(uint3 vThreadGroupID : SV_GroupID, uint3 vThreadIDInGroup : SV_GroupThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 8, 8, 1
  r0.xy = (uint2)vThreadGroupID.xy << int2(3, 3);
  r0.z = mad((int)vThreadIDInGroup.y, 8, (int)vThreadIDInGroup.x);
  uiDest.x = (uint)r0.z / 10;
  r2.x = (uint)r0.z % 10;
  r1.x = uiDest.x;
  r0.w = (int)r0.x + (int)r2.x;
  r1.x = mad((int)vThreadGroupID.y, 8, (int)r1.x);
  r2.x = (int)r0.w + -1;
  r2.y = (int)r1.x + -1;
  r2.zw = float2(0, 0);
  float3 t1InputColor = t1.Load(r2.xyz).xyz;
  r1.xyz = t1InputColor;
  r0.w = (int)r0.z + 64;
  r1.w = cmp((uint)r0.w < 100);
  if (r1.w != 0) {
    uiDest.x = (uint)r0.w / 10;
    r3.x = (uint)r0.w % 10;
    r2.x = uiDest.x;
    r0.x = (int)r0.x + (int)r3.x;
    r0.y = (int)r0.y + (int)r2.x;
    r2.xy = (int2)r0.xy + int2(-1, -1);
    r2.zw = float2(0, 0);
    r2.xyz = t1.Load(r2.xyz).xyz;
  } else {
    r2.xyz = float3(0, 0, 0);
  }
  r0.x = dot(float3(0.212599993, 0.715200007, 0.0722000003), r1.xyz);
  r0.x = 1 + r0.x;
  r1.xyz = r1.xyz / r0.xxx;
  r0.x = dot(float3(0.25, 0.5, 0.25), r1.xyz);
  r0.y = dot(float3(-0.25, 0.5, -0.25), r1.xyz);
  r1.x = dot(float2(0.5, -0.5), r1.xz);
  g0[r0.z].val[0 / 4] = r0.x;
  g1[r0.z].val[0 / 4] = r0.y;
  g2[r0.z].val[0 / 4] = r1.x;
  if (r1.w != 0) {
    r0.x = dot(float3(0.212599993, 0.715200007, 0.0722000003), r2.xyz);
    r0.x = 1 + r0.x;
    r0.xyz = r2.xyz / r0.xxx;
    r1.x = dot(float3(0.25, 0.5, 0.25), r0.xyz);
    r0.y = dot(float3(-0.25, 0.5, -0.25), r0.xyz);
    r0.x = dot(float2(0.5, -0.5), r0.xz);
    g0[r0.w].val[0 / 4] = r1.x;
    g1[r0.w].val[0 / 4] = r0.y;
    g2[r0.w].val[0 / 4] = r0.x;
  }
  GroupMemoryBarrierWithGroupSync();
  r0.xy = mad((int2)vThreadGroupID.xy, int2(8, 8), (int2)vThreadIDInGroup.xy);
  r1.xy = (uint2)cb11[0].zw;
  r1.xy = cmp((uint2)r0.xy >= (uint2)r1.xy);
  r1.x = (int)r1.y | (int)r1.x;
  if (r1.x != 0) {
    return;
  }
  r0.zw = float2(0, 0);
  r1.x = t0.Load(r0.xyw).x;
  r2.xyzw = (int4)r0.xyxy + int4(1, -1, -1, -1);
  r3.xy = r2.zw;
  r3.zw = float2(0, 0);
  r1.y = t0.Load(r3.xyz).x;
  r3.xy = cmp(r1.xx < r1.yy);
  r3.z = max(r1.x, r1.y);
  r2.zw = float2(0, 0);
  r1.z = t0.Load(r2.xyz).x;
  r1.w = cmp(r3.z < r1.z);
  r1.xy = float2(1, -1);
  r1.xyz = r1.www ? r1.xyz : r3.xyz;
  r2.xyzw = (int4)r0.xyxy + int4(1, 1, -1, 1);
  r3.xy = r2.zw;
  r3.zw = float2(0, 0);
  r3.z = t0.Load(r3.xyz).x;
  r1.w = cmp(r1.z < r3.z);
  r3.xy = float2(-1, 1);
  r1.xyz = r1.www ? r3.xyz : r1.xyz;
  r2.zw = float2(0, 0);
  r1.w = t0.Load(r2.xyz).x;
  r1.z = cmp(r1.z < r1.w);
  r1.xy = r1.zz ? float2(1, 1) : r1.xy;
  r1.xy = (int2)r0.xy + (int2)r1.xy;
  r1.zw = float2(0, 0);
  r1.xy = t2.Load(r1.xyz).xy;
  r1.zw = (uint2)r0.xy;
  r1.zw = float2(0.5, 0.5) + r1.zw;
  r1.xy = r1.zw * cb11[0].xy + -r1.xy;

  r2.xyz = t1.Load(r0.xyz).xyz;

  const float3 t3InputColor = t3.SampleLevel(s0_s, r1.xy, 0).xyz;
  r3.xyz = max(0, t3InputColor);
  r3.xyz = rsqrt(r3.xyz);
  // r3 should already be linear
  r3.xyz = float3(1, 1, 1) / r3.xyz;
  r4.xyz = (int3)r3.xyz & int3(0x7fffffff, 0x7fffffff, 0x7fffffff);
  r4.xyz = cmp((int3)r4.xyz == int3(0x7f800000, 0x7f800000, 0x7f800000));
  r0.z = (int)r4.y | (int)r4.x;
  r0.z = (int)r4.z | (int)r0.z;

  float4 outputColor4 = r2.xyzw;

  if (r0.z != 0) {
    // r4.xyzw = r2.xyzx * r2.xyzx;
    // r4.xyzw = r2.xyzx;

    // r4.r = 1.f;
    // u0[uint2(r0.x, r0.y)] = r4.xyzw;

    // No code for instruction (needs manual fix):
    // store_uav_typed u0.xyzw, r0.xyyy, r4.xyzw
  } else {
    r0.z = dot(float3(0.212599993, 0.715200007, 0.0722000003), r2.xyz);
    r0.z = 1 + r0.z;
    r2.xyzw = r2.xyzx / r0.zzzz;
    r0.z = dot(float3(0.212599993, 0.715200007, 0.0722000003), r3.xyz);
    r0.z = 1 + r0.z;
    r3.xyz = r3.xyz / r0.zzz;

    r0.zw = (int2)vThreadIDInGroup.xx + int2(1, 2);
    r1.zw = mad((int2)vThreadIDInGroup.yy, int2(10, 10), int2(10, 20));
    r4.xyzw = (int4)r0.zwzw + (int4)r1.zzww;
    r5.x = g0[r4.x].val[0 / 4];
    r5.y = g1[r4.x].val[0 / 4];
    r5.z = g2[r4.x].val[0 / 4];
    r3.w = mad((int)vThreadIDInGroup.y, 10, (int)vThreadIDInGroup.x);
    r6.x = g0[r3.w].val[0 / 4];
    r6.y = g1[r3.w].val[0 / 4];
    r6.z = g2[r3.w].val[0 / 4];
    r7.xyz = min(r6.xyz, r5.xyz);
    r6.xyz = max(r6.xyz, r5.xyz);
    r0.zw = mad((int2)vThreadIDInGroup.yy, int2(10, 10), (int2)r0.zw);
    r8.x = g0[r0.z].val[0 / 4];
    r8.y = g1[r0.z].val[0 / 4];
    r8.z = g2[r0.z].val[0 / 4];
    r7.xyz = min(r8.xyz, r7.xyz);
    r6.xyz = max(r8.xyz, r6.xyz);
    r8.x = g0[r0.w].val[0 / 4];
    r8.y = g1[r0.w].val[0 / 4];
    r8.z = g2[r0.w].val[0 / 4];
    r7.xyz = min(r8.xyz, r7.xyz);
    r6.xyz = max(r8.xyz, r6.xyz);
    r0.zw = (int2)r1.zw + (int2)vThreadIDInGroup.xx;
    r8.x = g0[r0.z].val[0 / 4];
    r8.y = g1[r0.z].val[0 / 4];
    r8.z = g2[r0.z].val[0 / 4];
    r7.xyz = min(r8.xyz, r7.xyz);
    r6.xyz = max(r8.xyz, r6.xyz);
    r8.x = g0[r4.y].val[0 / 4];
    r8.y = g1[r4.y].val[0 / 4];
    r8.z = g2[r4.y].val[0 / 4];
    r7.xyz = min(r8.xyz, r7.xyz);
    r6.xyz = max(r8.xyz, r6.xyz);
    r8.x = g0[r0.w].val[0 / 4];
    r8.y = g1[r0.w].val[0 / 4];
    r8.z = g2[r0.w].val[0 / 4];
    r7.xyz = min(r8.xyz, r7.xyz);
    r6.xyz = max(r8.xyz, r6.xyz);
    r8.x = g0[r4.z].val[0 / 4];
    r8.y = g1[r4.z].val[0 / 4];
    r8.z = g2[r4.z].val[0 / 4];
    r4.xyz = min(r8.xyz, r7.xyz);
    r6.xyz = max(r8.xyz, r6.xyz);
    r7.x = g0[r4.w].val[0 / 4];
    r7.y = g1[r4.w].val[0 / 4];
    r7.z = g2[r4.w].val[0 / 4];
    r4.xyz = min(r7.xyz, r4.xyz);
    r6.xyz = max(r7.xyz, r6.xyz);
    r0.z = dot(float3(0.25, 0.5, 0.25), r3.xyz);
    r7.x = dot(float3(-0.25, 0.5, -0.25), r3.xyz);
    r7.y = dot(float2(0.5, -0.5), r3.xz);
    r1.zw = -r7.xy + r5.yz;
    r3.xy = float2(1, 1) / r1.zw;
    r3.zw = -r7.xy + r4.yz;
    r3.zw = r3.zw * r3.xy;
    r4.yz = -r7.xy + r6.yz;
    r3.xy = r4.yz * r3.xy;
    r3.xy = min(r3.zw, r3.xy);
    r0.w = saturate(max(r3.x, r3.y));
    r0.z = max(r0.z, r4.x);
    r0.z = min(r0.z, r6.x);
    r1.zw = r1.zw * r0.ww + r7.xy;
    r0.w = -r1.z + r0.z;
    r3.xyw = r1.wzw + r0.wzw;
    r3.z = r0.w + -r1.w;
    r0.zw = cb11[0].zw * r1.xy;
    r0.zw = frac(r0.zw);
    r0.zw = float2(-0.5, -0.5) + r0.zw;
    r0.z = max(abs(r0.z), abs(r0.w));
    r0.z = -r0.z * 0.5 + 1;
    r1.xy = cmp(int2(0x3f800000, 0x3f800000) < (uint2)r1.xy);
    r0.w = (int)r1.y | (int)r1.x;
    r0.z = cb11[1].x * r0.z;
    r0.z = r0.w ? 0 : r0.z;
    r1.xyzw = r3.xyzw + -r2.wyzw;
    r1.xyzw = r0.zzzz * r1.xyzw + r2.xyzw;
    r0.z = dot(float3(0.715200007, 0.0722000003, 0.212599993), r1.yzw);
    r0.z = 1 + -r0.z;
    r1.xyzw = r1.xyzw / r0.zzzz;
    r1.xyzw = max(float4(0, 0, 0, 0), r1.xyzw);
    r1.xyzw = min(float4(10000, 10000, 10000, 10000), r1.xyzw);
    outputColor4 = r1.xyzw;
  }

  outputColor4.rgb = outputColor4.rgb * outputColor4.rgb;

  if (injectedData.toneMapType == 0.f) {
    outputColor4.rgb = saturate(outputColor4.rgb);
  }

  u0[uint2(r0.x, r0.y)] = outputColor4;

  return;
}
