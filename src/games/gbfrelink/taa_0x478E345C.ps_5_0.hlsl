#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.16 on Wed Feb  5 19:01:09 2025
Texture2D<float4> t23 : register(t23);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

SamplerState s3_s : register(s3);

cbuffer cb12 : register(b12)
{
  float4 cb12[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t5.Gather(s3_s, v1.xy, int2(-1, -1)).xyzw;
  r1.xz = t5.Gather(s3_s, v1.xy, int2(0, -1)).zy;
  r2.xy = t5.Gather(s3_s, v1.xy, int2(-1, 0)).xy;
  r3.xyzw = t5.Gather(s3_s, v1.xy).xyzw;
  r1.w = cmp(1 >= r0.w);
  if (r1.w != 0) {
    r4.x = r0.w;
  } else {
    r4.x = 1;
  }
  r0.w = cmp(r4.x >= r0.z);
  if (r0.w != 0) {
    r4.x = r0.z;
    r4.y = 1;
  } else {
    r4.y = 0;
  }
  r0.z = cmp(r4.x < r1.x);
  r1.y = r0.z ? 3 : 2;
  r4.xy = r0.zz ? r4.xy : r1.xy;
  r0.z = cmp(r4.x >= r0.x);
  if (r0.z != 0) {
    r4.yz = float2(0,1.40129846e-45);
    r4.x = r0.x;
  } else {
    r4.z = 0;
  }
  r0.x = cmp(r4.x >= r0.y);
  if (r0.x != 0) {
    r4.yz = float2(1.40129846e-45,1.40129846e-45);
    r4.x = r0.y;
  }
  r0.x = cmp(r4.x < r1.z);
  r1.y = r0.x ? 3 : 2;
  r1.x = 1;
  r0.xyz = r0.xxx ? r4.yzx : r1.yxz;
  r0.w = cmp(r0.z >= r2.x);
  if (r0.w != 0) {
    r0.xy = float2(0,2.80259693e-45);
    r0.z = r2.x;
  }
  r0.w = cmp(r0.z >= r2.y);
  if (r0.w != 0) {
    r0.xy = float2(1,2);
    r0.z = r2.y;
  }
  r0.z = cmp(r0.z < r3.y);
  r1.x = r0.z ? 3 : 2;
  r1.yzw = float3(2.80259693e-45,0,0);
  r0.xy = r0.zz ? r0.xy : r1.xy;
  r0.xy = (int2)r0.xy + int2(-1,-1);
  r0.xy = (int2)r0.xy;
  r0.xy = v0.xy + r0.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r0.xy = t23.Load(r0.xyz).xy;
  r0.zw = v1.xy + -r0.xy;
  r1.xy = (int2)v0.xy;
  r1.xyz = t3.Load(r1.xyz).xyz;
  r2.xy = float2(1,1) / cb12[0].zw;
  r2.zw = r0.zw * cb12[0].zw + float2(-0.5,-0.5);
  r2.zw = floor(r2.zw);
  r4.xyzw = float4(0.5,0.5,-0.5,-0.5) + r2.zwzw;
  r5.xy = r0.zw * cb12[0].zw + -r4.xy;
  r5.zw = r5.xy * r5.xy;
  r6.xy = r5.xy * r5.zw;
  r6.zw = r5.wz + r5.wz;
  r7.xy = -r5.yx * r5.wz + r6.zw;
  r7.xy = r7.xy + -r5.yx;
  r6.zw = r5.yx * r5.wz + -r6.zw;
  r6.zw = float2(1,1) + r6.zw;
  r6.xy = r5.xy * r5.xy + -r6.xy;
  r6.xy = r6.xy + r5.xy;
  r5.xy = r5.xy * r5.zw + -r5.zw;
  r5.zw = r6.zw + r6.yx;
  r6.xy = r6.xy / r5.wz;
  r4.xy = r6.xy + r4.xy;
  r6.xy = r4.xy * r2.xy;
  r8.xyz = t4.Sample(s3_s, r6.xy).xyz;
  r6.zw = r4.zw * r2.xy;
  r2.zw = float2(2.5,2.5) + r2.zw;
  r2.xy = r2.xy * r2.zw;
  r4.xyz = t4.Sample(s3_s, r6.xw).xyz;
  r7.xy = r5.wz * r7.xy;
  r4.w = 1;
  r9.xyz = t4.Sample(s3_s, r6.zy).xyz;
  r9.w = 1;
  r9.xyzw = r9.xyzw * r7.yyyy;
  r4.xyzw = r4.xyzw * r7.xxxx + r9.xyzw;
  r1.w = r5.w * r5.z;
  r8.w = 1;
  r4.xyzw = r8.xyzw * r1.wwww + r4.xyzw;
  r2.zw = r6.yx;
  r6.xyz = t4.Sample(s3_s, r2.xz).xyz;
  r2.xz = r5.xy * r5.zw;
  r6.w = 1;
  r4.xyzw = r6.xyzw * r2.xxxx + r4.xyzw;
  r5.xyz = t4.Sample(s3_s, r2.wy).xyz;
  r5.w = 1;
  r2.xyzw = r5.xyzw * r2.zzzz + r4.xyzw;
  r1.w = rcp(r2.w);

  //r2.xyz = saturate(r2.xyz * r1.www);
  r2.xyz = (r2.xyz * r1.www);
  
  //r1.xyz = saturate(r1.xyz);
  r1.xyz = (r1.xyz);

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r2.xyz = saturate(r2.xyz);
    r1.xyz = saturate(r1.xyz);
  }
  
  r4.x = dot(float3(0.25,0.5,0.25), r1.xyz);
  r4.y = dot(float2(0.5,-0.5), r1.xz);
  r4.z = dot(float3(-0.25,0.5,-0.25), r1.xyz);
  r1.x = dot(float3(0.25,0.5,0.25), r2.xyz);
  r1.y = dot(float2(0.5,-0.5), r2.xz);
  r1.z = dot(float3(-0.25,0.5,-0.25), r2.xyz);
  r2.xyz = t3.Sample(s3_s, v1.xy, int2(1, 0)).xyz; // needed to fix up all the int2(x, y) values because they were just (0, 0) with 3dmigoto
  r5.x = dot(float3(0.25,0.5,0.25), r2.xyz);
  r5.y = dot(float2(0.5,-0.5), r2.xz);
  r5.z = dot(float3(-0.25,0.5,-0.25), r2.xyz);
  r2.xyz = r5.xyz + r4.xyz;
  r5.xyz = r5.xyz * r5.xyz;
  r5.xyz = r4.xyz * r4.xyz + r5.xyz;
  r6.xyz = t3.Sample(s3_s, v1.xy, int2(0, -1)).xyz;
  r7.x = dot(float3(0.25,0.5,0.25), r6.xyz);
  r7.y = dot(float2(0.5,-0.5), r6.xz);
  r7.z = dot(float3(-0.25,0.5,-0.25), r6.xyz);
  r2.xyz = r7.xyz + r2.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyz = t3.Sample(s3_s, v1.xy, int2(0, 1)).xyz;
  r7.x = dot(float3(0.25,0.5,0.25), r6.xyz);
  r7.y = dot(float2(0.5,-0.5), r6.xz);
  r7.z = dot(float3(-0.25,0.5,-0.25), r6.xyz);
  r2.xyz = r7.xyz + r2.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyz = t3.Sample(s3_s, v1.xy, int2(-1, 0)).xyz;
  r7.x = dot(float3(0.25,0.5,0.25), r6.xyz);
  r7.y = dot(float2(0.5,-0.5), r6.xz);
  r7.z = dot(float3(-0.25,0.5,-0.25), r6.xyz);
  r2.xyz = r7.xyz + r2.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyz = t3.Sample(s3_s, v1.xy, int2(-1, -1)).xyz;
  r7.x = dot(float3(0.25,0.5,0.25), r6.xyz);
  r7.y = dot(float2(0.5,-0.5), r6.xz);
  r7.z = dot(float3(-0.25,0.5,-0.25), r6.xyz);
  r2.xyz = r7.xyz + r2.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyz = t3.Sample(s3_s, v1.xy, int2(-1, 1)).xyz;
  r7.x = dot(float3(0.25,0.5,0.25), r6.xyz);
  r7.y = dot(float2(0.5,-0.5), r6.xz);
  r7.z = dot(float3(-0.25,0.5,-0.25), r6.xyz);
  r2.xyz = r7.xyz + r2.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyz = t3.Sample(s3_s, v1.xy, int2(1, -1)).xyz;
  r7.x = dot(float3(0.25,0.5,0.25), r6.xyz);
  r7.y = dot(float2(0.5,-0.5), r6.xz);
  r7.z = dot(float3(-0.25,0.5,-0.25), r6.xyz);
  r2.xyz = r7.xyz + r2.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyz = t3.Sample(s3_s, v1.xy, int2(1, 1)).xyz;
  r7.x = dot(float3(0.25,0.5,0.25), r6.xyz);
  r7.y = dot(float2(0.5,-0.5), r6.xz);
  r7.z = dot(float3(-0.25,0.5,-0.25), r6.xyz);
  r2.xyz = r7.xyz + r2.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyz = float3(0.111111112,0.111111112,0.111111112) * r2.xyz;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = min(1, r0.x);
  r0.y = r0.x * -0.850000024 + 0.850000024;
  r6.xyz = r6.xyz * r6.xyz;
  r5.xyz = r5.xyz * float3(0.111111112,0.111111112,0.111111112) + -r6.xyz;
  r5.xyz = max(float3(0,0,0), r5.xyz);
  r5.xyz = sqrt(r5.xyz);
  r5.xyz = r5.xyz * r0.yyy;
  r6.xyz = r2.xyz * float3(0.111111112,0.111111112,0.111111112) + -r5.xyz;
  r2.xyz = r2.xyz * float3(0.111111112,0.111111112,0.111111112) + r5.xyz;
  r1.xyz = max(r6.xyz, r1.xyz);
  r1.xyz = min(r1.xyz, r2.xyz);
  r0.x = -r0.x * 10 + 1;
  r0.x = max(0, r0.x);
  r2.xy = min(r3.xz, r3.yw);
  r0.y = min(r2.x, r2.y);
  r2.xy = max(r3.xz, r3.yw);
  r1.w = max(r2.x, r2.y);
  r1.w = r1.w + -r0.y;
  r1.w = cmp(0.00100000005 < abs(r1.w));
  r2.xyzw = t6.Gather(s3_s, r0.zw).xyzw;
  r2.xy = max(r2.xz, r2.yw);
  r2.x = max(r2.x, r2.y);
  r2.x = 0.00100000005 + r2.x;
  r0.y = cmp(r2.x >= r0.y);
  r0.y = (int)r1.w | (int)r0.y;
  r2.xy = cmp(r0.zw >= float2(0,0));
  r1.w = r2.y ? r2.x : 0;
  r0.zw = cmp(r0.zw < float2(1,1));
  r0.z = r0.w ? r0.z : 0;
  r0.z = r0.z ? r1.w : 0;
  r0.yz = r0.yz ? float2(1,1) : 0;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r0.z;
  r0.x = 0.925000012 * r0.x;
  r0.yzw = r1.xyz + -r4.xyz;
  r0.xyz = r0.xxx * r0.yzw + r4.xyz;
  r1.x = dot(float3(1,1,-1), r0.xyz);
  r1.y = dot(float2(1,1), r0.xz);
  r1.z = dot(float3(1,-1,-1), r0.xyz);
  r1.w = 1;

  o0.xyzw = r1.xyzw;
  o1.xyzw = r1.xyzw;
  return;
}