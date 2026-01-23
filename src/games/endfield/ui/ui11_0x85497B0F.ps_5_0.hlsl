// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 15:07:05 2026

#include "../shared.h"

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[27];
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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[0].y * 0.0009765625;
  r0.y = cmp(r0.x >= -r0.x);
  r0.x = frac(abs(r0.x));
  r0.x = r0.y ? r0.x : -r0.x;
  r0.x = 1024 * r0.x;
  r1.xyzw = cb1[21].xxyy * r0.xxxx + v2.xxyy;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r1.xyzw = cb1[18].xyzw * r1.xyzw;
  r0.yz = r1.xy + r1.zw;
  r0.yz = float2(0.5,0.5) + r0.yz;
  r0.yz = r0.yz * cb1[19].xy + cb1[19].zw;
  r0.yzw = t1.Sample(s1_s, r0.yz).xyw;
  r0.zw = r0.wz * float2(2,2) + float2(-1,-1);
  r0.zw = cb1[16].yy * r0.zw;
  r1.x = cb1[15].w + 1;
  r0.y = r0.y * r1.x + -cb1[15].w;
  r1.yz = cb1[16].yz * r0.yy;
  r0.y = cmp(0.000000 != cb1[16].x);
  r0.yz = r0.yy ? r0.zw : r1.yz;
  r1.yz = cb1[22].xy * r0.xx + v2.xy;
  r1.yz = r1.yz * cb1[20].xy + cb1[20].zw;
  r1.yzw = t2.Sample(s2_s, r1.yz).xyw;
  r0.w = r1.y * r1.x + -cb1[15].w;
  r1.xy = r1.wz * float2(2,2) + float2(-1,-1);
  r1.xy = cb1[17].yy * r1.xy;
  r1.zw = cb1[17].yz * r0.ww;
  r0.w = cmp(0.000000 != cb1[17].x);
  r1.xy = r0.ww ? r1.xy : r1.zw;
  r0.yz = r1.xy + r0.yz;
  r1.xyzw = cb1[12].xxyy * r0.xxxx + v2.xxyy;
  r2.xyzw = cb1[25].xxyy * r0.xxxx + v2.xxyy;
  r2.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r2.xyzw;
  r2.xyzw = cb1[26].xyzw * r2.xyzw;
  r0.xw = r2.xy + r2.zw;
  r0.xw = float2(0.5,0.5) + r0.xw;
  r0.xw = r0.xw * cb1[24].xy + cb1[24].zw;
  r0.xw = r0.yz * cb1[23].xx + r0.xw;
  r2.xyzw = t3.Sample(s3_s, r0.xw).xyzw;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r1.xyzw = cb1[13].xyzw * r1.xyzw;
  r0.xw = r1.xy + r1.zw;
  r0.xw = float2(0.5,0.5) + r0.xw;
  r0.xw = r0.xw * cb1[14].xy + cb1[14].zw;
  r0.xy = r0.yz * cb1[10].ww + r0.xw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.w = r0.x;
  r1.x = 1;
  r1.xyzw = r1.xxxw + -r0.xyzw;
  r0.xyzw = cb1[11].xxxx * r1.xyzw + r0.xyzw;
  r1.x = 255 * v1.w;
  r1.x = round(r1.x);
  r1.w = 0.00392156886 * r1.x;
  r1.xyz = v1.xyz;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.w = r2.x;
  r1.x = 1;
  r1.xyzw = r1.xxxw + -r2.xyzw;
  r1.xyzw = cb1[23].yyyy * r1.xyzw + r2.xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r1.xy = cb1[4].zw + -cb1[4].xy;
  r1.xy = -abs(v4.xy) + r1.xy;
  r1.xy = saturate(v4.zw * r1.xy);
  r1.x = r1.x * r1.y;
  r0.w = r1.x * r0.w;
  r1.xyzw = max(cb1[4].xyzw, float4(-2e+10,-2e+10,-2e+10,-2e+10));
  r1.xyzw = min(float4(2e+10,2e+10,2e+10,2e+10), r1.xyzw);
  r2.xy = v4.xy + r1.xy;
  r2.xy = r2.xy + r1.zw;
  r1.xy = r2.xy * float2(0.5,0.5) + -r1.xy;
  r1.zw = -r2.xy * float2(0.5,0.5) + r1.zw;
  r2.xyzw = float4(1,1,1,1) / cb1[8].xzyw;
  r1.xyzw = saturate(r2.xzyw * r1.xyzw);
  r2.xy = r1.xy * float2(-2,-2) + float2(3,3);
  r1.xy = r1.xy * r1.xy;
  r1.xy = r2.xy * r1.xy;
  r2.xy = r1.zw * float2(-2,-2) + float2(3,3);
  r1.zw = r1.zw * r1.zw;
  r1.zw = r2.xy * r1.zw;
  r1.x = r1.x * r1.z;
  r1.x = r1.x * r1.y;
  r1.x = r1.x * r1.w;
  r0.w = r1.x * r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = cb1[9].z * -r0.w + r0.w;

  if (UI_VISIBILITY < 0.5f) o0 = 0;

  return;
}