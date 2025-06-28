#include "../common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fTimer : packoffset(c0);
  float4 _g_vDiffuseColor : packoffset(c1);
  float4 _g_vHighliteColor : packoffset(c2);
  float4 _g_vTCMulAdd : packoffset(c3);
  float4 _vLineOffset : packoffset(c4);
  float4 _vLineParams : packoffset(c5);
}
SamplerState _g_sSlot0_s : register(s0);
Texture2D<float4> _TMP11 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -_vLineParams.x + _vLineOffset.z;
  r0.x = 0.5 * r0.x;
  r0.x = _vLineOffset.z / r0.x;
  r0.y = 0.5 * r0.x;
  r0.y = -r0.x * v1.y + r0.y;
  r0.x = -r0.x * 0.5 + abs(r0.y);
  r0.x = saturate(1 + r0.x);
  r0.x = 1 + -r0.x;
  r0.x = log2(r0.x);
  r0.x = 2.5 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = _g_vHighliteColor.w * r0.x;
  r0.y = _vLineParams.x / _vLineOffset.z;
  r0.z = -r0.y * 0.5 + 0.5;
  r0.z = v1.y + -r0.z;
  r0.z = r0.z / r0.y;
  r0.w = _vLineParams.x * 0.5;
  r0.w = -_vLineParams.x * r0.z + r0.w;
  r0.w = -_vLineParams.x * 0.5 + abs(r0.w);
  r0.w = saturate(1 + r0.w);
  r0.w = 1 + -r0.w;
  r1.x = 1 + -r0.w;
  r2.w = r1.x * r0.x;
  r2.xyz = _g_vHighliteColor.xyz * r1.xxx;
  r0.y = v1.x;
  r0.yz = r0.yz * _g_vTCMulAdd.xy + _g_vTCMulAdd.zw;
  r0.x = _g_fTimer * _vLineOffset.w + r0.y;
  r1.xyzw = _TMP11.Sample(_g_sSlot0_s, r0.xz).xyzw;
  r1.xyzw = _g_vDiffuseColor.xyzw * r1.xyzw;
  o0.xyzw = r1.xyzw * r0.wwww + r2.xyzw;
  o0.rgb = UIScale(o0.rgb);
  return;
}