#include "./shared.h"

cbuffer cbObjectDynamic : register(b3) {
  float4 cb_data[24];
};

Texture2D<float4> g_AverageLuminance : register(t0);
Texture2D<float4> g_AverageLowLuminance : register(t1);
Texture2D<float4> g_Texture : register(t2);
Texture2D<float4> g_WeightsRO : register(t3);
SamplerState g_Sampler_LinearClamp : register(s1);
RWTexture2D<uint> g_Output : register(u0);

// PQ (ST.2084) encode
// max_nits controls the range: values up to max_nits map to [0,1] in PQ space
float3 PQEncode(float3 linear_color, float max_nits) {
  // Normalize to [0,1] where 1.0 = max_nits
  float3 L = saturate(linear_color / max_nits);

  const float m1 = 0.1593017578125f;
  const float m2 = 78.84375f;
  const float c1 = 0.8359375f;
  const float c2 = 18.8515625f;
  const float c3 = 18.6875f;

  float3 Lm1 = pow(L, m1);
  float3 numerator = c1 + c2 * Lm1;
  float3 denominator = 1.0f + c3 * Lm1;
  return pow(numerator / denominator, m2);
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

  if (shader_injection.tone_map_type == 0) {
    // Vanilla: apply ACES tonemap
    float3 tonemapped = (color * (2.51f * color + 0.03f)) / (color * (2.43f * color + 0.59f) + 0.14f);
    g_Output[dtid.xy] = PackR10G10B10A2(saturate(tonemapped));
  } else {
    // HDR: PQ encode with range matching peak nits setting
    // Use 25.0 as max linear value (covers typical HDR scene range)
    float3 encoded = PQEncode(color, 25.0f);
    g_Output[dtid.xy] = PackR10G10B10A2(encoded);
  }
}
