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
  float _8;
  float _10;
  float _12;
  float _33;
  float _34;
  float _35;
  float _16;
  float _17;
  float _18;
  float _19;
  float _20;
  float _21;
  float _25;
  _3 = uint(SV_Position.x);
  _8 = ((float)((uint)((uint)(_3 & 31)))) * 0.032258063554763794f;
  _10 = ((float)((uint)uint(SV_Position.y))) * 0.032258063554763794f;
  _12 = ((float)((uint)((uint)((uint)(_3) >> 5)))) * 0.032258063554763794f;
  if (dot(float3(_8, _10, _12), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) < -1.1754943508222875e-38f) {
    _16 = max(_8, 0.0f);
    _17 = max(_10, 0.0f);
    _18 = max(_12, 0.0f);
    _19 = min(_8, 0.0f);
    _20 = min(_10, 0.0f);
    _21 = min(_12, 0.0f);
    _25 = dot(float3(_16, _17, _18), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)) / (-0.0f - dot(float3(_19, _20, _21), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)));
    _33 = ((_25 * _19) + _16);
    _34 = ((_25 * _20) + _17);
    _35 = ((_25 * _21) + _18);
  } else {
    _33 = _8;
    _34 = _10;
    _35 = _12;
  }
  SV_Target.x = _33;
  SV_Target.y = _34;
  SV_Target.z = _35;
  SV_Target.w = 1.0f;
  return SV_Target;
}
