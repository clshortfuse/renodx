#include "../shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Wed Apr 29 02:23:56 2026
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
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v5.xy * float2(1,-1) + float2(0,1);
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = asfloat(asuint(r0.xyzw) & asint(cb3[46].xyzw));
  r0.xyzw = asfloat(asuint(r0.xyzw) | asint(cb3[47].xyzw));
  r1.xyzw = float4(0.5,0.5,0.5,0.5) + r0.xyzw;
  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r0.xyzw = cb4[8].xxxx * r0.xyzw;
  r0.xyzw = r0.xyzw + r0.xyzw;
  r2.xyzw = frac(r1.xyzw);
  r1.xyzw = -r2.xyzw + r1.xyzw;
  r2.y = -1;
  r2.xyzw = cb4[9].xyzw + r2.yyyy;
  r2.xyzw = r1.xyzw * r2.xyzw + float4(1,1,1,1);
  r1.xyzw = float4(1,1,1,1) + -r1.xyzw;
  r3.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  r2.xyzw = r0.xyzw * r2.xyzw + r3.xyzw;
  r0.xyzw = abs(r0.xyzw);
  r0.xyzw = r1.xyzw * r0.xyzw;
  float strength = CUSTOM_WHITE_GRADIENT_STRENGTH;
  float4 overlay = r0.xyzw * cb4[10].xyzw;
  float4 composite = lerp(r3.xyzw, r2.xyzw, strength) + overlay * strength;
  o0.xyzw = max(composite, 0.f);
  return;
}
