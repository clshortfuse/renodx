#include "./present_core.hlsli"
#include "../bicubic_upscale.hlsli"
#include "../bspline_upscale.hlsli"

// The one HDR present body: all 30 vanilla present rows that end in HDR10 PQ compile from this
// file. Everything after the scene fetch is identical in all of them, which is why one
// parameterized body covers the lot. Both upscale front-ends are included unconditionally and fxc
// drops whichever entry points the selected filter does not call.
// All three axes are required - a defaulted axis ships a wrong-but-compiling shader, and none of
// the wrongness is visible at build time:
//   MEA_PRESENT_LUT3D   1 = row applies the vanilla 32^3 calibration LUT at t5. Declared and
//                       enforced in linearize.hlsli, which owns the t5 declaration.
//   MEA_PRESENT_SCALED  0 = scene buffer is already output res, 1 = smaller than output. Fixes the
//                       sampler layout AND RCAS eligibility; the two cannot desync because they
//                       read the same macro.
//   MEA_PRESENT_FILTER  how t0 is fetched - a cost ladder of 1 / 16 / 4 / 4 taps:
//                       0 = single bilinear tap (1:1, or Post Process Quality = Low)
//                       1 = 16-tap separable Keys cubic     bicubic_upscale.hlsli
//                       2 = 4-tap Keys cubic, Y only        bicubic_upscale.hlsli
//                       3 = 4-bilinear-tap cubic B-spline   bspline_upscale.hlsli
// cbData[0].xy = source res px, .zw = texel size (filters 1-3 only).

#ifndef MEA_PRESENT_SCALED
#error "Define MEA_PRESENT_SCALED (0 = scene is output res, 1 = scene is smaller) before including output_present.hlsli."
#endif
#ifndef MEA_PRESENT_FILTER
#error "Define MEA_PRESENT_FILTER (0 single tap, 1 Keys-16, 2 Keys-Y4, 3 B-spline) before including output_present.hlsli."
#endif
#if !MEA_PRESENT_SCALED && MEA_PRESENT_FILTER != 0
#error "A 1:1 row has nothing to resample: MEA_PRESENT_SCALED 0 requires MEA_PRESENT_FILTER 0."
#endif

Texture2D<float4> sceneTexture : register(t0);
Texture2D<float4> uiTexture : register(t1);
Texture1D<float4> outputLut : register(t2);

// The sampler layout is dictated by the vanilla shaders, not chosen: the 1:1 row is handed a
// dedicated scene sampler at s0, while the scaled rows bind nothing at s0 and let s1 filter the
// scene taps as well as the 1D output LUT. Declared register-ascending purely for readability -
// measured, fxc emits dcl_sampler in register order regardless of source order because every
// sampler here carries an explicit register(sN) (it would be load-bearing if they were
// auto-assigned). The alias below is the ONLY legal way to express "the scaled rows' scene taps
// come from the LUT sampler": declaring a second SamplerState at s1 instead fails with
// "error X4500: overlapping register semantics not yet implemented 's1'". MEA_SCENE_SAMPLER is
// prefixed rather than aliasing "sceneSampler", which is also a PresentScene parameter name - a
// #define of that name would rewrite the parameter.
#if !MEA_PRESENT_SCALED
SamplerState sceneSampler : register(s0);
#define MEA_SCENE_SAMPLER sceneSampler
#else
#define MEA_SCENE_SAMPLER lutSampler
#endif
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
  // A row carries the fetched scene alpha iff its fetch reads four components; the cardinal-cubic
  // rows read RGB only and emit 1.0, matching vanilla.
#if MEA_PRESENT_FILTER == 0
  float4 scene = sceneTexture.SampleLevel(MEA_SCENE_SAMPLER, input.texcoord, 0.f);
#elif MEA_PRESENT_FILTER == 1
  float4 scene = float4(SampleSceneBicubic(sceneTexture, MEA_SCENE_SAMPLER, input.texcoord, cbData[0]), 1.f);
#elif MEA_PRESENT_FILTER == 2
  float4 scene = float4(SampleSceneCubicY(sceneTexture, MEA_SCENE_SAMPLER, input.texcoord, cbData[0]), 1.f);
#elif MEA_PRESENT_FILTER == 3
  float4 scene = SampleSceneFastBSpline(sceneTexture, MEA_SCENE_SAMPLER, input.texcoord, cbData[0]);
#else
#error "MEA_PRESENT_FILTER must be 0 (single tap), 1 (Keys-16), 2 (Keys-Y4) or 3 (B-spline)."
#endif
  // Compile-time literal: fxc folds the RCAS gate out entirely (see present_core.hlsli).
  return PresentScene(scene, input.texcoord, cbData[2],
                      sceneTexture, MEA_SCENE_SAMPLER, uiTexture, uiSampler, outputLut, lutSampler,
                      MEA_PRESENT_SCALED != 0);
}
