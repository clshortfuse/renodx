#include ".././common.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Tue Apr 28 21:50:40 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

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
  float4 v2 : COLOR0,
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

  r0.xyz = v5.xyx * float3(1,1,0) + float3(0,0,1);
  r1.x = dot(r0.xyz, cb4[136].xyz);
  r1.y = dot(r0.xyz, cb4[137].xyz);
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = asfloat(asuint(r1.xyzw) & asint(cb3[46].xyzw));
  r1.xyzw = asfloat(asuint(r1.xyzw) | asint(cb3[47].xyzw));
  r1.x = dot(r0.xyz, cb4[139].xyz);
  r1.y = dot(r0.xyz, cb4[140].xyz);
  r0.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.xyzw = asfloat(asuint(r0.xyzw) & asint(cb3[46].xyzw));
  r0.xyzw = asfloat(asuint(r0.xyzw) | asint(cb3[47].xyzw));
  r0.x = r0.z * r1.z;
  r2.x = log2(abs(r0.x));
  r2.x = 0.199999988 * r2.x;
  r2.y = cmp(r2.x != r2.x);
  r2.x = r2.y ? 0 : r2.x;
  r1.x = exp2(r2.x);
  r0.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  r0.xyzw = asfloat(asuint(r0.xyzw) & asint(cb3[44].xyzw));
  r0.xyzw = asfloat(asuint(r0.xyzw) | asint(cb3[45].xyzw));
  r0.y = r0.w + -r1.x;
  r0.x = cb4[142].x * r0.x;
  r0.y = 0.5 * r0.y;
  r0.x = r0.x * r0.y;
  r2.xyzw = float4(15,15,15,15) * r0.xxxx;
  r0.w = r2.w * 255 + 9.99999975e-005;
  r0.w = (uint)r0.w;
  r0.w = cmp((uint)r0.w < asuint(cb3[8].z));
  if (r0.w != 0) discard;
  o0.xyzw = 1.f - exp2(-max(r2.xyzw, 0.f));
  return;
}