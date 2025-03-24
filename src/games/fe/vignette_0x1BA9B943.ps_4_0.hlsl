#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.xy = r0.xy + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r1.x = cb0[2].y * r0.x;
  r0.x = -r0.x * cb0[2].x * injectedData.fxVignette + 1;
  r1.x = saturate(r1.x);
  r0.yz = w1.xy * cb0[5].xy + cb0[5].zw;
  r2.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r0.yz = v1.xy * cb0[4].xy + cb0[4].zw;
  r3.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r2.xyzw = -r3.xyzw + r2.xyzw;
  r1.xyzw = r1.xxxx * r2.xyzw + r3.xyzw;
  o0.xyzw = r1.xyzw * r0.xxxx;
  return;
}