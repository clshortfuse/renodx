#include "../common.hlsli"

#define LMS_WHITE_BT709  renodx::color::lms::from::BT709(1.0f)
#define LMS_WHITE_BT2020 renodx::color::lms::from::BT2020(1.0f)

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

void CalculateFilmTonemapHDRHeadroom(inout float hdr_scale, inout float hdr_headroom, inout float film_white_clip) {
  float black_offset = cbPostChainMerge.vHDRParams.x;
  float peak_white = cbPostChainMerge.vHDRParams.y;
  float diffuse_white = cbPostChainMerge.vHDRParams.z;
  if (TONE_MAP_TYPE != 0.f) {
    hdr_scale = 1.f;
    hdr_headroom = 0.f;
    film_white_clip = cbPostChainMerge.fFilmWhiteClip;
  } else {
    hdr_scale = max((peak_white - black_offset), diffuse_white) / diffuse_white;
    hdr_headroom = hdr_scale - 1.f;
    film_white_clip = max(hdr_headroom, cbPostChainMerge.fFilmWhiteClip);
  }
}

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

float3 ApplyHuePurityFromLMS(
    float3 lms_source,
    float3 lms_target,
    float amount = 1.f,
    float hue_amount = 0.f,
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

  float2 source_hue_offset = source_offset * (tgt_radius / max(src_radius, eps));
  float2 hue_offset = lerp(target_offset, source_hue_offset, saturate(hue_amount));
  float hue_radius = length(hue_offset);

  if (hue_radius <= eps) return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(lms_target, 1.f) : lms_target;

  float transfer_scale = src_radius / max(hue_radius, eps);
  float no_purity_loss_scale = max(transfer_scale, 1.f);
  transfer_scale = lerp(transfer_scale, no_purity_loss_scale, clamp_purity_loss);
  float scale = lerp(1.f, transfer_scale, amount);
  float2 mb_scaled = mb_white + hue_offset * scale;

  float3 output_lms = renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb_target.z));
  return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(output_lms, 1.f) : output_lms;
}

float3 ApplyWeightedHuePurityFromLMS(
    float3 lms_source,
    float3 lms_target,
    float amount = 1.f,
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
  float hue_amount = saturate(0.5f - (purity_delta / (2.f * no_change_distance)));

  float2 source_hue_offset = source_offset * (tgt_radius / max(src_radius, eps));
  float2 hue_offset = lerp(target_offset, source_hue_offset, hue_amount);
  float hue_radius = length(hue_offset);

  if (hue_radius <= eps) return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(lms_target, 1.f) : lms_target;

  float transfer_scale = src_radius / max(hue_radius, eps);
  float no_purity_loss_scale = max(transfer_scale, 1.f);
  transfer_scale = lerp(transfer_scale, no_purity_loss_scale, clamp_purity_loss);
  float scale = lerp(1.f, transfer_scale, amount);
  float2 mb_scaled = mb_white + hue_offset * scale;

  float3 output_lms = renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb_target.z));
  return compress_bt2020 ? renodx::color::gamut::GamutCompressLMSBoundBT2020(output_lms, 1.f) : output_lms;
}

float3 ApplyPurityFromLMS(
    float3 lms_source,
    float3 lms_target,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f,
    bool compress_bt2020 = false) {
  return ApplyHuePurityFromLMS(lms_source, lms_target, amount, 0.f, clamp_purity_loss, eps, compress_bt2020);
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
  lut_config.recolor = 0.f;
  lut_config.gamut_compress = 0.f;
  lut_config.strength = COLOR_GRADE_LUT_STRENGTH;
  return lut_config;
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
