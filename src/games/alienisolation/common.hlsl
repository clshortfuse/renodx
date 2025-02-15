#include "./shared.h"

float4 UIScale(float4 color) {
  color = saturate(color);
  color.rgb = renodx::color::gamma::Decode(color.rgb, 2.2f);
  color.rgb *= injectedData.toneMapUINits / renodx::color::srgb::REFERENCE_WHITE;

  return color;
}

float4 GameScale(float4 color) {
  color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2f);
  color.rgb *= injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;

  return color;
}
