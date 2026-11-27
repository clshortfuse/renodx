#ifndef SRC_GAMES_GUARDIANSOFTHEGALAXY_SHARED_H_
#define SRC_GAMES_GUARDIANSOFTHEGALAXY_SHARED_H_

// Must be 32bit aligned. Field order must match the injected data in addon.cpp.
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_exposure;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_sdr_color;
  float tone_map_hue_clip;
  float gamma_correction;
  float sharpness;
  float hdr_output;
  float bloom_strength;
  float bloom_threshold;
  float bloom_saturation;
  float dof_upscale;
  float dof_dither;
  float bokeh_max_samples;
  float fog_black_preservation;
  float fog_scene_row_pixels;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE          shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS        shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS     shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS    shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_EXPOSURE      shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_CONTRAST      shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION    shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHTS    shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS       shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_SDR_COLOR     shader_injection.tone_map_sdr_color
#define RENODX_TONE_MAP_HUE_CLIP      shader_injection.tone_map_hue_clip
#define RENODX_GAMMA_CORRECTION       shader_injection.gamma_correction
#define RENODX_SHARPNESS              shader_injection.sharpness
#define RENODX_HDR_OUTPUT             shader_injection.hdr_output
#define RENODX_BLOOM_STRENGTH         shader_injection.bloom_strength
#define RENODX_BLOOM_THRESHOLD        shader_injection.bloom_threshold
#define RENODX_BLOOM_SATURATION       shader_injection.bloom_saturation
#define RENODX_DOF_UPSCALE            shader_injection.dof_upscale
#define RENODX_DOF_DITHER             shader_injection.dof_dither
#define RENODX_BOKEH_MAX_SAMPLES      shader_injection.bokeh_max_samples
#define RENODX_FOG_BLACK_PRESERVATION shader_injection.fog_black_preservation
#define RENODX_FOG_SCENE_ROW_PIXELS   shader_injection.fog_scene_row_pixels

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_GUARDIANSOFTHEGALAXY_SHARED_H_
