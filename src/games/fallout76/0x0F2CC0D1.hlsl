// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:45 2024

SamplerState SampBase_s : register(s0);
Texture2D<float4> TexBase : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = TexBase.Sample(SampBase_s, v1.xy).xyzw;
  o0.xyzw = r0.zyxw;
  return;
}