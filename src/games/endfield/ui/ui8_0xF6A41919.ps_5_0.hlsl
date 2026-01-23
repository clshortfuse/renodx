// ---- Created with 3Dmigoto v1.4.1 on Thu Jan 22 14:33:10 2026

#include "../shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[19];
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

  r0.xy = -cb0[8].yw + float2(1,1);
  r1.xyzw = -cb0[7].xyzw + v2.zzww;
  r0.xy = r1.yw * r0.xy;
  r0.zw = -cb0[7].yw + float2(1,1);
  r0.xy = r0.xy / r0.zw;
  r0.xy = cb0[8].yw + r0.xy;
  r0.zw = cmp(float2(1,1) >= v2.zw);
  r0.xy = r0.zw ? r0.xy : v2.zw;
  r0.zw = cb0[8].yw + -cb0[8].xz;
  r0.zw = r1.xz * r0.zw;
  r1.xy = cb0[7].yw + -cb0[7].xz;
  r0.zw = r0.zw / r1.xy;
  r0.zw = cb0[8].xz + r0.zw;
  r1.xyzw = cmp(cb0[7].xyzw >= v2.zzww);
  r0.xy = r1.yw ? r0.zw : r0.xy;
  r0.zw = cb0[8].xz * v2.zw;
  r0.zw = r0.zw / cb0[7].xz;
  r1.yw = cmp(v2.zw >= float2(0,0));
  r1.xy = r1.xz ? r1.yw : 0;
  r0.xy = r1.xy ? r0.zw : r0.xy;
  r0.zw = cmp(v2.zw < float2(0,0));
  r0.xy = r0.zw ? v2.zw : r0.xy;
  r0.z = cmp(0.000000 != cb0[9].x);
  r0.xy = r0.zz ? r0.xy : v2.zw;
  r0.zw = cmp(float2(1,1) >= r0.xy);
  r0.zw = r0.zw ? float2(1,1) : 0;
  r1.xy = cmp(float2(0,0) >= -r0.xy);
  r0.xy = r0.xy * cb0[2].xy + cb0[2].zw;
  r0.x = t1.Sample(s1_s, r0.xy).w;
  r1.xy = r1.xy ? float2(1,1) : 0;
  r0.yz = r1.xy * r0.zw;
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r0.z;
  r0.y = cmp(0.000000 != cb0[18].z);
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.w = r0.y ? 1 : r1.w;
  r1.xyzw = cb0[11].xyzw + r1.xyzw;
  r0.y = 255 * v1.w;
  r0.y = round(r0.y);
  r2.w = 0.00392156886 * r0.y;
  r2.xyz = v1.xyz;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r0.x = r1.w * r0.x;
  r0.yz = cb0[12].zw + -cb0[12].xy;
  r0.yz = -abs(v4.xy) + r0.yz;
  r0.yz = saturate(v4.zw * r0.yz);
  r0.y = r0.y * r0.z;
  r0.x = r0.x * r0.y;
  r2.xyzw = max(cb0[12].xyzw, float4(-2e+10,-2e+10,-2e+10,-2e+10));
  r2.xyzw = min(float4(2e+10,2e+10,2e+10,2e+10), r2.xyzw);
  r0.yz = v4.xy + r2.xy;
  r0.yz = r0.yz + r2.zw;
  r2.xy = r0.yz * float2(0.5,0.5) + -r2.xy;
  r0.yz = -r0.yz * float2(0.5,0.5) + r2.zw;
  r3.xyzw = float4(1,1,1,1) / cb0[16].xzyw;
  r2.xy = saturate(r3.xz * r2.xy);
  r0.yz = saturate(r3.yw * r0.yz);
  r2.zw = r2.xy * float2(-2,-2) + float2(3,3);
  r2.xy = r2.xy * r2.xy;
  r2.xy = r2.zw * r2.xy;
  r2.zw = r0.yz * float2(-2,-2) + float2(3,3);
  r0.yz = r0.yz * r0.yz;
  r0.yz = r2.zw * r0.yz;
  r0.y = r2.x * r0.y;
  r0.y = r0.y * r2.y;
  r0.y = r0.y * r0.z;
  r0.x = r0.x * r0.y;
  o0.xyz = r1.xyz * r0.xxx;
  o0.w = cb0[17].z * -r0.x + r0.x;
  
  if (UI_VISIBILITY < 0.5f) o0 = 0;
  
  return;
}