#include "../common.hlsl"

SamplerState _g_sSlot0_s : register(s0);
Texture2D<float4> _TMP1 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _TMP1.Sample(_g_sSlot0_s, v1.xy).xyzw;
  o0.xyzw = v2.xyzw * r0.xyzw;
  o0.a = saturate(o0.a);
  o0.rgb = UIScale(o0.rgb);
  return;
}