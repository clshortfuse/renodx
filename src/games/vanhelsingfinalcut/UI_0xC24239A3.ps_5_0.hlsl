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
Texture2D<float4> _TMP30 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.z = rsqrt(r0.z);
  r0.w = 1 / r0.z;
  r0.xy = r0.zz * r0.xy;
  r0.z = 3.1415 * r0.w;
  r0.z = sin(r0.z);
  r0.z = r0.z * -0.00999999978 + r0.w;
  r0.z = -1 + r0.z;
  r0.z = _g_fUIDesat * r0.z + 1;
  r0.xy = r0.xy * r0.zz;
  r0.xy = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.xyzw = _TMP30.Sample(_g_sSlot0Clamp_s, r0.xy).xyzw;
  r1.x = dot(r0.xyz, float3(0.333332986,0.333332986,0.333332986));
  r1.yzw = -r1.xxx + r0.xyz;
  r1.xyz = r1.yzw * float3(1.25,1.25,1.25) + r1.xxx;
  r1.xyz = r1.xyz * float3(1.29999995,1.29999995,1.29999995) + float3(-0.100000001,-0.100000001,-0.100000001);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = _g_fUIDesat * r1.xyz + r0.xyz;
  r0.xyzw = r0.xyzw * _g_vDiffuseColor.xyzw + _g_vHighliteColor.xyzw;
  r0.xyz = max(float3(0.0009765625,0.0009765625,0.0009765625), r0.xyz);
  o0.w = r0.w;
  o0.xyz = UIScale(r0.xyz);
  return;
}