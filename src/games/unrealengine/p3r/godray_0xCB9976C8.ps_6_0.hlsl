#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_004x : packoffset(c004.x);
  float cb0_004y : packoffset(c004.y);
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  uint cb0_037x : packoffset(c037.x);
  uint cb0_037y : packoffset(c037.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_038w : packoffset(c038.w);
};

cbuffer cb1 : register(b1) {
  float cb1_000x : packoffset(c000.x);
};

cbuffer cb2 : register(b2) {
  float cb2_000x : packoffset(c000.x);
  float cb2_000y : packoffset(c000.y);
  float cb2_000z : packoffset(c000.z);
  float cb2_000w : packoffset(c000.w);
  float cb2_002x : packoffset(c002.x);
  float cb2_002y : packoffset(c002.y);
  float cb2_002z : packoffset(c002.z);
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
};

cbuffer cb3 : register(b3) {
  float cb3_001x : packoffset(c001.x);
  float cb3_001y : packoffset(c001.y);
  float cb3_001z : packoffset(c001.z);
  float cb3_002x : packoffset(c002.x);
};

SamplerState s0 : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float _19 = ((SV_Position.x) - (float((uint)(cb0_037x)))) * (cb0_038z);
  float _20 = ((SV_Position.y) - (float((uint)(cb0_037y)))) * (cb0_038w);
  float4 _31 = t0.Sample(s0, float2(((_19 * (cb0_005x)) + (cb0_004x)), ((_20 * (cb0_005y)) + (cb0_004y))));
  float3 tonemapped = _31.rgb;
  _31.rgb = saturate(tonemapped);
  float _42 = 1.0f - _20;
  float _49 = (_42 * _19) * (cb2_000y);
  float _59 = ((1.0f - _19) * _42) * (cb2_000x);
  float _67 = (cb2_000z)*_20;
  float _77 = (cb2_000w) * (1.0f - (cb1_000x));
  float _81 = (_77 * (((_59 * (cb2_002x)) + ((cb2_004x)*_67)) + (_49 * (cb2_003x)))) + (_31.x);
  float _82 = (_77 * (((_59 * (cb2_002y)) + ((cb2_004y)*_67)) + (_49 * (cb2_003y)))) + (_31.y);
  float _83 = (_77 * (((_59 * (cb2_002z)) + ((cb2_004z)*_67)) + (_49 * (cb2_003z)))) + (_31.z);
  SV_Target.x = (max(((((cb3_001x)-_81) * (cb3_002x)) + _81), 0.0f));
  SV_Target.y = (max(((((cb3_001y)-_82) * (cb3_002x)) + _82), 0.0f));
  SV_Target.z = (max(((((cb3_001z)-_83) * (cb3_002x)) + _83), 0.0f));
  SV_Target.rgb = renodx::draw::UpgradeToneMapByLuminance(tonemapped, renodx::tonemap::renodrt::NeutralSDR(tonemapped), SV_Target.rgb, 1.f);
  SV_Target.a = 1.f;
  return SV_Target;
}
