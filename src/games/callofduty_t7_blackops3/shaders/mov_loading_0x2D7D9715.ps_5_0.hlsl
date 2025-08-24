// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 01 10:20:55 2025

#include "../common.hlsl"

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  
  //video color
  r0.x = t0.Sample(s1_s, v1.xy).x;
  r0.x = -0.0625 + r0.x;
  r1.xy = t6.Sample(s2_s, v1.xy).xy;
  r0.yz = float2(-0.5,-0.5) + r1.xy;
  o0.x = dot(float2(1.16439998,1.79270005), r0.xz);
  o0.y = dot(float3(1.16439998,-0.213300005,-0.532899976), r0.xyz);
  o0.z = dot(float2(1.16439998,2.11240005), r0.xy);

  //autohdr
  o0.xyz = PumboAutoHDR(o0.xyz);
  // o0.xyz = renodx::draw::UpscaleVideoPass(o0.xyz);

  return;
}