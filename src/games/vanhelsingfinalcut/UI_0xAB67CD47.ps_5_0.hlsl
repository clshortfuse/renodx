#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fBrightness : packoffset(c0);
  float _g_fContrast : packoffset(c1);
  float _g_fGamma : packoffset(c2);
  float4 _g_vDiffuseColor : packoffset(c3);
  float4 _g_vHighliteColor : packoffset(c4);
  float _g_fUIDesat : packoffset(c5);
}
SamplerState _g_sSlot0Clamp_s : register(s0);
Texture2D<float4> _TMP23 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = rsqrt(r0.x);
  r0.x = 1 / r0.x;
  r0.y = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.x = r0.x * 2.82841778 + 1;
  r1.xyzw = _TMP23.Sample(_g_sSlot0Clamp_s, v1.xy).xyzw;
  r0.y = dot(r1.xyz, float3(0.333332986,0.333332986,0.333332986));
  r2.xyz = r1.xyz + -r0.yyy;
  r0.yzw = r2.xyz * float3(1.25,1.25,1.25) + r0.yyy;
  r0.yzw = r0.yzw * float3(1.29999995,1.29999995,1.29999995) + float3(-0.100000001,-0.100000001,-0.100000001);
  r0.xyz = r0.yzw * r0.xxx + -r1.xyz;
  r1.xyz = _g_fUIDesat * r0.xyz + r1.xyz;
  r0.xyzw = r1.xyzw * _g_vDiffuseColor.xyzw + _g_vHighliteColor.xyzw;
  r0.xyz = max(float3(0.0009765625,0.0009765625,0.0009765625), r0.xyz);
  o0 = saturate(r0);
  o0.rgb = UIScale(o0.rgb);
  return;
}