// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 25 15:13:11 2025
// Temporal/bloom resolve selecting brightest candidate among surrounding samples.

#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[191];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Load current frame color and unpack normal-aligned weighting vectors.
  r0.xyzw = t1.Sample(s1_s, v0.xy, int2(0, 0)).xyzw;
  r0.zw = r0.xy * cb0[187].xy + cb0[187].zw;
  r0.xy = r0.xy * cb0[186].xy + cb0[186].zw;
  r1.xy = v0.xy + -r0.zw;
  // Evaluate neighbor at -offset to decide if we should accumulate its HDR value.
  r2.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r1.zw = r2.xy * cb0[186].xy + cb0[186].zw;
  r1.z = dot(r1.zw, r0.xy);
  r1.w = dot(r0.xy, r0.xy);
  r1.w = cb0[189].x * r1.w;
  r1.z = cmp(r1.w < r1.z);
  r2.xyzw = t0.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r1.xy = r1.xy * cb0[190].xy + cb0[190].zw;
  r1.xy = cmp(float2(1,1) >= abs(r1.xy));
  r1.x = r1.y ? r1.x : 0;
  r3.xyzw = t0.Sample(s0_s, v0.xy, int2(0, 0)).xyzw;
  r1.y = cb0[189].y + r3.w;
  r4.x = cmp(r2.w >= r1.y);
  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.z = r1.z ? r4.x : 0;
  r2.xyzw = r1.zzzz ? r2.xyzw : r3.xyzw;
  r1.z = r1.z ? 2 : 1;
  r1.z = r1.x ? r1.z : 1;
  r2.xyzw = r1.xxxx ? r2.xyzw : r3.xyzw;
  // Probe opposite direction (-2 * offset) for additional bright contributions.
  r4.xy = r0.zw * float2(-2,-2) + v0.xy;
  r5.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r6.xyzw = r5.xyzw + r2.xyzw;
  r1.x = cmp(r5.w >= r1.y);
  r5.xyzw = t1.SampleLevel(s1_s, r4.xy, 0).xyzw;
  r4.xy = r4.xy * cb0[190].xy + cb0[190].zw;
  r4.xy = cmp(float2(1,1) >= abs(r4.xy));
  r4.x = r4.y ? r4.x : 0;
  r4.yz = r5.xy * cb0[186].xy + cb0[186].zw;
  r4.y = dot(r4.yz, r0.xy);
  r4.y = cmp(r1.w < r4.y);
  r1.x = r1.x ? r4.y : 0;
  r5.xyzw = r1.xxxx ? r6.xyzw : r2.xyzw;
  r2.xyzw = r4.xxxx ? r5.xyzw : r2.xyzw;
  r4.yz = v0.xy + r0.zw;
  r0.zw = r0.zw * float2(2,2) + v0.xy;
  r5.xyzw = t0.SampleLevel(s0_s, r4.yz, 0).xyzw;
  r6.xyzw = r5.xyzw + r2.xyzw;
  r4.w = cmp(r5.w >= r1.y);
  r5.xyzw = t1.SampleLevel(s1_s, r4.yz, 0).xyzw;
  r4.yz = r4.yz * cb0[190].xy + cb0[190].zw;
  r4.yz = cmp(float2(1,1) >= abs(r4.yz));
  r4.y = r4.z ? r4.y : 0;
  r5.xy = r5.xy * cb0[186].xy + cb0[186].zw;
  r4.z = dot(r5.xy, r0.xy);
  r4.z = cmp(r1.w < r4.z);
  r4.z = r4.w ? r4.z : 0;
  r5.xyzw = r4.zzzz ? r6.xyzw : r2.xyzw;
  r2.xyzw = r4.yyyy ? r5.xyzw : r2.xyzw;
  // Check forward offsets (+offset, +2*offset) with the same criteria.
  r5.xyzw = t0.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r6.xyzw = r5.xyzw + r2.xyzw;
  r1.y = cmp(r5.w >= r1.y);
  r5.xyzw = t1.SampleLevel(s1_s, r0.zw, 0).xyzw;
  r0.zw = r0.zw * cb0[190].xy + cb0[190].zw;
  r0.zw = cmp(float2(1,1) >= abs(r0.zw));
  r0.z = r0.w ? r0.z : 0;
  r5.xy = r5.xy * cb0[186].xy + cb0[186].zw;
  r0.w = dot(r5.xy, r0.xy);
  r0.x = abs(r0.x) + abs(r0.y);
  r0.x = cmp(r0.x >= cb0[188].z);
  r0.y = cmp(r1.w < r0.w);
  r0.y = r1.y ? r0.y : 0;
  r5.xyzw = r0.yyyy ? r6.xyzw : r2.xyzw;
  r2.xyzw = r0.zzzz ? r5.xyzw : r2.xyzw;
  r0.w = 1 + r1.z;
  r0.w = r1.x ? r0.w : r1.z;
  r0.w = r4.x ? r0.w : r1.z;
  r1.x = 1 + r0.w;
  r1.x = r4.z ? r1.x : r0.w;
  r0.w = r4.y ? r1.x : r0.w;
  r1.x = 1 + r0.w;
  r0.y = r0.y ? r1.x : r0.w;
  r0.y = r0.z ? r0.y : r0.w;
  // Apply average scaling using number of selected samples.
  r1.xyzw = cb0[159].xyzw / r0.yyyy;
  r1.xyzw = r2.xyzw * r1.xyzw;
  // Output enhanced bloom tap unless the local slope fails the threshold.
  o0.xyzw = r0.xxxx ? r1.xyzw : r3.xyzw;
  return;
}