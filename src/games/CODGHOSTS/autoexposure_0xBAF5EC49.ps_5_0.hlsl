// Call of Duty: Ghosts
// Human-readable auto-exposure adaptation shader with RenoDX slider control.
//
// What this shader does:
// - Reads the scene-average luminance from t4.
// - Converts it into a target exposure using cb2[7].z.
// - Reads the previously adapted exposure from t0.
// - Moves the previous exposure toward the target exposure by a limited amount.
// - The RenoDX slider scales that per-frame movement limit.
//
// Slider behavior:
//   100% = exact original game adaptation speed.
//    35% = calmer / less reactive adaptation.
//     0% = freeze exposure adaptation.

#include "./shared.h"

Texture2D<float4> t4 : register(t4);  // Average luminance source.
Texture2D<float4> t0 : register(t0);  // Previous exposure history.

SamplerState s4_s : register(s4);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[9];
}

static const float MIN_AVERAGE_LUMINANCE = 1.0e-4f;

float SampleAverageLuminance()
{
  float averageLuminance = t4.Sample(s4_s, float2(0.5f, 0.5f)).x;
  return max(MIN_AVERAGE_LUMINANCE, averageLuminance);
}

float SamplePreviousExposure(float2 uv)
{
  return t0.Sample(s0_s, uv).x;
}

float ComputeTargetExposure(float averageLuminance)
{
  return cb2[7].z / averageLuminance;
}

float ApplyAdaptationStep(float previousExposure, float targetExposure)
{
  float adaptationSpeed = saturate(RENODX_GHOSTS_AUTO_EXPOSURE_ADAPTATION_SPEED);

  // Original game limits for how much exposure can change this frame.
  float maxIncreasePerFrame = cb2[8].y * cb2[8].z;
  float maxDecreasePerFrame = cb2[8].x * cb2[8].z;

  // RenoDX slider scales both directions equally.
  maxIncreasePerFrame *= adaptationSpeed;
  maxDecreasePerFrame *= adaptationSpeed;

  float exposureDelta = targetExposure - previousExposure;

  if (exposureDelta > 0.0f)
  {
    exposureDelta = min(exposureDelta, maxIncreasePerFrame);
  }
  else
  {
    exposureDelta = max(exposureDelta, -maxDecreasePerFrame);
  }

  float newExposure = previousExposure + exposureDelta;

  // Preserve the original game min/max exposure clamps.
  newExposure = min(cb2[7].y, newExposure);
  newExposure = max(cb2[7].x, newExposure);

  return newExposure;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float averageLuminance = SampleAverageLuminance();
  float previousExposure = SamplePreviousExposure(v1.xy);
  float targetExposure = ComputeTargetExposure(averageLuminance);
  float newExposure = ApplyAdaptationStep(previousExposure, targetExposure);

  o0 = newExposure.xxxx;
}
