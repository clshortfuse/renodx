#include "../common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fBrightness : packoffset(c0);
  float _g_fContrast : packoffset(c1);
  float _g_fGamma : packoffset(c2);
  float4 _g_vDiffuseColor : packoffset(c3);
  float4 _g_vHighliteColor : packoffset(c4);
  float _g_fUIDesat : packoffset(c5);
}
SamplerState _g_sSlot0Clamp_s : register(s0);
Texture2D<float4> _TMP14 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _TMP14.Sample(_g_sSlot0Clamp_s, v1.xy).xyzw;
  r1.x = dot(r0.xyz, float3(0.333332986,0.333332986,0.333332986));
  r1.y = -r1.x + r0.x;
  r0.xyz = _g_fUIDesat * r1.yyy + r1.xxx;
  r0.xyzw = r0.xyzw * _g_vDiffuseColor.xyzw + _g_vHighliteColor.xyzw;
  r0.xyz = max(float3(0.0009765625,0.0009765625,0.0009765625), r0.xyz);
  o0.w = r0.w;
  o0.xyz = UIScale(r0.xyz);
  return;
}