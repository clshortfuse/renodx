#include "../shared.h"
// from Alias: Isolation by RyanJGray
// github.com/aliasIsolation/aliasIsolation/blob/master/data/shaders/sharpen_ps.hlsl

SamplerState LinearSampler : register(s0);
SamplerState PointSampler : register(s1);

Texture2D<float3> colorTex : register(t0);
Texture2D<float4> logoTex : register(t20);

cbuffer Constants : register(b10) {
  float logoIntensity;
  float sharpenAmount;
  bool sharpenEnabled;
  float pad;
}

#define GAMMA_ENCODE 0

struct PSInput {
  float4 param0 : SV_Position;
  float2 param1 : TEXCOORD0;
  float4 param2 : TEXCOORD1;
};

struct PSOutput {
  float4 param0 : SV_Target0;
  float4 param1 : SV_Target1;
};

/// Fix up sharpening/blurring when done on HDR images in post processing. In SDR, the source color could only be between 0 and 1,
/// so the halos (rings) that can appear around rapidly changing colors were limited, but in HDR lights can go much brighter so the halos got noticeable with default settings.
/// This should work in linear or gamma space.
float3 FixUpSharpeningOrBlurring(float3 postSharpeningColor, float3 preSharpeningColor) {
  // Either set it to 0.5, 0.75 or 1 to make results closer to SDR (this makes more sense when done in gamma space, but also works in linear space).
  // Lower values slightly diminish the effect of sharpening, but further avoid halos issues.
  static const float sharpeningMaxColorDifference = 0.5;
  postSharpeningColor.rgb = clamp(postSharpeningColor.rgb, preSharpeningColor - sharpeningMaxColorDifference, preSharpeningColor + sharpeningMaxColorDifference);
  return postSharpeningColor;
}

PSOutput main(in PSInput IN) {
  PSOutput OUT = (PSOutput)0;

  uint screenWidth, screenHeight;
  colorTex.GetDimensions(screenWidth, screenHeight);
  const float2 texelSize = 1.0.xx / float2(screenWidth, screenHeight);

  float3 center =
      colorTex.SampleLevel(PointSampler, IN.param1 + float2(0, 0) * texelSize, 0).xyz;
  float3 outColor;

  if (sharpenEnabled) {
    float3 neighbors[4] = {
      colorTex.SampleLevel(PointSampler, IN.param1 + float2(1, 1) * texelSize, 0).xyz,
      colorTex.SampleLevel(PointSampler, IN.param1 + float2(-1, 1) * texelSize, 0).xyz,
      colorTex.SampleLevel(PointSampler, IN.param1 + float2(1, -1) * texelSize, 0).xyz,
      colorTex.SampleLevel(PointSampler, IN.param1 + float2(-1, -1) * texelSize, 0).xyz
    };

    float neighborDiff = 0;

    [unroll]
    for (uint i = 0; i < 4; ++i) {
      neighborDiff +=
          renodx::color::y::from::BT709(neighbors[i] - center);  // replace BT.601 luma
    }

    float sharpening = (1 - saturate(2 * neighborDiff)) * sharpenAmount;

    float3 sharpened = float3(
                           0.0.xxx
                           + neighbors[0] * -sharpening
                           + neighbors[1] * -sharpening
                           + neighbors[2] * -sharpening
                           + neighbors[3] * -sharpening
                           + center * 5)
                       * 1.0 / (5.0 + sharpening * -4.0);

    sharpened = FixUpSharpeningOrBlurring(sharpened, center);
    sharpened = min(sharpened, injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE);
#if GAMMA_ENCODE
    outColor = renodx::color::srgb::EncodeSafe(sharpened);
#else
    outColor = sharpened;
#endif
  } else {
#if GAMMA_ENCODE
    outColor = renodx::color::srgb::EncodeSafe(center);
#else
    outColor = center;
#endif
  }

  if (logoIntensity > 0.0) {
    uint logoWidth, logoHeight;
    logoTex.GetDimensions(logoWidth, logoHeight);

    float4 logoColor = logoTex.Sample(
        PointSampler, IN.param0.xy / float2(logoWidth, logoHeight));
    outColor =
        lerp(outColor, logoColor.rgb, 0.75 * logoColor.a * logoIntensity);
  }

  OUT.param0 = float4(outColor, 1.0);

  return OUT;
}
