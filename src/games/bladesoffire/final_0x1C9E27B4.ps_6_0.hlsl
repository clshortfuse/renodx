#include "./shared.h"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_002x : packoffset(c002.x);
  float cb0_002y : packoffset(c002.y);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1,
    linear float4 TEXCOORD_2: TEXCOORD2) : SV_Target {
  float4 SV_Target;
  float4 _16 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _25 = t0.Sample(s0, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float4 _37 = t0.Sample(s0, float2(TEXCOORD_1.z, TEXCOORD_1.w));
  float4 _49 = t0.Sample(s0, float2(TEXCOORD_2.x, TEXCOORD_2.y));
  float4 _61 = t0.Sample(s0, float2(TEXCOORD_2.z, TEXCOORD_2.w));
  float _70 = ((((cb0_011z * _16.x) - (cb0_011x * _25.x)) - (cb0_011x * _37.x)) - (cb0_011y * _49.x)) - (cb0_011y * _61.x);
  float _71 = ((((cb0_011z * _16.y) - (cb0_011x * _25.y)) - (cb0_011x * _37.y)) - (cb0_011y * _49.y)) - (cb0_011y * _61.y);
  float _72 = ((((cb0_011z * _16.z) - (cb0_011x * _25.z)) - (cb0_011x * _37.z)) - (cb0_011y * _49.z)) - (cb0_011y * _61.z);
  float _79 = saturate(abs(dot(float3(_16.x, _16.y, _16.z), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f)) - dot(float3(_70, _71, _72), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f))) * cb0_011w);
  float _91 = ((_79 * (_16.x - _70)) + _70) * cb0_002x;
  float _92 = ((_79 * (_16.y - _71)) + _71) * cb0_002x;
  float _93 = ((_79 * (_16.z - _72)) + _72) * cb0_002x;

  float3 scene = float3(_91, _92, _93);
  scene.rgb = renodx::color::gamma::DecodeSafe(scene.rgb, 2.f);
  scene.rgb = renodx::tonemap::ExponentialRollOff(scene.rgb, 0.f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  scene.rgb = renodx::color::correct::GammaSafe(scene.rgb);
  scene.rgb = renodx::color::gamma::EncodeSafe(scene.rgb, 2.f);

  float4 _94 = t1.Sample(s1, float2(TEXCOORD.x, TEXCOORD.y));
  // 1 = diffuse white
  _94.rgb = renodx::color::gamma::DecodeSafe(_94.rgb, 2.f);
  _94.rgb = renodx::color::correct::GammaSafe(_94.rgb);
  _94.rgb = _94.rgb * RENODX_GRAPHICS_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  _94.rgb = renodx::color::gamma::EncodeSafe(_94.rgb, 2.f);

  // Lerp is done in gamma 2.0
  float _109 = saturate(cb0_010y * _94.w);
  float _119 = 1.0f - _94.w;
  /* float _123 = (((_109 * (min(_91, cb0_010x) - _91)) + _91) * _119) + (cb0_010x * _94.x);
  float _124 = (((_109 * (min(_92, cb0_010x) - _92)) + _92) * _119) + (cb0_010x * _94.y);
  float _125 = (((_109 * (min(_93, cb0_010x) - _93)) + _93) * _119) + (cb0_010x * _94.z); */
  float _123 = (((_109 * (min(scene.r, cb0_010x) - scene.r)) + scene.r) * _119) + (cb0_010x * _94.x);
  float _124 = (((_109 * (min(scene.g, cb0_010x) - scene.g)) + scene.g) * _119) + (cb0_010x * _94.y);
  float _125 = (((_109 * (min(scene.b, cb0_010x) - scene.b)) + scene.b) * _119) + (cb0_010x * _94.z);

  float4 final = float4(_123, _124, _125, 0.f);
  final.rgb = renodx::color::gamma::DecodeSafe(final.rgb, 2.f);
  final.rgb = renodx::color::bt2020::from::BT709(final.rgb);
  final.rgb = renodx::color::pq::EncodeSafe(final.rgb, RENODX_DIFFUSE_WHITE_NITS);
  return final;

  // pow(color, 2.f) * pw?
  float _129 = (_123 * _123) * cb0_002y;
  float _131 = (_124 * _124) * cb0_002y;
  float _133 = (_125 * _125) * cb0_002y;

  float _152 = exp2(log2(mad(0.043299999088048935f, _133, mad(0.3292999863624573f, _131, (_129 * 0.6273999810218811f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _153 = exp2(log2(mad(0.01140000019222498f, _133, mad(0.9194999933242798f, _131, (_129 * 0.06909999996423721f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _154 = exp2(log2(mad(0.8956000208854675f, _133, mad(0.08799999952316284f, _131, (_129 * 0.01640000008046627f))) * 0.009999999776482582f) * 0.1593017578125f);
  SV_Target.x = exp2(log2(((_152 * 18.8515625f) + 0.8359375f) / ((_152 * 18.6875f) + 1.0f)) * 78.84375f);
  SV_Target.y = exp2(log2(((_153 * 18.8515625f) + 0.8359375f) / ((_153 * 18.6875f) + 1.0f)) * 78.84375f);
  SV_Target.z = exp2(log2(((_154 * 18.8515625f) + 0.8359375f) / ((_154 * 18.6875f) + 1.0f)) * 78.84375f);

  SV_Target.w = 0.0f;

  // SV_Target = FinalizeOutput(float4(_91, _92, _93, 0.f), _94);
  return SV_Target;
}
