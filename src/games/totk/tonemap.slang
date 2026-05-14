#version 450
#include "./psycho_test17_custom.hlsli"
#include "./psychov_17.hlsl"
#include "./shared.h"

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
luminance;

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
grading;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;

layout(location = 0) in float4 passParameterSem0;
layout(location = 0) out float4 passPixelColor0;

static const float kInputClamp = 10000.0;
static const float kBt601RedWeight = 0.29890000820159912109375;
static const float kNegInvLn2 = -1.44269502162933349609375;
static const float kRedGradeWeight = 0.666666686534881591796875;
static const float kHueTransferChromaStart = 0.02;
static const float kHueTransferChromaEnd = 0.12;

float ToneCurve(float value) {
  return 1.0 - exp2(value * kNegInvLn2);
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
  //config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.adaptation_contrast = 1.f;
  config.bleaching_intensity = 0.f;
  config.hue_emulation = 0.f;
  config.pre_gamut_compress = false;
  config.post_gamut_compress = false;
  config.apply_lms_tonemap = false;
  config.apply_maxch_tonemap = false;
  return config;
}

float ComputeTotkWeightedLuma(float3 color) {
  return color.r * kBt601RedWeight + color.g * luminance._m0[0].x + color.b * luminance._m0[0].y;
}

float ComputeTotkGradeInput(float3 color) {
  return color.r * kRedGradeWeight + (color.g + color.b) * luminance._m0[0].z;
}

float3 ApplyTotkVanillaToneMap(float3 untonemapped) {
  float weighted_luma = ComputeTotkWeightedLuma(untonemapped);

  float luma_curve = ToneCurve(weighted_luma);
  float luma_scale = luma_curve / weighted_luma;
  float blend_weight = saturate(luma_curve);
  blend_weight *= blend_weight;

  float3 tonemapped_luma = untonemapped * luma_scale;
  float3 tonemapped_per_channel = float3(
      ToneCurve(untonemapped.x),
      ToneCurve(untonemapped.y),
      ToneCurve(untonemapped.z));
  float3 tonemapped = lerp(tonemapped_luma, tonemapped_per_channel, blend_weight);

  return saturate(tonemapped);
}

float3 ApplyVanillaToneMap(float3 untonemapped, float range = 1.f) {
  float lum_in = renodx::color::luma::from::BT601(untonemapped);
  float lum_out = range * (1.f - exp(-lum_in / range));
  float3 tonemapped_lum = untonemapped * renodx::math::DivideSafe(lum_out, lum_in, 0.f);

  float3 tonemapped_perch = range * (1.f - exp(-untonemapped / range));

  float blend_weight = pow(saturate(lum_out), 2.f);
  return lerp(tonemapped_lum, tonemapped_perch, blend_weight);
}

float3 ApplyVanillaToneMapExtended(float3 untonemapped, float range = 1.f, float pivot_point = 0.18f) {
  float lum_in = renodx::color::luma::from::BT601(untonemapped);
  float lum_out = VanillaToneCurveExtended(lum_in, range, pivot_point);
  float3 tonemapped_lum = untonemapped * renodx::math::DivideSafe(lum_out, lum_in, 0.f);

  float3 tonemapped_perch = VanillaToneCurveExtended(untonemapped, range, pivot_point);

  float blend_weight = range * (1.f - exp(-lum_in / range));
  blend_weight = pow(saturate(blend_weight), 2.f);
  return lerp(tonemapped_lum, tonemapped_perch, blend_weight);
}

float ComputeHueTransferStrength(float3 donor) {
  float donor_max = max(donor.r, max(donor.g, donor.b));
  float donor_min = min(donor.r, min(donor.g, donor.b));
  float donor_chroma = renodx::math::DivideSafe(donor_max - donor_min, donor_max, 0.f);
  return smoothstep(kHueTransferChromaStart, kHueTransferChromaEnd, donor_chroma);
}

// Applies SDR hue and chroma onto the HDR-graded color.
float3 ComputeUntonemappedGraded(float3 untonemapped) {
  float3 untonemapped_graded = ApplyVanillaToneMapExtended(untonemapped, 1.f, RENODX_TONE_MAP_SDR_BLEND_FACTOR);
  float3 tonemapped_sdr = saturate(ApplyVanillaToneMap(untonemapped));
  float hue_transfer_strength = RENODX_COLOR_GRADE_STRENGTH * ComputeHueTransferStrength(tonemapped_sdr);

  untonemapped_graded = CorrectHueAndPurityMBBT709WithBT2020(
      untonemapped_graded,
      tonemapped_sdr,
      hue_transfer_strength,
      RENODX_TONE_MAP_BLOWOUT);

  return untonemapped_graded;
}

float3 ApplySaturationGrading(float3 color, float grade_bias, float grade_scale) {
  float triangle = ComputeTotkGradeInput(color) - 1.0;
  float grade = (1.0 - triangle * triangle) * grade_scale + grade_bias;

  float peak_channel = renodx::math::Max(color);
  if (peak_channel <= 0.0) return float3(0.0);

  return peak_channel.xxx + (color - peak_channel.xxx) * grade;
}

void main() {
  float2 uv = passParameterSem0.xy;
  float alpha = 0.0;

  float3 glow = min(texture(fp_t_tcb_8, uv).xyz, kInputClamp.xxx);
  float3 raw = texture(fp_t_tcb_A, uv).xyz;
  float3 untonemapped = glow + raw;

  float saturation_grade_bias = grading._m0[0].x;
  float saturation_grade_scale = grading._m0[0].y * VANILLA_SATURATION;
  float3 output;

  if (RENODX_TONE_MAP_TYPE == 0.0) {
    float3 tonemapped = ApplyTotkVanillaToneMap(untonemapped);
    float3 tonemapped_graded = ApplySaturationGrading(tonemapped, saturation_grade_bias, saturation_grade_scale);

    output = tonemapped_graded;
  } else {
    float3 graded_untonemapped = ComputeUntonemappedGraded(untonemapped);

    float maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(graded_untonemapped);
    graded_untonemapped = ApplySaturationGrading(graded_untonemapped * maxch_scale, saturation_grade_bias, saturation_grade_scale) / maxch_scale;

    if (CUSTOM_TONEMAP_CLAMP == 0.0) {
      graded_untonemapped = renodx::color::bt709::clamp::BT709(graded_untonemapped);
    }

    // Apply user grading.
    renodx_custom::tonemap::psycho::config17::Config psycho17_config = BuildPsycho17Config();
    float3 graded_untonemapped_bt2020 = renodx::color::bt2020::from::BT709(graded_untonemapped);
    graded_untonemapped_bt2020 = renodx_custom::tonemap::psycho::ApplyTest17BT2020(
        graded_untonemapped_bt2020, graded_untonemapped_bt2020, psycho17_config);
    graded_untonemapped = renodx::color::bt709::from::BT2020(graded_untonemapped_bt2020);

    // Max-channel tonemap to display peak.
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.0) {
      peak = renodx::color::correct::GammaSafe(peak, true);
    }
    if (RENODX_GAMMA_CORRECTION == 2.0) {
      peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
    }

    output = renodx::tonemap::neutwo::PerChannel(max(0, graded_untonemapped_bt2020), peak);
    output = renodx::color::bt709::from::BT2020(output);
    
  }

  output = renodx::draw::RenderIntermediatePass(output);
  //output = saturate(renodx::color::pq::Encode(output, RENODX_DIFFUSE_WHITE_NITS));
  passPixelColor0 = float4(output, alpha);
  
 
  
}

