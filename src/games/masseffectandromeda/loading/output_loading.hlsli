// Loading/video present row. Art (t0) is sRGB-encoded (no 1D LUT); tail is the shared
// LoadingPresentScene. Without it the vanilla pass PQ-encodes the art at ~1500 nits.
// Axes (per-hash wrappers override):
//   MEA_LOADING_SCENE_SAMPLER  scene sampler slot (default s0; the s1 perms override)
//   MEA_LOADING_BICUBIC        1 = 16-tap bicubic fetch (Resolution Scale != 100%): resample-then-
//                              decode, matching vanilla; requires bicubic_upscale.hlsli first,
//                              cbData[0].xy = source res, .zw = texel
// Requires shared.h + loading_core.hlsli first.
// Per-gamut wrapper hashes share this body unchanged: see FinalizeToPQ in shared.h.

#ifndef MEA_LOADING_SCENE_SAMPLER
#define MEA_LOADING_SCENE_SAMPLER s0
#endif
#ifndef MEA_LOADING_BICUBIC
#define MEA_LOADING_BICUBIC 0
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
#if MEA_LOADING_BICUBIC
  // Alpha = 1, matching the vanilla upscale present (no scene alpha carried).
  float4 scene = float4(SampleSceneBicubic(sceneTexture, sceneSampler, input.texcoord, cbData[0]), 1.f);
#else
  float4 scene = sceneTexture.SampleLevel(sceneSampler, input.texcoord, 0.f);
#endif
  return LoadingPresentScene(scene, input.texcoord, cbData[2], uiTexture, uiSampler);
}
