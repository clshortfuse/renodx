#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 25 22:39:13 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  float4 v9 : TEXCOORD8,
  float4 v10 : TEXCOORD9,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v7.wy).xyzw;
  r0.xyzw = float4(0.0840036124,0.0840036124,0.0840036124,0.0840036124) * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v7.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.133958012,0.133958012,0.133958012,0.133958012) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v7.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0526777469,0.0526777469,0.0526777469,0.0526777469) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v6.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0330336392,0.0330336392,0.0330336392,0.0330336392) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v6.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0207150355,0.0207150355,0.0207150355,0.0207150355) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v6.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.012990172,0.012990172,0.012990172,0.012990172) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v8.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00814599544,0.00814599544,0.00814599544,0.00814599544) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v8.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00510826474,0.00510826474,0.00510826474,0.00510826474) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v8.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00320333708,0.00320333708,0.00320333708,0.00320333708) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v10.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00200877781,0.00200877781,0.00200877781,0.00200877781) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v10.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00125968258,0.00125968258,0.00125968258,0.00125968258) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v10.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.000789933198,0.000789933198,0.000789933198,0.000789933198) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v9.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.000495358487,0.000495358487,0.000495358487,0.000495358487) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v9.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.000310633885,0.000310633885,0.000310633885,0.000310633885) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v9.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.000194795124,0.000194795124,0.000194795124,0.000194795124) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.133958012,0.133958012,0.133958012,0.133958012) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0840036124,0.0840036124,0.0840036124,0.0840036124) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0526777469,0.0526777469,0.0526777469,0.0526777469) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0330336392,0.0330336392,0.0330336392,0.0330336392) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.0207150355,0.0207150355,0.0207150355,0.0207150355) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.012990172,0.012990172,0.012990172,0.012990172) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v3.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00814599544,0.00814599544,0.00814599544,0.00814599544) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v3.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00510826474,0.00510826474,0.00510826474,0.00510826474) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v3.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00320333708,0.00320333708,0.00320333708,0.00320333708) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v5.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00200877781,0.00200877781,0.00200877781,0.00200877781) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v5.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.00125968258,0.00125968258,0.00125968258,0.00125968258) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v5.wz).xyzw;
  r0.xyzw = r1.xyzw * float4(0.000789933198,0.000789933198,0.000789933198,0.000789933198) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v4.wx).xyzw;
  r0.xyzw = r1.xyzw * float4(0.000495358487,0.000495358487,0.000495358487,0.000495358487) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v4.wy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.000310633885,0.000310633885,0.000310633885,0.000310633885) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v4.wz).xyzw;
  o0.xyzw = r1.xyzw * float4(0.000194795124,0.000194795124,0.000194795124,0.000194795124) + r0.xyzw * injectedData.fxBloom;
  return;
}