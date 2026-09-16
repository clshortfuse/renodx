#ifndef SRC_STREETFIGHTER6_SHARED_H_
#define SRC_STREETFIGHTER6_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float tone_map_per_channel;

  float color_grade_hue_correction;
  float color_grade_blowout_restoration;

  float custom_sharpness;
  float custom_saturation_correction;

  float sf6_post_process_02;
  float sf6_post_process_03;
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
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE    2.f
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_GAMMA_CORRECTION              GAMMA_CORRECTION_GAMMA_2_2
#define RENODX_INTERMEDIATE_ENCODING         GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_DECODING           GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION   GAMMA_CORRECTION_GAMMA_2_2
#define RENODX_SWAP_CHAIN_COMPRESS_COLOR_SPACE 1.f
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET        1.f
#define CUSTOM_SHARPNESS                     shader_injection.custom_sharpness
#define CUSTOM_SATURATION_CORRECTION         shader_injection.custom_saturation_correction
#define SF6_POST_PROCESS_02                  shader_injection.sf6_post_process_02
#define SF6_POST_PROCESS_03                  shader_injection.sf6_post_process_03

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_STREETFIGHTER6_SHARED_H_
