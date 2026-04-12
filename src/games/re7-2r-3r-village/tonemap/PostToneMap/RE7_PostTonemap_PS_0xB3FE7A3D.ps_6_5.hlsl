#define SHADER_HASH 0xB3FE7A3D
#include "../tonemap.hlsli"

Texture2D<float4> HDRImage : register(t0);

// cbuffer Tonemap : register(b0) {
//   float exposureAdjustment : packoffset(c000.x);
//   float tonemapRange : packoffset(c000.y);
//   float sharpness : packoffset(c000.z);
//   float preTonemapRange : packoffset(c000.w);
//   int useAutoExposure : packoffset(c001.x);
//   float echoBlend : packoffset(c001.y);
//   float AABlend : packoffset(c001.z);
//   float AASubPixel : packoffset(c001.w);
//   float ResponsiveAARate : packoffset(c002.x);
// };

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 Kerare : Kerare,
  linear float Exposure : Exposure
) : SV_Target {
  float4 SV_Target;
  float4 _8 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _12 = _8.x * Exposure;
  float _13 = _8.y * Exposure;
  float _14 = _8.z * Exposure;
  float _16 = max(max(_12, _13), _14);
  float _27;
  float _28;
  float _29;
  if (isfinite(_16)) {
    float _22 = (tonemapRange * _16) + 1.0f;
    _27 = (_12 / _22);
    _28 = (_13 / _22);
    _29 = (_14 / _22);
  } else {
    _27 = 1.0f;
    _28 = 1.0f;
    _29 = 1.0f;
  }
  SV_Target.x = _27;
  SV_Target.y = _28;
  SV_Target.z = _29;
  SV_Target.w = 1.0f;

#if 1
  float2 grain_uv = SV_Position.xy;
  SV_Target.rgb = ApplyUserGradingAndToneMap(SV_Target.rgb, grain_uv);
#endif

  return SV_Target;
}
