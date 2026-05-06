// ---- Created with 3Dmigoto v1.3.16 on Mon May 04 22:26:32 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  uiDest.xyzw = asuint(r0.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r0.xyzw = asfloat(uiDest.xyzw);
  r1.xyzw = t1.Sample(s1_s, v5.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[46].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[47].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  o0.xyzw = max(r1.xyzw + r0.xyzw, 0.f);
  return;
}
