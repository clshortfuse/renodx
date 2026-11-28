// ---- Created with 3Dmigoto v1.3.16 on Sun Mar 08 14:19:56 2026

cbuffer PSConstants : register(b0)
{
  float4 cxmul : packoffset(c0);
  float4 cxadd : packoffset(c1);
}



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

  r0.xyzw = v0.xyzw * cxmul.xyzw + cxadd.xyzw;
  o0.w = saturate(v1.w * r0.w);
  o0.xyz = saturate(r0.xyz);
  return;
}