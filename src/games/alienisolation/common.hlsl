#include "./shared.h"

float4 UIScale(float4 color) {
  color = saturate(color);
  color.rgb = renodx::color::gamma::Decode(color.rgb, 2.2f);
  color.rgb *= injectedData.toneMapUINits / renodx::color::srgb::REFERENCE_WHITE;

  return color;
}

float4 GameScale(float4 color) {
  color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2f);
  if (injectedData.toneMapType > 1.f) {
    color.rgb = min(color.rgb, injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  } else if (injectedData.toneMapType == 0.f) {
    color.rgb = saturate(color.rgb);
  }
  color.rgb *= injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;

  return color;
}
