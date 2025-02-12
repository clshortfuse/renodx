#include "./common.hlsl"

Texture2D<float4> PAAComp_CurTarg : register(t0);

Texture3D<float4> PostAA_Grain : register(t2);

cbuffer PER_BATCH : register(b0, space1) {
  float PER_BATCH_000w : packoffset(c000.w);
  float PER_BATCH_001x : packoffset(c001.x);
  float PER_BATCH_001y : packoffset(c001.y);
  float PER_BATCH_002x : packoffset(c002.x);
};

SamplerState PostAA_GrainSS : register(s7);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  // float4 _11 = PAAComp_CurTarg.Load(int3((int(9)), (int(10)), 0));
  float4 _11 = PAAComp_CurTarg.Load(int3((int(SV_Position.x)), (int(SV_Position.y)), 0));
  // _11.rgb = renodx::draw::InvertIntermediatePass(_11.rgb); // OptiScaler?
  float _31 = (PER_BATCH_000w) * ((((float4)(PostAA_Grain.Sample(PostAA_GrainSS, float3((((TEXCOORD.x) * 4.0f) * ((PER_BATCH_001x) / (PER_BATCH_001y))), ((TEXCOORD.y) * 4.0f), ((PER_BATCH_002x) * 3.0f))))).x) + -0.5f);
  float _32 = _31 + 0.5f;
  float _45 = 0.5f - _31;
  float _53 = ((_11.x) * 2.0f) * _32;
  float _55 = ((_11.y) * 2.0f) * _32;
  float _57 = ((_11.z) * 2.0f) * _32;
  /* SV_Target.x = (saturate(((((1.0f - (((1.0f - (_11.x)) * 2.0f) * _45)) - _53) * ((((bool)(((_11.x) < 0.5f))) ? 0.0f : 1.0f))) + _53)));
  SV_Target.y = (saturate(((((1.0f - (((1.0f - (_11.y)) * 2.0f) * _45)) - _55) * ((((bool)(((_11.y) < 0.5f))) ? 0.0f : 1.0f))) + _55)));
  SV_Target.z = (saturate(((((1.0f - (((1.0f - (_11.z)) * 2.0f) * _45)) - _57) * ((((bool)(((_11.z) < 0.5f))) ? 0.0f : 1.0f))) + _57))); */
  SV_Target.x = (((((1.0f - (((1.0f - (_11.x)) * 2.0f) * _45)) - _53) * ((((bool)(((_11.x) < 0.5f))) ? 0.0f : 1.0f))) + _53));
  SV_Target.y = (((((1.0f - (((1.0f - (_11.y)) * 2.0f) * _45)) - _55) * ((((bool)(((_11.y) < 0.5f))) ? 0.0f : 1.0f))) + _55));
  SV_Target.z = (((((1.0f - (((1.0f - (_11.z)) * 2.0f) * _45)) - _57) * ((((bool)(((_11.z) < 0.5f))) ? 0.0f : 1.0f))) + _57));
  // SV_Target.rgb = renodx::color::srgb::EncodeSafe(SV_Target.rgb);  // OptiScaler?
  SV_Target.w = (saturate((_11.w)));

  return SV_Target;
}
