#include "./shared.h"

// float3 CustomTonemap(float3 untonemapped, float3 tonemapped_bt709, renodx::lut::Config lut_config, Texture3D lut) {
//   float3 outputColor;
//   if (RENODX_TONE_MAP_TYPE == 0.f) {
//     outputColor = tonemapped_bt709;
//   } else {
//     if (RENODX_TONE_MAP_TYPE >= 1.f && CUSTOM_TONE_MAP_CONFIGURATION == 1.f) {
//       outputColor = renodx::draw::ToneMapPass(
//           untonemapped,
//           renodx::lut::Sample(
//               renodx::tonemap::renodrt::NeutralSDR(untonemapped, true),
//               lut_config,
//               lut));
//       outputColor = renodx::color::correct::Hue(outputColor, tonemapped_bt709, RENODX_TONE_MAP_HUE_CORRECTION, RENODX_TONE_MAP_HUE_PROCESSOR);
//     }
//     else {
//       outputColor = renodx::draw::ToneMapPass(untonemapped, tonemapped_bt709);
//     }
//   }

//   return renodx::draw::RenderIntermediatePass(outputColor);
//   return outputColor;
// }

float3 CustomTonemap(float3 untonemapped, float3 tonemapped_bt709) {
  float3 outputColor;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = tonemapped_bt709;
  } 
  else {
    outputColor = renodx::draw::ToneMapPass(untonemapped, tonemapped_bt709);
  }

  //return renodx::draw::RenderIntermediatePass(outputColor);
  return outputColor;
}

float3 HDRSaturate(float3 value) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return saturate(value);
  }
  value = max(0, value);
  value = min(RENODX_PEAK_WHITE_NITS, value);
  // value = renodx::tonemap::renodrt::NeutralSDR(value);
  return value;
}