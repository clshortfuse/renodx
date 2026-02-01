#include "./shared.h"

float3 Unclamp(float3 original_gamma, float3 black_gamma, float3 mid_gray_gamma, float3 neutral_gamma) {
  const float3 added_gamma = black_gamma;

  const float mid_gray_average = (mid_gray_gamma.r + mid_gray_gamma.g + mid_gray_gamma.b) / 3.f;

  // Remove from 0 to mid-gray
  const float shadow_length = mid_gray_average;
  const float shadow_stop = max(neutral_gamma.r, max(neutral_gamma.g, neutral_gamma.b));
  const float3 floor_remove = added_gamma * max(0, shadow_length - shadow_stop) / shadow_length;

  const float3 unclamped_gamma = max(0, original_gamma - floor_remove);
  return unclamped_gamma;
}

float3 ApplyExposureContrastFlareHighlightsShadowsByLuminance(float3 untonemapped, float y, renodx::color::grade::Config config, float mid_gray = 0.18f) {
  if (config.exposure == 1.f && config.shadows == 1.f && config.highlights == 1.f && config.contrast == 1.f && config.flare == 0.f) {
    return untonemapped;
  }
  float3 color = untonemapped;

  color *= config.exposure;

  const float y_normalized = y / mid_gray;
  const float highlight_mask = 1.f / mid_gray;
  const float shadow_mask = mid_gray;

  // contrast & flare
  float flare = renodx::math::DivideSafe(y_normalized + config.flare, y_normalized, 1.f);
  float exponent = config.contrast * flare;
  const float y_contrasted = pow(y_normalized, exponent);

  // highlights
  float y_highlighted = pow(y_contrasted, config.highlights);
  y_highlighted = lerp(y_contrasted, y_highlighted, saturate(y_contrasted / highlight_mask));

  // shadows
  float y_shadowed = pow(y_highlighted, -1.f * (config.shadows - 2.f));
  y_shadowed = lerp(y_shadowed, y_highlighted, saturate(y_highlighted / shadow_mask));

  const float y_final = y_shadowed * mid_gray;

  color *= (y > 0 ? (y_final / y) : 0);

  return color;
}

float3 ApplySaturationBlowoutHueCorrectionHighlightSaturation(float3 tonemapped, float y, renodx::color::grade::Config config) {
  float3 color = tonemapped;
  if (config.saturation != 1.f || config.dechroma != 0.f || config.blowout != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(color);

    if (config.dechroma != 0.f) {
      perceptual_new.yz *= lerp(1.f, 0.f, saturate(pow(y / (10000.f / 100.f), (1.f - config.dechroma))));
    }

    if (config.blowout != 0.f) {
      float percent_max = saturate(y * 100.f / 10000.f);
      // positive = 1 to 0, negative = 1 to 2
      float blowout_strength = 100.f;
      float blowout_change = pow(1.f - percent_max, blowout_strength * abs(config.blowout));
      if (config.blowout < 0) {
        blowout_change = (2.f - blowout_change);
      }

      perceptual_new.yz *= blowout_change;
    }

    perceptual_new.yz *= config.saturation;

    color = renodx::color::bt709::from::OkLab(perceptual_new);

    color = renodx::color::bt709::clamp::AP1(color);
  }
  return color;
}

float3 SampleScaledLUT(Texture3D<float4> lut, renodx::lut::Config lut_config, float3 color) {
  float3 linear_input_color = color;

  color = renodx::lut::Sample(lut, lut_config, linear_input_color);
  if (!RENODX_TONE_MAP_TYPE) {
    return color;
  }

  float3 lutOutputLinear = color;

  if (CUSTOM_LUT_SCALING != 0.f) {
    float3 lut_black = 0.f;
    float3 lut_mid_gray = 0.18f;
    float3 lut_white = 1.f;
    lut_black = renodx::lut::Sample(lut, lut_config, lut_black);
    lut_mid_gray = renodx::lut::Sample(lut, lut_config, lut_mid_gray);
    lut_white = renodx::lut::Sample(lut, lut_config, lut_white);

    float3 output_gamma = lutOutputLinear;
    float3 black_gamma = lut_black;
    float3 midgray_gamma = lut_mid_gray;
    float3 peak_gamma = lut_white;
    float3 input_gamma = linear_input_color;

    float mid_gray = renodx::color::y::from::BT709(lut_mid_gray);
    float peak = renodx::color::y::from::BT709(lut_white);

    // linear to gamma
    output_gamma = renodx::color::srgb::EncodeSafe(lutOutputLinear);
    black_gamma = renodx::color::srgb::EncodeSafe(lut_black);
    midgray_gamma = renodx::color::srgb::EncodeSafe(lut_mid_gray);
    peak_gamma = 1.f;
    input_gamma = renodx::color::srgb::EncodeSafe(linear_input_color);

    float3 unclamped_gamma = renodx::lut::Unclamp(
        output_gamma,
        black_gamma,
        midgray_gamma,
        peak_gamma,
        input_gamma);

    float3 recolored = renodx::lut::RecolorUnclamped(
        color,
        renodx::color::srgb::DecodeSafe(unclamped_gamma));

    color = lerp(color, recolored, CUSTOM_LUT_SCALING);
  }
  color = lerp(linear_input_color, color, CUSTOM_LUT_STRENGTH);
  return color;
}

float3 SampleHDRLUT(float3 untonemapped, SamplerState sampleLinear_s, Texture3D<float4> g_tHdrLut) {
  float3 color = untonemapped;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = sampleLinear_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = 0.f;
  lut_config.precompute = 32.f;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::ARRI_C1000;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.recolor = 0.f;
  // if (RENODX_TONE_MAP_TYPE) {
  //   color = renodx::tonemap::neutwo::MaxChannel(color);
  // }

  color = SampleScaledLUT(g_tHdrLut, lut_config, color);
  return color;
}

float3 SampleSDRLUT(float3 lut_input_color, SamplerState sampleLinear_s, Texture3D<float4> g_tLdrLut) {
  float3 color = lut_input_color;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = sampleLinear_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = 0.f;
  lut_config.precompute = 32.f;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.recolor = 0.f;

  if (RENODX_TONE_MAP_TYPE) {
    color = renodx::tonemap::neutwo::BT709(color);
  }

  color = SampleScaledLUT(g_tLdrLut, lut_config, color);
  return color;
}

// SDR path
float4 ProcessColor(float3 untonemapped, float3 graded) {
  float4 color;
  color.rgb = graded;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    color.rgb = renodx::tonemap::UpgradeToneMap(untonemapped, renodx::tonemap::neutwo::MaxChannel(untonemapped), color.rgb, 1);
  }

  color.rgb = renodx::draw::RenderIntermediatePass(color.rgb);
  color.a = 1.f;

  return color;
}

float4 ProcessColor(float4 color) {
  color.rgb = renodx::tonemap::neutwo::BT709(color.rgb, RENODX_PEAK_NITS / RENODX_DIFFUSE_WHITE_NITS, RENODX_RENO_DRT_WHITE_CLIP);
  color.rgb = renodx::draw::RenderIntermediatePass(color.rgb);
  color.a = 1.f;

  return color;
}

/// Rational curve used in case 4 of Nioh LUT builder.
#define NIOHCURVE_GENERATOR(T)                                                        \
  T ApplyNiohCurve(T x, float A = 30.9882221, float B = 1.19912136,                   \
                   float C = 32.667881, float D = 9.87056255, float E = 8.97784805) { \
    return (x * (A * x + B)) / (x * (C * x + D) + E);                                 \
  }

NIOHCURVE_GENERATOR(float)
NIOHCURVE_GENERATOR(float3)
#undef NIOHCURVE_GENERATOR

// d/dx((A*x*x + B*x) / (C*x*x + D*x + E))
float NiohDerivative(float x, float A, float B, float C, float D, float E) {
  float denom = C * x * x + D * x + E;
  float num = (A * D - B * C) * x * x + (2.f * A * E) * x + (B * E);
  return num / (denom * denom);
}

static const float kInflectionPoint = 0.267011;

#define APPLYNIOHEXTENDED_GENERATOR(T)                                   \
  T ApplyNiohExtended(                                                   \
      T x, T base, float A = 30.9882221, float B = 1.19912136,           \
      float C = 32.667881, float D = 9.87056255, float E = 8.97784805) { \
    float pivot_x = kInflectionPoint;                                    \
                                                                         \
    float pivot_y = ApplyNiohCurve(pivot_x, A, B, C, D, E);              \
                                                                         \
    float slope = NiohDerivative(pivot_x, A, B, C, D, E);                \
                                                                         \
    /* Line passing through (pivot_x, pivot_y) with matching slope */    \
    T offset = pivot_y - slope * pivot_x;                                \
    T extended = slope * x + offset;                                     \
                                                                         \
    return lerp(base, extended, step(pivot_x, x));                       \
  }

APPLYNIOHEXTENDED_GENERATOR(float)
APPLYNIOHEXTENDED_GENERATOR(float3)
#undef APPLYNIOHEXTENDED_GENERATOR