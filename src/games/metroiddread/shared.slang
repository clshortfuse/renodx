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

float3 ApplyVanillaPostCurve(float3 color)
{
  float gammaBase = METROID_GAMMA / 2.2;
  float3 curved = renodx::math::PowSafe(color, gammaBase);
  return renodx::color::srgb::DecodeSafe(abs(curved));
}

float3 ApplyColorGrade(float3 color)
{
  renodx::color::grade::Config config = renodx::color::grade::config::Create();
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.blowout = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
  return renodx::color::grade::config::ApplyUserColorGrading(color, config);
}