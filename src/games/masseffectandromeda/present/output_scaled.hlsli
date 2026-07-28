// HDR present rows whose scene is smaller than the output. Four vanilla rows share this body and
// differ only in how t0 is fetched (a filter-cost ladder of 1 / 4 / 4 / 16 taps); the tail after the
// fetch is identical in all of them, which is why one parameterized body covers the lot. All of them
// pass isUpscale = true.
// Binding quirk: s1 = scene taps AND output LUT, s2 = UI, no s0 (that is the 1:1 main row).
// cbData[0].xy = source res px, .zw = texel size.
// Requires shared.h + linearize.hlsli + lilium_rcas.hlsli + present_core.hlsli first, plus the
// header supplying the selected filter: bicubic_upscale.hlsli (filters 1-2) or
// bspline_upscale.hlsli (filter 3).

#ifndef MEA_PRESENT_FILTER
// 0 = single bilinear tap (Post Process Quality = Low)   2 = 4-tap Keys cubic, Y only
// 1 = 16-tap separable Keys cubic                        3 = 4-bilinear-tap cubic B-spline
#define MEA_PRESENT_FILTER 0
#endif

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);
Texture1D<float4> outputLut : register(t2);

SamplerState sceneLutSampler : register(s1);  // scene taps + output LUT
SamplerState uiSampler : register(s2);

cbuffer cbData : register(b0) {
  float4 cbData[3] : packoffset(c0);
}

struct PSInput {
  float4 position : SV_Position;
  float2 texcoord : TEXCOORD;
};

float4 main(PSInput input) : SV_Target {
  // A row carries the fetched scene alpha iff its fetch reads four components; the cardinal-cubic
  // rows read RGB only and emit 1.0, matching vanilla.
#if MEA_PRESENT_FILTER == 0
  float4 scene = sceneTexture.SampleLevel(sceneLutSampler, input.texcoord, 0.f);
#elif MEA_PRESENT_FILTER == 1
  float4 scene = float4(SampleSceneBicubic(sceneTexture, sceneLutSampler, input.texcoord, cbData[0]), 1.f);
#elif MEA_PRESENT_FILTER == 2
  float4 scene = float4(SampleSceneCubicY(sceneTexture, sceneLutSampler, input.texcoord, cbData[0]), 1.f);
#elif MEA_PRESENT_FILTER == 3
  float4 scene = SampleSceneFastBSpline(sceneTexture, sceneLutSampler, input.texcoord, cbData[0]);
#else
#error "MEA_PRESENT_FILTER must be 0 (1:1), 1 (Keys-16), 2 (Keys-Y4) or 3 (B-spline)."
#endif
  return PresentScene(scene, input.texcoord, cbData[2],
                      sceneTexture, sceneLutSampler, uiTexture, uiSampler, outputLut, sceneLutSampler,
                      true);
}
