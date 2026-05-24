#include "./shared.h"
#include "./macleod_boynton.hlsli"

static const float kHueTransferChromaStart = 0.02;
static const float kHueTransferChromaEnd = 0.12;

float ComputeHueTransferStrength(float3 donor) {
  float donor_max = renodx::math::Max(donor);
  float donor_min = renodx::math::Min(donor);
  float donor_chroma = renodx::math::DivideSafe(donor_max - donor_min, donor_max, 0.f);
  return smoothstep(kHueTransferChromaStart, kHueTransferChromaEnd, donor_chroma);
}

float3 MetroidCorrect(float3 colour, float3 reference) {
  return CorrectHueAndPurityMBBT709WithBT2020(colour, reference, ComputeHueTransferStrength(colour) * 0.15f, 0.4f);
}