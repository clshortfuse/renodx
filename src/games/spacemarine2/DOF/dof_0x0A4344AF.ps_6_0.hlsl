Texture2D<float4> FILL_COLOR : register(t0, space2);

cbuffer CB_COMMON : register(b0) {
  float CB_COMMON_041x : packoffset(c041.x);
  float CB_COMMON_041y : packoffset(c041.y);
  float CB_COMMON_041z : packoffset(c041.z);
};

cbuffer CB_PS_PASS_FILL : register(b4) {
  float CB_PS_PASS_FILL_002x : packoffset(c002.x);
  float CB_PS_PASS_FILL_002y : packoffset(c002.y);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _9 = (CB_PS_PASS_FILL_002x) * (TEXCOORD.x);
  float _10 = (CB_PS_PASS_FILL_002y) * (TEXCOORD.y);
  float _11 = _9 + 0.5f;
  float _12 = _10 + 0.5f;
  float _13 = floor(_11);
  float _14 = floor(_12);
  float _15 = frac(_11);
  float _16 = frac(_12);
  float _17 = _15 * _15;
  float _18 = _16 * _16;
  float _19 = _17 * _15;
  float _20 = _18 * _16;
  float _21 = _15 * 6.0f;
  float _22 = _16 * 6.0f;
  float _23 = _21 + -15.0f;
  float _24 = _22 + -15.0f;
  float _25 = _23 * _15;
  float _26 = _24 * _16;
  float _27 = _25 + 10.0f;
  float _28 = _26 + 10.0f;
  float _29 = _19 * _27;
  float _30 = _20 * _28;
  float _31 = _13 + -0.5f;
  float _32 = _31 + _29;
  float _33 = _14 + -0.5f;
  float _34 = _33 + _30;
  float _35 = _32 / (CB_PS_PASS_FILL_002x);
  float _36 = _34 / (CB_PS_PASS_FILL_002y);
  float4 _38 = FILL_COLOR.Sample(PS_SAMPLERS[4], float2(_35, _36));
  float _47 = log2((_38.x));
  float _48 = log2((_38.y));
  float _49 = log2((_38.z));
  float _50 = _47 * (CB_COMMON_041x);
  float _51 = _48 * (CB_COMMON_041x);
  float _52 = _49 * (CB_COMMON_041x);
  float _53 = exp2(_50);
  float _54 = exp2(_51);
  float _55 = exp2(_52);
  float _56 = _53 * (CB_COMMON_041y);
  float _57 = _54 * (CB_COMMON_041y);
  float _58 = _55 * (CB_COMMON_041y);
  float _59 = _56 + (CB_COMMON_041z);
  float _60 = _57 + (CB_COMMON_041z);
  float _61 = _58 + (CB_COMMON_041z);
  SV_Target.x = _59;
  SV_Target.y = _60;
  SV_Target.z = _61;
  SV_Target.w = (_38.w);

  SV_Target = _38;
  return SV_Target;
}
