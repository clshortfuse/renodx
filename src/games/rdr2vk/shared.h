#ifndef SRC_RDR2_SHARED_H_
#define SRC_RDR2_SHARED_H_

#define CLAMP_PEAK 1

struct ShaderInjectData {
  float tone_map_type;
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;

  float sdr_eotf_emulation;
  float tone_map_per_channel;
  float tone_map_blowout;
  float tone_map_hue_shift;

  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;
  float tone_map_contrast;

  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_flare;
  float tone_map_dechroma;

  float custom_lut_strength;
  float custom_vignette;
  float custom_dithering;
  float custom_random;

  float custom_grain_strength;
  float custom_lut_encoding;
  float custom_unclamp_highlights;
  // Keep total float count in multiples of 4 (16-byte blocks).
  float is_tonemapped;
};

#ifndef __cplusplus
layout(push_constant) uniform PushData {
  ShaderInjectData shader_injection;
};

#define RENODX_TONE_MAP_TYPE        shader_injection.tone_map_type
#define RENODX_PEAK_WHITE_NITS      shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS   shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS  shader_injection.graphics_white_nits
#define RENODX_SDR_EOTF_EMULATION   shader_injection.sdr_eotf_emulation
#define RENODX_TONE_MAP_PER_CHANNEL shader_injection.tone_map_per_channel
#define RENODX_TONE_MAP_BLOWOUT     shader_injection.tone_map_blowout
#define RENODX_TONE_MAP_HUE_SHIFT   shader_injection.tone_map_hue_shift

#define RENODX_TONE_MAP_EXPOSURE             shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS           shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS              shader_injection.tone_map_shadows
#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_FLARE                shader_injection.tone_map_flare
#define RENODX_TONE_MAP_DECHROMA             shader_injection.tone_map_dechroma

#define CUSTOM_LUT_STRENGTH shader_injection.custom_lut_strength

#define CUSTOM_VIGNETTE       shader_injection.custom_vignette
#define CUSTOM_RANDOM         shader_injection.custom_random
#define CUSTOM_DITHERING      shader_injection.custom_dithering
#define CUSTOM_GRAIN_STRENGTH shader_injection.custom_grain_strength

#define CUSTOM_LUT_ENCODING shader_injection.custom_lut_encoding

#define UNCLAMP_HIGHLIGHTS shader_injection.custom_unclamp_highlights

#define IS_TONEMAPPED shader_injection.is_tonemapped

#endif  // __cplusplus

#endif  // SRC_RDR2_SHARED_H_
