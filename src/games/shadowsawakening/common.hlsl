#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen, bool colored) {
  float3 grainedColor;
  if (colored == true) {
    grainedColor = renodx::effects::ApplyFilmGrainColored(
        outputColor,
        screen,
        float3(
            injectedData.random_1,
            injectedData.random_2,
            injectedData.random_3),
        injectedData.fxFilmGrain * 0.01f,
        1.f);
  } else {
    grainedColor = renodx::effects::ApplyFilmGrain(
        outputColor,
        screen,
        injectedData.random_1,
        injectedData.fxFilmGrain * 0.03f,
        1.f);
  }
  return grainedColor;
}

//-----SCALING-----//
float3 PostToneMapScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
  }
  color *= injectedData.toneMapGameNits;
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
  } else {
    color = renodx::color::bt709::clamp::BT2020(color);
  }
  color /= 80.f;
  return color;
}

float3 UIScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::correct::Gamma(color, false, 2.4f);
    color *= injectedData.toneMapUINits / 80.f;
    color = renodx::color::correct::Gamma(color, true, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::correct::Gamma(color, false, 2.2f);
    color *= injectedData.toneMapUINits / 80.f;
    color = renodx::color::correct::Gamma(color, true, 2.2f);
  } else {
    color *= injectedData.toneMapUINits / 80.f;
  }
  return color;
}

float3 lutShaper(float3 color, bool builder = false) {
  // color = builder ? renodx::color::arri::logc::c1000::Decode(color, false)
  //				: saturate(renodx::color::arri::logc::c1000::Encode(color, false));
  color = builder ? renodx::color::pq::Decode(color, 100.f)
                  : renodx::color::pq::Encode(color, 100.f);
  return color;
}

float3 InverseToneMap(float3 color) {
  if (injectedData.toneMapType != 0.f) {
  color = renodx::color::srgb::Encode(color);
	float scaling = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
	float videoPeak = scaling * renodx::color::bt2408::REFERENCE_WHITE;
    videoPeak = renodx::color::correct::Gamma(videoPeak, false, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, false, 2.4f);
      if(injectedData.toneMapGammaCorrection == 2.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.4f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, true, 2.2f);
    scaling = renodx::color::correct::Gamma(scaling, true, 2.2f);
    }
  color = renodx::color::gamma::Decode(color, 2.4f);
  color = renodx::tonemap::inverse::bt2446a::BT709(color, renodx::color::bt709::REFERENCE_WHITE, videoPeak);
	color /= videoPeak;
	color *= scaling;
  color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  color = renodx::color::srgb::DecodeSafe(color);
  } else {}
	return color;
}

float3 ITMScale(float3 color) {
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.2f);
  } else {
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  }
  return color;
}

//-----TONEMAP-----//
float3 applyReinhardPlus(float3 color, renodx::tonemap::Config RhConfig, bool sdr = false) {
  float RhPeak = sdr ? 1.f : RhConfig.peak_nits / RhConfig.game_nits;
  if (RhConfig.gamma_correction != 0.f && sdr == false) {
    RhPeak = renodx::color::correct::Gamma(RhPeak, RhConfig.gamma_correction > 0.f, abs(RhConfig.gamma_correction) == 1.f ? 2.2f : 2.4f);
  }

  float y;
  if (RhConfig.reno_drt_working_color_space == 0u) {
    color = max(0, color);
    y = renodx::color::y::from::BT709(color * RhConfig.exposure);
  } else if (RhConfig.reno_drt_working_color_space == 1u) {
    color = renodx::color::bt2020::from::BT709(color);
    y = renodx::color::y::from::BT2020(abs(color * RhConfig.exposure));
  } else if (RhConfig.reno_drt_working_color_space == 2u) {
    color = renodx::color::ap1::from::BT709(color);
    y = renodx::color::y::from::AP1(color * RhConfig.exposure);
  }

  color = renodx::color::grade::UserColorGrading(color, RhConfig.exposure, RhConfig.highlights, RhConfig.shadows, RhConfig.contrast);
  color = renodx::tonemap::ReinhardScalable(color, RhPeak, 0.f, 0.18f, RhConfig.mid_gray_value);

  if (RhConfig.reno_drt_working_color_space == 1u) {
    color = renodx::color::bt709::from::BT2020(color);
  } else if (RhConfig.reno_drt_working_color_space == 2u) {
    color = renodx::color::bt709::from::AP1(color);
  }

  if (RhConfig.reno_drt_dechroma != 0.f || RhConfig.saturation != 1.f || RhConfig.reno_drt_blowout != 0.f || RhConfig.hue_correction_strength != 0.f) {
    float3 perceptual_new;

    if (RhConfig.reno_drt_hue_correction_method == 0u) {
      perceptual_new = renodx::color::oklab::from::BT709(color);
    } else if (RhConfig.reno_drt_hue_correction_method == 1u) {
      perceptual_new = renodx::color::ictcp::from::BT709(color);
    } else if (RhConfig.reno_drt_hue_correction_method == 2u) {
      perceptual_new = renodx::color::dtucs::uvY::from::BT709(color).zxy;
    }

    if (RhConfig.hue_correction_strength != 0.f) {
      float3 perceptual_old;
      if (RhConfig.hue_correction_type != renodx::tonemap::config::hue_correction_type::CUSTOM) {
        RhConfig.hue_correction_color = color;
      }

      if (RhConfig.reno_drt_hue_correction_method == 0u) {
        perceptual_old = renodx::color::oklab::from::BT709(RhConfig.hue_correction_color);
      } else if (RhConfig.reno_drt_hue_correction_method == 1u) {
        perceptual_old = renodx::color::ictcp::from::BT709(RhConfig.hue_correction_color);
      } else if (RhConfig.reno_drt_hue_correction_method == 2u) {
        perceptual_old = renodx::color::dtucs::uvY::from::BT709(RhConfig.hue_correction_color).zxy;
      }
      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, 0);
      perceptual_new.yz = lerp(perceptual_new.yz, perceptual_old.yz, RhConfig.hue_correction_strength);
      float chrominance_post_adjust = distance(perceptual_new.yz, 0);
      // Apply back previous chrominance
      perceptual_new.yz *= renodx::math::DivideSafe(chrominance_pre_adjust, chrominance_post_adjust, 1.f);
    }
    if (RhConfig.reno_drt_dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - RhConfig.reno_drt_dechroma))));
    }

    if (RhConfig.reno_drt_blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(RhConfig.reno_drt_blowout));
      if (RhConfig.reno_drt_blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }
      perceptual_new.yz *= blowout_change;
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

float3 applyVanillaTonemap(float3 color) {  // custom uc2
  static const float A = 0.02;
  static const float B = 0.24914;
  static const float C = 0.19459;
  static const float D = 0.30877;
  static const float E = 0.02;
  static const float F = 0.3;
  static const float whiteLevel = 10.13;
  static const float whiteClip = 0.938;

  float3 whiteScale = 1 / renodx::tonemap::ApplyCurve(whiteLevel, A, B, C, D, E, F);
  color = max(0, color);
  color = renodx::tonemap::ApplyCurve(color * whiteScale, A, B, C, D, E, F);
  color *= whiteScale;
  color /= whiteClip;

  return color;
}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor = untonemapped;
  float midGray = renodx::color::y::from::BT709(applyVanillaTonemap(float3(0.18f, 0.18f, 0.18f)));
  float3 hueCorrectionColor = applyVanillaTonemap(untonemapped);
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
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_contrast = 0.9f;
  config.reno_drt_saturation = 1.f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.01 * pow(injectedData.colorGradeFlare, 5.32192809489);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapPerChannel != 0.f
                                       ? (1.f - injectedData.toneMapHueCorrection)
                                       : injectedData.toneMapHueCorrection;
  config.hue_correction_color = hueCorrectionColor;
  config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(hueCorrectionColor);
  }
  if (injectedData.toneMapType == 4.f) {  // Reinhard+
    config.contrast *= 0.9f;
    config.saturation *= 0.95f;
    config.hue_correction_type = renodx::tonemap::config::hue_correction_type::CUSTOM;
    config.hue_correction_strength = injectedData.toneMapHueCorrection;
    outputColor = applyReinhardPlus(outputColor, config);
  } else {
    outputColor = renodx::tonemap::config::Apply(outputColor, config);
  }
  return outputColor;
}
