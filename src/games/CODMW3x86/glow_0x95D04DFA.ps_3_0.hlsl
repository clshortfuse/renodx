// MW3 glow apply: s0, c3.w and sampled alpha, verified against original bytecode.
// Pair with bloom_blend.hpp: SDR screen blending is unsafe on HDR targets.
#include "bloom_hdr.hlsl"
sampler2D colorMapSampler : register(s0);
float4 glowApply : register(c3);
float4 bloomControls : register(c59); // ShaderInjectData: bloom_brightness in y.
float4 main(float2 uv : TEXCOORD0) : COLOR0 {
  float4 sampled = tex2D(colorMapSampler, uv);
  float3 glow = MW3Positive(sampled.rgb) * MW3Positive(glowApply.w);
  glow = MW3Positive(glow * MW3Positive(bloomControls.y));
  // Unlike WaW, MW3 explicitly forwards texture alpha in this shader.
  return float4(glow, MW3Coverage(sampled.a));
}
