#include "../common.hlsli"

// Texture2D t0 : register(t0);
// SamplerState s0 : register(s0);
// float4 main(float4 vpos : SV_POSITION, float2 uv : TEXCOORD0)
//     : SV_TARGET {
//   return renodx::draw::SwapChainPass(t0.Sample(s0, uv));
// }

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0) : SV_TARGET {
  float4 color = t0.Sample(s0, uv);

  color = renodx::math::ZeroNaN(color);  // Clear NaNs

  [branch]
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb);
  }

  // if (RENODX_COLOR_GRADE_SPACE == 1.f) {
  //   color.rgb = renodx::color::bt709::from::BT709D93(color.rgb);
  // }

  color.rgb *= RENODX_GRAPHICS_WHITE_NITS;  // Scale paper white

  color.rgb = renodx::color::bt709::clamp::AP1(color.rgb);  // clamp to AP1

  // Gamut Compress to BT2020
#if 1
  color.rgb = renodx::color::bt2020::from::BT709(color.rgb);
  const float MID_GRAY_GAMMA = log(1 / (pow(10, 0.75))) / log(0.5f);  // ~2.49f

  float3 encoded = renodx::color::gamma::EncodeSafe(color.rgb, MID_GRAY_GAMMA);
  float encoded_gray = renodx::color::gamma::EncodeSafe(renodx::color::y::from::BT2020(color.rgb), MID_GRAY_GAMMA);

  float gamut_compression_scale = renodx::color::correct::ComputeGamutCompressionScale(encoded, encoded_gray);

  float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray, gamut_compression_scale);

  color.rgb = renodx::color::gamma::DecodeSafe(compressed, MID_GRAY_GAMMA);
  color.rgb = renodx::color::bt709::from::BT2020(color.rgb);
#endif

  // clamp swapchain to peak nits or ui nits by max channel
  float swapchain_clamp_nits = renodx::math::Select(RENODX_TONE_MAP_TYPE, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);
  float max_channel = max(max(max(color.r, color.g), color.b), swapchain_clamp_nits);
  color.rgb *= swapchain_clamp_nits / max_channel;  // Clamp UI or Videos

  [branch]
  if (SWAP_CHAIN_ENCODING == 0.f) {
    // HDR10
    color.rgb = renodx::color::bt2020::from::BT709(color.rgb);
    color.rgb = renodx::color::pq::EncodeSafe(color.rgb, 1.f);
  }
  if (SWAP_CHAIN_ENCODING == 1.f) {
    // scRGB
    color.rgb /= 80.f;
  }

  color.a = 1.f;

  return color;
}
