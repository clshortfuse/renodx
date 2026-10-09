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
  float _19;
  float _20;
  float4 _27;
  float4 _39;
  float _87;
  float _88;
  float _89;
  float _90;
  float _53;
  float _60;
  float4 _73;

  float peak_nits_pq = cb0_005x;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    peak_nits_pq = renodx::color::pq::Encode(RENODX_PEAK_WHITE_NITS, 1.f);
  }

  _19 = (((float)((uint)SV_DispatchThreadID.x)) + 0.5f) / ((float)((uint)(uint)(cb0_006x)));
  _20 = (((float)((uint)SV_DispatchThreadID.y)) + 0.5f) / ((float)((uint)(uint)(cb0_006y)));
  _27 = t0.SampleGrad(s8_space98, float2(_19, _20), float2((1.0f / ((float)((uint)(uint)(cb0_006z)))), 0.0f), float2(0.0f, (1.0f / ((float)((uint)(uint)(cb0_006w))))), int2(0, 0));
  _39 = t1.SampleGrad(s8_space98, float2(_19, _20), float2((1.0f / ((float)((uint)(uint)(cb0_007x)))), 0.0f), float2(0.0f, (1.0f / ((float)((uint)(uint)(cb0_007y))))), int2(0, 0));
  if (((uint)(int)(SV_DispatchThreadID.x) < (uint)cb0_007z) && ((uint)(int)(SV_DispatchThreadID.y) < (uint)cb0_007w)) {
    do {
      _87 = 0.0f;
      _88 = 0.0f;
      _89 = 0.0f;
      _90 = 0.0f;
      if (((uint)(int)(SV_DispatchThreadID.x) < (uint)cb0_006x) && ((uint)(int)(SV_DispatchThreadID.y) < (uint)cb0_006y)) {
        _53 = 1.0f - _27.w;
        _60 = 1.0f / max(_27.w, 1.0000000116860974e-07f);
        _73 = t3.SampleLevel(s0_space1,
                             float3(((saturate(_60 * _27.x) * 0.96875f) + 0.015625f),
                                    ((saturate(_60 * _27.y) * 0.96875f) + 0.015625f),
                                    ((saturate(_60 * _27.z) * 0.96875f) + 0.015625f)),
                             0.0f);
        _87 = ((_73.x * _27.w) + (min(_39.x, peak_nits_pq) * _53));
        _88 = ((_73.y * _27.w) + (min(_39.y, peak_nits_pq) * _53));
        _89 = ((_73.z * _27.w) + (min(_39.z, peak_nits_pq) * _53));
        _90 = 1.0f;
      }
      u0[int2(((int)(((int)((uint)(cb0_005y) + SV_DispatchThreadID.x)) % cb0_007z)), ((int)(((int)((uint)(cb0_005z) + SV_DispatchThreadID.y)) % cb0_007w)))] = float4(_87, _88, _89, _90);
    } while (false);
  }
}
