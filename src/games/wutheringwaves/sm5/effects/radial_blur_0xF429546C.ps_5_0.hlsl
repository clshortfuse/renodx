#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 12 07:05:26 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float4 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + -cb0[0].y;
  r0.x = max(9.99999975e-06, r0.x);
  r0.yz = -v0.xy * cb0[3].zw + cb0[2].xy;
  r0.w = dot(r0.yz, r0.yz);
  r0.w = sqrt(r0.w);
  r0.w = -cb0[0].x + r0.w;
  r0.x = saturate(r0.w / r0.x);
  r0.w = min(1, cb0[2].z);
  r1.xyzw = r0.yzyz * r0.wwww;
  r2.xyzw = cb0[3].zwzw * v0.xyxy;
  r3.xyzw = r1.zwzw * float4(0.142857149,0.142857149,0.285714298,0.285714298) + r2.zwzw;
  r4.xyzw = cb0[3].xyxy * r2.zwzw;
  r3.xyzw = r3.xyzw * cb0[3].xyxy + -r4.zwzw;
  r3.xyzw = r0.xxxx * r3.xyzw + r4.zwzw;
  r3.xyzw = max(cb0[1].xyxy, r3.xyzw);
  r3.xyzw = min(cb0[1].zwzw, r3.xyzw);
  r0.yzw = t0.Sample(s0_s, r3.xy).xyz;
  r3.xyz = t0.Sample(s0_s, r3.zw).xyz;
  r5.xy = max(cb0[1].xy, r4.zw);
  r5.xy = min(cb0[1].zw, r5.xy);
  r5.xyz = t0.Sample(s0_s, r5.xy).xyz;
  r0.yzw = r5.xyz + r0.yzw;
  r0.yzw = r0.yzw + r3.xyz;
  r3.xyzw = r1.zwzw * float4(0.428571463,0.428571463,0.571428597,0.571428597) + r2.zwzw;
  r1.xyzw = r1.xyzw * float4(0.714285731,0.714285731,0.857142925,0.857142925) + r2.xyzw;
  r1.xyzw = r1.xyzw * cb0[3].xyxy + -r4.zwzw;
  r1.xyzw = r0.xxxx * r1.xyzw + r4.xyzw;
  r1.xyzw = max(cb0[1].xyxy, r1.xyzw);
  r1.xyzw = min(cb0[1].zwzw, r1.xyzw);
  r2.xyzw = r3.xyzw * cb0[3].xyxy + -r4.zwzw;
  r2.xyzw = r0.xxxx * r2.xyzw + r4.zwzw;
  r2.xyzw = max(cb0[1].xyxy, r2.xyzw);
  r2.xyzw = min(cb0[1].zwzw, r2.xyzw);
  r3.xyz = t0.Sample(s0_s, r2.xy).xyz;
  r2.xyz = t0.Sample(s0_s, r2.zw).xyz;
  r0.xyz = r3.xyz + r0.yzw;
  r0.xyz = r0.xyz + r2.xyz;
  r2.xyz = t0.Sample(s0_s, r1.xy).xyz;
  r1.xyz = t0.Sample(s0_s, r1.zw).xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  o0.xyz = float3(0.142857149,0.142857149,0.142857149) * r0.xyz;
  o0.w = 1;
  return;
}