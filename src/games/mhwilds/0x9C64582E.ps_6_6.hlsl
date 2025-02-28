Texture2D<float4> SrcTexture : register(t0);

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _11 = (_7.x) * 0.6131157279014587f;
  float _12 = mad((_7.y), 0.33951008319854736f, _11);
  float _13 = mad((_7.z), 0.047374799847602844f, _12);
  float _14 = (_7.x) * 0.07019715756177902f;
  float _15 = mad((_7.y), 0.9163550138473511f, _14);
  float _16 = mad((_7.z), 0.013449129648506641f, _15);
  float _17 = (_7.x) * 0.020619075745344162f;
  float _18 = mad((_7.y), 0.10957999527454376f, _17);
  float _19 = mad((_7.z), 0.8698007464408875f, _18);
  float _20 = saturate(_13);
  float _21 = saturate(_16);
  float _22 = saturate(_19);
  float _23 = log2(_20);
  float _24 = log2(_21);
  float _25 = log2(_22);
  float _26 = _23 * 0.012683313339948654f;
  float _27 = _24 * 0.012683313339948654f;
  float _28 = _25 * 0.012683313339948654f;
  float _29 = exp2(_26);
  float _30 = exp2(_27);
  float _31 = exp2(_28);
  float _32 = _29 + -0.8359375f;
  float _33 = _30 + -0.8359375f;
  float _34 = _31 + -0.8359375f;
  float _35 = max(0.0f, _32);
  float _36 = max(0.0f, _33);
  float _37 = max(0.0f, _34);
  float _38 = _29 * 18.6875f;
  float _39 = _30 * 18.6875f;
  float _40 = _31 * 18.6875f;
  float _41 = 18.8515625f - _38;
  float _42 = 18.8515625f - _39;
  float _43 = 18.8515625f - _40;
  float _44 = _35 / _41;
  float _45 = _36 / _42;
  float _46 = _37 / _43;
  float _47 = log2(_44);
  float _48 = log2(_45);
  float _49 = log2(_46);
  float _50 = _47 * 6.277394771575928f;
  float _51 = _48 * 6.277394771575928f;
  float _52 = _49 * 6.277394771575928f;
  float _53 = exp2(_50);
  float _54 = exp2(_51);
  float _55 = exp2(_52);
  float _56 = _54 * 100.0f;
  float _57 = _55 * 100.0f;
  float _58 = _53 * 166.04910278320312f;
  float _59 = mad(-0.5876399874687195f, _56, _58);
  float _60 = mad(-0.07285170257091522f, _57, _59);
  float _61 = _53 * -12.454999923706055f;
  float _62 = mad(1.1328999996185303f, _56, _61);
  float _63 = mad(-0.00834800023585558f, _57, _62);
  float _64 = _53 * -1.8150999546051025f;
  float _65 = mad(-0.10057900100946426f, _56, _64);
  float _66 = mad(1.1187299489974976f, _57, _65);
  SV_Target.x = _60;
  SV_Target.y = _63;
  SV_Target.z = _66;
  SV_Target.w = 1.0f;
  return SV_Target;
}
