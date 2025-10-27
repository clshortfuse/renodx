#ifndef SRC_BATMAN_ARKHAMASYLUM_SHARED_H_
#define SRC_BATMAN_ARKHAMASYLUM_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float color_grade_strength;

  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;

  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;

  float tone_map_flare;
  float tone_map_hue_shift;
  float custom_bloom;
  float custom_lens_flare_type;

  float custom_random;
  float custom_grain_strength;
  float custom_fog_scaling;
  float tone_map_white_clip;
};

#ifndef __cplusplus
#if (__SHADER_TARGET_MAJOR == 3)

float4 shader_injection[5] : register(c50);

#define RENODX_PEAK_WHITE_NITS               shader_injection[0][0]
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection[0][1]
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection[0][2]
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection[0][3]
#define RENODX_TONE_MAP_TYPE                 shader_injection[1][0]
#define RENODX_TONE_MAP_EXPOSURE             shader_injection[1][1]
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection[1][2]
#define RENODX_TONE_MAP_SHADOWS              shader_injection[1][3]
#define RENODX_TONE_MAP_CONTRAST             shader_injection[2][0]
#define RENODX_TONE_MAP_SATURATION           shader_injection[2][1]
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection[2][2]
#define RENODX_TONE_MAP_BLOWOUT              shader_injection[2][3]
#define RENODX_TONE_MAP_FLARE                shader_injection[3][0]
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection[3][1]
#define CUSTOM_BLOOM                         shader_injection[3][2]
#define CUSTOM_LENS_FLARE_TYPE               shader_injection[3][3]
#define CUSTOM_RANDOM                        shader_injection[4][0]
#define CUSTOM_GRAIN_STRENGTH                shader_injection[4][1]
#define CUSTOM_FOG_SCALING                   shader_injection[4][2]
#define RENODX_TONE_MAP_WHITE_CLIP           shader_injection[4][3]

#else
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_LENS_FLARE_TYPE               shader_injection.custom_lens_flare_type
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define CUSTOM_GRAIN_STRENGTH                shader_injection.custom_grain_strength
#define CUSTOM_FOG_SCALING                   shader_injection.custom_fog_scaling
#define RENODX_TONE_MAP_WHITE_CLIP           shader_injection.tone_map_white_clip

#endif

#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_BATMAN_ARKHAMASYLUM_SHARED_H_
