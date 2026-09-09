#include "../common.hlsli"

#define LMS_WHITE_BT709  renodx::color::lms::from::BT709(1.0f)
#define LMS_WHITE_BT2020 renodx::color::lms::from::BT2020(1.0f)

// Defaults match PostChainMergeHDR_T3_CS_0x33CB3D22.
#define POSTCHAINMERGE_TONEMAP_NONE     0
#define POSTCHAINMERGE_TONEMAP_REINHARD 1
#define POSTCHAINMERGE_TONEMAP_HABLE    2
#define POSTCHAINMERGE_TONEMAP_FILM     3

#ifndef POSTCHAINMERGE_TONEMAP_TYPE
#define POSTCHAINMERGE_TONEMAP_TYPE POSTCHAINMERGE_TONEMAP_FILM
#endif

#ifndef POSTCHAINMERGE_IS_SDR
#define POSTCHAINMERGE_IS_SDR 0
#endif

#ifndef POSTCHAINMERGE_APPLY_SDR_DITHER
#define POSTCHAINMERGE_APPLY_SDR_DITHER POSTCHAINMERGE_IS_SDR
#endif

#ifndef POSTCHAINMERGE_OUTPUT_ALPHA
#define POSTCHAINMERGE_OUTPUT_ALPHA 0.f
#endif

#ifndef POSTCHAINMERGE_ENABLE_CBUFFER_DEBUG
#define POSTCHAINMERGE_ENABLE_CBUFFER_DEBUG 0
#endif

#ifndef POSTCHAINMERGE_DEBUG_FILM_TONEMAPPED_OUTPUT
#define POSTCHAINMERGE_DEBUG_FILM_TONEMAPPED_OUTPUT 0
#endif

struct SHDRAdaptationState {
  float m_fLuminanceGeometricMean;
  float m_fAdaptedMiddleGray;
  float m_fAdaptedBloomPoint;
  float m_fAdaptedBloomPointThreshold;
  float m_fAdaptedBloomPointClamp;
  float m_fAdaptedLuminance;
  float m_fAdaptedExposure;
  float m_fAdaptedBrightPassThreshold;
  float m_fAdaptedBrightPassClamp;
};

struct S_cbPostChainMerge {
  float2 vPixelSize;
  uint _pad_0;
  uint _pad_1;
  float4 vUVToGridUV;
  float4 vParams2;
  float4 vVignetteParams;
  float4 vVignetteParams2;
  float3 vColorTint;
  float fOptionalGammaAdjust;
  float4 vHDRParams;
  float fGlareStrength;
  float fTonemapScale;
  float fWhitePoint;
  float fRcpMappedWhitePoint;
  float fMaxUVDistortion;
  float fFadeValue;
  float fAlphaMaskFromDepthCutoff;
  float fFilmSlope;
  float fFilmToe;
  float fFilmShoulder;
  float fFilmBlackClip;
  float fFilmWhiteClip;
  float fFilmToeLinearInterp;
  int iToneMapType;
  uint nApplyExposure;
  int bTonemapDebugMainViewBlackDetection;
  int bTonemapDebugExposureOverride;
  int bTonemapDebugCompareToAces;
  float fTonemapDebugExposureValue;
  uint _pad_2;
};

cbuffer _cbPostChainMerge : register(b5) {
  S_cbPostChainMerge cbPostChainMerge : packoffset(c000.x);
};

Texture2D<float4> mapLinearLightTexture : register(t0);

Texture2D<float4> mapGlareTexture : register(t1);

Texture3D<float4> srvColorCorrectionVolume : register(t2);

Texture2D<float4> mapGridTexture : register(t3);

StructuredBuffer<SHDRAdaptationState> srvHDRAdaptationState : register(t6);

Texture2D<float> srvExposures : register(t14);

RWTexture2D<float4> uavOutput1 : register(u0);

SamplerState samplerLinearClampNode : register(s4);

float3 ReinhardPiecewise(float3 x, float3 x_max, float3 shoulder) {
  const float x_min = 0.f;
  x_max = max(x_max, shoulder + 1e-6f);
  float3 exposure = (x_max * (shoulder - x_min)) / (shoulder * (x_max - shoulder));
  float3 tonemapped = mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);

  return lerp(x, tonemapped, step(shoulder, x));
}

float3 ReinhardPiecewise(float3 x, float x_max, float3 shoulder) {
  return ReinhardPiecewise(x, x_max.xxx, shoulder);
}

static const float3x3 DISPLAYP3_TO_LMS_WEIGHTED_MAT = mul(
    renodx::color::macleod_boynton::XYZ_TO_LMS_WEIGHTED_MAT,
    renodx::color::DISPLAYP3_TO_XYZ_MAT);

float3 ApplyPerChannelPurityAndHue(
    float3 source_bt709,
    float3 target_bt709,
    float3x3 limiting_primaries_to_lms_weighted_mat,
    float purity_amount,
    float hue_amount,
    float purity_compression_knee = 0.9f) {
  const float epsilon = 1e-7f;
  float3 background_state_lms = renodx::color::lms::from::BT709(0.18f.xxx);
  float3 source_lms = renodx::color::lms::from::BT709(source_bt709);
  float3 target_lms = renodx::color::lms::from::BT709(target_bt709);

  // Express both colors relative to the same D65 background in physiologically
  // weighted LMS, then separate carried Yf from MacLeod-Boynton chromaticity.
  float3 source_relative_weighted = renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(source_lms), background_state_lms, 0.f);
  float3 target_relative_weighted = renodx::math::DivideSafe(
      renodx::color::macleod_boynton::WeighLMS(target_lms), background_state_lms, 0.f);
  float3 source_mb = renodx::color::macleod_boynton::from::WeightedLMS(source_relative_weighted);
  float3 target_mb = renodx::color::macleod_boynton::from::WeightedLMS(target_relative_weighted);
  float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float2 source_offset = source_mb.xy - mb_white;
  float2 target_offset = target_mb.xy - mb_white;
  float source_radius = sqrt(max(dot(source_offset, source_offset), 0.f));
  float target_radius = sqrt(max(dot(target_offset, target_offset), 0.f));

  float2 source_direction = source_radius > epsilon
                                ? source_offset / source_radius
                                : float2(1.f, 0.f);
  float2 target_direction = target_radius > epsilon
                                ? target_offset / target_radius
                                : source_direction;
  if (source_radius <= epsilon) {
    source_direction = target_direction;
  }

  float2 output_direction = lerp(target_direction, source_direction, hue_amount);
  float output_direction_length_squared = dot(output_direction, output_direction);
  output_direction = output_direction_length_squared > epsilon
                         ? output_direction * rsqrt(output_direction_length_squared)
                         : target_direction;

  // Preserve absolute purity while changing hue, then compress against the
  // selected limiting-gamut boundary along the output hue.
  float2 gamut_r;
  float2 gamut_g;
  float2 gamut_b;
  renodx::color::gamut::MakeRGBTriangleInMBAdaptiveWeighted(
      limiting_primaries_to_lms_weighted_mat,
      background_state_lms,
      gamut_r,
      gamut_g,
      gamut_b);

  bool has_output_boundary;
  float output_boundary_radius = renodx::color::gamut::RayMaxT_RGBTriangleInMB(
      mb_white, output_direction, gamut_r, gamut_g, gamut_b, has_output_boundary);

  float desired_radius = lerp(target_radius, source_radius, saturate(purity_amount));
  float output_purity = has_output_boundary
                            ? max(renodx::math::DivideSafe(desired_radius, output_boundary_radius, 0.f), 0.f)
                            : 0.f;

  float purity_knee = saturate(purity_compression_knee);
  float purity_range = max(1.f - purity_knee, epsilon);
  float purity_excess = max(output_purity - purity_knee, 0.f);
  float compressed_purity = purity_knee
                            + (purity_excess * purity_range
                               * rsqrt(mad(purity_excess, purity_excess, purity_range * purity_range)));
  output_purity = lerp(output_purity, compressed_purity, step(purity_knee, output_purity));

  float output_radius = has_output_boundary
                            ? output_purity * output_boundary_radius
                            : desired_radius;

  float3 output_relative_weighted = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(
      float3(mb_white + output_direction * output_radius, target_mb.z));
    return renodx::color::bt709::from::LMS(
      renodx::color::macleod_boynton::UnweighLMS(output_relative_weighted * background_state_lms));
}

struct FilmTonemapConfig {
  float toe_start;
  float toe_range;
  float toe_exponent_scale;
  float shoulder_start;
  float shoulder_white;
  float shoulder_range;
  float shoulder_exponent_scale;
  float mid_range;
  bool invert_mid_range;
  float black_level;
  bool use_toe_linear_interp;
};

FilmTonemapConfig CreateFilmTonemapConfig(float film_white_clip) {
  FilmTonemapConfig config;
  float toe_width = (1.0f - cbPostChainMerge.fFilmToe) + cbPostChainMerge.fFilmBlackClip;
  float shoulder_width = (1.0f - cbPostChainMerge.fFilmShoulder) + film_white_clip;

  config.toe_start = ((0.82f - cbPostChainMerge.fFilmToe) / cbPostChainMerge.fFilmSlope) + -0.7329999804496765f;
  config.toe_range = toe_width * 2.0f;
  config.toe_exponent_scale = ((cbPostChainMerge.fFilmSlope * -2.0f) / toe_width) * 1.4426950216293335f;
  config.shoulder_start = ((cbPostChainMerge.fFilmShoulder + -0.18f) / cbPostChainMerge.fFilmSlope) + -0.7329999804496765f;
  config.shoulder_white = film_white_clip + 1.0f;
  config.shoulder_range = shoulder_width * 2.0f;
  config.shoulder_exponent_scale = ((cbPostChainMerge.fFilmSlope * 2.0f) / shoulder_width) * 1.4426950216293335f;
  config.mid_range = config.shoulder_start - config.toe_start;
  config.invert_mid_range = (config.shoulder_start < config.toe_start);
  config.black_level = -0.0f - cbPostChainMerge.fFilmBlackClip;
  config.use_toe_linear_interp = (cbPostChainMerge.fFilmToeLinearInterp > 0.0f);

  return config;
}

#define APPLY_FILM_TONEMAP_GENERATOR(T)                                                                                                                                                                                    \
  T ApplyFilmToneMap(T untonemapped, const FilmTonemapConfig config, bool apply_shoulder) {                                                                                                                                \
    T log_value = log2(untonemapped) * 0.3010300099849701f;                                                                                                                                                                \
    T linear_value = ((log_value + 0.7329999804496765f) * cbPostChainMerge.fFilmSlope) + 0.18f;                                                                                                                            \
    T toe_delta = log_value - config.toe_start;                                                                                                                                                                            \
    T toe_value = select((log_value < config.toe_start), ((config.toe_range / (exp2(config.toe_exponent_scale * toe_delta) + 1.0f)) - cbPostChainMerge.fFilmBlackClip), linear_value);                                     \
    T mid_blend = saturate(toe_delta / config.mid_range);                                                                                                                                                                  \
    T film_blend = select(config.invert_mid_range, (1.0f - mid_blend), mid_blend);                                                                                                                                         \
    T shoulder_value = linear_value;                                                                                                                                                                                       \
    [branch]                                                                                                                                                                                                               \
    if (apply_shoulder) {                                                                                                                                                                                                  \
      shoulder_value = select((log_value > config.shoulder_start), (config.shoulder_white - (config.shoulder_range / (exp2(config.shoulder_exponent_scale * (log_value - config.shoulder_start)) + 1.0f))), linear_value); \
    }                                                                                                                                                                                                                      \
    T tonemapped = select((untonemapped < 1.0e-15f), config.black_level, (((film_blend * film_blend) * (shoulder_value - toe_value)) * (3.0f - (film_blend * 2.0f))) + toe_value);                                         \
    if (config.use_toe_linear_interp) {                                                                                                                                                                                    \
      return (saturate(exp2(log2(untonemapped / cbPostChainMerge.fFilmToeLinearInterp) * 0.6f)) * (tonemapped - untonemapped)) + untonemapped;                                                                             \
    }                                                                                                                                                                                                                      \
    return tonemapped;                                                                                                                                                                                                     \
  }                                                                                                                                                                                                                        \
  T ApplyFilmToneMap(T untonemapped, const FilmTonemapConfig config) {                                                                                                                                                     \
    return ApplyFilmToneMap(untonemapped, config, true);                                                                                                                                                                   \
  }                                                                                                                                                                                                                        \
  T ApplyFilmToneMap(T untonemapped, float film_white_clip) {                                                                                                                                                              \
    return ApplyFilmToneMap(untonemapped, CreateFilmTonemapConfig(film_white_clip));                                                                                                                                       \
  }

APPLY_FILM_TONEMAP_GENERATOR(float)
APPLY_FILM_TONEMAP_GENERATOR(float3)
APPLY_FILM_TONEMAP_GENERATOR(float4)

#undef APPLY_FILM_TONEMAP_GENERATOR

float ComputeFilmTonemapSlopeAtInput(const FilmTonemapConfig config, float input, bool apply_shoulder = true) {
  float eps = max(input * (1.0f / 1024.0f), 1e-5f);
  float low = ApplyFilmToneMap(input - eps, config, apply_shoulder);
  float high = ApplyFilmToneMap(input + eps, config, apply_shoulder);

  return (high - low) / (2.0f * eps);
}

#define APPLY_FILM_TONEMAP_EXTENDED_GENERATOR(T)                                                                                   \
  T ApplyFilmToneMapExtended(T untonemapped, const FilmTonemapConfig config, float branching_point, float tonemapped_lerp = 0.f) { \
    const float branching_output = ApplyFilmToneMap(branching_point, config, false);                                               \
    const float branching_slope = ComputeFilmTonemapSlopeAtInput(config, branching_point, false);                                  \
    T shoulderless_tonemapped = ApplyFilmToneMap(untonemapped, config, false);                                                     \
    T extended_tonemapped = mad((T)branching_slope, untonemapped - (T)branching_point, (T)branching_output);                       \
    T tonemapped = select((untonemapped > (T)branching_point), extended_tonemapped, shoulderless_tonemapped);                      \
    return lerp(tonemapped, shoulderless_tonemapped, tonemapped_lerp);                                                             \
  }                                                                                                                                \
  T ApplyFilmToneMapExtended(T untonemapped, float film_white_clip, float branching_point, float tonemapped_lerp = 0.f) {          \
    return ApplyFilmToneMapExtended(untonemapped, CreateFilmTonemapConfig(film_white_clip), branching_point, tonemapped_lerp);     \
  }

APPLY_FILM_TONEMAP_EXTENDED_GENERATOR(float)
APPLY_FILM_TONEMAP_EXTENDED_GENERATOR(float3)
APPLY_FILM_TONEMAP_EXTENDED_GENERATOR(float4)

#undef APPLY_FILM_TONEMAP_EXTENDED_GENERATOR

// samples the lutbuilder, scaling is done separately inside the lutbuilder
renodx::lut::Config CreateLUTConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 16u;
#if !USE_EXPENSIVE_LUT_GAMUT_RESTORATION
  lut_config.gamut_compress = 0.f;
#endif
  lut_config.strength = COLOR_GRADE_LUT_STRENGTH;
  return lut_config;
}

struct CustomGradingConfig {
  float exposure;
  float highlights;
  float contrast_highlights;
  float shadows;
  float contrast_shadows;
  float contrast;
  float flare;
  float gamma;
  float saturation;
  float dechroma;
  float highlight_saturation;
};

float ApplyCustomHighlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 1.f)));
  } else {
    float b = mid_gray * pow(x / mid_gray, 2.f - highlights);
    float t = min(x, 1.f);
    return min(x, renodx::math::DivideSafe(x * x, lerp(x, b, t), x));
  }
}

float ApplyCustomShadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float ApplyCustomContrastAndFlare(float x, float contrast, float contrast_highlights, float contrast_shadows, float flare, float mid_gray) {
  if (contrast == 1.f && flare == 0.f && contrast_highlights == 1.f && contrast_shadows == 1.f) return x;

  const float x_normalized = x / mid_gray;
  const float split_contrast = renodx::math::Select(x < mid_gray, contrast_shadows, contrast_highlights);
  float flare_ratio = renodx::math::DivideSafe(x_normalized + flare, x_normalized, 1.f);
  float exponent = contrast * split_contrast * flare_ratio;
  return pow(x_normalized, exponent) * mid_gray;
}

float3 ApplyCustomLuminanceGrading(float3 color, float y_in, CustomGradingConfig config, float mid_gray) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f
      && config.contrast_highlights == 1.f && config.contrast_shadows == 1.f && config.flare == 0.f && config.gamma == 1.f) {
    return color;
  }

  color *= config.exposure;

  float y_gamma_adjusted = renodx::math::Select(y_in < 1.f, pow(y_in, config.gamma), y_in);
  float y_contrasted = ApplyCustomContrastAndFlare(y_gamma_adjusted, config.contrast, config.contrast_highlights, config.contrast_shadows, config.flare, mid_gray);
  float y_highlighted = ApplyCustomHighlights(y_contrasted, config.highlights, mid_gray);
  float y_out = ApplyCustomShadows(y_highlighted, config.shadows, mid_gray);

  return renodx::color::correct::Luminance(color, y_in, y_out);
}

float3 ApplyCustomChromaGrading(float3 color, float y, CustomGradingConfig config) {
  float chroma_scale = config.saturation;

  if (config.dechroma != 0.f) {
    chroma_scale *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
  }

  if (config.highlight_saturation != 0.f) {
    float percent_max = saturate(y * 100.f / 10000.f);
    float blowout_strength = 100.f;
    float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
    if (config.highlight_saturation < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    chroma_scale *= blowout_change;
  }

  if (chroma_scale == 1.f) return color;

  float purity_scale = max(chroma_scale, 0.f);
  float3 color_lms = renodx::color::lms::from::BT2020(color);
  float3 mb = renodx::color::macleod_boynton::from::LMS(color_lms);
  float2 mb_white = renodx::color::macleod_boynton::from::D65XY();
  float2 mb_scaled = mb_white + ((mb.xy - mb_white) * purity_scale);

  float3 purity_scaled_lms = renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb.z));
  return renodx::color::bt2020::from::LMS(purity_scaled_lms);
}

float3 ApplyCustomGrading(float3 color_bt2020) {
  const CustomGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,
    RENODX_TONE_MAP_HIGHLIGHTS,
    RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
    RENODX_TONE_MAP_SHADOWS,
    RENODX_TONE_MAP_CONTRAST_SHADOWS,
    RENODX_TONE_MAP_CONTRAST,
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
    RENODX_TONE_MAP_GAMMA,
    RENODX_TONE_MAP_SATURATION,
    RENODX_TONE_MAP_DECHROMA,
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
  };

  float y = renodx::color::yf::from::BT2020(color_bt2020);
  color_bt2020 = ApplyCustomLuminanceGrading(color_bt2020, y, cg_config, 0.1f);
  y = renodx::color::yf::from::BT2020(color_bt2020);
  color_bt2020 = ApplyCustomChromaGrading(color_bt2020, y, cg_config);

  return color_bt2020;
}

#define POSTCHAINMERGE_DEBUG_FLOAT_FIELDS(FIELD)                                                                                                   \
  FIELD(cbPostChainMerge.fFilmSlope, 'f', 'F', 'i', 'l', 'm', 'S', 'l', 'o', 'p', 'e')                                                             \
  FIELD(cbPostChainMerge.fFilmToe, 'f', 'F', 'i', 'l', 'm', 'T', 'o', 'e')                                                                         \
  FIELD(cbPostChainMerge.fFilmShoulder, 'f', 'F', 'i', 'l', 'm', 'S', 'h', 'o', 'u', 'l', 'd', 'e', 'r')                                           \
  FIELD(cbPostChainMerge.fFilmBlackClip, 'f', 'F', 'i', 'l', 'm', 'B', 'l', 'a', 'c', 'k', 'C', 'l', 'i', 'p')                                     \
  FIELD(cbPostChainMerge.fFilmWhiteClip, 'f', 'F', 'i', 'l', 'm', 'W', 'h', 'i', 't', 'e', 'C', 'l', 'i', 'p')                                     \
  FIELD(cbPostChainMerge.fFilmToeLinearInterp, 'f', 'F', 'i', 'l', 'm', 'T', 'o', 'e', 'L', 'i', 'n', 'e', 'a', 'r', 'I', 'n', 't', 'e', 'r', 'p') \
  FIELD(cbPostChainMerge.fRcpMappedWhitePoint, 'f', 'R', 'c', 'p', 'M', 'a', 'p', 'p', 'e', 'd', 'W', 'h', 'i', 't', 'e', 'P', 'o', 'i', 'n', 't') \
  FIELD(cbPostChainMerge.vHDRParams.x, 'v', 'H', 'D', 'R', 'P', 'a', 'r', 'a', 'm', 's', '.', 'x')                                                 \
  FIELD(cbPostChainMerge.vHDRParams.y, 'v', 'H', 'D', 'R', 'P', 'a', 'r', 'a', 'm', 's', '.', 'y')                                                 \
  FIELD(cbPostChainMerge.vHDRParams.z, 'v', 'H', 'D', 'R', 'P', 'a', 'r', 'a', 'm', 's', '.', 'z')                                                 \
  FIELD(cbPostChainMerge.vHDRParams.w, 'v', 'H', 'D', 'R', 'P', 'a', 'r', 'a', 'm', 's', '.', 'w')                                                 \
  FIELD(cbPostChainMerge.vParams2.x, 'v', 'P', 'a', 'r', 'a', 'm', 's', '2', '.', 'x')                                                             \
  FIELD(cbPostChainMerge.vParams2.y, 'v', 'P', 'a', 'r', 'a', 'm', 's', '2', '.', 'y')                                                             \
  FIELD(cbPostChainMerge.vParams2.z, 'v', 'P', 'a', 'r', 'a', 'm', 's', '2', '.', 'z')                                                             \
  FIELD(cbPostChainMerge.fTonemapScale, 'f', 'T', 'o', 'n', 'e', 'm', 'a', 'p', 'S', 'c', 'a', 'l', 'e')                                           \
  FIELD(cbPostChainMerge.fWhitePoint, 'f', 'W', 'h', 'i', 't', 'e', 'P', 'o', 'i', 'n', 't')

float3 DrawPostChainMergeCBufferDebug(float3 color, float2 screen_position) {
  const float2 panel_min = float2(32.0f, 32.0f);
  const float2 panel_max = float2(800.0f, 850.0f);

  renodx::canvas::Context context = CreateDebugOverlayContext(
      color,
      screen_position,
      panel_min + float2(24.0f, 24.0f),
      float2(24.0f, 36.0f),
      true);

  renodx::canvas::SetColor(context, 0x05080c, 0.88f, 1.0f);
  renodx::canvas::FillRect(context, panel_min, panel_max);

  renodx::canvas::SetColor(context, 0x38ff9c, 1.0f, 1.0f);
  DrawDebugText(context, 'P', 'o', 's', 't', 'C', 'h', 'a', 'i', 'n', 'M', 'e', 'r', 'g', 'e');
  renodx::canvas::NewLine(context);

#define DRAW_DEBUG_FLOAT_FIELD(VALUE, ...) DrawDebugFloatRow(context, VALUE, __VA_ARGS__);

  renodx::canvas::SetColor(context, 0xdde6f0, 1.0f, 1.0f);
  DrawDebugIntegerRow(context, int(cbPostChainMerge.nApplyExposure), 'n', 'A', 'p', 'p', 'l', 'y', 'E', 'x', 'p', 'o', 's', 'u', 'r', 'e');
  POSTCHAINMERGE_DEBUG_FLOAT_FIELDS(DRAW_DEBUG_FLOAT_FIELD)

#undef DRAW_DEBUG_FLOAT_FIELD

  return GetDebugOverlayOutput(context, true);
}

#undef POSTCHAINMERGE_DEBUG_FLOAT_FIELDS
