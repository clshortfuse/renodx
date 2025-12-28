#include "../common.hlsli"

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.18f, float output_max = 1.f, float white_clip = 100.f) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

void ToneMapForGrading(inout float3 untonemapped, inout float scale) {
  if (RENODX_TONE_MAP_TYPE != 0.f && RENODX_TONE_MAP_TYPE != 3.f) {
    untonemapped = renodx::color::gamma::DecodeSafe(untonemapped, 2.2f);

    // untonemapped = renodx::color::correct::Hue(untonemapped, ExponentialRollOffExtended(untonemapped, 1.f, 2.f, 100.f));

    untonemapped = renodx::color::bt2020::from::BT709(untonemapped);
    untonemapped = max(0, untonemapped);

    scale = ComputeReinhardSmoothClampScale(untonemapped);
    untonemapped *= scale;

    untonemapped = renodx::color::bt709::from::BT2020(untonemapped);
    untonemapped = renodx::color::gamma::EncodeSafe(untonemapped, 2.2f);
  } else {  // Vanilla
    // noop
  }
}

void UpgradeToneMap(float3 ungraded_hdr, float3 ungraded_sdr, inout float3 output, float scale) {
  if (RENODX_TONE_MAP_TYPE != 0.f && RENODX_TONE_MAP_TYPE != 3.f) {
    output = renodx::color::gamma::DecodeSafe(output, 2.2f);
    output = renodx::color::bt709::clamp::BT2020(output);

    output = renodx::tonemap::UpgradeToneMap(
        renodx::color::gamma::DecodeSafe(ungraded_hdr, 2.2f),
        renodx::color::gamma::DecodeSafe(ungraded_sdr, 2.2f),
        output,
        RENODX_COLOR_GRADE_STRENGTH);

    UserGradingConfig cg_config = CreateColorGradeConfig();
    float y = renodx::color::y::from::BT709(output);
    float3 hue_correction_source = renodx::tonemap::ReinhardPiecewise(output, 6.f, 1.f);
    output = ApplyExposureContrastFlareHighlightsShadowsByLuminance(output, y, cg_config);
    output = ApplySaturationBlowoutHueCorrectionHighlightSaturation(output, hue_correction_source, y, cg_config);

    if (RENODX_TONE_MAP_TYPE == 2.f) {
#if 1
      output = renodx::color::bt709::from::BT2020(ApplyExponentialRolloffMaxChannel(
          max(0, renodx::color::bt2020::from::BT709(output)),
          RENODX_DIFFUSE_WHITE_NITS, RENODX_PEAK_WHITE_NITS,
          0.5f,
          100.f));
#else
      output = renodx::color::bt709::from::BT2020(ApplyHermiteSplineByMaxChannel(
          max(0, renodx::color::bt2020::from::BT709(output)),
          RENODX_DIFFUSE_WHITE_NITS, RENODX_PEAK_WHITE_NITS));
#endif
    }

    output = renodx::color::gamma::EncodeSafe(output, 2.2f);
  } else if (RENODX_TONE_MAP_TYPE == 3.f) {
    output = lerp(saturate(ungraded_hdr), saturate(output), RENODX_COLOR_GRADE_STRENGTH);
  } else {  // Vanilla
    // noop
  }
}
