#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_SHARED_H_
#define SRC_GAMES_MASSEFFECTANDROMEDA_SHARED_H_

// C++/HLSL contract (host writes, shaders read at b13) plus the game-wide HLSL helpers every
// replaced pass builds on (output-LUT linearize, EOTF emulation, present params, Vanilla+ display map).

// Must be 32-bit aligned.
struct ShaderInjectData {
  float toneMapType;       // 0 = Vanilla, 1 = Vanilla+ (faithful), 2 = Vanilla+ (Neutwo), 3 = Vanilla+ (Psycho v24)
  float toneMapPeakNits;   // display peak the roll-off pins highlights to (Vanilla+)
  float toneMapGameNits;   // diffuse-white (paper white) nits; Vanilla pins 100
  float toneMapUINits;     // UI/HUD white nits; Vanilla pins 100
  float colorGradeExposure;    // pre-tonemap exposure scale (1.0 = vanilla)
  float colorGradeHighlights;  // 1.0 = vanilla
  float colorGradeShadows;     // 1.0 = vanilla
  float colorGradeContrast;    // 1.0 = vanilla
  float colorGradeSaturation;  // 1.0 = vanilla; test24 routes this through purity_scale instead
  float colorGradeHighlightSaturation;  // 1.0 = vanilla; >1 boosts highlight color, <1 blows out to white
  float colorGradeFlare;     // flare/glare compensation (0 = vanilla/off)
  float colorGradeHueShift;  // 0 = keep BioWare hue, >0 = blend highlights toward per-channel hue
  float gammaCorrection;   // 0 = Off, 1 = 2.2, 2 = BT.1886 (2.4); RenoDX per-channel gamma correction
  float fxBloom;           // additive bloom scale (1.0 = vanilla)
  float fxVignette;             // vignette strength (1.0 = vanilla, 0 = off)
  float fxChromaticAberration;  // chromatic aberration strength (1.0 = vanilla, 0 = off)
  float fxFilmGrain;       // perceptual film grain strength (0 = off)
  float fxFilmGrainType;   // 0 = Vanilla (game grain), 1 = Monochrome (luminance), 2 = Colored (per-channel)
  float fxHDRVideos;       // 0 = Off, 1 = BT.2446a (FMV inverse tone map)
  float fxVideoActive;     // runtime flag: an FMV decode pass ran this frame
  float fxSharpness;       // Lilium HDR RCAS strength (0 = off), Vanilla+ only
  float fxSwapchainPresent;  // runtime flag: 1 when the present draw targets the swapchain (RCAS gate)
  float customRandom;      // per-frame random seed for perceptual grain
  float customLutTetrahedral;  // 0 = Trilinear (vanilla), 1 = Tetrahedral (higher-quality native LUT sampling)
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

#define TONE_MAP_VANILLA 0.f
#define TONE_MAP_VANILLA_PLUS 1.f         // faithful log2 highlight roll-off; the fall-through mode (never compared)
#define TONE_MAP_VANILLA_PLUS_NEUTWO 2.f  // knee-free Neutwo highlight curve (continuous, no identity segment)
#define TONE_MAP_VANILLA_PLUS_TEST24 3.f  // PsychoV test24 perceptual observer-model curve (experimental)

#define FILM_GRAIN_VANILLA 0.f
#define FILM_GRAIN_LUMINANCE 1.f
#define FILM_GRAIN_PER_CHANNEL 2.f

#define CUSTOM_SHARPNESS injectedData.fxSharpness

// "Full pipeline" predicate: true for any Vanilla+ mode (faithful roll-off, Neutwo, or Psycho v24).
// Reads only injectedData, so usable from any pass. Only the final display-mapping step differs.
bool IsVanillaPlus() {
  return injectedData.toneMapType != TONE_MAP_VANILLA;
}

#include "../../shaders/renodx.hlsl"
#include "psycho_test24.hlsli"  // experimental PsychoV test24 tone mapper (HLSL-only)

// Game's 1D output LUT: linearizes the PQ-encoded graded buffer to scene-linear (1.0 = diffuse white).
// Shared by the present center tap and RCAS neighbors so both linearize identically.
float3 SampleOutputLut(Texture1D<float4> lut_tex, SamplerState lut_smp, float3 color) {
  return float3(
      lut_tex.SampleLevel(lut_smp, color.r, 0.f).r,
      lut_tex.SampleLevel(lut_smp, color.g, 0.f).r,
      lut_tex.SampleLevel(lut_smp, color.b, 0.f).r);
}

// Selected SDR EOTF gamma: 0 = Off, else 2.2 / 2.4 (BT.1886). Single source for the gamma-mode
// dispatch — the scene emulation, the test24 peak fold, and the present UI re-gamma all read it.
float EotfGamma() {
  if (injectedData.gammaCorrection == renodx::draw::GAMMA_CORRECTION_GAMMA_2_4) return 2.4f;
  if (injectedData.gammaCorrection == renodx::draw::GAMMA_CORRECTION_GAMMA_2_2) return 2.2f;
  return 0.f;
}

// SDR EOTF emulation = RenoDX per-channel gamma correction with the selected gamma.
// GammaSafe is sign-preserving (color grading can push a channel negative; non-Safe Gamma -> NaN).
float3 ApplyEotfEmulation(float3 color) {
  const float gamma = EotfGamma();
  if (gamma != 0.f) color = renodx::color::correct::GammaSafe(color, false, gamma);
  return color;
}

// Per-present tone-map params, shared by both present tails. Vanilla pins diffuse/UI to 100 nits
// and disables EOTF; Vanilla+ follows the Game/UI Brightness sliders and the EOTF selector.
struct PresentParams {
  bool full;
  float paperWhite;
  float uiNits;
  float uiGamma;  // 0 = sRGB decode (Vanilla / EOTF off), else re-interpret the UI with this gamma
};
PresentParams GetPresentParams() {
  PresentParams p;
  p.full = IsVanillaPlus();
  p.paperWhite = p.full ? max(injectedData.toneMapGameNits, 1.f) : 100.f;
  p.uiNits = p.full ? max(injectedData.toneMapUINits, 1.f) : 100.f;
  p.uiGamma = p.full ? EotfGamma() : 0.f;
  return p;
}

// Final HDR10 output, shared by both present tails: BT.709 nits -> BT.2020 -> ST.2084 PQ. Caller
// supplies the alpha.
// The game runtime-selects an output gamut per display (BT.2020 / DCI-P3 / no-matrix — separate
// hashes); every variant lands here on the forced HDR10/BT.2020 swapchain, which is why the
// per-gamut wrappers share their row bodies unchanged.
float3 FinalizeToPQ(float3 scene_nits) {
  return renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(scene_nits), 1.f);
}

// UI/video over-scene alpha composite (cb2.z = UI alpha factor; ui_term_nits = linearized UI in nits).
// max(0,...) guards the pow: cb2.z is unclamped, so ui.a*cb2.z can exceed 1 and pow(negative) = NaN
// on the fp16 target (vanilla wrote UNORM, which clamped).
void CompositeUI(inout float3 scene_nits, inout float scene_a, float ui_alpha_src, float4 cb2, float3 ui_term_nits) {
  const float uiAlpha = 1.f - pow(max(0.f, 1.f - ui_alpha_src * cb2.z), 2.f);
  const float sceneAlpha = 1.f - uiAlpha;
  scene_nits = scene_nits * sceneAlpha + ui_term_nits;
  scene_a = scene_a * sceneAlpha + uiAlpha;
}

// Vanilla+ finalize: user color grade, then a mode-selected display map (Psycho v24 | Neutwo |
// faithful luminance roll-off + Hue Shift), each pinning the peak to Peak Brightness. exposure is 1.0
// for the main pass (applied pre-tonemap) / the slider for loading; paperWhite = diffuse-white nits.
float3 ApplyVanillaPlus(float3 color, float exposure, float paperWhite) {
  // test24 routes the Saturation slider through the tonemapper's purity_scale instead of the
  // pre-grade; every other mode saturates in the grade as before. One decision, two consumers.
  const bool satViaPurity = injectedData.toneMapType == TONE_MAP_VANILLA_PLUS_TEST24;

  // Highlight roll-off pins the peak to Peak Brightness so paper white only moves diffuse/mids
  // (not the peak). Requires the in-game Peak Brightness at MAX. peak = display HDR headroom ratio.
  const float peak = max(injectedData.toneMapPeakNits / paperWhite, 1.f + 1e-3f);

  // User color grading (neutral sliders early-return to a no-op).
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

  // PsychoV test24 (opt-in): a linear-domain observer-model curve. The scene stays LINEAR into the
  // curve; the SDR EOTF gamma is folded OUT of the peak target (inverse) and back ONTO the tonemapped
  // output (forward), so the gamma darkens the mids while the peak still lands at Peak Brightness.
  // H/S/C are graded upstream (passed neutral); saturation rides purity_scale; gamut compresses to
  // the BT.2020 hull (HDR10).
  if (injectedData.toneMapType == TONE_MAP_VANILLA_PLUS_TEST24) {
    float peakT24 = peak;
    const float gamma = EotfGamma();
    if (gamma != 0.f) peakT24 = renodx::color::correct::GammaSafe(peakT24, true, gamma);
    float3 t24 = renodx::tonemap::psychov::psychotm_test24(
        color,        // BT.709 linear, graded (no EOTF on the input)
        peakT24,      // display headroom ratio, inverse-gamma'd
        1.f,          // exposure (applied upstream)
        1.f, 1.f, 1.f,               // highlights / shadows / contrast (neutral: graded upstream)
        injectedData.colorGradeSaturation,  // purity_scale = Saturation slider (test24's saturation lever)
        1.f, 100.f, 1.f, 1.f,  // bleaching / clip / hue_restore / adaptation_contrast (defaults)
        0,            // white_curve_mode
        1.f,          // cone_response_exponent
        0.18f.xxx,    // adaptive state (mid grey)
        0.18f.xxx,    // background state (mid grey)
        1.f,          // gamut compression strength
        1,            // gamut compression bound = BT.2020 (forced HDR10 output)
        1.f,          // adaptive_normalization
        0.f,          // compression = auto (shoulder from display headroom)
        1.f,          // highlight_saturation (unused by test24)
        0.f);         // gamut_hue_restore off
    // Forward EOTF gamma on the output = the same GammaSafe the other modes apply, undoing the peak
    // inverse so the peak is preserved and the mids are darkened.
    return ApplyEotfEmulation(t24);
  }

  // SDR EOTF emulation (selected gamma).
  color = ApplyEotfEmulation(color);

  if (injectedData.toneMapType == TONE_MAP_VANILLA_PLUS_NEUTWO) {
    // Neutwo (x/sqrt(x^2+p^2)) on the BT.2020 max channel: a knee-free continuous highlight curve,
    // hue-stable by construction (so no Hue Shift), asymptoting to the peak. Clipless on purpose:
    // MEA's native grade reaches ~10k nits (~80-100x diffuse white), so a fixed content-cap clip
    // would crush every value above the cap into the peak; the 2-arg form maps the whole range
    // smoothly and never exceeds the peak (no min() needed). The scale is a scalar, so it applies
    // to the BT.709 color directly (no round-trip matrix needed).
    color *= renodx::tonemap::neutwo::ComputeMaxChannelScale(
        renodx::color::bt2020::from::BT709(color), peak);
    return color;
  }

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

#endif

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_SHARED_H_
