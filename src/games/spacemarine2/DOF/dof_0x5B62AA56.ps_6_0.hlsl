Texture2D<float4> DOF_BUFFER_0 : register(t0, space2);

cbuffer CB_SCREEN_RECT_DATA : register(b2) {
  float CB_SCREEN_RECT_DATA_000y : packoffset(c000.y);
};

cbuffer CB_PASS_DOF : register(b4) {
  float CB_PASS_DOF_000x : packoffset(c000.x);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _10 = (CB_SCREEN_RECT_DATA_000y) * (CB_PASS_DOF_000x);
  float _11 = _10 * 3.200000047683716f;
  float _12 = (TEXCOORD.y) - _11;
  float4 _14 = DOF_BUFFER_0.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), _12));
  float _19 = _10 * 1.3333333730697632f;
  float _20 = (TEXCOORD.y) - _19;
  float4 _22 = DOF_BUFFER_0.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), _20));
  float4 _28 = DOF_BUFFER_0.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _33 = _19 + (TEXCOORD.y);
  float4 _35 = DOF_BUFFER_0.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), _33));
  float _40 = _11 + (TEXCOORD.y);
  float4 _42 = DOF_BUFFER_0.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), _40));
  float _47 = (_28.x) * 0.2532773017883301f;
  float _48 = (_28.y) * 0.2532773017883301f;
  float _49 = (_28.z) * 0.2532773017883301f;
  float _50 = (_35.x) + (_22.x);
  float _51 = _50 * 0.32117074728012085f;
  float _52 = (_42.x) + (_14.x);
  float _53 = _52 * 0.05219059810042381f;
  float _54 = _51 + _47;
  float _55 = _54 + _53;
  float _56 = (_35.y) + (_22.y);
  float _57 = _56 * 0.32117074728012085f;
  float _58 = (_42.y) + (_14.y);
  float _59 = _58 * 0.05219059810042381f;
  float _60 = _57 + _48;
  float _61 = _60 + _59;
  float _62 = (_35.z) + (_22.z);
  float _63 = _62 * 0.32117074728012085f;
  float _64 = (_42.z) + (_14.z);
  float _65 = _64 * 0.05219059810042381f;
  float _66 = _63 + _49;
  float _67 = _66 + _65;
  float _68 = (_14.w) - (_28.w);
  float _69 = (_22.w) - (_28.w);
  float _70 = (_35.w) - (_28.w);
  float _71 = (_42.w) - (_28.w);
  float _72 = saturate(_68);
  float _73 = saturate(_69);
  float _74 = saturate(_70);
  float _75 = saturate(_71);
  float _76 = _72 * 0.5f;
  float _77 = _75 * 0.5f;
  float _78 = dot(float4(_76, _73, _74, _77), float4((_14.w), (_22.w), (_35.w), (_42.w)));
  float _79 = _78 + (_28.w);
  SV_Target.x = _55;
  SV_Target.y = _61;
  SV_Target.z = _67;
  SV_Target.w = _79;
  return SV_Target;
}
