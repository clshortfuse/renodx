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

float3 FinalizeOutput(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  color *= injectedData.toneMapUINits;
  color = min(color, injectedData.toneMapPeakNits);  // Clamp UI or Videos

  if (injectedData.colorGradeColorSpace == 3.f) {
    // BT.709 D65 => ARIB-TR-B09 D93 (NTSC-J)
    color = mul(float3x3(
                    0.871554791f, -0.161164566f, -0.0151899587f,
                    0.0417598634f, 0.980491757f, -0.00258531118f,
                    0.00544220115f, 0.0462860465f, 1.73763155f),
                color);
  } else if (injectedData.colorGradeColorSpace == 2.f) {
    // BT.709 D65 => BT.601 (NTSC-U)
    color = mul(float3x3(
                    0.939542055f, 0.0501813553f, 0.0102765792f,
                    0.0177722238f, 0.965792834f, 0.0164349135f,
                    -0.00162159989f, -0.00436974968f, 1.00599133f),
                color);
  } else if (injectedData.colorGradeColorSpace == 1.f) {
    // BT709 D65 => BT709 D93
    color = mul(float3x3(
                    0.941922724f, -0.0795196890f, -0.0160709824f,
                    0.00374091602f, 1.01361334f, -0.00624059885f,
                    0.00760519271f, 0.0278747007f, 1.30704438f),
                color);
  }

  color /= 80.f;  // or PQ
  return color;
}

float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrt_config = renodx::tonemap::renodrt::config::Create();
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
  renodrt_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrt_config.working_color_space = 2u;

  return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
}

float3 ToneMap(float3 color) {
  color = max(0, color);
  color = renodx::color::srgb::DecodeSafe(color);

  if (injectedData.toneMapType == 0.f) {
    color = saturate(color);
  }
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_contrast = 1.04f;
  config.reno_drt_saturation = 1.05f;
  config.mid_gray_nits = 19.f;
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::ICTCP;

  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = color;
  if (injectedData.toneMapHueCorrectionMethod == 3.f) {
    config.hue_correction_color = RenoDRTSmoothClamp(color);
  } else if (injectedData.toneMapHueCorrectionMethod == 2.f) {
    config.hue_correction_color = renodx::tonemap::uncharted2::BT709(color);
  } else if (injectedData.toneMapHueCorrectionMethod == 1.f) {
    config.hue_correction_color = saturate(color);
  } else {
    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::INPUT;
  }

  color = renodx::tonemap::config::Apply(color, config);

  color = renodx::color::bt709::clamp::BT709(color);  // Needed for later blending
  return color;
}

