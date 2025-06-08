#include "./shared.h"

// clang-format off
cbuffer cb1 : register(b1) {
  struct cConstant0_Struct {
    struct ChromaticAberrationParameter {
      float4 ChromaticAberrationParameter_000[3];
      float ChromaticAberrationParameter_048;
      int ChromaticAberrationParameter_052;
      int2 ChromaticAberrationParameter_056;
    } cConstant0_Struct_000;
    struct VignetteParameter {
      struct VignetteMechanicalParameter {
        float VignetteMechanicalParameter_000;
        float VignetteMechanicalParameter_004;
        int2 VignetteMechanicalParameter_008;
      } VignetteParameter_000;
      struct VignetteNaturalParameter {
        float VignetteNaturalParameter_000;
        float VignetteNaturalParameter_004;
        float VignetteNaturalParameter_008;
        int VignetteNaturalParameter_012;
      } VignetteParameter_016;
      float3 VignetteParameter_032;
      float VignetteParameter_044;
    } cConstant0_Struct_064;
    struct NightFilterParameter {
      float4 NightFilterParameter_000[30];
    } cConstant0_Struct_112;
    struct FilmGrainParameter {
      float2 FilmGrainParameter_000;
      float2 FilmGrainParameter_008;
      float FilmGrainParameter_016;
      int3 FilmGrainParameter_020;
    } cConstant0_Struct_592;
    struct ColorGradingLutParameter {
      int ColorGradingLutParameter_000;
      float ColorGradingLutParameter_004;
      int2 ColorGradingLutParameter_008;
    } cConstant0_Struct_624;
    struct ColorGradingRuntimeParameter {
      float4 ColorGradingRuntimeParameter_000;
      float4 ColorGradingRuntimeParameter_016;
      float4 ColorGradingRuntimeParameter_032;
      float4 ColorGradingRuntimeParameter_048;
      float4 ColorGradingRuntimeParameter_064;
    } cConstant0_Struct_640;
    struct ColorGradingRuntime2Parameter {
      float4 ColorGradingRuntime2Parameter_000;
      float4 ColorGradingRuntime2Parameter_016;
      float4 ColorGradingRuntime2Parameter_032;
    } cConstant0_Struct_720;
    struct ToneMappingParameter {
      struct TripleSectionToneMappingParams {
        float TripleSectionToneMappingParams_000;
        float TripleSectionToneMappingParams_004;
        float TripleSectionToneMappingParams_008;
        float TripleSectionToneMappingParams_012;
        float TripleSectionToneMappingParams_016;
        float TripleSectionToneMappingParams_020;
        int2 TripleSectionToneMappingParams_024;
        float4 TripleSectionToneMappingParams_032;
      } ToneMappingParameter_000;
      float ToneMappingParameter_048;
      float ToneMappingParameter_052;
      int2 ToneMappingParameter_056;
    } cConstant0_Struct_768;
    float cConstant0_Struct_832;
    int3 cConstant0_Struct_836;
  } cConstant0_000 : packoffset(c000.x);
};
// clang-format on

// Final Fantasy XVI's Triple-Section HDR Tonemap
// Blends log toe, linear mid, and exponential compressed shoulder
#define TRIPLE_SECTION_TONEMAP_GENERATOR(T)                                                                                            \
  T TripleSectionTonemap(T color, float peak_ratio) {                                                                                  \
    const float kInvLn2 = 1 / log(2);                                                                                                  \
                                                                                                                                       \
    /* Exposure and tone scale parameters */                                                                                           \
    const float exposure_comp = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_048;                                         \
    const float linear_start = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;       \
    const float linear_slope = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_004;       \
    const float toe_strength = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_016;       \
    const float toe_offset = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_020;         \
    const float highlight_start = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.x;  \
    const float highlight_end = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.y;    \
    const float rolloff_strength = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.z; \
                                                                                                                                       \
    T scene_color = color * exposure_comp;                                                                                             \
    T normalized = scene_color / linear_start;                                                                                         \
                                                                                                                                       \
    /* Logarithmic toe segment */                                                                                                      \
    T toe = pow(abs(normalized), toe_strength) * linear_start + toe_offset;                                                            \
                                                                                                                                       \
    /* Linear mid section */                                                                                                           \
    T mid = (scene_color - linear_start) * linear_slope + linear_start;                                                                \
                                                                                                                                       \
    /* Exponential highlight roll-off */                                                                                               \
    T delta = scene_color - highlight_start;                                                                                           \
    T scaled = delta * (-rolloff_strength) * kInvLn2 / peak_ratio;                                                                     \
    T highlight = peak_ratio - exp2(scaled) * (peak_ratio - highlight_end);                                                            \
                                                                                                                                       \
    /* Smootherstep blend between regions */                                                                                           \
    T t = saturate(normalized);                                                                                                        \
    T blend = t * t * (3.0f - 2.0f * t); /* smootherstep */                                                                            \
                                                                                                                                       \
    /* Highlight transition mask */                                                                                                    \
    T in_highlight = select(scene_color < highlight_start, (T)(0.0f), (T)(1.0f));                                                      \
    T highlight_blend = blend - in_highlight;                                                                                          \
                                                                                                                                       \
    T result = toe * (1.0f - blend) + mid * highlight_blend + highlight * (blend - highlight_blend);                                   \
    return result;                                                                                                                     \
  }

TRIPLE_SECTION_TONEMAP_GENERATOR(float)
TRIPLE_SECTION_TONEMAP_GENERATOR(float3)
TRIPLE_SECTION_TONEMAP_GENERATOR(float4)
#undef TRIPLE_SECTION_TONEMAP_GENERATOR

void AdjustPeak(inout float peak_ratio) {
  if (RENODX_OVERRIDE_PEAK_NITS) {
    peak_ratio = RENODX_PEAK_WHITE_NITS / 260.f;
  }
  peak_ratio *= (260.f / RENODX_DIFFUSE_WHITE_NITS);
}

float3 ApplyToneMap(float3 untonemapped, float peak_ratio) {
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create();
  cg_config.exposure = RENODX_TONE_MAP_EXPOSURE;
  cg_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  cg_config.shadows = RENODX_TONE_MAP_SHADOWS;
  cg_config.contrast = RENODX_TONE_MAP_CONTRAST;
  cg_config.saturation = RENODX_TONE_MAP_SATURATION;
  cg_config.dechroma = RENODX_TONE_MAP_BLOWOUT;
  cg_config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  cg_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  untonemapped = renodx::color::grade::config::ApplyUserColorGrading(
      untonemapped,
      cg_config);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped = TripleSectionTonemap(untonemapped, peak_ratio);
  } else {
    float y_in = renodx::color::y::from::BT709(untonemapped);

    // rgb = channel tonemap
    // a = luminance tonemap - y out
    float4 dual_tonemaps = TripleSectionTonemap(float4(untonemapped, y_in), peak_ratio);
    float3 vanilla_tonemapped = dual_tonemaps.rgb;

    float y_out = dual_tonemaps.a;
    tonemapped = untonemapped * select(y_in > 0, y_out / y_in, 0.f);
    renodx::color::grade::Config lum_tm_config = renodx::color::grade::config::Create(
        1.f,
        1.f,
        1.f,
        1.f,
        0.f,
        6.4f,
        0.97f,
        0.f,
        0,
        renodx::color::grade::config::hue_correction_type::INPUT,
        -1.f * (1.f - 1.f));
    tonemapped = renodx::color::grade::config::ApplyUserColorGrading(
        tonemapped,
        lum_tm_config);

    float3 vanilla_tonemapped_bt2020 = renodx::color::bt2020::from::BT709(vanilla_tonemapped);
    float3 tonemapped_bt2020 = max(0, renodx::color::bt2020::from::BT709(tonemapped));
    float3 blended_tonemapped =
        renodx::color::bt709::from::BT2020(lerp(tonemapped_bt2020,
                                                vanilla_tonemapped_bt2020,
                                                min(1.f, renodx::color::y::from::BT2020(tonemapped_bt2020 / 0.4f))));

    tonemapped = blended_tonemapped;
  }

  if (RENODX_CUSTOM_COLOR_SPACE == 1.f) {  // BT709 D65 => BT709 D93
    tonemapped = renodx::color::bt709::from::BT709D93(tonemapped);
  }
  tonemapped *= RENODX_DIFFUSE_WHITE_NITS / 260.f;

  return tonemapped;
}
