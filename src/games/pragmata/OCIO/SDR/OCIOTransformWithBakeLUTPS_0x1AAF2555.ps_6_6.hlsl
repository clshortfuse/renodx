#include "../../common.hlsli"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  SV_Target.w = 1.0f;
  float4 _9 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

#if SKIP_OCIO_LUT
  SV_Target.rgb = _9.rgb;
  SV_Target.rgb = renodx::color::bt709::from::AP1(SV_Target.rgb);
  SV_Target.rgb = renodx::color::srgb::EncodeSafe(SV_Target.rgb);
  return SV_Target;
#endif
  float _27;
  float _42;
  float _57;
  if (!(_9.x <= 0.0f)) {
    if (_9.x < 3.0517578125e-05f) {
      _27 = ((log2((_9.x * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _27 = ((log2(_9.x) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _27 = -0.35844698548316956f;
  }
  if (!(_9.y <= 0.0f)) {
    if (_9.y < 3.0517578125e-05f) {
      _42 = ((log2((_9.y * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _42 = ((log2(_9.y) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _42 = -0.35844698548316956f;
  }
  if (!(_9.z <= 0.0f)) {
    if (_9.z < 3.0517578125e-05f) {
      _57 = ((log2((_9.z * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _57 = ((log2(_9.z) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _57 = -0.35844698548316956f;
  }
  float4 _66 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_27 * 0.984375f) + 0.0078125f), ((_42 * 0.984375f) + 0.0078125f), ((_57 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = _66.x;
  SV_Target.y = _66.y;
  SV_Target.z = _66.z;
  return SV_Target;
}

