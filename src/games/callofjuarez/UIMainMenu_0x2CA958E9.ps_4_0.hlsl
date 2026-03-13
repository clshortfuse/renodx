#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sun Jan 25 22:10:10 2026

cbuffer _Globals : register(b0)
{
  float4 CONST_7 : packoffset(c0);
}

SamplerState samDirt_s : register(s0);
SamplerState samCharacter0_s : register(s1);
SamplerState samCharacter1_s : register(s2);
SamplerState samFog0_s : register(s3);
SamplerState samFog1_s : register(s4);
SamplerState samLogo_s : register(s5);
Texture2D<float4> sDirt : register(t0);
Texture2D<float4> sCharacter0 : register(t1);
Texture2D<float4> sCharacter1 : register(t2);
Texture2D<float4> sFog0 : register(t3);
Texture2D<float4> sFog1 : register(t4);
Texture2D<float4> sLogo : register(t5);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  float2 w3 : TEXCOORD5,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sDirt.Sample(samDirt_s, v1.xy).xyzw;
  r1.xyzw = r0.xyzw * r0.wwww;
  r2.xyzw = sCharacter0.Sample(samCharacter0_s, w1.xy).xyzw;
  r3.x = CONST_7.w * r2.w;
  r0.xyzw = -r0.xyzw * r0.wwww + r2.xyzw;
  r0.xyzw = saturate(r3.xxxx * r0.xyzw + r1.xyzw);
  r1.xyzw = sCharacter1.Sample(samCharacter1_s, v2.xy).xyzw;
  r2.xyzw = r1.xyzw + -r0.xyzw;
  r1.x = CONST_7.z * r1.w;
  r0.xyzw = saturate(r1.xxxx * r2.xyzw + r0.xyzw);
  r1.xyzw = sFog0.Sample(samFog0_s, w2.xy).xyzw;
  r2.xyzw = sFog1.Sample(samFog1_s, v3.xy).xyzw;
  r3.xyzw = r1.xyzw * r2.xyzw + -r0.xyzw;
  r1.x = r2.w * r1.w;
  r0.xyzw = saturate(r1.xxxx * r3.xyzw + r0.xyzw);
  r1.xyzw = sLogo.Sample(samLogo_s, w3.xy).xyzw;
  r2.xyzw = r1.xyzw + -r0.xyzw;
  o0.xyzw = r1.wwww * r2.xyzw + r0.xyzw;
  o0.xyz = renodx::color::srgb::Decode(o0.xyz);
  o0.xyzw = saturate(o0.xyzw);
  return;
}