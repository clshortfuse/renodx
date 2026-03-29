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
  float color_grade_shadows;
  float color_grade_contrast;
  float color_grade_saturation;
  float color_grade_highlight_saturation;
  float color_grade_blowout;
  float color_grade_flare;
  float color_grade_gamma;
  float color_grade_contrast_highlights;
  float color_grade_contrast_shadows;
  float color_grade_adaptation_contrast;

  float tone_map_scaling;

  float reno_drt_white_clip;

  float gamma_correction;
  float swap_chain_gamma_correction;
  float processing_use_scrgb;

  float wuwa_tonemapper;
  float wuwa_ktm_sharpening;
  float wuwa_chromatic_aberration;
  float wuwa_bloom;
  float wuwa_blowout;
  float wuwa_hdr_sun;

  float ui_visibility;
  float text_opacity;
  float status_text_opacity;
  float hud_opacity;

  // Per-frame random seed (temporal dither/grain).
  float custom_random;
  float custom_random_pad0;
  float custom_random_pad1;
  float custom_random_pad2;
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

// PsychoV semantic aliases for legacy-bound controls.
#define RENODX_PSYCHOV_BLEND                     shader_injection.color_grade_strength
#define RENODX_PSYCHOV_HUE_RESTORE               shader_injection.color_grade_hue_correction
#define RENODX_PSYCHOV_PURITY_SCALE              shader_injection.color_grade_saturation_correction
#define RENODX_PSYCHOV_HIGHLIGHT_PURITY_BIAS     shader_injection.color_grade_hue_shift

#define RENODX_TONE_MAP_TYPE                     shader_injection.tone_map_type
#define RENODX_TONE_MAP_HDR_VIDEO                shader_injection.tone_map_hdr_video

#define RENODX_TONE_MAP_EXPOSURE                 shader_injection.color_grade_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS               shader_injection.color_grade_highlights
#define RENODX_TONE_MAP_SHADOWS                  shader_injection.color_grade_shadows
#define RENODX_TONE_MAP_CONTRAST                 shader_injection.color_grade_contrast
#define RENODX_TONE_MAP_SATURATION               shader_injection.color_grade_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION     shader_injection.color_grade_highlight_saturation
#define RENODX_TONE_MAP_FLARE                    shader_injection.color_grade_flare
#define RENODX_TONE_MAP_GAMMA                    shader_injection.color_grade_gamma
#define RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS      shader_injection.color_grade_contrast_highlights
#define RENODX_TONE_MAP_CONTRAST_SHADOWS         shader_injection.color_grade_contrast_shadows
#define RENODX_TONE_MAP_ADAPTATION_CONTRAST      shader_injection.color_grade_adaptation_contrast
#define RENODX_TONE_MAP_SCALING                  shader_injection.tone_map_scaling

// #define RENODX_TONE_MAP_HUE_CORRECTION           1.f
#define RENODX_TONE_MAP_HUE_SHIFT                0.f
#define RENODX_TONE_MAP_HUE_SHIFT_METHOD         renodx::draw::HUE_SHIFT_METHOD_ACES_FITTED_BT709
// #define RENODX_TONE_MAP_HUE_SHIFT_MODIFIER       1.f
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE      renodx::color::convert::COLOR_SPACE_NONE
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE        renodx::color::convert::COLOR_SPACE_NONE
#define RENODX_TONE_MAP_CLAMP_PEAK               renodx::color::convert::COLOR_SPACE_NONE
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
// Fixed to BT.709 -> BT.2020 conversion for HDR10 path.
#define RENODX_OUTPUT_COLOR_SPACE                0.f
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
#define RENODX_WUWA_HDR_SUN                      shader_injection.wuwa_hdr_sun

#define TEXT_OPACITY                             shader_injection.text_opacity * shader_injection.ui_visibility
#define STATUS_TEXT_OPACITY                      shader_injection.status_text_opacity * shader_injection.ui_visibility
#define HUD_OPACITY                              shader_injection.hud_opacity * shader_injection.ui_visibility

#define CUSTOM_RANDOM                            shader_injection.custom_random

#include "../../shaders/renodx.hlsl"
#endif

#endif  // SRC_WUTHERINGWAVES_SHARED_H_
