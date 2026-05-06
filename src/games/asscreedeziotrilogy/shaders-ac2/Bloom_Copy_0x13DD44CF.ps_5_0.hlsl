// ---- Created with 3Dmigoto v1.3.16 on Mon May 04 22:26:32 2026
Texture2D<float4> t0 : register(t0);

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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v5.xy + cb4[9].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  uiDest.xyzw = asuint(r0.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r0.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[22].xyzw * r0.xyzw;
  r1.xy = v5.xy + cb4[8].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[21].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[10].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[23].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[11].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[24].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[12].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[25].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[13].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[26].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[14].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[27].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[15].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[28].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[16].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[29].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[17].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[30].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[18].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[31].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[19].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  r0.xyzw = cb4[32].xyzw * r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[20].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  uiDest.xyzw = asuint(r1.xyzw);
  uiDest.xyzw = uiDest.xyzw & asuint(cb3[44].xyzw);
  uiDest.xyzw = uiDest.xyzw | asuint(cb3[45].xyzw);
  r1.xyzw = asfloat(uiDest.xyzw);
  o0.xyzw = max(cb4[33].xyzw * r1.xyzw + r0.xyzw, 0.f);
  return;
}
