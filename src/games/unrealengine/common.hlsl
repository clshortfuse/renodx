#include "./shared.h"

float3 PostToneMapScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::srgb::EncodeSafe(color);
  }

  return color;
}

float UpgradeToneMapRatio(float color_hdr, float color_sdr, float post_process_color) {
  if (color_hdr < color_sdr) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return color_hdr / color_sdr;
  } else {
    float delta = color_hdr - color_sdr;
    delta = max(0, delta);  // Cleans up NaN
    const float new_value = post_process_color + delta;

    const bool valid = (post_process_color > 0);  // Cleans up NaN and ignore black
    return valid ? (new_value / post_process_color) : 0;
  }
}
float3 UpgradeToneMapPerChannel(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

  float3 bt2020_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
  float3 bt2020_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
  float3 bt2020_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));

  float3 ratio = float3(
      UpgradeToneMapRatio(bt2020_hdr.r, bt2020_sdr.r, bt2020_post_process.r),
      UpgradeToneMapRatio(bt2020_hdr.g, bt2020_sdr.g, bt2020_post_process.g),
      UpgradeToneMapRatio(bt2020_hdr.b, bt2020_sdr.b, bt2020_post_process.b));

  float3 color_scaled = max(0, bt2020_post_process * ratio);
  color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
  float peak_correction = saturate(1.f - renodx::color::y::from::BT2020(bt2020_post_process));
  color_scaled = renodx::color::correct::Hue(color_scaled, post_process_color, peak_correction);
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 UpgradeToneMapByLuminance(float3 color_hdr, float3 color_sdr, float3 post_process_color, float post_process_strength) {
  // float ratio = 1.f;

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

float3 FinalizeOutput(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }

  if (injectedData.colorGradeColorSpace == 1.f) {
    color = renodx::color::bt709::from::BT709D93(color);
  } else if (injectedData.colorGradeColorSpace == 2.f) {
    color = renodx::color::bt709::from::BT601NTSCU(color);
  } else if (injectedData.colorGradeColorSpace == 3.f) {
    color = renodx::color::bt709::from::ARIBTRB9(color);
  }

  color *= injectedData.toneMapUINits;
  color = min(color, injectedData.toneMapPeakNits);  // Clamp UI or Videos

  // Always clamp to BT2020
  color = renodx::color::bt2020::from::BT709(color);
  color = max(0, color);

  if (injectedData.processingUseSCRGB == 1.f) {
    color = renodx::color::bt709::from::BT2020(color);
    color = color / 80.f;
  } else {
    color = renodx::color::pq::Encode(color, 1.f);
  }

  return color;
}

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
  renodrt_config.working_color_space = 0u;

  // renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;

  return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
}

float3 ToneMap(float3 bt709) {
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = 3.f;
  config.peak_nits = injectedData.toneMapPeakNits;
  // config.peak_nits = 10000.f;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;

  // Default inverts smooth clamp
  config.reno_drt_highlights = 1.0f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 1.0f;
  config.reno_drt_saturation = 1.0f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;

  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;

  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  if (injectedData.toneMapHueCorrectionMethod == 1.f) {
    config.hue_correction_type =
        renodx::tonemap::config::hue_correction_type::CUSTOM;
    config.hue_correction_color = RenoDRTSmoothClamp(bt709);
  }

  float3 output_color = renodx::tonemap::config::Apply(bt709, config);

  return output_color;
}

float3 UpgradeToneMapAP1(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  float3 untonemapped_graded = untonemapped_bt709;
  if (injectedData.colorGradeStrength != 0) {
    float3 neutral_sdr_color = RenoDRTSmoothClamp(untonemapped_bt709);

    if (injectedData.colorGradeRestorationMethod == 1) {
      untonemapped_graded = UpgradeToneMapPerChannel(
          untonemapped_bt709,
          neutral_sdr_color,
          tonemapped_bt709,
          1);
    } else {
      untonemapped_graded = UpgradeToneMapByLuminance(
          untonemapped_bt709,
          neutral_sdr_color,
          tonemapped_bt709,
          1);
    }
    untonemapped_graded = lerp(untonemapped_bt709, untonemapped_graded, injectedData.colorGradeStrength);
  }
  return ToneMap(untonemapped_graded);
}

float4 LutBuilderToneMap(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 color = UpgradeToneMapAP1(untonemapped_ap1, tonemapped_bt709);

  color = renodx::color::bt709::clamp::BT2020(color);
  color = PostToneMapScale(color);
  color *= 1.f / 1.05f;
  return float4(color, 1);
}
