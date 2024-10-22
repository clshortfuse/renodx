#include "./shared.h"

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

void main(
    float4 vpos: SV_Position,
    float2 texcoord: TEXCOORD,
    out float4 output: SV_Target0) {
  float4 color = sourceTexture.Sample(sourceSampler_s, texcoord.xy);

  if (injectedData.outputMode == 1) {
    // Linearize with 2.2 Gamma and scale paper white
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2);
    color.rgb *= injectedData.toneMapUINits / renodx::color::srgb::REFERENCE_WHITE;
  } else {
    color.rgb = max(0, color.rgb);
    color.rgb = renodx::color::srgb::Decode(color.rgb);
  }

  output.rgba = float4(color.rgb, color.a);
}
