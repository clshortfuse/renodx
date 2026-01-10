// ---- Created with 3Dmigoto v1.4.1 on Tue Dec  9 16:53:14 2025

SamplerState s_PointClamp_s : register(s10);
Texture2D<float4> t_s0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = t_s0.Sample(s_PointClamp_s, v1.xy).xyzw;
  return;
}