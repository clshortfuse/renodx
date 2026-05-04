#include "../common.hlsli"
// ---- Created with 3Dmigoto v1.3.16 on Tue Apr 28 21:28:01 2026
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

  r0.xy = v5.xy + cb4[8].xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = asfloat(asuint(r0.xyzw) & asint(cb3[44].xyzw));
  r0.xyzw = asfloat(asuint(r0.xyzw) | asint(cb3[45].xyzw));
  r1.xy = v5.xy + cb4[9].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[10].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[11].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw)| asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[12].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[13].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[14].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[15].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[16].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[17].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[18].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[19].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[20].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[21].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[22].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = v5.xy + cb4[23].xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[44].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[45].xyzw));
  r0.xyzw = r1.xyzw + r0.xyzw;
  //o0.xyzw = saturate(float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw);
  o0.xyzw = float4(0.0625, 0.0625, 0.0625, 0.0625) * r0.xyzw;
  o0.rgb = max(o0.rgb, 0.f);
  o0.a = saturate(o0.a);
  return;
}
