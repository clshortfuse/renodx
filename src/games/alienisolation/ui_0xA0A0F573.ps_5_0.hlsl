#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:26 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : COLOR1,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = v1.wwww * v0.wwww;

  o0 = UIScale(o0);
  return;
}