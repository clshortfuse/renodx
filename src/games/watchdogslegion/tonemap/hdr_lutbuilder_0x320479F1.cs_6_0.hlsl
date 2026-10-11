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
  float4 _20;
  float4 _29;
  float4 _41;
  float _48;
  float _49;
  float _50;
  float _102;
  float _103;
  float _104;
  float _106;
  float _107;
  float _122;
  float _139;
  float _140;
  float _141;
  float _142;
  float _174;
  float _175;
  float _181;
  float _187;
  float _188;
  float _189;
  float _205;
  float _212;
  float _219;
  float _232;
  float _245;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _20 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _29 = t1.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _41 = t2.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _48 = ((_29.x * cb0_009x) + (_20.x * cb0_008x)) + (_41.x * cb0_010x);
    _49 = ((_29.y * cb0_009x) + (_20.y * cb0_008x)) + (_41.y * cb0_010x);
    _50 = ((_29.z * cb0_009x) + (_20.z * cb0_008x)) + (_41.z * cb0_010x);
    float3 upgraded = UpgradeBlendedLUT(SV_DispatchThreadID, uint(cb0_023y), float3(_48, _49, _50));
    _48 = upgraded.r;
    _49 = upgraded.g;
    _50 = upgraded.b;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      _102 = (cb0_004x + exp2(log2(max((((cb0_003x * (1.0f - _48)) + _48) * cb0_001x), 0.0f)) * (1.0f / max(cb0_002x, 9.999999974752427e-07f)))) + cb0_006x;
      _103 = (cb0_004y + exp2(log2(max((((cb0_003y * (1.0f - _49)) + _49) * cb0_001y), 0.0f)) * (1.0f / max(cb0_002y, 9.999999974752427e-07f)))) + cb0_006x;
      _104 = (cb0_004z + exp2(log2(max((((cb0_003z * (1.0f - _50)) + _50) * cb0_001z), 0.0f)) * (1.0f / max(cb0_002z, 9.999999974752427e-07f)))) + cb0_006x;
      _106 = -0.0f - cb0_006z;
      _107 = dot(float3(_102, _103, _104), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
      _122 = (1.0f - cb0_006y) * 0.18000000715255737f;
      _139 = (_122 + ((lerp(_102, _107, _106)) * cb0_006y)) * saturate(cb0_000x);
      _140 = (_122 + ((lerp(_103, _107, _106)) * cb0_006y)) * saturate(cb0_000y);
      _141 = (_122 + ((lerp(_104, _107, _106)) * cb0_006y)) * saturate(cb0_000z);
    } else {
      _139 = _48;
      _140 = _49;
      _141 = _50;
    }
#if 1  // custom code
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = EncodeHDRLUT(_139, _140, _141, HDROutput_000, HDROutput_064);
#else  // original code
    _139 = saturate(_139);
    _140 = saturate(_140);
    _141 = saturate(_141);
    _142 = dot(float3(_139, _140, _141), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _174 = select((_142 > 0.5f), (((_142 * HDROutput_000.y) / (HDROutput_000.y - _142)) + HDROutput_000.x), (_142 / (1.000100016593933f - _142)));
    _175 = _142 + 9.999999747378752e-05f;
    _181 = _174 * 0.75f;
    _187 = (((_139 / _175) * 0.75f) * _174) + (select((_139 > 0.5f), (((HDROutput_000.y * _139) / (HDROutput_000.y - _139)) + HDROutput_000.x), (_139 / (1.000100016593933f - _139))) * 0.25f);
    _188 = (_181 * (_140 / _175)) + (select((_140 > 0.5f), (((_140 * HDROutput_000.y) / (HDROutput_000.y - _140)) + HDROutput_000.x), (_140 / (1.000100016593933f - _140))) * 0.25f);
    _189 = (_181 * (_141 / _175)) + (select((_141 > 0.5f), (((_141 * HDROutput_000.y) / (HDROutput_000.y - _141)) + HDROutput_000.x), (_141 / (1.000100016593933f - _141))) * 0.25f);
    _205 = saturate(max(max(_187, _188), _189) + -1.0f);
    _212 = HDROutput_064 * 9.999999747378752e-05f;
    _219 = exp2(log2(abs(_212 * (((1.0f - _205) * mad(0.04331360012292862f, _189, mad(0.3292819857597351f, _188, (_187 * 0.627403974533081f)))) + (_205 * mad(0.047561999410390854f, _189, mad(0.19859300553798676f, _188, (_187 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _232 = exp2(log2(abs(_212 * mad(0.012477199546992779f, _189, mad(0.9417769908905029f, _188, (_187 * 0.045745600014925f))))) * 0.1593017578125f);
    _245 = exp2(log2(abs(_212 * mad(0.9836069941520691f, _189, mad(0.017604099586606026f, _188, (_187 * -0.0012105499627068639f))))) * 0.1593017578125f);
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(exp2(log2(abs(((_219 * 18.8515625f) + 0.8359375f) / ((_219 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_232 * 18.8515625f) + 0.8359375f) / ((_232 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_245 * 18.8515625f) + 0.8359375f) / ((_245 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f);
#endif
  }
}
