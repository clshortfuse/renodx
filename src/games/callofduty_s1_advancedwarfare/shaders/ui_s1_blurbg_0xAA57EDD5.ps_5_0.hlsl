// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 12 13:21:57 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[18];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
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
  r1.xyz = r0.xxx * v3.xyw + v5.xyw;
  r1.xyz = r0.yyy * v4.xyw + r1.xyz;
  r0.xy = r1.xy * cb2[17].xy + float2(0.5,0.5);
  r1.xy = floor(r0.xy);
  r0.xy = frac(r0.xy);
  r2.xy = r0.xy * r0.xy;
  r2.xy = r2.xy * r0.xy;
  r2.zw = r0.xy * float2(6,6) + float2(-15,-15);
  r0.xy = r0.xy * r2.zw + float2(10,10);
  r0.xy = r2.xy * r0.xy + r1.xy;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r0.xy = r0.xy / cb2[17].xy;
  r0.xy = r0.xy / r1.zz;
  r0.z = r0.z * 5 + -cb3[0].x;
  o0.w = v1.w * r0.w;
  r0.z = cb3[0].y * r0.z + cb3[0].x;
  r0.xyz = t4.SampleLevel(s4_s, r0.xy, r0.z).xyz;
  o0.xyz = v1.xyz * r0.xyz;
  return;
}