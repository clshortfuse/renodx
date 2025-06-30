// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 09:04:44 2025
Texture2D<float4> t0 : register(t0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v1.xy;
  r0.zw = float2(0,0);
  o0.xyzw = t0.Load(r0.xyz).xyzw;
  return;
}