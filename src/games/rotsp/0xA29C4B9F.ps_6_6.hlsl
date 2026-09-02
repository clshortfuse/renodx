#include "./common.hlsl"

Texture2D<float4> Material_Texture2D_0 : register(t0);

Texture2D<float4> PostProcessInput_0_Texture : register(t1);

cbuffer $Globals : register(b0) {
  float2 PostProcessInput_0_UVViewportMin : packoffset(c000.x);
  float2 PostProcessInput_0_UVViewportSize : packoffset(c000.z);
  float2 PostProcessInput_0_UVViewportBilinearMin : packoffset(c001.x);
  float2 PostProcessInput_0_UVViewportBilinearMax : packoffset(c001.z);
  float2 PostProcessInput_1_UVViewportMin : packoffset(c002.x);
  float2 PostProcessInput_1_UVViewportSize : packoffset(c002.z);
  float2 PostProcessInput_1_UVViewportBilinearMin : packoffset(c003.x);
  float2 PostProcessInput_1_UVViewportBilinearMax : packoffset(c003.z);
  float2 PostProcessInput_2_UVViewportMin : packoffset(c004.x);
  float2 PostProcessInput_2_UVViewportSize : packoffset(c004.z);
  float2 PostProcessInput_2_UVViewportBilinearMin : packoffset(c005.x);
  float2 PostProcessInput_2_UVViewportBilinearMax : packoffset(c005.z);
  float2 PostProcessInput_3_UVViewportMin : packoffset(c006.x);
  float2 PostProcessInput_3_UVViewportSize : packoffset(c006.z);
  float2 PostProcessInput_3_UVViewportBilinearMin : packoffset(c007.x);
  float2 PostProcessInput_3_UVViewportBilinearMax : packoffset(c007.z);
  float2 PostProcessInput_4_UVViewportMin : packoffset(c008.x);
  float2 PostProcessInput_4_UVViewportSize : packoffset(c008.z);
  float2 PostProcessInput_4_UVViewportBilinearMin : packoffset(c009.x);
  float2 PostProcessInput_4_UVViewportBilinearMax : packoffset(c009.z);
  uint2 PostProcessOutput_ViewportMin : packoffset(c010.x);
  float2 PostProcessOutput_ViewportSizeInverse : packoffset(c010.z);
};

cbuffer UniformBufferConstants_Material : register(b1) {
  float4 Material_PreshaderBuffer[6] : packoffset(c000.x);
  uint BindlessResource_Material_Texture2D_0 : packoffset(c006.x);
  uint PrePadding_Material_100 : packoffset(c006.y);
  uint BindlessSampler_Material_Texture2D_0Sampler : packoffset(c006.z);
  uint PrePadding_Material_108 : packoffset(c006.w);
  uint BindlessSampler_Material_Wrap_WorldGroupSettings : packoffset(c007.x);
  uint PrePadding_Material_116 : packoffset(c007.y);
  uint BindlessSampler_Material_Clamp_WorldGroupSettings : packoffset(c007.z);
};

SamplerState Material_Texture2D_0Sampler : register(s0);

SamplerState PostProcessInput_0_Sampler : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _21 = (SV_Position.x - float((uint)(int)(PostProcessOutput_ViewportMin.x))) * PostProcessOutput_ViewportSizeInverse.x;
  float _22 = (SV_Position.y - float((uint)(int)(PostProcessOutput_ViewportMin.y))) * PostProcessOutput_ViewportSizeInverse.y;
  float4 _43 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(min(max(((PostProcessInput_0_UVViewportSize.x * _21) + PostProcessInput_0_UVViewportMin.x), PostProcessInput_0_UVViewportBilinearMin.x), PostProcessInput_0_UVViewportBilinearMax.x), min(max(((PostProcessInput_0_UVViewportSize.y * _22) + PostProcessInput_0_UVViewportMin.y), PostProcessInput_0_UVViewportBilinearMin.y), PostProcessInput_0_UVViewportBilinearMax.y)));
  float4 _49 = Material_Texture2D_0.Sample(Material_Texture2D_0Sampler, float2(_21, _22));
  float _57 = saturate((Material_PreshaderBuffer[3].y) - (_49.x * 100.0f)) * _49.y;
  float _65 = ((Material_PreshaderBuffer[4].x) * _57) + _43.x;
  float _66 = ((Material_PreshaderBuffer[4].y) * _57) + _43.y;
  float _67 = ((Material_PreshaderBuffer[4].z) * _57) + _43.z;
  //SV_Target.x = max(((((Material_PreshaderBuffer[5].y) - _65) * (Material_PreshaderBuffer[5].x)) + _65), 0.0f);
  //SV_Target.y = max(((((Material_PreshaderBuffer[5].z) - _66) * (Material_PreshaderBuffer[5].x)) + _66), 0.0f);
  //SV_Target.z = max(((((Material_PreshaderBuffer[5].w) - _67) * (Material_PreshaderBuffer[5].x)) + _67), 0.0f);
  SV_Target.x = ((((Material_PreshaderBuffer[5].y) - _65) * (Material_PreshaderBuffer[5].x)) + _65);
  SV_Target.y = ((((Material_PreshaderBuffer[5].z) - _66) * (Material_PreshaderBuffer[5].x)) + _66);
  SV_Target.z = ((((Material_PreshaderBuffer[5].w) - _67) * (Material_PreshaderBuffer[5].x)) + _67);
  SV_Target.w = 0.0f;
  return SV_Target;
}
