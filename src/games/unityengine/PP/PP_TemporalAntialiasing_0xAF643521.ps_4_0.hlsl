#include "../shared.h"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[33];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[29].xy + w1.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r0.xy = min(cb0[26].xx, r0.xy);
  r0.xyzw = t3.Sample(s2_s, r0.xy).yzxw;
  r1.xyzw = t3.Sample(s2_s, w1.xy).yzxw;
  r0.w = step(r1.z, r0.z);
  r0.xy = float2(-1,-1);
  r1.xy = float2(0,0);
  r0.xyz = -r1.yyz + r0.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r1.xy = float2(1,-1);
  r2.xyzw = cb0[29].xyxy * float4(1,-1,-1,1) + w1.xyxy;
  r2.xyzw = max(float4(0,0,0,0), r2.xyzw);
  r2.xyzw = min(cb0[26].xxxx, r2.xyzw);
  r3.xyzw = t3.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s2_s, r2.zw).yzxw;
  r1.z = r3.x;
  r0.w = step(r0.z, r3.x);
  r1.xyz = r1.xyz + -r0.yyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r2.xy = float2(-1,1);
  r0.w = step(r0.z, r2.z);
  r1.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xy = cb0[29].xy + w1.xy;
  r1.xy = max(float2(0,0), r1.xy);
  r1.xy = min(cb0[26].xx, r1.xy);
  r1.xyzw = t3.Sample(s2_s, r1.xy).xyzw;
  r0.z = step(r0.z, r1.x);
  r1.xy = float2(1,1) + -r0.xy;
  r0.xy = r0.zz * r1.xy + r0.xy;
  r0.xy = r0.xy * cb0[29].xy + w1.xy;
  r0.xyzw = t4.Sample(s3_s, r0.xy).xyzw;
  r0.zw = w1.xy + -r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.yz = max(float2(0,0), r0.zw);
  r0.yz = min(cb0[26].xx, r0.yz);
  r1.xyzw = t2.Sample(s1_s, r0.yz).xyzw;
  r0.y = 100 * r0.x;
  r0.x = cb0[31].z * r0.x;
  r0.y = min(1, r0.y);
  r0.y = r0.y * -3.75 + 4;
  r0.zw = -cb0[30].xy + w1.xy;
  r0.zw = max(float2(0,0), r0.zw);
  r0.zw = min(cb0[26].xx, r0.zw);
  r2.xy = -cb0[28].xy * float2(0.5,0.5) + r0.zw;
  r2.xy = max(float2(0,0), r2.xy);
  r2.xy = min(cb0[26].xx, r2.xy);
  r2.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r3.xy = cb0[28].xy * float2(0.5,0.5) + r0.zw;
  r3.xy = max(float2(0,0), r3.xy);
  r3.xy = min(cb0[26].xx, r3.xy);
  r3.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r4.xyzw = r3.xyzw + r2.xyzw;
  r5.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  r6.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.z = r6.x * -0.800000012 + 1;
  r6.xyzw = r5.xyzw + r5.xyzw;
  r4.xyzw = r4.xyzw * float4(4,4,4,4) + -r6.xyzw;
  r6.xyzw = -r4.xyzw * float4(0.166666999,0.166666999,0.166666999,0.166666999) + r5.xyzw;
  r6.xyzw = cb0[32].xxxx * r6.xyzw;
  r5.xyzw = r6.xyzw * float4(2.71828198,2.71828198,2.71828198,2.71828198) + r5.xyzw;
  if(injectedData.toneMapType == 0.f){
  r5.xyzw = max(float4(0,0,0,0), r5.xyzw);
  }
  r5.xyzw = min(float4(65472,65472,65472,65472), r5.xyzw);
  r4.xyz = r5.xyz + r4.xyz;
  r4.xyz = float3(0.142857,0.142857,0.142857) * r4.xyz;
  r0.w = dot(r4.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.w = dot(r5.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.w = -r2.w + r0.w;
  r4.xyz = min(r3.xyz, r2.xyz);
  r2.xyz = max(r3.xyz, r2.xyz);
  r2.xyz = r0.yyy * abs(r0.www) + r2.xyz;
  r3.xyz = -r0.yyy * abs(r0.www) + r4.xyz;
  r4.xyz = -r3.xyz + r2.xyz;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyz = float3(0.5,0.5,0.5) * r4.xyz;
  r4.xyz = -r2.xyz * float3(0.5,0.5,0.5) + r1.xyz;
  r2.xyz = float3(0.5,0.5,0.5) * r2.xyz;
  r6.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) + r4.xyz;
  r3.xyz = r3.xyz / r6.xyz;
  r0.y = min(abs(r3.x), abs(r3.y));
  r0.y = min(r0.y, abs(r3.z));
  r0.y = min(1, r0.y);
  r1.xyz = r4.xyz * r0.yyy + r2.xyz;
  r1.xyzw = -r5.xyzw + r1.xyzw;
  r0.y = cb0[31].y + -cb0[31].x;
  r0.x = r0.x * r0.y + cb0[31].x;
  r0.x = max(cb0[31].y, r0.x);
  r0.x = min(cb0[31].x, r0.x);
  r0.x = r0.x * r0.z;
  r0.xyzw = r0.xxxx * r1.xyzw + r5.xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  }
  r0.xyzw = min(float4(65472,65472,65472,65472), r0.xyzw);
  o0.xyzw = r0.xyzw;
  o1.xyzw = r0.xyzw;
  return;
}