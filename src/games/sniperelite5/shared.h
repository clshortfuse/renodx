#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

// Must be 32bit aligned
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
  float gamma_correction;
  float intermediate_encoding;
  float swap_chain_decoding;
  float swap_chain_gamma_correction;
  float swap_chain_custom_color_space;
  float swap_chain_clamp_color_space;
  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  float custom_auto_exposure_brighten;
  float custom_auto_exposure_darken;
  float custom_bloom;
  float custom_god_rays;
  float custom_motion_blur;
  float custom_sharpening;
  float custom_lut_strength;
  float custom_lut_tetrahedral;
  float custom_smaa_ultra;
  float custom_aa_highlight_weight;
  float custom_auto_exposure_metering;
  float custom_auto_exposure_centre_weight;
  float custom_auto_exposure_ignore_bright;
  float custom_auto_exposure_ignore_dark;
  float custom_auto_exposure_speed;
  float custom_auto_exposure_limit_brighten;
  float custom_auto_exposure_limit_darken;
  float custom_lens_dirt;
  float custom_motion_blur_quality;
  float custom_film_grain;
  float custom_random;
  float custom_depth_edges;
  float custom_highlight_colour;
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
#define RENODX_TONE_MAP_PER_CHANNEL          0.f
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  0.f
#define RENODX_TONE_MAP_HUE_PROCESSOR        0.f
#define RENODX_TONE_MAP_HUE_CORRECTION       0.f
#define RENODX_TONE_MAP_HUE_SHIFT            0.f
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE    0.f
#define RENODX_TONE_MAP_CLAMP_PEAK           0.f
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION 0.f
#define RENODX_TONE_MAP_BLOWOUT              0.f
#define RENODX_TONE_MAP_FLARE                0.f
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
#define RENODX_INTERMEDIATE_ENCODING         shader_injection.intermediate_encoding
#define RENODX_SWAP_CHAIN_DECODING           shader_injection.swap_chain_decoding
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION   shader_injection.swap_chain_gamma_correction
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    shader_injection.swap_chain_clamp_color_space
#define RENODX_SWAP_CHAIN_ENCODING             shader_injection.swap_chain_encoding
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE shader_injection.swap_chain_encoding_color_space
#define CUSTOM_AUTO_EXPOSURE_BRIGHTEN          shader_injection.custom_auto_exposure_brighten
#define CUSTOM_AUTO_EXPOSURE_DARKEN            shader_injection.custom_auto_exposure_darken
#define CUSTOM_BLOOM                           shader_injection.custom_bloom
#define CUSTOM_GOD_RAYS                        shader_injection.custom_god_rays
#define CUSTOM_MOTION_BLUR                     shader_injection.custom_motion_blur
#define CUSTOM_SHARPENING                      shader_injection.custom_sharpening
#define CUSTOM_LUT_STRENGTH                    shader_injection.custom_lut_strength
#define CUSTOM_LUT_TETRAHEDRAL                 shader_injection.custom_lut_tetrahedral
#define CUSTOM_SMAA_ULTRA                      shader_injection.custom_smaa_ultra
#define CUSTOM_AA_HIGHLIGHT_WEIGHT             shader_injection.custom_aa_highlight_weight
#define CUSTOM_AUTO_EXPOSURE_METERING          shader_injection.custom_auto_exposure_metering
#define CUSTOM_AUTO_EXPOSURE_CENTRE_WEIGHT     shader_injection.custom_auto_exposure_centre_weight
#define CUSTOM_AUTO_EXPOSURE_IGNORE_BRIGHT     shader_injection.custom_auto_exposure_ignore_bright
#define CUSTOM_AUTO_EXPOSURE_IGNORE_DARK       shader_injection.custom_auto_exposure_ignore_dark
#define CUSTOM_AUTO_EXPOSURE_SPEED             shader_injection.custom_auto_exposure_speed
#define CUSTOM_AUTO_EXPOSURE_LIMIT_BRIGHTEN    shader_injection.custom_auto_exposure_limit_brighten
#define CUSTOM_AUTO_EXPOSURE_LIMIT_DARKEN      shader_injection.custom_auto_exposure_limit_darken
#define CUSTOM_LENS_DIRT                       shader_injection.custom_lens_dirt
#define CUSTOM_MOTION_BLUR_QUALITY             shader_injection.custom_motion_blur_quality
#define CUSTOM_FILM_GRAIN                      shader_injection.custom_film_grain
#define CUSTOM_RANDOM                          shader_injection.custom_random
#define CUSTOM_DEPTH_EDGES                     shader_injection.custom_depth_edges
#define CUSTOM_HIGHLIGHT_COLOUR                shader_injection.custom_highlight_colour

#include "../../shaders/renodx.hlsl"

// RenoDX: the mod's RGBA16F clone of the albedo G-buffer can't hold material IDs (k/255) exactly
bool MaterialIdEquals(float alpha, float id) { return abs(alpha - id) < 0.5f / 255.f; }

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
