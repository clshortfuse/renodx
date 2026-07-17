// Post Process Quality = Low HDR present row (single bilinear-upscale tap). Tail is byte-identical to
// the main row's, but the scene is smaller than the output, so RCAS is skipped (isUpscale = true).
// Binding quirk (like the upscale row): s1 = scene + LUT sampler, s2 = UI, no s0.
// Requires shared.h + linearize.hlsli + lilium_rcas.hlsli + present_core.hlsli first.
// Output gamut is runtime-selected by the game (BT.2020 / DCI-P3 / no-matrix). Every per-hash wrapper
// over this row normalizes to the forced HDR10/BT.2020 swapchain, so they all share this body unchanged.

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
