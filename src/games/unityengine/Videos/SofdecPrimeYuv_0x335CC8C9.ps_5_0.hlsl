#include "../shared.h"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[182];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD4,
  float3 v3 : TEXCOORD5,
  float4 v4 : COLOR0,
  float4 v5 : SV_POSITION0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s1_s, v0.xy).w;
  r0.y = t2.Sample(s2_s, v1.xy).w;
  r0.z = t3.Sample(s3_s, v1.xy).w;
  r0.xyz = float3(-0.0627499968,-0.50195998,-0.50195998) + r0.xyz;
  r1.x = dot(float2(1.16437995,1.59603), r0.xz);
  r1.y = dot(float3(1.16437995,-0.391759992,-0.812969983), r0.xyz);
  r1.z = dot(float2(1.16437995,2.01723003), r0.xy);
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  if(injectedData.toneMapType == 0.f){
  r0.xyz = min(float3(1,1,1), r0.xyz);
  }
  r1.x = 1 + -cb0[179].y;
  r0.w = v4.w * r1.x;
  if (cb0[179].w == 1.0) {
    r1.xyzw = cb0[179].zzzz * r0.xyzw;
    r2.xyzw = t0.Sample(s0_s, w0.xy).xyzw;
    r2.w = log2(abs(r2.w));
    r2.w = 2.20000005 * r2.w;
    r2.w = exp2(r2.w);
    r2.w = 34.4932404 * r2.w;
    r3.xyz = r2.xyz * r2.www;
    r4.xy = cb0[180].xy >= float2(0.1,0.1) ? float2(1,1) : 0;
    r2.xyz = r2.xyz * r2.www + r0.xyz;
    r2.xyz = cb0[181].xxx * r2.xyz;
    r3.xyz = r3.xyz * r0.xyz;
    r3.xyz = r3.xyz * cb0[181].xxx + -r2.xyz;
    r2.xyz = r4.xxx * r3.xyz + r2.xyz;
    r2.xyz = r2.xyz + -r0.xyz;
    r2.xyz = cb0[180].www * r2.xyz + r0.xyz;
    r2.xyz = cb0[180].zzz * r2.xyz;
    r2.w = r0.w;
    r3.xyzw = -r0.xyzw * cb0[179].zzzz + r2.xyzw;
    r1.xyzw = r4.yyyy * r3.xyzw + r1.xyzw;
    r0.xyz = r2.xyz;
  } else {
    r1.xyzw = float4(0,0,0,0);
  }
  r2.x = trunc(cb0[179].w);
  r1.xyzw = r1.xyzw + -r0.xyzw;
  o0.xyzw = r2.xxxx * r1.xyzw + r0.xyzw;
  o1.xyzw = float4(0,1,0,0);
  return;
}