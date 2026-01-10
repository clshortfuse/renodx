#ifndef SRC_DEADISLAND2_SHARED_H_
#define SRC_DEADISLAND2_SHARED_H_

// #define RENODX_TONE_MAP_TYPE           2.f
// #define RENODX_PEAK_WHITE_NITS         400.f
// #define RENODX_DIFFUSE_WHITE_NITS      100.f
// #define RENODX_GRAPHICS_WHITE_NITS     100.f
// #define RENODX_GAMMA_CORRECTION        1.f
// #define RENODX_TONE_MAP_HUE_CORRECTION 0.f
// #define RENODX_TONE_MAP_EXPOSURE       1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS     1.f
// #define RENODX_TONE_MAP_SHADOWS        1.f
// #define RENODX_TONE_MAP_CONTRAST       1.f
// #define RENODX_TONE_MAP_SATURATION     1.f
// #define RENODX_TONE_MAP_BLOWOUT        0.f
// #define CUSTOM_BLOOM                   1.f

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_under_ui;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_hue_correction;
  float gamma_correction;
  float tone_map_per_channel;

  float custom_bloom;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define TONEMAP_UNDER_UI                     shader_injection.tone_map_under_ui
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_BLOOM                         shader_injection.custom_bloom

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_DEADISLAND2_SHARED_H_
