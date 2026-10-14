#ifndef RENODX_GAMES_CONTROLRESONANT_REMEDY_AGX_HLSLI_
#define RENODX_GAMES_CONTROLRESONANT_REMEDY_AGX_HLSLI_

#include "../common.hlsli"

// Remedy stores its SDR AgX bounds as absolute log2(scene-linear) values.
// RenoDX AgX expresses them as stops relative to 18% mid gray.
static const float REMEDY_AGX_MID_GRAY = 0.18f;
static const float REMEDY_AGX_SHADOW_STOPS = 10.f;
static const float REMEDY_AGX_HIGHLIGHT_STOPS = 6.5f;
static const float REMEDY_AGX_LOG_PIVOT =
    REMEDY_AGX_SHADOW_STOPS / (REMEDY_AGX_SHADOW_STOPS + REMEDY_AGX_HIGHLIGHT_STOPS);
static const float REMEDY_AGX_OUTPUT_GAMMA = 2.4f;

// Game-local representation of Remedy's supplied curve constants and matrices.
struct RemedyAgXToneScaleParameters {
  float min_ev;
  float max_ev;
  float input_mid_gray;
  float output_pivot;
  float toe_power;
  float shoulder_power;
  float slope;
  float output_power;
};

struct RemedyAgXToneScale {
  RemedyAgXToneScaleParameters parameters;
  float inverse_ev_range;
  float minimum_linear;
  float input_pivot;
  float toe_scale;
  float shoulder_scale;
  float inverse_toe_power;
  float inverse_shoulder_power;
};

struct RemedyAgXGamutTransforms {
  float3x3 inset;
  float3x3 outset;
};

RemedyAgXToneScale BuildRemedyAgXToneScale(RemedyAgXToneScaleParameters parameters, float toe_scale, float shoulder_scale) {
  RemedyAgXToneScale tone_scale;
  tone_scale.parameters = parameters;
  const float ev_range = parameters.max_ev - parameters.min_ev;
  tone_scale.inverse_ev_range = 1.f / ev_range;
  tone_scale.minimum_linear = parameters.input_mid_gray * exp2(parameters.min_ev);
  tone_scale.input_pivot = -parameters.min_ev * tone_scale.inverse_ev_range;
  tone_scale.toe_scale = toe_scale;
  tone_scale.shoulder_scale = shoulder_scale;
  tone_scale.inverse_toe_power = 1.f / parameters.toe_power;
  tone_scale.inverse_shoulder_power = 1.f / parameters.shoulder_power;
  return tone_scale;
}

float DecodeRemedyAgXLog2(float value, RemedyAgXToneScale tone_scale) {
  const float ev_range = tone_scale.parameters.max_ev - tone_scale.parameters.min_ev;
  const float ev = value * ev_range + tone_scale.parameters.min_ev;
  return tone_scale.parameters.input_mid_gray * exp2(ev);
}

#define REMEDY_AGX_SIGMOID_GENERATOR(T, B)                                                                                       \
  T ApplyRemedyAgXToneScaleSigmoid(T value, RemedyAgXToneScale tone_scale) {                                                     \
    const RemedyAgXToneScaleParameters parameters = tone_scale.parameters;                                                       \
    const B use_shoulder = value >= tone_scale.input_pivot;                                                                      \
    const T distance = abs(value - tone_scale.input_pivot);                                                                      \
    const T power = renodx::math::Select(use_shoulder, parameters.shoulder_power, parameters.toe_power);                         \
    const T scale = renodx::math::Select(use_shoulder, tone_scale.shoulder_scale, tone_scale.toe_scale);                         \
    const T inverse_power = renodx::math::Select(use_shoulder, tone_scale.inverse_shoulder_power, tone_scale.inverse_toe_power); \
    const T mapped = parameters.slope * distance / scale;                                                                        \
    const T powered = renodx::math::SignPow(mapped, power);                                                                      \
    const T response = renodx::math::SignPow(1.f + powered, inverse_power);                                                      \
    const T shaped = scale * mapped / response;                                                                                  \
    return parameters.output_pivot + renodx::math::Select(use_shoulder, shaped, -shaped);                                        \
  }

REMEDY_AGX_SIGMOID_GENERATOR(float, bool)
REMEDY_AGX_SIGMOID_GENERATOR(float3, bool3)
#undef REMEDY_AGX_SIGMOID_GENERATOR

struct RemedyAgXParameters {
  RemedyAgXToneScale tone_scale;
  RemedyAgXGamutTransforms gamut;

  // Remedy's separate HDR expansion.
  float hdr_ratio;
  float hdr_mid_gray;
  float hdr_toe_scale;
  float hdr_shoulder_scale;
  float hdr_saturation;

  // Linear-domain tangent continuation used by Vanilla+/Customized.
  float input_pivot_linear;
  float output_pivot_linear;
  float linear_tangent_slope;
};

RemedyAgXParameters CreateRemedyAgXParameters(
    float min_log2_linear,
    float max_log2_linear,
    float toe_power,
    float shoulder_power,
    float contrast_slope,
    float toe_scale,
    float shoulder_scale,
    float3 inset_row_0,
    float3 inset_row_1,
    float3 inset_row_2,
    float3 outset_row_0,
    float3 outset_row_1,
    float3 outset_row_2,
    float hdr_ratio,
    float hdr_mid_gray,
    float hdr_toe_scale,
    float hdr_shoulder_scale,
    float hdr_saturation) {
  RemedyAgXParameters params;

  const float mid_gray_log2 = log2(REMEDY_AGX_MID_GRAY);

  RemedyAgXToneScaleParameters tone_scale_parameters;
  tone_scale_parameters.min_ev = min_log2_linear - mid_gray_log2;
  tone_scale_parameters.max_ev = max_log2_linear - mid_gray_log2;
  tone_scale_parameters.input_mid_gray = REMEDY_AGX_MID_GRAY;
  tone_scale_parameters.output_pivot = pow(REMEDY_AGX_MID_GRAY, 1.f / REMEDY_AGX_OUTPUT_GAMMA);
  tone_scale_parameters.toe_power = toe_power;
  tone_scale_parameters.shoulder_power = shoulder_power;
  tone_scale_parameters.slope = contrast_slope;
  tone_scale_parameters.output_power = REMEDY_AGX_OUTPUT_GAMMA;

  params.tone_scale =
      BuildRemedyAgXToneScale(tone_scale_parameters, toe_scale, shoulder_scale);

  // Remedy fixes the sigmoid pivot to EV 0's normalized position in a
  // -10/+6.5-stop range, independently of the supplied log bounds.
  params.tone_scale.input_pivot = REMEDY_AGX_LOG_PIVOT;

  params.gamut.inset = float3x3(inset_row_0, inset_row_1, inset_row_2);
  params.gamut.outset = float3x3(outset_row_0, outset_row_1, outset_row_2);

  params.hdr_ratio = hdr_ratio;
  params.hdr_mid_gray = hdr_mid_gray;
  params.hdr_toe_scale = hdr_toe_scale;
  params.hdr_shoulder_scale = hdr_shoulder_scale;
  params.hdr_saturation = hdr_saturation;

  // Linear-light input value at Remedy's fixed normalized-log pivot.
  // This evaluates to 18% for the game's standard log bounds.
  params.input_pivot_linear =
      DecodeRemedyAgXLog2(params.tone_scale.input_pivot, params.tone_scale);

  params.output_pivot_linear = REMEDY_AGX_MID_GRAY;

  // Linear-light derivative of the SDR AgX curve at the pivot.
  params.linear_tangent_slope =
      tone_scale_parameters.output_power
      * pow(tone_scale_parameters.output_pivot, tone_scale_parameters.output_power - 1.f)
      * tone_scale_parameters.slope
      * params.tone_scale.inverse_ev_range
      / (log(2.f) * params.input_pivot_linear);

  return params;
}

// Remedy's HDR expansion uses the same AgX sigmoid form with a separate
// CPU-precomputed toe/shoulder pair.
float3 ApplyRemedyAgXSigmoid(
    float3 shoulder,
    float3 toe,
    bool3 use_shoulder,
    float shoulder_power,
    float toe_power,
    float shoulder_scale,
    float toe_scale) {
  return select(
      use_shoulder,
      (shoulder / pow(renodx::math::SignPow(shoulder, shoulder_power) + 1.f, 1.f / shoulder_power)) * shoulder_scale,
      (toe / pow(renodx::math::SignPow(toe, toe_power) + 1.f, 1.f / toe_power)) * -toe_scale);
}

static const float3x3 REMEDY_BT2020_TO_BT709 = float3x3(
    1.6604962f, -0.58765644f, -0.072839774f,
    -0.124547094f, 1.1328951f, -0.008348013f,
    -0.01815368f, -0.100597374f, 1.118751f);

float3 ApplyVanillaSDRAgX(float3 color, RemedyAgXParameters params) {
  color = mul(params.gamut.inset, max(color, 0.f));
  color = max(color, params.tone_scale.minimum_linear);
  const float3 ev = log2(color / params.tone_scale.parameters.input_mid_gray);
  color = saturate((ev - params.tone_scale.parameters.min_ev) * params.tone_scale.inverse_ev_range);
  color = ApplyRemedyAgXToneScaleSigmoid(color, params.tone_scale);

  // Preserve Remedy's original ordering:
  // outset in the sigmoid-output domain, then linearize.
  color = mul(params.gamut.outset, color);

  // Remedy floors negative sigmoid/output-gamut values before the output gamma.
  return pow(max(color, 0.f), params.tone_scale.parameters.output_power);
}

float3 ApplyVanillaHDRExpansion(float3 color, RemedyAgXParameters params) {
  if (params.hdr_ratio <= 1.f) {
    return color;
  }

  if (renodx::math::Max(color) < params.hdr_mid_gray) {
    return color;
  }

  static const float HDR_TOE_STOPS = 20.f;
  static const float HDR_SHOULDER_POWER = 1.f;
  static const float HDR_TOE_POWER = 3.f;

  // Slightly above 1 to avoid the sigmoid degenerating when hdr_ratio == 1.
  static const float HDR_SLOPE = 1.000001f;

  const float max_ev = log2(1.f / params.hdr_mid_gray);
  const float ev_range = max_ev + HDR_TOE_STOPS;
  const float log_hdr_ratio = log2(params.hdr_ratio);
  const float3 relative_ev = min(max(log2(max(color, 1e-12f) / params.hdr_mid_gray), -HDR_TOE_STOPS), max_ev);
  const float3 log_color = (relative_ev + HDR_TOE_STOPS) / ev_range;
  const float max_log_color = renodx::math::Max(log_color);

  const float hdr_input_pivot = HDR_TOE_STOPS / ev_range;
  const float hdr_output_pivot = (HDR_TOE_STOPS - log_hdr_ratio) / ev_range;

  const float hdr_shoulder = ((max_log_color - hdr_input_pivot) * HDR_SLOPE) / params.hdr_shoulder_scale;
  const float hdr_toe = (HDR_SLOPE / params.hdr_toe_scale) * (hdr_input_pivot - max_log_color);

  const float mapped_max =
      ApplyRemedyAgXSigmoid(
          hdr_shoulder.xxx,
          hdr_toe.xxx,
          max_log_color >= hdr_input_pivot,
          HDR_SHOULDER_POWER,
          HDR_TOE_POWER,
          params.hdr_shoulder_scale,
          params.hdr_toe_scale)
          .x
      + hdr_output_pivot;

  const float saturation_scale = exp2(((mapped_max - max_log_color) * ev_range + log_hdr_ratio) * params.hdr_saturation);

  color = exp2((mapped_max + saturation_scale * (log_color - max_log_color)) * ev_range - HDR_TOE_STOPS)
          * params.hdr_mid_gray;

  return saturate(color) * params.hdr_ratio;
}

#endif  // RENODX_GAMES_CONTROLRESONANT_REMEDY_AGX_HLSLI_
