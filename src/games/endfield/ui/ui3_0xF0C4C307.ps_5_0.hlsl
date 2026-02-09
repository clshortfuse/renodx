// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 11:53:21 2026
#include "../shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[24];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[0].y * 0.0009765625;
  r0.y = cmp(r0.x >= -r0.x);
  r0.x = frac(abs(r0.x));
  r0.x = r0.y ? r0.x : -r0.x;
  r0.x = 1024 * r0.x;
  r0.xyzw = cb1[23].xxyy * r0.xxxx + v2.xxyy;
  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r0.xyzw = cb1[20].xyzw * r0.xyzw;
  r0.xy = r0.xy + r0.zw;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = r0.xy * cb1[21].xy + cb1[21].zw;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r1.x = cmp(0.000000 != cb1[18].z);
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r2.w = r1.x ? 1 : r2.w;
  r1.xyzw = cb1[11].xyzw + r2.xyzw;
  r2.x = 255 * v1.w;
  r2.x = round(r2.x);
  r2.w = 0.00392156886 * r2.x;
  r0.w = r2.w * r1.w + r0.w;
  r0.w = saturate(cb1[22].w * r0.w);
  r2.xyz = v1.xyz;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r0.xyz = r0.xyz * cb1[22].xyz + -r1.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r1.xy = -cb1[8].yw + float2(1,1);
  r2.xyzw = -cb1[7].xyzw + v2.zzww;
  r1.xy = r2.yw * r1.xy;
  r2.yw = -cb1[7].yw + float2(1,1);
  r1.xy = r1.xy / r2.yw;
  r1.xy = cb1[8].yw + r1.xy;
  r2.yw = cmp(float2(1,1) >= v2.zw);
  r1.xy = r2.yw ? r1.xy : v2.zw;
  r2.yw = cb1[8].yw + -cb1[8].xz;
  r2.xy = r2.xz * r2.yw;
  r2.zw = cb1[7].yw + -cb1[7].xz;
  r2.xy = r2.xy / r2.zw;
  r2.xy = cb1[8].xz + r2.xy;
  r3.xyzw = cmp(cb1[7].xyzw >= v2.zzww);
  r1.xy = r3.yw ? r2.xy : r1.xy;
  r2.xy = cb1[8].xz * v2.zw;
  r2.xy = r2.xy / cb1[7].xz;
  r2.zw = cmp(v2.zw >= float2(0,0));
  r2.zw = r3.xz ? r2.zw : 0;
  r1.xy = r2.zw ? r2.xy : r1.xy;
  r2.xy = cmp(v2.zw < float2(0,0));
  r1.xy = r2.xy ? v2.zw : r1.xy;
  r0.w = cmp(0.000000 != cb1[9].x);
  r1.xy = r0.ww ? r1.xy : v2.zw;
  r2.xy = cmp(float2(1,1) >= r1.xy);
  r2.xy = r2.xy ? float2(1,1) : 0;
  r2.zw = cmp(float2(0,0) >= -r1.xy);
  r1.xy = r1.xy * cb1[2].xy + cb1[2].zw;
  r0.w = t1.Sample(s1_s, r1.xy).w;
  r1.xy = r2.zw ? float2(1,1) : 0;
  r1.xy = r2.xy * r1.xy;
  r0.w = r1.x * r0.w;
  r0.w = r0.w * r1.y;
  r0.w = r1.w * r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = cb1[17].z * -r0.w + r0.w;
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  return;
}