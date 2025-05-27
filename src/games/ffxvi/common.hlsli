#include "./shared.h"

void AdjustPeak(inout float peak_ratio) {
  if (RENODX_OVERRIDE_PEAK_NITS) {
    peak_ratio = RENODX_PEAK_WHITE_NITS / 260.f;
  }
  peak_ratio *= (260.f / RENODX_DIFFUSE_WHITE_NITS);

  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
    peak_ratio = 100.f;
  }
}

float3 ApplySliders(inout float r, inout float g, inout float b, inout float y_in) {
  float3 untonemapped = float3(r, g, b);

  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+

    renodx::color::grade::Config cg_config = renodx::color::grade::config::Create(
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT,
        0.f,
        0,
        renodx::color::grade::config::hue_correction_type::INPUT,
        -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f));
    untonemapped = renodx::color::grade::config::ApplyUserColorGrading(
        untonemapped,
        cg_config);
  }

  r = untonemapped.r;
  g = untonemapped.g;
  b = untonemapped.b;

  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
    r = renodx::color::y::from::BT709((float3(r, g, b)));
    y_in = r;
  }

  return untonemapped;
}

void FinalizeToneMap(inout float r, inout float g, inout float b, float3 untonemapped, float y_in) {
  float3 tonemapped_bt709 = float3(r, g, b);
  if (RENODX_TONE_MAP_TYPE == 1.f) {  // Vanilla+
    float y_out = r;
    tonemapped_bt709 = untonemapped * select(y_in > 0, y_out / y_in, 0.f);

    float3 display_mapped_bt709 = renodx::tonemap::ExponentialRollOff(tonemapped_bt709, RENODX_TONE_MAP_SHOULDER_START, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    display_mapped_bt709 = renodx::color::correct::Hue(display_mapped_bt709, tonemapped_bt709, RENODX_TONE_MAP_HUE_CORRECTION);
    tonemapped_bt709 = display_mapped_bt709;
  }

  if (RENODX_CUSTOM_COLOR_SPACE == 1.f) {  // BT709 D65 => BT709 D93
    tonemapped_bt709 = renodx::color::bt709::from::BT709D93(tonemapped_bt709);
  }

  tonemapped_bt709 *= RENODX_DIFFUSE_WHITE_NITS / 260.f;
  r = tonemapped_bt709.r;
  g = tonemapped_bt709.g;
  b = tonemapped_bt709.b;
}
