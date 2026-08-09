#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[13];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v2.zw).xyzw;
  r0.xyz = float3(0,1,0) * r0.xyz;
  r1.xyzw = t1.Sample(s1_s, v2.xy).xyzw;
  r0.xyz = r1.xyz * float3(1,0,0) + r0.xyz;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.xyz = r1.xyz * float3(0,0,1) + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyz = cb0[3].xyz * r1.xyz;
  r1.xy = r2.xx + r2.yz;
  r0.w = r2.y * r1.y;
  r1.x = r1.z * cb0[3].z + r1.x;
  o0.w = r1.w;
  r0.w = sqrt(r0.w);
  r0.w = dot(cb0[3].ww, r0.ww);
  r0.w = r1.x + r0.w;
  r0.w = -cb0[12].x + r0.w;
  r1.xy = saturate(cb0[12].yz * r0.ww);
  r0.w = dot(cb0[10].zy, r1.xy);
  r0.w = max(0, r0.w);
  r0.w = cb0[10].x * injectedData.fxFilmGrain + r0.w;
  r1.xyz = cb0[8].xyz * r0.www;
  o0.xyz = saturate(r1.xyz * r0.xyz + float3(0.5,0.5,0.5));
  return;
}