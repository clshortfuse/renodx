// Hand-decompiled from DXBC.
//
// Brotherhood eagle-eye bloom mask:
// 1. Measure distance from world position v6 to anchor cb4[20].
// 2. Normalize by 12, saturate, then raise to the 6th power.
// 3. Normalize view direction v9 and compare it against cb4[23].xyz.
// 4. Build a two-lobe response from abs(dot(view, cb4[23])) using powers
//    0.12 and 0.7, then shape it with cb4[136].x and cb4[137].x.
// 5. Sample t0 at screen UV v5, bit-normalize with cb3[44]/cb3[45], and
//    gate the result from sample alpha times vertex alpha.
// 6. Output a grayscale intensity times 12 to all channels and discard when
//    quantized alpha falls below cb3[8].z.

#include ".././common.hlsli"

Texture2D<float4> t0 : register(t0);
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

float SafeLength(float3 v) {
  float d = dot(v, v);
  return (d > 0.f) ? sqrt(d) : 0.f;
}

float3 SafeNormalize(float3 v) {
  float d = dot(v, v);
  return (d > 0.f) ? v * rsqrt(d) : 0.f;
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
  float distance01 = saturate(SafeLength(cb4[20].xyz - v6.xyz) * (1.f / 12.f));
  float distance_shape = distance01 * distance01;
  distance_shape *= distance_shape;
  distance_shape *= distance01 * distance01;

  float3 view_dir = SafeNormalize(v9.xyz);
  float view_light = dot(cb4[23].xyz, view_dir);

  float pow_lo = pow(abs(view_light), 0.12f);
  float pow_hi = pow(abs(view_light), 0.7f);
  float response = pow_hi - pow_lo;
  response *= distance_shape;
  response = saturate(cb4[136].x * response + pow_lo);
  response = (1.f - response) * cb4[137].x;

  float4 sample0 = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);

  float alpha_mul = sample0.a * v2.a;
  float alpha_shape = pow(abs(alpha_mul), 5.f);
  float alpha_gate = (sample0.a <= 0.1f) ? 1.f : alpha_shape;

  float intensity = response * alpha_gate;
  float4 color = intensity.xxxx * 12.f;

  uint alpha_q = (uint)(color.a * 255.f + 0.0001f);
  if (alpha_q < (uint)cb3[8].z) discard;

  o0 = 1.f - exp2(-max(color, 0.f));
}
