// Hand-decompiled from DXBC.
//
// Brotherhood bloom focus mask:
// 1. Build projected UVs from screen-space v5 using cb4[136]/cb4[137].
// 2. Sample t0 with those UVs, bit-normalize with cb3[44]/cb3[45], and
//    compute an inverted average luminance term.
// 3. Raise that term to the power 1.2.
// 4. Sample t1 at screen UV v5, bit-normalize with cb3[46]/cb3[47], and
//    modulate the result by the alpha of that sample.
// 5. Output a grayscale focus intensity times 800, discarding when the
//    quantized alpha falls below cb3[8].z.

#include ".././common.hlsli"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

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
  float4 uvh = float4(v5.x, v5.y, 1.f, 1.2f);
  float2 sample_uv;
  sample_uv.x = dot(uvh, cb4[136]);
  sample_uv.y = dot(uvh, cb4[137]);

  float4 sample0 = BitNorm(t0.Sample(s0_s, sample_uv), cb3[44], cb3[45]);
  float luminance = saturate(dot(sample0.rgb, 0.333f.xxx));
  float focus_shape = pow(1.f - luminance, 1.2f);

  float4 sample1 = BitNorm(t1.Sample(s1_s, v5.xy), cb3[46], cb3[47]);
  float intensity = sample1.a * focus_shape;
  float4 color = (1.f - exp2(-800.f * intensity)).xxxx;

  uint alpha_q = (uint)(color.a * 255.f + 0.0001f);
  if (alpha_q < (uint)cb3[8].z) discard;

  o0 = color;
}
