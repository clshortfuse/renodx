#ifndef RENODX_UNREAL_LUT_BUILDER_USER_GRADING_HLSLI_
#define RENODX_UNREAL_LUT_BUILDER_USER_GRADING_HLSLI_

#include "../common.hlsli"

float AnchoredPowerContrastSmootherStep(float t) {
  return t * t * t * (t * (t * 6.f - 15.f) + 10.f);
}

float ApplyAnchoredPowerContrast(
    float x,
    float contrast,
    float anchor_in = 0.18f,
    float anchor_out = 0.18f,
    float flare = 0.f,
    float contrast_highlights = 1.f,
    float contrast_shadows = 1.f,
    float highlights = 1.f,
    float shadows = 1.f) {
  if (contrast == 1.f && flare == 0.f
      && contrast_highlights == 1.f && contrast_shadows == 1.f
      && highlights == 1.f && shadows == 1.f) {
    return x / anchor_in * anchor_out;
  }

  float normalized = x / anchor_in;
  float contrasted_normalized = normalized;
  if (contrast != 1.f || flare != 0.f) {
    float flare_ratio = renodx::math::DivideSafe(normalized + flare, normalized, 1.f);
    contrasted_normalized = pow(normalized, contrast * flare_ratio);
  }

  if (contrast_highlights != 1.f) {
    float highlight_distance = max(contrasted_normalized - 1.f, 0.f);
    contrasted_normalized += highlight_distance
                             * (pow(1.f + highlight_distance * highlight_distance,
                                    (contrast_highlights - 1.f) / 2.f)
                                - 1.f);
  }

  if (contrast_shadows != 1.f) {
    float shadow_distance = max(1.f - contrasted_normalized, 0.f);
    contrasted_normalized *= pow(
        1.f + shadow_distance * shadow_distance * shadow_distance,
        contrast_shadows - 1.f);
  }

  float contrasted = contrasted_normalized * anchor_out;

  if (highlights != 1.f) {
    float t = saturate(log2(contrasted / anchor_out) / log2(1.f / anchor_out));
    t = AnchoredPowerContrastSmootherStep(t);
    if (highlights > 1.f) {
      contrasted = lerp(contrasted, anchor_out * pow(contrasted / anchor_out, highlights), t);
    } else {
      float compressed = anchor_out * pow(contrasted / anchor_out, 2.f - highlights);
      contrasted = renodx::math::DivideSafe(
          contrasted * contrasted,
          lerp(contrasted, compressed, t),
          contrasted);
    }
  }

  if (shadows != 1.f) {
    float ratio = max(renodx::math::DivideSafe(contrasted, anchor_out, 0.f), 0.f);
    float base_term = contrasted * anchor_out;
    float base_scale = renodx::math::DivideSafe(base_term, ratio, 0.f);
    float shadow_floor = anchor_out / 16.f;
    float t = saturate(log2(contrasted / anchor_out) / log2(shadow_floor / anchor_out));
    t = AnchoredPowerContrastSmootherStep(t);
    if (shadows > 1.f) {
      float raised = contrasted
                     * (1.f + renodx::math::DivideSafe(base_term, pow(ratio, shadows), 0.f));
      float reference = contrasted * (1.f + base_scale);
      contrasted += (raised - reference) * t;
    } else {
      float lowered = contrasted
                      * (1.f - renodx::math::DivideSafe(base_term, pow(ratio, 2.f - shadows), 0.f));
      float reference = contrasted * (1.f - base_scale);
      contrasted += (lowered - reference) * t;
    }
  }

  return contrasted;
}

float3 ScalePurityMBAdaptive(
    float3 lms_input,
    float purity_scale,
    float3 lms_adaptive_state,
    float eps = 1e-7f) {
  if (abs(purity_scale - 1.f) <= eps) return lms_input;

  float3 lms_relative = renodx::tonemap::psychov::psycho17_ToAdaptiveRelativeLMS(
      lms_input,
      lms_adaptive_state);
  float3 mb = renodx::color::macleod_boynton::from::LMS(lms_relative);
  float2 mb_white = renodx::color::macleod_boynton::from::LMS(1.f.xxx).xy;
  float2 mb_scaled = mb_white + (mb.xy - mb_white) * purity_scale;

  return renodx::tonemap::psychov::psycho17_FromAdaptiveRelativeLMS(
      renodx::color::lms::from::MacLeodBoynton(float3(mb_scaled, mb.z)),
      lms_adaptive_state);
}

float3 ApplyUserGradingAP1(float3 ungraded_ap1) {
  if (RENODX_TONE_MAP_EXPOSURE == 1.f
      && RENODX_TONE_MAP_HIGHLIGHTS == 1.f
      && RENODX_TONE_MAP_SHADOWS == 1.f
      && RENODX_TONE_MAP_CONTRAST == 1.f
      && RENODX_TONE_MAP_FLARE == 0.f
      && RENODX_TONE_MAP_SATURATION == 1.f
      && RENODX_TONE_MAP_HIGHLIGHT_SATURATION == 1.f
      && RENODX_TONE_MAP_BLOWOUT == 0.f) {
    return ungraded_ap1;
  }

  const float MID_GRAY = 0.18f;
  float yf = max(renodx::color::yf::from::AP1(ungraded_ap1), 0.f);
  float graded_yf = ApplyAnchoredPowerContrast(
      yf * RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_CONTRAST,
      MID_GRAY,
      MID_GRAY,
      0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      1.f,
      1.f,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS);
  float3 graded_ap1 = ungraded_ap1 * renodx::math::DivideSafe(graded_yf, yf, 1.f);

  float purity_scale = RENODX_TONE_MAP_SATURATION;

  if (RENODX_TONE_MAP_BLOWOUT != 0.f) {
    purity_scale *= lerp(1.f, 0.f, saturate(pow(graded_yf / (10000.f / 100.f), 1.f - RENODX_TONE_MAP_BLOWOUT)));
  }

  float purity_highlights = 1.f - RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  if (purity_highlights != 0.f) {
    float percent_max = saturate(graded_yf * 100.f / 10000.f);
    float blowout_change = pow(1.f - percent_max, 100.f * abs(purity_highlights));
    if (purity_highlights < 0.f) {
      blowout_change = 2.f - blowout_change;
    }
    purity_scale *= blowout_change;
  }

  if (purity_scale != 1.f) {
    float3 color_lms = renodx::color::lms::from::AP1(graded_ap1);
    color_lms = ScalePurityMBAdaptive(
        color_lms,
        purity_scale,
        renodx::color::lms::from::AP1(MID_GRAY.xxx));
    graded_ap1 = renodx::color::ap1::from::LMS(color_lms);
  }

  graded_ap1 = max(0, graded_ap1);

  return graded_ap1;
}

#endif  // RENODX_UNREAL_LUT_BUILDER_USER_GRADING_HLSLI_
