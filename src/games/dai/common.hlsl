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
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  color = renodx::color::gamma::DecodeSafe(color, 2.4f);
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
  color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  color = renodx::color::srgb::DecodeSafe(color);
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
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
  } else {
    color = renodx::color::bt709::clamp::BT2020(color);
  }
  color /= 80.f;
  return color;
}

float3 InverseToneMap(float3 color) {
  if (injectedData.toneMapType != 0.f) {
    float scaling = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    float videoPeak = scaling * renodx::color::bt2408::REFERENCE_WHITE;
    videoPeak = renodx::color::gamma::Encode(videoPeak, 2.2f);
    videoPeak = renodx::color::gamma::Decode(videoPeak, 2.4f);
    scaling = renodx::color::gamma::Encode(scaling, 2.2f);
    scaling = renodx::color::gamma::Decode(scaling, 2.4f);
      if(injectedData.toneMapGammaCorrection == 2.f){
    videoPeak = renodx::color::gamma::Encode(videoPeak, 2.4f);
    videoPeak = renodx::color::gamma::Decode(videoPeak, 2.2f);
    scaling = renodx::color::gamma::Encode(scaling, 2.4f);
    scaling = renodx::color::gamma::Decode(scaling, 2.2f);    
    } else if(injectedData.toneMapGammaCorrection == 0.f){
    videoPeak = renodx::color::correct::Gamma(videoPeak, false, 2.2f);
    scaling = renodx::color::correct::Gamma(scaling, false, 2.2f);
    }
    color = renodx::color::gamma::Decode(color, 2.4f);
    color = renodx::tonemap::inverse::bt2446a::BT709(color, renodx::color::bt709::REFERENCE_WHITE, videoPeak);
    color /= videoPeak;
    color *= scaling;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else {
  }
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  return color;
}

float gammaCorrectPeak(float peak) {
  if (injectedData.toneMapGammaCorrection == 0.f) {
   return renodx::color::gamma::Decode(renodx::color::srgb::Encode(peak / injectedData.toneMapGameNits), 2.2f) * injectedData.toneMapGameNits;
  } else if (injectedData.toneMapGammaCorrection == 2.f) {
    return renodx::color::gamma::Decode(renodx::color::gamma::Encode(peak / injectedData.toneMapGameNits, 2.4), 2.2f) * injectedData.toneMapGameNits;
 } else {
   return peak;
 }
}

//-----TONEMAP-----//
float3 applyUserTonemap(float3 untonemapped, Texture3D lutTexture, SamplerState lutSampler, float3 LUTless, float midGray, bool cutscene = false) {
  float3 outputColor;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType > 1.f ? 3.f : injectedData.toneMapType;
  config.peak_nits = gammaCorrectPeak(injectedData.toneMapPeakNits);
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 0.f;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  if (cutscene == false) {
  config.reno_drt_shadows = 0.9f;
  config.reno_drt_contrast = 1.2f;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  } else {
  config.reno_drt_flare = 0.005f * pow(injectedData.colorGradeFlare, 10.f);
  }
  config.reno_drt_saturation = 1.1f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
                                   ? renodx::tonemap::config::hue_correction_type::INPUT
                                   : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, LUTless, injectedData.toneMapHueShift);
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_hue_correction_method = (int)injectedData.toneMapHueProcessor;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = injectedData.colorGradeLUTStrength;
  lut_config.scaling = 0.f;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  lut_config.size = 32;
  lut_config.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(LUTless);
  } else {
    outputColor = untonemapped;
  }
return renodx::tonemap::config::Apply(outputColor, config, lut_config, lutTexture);;
}
