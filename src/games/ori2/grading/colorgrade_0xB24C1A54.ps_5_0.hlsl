#include "./grading.hlsli" 
#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 15 21:14:57 2024
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[22];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  linear noperspective float2 v1 : TEXCOORD0,
  linear noperspective float2 w1 : TEXCOORD1,
  linear noperspective float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t0.Sample(s2_s, v2.xy).xy;
  r0.xy = float2(-0.498039216,-0.498039216) + r0.xy;
  r0.xy = float2(0.100000001,0.100000001) * r0.xy;
  r1.xyzw = r0.xyxy * cb0[5].xyxy + v1.xyxy;
  r0.xy = r0.xy * cb0[5].xy + v2.xy;
  r0.xy = min(cb0[6].zw, r0.xy);
  r0.xyzw = t2.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = saturate(-r0.xyzw * cb0[21].xxxx + float4(1,1,1,1));
  r1.xyzw = min(cb0[6].xyxy, r1.xyzw);
  r2.xyzw = cb0[3].xyxy * float4(-1.5,-1.5,1.5,-1.5) + r1.zwzw;
  r3.xyz = t1.Sample(s0_s, r2.xy).xyz;
  r2.xyz = t1.Sample(s0_s, r2.zw).xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = cb0[3].xyxy * float4(-1.5,1.5,1.5,1.5) + r1.xyzw;
  r1.xyzw = t1.Sample(s0_s, r1.zw).xyzw;
  r4.xyz = t1.Sample(s0_s, r3.xy).xyz;
  r3.xyz = t1.Sample(s0_s, r3.zw).xyz;
  r2.xyz = r4.xyz + r2.xyz;
  r2.xyz = r2.xyz + r3.xyz;
  r2.xyz = -r2.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r1.xyz = r2.xyz * cb0[8].yyy + r1.xyz;
  r2.xy = w1.xy * float2(2,2) + float2(-1,-1);
  r2.x = dot(r2.xy, r2.xy);
  r2.x = min(1, r2.x);
  r2.x = cb0[8].x * r2.x;
  r2.x = r2.x * 7 + 1;
  r1.xyzw = r2.xxxx * r1.xyzw;
r2.xyz = cb0[17].xyz * r1.xyz;  //    r2.xyz = saturate(cb0[17].xyz * r1.xyz);
  float3 hdrColor = r2.xyz;
  float3 sdrColor = r2.xyz;
  float scale = 1.f;
  ToneMapForGrading(sdrColor, scale);
  r2.xyz = saturate(sdrColor);

  r3.xyz = r2.xyz * r2.xyz;
  r4.xyz = r3.xyz * r2.xyz;
  r5.w = r4.x;
  r6.xyz = float3(1,1,1) + -r2.xyz;
  r7.xyz = r6.xyz * r6.xyz;
  r8.xyz = r7.yxz * r6.yxz;
  r3.xyz = r6.xyz * r3.xyz;
  r2.xyz = r7.xzy * r2.xzy;
  r5.x = r8.y;
  r5.y = r2.x;
  r5.z = r3.x;
  r5.x = dot(r5.xyzw, cb0[14].xyzw);
  r2.x = r8.z;
  r8.y = r2.z;
  r8.z = r3.y;
  r2.z = r3.z;
  r8.w = r4.y;
  r2.w = r4.z;
  r5.z = dot(r2.xyzw, cb0[16].xyzw);
  r5.y = dot(r8.xyzw, cb0[15].xyzw);
  r1.xyz = r5.xyz * cb0[9].xxx + cb0[9].yyy;
  r1.xyzw = float4(1,1,1,1) + -r1.xyzw;
  r2.xyzw = -r0.xyzw * r1.xyzw + float4(1,1,1,1);
  r0.xyz = -r0.xyz * r1.xyz + float3(0.5,0.5,0.5);
  r1.xy = float2(-0.5,-0.5) + w1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = r0.w * 0.720000029 + -0.800000012;
  r0.w = saturate(-1.83715463 * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r1.y = r1.x * r0.w + -1;
  r0.w = r1.x * r0.w;
  r1.x = -r1.y * 0.200000003 + 1;
  r1.x = max(1, r1.x);
  r0.xyz = r0.xyz * r1.xxx + float3(0.5,0.5,0.5);
  r0.xyz = r0.xyz * r0.www + -r2.xyz;
  r0.w = 0;
  o0.xyzw = cb0[12].yyyy * r0.xyzw + r2.xyzw;
  UpgradeToneMap(hdrColor, sdrColor, o0.xyz, scale);

  return;
}
