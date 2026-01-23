#include "../common.hlsli"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float4 sample = t0.Sample(s0, uv);

  float3 color = sample.rgb;
  color = renodx::color::gamma::DecodeSafe(color, 2.2f);

#if 1
  color = renodx::color::bt2020::from::BT709(color);
  color = renodx::color::pq::EncodeSafe(color, RENODX_GRAPHICS_WHITE_NITS);
#else
  color *= RENODX_GRAPHICS_WHITE_NITS / 80.f;
#endif
  return float4(color, sample.a);
}
