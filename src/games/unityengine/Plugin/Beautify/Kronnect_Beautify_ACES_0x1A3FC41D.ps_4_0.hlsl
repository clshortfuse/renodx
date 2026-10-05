#include "../../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[145];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.SampleBias(s3_s, v3.xy, cb0[5].x).xyzw;
  r0.x = cb0[23].x * r0.x + cb0[23].y;
  r0.x = 1 / r0.x;
  r1.xyzw = t1.SampleBias(s3_s, w1.xy, cb0[5].x).xyzw;
  r0.y = cb0[23].x * r1.x + cb0[23].y;
  r0.y = 1 / r0.y;
  r0.z = max(r0.y, r0.x);
  r0.x = min(r0.y, r0.x);
  r1.xyzw = t1.SampleBias(s3_s, v2.xy, cb0[5].x).xyzw;
  r0.y = cb0[23].x * r1.x + cb0[23].y;
  r0.y = 1 / r0.y;
  r0.z = max(r0.z, r0.y);
  r1.xyzw = t1.SampleBias(s3_s, w2.xy, cb0[5].x).xyzw;
  r0.w = cb0[23].x * r1.x + cb0[23].y;
  r0.w = 1 / r0.w;
  r0.z = max(r0.z, r0.w);
  r0.x = min(r0.x, r0.y);
  r0.y = -cb0[138].z + r0.y;
  r0.y = cmp(abs(r0.y) < cb0[138].w);
  r0.y = r0.y ? 1.000000 : 0;
  r0.x = min(r0.x, r0.w);
  r0.x = r0.z + -r0.x;
  r0.x = 9.99999997e-007 + r0.x;
  r0.x = saturate(cb0[139].y / r0.x);
  r1.xyzw = t0.SampleBias(s0_s, w1.xy, cb0[5].x).xyzw;
  r0.z = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r1.xyzw = t0.SampleBias(s0_s, v3.xy, cb0[5].x).xyzw;
  r0.w = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r1.x = min(r0.z, r0.w);
  r0.z = max(r0.z, r0.w);
  r2.xyzw = t0.SampleBias(s0_s, v2.xy, cb0[5].x).xyzw;
  r0.w = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r1.x = min(r1.x, r0.w);
  r0.z = max(r0.z, r0.w);
  r2.xyzw = t0.SampleBias(s0_s, w2.xy, cb0[5].x).xyzw;
  r0.w = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r1.x = min(r1.x, r0.w);
  r0.z = max(r0.z, r0.w);
  r0.w = -9.99999997e-007 + r1.x;
  r1.x = r0.z + -r0.w;
  r1.x = saturate(cb0[139].w / r1.x);
  r2.xyzw = t0.SampleBias(s2_s, v1.xy, cb0[5].x).xyzw;
  r1.yzw = max(float3(0,0,0), r2.xyz);
  o0.w = r2.w;
  r1.yzw = min(cb0[142].zzz, r1.yzw);
  r2.x = dot(r1.yzw, float3(0.298999995,0.587000012,0.114));
  r0.w = r2.x * 2 + -r0.w;
  r2.x = saturate(1 + -r2.x);
  r0.z = r0.w + -r0.z;
  r0.z = r0.z * r1.x;
  r0.x = r0.z * r0.x;
  r0.x = cb0[139].x * r0.x;
  r0.x = max(-cb0[139].z, r0.x);
  r0.x = min(cb0[139].z, r0.x);
  r0.x = r0.x * r0.y + 1;
  r3.xyzw = t2.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.yzw = cb0[140].xxx * r3.xyz;
  r0.xyz = r1.yzw * r0.xxx + r0.yzw;
  /*r0.xyz = cb0[142].xxx * r0.xyz;
  r1.x = dot(float3(0.597190022,0.354579985,0.0482299998), r0.xyz);
  r1.y = dot(float3(0.0759999976,0.908339977,0.0156599991), r0.xyz);
  r1.z = dot(float3(0.0284000002,0.133829996,0.837769985), r0.xyz);
  r0.xyz = float3(0.0245785993,0.0245785993,0.0245785993) + r1.xyz;
  r0.xyz = r1.xyz * r0.xyz + float3(-9.05370034e-005,-9.05370034e-005,-9.05370034e-005);
  r2.yzw = r1.xyz * float3(0.983729005,0.983729005,0.983729005) + float3(0.432951003,0.432951003,0.432951003);
  r1.xyz = r1.xyz * r2.yzw + float3(0.238080993,0.238080993,0.238080993);
  r0.xyz = r0.xyz / r1.xyz;
  r1.x = saturate(dot(float3(1.60475004,-0.531080008,-0.0736699998), r0.xyz));
  r1.y = saturate(dot(float3(-0.102080002,1.10812998,-0.00604999997), r0.xyz));
  r1.z = saturate(dot(float3(-0.00326999999, -0.0727600008, 1.07602), r0.xyz));
  r0.xyz = cb0[142].yyy * r1.xyz;*/
  r0.xyz = SHAcesTonemap(r0.xyz, cb0[142].x, cb0[142].y);
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.w = min(r0.y, r0.z);
  r1.w = min(r1.w, r0.x);
  r0.w = saturate(-r1.w + r0.w);
  r0.w = 1 + -r0.w;
  r0.w = cb0[143].z * r0.w;
  r1.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r1.xyz = r1.xyz * cb0[142].yyy + -r1.www;
  r1.xyz = r0.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[144].xyz + -r0.xyz;
  r0.xyz = cb0[144].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[143].yyy + float3(0.5,0.5,0.5);
  r1.xy = cb0[135].xy * v1.xy;
  r1.xy = cb0[132].zw * r1.xy;
  r1.xyzw = t3.SampleBias(s1_s, r1.xy, cb0[5].x).xyzw;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = cb0[143].www * r1.xyz;
  r1.xyz = r1.xyz * r2.xxx;
  r0.xyz = r0.xyz * cb0[143].xxx + r1.xyz;
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}