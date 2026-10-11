#include "tonemap.hlsli"

Texture3D<float4> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

Texture3D<float4> t2 : register(t2);

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
  float cb0_009x : packoffset(c009.x);
  float cb0_010x : packoffset(c010.x);
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
  float4 _19;
  float4 _28;
  float4 _40;
  float _47;
  float _48;
  float _49;
  float _101;
  float _102;
  float _103;
  float _105;
  float _106;
  float _121;
  float _132;
  float _133;
  float _134;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _19 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _28 = t1.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _40 = t2.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _47 = ((_28.x * cb0_009x) + (_19.x * cb0_008x)) + (_40.x * cb0_010x);
    _48 = ((_28.y * cb0_009x) + (_19.y * cb0_008x)) + (_40.y * cb0_010x);
    _49 = ((_28.z * cb0_009x) + (_19.z * cb0_008x)) + (_40.z * cb0_010x);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      _101 = (cb0_004x + exp2(log2(max((((cb0_003x * (1.0f - _47)) + _47) * cb0_001x), 0.0f)) * (1.0f / max(cb0_002x, 9.999999974752427e-07f)))) + cb0_006x;
      _102 = (cb0_004y + exp2(log2(max((((cb0_003y * (1.0f - _48)) + _48) * cb0_001y), 0.0f)) * (1.0f / max(cb0_002y, 9.999999974752427e-07f)))) + cb0_006x;
      _103 = (cb0_004z + exp2(log2(max((((cb0_003z * (1.0f - _49)) + _49) * cb0_001z), 0.0f)) * (1.0f / max(cb0_002z, 9.999999974752427e-07f)))) + cb0_006x;
      _105 = -0.0f - cb0_006z;
      _106 = dot(float3(_101, _102, _103), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
      _121 = (1.0f - cb0_006y) * 0.18000000715255737f;
      _132 = (_121 + ((lerp(_101, _106, _105)) * cb0_006y)) * saturate(cb0_000x);
      _133 = (_121 + ((lerp(_102, _106, _105)) * cb0_006y)) * saturate(cb0_000y);
      _134 = (_121 + ((lerp(_103, _106, _105)) * cb0_006y)) * saturate(cb0_000z);
    } else {
      _132 = _47;
      _133 = _48;
      _134 = _49;
    }
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(select((_132 <= 0.0031308000907301903f), (_132 * 12.920000076293945f), ((exp2(log2(abs(_132)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)),
                                                                                                                select((_133 <= 0.0031308000907301903f), (_133 * 12.920000076293945f), ((exp2(log2(abs(_133)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)),
                                                                                                                select((_134 <= 0.0031308000907301903f), (_134 * 12.920000076293945f), ((exp2(log2(abs(_134)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)), 0.0f);
  }
}
