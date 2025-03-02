Texture2D<float4> HDRImage : register(t0);

SamplerState BilinearClamp : register(s5, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = HDRImage.Sample(BilinearClamp, float2((TEXCOORD.x), (TEXCOORD.y)));
  float _21 = exp2(((log2((saturate((_7.x))))) * 0.012683313339948654f));
  float _22 = exp2(((log2((saturate((_7.y))))) * 0.012683313339948654f));
  float _23 = exp2(((log2((saturate((_7.z))))) * 0.012683313339948654f));
  float _45 = exp2(((log2(((max(0.0f, (_21 + -0.8359375f))) / (18.8515625f - (_21 * 18.6875f))))) * 6.277394771575928f));
  float _48 = (exp2(((log2(((max(0.0f, (_22 + -0.8359375f))) / (18.8515625f - (_22 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  float _49 = (exp2(((log2(((max(0.0f, (_23 + -0.8359375f))) / (18.8515625f - (_23 * 18.6875f))))) * 6.277394771575928f))) * 100.0f;
  SV_Target.x = (mad(-0.07285170257091522f, _49, (mad(-0.5876399874687195f, _48, (_45 * 166.04910278320312f)))));
  SV_Target.y = (mad(-0.00834800023585558f, _49, (mad(1.1328999996185303f, _48, (_45 * -12.454999923706055f)))));
  SV_Target.z = (mad(1.1187299489974976f, _49, (mad(-0.10057900100946426f, _48, (_45 * -1.8150999546051025f)))));
  SV_Target.w = (_7.w);
  return SV_Target;
}
