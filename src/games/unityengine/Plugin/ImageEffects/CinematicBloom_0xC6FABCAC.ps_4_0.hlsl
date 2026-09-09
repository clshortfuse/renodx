#include "../../shared.h"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1;
  r0.z = cb0[6].w;
  r0.xyzw = cb0[2].xyxy * r0.xxzz;
  r1.zw = float2(-1,0);
  r1.x = cb0[6].w;
  r2.xyzw = -r0.xywy * r1.xxwx + v1.xyxy;
  r3.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r3.xyz;
  r3.xy = -r0.zy * r1.zx + v1.xy;
  r3.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = r0.zwxw * r1.zwxw + v1.xyxy;
  r4.xyzw = r0.zywy * r1.zxwx + v1.xyxy;
  r0.xy = r0.xy * r1.xx + v1.xy;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r3.zw).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + r2.xyz;
  r2.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * float3(4,4,4) + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r2.xyzw = t1.Sample(s0_s, r4.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r4.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[7].xxx * r0.xyz;
  r1.xyz = float3(0.0625,0.0625,0.0625) * r0.xyz;
  r1.xyz = renodx::math::SignPow(r1.xyz, 1.3f);
  r2.z = 0.00200000009 * cb1[0].y;
  r2.w = 0;
  r2.xy = v1.xy * float2(1.5,1.5) + r2.zw;
  r2.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyz = cb0[7].yyy * r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.w = dot(r2.xyz, float3(0.300000012,0.600000024,0.100000001));
  r0.w = 1.5 * r0.w;
  r1.w = r0.w * r0.w;
  r0.w = saturate(r1.w * r0.w);
  r1.w = -cb1[0].x * 0.0149999997 + v1.x;
  r2.x = 12 * r1.w;
  r2.yz = float2(0,0);
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r1.w = r3.x * r3.x;
  r1.w = r1.w * r1.w;
  r1.w = r1.w * 3 + 1;
  r2.x = cb1[0].y * 0.00499999989 + v1.y;
  r2.w = 12 * r2.x;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.x = r2.y * r2.y;
  r2.x = r2.x * r2.x;
  r1.w = r2.x * 3 + r1.w;
  r1.w = -1 + r1.w;
  r0.w = r0.w * r1.w + 1;
  r2.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  r0.xyz = r0.xyz * float3(0.0625,0.0625,0.0625) + r2.xyz;
  o0.w = r2.w;
  o0.xyz = r1.xyz * r0.www + r0.xyz;
  return;
}