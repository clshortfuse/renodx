#include "../shared.h"

// Faithful Frostbite scene tonemap+grade pass (VS 0xCD03DB44), shared by all twelve perms.
// Builds linear scene -> *0.01 -> ST.2084 PQ -> 33^3 LUT (PQ space), as vanilla. Parametrized by:
//   MEA_TONEMAP_CA          0 = distortion-offset warp; 1 = chromatic aberration (per-channel split on cb0[12])
//   MEA_TONEMAP_DISTORTION  1 = radial lens warp on cb0[4] applied to the base UV
//   MEA_TONEMAP_T4          t4 role: 0 = unused; 1 = additive film grain (cb0[1]); 2 = RGBA overlay
//                           composited over the graded output (scanner/screen effects)
// Vanilla+ user controls (neutral at vanilla): fxBloom, colorGradeExposure, fxVignette, fxChromaticAberration.

#ifndef MEA_TONEMAP_CA
#define MEA_TONEMAP_CA 0
#endif
#ifndef MEA_TONEMAP_DISTORTION
#define MEA_TONEMAP_DISTORTION 0
#endif
#ifndef MEA_TONEMAP_T4
#define MEA_TONEMAP_T4 0
#endif

Texture2D<float4> sceneTexture : register(t0);
Texture3D<float4> colorGradingTexture : register(t1);
Texture2D<float4> distortionTexture : register(t2);
Texture2D<float4> bloomTexture : register(t3);
#if MEA_TONEMAP_T4 == 1
Texture2D<float4> noiseTexture : register(t4);
#elif MEA_TONEMAP_T4 == 2
Texture2D<float4> overlayTexture : register(t4);
#endif

SamplerState sceneSampler : register(s0);
SamplerState colorGradingSampler : register(s1);
SamplerState distortionSampler : register(s2);
SamplerState bloomSampler : register(s3);
#if MEA_TONEMAP_T4 == 1
SamplerState noiseSampler : register(s4);
#elif MEA_TONEMAP_T4 == 2
SamplerState overlaySampler : register(s4);
#endif

cbuffer cbData : register(b0) {
  float4 cbData[14] : packoffset(c0);
}

struct PSInput {
  float4 position : SV_Position;
  float4 texcoord0 : TEXCOORD0;
  float2 texcoord : TEXCOORD1;
};

struct PSOutput {
  float4 color : SV_Target0;
  float luma : SV_Target1;
};

// Vignette, blended toward 1.0 (no darkening) by the user Vignette control in Vanilla+ (1.0 = vanilla).
// Always evaluated at the original (unwarped) UV.
float ApplyVignette(float2 uv) {
  float2 vignette_uv = (uv - 0.5f) * cbData[10].xy;
  float vignette = dot(vignette_uv, vignette_uv);
  vignette = saturate(1.f - vignette * cbData[11].w);
  vignette = exp(log(max(vignette, 0.000001f)) * cbData[10].z);
  const bool full = IsVanillaPlus();
  // max() guards the >50 range: lerp extrapolates past 1.0 and could drive corners to a negative multiplier.
  return full ? max(0.f, lerp(1.f, vignette, injectedData.fxVignette)) : vignette;
}

#if MEA_TONEMAP_DISTORTION
// Radial lens warp (cb0[4]): quadratic branch when cb0[4].y ~ 0, cubic otherwise. Replaces the
// original UV as the base the distortion-offset chain starts from; vignette keeps the original UV.
float2 ApplyRadialWarp(float2 uv) {
  float2 centered = uv - 0.5f;
  float r2 = dot(centered, centered);
  float scale;
  if (abs(cbData[4].y) < 0.0001f) {
    scale = (r2 * cbData[4].x + 1.f) * cbData[4].z;
  } else {
    float k = cbData[4].y * sqrt(r2) + cbData[4].x;
    scale = (r2 * k + 1.f) * cbData[4].w;
  }
  return centered * scale + 0.5f;
}
#endif

// Scene composite (warp / chromatic aberration + bloom + exposure + vignette) -> linear HDR.
// scene_uv returns the distorted UV the scene was fetched at (t4 overlay samples there too).
float3 ApplyScenePost(float2 uv, out float2 scene_uv) {
  float3 distortion = distortionTexture.Sample(distortionSampler, uv).xyz;

#if MEA_TONEMAP_DISTORTION
  const float2 base = ApplyRadialWarp(uv);
#else
  const float2 base = uv;
#endif

  // Vanilla mode applies nothing; Vanilla+ applies the user effect controls.
  const bool full = IsVanillaPlus();

#if MEA_TONEMAP_CA
  // Chromatic aberration (port of 0xEB91AB31): split the base distorted UV per channel by cb0[12]
  // (0.5 = no split). Red at cb0[12].xy, green at .zw, blue keeps base UV + the dist.z bloom blend.
  float2 base_uv = distortion.xy * cbData[13].xy + cbData[13].zw + base;
  scene_uv = base_uv;
  float scene_b = sceneTexture.Sample(sceneSampler, base_uv).z;
  float3 bloom = bloomTexture.Sample(bloomSampler, base_uv).xyz;
  // User Chromatic Aberration control (Vanilla+): lerp the per-channel split toward 0.5 (no split).
  const float caScale = full ? injectedData.fxChromaticAberration : 1.f;
  float2 caXY = lerp(0.5f, cbData[12].xy, caScale);
  float2 caZW = lerp(0.5f, cbData[12].zw, caScale);
  float2 red_uv = (base_uv - 0.5f) * 2.f * caXY + 0.5f;
  float2 green_uv = (base_uv - 0.5f) * 2.f * caZW + 0.5f;
  float blend_b = distortion.z * (bloom.z - scene_b) + scene_b;
  float scene_r = sceneTexture.Sample(sceneSampler, red_uv).x;
  float scene_g = sceneTexture.Sample(sceneSampler, green_uv).y;
  float3 color = float3(scene_r, scene_g, blend_b);
#else
  // Single-sample warp (0xB6A91712): scene/bloom lerp by distortion.z.
  float2 distorted_uv = distortion.xy * cbData[13].xy + cbData[13].zw + base;
  scene_uv = distorted_uv;
  float3 scene = sceneTexture.Sample(sceneSampler, distorted_uv).rgb;
  float3 bloom = bloomTexture.Sample(bloomSampler, distorted_uv).rgb;
  float3 color = lerp(scene, bloom, distortion.z);
#endif

  const float bloomScale = full ? injectedData.fxBloom : 1.f;
  const float expScale = full ? injectedData.colorGradeExposure : 1.f;

  // Additive bloom glow (1.0 = vanilla).
  color = bloom * cbData[8].xyz * bloomScale + color;
  // Pre-tonemap exposure / grade scale (cb0[5]) (1.0 = vanilla).
  color *= cbData[5].xyz * expScale;
  color *= ApplyVignette(uv);
  return color;
}

// PQ-encode the linear scene (1.0 == 100 nits) and sample the native 33^3 grade LUT (PQ space).
// Vanilla+ optionally uses tetrahedral interpolation (higher quality, less banding) on the same LUT;
// vanilla / Trilinear keep the game's hardware-trilinear sample with the 32/33 texel-center bias.
float3 SampleNativeGrade(float3 color) {
  float3 pq_color = renodx::color::pq::EncodeSafe(color, 100.f);
  if (IsVanillaPlus() && injectedData.customLutTetrahedral == 1.f) {
    // Tetrahedral takes the pre-scale/bias coordinate; it centers and reads the size (33) internally.
    return renodx::lut::SampleTetrahedral(colorGradingTexture, pq_color, 0.f);
  }
  pq_color = pq_color * 0.96969697f + 0.01515152f;
  return colorGradingTexture.Sample(colorGradingSampler, pq_color).rgb;
}

PSOutput main(PSInput input) {
  PSOutput output;

  float2 scene_uv;
  float3 linear_scene = ApplyScenePost(input.texcoord, scene_uv);
  float3 graded = SampleNativeGrade(linear_scene);

#if MEA_TONEMAP_T4 == 1
  // Vanilla film grain (additive, post-LUT). Kept in native modes and Vanilla+ Film Grain = Vanilla;
  // Luminance / Per-Channel skip it here and apply perceptual grain in the present pass instead.
  if (!IsVanillaPlus() || injectedData.fxFilmGrainType == FILM_GRAIN_VANILLA) {
    float2 noise_uv = input.texcoord * cbData[2].xy + cbData[2].zw;
    float noise = noiseTexture.Sample(noiseSampler, noise_uv).x;
    graded += (noise - 0.5f) * cbData[1].xyz;
  }
#endif

  // Vanilla writes the luma target before the overlay composite (grain, when present, is included).
  float luma = dot(graded, float3(0.299f, 0.587f, 0.114f));

#if MEA_TONEMAP_T4 == 2
  // Gameplay overlay (scanner/screen effects), sampled at the scene's distorted UV and alpha-
  // composited over the graded output. Not gated by any Vanilla+ control.
  float4 overlay = overlayTexture.Sample(overlaySampler, scene_uv);
  graded = graded * (1.f - overlay.a) + overlay.rgb;
#endif

  output.color.rgb = graded;
  output.color.a = 1.f;
  output.luma = luma;

  return output;
}
