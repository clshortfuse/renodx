#include ".././common.hlsli"

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

float SafeRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 0.f;
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
  float3 delta = cb4[20].xyz - v6.xyz;
  float dist = sqrt(dot(delta, delta));
  float dist01 = saturate((dist - cb4[146].x) * SafeRcp(cb4[147].x - cb4[146].x));

  float4 shifted = float4(v6.xyz, 1.f) - float4(cb4[20].xyz, 0.f);
  shifted.y += 0.33f;
  float shifted_inv_dist = rsqrt(dot(shifted, shifted));
  float3 shifted_dir = shifted.xyz * shifted_inv_dist;

  float3 view_dir = normalize(v9.xyz);
  float facing = dot(view_dir, shifted_dir);

  float focus = exp(log(max(abs(facing), 1e-4f)) * cb4[148].x);
  focus = cb4[149].x * (focus - 1.f) + 1.f;
  float focus_sat = saturate(focus);
  float focus_mix = max(lerp(focus, 1.f - focus, cb4[150].x), 0.f);

  float3 uvw0 = float3(v5.x + 1.f, v5.x, 1.f);

  float2 uv0;
  uv0.x = dot(uvw0, cb4[136].xyz);
  uv0.y = dot(uvw0, cb4[137].xyz);
  float4 sample0 = BitNorm(t0.Sample(s0_s, uv0), cb3[44], cb3[45]);

  float2 uv1;
  uv1.x = dot(uvw0, cb4[139].xyz);
  uv1.y = dot(uvw0, cb4[140].xyz);
  float4 sample1 = BitNorm(t1.Sample(s1_s, uv1), cb3[46], cb3[47]);

  float mixed_alpha = lerp(sample0.w, sample1.w, cb4[142].x);
  float sample1_luma = dot(sample1.rgb, float3(0.33f, 0.33f, 0.33f));
  float flare = lerp(mixed_alpha, sample1_luma, cb4[143].x);

  float intensity = max(flare * cb4[151].x, 0.f);
  intensity *= focus_mix;
  intensity *= max(cb4[152].x * (v2.w - 1.f) + 1.f, 0.f);
  intensity *= dist01;

  float fade_out = 1.f - flare;
  float fade_in = saturate(flare - cb4[145].x);
  float fade_gate = min(fade_in, saturate(fade_out - (focus_sat - cb4[144].x)));
  intensity *= fade_gate;

  float gain = max(cb4[151].x * cb4[153].x * focus_mix, 0.f);
  float bloom = max(intensity * gain, 0.f);
  bloom = 1.f - exp2(-bloom);
  o0 = bloom.xxxx;
}
