#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.Sample(s6_s, v1.xy).x;
  r0.x = -0.5 + r0.x;
  r0.y = t1.Sample(s6_s, v1.xy).x;
  r0.y = -0.5 + r0.y;
  r0.z = t0.Sample(s6_s, v1.xy).x;
  r0.z = -0.0627449974 + r0.z;
  r1.x = 1.16400003 * r0.z;
  r1.yz = r0.yy * float2(-0.213,2.11500001) + r1.xx;
  r1.xy = r0.xx * float2(1.79299998,-0.533999979) + r1.xy;
  r0.xyz = r1.xyz * r1.xyz;
  r0.xyz = cb1[1].xyz * r0.xyz;
  r0.xyz = cb1[1].www * r0.xyz;
  r1.xy = cmp(v1.xy < cb1[2].xy);
  r1.x = r1.y ? r1.x : 0;
  r1.yz = cmp(cb1[2].zw < v1.xy);
  r1.x = r1.y ? r1.x : 0;
  r1.x = r1.z ? r1.x : 0;
  r1.x = r1.x ? 1.000000 : 0;
  r2.x = 0;
  r2.w = cb1[1].w;
  r0.w = cb1[1].w;
  r2.xyzw = r2.xxxw + -r0.xyzw;
  o0.xyzw = r1.xxxx * r2.xyzw + r0.xyzw;
  o0.rgb = PostToneMapScale(o0.rgb, true);
  return;
}