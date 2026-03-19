#ifndef COMMON_HLSLI
#define COMMON_HLSLI

#include "./shared.h"

void ScaleVideo(inout float r, inout float g, inout float b) {
  float3 color = float3(r, g, b);
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color = renodx::color::correct::GammaSafe(color);
  }

  color *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;

  if (RENODX_GAMMA_CORRECTION != 0.f) {
    color = renodx::color::correct::GammaSafe(color, true);
  }
  r = color.r, g = color.g, b = color.b;
  return;
}

float3 PQFromBT709(float3 color_bt709, float cbuffer_PQ_M1, float cbuffer_diffuse_white) {
  float3 color_pq;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float _90 = exp2(log2(abs(mad(0.04331306740641594f, color_bt709.z, mad(0.3292830288410187f, color_bt709.y, (color_bt709.x * 0.6274039149284363f))) * cbuffer_diffuse_white)) * cbuffer_PQ_M1);
    float _91 = exp2(log2(abs(mad(0.011362316086888313f, color_bt709.z, mad(0.9195404052734375f, color_bt709.y, (color_bt709.x * 0.06909728795289993f))) * cbuffer_diffuse_white)) * cbuffer_PQ_M1);
    float _92 = exp2(log2(abs(mad(0.8955952525138855f, color_bt709.z, mad(0.08801330626010895f, color_bt709.y, (color_bt709.x * 0.016391439363360405f))) * cbuffer_diffuse_white)) * cbuffer_PQ_M1);
    color_pq.r = exp2(log2(abs(((_90 * 18.8515625f) + 0.8359375f) / ((_90 * 18.6875f) + 1.0f))) * 78.84375f);
    color_pq.g = exp2(log2(abs(((_91 * 18.8515625f) + 0.8359375f) / ((_91 * 18.6875f) + 1.0f))) * 78.84375f);
    color_pq.b = exp2(log2(abs(((_92 * 18.8515625f) + 0.8359375f) / ((_92 * 18.6875f) + 1.0f))) * 78.84375f);
  } else {
    float3 color_bt2020 = renodx::color::bt2020::from::BT709(color_bt709);

    color_pq = renodx::color::pq::EncodeSafe(color_bt2020, RENODX_GRAPHICS_WHITE_NITS);
  }
  return color_pq;
}

void PQFromBT709(float color_bt709_r, float color_bt709_g, float color_bt709_b,
                 float cbuffer_PQ_M1, float cbuffer_diffuse_white,
                 inout float color_pq_r, inout float color_pq_g, inout float color_pq_b) {
  float3 color_pq = PQFromBT709(float3(color_bt709_r, color_bt709_g, color_bt709_b), cbuffer_PQ_M1, cbuffer_diffuse_white);
  color_pq_r = color_pq.r, color_pq_g = color_pq.g, color_pq_b = color_pq.b;

  return;
}

void PQFromBT709FinalWithGammaCorrection(float color_bt709_r, float color_bt709_g, float color_bt709_b,
                                         float cbuffer_PQ_M1, float cbuffer_diffuse_white,
                                         inout float color_pq_r, inout float color_pq_g, inout float color_pq_b) {
  float3 color_bt709 = float3(color_bt709_r, color_bt709_g, color_bt709_b);
  color_bt709 = renodx::color::bt709::clamp::AP1(color_bt709);
  
  if (RENODX_GAMMA_CORRECTION != 0.f && RENODX_TONE_MAP_TYPE != 0.f) color_bt709 = renodx::color::correct::GammaSafe(color_bt709);

  float3 color_pq = PQFromBT709(color_bt709, cbuffer_PQ_M1, cbuffer_diffuse_white);
  color_pq_r = color_pq.r, color_pq_g = color_pq.g, color_pq_b = color_pq.b;

  return;
}

#endif  // COMMON_HLSLI