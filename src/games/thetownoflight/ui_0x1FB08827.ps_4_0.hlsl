#include "C:\Users\Musa\Documents\Programming Projects\renodx\src\shaders\renodx.hlsl"
#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Tue Dec 03 21:18:49 2024
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[9];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  
  r0.xy = cmp(v3.xy >= cb0[8].xy);
  r0.zw = cmp(cb0[8].zw >= v3.xy);
  r0.xyzw = r0.xyzw ? float4(1,1,1,1) : 0;
  r0.xy = r0.xy * r0.zw;
  r0.x = r0.x * r0.y;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = cb0[7].xyzw + r1.xyzw;
  r1.xyzw = v1.xyzw * r1.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;

  o0.xyz = UIScale(o0.xyz, 1.f);
  return;
}