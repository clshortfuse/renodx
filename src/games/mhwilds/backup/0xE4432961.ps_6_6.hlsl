Texture2D<float4> SrcTexture : register(t0);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_007x : packoffset(c007.x);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _15 = (HDRMapping_000x) * 0.009999999776482582f;
  float _16 = _15 * (_9.x);
  float _17 = _15 * (_9.y);
  float _18 = _15 * (_9.z);
  float _19 = _16 * 0.6131157279014587f;
  float _20 = mad(_17, 0.33951008319854736f, _19);
  float _21 = mad(_18, 0.047374799847602844f, _20);
  float _22 = _16 * 0.07019715756177902f;
  float _23 = mad(_17, 0.9163550138473511f, _22);
  float _24 = mad(_18, 0.013449129648506641f, _23);
  float _25 = _16 * 0.020619075745344162f;
  float _26 = mad(_17, 0.10957999527454376f, _25);
  float _27 = mad(_18, 0.8698007464408875f, _26);
  int _30 = ((uint)(HDRMapping_007x)) & 2;
  bool _31 = (_30 == 0);
  float _92 = _21;
  float _93 = _24;
  float _94 = _27;
  if (!_31) {
    float _34 = (HDRMapping_000z) * 9.999999747378752e-05f;
    float _35 = saturate(_34);
    float _36 = log2(_35);
    float _37 = _36 * 0.1593017578125f;
    float _38 = exp2(_37);
    float _39 = _38 * 18.8515625f;
    float _40 = _39 + 0.8359375f;
    float _41 = _38 * 18.6875f;
    float _42 = _41 + 1.0f;
    float _43 = _40 / _42;
    float _44 = log2(_43);
    float _45 = _44 * 78.84375f;
    float _46 = exp2(_45);
    float _47 = saturate(_46);
    float _49 = (HDRMapping_000w) * 9.999999747378752e-05f;
    float _50 = saturate(_49);
    float _51 = log2(_50);
    float _52 = _51 * 0.1593017578125f;
    float _53 = exp2(_52);
    float _54 = _53 * 18.8515625f;
    float _55 = _54 + 0.8359375f;
    float _56 = _53 * 18.6875f;
    float _57 = _56 + 1.0f;
    float _58 = _55 / _57;
    float _59 = log2(_58);
    float _60 = _59 * 78.84375f;
    float _61 = exp2(_60);
    float _62 = saturate(_61);
    float _63 = _47 - _62;
    float _64 = _21 / _47;
    float _65 = _24 / _47;
    float _66 = _27 / _47;
    float _67 = saturate(_64);
    float _68 = saturate(_65);
    float _69 = saturate(_66);
    float _70 = _67 * _47;
    float _71 = _68 * _47;
    float _72 = _69 * _47;
    float _73 = _67 + _67;
    float _74 = 2.0f - _73;
    float _75 = _74 * _63;
    float _76 = _75 + _70;
    float _77 = _76 * _67;
    float _78 = _68 + _68;
    float _79 = 2.0f - _78;
    float _80 = _79 * _63;
    float _81 = _80 + _71;
    float _82 = _81 * _68;
    float _83 = _69 + _69;
    float _84 = 2.0f - _83;
    float _85 = _84 * _63;
    float _86 = _85 + _72;
    float _87 = _86 * _69;
    float _88 = min(_77, _21);
    float _89 = min(_82, _24);
    float _90 = min(_87, _27);
    _92 = _88;
    _93 = _89;
    _94 = _90;
  }
  SV_Target.x = _92;
  SV_Target.y = _93;
  SV_Target.z = _94;
  SV_Target.w = 1.0f;
  return SV_Target;
}
