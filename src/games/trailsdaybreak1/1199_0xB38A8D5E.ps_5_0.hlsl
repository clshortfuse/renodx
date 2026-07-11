// ---- Created with 3Dmigoto v1.3.16 on Mon Oct 21 22:42:43 2024

SamplerState samDefault_s : register(s0);
Texture2D<float4> colorMap : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = colorMap.SampleLevel(samDefault_s, v1.xy, 0).xyzw;
  return;
}