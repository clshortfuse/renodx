#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

// Lightweight proxy that lets ReShade/3Dmigoto hook Rome 2's swap chain while
// still running the shared renodx presentation helpers.
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  return renodx::draw::SwapChainPass(t0.Sample(s0, uv));
}
