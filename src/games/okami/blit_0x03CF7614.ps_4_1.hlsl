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
 * IMPORTANT - the composite is the FP16-UPGRADED buffer, so the game's additive
 * / blend ops no longer clamp: it carries values outside the BT.709 [0,1] RGB
 * cube on both sides. Below 0 is tiny negative blend noise (most visibly across
 * the dark sky); feeding it raw into ToneMapPass(DecodeSafe(composite)) sent
 * ~70% of the frame negative / invalid (measured). The 8-bit UNORM targets
 * clamped that at 0, so the None / ACES / RenoDRT path clamps it the same way.
 * Above 1 is the additive bloom / emissive over-range, the only real HDR in the
 * frame, and is kept with its own chromaticity. There is no grade or LUT to
 * preserve, so no SDR base is reconstructed: a saturate() base would give the
 * over-range the per-channel clip's chromaticity (UpgradeToneMap rescales the
 * clipped color to the original luminance), shifting e.g. orange emissives
 * toward yellow. Nothing is guessed (not ITM). Grade / brightness / gamma are
 * all global.
 *
 * Registered as a CustomSwapchainShader, so the conversion only runs on the draw
 * whose render target is the swapchain backbuffer. The bloom-downscale and
 * history-copy draws that share this hash keep the vanilla blit.
 *
 * NOTE: the Vanilla / None / ACES / RenoDRT paths treat the composite as
 * sRGB-encoded (DecodeSafe below) and apply Gamma Correction after the tone
 * map - validated clean in-game. The PsychoV path instead decodes with the
 * Gamma Correction EOTF directly (see the comment in that branch).
 */

#include "./customtest31.hlsli"

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

  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 color;
  [branch]
  if (RENODX_TONE_MAP_TYPE == 4.f) {
    // PsychoV31 by ShortFuse (Carlos Lopez, MIT), through the custom Test31
    // variant with Musa Haji's modifications (customtest31.hlsli, which keeps
    // both copyright notices), parameterized for Okami's pipeline. The
    // composite is display-referred, nonlinear R'G'B' (BT.709 primaries, D65),
    // so PsychoV acts here as a display-referred highlight extension plus gamut
    // mapping, not as a scene-to-display OOTF:
    //
    // - Decode with the EOTF of the display that Gamma Correction assumes: a
    //   pure 2.2 or 2.4 power law, or the piecewise sRGB function when Off. For
    //   R'G'B' in [0, 1] this equals the sRGB decode + RenderIntermediatePass
    //   correction the other tone mappers get, but it runs before the tone map,
    //   so the shoulder lands exactly on peak. RenderIntermediatePass's gamma
    //   step is disabled for this branch so it isn't applied twice.
    // - Values above 1 come from additive blending on encoded values in the
    //   upgraded FP16 targets. SignPow extends the EOTF past its [0, 1] domain,
    //   so their decoded level is an extrapolation, not a measured luminance.
    // - No saturate() base: the BT.709 source boundary moves values outside the
    //   BT.709 RGB cube (negative components left by that same encoded-domain
    //   arithmetic) back onto the BT.709 hull at their own Yf.
    // - 0.18 -> 0.18, unit contrast, no built-in flare: vanilla is a hard clip
    //   with no toe, so there is no shadow curve to reproduce.
    // - Compression 1.0, the shoulder's minimum (closest to identity). The
    //   whole authored image, HUD included, sits in [0, 1]: diffuse white
    //   (relative luminance 1.0) maps to 0.997 at 1000 nits peak and 0.925 at
    //   400 nits (1.5 gives 0.990 / 0.883).
    // - BT.2020 target: the smooth limiter already shrinks PsychoV's radial L8
    //   demand before the hull (to 0.9375 at demand 1), so a BT.709 target
    //   would pull in Okami's most saturated BT.709 colors inside SDR range.
    // - Mean-A2 highlight source weight 0 keeps PsychoV's response hue in
    //   highlights. Heuristic, not measured: vanilla's per-channel clip of
    //   encoded R'G'B' also let highlight hue shift, but in a different space.
    float3 display_linear;
    [branch]
    if (RENODX_GAMMA_CORRECTION == 0.f) {
      display_linear = renodx::color::srgb::DecodeSafe(composite);
    } else {
      display_linear = renodx::color::gamma::DecodeSafe(
          composite, RENODX_GAMMA_CORRECTION == 1.f ? 2.2f : 2.4f);
    }
    config.gamma_correction = renodx::draw::GAMMA_CORRECTION_NONE;

    color = renodx::tonemap::psychov::custom_psychotm_test31(
        display_linear,
        RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        // Quadratic so the slider acts across its whole range: about -0.15 /
        // -0.5 / -1.0 / -1.4 stops at linear 0.02 for 25 / 50 / 75 / 100.
        0.1f * RENODX_TONE_MAP_FLARE * RENODX_TONE_MAP_FLARE,
        RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
        RENODX_TONE_MAP_CONTRAST_SHADOWS,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        RENODX_TONE_MAP_BLOWOUT,  // dechroma
        0.18f,                    // adaptation anchor (in)
        0.18f,                    // background anchor (out)
        0.f,                      // SDR EOTF emulation (done at decode)
        1.f,                      // gamut compression
        renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT2020,
        1.f,   // compression
        1.f,   // Mean-A2 shadow source weight
        0.5f,  // Mean-A2 midgray source weight
        0.f,   // Mean-A2 highlight source weight
        renodx::tonemap::psychov::PSYCHO30_SOURCE_BOUNDARY_BT709,
        1.f);
  } else if (RENODX_TONE_MAP_TYPE == 0.f) {
    // Vanilla: the game's own final-frame result, a per-channel hard clip, as
    // the BGRA8 UNORM backbuffer applied it. The FP16 upgrade of the
    // intermediate targets stays active, so blends and bloom that read
    // over-range values can still differ slightly from the unmodded game.
    color = renodx::color::srgb::DecodeSafe(saturate(composite));
  } else {
    // None / ACES / RenoDRT: clamp only the negative residue, as the 8-bit
    // targets did, and keep the over-range intact (see header).
    color = renodx::draw::ToneMapPass(
        max(0.f, renodx::color::srgb::DecodeSafe(composite)));
  }

  color = renodx::draw::RenderIntermediatePass(color, config);  // encode intermediate
  color = renodx::draw::SwapChainPass(color);                   // decode + scRGB
  o0 = float4(color, 1.f);
}
