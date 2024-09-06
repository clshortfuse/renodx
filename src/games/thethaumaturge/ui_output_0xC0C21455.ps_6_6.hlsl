#include "./shared.h"

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
  float _11 = TEXCOORD_1.z;
  float _12 = TEXCOORD_1.w;
  float _13 = _11 * _9;
  float _14 = _12 * _10;
  // _15 = _1;
  // _16 = _2;
  float4 _17 = t0.Sample(s0, float2(_13, _14));
  float _18 = _17.x;
  float _19 = _17.y;
  float _20 = _17.z;
  float _21 = _17.w;
  float _22 = _18 * _5;
  float _23 = _19 * _6;
  float _24 = _20 * _7;
  float _25 = _21 * _8;
  float4 _26 = cb0[0u];
  float _27 = _26.w;
  bool _28 = (_27 != 1.0f);
  float _43;
  _43 = _22;
  float _44;
  _44 = _23;
  float _45;
  _45 = _24;
  float _69;
  float _80;
  float _91;
  float _92;
  float _93;
  if (_28) {
    float _30 = _22 + -0.25f;
    float _31 = _23 + -0.25f;
    float _32 = _24 + -0.25f;
    float _33 = _27 * _30;
    float _34 = _27 * _31;
    float _35 = _27 * _32;
    float _36 = _33 + 0.25f;
    float _37 = _34 + 0.25f;
    float _38 = _35 + 0.25f;
    float _39 = saturate(_36);
    float _40 = saturate(_37);
    float _41 = saturate(_38);
    _43 = _39;
    _44 = _40;
    _45 = _41;
  }
  float _46 = _26.y;
  bool _47 = (_46 != 1.0f);
  _91 = _43;
  _92 = _44;
  _93 = _45;

  _47 = false; // disable srgb
  
  if (_47) {
    float _49 = _26.x;
    float _50 = log2(_43);
    float _51 = log2(_44);
    float _52 = log2(_45);
    float _53 = _50 * _49;
    float _54 = _51 * _49;
    float _55 = _52 * _49;
    float _56 = exp2(_53);
    float _57 = exp2(_54);
    float _58 = exp2(_55);
    bool _59 = (_56 < 0.0031306699384003878f);
    if (_59) {
      float _61 = _56 * 12.920000076293945f;
      _69 = _61;
    } else { 
      float _63 = log2(_56);
      float _64 = _63 * 0.4166666567325592f;
      float _65 = exp2(_64);
      float _66 = _65 * 1.0549999475479126f;
      float _67 = _66 + -0.054999999701976776f;
      _69 = _67;
    }
    bool _70 = (_57 < 0.0031306699384003878f);
    if (_70) {
      float _72 = _57 * 12.920000076293945f;
      _80 = _72;
    } else { 
      float _74 = log2(_57);
      float _75 = _74 * 0.4166666567325592f;
      float _76 = exp2(_75);
      float _77 = _76 * 1.0549999475479126f;
      float _78 = _77 + -0.054999999701976776f;
      _80 = _78;
    }
    bool _81 = (_58 < 0.0031306699384003878f);
    if (_81) {
      float _83 = _58 * 12.920000076293945f;
      _91 = _69;
      _92 = _80;
      _93 = _83;
    } else { 
      float _85 = log2(_58);
      float _86 = _85 * 0.4166666567325592f;
      float _87 = exp2(_86);
      float _88 = _87 * 1.0549999475479126f;
      float _89 = _88 + -0.054999999701976776f;
      _91 = _69;
      _92 = _80;
      _93 = _89;
    }
  }
  float _94 = _26.z;
  float _95 = _25 * -2.0f;
  float _96 = _95 + 1.0f;
  float _97 = _94 * _96;
  float _98 = _97 + _25;
  SV_Target.x = _91;
  SV_Target.y = _92;
  SV_Target.z = _93;
  SV_Target.w = _98;

  SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);
  SV_Target.rgb = renodx::color::pq::from::BT2020(SV_Target.rgb, 203.f);
  return SV_Target;
}
