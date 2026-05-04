// Hand-decompiled from DXBC.
//
// This is a dual-output eagle-eye bloom / flare pass.
// RT0 carries the flare color. RT1 carries auxiliary data derived from
// v6.zw and the final flare intensity.

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
    out float4 o0 : SV_TARGET0,
    out float4 o1 : SV_TARGET1) {
  if (any(v7.w < 0.f)) discard;

  // Distance falloff from world position to anchor.
  float distance01 = saturate(SafeLength(cb4[20].xyz - v7.xyz) * (1.f / 12.f));
  float distance_shape = distance01 * distance01;
  distance_shape *= distance_shape;
  distance_shape *= distance01;

  float3 light_dir = SafeNormalize(v10.xyz);

  float v11_len = SafeLength(v11.xyz);
  float3 v11_scaled = v11.xyz * v11_len;
  float range_mask = saturate((v11_len - cb4[25].x) * cb4[25].y) * cb4[25].z;

  float view_light = dot(v11_scaled, light_dir);
  float pow_lo = pow(abs(view_light), 0.12f);
  float pow_hi = pow(abs(view_light), 0.7f);
  float response = pow_hi - pow_lo;
  response *= distance_shape;
  response = saturate(cb4[136].x * response + pow_lo);
  response = (1.f - response) * cb4[137].x;

  float3 flare_tint = response * cb4[138].xyz;
  float3 flare_base = cb4[24].xyz + cb4[138].xyz * (-response);
  float4 flare_color = float4(mad(range_mask, flare_base, flare_tint), response);

  float inv_v6_w = (abs(v6.w) > 0.f) ? rcp(v6.w) : 0.f;
  o1.xyz = inv_v6_w * v6.z;

  float4 sample0 = BitNorm(t0.Sample(s0_s, v5.xy), cb3[44], cb3[45]);
  float alpha_mul = sample0.a * v2.a;
  float alpha_shape = pow(abs(alpha_mul), 5.f);
  float alpha_floor = sample0.a - 0.1f;
  float alpha_frac = saturate(frac(-alpha_floor) + alpha_floor);
  float alpha_gate = (alpha_floor <= 0.f) ? 1.f : alpha_shape;

  float intensity = alpha_gate * response;

  flare_color.a = intensity;
  o1.a = intensity;

  uint alpha_q = (uint)(flare_color.a * 255.f + 0.0001f);
  if (alpha_q < (uint)cb3[8].z) discard;

  o0 = 1.f - exp2(-max(flare_color, 0.f));
}
