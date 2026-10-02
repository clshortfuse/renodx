#ifndef SRC_CONTROL_RESONANT_SHARED_H_
#define SRC_CONTROL_RESONANT_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;

  float tone_map_type;
  float tone_map_highlight_compression;
  float tone_map_highlights;
  float tone_map_contrast_highlights;

  float tone_map_shadows;
  float tone_map_contrast_shadows;
  float tone_map_contrast;
  float tone_map_saturation;

  float tone_map_highlight_saturation;
  float tone_map_dechroma;
  float tone_map_flare;

  float tone_map_gamut_clip;
  // float tone_map_secondary_primaries_scale;
};

#ifndef __cplusplus
cbuffer shader_injection : register(b0, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits

#define TONE_MAP_TYPE                      shader_injection.tone_map_type
#define TONE_MAP_HIGHLIGHT_COMPRESSION     shader_injection.tone_map_highlight_compression
#define TONE_MAP_GAMUT_CLIP                shader_injection.tone_map_gamut_clip
#define TONE_MAP_SECONDARY_PRIMARIES_SCALE 3.f

#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS  shader_injection.tone_map_contrast_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST_SHADOWS     shader_injection.tone_map_contrast_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_CONTROL_RESONANT_SHARED_H_