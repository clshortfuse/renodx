#ifndef SRC_GAMES_GHOSTWIRETOKYO_SHARED_H_
#define SRC_GAMES_GHOSTWIRETOKYO_SHARED_H_

#define ENABLE_SLIDERS 1

#if ENABLE_SLIDERS
// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float gamma_correction_ui;
  float tone_map_hue_correction_type;
  float tone_map_hue_correction;
  float override_black_clip;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
};
#endif

#ifndef __cplusplus

#if ENABLE_SLIDERS
cbuffer shader_injection : register(b12) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type  // 0 - Vanilla, 1 - None, 2 - ACES, 3 - RenoDRT, 4 - SDR
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_GAMMA_CORRECTION_UI           shader_injection.gamma_correction_ui
#define RENODX_TONE_MAP_HUE_CORRECTION_TYPE  shader_injection.tone_map_hue_correction_type  // 0 - Highlights, Midtones, & Shadows, 1 - Midtones & Shadows
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define OVERRIDE_BLACK_CLIP                  shader_injection.override_black_clip  // 0 - Off, 1 - 0.0001 nits
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#else

#define RENODX_TONE_MAP_TYPE                 3.f  // 0 - Vanilla, 1 - None, 2 - ACES, 3 - Vanilla+, 4 - SDR
#define RENODX_PEAK_WHITE_NITS               400.f
#define RENODX_DIFFUSE_WHITE_NITS            100.f
#define RENODX_GRAPHICS_WHITE_NITS           100.f
#define RENODX_GAMMA_CORRECTION              1.f
#define RENODX_GAMMA_CORRECTION_UI           1.f
#define RENODX_TONE_MAP_HUE_CORRECTION_TYPE  1.f
#define RENODX_TONE_MAP_HUE_CORRECTION       0.f
#define OVERRIDE_BLACK_CLIP                  1.f  // 0 - Off, 1 - 0.0001 nits
#define RENODX_TONE_MAP_EXPOSURE             1.f
#define RENODX_TONE_MAP_HIGHLIGHTS           1.f
#define RENODX_TONE_MAP_SHADOWS              1.f
#define RENODX_TONE_MAP_CONTRAST             1.f
#define RENODX_TONE_MAP_SATURATION           1.f
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 1.f
#define RENODX_TONE_MAP_BLOWOUT              0.f
#define RENODX_TONE_MAP_FLARE                0.f
#define CUSTOM_LUT_STRENGTH                  1.f
#define CUSTOM_LUT_SCALING                   1.f

#define CUSTOM_RANDOM         0.f
#define CUSTOM_GRAIN_TYPE     0.f
#define CUSTOM_GRAIN_STRENGTH 0.f
#define CUSTOM_SHARPNESS      0.f

#define FIX_POST_PROCESS 2.f  // 0 - BT.2020 PQ, 1 - BT.709 piecewise sRGB, 2 - BT.2020 piecewise sRGB

#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_GHOSTWIRETOKYO_SHARED_H_
