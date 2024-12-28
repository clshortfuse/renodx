#include "./DICE.hlsl"
#include "./shared.h"

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  color = renodx::color::srgb::EncodeSafe(color);
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);

  return color;
}

float3 FinalizeOutput(float3 color) {
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
  } else {
    color = renodx::color::correct::GammaSafe(color);

    color = renodx::color::bt709::clamp::BT2020(color);

  }

  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  
  color *= injectedData.toneMapUINits;
  color = min(color, injectedData.toneMapPeakNits);  // Clamp UI or Videos

  color /= 80.f;

  return color;
}

float3 lutShaper(float3 color, bool builder = false) {
  color = builder ? renodx::color::pq::Decode(color, 100.f)
                  : renodx::color::pq::Encode(color, 100.f);

  return color;
}

//-----TONEMAP-----//
float3 RenoDRTSmoothClamp(float3 untonemapped) {
  renodx::tonemap::renodrt::Config renodrtSC_config = renodx::tonemap::renodrt::config::Create();
  renodrtSC_config.nits_peak = 100.f;
  renodrtSC_config.mid_gray_value = 0.18f;
  renodrtSC_config.mid_gray_nits = 18.f;
  renodrtSC_config.exposure = 1.f;
  renodrtSC_config.highlights = 1.f;
  renodrtSC_config.shadows = 1.f;
  renodrtSC_config.contrast = 1.05f;
  renodrtSC_config.saturation = 1.04f;
  renodrtSC_config.dechroma = 0.f;
  renodrtSC_config.flare = 0.f;
  renodrtSC_config.hue_correction_strength = 0.f;
  renodrtSC_config.hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;
  renodrtSC_config.tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  renodrtSC_config.hue_correction_type = renodx::tonemap::renodrt::config::hue_correction_type::INPUT;
  renodrtSC_config.working_color_space = 2u;
  renodrtSC_config.per_channel = false;
  float3 renoDRTColor = renodx::tonemap::renodrt::BT709(untonemapped, renodrtSC_config);
  return renoDRTColor;
}

float3 applyFrostbite(float3 color, renodx::tonemap::Config FbConfig) {
  float FbPeak = FbConfig.peak_nits / FbConfig.game_nits;
  if (FbConfig.gamma_correction == 1.f) {
    FbPeak = renodx::color::correct::Gamma(FbPeak, true);
  }
  float y = renodx::color::y::from::BT709(color * FbConfig.exposure);
  color = renodx::color::grade::UserColorGrading(color, FbConfig.exposure, FbConfig.highlights, FbConfig.shadows, FbConfig.contrast);
  color = renodx::tonemap::frostbite::BT709(color, FbPeak);
  if (FbConfig.reno_drt_dechroma != 0.f || FbConfig.saturation != 1.f) {
    float3 perceptual_new;

    if (FbConfig.reno_drt_hue_correction_method == 0u) {
      perceptual_new = renodx::color::oklab::from::BT709(color);
    } else if (FbConfig.reno_drt_hue_correction_method == 1u) {
      perceptual_new = renodx::color::ictcp::from::BT709(color);
    } else if (FbConfig.reno_drt_hue_correction_method == 2u) {
      perceptual_new = renodx::color::dtucs::uvY::from::BT709(color).zxy;
    }

    if (FbConfig.reno_drt_dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - FbConfig.reno_drt_dechroma))));
    }

    perceptual_new.yz *= FbConfig.saturation;

    if (FbConfig.reno_drt_hue_correction_method == 0u) {
      color = renodx::color::bt709::from::OkLab(perceptual_new);
    } else if (FbConfig.reno_drt_hue_correction_method == 1u) {
      color = renodx::color::bt709::from::ICtCp(perceptual_new);
    } else if (FbConfig.reno_drt_hue_correction_method == 2u) {
      color = renodx::color::bt709::from::dtucs::uvY(perceptual_new.yzx);
    }
  }
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 applyDICE(float3 color, renodx::tonemap::Config DiceConfig) {
  DICESettings DICEconfig = DefaultDICESettings();
  DICEconfig.Type = 3;
  DICEconfig.ShoulderStart = 0.33f;
  float DicePaperWhite = DiceConfig.game_nits / 80.f;
  float DicePeak = DiceConfig.peak_nits / 80.f;
  if (DiceConfig.gamma_correction == 1.f) {
    DicePaperWhite = renodx::color::correct::Gamma(DicePaperWhite, true);
    DicePeak = renodx::color::correct::Gamma(DicePeak, true);
  }

  float y = renodx::color::y::from::BT709(color * DiceConfig.exposure);
  color = renodx::color::grade::UserColorGrading(color, DiceConfig.exposure, DiceConfig.highlights, DiceConfig.shadows, DiceConfig.contrast);
  color = DICETonemap(color * DicePaperWhite, DicePeak, DICEconfig) / DicePaperWhite;

  if (DiceConfig.reno_drt_dechroma != 0.f || DiceConfig.saturation != 1.f) {
    float3 perceptual_new;

    if (DiceConfig.reno_drt_hue_correction_method == 0u) {
      perceptual_new = renodx::color::oklab::from::BT709(color);
    } else if (DiceConfig.reno_drt_hue_correction_method == 1u) {
      perceptual_new = renodx::color::ictcp::from::BT709(color);
    } else if (DiceConfig.reno_drt_hue_correction_method == 2u) {
      perceptual_new = renodx::color::dtucs::uvY::from::BT709(color).zxy;
    }

    if (DiceConfig.reno_drt_dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - DiceConfig.reno_drt_dechroma))));
    }

    perceptual_new.yz *= DiceConfig.saturation;

    if (DiceConfig.reno_drt_hue_correction_method == 0u) {
      color = renodx::color::bt709::from::OkLab(perceptual_new);
    } else if (DiceConfig.reno_drt_hue_correction_method == 1u) {
      color = renodx::color::bt709::from::ICtCp(perceptual_new);
    } else if (DiceConfig.reno_drt_hue_correction_method == 2u) {
      color = renodx::color::bt709::from::dtucs::uvY(perceptual_new.yzx);
    }
  }
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor = untonemapped;
  float3 hueCorrectionColor = RenoDRTSmoothClamp(outputColor);

  renodx::tonemap::Config config = renodx::tonemap::config::Create();

  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 1.f;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = 0.19f;
  config.mid_gray_nits = 19.f;
  config.reno_drt_contrast = 1.04f;
  config.reno_drt_saturation = 1.05f;
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.001 * pow(injectedData.colorGradeFlare, 2.3f);

  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(outputColor);
  }
  if (injectedData.toneMapType == 2.f) {  // Frostbite
    outputColor = applyFrostbite(outputColor, config);

  } else if (injectedData.toneMapType == 4.f) {  // DICE
    outputColor = applyDICE(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }

  return outputColor;
}
