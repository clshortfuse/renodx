#include "./shared.h"
#include "./customtest31.hlsli"

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

float3 ApplyAnchoredSaturationGrading(
    float3 color, float3 grading_source,
    float anchor_y,
    float saturation, float highlight_saturation, float dechroma) {
  [branch]
  if (saturation == 1.f && highlight_saturation == 1.f && dechroma == 0.f) {
    return color;
  }

  const float3 anchor_lms = renodx::color::lms::from::BT709(anchor_y.xxx);
  float effective_purity_scale = saturation;

  [branch]
  if (dechroma != 0.f || highlight_saturation != 1.f) {
    static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
    static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
    static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

    float source_relative_yf = max(
        renodx::color::yf::from::LMS(renodx::color::lms::from::BT709(grading_source) / anchor_lms)
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
  return renodx::color::bt709::from::LMS(
      renodx::tonemap::psychov::psycho30_ApplyAdaptiveRelativePurity(
          renodx::color::lms::from::BT709(color), anchor_lms, effective_purity_scale)
      * anchor_lms);
}

float3 GammaDecode(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color = renodx::color::srgb::Decode(color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::Decode(color, 2.2f);
  } else {
    color = renodx::color::gamma::Decode(color, 2.4f);
  }
  return color;
}

float3 GammaEncode(float3 color) {
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color = renodx::color::srgb::Encode(color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color = renodx::color::gamma::Encode(color, 2.2f);
  } else {
    color = renodx::color::gamma::Encode(color, 2.4f);
  }
  return color;
}

float3 ApplyToneMapAndScale(float3 color, float2 vpos, bool clamp = false) {
  float3 untonemapped = GammaDecode(max(0, color));

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 0.f) {  // Vanilla
    tonemapped = saturate(untonemapped);
  } else {
    const float peak_ratio = clamp ? 1.f : RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_TONE_MAP_TYPE == 2.f) {  // PsychoV
      tonemapped = renodx::tonemap::psychov::custom_psychotm_test31(
          untonemapped,
          peak_ratio,
          RENODX_TONE_MAP_EXPOSURE,
          RENODX_TONE_MAP_HIGHLIGHTS,
          RENODX_TONE_MAP_SHADOWS,
          RENODX_TONE_MAP_CONTRAST,
          0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f),
          RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
          RENODX_TONE_MAP_CONTRAST_SHADOWS,
          RENODX_TONE_MAP_SATURATION,
          RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
          RENODX_TONE_MAP_DECHROMA);

    } else {  // Vanilla+
      float3 graded = ApplyAnchoredTonalGrading(
          untonemapped * RENODX_TONE_MAP_EXPOSURE,
          0.18f,
          0.18f,
          RENODX_TONE_MAP_CONTRAST,
          0.1f * pow(RENODX_TONE_MAP_FLARE, 10.f),
          RENODX_TONE_MAP_CONTRAST_HIGHLIGHTS,
          RENODX_TONE_MAP_CONTRAST_SHADOWS,
          RENODX_TONE_MAP_HIGHLIGHTS,
          RENODX_TONE_MAP_SHADOWS);
      tonemapped = renodx::tonemap::CInfinityRollOff(graded, peak_ratio, 0.18f, 1.5f);
      tonemapped = ApplyAnchoredSaturationGrading(
          tonemapped,
          graded,
          0.18f,
          RENODX_TONE_MAP_SATURATION,
          RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
          RENODX_TONE_MAP_DECHROMA);
    }
  }
  color = tonemapped;

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    color = renodx::effects::ApplyFilmGrain(
        color,
        vpos,
        CUSTOM_RANDOM,
        CUSTOM_FILM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }

  color = sign(color) * GammaEncode(abs(color));
  return color;
}

float4 FinalizePostFX(float4 color) {
  // writes onto swapchain, breaks unless manually clamped
#if CLAMP_POSTFX
  color = max(0, color);
#endif

  return color;
}
