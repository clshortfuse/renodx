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
  float4 _19;
  float4 _28;
  float _35;
  float _36;
  float _37;
  float _89;
  float _90;
  float _91;
  float _93;
  float _94;
  float _109;
  float _126;
  float _127;
  float _128;
  float _129;
  float _161;
  float _162;
  float _168;
  float _174;
  float _175;
  float _176;
  float _192;
  float _199;
  float _206;
  float _219;
  float _232;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _19 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _28 = t1.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _35 = (_28.x * cb0_009x) + (_19.x * cb0_008x);
    _36 = (_28.y * cb0_009x) + (_19.y * cb0_008x);
    _37 = (_28.z * cb0_009x) + (_19.z * cb0_008x);
    float3 upgraded = UpgradeBlendedLUT(SV_DispatchThreadID, uint(cb0_023y), float3(_35, _36, _37));
    _35 = upgraded.r;
    _36 = upgraded.g;
    _37 = upgraded.b;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      _89 = (cb0_004x + exp2(log2(max((((cb0_003x * (1.0f - _35)) + _35) * cb0_001x), 0.0f)) * (1.0f / max(cb0_002x, 9.999999974752427e-07f)))) + cb0_006x;
      _90 = (cb0_004y + exp2(log2(max((((cb0_003y * (1.0f - _36)) + _36) * cb0_001y), 0.0f)) * (1.0f / max(cb0_002y, 9.999999974752427e-07f)))) + cb0_006x;
      _91 = (cb0_004z + exp2(log2(max((((cb0_003z * (1.0f - _37)) + _37) * cb0_001z), 0.0f)) * (1.0f / max(cb0_002z, 9.999999974752427e-07f)))) + cb0_006x;
      _93 = -0.0f - cb0_006z;
      _94 = dot(float3(_89, _90, _91), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
      _109 = (1.0f - cb0_006y) * 0.18000000715255737f;
      _126 = (_109 + ((lerp(_89, _94, _93)) * cb0_006y)) * saturate(cb0_000x);
      _127 = (_109 + ((lerp(_90, _94, _93)) * cb0_006y)) * saturate(cb0_000y);
      _128 = (_109 + ((lerp(_91, _94, _93)) * cb0_006y)) * saturate(cb0_000z);
    } else {
      _126 = _35;
      _127 = _36;
      _128 = _37;
    }
#if 1  // custom code
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = EncodeHDRLUT(_126, _127, _128, HDROutput_000, HDROutput_064);
#else  // original code
    _126 = saturate(_126);
    _127 = saturate(_127);
    _128 = saturate(_128);
    _129 = dot(float3(_126, _127, _128), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _161 = select((_129 > 0.5f), (((_129 * HDROutput_000.y) / (HDROutput_000.y - _129)) + HDROutput_000.x), (_129 / (1.000100016593933f - _129)));
    _162 = _129 + 9.999999747378752e-05f;
    _168 = _161 * 0.75f;
    _174 = (((_126 / _162) * 0.75f) * _161) + (select((_126 > 0.5f), (((HDROutput_000.y * _126) / (HDROutput_000.y - _126)) + HDROutput_000.x), (_126 / (1.000100016593933f - _126))) * 0.25f);
    _175 = (_168 * (_127 / _162)) + (select((_127 > 0.5f), (((_127 * HDROutput_000.y) / (HDROutput_000.y - _127)) + HDROutput_000.x), (_127 / (1.000100016593933f - _127))) * 0.25f);
    _176 = (_168 * (_128 / _162)) + (select((_128 > 0.5f), (((_128 * HDROutput_000.y) / (HDROutput_000.y - _128)) + HDROutput_000.x), (_128 / (1.000100016593933f - _128))) * 0.25f);
    _192 = saturate(max(max(_174, _175), _176) + -1.0f);
    _199 = HDROutput_064 * 9.999999747378752e-05f;
    _206 = exp2(log2(abs(_199 * (((1.0f - _192) * mad(0.04331360012292862f, _176, mad(0.3292819857597351f, _175, (_174 * 0.627403974533081f)))) + (_192 * mad(0.047561999410390854f, _176, mad(0.19859300553798676f, _175, (_174 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _219 = exp2(log2(abs(_199 * mad(0.012477199546992779f, _176, mad(0.9417769908905029f, _175, (_174 * 0.045745600014925f))))) * 0.1593017578125f);
    _232 = exp2(log2(abs(_199 * mad(0.9836069941520691f, _176, mad(0.017604099586606026f, _175, (_174 * -0.0012105499627068639f))))) * 0.1593017578125f);
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(exp2(log2(abs(((_206 * 18.8515625f) + 0.8359375f) / ((_206 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_219 * 18.8515625f) + 0.8359375f) / ((_219 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_232 * 18.8515625f) + 0.8359375f) / ((_232 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f);
#endif
  }
}
