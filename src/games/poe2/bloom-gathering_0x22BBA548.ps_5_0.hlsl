// ---- Created with 3Dmigoto v1.4.1 on Wed Dec  3 06:20:11 2025
// Downsample helper: accumulates several mips of t0 with exponential weights
// derived from cb0[0].w to build a filtered luminance estimate.
#include "shared.h"
Texture2D<float4> t0 : register(t0);

SamplerState s9_s : register(s9);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  const int kBloomMipCount = 6;
  float2 viewport_pixels = max(float2(asint(cb0[0].xy)), float2(1.0, 1.0));
  float2 texel_size = 1.0 / viewport_pixels;
  float2 base_uv = v0.xy * texel_size;
  float log_weight = log2(cb0[0].w);

  // Vanilla behavior
  float4 vanilla_sum = float4(0, 0, 0, 0);
  float vanilla_weight = 0;
  [unroll]
    for (int vanilla_mip = 0; vanilla_mip < kBloomMipCount; ++vanilla_mip) {
      float weight = exp2(log_weight * float(vanilla_mip));
      float4 sample = t0.SampleLevel(s9_s, base_uv, vanilla_mip);
    vanilla_sum += sample * weight;
    vanilla_weight += weight;
  }
  float4 vanilla_color = vanilla_sum / (1.00000001e-07 + vanilla_weight);

  // Alt gather: stochastic offsetting to reduce banding/blockiness.
  float4 enhanced_sum = float4(0, 0, 0, 0);
  float enhanced_weight = 0;
  float jitter_seed = frac(sin(dot(v0.xy, float2(12.9898005,78.2330017))) * 43758.5469);
  [unroll]
    for (int enhanced_mip = 0; enhanced_mip < kBloomMipCount; ++enhanced_mip) {
      float mip_f = float(enhanced_mip);
    float weight = exp2(mip_f * log_weight);
    float jitter_angle = jitter_seed + mip_f * 2.39996323;
    float jitter_radius = texel_size.x * (mip_f + 1.0) * 1.5;
    float2 jitter = float2(cos(jitter_angle), sin(jitter_angle)) * jitter_radius;
    float2 sample_uv = base_uv + jitter;
      float4 sample = t0.SampleLevel(s9_s, sample_uv, enhanced_mip);
    enhanced_sum += sample * weight;
    enhanced_weight += weight;
  }
  float4 enhanced_color = enhanced_sum / (1.00000001e-07 + enhanced_weight);

  float use_enhanced = step(0.5f, CUSTOM_BLOOM_MODE);
  float4 bloom_color = lerp(vanilla_color, enhanced_color, use_enhanced);
  bloom_color.xyz *= max(CUSTOM_BLOOM_STRENGTH, 0.0f);
  o0 = bloom_color;
  return;
}