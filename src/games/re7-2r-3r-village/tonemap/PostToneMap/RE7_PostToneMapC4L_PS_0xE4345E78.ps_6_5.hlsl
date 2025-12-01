#include "../../common.hlsli"

Texture2D<float4> HDRImage : register(t0);

cbuffer Tonemap : register(b0) {
  float exposureAdjustment : packoffset(c000.x);
  float tonemapRange : packoffset(c000.y);
  float sharpness : packoffset(c000.z);
  float preTonemapRange : packoffset(c000.w);
  int useAutoExposure : packoffset(c001.x);
  float echoBlend : packoffset(c001.y);
  float AABlend : packoffset(c001.z);
  float AASubPixel : packoffset(c001.w);
  float ResponsiveAARate : packoffset(c002.x);
};

cbuffer CameraKerare : register(b1) {
  float kerare_scale : packoffset(c000.x);
  float kerare_offset : packoffset(c000.y);
  float kerare_brightness : packoffset(c000.z);
};

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 Kerare: Kerare,
    linear float Exposure: Exposure)
    : SV_Target {
  float tonemap_range = tonemapRange;

#if 1
  tonemap_range = 0.f;  // no highlight compression
#endif

  float4 SV_Target;
  float4 _13 = HDRImage.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  float _19 = Kerare.x / Kerare.w;
  float _20 = Kerare.y / Kerare.w;
  float _21 = Kerare.z / Kerare.w;
  float _25 = abs(rsqrt(dot(float3(_19, _20, _21), float3(_19, _20, _21))) * _21);
  float _32 = _25 * _25;
  float _36 = saturate(((_32 * _32) * (1.0f - saturate((kerare_scale * _25) + kerare_offset))) + kerare_brightness);
  float _38 = (_13.x * Exposure) * _36;
  float _40 = (_13.y * Exposure) * _36;
  float _42 = (_13.z * Exposure) * _36;
  float _44 = max(max(_38, _40), _42);
  float _55;
  float _56;
  float _57;
  if (isfinite(_44)) {
    float _50 = (tonemap_range * _44) + 1.0f;
    _55 = (_38 / _50);
    _56 = (_40 / _50);
    _57 = (_42 / _50);
  } else {
    _55 = 1.0f;
    _56 = 1.0f;
    _57 = 1.0f;
  }
  SV_Target.x = _55;
  SV_Target.y = _56;
  SV_Target.z = _57;
  SV_Target.w = 1.0f;

#if 1
  SV_Target.rgb = ApplyPreDisplayMap(SV_Target.rgb);
#endif
  return SV_Target;
}
