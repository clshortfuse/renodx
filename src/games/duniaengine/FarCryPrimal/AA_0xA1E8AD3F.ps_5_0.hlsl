#include "../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(0, 1)).xyz;
  r1.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(1, 1)).xyz;
  r2.xyz = min(r1.xyz, r0.xyz);
  r0.xyz = max(r1.xyz, r0.xyz);
  r1.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(-1, 1)).xyz;
  r2.xyz = min(r1.xyz, r2.xyz);
  r0.xyz = max(r1.xyz, r0.xyz);
  r1.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(1, 0)).xyz;
  r2.xyz = min(r1.xyz, r2.xyz);
  r0.xyz = max(r1.xyz, r0.xyz);
  r1.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(0, 0)).xyz;
  r2.xyz = min(r1.xyz, r2.xyz);
  r3.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(-1, 0)).xyz;
  r2.xyz = min(r3.xyz, r2.xyz);
  r4.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(1, -1)).xyz;
  r2.xyz = min(r4.xyz, r2.xyz);
  r5.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(0, -1)).xyz;
  r2.xyz = min(r5.xyz, r2.xyz);
  r6.xyz = t2.SampleLevel(s0_s, v1.xy, 0, int2(-1, -1)).xyz;
  r2.xyz = min(r6.xyz, r2.xyz);
  r0.xyz = max(r1.xyz, r0.xyz);
  r0.xyz = max(r3.xyz, r0.xyz);
  r0.xyz = max(r4.xyz, r0.xyz);
  r0.xyz = max(r5.xyz, r0.xyz);
  r0.xyz = max(r6.xyz, r0.xyz);
  r3.xyz = r0.xyz + -r2.xyz;
  r4.xyz = -cb0[6].xxx * r3.xyz + r2.xyz;
  r3.xyz = cb0[6].xxx * r3.xyz + r0.xyz;
  r5.xy = (int2)v0.xy;
  r5.zw = float2(0,0);
  r5.xy = t0.Load(r5.xyz).xy;
  r5.zw = v1.xy + r5.xy;
  r6.xyz = t4.SampleLevel(s1_s, r5.zw, 0).xyz;
  r4.xyz = saturate(-r6.xyz + r4.xyz);
  r3.xyz = saturate(r6.xyz + -r3.xyz);
  r3.xyz = r4.xyz + r3.xyz;
  r0.w = dot(r3.xyz, r3.xyz);
  r0.w = sqrt(r0.w);
  r0.w = cb0[6].w * r0.w;
  r3.xyz = -r6.xyz + r1.xyz;
  r1.rgb = renodx::math::SignPow(r1.rgb, 2.f);
  r4.xyz = max(r6.xyz, r2.xyz);
  r4.xyz = min(r4.xyz, r0.xyz);
  r4.rgb = renodx::math::SignPow(r4.rgb, 2.f);
  r1.w = dot(abs(r3.xyz), abs(r3.xyz));
  r1.w = sqrt(r1.w);
  r0.w = cb0[6].z * r1.w + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = 0.00100000005 + r0.w;
  r0.w = 1 / r0.w;
  r0.w = min(1, r0.w);
  r0.w = max(cb0[6].y, r0.w);
  r0.w = 1 + r0.w;
  r3.xy = cmp(float2(1,1) < r5.zw);
  r3.zw = cmp(r5.zw < float2(0,0));
  r1.w = (int)r3.z | (int)r3.x;
  r1.w = (int)r3.y | (int)r1.w;
  r1.w = (int)r3.w | (int)r1.w;
  r0.w = r1.w ? 2 : r0.w;
  r3.xy = t1.SampleLevel(s1_s, r5.zw, 0).xy;
  r6.xyz = t3.SampleLevel(s1_s, r5.zw, 0).xyz;
  r2.xyz = max(r6.xyz, r2.xyz);
  r0.xyz = min(r2.xyz, r0.xyz);
  r0.rgb = renodx::math::SignPow(r0.rgb, 2.f) - r1.rgb;
  r2.xy = r3.xy + -r5.xy;
  r2.x = dot(r2.xy, r2.xy);
  r2.x = sqrt(r2.x);
  r2.x = -r2.x * 32 + 1;
  r2.x = max(0, r2.x);
  r0.w = -r2.x + r0.w;
  r2.x = 0.5 * r2.x;
  r1.w = r1.w ? 0 : r2.x;
  r0.xyz = r1.www * r0.xyz + r1.xyz;
  r0.w = min(1, r0.w);
  r1.x = 1 + -r0.w;
  r1.xyz = r4.xyz * r1.xxx;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  o0.xyz = renodx::math::SignSqrt(r0.xyz);
  o0.w = 1;
  return;
}