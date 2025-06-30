#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 29 15:53:29 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[8];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[7].xy + cb0[7].zw;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = -cb0[2].xyz + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.x = dot(r0.xyz, float3(1,1,1));
  r0.yz = cb0[5].xy + -w1.xy;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);

  r0.y = saturate(cb0[5].w + -r0.y);

  r0.x = r0.x * r0.y;
  r0.yz = w1.xy * cb0[10].xy + cb0[10].zw;
  r1.xyzw = t0.Sample(s1_s, r0.yz).xyzw;
  r0.y = cb1[7].x * r1.x + cb1[7].y;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.y = 1 / r0.y;
    r0.y = cmp(0.99000001 < r0.y);
  } else {
    r0.y = 100 / r0.y;               // removing unclamps comparison range
    r0.y = cmp(99.99000001 < r0.y); //raising to 1 un-blasts the screen with light
  }


  o0.xyzw = r0.yyyy ? r0.xxxx : 0;
  return;
}