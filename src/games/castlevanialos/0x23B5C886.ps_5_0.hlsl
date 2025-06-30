// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 09:35:48 2025
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = -0.874390364;
  r0.x = cb4[8].x * r0.y;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r1.xyzw = t0.Sample(s0_s, float2(0.5,0.5)).xyzw;
  ////r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
  ////r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r2.xyzw = t1.Sample(s1_s, float2(0.5,0.5)).xyzw;
  ////r2.xyzw = (int4)r2.xyzw & asint(cb3[46].xyzw);
  ////r2.xyzw = (int4)r2.xyzw | asint(cb3[47].xyzw);
  r4.x = -r1.x + r2.x;
  r3.x = r0.x * r4.x + r1.x;
  r0.x = max(cb4[9].x, r3.x);
  o0.xyzw = min(r0.xxxx, cb4[9].yyyy);
  return;
}