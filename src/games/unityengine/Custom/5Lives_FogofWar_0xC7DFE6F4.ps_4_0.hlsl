#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[28];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  r0.x = cb1[7].x * r0.x + cb1[7].y;
  r0.x = 1 / r0.x;
  r0.xy = r0.xx * v2.xz + cb0[17].xz;
  r0.zw = -cb0[22].xz + r0.xy;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r0.z = -cb0[7].x + r0.z;
  r1.xy = -cb0[21].xz + r0.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = -cb0[7].x + r0.w;
  r0.zw = cb0[7].zz * r0.zw;
  r0.z = min(r0.w, r0.z);
  r1.xy = -cb0[23].xz + r0.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = -cb0[7].x + r1.x;
  r1.x = cb0[7].z * r1.x;
  r0.z = min(r1.x, r0.z);
  r1.xy = -cb0[24].xz + r0.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = -cb0[7].x + r1.x;
  r1.x = cb0[7].z * r1.x;
  r0.z = min(r1.x, r0.z);
  r0.z = min(r0.z, r0.w);
  r1.xy = -cb0[25].xz + r0.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = -cb0[7].x + r0.w;
  r1.xy = -cb0[26].xz + r0.xy;
  r0.xy = -cb0[27].xz + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = -cb0[7].x + r0.x;
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  r0.y = -cb0[7].x + r0.y;
  r0.xyw = cb0[7].zzz * r0.xyw;
  r0.y = min(r0.w, r0.y);
  r0.x = min(r0.y, r0.x);
  r0.x = saturate(min(r0.z, r0.x));
  r0.x = min(cb0[7].y, r0.x);
  r1.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  r0.y = dot(r1.xyzw, r1.xyzw);
  r0.y = sqrt(r0.y);
  r0.y = min(1, r0.y);
  r0.y = 1 + -r0.y;
  r0.y = log2(r0.y);
  r0.z = cb0[6].w * 25 + 1;
  r0.y = r0.z * r0.y;
  r0.y = exp2(r0.y);
  r0.y = 1 + -r0.y;
  r2.xyz = cb0[6].xyz * r0.yyy;
  r2.w = 0;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  o0.xyzw = r0.xxxx * r2.xyzw + r1.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}