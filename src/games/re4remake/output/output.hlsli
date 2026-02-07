#include "../common.hlsli"

float4 GenerateOutput(Texture2D<float4> tLinearImage, SamplerState PointBorder, float2 TEXCOORD) {
  float3 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f).rgb;

  bt709Color = ApplyGammaCorrection(bt709Color);

  float3 bt2020Color = renodx::color::bt2020::from::BT709(bt709Color.rgb);

  bt2020Color *= RENODX_GRAPHICS_WHITE_NITS;
  bt2020Color = min(bt2020Color, RENODX_PEAK_WHITE_NITS);
  float3 pqColor = renodx::color::pq::EncodeSafe(bt2020Color, 1.f);

  return float4(pqColor, 1.0);
}