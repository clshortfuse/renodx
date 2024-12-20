#ifndef SRC_FF7REMAKE_COMMON_HLSL_
#define SRC_FF7REMAKE_COMMON_HLSL_

#include "./shared.h"

float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrt_config =
      renodx::tonemap::renodrt::config::Create();
  renodrt_config.nits_peak = 100.f;
  renodrt_config.mid_gray_value = 0.18f;
  renodrt_config.mid_gray_nits = 18.f;
  renodrt_config.exposure = 1.f;
  renodrt_config.highlights = 1.f;
  renodrt_config.shadows = 1.f;
  renodrt_config.contrast = 1.05f;
  renodrt_config.saturation = 1.05f;
  renodrt_config.dechroma = 0.f;
  renodrt_config.flare = 0.f;
  renodrt_config.hue_correction_strength = 0.f;
  renodrt_config.tone_map_method =
      renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.working_color_space = 2u;

  return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
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
  // float ratio = 1.f;

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

float3 ToneMap(float3 color, float2 position) {
  color *= 1.0f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.tone_map_type;
  config.peak_nits = injectedData.tone_map_peak_nits;
  config.game_nits = injectedData.tone_map_game_nits;
  config.gamma_correction = injectedData.tone_map_gamma_correction;
  config.exposure = injectedData.color_grade_exposure;
  config.highlights = injectedData.color_grade_highlights;
  config.shadows = injectedData.color_grade_shadows;
  config.contrast = injectedData.color_grade_contrast;
  config.saturation = injectedData.color_grade_saturation;

  config.reno_drt_highlights = 1.20f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 1.1f;
  config.reno_drt_saturation = 1.0f;
  config.reno_drt_dechroma = 0;  // 0.80f;  // 0.80f
  config.reno_drt_blowout = injectedData.color_grade_blowout;
  config.reno_drt_flare = 0.10 * injectedData.color_grade_flare;
  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = injectedData.tone_map_per_channel != 0;

  // config.reno_drt_highlights = 1.00f;
  // config.reno_drt_shadows = 1.0f;
  // config.reno_drt_contrast = 2.0f;
  // config.reno_drt_saturation = 3.0f * .73 * 2.f;
  // config.reno_drt_dechroma = 2.f * 0.472f * 2.f * injectedData.colorGradeBlowout;
  // config.reno_drt_flare = 0.f;

  config.reno_drt_hue_correction_method = (uint)injectedData.tone_map_hue_processor;

  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.tone_map_hue_correction;
  config.hue_correction_color = color;
  if (injectedData.tone_map_hue_correction_method == 1.f) {
    config.hue_correction_color = renodx::tonemap::ACESFittedAP1(color);
  } else if (injectedData.tone_map_hue_correction_method == 2.f) {
    config.hue_correction_color = renodx::tonemap::uncharted2::BT709(color * 2.f);
  } else if (injectedData.tone_map_hue_correction_method == 3.f) {
    config.hue_correction_color = RenoDRTSmoothClamp(color);
  } else {
    config.hue_correction_type =
        renodx::tonemap::config::hue_correction_type::INPUT;
  }

  color = renodx::tonemap::config::Apply(color, config);

  if (injectedData.color_grade_color_space == 1.f) {
    // BT709 D65 => BT709 D93
    color = mul(float3x3(0.941922724f, -0.0795196890f, -0.0160709824f,
                         0.00374091602f, 1.01361334f, -0.00624059885f,
                         0.00760519271f, 0.0278747007f, 1.30704438f),
                color);
  } else if (injectedData.color_grade_color_space == 2.f) {
    // BT.709 D65 => BT.601 (NTSC-U)
    color = mul(float3x3(0.939542055f, 0.0501813553f, 0.0102765792f,
                         0.0177722238f, 0.965792834f, 0.0164349135f,
                         -0.00162159989f, -0.00436974968f, 1.00599133f),
                color);
  } else if (injectedData.color_grade_color_space == 3.f) {
    // BT.709 D65 => ARIB-TR-B09 D93 (NTSC-J)
    color = mul(float3x3(0.871554791f, -0.161164566f, -0.0151899587f,
                         0.0417598634f, 0.980491757f, -0.00258531118f,
                         0.00544220115f, 0.0462860465f, 1.73763155f),
                color);
  }

  if (injectedData.tone_map_gamma_correction == 1) {
    color = renodx::color::correct::GammaSafe(color);
  } else if (injectedData.tone_map_gamma_correction == 2) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  }

  if (injectedData.fx_film_grain != 0) {
    color = renodx::effects::ApplyFilmGrainColored(
        color.rgb,
        position.xy,
        float3(
            injectedData.random_1,
            injectedData.random_2,
            injectedData.random_3),
        injectedData.fx_film_grain * 0.01f,
        1.f);
  }

  color = renodx::color::bt2020::from::BT709(color);

  color = max(0, color);
  return color * injectedData.tone_map_game_nits;
}

#endif // SRC_FF7REMAKE_COMMON_HLSL_
