#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_DISPLAY_MAP_HLSLI_
#define SRC_GAMES_MASSEFFECTANDROMEDA_DISPLAY_MAP_HLSLI_

#include "./shared.h"
#include "psycho_test24.hlsli"

float EotfGamma() {
  if (injectedData.gammaCorrection == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) return 2.4f;
  if (injectedData.gammaCorrection == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) return 2.2f;
  return 0.f;
}

float3 ApplyEotfEmulation(float3 color) {
  const float gamma = EotfGamma();
  if (gamma != 0.f) color = renodx::color::correct::GammaSafe(color, false, gamma);
  return color;
}

// Per-present tone-map params, shared by the present and loading tails. Vanilla pins diffuse/UI to
// 100 nits and disables EOTF; Vanilla+ follows the Game/UI Brightness sliders and the EOTF selector.
struct PresentParams {
  float paperWhite;
  float uiNits;
  float uiGamma;  // 0 = sRGB decode (Vanilla / EOTF off), else re-interpret the UI with this gamma
};
PresentParams GetPresentParams() {
  const bool full = IsVanillaPlus();
  PresentParams p;
  p.paperWhite = full ? max(injectedData.toneMapGameNits, 1.f) : 100.f;
  p.uiNits = full ? max(injectedData.toneMapUINits, 1.f) : 100.f;
  p.uiGamma = full ? EotfGamma() : 0.f;
  return p;
}

// Final HDR10 output, shared by the present and loading tails: BT.709 nits -> BT.2020 -> ST.2084 PQ.
// Caller supplies the alpha. Vanilla+ clips per channel at Peak Brightness: the display maps bound
// luminance or the LMS cones, not the BT.2020 channels, and the input arrives post-composite.
float3 FinalizeToPQ(float3 scene_nits) {
  float3 bt2020_nits = renodx::color::bt2020::from::BT709(scene_nits);
  if (IsVanillaPlus()) {
    bt2020_nits = min(bt2020_nits, injectedData.toneMapPeakNits);
  }
  return renodx::color::pq::EncodeSafe(bt2020_nits, 1.f);
}

// UI/video over-scene alpha composite.
void CompositeUI(inout float3 scene_nits, inout float scene_a, float ui_alpha_src, float ui_alpha_factor, float3 ui_term_nits) {
  const float t = max(0.f, 1.f - ui_alpha_src * ui_alpha_factor);
  const float uiAlpha = 1.f - t * t;
  const float sceneAlpha = 1.f - uiAlpha;
  scene_nits = scene_nits * sceneAlpha + ui_term_nits;
  scene_a = scene_a * sceneAlpha + uiAlpha;
}

float3 ApplyVanillaPlus(float3 color, float exposure) {
  const float paperWhite = GetPresentParams().paperWhite;
  const bool satViaPurity = injectedData.toneMapType == TONE_MAP_VANILLA_PLUS_TEST24;

  // Display HDR headroom ratio: the roll-off asymptote in paper-white-relative units, so paper white
  // moves diffuse and mids without moving the peak.
  const float peak = max(injectedData.toneMapPeakNits / paperWhite, 1.f + 1e-3f);

  renodx::color::grade::Config cg = renodx::color::grade::config::Create(
      exposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeFlare,
      satViaPurity ? 1.f : injectedData.colorGradeSaturation,
      0.f,  // dechroma
      0.f,  // hue_correction_strength
      float3(0.f, 0.f, 0.f),
      renodx::color::grade::config::hue_correction_type::INPUT,
      -1.f * (injectedData.colorGradeHighlightSaturation - 1.f));  // blowout (highlight saturation, centered at 1.0)
  color = renodx::color::grade::config::ApplyUserColorGrading(color, cg);

  if (satViaPurity) {
    float peakT24 = peak;
    const float gamma = EotfGamma();
    if (gamma != 0.f) peakT24 = renodx::color::correct::GammaSafe(peakT24, true, gamma);
    float3 t24 = renodx_custom::tonemap::psycho24::psychotm_test24(
        color,                              // BT.709 linear, graded (no EOTF on the input)
        peakT24,                            // display headroom ratio, inverse-gamma'd
        1.f,                                // exposure (applied upstream)
        1.f, 1.f, 1.f,                      // highlights / shadows / contrast (neutral: graded upstream)
        injectedData.colorGradeSaturation,  // purity_scale = Saturation slider (test24's saturation lever)
        1.f, 100.f, 1.f, 1.f,               // bleaching / clip / hue_restore / adaptation_contrast (defaults)
        0,                                  // white_curve_mode
        1.f,                                // cone_response_exponent
        0.18f.xxx,                          // adaptive state (mid grey)
        0.18f.xxx,                          // background state (mid grey)
        1.f,                                // gamut compression strength
        1,                                  // gamut compression bound = BT.2020 (forced HDR10 output)
        1.f,                                // adaptive_normalization
        0.f,                                // compression = auto (shoulder from display headroom)
        1.f,                                // highlight_saturation (unused by test24)
        0.f);                               // gamut_hue_restore off

    return ApplyEotfEmulation(t24);
  }

  color = ApplyEotfEmulation(color);

  // Vanilla+ (faithful): luminance-preserving log2 roll-off (keeps hue) + optional Hue Shift.
  const float rolloffStart = min(1.f, peak * 0.5f);
  const float3 preRolloff = color;
  const float y = renodx::color::y::from::BT709(color);
  const float yNew = renodx::tonemap::ExponentialRollOff(y, rolloffStart, peak);
  color = renodx::color::correct::Luminance(color, y, yNew);

  // Hue Shift: blend toward the per-channel roll-off hue (the SDR-display look). 0 = keep BioWare hue.
  if (injectedData.colorGradeHueShift > 0.f) {
    const float3 perChannel = renodx::tonemap::ExponentialRollOff(preRolloff, rolloffStart, peak);
    color = renodx::color::correct::Hue(color, perChannel, injectedData.colorGradeHueShift);
  }

  return color;
}

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_DISPLAY_MAP_HLSLI_
