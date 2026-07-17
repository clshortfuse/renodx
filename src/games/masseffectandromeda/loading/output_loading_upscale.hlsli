// Upscaling loading/video present row (Resolution Scale != 100%): 16-tap bicubic fetch of the
// sRGB-encoded art (resample-then-decode, matching vanilla; LoadingPresentScene does the decode).
// Binding quirk: s1 = scene taps, s2 = UI, no s0/LUT. cbData[0].xy = source res, .zw = texel.
// Requires shared.h + loading_core.hlsli + bicubic_upscale.hlsli first.
// Output gamut is runtime-selected by the game (BT.2020 / DCI-P3 / no-matrix). Every per-hash wrapper
// over this row normalizes to the forced HDR10/BT.2020 swapchain, so they all share this body unchanged.

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
  // Alpha = 1, matching the vanilla upscale present (no scene alpha carried).
  float4 scene = float4(SampleSceneBicubic(sceneTexture, sceneSampler, input.texcoord, cbData[0]), 1.f);
  return LoadingPresentScene(scene, input.texcoord, cbData[2], uiTexture, uiSampler);
}
