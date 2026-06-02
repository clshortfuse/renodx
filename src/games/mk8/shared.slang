#include "./shared.h"
#include "./macleod_boynton.hlsli"

float3 ColourCorrect(float3 colour, float3 reference) {
  float3 corrected = renodx::color::correct::ChrominanceOKLab(colour, reference, RENODX_TONE_MAP_BLOWOUT);
  return renodx::color::correct::HueOKLab(corrected, reference, RENODX_COLOR_GRADE_STRENGTH);
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

float3 DisplayMap(float3 color, bool ui = false)
{
  float peakRatio = RENODX_PEAK_WHITE_NITS / (ui ? RENODX_GRAPHICS_WHITE_NITS : RENODX_DIFFUSE_WHITE_NITS);
  [branch]
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    peakRatio = renodx::color::correct::Gamma(
        peakRatio,
        true,
        renodx::math::Select(RENODX_GAMMA_CORRECTION == 1.f, 2.2f, 2.4f));
  }

  return renodx::tonemap::neutwo::PerChannel(color, peakRatio);
}
