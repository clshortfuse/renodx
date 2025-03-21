#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Mar 21 00:58:55 2025
Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[2];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[7];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[47];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




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
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s2_s, v1.xy).xyzw;
  r1.x = r1.x + -r0.w;
  r0.w = cb3[1].z * r1.x + r0.w;
  r0.xyzw = v4.xyzw * r0.xyzw;
  r0.xyz = r0.xyz * r0.www;
  r1.x = cmp(cb2[0].x == 1.000000);
  if (r1.x != 0) {
    r1.x = cmp(cb2[0].y == 1.000000);
    r1.yzw = cb2[2].xyz * v3.yyy;
    r1.yzw = cb2[1].xyz * v3.xxx + r1.yzw;
    r1.yzw = cb2[3].xyz * v3.zzz + r1.yzw;
    r1.yzw = cb2[4].xyz + r1.yzw;
    r1.xyz = r1.xxx ? r1.yzw : v3.xyz;
    r1.xyz = -cb2[6].xyz + r1.xyz;
    r1.yzw = cb2[5].xyz * r1.xyz;
    r1.y = r1.y * 0.25 + 0.75;
    r2.x = cb2[0].z * 0.5 + 0.75;
    r1.x = max(r2.x, r1.y);
    r1.xyzw = t2.Sample(s0_s, r1.xzw).xyzw;
  } else {
    r1.xyzw = float4(1,1,1,1);
  }
  r1.x = saturate(dot(r1.xyzw, cb1[46].xyzw));
  r1.xyz = cb0[2].xyz * r1.xxx;
  r1.w = dot(v2.xyz, cb1[0].xyz);
  r1.w = max(0, r1.w);
  r1.xyz = r1.xyz * r0.xyz;
  r0.xyz = v5.xyz * r0.xyz;
  o0.xyz = r1.xyz * r1.www + r0.xyz;
  o0.w = r0.w;

  if (RENODX_TONE_MAP_TYPE == 0) {
    o0 = saturate(o0);
  } else {
    o0 = max(0, o0);
  }
  return;
}