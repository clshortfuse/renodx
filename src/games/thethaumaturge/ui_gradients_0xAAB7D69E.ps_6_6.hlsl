#include "./shared.h"

Texture2D<float4> t0 : register(t0);

cbuffer _cb0 : register(b0) {
  float4 cb0[7] : packoffset(c0);
};
cbuffer _cb1 : register(b1) {
  float4 cb1[11] : packoffset(c0);
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
  float4 _17 = cb1[4u];
  float _18 = _17.y;
  float _19 = _15 * _18;
  float _20 = _16 * _18;
  float _21 = _17.z;
  float _22 = _19 - _21;
  float _23 = _20 - _21;
  float4 _24 = cb1[5u];
  float _25 = _24.x;
  float _26 = _24.y;
  float _27 = dot(float2(_25, _26), float2(_22, _23));
  float _28 = _24.z;
  float _29 = _24.w;
  float _30 = dot(float2(_28, _29), float2(_22, _23));
  float _31 = _27 + 0.5f;
  float _32 = _30 + 0.5f;
  // _33 = _1;
  // _34 = _2;
  float4 _35 = t0.Sample(s0, float2(_31, _32));
  float _36 = _35.x;
  float _37 = _35.w;
  float4 _38 = cb1[6u];
  float _39 = _38.x;
  float _40 = _38.y;
  float _41 = _38.z;
  float _42 = _39 * _36;
  float _43 = _40 * _36;
  float _44 = _41 * _36;
  float _45 = _38.w;
  float4 _46 = cb1[7u];
  float _47 = _46.x;
  float _48 = _46.y;
  float _49 = _46.z;
  float _50 = _47 - _42;
  float _51 = _48 - _43;
  float _52 = _49 - _44;
  float _53 = _50 * _45;
  float _54 = _51 * _45;
  float _55 = _52 * _45;
  float _56 = _53 + _42;
  float _57 = _54 + _43;
  float _58 = _55 + _44;
  float _59 = _46.w;
  float _60 = _59 * _37;
  float _61 = saturate(_60);
  float _62 = max(_56, 0.0f);
  float _63 = max(_57, 0.0f);
  float _64 = max(_58, 0.0f);
  float _65 = _62 * _7;
  float _66 = _63 * _8;
  float _67 = _64 * _9;
  float _68 = _61 * _10;
  float4 _69 = cb0[5u];
  float _70 = _69.x;
  bool _71 = (_70 != 0.0f);
  float _72 = _68 * 0.44999998807907104f;
  float _73 = _71 ? _72 : _68;
  float4 _74 = cb0[2u];
  float _75 = _74.w;
  bool _76 = (_75 != 1.0f);
  float _91;
  _91 = _65;
  float _92;
  _92 = _66;
  float _93;
  _93 = _67;
  float _117;
  float _128;
  float _139;
  float _140;
  float _141;
  if (_76) {
    float _78 = _65 + -0.25f;
    float _79 = _66 + -0.25f;
    float _80 = _67 + -0.25f;
    float _81 = _75 * _78;
    float _82 = _75 * _79;
    float _83 = _75 * _80;
    float _84 = _81 + 0.25f;
    float _85 = _82 + 0.25f;
    float _86 = _83 + 0.25f;
    float _87 = saturate(_84);
    float _88 = saturate(_85);
    float _89 = saturate(_86);
    _91 = _87;
    _92 = _88;
    _93 = _89;
  }
  float _94 = _74.y;
  bool _95 = (_94 != 1.0f);
  _139 = _91;
  _140 = _92;
  _141 = _93;

  _95 = false; // disable srgb

  if (_95) {
    float _97 = _74.x;
    float _98 = log2(_91);
    float _99 = log2(_92);
    float _100 = log2(_93);
    float _101 = _98 * _97;
    float _102 = _99 * _97;
    float _103 = _100 * _97;
    float _104 = exp2(_101);
    float _105 = exp2(_102);
    float _106 = exp2(_103);
    bool _107 = (_104 < 0.0031306699384003878f);
    if (_107) {
      float _109 = _104 * 12.920000076293945f;
      _117 = _109;
    } else { 
      float _111 = log2(_104);
      float _112 = _111 * 0.4166666567325592f;
      float _113 = exp2(_112);
      float _114 = _113 * 1.0549999475479126f;
      float _115 = _114 + -0.054999999701976776f;
      _117 = _115;
    }
    bool _118 = (_105 < 0.0031306699384003878f);
    if (_118) {
      float _120 = _105 * 12.920000076293945f;
      _128 = _120;
    } else { 
      float _122 = log2(_105);
      float _123 = _122 * 0.4166666567325592f;
      float _124 = exp2(_123);
      float _125 = _124 * 1.0549999475479126f;
      float _126 = _125 + -0.054999999701976776f;
      _128 = _126;
    }
    bool _129 = (_106 < 0.0031306699384003878f);
    if (_129) {
      float _131 = _106 * 12.920000076293945f;
      _139 = _117;
      _140 = _128;
      _141 = _131;
    } else { 
      float _133 = log2(_106);
      float _134 = _133 * 0.4166666567325592f;
      float _135 = exp2(_134);
      float _136 = _135 * 1.0549999475479126f;
      float _137 = _136 + -0.054999999701976776f;
      _139 = _117;
      _140 = _128;
      _141 = _137;
    }
  }
  SV_Target.x = _139;
  SV_Target.y = _140;
  SV_Target.z = _141;
  SV_Target.w = _73;

  SV_Target.rgb = renodx::color::bt2020::from::BT709(SV_Target.rgb);
  SV_Target.rgb = renodx::color::pq::Encode(SV_Target.rgb, 203.f);
  return SV_Target;
}
