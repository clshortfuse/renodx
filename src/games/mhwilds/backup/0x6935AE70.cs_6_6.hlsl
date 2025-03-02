RWTexture3D<float4> OutLUT : register(u0);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_007x : packoffset(c007.x);
};

[numthreads(8, 8, 8)]
void main(uint3 SV_DispatchThreadID: SV_DispatchThreadID) {
  float _7 = float((uint)(SV_DispatchThreadID.x));
  float _8 = float((uint)(SV_DispatchThreadID.y));
  float _9 = float((uint)(SV_DispatchThreadID.z));
  float _10 = _7 * 0.01587301678955555f;
  float _11 = _8 * 0.01587301678955555f;
  float _12 = _9 * 0.01587301678955555f;
  bool _13 = !(_10 <= -0.3013699948787689f);
  float _26;
  float _40;
  float _54;
  float _129;
  float _130;
  float _131;
  if (!_13) {
    float _15 = _7 * 0.2780952751636505f;
    float _16 = _15 + -8.720000267028809f;
    float _17 = exp2(_16);
    float _18 = _17 + -3.0517578125e-05f;
    _26 = _18;
  } else {
    bool _20 = (_10 < 1.468000054359436f);
    _26 = 65504.0f;
    if (_20) {
      float _22 = _7 * 0.2780952751636505f;
      float _23 = _22 + -9.720000267028809f;
      float _24 = exp2(_23);
      _26 = _24;
    }
  }
  bool _27 = !(_11 <= -0.3013699948787689f);
  if (!_27) {
    float _29 = _8 * 0.2780952751636505f;
    float _30 = _29 + -8.720000267028809f;
    float _31 = exp2(_30);
    float _32 = _31 + -3.0517578125e-05f;
    _40 = _32;
  } else {
    bool _34 = (_11 < 1.468000054359436f);
    _40 = 65504.0f;
    if (_34) {
      float _36 = _8 * 0.2780952751636505f;
      float _37 = _36 + -9.720000267028809f;
      float _38 = exp2(_37);
      _40 = _38;
    }
  }
  bool _41 = !(_12 <= -0.3013699948787689f);
  if (!_41) {
    float _43 = _9 * 0.2780952751636505f;
    float _44 = _43 + -8.720000267028809f;
    float _45 = exp2(_44);
    float _46 = _45 + -3.0517578125e-05f;
    _54 = _46;
  } else {
    bool _48 = (_12 < 1.468000054359436f);
    _54 = 65504.0f;
    if (_48) {
      float _50 = _9 * 0.2780952751636505f;
      float _51 = _50 + -9.720000267028809f;
      float _52 = exp2(_51);
      _54 = _52;
    }
  }
  float _55 = _26 * 0.6131157279014587f;
  float _56 = mad(_40, 0.33951008319854736f, _55);
  float _57 = mad(_54, 0.047374799847602844f, _56);
  float _58 = _26 * 0.07019715756177902f;
  float _59 = mad(_40, 0.9163550138473511f, _58);
  float _60 = mad(_54, 0.013449129648506641f, _59);
  float _61 = _26 * 0.020619075745344162f;
  float _62 = mad(_40, 0.10957999527454376f, _61);
  float _63 = mad(_54, 0.8698007464408875f, _62);
  int _66 = ((uint)(HDRMapping_007x)) & 2;
  bool _67 = (_66 == 0);
  _129 = _57;
  _130 = _60;
  _131 = _63;
  if (!_67) {
    float _71 = (HDRMapping_000z) * 9.999999747378752e-05f;
    float _72 = saturate(_71);
    float _73 = log2(_72);
    float _74 = _73 * 0.1593017578125f;
    float _75 = exp2(_74);
    float _76 = _75 * 18.8515625f;
    float _77 = _76 + 0.8359375f;
    float _78 = _75 * 18.6875f;
    float _79 = _78 + 1.0f;
    float _80 = _77 / _79;
    float _81 = log2(_80);
    float _82 = _81 * 78.84375f;
    float _83 = exp2(_82);
    float _84 = saturate(_83);
    float _86 = (HDRMapping_000w) * 9.999999747378752e-05f;
    float _87 = saturate(_86);
    float _88 = log2(_87);
    float _89 = _88 * 0.1593017578125f;
    float _90 = exp2(_89);
    float _91 = _90 * 18.8515625f;
    float _92 = _91 + 0.8359375f;
    float _93 = _90 * 18.6875f;
    float _94 = _93 + 1.0f;
    float _95 = _92 / _94;
    float _96 = log2(_95);
    float _97 = _96 * 78.84375f;
    float _98 = exp2(_97);
    float _99 = saturate(_98);
    float _100 = _84 - _99;
    float _101 = _57 / _84;
    float _102 = _60 / _84;
    float _103 = _63 / _84;
    float _104 = saturate(_101);
    float _105 = saturate(_102);
    float _106 = saturate(_103);
    float _107 = _104 * _84;
    float _108 = _105 * _84;
    float _109 = _106 * _84;
    float _110 = _104 + _104;
    float _111 = 2.0f - _110;
    float _112 = _111 * _100;
    float _113 = _112 + _107;
    float _114 = _113 * _104;
    float _115 = _105 + _105;
    float _116 = 2.0f - _115;
    float _117 = _116 * _100;
    float _118 = _117 + _108;
    float _119 = _118 * _105;
    float _120 = _106 + _106;
    float _121 = 2.0f - _120;
    float _122 = _121 * _100;
    float _123 = _122 + _109;
    float _124 = _123 * _106;
    float _125 = min(_114, _57);
    float _126 = min(_119, _60);
    float _127 = min(_124, _63);
    _129 = _125;
    _130 = _126;
    _131 = _127;
  }
  OutLUT[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4(_129, _130, _131, 1.0f);
}
