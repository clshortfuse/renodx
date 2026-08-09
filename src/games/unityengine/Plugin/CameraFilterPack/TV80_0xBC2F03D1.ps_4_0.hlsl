#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[6].x * 0.33 + 0.3;
  r0.x = v0.y * 31 + r0.x;
  r0.yzw = float3(21,29,16) * v0.yyx;
  r0.yz = cb0[6].xx * float2(0.3,0.7) + r0.yz;
  r0.w = v0.y * r0.w;
  r0.xyz = sin(r0.xyz);
  r0.y = r0.y * r0.z;
  r0.x = r0.y * r0.x;
  r0.y = r0.x * 0.0017 + 0.025;
  r0.x = r0.x * 0.0017 + v0.x;
  r1.z = 0.001 + r0.x;
  r0.x = 0.75 * r0.y;
  r0.y = -0.015;
  r1.xyw = float3(0.001,0.001,0.001) + v0.xyy;
  r0.xy = r1.xy + r0.xy;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyz = float3(0.05,0.05,0.05) + r1.xyz;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = r2.xyz * float3(0.08,0.05,0.08) + r1.xyz;
  r1.xyz = r0.xyz * r0.xyz;
  r1.xyz = float3(0.4,0.4,0.4) * r1.xyz;
  r0.xyz = saturate(r0.xyz * float3(0.6,0.6,0.6) + r1.xyz);
  r1.xy = float2(1,1) + -v0.xy;
  r0.w = r1.x * r0.w;
  r0.w = r0.w * r1.y;
  r0.w = log2(r0.w);
  r0.w = 0.3 * r0.w;
  r0.w = exp2(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.w = 3.5 * cb0[6].x;
  r1.x = cb0[7].y * v0.y;
  r0.w = r1.x * 1.5 + r0.w;
  r0.w = sin(r0.w);
  r0.w = r0.w * 0.35 + 0.35;
  r0.w = log2(r0.w);
  r0.xyzw = float4(3.66,2.94,2.66,1.7) * r0.xyzw;
  r0.w = exp2(r0.w);
  r0.w = r0.w * 0.7 + 0.4;
  r0.xyz = r0.xyz * r0.www;
  r1.xy = float2(2.6,110) * cb0[6].xx;
  r0.w = v0.y * 6 + r1.x;
  r1.x = sin(r1.y);
  r1.x = r1.x * 0.01 + 1;
  r0.w = sin(r0.w);
  r0.w = 1.95 + r0.w;
  r0.w = floor(r0.w);
  r0.w = min(1.1, r0.w);
  r0.w = r0.w * 0.25 + r1.x;
  r0.xyz = r0.xyz * r0.www;
  r1.xy = cmp(v0.xy < float2(0,0));
  r1.zw = cmp(float2(1,1) < v0.xy);
  r1.xy = (int2)r1.zw | (int2)r1.xy;
  r0.w = (int)r1.y | (int)r1.x;
  o0.xyz = r0.www ? float3(0,0,0) : r0.xyz;
  o0.w = 1;
  if(injectedData.isClamped != 0.f){
  o0.xyz = saturate(o0.xyz);
  }
  return;
}