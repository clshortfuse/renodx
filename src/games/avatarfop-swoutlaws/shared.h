#ifndef SRC_GAMES_AVATARFOP_SHARED_H_
#define SRC_GAMES_AVATARFOP_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float sdr_eotf_emulation;
  float sdr_eotf_emulation_ui;
  float tone_map_blowout;
  float tone_map_hue_shift;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_dechroma;
  float tone_map_flare;
  float custom_lut_strength;
  float custom_lut_scaling;
};

#ifndef __cplusplus

cbuffer cb13 : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_SDR_EOTF_EMULATION            shader_injection.sdr_eotf_emulation
#define RENODX_SDR_EOTF_EMULATION_UI         shader_injection.sdr_eotf_emulation_ui
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma

#include "../../shaders/renodx.hlsl"

#endif  // __cplusplus

#endif  // SRC_GAMES_AVATARFOP_SHARED_H_