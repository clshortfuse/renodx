#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Mar 22 17:32:27 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = v1.xx;
  r1.x = cb0[3].x * cb0[2].y;
  r2.xyzw = r1.xxxx * float4(-4,3,-3,-2) + v1.yyyy;
  r0.yw = r2.xz;
  r0.xyzw = r0.xyzw / v1.wwww;
  r3.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r3.xyzw = float4(0.0900000036,0.0900000036,0.0900000036,0.0900000036) * r3.xyzw;
  r0.xyzw = r0.xyzw * float4(0.0500000007,0.0500000007,0.0500000007,0.0500000007) + r3.xyzw;
  r3.y = r2.w;
  r3.xz = v1.xx;
  r1.yz = r3.xy / v1.ww;
  r4.xyzw = t0.Sample(s0_s, r1.yz).xyzw;
  r0.xyzw = r4.xyzw * float4(0.119999997,0.119999997,0.119999997,0.119999997) + r0.xyzw;
  r3.w = -cb0[2].y * cb0[3].x + v1.y;
  r1.yz = r3.zw / v1.ww;
  r3.xyzw = t0.Sample(s0_s, r1.yz).xyzw;
  r0.xyzw = r3.xyzw * float4(0.150000006,0.150000006,0.150000006,0.150000006) + r0.xyzw;
  r1.yz = v1.xy / v1.ww;
  r3.xyzw = t0.Sample(s0_s, r1.yz).xyzw;
  r0.xyzw = r3.xyzw * float4(0.180000007,0.180000007,0.180000007,0.180000007) + r0.xyzw;
  r3.y = cb0[2].y * cb0[3].x + v1.y;
  r3.xz = v1.xx;
  r1.yz = r3.xy / v1.ww;
  r4.xyzw = t0.Sample(s0_s, r1.yz).xyzw;
  r0.xyzw = r4.xyzw * float4(0.150000006,0.150000006,0.150000006,0.150000006) + r0.xyzw;
  r3.w = r1.x * 2 + v1.y;
  r2.w = r1.x * 4 + v1.y;
  r1.xy = r3.zw / v1.ww;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.119999997,0.119999997,0.119999997,0.119999997) + r0.xyzw;
  r2.xz = v1.xx;
  r1.xyzw = r2.xyzw / v1.wwww;
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0900000036,0.0900000036,0.0900000036,0.0900000036) + r0.xyzw;
  o0.xyzw = r2.xyzw * float4(0.0500000007,0.0500000007,0.0500000007,0.0500000007) + r0.xyzw;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}