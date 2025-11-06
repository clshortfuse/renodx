#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  // Used for OpenGL support
  uv.y = lerp(uv.y, 1.0 - uv.y, shader_injection.custom_flip_uv_y);

  return renodx::draw::SwapChainPass(t0.Sample(s0, uv));
}
