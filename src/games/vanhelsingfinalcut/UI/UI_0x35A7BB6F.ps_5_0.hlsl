#include "../common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fLSProgress : packoffset(c0);
}
SamplerState _g_sSlot0_s : register(s0);
SamplerState _g_sSlot1_s : register(s1);
Texture2D<float4> _TMP5 : register(t0);
Texture2D<float4> _TMP6 : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = _TMP6.Sample(_g_sSlot1_s, v1.xy).x;
  r0.x = 1 + -r0.x;
  r0.y = -_g_fLSProgress + 1;
  r0.z = r0.y * 1.15 + -0.15;
  r0.y = r0.y * 1.15 + -r0.z;
  r0.x = r0.x + -r0.z;
  r0.x = saturate(r0.x / r0.y);
  r1.xyzw = _TMP5.Sample(_g_sSlot0_s, v1.xy).xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = UIScale(r1.xyz);
  return;
}