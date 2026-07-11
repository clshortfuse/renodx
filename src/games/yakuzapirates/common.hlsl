#include "./shared.h"

float3 ProcessColor(float3 color) {
  float3 gamma = injectedData.gamma ? renodx::math::PowSafe(color.rgb, 2.4f) : renodx::math::PowSafe(color.rgb, 2.2f);                  // Linearize with 2.2 or 2.4 gamma
  float3 bt2020Color = renodx::color::bt2020::from::BT709(gamma);                                                                       // get 2020 color from 709 color
  float3 tonemap = renodx::tonemap::ExponentialRollOff(bt2020Color, 1.f, injectedData.toneMapPeakNits / injectedData.toneMapGameNits);  // Display map with ExponentialRollOff
  float3 pqEncode = renodx::color::pq::Encode(tonemap, injectedData.toneMapGameNits);

  return pqEncode;
}