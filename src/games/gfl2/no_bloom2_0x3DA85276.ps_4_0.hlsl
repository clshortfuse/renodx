#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.2 on Sat Apr 12 13:49:57 2025
Texture2D<float4> t11 : register(t11);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1467];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cmp(float2(0.5,0.5) < cb0[1403].xy);
  r0.zw = float2(-0.5,-0.5) + v1.xy;
  r1.xy = r0.zw * cb0[1412].zz + float2(0.5,0.5);
  r0.zw = r0.zw * cb0[1412].zz + -cb0[1411].xy;
  r0.zw = cb0[1411].zw * r0.zw;
  r1.z = dot(r0.zw, r0.zw);
  r1.z = sqrt(r1.z);
  r1.w = cmp(0 < cb0[1412].w);
  if (r1.w != 0) {
    r2.xy = cb0[1412].xy * r1.zz;
    sincos(r2.x, r2.x, r3.x);
    r2.x = r2.x / r3.x;
    r2.y = 1 / r2.y;
    r2.x = r2.x * r2.y + -1;
    r2.xy = r0.zw * r2.xx + r1.xy;
  } else {
    r2.z = 1 / r1.z;
    r2.z = cb0[1412].x * r2.z;
    r1.z = cb0[1412].y * r1.z;
    r2.w = min(1, abs(r1.z));
    r3.x = max(1, abs(r1.z));
    r3.x = 1 / r3.x;
    r2.w = r3.x * r2.w;
    r3.x = r2.w * r2.w;
    r3.y = r3.x * 0.0208350997 + -0.0851330012;
    r3.y = r3.x * r3.y + 0.180141002;
    r3.y = r3.x * r3.y + -0.330299497;
    r3.x = r3.x * r3.y + 0.999866009;
    r3.y = r3.x * r2.w;
    r3.z = cmp(1 < abs(r1.z));
    r3.y = r3.y * -2 + 1.57079637;
    r3.y = r3.z ? r3.y : 0;
    r2.w = r2.w * r3.x + r3.y;
    r1.z = min(1, r1.z);
    r1.z = cmp(r1.z < -r1.z);
    r1.z = r1.z ? -r2.w : r2.w;
    r1.z = r2.z * r1.z + -1;
    r2.xy = r0.zw * r1.zz + r1.xy;
  }
  r0.zw = r0.xx ? r2.xy : v1.xy;
  r1.x = cmp(0.5 < cb0[1466].x);
  if (r1.x != 0) {
    r2.xyzw = t11.Sample(s1_s, r0.zw).xyzw;
    r0.zw = r2.xy + r0.zw;
  }
  r1.y = cmp(0 < cb0[1460].x);
  if (r1.y != 0) {
    r2.xy = cb0[1462].xy * cb0[1290].yy;
    r2.xy = r2.xy * float2(0.00999999978,0.00999999978) + v1.xy;
    r2.xy = r2.xy * cb0[1461].xy + cb0[1461].zw;
    r2.xyzw = t9.Sample(s6_s, r2.xy).xyzw;
    r1.z = r2.w * 2 + -1;
    r1.z = cb0[1460].y * r1.z;
    r3.x = 0.00999999978 * r1.z;
    r3.y = 0;
    r0.zw = v1.xy + r3.xy;
  } else {
    r2.xyz = float3(0,0,0);
  }
  r3.xyzw = t0.Sample(s4_s, r0.zw).xyzw;
  float3 untonemapped = r3.rgb;
  untonemapped = renodx::color::srgb::DecodeSafe(untonemapped);
  r0.y = (int)r0.y | (int)r1.y;
  if (r0.y != 0) {
    if (r1.y != 0) {
      r0.y = 0.00999999978 * cb0[1460].z;
      r4.x = cb0[1460].z * 0.00999999978 + r0.z;
      r4.y = r0.w;
      r5.x = -r0.y;
      r5.y = -0;
      r4.zw = r5.xy + r0.zw;
    } else {
      r5.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
      r0.y = dot(r5.zw, r5.zw);
      r5.xyzw = r5.xyzw * r0.yyyy;
      r5.xyzw = cb0[1413].xxxx * r5.xyzw;
      r5.xyzw = r5.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
      r6.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r5.xyzw;
      r7.xyzw = r6.xyzw * cb0[1412].zzzz + float4(0.5,0.5,0.5,0.5);
      r6.xyzw = r6.xyzw * cb0[1412].zzzz + -cb0[1411].xyxy;
      r6.xyzw = cb0[1411].zwzw * r6.xyzw;
      r0.y = dot(r6.xy, r6.xy);
      r0.y = sqrt(r0.y);
      if (r1.w != 0) {
        r8.xy = cb0[1412].xy * r0.yy;
        sincos(r8.x, r8.x, r9.x);
        r1.z = r8.x / r9.x;
        r2.w = 1 / r8.y;
        r1.z = r1.z * r2.w + -1;
        r8.xy = r6.xy * r1.zz + r7.xy;
      } else {
        r1.z = 1 / r0.y;
        r1.z = cb0[1412].x * r1.z;
        r0.y = cb0[1412].y * r0.y;
        r2.w = min(1, abs(r0.y));
        r8.z = max(1, abs(r0.y));
        r8.z = 1 / r8.z;
        r2.w = r8.z * r2.w;
        r8.z = r2.w * r2.w;
        r8.w = r8.z * 0.0208350997 + -0.0851330012;
        r8.w = r8.z * r8.w + 0.180141002;
        r8.w = r8.z * r8.w + -0.330299497;
        r8.z = r8.z * r8.w + 0.999866009;
        r8.w = r8.z * r2.w;
        r9.x = cmp(1 < abs(r0.y));
        r8.w = r8.w * -2 + 1.57079637;
        r8.w = r9.x ? r8.w : 0;
        r2.w = r2.w * r8.z + r8.w;
        r0.y = min(1, r0.y);
        r0.y = cmp(r0.y < -r0.y);
        r0.y = r0.y ? -r2.w : r2.w;
        r0.y = r1.z * r0.y + -1;
        r8.xy = r6.xy * r0.yy + r7.xy;
      }
      r4.xy = r0.xx ? r8.xy : r5.xy;
      if (r1.x != 0) {
        r8.xyzw = t11.Sample(s1_s, r4.xy).xyzw;
        r4.xy = r8.xy + r4.xy;
      }
      r0.y = dot(r6.zw, r6.zw);
      r0.y = sqrt(r0.y);
      if (r1.w != 0) {
        r1.zw = cb0[1412].xy * r0.yy;
        sincos(r1.z, r5.x, r6.x);
        r1.z = r5.x / r6.x;
        r1.w = 1 / r1.w;
        r1.z = r1.z * r1.w + -1;
        r1.zw = r6.zw * r1.zz + r7.zw;
      } else {
        r2.w = 1 / r0.y;
        r2.w = cb0[1412].x * r2.w;
        r0.y = cb0[1412].y * r0.y;
        r5.x = min(1, abs(r0.y));
        r5.y = max(1, abs(r0.y));
        r5.y = 1 / r5.y;
        r5.x = r5.x * r5.y;
        r5.y = r5.x * r5.x;
        r6.x = r5.y * 0.0208350997 + -0.0851330012;
        r6.x = r5.y * r6.x + 0.180141002;
        r6.x = r5.y * r6.x + -0.330299497;
        r5.y = r5.y * r6.x + 0.999866009;
        r6.x = r5.x * r5.y;
        r6.y = cmp(1 < abs(r0.y));
        r6.x = r6.x * -2 + 1.57079637;
        r6.x = r6.y ? r6.x : 0;
        r5.x = r5.x * r5.y + r6.x;
        r0.y = min(1, r0.y);
        r0.y = cmp(r0.y < -r0.y);
        r0.y = r0.y ? -r5.x : r5.x;
        r0.y = r2.w * r0.y + -1;
        r1.zw = r6.zw * r0.yy + r7.zw;
      }
      r4.zw = r0.xx ? r1.zw : r5.zw;
      if (r1.x != 0) {
        r5.xyzw = t11.Sample(s1_s, r4.zw).xyzw;
        r4.zw = r5.xy + r4.zw;
      }
    }
    r5.xyzw = t0.Sample(s4_s, r4.xy).xyzw;
    r4.xyzw = t0.Sample(s4_s, r4.zw).xyzw;
    r6.xz = r3.xz;
    r6.y = r5.y;
    r5.x = 0;
    r1.xzw = r6.xyz + r5.xxz;
    r5.xy = r4.xy;
    r5.z = 0;
    r1.xzw = r5.xyz + r1.xzw;
    r1.xzw = float3(0.5,0.5,0.5) * r1.xzw;
    r6.w = r4.z;
    r3.xyz = r1.yyy ? r1.xzw : r6.xyw;
  }
  r1.xzw = float3(1,1,1) + -r2.xyz;
  r1.xzw = -r1.xzw * cb0[1460].xxx + float3(1,1,1);
  r1.xzw = r3.xyz * r1.xzw;
  r1.xyz = r1.yyy ? r1.xzw : r3.xyz;
  r0.x = cmp(0 < cb0[1451].x);
  if (r0.x != 0) {
    r2.xyzw = t1.Sample(s3_s, v1.xy).xyzw;
    r0.x = cmp(0 < r2.x);
    if (r0.x != 0) {
      r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
      r2.yzw = cb0[3].xzw * r0.yyy;
      r2.yzw = cb0[2].xzw * r0.xxx + r2.yzw;
      r2.xyz = cb0[4].xzw * r2.xxx + r2.yzw;
      r2.xyz = cb0[5].xzw + r2.xyz;
      r0.xy = r2.xy / r2.zz;
      r2.xyzw = cb0[1454].wwww * r0.xyxy;
      r4.xy = floor(r2.zw);
      r4.zw = frac(r2.zw);
      r5.xy = r4.zw * r4.zw;
      r4.zw = -r4.zw * float2(2,2) + float2(3,3);
      r4.zw = r5.xy * r4.zw;
      r5.xyzw = float4(1,0,0,1) + r4.xyxy;
      r6.xy = float2(1,1) + r4.xy;
      r1.w = dot(r4.xy, float2(12.9898005,78.2330017));
      r1.w = sin(r1.w);
      r1.w = 43758.5469 * r1.w;
      r1.w = frac(r1.w);
      r4.x = dot(r5.xy, float2(12.9898005,78.2330017));
      r4.x = sin(r4.x);
      r4.x = 43758.5469 * r4.x;
      r4.y = dot(r5.zw, float2(12.9898005,78.2330017));
      r4.y = sin(r4.y);
      r4.y = 43758.5469 * r4.y;
      r4.xy = frac(r4.xy);
      r5.x = dot(r6.xy, float2(12.9898005,78.2330017));
      r5.x = sin(r5.x);
      r5.x = 43758.5469 * r5.x;
      r5.x = frac(r5.x);
      r4.x = r4.x + -r1.w;
      r1.w = r4.z * r4.x + r1.w;
      r4.x = r5.x + -r4.y;
      r4.x = r4.z * r4.x + r4.y;
      r4.x = r4.x + -r1.w;
      r1.w = r4.w * r4.x + r1.w;
      r2.xyzw = float4(0.5,0.5,0.25,0.25) * r2.xyzw;
      r4.xyzw = floor(r2.xyzw);
      r2.xyzw = frac(r2.xyzw);
      r5.xyzw = r2.xyzw * r2.xyzw;
      r2.xyzw = -r2.xyzw * float4(2,2,2,2) + float4(3,3,3,3);
      r2.xyzw = r5.xyzw * r2.xyzw;
      r5.xyzw = float4(1,0,0,1) + r4.xyxy;
      r6.xyzw = float4(1,1,1,0) + r4.xyzw;
      r4.x = dot(r4.xy, float2(12.9898005,78.2330017));
      r4.x = sin(r4.x);
      r4.x = 43758.5469 * r4.x;
      r4.y = dot(r5.xy, float2(12.9898005,78.2330017));
      r4.y = sin(r4.y);
      r4.y = 43758.5469 * r4.y;
      r4.xy = frac(r4.xy);
      r5.x = dot(r5.zw, float2(12.9898005,78.2330017));
      r5.x = sin(r5.x);
      r5.x = 43758.5469 * r5.x;
      r5.y = dot(r6.xy, float2(12.9898005,78.2330017));
      r5.y = sin(r5.y);
      r5.y = 43758.5469 * r5.y;
      r5.xy = frac(r5.xy);
      r4.y = r4.y + -r4.x;
      r4.x = r2.x * r4.y + r4.x;
      r4.y = r5.y + -r5.x;
      r2.x = r2.x * r4.y + r5.x;
      r2.x = r2.x + -r4.x;
      r2.x = r2.y * r2.x + r4.x;
      r2.x = 0.25 * r2.x;
      r1.w = r1.w * 0.125 + r2.x;
      r5.xyzw = float4(0,1,1,1) + r4.zwzw;
      r2.x = dot(r4.zw, float2(12.9898005,78.2330017));
      r2.x = sin(r2.x);
      r2.x = 43758.5469 * r2.x;
      r2.y = dot(r6.zw, float2(12.9898005,78.2330017));
      r2.y = sin(r2.y);
      r2.y = 43758.5469 * r2.y;
      r2.xy = frac(r2.xy);
      r4.x = dot(r5.xy, float2(12.9898005,78.2330017));
      r4.x = sin(r4.x);
      r4.x = 43758.5469 * r4.x;
      r4.y = dot(r5.zw, float2(12.9898005,78.2330017));
      r4.y = sin(r4.y);
      r4.y = 43758.5469 * r4.y;
      r4.xy = frac(r4.xy);
      r2.y = r2.y + -r2.x;
      r2.x = r2.z * r2.y + r2.x;
      r2.y = r4.y + -r4.x;
      r2.y = r2.z * r2.y + r4.x;
      r2.y = r2.y + -r2.x;
      r2.x = r2.w * r2.y + r2.x;
      r1.w = r2.x * 0.5 + r1.w;
      r2.x = cb0[1454].y * r1.w;
      r2.yz = cb0[1453].xy * cb0[1453].zz;
      r2.yz = cb0[1294].xx * r2.yz;
      r0.xy = r0.xy * cb0[1453].zw + r2.yz;
      r0.xy = cb0[1454].yy * r1.ww + r0.xy;
      r4.xyzw = t8.Sample(s5_s, r0.xy).xyzw;
      r0.x = cb0[1454].x * r4.x;
      r0.x = log2(r0.x);
      r0.x = cb0[1451].x * r0.x;
      r0.x = exp2(r0.x);
      r0.x = min(1, r0.x);
      r0.y = cb0[1454].z * r2.x;
      r0.x = saturate(-r0.y * 5 + r0.x);
      r0.x = cb0[1452].w * r0.x;
      r2.xyz = cb0[1452].xyz + -r1.xyz;
      r1.xyz = r0.xxx * r2.xyz + r1.xyz;
    }
  }
  r0.x = cmp(0 < cb0[1425].x);
  if (r0.x != 0) {
    r2.xyzw = t1.Sample(s3_s, cb0[1424].xy).xyzw;
    r0.x = cb0[1298].x * r2.x + cb0[1298].y;
    r0.x = 1 / r0.x;
    r0.x = cmp(r0.x >= cb0[1444].x);
    if (r0.x != 0) {
      r2.xy = -cb0[1424].xy + v1.xy;
      r0.x = cb0[1397].x / cb0[1397].y;
      r2.z = r2.y * r0.x;
      r0.y = dot(r2.xz, r2.xz);
      r4.y = sqrt(r0.y);
      r0.y = saturate(cb0[1425].y + -r4.y);
      r0.y = 1 + r0.y;
      r0.y = log2(r0.y);
      r0.y = 75 * r0.y;
      r0.y = exp2(r0.y);
      r0.y = -1 + r0.y;
      r1.w = min(abs(r2.z), abs(r2.x));
      r2.w = max(abs(r2.z), abs(r2.x));
      r2.w = 1 / r2.w;
      r1.w = r2.w * r1.w;
      r2.w = r1.w * r1.w;
      r5.x = r2.w * 0.0208350997 + -0.0851330012;
      r5.x = r2.w * r5.x + 0.180141002;
      r5.x = r2.w * r5.x + -0.330299497;
      r2.w = r2.w * r5.x + 0.999866009;
      r5.x = r2.w * r1.w;
      r5.y = cmp(abs(r2.x) < abs(r2.z));
      r5.x = r5.x * -2 + 1.57079637;
      r5.x = r5.y ? r5.x : 0;
      r1.w = r1.w * r2.w + r5.x;
      r2.w = cmp(r2.x < -r2.x);
      r2.w = r2.w ? -3.141593 : 0;
      r1.w = r2.w + r1.w;
      r2.w = min(r2.z, r2.x);
      r2.z = max(r2.z, r2.x);
      r2.w = cmp(r2.w < -r2.w);
      r2.z = cmp(r2.z >= -r2.z);
      r2.z = r2.z ? r2.w : 0;
      r1.w = r2.z ? -r1.w : r1.w;
      r1.w = cb0[1424].w + r1.w;
      r2.z = r1.w * cb0[1426].y + cb0[1426].w;
      r2.z = cos(r2.z);
      r2.z = cb0[1426].x * r2.z;
      r2.z = cb0[1426].z + abs(r2.z);
      r4.xzw = float3(1,0.100000001,0.200000003) + r4.yyy;
      r2.w = 1 / cb0[1426].x;
      r4.x = log2(r4.x);
      r2.w = r4.x * r2.w;
      r2.w = exp2(r2.w);
      r2.z = r2.z * r2.w;
      r2.z = 1 / r2.z;
      r0.y = r2.z + r0.y;
      r1.w = r1.w * cb0[1427].y + cb0[1427].w;
      r1.w = sin(r1.w);
      r1.w = cb0[1427].x * r1.w;
      r1.w = cb0[1427].z + abs(r1.w);
      r2.z = 1 / cb0[1427].x;
      r2.z = r2.z * r4.x;
      r2.z = exp2(r2.z);
      r1.w = r2.z * r1.w;
      r1.w = 1 / r1.w;
      r0.y = r1.w + r0.y;
      r5.xyzw = float4(1,1,0.5,0.5) + -cb0[1424].xyxy;
      r2.zw = v1.xy + -r5.xy;
      r6.xy = r5.zw * cb0[1428].zz + r2.zw;
      r6.z = r6.y * r0.x;
      r1.w = dot(r6.xz, r6.xz);
      r1.w = sqrt(r1.w);
      r1.w = saturate(cb0[1428].y / r1.w);
      r1.w = log2(r1.w);
      r1.w = 12 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = cb0[1428].w * r1.w;
      r1.w = r1.w / r4.y;
      r4.x = cb0[1443].w * r1.w;
      r0.y = r0.y * cb0[1425].x + r4.x;
      r6.xy = r5.zw * cb0[1430].zz + r2.zw;
      r6.z = r6.y * r0.x;
      r4.x = dot(r6.xz, r6.xz);
      r4.x = sqrt(r4.x);
      r4.x = saturate(cb0[1430].y / r4.x);
      r4.x = log2(r4.x);
      r4.x = 12 * r4.x;
      r4.x = exp2(r4.x);
      r4.x = cb0[1430].w * r4.x;
      r4.x = r4.x / r4.y;
      r0.y = r4.x * cb0[1443].w + r0.y;
      r6.xyz = cb0[1431].xyz * r4.xxx;
      r6.xyz = cb0[1429].xyz * r1.www + r6.xyz;
      r7.xy = r5.zw * cb0[1432].zz + r2.zw;
      r7.z = r7.y * r0.x;
      r1.w = dot(r7.xz, r7.xz);
      r1.w = sqrt(r1.w);
      r1.w = saturate(cb0[1432].y / r1.w);
      r1.w = log2(r1.w);
      r1.w = 12 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = cb0[1432].w * r1.w;
      r1.w = r1.w / r4.y;
      r0.y = r1.w * cb0[1443].w + r0.y;
      r6.xyz = cb0[1433].xyz * r1.www + r6.xyz;
      r7.xy = r5.zw * cb0[1434].zz + r2.zw;
      r7.z = r7.y * r0.x;
      r1.w = dot(r7.xz, r7.xz);
      r1.w = sqrt(r1.w);
      r1.w = saturate(cb0[1434].y / r1.w);
      r1.w = log2(r1.w);
      r1.w = 12 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = cb0[1434].w * r1.w;
      r1.w = r1.w / r4.y;
      r0.y = r1.w * cb0[1443].w + r0.y;
      r6.xyz = cb0[1435].xyz * r1.www + r6.xyz;
      r7.xy = r5.zw * cb0[1436].zz + r2.zw;
      r7.z = r7.y * r0.x;
      r1.w = dot(r7.xz, r7.xz);
      r1.w = sqrt(r1.w);
      r1.w = saturate(cb0[1436].y / r1.w);
      r1.w = log2(r1.w);
      r1.w = 12 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = cb0[1436].w * r1.w;
      r1.w = r1.w / r4.y;
      r6.xyz = cb0[1437].xyz * r1.www + r6.xyz;
      r7.xy = r5.zw * cb0[1438].zz + r2.zw;
      r7.z = r7.y * r0.x;
      r1.w = dot(r7.xz, r7.xz);
      r1.w = sqrt(r1.w);
      r1.w = saturate(cb0[1438].y / r1.w);
      r1.w = log2(r1.w);
      r1.w = 12 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = cb0[1438].w * r1.w;
      r1.w = r1.w / r4.y;
      r6.xyz = cb0[1439].xyz * r1.www + r6.xyz;
      r5.xy = r5.zw * cb0[1440].zz + r2.zw;
      r5.z = r5.y * r0.x;
      r1.w = dot(r5.xz, r5.xz);
      r1.w = sqrt(r1.w);
      r1.w = saturate(cb0[1440].y / r1.w);
      r1.w = log2(r1.w);
      r1.w = 12 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = cb0[1440].w * r1.w;
      r1.w = r1.w / r4.y;
      r5.xyz = cb0[1441].xyz * r1.www + r6.xyz;
      r1.w = dot(r2.xy, r2.xy);
      r1.w = sqrt(r1.w);
      sincos(cb0[1424].w, r4.x, r6.x);
      r7.x = -r4.x;
      r7.y = r6.x;
      r2.z = dot(r7.yx, r2.xy);
      r7.z = r4.x;
      r2.y = dot(r7.zy, r2.xy);
      r0.x = r2.z * r0.x;
      r2.x = 0.100000001 * r0.x;
      r2.xy = r2.xy / r4.yy;
      r2.xy = cb0[1424].zz + r2.xy;
      r2.xyzw = t4.Sample(s2_s, r2.xy).xyzw;
      r0.x = saturate(-cb0[1425].w + r2.x);
      r2.xyz = float3(3.14159274,3.14159274,3.14159274) * r4.yzw;
      r2.xyz = sin(r2.xyz);
      r2.xyz = r2.xyz * r0.xxx;
      r0.x = 1 + r1.w;
      r0.x = log2(r0.x);
      r0.x = 13 * r0.x;
      r0.x = exp2(r0.x);
      r1.w = cb0[1425].z / r0.x;
      r2.xyz = r2.xyz * r1.www + r0.yyy;
      r0.y = -cb0[1442].x + r4.y;
      r0.y = cb0[1442].y * r0.y;
      r0.y = max(0, r0.y);
      r0.y = min(3.14159274, r0.y);
      r4.xy = float2(0.100000001,0.200000003) + r0.yy;
      r6.x = sin(r0.y);
      r6.yz = sin(r4.xy);
      r4.xyz = r6.xyz * r6.xyz;
      r4.xyz = r4.xyz * r4.xyz;
      r6.xyz = r4.xyz * r4.xyz;
      r4.xyz = r6.xyz * r4.xyz;
      r0.x = cb0[1442].z / r0.x;
      r2.xyz = r4.xyz * r0.xxx + r2.xyz;
      r0.x = 1 + -cb0[1443].w;
      r4.xyz = r5.xyz * r0.xxx;
      r2.xyz = r2.xyz * cb0[1443].xyz + r4.xyz;
    } else {
      r2.xyz = float3(0,0,0);
    }
    r1.xyz = r2.xyz + r1.xyz;
  }
  r0.x = cmp(0 < cb0[1444].y);
  if (r0.x != 0) {
    r2.xw = float2(0,0);
    r2.yz = cb0[1394].yx;
    r4.xyzw = r2.wyzw + r0.zwzw;
    r2.xyzw = -r2.xyzw + r0.zwzw;
    r5.xyzw = t1.Sample(s3_s, r4.xy).xyzw;
    r6.xyzw = t1.Sample(s3_s, r4.zw).xyzw;
    r7.xyzw = t1.Sample(s3_s, r2.xy).xyzw;
    r0.x = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
    r0.y = max(r7.x, r5.x);
    r0.y = max(r0.y, r2.z);
    r0.y = max(r0.y, r6.x);
    r1.w = min(r7.x, r5.x);
    r1.w = min(r1.w, r2.z);
    r1.w = min(r1.w, r6.x);
    r0.y = -r1.w + r0.y;
    r0.y = 9.99999997e-007 + r0.y;
    r0.y = saturate(cb0[1445].y / r0.y);
    r5.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
    r6.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
    r7.xyzw = t0.Sample(s1_s, r4.zw).xyzw;
    r4.xyzw = t0.Sample(s1_s, r4.xy).xyzw;
    r1.w = dot(r4.xyz, float3(0.298999995,0.587000012,0.114));
    r2.x = dot(r7.xyz, float3(0.298999995,0.587000012,0.114));
    r2.y = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
    r2.w = dot(r5.xyz, float3(0.298999995,0.587000012,0.114));
    r4.x = max(r2.w, r1.w);
    r4.x = max(r4.x, r2.y);
    r4.x = max(r4.x, r2.x);
    r1.w = min(r2.w, r1.w);
    r1.w = min(r1.w, r2.y);
    r1.w = min(r1.w, r2.x);
    r1.w = -9.99999997e-007 + r1.w;
    r0.x = r0.x * 2 + -r1.w;
    r0.x = r0.x + -r4.x;
    r1.w = r4.x + -r1.w;
    r1.w = saturate(cb0[1445].w / r1.w);
    r2.x = -cb0[1444].z + r2.z;
    r2.x = cmp(abs(r2.x) < cb0[1444].w);
    r2.x = r2.x ? 1.000000 : 0;
    r0.x = r1.w * r0.x;
    r0.x = r0.x * r0.y;
    r0.x = cb0[1445].x * r0.x;
    r0.x = max(-cb0[1445].z, r0.x);
    r0.x = min(cb0[1445].z, r0.x);
    r0.x = r0.x * r2.x + 1;
    r1.xyz = r1.xyz * r0.xxx;
  }
  r0.xy = cmp(float2(0.5,0.5) < cb0[1448].xy);
  if (r0.x != 0) {
    r2.xyzw = t6.Sample(s1_s, r0.zw).xyzw;
    r1.xyz = r2.xyz + r1.xyz;
  }
  r0.x = cmp(0 < cb0[1415].z);
  if (r0.x != 0) {
    r0.xz = -cb0[1415].xy + r0.zw;
    r2.yz = cb0[1415].zz * abs(r0.xz);
    r2.x = cb0[1414].w * r2.y;
    r0.x = dot(r2.xz, r2.xz);
    r0.x = 1 + -r0.x;
    r0.x = max(0, r0.x);
    r0.x = log2(r0.x);
    r0.x = cb0[1415].w * r0.x;
    r0.x = exp2(r0.x);
    r2.xyz = float3(1,1,1) + -cb0[1414].xyz;
    r0.xzw = r0.xxx * r2.xyz + cb0[1414].xyz;
    r1.xyz = r1.xyz * r0.xzw;
  }
  r0.xzw = cb0[1404].www * r1.zxy;
  r0.xzw = r0.xzw * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xzw = log2(r0.xzw);
  r0.xzw = saturate(r0.xzw * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));
  r1.xyz = cb0[1404].zzz * r0.xzw;
  r0.z = floor(r1.x);
  r1.xw = float2(0.5,0.5) * cb0[1404].xy;
  r1.yz = r1.yz * cb0[1404].xy + r1.xw;
  r1.x = r0.z * cb0[1404].y + r1.y;
  r2.xyzw = t2.SampleLevel(s1_s, r1.xz, 0).xyzw;
  r4.x = cb0[1404].y;
  r4.y = 0;
  r1.xy = r4.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r0.x = r0.x * cb0[1404].z + -r0.z;
  r1.xyz = r1.xyz + -r2.xyz;
  r0.xzw = r0.xxx * r1.xyz + r2.xyz;
  r1.x = cmp(0 < cb0[1405].w);
  if (r1.x != 0) {
    r0.xzw = saturate(r0.xzw);
    r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xzw;
    r2.xyz = log2(r0.xzw);
    r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r4.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xzw);
    r1.xyz = r4.xyz ? r1.xyz : r2.xyz;
    r2.xyz = cb0[1405].zzz * r1.zxy;
    r1.w = floor(r2.x);
    r2.xw = float2(0.5,0.5) * cb0[1405].xy;
    r2.yz = r2.yz * cb0[1405].xy + r2.xw;
    r2.x = r1.w * cb0[1405].y + r2.y;
    r4.xyzw = t3.SampleLevel(s1_s, r2.xz, 0).xyzw;
    r5.x = cb0[1405].y;
    r5.y = 0;
    r2.xy = r5.xy + r2.xz;
    r2.xyzw = t3.SampleLevel(s1_s, r2.xy, 0).xyzw;
    r1.w = r1.z * cb0[1405].z + -r1.w;
    r2.xyz = r2.xyz + -r4.xyz;
    r2.xyz = r1.www * r2.xyz + r4.xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[1405].www * r2.xyz + r1.xyz;
    r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
    r4.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r1.xyz;
    r4.xyz = float3(0.947867334,0.947867334,0.947867334) * r4.xyz;
    r4.xyz = log2(abs(r4.xyz));
    r4.xyz = float3(2.4000001,2.4000001,2.4000001) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r1.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r1.xyz);
    r0.xzw = r1.xyz ? r2.xyz : r4.xyz;
  }
  r1.x = cmp(0 < cb0[1463].z);
  if (r1.x != 0) {
    r1.yz = cb0[1463].yx + v1.yx;
    r2.xy = -cb0[1463].xy + v1.xy;
    r4.xyzw = t10.Sample(s1_s, v1.xy).xyzw;
    r4.y = cmp(0 < cb0[1463].w);
    if (r4.y != 0) {
      r2.zw = v1.yx;
      r5.xyzw = t10.Sample(s1_s, r2.xz).xyzw;
      r1.xw = v1.yx;
      r6.xyzw = t10.Sample(s1_s, r1.zx).xyzw;
      r7.xyzw = t10.Sample(s1_s, r1.wy).xyzw;
      r8.xyzw = t10.Sample(s1_s, r2.wy).xyzw;
      r2.z = r6.x + r5.x;
      r2.z = r2.z + r7.x;
      r2.z = r2.z + r8.x;
    } else {
      r2.z = 0;
    }
    r1.xw = r2.xy;
    r5.xyzw = t10.Sample(s1_s, r1.xy).xyzw;
    r6.xyzw = t10.Sample(s1_s, r1.zy).xyzw;
    r7.xyzw = t10.Sample(s1_s, r2.xy).xyzw;
    r1.xyzw = t10.Sample(s1_s, r1.zw).xyzw;
    r1.y = r5.x + r2.z;
    r1.y = r1.y + r6.x;
    r1.y = r1.y + r7.x;
    r1.x = saturate(r1.y + r1.x);
    r1.x = saturate(r1.x + -r4.x);
    r1.xyzw = cb0[1464].xyzw * r1.xxxx;
    r2.xyzw = cb0[1465].xyzw * r4.xxxx;
    r1.xyzw = saturate(max(r2.xyzw, r1.xyzw));
    r1.xyz = r1.xyz + -r0.xzw;
    r0.xzw = r1.www * r1.xyz + r0.xzw;
  }
  r1.x = cmp(0 < cb0[1421].x);
  r1.y = cb0[1421].y + v1.y;
  r1.y = saturate(-1 + r1.y);
  r1.z = max(0.00100000005, cb0[1421].y);
  r1.y = r1.y / r1.z;
  r1.z = cb0[1421].z * 0.5 + 0.5;
  r1.z = cb0[1421].x * r1.z;
  r1.w = r1.y * r1.y;
  r2.x = 1 + -r1.y;
  r1.y = r2.x * r1.y;
  r1.y = dot(r1.yy, r1.zz);
  r1.y = r1.w * cb0[1421].x + r1.y;
  r2.xyz = cb0[1422].xyz + -r0.xzw;
  r1.yzw = r1.yyy * r2.xyz + r0.xzw;
  r3.xyz = r1.xxx ? r1.yzw : r0.xzw;
  r0.x = cmp(0 < cb0[1446].x);
  if (r0.x != 0) {
    r1.y = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
    r0.xz = cb0[1446].yy * float2(1.13999999,2.99000001) + float2(1,1);
    r1.x = r1.y / r0.x;
    r1.z = r1.y * r0.z;
    r1.xyz = saturate(r1.xyz);
    r2.xyzw = t5.Sample(s1_s, float2(0.5,0.5)).xyzw;
    r0.x = 1.44269502 * r2.y;
    r0.x = exp2(r0.x);
    r0.x = saturate(-cb0[1446].z + r0.x);
    r2.xyz = r3.xyz + -r1.xyz;
    r3.xyz = r0.xxx * r2.xyz + r1.xyz;
  }
  if (r0.y != 0) {
    r0.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
    r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
    r1.xyzw = cb0[3].xyzw * r0.zzzz;
    r1.xyzw = cb0[2].xyzw * r0.yyyy + r1.xyzw;
    r0.xyzw = cb0[4].xyzw * r0.xxxx + r1.xyzw;
    r0.xyzw = cb0[5].xyzw + r0.xyzw;
    r0.xyz = r0.xyz / r0.www;
    r0.xyz = -cb0[1295].xyz + r0.xyz;
    r0.w = dot(r0.xyz, r0.xyz);
    r1.x = rsqrt(r0.w);
    r0.xyz = r1.xxx * r0.xyz;
    r0.y = cb0[1295].y / r0.y;
    r0.w = sqrt(r0.w);
    r0.y = min(abs(r0.y), r0.w);
    r0.xy = r0.xz * r0.yy + cb0[1295].xz;
    r0.xy = -cb0[1450].zw + r0.xy;
    r0.xy = cb0[1450].xy * r0.xy;
    r0.xyzw = t7.Sample(s1_s, r0.xy).xyzw;
    r0.x = 1 + -r0.y;
    r0.y = cb0[1449].w * r0.x;
    r1.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * cb0[1449].xyz;
    r2.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + cb0[1449].xyz;
    r2.xyz = float3(0.947867334,0.947867334,0.947867334) * r2.xyz;
    r2.xyz = log2(abs(r2.xyz));
    r2.xyz = float3(2.4000001,2.4000001,2.4000001) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r4.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= cb0[1449].xyz);
    r1.xyz = r4.xyz ? r1.xyz : r2.xyz;
    r0.x = -r0.x * cb0[1449].w + 1;
    r0.xzw = r3.xyz * r0.xxx;
    r3.xyz = r1.xyz * r0.yyy + r0.xzw;
  }
  o0.xyzw = r3.xyzw;

  float3 sdr = saturate(o0.rgb);
  o0.rgb = renodx::color::srgb::DecodeSafe(sdr);
  o0.rgb = renodx::draw::ToneMapPass(untonemapped, sdr);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}