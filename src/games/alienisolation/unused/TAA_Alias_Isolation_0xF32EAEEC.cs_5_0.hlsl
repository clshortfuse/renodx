#include "../shared.h"

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

RWTexture2D<float4> u0 : register(u0);

#define cmp            -
#define DISPATCH_BLOCK 8

[numthreads(DISPATCH_BLOCK, DISPATCH_BLOCK, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5, 0.5) + r0.xy;
  r0.zw = asuint(cb0[0].xy);
  r0.xy = r0.xy / r0.zw;
  r1.xy = -cb0[0].zw + r0.xy;

  r2.xyz = t0.SampleLevel(s1_s, r1.xy, 0).xyz;
  r3.xyz = min(100000, r2.xyz);
  r4.xyz = max(-100000, r2.xyz);
  r5.xyzw = cb0[0].zwzw * float4(0, -1, 1, -1) + r0.xyxy;

  r6.xyz = t0.SampleLevel(s1_s, r5.xy, 0).xyz;
  r7.xyzw = 0.101266459 * r6.xyzx;
  r2.xyzw = r2.xyzx * 0.0102548962 + r7.xyzw;
  r3.xyz = min(r6.xyz, r3.xyz);
  r4.xyz = max(r6.xyz, r4.xyz);
  r7.xyz = min(100000, r6.xyz);
  r6.xyz = max(-100000, r6.xyz);

  r8.xyz = t0.SampleLevel(s1_s, r5.zw, 0).xyz;
  r2.xyzw = r8.xyzx * 0.0102548962 + r2.xyzw;
  r3.xyz = min(r8.xyz, r3.xyz);
  r4.xyz = max(r8.xyz, r4.xyz);
  r8.xyzw = cb0[0].zwzw * float4(-1, 0, 1, 0) + r0.xyxy;
  r9.xyz = t0.SampleLevel(s1_s, r8.xy, 0).xyz;
  r2.xyzw = r9.xyzx * 0.101266459 + r2.xyzw;
  r3.xyz = min(r9.xyz, r3.xyz);
  r4.xyz = max(r9.xyz, r4.xyz);
  r7.xyz = min(r9.xyz, r7.xyz);
  r6.xyz = max(r9.xyz, r6.xyz);

  r9.xyz = t0.SampleLevel(s1_s, r0.xy, 0).xyz;
  r2.xyzw = r9.xyzx + r2.xyzw;
  r3.xyz = min(r9.xyz, r3.xyz);
  r4.xyz = max(r9.xyz, r4.xyz);
  r7.xyz = min(r9.xyz, r7.xyz);
  r6.xyz = max(r9.xyz, r6.xyz);

  r8.xyz = t0.SampleLevel(s1_s, r8.zw, 0).xyz;
  r2.xyzw = r8.xyzx * 0.101266459 + r2.xyzw;
  r3.xyz = min(r8.xyz, r3.xyz);
  r4.xyz = max(r8.xyz, r4.xyz);
  r7.xyz = min(r8.xyz, r7.xyz);
  r6.xyz = max(r8.xyz, r6.xyz);
  r8.xyzw = cb0[0].zwzw * float4(-1, 1, 0, 1) + r0.xyxy;

  r9.xyz = t0.SampleLevel(s1_s, r8.xy, 0).xyz;
  r2.xyzw = r9.xyzx * 0.0102548962 + r2.xyzw;
  r3.xyz = min(r9.xyz, r3.xyz);
  r4.xyz = max(r9.xyz, r4.xyz);

  r9.xyz = t0.SampleLevel(s1_s, r8.zw, 0).xyz;
  r2.xyzw = r9.xyzx * 0.101266459 + r2.xyzw;
  r3.xyz = min(r9.xyz, r3.xyz);
  r4.xyz = max(r9.xyz, r4.xyz);
  r7.xyz = min(r9.xyz, r7.xyz);
  r6.xyz = max(r9.xyz, r6.xyz);
  r1.zw = cb0[0].zw + r0.xy;

  r9.xyz = t0.SampleLevel(s1_s, r1.zw, 0).xyz;
  r2.xyzw = r9.xyzx * 0.0102548962 + r2.xyzw;
  r3.xyz = min(r9.xyz, r3.xyz);
  r4.xyz = max(r9.xyz, r4.xyz);
  r9.xyz = 0.691522062 * r2.yzw;
  r7.xyz = r7.xyz + -r3.xyz;
  r3.xyz = r7.xyz * float3(0.5, 0.5, 0.5) + r3.xyz;
  r6.xyz = r6.xyz + -r4.xyz;
  r4.xyz = r6.xyz * float3(0.5, 0.5, 0.5) + r4.xyz;
  r6.xy = t2.SampleLevel(s1_s, r0.xy, 0).xy;
  r3.w = t3.SampleLevel(s1_s, r0.xy, 0).x;
  r6.z = -abs(r3.w);
  r7.xy = t2.SampleLevel(s1_s, r1.zw, 0).xy;
  r1.z = t3.SampleLevel(s1_s, r1.zw, 0).x;
  r7.z = -abs(r1.z);
  r1.z = cmp(abs(r3.w) < abs(r1.z));
  r6.xyz = r1.zzz ? r6.xyz : r7.xyz;
  r7.xy = t2.SampleLevel(s1_s, r8.xy, 0).xy;
  r1.z = t3.SampleLevel(s1_s, r8.xy, 0).x;
  r7.z = -abs(r1.z);
  r1.z = cmp(r7.z < r6.z);
  r6.xyz = r1.zzz ? r6.xyz : r7.xyz;
  r7.xy = t2.SampleLevel(s1_s, r5.zw, 0).xy;
  r1.z = t3.SampleLevel(s1_s, r5.zw, 0).x;
  r7.z = -abs(r1.z);
  r1.z = cmp(r7.z < r6.z);
  r5.xyz = r1.zzz ? r6.xyz : r7.xyz;
  r1.zw = t2.SampleLevel(s1_s, r1.xy, 0).xy;
  r1.x = t3.SampleLevel(s1_s, r1.xy, 0).x;
  r1.x = cmp(-abs(r1.x) < r5.z);
  r1.xy = r1.xx ? r5.xy : r1.zw;
  r0.xy = -r1.xy + r0.xy;
  r1.zw = float2(-0.5, -0.5) + r0.xy;
  r1.zw = cmp(abs(r1.zw) < float2(0.5, 0.5));
  r1.z = r1.w ? r1.z : 0;
  if (r1.z != 0) {
    r1.zw = float2(1, 1) / r0.zw;
    r5.xy = r0.xy * r0.zw + float2(-0.5, -0.5);
    r5.xy = floor(r5.xy);
    r6.xyzw = float4(0.5, 0.5, -0.5, -0.5) + r5.xyxy;
    r0.xy = r0.xy * r0.zw + -r6.xy;
    r5.zw = r0.xy * r0.xy;
    r7.xy = r5.zw * r0.xy;
    r7.zw = r5.zw * r0.xy + r0.xy;
    r7.zw = -r7.zw * float2(0.5, 0.5) + r5.zw;
    r8.xy = float2(2.5, 2.5) * r5.zw;
    r7.xy = r7.xy * float2(1.5, 1.5) + -r8.xy;
    r7.xy = float2(1, 1) + r7.xy;
    r0.xy = r5.zw * r0.xy + -r5.zw;
    r5.zw = float2(0.5, 0.5) * r0.xy;
    r8.xy = float2(1, 1) + -r7.zw;
    r8.xy = r8.xy + -r7.xy;
    r0.xy = -r0.xy * float2(0.5, 0.5) + r8.xy;
    r7.xy = r7.xy + r0.xy;
    r0.xy = r0.xy / r7.xy;
    r0.xy = r6.xy + r0.xy;
    r5.xy = float2(2.5, 2.5) + r5.xy;
    r6.xw = r6.zw * r1.zw;
    r6.yz = r0.yx * r1.wz;
    r8.xy = r5.xy * r1.zw;
    r10.xyz = t1.SampleLevel(s0_s, r6.xw, 0).xyz;
    r10.xyz = r10.xyz * r7.zzz;
    r11.xyz = t1.SampleLevel(s0_s, r6.zw, 0).xyz;
    r11.xyz = r11.xyz * r7.xxx;
    r11.xyz = r11.xyz * r7.www;
    r10.xyz = r10.xyz * r7.www + r11.xyz;
    r8.zw = r6.wy;
    r11.xyz = t1.SampleLevel(s0_s, r8.xz, 0).xyz;
    r11.xyz = r11.xyz * r5.zzz;
    r10.xyz = r11.xyz * r7.www + r10.xyz;
    r11.xyz = t1.SampleLevel(s0_s, r6.xy, 0).xyz;
    r11.xyz = r11.xyz * r7.zzz;
    r10.xyz = r11.xyz * r7.yyy + r10.xyz;
    r11.xyz = t1.SampleLevel(s0_s, r6.zy, 0).xyz;
    r11.xyz = r11.xyz * r7.xxx;
    r10.xyz = r11.xyz * r7.yyy + r10.xyz;
    r11.xyz = t1.SampleLevel(s0_s, r8.xw, 0).xyz;
    r11.xyz = r11.xyz * r5.zzz;
    r10.xyz = r11.xyz * r7.yyy + r10.xyz;
    r6.y = r8.y;
    r11.xyz = t1.SampleLevel(s0_s, r6.xy, 0).xyz;
    r7.yzw = r11.xyz * r7.zzz;
    r7.yzw = r7.yzw * r5.www + r10.xyz;
    r6.xyz = t1.SampleLevel(s0_s, r6.zy, 0).xyz;
    r6.xyz = r6.xyz * r7.xxx;
    r6.xyz = r6.xyz * r5.www + r7.yzw;
    r7.xyz = t1.SampleLevel(s0_s, r8.xy, 0).xyz;
    r5.xyz = r7.xyz * r5.zzz;
    r5.xyz = r5.xyz * r5.www + r6.xyz;
  } else {
    r5.xyz = r9.zxy;
  }
  r6.xyz = -r2.wyz * 0.691522062 + r4.xyz;
  r7.xyzw = -r2.wyzw * 0.691522062 + r5.xyzx;
  r6.xyz = r6.xyz / r7.xyz;
  r8.xyz = -r2.wyz * 0.691522062 + r3.xyz;
  r8.xyz = r8.xyz / r7.xyz;
  r6.xyz = max(r8.xyz, r6.xyz);
  r0.x = min(r6.y, r6.z);
  r0.x = saturate(min(r6.x, r0.x));
  r6.xyzw = r7.xyzw * r0.xxxx + r9.zxyz;

  // originally BT.601
  r0.x = renodx::color::y::from::BT709(r5.rgb);
  r0.y = renodx::color::y::from::BT709(r3.rgb);
  r1.z = renodx::color::y::from::BT709(r4.rgb);

  r1.w = r0.x + -r0.y;
  r0.x = -r1.z + r0.x;
  r0.y = r1.z + -r0.y;
  r0.x = min(abs(r1.w), abs(r0.x));
  r0.x = r0.x / r0.y;
  r0.yz = abs(r1.xy) * r0.zw;
  r0.yz = frac(r0.yz);
  r0.yz = float2(-0.5, -0.5) + r0.yz;
  r0.yz = float2(0.5, 0.5) + -abs(r0.yz);
  r0.x = 0.15 * r0.x;
  r0.y = dot(r0.yz, float2(1, 1));
  r0.y = 1 + r0.y;
  r0.x = saturate(r0.x * r0.y);
  r1.xyzw = r2.xyzw * 0.691522062 + -r6.wyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + r6.xyzw;
  r0.xyzw = max(0.f, r0.xyzw);
  r0.xyzw = min(65502.f, r0.xyzw);
  u0[vThreadID.xy] = r0.xyzw;
  return;
}
