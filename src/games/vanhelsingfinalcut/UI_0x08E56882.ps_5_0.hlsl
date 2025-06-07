#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float4 _g_vDiffuseColor : packoffset(c0);
  float4 _g_vHighliteColor : packoffset(c1);
  float2 _g_vAlphaMaskRange : packoffset(c2);
}
SamplerState _g_sSlot0Clamp_s : register(s0);
SamplerState _g_sSlot1_s : register(s1);
Texture2D<float4> _TMP7 : register(t0);
Texture2D<float4> _TMP8 : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = _TMP7.Sample(_g_sSlot1_s, v1.xy).w;
  r0.y = -_g_vAlphaMaskRange.x + r0.x;
  r0.x = _g_vAlphaMaskRange.y + -r0.x;
  if (r0.x < 0) discard;
  if (r0.y < 0) discard;
  r0.xyzw = _TMP8.Sample(_g_sSlot0Clamp_s, v1.xy).xyzw;
  o0.xyzw = r0.xyzw * _g_vDiffuseColor.xyzw + _g_vHighliteColor.xyzw;
  return;
}