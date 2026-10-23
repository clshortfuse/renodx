#include "./shared.h"
#include "./common.hlsli"

Texture2D<float4> hdr_source : register(t0);

float4 main(float4 position: SV_Position) : SV_Target {
  float4 source = hdr_source.Load(int3(int2(position.xy), 0));
  float3 color = ScaleSceneInverse(source.rgb);
  [branch]
  if (RENODX_GAMMA_CORRECTION == 0.f) {
    color.rgb = renodx::color::srgb::DecodeSafe(color.rgb);
  } else if (RENODX_GAMMA_CORRECTION == 1.f) {
    color.rgb = renodx::color::gamma::DecodeSafe(color.rgb);
  }
  color = renodx::color::gamut::GamutCompressBT709(color);
  color = renodx::tonemap::neutwo::MaxChannel(color);
  color = saturate(color);
  return float4(renodx::color::srgb::EncodeSafe(color), source.a);
}
