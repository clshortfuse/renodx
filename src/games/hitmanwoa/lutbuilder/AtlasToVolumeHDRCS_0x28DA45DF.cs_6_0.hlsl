#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

SamplerState s4 : register(s4);

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float3 color_input = float3(SV_DispatchThreadID.xyz) / 15.f;

  float3 color_srgb;
  if (RENODX_LUT_SAMPLING_TYPE != 0.f) {  // sRGB input
    color_srgb = color_input;
  } else {                                // linear input
    color_srgb = renodx::color::srgb::EncodeSafe(color_input);
  }

  float4 lut_output_srgb = saturate(SampleLUTSRGBInSRGBOut(t0, s4, color_srgb));

  u0[int3((uint3)(SV_DispatchThreadID.xyz))] = lut_output_srgb;
}
