#include "./shared.h"

//-----EFFECTS-----//
float3 applyFilmGrain(float3 outputColor, float2 screen){
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
  } else if (injectedData.toneMapGammaCorrection == 1.f){
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
  } else {
  color = renodx::color::srgb::DecodeSafe(color);
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

float3 InverseToneMapBT2446a(float3 color) {
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
  } else {}
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);
	return color;
}

//-----TONEMAP-----//
float3 vanillaTonemap(float3 color){
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  return (color * (a * color + b)) / (color * (c * color + d) + e);
}

float3 vanillaTonemapInverse(float3 x) {
  static const float a = 2.51;
  static const float b = 0.03;
  static const float c = 2.43;
  static const float d = 0.59;
  static const float e = 0.14;
  float3 part1 = renodx::math::DivideSafe(
    d * x - b,
  2.f * (a - c * x));
  float3 part2 = renodx::math::DivideSafe(
    renodx::math::SignSqrt(4.f * a * e * x + b * b - 2.f * b * d * x - 4.f * c * e * x * x + d * d * x * x),
  2.f * (a - c * x));
return part1 + part2;
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

float3 applyVideoTonemap(float3 untonemapped){
  float3 outputColor;
  float midGray = vanillaTonemap(float3(0.18f,0.18f,0.18f)).x;
  float3 hueCorrectionColor = vanillaTonemap(untonemapped);
  bool perChannel = injectedData.toneMapPerChannel != 0.f;
    renodx::tonemap::Config config = renodx::tonemap::config::Create();
    config.type = injectedData.toneMapType > 1.f ? 3.f : injectedData.toneMapType;
    config.peak_nits = gammaCorrectPeak(injectedData.toneMapPeakNits);
    config.game_nits = injectedData.toneMapGameNits;
    config.gamma_correction = 0.f;
    config.mid_gray_value = midGray;
    config.mid_gray_nits = midGray * 100;
    config.reno_drt_shadows = 0.95f;
    config.reno_drt_contrast = 1.45f;
    config.reno_drt_saturation = perChannel ? 1.f : 1.6f;
    config.reno_drt_dechroma = perChannel ? 0.f : 0.8f;
    config.hue_correction_type = perChannel ? renodx::tonemap::config::hue_correction_type::INPUT
                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
    config.hue_correction_strength = perChannel ? 0.f : 1.f;
    config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, injectedData.toneMapHueShift);
    config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
    config.reno_drt_hue_correction_method = (int)injectedData.toneMapHueProcessor;
    config.reno_drt_per_channel = perChannel;
    config.reno_drt_white_clip = 7.25f;
    config.reno_drt_blowout = perChannel ? -0.02f : 0.f;
      if(injectedData.toneMapType == 0.f){
    outputColor = saturate(hueCorrectionColor);
    } else {
    outputColor = untonemapped;
    }
return renodx::tonemap::config::Apply(outputColor, config);
}

float3 InverseToneMapCustom(float3 color) {
  color = renodx::color::srgb::Decode(color);
  float3 untonemapped = vanillaTonemapInverse(color);
  return applyVideoTonemap(untonemapped);
}