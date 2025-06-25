#include "../common.hlsl"
Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

// clang-format off
cbuffer cb5 : register(b5) {
  struct S_cbColorCorrectionResolve {
    float S_cbColorCorrectionResolve_000;
  } _cbColorCorrectionResolve_000: packoffset(c000.x);
};
// clang-format on

SamplerState s4 : register(s4);

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float3 gamma2_color = float3(SV_DispatchThreadID) / 15.f;
  float3 linear_color = gamma2_color * gamma2_color;

  float3 srgb_color = saturate(renodx::color::srgb::Encode(linear_color));

  float4 lut_sample = saturate(SampleLUTSRGBInLinearOut(t0, s4, srgb_color));
  lut_sample.rgb = renodx::color::srgb::Encode(lut_sample.rgb);

  float4 interpolated_output = lerp(lut_sample, float4(srgb_color, 1.f), _cbColorCorrectionResolve_000.S_cbColorCorrectionResolve_000);

  u0[SV_DispatchThreadID] = interpolated_output;
}
