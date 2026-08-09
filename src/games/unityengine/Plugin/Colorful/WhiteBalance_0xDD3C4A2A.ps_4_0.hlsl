#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(float3(0.381099999,0.578299999,0.0401999988), cb0[2].xyz);
  r0.x = 9.99999997e-07 + r0.x;
  r0.x = 0.5 / r0.x;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.y = dot(float3(0.381099999,0.578299999,0.0401999988), r1.xyz);
  r0.x = r0.x * r0.y;
  r0.w = dot(float3(0.196700007,0.724399984,0.0781999975), cb0[2].xyz);
  r0.w = 9.99999997e-07 + r0.w;
  r0.w = 0.5 / r0.w;
  r1.w = dot(float3(0.196700007,0.724399984,0.0781999975), r1.xyz);
  r1.x = dot(float3(0.0241,0.128800005,0.844399989), r1.xyz);
  r0.y = r1.w * r0.w;
  r0.w = dot(float3(0.0241,0.128800005,0.844399989), cb0[2].xyz);
  r0.w = 9.99999997e-07 + r0.w;
  r0.w = 0.5 / r0.w;
  r0.z = r0.w * r1.x;
  o0.x = dot(float3(4.4678998,-3.58730006,0.1193), r0.xyz);
  o0.y = dot(float3(-1.21860003,2.38089991,-0.162400007), r0.xyz);
  o0.z = dot(float3(0.0496999994,-0.243900001,1.20449996), r0.xyz);
  if(injectedData.toneMapType == 0.f){
	o0.xyz = saturate(o0.xyz);
  }
  o0.w = 1;
  return;
}