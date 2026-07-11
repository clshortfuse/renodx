#ifndef SRC_GAMES_UNREAL_EXTENDED_
#define SRC_GAMES_UNREAL_EXTENDED_

#define ENABLE_SLIDERS   1
#define FIX_POST_PROCESS 2

#define RENODX_TONE_MAP_TYPE                   shader_injection.tone_map_type  // 0 - Vanilla, 1 - None, 2 - ACES, 3 - RenoDRT, 4 - SDR
#define RENODX_PEAK_WHITE_NITS                 shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS              shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS             shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                shader_injection.gamma_correction
#define RENODX_GAMMA_CORRECTION_UI             shader_injection.gamma_correction_ui
#define RENODX_TONE_MAP_HUE_CORRECTION_TYPE    shader_injection.tone_map_hue_correction_type  // 0 - Highlights, Midtones, & Shadows, 1 - Midtones & Shadows
#define RENODX_TONE_MAP_HUE_CORRECTION         shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_PER_CH_PEAK            shader_injection.tone_map_per_ch_peak
#define RENODX_TONE_MAP_HUE_SHIFT              shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_EXPOSURE               shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS             shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST               shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION             shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_CHROMA_CORRECT_BLOWOUT shader_injection.tone_map_chroma_correct_blowout
#define RENODX_TONE_MAP_FLARE                  shader_injection.tone_map_flare
#define CUSTOM_LUT_STRENGTH                    shader_injection.custom_lut_strength
#define CUSTOM_LUT_SCALING                     shader_injection.custom_lut_scaling
#define CUSTOM_LUT_GAMUT_RESTORATION           shader_injection.custom_lut_gamut_restoration

#define CUSTOM_RANDOM         shader_injection.custom_random
#define CUSTOM_GRAIN_TYPE     shader_injection.custom_grain_type
#define CUSTOM_GRAIN_STRENGTH shader_injection.custom_grain_strength
#define CUSTOM_SHARPNESS      shader_injection.custom_sharpness
#define TONEMAP_UNDER_UI      shader_injection.tm_under_ui
#define CUSTOM_HIDE_UI        shader_injection.custom_hide_ui

#define RENODX_TONE_MAP_SCALING shader_injection.tone_map_scaling
#define BLEND_FACTOR            shader_injection.blend_factor

// #define FIX_POST_PROCESS                     shader_injection.fix_post_process     // 0 - BT.2020 PQ, 1 - BT.709 piecewise sRGB, 2 - BT.2020 piecewise sRGB
#define OVERRIDE_BLACK_CLIP shader_injection.override_black_clip   // 0 - Off, 1 - 0.0001 nits
#define PROCESSING_PATH     shader_injection.processing_path       // 0 hdr, 1 sdr // temp name
#define SWAP_CHAIN_ENCODING shader_injection.processing_use_scrgb  // 0 HDR10, 1 scRGB

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
  float tone_map_per_ch_peak;
  float tone_map_hue_shift;
  float tone_map_chroma_correct_blowout;
  float override_black_clip;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float custom_lut_strength;
  float custom_lut_scaling;
  float custom_lut_gamut_restoration;

  float custom_random;
  float custom_grain_type;
  float custom_grain_strength;
  float custom_sharpness;

  float tm_under_ui;
  float custom_hide_ui;

  // float fix_post_process;

  float processing_path;
  float processing_use_scrgb;

  float tone_map_scaling;
  float blend_factor;
};

#ifndef __cplusplus

#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injected_buffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injected_buffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_UNREAL_EXTENDED
