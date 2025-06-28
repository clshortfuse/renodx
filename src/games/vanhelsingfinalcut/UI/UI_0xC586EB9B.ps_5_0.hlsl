#include "../common.hlsl"

SamplerState _g_sSlot1_s : register(s0);
Texture2D<float4> _TMP5 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = _TMP5.Sample(_g_sSlot1_s, v1.xy).x;
  o0.xyz = UIScale(r0.xxx);
  o0.w = 1;
  return;
}