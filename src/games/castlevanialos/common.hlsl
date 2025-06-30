#include "./shared.h"

float3 CustomTonemap(float3 untonemapped, float3 sdr_color, float2 texcords) {
  //if (IS_TONEMAPPED == 1.f) { return renodx::color::srgb::EncodeSafe(untonemapped);}

  float3 outputColor;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = sdr_color;
  } 
  else {
    outputColor = renodx::draw::ToneMapPass(untonemapped);
    //outputColor = renodx::draw::ToneMapPass(untonemapped, sdr_color);
  }

  outputColor = renodx::effects::ApplyFilmGrain(
      outputColor,
      texcords,
      CUSTOM_RANDOM,
      CUSTOM_FILM_GRAIN_STRENGTH * 0.03f);

  return renodx::draw::RenderIntermediatePass(outputColor);
}

float3 AutoHDRVideo(float3 sdr_video) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return sdr_video;
  }
  float3 hdr_video = renodx::draw::UpscaleVideoPass(saturate(sdr_video));
  hdr_video = renodx::color::srgb::DecodeSafe(hdr_video);
  return renodx::draw::RenderIntermediatePass(hdr_video);
}