#ifndef SRC_WUTHERINGWAVES_SHARED_H_
#define SRC_WUTHERINGWAVES_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_peak_nits;
  float tone_map_game_nits;
  float tone_map_ui_nits;
  float tone_map_video_nits;

  float color_grade_strength;
  float color_grade_blowout_restoration;
  float color_grade_hue_correction;
  float color_grade_saturation_correction;
  float color_grade_hue_shift;

  float tone_map_type;
  float tone_map_hdr_video;

  float color_grade_exposure;
  float color_grade_highlights;
  float color_grade_highlights_version;
  float color_grade_shadows;
  float color_grade_shadows_version;
  float color_grade_contrast;
  float color_grade_saturation;
  float color_grade_highlight_saturation;
  float color_grade_blowout;
  float color_grade_flare;

  float tone_map_hue_processor;

  float reno_drt_white_clip;

  float gamma_correction;
  float swap_chain_gamma_correction;
  float output_color_space;
  float processing_use_scrgb;

  float wuwa_tonemapper;
  float wuwa_ktm_sharpening;
  float wuwa_chromatic_aberration;
  float wuwa_bloom;
  float wuwa_blowout;

  float text_opacity;
  float status_text_opacity;
  float hud_opacity;
};

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer injected_buffer : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer injected_buffer : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#if (__SHADER_TARGET_MAJOR >= 6)
#pragma dxc diagnostic ignored "-Wparentheses-equality"
#endif

#define RENODX_PEAK_NITS                         shader_injection.tone_map_peak_nits
#define RENODX_GAME_NITS                         shader_injection.tone_map_game_nits
#define RENODX_UI_NITS                           shader_injection.tone_map_ui_nits
#define RENODX_VIDEO_NITS                        shader_injection.tone_map_video_nits

#define RENODX_COLOR_GRADE_STRENGTH              shader_injection.color_grade_strength
#define RENODX_PER_CHANNEL_BLOWOUT_RESTORATION   shader_injection.color_grade_blowout_restoration
#define RENODX_PER_CHANNEL_HUE_CORRECTION        shader_injection.color_grade_hue_correction
#define RENODX_PER_CHANNEL_CHROMINANCE_CORRECTION \
                                                 shader_injection.color_grade_saturation_correction
#define RENODX_PER_CHANNEL_HUE_SHIFT             shader_injection.color_grade_hue_shift

#define RENODX_TONE_MAP_TYPE                     shader_injection.tone_map_type
#define RENODX_TONE_MAP_HDR_VIDEO                shader_injection.tone_map_hdr_video

#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.color_grade_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.color_grade_highlights
#define RENODX_COLOR_GRADE_HIGHLIGHTS_VERSION    shader_injection.color_grade_highlights_version
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.color_grade_shadows
#define RENODX_COLOR_GRADE_SHADOWS_VERSION       shader_injection.color_grade_shadows_version
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.color_grade_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.color_grade_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.color_grade_highlight_saturation
#define RENODX_TONE_MAP_FLARE                    shader_injection.color_grade_flare

// #define RENODX_TONE_MAP_HUE_CORRECTION           1.f
#define RENODX_TONE_MAP_HUE_SHIFT                0.f
#define RENODX_TONE_MAP_HUE_SHIFT_METHOD         renodx::draw::HUE_SHIFT_METHOD_ACES_FITTED_BT709
// #define RENODX_TONE_MAP_HUE_SHIFT_MODIFIER       1.f
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE      renodx::color::convert::COLOR_SPACE_NONE
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE        renodx::color::convert::COLOR_SPACE_NONE
#define RENODX_TONE_MAP_CLAMP_PEAK               renodx::color::convert::COLOR_SPACE_NONE
#define RENODX_TONE_MAP_HUE_PROCESSOR            shader_injection.tone_map_hue_processor
// #define RENODX_TONE_MAP_PER_CHANNEL              0.f
#define RENODX_TONE_MAP_PASS_AUTOCORRECTION      1.f

#define RENODX_RENO_DRT_TONE_MAP_METHOD          renodx::tonemap::renodrt::config::tone_map_method::REINHARD
#define RENODX_RENO_DRT_WHITE_CLIP               shader_injection.reno_drt_white_clip

// Swapchain -------------------------------------------------------------------
#define RENODX_INTERMEDIATE_ENCODING             renodx::draw::ENCODING_SRGB
#define RENODX_SWAP_CHAIN_DECODING               RENODX_INTERMEDIATE_ENCODING

#define RENODX_GAMMA_CORRECTION                  shader_injection.gamma_correction
#define RENODX_SWAP_CHAIN_GAMMA_CORRECTION       shader_injection.swap_chain_gamma_correction

#define RENODX_INTERMEDIATE_SCALING              RENODX_GAME_NITS / RENODX_UI_NITS
#define RENODX_SWAP_CHAIN_SCALING_NITS           RENODX_UI_NITS
#define RENODX_SWAP_CHAIN_CLAMP_NITS             RENODX_PEAK_NITS

// if (clamp == UNKNOWN) {
//   decoding -> encoding
// } else {
//   if (clamp == encoding) {
//     decoding -> encoding
//     max(0, color)
//   } else {
//     if (clamp != decoding) {
//       decoding -> clamp
//     }
//     max(0, color)
//     clamp -> encoding
//   }
// }
#define RENODX_INTERMEDIATE_COLOR_SPACE          renodx::color::convert::COLOR_SPACE_BT709
#define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE      renodx::color::convert::COLOR_SPACE_BT2020
#define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE   RENODX_INTERMEDIATE_COLOR_SPACE
// Only used for HDR10
#define RENODX_OUTPUT_COLOR_SPACE                shader_injection.output_color_space
// Only used for scRGB
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE   (renodx::color::convert::COLOR_SPACE_BT2020 - shader_injection.processing_use_scrgb)

#define RENODX_SWAP_CHAIN_ENCODING               (renodx::draw::ENCODING_PQ + shader_injection.processing_use_scrgb)
// -----------------------------------------------------------------------------

#define RENODX_WUWA_TM                           shader_injection.wuwa_tonemapper
#define RENODX_WUWA_KTM_SHARPENING               shader_injection.wuwa_ktm_sharpening
#define RENODX_WUWA_CA                           1.f
#define RENODX_WUWA_BLOOM                        shader_injection.wuwa_bloom
#define RENODX_WUWA_GRAIN                        1.f
#define RENODX_WUWA_BLOWOUT                      shader_injection.wuwa_blowout

#define TEXT_OPACITY                             shader_injection.text_opacity
#define STATUS_TEXT_OPACITY                      shader_injection.status_text_opacity
#define HUD_OPACITY                              shader_injection.hud_opacity

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_WUTHERINGWAVES_SHARED_H_
