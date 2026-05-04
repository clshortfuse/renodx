Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

float4 BitNorm(float4 value, uint4 bit_and, uint4 bit_or) {
  return asfloat((asuint(value) & bit_and) | bit_or);
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    linear centroid float4 v2 : COLOR0,
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
  float4 sample0 = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);
  float4 result = mad(sample0 * v2, cb4[136], cb4[137]);

  // Preserve the authored scale/bias behavior, but don't let FP16 carry
  // negative bloom/copy energy forward into later blur/accumulation passes.
  o0.rgb = max(result.rgb, 0.f);
  o0.a = saturate(result.a);
}
