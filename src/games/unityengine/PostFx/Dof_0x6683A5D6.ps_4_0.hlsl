#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -cb0[2].xyxy * float4(0.5,0.5,-0.5,0.5) + w1.xyxy;
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r0.x = cb1[7].z * r0.x + cb1[7].w;
  r0.y = 1 / r0.x;
  r1.x = cb1[7].z * r1.x + cb1[7].w;
  r0.x = 1 / r1.x;
  r1.xyzw = cb0[2].xyxy * float4(-0.5,0.5,0.5,0.5) + w1.xyxy;
  r2.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
  r1.x = cb1[7].z * r1.x + cb1[7].w;
  r0.w = 1 / r1.x;
  r1.x = cb1[7].z * r2.x + cb1[7].w;
  r0.z = 1 / r1.x;
  r1.xyzw = -cb0[4].xxxx + r0.xyzw;
  r1.xyzw = cb0[4].yyyy * r1.xyzw;
  r0.xyzw = r1.xyzw / r0.xyzw;
  r0.xyzw = max(-cb0[4].zzzz, r0.xyzw);
  r0.xyzw = min(cb0[4].zzzz, r0.xyzw);
  r1.xyzw = cb0[4].wwww * abs(r0.xyzw);
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r1.w = saturate(r1.w);
  r0.x = dot(r0.xyzw, float4(0.25,0.25,0.25,0.25));
  r2.xyzw = -cb0[2].xyxy * float4(0.5,0.5,-0.5,0.5) + v1.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r0.y = max(r3.y, r3.z);
  r0.y = max(r3.x, r0.y);
  r0.y = 1 + r0.y;
  r0.y = 1 / r0.y;
  r4.y = r1.y * r0.y;
  r0.yzw = r4.yyy * r3.xyz;
  r1.y = max(r2.y, r2.z);
  r1.y = max(r2.x, r1.y);
  r1.y = 1 + r1.y;
  r1.y = 1 / r1.y;
  r4.x = r1.x * r1.y;
  r0.yzw = r2.xyz * r4.xxx + r0.yzw;
  r2.xyzw = cb0[2].xyxy * float4(-0.5,0.5,0.5,0.5) + v1.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r1.x = max(r3.y, r3.z);
  r1.x = max(r3.x, r1.x);
  r1.x = 1 + r1.x;
  r1.x = 1 / r1.x;
  r4.z = r1.z * r1.x;
  r0.yzw = r3.xyz * r4.zzz + r0.yzw;
  r1.x = max(r2.y, r2.z);
  r1.x = max(r2.x, r1.x);
  r1.x = 1 + r1.x;
  r1.x = 1 / r1.x;
  r4.w = r1.w * r1.x;
  r0.yzw = r2.xyz * r4.www + r0.yzw;
  r1.x = dot(r4.xyzw, float4(1,1,1,1));
  r0.yzw = r0.yzw / r1.xxx;
  r1.x = cb0[2].y + cb0[2].y;
  r1.x = 1 / r1.x;
  r1.x = saturate(r1.x * abs(r0.x));
  o0.w = r0.x;
  r0.x = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r0.x = r1.x * r0.x;
  r0.xyz = r0.yzw * r0.xxx;
  o0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  return;
}