// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 27 02:30:00 2025



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  linear noperspective float4 v1 : TXAA_PV0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v1.x < 0.5);
  o0.xyzw = r0.xxxx ? float4(898781440,791253.25,8.49942688e+14,1.01438831e-08) : float4(1.18418999e-11,1.00801971e-08,9.8439425e-12,9.8439425e-12);

  o0.w = saturate(o0.w);
  return;
}