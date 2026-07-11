#include "./shared.h"
#include "./lilium_rcas.hlsli"
#include "./present_core.hlsli"
#include "./bicubic_upscale.hlsli"

// Upscaling HDR present (Resolution Scale < 100%; game swaps 0xF5B0DBFA -> this). Like 0xF5B0DBFA but
// the scene is a 16-tap bicubic fetch; tail is the shared PresentScene.
// Binding quirk: s1 = scene taps AND LUT, s2 = UI, no s0. cbData[0].xy = source res, .zw = texel (1/res).

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);
Texture1D<float4> outputLut : register(t2);

SamplerState sceneLutSampler : register(s1);  // scene bicubic taps + output LUT
SamplerState uiSampler : register(s2);

cbuffer cbData : register(b0) {
  float4 cbData[3] : packoffset(c0);
}

struct PSInput {
  float4 position : SV_Position;
  float2 texcoord : TEXCOORD;
};

float4 main(PSInput input) : SV_Target {
  // Bicubic-upscaled scene (alpha = 1, matching the vanilla upscale present which doesn't carry scene alpha).
  float4 scene = float4(SampleSceneBicubic(sceneTexture, sceneLutSampler, input.texcoord, cbData[0]), 1.f);
  return PresentScene(scene, input.texcoord, cbData[2],
                      sceneTexture, sceneLutSampler, uiTexture, uiSampler, outputLut, sceneLutSampler,
                      true);  // upscale: bicubic center, RCAS skipped (asymmetric neighborhood)
}
