// Loading/video present row (1:1, single tap). Art (t0) is sRGB-encoded (no 1D LUT); tail is the
// shared LoadingPresentScene. Without it the vanilla pass PQ-encodes the art at ~1500 nits.
// The scene sampler slot is the MEA_LOADING_SCENE_SAMPLER axis (default s0; the s1 perms override).
// Requires shared.h + loading_core.hlsli first.
// Output gamut is runtime-selected by the game (BT.2020 / DCI-P3 / no-matrix). Every per-hash wrapper
// over this row normalizes to the forced HDR10/BT.2020 swapchain, so they all share this body unchanged.

#ifndef MEA_LOADING_SCENE_SAMPLER
#define MEA_LOADING_SCENE_SAMPLER s0
#endif

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);

SamplerState sceneSampler : register(MEA_LOADING_SCENE_SAMPLER);
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
