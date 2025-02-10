#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu May 30 01:30:34 2024



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : COLOR1,
  out float4 o0 : SV_Target0)
{
  o0.w = saturate(v1.w * v0.w);
  o0.xyz = v0.xyz;

  o0 = UIScale(o0);
  return;
}