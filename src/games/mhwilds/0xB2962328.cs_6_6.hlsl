RWTexture3D<float> OutLUT : register(u0);

[numthreads(8, 8, 8)]
void main(uint3 SV_DispatchThreadID: SV_DispatchThreadID) {
  float _5 = float((uint)(SV_DispatchThreadID.x));
  float _6 = float((uint)(SV_DispatchThreadID.y));
  float _7 = float((uint)(SV_DispatchThreadID.z));
  float _8 = _5 * 0.01587301678955555f;
  float _9 = _6 * 0.01587301678955555f;
  float _10 = _7 * 0.01587301678955555f;
  bool _11 = !(_8 <= -0.3013699948787689f);
  float _24;
  float _38;
  float _52;
  if (!_11) {
    float _13 = _5 * 0.2780952751636505f;
    float _14 = _13 + -8.720000267028809f;
    float _15 = exp2(_14);
    float _16 = _15 + -3.0517578125e-05f;
    _24 = _16;
  } else {
    bool _18 = (_8 < 1.468000054359436f);
    _24 = 65504.0f;
    if (_18) {
      float _20 = _5 * 0.2780952751636505f;
      float _21 = _20 + -9.720000267028809f;
      float _22 = exp2(_21);
      _24 = _22;
    }
  }
  bool _25 = !(_9 <= -0.3013699948787689f);
  if (!_25) {
    float _27 = _6 * 0.2780952751636505f;
    float _28 = _27 + -8.720000267028809f;
    float _29 = exp2(_28);
    float _30 = _29 + -3.0517578125e-05f;
    _38 = _30;
  } else {
    bool _32 = (_9 < 1.468000054359436f);
    _38 = 65504.0f;
    if (_32) {
      float _34 = _6 * 0.2780952751636505f;
      float _35 = _34 + -9.720000267028809f;
      float _36 = exp2(_35);
      _38 = _36;
    }
  }
  bool _39 = !(_10 <= -0.3013699948787689f);
  if (!_39) {
    float _41 = _7 * 0.2780952751636505f;
    float _42 = _41 + -8.720000267028809f;
    float _43 = exp2(_42);
    float _44 = _43 + -3.0517578125e-05f;
    _52 = _44;
  } else {
    bool _46 = (_10 < 1.468000054359436f);
    _52 = 65504.0f;
    if (_46) {
      float _48 = _7 * 0.2780952751636505f;
      float _49 = _48 + -9.720000267028809f;
      float _50 = exp2(_49);
      _52 = _50;
    }
  }
  float _53 = _24 * 0.6131157279014587f;
  float _54 = mad(_38, 0.33951008319854736f, _53);
  float _55 = mad(_52, 0.047374799847602844f, _54);
  float _56 = _24 * 0.07019715756177902f;
  float _57 = mad(_38, 0.9163550138473511f, _56);
  float _58 = mad(_52, 0.013449129648506641f, _57);
  float _59 = _24 * 0.020619075745344162f;
  float _60 = mad(_38, 0.10957999527454376f, _59);
  float _61 = mad(_52, 0.8698007464408875f, _60);
  float _62 = saturate(_55);
  float _63 = saturate(_58);
  float _64 = saturate(_61);
  float _65 = log2(_62);
  float _66 = log2(_63);
  float _67 = log2(_64);
  float _68 = _65 * 0.012683313339948654f;
  float _69 = _66 * 0.012683313339948654f;
  float _70 = _67 * 0.012683313339948654f;
  float _71 = exp2(_68);
  float _72 = exp2(_69);
  float _73 = exp2(_70);
  float _74 = _71 + -0.8359375f;
  float _75 = _72 + -0.8359375f;
  float _76 = _73 + -0.8359375f;
  float _77 = max(0.0f, _74);
  float _78 = max(0.0f, _75);
  float _79 = max(0.0f, _76);
  float _80 = _71 * 18.6875f;
  float _81 = _72 * 18.6875f;
  float _82 = _73 * 18.6875f;
  float _83 = 18.8515625f - _80;
  float _84 = 18.8515625f - _81;
  float _85 = 18.8515625f - _82;
  float _86 = _77 / _83;
  float _87 = _78 / _84;
  float _88 = _79 / _85;
  float _89 = log2(_86);
  float _90 = log2(_87);
  float _91 = log2(_88);
  float _92 = _89 * 6.277394771575928f;
  float _93 = _90 * 6.277394771575928f;
  float _94 = _91 * 6.277394771575928f;
  float _95 = exp2(_92);
  float _96 = exp2(_93);
  float _97 = exp2(_94);
  float _98 = _96 * 100.0f;
  float _99 = _97 * 100.0f;
  float _100 = _95 * 166.04910278320312f;
  float _101 = mad(-0.5876399874687195f, _98, _100);
  float _102 = mad(-0.07285170257091522f, _99, _101);
  float _103 = _95 * -12.454999923706055f;
  float _104 = mad(1.1328999996185303f, _98, _103);
  float _105 = mad(-0.00834800023585558f, _99, _104);
  float _106 = _95 * -1.8150999546051025f;
  float _107 = mad(-0.10057900100946426f, _98, _106);
  float _108 = mad(1.1187299489974976f, _99, _107);
  OutLUT[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4(_102, _105, _108, 1.0f);
}
