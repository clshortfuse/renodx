#version 450
#include "./shared.h"

layout(set = 1, binding = 2, std140) uniform ufBlock {
  int4 uf_remappedPS[1];
  float4 uf_fragCoordScale;
}
_409;

layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler2D textureUnitPS1;

layout(location = 0) in float4 passParameterSem0;
layout(location = 0) out float4 passPixelColor0;

float ComputeBotwSaturationGrade(float3 color, float grade_bias, float grade_scale) {
  float triangle = dot(color, float3(0.6666667)) - 1.0;
  return (1.0 - triangle * triangle) * grade_scale + grade_bias;
}

float3 ApplyBotwSaturationGrade(float3 color, float grade) {
  float peak_channel = renodx::math::Max(color);
  if (peak_channel <= 0.0) return float3(0.0);

  return peak_channel + (color - peak_channel.xxx) * grade;
}

float3 ComputeVanillaBlendedSdr(float3 untonemapped, float range = 1.f) {
  float lum_in = dot(untonemapped, float3(0.2989030703f, 0.5866198547f, 0.1144770751f));
  float lum_out = range * (1.f - exp(-lum_in / range));
  float3 tonemapped_lum = untonemapped * renodx::math::DivideSafe(lum_out, lum_in, 0.f);

  float3 tonemapped_perch = range * (1.f - exp(-untonemapped / range));

  float blend_weight = pow(saturate(lum_out), 2.f);
  float3 tonemapped = (lerp(tonemapped_lum, tonemapped_perch, blend_weight));

  return tonemapped;
}

// applies hues and chrominance from a tonemapped color onto untonemapped
float3 ComputeUntonemappedGraded(float3 untonemapped) {
  float tm_peak = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  float3 tonemapped = renodx::tonemap::ReinhardPiecewise(untonemapped, tm_peak);

  float3 untonemapped_graded = renodx::color::correct::Luminance(tonemapped, untonemapped);

  untonemapped_graded = renodx::color::correct::Hue(untonemapped_graded, ComputeVanillaBlendedSdr(untonemapped, 1), RENODX_COLOR_GRADE_STRENGTH);

  return untonemapped_graded;
}

void main() {
  float2 uv = passParameterSem0.xy;
  float alpha = passParameterSem0.w;
  float3 glow = texture(textureUnitPS0, uv).xyz;
  float3 raw = texture(textureUnitPS1, uv).xyz;
  float3 untonemapped = glow + raw;

  float3 vanilla_blended_sdr;
  float maxch_scale;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    vanilla_blended_sdr = ComputeVanillaBlendedSdr(untonemapped);
    vanilla_blended_sdr = saturate(vanilla_blended_sdr);
    maxch_scale = 1.f;
  } else {
    vanilla_blended_sdr = ComputeUntonemappedGraded(untonemapped);
    maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(vanilla_blended_sdr);
  }

  float saturation_grade_bias = intBitsToFloat(_409.uf_remappedPS[0].x);
  float saturation_grade_scale = intBitsToFloat(_409.uf_remappedPS[0].y) * VANILLA_SATURATION;

  vanilla_blended_sdr *= maxch_scale;
  float vanilla_saturation_grade = ComputeBotwSaturationGrade(vanilla_blended_sdr, saturation_grade_bias, saturation_grade_scale);
  float3 output = ApplyBotwSaturationGrade(vanilla_blended_sdr, vanilla_saturation_grade);
  output /= maxch_scale;

  output = (CUSTOM_TONEMAP_CLAMP == 1.f)
               ? renodx::color::bt709::clamp::AP1(output)
               : renodx::color::bt709::clamp::BT709(output);

  // output = renodx::draw::ToneMapPass(output);
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);

  output = renodx::color::grade::config::ApplyUserColorGrading(output, cg_config);
  output = renodx::tonemap::neutwo::MaxChannel(output, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  passPixelColor0 = float4(renodx::draw::RenderIntermediatePass(output), alpha);
}