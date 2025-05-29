#include "./shared.h"

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

void main(
    float4 vpos: SV_Position,
    float2 texcoord: TEXCOORD,
    out float4 output: SV_Target0) {
  float4 color = sourceTexture.Sample(sourceSampler_s, texcoord.xy);
  color.a = saturate(color.a);

  if (RENODX_GAMMA_CORRECTION) {
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
  }
  color.rgb *= RENODX_GRAPHICS_WHITE_NITS / 80.f;

  output.rgba = color;
}
