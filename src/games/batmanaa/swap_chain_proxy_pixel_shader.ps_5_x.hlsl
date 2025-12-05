#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 color = t0.Sample(s0, uv);
  color.rgb = renodx::color::gamma::DecodeSafe(color.rgb);
  color.rgb *= RENODX_GRAPHICS_WHITE_NITS / 80.f;
  return color;
}
