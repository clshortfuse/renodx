#include "./shared.h"

float3 ExponentialRollOffByLum(float3 color, float output_luminance_max, float highlights_shoulder_start = 0.f) {
  const float source_luminance = renodx::color::y::from::BT709(color);

  [branch]
  if (source_luminance > 0.0f) {
    const float compressed_luminance = renodx::tonemap::ExponentialRollOff(source_luminance, highlights_shoulder_start, output_luminance_max);
    color *= compressed_luminance / source_luminance;
  }

  return color;
}

float3 ApplyExponentialRollOff(float3 color) {
  const float paperWhite = RENODX_DIFFUSE_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  const float peakWhite = RENODX_PEAK_WHITE_NITS / renodx::color::srgb::REFERENCE_WHITE;

  // const float highlightsShoulderStart = paperWhite;
  const float highlightsShoulderStart = 1.f;

  [branch]
  if (RENODX_TONE_MAP_PER_CHANNEL == 0.f) {
    return ExponentialRollOffByLum(color * paperWhite, peakWhite, highlightsShoulderStart) / paperWhite;
  } else {
    return renodx::tonemap::ExponentialRollOff(color * paperWhite, highlightsShoulderStart, peakWhite) / paperWhite;
  }
}

float3 ToneMap(float3 untonemapped, float3 tonemapped_bt709, SamplerState lutSampler, Texture2D lutTexture, float3 preCompute) {
  float3 outputColor;

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    renodx::lut::Config lut_config = renodx::lut::config::Create();
    lut_config.lut_sampler = lutSampler;
    lut_config.strength = 1.f;
    lut_config.scaling = 0.f;
    lut_config.precompute = preCompute;
    lut_config.tetrahedral = true;
    lut_config.type_input = renodx::lut::config::type::ARRI_C1000_NO_CUT;
    lut_config.type_output = renodx::lut::config::type::LINEAR;

    untonemapped = max(0.00001f, untonemapped); // fixes black squares in somnia

    outputColor = renodx::tonemap::UpgradeToneMap(
      untonemapped,
      renodx::tonemap::renodrt::NeutralSDR(untonemapped),
      renodx::lut::Sample(
        renodx::tonemap::dice::BT709(untonemapped, 1.0f, 0.25f),  // better than RenoDRT NeutralSDR
        lut_config,
        lutTexture),
      1.f
    );

    [branch]
    if (RENODX_TONE_MAP_TYPE == 6.f) {
      renodx::draw::Config draw_config = renodx::draw::BuildConfig();
      draw_config.peak_white_nits = 10000.f;
      draw_config.tone_map_type = 3.f;
      draw_config.tone_map_per_channel = 0.f;

      outputColor = renodx::draw::ToneMapPass(outputColor, draw_config);

      outputColor = ApplyExponentialRollOff(outputColor);
    } else {
      outputColor = renodx::draw::ToneMapPass(outputColor);
    }
  } else {
    outputColor = saturate(tonemapped_bt709);
  }

  outputColor = renodx::draw::RenderIntermediatePass(outputColor);

  return outputColor;
}