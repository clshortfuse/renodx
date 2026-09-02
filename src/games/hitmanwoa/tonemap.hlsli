#include "./shared.h"

#define LMS_WHITE_BT709  renodx::color::lms::from::BT709(1.0f)
#define LMS_WHITE_BT2020 renodx::color::lms::from::BT2020(1.0f)

float3 ApplyPurityFromLMS(
    float3 lms_source,
    float3 lms_target,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f) {
  float3 mb_source = renodx::color::macleod_boynton::from::LMS(lms_source);
  float3 mb_target = renodx::color::macleod_boynton::from::LMS(lms_target);
  float2 mb_white = renodx::color::macleod_boynton::from::D65XY();

  float2 source_offset = mb_source.xy - mb_white;
  float2 target_offset = mb_target.xy - mb_white;
  float src_radius = length(source_offset);
  float tgt_radius = length(target_offset);
  if (tgt_radius <= eps) return lms_target;

  float transfer_scale = src_radius / max(tgt_radius, eps);
  float no_purity_loss_scale = max(transfer_scale, 1.f);
  transfer_scale = lerp(transfer_scale, no_purity_loss_scale, clamp_purity_loss);
  float scale = lerp(1.f, transfer_scale, amount);
  float2 mb_scaled = mb_white + target_offset * scale;
  return renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb_target.z));
}

float3 ApplyPurityFromBT2020(
    float3 bt2020_source,
    float3 bt2020_target,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f,
    bool compress_gamut = true) {
  if (amount <= 0.f) return bt2020_target;

  float3 lms_target = renodx::color::lms::from::BT2020(bt2020_target);
  float3 lms_source = renodx::color::lms::from::BT2020(bt2020_source);
  float3 lms_out = ApplyPurityFromLMS(
      lms_source,
      lms_target,
      amount,
      clamp_purity_loss,
      eps);

  if (compress_gamut) {
    lms_out = renodx::tonemap::psychov::psycho17_GamutCompressLMSBoundAdaptive(
        lms_out,
        1.f.xxx,
        renodx::color::macleod_boynton::BT2020_TO_LMS_WEIGHTED_MAT,
        1.f);
  }
  return renodx::color::bt2020::from::LMS(lms_out);
}

float3 ApplyPurityFromBT709(
    float3 bt709_source,
    float3 bt709_target,
    float amount = 1.f,
    float clamp_purity_loss = 0.f,
    float eps = 1e-7f,
    bool compress_gamut = true) {
  if (amount <= 0.f) return bt709_target;

  float3 lms_target = renodx::color::lms::from::BT709(bt709_target);
  float3 lms_source = renodx::color::lms::from::BT709(bt709_source);
  float3 lms_out = ApplyPurityFromLMS(
      lms_source,
      lms_target,
      amount,
      clamp_purity_loss,
      eps);

  if (compress_gamut) {
    lms_out = renodx::tonemap::psychov::psycho17_GamutCompressLMSBoundAdaptive(
        lms_out,
        1.f.xxx,
        renodx::color::macleod_boynton::BT709_TO_LMS_WEIGHTED_MAT,
        1.f);
  }
  return renodx::color::bt709::from::LMS(lms_out);
}

static const float HITMAN_BRANCHING_POINT = 0.00414824f;
static const float REINHARD_BRANCHING_POINT = 0.465571f;

#define APPLY_TONEMAP_HITMAN_GENERATOR(T)                                       \
  T ToneMapHitman(T x) {                                                        \
    return renodx::tonemap::ApplyCurve(x, 0.6f, 1.f, 0.1f, 1.f, 0.004f, 0.06f); \
  }

APPLY_TONEMAP_HITMAN_GENERATOR(float)
APPLY_TONEMAP_HITMAN_GENERATOR(float3)

#undef APPLY_TONEMAP_HITMAN_GENERATOR

float ToneMapHitmanDerivative(float x) {
  float N = 0.6f * x * x + 0.1f * x + 0.004f;
  float D = 0.6f * x * x + 1.f * x + 0.06f;

  float Np = 1.2f * x + 0.1f;  // dN/dx
  float Dp = 1.2f * x + 1.f;   // dD/dx

  return (Np * D - N * Dp) / (D * D);
}

#define APPLY_HITMAN_EXTENDED_GENERATOR(T)                            \
  T ToneMapHitmanExtended(T x, float original_blend_strength = 0.f) { \
    const T base = ToneMapHitman(x);                                  \
                                                                      \
    const float pivot_x = HITMAN_BRANCHING_POINT;                     \
    float pivot_y = ToneMapHitman(pivot_x);                           \
    float slope = ToneMapHitmanDerivative(pivot_x);                   \
                                                                      \
    float offset = pivot_y - slope * pivot_x;                         \
    T extended = slope * x + offset;                                  \
                                                                      \
    T hdr_tonemapped = lerp(base, extended, step(pivot_x, x));        \
                                                                      \
    return lerp(hdr_tonemapped, base, original_blend_strength);       \
  }

APPLY_HITMAN_EXTENDED_GENERATOR(float)
APPLY_HITMAN_EXTENDED_GENERATOR(float3)

#undef APPLY_HITMAN_EXTENDED_GENERATOR

float3 ApplyCustomHitmanToneMap(float3 untonemapped) {
  float y_in = renodx::color::yf::from::BT709(untonemapped);
  float y_out = ToneMapHitmanExtended(y_in);
  float3 hdr_tonemap = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

  float3 ch_tonemap = renodx::color::bt709::from::LMS(
      renodx::tonemap::ReinhardPiecewise(
          ToneMapHitmanExtended(renodx::color::lms::from::BT709(untonemapped) / LMS_WHITE_BT709), 4.f, HITMAN_BRANCHING_POINT)
      * LMS_WHITE_BT709);

  hdr_tonemap = ApplyPurityFromBT709(ch_tonemap, hdr_tonemap, RENODX_TONE_MAP_BLOWOUT, 0.f, 1e-7f, true);

  return hdr_tonemap;
}

float ReinhardDerivative(float x, float peak = 1.f) {
  return (peak * peak) / ((x + peak) * (x + peak));
}

#define APPLY_EXTENDED_GENERATOR(T)                               \
  T ApplyReinhardPlus(T x, float original_blend_strength = 1.f) { \
    const T base = renodx::tonemap::Reinhard(x);                  \
                                                                  \
    float pivot_x = REINHARD_BRANCHING_POINT;                     \
    float pivot_y = renodx::tonemap::Reinhard(pivot_x);           \
    float slope = ReinhardDerivative(pivot_x);                    \
    T offset = pivot_y - slope * pivot_x;                         \
                                                                  \
    T extended = slope * x + offset; /* match slope */            \
                                                                  \
    T hdr_tonemapped = lerp(base, extended, step(pivot_x, x));    \
                                                                  \
    return lerp(hdr_tonemapped, base, original_blend_strength);   \
  }

APPLY_EXTENDED_GENERATOR(float)
APPLY_EXTENDED_GENERATOR(float3)
#undef APPLY_EXTENDED_GENERATOR

float3 ApplyCustomSimpleReinhardToneMap(float3 untonemapped) {
  float y_in = renodx::color::yf::from::BT709(untonemapped);
  float y_out = ApplyReinhardPlus(y_in);
  float3 hdr_tonemap = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

  float3 ch_tonemap = renodx::color::bt709::from::LMS(
      renodx::tonemap::ReinhardPiecewise(
          ApplyReinhardPlus(renodx::color::lms::from::BT709(untonemapped) / LMS_WHITE_BT709), 4.f, REINHARD_BRANCHING_POINT)
      * LMS_WHITE_BT709);

  hdr_tonemap = ApplyPurityFromBT709(ch_tonemap, hdr_tonemap, RENODX_TONE_MAP_BLOWOUT, 0.f, 1e-7f, true);

  return hdr_tonemap;
}

// USER GRADING
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
    0.f,                                                  // float hue_emulation_strength; handled earlier
    -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),  // float highlight_saturation;
    0.f                                                   // float chrominance_emulation_strength; handled earlier
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
