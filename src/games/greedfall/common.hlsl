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

float gammaCorrectPeak(float peak) {
  if (injectedData.toneMapGammaCorrection == 0.f) {
   return renodx::color::gamma::Decode(renodx::color::srgb::Encode(peak / injectedData.toneMapGameNits), 2.2f) * injectedData.toneMapGameNits;
  } else if (injectedData.toneMapGammaCorrection == 2.f) {
    return renodx::color::gamma::Decode(renodx::color::gamma::Encode(peak / injectedData.toneMapGameNits, 2.4), 2.2f) * injectedData.toneMapGameNits;
 } else {
   return peak;
 }
}