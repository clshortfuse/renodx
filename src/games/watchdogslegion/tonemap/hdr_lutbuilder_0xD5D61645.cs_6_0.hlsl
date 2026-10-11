#include "tonemap.hlsli"

Texture3D<float4> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
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
  float _41;
  float _42;
  float _43;
  float _44;
  float _76;
  float _77;
  float _83;
  float _89;
  float _90;
  float _91;
  float _107;
  float _114;
  float _121;
  float _134;
  float _147;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _19 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _28 = t1.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _41 = (_28.x * cb0_009x) + (_19.x * cb0_008x);
    _42 = (_28.y * cb0_009x) + (_19.y * cb0_008x);
    _43 = (_28.z * cb0_009x) + (_19.z * cb0_008x);
    float3 upgraded = UpgradeBlendedLUT(SV_DispatchThreadID, uint(cb0_023y), float3(_41, _42, _43));
    _41 = upgraded.r;
    _42 = upgraded.g;
    _43 = upgraded.b;
#if 1  // custom code
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = EncodeHDRLUT(_41, _42, _43, HDROutput_000, HDROutput_064);
#else  // original code
    _41 = saturate(_41);
    _42 = saturate(_42);
    _43 = saturate(_43);
    _44 = dot(float3(_41, _42, _43), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _76 = select((_44 > 0.5f), (((_44 * HDROutput_000.y) / (HDROutput_000.y - _44)) + HDROutput_000.x), (_44 / (1.000100016593933f - _44)));
    _77 = _44 + 9.999999747378752e-05f;
    _83 = _76 * 0.75f;
    _89 = (((_41 / _77) * 0.75f) * _76) + (select((_41 > 0.5f), (((HDROutput_000.y * _41) / (HDROutput_000.y - _41)) + HDROutput_000.x), (_41 / (1.000100016593933f - _41))) * 0.25f);
    _90 = (_83 * (_42 / _77)) + (select((_42 > 0.5f), (((_42 * HDROutput_000.y) / (HDROutput_000.y - _42)) + HDROutput_000.x), (_42 / (1.000100016593933f - _42))) * 0.25f);
    _91 = (_83 * (_43 / _77)) + (select((_43 > 0.5f), (((_43 * HDROutput_000.y) / (HDROutput_000.y - _43)) + HDROutput_000.x), (_43 / (1.000100016593933f - _43))) * 0.25f);
    _107 = saturate(max(max(_89, _90), _91) + -1.0f);
    _114 = HDROutput_064 * 9.999999747378752e-05f;
    _121 = exp2(log2(abs(_114 * (((1.0f - _107) * mad(0.04331360012292862f, _91, mad(0.3292819857597351f, _90, (_89 * 0.627403974533081f)))) + (_107 * mad(0.047561999410390854f, _91, mad(0.19859300553798676f, _90, (_89 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _134 = exp2(log2(abs(_114 * mad(0.012477199546992779f, _91, mad(0.9417769908905029f, _90, (_89 * 0.045745600014925f))))) * 0.1593017578125f);
    _147 = exp2(log2(abs(_114 * mad(0.9836069941520691f, _91, mad(0.017604099586606026f, _90, (_89 * -0.0012105499627068639f))))) * 0.1593017578125f);
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(exp2(log2(abs(((_121 * 18.8515625f) + 0.8359375f) / ((_121 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_134 * 18.8515625f) + 0.8359375f) / ((_134 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_147 * 18.8515625f) + 0.8359375f) / ((_147 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f);
#endif
  }
}
