#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_LOADING_CORE_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_LOADING_CORE_HLSLI_

#include "../shared.h"
#include "../display_map.hlsli"

// Shared loading/video present tail -> HDR10 PQ, backing all nine loading rows (1:1 s0, 1:1 s1,
// upscale - each in three output-gamut variants).
// No 1D output LUT here: the loading art (scene) is sRGB-encoded, decoded to linear directly.
// cb2 = cbData[2]: .x scene scale, .y UI gate, .z UI alpha factor.

float4 LoadingPresentScene(
    float4 scene, float2 texcoord, float4 cb2,
    Texture2D<float4> uiTexture, SamplerState uiSampler) {
  scene *= cb2.x;

  float3 color = renodx::color::srgb::DecodeSafe(max(0.f, scene.rgb));

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
      if (p.full && injectedData.fxHDRVideos != 0.f) {
        // BT.2446a Method A is display-referred: it returns pow(saturate(..), 2.4) * target, so video
        // white lands exactly ON the target and the mid tones lift with it - this is not a
        // highlights-only curve. Measured at paper white 203: mid grey (0.18) goes 36.5 nits -> 44.5 at
        // a 400-nit target, 52.7 at 500, 88.7 at 1000. So the target is the whole control: there is no
        // separate strength, and the curve covers the full range with no shoulder to place.
        // Clamped in the shader, not merely bounded in the UI: above the display peak we would hand the
        // display values it has to tone map a second time, and below paper white the video would read
        // dimmer than the UI beside it. Peak deliberately wins if Game Brightness is set above it.
        const float videoNits = clamp(injectedData.fxVideoNits, p.paperWhite, injectedData.toneMapPeakNits);
        uiTermNits = renodx::tonemap::inverse::bt2446a::BT709(v, p.paperWhite, videoNits);
      } else {
        uiTermNits = v * p.paperWhite;
      }
    } else {
      // Raw unorm UI/HUD. Decode with sRGB by default, or the selected gamma (2.2 / BT.1886) when
      // SDR EOTF emulation is on.
      const float3 uiLinear = (p.uiGamma != 0.f)
          ? renodx::color::gamma::DecodeSafe(max(0.f, ui.rgb), p.uiGamma)
          : renodx::color::srgb::DecodeSafe(max(0.f, ui.rgb));
      uiTermNits = uiLinear * p.uiNits;
    }

    CompositeUI(scene_nits, scene.a, ui.a, cb2, uiTermNits);
  }

  return float4(FinalizeToPQ(scene_nits), scene.a);
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_LOADING_CORE_HLSLI_
