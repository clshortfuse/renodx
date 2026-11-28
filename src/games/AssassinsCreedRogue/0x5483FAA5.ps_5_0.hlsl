#include "./finite.hlsli"

Texture2D<float4> sprite : register(t0);
Texture2D<float> depth : register(t8);
SamplerState sprite_sampler : register(s0);
SamplerState depth_sampler : register(s8);

cbuffer ParticleConstants : register(b0) {
  float4 position_to_uv : packoffset(c19);
  float4 reverse_projection : packoffset(c20);
  float4 depth_fade : packoffset(c129);
  float4 blend_start : packoffset(c130);
  float4 blend_mask : packoffset(c131);
  float fade : packoffset(c132);
  float msaa_uv_offset : packoffset(c133);
}

float4 main(float4 position : SV_Position0, float4 texcoord : TEXCOORD0, float4 tint : TEXCOORD1) : SV_Target0 {
  float4 texel = sprite.Sample(sprite_sampler, texcoord.xy);
  clip(texel.a - texcoord.z);
  float2 uv = position.xy * position_to_uv.xy + position_to_uv.zw;
  uv += uv * msaa_uv_offset;
  float depth_denominator = RogueFinite(depth.SampleLevel(depth_sampler, uv, 0.f)) + RogueFinite(reverse_projection.z);
  float scene_depth = RogueFinite(reverse_projection.w) / RogueSafeDenominator(depth_denominator);
  float depth_weight = saturate((-scene_depth - RogueFinite(texcoord.w)) * RogueFinite(depth_fade.z));
  float4 weight = saturate(depth_weight * RogueFinite(fade) + RogueFinite(blend_mask));
  float4 result = lerp(blend_start, texel * tint, weight);
  if (!RogueIsFinite(result)) discard;
  return clamp(result, -ROGUE_FP16_MAX, ROGUE_FP16_MAX);
}
