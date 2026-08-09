#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[2].xy + cb0[2].zw;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r0.x = -cb0[4].x + r0.w;
  r0.y = cb0[4].y + -cb0[4].x;
  r0.x = saturate(r0.x / r0.y);
  r0.x = 1 + -r0.x;
  r0.y = 1 + -r0.x;
  r0.x = r0.x * r0.x;
  r0.y = r0.y * r0.y + r0.x;
  r0.x = r0.x / r0.y;
  r0.yz = v2.xy / v2.ww;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r2.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r0.yzw = cb0[3].yyy * r1.xyz;
  r1.x = dot(r0.yzw, float3(0.0396819152,0.45802179,0.00609653955));
  if(injectedData.toneMapType == 0.f){
    r0.yzw = saturate(r0.yzw);
  }
  r1.xyz = r1.xxx + -r0.yzw;
  r0.yzw = cb0[3].xxx * r1.xyz + r0.yzw;
  r1.xyz = r2.xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  o0.w = dot(r0.xyz, float3(0.0396819152,0.45802179,0.00609653955));
  o0.xyz = r0.xyz;
  return;
}