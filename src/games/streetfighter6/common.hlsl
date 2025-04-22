#include "./shared.h"

float3 Tonemap(float3 untonemapped, float3 graded) {
  float3 color = graded;
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    color = renodx::draw::ToneMapPass(untonemapped, color);
  }

  color = renodx::draw::RenderIntermediatePass(color);
  return color;
}

float3 FinalOutput(float3 final_image) {
  final_image = renodx::draw::SwapChainPass(final_image);
  final_image = renodx::color::correct::GammaSafe(final_image);
  return final_image;
}
