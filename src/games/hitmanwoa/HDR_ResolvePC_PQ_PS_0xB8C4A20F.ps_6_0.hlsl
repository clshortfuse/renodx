#include "./common.hlsli"

struct S_cbHDRResolve {
  float4 S_cbHDRResolve_000;
  float4 S_cbHDRResolve_016[4];
};

Texture2D<float4> t0 : register(t0);

cbuffer cb5 : register(b5) {
  S_cbHDRResolve _cbHDRResolve_000 : packoffset(c000.x);
};

float4 main(
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
#if 0
  float paper_white = _cbHDRResolve_000.S_cbHDRResolve_000.y * 10000.f * 2.5f;  // _cbHDRResolve_000.S_cbHDRResolve_000.y = 100.f
#else
  float paper_white = RENODX_GRAPHICS_WHITE_NITS;
#endif

  uint2 pixel_coord = uint2(SV_Position.xy);
  float3 linear_color = t0.Load(int3(pixel_coord, 0)).rgb;

  linear_color /= 2.5f;  // normalize brightness
  linear_color = ApplyGammaCorrection(linear_color);

  // linear_color = renodx::math::SignPow(linear_color, _cbHDRResolve_000.S_cbHDRResolve_000.x);
  float3 bt2020_color = renodx::color::bt2020::from::BT709(linear_color);
  bt2020_color = GamutCompress(bt2020_color, renodx::color::BT2020_TO_XYZ_MAT);
  float3 pq_color = renodx::color::pq::EncodeSafe(bt2020_color, 200.f / pow(_cbHDRResolve_000.S_cbHDRResolve_000.x, 3.80178));  // gamma slider at 0.8 (actually 1.2) = 100
  // float3 pq_color = renodx::color::pq::EncodeSafe(bt2020_color, paper_white);
  return float4(pq_color, 1.f);
}
