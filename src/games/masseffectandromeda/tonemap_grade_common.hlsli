#include "./shared.h"

// Faithful Frostbite scene tonemap+grade pass (VS 0xCD03DB44), shared by all four {CA, grain} perms.
// Builds linear scene -> *0.01 -> ST.2084 PQ -> 33^3 LUT (PQ space), as vanilla. Parametrized by:
//   MEA_TONEMAP_CA     0 = distortion warp (0xB6A91712 / 0x376C116B); 1 = chromatic aberration (0xEB91AB31 / 0xE3D57A10)
//   MEA_TONEMAP_GRAIN  0 = no noise (grain-off); 1 = vanilla grain on t4 (grain-on)
// Vanilla+ user controls (neutral at vanilla): fxBloom, colorGradeExposure, fxVignette, fxChromaticAberration.

#ifndef MEA_TONEMAP_CA
#define MEA_TONEMAP_CA 0
#endif
#ifndef MEA_TONEMAP_GRAIN
#define MEA_TONEMAP_GRAIN 0
#endif

Texture2D<float4> sceneTexture : register(t0);
Texture3D<float4> colorGradingTexture : register(t1);
Texture2D<float4> distortionTexture : register(t2);
Texture2D<float4> bloomTexture : register(t3);
#if MEA_TONEMAP_GRAIN
Texture2D<float4> noiseTexture : register(t4);
#endif

SamplerState sceneSampler : register(s0);
SamplerState colorGradingSampler : register(s1);
SamplerState distortionSampler : register(s2);
SamplerState bloomSampler : register(s3);
#if MEA_TONEMAP_GRAIN
SamplerState noiseSampler : register(s4);
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
float ApplyVignette(float2 uv) {
  float2 vignette_uv = (uv - 0.5f) * cbData[10].xy;
  float vignette = dot(vignette_uv, vignette_uv);
  vignette = saturate(1.f - vignette * cbData[11].w);
  vignette = exp(log(max(vignette, 0.000001f)) * cbData[10].z);
  const bool full = IsVanillaPlus();
  // max() guards the >50 range: lerp extrapolates past 1.0 and could drive corners to a negative multiplier.
  return full ? max(0.f, lerp(1.f, vignette, injectedData.fxVignette)) : vignette;
}

// Scene composite (distortion warp / chromatic aberration + bloom + exposure + vignette) -> linear HDR.
float3 ApplyScenePost(float2 uv) {
  float3 distortion = distortionTexture.Sample(distortionSampler, uv).xyz;

  // Vanilla mode applies nothing; Vanilla+ applies the user effect controls.
  const bool full = IsVanillaPlus();

#if MEA_TONEMAP_CA
  // Chromatic aberration (port of 0xEB91AB31): split the base distorted UV per channel by cb0[12]
  // (0.5 = no split). Red at cb0[12].xy, green at .zw, blue keeps base UV + the dist.z bloom blend.
  float2 base_uv = distortion.xy * cbData[13].xy + cbData[13].zw + uv;
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
  // Single-sample distortion warp (0xB6A91712): scene/bloom lerp by distortion.z.
  float2 distorted_uv = distortion.xy * cbData[13].xy + cbData[13].zw + uv;
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
float3 SampleNativeGrade(float3 color) {
  float3 pq_color = renodx::color::pq::EncodeSafe(color, 100.f);
  pq_color = pq_color * 0.96969697f + 0.01515152f;
  return colorGradingTexture.Sample(colorGradingSampler, pq_color).rgb;
}

PSOutput main(PSInput input) {
  PSOutput output;

  float3 linear_scene = ApplyScenePost(input.texcoord);
  float3 graded = SampleNativeGrade(linear_scene);

#if MEA_TONEMAP_GRAIN
  // Vanilla film grain (additive, post-LUT). Kept in native modes and Vanilla+ Film Grain = Vanilla;
  // Luminance / Per-Channel skip it here and apply perceptual grain in the present pass instead.
  if (!IsVanillaPlus() || injectedData.fxFilmGrainType == FILM_GRAIN_VANILLA) {
    float2 noise_uv = input.texcoord * cbData[2].xy + cbData[2].zw;
    float noise = noiseTexture.Sample(noiseSampler, noise_uv).x;
    graded += (noise - 0.5f) * cbData[1].xyz;
  }
#endif

  output.color.rgb = graded;
  output.color.a = 1.f;
  output.luma = dot(graded, float3(0.299f, 0.587f, 0.114f));

  return output;
}
