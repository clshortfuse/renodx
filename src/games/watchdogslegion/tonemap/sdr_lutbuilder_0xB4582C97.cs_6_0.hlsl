#include "tonemap.hlsli"

Texture3D<float4> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

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
  float4 _18;
  float4 _27;
  float _34;
  float _35;
  float _36;
  float _88;
  float _89;
  float _90;
  float _92;
  float _93;
  float _108;
  float _119;
  float _120;
  float _121;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _18 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _27 = t1.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _34 = (_27.x * cb0_009x) + (_18.x * cb0_008x);
    _35 = (_27.y * cb0_009x) + (_18.y * cb0_008x);
    _36 = (_27.z * cb0_009x) + (_18.z * cb0_008x);
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      _88 = (cb0_004x + exp2(log2(max((((cb0_003x * (1.0f - _34)) + _34) * cb0_001x), 0.0f)) * (1.0f / max(cb0_002x, 9.999999974752427e-07f)))) + cb0_006x;
      _89 = (cb0_004y + exp2(log2(max((((cb0_003y * (1.0f - _35)) + _35) * cb0_001y), 0.0f)) * (1.0f / max(cb0_002y, 9.999999974752427e-07f)))) + cb0_006x;
      _90 = (cb0_004z + exp2(log2(max((((cb0_003z * (1.0f - _36)) + _36) * cb0_001z), 0.0f)) * (1.0f / max(cb0_002z, 9.999999974752427e-07f)))) + cb0_006x;
      _92 = -0.0f - cb0_006z;
      _93 = dot(float3(_88, _89, _90), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
      _108 = (1.0f - cb0_006y) * 0.18000000715255737f;
      _119 = (_108 + ((lerp(_88, _93, _92)) * cb0_006y)) * saturate(cb0_000x);
      _120 = (_108 + ((lerp(_89, _93, _92)) * cb0_006y)) * saturate(cb0_000y);
      _121 = (_108 + ((lerp(_90, _93, _92)) * cb0_006y)) * saturate(cb0_000z);
    } else {
      _119 = _34;
      _120 = _35;
      _121 = _36;
    }
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(select((_119 <= 0.0031308000907301903f), (_119 * 12.920000076293945f), ((exp2(log2(abs(_119)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)),
                                                                                                                select((_120 <= 0.0031308000907301903f), (_120 * 12.920000076293945f), ((exp2(log2(abs(_120)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)),
                                                                                                                select((_121 <= 0.0031308000907301903f), (_121 * 12.920000076293945f), ((exp2(log2(abs(_121)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f)), 0.0f);
  }
}
