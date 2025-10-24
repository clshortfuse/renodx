#ifndef SRC_GAMES_CRONOSTHENEWDAWN_SHARED_H_
#define SRC_GAMES_CRONOSTHENEWDAWN_SHARED_H_

#define ENABLE_CUSTOM_COLOR_CORRECTION 1

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;
  float gamma_correction_ui;
  float tone_map_per_channel;
  float tone_map_hue_correction;
  float override_black_clip;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;
  float tone_map_flare;

  float shadow_color_offset_fix_type;
  float shadow_color_offset_brightness_bias;
  float color_offset_midtones_highliqhts;
  float shadow_color_offset_chrominance_restoration;

  float custom_sharpness;
};

#ifndef __cplusplus

cbuffer cb13 : register(b13, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_TONE_MAP_TYPE                          shader_injection.tone_map_type  // 0 - Vanilla, 1 - None, 2 - ACES, 3 - RenoDRT, 4 - SDR
#define RENODX_PEAK_WHITE_NITS                        shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS                     shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS                    shader_injection.graphics_white_nits
#define RENODX_GAMMA_CORRECTION                       shader_injection.gamma_correction
#define RENODX_GAMMA_CORRECTION_UI                    shader_injection.gamma_correction_ui
#define RENODX_TONE_MAP_PER_CHANNEL                   shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_HUE_CORRECTION                shader_injection.tone_map_hue_correction
#define RENODX_TONE_MAP_EXPOSURE                      shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS                    shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS                       shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST                      shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION                    shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION          shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT                       shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_FLARE                         shader_injection.tone_map_flare

#define SHADOW_COLOR_OFFSET_FIX_TYPE                  shader_injection.shadow_color_offset_fix_type
#define COLOR_OFFSET_MIDTONES_HIGHLIGHTS              shader_injection.color_offset_midtones_highliqhts
#define SHADOW_COLOR_OFFSET_BRIGHTNESS_BIAS           shader_injection.shadow_color_offset_brightness_bias
#define SHADOW_COLOR_OFFSET_CHROMINANCE_RESTORATION   shader_injection.shadow_color_offset_chrominance_restoration

#define CUSTOM_SHARPNESS                              shader_injection.custom_sharpness

#define OVERRIDE_BLACK_CLIP shader_injection.override_black_clip  // 0 - Off, 1 - 0.0001 nits

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_GAMES_CRONOSTHENEWDAWN_SHARED_H_
