#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0) : SV_TARGET {
  float4 color = t0.Sample(s0, uv);

  color.rgb = renodx::color::correct::GammaSafe(color.rgb);  // The game is linear, idk if we even need this

  color.rgb *= injectedData.toneMapUINits;  // Scale luminance -- The tonemapper has a ratio of injectedData.toneMapGameNits / injectedData.toneMapUINits

  // Shortfuse's bandaid
  if ((injectedData.toneMapType >= 2) && (injectedData.clipPeak)) {  // If tonemapper is not "none" or "Vanilla"
    float y_max = injectedData.toneMapPeakNits;
    float y = renodx::color::y::from::BT709(abs(color.rgb));
    if (y > y_max) {
      color.rgb *= y_max / y;
    }
  }

  color.rgb /= 80.f;

  color.a = 1.f;

  return color;
}
