#include "../shared.h"
// from Alias: Isolation by RyanJGray
// github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/sharpen_ps.hlsl

SamplerState LinearSampler : register(s0);
SamplerState PointSampler : register(s1);

Texture2D<float3> colorTex : register(t0);

struct PSInput {
  float4 param0 : SV_Position;
  float2 param1 : TEXCOORD0;
};

float4 main(in PSInput IN) : SV_Target0 {
  uint screenWidth, screenHeight;
  colorTex.GetDimensions(screenWidth, screenHeight);
  const float2 texelSize = 1.0.xx / float2(screenWidth, screenHeight);

  const float3 center = renodx::color::srgb::DecodeSafe(colorTex.SampleLevel(PointSampler, IN.param1, 0).xyz);
  float3 outColor;

  if (injectedData.fxSharpening > 0.f) {
    float3 neighbors[4] = {
        renodx::color::srgb::DecodeSafe(colorTex.SampleLevel(PointSampler, IN.param1 + float2(1, 1) * texelSize, 0).xyz),
        renodx::color::srgb::DecodeSafe(colorTex.SampleLevel(PointSampler, IN.param1 + float2(-1, 1) * texelSize, 0).xyz),
        renodx::color::srgb::DecodeSafe(colorTex.SampleLevel(PointSampler, IN.param1 + float2(1, -1) * texelSize, 0).xyz),
        renodx::color::srgb::DecodeSafe(colorTex.SampleLevel(PointSampler, IN.param1 + float2(-1, -1) * texelSize, 0).xyz),
    };

    float neighborDiff = 0.f;

    [unroll]
    for (uint i = 0; i < 4; ++i) {
      neighborDiff += renodx::color::y::from::BT709(neighbors[i] - center);
    }

    const float sharpening = (1.f - saturate(2.f * neighborDiff)) * injectedData.fxSharpening;

    const float3 sharpened = (neighbors[0] * -sharpening
                              + neighbors[1] * -sharpening
                              + neighbors[2] * -sharpening
                              + neighbors[3] * -sharpening
                              + center * 5.f)
                             / (5.f - sharpening * 4.f);

    outColor = renodx::color::srgb::EncodeSafe(sharpened);
  } else {
    outColor = renodx::color::srgb::EncodeSafe(center);
  }

  return float4(outColor, 1.f);
}
