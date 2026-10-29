#include "./shared.h"

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

// Linear AP1 grading; anchor_y must be positive.
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

  const float3 anchor_lms = renodx::color::lms::from::AP1(anchor_y.xxx);
  float effective_purity_scale = saturation;

  [branch]
  if (dechroma != 0.f || highlight_saturation != 1.f) {
    static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
    static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
    static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

    float source_relative_yf = max(
        renodx::color::yf::from::LMS(renodx::color::lms::from::AP1(grading_source) / anchor_lms)
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
  return renodx::color::ap1::from::LMS(
      renodx::tonemap::psychov::psycho30_ApplyAdaptiveRelativePurity(
          renodx::color::lms::from::AP1(color), anchor_lms, effective_purity_scale)
      * anchor_lms);
}
