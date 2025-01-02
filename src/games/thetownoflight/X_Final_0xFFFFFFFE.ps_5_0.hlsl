#include "./shared.h"

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

void main(
    float4 vpos: SV_Position,
    float2 texcoord: TEXCOORD,
    out float4 output: SV_Target0) {
  float4 color = sourceTexture.Sample(sourceSampler_s, texcoord.xy);

  if (injectedData.toneMapType == 0) {
    color.rgb = min(1, color.rgb);  // in some cases the image is not clamped by previous shaders
  }

  if (injectedData.outputMode == 1) {
    // Linearize with 2.2 Gamma and scale paper white for HDR
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2);
    color.rgb *= injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;
  } else {
    // scRGB HDR can also be used in SDR in Windows, but it's interpreted with sRGB transfer function,
    // so we apply the sRGB transfer function and let the display apply the sRGB<->2.2 gamma mismatch
    color.rgb = max(0, color.rgb);
    color.rgb = renodx::color::srgb::Decode(color.rgb);
  }

  output.rgba = float4(color.rgb, saturate(color.a));
}
