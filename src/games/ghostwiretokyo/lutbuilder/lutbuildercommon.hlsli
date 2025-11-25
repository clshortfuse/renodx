#include "../common.hlsli"

float3 GammaCorrectHuePreserving(float3 incorrect_color) {
  float3 result = renodx::color::correct::GammaSafe(incorrect_color);
  result = renodx::color::correct::Hue(result, incorrect_color);

  return result;
}

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION == 2.f) {
    corrected_color = GammaCorrectHuePreserving(incorrect_color);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

bool GenerateOutput(float r, float g, float b, inout float4 SV_Target, bool is_hdr = true) {
  if (RENODX_TONE_MAP_TYPE == 0 || !is_hdr) return false;  // skip if SDR or Vanilla tone mapper

  float3 final_color = (float3(r, g, b));
  if (RENODX_TONE_MAP_TYPE == 4.f) final_color = saturate(final_color);

  final_color = ApplyGammaCorrection(final_color);

  float3 bt2020_color = renodx::color::bt2020::from::BT709(final_color);

  float3 encoded_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);

  SV_Target = float4(encoded_color / 1.05f, 0.f);
  return true;
}
