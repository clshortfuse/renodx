#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Feb  4 16:26:06 2025

// clang-format off
groupshared struct { float val[1]; } g2[128];
groupshared struct { float val[1]; } g1[128];
groupshared struct { float val[1]; } g0[128];
// clang-format on

cbuffer cb0 : register(b0) {
  float2 g_inverseDimensions : packoffset(c0);
  float g_upsampleBlendFactor : packoffset(c0.z);
  float g_bloomStrength : packoffset(c0.w);
}

SamplerState LinearBorder_s : register(s1);
Texture2D<float3> HigherResBuf : register(t0);
Texture2D<float3> LowerResBuf : register(t1);
RWTexture2D<float3> Result : register(u0);

// 3Dmigoto declarations
#define cmp -

[numthreads(8, 8, 1)]
void main(uint2 vThreadID: SV_DispatchThreadID, uint2 vThreadGroupID: SV_GroupID, uint2 vThreadIDInGroup: SV_GroupThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 8, 8, 1
  r0.zw = float2(0, 0);
  r1.xy = (uint2)vThreadGroupID.xy << int2(3, 3);
  r1.xy = (int2)r1.xy + int2(-4, -4);
  r1.zw = (uint2)vThreadIDInGroup.xy << int2(1, 1);
  r0.xy = (int2)r1.xy + (int2)r1.zw;
  r1.x = mad((int)vThreadIDInGroup.y, 16, (int)r1.z);
  r1.yzw = HigherResBuf.Load(r0.xyz).xyz;
  r0.zw = (int2)r0.xy;
  r0.zw = float2(0.5, 0.5) + r0.zw;
  r2.zw = g_inverseDimensions.xy * r0.zw;
  r2.xy = r0.zw * g_inverseDimensions.xy + g_inverseDimensions.xy;
  r3.xyz = LowerResBuf.SampleLevel(LinearBorder_s, r2.zw, 0).xyz;
  r3.xyz = r3.xyz + -r1.yzw;
  r1.yzw = g_upsampleBlendFactor * r3.xyz + r1.yzw;
  r1.yzw = f32tof16(r1.yzw);
  r3.xyzw = (int4)r0.xyxy + int4(0, 1, 1, 0);
  r0.xy = (int2)r0.xy + int2(1, 1);
  r4.xy = r3.zw;
  r4.zw = float2(0, 0);
  r4.xyz = HigherResBuf.Load(r4.xyz).xyz;
  r5.xyz = LowerResBuf.SampleLevel(LinearBorder_s, r2.xw, 0).xyz;
  r6.xyz = LowerResBuf.SampleLevel(LinearBorder_s, r2.zy, 0).xyz;
  r2.xyz = LowerResBuf.SampleLevel(LinearBorder_s, r2.xy, 0).xyz;
  r5.xyz = r5.xyz + -r4.xyz;
  r4.xyz = g_upsampleBlendFactor * r5.xyz + r4.xyz;
  r4.xyz = f32tof16(r4.xyz);
  r1.yzw = mad((int3)r4.xyz, int3(0x10000, 0x10000, 0x10000), (int3)r1.yzw);
  r4.xy = mad((int2)vThreadIDInGroup.yy, int2(16, 8), (int2)vThreadIDInGroup.xx);
  g0[r4.x].val[0 / 4] = r1.y;
  g1[r4.x].val[0 / 4] = r1.z;
  g2[r4.x].val[0 / 4] = r1.w;
  r0.zw = float2(0, 0);
  r0.xyz = HigherResBuf.Load(r0.xyz).xyz;
  r1.yzw = r2.xyz + -r0.xyz;
  r0.xyz = g_upsampleBlendFactor * r1.yzw + r0.xyz;
  r0.xyz = f32tof16(r0.xyz);
  r3.zw = float2(0, 0);
  r1.yzw = HigherResBuf.Load(r3.xyz).xyz;
  r2.xyz = r6.xyz + -r1.yzw;
  r1.yzw = g_upsampleBlendFactor * r2.xyz + r1.yzw;
  r1.yzw = f32tof16(r1.yzw);
  r0.xyz = mad((int3)r0.xyz, int3(0x10000, 0x10000, 0x10000), (int3)r1.yzw);
  r0.w = (int)r4.x + 8;
  g0[r0.w].val[0 / 4] = r0.x;
  g1[r0.w].val[0 / 4] = r0.y;
  g2[r0.w].val[0 / 4] = r0.z;
  GroupMemoryBarrierWithGroupSync();
  r0.x = (int)vThreadIDInGroup.x & 4;
  r0.x = (int)r0.x + (int)r4.x;
  r0.y = g0[r0.x].val[0 / 4];
  r0.z = g1[r0.x].val[0 / 4];
  r0.w = g2[r0.x].val[0 / 4];
  r2.xyzw = (int4)r0.xxxx + int4(1, 2, 3, 4);
  r0.x = g0[r2.x].val[0 / 4];
  r1.y = g1[r2.x].val[0 / 4];
  r1.z = g2[r2.x].val[0 / 4];
  r1.w = g0[r2.y].val[0 / 4];
  r2.x = g1[r2.y].val[0 / 4];
  r2.y = g2[r2.y].val[0 / 4];
  r3.x = g0[r2.z].val[0 / 4];
  r3.y = g0[r2.w].val[0 / 4];
  r3.z = g1[r2.z].val[0 / 4];
  r3.w = g1[r2.w].val[0 / 4];
  r2.z = g2[r2.z].val[0 / 4];
  r2.w = g2[r2.w].val[0 / 4];
  r5.x = f16tof32(r1.w);
  r1.w = (uint)r1.w >> 16;
  r6.x = f16tof32(r1.w);
  r1.w = (uint)r2.x >> 16;
  r6.y = f16tof32(r1.w);
  r5.yz = f16tof32(r2.xy);
  r1.w = (uint)r2.y >> 16;
  r6.z = f16tof32(r1.w);
  r1.w = (uint)r0.x >> 16;
  r7.x = f16tof32(r0.x);
  r8.x = f16tof32(r1.w);
  r0.x = (uint)r1.y >> 16;
  r8.y = f16tof32(r0.x);
  r0.x = (uint)r1.z >> 16;
  r7.yz = f16tof32(r1.yz);
  r8.z = f16tof32(r0.x);
  r1.yzw = r8.xyz + r6.xyz;
  r1.yzw = float3(0.21875, 0.21875, 0.21875) * r1.yzw;
  r1.yzw = r5.xyz * float3(0.2734375, 0.2734375, 0.2734375) + r1.yzw;
  r0.x = (uint)r3.x >> 16;
  r10.x = f16tof32(r0.x);
  r9.xy = f16tof32(r3.xz);
  r0.x = (uint)r3.z >> 16;
  r10.y = f16tof32(r0.x);
  r9.z = f16tof32(r2.z);
  r0.x = (uint)r2.z >> 16;
  r10.z = f16tof32(r0.x);
  r2.xyz = r9.xyz + r7.xyz;
  r4.xzw = r9.xyz + r5.xyz;
  r4.xzw = float3(0.21875, 0.21875, 0.21875) * r4.xzw;
  r4.xzw = r6.xyz * float3(0.2734375, 0.2734375, 0.2734375) + r4.xzw;
  r1.yzw = r2.xyz * float3(0.109375, 0.109375, 0.109375) + r1.yzw;
  r0.x = (uint)r0.y >> 16;
  r5.x = f16tof32(r0.x);
  r0.x = (uint)r0.z >> 16;
  r5.y = f16tof32(r0.x);
  r0.x = (uint)r0.w >> 16;
  r2.xyz = f16tof32(r0.yzw);
  r5.z = f16tof32(r0.x);
  r0.xyz = r5.xyz + r10.xyz;
  r6.xyz = r10.xyz + r8.xyz;
  r4.xzw = r6.xyz * float3(0.109375, 0.109375, 0.109375) + r4.xzw;
  r0.xyz = r0.xyz * float3(0.03125, 0.03125, 0.03125) + r1.yzw;
  r0.w = (uint)r3.y >> 16;
  r3.x = f16tof32(r0.w);
  r6.xy = f16tof32(r3.yw);
  r0.w = (uint)r3.w >> 16;
  r3.y = f16tof32(r0.w);
  r6.z = f16tof32(r2.w);
  r0.w = (uint)r2.w >> 16;
  r3.z = f16tof32(r0.w);
  r1.yzw = r5.xyz + r3.xyz;
  r2.xyz = r6.xyz + r2.xyz;
  r3.xyz = r7.xyz + r6.xyz;
  r3.xyz = r3.xyz * float3(0.03125, 0.03125, 0.03125) + r4.xzw;
  r1.yzw = r1.yzw * float3(0.00390625, 0.00390625, 0.00390625) + r3.xyz;
  r0.xyz = r2.xyz * float3(0.00390625, 0.00390625, 0.00390625) + r0.xyz;
  g0[r1.x].val[0 / 4] = r0.x;
  g1[r1.x].val[0 / 4] = r0.y;
  g2[r1.x].val[0 / 4] = r0.z;
  r0.x = (int)r1.x + 1;
  g0[r0.x].val[0 / 4] = r1.y;
  g1[r0.x].val[0 / 4] = r1.z;
  g2[r0.x].val[0 / 4] = r1.w;
  GroupMemoryBarrierWithGroupSync();
  r0.xyzw = (int4)r4.yyyy + int4(8, 16, 24, 32);
  r1.x = g0[r0.w].val[0 / 4];
  r1.y = g1[r0.w].val[0 / 4];
  r1.z = g2[r0.w].val[0 / 4];
  r2.xyz = (int3)r4.yyy + int3(40, 48, 56);
  r3.x = g0[r2.x].val[0 / 4];
  r3.y = g1[r2.x].val[0 / 4];
  r3.z = g2[r2.x].val[0 / 4];
  r5.x = g0[r0.z].val[0 / 4];
  r5.y = g1[r0.z].val[0 / 4];
  r5.z = g2[r0.z].val[0 / 4];
  r3.xyzw = r5.xyzx + r3.xyzx;
  r3.xyzw = float4(0.21875, 0.21875, 0.21875, 0.21875) * r3.xyzw;
  r1.xyzw = r1.xyzx * float4(0.2734375, 0.2734375, 0.2734375, 0.2734375) + r3.xyzw;
  r3.x = g0[r0.y].val[0 / 4];
  r3.y = g1[r0.y].val[0 / 4];
  r3.z = g2[r0.y].val[0 / 4];
  r5.x = g0[r2.y].val[0 / 4];
  r5.y = g1[r2.y].val[0 / 4];
  r5.z = g2[r2.y].val[0 / 4];
  r3.xyzw = r5.xyzx + r3.xyzx;
  r1.xyzw = r3.xyzw * float4(0.109375, 0.109375, 0.109375, 0.109375) + r1.xyzw;
  r3.x = g0[r0.x].val[0 / 4];
  r3.y = g1[r0.x].val[0 / 4];
  r3.z = g2[r0.x].val[0 / 4];
  r0.x = g0[r2.z].val[0 / 4];
  r0.y = g1[r2.z].val[0 / 4];
  r0.z = g2[r2.z].val[0 / 4];
  r0.xyzw = r3.xyzx + r0.xyzx;
  r0.xyzw = r0.xyzw * float4(0.03125, 0.03125, 0.03125, 0.03125) + r1.xyzw;
  r1.x = g0[r4.y].val[0 / 4];
  r1.y = g1[r4.y].val[0 / 4];
  r1.z = g2[r4.y].val[0 / 4];
  r1.w = (int)r4.y + 64;
  r2.x = g0[r1.w].val[0 / 4];
  r2.y = g1[r1.w].val[0 / 4];
  r2.z = g2[r1.w].val[0 / 4];
  r1.xyzw = r2.xyzx + r1.xyzx;
  r0.xyzw = r1.xyzw * float4(0.00390625, 0.00390625, 0.00390625, 0.00390625) + r0.xyzw;
  r0.xyzw = g_bloomStrength * r0.xyzw * CUSTOM_BLOOM;
  // No code for instruction (needs manual fix):
  // store_uav_typed u0.xyzw, vThreadID.xyyy, r0.xyzw
  Result[vThreadID] = r0;
  return;
}
