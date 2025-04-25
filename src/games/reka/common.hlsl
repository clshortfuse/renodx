#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen, bool colored){
    float3 grainedColor;
      if(colored == true){
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
      if(injectedData.toneMapGammaCorrection == 2.f){
    color = renodx::color::correct::GammaSafe(color, false, 2.4f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    color = renodx::color::correct::GammaSafe(color, true, 2.2f);
    } else {
    color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
    }
  return color;
}

float3 FinalizeOutput(float3 color) {
  	  if(injectedData.toneMapGammaCorrection == 2.f){
	  color = renodx::color::correct::GammaSafe(color, false, 2.4f);
  	} else if(injectedData.toneMapGammaCorrection == 1.f){
    color = renodx::color::correct::GammaSafe(color, false, 2.2f);
    }
    color *= injectedData.toneMapUINits;
      if(injectedData.toneMapType == 0.f){
    color = renodx::color::bt709::clamp::BT709(color);
    } else {
    color = renodx::color::bt709::clamp::BT2020(color);
    }
  	color /= 80.f;
  	return color;
}

// logc c1000 custom encoding
static const float arri_a = renodx::color::arri::logc::c1000::PARAMS.a;
static const float arri_b = renodx::color::arri::logc::c1000::PARAMS.b;
static const float arri_c = renodx::color::arri::logc::c1000::PARAMS.c;
static const float arri_d = renodx::color::arri::logc::c1000::PARAMS.d;

float3 arriDecode(float3 color) {
  return (pow(10.f, (color - arri_d) / arri_c) - arri_b) / arri_a;
}

float3 lutShaper(float3 color, bool builder = false){
		if(injectedData.colorGradeLUTShaper == 0.f){
    color = builder ? arriDecode(color)
					: saturate(renodx::color::arri::logc::c1000::Encode(color));
    } else {
    color = builder ? renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(color, 100.f))
					: renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color), 100.f);
    }
return color;
}

//-----TONEMAP-----//
float3 applyUserTonemap(float3 untonemapped, float3 vanilla, float midGray){
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
			config.reno_drt_contrast = 1.1f;
			//config.reno_drt_saturation = 1.05f;
			config.reno_drt_dechroma = injectedData.colorGradeDechroma;
			config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
			config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
      ? renodx::tonemap::config::hue_correction_type::INPUT
      : renodx::tonemap::config::hue_correction_type::CUSTOM;
			config.hue_correction_strength = injectedData.toneMapPerChannel != 0.f
      ? (1.f - injectedData.toneMapHueCorrection)
      : injectedData.toneMapHueCorrection;
			config.hue_correction_color = lerp(untonemapped, vanilla, injectedData.toneMapHueShift);
			config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
			config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
			config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;
			config.reno_drt_blowout = injectedData.colorGradeBlowout;
      config.reno_drt_white_clip = injectedData.colorGradeClip;
				if(injectedData.toneMapType == 0.f){
			outputColor = saturate(vanilla);
			} else {
      outputColor = untonemapped;
      }
return renodx::tonemap::config::Apply(outputColor, config);
}