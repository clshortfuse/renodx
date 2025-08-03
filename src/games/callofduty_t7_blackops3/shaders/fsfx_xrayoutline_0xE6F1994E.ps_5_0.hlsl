// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 21:12:23 2025

#include "../common.hlsl"

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[70];
}

cbuffer cb8 : register(b8)
{
  float4 cb8[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r1.x = t0.Load(r0.xyw).x;
  r0.xyz = t6.Load(r0.xyz).xyz;
  r0.w = cmp(0.899999976 < r1.x);

  if (CUSTOM_XRAY_OUTLINE == 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }

  r2.xy = cb1[44].zw * cb8[0].ww;
  r3.x = -r2.y;
  r3.z = 0;
  r1.yz = v1.xy + r3.zx;
  r3.xyz = t7.Sample(s0_s, r1.yz).xyz;
  r2.z = 0;
  r4.xyzw = v1.xyxy + r2.zyxz;
  r5.xyz = t7.Sample(s0_s, r4.xy).xyz;
  r2.w = -r2.x;
  r2.xy = v1.xy + r2.wz;
  r6.xyz = t7.Sample(s0_s, r2.xy).xyz;
  r7.xyz = t7.Sample(s0_s, r4.zw).xyz;
  r1.y = t9.Sample(s0_s, r1.yz).x;
  r1.z = t9.Sample(s0_s, r4.xy).x;
  r1.w = t9.Sample(s0_s, r2.xy).x;
  r2.x = t9.Sample(s0_s, r4.zw).x;
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r0.w = t9.Sample(s0_s, v1.xy).x;
  r2.y = cmp(0 < r0.w);
  if (r2.y != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r2.yzw = r5.xyz + r3.xyz;
  r2.yzw = r2.yzw + r6.xyz;
  r2.yzw = r2.yzw + r7.xyz;
  r2.yzw = float3(0.25,0.25,0.25) * r2.yzw;
  r3.x = max(r2.z, r2.w);
  r3.x = max(r3.x, r2.y);
  r3.x = cmp(r3.x == 0.000000);
  if (r3.x != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r1.y = max(r1.y, r1.z);
  r0.w = max(r1.y, r0.w);
  r1.y = max(r2.x, r1.w);
  r0.w = max(r1.y, r0.w);
  r1.y = cmp(0 < r0.w);
  r1.z = -4.99999987e-005 + r1.x;
  r0.w = cmp(r1.z < r0.w);
  r0.w = r0.w ? r1.y : 0;
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r0.w = cmp(r1.x >= 0.984375);
  r1.y = 1.01587307 * r1.x;
  r1.x = r1.x * 64 + -63;
  r0.w = r0.w ? r1.x : r1.y;
  r0.w = max(9.99999994e-009, r0.w);
  r0.w = rcp(r0.w);
  r0.w = cb8[1].x + -r0.w;
  r0.w = saturate(cb8[1].y * r0.w);
  r1.x = sin(cb1[69].w);
  r1.x = r1.x * 0.5 + 0.75;
  r1.xyz = r2.yzw * r1.xxx;
  r1.xyz = r1.xyz * r0.www;
  o0.xyz = r1.xyz * float3(32768,32768,32768) * r0.xyz;

  o0.xyz /= 32768;
  o0.xyz *= CUSTOM_XRAY_OUTLINE; 

  o0.w = 1;
  return;
}