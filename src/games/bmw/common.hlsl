#include "./shared.h"

static const float DEFAULT_BRIGHTNESS = 0.f;  // 50%
static const float DEFAULT_CONTRAST = 1.f;    // 50%
static const float DEFAULT_GAMMA = 1.f;

float3 CorrectGamma(float3 color) {
  color = renodx::color::correct::GammaSafe(color);
  return color;
}

float3 DecodedTosRGB(float3 input_linear) {
  if (injectedData.toneMapType > 1.f) {
    input_linear = renodx::color::srgb::EncodeSafe(saturate(input_linear));
    input_linear = saturate(input_linear);
  }
  return input_linear;
}

float3 PQToDecoded(float3 input_pq) {
  float3 output = input_pq;
  if (injectedData.toneMapType > 1.f) {
    output = renodx::color::pq::Decode(input_pq, injectedData.toneMapGameNits);
  }

  return output;
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

  return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
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

float3 UpgradePostProcess(float3 tonemappedRender, float3 post_processed, float lerpValue = 1.f) {
  float3 output = post_processed;
  if (injectedData.toneMapType == 1.f) {
    output = tonemappedRender;
  } else if (injectedData.toneMapType > 1.f) {
    if (lerpValue == 0.f) {
      output = renodx::color::pq::Encode(tonemappedRender, injectedData.toneMapGameNits);
    } else {
      post_processed = renodx::color::srgb::DecodeSafe(post_processed);
      output = UpgradeToneMapPerChannel(tonemappedRender, saturate(tonemappedRender), saturate(post_processed), lerpValue);
      output = renodx::color::pq::Encode(output, injectedData.toneMapGameNits);
    }
  }

  return output;
}

float3 ToneMap(float3 bt709) {
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  // We override ACES
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 1.f;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;

  // Default inverts smooth clamp
  config.reno_drt_highlights = 1.0f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 1.05f;
  config.reno_drt_saturation = 1.05f;
  config.reno_drt_dechroma = 0;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  // Flare darkens too much (stalker2)
  // config.reno_drt_flare = 0.10f * injectedData.colorGradeFlare;
  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = false;

  float3 output_color = renodx::tonemap::config::Apply(bt709, config);

  return output_color;
}

float4 FinalizeUEOutput(float4 scene, float4 ui, bool is_hdr10 = true, bool only_correct_ui = false) {
  scene.rgb = renodx::color::pq::Decode(scene.rgb, injectedData.toneMapGameNits);

  ui.rgb = renodx::color::srgb::Decode(ui.rgb);
  ui.rgb = renodx::color::bt2020::from::BT709(ui.rgb);
  if (only_correct_ui) {
    ui.rgb = CorrectGamma(ui.rgb);
  }
  ui.rgb = ui.rgb * injectedData.toneMapUINits / injectedData.toneMapGameNits;

  if (is_hdr10) {
    scene.rgb = lerp(scene.rgb, ui.rgb, ui.a);
    if (!only_correct_ui) {
      scene.rgb = CorrectGamma(scene.rgb);
    }
    scene.rgb = renodx::color::pq::Encode(scene.rgb, injectedData.toneMapGameNits);

    return float4(scene.rgb, ui.a);
  } else {
    return scene;
  }
}

float3 FinalizeTonemap(float3 color, bool is_hdr10 = true) {
  color = renodx::color::gamma::DecodeSafe(color);
  color *= injectedData.toneMapUINits;
  color = min(color, injectedData.toneMapPeakNits);  // Clamp UI or Videos

  color /= 80.f;

  return color;
}

float3 UpgradeToneMapAP1(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(untonemapped_ap1);

  float3 neutral_sdr_color = RenoDRTSmoothClamp(untonemapped_bt709);

  float3 untonemapped_graded;

  untonemapped_graded = UpgradeToneMapByLuminance(
      untonemapped_bt709,
      neutral_sdr_color,
      tonemapped_bt709,
      1);

  return ToneMap(untonemapped_graded);
}

float4 LutBuilderToneMap(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 color = UpgradeToneMapAP1(untonemapped_ap1, tonemapped_bt709);

  // Correct gamma in final shader causes issues with FSR3 FG
  color = renodx::color::bt709::clamp::BT2020(color);
  color = renodx::color::bt2020::from::BT709(color);
  if (injectedData.toneMapGammaCorrection == 1.f) {
    color = CorrectGamma(color);
  }
  color = renodx::color::pq::Encode(color, injectedData.toneMapGameNits);
  color *= 1.f / 1.05f;
  return float4(color, 0.f);
}
