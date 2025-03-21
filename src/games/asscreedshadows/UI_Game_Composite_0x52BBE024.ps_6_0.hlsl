#include "./shared.h"

Texture2D<float4> t0 : register(t0, space3);

Texture2D<float4> t1 : register(t1, space3);

Texture3D<float4> t2 : register(t3, space3);

cbuffer cb0 : register(b0, space3) {
  float cb0_004w : packoffset(c004.w);
};

SamplerState s0 : register(s8, space98);

SamplerState s1 : register(s0, space4);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _9 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _14 = t1.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _19 = 1.0f - _9.w;
  float _22 = min(_14.x, cb0_004w);
  float _23 = min(_14.y, cb0_004w);
  float _24 = min(_14.z, cb0_004w);
  float _25 = max(_9.w, 1.0000000116860974e-07f);
  float _26 = 1.0f / _25;
  float _27 = _26 * _9.x;
  float _28 = _26 * _9.y;
  float _29 = _26 * _9.z;

#if RENODX_UI_MODE  // Manual BT.2020 PQ Conversion
  float3 _39 = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(pow(max(float3(_27, _28, _29), 0), 2.2f)), RENODX_GRAPHICS_WHITE_NITS);
#else  // use LUT for UI BT.2020 PQ Conversion
  float4 _39 = t2.SampleLevel(s1, saturate(float3(_27, _28, _29)) * 0.96875f + 0.015625f, 0.0f);
  // _39.rgb = renodx::color::pq::DecodeSafe(_39.rgb);
  // _39.rgb *= RENODX_GRAPHICS_WHITE_NITS / 269.f;
  // _39.rgb = renodx::color::pq::EncodeSafe(_39.rgb);
#endif

  float _43 = _39.x * _9.w;
  float _44 = _39.y * _9.w;
  float _45 = _39.z * _9.w;
  float _46 = _22 * _19;
  float _47 = _23 * _19;
  float _48 = _24 * _19;
  float _49 = _14.w * _19;
  float _50 = _43 + _46;
  float _51 = _44 + _47;
  float _52 = _45 + _48;
  float _53 = _49 + _9.w;
  SV_Target.x = _50;
  SV_Target.y = _51;
  SV_Target.z = _52;
  SV_Target.w = _53;
  return SV_Target;
}
