// ---- Created with 3Dmigoto v1.3.16 on Wed May 13 19:42:21 2026

cbuffer _Globals : register(b0)
{
  float4 color : packoffset(c0);
}



// 3Dmigoto declarations
#define cmp -


void main(
  out float4 o0 : SV_Target0)
{
  // This pass was authored for an UNORM render target. Keep the original
  // normalized output contract when the target is upgraded to FP16.
  o0.xyzw = saturate(color.xyzw);
  return;
}
