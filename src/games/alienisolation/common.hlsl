#include "./shared.h"

float4 UIScale(float4 color) {
  color = saturate(color);
  color.rgb = renodx::color::gamma::Decode(color.rgb, 2.2f);
  color.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits;
  color.rgb = renodx::color::gamma::Encode(color.rgb, 2.2f);

  return color;
}

float4 FinalizeOutput(float4 color) {
  // color.a = saturate(color.a);
  color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2f);
  color.rgb *= injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;

  return color;
}
