#include "./shared.h"

float3 applyNeutralTonemapAP1(float3 untonemapped, float midGray = 0.18f) {
  float3 ap1_color = renodx::color::ap1::from::BT709(untonemapped * midGray / 0.18f);
  float3 tonemapped = renodx::color::bt709::from::AP1(
      renodx::tonemap::ExponentialRollOff(ap1_color, 1.f, 4.f));
  return tonemapped;
}

float UpgradeToneMapRatio(float ap1_color_hdr, float ap1_color_sdr, float ap1_post_process_color) {
  if (ap1_color_hdr < ap1_color_sdr) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return ap1_color_hdr / ap1_color_sdr;
  } else {
    float ap1_delta = ap1_color_hdr - ap1_color_sdr;
    ap1_delta = max(0, ap1_delta);  // Cleans up NaN
    const float ap1_new = ap1_post_process_color + ap1_delta;

    const bool ap1_valid = (ap1_post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / ap1_post_process_color) : 0;
  }
}
float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  float3 ap1_hdr = max(0, renodx::color::ap1::from::BT709(color_hdr));
  float3 ap1_sdr = max(0, renodx::color::ap1::from::BT709(color_sdr));
  float3 ap1_post_process = max(0, renodx::color::ap1::from::BT709(post_process_color));

  float3 ratio = float3(
      UpgradeToneMapRatio(ap1_hdr.r, ap1_sdr.r, ap1_post_process.r),
      UpgradeToneMapRatio(ap1_hdr.g, ap1_sdr.g, ap1_post_process.g),
      UpgradeToneMapRatio(ap1_hdr.b, ap1_sdr.b, ap1_post_process.b));

  float3 color_scaled = max(0, ap1_post_process * ratio);
  color_scaled = renodx::color::bt709::from::AP1(color_scaled);
  float peak_correction = saturate(1.f - renodx::color::y::from::AP1(ap1_post_process));
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color, peak_correction);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 UpgradeToneMapByLuminance(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  float3 bt2020_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
  float3 bt2020_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
  float3 bt2020_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));

  float ratio = UpgradeToneMapRatio(
      renodx::color::y::from::BT2020(bt2020_hdr),
      renodx::color::y::from::BT2020(bt2020_sdr),
      renodx::color::y::from::BT2020(bt2020_post_process));

  float3 color_scaled = max(0, bt2020_post_process * ratio);
  color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 ToneMap(float3 color, float3 vanillaColor, float midGray) {
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = 3u;
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = 0.f;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.reno_drt_tone_map_method = RENODX_RENO_DRT_TONE_MAP_METHOD;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = config.mid_gray_value * 100.f;

  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);

  config.reno_drt_highlights = 1.f;
  config.reno_drt_shadows = 1.f;
  config.reno_drt_contrast = 1.f;
  config.reno_drt_saturation = 1.f;

  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0;

  color = renodx::tonemap::config::Apply(color, config);

  return color;
}

float3 applyACES(float3 untonemapped, float midGray = 0.1f, float peak_nits = 1000.f, float game_nits = 250.f) {
  renodx::tonemap::Config aces_config = renodx::tonemap::config::Create();
  aces_config.peak_nits = peak_nits;
  aces_config.game_nits = game_nits;
  aces_config.type = 2u;
  aces_config.mid_gray_value = midGray;
  aces_config.mid_gray_nits = midGray * 100.f;
  aces_config.gamma_correction = 0;
  return renodx::tonemap::config::ApplyACES(untonemapped, aces_config);
}

float3 applyReferenceACES(float3 untonemapped, float midGray = 0.1f) {
  return applyACES(untonemapped, midGray, 1000.f, 250.f);
}

float3 extractColorGradeAndApplyTonemap(float3 ungraded_bt709, float3 lutOutputColor_bt709, float midGray = 0.18f, float vanilla_paperwhite = 200.f) {
  float3 graded_aces_bt709 = lutOutputColor_bt709;

  float3 tonemapped_bt709 = graded_aces_bt709;
  // separate the display mapping from the color grading/tone mapping
  float3 reference_tonemap_bt709 = renodx::tonemap::ReinhardScalable(ungraded_bt709, 1000.f / vanilla_paperwhite, 0.f, 0.18f, midGray);
  float3 graded_untonemapped_bt709 = UpgradeToneMapPerChannel(ungraded_bt709, reference_tonemap_bt709, graded_aces_bt709, 1.f);

  tonemapped_bt709 = ToneMap(graded_untonemapped_bt709, graded_aces_bt709, midGray);

  if (CUSTOM_LUT_STRENGTH != 1.f) {
    float3 ungraded_tonemapped_bt709 = ToneMap(ungraded_bt709, graded_aces_bt709, midGray);

    tonemapped_bt709 = lerp(ungraded_tonemapped_bt709, tonemapped_bt709, CUSTOM_LUT_STRENGTH);
  }

  // Keep it linear
  return tonemapped_bt709;
}
