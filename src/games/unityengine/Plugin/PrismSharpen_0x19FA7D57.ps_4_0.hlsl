#include "../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0.5,-0.5,-0.5,-0.5) * cb0[3].xyxy;
  r0.xyzw = r0.xyzw * cb0[4].xxxx + w1.xyxy;
  r0.xyzw = r0.xyzw * cb0[2].xyxy + cb0[2].zwzw;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = float4(0.5,0.5,-0.5,0.5) * cb0[3].xyxy;
  r1.xyzw = r1.xyzw * cb0[4].xxxx + w1.xyxy;
  r1.xyzw = r1.xyzw * cb0[2].xyxy + cb0[2].zwzw;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r1.xy = w1.xy * cb0[2].xy + cb0[2].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyz = -r0.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r2.xyz = float3(0.2558,0.6511,0.0931) * cb0[4].zzz;
  r2.w = 0.5 / cb0[4].y;
  r2.xyz = r2.xyz * r2.www;
  r0.w = 1;
  r2.w = 0.5;
  r0.x = saturate(dot(r0.xyzw, r2.xyzw));
  r0.x = dot(cb0[4].yy, r0.xx);
  r0.x = -cb0[4].y + r0.x;
  o0.xyz = r1.xyz + r0.xxx;
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(o0.xyz);
  }
  o0.w = saturate(r1.w);
  return;
}