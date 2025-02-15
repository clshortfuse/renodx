#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.f;

bool ShouldTonemap(uint output_type = 3u) {
  return injectedData.toneMapType != 0.f;
}

float3 EncodeToPQ(float3 color) {
  color.rgb = renodx::color::pq::EncodeSafe(color.rgb, RENODX_GAME_NITS);
  return color;
}

float3 DecodeFromPQ(float3 color) {
  color.rgb = renodx::color::pq::DecodeSafe(color.rgb, RENODX_GAME_NITS);
  return color;
}

float3 FinalizeTonemap(float3 color, bool is_hdr10 = true) {
  color = renodx::color::gamma::DecodeSafe(color);
  color *= injectedData.toneMapUINits;
  color = min(color, injectedData.toneMapPeakNits);  // Clamp UI or Videos

  color /= 80.f;

  return color;
}

float4 FinalizeUEOutput(float4 scene, float4 ui, bool blend_ui = true) {
  scene.rgb = DecodeFromPQ(scene.rgb);

  ui.rgb = renodx::color::srgb::Decode(ui.rgb);
  float uiY = renodx::color::y::from::BT709(ui.rgb);
  if (uiY == 0.f && ui.a == 1.f) {
    ui.a = 0.f;
  }

  ui.rgb = renodx::color::bt2020::from::BT709(ui.rgb);
  ui.rgb = ui.rgb * injectedData.toneMapUINits / injectedData.toneMapGameNits;

  if (blend_ui) {
    scene.rgb = lerp(scene.rgb, ui.rgb, ui.a);
  }
  scene.rgb = renodx::color::correct::Gamma(scene.rgb);
  scene.rgb = EncodeToPQ(scene.rgb);

  return float4(scene.rgb, 1.f);
}

float3 UpgradeToneMapAP1(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);
  return renodx::draw::ToneMapPass(untonemapped_bt709, tonemapped_bt709);
}

float4 LutBuilderToneMap(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 color = UpgradeToneMapAP1(untonemapped_ap1, tonemapped_bt709);
  color = renodx::draw::RenderIntermediatePass(color);
  color *= 1.f / 1.05f;
  return float4(color, 1);
}

float4 OutputToneMap(float4 untonemapped, float4 tonemapped) {
  // It's PQ in HDR
  float3 color = renodx::color::pq::Decode(tonemapped.rgb, 100.f);
  color = renodx::draw::ToneMapPass(untonemapped.rgb, color);
  color *= 1.05f;
  color = EncodeToPQ(color);
  return float4(color.rgb, 0.f);
}
