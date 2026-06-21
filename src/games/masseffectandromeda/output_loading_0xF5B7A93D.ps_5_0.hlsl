#include "./shared.h"
#include "./loading_core.hlsli"

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);

SamplerState sceneSampler : register(s0);
SamplerState uiSampler : register(s2);

cbuffer cbData : register(b0) {
  float4 cbData[3] : packoffset(c0);
}

struct PSInput {
  float4 position : SV_Position;
  float2 texcoord : TEXCOORD;
};

// Loading/video present (1:1). Art (t0) is sRGB-encoded (no 1D LUT); tail is the shared
// LoadingPresentScene. Without it the vanilla pass PQ-encodes the art at ~1500 nits.
float4 main(PSInput input) : SV_Target {
  float4 scene = sceneTexture.SampleLevel(sceneSampler, input.texcoord, 0.f);
  return LoadingPresentScene(scene, input.texcoord, cbData[2], uiTexture, uiSampler);
}
