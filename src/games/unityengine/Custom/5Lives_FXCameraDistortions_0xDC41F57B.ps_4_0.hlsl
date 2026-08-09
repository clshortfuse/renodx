#include "../shared.h"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[22];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[6].y * v1.y;
  r0.x = r0.x / cb0[12].x;
  r0.x = cb0[14].y * r0.x;
  r0.x = frac(r0.x);
  r0.x = r0.x * 2 + -1;
  r0.y = -0.5 + abs(r0.x);
  r0.x = abs(r0.x) * cb0[12].y + v1.x;
  r0.x = cb0[13].z + r0.x;
  r0.x = frac(r0.x);
  r0.y = cb0[12].z * r0.y + 0.5;
  r0.z = 1 + -abs(cb0[12].y);
  r1.x = r0.x * r0.z;
  r1.y = cb0[13].y + v1.y;
  r2.xyzw = t0.Sample(s3_s, r1.xy).xyzw;
  r0.xz = float2(-0.5,-0.5) + r2.xz;
  r0.z = r0.z + -r0.x;
  r0.x = cb0[13].x * r0.z + r0.x;
  r1.x = saturate(r0.x * cb0[12].w + r1.x);
  r0.x = cb0[14].x + v1.y;
  r0.x = frac(r0.x);
  r0.z = cb0[14].y * 0.5 + -0.5;
  r1.y = r0.x * cb0[14].y + -r0.z;
  r0.xz = saturate(r1.xy);
  r2.xyzw = t0.Sample(s3_s, r0.xz).xyzw;
  r0.x = r2.y + r2.y;
  r0.zw = cb0[20].yw + r2.ww;
  r0.zw = max(float2(0.01,0.01), r0.zw);
  r0.zw = min(float2(1,1), r0.zw);
  r0.zw = log2(r0.zw);
  r0.zw = cb0[20].xz * r0.zw;
  r0.zw = exp2(r0.zw);
  r0.x = r0.y * r0.x;
  r0.x = dot(r0.xx, cb0[14].yy);
  r1.zw = r1.xy * cb0[15].xy + cb0[15].zw;
  r2.xyzw = t1.Sample(s2_s, r1.zw).xyzw;
  r1.zw = float2(-0.5,-0.5) + r2.xy;
  r0.y = cb0[14].z * r2.z;
  r1.zw = cb0[14].zz * r1.zw;
  r2.x = 1 + -r0.z;
  r1.xy = r1.zw * r2.xx + r1.xy;
  r2.xyzw = -v1.xyxy + r1.xyxy;
  r3.xyzw = r2.xyzw * cb0[16].zzww + r1.xyxy;
  r2.xyzw = r2.zwzw * cb0[16].xxyy + r1.xyxy;
  r1.xyzw = t2.Sample(s0_s, r1.xy).xyzw;
  r4.xyzw = t3.Sample(s1_s, r3.zw).xyzw;
  r5.xyzw = t2.Sample(s0_s, r3.zw).xyzw;
  r3.z = -r5.w + r4.z;
  r4.w = r0.y * r3.z + r5.w;
  r5.xyzw = t3.Sample(s1_s, r2.xy).xyzw;
  r6.xyzw = t2.Sample(s0_s, r2.xy).xyzw;
  r2.x = -r6.x + r5.x;
  r4.x = r0.y * r2.x + r6.x;
  r5.xyzw = t3.Sample(s1_s, r2.zw).xyzw;
  r2.xyzw = t2.Sample(s0_s, r2.zw).xyzw;
  r2.x = r5.y + -r2.y;
  r4.y = r0.y * r2.x + r2.y;
  r2.xyzw = t3.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s0_s, r3.xy).xyzw;
  r2.x = -r3.z + r2.z;
  r4.z = r0.y * r2.x + r3.z;
  r2.xyzw = r4.xyzw * r0.xxxx;
  r0.y = dot(r2.xyz, float3(0.222,0.707,0.071));
  r3.xyz = r4.xyz * r0.xxx + -r0.yyy;
  r0.x = cb0[17].x * r0.y;
  r4.xyzw = cb0[19].xyzw + -cb0[18].xyzw;
  r4.xyzw = r0.xxxx * r4.xyzw + cb0[18].xyzw;
  if(injectedData.toneMapType == 0.f){
    r4.xyzw = max(float4(0,0,0,0), r4.xyzw);
    r4.xyzw = min(float4(2,2,2,2), r4.xyzw);
  }
  r3.xyz = r3.xyz * r4.www + r2.xyz;
  r3.xyz = r3.xyz + -r0.yyy;
  r3.xyz = r4.www * r3.xyz + r0.yyy;
  r2.xyz = r3.xyz * r4.xyz;
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r1.xyzw = r0.zzzz * r1.xyzw + r2.xyzw;
  r0.xyz = saturate(cb0[21].xyz + cb0[21].www);
  r0.xyz = float3(1,1,1) + -r0.xyz;
  r0.xyz = r1.xyz * r0.xyz + cb0[21].xyz;
  r2.xyz = r1.xyz + -r0.xyz;
  r1.xyz = r0.www * r2.xyz + r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r1.xyzw = max(float4(0,0,0,0), r1.xyzw);
  }
  o0.xyzw = r1.xyzw;
  return;
}