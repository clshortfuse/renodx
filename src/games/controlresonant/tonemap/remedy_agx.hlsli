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

struct RemedyAgXParameters {
  renodx::tonemap::agx::ToneScale tone_scale;
  renodx::tonemap::agx::GamutTransforms gamut;

  // Remedy's separate HDR expansion.
  float hdr_ratio;
  float hdr_mid_gray;
  float hdr_toe_scale;
  float hdr_shoulder_scale;

  // Linear-domain tangent continuation used by Vanilla+/Enhanced.
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
    float hdr_shoulder_scale) {
  RemedyAgXParameters params;

  const float mid_gray_log2 = log2(REMEDY_AGX_MID_GRAY);

  renodx::tonemap::agx::ToneScaleParameters tone_scale_parameters;
  tone_scale_parameters.min_ev = min_log2_linear - mid_gray_log2;
  tone_scale_parameters.max_ev = max_log2_linear - mid_gray_log2;
  tone_scale_parameters.input_mid_gray = REMEDY_AGX_MID_GRAY;
  tone_scale_parameters.output_pivot = pow(REMEDY_AGX_MID_GRAY, 1.f / REMEDY_AGX_OUTPUT_GAMMA);
  tone_scale_parameters.toe_power = toe_power;
  tone_scale_parameters.shoulder_power = shoulder_power;
  tone_scale_parameters.slope = contrast_slope;
  tone_scale_parameters.output_power = REMEDY_AGX_OUTPUT_GAMMA;

  params.tone_scale =
      renodx::tonemap::agx::BuildToneScale(tone_scale_parameters, toe_scale, shoulder_scale);

  // Remedy fixes the sigmoid pivot to EV 0's normalized position in a
  // -10/+6.5-stop range, independently of the supplied log bounds.
  params.tone_scale.input_pivot = REMEDY_AGX_LOG_PIVOT;

  params.gamut.inset = float3x3(inset_row_0, inset_row_1, inset_row_2);
  params.gamut.outset = float3x3(outset_row_0, outset_row_1, outset_row_2);

  params.hdr_ratio = hdr_ratio;
  params.hdr_mid_gray = hdr_mid_gray;
  params.hdr_toe_scale = hdr_toe_scale;
  params.hdr_shoulder_scale = hdr_shoulder_scale;

  // Linear-light input value at Remedy's fixed normalized-log pivot.
  // This evaluates to 18% for the game's standard log bounds.
  params.input_pivot_linear =
      renodx::tonemap::agx::DecodeLog2(params.tone_scale.input_pivot, params.tone_scale);

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
  color = renodx::tonemap::agx::ApplyInset(color, params.gamut);
  color = renodx::tonemap::agx::EncodeLog2(color, params.tone_scale);
  color = renodx::tonemap::agx::ApplySigmoid(color, params.tone_scale);

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
  const float3 relative_ev = min(max(log2(max(color, 1e-12f) / params.hdr_mid_gray), -HDR_TOE_STOPS), max_ev);

  const float hdr_input_pivot = HDR_TOE_STOPS / ev_range;
  const float hdr_output_pivot = (HDR_TOE_STOPS - log2(params.hdr_ratio)) / ev_range;

  const float3 hdr_shoulder = ((relative_ev / ev_range) * HDR_SLOPE) / params.hdr_shoulder_scale;
  const float3 hdr_toe = (-relative_ev / ev_range) * (HDR_SLOPE / params.hdr_toe_scale);

  color = ApplyRemedyAgXSigmoid(
      hdr_shoulder,
      hdr_toe,
      ((relative_ev + HDR_TOE_STOPS) / ev_range) >= hdr_input_pivot,
      HDR_SHOULDER_POWER,
      HDR_TOE_POWER,
      params.hdr_shoulder_scale,
      params.hdr_toe_scale);

  return saturate(exp2(((color + hdr_output_pivot) * ev_range) - HDR_TOE_STOPS) * params.hdr_mid_gray) * params.hdr_ratio;
}

#endif  // RENODX_GAMES_CONTROLRESONANT_REMEDY_AGX_HLSLI_
