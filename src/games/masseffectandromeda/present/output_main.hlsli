// Main HDR present row (1:1, single tap). Requires shared.h + linearize.hlsli + lilium_rcas.hlsli +
// present_core.hlsli first. outputLut (t2) linearizes the PQ graded buffer to scene-linear.
// Output gamut is runtime-selected by the game (BT.2020 / DCI-P3 / no-matrix). Every per-hash wrapper
// over this row normalizes to the forced HDR10/BT.2020 swapchain, so they all share this body unchanged.

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);
Texture1D<float4> outputLut : register(t2);

SamplerState sceneSampler : register(s0);
SamplerState lutSampler : register(s1);
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
  return PresentScene(scene, input.texcoord, cbData[2],
                      sceneTexture, sceneSampler, uiTexture, uiSampler, outputLut, lutSampler,
                      false);  // 1:1: scene == output res, RCAS active
}
