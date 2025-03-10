#include "./shared.h"

renodx::tonemap::config::DualToneMap ApplyDualToneMap(float3 color) {
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection - 1;  // LUT output was in 2.2
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_highlights = 0.74f;
  config.reno_drt_contrast = 1.825f;
  config.reno_drt_saturation = 0.92f;
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
  config.reno_drt_working_color_space = injectedData.toneMapWorkingColorSpace;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  config.hue_correction_strength = 1.f;

  renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(color, config);

  return dual_tone_map;
}
