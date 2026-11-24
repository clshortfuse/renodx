#include "./common.hlsli"

struct UICompositingParameters__Constants {
  float4 UICompositingParameters__Constants_000[4];
  float UICompositingParameters__Constants_064;
  float UICompositingParameters__Constants_068;
  float UICompositingParameters__Constants_072;
  float UICompositingParameters__Constants_076;
  float UICompositingParameters__Constants_080;
  int2 UICompositingParameters__Constants_084;
  int2 UICompositingParameters__Constants_092;
  int2 UICompositingParameters__Constants_100;
  int2 UICompositingParameters__Constants_108;
  int2 UICompositingParameters__Constants_116;
};

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t3 : register(t3);

RWTexture2D<float4> u0 : register(u0);

RWTexture2D<float4> u2 : register(u2);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  int cb0_005y : packoffset(c005.y);
  int cb0_005z : packoffset(c005.z);
  int cb0_006x : packoffset(c006.x);
  int cb0_006y : packoffset(c006.y);
  int cb0_006z : packoffset(c006.z);
  int cb0_006w : packoffset(c006.w);
  int cb0_007x : packoffset(c007.x);
  int cb0_007y : packoffset(c007.y);
  int cb0_007z : packoffset(c007.z);
  int cb0_007w : packoffset(c007.w);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s8_space98 : register(s8, space98);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

[numthreads(16, 16, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _20;
  float _21;
  float4 _28;
  float4 _40;
  float _88;
  float _89;
  float _90;
  float _91;
  float _92;
  float _93;
  float _94;
  float _54;
  float _57;
  float _58;
  float _59;
  float _61;
  float4 _74;
  uint _100;
  uint _101;

  float peak_nits_pq = cb0_005x;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    peak_nits_pq = renodx::color::pq::Encode(RENODX_PEAK_WHITE_NITS, 1.f);
  }

  _20 = (((float)((uint)SV_DispatchThreadID.x)) + 0.5f) / ((float)((uint)(uint)(cb0_006x)));
  _21 = (((float)((uint)SV_DispatchThreadID.y)) + 0.5f) / ((float)((uint)(uint)(cb0_006y)));
  _28 = t0.SampleGrad(s8_space98, float2(_20, _21), float2((1.0f / ((float)((uint)(uint)(cb0_006z)))), 0.0f), float2(0.0f, (1.0f / ((float)((uint)(uint)(cb0_006w))))), int2(0, 0));
  _40 = t1.SampleGrad(s8_space98, float2(_20, _21), float2((1.0f / ((float)((uint)(uint)(cb0_007x)))), 0.0f), float2(0.0f, (1.0f / ((float)((uint)(uint)(cb0_007y))))), int2(0, 0));
  if (((uint)(int)(SV_DispatchThreadID.x) < (uint)cb0_007z) && ((uint)(int)(SV_DispatchThreadID.y) < (uint)cb0_007w)) {
    do {
      _88 = 0.0f;
      _89 = 0.0f;
      _90 = 0.0f;
      _91 = 0.0f;
      _92 = 0.0f;
      _93 = 0.0f;
      _94 = 0.0f;
      if (((uint)(int)(SV_DispatchThreadID.x) < (uint)cb0_006x) && ((uint)(int)(SV_DispatchThreadID.y) < (uint)cb0_006y)) {
        _54 = 1.0f - _28.w;
        _57 = min(_40.x, peak_nits_pq);
        _58 = min(_40.y, peak_nits_pq);
        _59 = min(_40.z, peak_nits_pq);
        _61 = 1.0f / max(_28.w, 1.0000000116860974e-07f);
        _74 = t3.SampleLevel(s0_space1,
                             float3(((saturate(_61 * _28.x) * 0.96875f) + 0.015625f),
                                    ((saturate(_61 * _28.y) * 0.96875f) + 0.015625f),
                                    ((saturate(_61 * _28.z) * 0.96875f) + 0.015625f)),
                             0.0f);
        _88 = ((_74.x * _28.w) + (_57 * _54));
        _89 = ((_74.y * _28.w) + (_58 * _54));
        _90 = ((_74.z * _28.w) + (_59 * _54));
        _91 = 1.0f;
        _92 = _57;
        _93 = _58;
        _94 = _59;
      }
      _100 = ((int)((uint)(cb0_005y) + SV_DispatchThreadID.x)) % cb0_007z;
      _101 = ((int)((uint)(cb0_005z) + SV_DispatchThreadID.y)) % cb0_007w;
      u0[int2(_100, _101)] = float4(_88, _89, _90, _91);
      u2[int2(_100, _101)] = float4(_92, _93, _94, _91);
    } while (false);
  }
}
