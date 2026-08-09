#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[30];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r0.w = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[29].xxx * r0.xyz + r0.www;
  r0.w = -cb0[29].z * 0.5 + 0.5;
  r0.xyz = r0.xyz * cb0[29].zzz + r0.www;
  r0.w = -1 + cb0[29].y;
  r0.xyz = r0.xyz + r0.www;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyz = cb0[28].xyz * r0.xyz;
  return;
}