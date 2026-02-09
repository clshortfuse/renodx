#ifndef SRC_ATELIERRYZADX_SHARED_H_
#define SRC_ATELIERRYZADX_SHARED_H_

#define RENODX_PEAK_WHITE_NITS               shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS            shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS           shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE                 shader_injection.tone_map_type
#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_HUE_CORRECTION       shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_HUE_SHIFT            shader_injection.tone_map_hue_shift
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE  shader_injection.tone_map_working_color_space
#define RENODX_TONE_MAP_HUE_PROCESSOR        shader_injection.tone_map_hue_processor
#define RENODX_TONE_MAP_PER_CHANNEL          shader_injection.tone_map_per_channel
#define RENODX_GAMMA_CORRECTION              shader_injection.gamma_correction
#define RENODX_TONE_MAP_HUE_SHIFT_METHOD     HUE_SHIFT_METHOD_SDR_MODIFIED
#define RENODX_TONE_MAP_HUE_SHIFT_MODIFIER   0.f
#define RENODX_SWAP_CHAIN_OUTPUT_PRESET      renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10
#define CUSTOM_SAT_STRENGTH                  shader_injection.custom_sat_strength
#define CUSTOM_SAT_BRIGHTNESS                shader_injection.custom_sat_brightness
#define CUSTOM_FLARE_EFFECT                  shader_injection.custom_flare_effect

#define RENODX_RENO_DRT_TONE_MAP_METHOD               renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_TONE_MAP_METHOD   renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_PEAK        -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_CLAMP_COLOR_SPACE -1.f
#define RENODX_RENO_DRT_NEUTRAL_SDR_WHITE_CLIP        20.f

//#define RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION 1
#define RENODX_COLOR_GRADE_SHADOWS_VERSION    1

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
  float custom_sat_strength;
  float custom_sat_brightness;
  float custom_flare_effect;
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

#endif  // SRC_ATELIERRYZADX_SHARED_H_