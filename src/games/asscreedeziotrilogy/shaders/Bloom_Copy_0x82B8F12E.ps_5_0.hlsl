#include ".././common.hlsli"

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

SamplerState s0_s : register(s0);

Texture2D<float4> t0 : register(t0);

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

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
    out float4 o0 : SV_TARGET0) {
  float4 sum = BitNorm(t0.Sample(s0_s, v5.xy + cb4[8].xy), cb3[44], cb3[45]);
  sum += BitNorm(t0.Sample(s0_s, v5.xy + cb4[9].xy), cb3[44], cb3[45]);
  sum += BitNorm(t0.Sample(s0_s, v5.xy + cb4[10].xy), cb3[44], cb3[45]);
  sum += BitNorm(t0.Sample(s0_s, v5.xy + cb4[11].xy), cb3[44], cb3[45]);
  sum *= 0.25f;

  o0.rgb = max(sum.rgb, 0.f);
  o0.a = saturate(sum.a);
}
