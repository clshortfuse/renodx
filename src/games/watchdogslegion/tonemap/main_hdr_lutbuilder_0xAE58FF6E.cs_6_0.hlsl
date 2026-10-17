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

cbuffer cb1 : register(b1) {
  float4 HDROutput_000 : packoffset(c000.x);
  float4 HDROutput_016 : packoffset(c001.x);
  float HDROutput_032 : packoffset(c002.x);
  float HDROutput_036 : packoffset(c002.y);
  float HDROutput_040 : packoffset(c002.z);
  float HDROutput_044 : packoffset(c002.w);
  float HDROutput_048 : packoffset(c003.x);
  float HDROutput_052 : packoffset(c003.y);
  float HDROutput_056 : packoffset(c003.z);
  float HDROutput_060 : packoffset(c003.w);
  float HDROutput_064 : packoffset(c004.x);
  float HDROutput_068 : packoffset(c004.y);
  float HDROutput_072 : packoffset(c004.z);
  float HDROutput_076 : packoffset(c004.w);
  float HDROutput_080 : packoffset(c005.x);
  float HDROutput_084 : packoffset(c005.y);
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
  float _22;
  float _23;
  float _24;
  float _76;
  float _77;
  float _78;
  float _80;
  float _81;
  float _96;
  float _113;
  float _114;
  float _115;
  float _116;
  float _148;
  float _149;
  float _155;
  float _161;
  float _162;
  float _163;
  float _179;
  float _186;
  float _193;
  float _206;
  float _219;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _18 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _22 = _18.x * cb0_008x;
    _23 = _18.y * cb0_008x;
    _24 = _18.z * cb0_008x;
    float3 upgraded = UpgradeBlendedLUT(SV_DispatchThreadID, uint(cb0_023y), float3(_22, _23, _24));
    _22 = upgraded.r;
    _23 = upgraded.g;
    _24 = upgraded.b;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      _76 = (cb0_004x + exp2(log2(max((((cb0_003x * (1.0f - _22)) + _22) * cb0_001x), 0.0f)) * (1.0f / max(cb0_002x, 9.999999974752427e-07f)))) + cb0_006x;
      _77 = (cb0_004y + exp2(log2(max((((cb0_003y * (1.0f - _23)) + _23) * cb0_001y), 0.0f)) * (1.0f / max(cb0_002y, 9.999999974752427e-07f)))) + cb0_006x;
      _78 = (cb0_004z + exp2(log2(max((((cb0_003z * (1.0f - _24)) + _24) * cb0_001z), 0.0f)) * (1.0f / max(cb0_002z, 9.999999974752427e-07f)))) + cb0_006x;
      _80 = -0.0f - cb0_006z;
      _81 = dot(float3(_76, _77, _78), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
      _96 = (1.0f - cb0_006y) * 0.18000000715255737f;
      _113 = (_96 + ((lerp(_76, _81, _80)) * cb0_006y)) * saturate(cb0_000x);
      _114 = (_96 + ((lerp(_77, _81, _80)) * cb0_006y)) * saturate(cb0_000y);
      _115 = (_96 + ((lerp(_78, _81, _80)) * cb0_006y)) * saturate(cb0_000z);
    } else {
      _113 = _22;
      _114 = _23;
      _115 = _24;
    }
    // _113 = (_18.x);
    // _114 = (_18.y);
    // _115 = (_18.z);

#if 1  // custom code
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = EncodeHDRLUT(_113, _114, _115, HDROutput_000, HDROutput_064);
#else  // original code
    _113 = saturate(_113);
    _114 = saturate(_114);
    _115 = saturate(_115);
    _116 = dot(float3(_113, _114, _115), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _148 = select((_116 > 0.5f), (((_116 * HDROutput_000.y) / (HDROutput_000.y - _116)) + HDROutput_000.x), (_116 / (1.000100016593933f - _116)));
    _149 = _116 + 9.999999747378752e-05f;
    _155 = _148 * 0.75f;
    _161 = (((_113 / _149) * 0.75f) * _148) + (select((_113 > 0.5f), (((HDROutput_000.y * _113) / (HDROutput_000.y - _113)) + HDROutput_000.x), (_113 / (1.000100016593933f - _113))) * 0.25f);
    _162 = (_155 * (_114 / _149)) + (select((_114 > 0.5f), (((_114 * HDROutput_000.y) / (HDROutput_000.y - _114)) + HDROutput_000.x), (_114 / (1.000100016593933f - _114))) * 0.25f);
    _163 = (_155 * (_115 / _149)) + (select((_115 > 0.5f), (((_115 * HDROutput_000.y) / (HDROutput_000.y - _115)) + HDROutput_000.x), (_115 / (1.000100016593933f - _115))) * 0.25f);
    _179 = saturate(max(max(_161, _162), _163) + -1.0f);
    _186 = HDROutput_064 * 9.999999747378752e-05f;
    _193 = exp2(log2(abs(_186 * (((1.0f - _179) * mad(0.04331360012292862f, _163, mad(0.3292819857597351f, _162, (_161 * 0.627403974533081f)))) + (_179 * mad(0.047561999410390854f, _163, mad(0.19859300553798676f, _162, (_161 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _206 = exp2(log2(abs(_186 * mad(0.012477199546992779f, _163, mad(0.9417769908905029f, _162, (_161 * 0.045745600014925f))))) * 0.1593017578125f);
    _219 = exp2(log2(abs(_186 * mad(0.9836069941520691f, _163, mad(0.017604099586606026f, _162, (_161 * -0.0012105499627068639f))))) * 0.1593017578125f);
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(exp2(log2(abs(((_193 * 18.8515625f) + 0.8359375f) / ((_193 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_206 * 18.8515625f) + 0.8359375f) / ((_206 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_219 * 18.8515625f) + 0.8359375f) / ((_219 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f);
#endif
  }
}
