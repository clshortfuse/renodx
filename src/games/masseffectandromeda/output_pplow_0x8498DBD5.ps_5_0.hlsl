#include "./shared.h"
#include "./lilium_rcas.hlsli"
#include "./present_core.hlsli"

// HDR present permutation used at Post Process Quality = Low (the game swaps 0xF5B0DBFA -> this).
// Tail is byte-identical to 0xF5B0DBFA's (scene -> scale -> 1D LUT linearize -> UI composite ->
// 709->2020 -> PQ), but it single-taps the scene with a bilinear upscale rather than 1:1.
// Binding quirk (like 0xAFFFA4AB): s1 = scene + LUT sampler, s2 = UI, no s0.
// isUpscale = true: the scene is smaller than the output (bilinear upscale), so RCAS is skipped.

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);
Texture1D<float4> outputLut : register(t2);

SamplerState sceneLutSampler : register(s1);  // scene tap + output LUT
SamplerState uiSampler : register(s2);

cbuffer cbData : register(b0) {
  float4 cbData[3] : packoffset(c0);
}

struct PSInput {
  float4 position : SV_Position;
  float2 texcoord : TEXCOORD;
};

float4 main(PSInput input) : SV_Target {
  float4 scene = sceneTexture.SampleLevel(sceneLutSampler, input.texcoord, 0.f);
  return PresentScene(scene, input.texcoord, cbData[2],
                      sceneTexture, sceneLutSampler, uiTexture, uiSampler, outputLut, sceneLutSampler,
                      true);  // scene != output (bilinear upscale) -> RCAS skipped
}
