#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen)
{
  float3 grainedColor = renodx::effects::ApplyFilmGrain(
      outputColor,
      screen,
      injectedData.random,
			injectedData.fxFilmGrain * 0.03f,
			1.f);
    return grainedColor;
}

//-----SCALING-----//
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
  if(injectedData.toneMapGammaCorrection == 2.f){
	  color = renodx::color::gamma::DecodeSafe(color, 2.4f);
	} else if(injectedData.toneMapGammaCorrection == 1.f){
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
    color = renodx::color::srgb::DecodeSafe(color);
  }
  color *= injectedData.toneMapUINits;
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
    color = min(injectedData.toneMapGameNits, color);
  } else if(injectedData.toneMapType >= 2.f) {
    color = renodx::color::bt709::clamp::BT2020(color);
    color = min(color, injectedData.toneMapPeakNits);
  }
  color /= 80.f;
return color;
}

//-----TONEMAP-----//
float3 applyUserTonemap(float3 untonemapped, float3 vanilla, float midGray) {
  float3 outputColor;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
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
  config.reno_drt_highlights = 1.1f;
  config.reno_drt_contrast = 1.07f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, vanilla, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = (int)injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
   outputColor = min(1.f, vanilla);
  } else {
    outputColor = untonemapped;
  }
return renodx::tonemap::config::Apply(outputColor, config);
}

float3 doLutThings(float3 input, Texture2D lutTexture, SamplerState lutSampler){
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lutSampler;
  lut_config.strength = 1.f;
  lut_config.scaling = injectedData.colorGradeLUTScaling;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
  if(injectedData.colorGradeLUTStrength == 0.f){return input;}
  float y = renodx::color::y::from::BT709(input);
  float3 neutralSDR = renodx::tonemap::renodrt::NeutralSDR(input);
  float3 sdrColor = lerp(input, neutralSDR, saturate(y));
  float3 lutColor = renodx::lut::Sample(sdrColor, lut_config, lutTexture);
  float3 color_output = renodx::tonemap::UpgradeToneMap(input, sdrColor, lutColor, injectedData.colorGradeLUTStrength);
return color_output;
}

float3 rolloffSdr(float3 color, float ratio = 0.85f) {
  if (injectedData.toneMapType == 0.f) { return saturate(color);}
  float old_y = renodx::color::y::from::BT709(color);
  float y_max = 1.f;
  float new_y = renodx::tonemap::ExponentialRollOff(old_y, y_max * ratio, y_max); 
return saturate(color * renodx::math::DivideSafe(new_y, old_y));
}