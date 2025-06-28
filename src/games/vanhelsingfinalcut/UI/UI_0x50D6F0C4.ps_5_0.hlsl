#include "../common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fBrightness : packoffset(c0);
  float _g_fContrast : packoffset(c1);
  float _g_fGamma : packoffset(c2);
  float4 _g_vDiffuseColor : packoffset(c3);
  float4 _g_vHighliteColor : packoffset(c4);
}
SamplerState _g_sSlot0Clamp_s : register(s0);
SamplerState _g_sSlot1_s : register(s1);
Texture2D<float4> _TMP17 : register(t0);
Texture2D<float4> _TMP18 : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = ddx_coarse(v1.xy);
  r0.zw = r0.xy * float2(0.699999988,0.699999988) + v1.xy;
  r0.xy = -r0.xy * float2(0.699999988,0.699999988) + v1.xy;
  r1.xyzw = _TMP17.Sample(_g_sSlot0Clamp_s, r0.xy).xyzw;
  r0.xyzw = _TMP17.Sample(_g_sSlot0Clamp_s, r0.zw).xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xy = ddy_coarse(v1.xy);
  r1.zw = r1.xy * float2(0.699999988,0.699999988) + v1.xy;
  r1.xy = -r1.xy * float2(0.699999988,0.699999988) + v1.xy;
  r2.xyzw = _TMP17.Sample(_g_sSlot0Clamp_s, r1.xy).xyzw;
  r1.xyzw = _TMP17.Sample(_g_sSlot0Clamp_s, r1.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r2.xyzw;
  r0.xyzw = float4(0.174999997,0.174999997,0.174999997,0.174999997) * r0.xyzw;
  r1.xyzw = _TMP17.Sample(_g_sSlot0Clamp_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.300000012,0.300000012,0.300000012,0.300000012) + r0.xyzw;
  r1.x = _TMP18.Sample(_g_sSlot1_s, v1.xy).w;
  r0.w = min(r1.x, r0.w);
  r0.xyzw = r0.xyzw * _g_vDiffuseColor.xyzw + _g_vHighliteColor.xyzw;
  r0.xyz = max(float3(0.0009765625,0.0009765625,0.0009765625), r0.xyz);
  o0.w = r0.w;
  o0.xyz = UIScale(r0.xyz);
  return;
}