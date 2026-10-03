#ifndef SRC_GAMES_GENSHIN_COMMON_HLSLI_
#define SRC_GAMES_GENSHIN_COMMON_HLSLI_

#include "./shared.h"

// Vanilla SDR tone curve, shared by the SDR uberpost path (applied, then
// clipped) and the HDR LUT builder (applied per channel for hue/saturation).
float3 VanillaToneMap(float3 x) {
  return saturate((x * (1.36f * x + 0.047f)) / (x * (0.93f * x + 0.56f) + 0.14f));
}

// HDR mode final composites: converts the PQ BT.2020 scene (nits) to the
// RenoDX intermediate encoding (1.0 = UI white nits) and blends the
// premultiplied UI at that level. Vanilla blends at the game's UI paper white
// and PQ encodes through a 1D LUT; the swapchain proxy does the final encode.
float4 CompositeSceneAndUI(float3 scene_pq, float4 ui) {
  renodx::draw::Config config = renodx::draw::BuildConfig();

  float3 scene_nits = renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(scene_pq, 1.f));
  float3 color = renodx::draw::EncodeColor(scene_nits / config.graphics_white_nits, config.intermediate_encoding);

  // With ReShade effects before UI, the addon renders effects on the scene and
  // blends the UI afterwards with the same premultiplied math
  if (shader_injection.custom_effects_before_ui == 0.f && (ui.a != 1.f || any(ui.rgb != 0.f))) {
    color = color * ui.a + ui.rgb;
  }

  return float4(color, 1.f);
}

#endif  // SRC_GAMES_GENSHIN_COMMON_HLSLI_
