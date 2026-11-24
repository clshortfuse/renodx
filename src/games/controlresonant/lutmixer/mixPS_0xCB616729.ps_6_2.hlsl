#include "./lutmixer.hlsli"

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  uint _3;
  float _19;
  float _20;
  float _21;
  float _46;
  float _47;
  float _48;
  float _69;
  float _70;
  float _71;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _61;
  float _74;
  float _77;
  float _80;
  float _111;
  float _112;
  float _113;
  _3 = uint(SV_Position.x);
  _19 = exp2(log2(((float)((uint)(_3 % 48))) * 0.021276595070958138f) * 0.012683313339948654f);
  _20 = exp2(log2(((float)((uint)uint(SV_Position.y))) * 0.021276595070958138f) * 0.012683313339948654f);
  _21 = exp2(log2(((float)((uint)(_3 / 48u))) * 0.021276595070958138f) * 0.012683313339948654f);
  _46 = exp2(log2(max((_19 + -0.8359375f), 0.0f) / (18.8515625f - (_19 * 18.6875f))) * 6.277394771575928f) * 125.0f;
  _47 = exp2(log2(max((_20 + -0.8359375f), 0.0f) / (18.8515625f - (_20 * 18.6875f))) * 6.277394771575928f) * 125.0f;
  _48 = exp2(log2(max((_21 + -0.8359375f), 0.0f) / (18.8515625f - (_21 * 18.6875f))) * 6.277394771575928f) * 125.0f;
  if (dot(float3(_46, _47, _48), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _52 = max(_46, 0.0f);
    _53 = max(_47, 0.0f);
    _54 = max(_48, 0.0f);
    _55 = min(_46, 0.0f);
    _56 = min(_47, 0.0f);
    _57 = min(_48, 0.0f);
    _61 = dot(float3(_52, _53, _54), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_55, _56, _57), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _69 = ((_61 * _55) + _52);
    _70 = ((_61 * _56) + _53);
    _71 = ((_61 * _57) + _54);
  } else {
    _69 = _46;
    _70 = _47;
    _71 = _48;
  }
  _74 = mad(0.05144599452614784f, _71, mad(0.5363325476646423f, _70, (_69 * 0.4122214615345001f)));
  _77 = mad(0.10739696025848389f, _71, mad(0.6806995272636414f, _70, (_69 * 0.21190349757671356f)));
  _80 = mad(0.6299787163734436f, _71, mad(0.2817188501358032f, _70, (_69 * 0.08830246329307556f)));
  _111 = exp2(log2(abs(_74)) * 0.3333333432674408f) * float((int)(((int)(uint)((int)(_74 > 0.0f))) - ((int)(uint)((int)(_74 < 0.0f)))));
  _112 = exp2(log2(abs(_77)) * 0.3333333432674408f) * float((int)(((int)(uint)((int)(_77 > 0.0f))) - ((int)(uint)((int)(_77 < 0.0f)))));
  _113 = exp2(log2(abs(_80)) * 0.3333333432674408f) * float((int)(((int)(uint)((int)(_80 > 0.0f))) - ((int)(uint)((int)(_80 < 0.0f)))));
  SV_Target.x = mad(-0.004072046838700771f, _113, mad(0.7936177849769592f, _112, (_111 * 0.21045425534248352f)));
  SV_Target.y = mad(0.4505937099456787f, _113, mad(-2.4285922050476074f, _112, (_111 * 1.9779984951019287f)));
  SV_Target.z = mad(-0.8086757659912109f, _113, mad(0.7827717661857605f, _112, (_111 * 0.025904037058353424f)));
  SV_Target.w = 1.0f;
  return SV_Target;
}
