#include ".././common.hlsli"

// Hand-decompiled from DXBC.
//
// Eagle-eye grading composite:
// 1. Sample the tertiary and secondary eagle-eye layers (t2/t1), bit-normalize
//    them with cb3[48..49] and cb3[46..47], and remap each from [0,1] to [-1,1].
// 2. Scale those signed layers by cb4[9].x and cb4[8].x respectively.
// 3. Sample the base scene grade texture t0 with cb3[44..45] normalization.
// 4. Add the signed grading contribution back onto the base color and clamp
//    negative underflow.

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

float4 BitNorm(float4 c, float4 mask, float4 set) {
  return asfloat((asuint(c) & asuint(mask)) | asuint(set));
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
  float4 layer2 = BitNorm(t2.Sample(s2_s, v5.xy), cb3[48], cb3[49]);
  layer2.rgb = layer2.rgb * 2.f - 1.f;
  layer2.rgb *= cb4[9].x;

  float4 layer1 = BitNorm(t1.Sample(s1_s, v5.xy), cb3[46], cb3[47]);
  layer1.rgb = layer1.rgb * 2.f - 1.f;
  layer2.rgb += layer1.rgb * cb4[8].x;

  float4 base = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);

  o0.rgb = max(0.f, base.rgb + layer2.rgb);
  //o0.rgb = base.rgb + layer2.rgb;
  o0.a = 1.f;
}
