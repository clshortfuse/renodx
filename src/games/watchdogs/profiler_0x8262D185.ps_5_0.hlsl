#include "./common.hlsl"

cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + cb0[0].xyzw;
  o0.xyzw = cb0[0].wwww * r0.xyzw * injectedData.fxProfiler + float4(0.5,0.5,0.5,0.5);
  return;
}