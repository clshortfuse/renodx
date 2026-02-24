#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  SV_Target.x = mad(_7.z, 0.047374799847602844f, mad(_7.y, 0.33951008319854736f, (_7.x * 0.6131157279014587f)));
  SV_Target.y = mad(_7.z, 0.013449129648506641f, mad(_7.y, 0.9163550138473511f, (_7.x * 0.07019715756177902f)));
  SV_Target.z = mad(_7.z, 0.8698007464408875f, mad(_7.y, 0.10957999527454376f, (_7.x * 0.020619075745344162f)));
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


