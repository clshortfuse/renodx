#ifndef RENODX_UNREAL_LUT_BUILDER_CONFIG_HLSLI_
#define RENODX_UNREAL_LUT_BUILDER_CONFIG_HLSLI_

#include "../common.hlsli"

namespace unrealengine {
namespace lutbuilder {

struct ColorCorrectionRegionConfig {
  float4 saturation;
  float4 contrast;
  float4 gamma;
  float4 gain;
  float4 offset;
};

struct ColorCorrectionConfig {
  ColorCorrectionRegionConfig global;
  ColorCorrectionRegionConfig shadows;
  ColorCorrectionRegionConfig midtones;
  ColorCorrectionRegionConfig highlights;
  float shadows_max;
  float highlights_min;
  float highlights_max;
};

struct FilmToneMapConfig {
  float blue_correction;
  float tone_curve_amount;
  float slope;
  float toe;
  float shoulder;
  float black_clip;
  float white_clip;
};

struct PostGradeConfig {
  float4 overlay_color;
  float3 color_scale;
  float3 mapping_polynomial;
  float inverse_gamma;
};

struct OutputConfig {
  float inverse_gamma;
  int output_device;
  int output_gamut;
  float3 working_to_ap1_row_0;
  float3 working_to_ap1_row_1;
  float3 working_to_ap1_row_2;
  float3 working_from_ap1_row_0;
  float3 working_from_ap1_row_1;
  float3 working_from_ap1_row_2;
  int working_is_srgb;
};

struct Config {
  ColorCorrectionConfig color_correction;
  FilmToneMapConfig film;
  PostGradeConfig post_grade;
  OutputConfig output;
};

namespace config {

Config Create() {
  Config lutbuilder_config;

  lutbuilder_config.color_correction.global.saturation = 1.f;
  lutbuilder_config.color_correction.global.contrast = 1.f;
  lutbuilder_config.color_correction.global.gamma = 1.f;
  lutbuilder_config.color_correction.global.gain = 1.f;
  lutbuilder_config.color_correction.global.offset = 0.f;
  lutbuilder_config.color_correction.shadows = lutbuilder_config.color_correction.global;
  lutbuilder_config.color_correction.midtones = lutbuilder_config.color_correction.global;
  lutbuilder_config.color_correction.highlights = lutbuilder_config.color_correction.global;
  lutbuilder_config.color_correction.shadows_max = 1.f;
  lutbuilder_config.color_correction.highlights_min = 0.f;
  lutbuilder_config.color_correction.highlights_max = 1.f;

  lutbuilder_config.film.blue_correction = 0.f;
  lutbuilder_config.film.tone_curve_amount = 1.f;
  lutbuilder_config.film.slope = 0.f;
  lutbuilder_config.film.toe = 0.f;
  lutbuilder_config.film.shoulder = 0.f;
  lutbuilder_config.film.black_clip = 0.f;
  lutbuilder_config.film.white_clip = 0.f;

  lutbuilder_config.post_grade.overlay_color = 0.f;
  lutbuilder_config.post_grade.color_scale = 1.f;
  lutbuilder_config.post_grade.mapping_polynomial = float3(0.f, 1.f, 0.f);
  lutbuilder_config.post_grade.inverse_gamma = 1.f;

  lutbuilder_config.output.inverse_gamma = 1.f / 2.2f;
  lutbuilder_config.output.output_device = 0;
  lutbuilder_config.output.output_gamut = 0;
  lutbuilder_config.output.working_to_ap1_row_0 = float3(1.f, 0.f, 0.f);
  lutbuilder_config.output.working_to_ap1_row_1 = float3(0.f, 1.f, 0.f);
  lutbuilder_config.output.working_to_ap1_row_2 = float3(0.f, 0.f, 1.f);
  lutbuilder_config.output.working_from_ap1_row_0 = float3(1.f, 0.f, 0.f);
  lutbuilder_config.output.working_from_ap1_row_1 = float3(0.f, 1.f, 0.f);
  lutbuilder_config.output.working_from_ap1_row_2 = float3(0.f, 0.f, 1.f);
  lutbuilder_config.output.working_is_srgb = 1;

  return lutbuilder_config;
}

}  // namespace config
}  // namespace lutbuilder
}  // namespace unrealengine

#endif  // RENODX_UNREAL_LUT_BUILDER_CONFIG_HLSLI_