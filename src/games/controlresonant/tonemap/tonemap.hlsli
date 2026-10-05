#include "../common.hlsli"
#include "remedy_agx.hlsli"

float ConditionalOverrideGameBrightness(float original_paper_white, int hdr_enabled) {
  return (hdr_enabled == 0 || TONE_MAP_TYPE == 0.f)
             ? original_paper_white
             : RENODX_DIFFUSE_WHITE_NITS / 80.f;
}

float3 CInfinityTransition(float3 position) {
  position = saturate(position);
  return rcp(1.f + exp2((1.f - 2.f * position) / (position * (1.f - position))));
}

float3 ApplyAnchoredTonalGrading(
    float3 color,
    float3 anchor_in, float3 anchor_out,
    float contrast, float flare,
    float highlight_contrast, float shadow_contrast,
    float highlights, float shadows) {
  [branch]
  if (contrast == 1.f && flare == 0.f
      && highlight_contrast == 1.f && shadow_contrast == 1.f
      && highlights == 1.f && shadows == 1.f
      && all(anchor_in == anchor_out)) {
    return color;
  }

  const float3 signed_normalized = color / anchor_in;
  const float3 normalized = abs(signed_normalized);
  float3 graded_normalized = normalized;

  [branch]
  if (contrast != 1.f || flare > 0.f) {
    float3 exponent = contrast;

    [branch]
    if (flare > 0.f) {
      const float3 shadow_distance = saturate(1.f - normalized);
      const float3 flat_shadow_weight = exp2(-normalized / shadow_distance);

      exponent *= mad(flat_shadow_weight, flare / (normalized + flare), 1.f);
    }

    const float3 input_stops = log2(normalized);
    const float3 highlight_stops = max(input_stops, 0.f);
    float3 output_highlight_stops = highlight_stops;

    [branch]
    if (contrast != 1.f) {
      const float3 displacement = (contrast - 1.f) * highlight_stops;
      const float3 displacement_magnitude = abs(displacement);

      output_highlight_stops += displacement / mad(displacement_magnitude, exp2(-1.f / displacement_magnitude), 1.f);
    }

    graded_normalized = exp2(mad(exponent, min(input_stops, 0.f), output_highlight_stops));
  }

  [branch]
  if (highlight_contrast != 1.f) {
    const float3 distance = max(graded_normalized - 1.f, 0.f);
    const float3 distance_squared = distance * distance;
    const float3 flat_distance = (1.f + distance_squared) * exp2(-1.f / distance_squared);

    graded_normalized += distance * (pow(1.f + flat_distance, 0.5f * (highlight_contrast - 1.f)) - 1.f);
  }

  [branch]
  if (shadow_contrast != 1.f) {
    const float3 distance = saturate(1.f - graded_normalized);
    const float3 distance_squared = distance * distance;
    const float3 flat_distance = distance_squared * distance * exp2(1.f - 1.f / distance_squared);

    graded_normalized *= pow(1.f + flat_distance, 1.f - shadow_contrast);
  }

  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    static const float TONAL_OFFSET_START_STOPS = 1.f;
    static const float TONAL_OFFSET_END_STOPS = 8.f;
    static const float TONAL_OFFSET_INVERSE_RANGE_STOPS = 1.f / (TONAL_OFFSET_END_STOPS - TONAL_OFFSET_START_STOPS);

    const float3 tonal_stops = log2(graded_normalized);
    float3 tonal_displacement = 0.f;

    [branch]
    if (highlights != 1.f) {
      const float adjustment = highlights - 1.f;
      const float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      const float3 weight = CInfinityTransition((tonal_stops - TONAL_OFFSET_START_STOPS) * TONAL_OFFSET_INVERSE_RANGE_STOPS);

      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    [branch]
    if (shadows != 1.f) {
      const float adjustment = shadows - 1.f;
      const float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      const float3 weight = CInfinityTransition((-TONAL_OFFSET_START_STOPS - tonal_stops) * TONAL_OFFSET_INVERSE_RANGE_STOPS);

      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    graded_normalized *= exp2(tonal_displacement);
  }

  return renodx::math::CopySign(graded_normalized, signed_normalized) * anchor_out;
}

// Linear BT.2020 grading; anchor_y must be positive.
// grading_source drives highlight detection independently of the color being adjusted.
// anchor_y is the input luminance anchor of grading_source, not the output color's anchor.
float3 ApplyAnchoredSaturationGrading(
    float3 color, float3 grading_source,
    float anchor_y,
    float saturation, float highlight_saturation, float dechroma) {
  [branch]
  if (saturation == 1.f && highlight_saturation == 1.f && dechroma == 0.f) {
    return color;
  }

  const float3 anchor_lms = renodx::color::lms::from::BT2020(anchor_y.xxx);
  float effective_purity_scale = saturation;

  [branch]
  if (dechroma != 0.f || highlight_saturation != 1.f) {
    static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
    static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
    static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

    float source_relative_yf = max(
        renodx::color::yf::from::LMS(renodx::color::lms::from::BT2020(grading_source) / anchor_lms)
            / renodx::color::yf::from::LMS(1.f.xxx),
        0.f);
    float rolloff_position = saturate(log2(max(source_relative_yf, 1.f)) * INVERSE_HIGHLIGHT_RANGE_STOPS);
    float rolloff_position_squared = rolloff_position * rolloff_position;

    float rolloff = rolloff_position_squared * rolloff_position * mad(rolloff_position, mad(6.f, rolloff_position, -15.f), 10.f);

    [branch]
    if (dechroma != 0.f) {
      effective_purity_scale *= mad(-dechroma, rolloff, 1.f);
    }

    [branch]
    if (highlight_saturation != 1.f) {
      float highlight_rolloff = rolloff * rolloff * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);

      effective_purity_scale *= mad(highlight_saturation - 1.f, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
    }
  }

  [branch]
  if (effective_purity_scale == 1.f) return color;

  // Fixed-Yf MB chromaticity interpolation toward the anchor, evaluated in LMS
  // without dividing by pixel Yf. This also retains signed and zero-Yf states.
  return renodx::color::bt2020::from::LMS(
      renodx::tonemap::psychov::psycho30_ApplyAdaptiveRelativePurity(
          renodx::color::lms::from::BT2020(color), anchor_lms, effective_purity_scale)
      * anchor_lms);
}

float3 RejectNonPositiveBT709Luminance(float3 color) {
  return renodx::color::yf::from::BT709(color) <= 0.f
             ? 0.f
             : color;
}

// -----------------------------------------------------------------------------
// Tone-map modes
//
// 0: Vanilla
// 1: RenoDX (Vanilla+)
// 2: RenoDX (Customized)
// 3: RenoDX (PsychoV)
// 4: SDR
// -----------------------------------------------------------------------------

float3 ApplyVanillaToneMap(float3 untonemapped, RemedyAgXParameters params) {
  float3 color = ApplyVanillaSDRAgX(untonemapped, params);

  color = ApplyVanillaHDRExpansion(color, params);

  return mul(REMEDY_BT2020_TO_BT709, color);
}

static const float REMEDY_AGX_WHITE_CLIP = 72.f;  // untonemapped typically doesn't get brighter than this

struct RemedyAgXCurveParameters {
  renodx::tonemap::agx::ToneScale tone_scale;
  float input_pivot_linear;
  float output_pivot_linear;
  float linear_tangent_slope;
};

float ApplyVanillaSDRAgXAsymptote(RemedyAgXCurveParameters params) {
  return pow(
      params.tone_scale.parameters.output_pivot + params.tone_scale.shoulder_scale,
      params.tone_scale.parameters.output_power);
}

RemedyAgXCurveParameters GetRemedyAgXCurveParameters(RemedyAgXParameters params) {
  RemedyAgXCurveParameters curve;
  curve.tone_scale = params.tone_scale;
  curve.input_pivot_linear = params.input_pivot_linear;
  curve.output_pivot_linear = params.output_pivot_linear;
  curve.linear_tangent_slope = params.linear_tangent_slope;
  return curve;
}

RemedyAgXCurveParameters CreateRemedyAgXCurveParameters(
    float min_log2_linear,
    float max_log2_linear,
    float toe_power,
    float shoulder_power,
    float contrast_slope,
    float toe_scale,
    float shoulder_scale) {
  RemedyAgXCurveParameters curve;

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

  curve.tone_scale = renodx::tonemap::agx::BuildToneScale(tone_scale_parameters, toe_scale, shoulder_scale);
  curve.tone_scale.input_pivot = REMEDY_AGX_LOG_PIVOT;

  curve.input_pivot_linear = renodx::tonemap::agx::DecodeLog2(curve.tone_scale.input_pivot, curve.tone_scale);
  curve.output_pivot_linear = REMEDY_AGX_MID_GRAY;
  curve.linear_tangent_slope =
      tone_scale_parameters.output_power * pow(tone_scale_parameters.output_pivot, tone_scale_parameters.output_power - 1.f)
      * tone_scale_parameters.slope * curve.tone_scale.inverse_ev_range / (log(2.f) * curve.input_pivot_linear);

  return curve;
}

#define APPLY_REMEDY_AGX_CURVE_GENERATOR(T)                                                                        \
  void ApplyRemedyAgXCurve(                                                                                        \
      T color, RemedyAgXCurveParameters params, out T sdr_gamma, out T sdr_linear, out T extended_linear) {        \
    const float output_power = params.tone_scale.parameters.output_power;                                          \
                                                                                                                   \
    const T safe_color = max(color, params.tone_scale.minimum_linear);                                             \
    const T ev = log2(safe_color / params.tone_scale.parameters.input_mid_gray);                                   \
    const T log_color = max((ev - params.tone_scale.parameters.min_ev) * params.tone_scale.inverse_ev_range, 0.f); \
                                                                                                                   \
    sdr_gamma = renodx::tonemap::agx::ApplySigmoid(log_color, params.tone_scale);                                  \
    sdr_linear = pow(max(sdr_gamma, 0.f), output_power);                                                           \
                                                                                                                   \
    extended_linear = select(                                                                                      \
        color > params.input_pivot_linear,                                                                         \
        params.output_pivot_linear + params.linear_tangent_slope * (color - params.input_pivot_linear),            \
        sdr_linear);                                                                                               \
  }

APPLY_REMEDY_AGX_CURVE_GENERATOR(float)
APPLY_REMEDY_AGX_CURVE_GENERATOR(float3)

#undef APPLY_REMEDY_AGX_CURVE_GENERATOR

// Harmonic mean (power mean p = -1) between the finite AgX response and its
// linear-light tangent extension. Inputs and output remain linear-light.
struct RemedyAgXBlendParameters {
  float sdr_weight;
  float extended_weight;
  uint valid;
};

RemedyAgXBlendParameters CreateRemedyAgXBlendParameters(
    RemedyAgXCurveParameters params,
    float hdr_ratio,
    float white_clip = REMEDY_AGX_WHITE_CLIP) {
  RemedyAgXBlendParameters blend;
  blend.sdr_weight = 1.f;
  blend.extended_weight = 0.f;
  blend.valid = 0u;

  float clip_sdr_gamma;
  float clip_sdr_linear;
  float clip_extended_linear;
  ApplyRemedyAgXCurve(white_clip, params, clip_sdr_gamma, clip_sdr_linear, clip_extended_linear);

  if (!(clip_sdr_linear > 0.f) || !(clip_extended_linear > 0.f) || !(hdr_ratio > 0.f)
      || clip_sdr_linear == clip_extended_linear) {
    return blend;
  }

  // Solve signed harmonic-mean weights so white_clip maps exactly to hdr_ratio.
  const float weight_denominator = hdr_ratio * (clip_extended_linear - clip_sdr_linear);
  blend.sdr_weight = clip_sdr_linear * (clip_extended_linear - hdr_ratio) / weight_denominator;
  blend.extended_weight = clip_extended_linear * (hdr_ratio - clip_sdr_linear) / weight_denominator;
  blend.valid = 1u;
  return blend;
}

float ApplyRemedyAgXBlend(float sdr, float extended, RemedyAgXBlendParameters blend) {
  if (blend.valid == 0u || blend.extended_weight == 0.f || sdr == extended) return sdr;
  if (blend.sdr_weight == 0.f) return extended;

  const bool sdr_is_lower = sdr <= extended;
  const float lower = min(sdr, extended);
  const float upper = max(sdr, extended);
  const float lower_weight = sdr_is_lower ? blend.sdr_weight : blend.extended_weight;
  const float upper_weight = sdr_is_lower ? blend.extended_weight : blend.sdr_weight;
  const float denominator = lower_weight + upper_weight * (lower / upper);

  return lower / denominator;
}

float3 ApplyRemedyAgXBlend(float3 sdr, float3 extended, RemedyAgXBlendParameters blend) {
  if (blend.valid == 0u) return sdr;

  const bool3 sdr_is_lower = sdr <= extended;
  const float3 lower = min(sdr, extended);
  const float3 upper = max(sdr, extended);
  const float3 lower_weight = select(sdr_is_lower, blend.sdr_weight.xxx, blend.extended_weight.xxx);
  const float3 upper_weight = select(sdr_is_lower, blend.extended_weight.xxx, blend.sdr_weight.xxx);
  const float3 denominator = lower_weight + upper_weight * (lower / upper);

  return lower / denominator;
}

float3 ApplyVanillaPlusOpponentExpansionLMS(
    float3 sdr_lms,
    float sdr_yf,
    float hdr_yf,
    RemedyAgXCurveParameters params,
    float opponent_strength) {
  const float3 d65_lms = renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;
  const float alpha_l = renodx::tonemap::psychov::PSYCHO30_D65_ALPHA_L;
  const float alpha_m = renodx::tonemap::psychov::PSYCHO30_D65_ALPHA_M;

  // Remove common cone amplitude before pow(); it cancels when Yf is restored.
  float3 source_cones = max(sdr_lms, 0.f) / d65_lms;
  const float cone_scale = renodx::math::Max(source_cones);

  if (!(cone_scale > 0.f)) {
    return sdr_lms;
  }

  source_cones /= cone_scale;

  const float source_cone_yf = alpha_l * source_cones.x + alpha_m * source_cones.y;

  if (!(source_cone_yf > 0.f)) {
    return sdr_lms;
  }

  // Strength 0 preserves the SDR tone map's cone ratios and only changes luminance.
  const float3 luminance_lms = (source_cones / source_cone_yf) * d65_lms * hdr_yf;

  if (opponent_strength == 0.f || hdr_yf == sdr_yf) {
    return luminance_lms;
  }

  const float sdr_asymptote = ApplyVanillaSDRAgXAsymptote(params);
  const float sdr_highlight_range_stops = log2(sdr_asymptote / params.output_pivot_linear);

  if (!(sdr_highlight_range_stops > 0.f)) {
    return luminance_lms;
  }

  // Scale the cone-ratio response in gain/stop space.
  const float hdr_gain_stops = log2(hdr_yf) - log2(sdr_yf);
  const float cone_response_power = exp2(opponent_strength * hdr_gain_stops / sdr_highlight_range_stops);

  const float3 powered_cones = pow(source_cones, cone_response_power);
  const float powered_yf = alpha_l * powered_cones.x + alpha_m * powered_cones.y;

  if (!(powered_yf > 0.f)) {
    return luminance_lms;
  }

  const float3 opponent_lms = (powered_cones / powered_yf) * d65_lms * hdr_yf;

  return !any(isnan(opponent_lms)) && !any(isinf(opponent_lms))
             ? opponent_lms
             : luminance_lms;
}

float3 ApplyVanillaPlusAgXWithOpponentExpansion(
    float3 untonemapped, RemedyAgXParameters params, float hdr_clip_input = 100.f, float opponent_strength = 2.f) {
  const float d65_yf = renodx::tonemap::psychov::PSYCHO30_D65_WHITE_YF;

  const RemedyAgXCurveParameters curve_params = GetRemedyAgXCurveParameters(params);
  const float output_power = curve_params.tone_scale.parameters.output_power;
  const float inverse_output_power = rcp(output_power);

  float3 curve_input = lerp(untonemapped, max(untonemapped, 0.f), TONE_MAP_GAMUT_CLIP);
  curve_input = max(mul(params.gamut.inset, curve_input), 0.f);

  curve_input = ApplyAnchoredTonalGrading(
      curve_input,
      curve_params.input_pivot_linear,
      curve_params.input_pivot_linear,
      RENODX_TONE_MAP_CONTRAST,
      0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
      RENODX_TONE_MAP_CONTRAST_SHADOWS,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS);

  float3 sdr_gamma;
  float3 sdr_linear;
  float3 extended_linear;
  ApplyRemedyAgXCurve(curve_input, curve_params, sdr_gamma, sdr_linear, extended_linear);

  // Preserve Remedy's original outset ordering for both curves.
  const float3 sdr_color = pow(max(mul(params.gamut.outset, sdr_gamma), 0.f), output_power);
  const float3 extended_gamma = pow(max(extended_linear, 0.f), inverse_output_power);
  const float3 extended_color = pow(max(mul(params.gamut.outset, extended_gamma), 0.f), output_power);

  const float3 raw_sdr_lms = renodx::color::lms::from::BT2020(sdr_color);
  const float sdr_yf = renodx::color::yf::from::LMS(raw_sdr_lms) / d65_yf;
  const float extended_yf = renodx::color::yf::from::BT2020(extended_color) / d65_yf;

  if (!(sdr_yf > 0.f) || !(extended_yf > 0.f) || !(params.hdr_ratio > 0.f)) {
    return sdr_color;
  }

  const RemedyAgXBlendParameters blend_params =
      CreateRemedyAgXBlendParameters(curve_params, params.hdr_ratio, hdr_clip_input);
  if (blend_params.valid == 0u) return sdr_color;

  const float hdr_yf = ApplyRemedyAgXBlend(sdr_yf, extended_yf, blend_params);

  // Numerical failure fallback only. Signed extrapolation itself remains enabled.
  if (!(hdr_yf > 0.f) || isinf(hdr_yf)) {
    return sdr_color;
  }

  const float3 output_lms =
      ApplyVanillaPlusOpponentExpansionLMS(raw_sdr_lms, sdr_yf, hdr_yf, curve_params, opponent_strength);

  return renodx::color::bt2020::from::LMS(output_lms);
}

float3 ApplyRenoDXVanillaPlusToneMap(float3 untonemapped, RemedyAgXParameters params) {
  float3 color = ApplyVanillaPlusAgXWithOpponentExpansion(untonemapped, params, 72.f, 2.f);

  color = ApplyAnchoredSaturationGrading(
      color,
      renodx::color::bt2020::from::BT709(untonemapped),
      params.input_pivot_linear,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
      RENODX_TONE_MAP_DECHROMA);

  color = min(color, params.hdr_ratio);
  color = mul(REMEDY_BT2020_TO_BT709, color);

  return color;
}

float3 ApplyRenoDXCustomizedToneMap(float3 untonemapped, RemedyAgXParameters params) {
  untonemapped = RejectNonPositiveBT709Luminance(untonemapped);
  untonemapped = ApplyXYZExpandedBT709GamutClip(untonemapped, TONE_MAP_GAMUT_CLIP);

  float3 color = renodx::color::bt2020::from::BT709(untonemapped);
  color = max(mul(BT2020_TO_CUSTOM_PRIMARIES_MAT, color), 0.f);

  color = ApplyAnchoredTonalGrading(
      color,
      params.output_pivot_linear,
      params.output_pivot_linear,
      RENODX_TONE_MAP_CONTRAST,
      0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
      RENODX_TONE_MAP_CONTRAST_SHADOWS,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS);

  const RemedyAgXCurveParameters curve_params = GetRemedyAgXCurveParameters(params);
  const RemedyAgXBlendParameters blend_params = CreateRemedyAgXBlendParameters(curve_params, params.hdr_ratio);

  float3 sdr_gamma;
  float3 sdr_linear;
  float3 extended_linear;
  ApplyRemedyAgXCurve(color, curve_params, sdr_gamma, sdr_linear, extended_linear);

  color = ApplyRemedyAgXBlend(sdr_linear, extended_linear, blend_params);
  if (any(isnan(color)) || any(isinf(color))) color = sdr_linear;

  color = mul(CUSTOM_PRIMARIES_TO_BT2020_MAT, color);

  static const float SATURATION = 1.1875f;
  static const float DECHROMA = 50.f / 100.f;
  color = ApplyAnchoredSaturationGrading(
      color,
      renodx::color::bt2020::from::BT709(untonemapped),
      params.input_pivot_linear,
      RENODX_TONE_MAP_SATURATION * SATURATION,
      RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
      lerp(DECHROMA, 1.f, RENODX_TONE_MAP_DECHROMA));

  color = FixNegativeLuminanceBT2020(color);
  color = CompressBT2020Radial(color, 0.8f, 8.f);

  return renodx::color::bt709::from::BT2020(color);
}

float3 ApplyRenoDXPsychoVToneMap(float3 untonemapped, RemedyAgXCurveParameters params, float hdr_ratio) {
  untonemapped = RejectNonPositiveBT709Luminance(untonemapped);
  untonemapped = ApplyXYZExpandedBT709GamutClip(untonemapped, TONE_MAP_GAMUT_CLIP);

  const float3 d65_lms = renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;
  const float3 input_lms = mul(renodx::tonemap::psychov::PSYCHO30_BT709_TO_LMS_MAT, untonemapped);
  const float3 source_anchor_lms = d65_lms * params.input_pivot_linear;
  const float3 target_peak_lms = d65_lms * hdr_ratio;

  static const float HIGHLIGHT_CONTRAST = 1.f;
  static const float SATURATION = 57.f / 50.f;
  static const float DECHROMA = 25.f / 100.f;

  // MeanA2's source hue remains the original pre-grade LMS signal.
  float3 tonal_input_lms;
  const float3 graded_input_lms = renodx::tonemap::psychov::custom_psycho31_GradeLMS(
      input_lms,
      source_anchor_lms,
      source_anchor_lms,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      HIGHLIGHT_CONTRAST * RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
      RENODX_TONE_MAP_CONTRAST_SHADOWS,
      SATURATION * RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
      lerp(DECHROMA, 1.f, RENODX_TONE_MAP_DECHROMA),
      0.f,
      tonal_input_lms,
      true);

  const float3 normalized_graded_lms = graded_input_lms / d65_lms;

  float3 sdr_gamma;
  float3 sdr_linear;
  float3 extended_linear;
  ApplyRemedyAgXCurve(abs(normalized_graded_lms), params, sdr_gamma, sdr_linear, extended_linear);

  // Tangent is the pre-shoulder response; the shared white-clip blend is the shoulder response.
  const float3 graded_lms = extended_linear * d65_lms;
  const RemedyAgXBlendParameters blend_params = CreateRemedyAgXBlendParameters(params, hdr_ratio);

  float3 response_linear = ApplyRemedyAgXBlend(sdr_linear, extended_linear, blend_params);
  if (any(isnan(response_linear)) || any(isinf(response_linear))) response_linear = sdr_linear;

  const float3 response_lms = response_linear * d65_lms;
  const float3 source_q = input_lms / source_anchor_lms;
  const float3 tonal_input_q = tonal_input_lms / source_anchor_lms;
  const float3 response_u = renodx::math::CopySign(response_lms, graded_input_lms) / target_peak_lms;

  const float mean_a2_weight = renodx::tonemap::psychov::custom_psycho31_ShoulderMeanA2Weight(
      abs(tonal_input_q), graded_lms, response_lms, 1.f, 0.5f, 0.f);

  float response_yf;
  uint response_valid;
  float3 desired_coord = renodx::tonemap::psychov::custom_psycho31_MeanA2Response(
      source_q, response_u, mean_a2_weight, response_yf, response_valid);

  if (response_valid == 0u) return 0.f;

  float3 desired_lms = renodx::tonemap::psychov::psycho31_LMSFromTest30Coord(desired_coord, hdr_ratio);
  desired_lms = FixNegativeLuminanceLMS(desired_lms);
  desired_coord = renodx::tonemap::psychov::psycho31_Test30CoordFromLMS(desired_lms, hdr_ratio);
  response_yf = renodx::tonemap::psychov::psycho31_YfFromTest30Coord(desired_coord);

  static const int TARGET_GAMUT = renodx::tonemap::psychov::CUSTOM_PSYCHO31_TARGET_GAMUT_BT2020;
  const float normalized_demand = renodx::tonemap::psychov::custom_psycho31_NormalizedL8TargetDemand(
      desired_coord, response_yf, TARGET_GAMUT);
  const float3 mapped_coord = renodx::tonemap::psychov::custom_psycho31_MapL8TargetDemand(
      desired_coord, response_yf, TARGET_GAMUT, normalized_demand);

  const float3 output_lms = renodx::tonemap::psychov::psycho31_LMSFromTest30Coord(mapped_coord, hdr_ratio);
  const float3 output_bt709 = mul(renodx::tonemap::psychov::PSYCHO30_LMS_TO_BT709_MAT, output_lms);
  return !any(isnan(output_bt709)) && !any(isinf(output_bt709)) ? output_bt709 : 0.f;
}

float3 ApplySDRToneMap(float3 untonemapped, RemedyAgXParameters params) {
  // Keep SDR separate from Vanilla:
  // same SDR AgX base, but no HDR extension.
  float3 color = ApplyVanillaSDRAgX(untonemapped, params);

  color = mul(REMEDY_BT2020_TO_BT709, color);

  return saturate(color);  // SDR clamps 0 - 1 in BT.709
}

// -----------------------------------------------------------------------------
// Entry
// -----------------------------------------------------------------------------

// Callers select paper white upstream so post-tonemap effects use the same brightness.
float3 ApplyRemedyAgX(
    float input_r,
    float input_g,
    float input_b,
    float paper_white,
    int g_bHDR,
    float g_fAgxMinEV,
    float g_fAgxMaxEV,
    float g_fAgxToePower,
    float g_fAgxShoulderPower,
    float g_fAgxContrastSlope,
    float g_fAgxToePrecalcConstant,
    float g_fAgxShoulderPrecalcConstant,
    float3 g_vAgxInsetRow0,
    float3 g_vAgxInsetRow1,
    float3 g_vAgxInsetRow2,
    float3 g_vAgxOutsetRow0,
    float3 g_vAgxOutsetRow1,
    float3 g_vAgxOutsetRow2,
    float g_fAgxHDRRatio,
    float g_fAgxHDRMidGrey,
    float g_fAgxHDRToePrecalcConstant,
    float g_fAgxHDRShoulderPrecalcConstant,
    float2 texcoord,
    float g_fAgxHDRSaturation = 0.f) {
  [branch]
  if (g_bHDR != 0 && TONE_MAP_TYPE != 0.f) {
    g_fAgxHDRRatio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  }

  const float3 untonemapped = float3(input_r, input_g, input_b);

  float3 output_color;

  [branch]
  if (TONE_MAP_TYPE == 3.f) {  // RenoDX (PsychoV)
    const RemedyAgXCurveParameters curve_params =
        CreateRemedyAgXCurveParameters(
            g_fAgxMinEV,
            g_fAgxMaxEV,
            g_fAgxToePower,
            g_fAgxShoulderPower,
            g_fAgxContrastSlope,
            g_fAgxToePrecalcConstant,
            g_fAgxShoulderPrecalcConstant);
    output_color = ApplyRenoDXPsychoVToneMap(untonemapped, curve_params, g_fAgxHDRRatio);
  } else {
    const RemedyAgXParameters params =
        CreateRemedyAgXParameters(
            g_fAgxMinEV,
            g_fAgxMaxEV,
            g_fAgxToePower,
            g_fAgxShoulderPower,
            g_fAgxContrastSlope,
            g_fAgxToePrecalcConstant,
            g_fAgxShoulderPrecalcConstant,
            g_vAgxInsetRow0,
            g_vAgxInsetRow1,
            g_vAgxInsetRow2,
            g_vAgxOutsetRow0,
            g_vAgxOutsetRow1,
            g_vAgxOutsetRow2,
            g_fAgxHDRRatio,
            g_fAgxHDRMidGrey,
            g_fAgxHDRToePrecalcConstant,
            g_fAgxHDRShoulderPrecalcConstant,
            g_fAgxHDRSaturation);

    [branch]
    if (TONE_MAP_TYPE == 0.f) {  // Vanilla
      output_color = ApplyVanillaToneMap(untonemapped, params);
    } else if (TONE_MAP_TYPE == 1.f) {  // RenoDX (Vanilla+)
      output_color = ApplyRenoDXVanillaPlusToneMap(untonemapped, params);
    } else if (TONE_MAP_TYPE == 2.f) {  // RenoDX (Customized)
      output_color = ApplyRenoDXCustomizedToneMap(untonemapped, params);
    } else {  // SDR
      output_color = ApplySDRToneMap(untonemapped, params);
    }
  }

#if 0
  // Normalized UV layout: white text is scaled by paper white along with the image below.
  // Normalized coordinates: increase X to move right, Y to move down.
  const float DEBUG_OFFSET_X = 0.02f;
  const float DEBUG_OFFSET_Y = 0.20f;
  renodx::canvas::Context debug_canvas =
      renodx::canvas::CreateContext(
          texcoord,
          float2(DEBUG_OFFSET_X, DEBUG_OFFSET_Y),
          float2(0.007f, 0.018f),
          output_color,
          1.f);

#define AGX_PRINT_SCALAR(VALUE, ...)                                      \
  renodx::canvas::DrawText(debug_canvas, __VA_ARGS__);                    \
  renodx::canvas::DrawFloat(debug_canvas, VALUE, 6.f, 6.f, false, false); \
  renodx::canvas::NewLine(debug_canvas);

#define AGX_PRINT_ROW(VALUE, ...)                                           \
  renodx::canvas::DrawText(debug_canvas, __VA_ARGS__);                      \
  renodx::canvas::DrawFloat(debug_canvas, VALUE.x, 3.f, 9.f, false, false); \
  renodx::canvas::DrawText(debug_canvas, ' ', ' ');                         \
  renodx::canvas::DrawFloat(debug_canvas, VALUE.y, 3.f, 9.f, false, false); \
  renodx::canvas::DrawText(debug_canvas, ' ', ' ');                         \
  renodx::canvas::DrawFloat(debug_canvas, VALUE.z, 3.f, 9.f, false, false); \
  renodx::canvas::NewLine(debug_canvas);

  AGX_PRINT_SCALAR(paper_white, 'P', 'a', 'p', 'e', 'r', 'W', 'h', 'i', 't', 'e', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxMinEV, 'M', 'i', 'n', 'E', 'V', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxMaxEV, 'M', 'a', 'x', 'E', 'V', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxToePower, 'T', 'o', 'e', 'P', 'o', 'w', 'e', 'r', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxShoulderPower, 'S', 'h', 'o', 'u', 'l', 'd', 'e', 'r', 'P', 'o', 'w', 'e', 'r', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxContrastSlope, 'C', 'o', 'n', 't', 'r', 'a', 's', 't', 'S', 'l', 'o', 'p', 'e', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxToePrecalcConstant, 'T', 'o', 'e', 'P', 'r', 'e', 'c', 'a', 'l', 'c', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxShoulderPrecalcConstant, 'S', 'h', 'o', 'u', 'l', 'd', 'e', 'r', 'P', 'r', 'e', 'c', 'a', 'l', 'c', ':')
  AGX_PRINT_ROW(g_vAgxInsetRow0, 'I', 'n', 's', 'e', 't', 'R', 'o', 'w', '0', ':', ' ')
  AGX_PRINT_ROW(g_vAgxInsetRow1, 'I', 'n', 's', 'e', 't', 'R', 'o', 'w', '1', ':', ' ')
  AGX_PRINT_ROW(g_vAgxInsetRow2, 'I', 'n', 's', 'e', 't', 'R', 'o', 'w', '2', ':', ' ')
  AGX_PRINT_ROW(g_vAgxOutsetRow0, 'O', 'u', 't', 's', 'e', 't', 'R', 'o', 'w', '0', ':', ' ')
  AGX_PRINT_ROW(g_vAgxOutsetRow1, 'O', 'u', 't', 's', 'e', 't', 'R', 'o', 'w', '1', ':', ' ')
  AGX_PRINT_ROW(g_vAgxOutsetRow2, 'O', 'u', 't', 's', 'e', 't', 'R', 'o', 'w', '2', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxHDRRatio, 'H', 'D', 'R', 'R', 'a', 't', 'i', 'o', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxHDRMidGrey, 'H', 'D', 'R', 'M', 'i', 'd', 'G', 'r', 'e', 'y', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxHDRToePrecalcConstant, 'H', 'D', 'R', 'T', 'o', 'e', 'P', 'r', 'e', 'c', 'a', 'l', 'c', ':', ' ')
  AGX_PRINT_SCALAR(g_fAgxHDRShoulderPrecalcConstant, 'H', 'D', 'R', 'S', 'h', 'P', 'r', 'e', 'c', 'a', 'l', 'c', ':', ' ')

#undef AGX_PRINT_ROW
#undef AGX_PRINT_SCALAR

  output_color = renodx::canvas::GetOutput(debug_canvas).rgb;
#endif

  return output_color * paper_white;
}
