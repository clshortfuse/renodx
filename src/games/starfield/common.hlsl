#include "./shared.h"

half Sign(half x) {
  return mad(saturate(mad(x, 65504.h, 0.5h)), 2.h, -1.h);
}

half3 ComputeCAS(half3 a, half3 b, half3 c, half3 d, half3 e, half strength) {
  half max_value;
  half min_value;
  bool use_luminance = true;
  if (use_luminance) {
    float a_y = renodx::color::y::from::BT709(a);
    float b_y = renodx::color::y::from::BT709(b);
    float c_y = renodx::color::y::from::BT709(c);
    float d_y = renodx::color::y::from::BT709(d);
    float e_y = renodx::color::y::from::BT709(e);
    max_value = max(max(max(max(a_y, b_y), c_y), d_y), e_y);
    min_value = min(min(min(min(a_y, b_y), c_y), d_y), e_y);
  } else {
    // use green
    max_value = max(max(max(max(a.g, b.g), c.g), d.g), e.g);
    min_value = min(min(min(min(a.g, b.g), c.g), d.g), e.g);
  }

  if (max_value == 0.h) return c;
  half value_0 = min(min_value, (1.0h - max_value)) * (1.0h / max_value);

  half value_1 = strength * Sign(value_0) * sqrt(abs(value_0));
  half value_2 = 1.0h / (value_1 * 4.0h + 1.0h);

  half3 computed = ((value_1 * (a + b + d + e) + c) * value_2);
  computed = renodx::color::bt709::clamp::BT2020(computed);
  return computed;
}

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

float3 FinalizeOutput(float3 color) {
  color = renodx::color::bt709::clamp::BT2020(color);
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }

  if (injectedData.colorGradeColorSpace == 1.f) {
    // BT709 D65 => BT709 D93
    color = mul(float3x3(0.941922724f, -0.0795196890f, -0.0160709824f,
                         0.00374091602f, 1.01361334f, -0.00624059885f,
                         0.00760519271f, 0.0278747007f, 1.30704438f),
                color);
  } else if (injectedData.colorGradeColorSpace == 2.f) {
    // BT.709 D65 => BT.601 (NTSC-U)
    color = mul(float3x3(0.939542055f, 0.0501813553f, 0.0102765792f,
                         0.0177722238f, 0.965792834f, 0.0164349135f,
                         -0.00162159989f, -0.00436974968f, 1.00599133f),
                color);
  } else if (injectedData.colorGradeColorSpace == 3.f) {
    // BT.709 D65 => ARIB-TR-B09 D93 (NTSC-J)
    color = mul(float3x3(0.871554791f, -0.161164566f, -0.0151899587f,
                         0.0417598634f, 0.980491757f, -0.00258531118f,
                         0.00544220115f, 0.0462860465f, 1.73763155f),
                color);
  }

  color *= injectedData.toneMapUINits;
  color = min(color, injectedData.toneMapPeakNits);  // Clamp UI or Videos

  color /= 80.f;
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
  renodrt_config.tone_map_method =
      renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.working_color_space = 2u;

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
  config.reno_drt_saturation = 1.05f;
  config.reno_drt_dechroma = 0;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * injectedData.colorGradeFlare;
  config.reno_drt_working_color_space = 2u;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;

  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;

  config.hue_correction_strength = injectedData.toneMapHueCorrection;

  float3 output_color = renodx::tonemap::config::Apply(bt709, config);

  return output_color;
}

float4 LutBuilderToneMap(float3 untonemapped_ap1, float3 tonemapped_bt709) {
  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(max(0, untonemapped_ap1));

  float3 neutral_sdr_color = RenoDRTSmoothClamp(untonemapped_bt709);

  float3 untonemapped_graded = UpgradeToneMapPerChannel(
      untonemapped_bt709,
      neutral_sdr_color,
      tonemapped_bt709,
      1);

  float3 color = ToneMap(untonemapped_graded);
  color = renodx::color::bt709::clamp::BT2020(color);
  color = PostToneMapScale(color);
  color *= 1.f / 1.05f;
  return float4(color, 1);
}

// float bethesdaSRGB(float color, float a, float gamma) {
//   float d = (2.f * color - 1.f) * a;
//   float e = d / (sqrt(d * d) + 1.f);
//   float f = e * (2.f * a / sqrt(a * a + 1.f)) + 0.5f;

//   return max(pow(_x, 1.f / gamma) * 1.055f - 0.055f, 0.0f);
// }
