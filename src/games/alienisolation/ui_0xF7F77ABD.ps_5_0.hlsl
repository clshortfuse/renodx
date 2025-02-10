#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:42 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : COLOR1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v1.w * v0.w;
  o0.xyz = v0.xyz * r0.xxx;
  o0.w = r0.x;

  o0 = UIScale(o0);
  return;
}