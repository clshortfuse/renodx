#ifndef SRC_ATLASFALLEN_SHARED_H_
#define SRC_ATLASFALLEN_SHARED_H_

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_CORRECTION       0.f
#define RENODX_TONE_MAP_HUE_SHIFT            0.f
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_SHIFT_METHOD     renodx::draw::HUE_SHIFT_METHOD_ACES_FITTED_BT709
#define RENODX_TONE_MAP_HUE_SHIFT_MODIFIER   0.f
#define RENODX_INTERMEDIATE_ENCODING         0.f
#define RENODX_SWAP_CHAIN_DECODING           0.f
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  renodx::color::convert::COLOR_SPACE_AP1
#define RENODX_PER_CHANNEL_CHROMINANCE_CORRECTION 0.f
#define RENODX_PER_CHANNEL_BLOWOUT_RESTORATION    0.f
#define RENODX_PER_CHANNEL_HUE_CORRECTION         0.f
#define CUSTOM_DISPLAY_MAP_TYPE                   shader_injection.custom_display_map_type
#define CUSTOM_CHROMATIC_ABERRATION               shader_injection.custom_chromatic_aberration
#define CUSTOM_TONEMAP_UPGRADE_TYPE               shader_injection.custom_tonemap_upgrade_type
#define CUSTOM_TONEMAP_UPGRADE_HUECORR            shader_injection.custom_tonemap_upgrade_huecorr
#define CUSTOM_TONEMAP_UPGRADE_STRENGTH           shader_injection.custom_tonemap_upgrade_strength

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
  float tone_map_working_color_space;
  float tone_map_hue_processor;
  float tone_map_per_channel;
  float gamma_correction;
  float scene_grade_saturation_correction;
  float scene_grade_blowout_restoration;
  float scene_grade_hue_correction;
  float scene_grade_strength;
  float custom_display_map_type;
  float custom_chromatic_aberration;
  float custom_tonemap_upgrade_type;
  float custom_tonemap_upgrade_huecorr;
  float custom_tonemap_upgrade_strength;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injected_buffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injected_buffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_ATLASFALLEN_SHARED_H_