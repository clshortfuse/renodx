#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + cb0[0].xyzw;
  r0.xyzw = cb0[0].wwww * r0.xyzw * injectedData.fxProfiler + float4(0.5,0.5,0.5,0.5);
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw + r0.xyzw;
  return;
}