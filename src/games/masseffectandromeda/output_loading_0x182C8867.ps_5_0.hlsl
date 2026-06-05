#include "./shared.h"
#include "./loading_core.hlsli"

// Loading/video present permutation (1:1, single tap). Same as 0xF5B7A93D — sRGB-encoded art (no 1D
// LUT), shared LoadingPresentScene tail — but binds the scene sampler on s1 instead of s0.

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);

SamplerState sceneSampler : register(s1);  // scene (s1 here, not s0)
SamplerState uiSampler : register(s2);

cbuffer cbData : register(b0) {
  float4 cbData[3] : packoffset(c0);
}

struct PSInput {
  float4 position : SV_Position;
  float2 texcoord : TEXCOORD;
};

float4 main(PSInput input) : SV_Target {
  float4 scene = sceneTexture.SampleLevel(sceneSampler, input.texcoord, 0.f);
  return LoadingPresentScene(scene, input.texcoord, cbData[2], uiTexture, uiSampler);
}
