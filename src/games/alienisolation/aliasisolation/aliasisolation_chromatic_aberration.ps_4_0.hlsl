#include "../shared.h"
// from Alias: Isolation by RyanJGray
// github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/chromaticAberration_ps.hlsl

SamplerState LinearSampler : register(s0);
Texture2D<float3> colorTex : register(t0);

struct PSInput {
  float4 param0 : SV_Position;
  float2 param1 : TEXCOORD0;
};

float4 main(in PSInput IN)
    : SV_Target0 {
  uint screenWidth, screenHeight;
  colorTex.GetDimensions(screenWidth, screenHeight);

  const float2 center_offset = IN.param1 - float2(0.5, 0.5);
  float ca_amount = 0.018f * injectedData.fxChromaticAberration;

  ca_amount *= saturate(length(center_offset) * 2.f);

  const int num_colors = 7;
  const float softness = 0.3f;

  float3 color_sum = float3(0, 0, 0);
  float3 res_sum = float3(0, 0, 0);

  [unroll]
  for (int i = 0; i < num_colors; ++i) {
    const float t = float(i) / float(num_colors - 1);

    const float thresh = softness * 2.f / 3.f + 1.f / 3.f;
    const float3 color =
        lerp(float3(0, 0, 1), float3(0, 0, 0), smoothstep(0, thresh, abs(t - 0.5f / 3.f)))
        + lerp(float3(0, 1, 0), float3(0, 0, 0), smoothstep(0, thresh, abs(t - 1.5f / 3.f)))
        + lerp(float3(1, 0, 0), float3(0, 0, 0), smoothstep(0, thresh, abs(t - 2.5f / 3.f)));

    color_sum += color;

    const float offset = float(i - num_colors * 0.5f) * ca_amount / num_colors;
    const float2 sampleUv = float2(0.5, 0.5) + center_offset * (1.f + offset);
    res_sum += color * colorTex.SampleLevel(LinearSampler, sampleUv, 0);
  }

  return float4(res_sum / color_sum, 1.f);
}
