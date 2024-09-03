#include "./shared.h";

Texture2D<float4> t0 : register(t0);

cbuffer _cb0 : register(b0) {
  float4 cb0[4] : packoffset(c0);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR : COLOR,
  linear float4 COLOR_1 : COLOR1,
  linear float4 ORIGINAL_POSITION : ORIGINAL_POSITION,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  // texture _1 = t0;
  // SamplerState _2 = s0;
  // cbuffer _3 = cb0; // index=0
  // _4 = _3;
  float _5 = COLOR.x;
  float _6 = COLOR.y;
  float _7 = COLOR.z;
  float _8 = COLOR.w;
  float _9 = TEXCOORD_1.x;
  float _10 = TEXCOORD_1.y;
  // _11 = _1;
  // _12 = _2;
  float4 _13 = t0.Sample(s0, float2(_9, _10));
  float _14 = _13.w;
  float _15 = _14 * _8;
  float4 _16 = cb0[0u];
  float _17 = _16.w;
  bool _18 = (_17 != 1.0f);
  float _33;
  _33 = _5;
  float _34;
  _34 = _6;
  float _35;
  _35 = _7;
  float _59;
  float _70;
  float _81;
  float _82;
  float _83;
  if (_18) {
    float _20 = _5 + -0.25f;
    float _21 = _6 + -0.25f;
    float _22 = _7 + -0.25f;
    float _23 = _17 * _20;
    float _24 = _17 * _21;
    float _25 = _17 * _22;
    float _26 = _23 + 0.25f;
    float _27 = _24 + 0.25f;
    float _28 = _25 + 0.25f;
    float _29 = saturate(_26);
    float _30 = saturate(_27);
    float _31 = saturate(_28);
    _33 = _29;
    _34 = _30;
    _35 = _31;
  }
  float _36 = _16.y;
  bool _37 = (_36 != 1.0f);
  _81 = _33;
  _82 = _34;
  _83 = _35;
  
  _37 = false; // disable srgb

  if (_37) {
    float _39 = _16.x;
    float _40 = log2(_33);
    float _41 = log2(_34);
    float _42 = log2(_35);
    float _43 = _40 * _39;
    float _44 = _41 * _39;
    float _45 = _42 * _39;
    float _46 = exp2(_43);
    float _47 = exp2(_44);
    float _48 = exp2(_45);
    bool _49 = (_46 < 0.0031306699384003878f);
    if (_49) {
      float _51 = _46 * 12.920000076293945f;
      _59 = _51;
    } else { 
      float _53 = log2(_46);
      float _54 = _53 * 0.4166666567325592f;
      float _55 = exp2(_54);
      float _56 = _55 * 1.0549999475479126f;
      float _57 = _56 + -0.054999999701976776f;
      _59 = _57;
    }
    bool _60 = (_47 < 0.0031306699384003878f);
    if (_60) {
      float _62 = _47 * 12.920000076293945f;
      _70 = _62;
    } else { 
      float _64 = log2(_47);
      float _65 = _64 * 0.4166666567325592f;
      float _66 = exp2(_65);
      float _67 = _66 * 1.0549999475479126f;
      float _68 = _67 + -0.054999999701976776f;
      _70 = _68;
    }
    bool _71 = (_48 < 0.0031306699384003878f);
    if (_71) {
      float _73 = _48 * 12.920000076293945f;
      _81 = _59;
      _82 = _70;
      _83 = _73;
    } else { 
      float _75 = log2(_48);
      float _76 = _75 * 0.4166666567325592f;
      float _77 = exp2(_76);
      float _78 = _77 * 1.0549999475479126f;
      float _79 = _78 + -0.054999999701976776f;
      _81 = _59;
      _82 = _70;
      _83 = _79;
    }
  }
  float _84 = _16.z;
  float _85 = _15 * -2.0f;
  float _86 = _85 + 1.0f;
  float _87 = _84 * _86;
  float _88 = _87 + _15;
  SV_Target.x = _81;
  SV_Target.y = _82;
  SV_Target.z = _83;
  SV_Target.w = _88;

  SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);
  SV_Target.rgb = renodx::color::pq::from::BT2020(SV_Target.rgb * (203.f / 10000.f));
  return SV_Target;
}
