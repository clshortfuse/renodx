// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of
// having to manage a wall of code in multiple files

#include "./shared.h"

renodx::tonemap::Config getCommonConfig() {}

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor = untonemapped;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();

  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;

  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_color =
      lerp(outputColor, renodx::tonemap::Reinhard(outputColor),
           injectedData.toneMapHueCorrection);

  outputColor = renodx::tonemap::config::Apply(outputColor, config);

  if (injectedData.toneMapType > 1.f) {
    outputColor = renodx::color::grade::UserColorGrading(
        outputColor,
        1.f,
        1.f,
        1.f,
        1.f,
        injectedData.colorGradeSaturation,
        injectedData.colorGradeBlowout);
  }

  return outputColor;
}

float3 scaleLuminance(float3 color) {
  color *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

  return color;
}

float3 restoreLuminance(float3 color) {
  color /= injectedData.toneMapGameNits / injectedData.toneMapUINits;

  return color;
}

// Incoming color is already adjusted by renoDX
float3 applyLUT(float3 tonemapped, SamplerState lut_sampler,
                Texture2D<float4> lut_texture) {
  float3 outputColor, sdrColor, lutOutput;

  sdrColor = saturate(tonemapped);

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      lut_sampler, injectedData.colorGradeLUTStrength, 0.f,
      renodx::lut::config::type::GAMMA_2_2,
      renodx::lut::config::type::GAMMA_2_2, 32.f);

  lutOutput = renodx::lut::Sample(lut_texture, lut_config, sdrColor);

  outputColor = renodx::tonemap::UpgradeToneMap(
      tonemapped, sdrColor, lutOutput, injectedData.colorGradeLUTStrength);

  return outputColor;
}

// End applyUserTonemap