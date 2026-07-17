#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_LOADING_CORE_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_LOADING_CORE_HLSLI_

// Shared loading/video present tail for both 1:1 (0xF5B7A93D) and upscale (0x667C56AF) -> HDR10 PQ.
// No 1D output LUT here: the loading art (scene) is sRGB-encoded, decoded to linear directly.
// cb2 = cbData[2]: .x scene scale, .y UI gate, .z UI alpha factor. Requires shared.h first.

float4 LoadingPresentScene(
    float4 scene, float2 texcoord, float4 cb2,
    Texture2D<float4> uiTexture, SamplerState uiSampler) {
  scene *= cb2.x;

  float3 color = renodx::color::srgb::DecodeSafe(max(0.f, scene.rgb));

  // Vanilla = native passthrough (diffuse 100, nothing applied).
  // Vanilla+ = exposure/grade + EOTF + roll-off (pins peak) + paper white.
  const PresentParams p = GetPresentParams();

  if (p.full) {
    // Grade + EOTF + roll-off + Hue Shift. The loading pass has no separate pre-tonemap exposure,
    // so apply the Exposure slider here.
    color = ApplyVanillaPlus(color, injectedData.colorGradeExposure, p.paperWhite);
  }

  float3 scene_nits = max(0.f, color * p.paperWhite);

  if (cb2.y > 0.f) {
    float4 ui = uiTexture.SampleLevel(uiSampler, texcoord, 0.f);

    float3 uiTermNits;
    if (injectedData.fxVideoActive != 0.f) {
      // FMV decoded into this layer. Decode the sRGB-encoded video and bind to Game Brightness (paper
      // white), never UI Brightness. Inverse tone map to HDR only in Vanilla+ with HDR Videos on;
      // otherwise present at paper white.
      const float3 v = renodx::color::srgb::DecodeSafe(max(0.f, ui.rgb));
      uiTermNits = (p.full && injectedData.fxHDRVideos == 1.f)
          ? renodx::tonemap::inverse::bt2446a::BT709(v, p.paperWhite, injectedData.toneMapPeakNits)
          : v * p.paperWhite;
    } else {
      // Raw unorm UI/HUD. Decode with sRGB by default, or the selected gamma (2.2 / BT.1886) when
      // SDR EOTF emulation is on.
      const float3 uiLinear = (p.eotf != 0.f)
          ? renodx::color::gamma::DecodeSafe(max(0.f, ui.rgb), EotfGamma())
          : renodx::color::srgb::DecodeSafe(max(0.f, ui.rgb));
      uiTermNits = uiLinear * p.uiNits;
    }

    CompositeUI(scene_nits, scene.a, ui.a, cb2, uiTermNits);
  }

  return float4(FinalizeToPQ(scene_nits), scene.a);
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_LOADING_CORE_HLSLI_
