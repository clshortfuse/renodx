#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fBrightness : packoffset(c0);
  float _g_fContrast : packoffset(c1);
  float _g_fGamma : packoffset(c2);
  float _g_fAlphaRef : packoffset(c3);
  float4 _g_vDiffuseColor : packoffset(c4);
}
SamplerState _g_sSlot0Clamp_s : register(s0);
Texture2D<float4> _TMP12 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = _TMP12.Sample(_g_sSlot0Clamp_s, v1.xy).w;
  r0.y = -_g_fAlphaRef + r0.x;
  o0.w = _g_vDiffuseColor.w * r0.x;
  if (r0.y < 0) discard;
  r0.xyz = max(_g_vDiffuseColor.xyz, float3(0.0009765625,0.0009765625,0.0009765625));
  o0.xyz = UIScale(r0.xyz);
  return;
}