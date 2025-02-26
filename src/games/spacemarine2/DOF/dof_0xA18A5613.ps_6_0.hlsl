Texture2D<float4> DOF_BUFFER_0 : register(t0, space2);

Texture2D<float4> DOF_BUFFER_1 : register(t1, space2);

cbuffer CB_COMMON_DYN : register(b1) {
  float CB_COMMON_DYN_029x : packoffset(c029.x);
  float CB_COMMON_DYN_029y : packoffset(c029.y);
};

cbuffer CB_PASS_DOF : register(b4) {
  float CB_PASS_DOF_001x : packoffset(c001.x);
  float CB_PASS_DOF_001y : packoffset(c001.y);
  float CB_PASS_DOF_001z : packoffset(c001.z);
  float CB_PASS_DOF_001w : packoffset(c001.w);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _8 = DOF_BUFFER_1.Sample(PS_SAMPLERS[3], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _13 = (CB_COMMON_DYN_029x) - (CB_COMMON_DYN_029y);
  float _14 = (CB_COMMON_DYN_029x) / _13;
  float _15 = (CB_COMMON_DYN_029y) * (CB_COMMON_DYN_029x);
  float _16 = -0.0f - _15;
  float _17 = (_8.x) - _14;
  float _18 = _13 * _17;
  float _19 = _16 / _18;
  float _20 = min(_19, 10000.0f);
  float4 _25 = DOF_BUFFER_0.Sample(PS_SAMPLERS[4], float2((TEXCOORD.x), (TEXCOORD.y)));
  float _30 = (CB_PASS_DOF_001x) + 0.0010000000474974513f;
  bool _31 = (_20 < _30);
  float _39 = 1.0f;
  if (_31) {
    float _35 = _20 - (CB_PASS_DOF_001y);
    float _36 = _35 * (CB_PASS_DOF_001z);
    float _37 = saturate(_36);
    _39 = _37;
  }
  float _40 = max(_39, (_25.w));
  float _41 = _40 * (CB_PASS_DOF_001w);
  float _42 = saturate(_41);
  float _43 = _42 * (_25.x);
  float _44 = _42 * (_25.y);
  float _45 = _42 * (_25.z);
  SV_Target.x = _43;
  SV_Target.y = _44;
  SV_Target.z = _45;
  SV_Target.w = _42;

  SV_Target.a = 0.f;
  return SV_Target;
}
