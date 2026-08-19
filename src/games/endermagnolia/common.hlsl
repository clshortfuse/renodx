#include "./shared.h"

float3 UpgradeToneMapAP1(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
  return renodx::draw::ToneMapPass(untonemapped_bt709, tonemapped_bt709);
}

float3 LutBuilderToneMap(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 color = UpgradeToneMapAP1(untonemapped_ap1, tonemapped_bt709);
  color = renodx::draw::RenderIntermediatePass(color);
  color *= 1.f / 1.05f;
  return color;
}

float4 ProcessColor(float3 untonemapped, float3 tonemapped) {
  untonemapped = renodx::color::ap1::from::BT709(untonemapped); // LutBuilderToneMap expects untonemapped to be in AP1
  tonemapped = renodx::color::srgb::DecodeSafe(tonemapped);
  float3 color = LutBuilderToneMap(untonemapped, tonemapped);
  color *= 1.05;
  return float4(color, 1.f);
}
