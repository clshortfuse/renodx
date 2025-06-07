#include "./common.hlsl"

SamplerState _g_sSlot0_s : register(s0);
Texture2D<float4> _TMP4 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = _TMP4.Sample(_g_sSlot0_s, v1.xy).xyzw;
  o0.xyz = UIScale(o0.xyz);
  return;
}