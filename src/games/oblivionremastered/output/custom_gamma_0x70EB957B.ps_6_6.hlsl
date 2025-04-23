#include "../shared.h"

Texture2D<float4> PostProcessInput_0_Texture : register(t0);

cbuffer $Globals : register(b0) {
  float2 PostProcessInput_0_UVViewportMin : packoffset(c000.x);
  float2 PostProcessInput_0_UVViewportSize : packoffset(c000.z);
  float2 PostProcessInput_1_UVViewportMin : packoffset(c001.x);
  float2 PostProcessInput_1_UVViewportSize : packoffset(c001.z);
  float2 PostProcessInput_2_UVViewportMin : packoffset(c002.x);
  float2 PostProcessInput_2_UVViewportSize : packoffset(c002.z);
  float2 PostProcessInput_3_UVViewportMin : packoffset(c003.x);
  float2 PostProcessInput_3_UVViewportSize : packoffset(c003.z);
  float2 PostProcessInput_4_UVViewportMin : packoffset(c004.x);
  float2 PostProcessInput_4_UVViewportSize : packoffset(c004.z);
  uint2 PostProcessOutput_ViewportMin : packoffset(c005.x);
  float2 PostProcessOutput_ViewportSizeInverse : packoffset(c005.z);
};

cbuffer UniformBufferConstants_Material : register(b1) {
  float4 Material_PreshaderBuffer[3] : packoffset(c000.x);
  uint BindlessSampler_Material_Wrap_WorldGroupSettings : packoffset(c003.x);
  uint PrePadding_Material_52 : packoffset(c003.y);
  uint BindlessSampler_Material_Clamp_WorldGroupSettings : packoffset(c003.z);
};

SamplerState PostProcessInput_0_Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _32 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(((((SV_Position.x - float((uint)PostProcessOutput_ViewportMin.x)) * PostProcessOutput_ViewportSizeInverse.x) * PostProcessInput_0_UVViewportSize.x) + PostProcessInput_0_UVViewportMin.x), ((((SV_Position.y - float((uint)PostProcessOutput_ViewportMin.y)) * PostProcessOutput_ViewportSizeInverse.y) * PostProcessInput_0_UVViewportSize.y) + PostProcessInput_0_UVViewportMin.y)));

  float4 signs = renodx::math::Sign(_32);
  _32 = abs(_32);

  float _42 = select((_32.x <= 0.0f), 0.0f, exp2(log2(_32.x) * (Material_PreshaderBuffer[1].w)));
  float _47 = select((_32.y <= 0.0f), 0.0f, exp2(log2(_32.y) * (Material_PreshaderBuffer[1].w)));
  float _52 = select((_32.z <= 0.0f), 0.0f, exp2(log2(_32.z) * (Material_PreshaderBuffer[1].w)));
  SV_Target.x = max(((((Material_PreshaderBuffer[2].y) - _42) * (Material_PreshaderBuffer[2].x)) + _42), 0.0f);
  SV_Target.y = max(((((Material_PreshaderBuffer[2].z) - _47) * (Material_PreshaderBuffer[2].x)) + _47), 0.0f);
  SV_Target.z = max(((((Material_PreshaderBuffer[2].w) - _52) * (Material_PreshaderBuffer[2].x)) + _52), 0.0f);
  SV_Target.w = 0.0f;

  SV_Target *= signs;
  return SV_Target;
}
