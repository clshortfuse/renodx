#include "../common.hlsli"

float3 ApplyGammaCorrection(float3 incorrect_color) {
  float3 corrected_color;
  if (RENODX_GAMMA_CORRECTION != 0.f) {
    corrected_color = renodx::color::correct::GammaSafe(incorrect_color);
  } else {
    corrected_color = incorrect_color;
  }

  return corrected_color;
}

float4 GenerateOutput(Texture2D<float4> tLinearImage, SamplerState PointBorder, float2 TEXCOORD) {
  float3 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f).rgb;
  bt709Color = renodx::color::bt709::clamp::AP1(bt709Color);

  bt709Color = ApplyGammaCorrection(bt709Color);

  float3 bt2020Color = renodx::color::bt2020::from::BT709(bt709Color.rgb);

  bt2020Color *= RENODX_GRAPHICS_WHITE_NITS;
  bt2020Color = min(bt2020Color, RENODX_PEAK_WHITE_NITS);
  float3 pqColor = renodx::color::pq::EncodeSafe(bt2020Color, 1.f);

  return float4(pqColor, 1.0);
}
