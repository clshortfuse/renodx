// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:27 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + cb0[2].x;
  r0.yz = v1.xy / v1.ww;
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = r1.w;
  return;
}