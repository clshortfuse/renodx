#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 03:22:39 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : COLOR1,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v0.xyzw * v3.xyzw + v2.xyzw;
  o0.w = v1.w * r0.w;
  o0.xyz = r0.xyz;

  o0 = UIScale(o0);
  return;
}