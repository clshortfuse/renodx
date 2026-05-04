#include ".././common.hlsli"

cbuffer cb3 : register(b3) {
  uint4 cb3[77];
}

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

SamplerState s0_s : register(s0);

Texture2D<float4> t0 : register(t0);

float SafeRcp(float x) {
  return abs(x) > 0.f ? rcp(x) : 1e34f;
}

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
  float3 uvh0 = float3(v5.xy, 1.f);

  float2 uv0;
  uv0.x = dot(uvh0, cb4[136].xyz);
  uv0.y = dot(uvh0, cb4[137].xyz);
  float sample0 = asfloat((asuint(t0.Sample(s0_s, uv0).y) & cb3[44].y) | cb3[45].y);

  float2 uv1;
  uv1.x = dot(uvh0, cb4[139].xyz);
  uv1.y = dot(uvh0, cb4[140].xyz);
  float sample1 = asfloat((asuint(t0.Sample(s0_s, uv1).y) & cb3[44].y) | cb3[45].y);

  float base = max(sample0, sample1) * 2.f;

  float3 phase_xyz = frac(v6.xyz * 0.047746f + 0.5f.xxx);
  phase_xyz = phase_xyz * 6.283185f - 3.141593f;
  float phase_sum = sin(phase_xyz.x) + sin(phase_xyz.y) + sin(phase_xyz.z);

  float inv_dist2 = SafeRcp(dot(v6.xyz, v6.xyz));
  float wave = mad(phase_sum, 3.f, inv_dist2);
  wave = mad(cb4[142].x, 0.900001f, wave);
  wave = frac(mad(wave, 0.159155f, 0.5f));
  wave = mad(wave, 6.283185f, -3.141593f);

  float gate = sin(wave) + 1.f;
  gate = min(gate, 1.f);
  float pulse = 1.f - gate;
  float log_pulse = pulse > 0.f ? log(pulse) : -1e34f;

  float gain_lo = exp(log_pulse * 4.1f);
  float gain_hi = exp(log_pulse * 12.f);
  gain_hi *= 0.3f;

  float intensity = mad(base, gain_lo, gain_hi);
  intensity = mad(gate, 0.4f, intensity);

  float4 color = intensity.xxxx * 0.5f;

  uint alpha_q = (uint)(color.a * 255.f + 0.0001f);
  if (alpha_q < (uint)cb3[8].z) discard;

  o0 = color;
  o0.rgb = saturate(o0.rgb);
  o0.a = saturate(o0.a);
}
