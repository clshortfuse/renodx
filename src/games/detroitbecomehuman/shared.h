#ifndef SRC_DETROITBECOMEHUMAN_SHARED_H_
#define SRC_DETROITBECOMEHUMAN_SHARED_H_

// Persisted setting values. Append new tone mappers; never renumber the
// existing Vanilla/Reinhard/RenoDRT entries stored in ReShadePreset.ini.
#define DETROIT_TONE_MAP_TYPE_VANILLA           0.f
#define DETROIT_TONE_MAP_TYPE_REINHARD          1.f
#define DETROIT_TONE_MAP_TYPE_RENO_DRT          2.f
#define DETROIT_TONE_MAP_TYPE_AGX               3.f
#define DETROIT_TONE_MAP_TYPE_ACES_FITTED       4.f
#define DETROIT_TONE_MAP_TYPE_LOTTES            5.f
#define DETROIT_TONE_MAP_TYPE_HABLE             6.f
#define DETROIT_TONE_MAP_TYPE_KHRONOS_PBR       7.f
#define DETROIT_TONE_MAP_TYPE_PSYCHOV_22        8.f
#define DETROIT_TONE_MAP_TYPE_DETROIT_DRT       9.f
#define DETROIT_TONE_MAP_TYPE_MAX               DETROIT_TONE_MAP_TYPE_DETROIT_DRT

// Vulkan push-constant payload. Keep this 16-byte aligned and small enough to
// coexist with Detroit's original push-constant ranges.
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_type;

  float output_mode;
  float output_is_hdr;
  float tone_map_exposure;
  float tone_map_highlights;

  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;

  float tone_map_blowout;
  float tone_map_flare;
  float color_grade_strength;
  float cas_mode;

  float cas_strength;
  float scene_path_active;
  float ui_path_active;
  float reserved;
};

#ifdef __cplusplus
static_assert(sizeof(ShaderInjectData) == 80u);
#endif

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 (shader_injection.tone_map_type == DETROIT_TONE_MAP_TYPE_VANILLA \
                                                  ? renodx::tonemap::config::type::VANILLA \
                                                  : (shader_injection.tone_map_type <= DETROIT_TONE_MAP_TYPE_RENO_DRT \
                                                         ? renodx::tonemap::config::type::RENODRT \
                                                         : renodx::tonemap::config::type::VANILLA))
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_RENO_DRT_TONE_MAP_METHOD      (shader_injection.tone_map_type == DETROIT_TONE_MAP_TYPE_REINHARD \
                                                  ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD \
                                                  : renodx::tonemap::renodrt::config::tone_map_method::DANIELE)

#define CUSTOM_TONE_MAP_TYPE        shader_injection.tone_map_type
#define CUSTOM_TONE_MAP_IS_EXTENDED (shader_injection.tone_map_type >= DETROIT_TONE_MAP_TYPE_AGX)

#define CUSTOM_OUTPUT_MODE       shader_injection.output_mode
#define CUSTOM_OUTPUT_IS_HDR     shader_injection.output_is_hdr
#define CUSTOM_CAS_MODE          shader_injection.cas_mode
#define CUSTOM_CAS_STRENGTH      shader_injection.cas_strength
#define CUSTOM_SCENE_PATH_ACTIVE shader_injection.scene_path_active
#define CUSTOM_UI_PATH_ACTIVE    shader_injection.ui_path_active
#define CUSTOM_HDR_ACTIVE        (shader_injection.output_is_hdr >= 0.5f \
                                  && shader_injection.output_mode != 1.f)

#ifndef __cplusplus
#ifdef __SLANG__
layout(push_constant) uniform PushData {
  ShaderInjectData shader_injection;
}
#else
#error Detroit Vulkan replacements must be compiled from Slang.
#endif

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_DETROITBECOMEHUMAN_SHARED_H_
