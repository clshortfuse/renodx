#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Wed Apr 16 00:36:16 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[236];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[77];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  linear centroid float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v5.xy * cb4[9].xy;
  r1.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  //r1.xyzw = (int4)r1.xyzw & asint(cb3[48].xyzw);
  //r1.xyzw = (int4)r1.xyzw | asint(cb3[49].xyzw);
  r1.xyz = float3(1.59579468,-0.813476562,0) * r1.www;
  r2.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
 //r2.xyzw = (int4)r2.xyzw & asint(cb3[46].xyzw);
 //r2.xyzw = (int4)r2.xyzw | asint(cb3[47].xyzw);
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
 //r0.xyzw = (int4)r0.xyzw & asint(cb3[50].xyzw);
 //r0.xyzw = (int4)r0.xyzw | asint(cb3[51].xyzw);
  r0.xyz = r2.www * float3(1.16412354,1.16412354,1.16412354) + r1.xyz;
  r0.xyz = r0.www * float3(0,-0.391448975,2.01782227) + r0.xyz;
  r0.xyz = float3(-0.87065506,0.529705048,-1.08166885) + r0.xyz;
  r0.w = 1;
  r0.xyzw = cb4[8].xyzw * r0.xyzw;
  o0.xyz = v2.xyz * r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
 //r1.xyzw = (int4)r1.xyzw & asint(cb3[44].xyzw);
 //r1.xyzw = (int4)r1.xyzw | asint(cb3[45].xyzw);
  r0.x = v2.w * r1.w;
  o0.w = r0.w * r0.x;

  o0.rgb = AutoHDRVideo(o0.rgb);
  return;
}