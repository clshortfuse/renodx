#include "./shared.h"

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

void main(
    float4 vpos: SV_Position,
    float2 texcoord: TEXCOORD,
    out float4 output: SV_Target0) {
  float4 color = sourceTexture.Sample(sourceSampler_s, texcoord.xy);

  if (injectedData.toneMapGammaCorrection) {
    color.rgb = renodx::color::correct::GammaSafe(color.rgb);
  }
  color.rgb *= injectedData.toneMapUINits / 80.f;

  output.rgba = color;
}
