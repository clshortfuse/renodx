/*
 * Copyright (C) 2026 megazeban
 * SPDX-License-Identifier: MIT
 *
 * Okami HD - final upscale blit to the swapchain (hash 0x03CF7614)
 *
 * ALL HDR conversion happens here, on the FINAL composited frame, because that
 * is the only place the whole image exists.
 *
 * DevKit-confirmed pipeline: Okami HD is a hard-clip-SDR game. The final image is
 * assembled directly in display-referred SDR across hundreds of draws - scene
 * geometry, the HUD alpha-blended straight in, then bloom. There is NO master
 * tone-map pass, NO HDR scene buffer, and NO whole-image LUT.
 *
 * IMPORTANT - why the 3-arg ToneMapPass with a saturate() base (not the 1-arg
 * form the hard-clip reference src/games/hollowknight-silksong uses): that
 * reference reads a CLEAN SDR render. Okami's composite is the FP16-UPGRADED
 * buffer, so the game's additive / blend ops no longer clamp - it carries
 * sub-zero and out-of-gamut values (most visibly tiny negative blend noise across
 * the dark sky) that 8-bit unorm would have clamped to [0,1]. Feeding that
 * straight into the 1-arg ToneMapPass(DecodeSafe(composite)) sent ~70% of the
 * frame negative / invalid (measured). So we reconstruct off a gamut-safe base:
 *   untonemapped = DecodeSafe(composite)            // real FP16 over-range (and dirt)
 *   neutral/graded = DecodeSafe(saturate(composite)) // clamped, gamut-safe SDR
 *   ToneMapPass(untonemapped, graded, neutral)       // luminance reconstruction:
 *     SDR preserved off the clean base, real over-range lifted by the luminance
 *     ratio and hue-matched to the clean base -> stays in BT.709 (0% invalid).
 * The genuine HDR is still only the additive bloom / emissive over-range; nothing
 * is guessed (not ITM). Grade / brightness / gamma are all global.
 *
 * Registered as a CustomSwapchainShader, so the conversion only runs on the draw
 * whose render target is the swapchain backbuffer. The bloom-downscale and
 * history-copy draws that share this hash keep the vanilla blit.
 *
 * NOTE: the composite is treated as sRGB-encoded (DecodeSafe below) - validated
 * clean in-game. If exposure ever looks off, try a gamma-2.2 decode instead.
 */

#include "./shared.h"

SamplerState gLinearSampler : register(s0);
Texture2D<float4> gBaseTexture : register(t0);

void main(
    float4 v0 : SV_Position,
    float4 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0) {
  float3 composite = gBaseTexture.Sample(gLinearSampler, v1.xy).rgb;

  // DevKit / live-shader passthrough guard: emit the raw blit when the injection
  // buffer isn't bound (peak nits invalid) instead of garbage.
  if (RENODX_PEAK_WHITE_NITS <= 0.f) {
    o0 = float4(composite, 1.f);
    return;
  }

  // Reconstruct HDR off a gamut-safe SDR base (see header). saturate() clamps the
  // dirty FP16 composite to [0,1] BT.709; the over-range is recovered via the
  // luminance ratio inside ToneMapPass.
  float3 untonemapped = renodx::color::srgb::DecodeSafe(composite);
  float3 neutral_sdr = renodx::color::srgb::DecodeSafe(saturate(composite));
  float3 graded_sdr = neutral_sdr;

  float3 color = renodx::draw::ToneMapPass(untonemapped, graded_sdr, neutral_sdr);
  color = renodx::draw::RenderIntermediatePass(color);  // encode intermediate
  color = renodx::draw::SwapChainPass(color);           // decode + scRGB
  o0 = float4(color, 1.f);
}
