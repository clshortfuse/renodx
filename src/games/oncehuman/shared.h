#ifndef SRC_GAMES_ONCEHUMAN_SHARED_H_
#define SRC_GAMES_ONCEHUMAN_SHARED_H_

// 32-bit aligned, 4x32.
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
  float gamma_correction;
  float swap_chain_gamma_correction;
  float swap_chain_custom_color_space;
  float swap_chain_encoding;
  float swap_chain_encoding_color_space;
  // Post-processing effect strengths (1.0 = vanilla).
  float vignette_strength;
  float chromatic_aberration_strength;
  float bloom_strength;
};

#ifndef __cplusplus
// Injection cbuffer: b13 (DX11) / b13, space50 (DX12).
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#else
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
#define RENODX_TONE_MAP_HUE_CORRECTION       1.f
#define RENODX_TONE_MAP_HUE_SHIFT            0.5f
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE    0.f
#define RENODX_TONE_MAP_CLAMP_PEAK           0.f
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_COLOR_GRADE_STRENGTH          shader_injection.color_grade_strength
// Intermediate encoding / swap chain decoding derived from gamma correction (no UI slider).
#define RENODX_INTERMEDIATE_ENCODING         (shader_injection.gamma_correction + 1.f)
#define RENODX_SWAP_CHAIN_DECODING           (shader_injection.gamma_correction + 1.f)
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION   shader_injection.swap_chain_gamma_correction
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.swap_chain_custom_color_space
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE  1.f
#define RENODX_SWAP_CHAIN_ENCODING             shader_injection.swap_chain_encoding
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE shader_injection.swap_chain_encoding_color_space
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_ONCEHUMAN_SHARED_H_
