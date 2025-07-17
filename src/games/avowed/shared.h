#ifndef SRC_AVOWED_H_
#define SRC_AVOWED_H_

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
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_white_clip;
  float color_grade_hue_correction;
  float color_grade_saturation_correction;
  float color_grade_blowout_restoration;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                     shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS                   shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS                shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS               shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                  shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                    shader_injection.tone_map_flare
#define RENODX_RENO_DRT_WHITE_CLIP               shader_injection.tone_map_white_clip
#define RENODX_RENO_DRT_TONE_MAP_METHOD          renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION      1.f
#define CUSTOM_COLOR_GRADE_HUE_CORRECTION        1.f
#define CUSTOM_COLOR_GRADE_SATURATION_CORRECTION 1.f
#define CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION   0.5f
#define CUSTOM_COLOR_GRADE_HUE_SHIFT             0.5f
#define CUSTOM_LUT_OPTIMIZATION                  1.f
#define CUSTOM_GRAIN_TYPE                        0.f
#define CUSTOM_GRAIN_STRENGTH                    1.f
#define CUSTOM_RANDOM                            0.f
#define CUSTOM_LOCAL_EXPOSURE                    1.f

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_AVOWED_H_
