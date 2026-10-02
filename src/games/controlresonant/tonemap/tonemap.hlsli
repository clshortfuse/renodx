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

  float3 normalized = color / anchor_in;
  float3 graded_normalized = normalized;

  [branch]
  if (contrast != 1.f || flare > 0.f) {
    float3 exponent = contrast;

    [branch]
    if (flare > 0.f) {
      float3 shadow_distance = saturate(1.f - normalized);
      float3 flat_shadow_weight = exp2(-normalized / shadow_distance);
      exponent *= mad(flat_shadow_weight, flare / (normalized + flare), 1.f);
    }

    float3 input_stops = log2(normalized);
    float3 highlight_stops = max(input_stops, 0.f);
    float3 output_highlight_stops = highlight_stops;

    [branch]
    if (contrast != 1.f) {
      float3 displacement = (contrast - 1.f) * highlight_stops;
      float3 displacement_magnitude = abs(displacement);
      output_highlight_stops += displacement / mad(displacement_magnitude, exp2(-1.f / displacement_magnitude), 1.f);
    }

    graded_normalized = exp2(mad(exponent, min(input_stops, 0.f), output_highlight_stops));
  }

  [branch]
  if (highlight_contrast != 1.f) {
    float3 distance = max(graded_normalized - 1.f, 0.f);
    float3 distance_squared = distance * distance;
    float3 flat_distance = (1.f + distance_squared) * exp2(-1.f / distance_squared);

    graded_normalized += distance * (pow(1.f + flat_distance, 0.5f * (highlight_contrast - 1.f)) - 1.f);
  }

  [branch]
  if (shadow_contrast != 1.f) {
    float3 distance = saturate(1.f - graded_normalized);
    float3 distance_squared = distance * distance;
    float3 flat_distance = distance_squared * distance * exp2(1.f - 1.f / distance_squared);

    graded_normalized *= pow(1.f + flat_distance, 1.f - shadow_contrast);
  }

  [branch]
  if (highlights != 1.f || shadows != 1.f) {
    static const float TONAL_OFFSET_START_STOPS = 1.f;
    static const float TONAL_OFFSET_END_STOPS = 8.f;
    static const float TONAL_OFFSET_INVERSE_RANGE_STOPS = 1.f / (TONAL_OFFSET_END_STOPS - TONAL_OFFSET_START_STOPS);

    float3 tonal_stops = log2(graded_normalized);
    float3 tonal_displacement = 0.f;

    [branch]
    if (highlights != 1.f) {
      float adjustment = highlights - 1.f;
      float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      float3 weight = CInfinityTransition((tonal_stops - TONAL_OFFSET_START_STOPS) * TONAL_OFFSET_INVERSE_RANGE_STOPS);

      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    [branch]
    if (shadows != 1.f) {
      float adjustment = shadows - 1.f;
      float displacement = adjustment * mad(1.5f, abs(adjustment), 0.5f);
      float3 weight = CInfinityTransition((-TONAL_OFFSET_START_STOPS - tonal_stops) * TONAL_OFFSET_INVERSE_RANGE_STOPS);

      tonal_displacement = mad(displacement, weight, tonal_displacement);
    }

    graded_normalized *= exp2(tonal_displacement);
  }

  return graded_normalized * anchor_out;
}

// Linear RGB grading: weights must match the RGB space and sum to 1; anchor_y must be positive.
// grading_source drives highlight detection independently of the color being adjusted.
// anchor_y is the input luminance anchor of grading_source, not the output color's anchor.
float3 ApplyAnchoredSaturationGrading(
    float3 color, float3 grading_source,
    float anchor_y,
    float3 luminance_weights,
    float saturation, float highlight_saturation, float dechroma) {
  [branch]
  if (saturation == 1.f && highlight_saturation == 1.f && dechroma == 0.f) {
    return color;
  }

  float effective_saturation = saturation;

  [branch]
  if (dechroma != 0.f || highlight_saturation != 1.f) {
    static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
    static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
    static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

    float source_relative_y = max(dot(grading_source, luminance_weights) / anchor_y, 0.f);
    float rolloff_position = saturate(log2(max(source_relative_y, 1.f)) * INVERSE_HIGHLIGHT_RANGE_STOPS);
    float rolloff_position_squared = rolloff_position * rolloff_position;

    float rolloff = rolloff_position_squared * rolloff_position * mad(rolloff_position, mad(6.f, rolloff_position, -15.f), 10.f);

    [branch]
    if (dechroma != 0.f) {
      effective_saturation *= mad(-dechroma, rolloff, 1.f);
    }

    [branch]
    if (highlight_saturation != 1.f) {
      float highlight_rolloff = rolloff * rolloff * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);

      effective_saturation *= mad(highlight_saturation - 1.f, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
    }
  }

  // Do not clamp Y or RGB: retain signed colors and HDR headroom.
  return lerp(dot(color, luminance_weights).xxx, color, effective_saturation);
}

float3 RejectNonPositiveBT709Luminance(float3 color) {
  return renodx::color::yf::from::BT709(color) <= 0.f
             ? 0.f
             : color;
}

// Shared Remedy AgX toe + tangent formation used by Vanilla+, Customized, and PsychoV.
struct RemedyExtendedAgXParameters {
  float min_log2_linear;
  float inverse_ev_range;
  float input_pivot_linear;
  float output_pivot;
  float output_pivot_linear;
  float linear_tangent_slope;
  float toe_power;
  float contrast_slope;
  float toe_scale;
};

RemedyExtendedAgXParameters CreateRemedyExtendedAgXParameters(
    float min_log2_linear,
    float max_log2_linear,
    float toe_power,
    float contrast_slope,
    float toe_scale) {
  RemedyExtendedAgXParameters params;
  const float ev_range = max_log2_linear - min_log2_linear;

  params.min_log2_linear = min_log2_linear;
  params.inverse_ev_range = rcp(ev_range);
  params.input_pivot_linear = exp2(min_log2_linear + REMEDY_AGX_LOG_PIVOT * ev_range);
  params.output_pivot = pow(REMEDY_AGX_MID_GRAY, 1.f / REMEDY_AGX_OUTPUT_GAMMA);
  params.output_pivot_linear = REMEDY_AGX_MID_GRAY;
  params.linear_tangent_slope = REMEDY_AGX_OUTPUT_GAMMA * pow(params.output_pivot, REMEDY_AGX_OUTPUT_GAMMA - 1.f) * contrast_slope
                                * params.inverse_ev_range / (log(2.f) * params.input_pivot_linear);
  params.toe_power = toe_power;
  params.contrast_slope = contrast_slope;
  params.toe_scale = toe_scale;

  return params;
}

RemedyExtendedAgXParameters CreateRemedyExtendedAgXParameters(RemedyAgXParameters params) {
  RemedyExtendedAgXParameters extended_params;
  const renodx::tonemap::agx::ToneScale tone_scale = params.tone_scale;
  const renodx::tonemap::agx::ToneScaleParameters parameters = tone_scale.parameters;

  extended_params.min_log2_linear = parameters.min_ev + log2(parameters.input_mid_gray);
  extended_params.inverse_ev_range = tone_scale.inverse_ev_range;
  extended_params.input_pivot_linear = params.input_pivot_linear;
  extended_params.output_pivot = parameters.output_pivot;
  extended_params.output_pivot_linear = params.output_pivot_linear;
  extended_params.linear_tangent_slope = params.linear_tangent_slope;
  extended_params.toe_power = parameters.toe_power;
  extended_params.contrast_slope = parameters.slope;
  extended_params.toe_scale = tone_scale.toe_scale;

  return extended_params;
}

// Preserve Remedy's AgX toe, then extend the upper range without the original finite shoulder.
// linear_input must contain positive magnitudes.
float3 ApplyRemedyExtendedAgXCurve(float3 linear_input, RemedyExtendedAgXParameters params, float shoulder_blend_strength) {
  const float3 log_color = (log2(max(linear_input, 1e-10f)) - params.min_log2_linear) * params.inverse_ev_range;

  const float3 toe = (params.contrast_slope / params.toe_scale) * max(REMEDY_AGX_LOG_PIVOT - log_color, 0.f);

  float3 color =
      select(
          log_color >= REMEDY_AGX_LOG_PIVOT,
          params.contrast_slope * (log_color - REMEDY_AGX_LOG_PIVOT),
          (toe / pow(pow(toe, params.toe_power) + 1.f, 1.f / params.toe_power)) * -params.toe_scale)
      + params.output_pivot;

  const float3 shoulderless_agx_linear = pow(max(color, 0.f), REMEDY_AGX_OUTPUT_GAMMA);

  color = select(
      linear_input > params.input_pivot_linear,
      params.output_pivot_linear + params.linear_tangent_slope * (linear_input - params.input_pivot_linear),
      shoulderless_agx_linear);

  return lerp(color, shoulderless_agx_linear, shoulder_blend_strength * 0.35f);
}

float3 ApplyShoulderlessAgXFormation(float3 linear_input, RemedyAgXParameters params, float shoulder_blend_strength) {
  float3 color = ApplyRemedyExtendedAgXCurve(linear_input, CreateRemedyExtendedAgXParameters(params), shoulder_blend_strength);

  return ApplyAnchoredTonalGrading(
      color,
      params.output_pivot_linear,
      params.output_pivot_linear,
      RENODX_TONE_MAP_CONTRAST,
      0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
      RENODX_TONE_MAP_CONTRAST_SHADOWS,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS);
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

float3 ApplyRenoDXVanillaPlusToneMap(float3 untonemapped, RemedyAgXParameters params) {
  float3 color = RejectNonPositiveBT709Luminance(untonemapped);

  // Preserve the current Vanilla+ behavior:
  // clamp before and after the original inset,
  // results in harsh gamut clipping.
  color = lerp(color, max(color, 0.f), TONE_MAP_GAMUT_CLIP);
  color = mul(params.gamut.inset, color);
  color = max(color, 0.f);

  color = ApplyShoulderlessAgXFormation(color, params, TONE_MAP_HIGHLIGHT_COMPRESSION);

  color = renodx::tonemap::CInfinityRollOff(color, params.hdr_ratio, params.output_pivot_linear, 100.f);

  // Preserve Vanilla+'s original outset ordering in the gamma-shaped domain.
  color = renodx::math::SignPow(color, 1.f / params.tone_scale.parameters.output_power);

  color = mul(params.gamut.outset, color);

  color = renodx::math::SignPow(color, params.tone_scale.parameters.output_power);

  color = ApplyAnchoredSaturationGrading(
      color,
      renodx::color::bt2020::from::BT709(untonemapped),
      params.input_pivot_linear,
      renodx::color::BT2020_TO_XYZ_MAT[1],
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
      RENODX_TONE_MAP_DECHROMA);

  color = max(color, 0.f);

  return renodx::color::bt709::from::BT2020(color);
}

float3 ApplyRenoDXCustomizedToneMap(float3 untonemapped, RemedyAgXParameters params) {
  untonemapped = RejectNonPositiveBT709Luminance(untonemapped);
  float3 color = renodx::color::bt2020::from::BT709(untonemapped);

  color = mul(BT2020_TO_CUSTOM_PRIMARIES_MAT, color);
  color = max(0.f, color);

  color = ApplyShoulderlessAgXFormation(color, params, TONE_MAP_HIGHLIGHT_COMPRESSION);

  const float neutral = dot(color, CUSTOM_PRIMARIES_LUMINANCE_WEIGHTS);
  color = lerp(neutral.xxx, color, 1.1875f);

  color = ToSecondaryCustomPrimaries(color, TONE_MAP_SECONDARY_PRIMARIES_SCALE);

  color = renodx::tonemap::CInfinityRollOff(color, params.hdr_ratio, params.output_pivot_linear, 100.f);

  color = FromSecondaryCustomPrimaries(color, TONE_MAP_SECONDARY_PRIMARIES_SCALE);

  color = mul(CUSTOM_PRIMARIES_TO_BT2020_MAT, color);

  color = ApplyAnchoredSaturationGrading(
      color,
      renodx::color::bt2020::from::BT709(untonemapped),
      params.input_pivot_linear,
      renodx::color::BT2020_TO_XYZ_MAT[1],
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
      RENODX_TONE_MAP_DECHROMA);

  color = FixNegativeLuminanceBT2020(color);
  color = CompressBT2020Radial(color, 0.5f, 8.f);

  return renodx::color::bt709::from::BT2020(color);
}

float3 ApplyRenoDXPsychoVToneMap(
    float3 untonemapped,
    float hdr_ratio,
    float min_log2_linear,
    float max_log2_linear,
    float toe_power,
    float contrast_slope,
    float toe_scale) {
  untonemapped = RejectNonPositiveBT709Luminance(untonemapped);

  const RemedyExtendedAgXParameters remedy_curve =
      CreateRemedyExtendedAgXParameters(min_log2_linear, max_log2_linear, toe_power, contrast_slope, toe_scale);

  const float3 input_lms = mul(renodx::tonemap::psychov::PSYCHO30_BT709_TO_LMS_MAT, untonemapped);
  const float3 source_anchor_lms = renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS * remedy_curve.input_pivot_linear;
  const float3 grade_anchor_lms = renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS * remedy_curve.output_pivot_linear;
  const float3 target_peak_lms = renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS * hdr_ratio;

  // Apply the live Remedy toe/tangent curve in D65-normalized LMS before PsychoV grading.
  const float3 normalized_input_lms = input_lms / renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;
  const float3 extended_lms = renodx::math::CopySign(
                                  ApplyRemedyExtendedAgXCurve(
                                      abs(normalized_input_lms), remedy_curve, TONE_MAP_HIGHLIGHT_COMPRESSION),
                                  normalized_input_lms)
                              * renodx::tonemap::psychov::PSYCHO30_D65_WHITE_LMS;

  static const float HIGHLIGHT_CONTRAST = 1.f;
  static const float SATURATION = 57.f / 50.f;
  static const float DECHROMA = 25.f / 100.f;

  float3 tonal_input_lms;
  const float3 pre_shoulder_lms = renodx::tonemap::psychov::custom_psycho31_GradeLMS(
      extended_lms,
      grade_anchor_lms,
      grade_anchor_lms,
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

  const float3 graded_lms = abs(pre_shoulder_lms);
  const float3 response_lms = renodx::tonemap::CInfinityRollOff(graded_lms, target_peak_lms, grade_anchor_lms, 100.f);

  // Keep MeanA2's hue reference on the original source; tonal-region weighting follows the
  // post-Remedy signal that actually enters PsychoV grading.
  const float3 source_q = input_lms / source_anchor_lms;
  const float3 tonal_input_q = tonal_input_lms / grade_anchor_lms;
  const float3 response_u = renodx::math::CopySign(response_lms, pre_shoulder_lms) / target_peak_lms;
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
    output_color = ApplyRenoDXPsychoVToneMap(
        untonemapped,
        g_fAgxHDRRatio,
        g_fAgxMinEV,
        g_fAgxMaxEV,
        g_fAgxToePower,
        g_fAgxContrastSlope,
        g_fAgxToePrecalcConstant);
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
  renodx::canvas::DrawFloat(debug_canvas, VALUE, 3.f, 6.f, false, false); \
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
