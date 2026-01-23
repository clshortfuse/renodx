#ifndef SRC_GAMES_BATMANAA_BRIGHTNESS_LIMITER_HLSLI_
#define SRC_GAMES_BATMANAA_BRIGHTNESS_LIMITER_HLSLI_

#include "./shared.h"

static const float ABL_ROLLOFF_START = 0.18f;
static const float ABL_OUTPUT_MAX = 0.6f;
static const float ABL_MIN_SCALE = 0.05f;
static const float ABL_COVERAGE_THRESHOLD = 0.95f;
static const float ABL_MIN_PEAK = 1e-4f;

static const float2 ABL_SAMPLE_UVS[17] = {
    float2(0.5f, 0.5f),
    float2(0.25f, 0.25f),
    float2(0.75f, 0.25f),
    float2(0.25f, 0.75f),
    float2(0.75f, 0.75f),
    float2(0.50f, 0.25f),
    float2(0.50f, 0.75f),
    float2(0.25f, 0.50f),
    float2(0.75f, 0.50f),
    float2(0.10f, 0.10f),
    float2(0.90f, 0.10f),
    float2(0.10f, 0.90f),
    float2(0.90f, 0.90f),
    float2(0.10f, 0.50f),
    float2(0.50f, 0.10f),
    float2(0.50f, 0.90f),
    float2(0.90f, 0.50f)};

float ABL_SampleMaxChannelFromLinear(float3 linearColor) {
  float3 perceptual = renodx::color::gamma::EncodeSafe(linearColor);
  return max(perceptual.x, max(perceptual.y, perceptual.z));
}

float ABL_SampleMaxChannel(sampler2D sceneTexture, float2 uv) {
  return ABL_SampleMaxChannelFromLinear(tex2D(sceneTexture, saturate(uv)).rgb);
}

float ABL_ComputeCoverageMaxChannel(sampler2D sceneTexture) {
  float minChannel = 1.0f;
  [unroll]
  for (int i = 0; i < 17; ++i) {
    float sampleMax = ABL_SampleMaxChannel(sceneTexture, ABL_SAMPLE_UVS[i]);
    minChannel = min(minChannel, sampleMax);
  }
  return minChannel;
}

float ABL_ComputeScale(float sceneMaxChannel) {
  if (sceneMaxChannel <= ABL_ROLLOFF_START) {
    return 1.0f;
  }

  float clampedPeak = max(sceneMaxChannel, ABL_MIN_PEAK);
  float log_peak = log2(clampedPeak);
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(ABL_ROLLOFF_START), log2(ABL_OUTPUT_MAX));
  float compressed_peak = exp2(log_mapped);
  float scale = saturate(compressed_peak / clampedPeak);

  float aggressive_weight = smoothstep(ABL_ROLLOFF_START, 1.0f, sceneMaxChannel);
  scale = lerp(scale, ABL_MIN_SCALE, aggressive_weight * aggressive_weight * aggressive_weight);
  return scale;
}

float ABL_ComputeAutoBrightnessScale(sampler2D sceneTexture, float3 pixelLinearColor) {
  float sceneCoverage = ABL_ComputeCoverageMaxChannel(sceneTexture);
  if (sceneCoverage < ABL_COVERAGE_THRESHOLD) {
    return 1.0f;
  }

  float pixelMax = ABL_SampleMaxChannelFromLinear(pixelLinearColor);
  float combinedMax = min(sceneCoverage, pixelMax);
  return ABL_ComputeScale(combinedMax);
}

float3 ABL_ApplyLimit(sampler2D sceneTexture, float3 tonemapped) {
  float autoBrightnessScale = ABL_ComputeAutoBrightnessScale(sceneTexture, tonemapped);
  if (autoBrightnessScale >= 0.999f) {
    return tonemapped;
  }

  tonemapped *= autoBrightnessScale;
  tonemapped = saturate(tonemapped);

  return tonemapped;
}

#endif  // SRC_GAMES_BATMANAA_BRIGHTNESS_LIMITER_HLSLI_
