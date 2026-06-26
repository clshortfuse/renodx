// Original shader 0x6DE32B48: finalCompositing compute pass
// Original code (decompiled): applies Narkowicz ACES tonemap and packs to R10G10B10A2.
//
//   float3 color = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;
//   color = max(0, color);
//   float3 tonemapped = (color * (2.51f * color + 0.03f)) / (color * (2.43f * color + 0.59f) + 0.14f);
//   tonemapped = saturate(tonemapped);
//   uint packed = ((uint)(tonemapped.r * 1023 + 0.5))
//              | (((uint)(tonemapped.g * 1023 + 0.5)) << 10)
//              | (((uint)(tonemapped.b * 1023 + 0.5)) << 20)
//              | (3u << 30);
//   g_Output[dtid.xy] = packed;
//
// Replacement: skip ACES, PQ encode HDR for transport through R10G10B10A2.

#include "./shared.h"

cbuffer cbObjectDynamic : register(b3) {
  float4 cb_data[24];
};

Texture2D<float4> g_AverageLuminance : register(t0);
Texture2D<float4> g_AverageLowLuminance : register(t1);
Texture2D<float4> g_Texture : register(t2);
SamplerState g_Sampler_LinearClamp : register(s1);
RWTexture2D<uint> g_Output : register(u0);

// Narkowicz ACES fit
float3 ACESFitted(float3 v) {
  v = max(0, v);
  return saturate((v * (2.51f * v + 0.03f)) / (v * (2.43f * v + 0.59f) + 0.14f));
}

uint PackR10G10B10A2(float3 color) {
  color = saturate(color);
  uint r = (uint)(color.r * 1023.0f + 0.5f);
  uint g = (uint)(color.g * 1023.0f + 0.5f);
  uint b = (uint)(color.b * 1023.0f + 0.5f);
  uint a = 3;
  return (a << 30) | (b << 20) | (g << 10) | r;
}

[numthreads(8, 8, 1)]
void main(uint3 dtid : SV_DispatchThreadID) {
  uint width, height;
  g_Output.GetDimensions(width, height);
  if (dtid.x >= width || dtid.y >= height) return;

  float2 uv = (float2(dtid.xy) + 0.5f) / float2(width, height);
  float3 color = g_Texture.SampleLevel(g_Sampler_LinearClamp, uv, 0).rgb;
  color = max(0, color);

  // Auto-exposure from original shader
  float avg_lum = g_AverageLuminance.SampleLevel(g_Sampler_LinearClamp, float2(0.5f, 0.5f), 0).r;
  float avg_low_lum = g_AverageLowLuminance.SampleLevel(g_Sampler_LinearClamp, float2(0.5f, 0.5f), 0).r;
  float log_exposure = log(max(cb_data[20].x, 0.001f));
  float range = abs(log(max(avg_lum, 0.0001f)) - log(max(avg_low_lum, 0.0001f))) * cb_data[21].x;
  float exposure_mult = exp(log_exposure * range);
  exposure_mult = clamp(exposure_mult, 0.01f, 100.f);
  color *= exposure_mult;

  if (RENODX_TONE_MAP_TYPE == 0) {
    // Vanilla: apply original ACES
    g_Output[dtid.xy] = PackR10G10B10A2(ACESFitted(color));
  } else {
    // HDR: PQ encode for transport through R10G10B10A2
    float3 pq = renodx::color::pq::EncodeSafe(color, 1.0f);

    // Dither at 10-bit precision
    float2 seed = float2(dtid.xy) * 0.7531f + float2(0.139f, 0.457f);
    float r1 = frac(sin(dot(seed, float2(12.9898f, 78.233f))) * 43758.5453f);
    float r2 = frac(sin(dot(seed + 0.5f, float2(12.9898f, 78.233f))) * 43758.5453f);
    float3 dither = float3(r1 + r2 - 1.0f, 
                           frac(r1 * 3.571f + r2 * 1.113f) + frac(r2 * 2.753f + r1 * 0.987f) - 1.0f,
                           frac(r1 * 7.138f + r2 * 4.567f) + frac(r2 * 5.213f + r1 * 2.331f) - 1.0f);
    pq += dither / 1023.f;

    g_Output[dtid.xy] = PackR10G10B10A2(pq);
  }
}
