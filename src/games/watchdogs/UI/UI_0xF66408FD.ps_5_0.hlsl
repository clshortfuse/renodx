#include "../common.hlsl"

cbuffer cb0 : register(b0){
  float4 cb0[21];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v0.xyz, float3(0.298999995,0.587000012,0.114));
  r0.yzw = v0.xyz + -r0.xxx;
  r0.xyz = cb0[20].zzz * r0.yzw + r0.xxx;
  r0.w = v0.w;
  o0.xyzw = r0.xyzw * cb0[1].xyzw + cb0[0].xyzw;
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  return;
}