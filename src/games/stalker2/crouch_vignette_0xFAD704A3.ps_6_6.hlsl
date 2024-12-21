#include "./shared.h"
#include "./common.hlsl"

Texture2D<float4> PostProcessInput_0_Texture : register(t0);

cbuffer $Globals : register(b0) {
  float $Globals_004x : packoffset(c004.x);
  float $Globals_004y : packoffset(c004.y);
  float $Globals_005x : packoffset(c005.x);
  float $Globals_005y : packoffset(c005.y);
  uint $Globals_072x : packoffset(c072.x);
  uint $Globals_072y : packoffset(c072.y);
  float $Globals_073z : packoffset(c073.z);
  float $Globals_073w : packoffset(c073.w);
};

cbuffer UniformBufferConstants_MaterialCollection0 : register(b1) {
  float UniformBufferConstants_MaterialCollection0_020w : packoffset(c020.w);
};

cbuffer UniformBufferConstants_Material : register(b2) {
  float UniformBufferConstants_Material_001y : packoffset(c001.y);
  float UniformBufferConstants_Material_001w : packoffset(c001.w);
  float UniformBufferConstants_Material_002x : packoffset(c002.x);
  float UniformBufferConstants_Material_002z : packoffset(c002.z);
  float UniformBufferConstants_Material_002w : packoffset(c002.w);
  float UniformBufferConstants_Material_003x : packoffset(c003.x);
  float UniformBufferConstants_Material_003y : packoffset(c003.y);
  float UniformBufferConstants_Material_004x : packoffset(c004.x);
  float UniformBufferConstants_Material_004y : packoffset(c004.y);
  float UniformBufferConstants_Material_004z : packoffset(c004.z);
};

SamplerState PostProcessInput_0_Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float3 tonemappedRender, post_srgb, output, srgb_input;

  float _21 = ((SV_Position.x) - (float((uint)($Globals_072x)))) * ($Globals_073z);
  float _22 = ((SV_Position.y) - (float((uint)($Globals_072y)))) * ($Globals_073w);
  float4 _35 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(((_21 * ($Globals_005x)) + ($Globals_004x)), ((_22 * ($Globals_005y)) + ($Globals_004y))));
  if (injectedData.toneMapType > 0.f) {
    // We decode before they attempt to blend
    tonemappedRender = PQToDecoded(_35.rgb);
    srgb_input = DecodedTosRGB(tonemappedRender);
    _35.rgb = srgb_input;
  }
  float _45 = (abs(((UniformBufferConstants_Material_001y) * (_21 + -0.5f)))) * 2.0f;
  float _51 = (abs(((UniformBufferConstants_Material_001w) * (_22 + -0.5f)))) * 2.0f;
  float _60 = ((1.0f - (UniformBufferConstants_Material_002x)) - ((1.0f - (_51 * _51)) * (1.0f - (_45 * _45)))) * (UniformBufferConstants_Material_002z);
  float _73 = ((UniformBufferConstants_MaterialCollection0_020w) * (saturate(((((bool)((_60 <= 0.0f))) ? 0.0f : (exp2(((log2(_60)) * (UniformBufferConstants_Material_002w))))))))) * (UniformBufferConstants_Material_003x);
  float _77 = (_35.x) - (_73 * (_35.x));
  float _78 = (_35.y) - (_73 * (_35.y));
  float _79 = (_35.z) - (_73 * (_35.z));
  SV_Target.x = (max(((((UniformBufferConstants_Material_004x)-_77) * (UniformBufferConstants_Material_003y)) + _77), 0.0f));
  SV_Target.y = (max(((((UniformBufferConstants_Material_004y)-_78) * (UniformBufferConstants_Material_003y)) + _78), 0.0f));
  SV_Target.z = (max(((((UniformBufferConstants_Material_004z)-_79) * (UniformBufferConstants_Material_003y)) + _79), 0.0f));
  post_srgb = SV_Target.rgb;

  if (injectedData.toneMapType > 0.f) {
    output = UpgradePostProcess(tonemappedRender, post_srgb);
    return float4(output, 0.f);
  }
  SV_Target.w = 0.0f;
  return SV_Target;
}
