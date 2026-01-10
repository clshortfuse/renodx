#include "./shared.h"

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

void main(
    float4 vpos: SV_Position,
    float2 texcoord: TEXCOORD,
    out float4 output: SV_Target0) {
  float4 color = sourceTexture.Sample(sourceSampler_s, texcoord.xy);
  color.a = saturate(color.a);

  if (RENODX_GAMMA_CORRECTION == 1.f) {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2f);
  } else if (RENODX_GAMMA_CORRECTION == 2.f) {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.4f);
  } else {
    color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  }
  color.rgb *= RENODX_GRAPHICS_WHITE_NITS / 80.f;

  output.rgba = color;
}
