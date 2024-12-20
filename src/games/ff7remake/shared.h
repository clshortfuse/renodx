#ifndef SRC_FF7REMAKE_SHARED_H_
#define SRC_FF7REMAKE_SHARED_H_

#ifndef __cplusplus
#include "../../shaders/renodx.hlsl"
#endif

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float tone_map_type;
  float tone_map_peak_nits;
  float tone_map_game_nits;
  float tone_map_ui_nits;
  float tone_map_gamma_correction;
  float tone_map_hue_processor;
  float tone_map_hue_correction_method;
  float tone_map_hue_correction;
  float tone_map_per_channel;
  float color_grade_exposure;
  float color_grade_highlights;
  float color_grade_shadows;
  float color_grade_contrast;
  float color_grade_saturation;
  float color_grade_blowout;
  float color_grade_color_space;
  float color_grade_flare;
  float color_grade_lut_strength;
  float fx_bloom;
  float fx_vignette;
  float fx_film_grain;
  float fx_hdr_videos;
  float random_1;
  float random_2;
  float random_3;
};

#ifndef __cplusplus
cbuffer injectedBuffer : register(b0,space50) {
  ShaderInjectData injectedData : packoffset(c0);
}
#endif

#endif  // SRC_FF7REMAKE_SHARED_H_
