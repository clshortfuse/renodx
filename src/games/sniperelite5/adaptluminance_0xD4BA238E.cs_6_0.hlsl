#include "./shared.h"

Texture2D<float4> g_xTexture : register(t0);

RWTexture2D<uint> g_xHistogramUAV : register(u0);

RWTexture2D<float> g_xOutputUAV : register(u1);

cbuffer AdaptionConstants : register(b1) {
  float m_fAdaptionFactor : packoffset(c000.x);
};

groupshared uint g_auHistogramEntry[256];

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  g_auHistogramEntry[SV_GroupIndex] = g_xHistogramUAV.Load(int2(SV_GroupIndex, 0));
  g_xHistogramUAV[int2(SV_GroupIndex, 0)] = 0;
  GroupMemoryBarrierWithGroupSync();

  [branch]
  if (SV_GroupIndex == 0) {
    float total = 0.0f;
    for (uint i = 0; i < 256; i++) {
      total += (float)g_auHistogramEntry[i];
    }
    // RenoDX: drop fractions of the histogram at both ends
    float low_cut = total * CUSTOM_AUTO_EXPOSURE_IGNORE_DARK;
    float high_cut = total * (1.0f - CUSTOM_AUTO_EXPOSURE_IGNORE_BRIGHT);

    float running = 0.0f;
    float sum_w = 0.0f;
    float sum_lin = 0.0f;
    float sum_log = 0.0f;
    for (uint j = 0; j < 256; j++) {
      float count = (float)g_auHistogramEntry[j];
      float end = running + count;
      // RenoDX: count only the part of this bin inside the kept range
      float kept = max(0.0f, min(end, high_cut) - max(running, low_cut));
      running = end;
      float log_l = (float)j * 0.05476778373122215f + -8.965784072875977f;
      sum_w += kept;
      sum_lin += exp2(log_l) * kept;
      sum_log += log_l * kept;
    }

    // RenoDX: 1 = log-average, 0 = vanilla linear average
    // RenoDX: the game's exposure curve expects an arithmetic mean; x2 brings the log-average back to that scale
    float mean = (CUSTOM_AUTO_EXPOSURE_METERING == 1.f) ? 2.f * exp2(sum_log / max(1.0f, sum_w)) : sum_lin / max(1.0f, sum_w);
    // RenoDX: speed 1 keeps the vanilla factor, other values scale the per-frame rate
    float factor = (CUSTOM_AUTO_EXPOSURE_SPEED == 1.f) ? m_fAdaptionFactor : 1.0f - pow(max(1.0f - saturate(m_fAdaptionFactor), 1e-6f), CUSTOM_AUTO_EXPOSURE_SPEED);

    float prev = g_xTexture.Load(int3(0, 0, 0)).x;
    float adapted = ((mean - prev) * factor) + prev;
    g_xOutputUAV[int2(0, 0)] = min(max(adapted, 0.02f), 16.0f);
  }
}
