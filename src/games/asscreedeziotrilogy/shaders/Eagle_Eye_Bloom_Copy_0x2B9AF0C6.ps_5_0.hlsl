// Hand-decompiled from DXBC.
//
// This shader builds a monochrome eagle-eye bloom / flare mask:
// 1. Measure distance from world position v6 to anchor cb4[20].
// 2. Normalize by 12, saturate, then raise to the 6th power.
// 3. Normalize view/light vectors v9/v10 and derive a two-lobe response
//    from abs(dot(view, light)) using exponents 0.12 and 0.7.
// 4. Shape that response with cb4[136].x and cb4[137].x.
// 5. Sample t0 using the affine UV transform in cb4[136..137], bit-normalize
//    the sample with cb3[44]/cb3[45], then derive an alpha gate from sample.a.
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
  // Distance falloff from the focus anchor.
  float distance01 = SafeLength(cb4[20].xyz - v6.xyz) * (1.f / 12.f);
  float distance_shape = distance01 * distance01;
  distance_shape *= distance_shape;   // ^4
  distance_shape *= distance_shape;   // ^6 total because current value is ^4 * ^2

  // View/light angular response.
  float3 view_dir = SafeNormalize(v9.xyz);
  float3 light_dir = SafeNormalize(v10.xyz);
  float view_light = dot(view_dir, light_dir);

  float pow_lo = pow(abs(view_light), 0.12f);
  float pow_hi = pow(abs(view_light), 0.7f);
  float response = pow_hi - pow_lo;
  response *= distance_shape;
  response = cb4[136].x * response + pow_lo;
  response = (1.f - response) * cb4[137].x;

  // Affine UV transform using homogeneous (u, v, 1).
  float3 uvh = float3(v5.xy, 1.f);
  float2 sample_uv;
  sample_uv.x = dot(uvh, cb4[136].xyz);
  sample_uv.y = dot(uvh, cb4[137].xyz);

  float4 sample0 = BitNorm(t0.Sample(s0_s, sample_uv), cb3[44], cb3[45]);

  // The shader uses a steep power on sample alpha times vertex alpha,
  // but bypasses it entirely when sample alpha is <= 0.1.
  float alpha_mul = sample0.a * v2.a;
  float alpha_shape = pow(abs(alpha_mul), 5.f);
  float alpha_gate = (sample0.a <= 0.1f) ? 1.f : alpha_shape;

  float intensity = response * alpha_gate;
  float4 color = intensity.xxxx * 12.f;

  uint alpha_q = (uint)(color.a * 255.f + 0.0001f);
  if (alpha_q < (uint)cb3[8].z) discard;

  o0 = 1.f - exp2(-max(color, 0.f));
}
