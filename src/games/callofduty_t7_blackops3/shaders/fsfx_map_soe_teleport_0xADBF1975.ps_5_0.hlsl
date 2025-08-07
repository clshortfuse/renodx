// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 02 16:33:15 2025

#include "../common.hlsl"

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb1 : register(b1)
{
  float4 cb1[70];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[2];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[15];
}


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[12].z * cb0[12].w;
  r0.y = cb0[13].x * r0.x;
  r0.z = cb1[69].w * r0.y;
  r0.z = cmp(r0.z >= -r0.z);
  r0.z = r0.z ? r0.y : -r0.y;
  r0.w = 1 / r0.z;
  r0.w = cb1[69].w * r0.w;
  r0.w = frac(r0.w);
  r0.z = r0.z * r0.w;
  r0.y = r0.z / r0.y;
  r0.x = r0.y * r0.x;
  r0.x = round(r0.x);
  r0.y = r0.x / cb0[12].w;
  r0.z = cb0[12].w * r0.x;
  r0.z = cmp(r0.z >= -r0.z);
  r0.z = r0.z ? cb0[12].w : -cb0[12].w;
  r0.w = 1 / r0.z;
  r0.x = r0.x * r0.w;
  r0.x = frac(r0.x);
  r0.x = r0.z * r0.x;
  r0.x = trunc(r0.x);
  r0.x = v1.x + r0.x;
  r1.x = r0.x / cb0[12].w;
  r0.x = trunc(r0.y);
  r0.x = v1.y + r0.x;
  r1.y = r0.x / cb0[12].z;
  r0.xyzw = t9.Sample(s1_s, r1.xy).xyzw;
  r1.xy = saturate(cb3[0].zy);
  r0.w = r1.x * r0.w;
  r1.xzw = log2(cb3[1].xyz);
  r1.xzw = float3(2.20000005,2.20000005,2.20000005) * r1.xzw;
  r1.xzw = exp2(r1.xzw);
  r1.xzw = float3(-1,-1,-1) + r1.xzw;
  r1.xzw = cb3[1].www * r1.xzw + float3(1,1,1);
  r2.xyz = r1.xzw * r0.xyz;
  r2.w = t6.Sample(s1_s, v1.xy).x;
  r2.w = 1 + -r2.w;
  r3.x = min(1, abs(cb3[0].x));
  r3.x = cb0[10].z * r3.x;
  r3.x = cb1[44].z * r3.x;
  r3.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r4.xy = cmp(float2(0,0) < cb3[0].xw);
  r3.w = r2.w * r3.x + 1;
  r4.zw = r3.yz * r3.ww;
  r4.zw = r4.zw * float2(0.5,0.5) + float2(0.5,0.5);
  r2.w = -r2.w * r3.x + 1;
  r3.xy = r3.yz * r2.ww;
  r3.xy = r3.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r3.xy = r4.xx ? r4.zw : r3.xy;
  if (r4.y != 0) {
    r3.zw = cb1[69].ww * cb0[14].xy;
    r3.zw = v1.xy * cb0[14].zw + r3.zw;
    r3.zw = frac(r3.zw);
    r4.xy = cb1[44].zw * cb0[13].zz;
    r3.zw = t10.Sample(s1_s, r3.zw).xy;
    r3.zw = r3.zw * float2(2,2) + float2(-1,-1);
    r3.zw = cb3[0].ww * r3.zw;
    r3.zw = r4.xy * r3.zw;
  } else {
    r3.zw = float2(0,0);
  }
  r3.xy = r3.xy + r3.zw;
  r3.zw = cb1[69].ww * cb0[12].xy + v1.xy;
  r2.w = t7.Sample(s1_s, r3.zw).x;
  r1.y = r2.w * r1.y;
  r1.y = cb0[10].w * r1.y;
  r3.zw = cb1[44].zw * r1.yy;
  r4.xyzw = r3.zwzw * cb0[11].xxyy + r3.xyxy;
  r5.x = t0.Sample(s1_s, r4.xy).x;
  r5.y = t0.Sample(s1_s, r4.zw).y;
  r3.xy = r3.zw * cb0[11].zz + r3.xy;
  r5.z = t0.Sample(s1_s, r3.xy).z;
  r3.xyz = float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) * r5.xyz;
  r0.xyz = r0.xyz * r1.xzw + -r3.xyz;
  r0.xyz = r0.www * r0.xyz + r3.xyz;
  r1.xyz = -r5.xyz * float3(3.05175781e-005,3.05175781e-005,3.05175781e-005) + float3(1,1,1);
  r2.xyz = -r2.xyz * r0.www + float3(1,1,1);
  r1.xyz = -r1.xyz * r2.xyz + float3(1,1,1);
  r0.xyz = cb0[13].yyy ? r0.xyz : r1.xyz;

  o0.xyz = float3(32768,32768,32768) * r0.xyz;

  o0.xyz = Tradeoff_PrepareFullWidthFsfx(o0.xyz, 1.5);
  o0.w = 1;
  return;
}