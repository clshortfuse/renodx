#include "./shared.h"

static const float3x3 sRGB_2_AP0 = float3x3(
    0.4397010, 0.3829780, 0.1773350,
    0.0897923, 0.8134230, 0.0967616,
    0.0175440, 0.1115440, 0.8707040);

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  // color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

float3 SRGB_2_BT709(float3 color) {
  color = mul(sRGB_2_AP0, color);
  color = mul(renodx::color::AP0_TO_AP1_MAT, color);

  color = renodx::color::bt709::from::AP1(color);

  return color;
}

/// Vanilla sdr is in AP1
/// untonemapped is using sRGB primaries (or they used the wrong matrix which is likely)
float3 UpgradeTonemap(float3 untonemapped, float3 vanillaSDR) {
  float3 outputColor = vanillaSDR;

  if (RENODX_TONE_MAP_TYPE) {
    const float ACES_MID_GRAY = 0.10f;
    const float ACES_MIN = 0.0001f;
    float aces_min = ACES_MIN / RENODX_DIFFUSE_WHITE_NITS;
    float aces_max = (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    aces_max = renodx::color::correct::Gamma(aces_max, true);
    aces_min = renodx::color::correct::Gamma(aces_min, true);

    untonemapped = renodx::tonemap::aces::RRTAndODT(untonemapped, aces_min * 48.f, aces_max * 48.f) / 48.f;
    // untonemapped = renodx::color::bt709::from::AP1(untonemapped);
    vanillaSDR = renodx::color::bt709::from::AP1(vanillaSDR);

    outputColor = renodx::draw::UpgradeToneMapByLuminance(untonemapped, ToneMapMaxCLL(untonemapped), ToneMapMaxCLL(vanillaSDR), 1.f);

    // Mimic them and return AP1?
    outputColor = renodx::color::ap1::from::BT709(outputColor);
  }

  return outputColor;
}

float3 ApplyUserTonemap(float3 untonemapped) {
  float3 outputColor = untonemapped;

  if (RENODX_TONE_MAP_TYPE) {
    outputColor = renodx::draw::ToneMapPass(untonemapped);
  }

  return outputColor;
}

// Incoming color is already adjusted by renoDX
float3 ApplyLUT(float3 tonemapped, Texture2D<float4> lut_texture, SamplerState lut_sampler, float strength) {
  float3 outputColor = tonemapped;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = lut_sampler;
  lut_config.size = 32u;
  lut_config.tetrahedral = true;
  lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  lut_config.scaling = 0.f;
  lut_config.strength = strength;

  outputColor = renodx::lut::Sample(saturate(outputColor), lut_config, lut_texture);

  // outputColor *= 1.05f; // Matching vanilla

  outputColor = renodx::tonemap::UpgradeToneMap(
      tonemapped, ToneMapMaxCLL(tonemapped), ToneMapMaxCLL(outputColor), 1.f);

  return outputColor;
}
