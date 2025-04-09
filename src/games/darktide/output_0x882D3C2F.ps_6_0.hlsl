#include "./shared.h"

Texture2D<float4> t0 : register(t0);

cbuffer global_viewport : register(b0) {
  float global_viewport_091z : packoffset(c091.z);
  float global_viewport_098x : packoffset(c098.x);
};

cbuffer c0 : register(b1) {
  float c0_004x : packoffset(c004.x);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = t0.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)));
  uint _17 = uint((SV_Position.x));
  uint _26 = (25 * ((uint)((23 * ((uint)(uint(((global_viewport_091z) + 2.0f))))) + (uint((c0_004x)))))) + _17;
  uint _30 = 30 * ((uint)(29 ^ ((uint)(27 ^ _26))));
  uint _33 = 33 * ((uint)(32 ^ ((uint)(_30) >> 4)));
  float _38 = ((float((uint)(35 ^ ((uint)(_33) >> 15)))) * 9.130612932395366e-13f) + -0.0019607841968536377f;
  float _41 = 2.200000047683716f / (global_viewport_098x);
  SV_Target.x = (saturate((_38 + (exp2(((log2((_9.x))) * _41))))));
  SV_Target.y = (saturate((_38 + (exp2(((log2((_9.y))) * _41))))));
  SV_Target.z = (saturate((_38 + (exp2(((log2((_9.z))) * _41))))));
  SV_Target.w = (_9.w);
  SV_Target.rgb = _9.rgb;
  return SV_Target;
}
