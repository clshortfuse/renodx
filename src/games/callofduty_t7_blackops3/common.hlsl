#include "./shared.h"

#define SDR_NOMRALIZATION_MAX 32768.0
// #define SDR_NOMRALIZATION_TRADEOFF 0.15 //TODO to reshade var instead?

/*
* in: linear
* out: srgb accounting for SDR_NOMRALIZATION_MAX
* 
* this is goofy. we have to make a tradeoff for max luminance to render fullscreen shaders.
* TODO extend LUT past 32768 instead?
*/
float3 AfterTonemapToFullscreenShadersTradeoff(float3 color) {
  if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 0.f) {
    color.rgb = renodx::color::srgb::EncodeSafe(color.rgb);
  } else if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 1.f) {
    color.rgb = renodx::color::gamma::EncodeSafe(color.rgb, 2.2);
  } else {
    color.rgb = renodx::color::gamma::EncodeSafe(color.rgb, 2.4);
  }

  color *= (SDR_NOMRALIZATION_MAX * CUSTOM_TRADEOFF_RATIO);

  return color;
}

/*
* in: srgb
* out: linear accounting for SDR_NOMRALIZATION_MAX
*/
float3 AfterFullscreenShaderBeforeUiTradeoff(float3 color) {
  color.rgb /= (SDR_NOMRALIZATION_MAX * CUSTOM_TRADEOFF_RATIO);

  if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 0.f) {
    color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  } else if (CUSTOM_FULLSCREEN_SHADER_GAMMA == 1.f) {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.2);
  } else {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb, 2.4);
  }

  return color;
}

float3 ScaleTonemappedTo01(float3 color) {
  color.rgb /= SDR_NOMRALIZATION_MAX;
  return color;
}

float3 AddBloom(float3 color, float3 bloom) {
  color += bloom * 0.0015 * CUSTOM_BLOOM;
  return color;
}

float3 ScaleBloomAfterSaturate(float3 color) {
  color.rgb *= CUSTOM_BLOOM;
  return color;
}