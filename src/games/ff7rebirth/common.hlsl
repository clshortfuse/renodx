#ifndef SRC_FF7REBIRTH_COMMON_HLSL_
#define SRC_FF7REBIRTH_COMMON_HLSL_

#include "./shared.h"

// AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// This is hue conserving and only really affects highlights.
// "sdr_color" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// https://github.com/Filoppi/PumboAutoHDR
float3 PumboAutoHDR(float3 sdr_color, float shoulder_pow = 2.75f) {
  const float SDRRatio = max(renodx::color::y::from::BT2020(sdr_color), 0.f);

  // Limit AutoHDR brightness, it won't look good beyond a certain level.
  // The paper white multiplier is applied later so we account for that.
  float target_max_luminance = min(RENODX_PEAK_WHITE_NITS, pow(10.f, ((log10(RENODX_DIFFUSE_WHITE_NITS) - 0.03460730900256) / 0.757737096673107)));
  target_max_luminance = lerp(1.f, target_max_luminance, .5f);

  const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
  const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
  const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
  const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
  return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
}

float3 applyHueSat(float3 input_color, float3 correct_hue_sat, float strength = 1.f) {
  float3 input_color_oklab = renodx::color::oklab::from::BT709(input_color);
  float3 correct_hue_sat_oklab = renodx::color::oklab::from::BT709(correct_hue_sat);

  float3 corrected_oklab =
      float3(input_color_oklab.x,
             lerp(input_color_oklab.y, correct_hue_sat_oklab.y, strength),
             lerp(input_color_oklab.z, correct_hue_sat_oklab.z, strength));

  return renodx::color::bt709::from::OkLab(corrected_oklab);
}

float3 applyNeutralTonemapAP1(float3 untonemapped, float midGray = 0.18f) {
  float3 ap1_color = renodx::color::ap1::from::BT709(untonemapped * midGray / 0.18f);
  float3 tonemapped = renodx::color::bt709::from::AP1(
      renodx::tonemap::ExponentialRollOff(ap1_color, 1.f, 4.f));
  return tonemapped;
}

float3 convertColorSpace(float3 tonemapped_bt709) {
  if (COLOR_GRADE_COLOR_SPACE == 1.f) {
    // BT709 D65 => BT709 D93
    tonemapped_bt709 = mul(float3x3(0.941922724f, -0.0795196890f, -0.0160709824f,
                                    0.00374091602f, 1.01361334f, -0.00624059885f,
                                    0.00760519271f, 0.0278747007f, 1.30704438f),
                           tonemapped_bt709);
  } else if (COLOR_GRADE_COLOR_SPACE == 2.f) {
    // BT.709 D65 => BT.601 (NTSC-U)
    tonemapped_bt709 = mul(float3x3(0.939542055f, 0.0501813553f, 0.0102765792f,
                                    0.0177722238f, 0.965792834f, 0.0164349135f,
                                    -0.00162159989f, -0.00436974968f, 1.00599133f),
                           tonemapped_bt709);
  } else if (COLOR_GRADE_COLOR_SPACE == 3.f) {
    // BT.709 D65 => ARIB-TR-B09 D93 (NTSC-J)
    tonemapped_bt709 = mul(float3x3(0.871554791f, -0.161164566f, -0.0151899587f,
                                    0.0417598634f, 0.980491757f, -0.00258531118f,
                                    0.00544220115f, 0.0462860465f, 1.73763155f),
                           tonemapped_bt709);
  }

  return tonemapped_bt709;
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
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = config.mid_gray_value * 100.f;

  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.reno_drt_flare = 0.10f * RENODX_TONE_MAP_FLARE;

  config.reno_drt_highlights = 1.f;
  config.reno_drt_shadows = 1.f;
  config.reno_drt_contrast = 1.f;
  config.reno_drt_saturation = 1.04f;

  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0;

  config.reno_drt_hue_correction_method = (uint)RENODX_TONE_MAP_HUE_PROCESSOR;

  // hue shifting
  if (!RENODX_TONE_MAP_PER_CHANNEL) {
    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;

    float3 incorrect_hue_ap1 = renodx::color::ap1::from::BT709(color * midGray / 0.18f);
    config.hue_correction_color = renodx::color::bt709::from::AP1(renodx::tonemap::ExponentialRollOff(incorrect_hue_ap1, midGray, 2.f));

    config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::CUSTOM;
    config.hue_correction_strength = RENODX_TONE_MAP_HUE_SHIFT;
  } else {
    config.hue_correction_strength = 0.f;
  }

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

float3 extractColorGradeAndApplyTonemap(float3 ungraded_bt709, float3 lutOutputColor_bt2020, float midGray) {
  // normalize LUT output paper white and convert to BT.709
  float3 graded_aces_bt709 = renodx::color::bt709::from::BT2020(lutOutputColor_bt2020 * (10000.f / 250.f));

  float3 tonemapped_bt709;
  if (RENODX_TONE_MAP_TYPE != 0) {
    // separate the display mapping from the color grading/tone mapping
    float3 reference_tonemap_bt709 = renodx::tonemap::ReinhardScalable(ungraded_bt709, 1000.f / 250.f, 0.f, 0.18f, midGray);
    float3 graded_untonemapped_bt709 = UpgradeToneMapPerChannel(ungraded_bt709, reference_tonemap_bt709, graded_aces_bt709, 1.f);

    tonemapped_bt709 = ToneMap(graded_untonemapped_bt709, graded_aces_bt709, midGray);

    if (CUSTOM_LUT_STRENGTH != 1.f) {
      float3 ungraded_tonemapped_bt709 = ToneMap(ungraded_bt709, graded_aces_bt709, midGray);

      tonemapped_bt709 = lerp(ungraded_tonemapped_bt709, tonemapped_bt709, CUSTOM_LUT_STRENGTH);
    }
  } else {
    // using custom_aces as hdr_color allows us to extend (or compress) the dynamic range
    // in a way that looks natural and perfectly preserves the original look
    float3 reference_tonemap_bt709 = applyReferenceACES(ungraded_bt709, midGray);
    float3 custom_aces = applyACES(ungraded_bt709, midGray, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);
    tonemapped_bt709 = UpgradeToneMapByLuminance(custom_aces, reference_tonemap_bt709, graded_aces_bt709, CUSTOM_LUT_STRENGTH);

    // clean up slight overshoot with very low peak values
    tonemapped_bt709 = min(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, tonemapped_bt709);
  }
  tonemapped_bt709 = convertColorSpace(tonemapped_bt709);

  tonemapped_bt709 = renodx::color::bt2020::from::BT709(tonemapped_bt709);

  return tonemapped_bt709 * (RENODX_DIFFUSE_WHITE_NITS / 10000.f);
}

#endif  // SRC_FF7REBIRTH_COMMON_HLSL_