#include "./shared.h"

Texture2D<float4> t31_space1 : register(t31, space1);

SamplerState s2_space1 : register(s2, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _10 = SV_Position.x * 0.3333333432674408f;
  float _11 = -0.0f - _10;
  bool _12 = (_10 >= _11);
  float _13 = abs(_10);
  float _14 = frac(_13);
  float _15 = -0.0f - _14;
  float _16 = select(_12, _14, _15);
  float _17 = _16 * 3.0f;
  float _18 = _17 + 1.0f;
  float _19 = SV_Position.y * 0.3333333432674408f;
  float _20 = -0.0f - _19;
  bool _21 = (_19 >= _20);
  float _22 = abs(_19);
  float _23 = frac(_22);
  float _24 = -0.0f - _23;
  float _25 = select(_21, _23, _24);
  float _26 = _25 * 9.0f;
  float _27 = _18 + _26;
  float _28 = _27 * 0.1111111119389534f;
  float _30;
  int _31;
  _30 = 0.0f;
  _31 = 0;
  while(true) {
    float _32 = float((int)(_31));
    float _33 = _32 + _28;
    float _34 = _33 * TEXCOORD_1.z;
    float _35 = _33 * TEXCOORD_1.w;
    float _36 = _34 + TEXCOORD_1.x;
    float _37 = _35 + TEXCOORD_1.y;
    float4 _38 = t31_space1.Sample(s2_space1, float2(_36, _37));
    float _40 = _32 + 1.0f;
    float _41 = _40 * 0.05999999865889549f;
    float _42 = 1.5f - _41;
    float _43 = _38.x * _42;
    float _44 = _43 + _30;
    int _45 = _31 + 1;
    bool _46 = (_45 == 15);
    if (!_46) {
      _30 = _44;
      _31 = _45;
      continue;
    }
    float4 _49 = t31_space1.Sample(s2_space1, float2(TEXCOORD_1.x, TEXCOORD_1.y));
    float _51 = _49.x * 1.5f;
    float _52 = _51 + _44;
    float _53 = _52 * 0.0595238134264946f;
    float _54 = _49.x * 0.10000000149011612f;
    float _55 = max(_54, _53);
    float _56 = dot(float2(TEXCOORD.x, TEXCOORD.y), float2(TEXCOORD.x, TEXCOORD.y));
    float _57 = sqrt(_56);
    float _58 = 1.0f - _57;
    // float _59 = _55 * 0.5f;
    float _59 = clamp(_55 * 0.5f, 0.0f, 0.5f);
    float _60 = _59 * _58;
    
    // float _61 = clamp(_60, 0.0f, 0.5f);
    float _61 = max(_60, 0.0f);
    
    float _62 = log2(_61);
    float _63 = _62 * 0.25f;
    float _64 = exp2(_63);
    SV_Target.x = _64;
    SV_Target.y = _64;
    SV_Target.z = _64;
    SV_Target.w = 1.0f;
    break;
  }
  return SV_Target;
}
