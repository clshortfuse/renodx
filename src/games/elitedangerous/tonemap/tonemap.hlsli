#include "../common.hlsli"
#include "./psychov25/customtest25.hlsli"

static const float MID_GRAY_IN = 0.119121851127f;
static const float MID_GRAY_OUT = 0.163979921774f;
static const float MID_GRAY_SLOPE = 1.95752308422f;

float3 ApplyAdaptiveMBPurity(float3 lms_input, float3 adaptive_neutral_lms, float purity_scale) {
  if (abs(purity_scale - 1.f) <= 1e-5f) return lms_input;

  float3 relative_weighted = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeWeightedLMS(lms_input, adaptive_neutral_lms);
  float3 mb = renodx::color::macleod_boynton::from::WeightedLMS(relative_weighted);
  float3 mb_neutral = renodx::color::macleod_boynton::from::LMS(1.f.xxx);
  float2 mb_scaled_xy = lerp(mb_neutral.xy, mb.xy, purity_scale);
  float3 relative_weighted_out = renodx::color::macleod_boynton::WeightedLMSFromMacleodBoynton(float3(mb_scaled_xy, mb.z));

  return renodx::color::macleod_boynton::UnweighLMS(
      renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeWeightedLMS(relative_weighted_out, adaptive_neutral_lms));
}

#define CONTRAST_AND_FLARE_GENERATOR(T)                                                                       \
  T ContrastAndFlare(T x, float contrast, float flare, T mid_gray_in = (T)0.18f, T mid_gray_out = (T)0.18f) { \
    T x_normalized = x / mid_gray_in;                                                                         \
    T flare_ratio = (T)1.f + renodx::math::DivideSafe(flare, x_normalized + flare, (T)0.f);                   \
    return pow(x_normalized, contrast * flare_ratio) * mid_gray_out;                                          \
  }

CONTRAST_AND_FLARE_GENERATOR(float)
CONTRAST_AND_FLARE_GENERATOR(float3)
#undef CONTRAST_AND_FLARE_GENERATOR

float3 ApplyLuminanceGradingLMS(float3 color_lms, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float yf = max(0.f, renodx::color::yf::from::LMS(color_lms));
  float yf_adjusted = yf * exposure;
  yf_adjusted = renodx::color::grade::Highlights(yf_adjusted, highlights, mid_gray_yf);
  yf_adjusted = renodx::color::grade::Shadows(yf_adjusted, shadows, mid_gray_yf);
  yf_adjusted = ContrastAndFlare(yf_adjusted, contrast, flare, mid_gray_yf, mid_gray_yf);
  return color_lms * renodx::math::DivideSafe(yf_adjusted, yf, 1.f);
}

float3 ApplyLuminanceGradingBT2020(float3 color_bt2020, float exposure, float highlights, float shadows, float contrast, float flare, float mid_gray_yf = 0.18f) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyLuminanceGradingLMS(color_lms, exposure, highlights, shadows, contrast, flare, mid_gray_yf);
  return renodx::color::bt2020::from::LMS(color_lms);
}

float3 ApplyPurityGradingLMS(float3 color_lms, float purity_scale, float highlight_saturation, float dechroma, float3 adaptive_neutral_lms = 0.18f) {
  if (purity_scale == 1.f && highlight_saturation == 1.f && dechroma == 0.f) return color_lms;

  if (dechroma != 0.f || highlight_saturation != 1.f) {
    float luminance = renodx::color::yf::from::LMS(color_lms);
    float neutral_luminance = renodx::color::yf::from::LMS(adaptive_neutral_lms);

    // Ramp purity grading over 2.75 decades above the adaptive neutral.
    static const float INVERSE_HIGHLIGHT_RANGE_STOPS = 1.f / (2.75f * log2(10.f));
    static const float HIGHLIGHT_ROLLOFF_CUBIC_BLEND = 0.5f;
    static const float HIGHLIGHT_PURITY_STRENGTH = 2.f / 3.f;

    float luminance_from_neutral = max(luminance, neutral_luminance) / neutral_luminance;
    float rolloff_position = saturate(log2(luminance_from_neutral) * INVERSE_HIGHLIGHT_RANGE_STOPS);

    float rolloff_position_squared = rolloff_position * rolloff_position;
    float rolloff = rolloff_position_squared * rolloff_position * mad(rolloff_position, mad(6.f, rolloff_position, -15.f), 10.f);

    // Base smootherstep brings dechroma into the midtones while remaining monotonic and C2.
    if (dechroma != 0.f) {
      purity_scale *= mad(-dechroma, rolloff, 1.f);
    }

    if (highlight_saturation != 1.f) {
      // Blend smootherstep squared and cubed for a later, gentler C2 progression.
      float highlight_rolloff = rolloff * rolloff * mad(HIGHLIGHT_ROLLOFF_CUBIC_BLEND, rolloff, 1.f - HIGHLIGHT_ROLLOFF_CUBIC_BLEND);
      purity_scale *= mad(highlight_saturation - 1.f, highlight_rolloff * HIGHLIGHT_PURITY_STRENGTH, 1.f);
    }
  }

  if (purity_scale != 1.f) {
    color_lms = ApplyAdaptiveMBPurity(color_lms, adaptive_neutral_lms, purity_scale);
  }

  return color_lms;
}

float3 ApplyPurityGradingBT2020(float3 color_bt2020, float purity_scale, float highlight_saturation, float dechroma) {
  float3 color_lms = renodx::color::lms::from::BT2020(color_bt2020);
  color_lms = ApplyPurityGradingLMS(color_lms, purity_scale, highlight_saturation, dechroma, renodx::color::lms::from::BT2020(0.18f.xxx));
  return renodx::color::bt2020::from::LMS(color_lms);
}

/// Elite Dangerous vanilla SDR tonemapper.
/// Output is in gamma space.
#define APPLY_VANILLA_TONEMAP_GENERATOR(T)                        \
  T ApplyVanillaTonemap(T untonemapped, float N4 = -1.274e-7f) {  \
    const float N0 = 8.46800041f;                                 \
    const float N1 = 1.0f;                                        \
    const float N2 = -0.00295699993f;                             \
    const float N3 = 0.000100400001f;                             \
                                                                  \
    const float D0 = 8.3604002f;                                  \
    const float D1 = 1.82270002f;                                 \
    const float D2 = 0.218899995f;                                \
    const float D3 = -0.00211700005f;                             \
    const float D4 = 3.67300017e-5f;                              \
                                                                  \
    T x = untonemapped;                                           \
    T numerator = (((x * N0 + N1) * x + N2) * x + N3) * x + N4;   \
    T denominator = (((x * D0 + D1) * x + D2) * x + D3) * x + D4; \
    return max((T)0.0f, numerator / denominator);                 \
  }

APPLY_VANILLA_TONEMAP_GENERATOR(float)
APPLY_VANILLA_TONEMAP_GENERATOR(float3)
#undef APPLY_VANILLA_TONEMAP_GENERATOR

#define APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(T)                                         \
  T ApplyExtendedVanillaTonemap(T x) {                                                      \
    const float INFLECTION_X = 0.119121851127f;                                             \
    const float INFLECTION_Y = 0.163979921774f;                                             \
    const float INFLECTION_SLOPE = 1.95752308422f;                                          \
    /* r^2 * log2(e), where r = sqrt(2 * V'(x0) / abs(V'''(x0))). */                        \
    const float NATURAL_RELEASE_EXP2_NUMERATOR = 0.0386582117104f;                          \
                                                                                            \
    /* Vanilla+ uses N4 = 0 to remove the original black clip. */                           \
    T vanilla_gamma = ApplyVanillaTonemap(x, 0.f);                                          \
    T vanilla_linear = pow(vanilla_gamma, 2.2f);                                            \
                                                                                            \
    T distance_from_inflection = max(x - (T)INFLECTION_X, (T)0.f);                          \
    T tangent_linear = mad((T)INFLECTION_SLOPE, distance_from_inflection, (T)INFLECTION_Y); \
    T release_exponent = renodx::math::DivideSafe(                                          \
        (T) - NATURAL_RELEASE_EXP2_NUMERATOR,                                               \
        distance_from_inflection * distance_from_inflection,                                \
        (T) - renodx::math::FLT_MAX);                                                       \
    T release_weight = exp2(release_exponent);                                              \
                                                                                            \
    return max((T)0.f, lerp(vanilla_linear, tangent_linear, release_weight));               \
  }

APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(float)
APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR(float3)
#undef APPLY_EXTENDED_VANILLA_TONEMAP_GENERATOR

float3 ApplyPreLUTToneMapAndGammaEncode(float3 untonemapped) {
  float3 tonemapped_gamma;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    tonemapped_gamma = ApplyVanillaTonemap(untonemapped);
  } else if (RENODX_TONE_MAP_TYPE == 1.f) {
    float3 tonemapped = ApplyExtendedVanillaTonemap(untonemapped);
    if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
      float perch_yf = renodx::color::yf::from::BT709(tonemapped);
      float lum_yf = ApplyExtendedVanillaTonemap(renodx::color::yf::from::BT709(untonemapped));
      tonemapped = renodx::color::correct::Luminance(tonemapped, perch_yf, lum_yf);
    }
    tonemapped_gamma = renodx::color::gamma::Encode(tonemapped, 2.2f);
  } else {
    tonemapped_gamma = renodx::color::gamma::Encode(max(0, untonemapped), 2.2f);
  }

  return tonemapped_gamma;
}

float3 ApplyLUT(float3 lut_input_gamma, Texture3D<float4> lut_texture, SamplerState lut_sampler, float texel_size, float lut_strength) {
  if (CUSTOM_LUT_STRENGTH == 0.f || lut_strength == 0.f) return lut_input_gamma;

  float3 lut_input_linear = renodx::color::gamma::Decode(lut_input_gamma, 2.2f);

  float maxch_scale = 1.f;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
      maxch_scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(lut_input_linear, 1.f, MID_GRAY_OUT, 1.5f);
    } else {  // Custom
      maxch_scale = ApplyAnchoredCInfinityShoulderMaxChannelScale(lut_input_linear, 1.f, MID_GRAY_IN, 1.5f);
    }
    lut_input_linear *= maxch_scale;
    lut_input_gamma = renodx::color::gamma::Encode(lut_input_linear, 2.2f);
  }

  float3 lut_output_gamma;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    lut_output_gamma = lut_texture.Sample(lut_sampler, saturate(lut_input_gamma) * (1 - texel_size) + (0.5 * texel_size)).rgb;  // LUT
  } else {
    lut_output_gamma = renodx::lut::SampleTetrahedral(lut_texture, lut_input_gamma, uint(1.f / texel_size));
  }
  lut_output_gamma = lerp(lut_input_gamma, lut_output_gamma, lut_strength * CUSTOM_LUT_STRENGTH);  // Blend in LUT as a percentage

  float3 lut_output_linear = renodx::color::gamma::Decode(lut_output_gamma, 2.2f) / maxch_scale;

  return renodx::color::gamma::Encode(lut_output_linear, 2.2f);
}

float3 ApplyPostLUTToneMap(float3 untonemapped_gamma) {
  if (RENODX_TONE_MAP_TYPE == 0.f) return untonemapped_gamma;

  float3 untonemapped = renodx::color::gamma::DecodeSafe(untonemapped_gamma, 2.2f);

  float3 tonemapped;
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
    untonemapped = max(0, renodx::color::bt2020::from::BT709(untonemapped));

    // Apply BT.2020 luminance and purity grading.
    untonemapped = ApplyLuminanceGradingBT2020(untonemapped,
                                               1.f,
                                               RENODX_TONE_MAP_HIGHLIGHTS,
                                               RENODX_TONE_MAP_SHADOWS,
                                               RENODX_TONE_MAP_CONTRAST,
                                               0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                               MID_GRAY_OUT);
    untonemapped = ApplyPurityGradingBT2020(untonemapped,
                                            RENODX_TONE_MAP_SATURATION,
                                            RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
                                            RENODX_TONE_MAP_DECHROMA);
    // untonemapped = max(untonemapped, 1e-7f);

    untonemapped = renodx::color::bt709::from::BT2020(untonemapped);
    tonemapped = renodx::math::CopySign(
        ApplyAnchoredCInfinityShoulder(abs(untonemapped), RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, MID_GRAY_OUT, 1.5f),
        untonemapped);
  } else {  // Custom

    tonemapped = ApplyCustomPsychoV25ToneMap(
        untonemapped,
        RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        1.55f * RENODX_TONE_MAP_CONTRAST,
        0.10f * pow(0.85f, 10.f) + 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        RENODX_TONE_MAP_DECHROMA,
        MID_GRAY_IN,
        MID_GRAY_OUT,
        0.35f,
        0.3,
        1.5f,
        renodx::tonemap::psychov::PSYCHO25_TARGET_GAMUT_DISPLAY_P3);
  }

  return renodx::color::gamma::EncodeSafe(tonemapped, 2.2f);
}
