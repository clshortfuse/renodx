#include "./shared.h"

float3 ApplyCustomGrade1(float3 color) {
  if (RENODX_TONE_MAP_EXPOSURE != 1.f || RENODX_TONE_MAP_HIGHLIGHTS != 1.f || RENODX_TONE_MAP_SHADOWS != 1.f || RENODX_TONE_MAP_CONTRAST != 1.f || RENODX_TONE_MAP_FLARE != 0.f) {
    float color_y = renodx::color::y::from::BT709(color);
    float mid_gray = 0.18f;

    color *= RENODX_TONE_MAP_EXPOSURE;

    const float color_y_normalized = color_y / mid_gray;

    float flare = renodx::math::DivideSafe(color_y_normalized + RENODX_TONE_MAP_FLARE, color_y_normalized, 1.f);

    float exponent = RENODX_TONE_MAP_CONTRAST * flare;

    const float color_y_contrast = pow(color_y_normalized, exponent) * mid_gray;

    float y_highlights = renodx::color::grade::Highlights(color_y_contrast, RENODX_TONE_MAP_HIGHLIGHTS, mid_gray);

    float y_shadows = renodx::color::grade::Shadows(y_highlights, RENODX_TONE_MAP_SHADOWS, mid_gray);
    y_shadows = max(0, y_shadows);

    const float y_final = y_shadows;

    color = renodx::color::correct::Luminance(color, color_y, y_final);
  }
  return color;
}

float3 ApplyCustomGrade2(float3 color) {
  if (RENODX_TONE_MAP_SATURATION != 1.f || RENODX_TONE_MAP_HIGHLIGHT_SATURATION != 1.f || RENODX_TONE_MAP_BLOWOUT != 0.f) {
    float3 color_perceptual = renodx::color::ictcp::from::BT709(color);
    float y = renodx::color::y::from::BT709(color);
    float highlight_saturation = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);

    if (RENODX_TONE_MAP_BLOWOUT != 0.f) {
      color_perceptual.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - RENODX_TONE_MAP_BLOWOUT))));
    }

    if (highlight_saturation != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(highlight_saturation));
      if (highlight_saturation < 0) {
        blowout_change = (2.f - blowout_change);
      }

      color_perceptual.yz *= blowout_change;
    }

    color_perceptual.yz *= RENODX_TONE_MAP_SATURATION;

    color = renodx::color::bt709::from::ICtCp(color_perceptual);
  }
  return renodx::color::bt709::clamp::AP1(color);
}

float3 NeutralSDR(float3 color) {
  float3 sdr_color = renodx::tonemap::renodrt::NeutralSDR(color);
  float y = renodx::color::y::from::BT709(color);

  return lerp(color, sdr_color, saturate(y));
}

float3 N2PerChannelLMS(float3 color) {
  const float3 lms_white = renodx::color::lms::from::BT709(1.f);

  float3 lms_color_normalized = renodx::color::lms::from::BT709(color) / lms_white;
  float3 lms_peak_normalized = renodx::color::lms::from::BT709(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS) / lms_white;
  float3 lms_displaymapped_normalized = renodx::tonemap::neutwo::PerChannel(lms_color_normalized, lms_peak_normalized);

  return renodx::color::bt709::from::LMS(lms_displaymapped_normalized * lms_white);
}

float3 ApplyGammaCorrectionLMS(float3 color_bt709, bool inverse) {
  const float3 lms_white = renodx::color::lms::from::BT709(1.f);

  float3 color_lms_normalized = renodx::color::lms::from::BT709(color_bt709) / lms_white;
  return renodx::color::bt709::from::LMS(
      renodx::color::correct::GammaSafe(color_lms_normalized, inverse) * lms_white);
}