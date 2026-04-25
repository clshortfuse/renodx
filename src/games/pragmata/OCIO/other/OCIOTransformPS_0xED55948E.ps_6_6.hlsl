#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

cbuffer OCIOTransformMatrix : register(b0) {
  row_major float4x4 OCIO_TransformMatrix : packoffset(c000.x);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  SV_Target.x = mad(_9.z, (OCIO_TransformMatrix[2].x), mad(_9.y, (OCIO_TransformMatrix[1].x), ((OCIO_TransformMatrix[0].x) * _9.x)));
  SV_Target.y = mad(_9.z, (OCIO_TransformMatrix[2].y), mad(_9.y, (OCIO_TransformMatrix[1].y), ((OCIO_TransformMatrix[0].y) * _9.x)));
  SV_Target.z = mad(_9.z, (OCIO_TransformMatrix[2].z), mad(_9.y, (OCIO_TransformMatrix[1].z), ((OCIO_TransformMatrix[0].z) * _9.x)));
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


