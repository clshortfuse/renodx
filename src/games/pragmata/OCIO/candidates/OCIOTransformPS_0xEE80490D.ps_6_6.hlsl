#include "../../common.hlsli"

Texture2D<float4> SrcTexture : register(t0);

SamplerState PointBorder : register(s2, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _29 = exp2(log2(saturate(mad(_7.z, 0.047374799847602844f, mad(_7.y, 0.33951008319854736f, (_7.x * 0.6131157279014587f))))) * 0.012683313339948654f);
  float _30 = exp2(log2(saturate(mad(_7.z, 0.013449129648506641f, mad(_7.y, 0.9163550138473511f, (_7.x * 0.07019715756177902f))))) * 0.012683313339948654f);
  float _31 = exp2(log2(saturate(mad(_7.z, 0.8698007464408875f, mad(_7.y, 0.10957999527454376f, (_7.x * 0.020619075745344162f))))) * 0.012683313339948654f);
  float _53 = exp2(log2(max(0.0f, (_29 + -0.8359375f)) / (18.8515625f - (_29 * 18.6875f))) * 6.277394771575928f);
  float _56 = exp2(log2(max(0.0f, (_30 + -0.8359375f)) / (18.8515625f - (_30 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _57 = exp2(log2(max(0.0f, (_31 + -0.8359375f)) / (18.8515625f - (_31 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  SV_Target.x = mad(-0.07285170257091522f, _57, mad(-0.5876399874687195f, _56, (_53 * 166.04910278320312f)));
  SV_Target.y = mad(-0.00834800023585558f, _57, mad(1.1328999996185303f, _56, (_53 * -12.454999923706055f)));
  SV_Target.z = mad(1.1187299489974976f, _57, mad(-0.10057900100946426f, _56, (_53 * -1.8150999546051025f)));
  SV_Target.w = 1.0f;

  // SV_Target = 0;

  return SV_Target;
}

