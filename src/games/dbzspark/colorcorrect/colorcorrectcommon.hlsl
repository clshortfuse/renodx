#include "../shared.h"

// clang-format off
static struct ColorCorrectBuilderConfig {
  float3 hdr_linear;
  float3 sdr_in;
  float3 sdr_out;
} CC_CONFIG;
// clang-format on

/// Applies Exponential Roll-Off tonemapping using the maximum channel.
/// Used to fit the color into a 0–output_max range for SDR LUT compatibility.
float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.5f, float output_max = 1.f) {
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

void InverIntermediateToSRGB(inout float3 color) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  color = renodx::draw::InvertIntermediatePass(color);
  CC_CONFIG.hdr_linear = color;
  color = saturate(color);
  CC_CONFIG.sdr_in = color;
  color = renodx::color::srgb::EncodeSafe(color);
}

void RenderIntermediateFromSRGB(inout float3 color, bool force = false) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  color = renodx::color::srgb::DecodeSafe(color);
  CC_CONFIG.sdr_out = color;
  if (RENODX_TONE_MAP_TYPE == 4.f) {
    color = CC_CONFIG.sdr_out;
  } else {
    float sdr_y_in = renodx::color::y::from::BT709(abs(CC_CONFIG.sdr_in));
    float sdr_y_out = renodx::color::y::from::BT709(abs(CC_CONFIG.sdr_out));

    color = CC_CONFIG.hdr_linear;

    color = renodx::color::correct::Luminance(color, sdr_y_in, sdr_y_out, 1.f);

    uint processor = 1u;

    color = renodx::color::correct::Hue(renodx::color::bt709::clamp::BT709(color), CC_CONFIG.sdr_out, 0.55f, processor);  // Any higher results in AP0 colors
    // color = renodx::color::correct::Chrominance(color, CC_CONFIG.sdr_out, 0.9f, processor);                               // Any higher results in AP0 colors
  }
  color = renodx::draw::RenderIntermediatePass(color);
}
