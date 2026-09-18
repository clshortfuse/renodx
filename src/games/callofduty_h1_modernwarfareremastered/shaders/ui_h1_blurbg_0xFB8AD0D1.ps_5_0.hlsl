// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 14 19:36:44 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s2_s : register(s2);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[19];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD8,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;

  r0.xyzw = t2.Sample(s0_s, v2.xy).xyzw;
  r0.w = v1.w * r0.w;
  r1.x = t3.Sample(s2_s, w2.xy).w;
  r0.w = r1.x * r0.w;
  r1.x = cmp(0 >= r0.w);
  if (r1.x != 0) discard;
  r1.xyz = r0.xxx * v3.xyw + v5.xyw;
  r1.xyz = r0.yyy * v4.xyw + r1.xyz;
  r0.x = r0.z * 5 + -cb3[0].x;
  r0.x = cb3[0].y * r0.x + cb3[0].x;
  r0.yz = r1.xy * cb2[18].xy + float2(0.5,0.5);
  r1.xy = floor(r0.yz);
  r0.yz = frac(r0.yz);
  r2.xy = r0.yz * r0.yz;
  r2.xy = r2.xy * r0.yz;
  r2.zw = r0.yz * float2(6,6) + float2(-15,-15);
  r0.yz = r0.yz * r2.zw + float2(10,10);
  r0.yz = r2.xy * r0.yz + r1.xy;
  r0.yz = float2(-0.5,-0.5) + r0.yz;
  r0.yz = r0.yz / cb2[18].xy;
  r0.yz = r0.yz / r1.zz;
  r0.xyz = t4.SampleLevel(s4_s, r0.yz, r0.x).xyz;
  o0.xyz = v1.xyz * r0.xyz;
  o0.w = r0.w;
  return;
}