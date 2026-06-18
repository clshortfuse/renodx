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

float3 TransferPurityAndWeightedHueFromLMS(
    float3 lms_source,
    float3 lms_target,
    float purity_loss_hue_power = 1.f,
    float baseline_hue_amount = 0.f,
    float purity_amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f,
    bool compress_bt2020 = false) {
  float3 mb_source = renodx::color::macleod_boynton::from::LMS(lms_source);
  float3 mb_target = renodx::color::macleod_boynton::from::LMS(lms_target);
  float2 mb_white = renodx::color::macleod_boynton::from::D65XY();

  float2 source_offset = mb_source.xy - mb_white;
  float2 target_offset = mb_target.xy - mb_white;
  float src_radius = length(source_offset);
  float tgt_radius = length(target_offset);
  if (tgt_radius <= eps) return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(lms_target, 1.f) : lms_target;

  // Per-channel hue weight from purity delta:
  // - purity gain  (source radius > target radius): less source hue, down to 0
  // - no change    (source radius == target radius): 0.5 source hue
  // - purity loss  (source radius < target radius): more source hue, up to 1
  float no_change_distance = max(tgt_radius - eps, eps);
  float purity_delta = src_radius - tgt_radius;
  float raw_hue_amount = saturate(0.5f - (purity_delta / (2.f * no_change_distance)));
  float purity_loss_hue_signal = saturate((raw_hue_amount - 0.5f) * 2.f);
  purity_loss_hue_signal = 1.f - pow(1.f - purity_loss_hue_signal, max(purity_loss_hue_power, eps));
  float purity_loss_hue_amount = 0.5f + (0.5f * purity_loss_hue_signal);
  float hue_amount = lerp(raw_hue_amount, purity_loss_hue_amount, step(0.5f, raw_hue_amount));
  hue_amount = max(hue_amount, saturate(baseline_hue_amount));

  float2 source_hue_offset = source_offset * (tgt_radius / max(src_radius, eps));
  float2 hue_offset = lerp(target_offset, source_hue_offset, hue_amount);
  float hue_radius = length(hue_offset);

  if (hue_radius <= eps) return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(lms_target, 1.f) : lms_target;

  float transfer_scale = src_radius / max(hue_radius, eps);
  float no_purity_loss_scale = max(transfer_scale, 1.f);
  transfer_scale = lerp(transfer_scale, no_purity_loss_scale, clamp_purity_loss);
  float scale = lerp(1.f, transfer_scale, purity_amount);
  float2 mb_scaled = mb_white + hue_offset * scale;

  float3 output_lms = renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb_target.z));
  return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(output_lms, 1.f) : output_lms;
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

  config.toe_start = ((0.8199999928474426f - cbPostChainMerge.fFilmToe) / cbPostChainMerge.fFilmSlope) + -0.7329999804496765f;
  config.toe_range = toe_width * 2.0f;
  config.toe_exponent_scale = ((cbPostChainMerge.fFilmSlope * -2.0f) / toe_width) * 1.4426950216293335f;
  config.shoulder_start = ((cbPostChainMerge.fFilmShoulder + -0.18000000715255737f) / cbPostChainMerge.fFilmSlope) + -0.7329999804496765f;
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
  T ApplyFilmToneMap(T untonemapped, const FilmTonemapConfig config) {                                                                                                                                                     \
    T log_value = log2(untonemapped) * 0.3010300099849701f;                                                                                                                                                                \
    T linear_value = ((log_value + 0.7329999804496765f) * cbPostChainMerge.fFilmSlope) + 0.18000000715255737f;                                                                                                             \
    T toe_delta = log_value - config.toe_start;                                                                                                                                                                            \
    T toe_value = select((log_value < config.toe_start), ((config.toe_range / (exp2(config.toe_exponent_scale * toe_delta) + 1.0f)) - cbPostChainMerge.fFilmBlackClip), linear_value);                                     \
    T mid_blend = saturate(toe_delta / config.mid_range);                                                                                                                                                                  \
    T film_blend = select(config.invert_mid_range, (1.0f - mid_blend), mid_blend);                                                                                                                                         \
    T shoulder_value = select((log_value > config.shoulder_start), (config.shoulder_white - (config.shoulder_range / (exp2(config.shoulder_exponent_scale * (log_value - config.shoulder_start)) + 1.0f))), linear_value); \
    T tonemapped = select((untonemapped < 1.0000000036274937e-15f), config.black_level, (((film_blend * film_blend) * (shoulder_value - toe_value)) * (3.0f - (film_blend * 2.0f))) + toe_value);                          \
    if (config.use_toe_linear_interp) {                                                                                                                                                                                    \
      return (saturate(exp2(log2(untonemapped / cbPostChainMerge.fFilmToeLinearInterp) * 0.6000000238418579f)) * (tonemapped - untonemapped)) + untonemapped;                                                              \
    }                                                                                                                                                                                                                      \
    return tonemapped;                                                                                                                                                                                                     \
  }                                                                                                                                                                                                                        \
  T ApplyFilmToneMap(T untonemapped, float film_white_clip) {                                                                                                                                                              \
    return ApplyFilmToneMap(untonemapped, CreateFilmTonemapConfig(film_white_clip));                                                                                                                                       \
  }

APPLY_FILM_TONEMAP_GENERATOR(float)
APPLY_FILM_TONEMAP_GENERATOR(float3)

#undef APPLY_FILM_TONEMAP_GENERATOR

float ComputeFilmTonemapSlopeAtInput(const FilmTonemapConfig config, float input) {
  float eps = max(input * (1.0f / 1024.0f), 1e-5f);
  float low = ApplyFilmToneMap(input - eps, config);
  float high = ApplyFilmToneMap(input + eps, config);

  return (high - low) / (2.0f * eps);
}

#define APPLY_FILM_TONEMAP_EXTENDED_GENERATOR(T)                                                                          \
  T ApplyFilmToneMapExtended(T untonemapped, T tonemapped, const FilmTonemapConfig config, float tonemapped_lerp = 0.f) { \
    const float pivot_input = 0.18f;                                                                                      \
    const float pivot_output = ApplyFilmToneMap(0.18, config); /* no longer 0.18 in/out*/                                 \
    float pivot_slope = ComputeFilmTonemapSlopeAtInput(config, pivot_input);                                              \
    T extended_tonemapped = (pivot_slope * (untonemapped - pivot_input)) + pivot_output;                                  \
    extended_tonemapped = lerp(extended_tonemapped, tonemapped, tonemapped_lerp);                                         \
                                                                                                                          \
    return select((untonemapped < (T)pivot_input), tonemapped, extended_tonemapped);                                      \
  }                                                                                                                       \
  T ApplyFilmToneMapExtended(T untonemapped, const FilmTonemapConfig config, float tonemapped_lerp = 0.f) {               \
    T tonemapped = ApplyFilmToneMap(untonemapped, config);                                                                \
    return ApplyFilmToneMapExtended(untonemapped, tonemapped, config, tonemapped_lerp);                                   \
  }                                                                                                                       \
  T ApplyFilmToneMapExtended(T untonemapped, float film_white_clip, float tonemapped_lerp = 0.f) {                        \
    return ApplyFilmToneMapExtended(untonemapped, CreateFilmTonemapConfig(film_white_clip), tonemapped_lerp);             \
  }

APPLY_FILM_TONEMAP_EXTENDED_GENERATOR(float)
APPLY_FILM_TONEMAP_EXTENDED_GENERATOR(float3)

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
