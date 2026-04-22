#version 450
#include "./psycho_test17_custom.hlsli"
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

float3 ApplySaturationGrading(float3 color, float grade_bias, float grade_scale) {
  float triangle = dot(color, float3(2.f / 3.f)) - 1.0;
  float grade = (1.0 - triangle * triangle) * grade_scale + grade_bias;

  float peak_channel = renodx::math::Max(color);
  if (peak_channel <= 0.0) return float3(0.0);

  return peak_channel + (color - peak_channel.xxx) * grade;
}

#define VANILLA_TONE_CURVE_FUNCTION_GENERATOR(T)                                      \
  T VanillaCurve(T x, float range = 1.f) {                                            \
    return range * (1.f - exp(-x / range));                                           \
  }                                                                                   \
                                                                                      \
  T VanillaToneCurveDerivative(T x, float range = 1.f) {                              \
    return exp(-x / range);                                                           \
  }                                                                                   \
                                                                                      \
  T VanillaToneCurveExtended(T x, float range = 1.f, float pivot_point = 0.567143f) { \
    float y0 = VanillaCurve(pivot_point, range);                                      \
    float m0 = VanillaToneCurveDerivative(pivot_point, range);                        \
    return renodx::math::Select(                                                      \
        x <= pivot_point,                                                             \
        VanillaCurve(x, range),                                                       \
        y0 + m0 * (x - pivot_point));                                                 \
  }

VANILLA_TONE_CURVE_FUNCTION_GENERATOR(float)
VANILLA_TONE_CURVE_FUNCTION_GENERATOR(float3)

#undef VANILLA_TONE_CURVE_FUNCTION_GENERATOR

renodx_custom::tonemap::psycho::config17::Config BuildPsycho17Config() {
  renodx_custom::tonemap::psycho::config17::Config config =
      renodx_custom::tonemap::psycho::config17::Create();
  config.peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  config.clip_point = 100.f;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.gamma = 1.f;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.contrast_highlights = 1.f;
  config.contrast_shadows = 1.f;
  config.purity_scale = RENODX_TONE_MAP_SATURATION;
  config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.adaptation_contrast = 1.f;
  config.bleaching_intensity = 0.f;
  config.hue_emulation = 0.f;
  config.pre_gamut_compress = false;
  config.post_gamut_compress = true;
  config.apply_lms_tonemap = false;
  config.apply_maxch_tonemap = false;
  return config;
}

float3 ApplyVanillaToneMap(float3 untonemapped, float range = 1.f) {
  float lum_in = renodx::color::luma::from::BT601(untonemapped);
  float lum_out = range * (1.f - exp(-lum_in / range));
  float3 tonemapped_lum = untonemapped * renodx::math::DivideSafe(lum_out, lum_in, 0.f);

  float3 tonemapped_perch = range * (1.f - exp(-untonemapped / range));

  float blend_weight = pow(saturate(lum_out), 2.f);
  float3 tonemapped = lerp(tonemapped_lum, tonemapped_perch, blend_weight);

  return tonemapped;
}

float3 ApplyVanillaToneMapExtended(float3 untonemapped, float range = 1.f, float pivot_point = 0.18f) {
  float lum_in = renodx::color::luma::from::BT601(untonemapped);
  float lum_out = VanillaToneCurveExtended(lum_in, range, pivot_point);
  float3 tonemapped_lum = untonemapped * renodx::math::DivideSafe(lum_out, lum_in, 0.f);

  float3 tonemapped_perch = VanillaToneCurveExtended(untonemapped, range, pivot_point);

  float blend_weight = range * (1.f - exp(-lum_in / range));
  blend_weight = pow(saturate(blend_weight), 2.f);
  float3 tonemapped = lerp(tonemapped_lum, tonemapped_perch, blend_weight);

  return tonemapped;
}

// applies hues and chrominance from a tonemapped color onto untonemapped
float3 ComputeUntonemappedGraded(float3 untonemapped) {
  float3 untonemapped_graded = ApplyVanillaToneMapExtended(untonemapped, 1.f, RENODX_TONE_MAP_SDR_BLEND_FACTOR);
  float3 tonemapped_sdr = ApplyVanillaToneMap(untonemapped);
  tonemapped_sdr = min(1, tonemapped_sdr);  // blues overshoot due to luminance tm

  untonemapped_graded = CorrectHueAndPurityMBBT709WithBT2020(untonemapped_graded, tonemapped_sdr, RENODX_COLOR_GRADE_STRENGTH, 0.85f);

  return untonemapped_graded;
}

void main() {
  float2 uv = passParameterSem0.xy;
  float alpha = passParameterSem0.w;
  float3 glow = texture(textureUnitPS0, uv).xyz;
  float3 raw = texture(textureUnitPS1, uv).xyz;
  float3 untonemapped = glow + raw;

  float saturation_grade_bias = intBitsToFloat(_409.uf_remappedPS[0].x);
  float saturation_grade_scale = intBitsToFloat(_409.uf_remappedPS[0].y) * VANILLA_SATURATION;

  float3 output;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float3 tonemapped = saturate(ApplyVanillaToneMap(untonemapped));
    float3 tonemapped_graded = ApplySaturationGrading(tonemapped, saturation_grade_bias, saturation_grade_scale);

    output = saturate(tonemapped_graded);
  } else {
    float3 graded_untonemapped = ComputeUntonemappedGraded(untonemapped);

    float maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(graded_untonemapped);
    graded_untonemapped = ApplySaturationGrading(graded_untonemapped * maxch_scale, saturation_grade_bias, saturation_grade_scale) / maxch_scale;

    if (CUSTOM_TONEMAP_CLAMP == 0.f) graded_untonemapped = renodx::color::bt709::clamp::BT709(graded_untonemapped);

    // Apply user grading
    renodx_custom::tonemap::psycho::config17::Config psycho17_config = BuildPsycho17Config();
    float3 graded_untonemapped_bt2020 = renodx::color::bt2020::from::BT709(graded_untonemapped);
    graded_untonemapped_bt2020 = renodx_custom::tonemap::psycho::ApplyTest17BT2020(graded_untonemapped_bt2020, graded_untonemapped_bt2020, psycho17_config);
    graded_untonemapped = renodx::color::bt709::from::BT2020(graded_untonemapped_bt2020);

    // maxch tonemap to peak
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.f) {
      peak = renodx::color::correct::GammaSafe(peak, true);
    }
    if (RENODX_GAMMA_CORRECTION == 2.f) {
      peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
    }
    float3 graded_tonemapped = renodx::tonemap::neutwo::MaxChannel(graded_untonemapped, peak);

    output = graded_tonemapped;
  }

  passPixelColor0 = float4(renodx::draw::RenderIntermediatePass(output), alpha);
}
