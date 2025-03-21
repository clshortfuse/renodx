// ---- Created with 3Dmigoto v1.4.1 on Thu Mar 20 19:55:35 2025
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
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;

  float3 input_color = r0.rgb;

  r0.xyzw = r0.xyzw * cb0[2].xxxx + float4(-0.5, -0.5, -0.5, -0.5);
  o0.xyzw = r0.xyzw * cb0[2].yyyy + float4(0.5, 0.5, 0.5, 0.5);

  o0.rgb = input_color;
  return;
}