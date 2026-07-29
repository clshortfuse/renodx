#ifndef SRC_GAMES_MASSEFFECTANDROMEDA_SHARED_H_
#define SRC_GAMES_MASSEFFECTANDROMEDA_SHARED_H_

struct ShaderInjectData {
  float toneMapType;                    // 0 = Vanilla, 1 = Vanilla+ (faithful), 2 = Vanilla+ (Neutwo), 3 = Vanilla+ (Psycho v24)
  float toneMapPeakNits;                // display peak the roll-off pins highlights to (Vanilla+)
  float toneMapGameNits;                // diffuse-white (paper white) nits; Vanilla pins 100
  float toneMapUINits;                  // UI/HUD white nits; Vanilla pins 100
  float colorGradeExposure;             // pre-tonemap exposure scale (1.0 = vanilla)
  float colorGradeHighlights;           // 1.0 = vanilla
  float colorGradeShadows;              // 1.0 = vanilla
  float colorGradeContrast;             // 1.0 = vanilla
  float colorGradeSaturation;           // 1.0 = vanilla; test24 routes this through purity_scale instead
  float colorGradeHighlightSaturation;  // 1.0 = vanilla; >1 boosts highlight color, <1 blows out to white
  float colorGradeFlare;                // flare/glare compensation (0 = vanilla/off)
  float colorGradeHueShift;             // 0 = keep BioWare hue, >0 = blend highlights toward per-channel hue
  float gammaCorrection;                // 0 = Off, 1 = 2.2, 2 = BT.1886 (2.4); RenoDX per-channel gamma correction
  float fxBloom;                        // additive bloom scale (1.0 = vanilla)
  float fxVignette;                     // vignette strength (1.0 = vanilla, 0 = off)
  float fxChromaticAberration;          // chromatic aberration strength (1.0 = vanilla, 0 = off)
  float fxFilmGrain;                    // perceptual film grain strength (0 = off)
  float fxFilmGrainType;                // 0 = Vanilla (game grain), 1 = Monochrome (luminance), 2 = Colored (per-channel)
  float fxHDRVideos;                    // 0 = Off, 1 = On (BT.2446a inverse tone map on FMV); target = fxVideoNits
  float fxVideoActive;                  // runtime flag: an FMV decode pass ran this frame
  float fxSharpness;                    // Lilium HDR RCAS strength (0 = off), Vanilla+ only
  float fxSwapchainPresent;             // runtime flag: 1 when the present draw targets the swapchain (RCAS gate)
  float customRandom;                   // per-frame random seed for perceptual grain
  float customLutTetrahedral;           // 0 = Trilinear (vanilla), 1 = Tetrahedral
  float fxVideoNits;                    // FMV inverse-tone-map target in nits (video white lands on it); clamped to [paper white, peak]
};

#define TONE_MAP_VANILLA             0.f
#define TONE_MAP_VANILLA_PLUS        1.f  // faithful log2 highlight roll-off
#define TONE_MAP_VANILLA_PLUS_NEUTWO 2.f  // knee-free Neutwo highlight curve (continuous, no identity segment)
#define TONE_MAP_VANILLA_PLUS_TEST24 3.f  // PsychoV test24 perceptual observer-model curve (experimental)

#define FILM_GRAIN_VANILLA     0.f
#define FILM_GRAIN_LUMINANCE   1.f
#define FILM_GRAIN_PER_CHANNEL 2.f

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData injectedData : packoffset(c0);
}

#define CUSTOM_SHARPNESS injectedData.fxSharpness

bool IsVanillaPlus() {
  return injectedData.toneMapType != TONE_MAP_VANILLA;
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_MASSEFFECTANDROMEDA_SHARED_H_
