#include "./shared.h"

SamplerState g_TextureSampler_s : register(s0);
SamplerState g_GammaTextureSampler_s : register(s1);
Texture2D<float4> g_Texture : register(t0);
Texture1D<float4> g_GammaTexture : register(t1);

void main(float4 v0: SV_Position0, float2 v1: TEXCOORD0, out float4 o0: SV_Target0) {
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  o0.xyz = g_Texture.Sample(g_TextureSampler_s, v1.xy).xyz;

  o0.rgb = renodx::math::PowSafe(o0.rgb, 2.2f);
#if 0  // scRGB
  o0.rgb *= RENODX_GRAPHICS_WHITE_NITS / 80.f;
#else  // HDR10
  o0.rgb = renodx::color::bt2020::from::BT709(o0.rgb);
  o0.rgb = renodx::color::pq::EncodeSafe(o0.rgb, RENODX_GRAPHICS_WHITE_NITS);
#endif
  // Removed gamma slider as it capped brightness
  // Image is unchanged when set to default 5

  return;
}
