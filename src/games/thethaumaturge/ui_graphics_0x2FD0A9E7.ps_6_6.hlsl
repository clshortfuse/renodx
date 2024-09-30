#include "./shared.h"

Texture2D<float4> t0 : register(t0);

cbuffer _cb0 : register(b0) {
  float4 cb0[7] : packoffset(c0);
};
cbuffer _cb1 : register(b1) {
  float4 cb1[5] : packoffset(c0);
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
  // cbuffer _3 = cb1; // index=1
  // cbuffer _4 = cb0; // index=0
  // _5 = _3;
  // _6 = _4;
  float _7 = COLOR.x;
  float _8 = COLOR.y;
  float _9 = COLOR.z;
  float _10 = COLOR.w;
  float _11 = TEXCOORD_1.x;
  float _12 = TEXCOORD_1.y;
  float _13 = TEXCOORD_1.z;
  float _14 = TEXCOORD_1.w;
  float _15 = _13 * _11;
  float _16 = _14 * _12;
  float _17 = _16 * 0.5759443044662476f;
  float _18 = _16 * 0.008232660591602325f;
  float _19 = 0.9301109910011292f - _17;
  float _20 = _18 + 0.01850000023841858f;
  float4 _21 = cb1[1u];
  float _22 = _21.x;
  float _23 = _21.y;
  float _24 = _21.z;
  float _25 = _21.w;
  float _26 = _23 - _19;
  float _27 = _25 - _20;
  float _28 = _26 * _22;
  float _29 = _24 * _22;
  float _30 = _27 * _22;
  float _31 = _28 + _19;
  float _32 = _30 + _20;
  // _33 = _1;
  // _34 = _2;
  float4 _35 = t0.Sample(s0, float2(_15, _16));
  float _36 = _35.x;
  float _37 = saturate(_36);
  float _38 = max(_31, 0.0f);
  float _39 = max(_29, 0.0f);
  float _40 = max(_32, 0.0f);
  float _41 = _38 * _7;
  float _42 = _39 * _8;
  float _43 = _40 * _9;
  float _44 = _37 * _10;
  float4 _45 = cb0[5u];
  float _46 = _45.x;
  bool _47 = (_46 != 0.0f);
  float _48 = _44 * 0.44999998807907104f;
  float _49 = _47 ? _48 : _44;
  float4 _50 = cb0[2u];
  float _51 = _50.w;
  bool _52 = (_51 != 1.0f);
  float _67;
  _67 = _41;
  float _68;
  _68 = _42;
  float _69;
  _69 = _43;
  float _93;
  float _104;
  float _115;
  float _116;
  float _117;
  if (_52) {
    float _54 = _41 + -0.25f;
    float _55 = _42 + -0.25f;
    float _56 = _43 + -0.25f;
    float _57 = _51 * _54;
    float _58 = _51 * _55;
    float _59 = _51 * _56;
    float _60 = _57 + 0.25f;
    float _61 = _58 + 0.25f;
    float _62 = _59 + 0.25f;
    float _63 = saturate(_60);
    float _64 = saturate(_61);
    float _65 = saturate(_62);
    _67 = _63;
    _68 = _64;
    _69 = _65;
  }
  float _70 = _50.y;
  bool _71 = (_70 != 1.0f);
  _115 = _67;
  _116 = _68;
  _117 = _69;

  _71 = false; // disable srgb

  if (_71) {
    float _73 = _50.x;
    float _74 = log2(_67);
    float _75 = log2(_68);
    float _76 = log2(_69);
    float _77 = _74 * _73;
    float _78 = _75 * _73;
    float _79 = _76 * _73;
    float _80 = exp2(_77);
    float _81 = exp2(_78);
    float _82 = exp2(_79);
    bool _83 = (_80 < 0.0031306699384003878f);
    if (_83) {
      float _85 = _80 * 12.920000076293945f;
      _93 = _85;
    } else { 
      float _87 = log2(_80);
      float _88 = _87 * 0.4166666567325592f;
      float _89 = exp2(_88);
      float _90 = _89 * 1.0549999475479126f;
      float _91 = _90 + -0.054999999701976776f;
      _93 = _91;
    }
    bool _94 = (_81 < 0.0031306699384003878f);
    if (_94) {
      float _96 = _81 * 12.920000076293945f;
      _104 = _96;
    } else { 
      float _98 = log2(_81);
      float _99 = _98 * 0.4166666567325592f;
      float _100 = exp2(_99);
      float _101 = _100 * 1.0549999475479126f;
      float _102 = _101 + -0.054999999701976776f;
      _104 = _102;
    }
    bool _105 = (_82 < 0.0031306699384003878f);
    if (_105) {
      float _107 = _82 * 12.920000076293945f;
      _115 = _93;
      _116 = _104;
      _117 = _107;
    } else { 
      float _109 = log2(_82);
      float _110 = _109 * 0.4166666567325592f;
      float _111 = exp2(_110);
      float _112 = _111 * 1.0549999475479126f;
      float _113 = _112 + -0.054999999701976776f;
      _115 = _93;
      _116 = _104;
      _117 = _113;
    }
  }
  SV_Target.x = _115;
  SV_Target.y = _116;
  SV_Target.z = _117;
  SV_Target.w = _49;

  SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);
  SV_Target.rgb = renodx::color::pq::Encode(SV_Target.rgb, 203.f);
  return SV_Target;
}
