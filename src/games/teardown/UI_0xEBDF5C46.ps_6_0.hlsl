Texture2D<float4> uTexture : register(t16);
cbuffer TextPerObjectBuffer : register(b3) {
  float4 mubMvpMatrix[4] : packoffset(c000.x);
  float4 mubColor : packoffset(c004.x);
  float4 mubLowerUpper : packoffset(c005.x);
};
SamplerState MinMagLinearMipNearestWrapRepaet : register(s2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 COLOR : COLOR
) : SV_Target {
  float4 SV_Target;
  float4 _10 = uTexture.Sample(MinMagLinearMipNearestWrapRepaet, float2(TEXCOORD.x, TEXCOORD.y));
  float _15 = mubLowerUpper.y - mubLowerUpper.x;
  float _16 = _10.x - mubLowerUpper.x;
  float _17 = _16 / _15;
  float _18 = saturate(_17);
  float _19 = _18 * 2.0f;
  float _20 = 3.0f - _19;
  float _21 = _18 * _18;
  float _22 = _21 * COLOR.w;
  float _23 = _22 * _20;
  SV_Target.x = COLOR.x;
  SV_Target.y = COLOR.y;
  SV_Target.z = COLOR.z;
  SV_Target.w = saturate(_23);  // added clamp
  return SV_Target;
}
