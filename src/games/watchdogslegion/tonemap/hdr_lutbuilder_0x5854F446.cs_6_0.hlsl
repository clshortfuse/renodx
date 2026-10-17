#include "tonemap.hlsli"

Texture3D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
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
  float _28;
  float _29;
  float _30;
  float _31;
  float _63;
  float _64;
  float _70;
  float _76;
  float _77;
  float _78;
  float _94;
  float _101;
  float _108;
  float _121;
  float _134;
  if (!((((uint)(int)(SV_DispatchThreadID.x) > (uint)cb0_023y) || ((uint)(int)(SV_DispatchThreadID.y) > (uint)cb0_023y)) || ((uint)(int)(SV_DispatchThreadID.z) > (uint)cb0_023y))) {
    _18 = t0.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z), 0));
    _28 = _18.x * cb0_008x;
    _29 = _18.y * cb0_008x;
    _30 = _18.z * cb0_008x;
    float3 upgraded = UpgradeBlendedLUT(SV_DispatchThreadID, uint(cb0_023y), float3(_28, _29, _30));
    _28 = upgraded.r;
    _29 = upgraded.g;
    _30 = upgraded.b;
#if 1  // custom code
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = EncodeHDRLUT(_28, _29, _30, HDROutput_000, HDROutput_064);
#else  // original code
    _28 = saturate(_28);
    _29 = saturate(_29);
    _30 = saturate(_30);
    _31 = dot(float3(_28, _29, _30), float3(0.2126390039920807f, 0.7151686549186707f, 0.07219231873750687f));
    _63 = select((_31 > 0.5f), (((_31 * HDROutput_000.y) / (HDROutput_000.y - _31)) + HDROutput_000.x), (_31 / (1.000100016593933f - _31)));
    _64 = _31 + 9.999999747378752e-05f;
    _70 = _63 * 0.75f;
    _76 = (((_28 / _64) * 0.75f) * _63) + (select((_28 > 0.5f), (((HDROutput_000.y * _28) / (HDROutput_000.y - _28)) + HDROutput_000.x), (_28 / (1.000100016593933f - _28))) * 0.25f);
    _77 = (_70 * (_29 / _64)) + (select((_29 > 0.5f), (((_29 * HDROutput_000.y) / (HDROutput_000.y - _29)) + HDROutput_000.x), (_29 / (1.000100016593933f - _29))) * 0.25f);
    _78 = (_70 * (_30 / _64)) + (select((_30 > 0.5f), (((_30 * HDROutput_000.y) / (HDROutput_000.y - _30)) + HDROutput_000.x), (_30 / (1.000100016593933f - _30))) * 0.25f);
    _94 = saturate(max(max(_76, _77), _78) + -1.0f);
    _101 = HDROutput_064 * 9.999999747378752e-05f;
    _108 = exp2(log2(abs(_101 * (((1.0f - _94) * mad(0.04331360012292862f, _78, mad(0.3292819857597351f, _77, (_76 * 0.627403974533081f)))) + (_94 * mad(0.047561999410390854f, _78, mad(0.19859300553798676f, _77, (_76 * 0.7538449764251709f))))))) * 0.1593017578125f);
    _121 = exp2(log2(abs(_101 * mad(0.012477199546992779f, _78, mad(0.9417769908905029f, _77, (_76 * 0.045745600014925f))))) * 0.1593017578125f);
    _134 = exp2(log2(abs(_101 * mad(0.9836069941520691f, _78, mad(0.017604099586606026f, _77, (_76 * -0.0012105499627068639f))))) * 0.1593017578125f);
    u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(exp2(log2(abs(((_108 * 18.8515625f) + 0.8359375f) / ((_108 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_121 * 18.8515625f) + 0.8359375f) / ((_121 * 18.6875f) + 1.0f))) * 78.84375f),
                                                                                                                exp2(log2(abs(((_134 * 18.8515625f) + 0.8359375f) / ((_134 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f);
#endif
  }
}
