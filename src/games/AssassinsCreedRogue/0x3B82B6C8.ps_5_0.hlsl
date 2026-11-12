#include "./finite.hlsli"

Texture2D<float4> sprite : register(t0);
SamplerState sprite_sampler : register(s0);

cbuffer ParticleConstants : register(b0) {
  float fade : packoffset(c132);
}

float4 main(float4 position : SV_Position0, float3 texcoord : TEXCOORD0, float4 tint : TEXCOORD1) : SV_Target0 {
  float2 texel = sprite.Sample(sprite_sampler, texcoord.xy).xy;
  clip(texel.y - texcoord.z);
  float4 color = texel.xxxy * tint;
  color.a *= fade;
  if (!RogueIsFinite(color)) discard;
  return clamp(color, -ROGUE_FP16_MAX, ROGUE_FP16_MAX);
}
