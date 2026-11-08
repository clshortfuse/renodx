#ifndef RENODX_RE6_BLOOM_HLSLI_
#define RENODX_RE6_BLOOM_HLSLI_

#include "./color_grade.hlsli"

float3 ExtractGameBloom(float3 color, float threshold, float peak_relative_to_white) {
  float maximum = max(color.r, max(color.g, color.b));
  float excess = max(maximum - threshold, 0.f);
  float amount = min(excess, 1.f);
  float headroom = peak_relative_to_white - 1.f;
  if (headroom > 0.f && excess > 1.f) {
    // Join the native curve at its old ceiling with a slope of one.
    amount += headroom * (1.f - exp(-(excess - 1.f) / max(headroom, 1.e-6f)));
  }
  // The original blur shaders decode sRGB before filtering.
  return EncodeGameSRGB(color * (amount / max(maximum, 1.e-6f)));
}

#endif
