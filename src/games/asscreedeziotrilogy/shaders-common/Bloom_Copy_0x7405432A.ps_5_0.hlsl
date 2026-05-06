#include ".././common.hlsli"

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);
SamplerState s4_s : register(s4);

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);

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
  float4 sum = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);
  sum += BitNorm(t1.Sample(s1_s, v5.xy), cb3[46], cb3[47]);
  sum += BitNorm(t2.Sample(s2_s, v5.xy), cb3[48], cb3[49]);
  sum += BitNorm(t3.Sample(s3_s, v5.xy), cb3[50], cb3[51]);
  sum += BitNorm(t4.Sample(s4_s, v5.xy), cb3[52], cb3[53]);

  float4 compressed = 1.f - exp2(-max(sum, 0.f));
  o0 = compressed;
}