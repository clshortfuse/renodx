#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xw = cb0[6].xy;
  r0.yz = float2(0,0);
  r1.xyzw = float4(v1, w1) + -r0.zwzw;
  r1.xy = saturate(r1.xy);
  r2.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
  r1.z = cb1[7].x * r2.x + cb1[7].y;
  r1.z = 1 / r1.z;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.x = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r2.xyzw = saturate(v1.xyxy + r0.zwxy);
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r1.y = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r1.w = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r2.x = min(r1.w, r1.x);
  r1.x = max(r1.w, r1.x);
  r3.xyzw = float4(v1, w1) + -r0.xyxy;
  r0.xyzw = w1.xyxy + r0.zwxy;
  r3.xy = saturate(r3.xy);
  r4.xyzw = t1.Sample(s1_s, r3.zw).xyzw;
  r1.w = cb1[7].x * r4.x + cb1[7].y;
  r1.w = 1 / r1.w;
  r3.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r2.y = dot(r3.xyz, float3(0.298999995,0.587000012,0.114));
  r2.x = min(r2.x, r2.y);
  r1.x = max(r2.y, r1.x);
  r1.x = max(r1.x, r1.y);
  r1.y = min(r2.x, r1.y);
  r1.y = -9.99999997e-007 + r1.y;
  r2.x = r1.x + -r1.y;
  r2.x = saturate(cb0[8].w / r2.x);
  r2.yz = cb1[6].xy * v1.xy;
  r2.y = dot(float2(171,231), r2.yz);
  r2.yzw = float3(0.00970873795,0.0140845068,0.010309278) * r2.yyy;
  r2.yzw = frac(r2.yzw);
  r2.yzw = -cb0[10].xyz + r2.yzw;
  r3.x = cmp(r1.w >= cb0[9].y);
  r3.x = r3.x ? 1.000000 : 0;
  r2.yzw = r3.xxx * r2.yzw;
  r2.yzw = r2.yzw * cb0[9].xxx + float3(1,1,1);
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.yzw = r3.xyz * r2.yzw;
  o0.w = r3.w;
  r3.x = dot(r2.yzw, float3(0.298999995,0.587000012,0.114));
  r1.y = r3.x * 2 + -r1.y;
  r1.x = r1.y + -r1.x;
  r1.x = r1.x * r2.x;
  r3.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r0.x = cb1[7].x * r0.x + cb1[7].y;
  r0.x = 1 / r0.x;
  r0.y = cb1[7].x * r3.x + cb1[7].y;
  r0.y = 1 / r0.y;
  r0.z = max(r0.y, r1.z);
  r0.y = min(r0.y, r1.z);
  r0.y = min(r0.y, r1.w);
  r0.y = min(r0.y, r0.x);
  r0.z = max(r0.z, r1.w);
  r0.w = -cb0[9].z + r1.w;
  r0.x = max(r0.z, r0.x);
  r0.x = r0.x + -r0.y;
  r0.x = saturate(cb0[8].y / r0.x);
  r0.x = r1.x * r0.x;
  r0.x = cb0[8].x * r0.x;
  r0.x = max(-cb0[8].z, r0.x);
  r0.x = min(cb0[8].z, r0.x);
  r0.y = cb0[9].w * 1.10000002 + abs(r0.w);
  r0.y = abs(r0.w) / r0.y;
  r0.z = cmp(abs(r0.w) >= cb0[9].w);
  r0.w = r0.y * r0.y;
  r0.y = -r0.y * 2 + 3;
  r0.y = -r0.w * r0.y + 1;
  r0.y = r0.z ? r0.y : 1;
  r0.x = r0.x * r0.y + 1;
  r0.yzw = r2.yzw * r0.xxx;
  r1.x = max(r0.z, r0.w);
  r1.x = max(r1.x, r0.y);
  r1.y = min(r0.z, r0.w);
  r1.y = min(r1.y, r0.y);
  r1.x = saturate(r1.x + -r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb0[7].z * r1.x;
  r1.y = dot(r0.yzw, float3(0.298999995,0.587000012,0.114));
  r1.yzw = r2.yzw * r0.xxx + -r1.yyy;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r0.xyz = r0.yzw * r1.xyz + -cb0[10].xyz;
  r0.xyz = r0.xyz * cb0[7].yyy + cb0[10].xyz;
  r0.xyz = cb0[7].xxx * r0.xyz;
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}