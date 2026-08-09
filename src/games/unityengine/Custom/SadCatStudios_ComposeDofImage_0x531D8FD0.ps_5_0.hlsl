#include "../shared.h"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : VAR_UV0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.SampleLevel(s0_s, v1.xy, 0).x;
  r0.x = saturate(-r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.x * r0.x;
  r0.yzw = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
  float3 preDoF = r0.yzw;
  r1.xyz = t4.SampleLevel(s1_s, v1.xy, 0).xyz;
  r1.xyz = float3(8,8,8) * r1.xyz;
  r0.yzw = r0.yzw * float3(8,8,8) + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;
  r1.xyz = t2.SampleLevel(s1_s, v1.xy, 0).xyz;
  r0.xyz = -r1.xyz * float3(8,8,8) + r0.xyz;
  r1.xyz = float3(8,8,8) * r1.xyz;
  r0.w = t3.SampleLevel(s1_s, v1.xy, 0).x;
  r0.w = 1 + -r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = t5.SampleLevel(s1_s, v1.xy, 0).xyz;
  r0.xyz = r1.xyz * float3(8,8,8) + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  o0.xyz = float3(0.125,0.125,0.125) * r0.xyz;
  o0.xyz = lerp(preDoF, o0.xyz, injectedData.fxDoF);
  o0.w = 1;
  return;
}