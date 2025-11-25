#ifndef LUTBUILDER_COMMON_HLSLI
#define LUTBUILDER_COMMON_HLSLI

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

bool GenerateOutput(float r, float g, float b, inout float4 SV_Target) {
  if (RENODX_TONE_MAP_TYPE == 0) return false;  // off uses Engine.ini HDR

  float3 final_color = (float3(r, g, b));
  if (RENODX_TONE_MAP_TYPE == 4.f) final_color = saturate(final_color);

  final_color = ApplyGammaCorrection(final_color);

  float3 bt2020_color = renodx::color::bt2020::from::BT709(final_color);

#if 0
  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(bt2020_color, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::Encode(renodx::color::y::from::BT2020(bt2020_color), MID_GRAY_GAMMA);

  float gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(encoded, encoded_gray);
  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray, gamut_compression_scale);

  renodx::color::gamma::DecodeSafe(compressed, MID_GRAY_GAMMA);
#endif

  float3 encoded_color = renodx::color::pq::EncodeSafe(bt2020_color, RENODX_DIFFUSE_WHITE_NITS);

  SV_Target = float4(encoded_color / 1.05f, 0.f);
  return true;
}

#endif  // LUTBUILDER_COMMON_HLSLI
