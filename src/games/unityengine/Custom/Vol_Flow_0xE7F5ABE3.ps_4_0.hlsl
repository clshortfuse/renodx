#include "../shared.h"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  sincos(cb0[1].w, r0.x, r1.x);
  r2.x = -r0.x;
  r2.y = r1.x;
  r2.z = r0.x;
  r0.xy = float2(-0.5,-0.5) + v0.xy;
  r1.x = dot(r0.yx, r2.xy);
  r1.y = dot(r0.yx, r2.yz);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = -cb0[3].x + r0.x;
  r0.x = saturate(-2 * r0.x);
  r0.yz = r1.xy * cb0[1].zz + cb0[1].xy;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r0.yz = frac(r0.yz);
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r0.yzw = r1.xyz * cb0[2].xyz + -r1.xyz;
  r1.xyz = cb0[2].www * r0.yzw + r1.xyz;
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = -r0.y * r0.x + 1;
  r0.yz = float2(-1,-0) + cb0[0].xy;
  r0.xy = r0.xx * r0.yz + float2(1,0);
  r1.xyzw = r1.xyzw * r0.yyyy;
  r2.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  o0.xyzw = r2.xyzw * r0.xxxx + r1.xyzw;
  o0.w = saturate(o0.w);
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}