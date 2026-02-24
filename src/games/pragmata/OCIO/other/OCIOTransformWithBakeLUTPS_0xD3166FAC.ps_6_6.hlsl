#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer OCIOTransformMatrix : register(b0) {
  row_major float4x4 OCIO_TransformMatrix : packoffset(c000.x);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _29 = mad(_11.z, (OCIO_TransformMatrix[2].x), mad(_11.y, (OCIO_TransformMatrix[1].x), ((OCIO_TransformMatrix[0].x) * _11.x)));
  float _32 = mad(_11.z, (OCIO_TransformMatrix[2].y), mad(_11.y, (OCIO_TransformMatrix[1].y), ((OCIO_TransformMatrix[0].y) * _11.x)));
  float _35 = mad(_11.z, (OCIO_TransformMatrix[2].z), mad(_11.y, (OCIO_TransformMatrix[1].z), ((OCIO_TransformMatrix[0].z) * _11.x)));
  float _50;
  float _65;
  float _80;
  if (!(_29 <= 0.0f)) {
    if (_29 < 3.0517578125e-05f) {
      _50 = ((log2((_29 * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _50 = ((log2(_29) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _50 = -0.35844698548316956f;
  }
  if (!(_32 <= 0.0f)) {
    if (_32 < 3.0517578125e-05f) {
      _65 = ((log2((_32 * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _65 = ((log2(_32) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _65 = -0.35844698548316956f;
  }
  if (!(_35 <= 0.0f)) {
    if (_35 < 3.0517578125e-05f) {
      _80 = ((log2((_35 * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _80 = ((log2(_35) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _80 = -0.35844698548316956f;
  }
  float4 _89 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_50 * 0.984375f) + 0.0078125f), ((_65 * 0.984375f) + 0.0078125f), ((_80 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = _89.x;
  SV_Target.y = _89.y;
  SV_Target.z = _89.z;
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


