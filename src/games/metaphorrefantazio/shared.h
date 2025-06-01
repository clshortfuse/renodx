#ifndef SRC_METAPHOR_SHARED_H_
#define SRC_METAPHOR_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;
  float output_has_drawn;
  float lutbuilder_has_drawn;
  float godray_drawn_count;
  float swap_chain_custom_color_space;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE shader_injection.swap_chain_custom_color_space
#define RENODX_RENO_DRT_TONE_MAP_METHOD      renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_GAMMA_CORRECTION              GAMMA_CORRECTION_NONE
#define RENODX_INTERMEDIATE_ENCODING         GAMMA_CORRECTION_NONE
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION   GAMMA_CORRECTION_GAMMA_2_2
#define RENODX_TONE_MAP_HUE_PROCESSOR        renodx::draw::HUE_PROCESSOR_ICTCP
#define RENODX_TONE_MAP_HUE_SHIFT            1.f
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION  1.f
#define RENODX_TONE_MAP_PER_CHANNEL          0.f
#define CUSTOM_OUTPUT_SHADER_DRAWN           shader_injection.output_has_drawn
#define CUSTOM_LUTBUILDER_SHADER_DRAWN       shader_injection.lutbuilder_has_drawn
#define CUSTOM_GODRAY_SHADER_DRAWN_COUNT     shader_injection.godray_drawn_count

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_METAPHOR_SHARED_H_
