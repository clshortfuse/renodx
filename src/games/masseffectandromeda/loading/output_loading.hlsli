#include "./loading_core.hlsli"
#include "../bicubic_upscale.hlsli"

// Loading/video present row. Art (t0) is sRGB-encoded (no 1D LUT); tail is the shared
// LoadingPresentScene. Without it the vanilla pass PQ-encodes the art at ~1500 nits.
// bicubic_upscale.hlsli is pulled in unconditionally; fxc drops it on the non-upscale rows.
// Both axes are required - 6 of the 9 rows are s1, so a default would be wrong more often than
// right, and binding the scene sampler to a slot the scaled rows leave unbound is invisible at
// build time:
//   MEA_LOADING_SCENE_SAMPLER  scene sampler slot, s0 or s1. A register token, not a number: it can
//                              be #ifndef-checked but never #if-compared, so a valid-but-wrong slot
//                              is caught only by comparing the emitted decls against vanilla.
//   MEA_LOADING_FILTER         how t0 is fetched, on the same rung scale as MEA_PRESENT_FILTER so the
//                              two families read cognate: 0 = single bilinear tap, 1 = 16-tap Keys
//                              cubic (Resolution Scale != 100%) - resample-then-decode, matching
//                              vanilla; cbData[0].xy = source res, .zw = texel.
#ifndef MEA_LOADING_SCENE_SAMPLER
#error "Define MEA_LOADING_SCENE_SAMPLER (s0 or s1) before including output_loading.hlsli."
#endif
#ifndef MEA_LOADING_FILTER
#error "Define MEA_LOADING_FILTER (0 = single bilinear tap, 1 = 16-tap Keys cubic) before including output_loading.hlsli."
#endif
// Only rungs 0 and 1 are reachable here. Rungs 2 (Keys-Y4) and 3 (B-spline) exist in the present
// family only - the game ships no Y-cubic or B-spline loading row, verified against its full shader
// dump - so accepting them would just widen the space of plausible-looking wrong rows.
#if MEA_LOADING_FILTER != 0 && MEA_LOADING_FILTER != 1
#error "MEA_LOADING_FILTER must be 0 (single tap) or 1 (Keys-16); rungs 2 and 3 are present-family only."
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
#if MEA_LOADING_FILTER == 1
  // Alpha = 1, matching the vanilla upscale present (no scene alpha carried).
  float4 scene = float4(SampleSceneBicubic(sceneTexture, sceneSampler, input.texcoord, cbData[0]), 1.f);
#else
  float4 scene = sceneTexture.SampleLevel(sceneSampler, input.texcoord, 0.f);
#endif
  return LoadingPresentScene(scene, input.texcoord, cbData[2], uiTexture, uiSampler);
}
