#ifndef SRC_GAMES_DRAGONAGE_VEILGUARD_SHARED_H_
#define SRC_GAMES_DRAGONAGE_VEILGUARD_SHARED_H_

// Must be 32-bit aligned; keep the C++ and HLSL layouts identical.
struct ShaderInjectData {
  float tone_map_type;                  // ToneMapType: 0 Vanilla, 1 None, 2 ACES, 3 RenoDRT
  float peak_white_nits;                // ToneMapPeakNits
  float diffuse_white_nits;             // ToneMapGameNits
  float graphics_white_nits;            // ToneMapUINits
  float gamma_correction;               // ToneMapGammaCorrection: 0 off, 1 2.2, 2 2.4
  float tone_map_hue_processor;         // ToneMapHueProcessor: 0 OKLab, 1 ICtCp, 2 darktable UCS
  float tone_map_hue_correction;        // ToneMapHueCorrection
  float reno_drt_tone_map_method;       // ToneMapMethod: renodrt::config::tone_map_method
  float tone_map_exposure;              // ColorGradeExposure
  float tone_map_highlights;            // ColorGradeHighlights
  float tone_map_shadows;               // ColorGradeShadows
  float tone_map_contrast;              // ColorGradeContrast
  float tone_map_saturation;            // ColorGradeSaturation
  float tone_map_highlight_saturation;  // ColorGradeHighlightSaturation
  float tone_map_blowout;               // ColorGradeBlowout
  float tone_map_flare;                 // ColorGradeFlare
  float ui_eotf_emulation;              // UIEOTFEmulation: 0 off (sRGB), 1 2.2
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_RENO_DRT_TONE_MAP_METHOD      shader_injection.reno_drt_tone_map_method
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_UI_EOTF_EMULATION             shader_injection.ui_eotf_emulation

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_DRAGONAGE_VEILGUARD_SHARED_H_
