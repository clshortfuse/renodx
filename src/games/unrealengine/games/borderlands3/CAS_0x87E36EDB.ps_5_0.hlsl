//THIS IS A BYPASS OF THIS SHARPENING SHADER AND NOT A PROPER FIX
//THE SHADER DOES NOT FUNCTION IN HDR AND SHOULD BE FIXED PROPERLY

#include "../../effects.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Mon Sep  8 23:46:55 2025
Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 bypass = t0.Load((int3)v1.xyz).xyz;

  // r0.zw = float2(0,0);
  // r1.xyzw = (int4)v1.xxyy;
  // r1.xyzw = (uint4)r1.xyzw;
  // r1.xyzw = r1.xyzw * cb0[1].xxyy + cb0[1].zzww;
  // r2.xyzw = floor(r1.yyww);
  // r1.xyzw = -r2.xyzw + r1.xyzw;
  // r2.xy = (int2)r2.yw;
  // r3.xyzw = (int4)r2.xyxy + int4(-1,1,1,0);
  // r0.xy = r3.zw;
  // r0.xyz = t0.Load(r0.xyz).xyz;

  // float3 f = r0.xyz;

  // r0.xyz = r0.xyz * r0.xyz;
  // r2.zw = float2(0,0);
  // r4.xyz = t0.Load(r2.xyz).xyz;

  // float3 e = r4.xyz;

  // r4.xyz = r4.xyz * r4.xyz;
  // r0.w = min(r4.y, r0.y);
  // r5.xyzw = (int4)r2.xyxy + int4(1,-1,-1,0);
  // r6.xy = r5.zw;
  // r6.zw = float2(0,0);
  // r6.xyz = t0.Load(r6.xyz).xyz;

  // float3 d = r6.xyz;

  // r6.xyz = r6.xyz * r6.xyz;
  // r0.w = min(r6.y, r0.w);
  // r7.xyzw = (int4)r2.xyxy + int4(-1,-1,0,-1);
  // r2.xyzw = (int4)r2.xyxy + int4(1,1,0,1);
  // r8.xy = r7.zw;
  // r8.zw = float2(0,0);
  // r8.xyz = t0.Load(r8.xyz).xyz;

  // float3 b = r8.xyz;

  // r8.xyz = r8.xyz * r8.xyz;
  // r9.xy = r2.zw;
  // r9.zw = float2(0,0);
  // r9.xyz = t0.Load(r9.xyz).xyz;

  // float3 h = r9.xyz;

  // r9.xyz = r9.xyz * r9.xyz;
  // r4.w = min(r9.y, r8.y);
  // r0.w = min(r4.w, r0.w);
  // r7.zw = float2(0,0);
  // r7.xyz = t0.Load(r7.xyz).xyz;

  // float3 a = r7.xyz;

  // r7.xyz = r7.xyz * r7.xyz;
  // r5.zw = float2(0,0);
  // r5.xyz = t0.Load(r5.xyz).xyz;

  // float3 c = r5.xyz;

  // r5.xyz = r5.xyz * r5.xyz;
  // r4.w = min(r7.y, r5.y);
  // r4.w = min(r4.w, r0.w);
  // r3.zw = float2(0,0);
  // r3.xyz = t0.Load(r3.xyz).xyz;

  // float3 g = r3.xyz;

  // r3.xyz = r3.xyz * r3.xyz;
  // r2.zw = float2(0,0);
  // r2.xyz = t0.Load(r2.xyz).xyz;

  // float3 i = r2.xyz;

  // //o0.rgb = ComputeCAS(b, d, e, f, h, 1);

  // // r2.xyz = r2.xyz * r2.xyz;
  // // r2.w = min(r3.y, r2.y);
  // // r2.w = min(r4.w, r2.w);
  // // r0.w = r2.w + r0.w;
  // // r2.w = max(r7.y, r5.y);
  // // r2.w = max(r2.w, r0.w);
  // // r3.w = max(r3.y, r2.y);
  // // r2.w = max(r3.w, r2.w);
  // // r3.w = max(r4.y, r0.y);
  // // r3.w = max(r6.y, r3.w);
  // // r4.w = max(r9.y, r8.y);
  // // r3.w = max(r4.w, r3.w);
  // // r2.w = r3.w + r2.w;
  // // r3.w = 2 + -r2.w;
  // // r2.w = rcp(r2.w);
  // // r0.w = min(r3.w, r0.w);
  // // r0.w = saturate(r0.w * r2.w);
  // // r2.w = r0.w + r0.w;
  // // r0.w = -r0.w * r0.w + r2.w;
  // // r0.w = max(0.5, r0.w);
  // // r10.xy = r0.ww * float2(1.5,1.5) + float2(1,2);
  // // r11.xyzw = r1.wwyy * cb0[2].xxxx + cb0[2].yyyy;
  // // r1.xyzw = r1.xyzw * cb0[2].xxxx + -cb0[2].yzyz;
  // // r11.xyzw = r11.xyzw * r11.xyzw;
  // // r0.w = r11.w + r11.y;
  // // r11.xyzw = r1.xyzw * r1.xyzw + r11.xyzw;
  // // r1.xyzw = r1.xyzw * r1.xyzw;
  // // r1.xyzw = r1.xyxy + r1.zzww;
  // // r1.xyzw = min(float4(1,1,1,1), r1.xyzw);
  // // r11.xyzw = min(float4(1,1,1,1), r11.xyzw);
  // // r0.w = min(1, r0.w);
  // // r2.w = r0.w * r0.w;
  // // r2.w = r10.x * r2.w;
  // // r0.w = -r10.y * r0.w + r2.w;
  // // r0.w = 1 + r0.w;
  // // r12.xyzw = r11.xyzw * r11.xyzw;
  // // r12.xyzw = r12.xyzw * r10.xxxx;
  // // r11.xyzw = -r10.yyyy * r11.xyzw + r12.xyzw;
  // // r11.xyzw = float4(1,1,1,1) + r11.xyzw;
  // // r8.xyz = r11.xxx * r8.xyz;
  // // r7.xyz = r7.xyz * r0.www + r8.xyz;
  // // r0.w = r11.x + r0.w;
  // // r0.w = r0.w + r11.y;
  // // r0.w = r0.w + r11.z;
  // // r5.xyz = r5.xyz * r11.yyy + r7.xyz;
  // // r5.xyz = r6.xyz * r11.zzz + r5.xyz;
  // // r6.xyzw = r1.xyzw * r1.xyzw;
  // // r6.xyzw = r10.xxxx * r6.xyzw;
  // // r1.xyzw = -r10.yyyy * r1.xyzw + r6.xyzw;
  // // r1.xyzw = float4(1,1,1,1) + r1.xyzw;
  // // r4.xyz = r4.xyz * r1.xxx + r5.xyz;
  // // r0.xyz = r0.xyz * r1.yyy + r4.xyz;
  // // r0.xyz = r3.xyz * r11.www + r0.xyz;
  // // r0.xyz = r9.xyz * r1.zzz + r0.xyz;
  // // r0.xyz = r2.xyz * r1.www + r0.xyz;
  // // r0.w = r1.x + r0.w;
  // // r0.w = r0.w + r1.y;
  // // r0.w = r0.w + r11.w;
  // // r0.w = r0.w + r1.z;
  // // r0.w = r0.w + r1.w;
  // // r0.w = rcp(r0.w);
  // // r0.xyz = saturate(r0.xyz * r0.www);
  // // r0.xyz = r0.xyz * r0.www;
  // // o0.xyz = sqrt(r0.xyz);

  o0.xyz = bypass;
  o0.w = 0;
  return;
}