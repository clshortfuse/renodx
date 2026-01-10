// UI/particle sprite shader with optional prem multiplied alpha control.
Texture2D<float4> DiffuseTexture : register(t0);

cbuffer Batch : register(b0) {
  float4 WorldViewProj[4] : packoffset(c000.x);
  float EffectParam : packoffset(c004.x);
  float PremultipliedAlpha : packoffset(c004.y);
};

SamplerState DiffuseTexture_Sampler : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR : COLOR,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // Sample sprite color in texture space.
  float4 _7 = DiffuseTexture.Sample(DiffuseTexture_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  // Blend between straight and premultiplied alpha depending on control parameter.
  float _16 = (PremultipliedAlpha * (_7.w + -1.0f)) + 1.0f;
  SV_Target.x = ((_7.x * COLOR.w) * _16);
  SV_Target.y = ((_7.y * COLOR.w) * _16);
  SV_Target.z = ((_7.z * COLOR.w) * _16);
  SV_Target.w = COLOR.w;
  return SV_Target;
}
