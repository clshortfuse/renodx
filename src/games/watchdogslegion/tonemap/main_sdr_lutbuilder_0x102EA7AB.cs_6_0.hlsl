#include "tonemap.hlsli"

Texture3D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_000x : packoffset(c000.x);
  float cb0_000y : packoffset(c000.y);
  float cb0_000z : packoffset(c000.z);
  float cb0_001x : packoffset(c001.x);
  float cb0_001y : packoffset(c001.y);
  float cb0_001z : packoffset(c001.z);
  float cb0_002x : packoffset(c002.x);
  float cb0_002y : packoffset(c002.y);
  float cb0_002z : packoffset(c002.z);
  float cb0_003x : packoffset(c003.x);
  float cb0_003y : packoffset(c003.y);
  float cb0_003z : packoffset(c003.z);
  float cb0_004x : packoffset(c004.x);
  float cb0_004y : packoffset(c004.y);
  float cb0_004z : packoffset(c004.z);
  float cb0_006x : packoffset(c006.x);
  float cb0_006y : packoffset(c006.y);
  float cb0_006z : packoffset(c006.z);
  float cb0_008x : packoffset(c008.x);
  int cb0_023y : packoffset(c023.y);
};

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float4 _17;
  float _21;
  float _22;
  float _23;
  float _75;
  float _76;
  float _77;
  float _79;
  float _80;
  float _95;
  float _106;
  float _107;
  float _108;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _17 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _21 = _17.x * cb0_008x;
    _22 = _17.y * cb0_008x;
    _23 = _17.z * cb0_008x;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      _75 = (cb0_004x + exp2(log2(max((((cb0_003x * (1.0f - _21)) + _21) * cb0_001x), 0.0f)) * (1.0f / max(cb0_002x, 9.999999974752427e-07f)))) + cb0_006x;
      _76 = (cb0_004y + exp2(log2(max((((cb0_003y * (1.0f - _22)) + _22) * cb0_001y), 0.0f)) * (1.0f / max(cb0_002y, 9.999999974752427e-07f)))) + cb0_006x;
      _77 = (cb0_004z + exp2(log2(max((((cb0_003z * (1.0f - _23)) + _23) * cb0_001z), 0.0f)) * (1.0f / max(cb0_002z, 9.999999974752427e-07f)))) + cb0_006x;
      _79 = -0.0f - cb0_006z;
      _80 = dot(float3(_75, _76, _77), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
      _95 = (1.0f - cb0_006y) * 0.18000000715255737f;
      _106 = (_95 + ((lerp(_75, _80, _79)) * cb0_006y)) * saturate(cb0_000x);
      _107 = (_95 + ((lerp(_76, _80, _79)) * cb0_006y)) * saturate(cb0_000y);
      _108 = (_95 + ((lerp(_77, _80, _79)) * cb0_006y)) * saturate(cb0_000z);
    } else {
      _106 = _21;
      _107 = _22;
      _108 = _23;
    }
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(select((_106 <= 0.0031308000907301903f), (_106 * 12.920000076293945f), ((exp2(log2(abs(_106)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)),
                                                                                                                select((_107 <= 0.0031308000907301903f), (_107 * 12.920000076293945f), ((exp2(log2(abs(_107)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)),
                                                                                                                select((_108 <= 0.0031308000907301903f), (_108 * 12.920000076293945f), ((exp2(log2(abs(_108)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)), 0.0f);
  }
}
