#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_PRESENT_CORE_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_PRESENT_CORE_HLSLI_

#include "../shared.h"
#include "../display_map.hlsli"
#include "./linearize.hlsli"
#include "./lilium_rcas.hlsli"

// Shared HDR present tail for every present row -> HDR10 PQ. The sole caller is
// output_present.hlsli, which supplies the scene fetch, the bindings, and the row's geometry.
// scene: rgb = pre-scale graded buffer, a = layer alpha. cb2 = cbData[2]: .x scene scale,
// .y UI gate, .z UI alpha factor.

float4 PresentScene(
    float4 scene, float2 texcoord, float4 cb2,
    Texture2D<float4> sceneTexture, SamplerState sceneSampler,
    Texture2D<float4> uiTexture, SamplerState uiSampler,
    Texture1D<float4> outputLut, SamplerState lutSampler,
    // Compile-time literal at the call site; fxc folds the RCAS gate below out entirely. Kept a
    // parameter so this file stays a pure function of its arguments with no config coupling.
    bool isScaled) {
  scene *= cb2.x;

  float3 color = max(0.f, LinearizeScene(outputLut, lutSampler, scene.rgb));

  const PresentParams p = GetPresentParams();

  if (p.full) {
    // RCAS (no-op at 0), before grade + UI composite so the HUD stays crisp. Swapchain-only (gate).
    // Skipped when the scene is scaled: resampled center vs source-res point neighbors is
    // asymmetric, so the taps are only coherent on the 1:1 row.
    if (injectedData.fxSwapchainPresent != 0.f && !isScaled) {
      color = ApplyRCAS(color, texcoord, sceneTexture, sceneSampler, outputLut, lutSampler, cb2.x);
    }

    // Grade + EOTF + roll-off + Hue Shift. Exposure is applied pre-tonemap in tonemap_grade, so pass 1.0.
    color = ApplyVanillaPlus(color, 1.f, p.paperWhite);

    // Perceptual film grain (Luminance / Per-Channel) in paper-white-relative units.
    if (injectedData.fxFilmGrain > 0.f) {
      const float strength = injectedData.fxFilmGrain * 0.03f;
      if (injectedData.fxFilmGrainType == FILM_GRAIN_LUMINANCE) {
        color = renodx::effects::ApplyFilmGrain(color, texcoord, injectedData.customRandom, strength, 1.f);
      } else if (injectedData.fxFilmGrainType == FILM_GRAIN_PER_CHANNEL) {
        const float r = injectedData.customRandom;
        // Irrational (phi, pi) offsets decorrelate the three channel seeds from one uniform draw.
        const float3 seed = float3(r, frac(r * 1.6180339887f + 0.5f), frac(r * 3.1415926535f + 0.25f));
        color = renodx::effects::ApplyFilmGrainColored(color, texcoord, seed, strength, 1.f);
      }
    }
  }

  float3 scene_nits = max(0.f, color * p.paperWhite);

  if (cb2.y > 0.f) {
    float4 ui = uiTexture.SampleLevel(uiSampler, texcoord, 0.f);

    // The UI arrives sRGB-decoded (t1 is an _srgb view). When SDR EOTF emulation is on,
    // re-interpret it with the selected gamma (2.2 / BT.1886) to match the scene's SDR look.
    float3 uiRgb = ui.rgb;
    if (p.uiGamma != 0.f) {
      uiRgb = renodx::color::correct::Gamma(uiRgb, false, p.uiGamma);
    }
    CompositeUI(scene_nits, scene.a, ui.a, cb2, uiRgb * p.uiNits);
  }

  return float4(FinalizeToPQ(scene_nits), scene.a);
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_PRESENT_CORE_HLSLI_
