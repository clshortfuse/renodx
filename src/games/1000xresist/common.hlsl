#include "./DICE.hlsl"
#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen) {
  float3 grainedColor = renodx::effects::ApplyFilmGrain(
      outputColor,
      screen,
      frac(injectedData.elapsedTime / 1000.f),
      injectedData.fxFilmGrain * 0.03f,
      1.f);
  return grainedColor;
}

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  color = renodx::color::correct::GammaSafe(color);
  color *= injectedData.toneMapGameNits / 80.f;
  color = renodx::color::correct::GammaSafe(color, true);
  return color;
}

float3 FinalizeOutput(float3 color) {
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
  } else {
    color = renodx::color::correct::GammaSafe(color);
    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 lutShaper(float3 color, bool builder = false) {
  color = builder ? renodx::color::pq::Decode(color, 100.f)
                  : renodx::color::pq::Encode(color, 100.f);

  return color;
}

float3 UIScale(float3 color) {
  color = renodx::color::correct::GammaSafe(color);
  color *= injectedData.toneMapUINits / 80.f;
  color = renodx::color::correct::GammaSafe(color, true);

  return color;
}

//-----TONEMAP-----//
float3 applyReinhardPlus(float3 color, renodx::tonemap::Config RhConfig) {
  float RhPeak = RhConfig.peak_nits / RhConfig.game_nits;
  if (RhConfig.gamma_correction == 1.f) {
    RhPeak = renodx::color::correct::Gamma(RhPeak, true);
  }

  color = renodx::color::ap1::from::BT709(color);
  float y = renodx::color::y::from::AP1(color * RhConfig.exposure);
  color = renodx::color::grade::UserColorGrading(color, RhConfig.exposure, RhConfig.highlights, RhConfig.shadows, RhConfig.contrast);
  color = renodx::tonemap::ReinhardScalable(color, RhPeak, 0.f, 0.18f, RhConfig.mid_gray_value);
  color = renodx::color::bt709::from::AP1(color);
  if (RhConfig.reno_drt_dechroma != 0.f || RhConfig.saturation != 1.f) {
    float3 perceptual_new;

    if (RhConfig.reno_drt_hue_correction_method == 0u) {
      perceptual_new = renodx::color::oklab::from::BT709(color);
    } else if (RhConfig.reno_drt_hue_correction_method == 1u) {
      perceptual_new = renodx::color::ictcp::from::BT709(color);
    } else if (RhConfig.reno_drt_hue_correction_method == 2u) {
      perceptual_new = renodx::color::dtucs::uvY::from::BT709(color).zxy;
    }

    if (RhConfig.reno_drt_dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - RhConfig.reno_drt_dechroma))));
    }

    perceptual_new.yz *= RhConfig.saturation;

    if (RhConfig.reno_drt_hue_correction_method == 0u) {
      color = renodx::color::bt709::from::OkLab(perceptual_new);
    } else if (RhConfig.reno_drt_hue_correction_method == 1u) {
      color = renodx::color::bt709::from::ICtCp(perceptual_new);
    } else if (RhConfig.reno_drt_hue_correction_method == 2u) {
      color = renodx::color::bt709::from::dtucs::uvY(perceptual_new.yzx);
    }
  }
  color = renodx::color::bt709::clamp::AP1(color);
  return color;
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor = untonemapped;
  float midGray = renodx::color::y::from::BT709(renodx::tonemap::ACESFittedAP1(float3(0.18f, 0.18f, 0.18f)));
  float3 hueCorrectionColor = renodx::tonemap::ACESFittedAP1(outputColor);

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
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_highlights = 1.2f;
  config.reno_drt_shadows = 1.2f;
  config.reno_drt_contrast = 1.3f;
  config.reno_drt_saturation = 1.2f;
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.005 * injectedData.colorGradeFlare;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;

  if (injectedData.toneMapType >= 3.f) {
    outputColor = renodx::color::correct::Hue(outputColor, hueCorrectionColor, injectedData.toneMapHueCorrection);
  }
  if (injectedData.toneMapType == 4.f) {
    // Reinhard+
    // We trust in Voosh defaults
    config.highlights *= 1.05f;
    config.shadows *= 1.1f;
    config.contrast *= 1.35f;
    config.saturation *= 1.25f;
    outputColor = applyReinhardPlus(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }

  return outputColor;
}
