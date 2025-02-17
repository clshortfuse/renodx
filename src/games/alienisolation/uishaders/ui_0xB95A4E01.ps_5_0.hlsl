#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sat Sep 21 23:16:38 2024

cbuffer Constants : register(b0)
{
  float4 cxmul : packoffset(c0);
}



// 3Dmigoto declarations
#define cmp -


void main(
  out float4 o0 : SV_Target0)
{
  o0.xyzw = cxmul.xyzw;
  // not sure if this does anything

  o0 = UIScale(o0);
  return;
}