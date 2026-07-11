#include "./shared.h"
#include "./loading_core.hlsli"
#include "./bicubic_upscale.hlsli"

// Upscaling loading/video present (Resolution Scale != 100%; game swaps 0xF5B7A93D -> this). Like
// 0xF5B7A93D but the sRGB art is a 16-tap bicubic fetch; tail is the shared LoadingPresentScene.
// Binding quirk: s1 = scene taps, s2 = UI, no s0/LUT. cbData[0].xy = source res, .zw = texel (1/res).

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);

SamplerState sceneSampler : register(s1);  // scene bicubic taps
SamplerState uiSampler : register(s2);

cbuffer cbData : register(b0) {
  float4 cbData[3] : packoffset(c0);
}

struct PSInput {
  float4 position : SV_Position;
  float2 texcoord : TEXCOORD;
};

float4 main(PSInput input) : SV_Target {
  // Bicubic-upscale the sRGB-encoded art (resample-then-decode, matching vanilla); LoadingPresentScene
  // does the sRGB decode. Alpha = 1, matching the vanilla upscale present (no scene alpha carried).
  float4 scene = float4(SampleSceneBicubic(sceneTexture, sceneSampler, input.texcoord, cbData[0]), 1.f);
  return LoadingPresentScene(scene, input.texcoord, cbData[2], uiTexture, uiSampler);
}
