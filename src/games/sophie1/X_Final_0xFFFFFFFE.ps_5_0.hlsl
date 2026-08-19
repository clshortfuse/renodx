#include "./shared.h"

SamplerState sourceSampler_s : register(s0);
Texture2D<float4> sourceTexture : register(t0);

void main(
    float4 vpos: SV_Position,
    float2 texcoord: TEXCOORD,
    out float4 output: SV_Target0) {
  float4 color = sourceTexture.Sample(sourceSampler_s, texcoord.xy);

  color.rgb = renodx::math::SafePow(color.rgb, 2.2f);
  color.rgb *= injectedData.toneMapGameNits;
  // color.rgb /= 80.f;

  // if ((injectedData.toneMapType >= 2) && (injectedData.clipPeak)) { //If tonemapper is not "none" or "Vanilla"
  //     if (renodx::color::y::from::BT709(color.rgb) > injectedData.toneMapPeakNits / 80.f) { // If the MaxCll is over peaknits
  //         color.rgb = min(color.rgb, injectedData.toneMapPeakNits / 80.f); //clamp output to peak nits slider, bandaid for a few effects
  //     }
  // }

  // Shortfuse's bandaid
  if ((injectedData.toneMapType >= 2) && (injectedData.clipPeak)) {  // If tonemapper is not "none" or "Vanilla"
    float y_max = injectedData.toneMapPeakNits;
    float y = renodx::color::y::from::BT709(abs(color.rgb));
    if (y > y_max) {
      color.rgb *= y_max / y;
    }
  }

  color.rgb /= 80.f;

  output.rgba = color;
}
