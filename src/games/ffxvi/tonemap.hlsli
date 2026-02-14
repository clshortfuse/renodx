#include "./macleod_boynton.hlsli"
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
// Blends toe, linear mid, and exponential compressed shoulder
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
    T blend = t * t * (3.f - 2.f * t); /* smootherstep */                                                                              \
                                                                                                                                       \
    /* Highlight transition mask */                                                                                                    \
    T in_highlight = select(scene_color < highlight_start, (T)(0.f), (T)(1.f));                                                        \
    T highlight_blend = blend - in_highlight;                                                                                          \
                                                                                                                                       \
    T result = toe * (1.f - blend) + mid * highlight_blend + highlight * (blend - highlight_blend);                                    \
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

float3 CorrectHueAndChrominanceOKLab(
    float3 incorrect_color_bt709,
    float3 reference_color_bt709,
    float hue_emulation_strength = 0.f,
    float chrominance_emulation_strength = 0.f,
    float hue_emulation_ramp_start = 0.18f,
    float hue_emulation_ramp_end = 1.f) {
  if (hue_emulation_strength == 0.0 && chrominance_emulation_strength == 0.0) {
    return incorrect_color_bt709;
  }

  float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color_bt709);
  float3 perceptual_reference = renodx::color::oklab::from::BT709(reference_color_bt709);

  float chrominance_current = length(perceptual_new.yz);
  float chrominance_ratio = 1.0;

  if (hue_emulation_strength != 0.0) {
    float ramp_denom = hue_emulation_ramp_end - hue_emulation_ramp_start;
    float ramp_t = clamp(renodx::math::DivideSafe(perceptual_new.x - hue_emulation_ramp_start, ramp_denom, 0.0), 0.0, 1.0);
    hue_emulation_strength *= ramp_t;

    float chrominance_pre = chrominance_current;
    perceptual_new.yz = lerp(perceptual_new.yz, perceptual_reference.yz, hue_emulation_strength);
    float chrominance_post = length(perceptual_new.yz);
    chrominance_ratio = renodx::math::DivideSafe(chrominance_pre, chrominance_post, 1.0);
    chrominance_current = chrominance_post;
  }

  if (chrominance_emulation_strength != 0.0) {
    float reference_chrominance = length(perceptual_reference.yz);
    float target_chrominance_ratio = renodx::math::DivideSafe(reference_chrominance, chrominance_current, 1.0);
    chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_emulation_strength);
  }

  perceptual_new.yz *= chrominance_ratio;

  float3 corrected_color_bt709 = renodx::color::bt709::from::OkLab(perceptual_new);
  return corrected_color_bt709;
}

float3 CorrectHueAndChrominance2ReferenceColorsOKLab(
    float3 incorrect_color,
    float3 chrominance_reference_color,
    float3 hue_reference_color,
    float hue_correct_strength = 1.f) {
  if (hue_correct_strength == 0.f)
    return renodx::color::correct::ChrominanceOKLab(incorrect_color, chrominance_reference_color);

  float3 incorrect_lab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 hue_lab = renodx::color::oklab::from::BT709(hue_reference_color);
  float3 chrominance_lab = renodx::color::oklab::from::BT709(chrominance_reference_color);

  float2 incorrect_ab = incorrect_lab.yz;
  float2 hue_ab = hue_lab.yz;

  // Always use chrominance magnitude from chroma reference
  float target_chrominance = length(chrominance_lab.yz);

  // Compute blended hue direction
  float2 blended_ab_dir = normalize(lerp(normalize(incorrect_ab), normalize(hue_ab), hue_correct_strength));

  // Apply chrominance magnitude from chroma_reference_color
  float2 final_ab = blended_ab_dir * target_chrominance;

  incorrect_lab.yz = final_ab;

  float3 result = renodx::color::bt709::from::OkLab(incorrect_lab);
  return renodx::color::bt709::clamp::AP1(result);
}

struct UserGradingConfig {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float gamma;
  float saturation;
  float dechroma;
  float highlight_saturation;
  float hue_emulation_strength_high;
  float chrominance_emulation_strength_high;
  float hue_emulation_strength_low;
  float chrominance_emulation_strength_low;
  float hue_chrominance_ramp_start;
  float hue_chrominance_ramp_end;
};

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1.f
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 ungraded, float y, UserGradingConfig config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f && config.gamma == 1.f) {
    return ungraded;
  }
  float3 color = ungraded;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

  // highlights
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  float y_gamma_adjusted = renodx::math::Select(y_shadowed < 1.f, pow(y_shadowed, config.gamma), y_shadowed);

  const float y_final = y_gamma_adjusted;

  float3 output = renodx::color::correct::Luminance(color, y, y_final);

#if 0  // chroma / hue correction using subtraction on
  float3 source_hue_chroma = ungraded - y;
  output = y_final + source_hue_chroma;
#endif

  return output;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.highlight_saturation != 0.f
      || config.hue_emulation_strength_high != 0.f || config.chrominance_emulation_strength_high != 0.f
      || config.hue_emulation_strength_low != 0.f || config.chrominance_emulation_strength_low != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue and chrominance emulation
    if (config.hue_emulation_strength_high != 0.f || config.chrominance_emulation_strength_high != 0.f
        || config.hue_emulation_strength_low != 0.f || config.chrominance_emulation_strength_low != 0.f) {
      const float3 perceptual_reference = renodx::color::oklab::from::BT709(hue_reference_color);

#if 1
      float hue_emulation_strength = config.hue_emulation_strength_high;
      float chrominance_emulation_strength = config.chrominance_emulation_strength_high;

      if (!(config.hue_chrominance_ramp_start == 0.f && config.hue_chrominance_ramp_end == 0.f)) {
        float ramp_denom = config.hue_chrominance_ramp_end - config.hue_chrominance_ramp_start;
        float ramp_t = saturate(renodx::math::DivideSafe(y - config.hue_chrominance_ramp_start, ramp_denom, 0.f));
        hue_emulation_strength = lerp(config.hue_emulation_strength_low, config.hue_emulation_strength_high, ramp_t);
        chrominance_emulation_strength = lerp(config.chrominance_emulation_strength_low, config.chrominance_emulation_strength_high, ramp_t);
      }
#endif

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_emulation_strength_high != 0.f || config.hue_emulation_strength_low != 0.f) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, perceptual_reference.yz, hue_emulation_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.chrominance_emulation_strength_high != 0.f || config.chrominance_emulation_strength_low != 0.f) {
        const float reference_chrominance = length(perceptual_reference.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_emulation_strength);
      }
      perceptual_new.yz *= chrominance_ratio;
    }

    // dechroma
    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    // highlight saturation
    if (config.highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float highlight_saturation_strength = 100.f;
      float highlight_saturation_change = pow(1.f - percent_max, highlight_saturation_strength * abs(config.highlight_saturation));
      if (config.highlight_saturation < 0) {
        highlight_saturation_change = (2.f - highlight_saturation_change);
      }

      perceptual_new.yz *= highlight_saturation_change;
    }

    // saturation
    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 ApplyUserGrading(float3 ungraded) {
  float hue_and_chrominance = 0.f;
  // only apply hue and chrominance correction if luminance is changed
  if (!(RENODX_TONE_MAP_SHADOWS == 1.f && RENODX_TONE_MAP_HIGHLIGHTS == 1.f && RENODX_TONE_MAP_CONTRAST == 1.f
        && RENODX_TONE_MAP_FLARE == 0.f && RENODX_TONE_MAP_GAMMA == 1.f)) {
    hue_and_chrominance = 1.f;
  }
  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_GAMMA,                                // float gamma;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    hue_and_chrominance,                                  // float hue_emulation_strength_high;
    hue_and_chrominance,                                  // float chrominance_emulation_strength_high;
    hue_and_chrominance,                                  // float hue_emulation_strength_low;
    hue_and_chrominance,                                  // float chrominance_emulation_strength_low;
    0.f,                                                  // float hue_chrominance_ramp_start;
    0.f                                                   // float hue_chrominance_ramp_end;
  };

  float y = renodx::color::y::from::BT709(ungraded);

  float3 graded = ApplyExposureContrastFlareHighlightsShadowsByLuminance(ungraded, y, cg_config, 0.18f);
  graded = ApplySaturationBlowoutHueCorrectionHighlightSaturation(graded, ungraded, y, cg_config);

  return graded;
}

float3 ApplyToneMap(float3 untonemapped, float peak_ratio) {
  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped = TripleSectionTonemap(untonemapped, peak_ratio);
  } else if (RENODX_TONE_MAP_TYPE == 2.f) {
    float y_in = renodx::color::y::from::BT709(untonemapped);
    float3 lum_tonemapped = renodx::color::correct::Luminance(untonemapped, y_in, TripleSectionTonemap(y_in, 1000.f));

    // 5.f empirically found to hue shift and blowout enough
    float3 ch_tonemapped = renodx::color::bt709::from::BT2020(TripleSectionTonemap(renodx::color::bt2020::from::BT709(untonemapped), 5.f));

    // use perch purity and use perch hues only on highlights
    tonemapped = CorrectLowHueThenHighHueAndPurityMB(lum_tonemapped, untonemapped, ch_tonemapped, 1.f, 1.f, 2.f);
    // tonemapped = CorrectHueAndChrominanceOKLab(lum_tonemapped, ch_tonemapped, 1.f, 1.f, 1.f, 2.f);
  } else {
    tonemapped = untonemapped;
  }

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    tonemapped = ApplyUserGrading(tonemapped);

    if (RENODX_TONE_MAP_TYPE == 2.f) {
      tonemapped = renodx::color::bt2020::from::BT709(tonemapped);
      tonemapped = renodx::tonemap::neutwo::MaxChannel(max(0, tonemapped), peak_ratio, 100.f);
      tonemapped = renodx::color::bt709::from::BT2020(tonemapped);
    }
  }

  if (RENODX_CUSTOM_WHITE_POINT == 1.f) {  // BT709 D65 => BT709 D93
    tonemapped = renodx::color::bt709::from::BT709D93(tonemapped);
  }

  tonemapped *= RENODX_DIFFUSE_WHITE_NITS / 260.f;

  return tonemapped;
}
