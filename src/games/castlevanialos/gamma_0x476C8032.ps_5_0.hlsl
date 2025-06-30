#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 08:46:33 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[236];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[77];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v6.xy).xyzw;
  ////r0.xyzw = (int4)r0.xyzw & asint(cb3[44].xyzw);
  ////r0.xyzw = (int4)r0.xyzw | asint(cb3[45].xyzw);

  float3 untonemapped = r0.rgb;

  r0.xyzw = cb4[8].wwww * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  ////r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
  ////r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r0.xyzw = r1.xyzw * cb4[8].zzzz + -r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v6.zw).xyzw;
  //r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
  //r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r0.xyzw = r1.xyzw * -cb4[8].wwww + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v7.xy).xyzw;
  //r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
  //r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r0.xyzw = r1.xyzw * -cb4[8].wwww + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v7.zw).xyzw;
  //r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
  //r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r0.xyzw = r1.zxyw * -cb4[8].wwww + r0.zxyw;
  r1.xz = r0.yz;
  r1.yw = cb4[9].xx;
  r2.xyzw = t1.Sample(s1_s, r1.xy).xyzw;

  //r2.xyzw = (int4)r2.xyzw & asint(cb3[46].xyzw);
  //r2.xyzw = (int4)r2.xyzw | asint(cb3[47].xyzw);
  r1.xyzw = t1.Sample(s1_s, r1.zw).xyzw;

  //r1.xyzw = (int4)r1.xyzw & asint(cb3[46].xyzw);
  //r1.xyzw = (int4)r1.xyzw | asint(cb3[47].xyzw);
  o0.y = r1.y;
  o0.x = r2.x;
  o0.w = r0.w;
  r0.y = cb4[9].x;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  //r0.xyzw = (int4)r0.xyzw & asint(cb3[46].xyzw);
  //r0.xyzw = (int4)r0.xyzw | asint(cb3[47].xyzw);
  o0.z = r0.z;

  o0.rgb = untonemapped;
  if (RENODX_TONE_MAP_TYPE == 0)
  {
    o0.rgb = saturate(untonemapped);
  }
  return;
}