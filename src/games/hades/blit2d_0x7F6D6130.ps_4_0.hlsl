#include "./shared.h"

SamplerState Sampler_s : register(s0);
Texture2D<float4> Texture : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: SV_POSITION0, float4 v1: COLOR0, float2 v2: TEXCOORD0, out float4 o0: SV_TARGET0) {
  o0.xyzw = Texture.Sample(Sampler_s, v2.xy).xyzw;
  // if (shader_injection.custom_is_swap_chain_render == 0.f) return;
  o0.rgb = renodx::draw::SwapChainPass(o0.rgb, v2);
}
