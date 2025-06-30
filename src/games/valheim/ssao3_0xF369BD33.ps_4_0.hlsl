#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 29 15:53:33 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;



 

  //if (CUSTOM_SSAO_FILTER == 1) {
    r0.x = cb0[2].y / cb0[8].x;  // coordinates?
    r0.yz = float2(1.38461542, 3.23076916);
    r1.xyzw = float4(-0, -2.76923084, -0, -6.46153831) * r0.yxzx + v2.xyxy;
    r0.xyzw = float4(0, 2.76923084, 0, 6.46153831) * r0.yxzx + v2.xyxy;
    r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
    r2.yzw = r2.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    r3.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
    r2.yzw = r2.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    r3.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
    r2.yzw = r2.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    r3.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
    r3.yzw = r3.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    r2.y = dot(r3.yzw, r2.yzw);
    r2.y = -0.800000012 + r2.y;
    r2.y = saturate(5.00000048 * r2.y);
    r2.z = r2.y * -2 + 3;
    r2.y = r2.y * r2.y;
    r2.y = r2.z * r2.y;
    r2.y = 0.31621623 * r2.y;
    r2.x = r2.x * r2.y;
    r2.x = r3.x * 0.227027029 + r2.x;
    r4.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
    r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
    r4.yzw = r4.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    r2.z = dot(r3.yzw, r4.yzw);
    r2.z = -0.800000012 + r2.z;
    r2.z = saturate(5.00000048 * r2.z);
    r2.w = r2.z * -2 + 3;
    r2.z = r2.z * r2.z;
    r2.z = r2.w * r2.z;
    r2.w = 0.31621623 * r2.z;
    r2.y = r2.z * 0.31621623 + r2.y;
    r2.x = r4.x * r2.w + r2.x;
    r1.yzw = r1.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.y = dot(r3.yzw, r1.yzw);
    r1.y = -0.800000012 + r1.y;
    r1.y = saturate(5.00000048 * r1.y);
    r1.z = r1.y * -2 + 3;
    r1.y = r1.y * r1.y;
    r1.y = r1.z * r1.y;
    r1.z = 0.0702702701 * r1.y;
    r1.y = r1.y * 0.0702702701 + r2.y;
    r1.x = r1.x * r1.z + r2.x;
    r0.yzw = r0.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.y = dot(r3.yzw, r0.yzw);
    o0.yzw = r3.yzw * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
    r0.y = -0.800000012 + r0.y;
    r0.y = saturate(5.00000048 * r0.y);
    r0.z = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r0.z * r0.y;
    r0.z = 0.0702702701 * r0.y;
    r0.y = r0.y * 0.0702702701 + r1.y;
    r0.y = 0.227027029 + r0.y;
    r0.x = r0.x * r0.z + r1.x;
    o0.x = r0.x / r0.y;
  //}
  //else {
    //float4 outputColor = ;
    //o0.xyzw = outputColor;
  //}
  return;
}