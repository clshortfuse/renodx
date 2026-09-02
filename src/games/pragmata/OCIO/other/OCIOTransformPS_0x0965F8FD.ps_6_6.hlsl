#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _13 = mad(_7.z, 0.047374799847602844f, mad(_7.y, 0.33951008319854736f, (_7.x * 0.6131157279014587f)));
  float _16 = mad(_7.z, 0.013449129648506641f, mad(_7.y, 0.9163550138473511f, (_7.x * 0.07019715756177902f)));
  float _19 = mad(_7.z, 0.8698007464408875f, mad(_7.y, 0.10957999527454376f, (_7.x * 0.020619075745344162f)));
  float _30;
  float _41;
  float _52;
  if (!(!(_13 >= 0.03928571194410324f))) {
    _30 = exp2(log2((_13 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _30 = (_13 * 0.07738011330366135f);
  }
  if (!(!(_16 >= 0.03928571194410324f))) {
    _41 = exp2(log2((_16 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _41 = (_16 * 0.07738011330366135f);
  }
  if (!(!(_19 >= 0.03928571194410324f))) {
    _52 = exp2(log2((_19 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f);
  } else {
    _52 = (_19 * 0.07738011330366135f);
  }
  SV_Target.x = _30;
  SV_Target.y = _41;
  SV_Target.z = _52;
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


