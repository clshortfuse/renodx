#ifndef AssassinsCreedLiberation_SHARED_H_
#define AssassinsCreedLiberation_SHARED_H_
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#define RENODX_RENDER_MODE                   shader_injection.render_mode_setting
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_WHITE_CLIP           shader_injection.white_clip
#define CUSTOM_HDR_BOOST                     shader_injection.hdr_boost

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#define RENODX_GAMMA_CORRECTION               0.f

#define CUSTOM_GRADING_STRENGTH              shader_injection.custom_grading_strength
//#define CUSTOM_SCENE_GRADE_PEAK              shader_injection.scene_grade_peak
#define CUSTOM_SCENE_GRADE_METHOD              shader_injection.scene_grade_method
#define CUSTOM_SCENE_GRADE_PER_CHANNEL_BLOWOUT shader_injection.scene_grade_per_channel_blowout
#define CUSTOM_SCENE_GRADE_HUE_SHIFT           shader_injection.scene_grade_hue_shift
#define CUSTOM_FILM_GRAIN_STRENGTH             shader_injection.custom_film_grain
#define CUSTOM_RANDOM                        shader_injection.custom_random
#define CUSTOM_BLOOM                         shader_injection.custom_bloom
#define CUSTOM_LENS_DIRT                     shader_injection.custom_lens_dirt
#define CUSTOM_FOG_DENSITY                   shader_injection.custom_fog_density

#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_DECODING           2.f // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
#define RENODX_INTERMEDIATE_ENCODING         2.f // 0 = linear, 1 = srgb, 2 = 2.2, 3 = 2.4, 4 = pq
#define RENODX_SWAP_CHAIN_ENCODING             renodx::draw::ENCODING_PQ
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT2020
#define CUSTOM_GRADING_STRENGTH shader_injection.color_grade_strength
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
  float tone_map_hue_correction;
  float tone_map_hue_shift;
  float tone_map_working_color_space;
  float tone_map_clamp_color_space;
  float tone_map_clamp_peak;
  float tone_map_hue_processor;
  float tone_map_per_channel;
  float gamma_correction;
  float intermediate_scaling;
  float intermediate_encoding;
  float intermediate_color_space;
  float swap_chain_decoding;
  float swap_chain_gamma_correction;
  //  float swap_chain_decoding_color_space;
  float swap_chain_custom_color_space;
  // float swap_chain_scaling_nits;
  // float swap_chain_clamp_nits;
  float swap_chain_clamp_color_space;
  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  float custom_flip_uv_y;
  float render_mode_setting;
  float white_clip;

  //float scene_grade_peak;
  float scene_grade_method;
  float scene_grade_per_channel_blowout;
  float scene_grade_hue_shift;
  float custom_grading_strength;
  float hdr_boost;
  float custom_film_grain;
  float custom_random;
  float custom_bloom;
  float custom_lens_dirt;
  float custom_fog_density;

  // PsychoV22 controls, appended so the existing layout stays stable.
  float psychov22_compression;
  float psychov22_gamut_compression;
  float psychov22_gamut_mode;
  float psychov22_cone_response;
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
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE    shader_injection.tone_map_clamp_color_space
#define RENODX_TONE_MAP_CLAMP_PEAK           shader_injection.tone_map_clamp_peak
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV22
#define RENODX_TONE_MAP_TYPE_PSYCHOV22       22.f
#endif
#ifndef RENODX_PSYCHOV22_COMPRESSION
#define RENODX_PSYCHOV22_COMPRESSION         shader_injection.psychov22_compression
#endif
#ifndef RENODX_PSYCHOV22_GAMUT_COMPRESSION
#define RENODX_PSYCHOV22_GAMUT_COMPRESSION   shader_injection.psychov22_gamut_compression
#endif
#ifndef RENODX_PSYCHOV22_GAMUT_MODE
#define RENODX_PSYCHOV22_GAMUT_MODE          shader_injection.psychov22_gamut_mode
#endif
#ifndef RENODX_PSYCHOV22_CONE_RESPONSE
#define RENODX_PSYCHOV22_CONE_RESPONSE       shader_injection.psychov22_cone_response
#endif
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_INTERMEDIATE_ENCODING         shader_injection.intermediate_encoding
#define RENODX_SWAP_CHAIN_DECODING           shader_injection.swap_chain_decoding
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION   shader_injection.swap_chain_gamma_correction
// #define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE shader_injection.swap_chain_decoding_color_space
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.swap_chain_custom_color_space
// #define RENODX_SWAP_CHAIN_SCALING_NITS         shader_injection.swap_chain_scaling_nits
// #define RENODX_SWAP_CHAIN_CLAMP_NITS           shader_injection.swap_chain_clamp_nits
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    shader_injection.swap_chain_clamp_color_space
#define RENODX_SWAP_CHAIN_ENCODING             shader_injection.swap_chain_encoding
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE shader_injection.swap_chain_encoding_color_space
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
