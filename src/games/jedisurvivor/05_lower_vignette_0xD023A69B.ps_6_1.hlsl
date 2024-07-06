#include "./shared.h"

cbuffer _13_15 : register(b0, space0) { float4 _15_m0[45] : packoffset(c0); };

cbuffer _18_20 : register(b1, space0) { float4 _20_m0[7] : packoffset(c0); };

Texture2D<float4> _8 : register(t0, space0);
SamplerState _23 : register(s0, space0);

float4 main(float4 gl_FragCoord : SV_Position, float4 TEXCOORD : TEXCOORD0) : SV_Target0 {
  uint4 _43 = asuint(_15_m0[37u]);
  float _55 = (gl_FragCoord.x - float(_43.x)) * _15_m0[38u].z;
  float _56 = (gl_FragCoord.y - float(_43.y)) * _15_m0[38u].w;
  float4 _86 = _8.Sample(
      _23, float2(min(max((_55 * _15_m0[5u].x) + _15_m0[4u].x, _15_m0[6u].x),
                      _15_m0[6u].z),
                  min(max((_56 * _15_m0[5u].y) + _15_m0[4u].y, _15_m0[6u].y),
                      _15_m0[6u].w)));

  if (injectedData.fxVignette == 0.f) {
    return float4(_86.rgb, 1.f);
  }

  float _89 = _86.x;
  float _90 = _86.y;
  float _91 = _86.z;
  float _102 = _20_m0[3u].z * (_55 + (-0.5f));
  float _103 = _56 + (-0.5f);
  float _110 =
      1.0f - (sqrt(dot(float2(_102, _103), float2(_102, _103))) / _20_m0[3u].w);
  float _115 = _20_m0[4u].x * _110;
  float _161 = clamp(
      ((clamp(clamp(((_20_m0[5u].x - _20_m0[5u].y) * dot(float4(_55, _56, 0.0f, 0.0f), float4(_20_m0[1u]))) + _20_m0[5u].y,
                    0.0f, 1.0f),
              0.0f, 1.0f)
        * clamp(1.0f - clamp(((_20_m0[4u].y - _20_m0[4u].z) * (((_110 >= 0.0f) && (abs(_110) > 9.9999997473787516355514526367188e-06f)) ? (1.0f - (1.0f / exp2((_115 * _115) * 1.442695140838623046875f))) : 0.0f)) + _20_m0[4u].z, 0.0f, 1.0f),
                0.0f, 1.0f))
       - _20_m0[5u].z)
          / (_20_m0[5u].w - _20_m0[5u].z),
      0.0f, 1.0f);
  float _167 = (_161 * _161) * (3.0f - (_161 * 2.0f));
  float _174 = (_167 * ((_20_m0[3u].x * _89) - _89)) + _89;
  float _175 = (_167 * ((_20_m0[3u].x * _90) - _90)) + _90;
  float _176 = (_167 * ((_20_m0[3u].x * _91) - _91)) + _91;
  float4 SV_Target;
  SV_Target.x = max(((_20_m0[2u].x - _174) * _20_m0[6u].x) + _174, 0.0f);
  SV_Target.y = max(((_20_m0[2u].y - _175) * _20_m0[6u].x) + _175, 0.0f);
  SV_Target.z = max(((_20_m0[2u].z - _176) * _20_m0[6u].x) + _176, 0.0f);
  SV_Target.w = 1.0f;

  SV_Target.rgb = lerp(_86.rgb, SV_Target.rgb, injectedData.fxVignette);

  return SV_Target;
}
