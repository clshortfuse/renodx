#include "../common.hlsli"

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
  const float EPSILON = 1e-7f;
  const float RADIUS_EPSILON_SQUARED = EPSILON * EPSILON;
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
  float source_radius_squared = max(dot(source_offset, source_offset), 0.f);
  float target_radius_squared = max(dot(target_offset, target_offset), 0.f);
  bool has_source_direction = source_radius_squared > RADIUS_EPSILON_SQUARED;
  bool has_target_direction = target_radius_squared > RADIUS_EPSILON_SQUARED;
  // Guard the rsqrt operand itself: inactive zero/subnormal radii must not produce infinity.
  float source_inverse_radius = rsqrt(has_source_direction ? source_radius_squared : 1.f);
  float target_inverse_radius = rsqrt(has_target_direction ? target_radius_squared : 1.f);
  // Keep sub-epsilon radii for purity interpolation rather than clamping them to zero or EPSILON.
  float source_radius = has_source_direction
                            ? source_radius_squared * source_inverse_radius
                            : sqrt(source_radius_squared);
  // Independent of target normalization so this sqrt can DCE for purity_amount == 1.
  float target_radius = sqrt(target_radius_squared);

  float2 source_direction = has_source_direction
                                ? source_offset * source_inverse_radius
                                : float2(1.f, 0.f);
  float2 target_direction = has_target_direction
                                ? target_offset * target_inverse_radius
                                : source_direction;
  if (!has_source_direction) {
    source_direction = target_direction;
  }

  float2 output_direction = lerp(target_direction, source_direction, hue_amount);
  float output_direction_length_squared = dot(output_direction, output_direction);
  output_direction = output_direction_length_squared > EPSILON
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
  float purity_range = max(1.f - purity_knee, EPSILON);
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
  const float LOG2_E = 1.f / log(2.f);
  const float FILM_LOG_OFFSET = 0.733f;
  FilmTonemapConfig config;
  float toe_width = (1.f - cbPostChainMerge.fFilmToe) + cbPostChainMerge.fFilmBlackClip;
  float shoulder_width = (1.f - cbPostChainMerge.fFilmShoulder) + film_white_clip;

  config.toe_start = ((0.82f - cbPostChainMerge.fFilmToe) / cbPostChainMerge.fFilmSlope) + -FILM_LOG_OFFSET;
  config.toe_range = toe_width * 2.f;
  config.toe_exponent_scale = ((cbPostChainMerge.fFilmSlope * -2.f) / toe_width) * LOG2_E;
  config.shoulder_start = ((cbPostChainMerge.fFilmShoulder + -0.18f) / cbPostChainMerge.fFilmSlope) + -FILM_LOG_OFFSET;
  config.shoulder_white = film_white_clip + 1.f;
  config.shoulder_range = shoulder_width * 2.f;
  config.shoulder_exponent_scale = ((cbPostChainMerge.fFilmSlope * 2.f) / shoulder_width) * LOG2_E;
  config.mid_range = config.shoulder_start - config.toe_start;
  config.invert_mid_range = (config.shoulder_start < config.toe_start);
  config.black_level = -0.f - cbPostChainMerge.fFilmBlackClip;
  config.use_toe_linear_interp = (cbPostChainMerge.fFilmToeLinearInterp > 0.f);

  return config;
}

#define APPLY_FILM_TONEMAP_GENERATOR(T)                                                                                                                                                                                      \
  T ApplyFilmToneMap(T untonemapped, const FilmTonemapConfig config, bool apply_shoulder) {                                                                                                                                  \
    const float FILM_LOG_OFFSET = 0.733f;                                                                                                                                                                                    \
    T log_value = log10(untonemapped);                                                                                                                                                                                       \
    T straight_color = ((log_value + FILM_LOG_OFFSET) * cbPostChainMerge.fFilmSlope) + 0.18f;                                                                                                                                \
    T toe_delta = log_value - config.toe_start;                                                                                                                                                                              \
    T toe_value = select((log_value < config.toe_start), ((config.toe_range / (exp2(config.toe_exponent_scale * toe_delta) + 1.0f)) + config.black_level), straight_color);                                                  \
    T mid_blend = saturate(toe_delta / config.mid_range);                                                                                                                                                                    \
    T film_blend = select(config.invert_mid_range, (1.0f - mid_blend), mid_blend);                                                                                                                                           \
    T shoulder_value = straight_color;                                                                                                                                                                                       \
    [branch]                                                                                                                                                                                                                 \
    if (apply_shoulder) {                                                                                                                                                                                                    \
      shoulder_value = select((log_value > config.shoulder_start), (config.shoulder_white - (config.shoulder_range / (exp2(config.shoulder_exponent_scale * (log_value - config.shoulder_start)) + 1.0f))), straight_color); \
    }                                                                                                                                                                                                                        \
    T tonemapped = select((untonemapped < 1.0e-15f), config.black_level, (((film_blend * film_blend) * (shoulder_value - toe_value)) * (3.0f - (film_blend * 2.0f))) + toe_value);                                           \
    [branch]                                                                                                                                                                                                                 \
    if (config.use_toe_linear_interp) {                                                                                                                                                                                      \
      return (saturate(pow(untonemapped / cbPostChainMerge.fFilmToeLinearInterp, 0.6f)) * (tonemapped - untonemapped)) + untonemapped;                                                                                       \
    }                                                                                                                                                                                                                        \
    return tonemapped;                                                                                                                                                                                                       \
  }                                                                                                                                                                                                                          \
  T ApplyFilmToneMap(T untonemapped, const FilmTonemapConfig config) {                                                                                                                                                       \
    return ApplyFilmToneMap(untonemapped, config, true);                                                                                                                                                                     \
  }                                                                                                                                                                                                                          \
  T ApplyFilmToneMap(T untonemapped, float film_white_clip) {                                                                                                                                                                \
    return ApplyFilmToneMap(untonemapped, CreateFilmTonemapConfig(film_white_clip));                                                                                                                                         \
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

// Enhanced shoulderless film: scene-linear input/branch, log10 landmarks, film-signal output.
// Requires finite config from CreateFilmTonemapConfig, positive slope/toe width and branch.
// Shoulder BEFORE toe is normal (e.g. toe .55, shoulder .26), not an invalid config!
// Retain that overlap's toe-to-line blend, replacing the cubic by a flat-ended C-infinity step.
// C-infinity is for x > 0 at fixed parameters, not across parameter changes, at zero, or
// across floating-point underflow. Nonpositive input returns black (zero with interpolation).

// Smooth only the final 10% of the toe-linear interpolation input range.
static const float FILM_ENHANCED_INTERP_RELATIVE_WIDTH = 0.1f;

// Black Flag's flat-ended step, evaluated without overflowing exp2 or dividing by zero
// in inactive vector lanes. Shared by the toe, optional interpolation, and extension.
#define FILM_ENHANCED_STEP_GENERATOR(T, B)                                       \
  T FilmEnhancedSmoothStep(T t) {                                                \
    B interior = (t > 0.f) & (t < 1.f);                                          \
    T u = renodx::math::Select(interior, t, (T)0.5f);                            \
    T product = u * (1.f - u);                                                   \
    T exponent = -abs(2.f * u - 1.f) / product;                                  \
    T tail = exp2(exponent);                                                     \
    T weight = renodx::math::Select(u < 0.5f, tail, (T)1.f) / (1.f + tail);      \
    return renodx::math::Select(interior, weight,                                \
                                renodx::math::Select(t >= 1.f, (T)1.f, (T)0.f)); \
  }

FILM_ENHANCED_STEP_GENERATOR(float, bool)
FILM_ENHANCED_STEP_GENERATOR(float3, bool3)
FILM_ENHANCED_STEP_GENERATOR(float4, bool4)
#undef FILM_ENHANCED_STEP_GENERATOR

// The baseline joins the full logistic and its log-line over the actual sorted landmarks.
// In inverted order this is precisely vanilla's overlap interval, without its cubic.
// In normal order vanilla switches toe to line at toe_start (only C2); using the full
// logistic until the smooth join finishes avoids retaining that hidden finite-order join.
// At equal landmarks there is no interval: use one intrinsic logistic e-fold ABOVE the toe.
// This explicit smooth regularization is not the undefined vanilla 0/0 or a hard fallback.
#define FILM_ENHANCED_BASELINE_GENERATOR(T)                                                                             \
  T FilmEnhancedBaseline(T input, const FilmTonemapConfig config) {                                                     \
    const float LOG10_2 = log10(2.f);                                                                                   \
    const float LOG2_E = 1.f / log(2.f);                                                                                \
    const float FILM_LOG_OFFSET = 0.733f;                                                                               \
    T safe_input = renodx::math::Select(input > 0.f, input, (T)1.f);                                                    \
    T log2_input = log2(safe_input);                                                                                    \
    T log_input = log2_input * LOG10_2;                                                                                 \
    T toe_delta = log_input - config.toe_start;                                                                         \
    T toe_power = config.toe_exponent_scale * toe_delta;                                                                \
    T tail = exp2(-abs(toe_power));                                                                                     \
    T toe = config.black_level + config.toe_range * renodx::math::Select(toe_power > 0.f, tail, (T)1.f) / (1.f + tail); \
    T straight_color = ((log_input + FILM_LOG_OFFSET) * cbPostChainMerge.fFilmSlope) + 0.18f;                           \
    float span = abs(config.shoulder_start - config.toe_start);                                                         \
    if (span == 0.f) span = -LOG2_E / config.toe_exponent_scale;                                                        \
    T blend = FilmEnhancedSmoothStep((log_input - min(config.toe_start, config.shoulder_start)) / span);                \
    T value = lerp(toe, straight_color, blend);                                                                         \
    [branch]                                                                                                            \
    if (config.use_toe_linear_interp) {                                                                                 \
      /* Retain vanilla interpolation below 0.9 * I; smoothly complete its cap at I. */                                 \
      const float INTERP_LOG_SPAN = -log10(1.f - FILM_ENHANCED_INTERP_RELATIVE_WIDTH);                                  \
      T interp_log_ratio = log2_input - log2(cbPostChainMerge.fFilmToeLinearInterp);                                    \
      /* Bound the exponent BEFORE exp2, including inactive/very bright lanes. */                                       \
      T r = exp2(min(interp_log_ratio, (T)0.f) * 0.6f);                                                                 \
      T step_weight = FilmEnhancedSmoothStep(                                                                           \
          1.f + interp_log_ratio * LOG10_2 / INTERP_LOG_SPAN);                                                          \
      T weight = lerp(r, (T)1.f, step_weight);                                                                          \
      value = weight * value + (1.f - weight) * safe_input;                                                             \
    }                                                                                                                   \
    return renodx::math::Select(input > 0.f, value, (T)(config.use_toe_linear_interp ? 0.f : config.black_level));      \
  }

FILM_ENHANCED_BASELINE_GENERATOR(float)
FILM_ENHANCED_BASELINE_GENERATOR(float3)
FILM_ENHANCED_BASELINE_GENERATOR(float4)
#undef FILM_ENHANCED_BASELINE_GENERATOR

// Preserve the original shoulderless film's shoulder-start value and analytic slope.
// This intentionally differs from the enhanced baseline's tangent.
// Linear extension span is the absolute toe-to-branch distance, bounded below by the
// branch's backward logistic e-fold distance to stay positive at coincident/nearby landmarks.
// Optional interpolation may end on either side of branch; arbitrary black/interp need not be monotone.
// After the join, tonemapped_lerp is the baseline weight; the remainder is the original-film tangent.
#define APPLY_FILM_TONEMAP_EXTENDED_ENHANCED_GENERATOR(T)                                                  \
  T ApplyFilmToneMapExtendedEnhanced(T input, const FilmTonemapConfig config,                              \
                                     float tonemapped_lerp = 0.f) {                                        \
    const float LN_2 = log(2.f);                                                                           \
    const float LN_10 = log(10.f);                                                                         \
    const float LOG2_E = 1.f / log(2.f);                                                                   \
    const float FILM_LOG_OFFSET = 0.733f;                                                                  \
    float branching_point = pow(10.f, config.shoulder_start);                                              \
    FilmTonemapConfig enhanced_config = config;                                                            \
    float toe_width = 1.f - cbPostChainMerge.fFilmToe;                                                     \
    float intrinsic_log_span = toe_width / (2.f * cbPostChainMerge.fFilmSlope);                            \
    enhanced_config.black_level = 0.f;                                                                     \
    enhanced_config.toe_range = 2.f * toe_width;                                                           \
    enhanced_config.toe_exponent_scale = -LOG2_E / intrinsic_log_span;                                     \
    float branch_output = 0.f;                                                                             \
    float branch_slope = 0.f;                                                                              \
    /* Preserve vanilla's constant-black path below its input cutoff (before interpolation). */            \
    if (branching_point >= 1e-15f) {                                                                       \
      if (config.shoulder_start < config.toe_start) {                                                      \
        /* At the overlap endpoint the blend and its derivative vanish: pure logistic. */                  \
        float toe_power = enhanced_config.toe_exponent_scale * (config.shoulder_start - config.toe_start); \
        float tail = exp2(-abs(toe_power));                                                                \
        branch_output = enhanced_config.toe_range * tail / (1.f + tail);                                   \
        branch_slope = -enhanced_config.toe_range * enhanced_config.toe_exponent_scale * LN_2              \
                       * tail / ((1.f + tail) * (1.f + tail) * LN_10 * branching_point);                   \
      } else {                                                                                             \
        /* Equality uses the straight tangent, matching the limiting zero-black toe. */                    \
        branch_output = (config.shoulder_start + FILM_LOG_OFFSET) * cbPostChainMerge.fFilmSlope + 0.18f;   \
        branch_slope = cbPostChainMerge.fFilmSlope / (LN_10 * branching_point);                            \
      }                                                                                                    \
    }                                                                                                      \
    /* At I the derivative is not unique; branch >= I keeps the unmodified right slope. */                 \
    if (config.use_toe_linear_interp && cbPostChainMerge.fFilmToeLinearInterp > branching_point) {         \
      float r = pow(branching_point / cbPostChainMerge.fFilmToeLinearInterp, 0.6f);                        \
      branch_slope = 1.f + r * (branch_slope - 1.f)                                                        \
                     + (0.6f * r / branching_point) * (branch_output - branching_point);                   \
      branch_output = branching_point + r * (branch_output - branching_point);                             \
    }                                                                                                      \
    T shoulderless = FilmEnhancedBaseline(input, enhanced_config);                                         \
    T branch_delta = input - (T)branching_point;                                                           \
    T tangent = mad(branch_delta, (T)branch_slope, (T)branch_output);                                      \
    float extension_span = max(abs(branching_point - pow(10.f, enhanced_config.toe_start)),                \
                               branching_point * (1.f - pow(10.f, -intrinsic_log_span)));                  \
    T result = lerp(shoulderless, tangent,                                                                 \
                    (1.f - tonemapped_lerp) * FilmEnhancedSmoothStep(branch_delta / extension_span));      \
    return renodx::math::Select(input > 0.f, result, (T)0.f);                                              \
  }                                                                                                        \
  T ApplyFilmToneMapExtendedEnhanced(T input, float film_white_clip,                                       \
                                     float tonemapped_lerp = 0.f) {                                        \
    return ApplyFilmToneMapExtendedEnhanced(                                                               \
        input, CreateFilmTonemapConfig(film_white_clip), tonemapped_lerp);                                 \
  }

APPLY_FILM_TONEMAP_EXTENDED_ENHANCED_GENERATOR(float)
APPLY_FILM_TONEMAP_EXTENDED_ENHANCED_GENERATOR(float3)
APPLY_FILM_TONEMAP_EXTENDED_ENHANCED_GENERATOR(float4)
#undef APPLY_FILM_TONEMAP_EXTENDED_ENHANCED_GENERATOR

// samples the lutbuilder, scaling is done separately inside the lutbuilder
renodx::lut::Config CreateLUTConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.scaling = 0.f;
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 16u;
  lut_config.gamut_compress = 0.f;
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
  [branch]
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

  [branch]
  if (config.dechroma != 0.f) {
    chroma_scale *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
  }

  [branch]
  if (config.highlight_saturation != 0.f) {
    float percent_max = saturate(y * 100.f / 10000.f);
    float blowout_strength = 100.f;
    float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.highlight_saturation));
    if (config.highlight_saturation < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    chroma_scale *= blowout_change;
  }

  [branch]
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
