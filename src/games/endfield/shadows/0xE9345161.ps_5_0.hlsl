// ---- Created with 3Dmigoto v1.4.1 on Sun Feb 15 13:39:39 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float oDepth : SV_Depth)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Gather(s0_s, v1.xy).xyzw;
  r0.xy = min(r0.xz, r0.yw);
  oDepth = min(r0.x, r0.y);
  return;
}