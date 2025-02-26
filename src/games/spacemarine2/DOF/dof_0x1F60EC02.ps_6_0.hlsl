Texture2D<float4> COMBINE_BACKBUFFER : register(t0, space2);

Texture2D<float4> COMBINE_BLURRED_BB : register(t1, space2);

Texture2D<float4> COMBINE_MASK : register(t2, space2);

cbuffer CB_PASS_COMBINE_EFFECTS : register(b4) {
  float CB_PASS_COMBINE_EFFECTS_002z : packoffset(c002.z);
  float CB_PASS_COMBINE_EFFECTS_002w : packoffset(c002.w);
  float CB_PASS_COMBINE_EFFECTS_003x : packoffset(c003.x);
  float CB_PASS_COMBINE_EFFECTS_003y : packoffset(c003.y);
  float CB_PASS_COMBINE_EFFECTS_003z : packoffset(c003.z);
  float CB_PASS_COMBINE_EFFECTS_003w : packoffset(c003.w);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _8 = COMBINE_BACKBUFFER.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _12 = (TEXCOORD.x) + -0.5f;
  float _13 = (TEXCOORD.y) + -0.5f;
  float _14 = dot(float2(_12, _13), float2(_12, _13));
  float4 _18 = COMBINE_MASK.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _22 = (CB_PASS_COMBINE_EFFECTS_003w) * (_18.w);
  float _23 = 1.0f - _22;
  float4 _24 = COMBINE_BLURRED_BB.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _28 = (CB_PASS_COMBINE_EFFECTS_002w) * _14;
  float _29 = _28 * _28;
  float _30 = _29 * (CB_PASS_COMBINE_EFFECTS_002z);
  float _32 = (CB_PASS_COMBINE_EFFECTS_003z) + _30;
  float _33 = _32 * _23;
  float _34 = saturate(_33);
  float _35 = (_24.x) - (_8.x);
  float _36 = (_24.y) - (_8.y);
  float _37 = (_24.z) - (_8.z);
  float _38 = _34 * _35;
  float _39 = _34 * _36;
  float _40 = _34 * _37;
  float _41 = _38 + (_8.x);
  float _42 = _39 + (_8.y);
  float _43 = _40 + (_8.z);
  float _46 = (CB_PASS_COMBINE_EFFECTS_003y) * _14;
  float _47 = sin(_46);
  float _48 = min(_47, (CB_PASS_COMBINE_EFFECTS_003x));
  float _49 = 1.0f - _48;
  float _50 = _49 * _41;
  float _51 = _49 * _42;
  float _52 = _49 * _43;
  SV_Target.x = _50;
  SV_Target.y = _51;
  SV_Target.z = _52;
  SV_Target.w = 0.0f;
  return SV_Target;
}
