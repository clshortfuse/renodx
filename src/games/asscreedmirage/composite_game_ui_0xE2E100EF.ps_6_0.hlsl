#include "./shared.h"

Texture2D<float4> t0 : register(t0, space4);

Texture2D<float4> t1 : register(t1, space4);

Texture3D<float4> t2 : register(t3, space4);

cbuffer cb0 : register(b0, space4) {
  float cb0_000w : packoffset(c000.w);
};

SamplerState s0 : register(s2, space98);

SamplerState s1 : register(s0, space5);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = t0.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)));
  float4 _14 = t1.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y))); // scene color
  float _19 = 1.0f - (_9.w);
  float _26 = 1.0f / (max((_9.w), 1.0000000116860974e-07f));

  // UI LUT
  float4 _39 = t2.SampleLevel(s1, float3((((saturate((_26 * (_9.x)))) * 0.96875f) + 0.015625f), (((saturate((_26 * (_9.y)))) * 0.96875f) + 0.015625f), (((saturate((_26 * (_9.z)))) * 0.96875f) + 0.015625f)), 0.0f);
  float _57 = exp2(((log2((abs((((_39.x) * (_9.w)) + ((min((_14.x), (cb0_000w))) * _19)))))) * 0.012683313339948654f));
  float _58 = _57 + -0.8359375f;
  float _67 = exp2(((log2((abs((((((bool)((_58 < 0.0f))) ? 0.0f : _58)) / (18.8515625f - (_57 * 18.6875f))))))) * 6.277394771575928f));
  float _71 = exp2(((log2((abs((((_39.y) * (_9.w)) + ((min((_14.y), (cb0_000w))) * _19)))))) * 0.012683313339948654f));
  float _72 = _71 + -0.8359375f;
  float _82 = (exp2(((log2((abs((((((bool)((_72 < 0.0f))) ? 0.0f : _72)) / (18.8515625f - (_71 * 18.6875f))))))) * 6.277394771575928f))) * 10000.0f;
  float _86 = exp2(((log2((abs((((_39.z) * (_9.w)) + ((min((_14.z), (cb0_000w))) * _19)))))) * 0.012683313339948654f));
  float _87 = _86 + -0.8359375f;
  float _97 = (exp2(((log2((abs((((((bool)((_87 < 0.0f))) ? 0.0f : _87)) / (18.8515625f - (_86 * 18.6875f))))))) * 6.277394771575928f))) * 10000.0f;
#if 1
  // Modified BT2020 -> XYZ what are `6369.58203125f` and `2627.002685546875f` for?
  float _100 = mad(_97, 0.16888095438480377f, (mad(_82, 0.14461688697338104f, (_67 * 6369.58203125f))));
  float _103 = mad(_97, 0.0593017116189003f, (mad(_82, 0.6779980063438416f, (_67 * 2627.002685546875f))));
  float _105 = mad(_97, 1.0609849691390991f, (mad(_82, 0.02807268314063549f, 0.0f)));
  float3 xyzColor = float3(_100, _103, _105);
  SV_Target.rgb = renodx::color::bt709::from::XYZ(float3(xyzColor)) * (125.f / 10000.f);
#else  // getting black parts on main menu
  float3 pqDecodedColor = renodx::color::pq::DecodeSafe(_14.rgb, 125.f);
  float3 bt709Color = renodx::color::bt709::from::BT2020(pqDecodedColor);
  SV_Target.rgb = bt709Color;
#endif
  SV_Target.w = (((_14.w) * _19) + (_9.w));
  return SV_Target;
}
