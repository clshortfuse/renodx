#include "./shared.h"

float ApplyExposureContrastFlareHighlightsShadowsByLuminance(float y, float mid_gray = 0.18f) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = 1.f;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);

  if (config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return y;
  }

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  // color *= (y > 0 ? (y_final / y) : 0);

  return y_final;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped) {
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  config.dechroma = RENODX_TONE_MAP_BLOWOUT;

  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float y = renodx::color::y::from::BT709(color);

    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);
  }
  return color;
}

// Replaces the game's ACES peak, min and exposure inputs, scaled so that 100 is diffuse white.
// SDR EOTF emulation mode 1 pre-applies the inverse of the 2.2 correction done at output. Mode 2 skips the 2.2 shape
// and lowers the ACES min nits instead, which lowers the curve's black floor.
void ApplyToneMapInputs(inout float peak_nits, inout float min_nits, inout float exposure) {
  if (RENODX_OVERRIDE_PEAK_NITS) {
    peak_nits = RENODX_PEAK_WHITE_NITS;
  }
  if (!RENODX_TONE_MAP_TYPE) return;

  min_nits = (RENODX_SDR_EOTF_EMULATION == 2.f ? 0.0000000016f : 0.0001f);
  exposure = 8.f * RENODX_TONE_MAP_EXPOSURE;

  if (RENODX_SDR_EOTF_EMULATION == 1.f) {
    peak_nits = renodx::color::correct::Gamma(peak_nits / RENODX_DIFFUSE_WHITE_NITS, true) * 100.f;
    min_nits = renodx::color::correct::Gamma(min_nits / RENODX_DIFFUSE_WHITE_NITS, true) * 100.f;
  } else {
    peak_nits = (peak_nits / RENODX_DIFFUSE_WHITE_NITS) * 100.f;
    min_nits = (min_nits / RENODX_DIFFUSE_WHITE_NITS) * 100.f;
  }
}
