Texture2D<float4> tTex : register(t0);

cbuffer CBImagePlane : register(b0) {
  float CBImagePlane_000x : packoffset(c000.x);
  float CBImagePlane_000y : packoffset(c000.y);
  float CBImagePlane_000z : packoffset(c000.z);
  float CBImagePlane_002x : packoffset(c002.x);
  float CBImagePlane_002y : packoffset(c002.y);
  float CBImagePlane_002z : packoffset(c002.z);
  float CBImagePlane_002w : packoffset(c002.w);
};

SamplerState BilinearClamp : register(s5, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _9 = (CBImagePlane_002z) * (TEXCOORD.x);
  float _11 = _9 + (CBImagePlane_002x);
  float _13 = (CBImagePlane_002w) * (TEXCOORD.y);
  float _15 = _13 + (CBImagePlane_002y);
  float4 _18 = tTex.Sample(BilinearClamp, float2(_11, _15));
  float _26 = (CBImagePlane_000x) * (_18.x);
  float _27 = (CBImagePlane_000y) * (_18.y);
  float _28 = (CBImagePlane_000z) * (_18.z);
  float _29 = saturate(_26);
  float _30 = saturate(_27);
  float _31 = saturate(_28);
  float _32 = log2(_29);
  float _33 = log2(_30);
  float _34 = log2(_31);
  float _35 = _32 * 0.012683313339948654f;
  float _36 = _33 * 0.012683313339948654f;
  float _37 = _34 * 0.012683313339948654f;
  float _38 = exp2(_35);
  float _39 = exp2(_36);
  float _40 = exp2(_37);
  float _41 = _38 + -0.8359375f;
  float _42 = _39 + -0.8359375f;
  float _43 = _40 + -0.8359375f;
  float _44 = max(0.0f, _41);
  float _45 = max(0.0f, _42);
  float _46 = max(0.0f, _43);
  float _47 = _38 * 18.6875f;
  float _48 = _39 * 18.6875f;
  float _49 = _40 * 18.6875f;
  float _50 = 18.8515625f - _47;
  float _51 = 18.8515625f - _48;
  float _52 = 18.8515625f - _49;
  float _53 = _44 / _50;
  float _54 = _45 / _51;
  float _55 = _46 / _52;
  float _56 = log2(_53);
  float _57 = log2(_54);
  float _58 = log2(_55);
  float _59 = _56 * 6.277394771575928f;
  float _60 = _57 * 6.277394771575928f;
  float _61 = _58 * 6.277394771575928f;
  float _62 = exp2(_59);
  float _63 = exp2(_60);
  float _64 = exp2(_61);
  float _65 = _63 * 100.0f;
  float _66 = _64 * 100.0f;
  float _67 = _62 * 166.04910278320312f;
  float _68 = mad(-0.5876399874687195f, _65, _67);
  float _69 = mad(-0.07285170257091522f, _66, _68);
  float _70 = _62 * -12.454999923706055f;
  float _71 = mad(1.1328999996185303f, _65, _70);
  float _72 = mad(-0.00834800023585558f, _66, _71);
  float _73 = _62 * -1.8150999546051025f;
  float _74 = mad(-0.10057900100946426f, _65, _73);
  float _75 = mad(1.1187299489974976f, _66, _74);
  SV_Target.x = _69;
  SV_Target.y = _72;
  SV_Target.z = _75;
  SV_Target.w = 1.0f;
  return SV_Target;
}
