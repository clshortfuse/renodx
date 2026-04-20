#include "./common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
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
  float2 flipped_uv = v5.xy * float2(1.f, -1.f) + float2(0.f, 1.f);

  float4 overlay_sample = t1.Sample(s1_s, flipped_uv);
  uint4 overlay_bits = asuint(overlay_sample);
  overlay_bits = (overlay_bits & asuint(cb3[46])) | asuint(cb3[47]);
  overlay_sample = asfloat(overlay_bits);

  float4 r1 = overlay_sample + 0.5f;
  float4 r0 = (overlay_sample - 0.5f) * cb4[8].xxxx;
  r0 += r0;

  float4 frac_part = frac(r1);
  r1 -= frac_part;

  float4 ramp = r1 * (cb4[9] - 1.f) + 1.f;
  float4 inv_r1 = 1.f - r1;

  float4 base_sample = t0.Sample(s0_s, v5.xy);
  uint4 base_bits = asuint(base_sample);
  base_bits = (base_bits & asuint(cb3[44])) | asuint(cb3[45]);
  base_sample = asfloat(base_bits);

  float4 combined = r0 * ramp + base_sample;
  float4 additive_term = abs(r0) * inv_r1;
  float gradient_strength = CUSTOM_BLOOM;
  combined = lerp(base_sample, combined, gradient_strength);
  additive_term *= gradient_strength;

  o0 = additive_term * cb4[10] + combined;
}
