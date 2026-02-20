#include "./shared.h"

float ComputeMaxChCompressionScale(float3 untonemapped) {
  float peak = renodx::math::Max(untonemapped);
  float mapped_peak = renodx::tonemap::Neutwo(peak);
  return renodx::math::DivideSafe(mapped_peak, peak, 1.f);
}

// 1D per-channel curve LUT (Nx1) with gamma-domain smoothing.
// linear -> gamma 2.2 -> center texel -> filtered sample -> gamma 2.2 -> linear
#define SampleLUT1DWithSmoothing(LUT, CHANNEL, max_index, point0, point1, fraction, OUT) \
  if (((point0) == 0) || ((point1) >= (max_index))) {                                    \
    /* Edge: preserve endpoints */                                                       \
    float sample_0 = (LUT).Load(int3((point0), 0, 0)).CHANNEL;                           \
    float sample_1 = (LUT).Load(int3((point1), 0, 0)).CHANNEL;                           \
    (OUT) = lerp(sample_0, sample_1, (fraction));                                        \
  } else {                                                                               \
    int point_prev = (point0) - 1;                                                       \
    int point_next = (point1) + 1;                                                       \
                                                                                         \
    /* 4-tap neighborhood: i-1, i, i+1, i+2 */                                           \
    float texel_prev = (LUT).Load(int3(point_prev, 0, 0)).CHANNEL;                       \
    float texel_0 = (LUT).Load(int3((point0), 0, 0)).CHANNEL;                            \
    float texel_1 = (LUT).Load(int3((point1), 0, 0)).CHANNEL;                            \
    float texel_next = (LUT).Load(int3(point_next, 0, 0)).CHANNEL;                       \
                                                                                         \
    /* Endpoint smoothing: [1,2,1] / 4 */                                                \
    float filtered_0 = (texel_prev + 2.0 * texel_0 + texel_1) * 0.25;                    \
    float filtered_1 = (texel_0 + 2.0 * texel_1 + texel_next) * 0.25;                    \
                                                                                         \
    /* Clamp to neighborhood to prevent overshoot */                                     \
    filtered_0 = clamp(filtered_0,                                                       \
                       min(texel_prev, min(texel_0, texel_1)),                           \
                       max(texel_prev, max(texel_0, texel_1)));                          \
    filtered_1 = clamp(filtered_1,                                                       \
                       min(texel_0, min(texel_1, texel_next)),                           \
                       max(texel_0, max(texel_1, texel_next)));                          \
                                                                                         \
    (OUT) = lerp(filtered_0, filtered_1, (fraction));                                    \
  }

float3 SampleLUT1D(Texture2D<float4> lut, SamplerState state, float3 linear_color) {
  const int LUT_SIZE = 256;
  const int MAX_INDEX = LUT_SIZE - 1;
  const float LUT_SIZE_F = 256.0;
  const float MAX_INDEX_F = 255.0;
  const float INV_LUT_SIZE = 1.0 / 256.0;

  float3 gamma_color = renodx::color::gamma::Encode(saturate(linear_color), 2.2f);

  float3 uv = mad(gamma_color, MAX_INDEX_F * INV_LUT_SIZE, 0.5 * INV_LUT_SIZE);

  if (CUSTOM_LUT_SMOOTHING) {
    float3 position = mad(uv, LUT_SIZE_F, -0.5);
    int3 point_0 = (int3)floor(position);
    float3 fraction = frac(position);

    int3 point_a = clamp(point_0, 0, MAX_INDEX);
    int3 point_b = min(point_a + 1, MAX_INDEX);

    SampleLUT1DWithSmoothing(lut, x, MAX_INDEX, point_a.x, point_b.x, fraction.x, gamma_color.r);
    SampleLUT1DWithSmoothing(lut, y, MAX_INDEX, point_a.y, point_b.y, fraction.y, gamma_color.g);
    SampleLUT1DWithSmoothing(lut, z, MAX_INDEX, point_a.z, point_b.z, fraction.z, gamma_color.b);
  } else {  // vanilla LUT sampling
    gamma_color.r = lut.Sample(state, (uv.rr)).x;
    gamma_color.g = lut.Sample(state, (uv.gg)).y;
    gamma_color.b = lut.Sample(state, (uv.bb)).z;
  }

  linear_color = renodx::color::gamma::Decode(gamma_color, 2.2f);

  return linear_color;
}

#undef SampleLUT1DWithSmoothing

struct UserGradingConfig {
  float exposure;
  float highlights;
  float shadows;
  float contrast;
  float flare;
  float saturation;
  float dechroma;
  float hue_emulation_strength;
  float highlight_saturation;
  float chrominance_emulation_strength;
};

UserGradingConfig CreateColorGradeConfig() {
  const UserGradingConfig cg_config = {
    RENODX_TONE_MAP_EXPOSURE,                             // float exposure;
    RENODX_TONE_MAP_HIGHLIGHTS,                           // float highlights;
    RENODX_TONE_MAP_SHADOWS,                              // float shadows;
    RENODX_TONE_MAP_CONTRAST,                             // float contrast;
    0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),             // float flare;
    RENODX_TONE_MAP_SATURATION,                           // float saturation;
    RENODX_TONE_MAP_DECHROMA,                             // float dechroma;
    RENODX_TONE_MAP_HUE_SHIFT,                            // float hue_emulation_strength;
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    RENODX_TONE_MAP_BLOWOUT                               // float chrominance_emulation_strength;
  };
  return cg_config;
}

float Highlights(float x, float highlights, float mid_gray) {
  if (highlights == 1.f) return x;

  if (highlights > 1.f) {
    return max(x, lerp(x, mid_gray * pow(x / mid_gray, highlights), min(x, 10.f)));
  } else {  // highlights < 1.f
    x /= mid_gray;
    return lerp(x, pow(x, highlights), step(1.f, x)) * mid_gray;
  }
}

float Shadows(float x, float shadows, float mid_gray) {
  if (shadows == 1.f) return x;

  const float ratio = max(renodx::math::DivideSafe(x, mid_gray, 0.f), 0.f);
  const float base_term = x * mid_gray;
  const float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);

  if (shadows > 1.f) {
    float raised = x * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
    float reference = x * (1.f + base_scale);
    return max(x, x + (raised - reference));
  } else {  // shadows < 1.f
    float lowered = x * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
    float reference = x * (1.f - base_scale);
    return clamp(x + (lowered - reference), 0.f, x);
  }
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, UserGradingConfig config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  // contrast & flare
  const float y_normalized = y / mid_gray;
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent) * mid_gray;

  // highlights
  float y_highlighted = Highlights(y_contrasted, config.highlights, mid_gray);

  // shadows
  float y_shadowed = Shadows(y_highlighted, config.shadows, mid_gray);

  const float y_final = y_shadowed;

  color = renodx::color::correct::Luminance(color, y, y_final);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float3 hue_reference_color, float y, UserGradingConfig config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.hue_emulation_strength != 0.f || config.chrominance_emulation_strength != 0.f || config.highlight_saturation != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    // hue and chrominance emulation
    if (config.hue_emulation_strength != 0.0 || config.chrominance_emulation_strength != 0.0) {
      const float3 perceptual_reference = renodx::color::oklab::from::BT709(hue_reference_color);

      float chrominance_current = length(perceptual_new.yz);
      float chrominance_ratio = 1.0;

      if (config.hue_emulation_strength != 0.0) {
        const float chrominance_pre = chrominance_current;
        perceptual_new.yz = lerp(perceptual_new.yz, perceptual_reference.yz, config.hue_emulation_strength);
        const float chrominancePost = length(perceptual_new.yz);
        chrominance_ratio = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
        chrominance_current = chrominancePost;
      }

      if (config.chrominance_emulation_strength != 0.0) {
        const float reference_chrominance = length(perceptual_reference.yz);
        float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
        chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, config.chrominance_emulation_strength);
      }
      perceptual_new.yz *= chrominance_ratio;
    }

    // dechroma
    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    // highlight saturation
    if (config.highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float highlight_saturation_strength = 100.f;
      float highlight_saturation_change = pow(1.f - percent_max, highlight_saturation_strength * abs(config.highlight_saturation));
      if (config.highlight_saturation < 0) {
        highlight_saturation_change = (2.f - highlight_saturation_change);
      }

      perceptual_new.yz *= highlight_saturation_change;
    }

    // saturation
    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}
