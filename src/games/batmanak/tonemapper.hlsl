#include "./shared.h"
#include "./uncharted2extended.hlsli"

renodx::lut::Config CreateLUTConfig(SamplerState lut_sampler) {
  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  lut_config.size = 16;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
  lut_config.max_channel = 0.f;
  lut_config.gamut_compress = 0.f;

  return lut_config;
}

float ComputeReinhardSmoothClampScale(float3 untonemapped, float rolloff_start = 0.375f, float output_max = 1.f, float white_clip = 100.f) {
  float peak = renodx::math::Max(untonemapped.r, untonemapped.g, untonemapped.b);
  float mapped_peak = renodx::tonemap::ReinhardPiecewiseExtended(peak, white_clip, output_max, rolloff_start);
  float scale = renodx::math::DivideSafe(mapped_peak, peak, 1.f);

  return scale;
}

float3 applyUserToneMap(float3 untonemapped, Texture2D lut_texture, SamplerState lut_sampler) {
  untonemapped = max(0, untonemapped);
  float3 color_output = untonemapped;

  if (RENODX_TONE_MAP_TYPE >= 3.f) {  // RenoDRT
    const float A = 0.22, B = 0.30, C = 0.10, D = 0.20, E = 0.01, F = 0.30, W = 2.2;

    float coeffs[6] = { A, B, C, D, E, F };
    float white_precompute = 1.f / renodx::tonemap::ApplyCurve(W, A, B, C, D, E, F);
    Uncharted2::Config::Uncharted2ExtendedConfig uc2_config = Uncharted2::Config::CreateUncharted2ExtendedConfig(coeffs, white_precompute);

    if (RENODX_TONE_MAP_PER_CHANNEL == 1.f) {  // per channel
      color_output = Uncharted2::ApplyExtended(untonemapped, uc2_config);
      color_output = renodx::color::correct::Hue(color_output, untonemapped, RENODX_TONE_MAP_HUE_CORRECTION);

      if (CUSTOM_LUT_STRENGTH != 0.f) {
        float scale = ComputeReinhardSmoothClampScale(color_output, 0.4f);

        color_output *= scale;
        color_output = renodx::lut::Sample(lut_texture, CreateLUTConfig(lut_sampler), color_output);
        color_output /= scale;
      }
    } else {  // by luminance
      float3 ch = Uncharted2::ApplyExtended(untonemapped, uc2_config);

      float y_in = renodx::color::y::from::BT709(untonemapped);
      float y_out = Uncharted2::ApplyExtended(y_in, uc2_config);
      float3 lum = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

      if (CUSTOM_LUT_STRENGTH != 0.f) {
        renodx::lut::Config lut_config = CreateLUTConfig(lut_sampler);
        float scale = ComputeReinhardSmoothClampScale(ch);

        ch *= scale;
        ch = renodx::lut::Sample(lut_texture, lut_config, ch);
        ch /= scale;

        scale = ComputeReinhardSmoothClampScale(lum);
        lum *= scale;
        lum = renodx::lut::Sample(lut_texture, lut_config, lum);
        lum /= scale;
      }

      // chrominance correction after lut doesn't artifact
      // see purple lights on hanging rail cars
      color_output = renodx::color::correct::Chrominance(lum, ch);
      color_output = renodx::color::bt709::clamp::AP1(color_output);
    }
  } else {  // ACES/None
    float scale = ComputeReinhardSmoothClampScale(color_output);
    color_output *= scale;
    color_output = renodx::lut::Sample(lut_texture, CreateLUTConfig(lut_sampler), color_output);
    color_output /= scale;
  }

  color_output = renodx::color::gamma::EncodeSafe(color_output, 2.2f);  // Back to LUT output
  color_output = renodx::color::srgb::DecodeSafe(color_output);         // Delinearize as vanilla HDR

  color_output = renodx::draw::ToneMapPass(color_output);

  return color_output;
}
