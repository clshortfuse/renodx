#include "./shared.h"

Texture2D<float4> hdr_source : register(t0);

float4 main(float4 position: SV_Position) : SV_Target {
  float4 source = hdr_source.Load(int3(int2(position.xy), 0));
  float3 color = max(0.f, renodx::draw::InvertIntermediatePass(source.rgb));
  color = renodx::color::gamut::GamutCompressBT709(color);
  color = renodx::tonemap::neutwo::MaxChannel(color);
  color = saturate(color);
  return float4(renodx::color::srgb::Encode(saturate(color)), source.a);
}
