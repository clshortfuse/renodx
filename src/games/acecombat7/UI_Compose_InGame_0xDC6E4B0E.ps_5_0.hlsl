// ---- Created with 3Dmigoto v1.4.1 on Fri Oct 11 21:13:12 2024

#include "./shared.h"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[129];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[26];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb1[128].xy + -cb1[126].xy;
  r0.xy = cb1[127].zw * r0.xy;
  r0.z = cmp(1 < cb1[127].y);
  r0.w = 1.77777779 * cb1[127].y;
  r0.w = cb1[127].x / r0.w;
  r0.w = r0.x * r0.w;
  r0.x = r0.z ? r0.w : r0.x;
  r0.z = cmp(0.5 < cb0[24].y);
  r0.w = cmp(r0.x >= cb0[19].x);
  r0.x = cmp(cb0[19].z >= r0.x);
  r0.x = r0.x ? r0.w : 0;
  r0.w = cmp(r0.y >= cb0[19].y);
  r0.x = r0.w ? r0.x : 0;
  r0.y = cmp(cb0[19].w >= r0.y);
  r0.x = r0.y ? r0.x : 0;
  r0.x = (int)r0.x | (int)r0.z;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r2.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r2.xyz = saturate(r2.xyz);                         // we don't care about wide gamut UI colors
  r2.xyz *= renodx::math::SafePow(r2.xyz, 1 / 2.2);  // set ui as gamma space (we will linearize it later.)
  r2.xyz *= injectedData.toneMapUINits / 80.f;       // Added ui slider
  r0.y = dot(r1.xyz, float3(0.298911989,0.586610973,0.114477001));
  r0.y = saturate(1 + -r0.y);
  r0.y = r0.x ? 1 : r0.y;
  r0.yz = cb0[18].xy * r0.yy;
  r0.w = cmp(-0.00999999978 < cb0[23].x);
  r3.xy = cb0[23].xx * r0.yz;
  r0.yz = r0.ww ? r3.xy : r0.yz;
  r3.xyz = t2.Sample(s2_s, v0.xy).xyz;
  r4.xyz = r3.xyz * r0.yyy;
  r0.w = saturate(dot(r4.xyz, float3(0.298911989,0.586610973,0.114477001)));
  r2.xyz = r3.xyz * r0.yyy + r2.xyz;
  r0.y = 1 + -r2.w;
  r0.y = r0.y * r0.w + r2.w;
  r1.xyz = r1.xyz * cb0[24].xxx + cb0[23].zzz;
  r0.w = cb1[127].y / cb1[127].x;
  r3.y = v0.y * r0.w;
  r3.x = v0.x;
  r3.xy = float2(40,40) * r3.xy;
  r0.w = t4.Sample(s4_s, r3.xy).w;
  r3.xyz = t3.Sample(s3_s, v0.xy).xyz;
  r3.xyz = r3.xyz * r0.zzz;
  r0.z = dot(r3.xyz, float3(0.298911989,0.586610973,0.114477001));
  r4.xyz = r3.xyz * r0.www;
  r4.xyz = float3(3,3,3) * r4.xyz;
  r0.z = saturate(r0.z + r0.z);
  r3.xyz = r4.xyz * r0.zzz + r3.xyz;
  r4.xw = float2(2,2) * cb1[128].zw;
  r4.yz = float2(0,0);
  r5.xyzw = v0.xyxy + -r4.xyzw;
  r6.xyz = t1.Sample(s1_s, r5.xy).xyz;
  r4.xyzw = v0.xyxy + r4.xyzw;
  r7.xyz = t1.Sample(s1_s, r4.xy).xyz;
  r5.xyz = t1.Sample(s1_s, r5.zw).xyz;
  r4.xyz = t1.Sample(s1_s, r4.zw).xyz;
  if (r0.x != 0) {
    r0.x = 1 + -r0.y;
    r0.xzw = r1.xyz * r0.xxx + r2.xyz;
    r2.w = saturate(dot(r3.xyz, float3(0.298911989,0.586610973,0.114477001)));
    r2.w = 1 + -r2.w;
    r0.xzw = r0.xzw * r2.www + r3.xyz;
  } else {
    r2.w = dot(r6.xyz, float3(0.298911989,0.586610973,0.114477001));
    r3.w = dot(r7.xyz, float3(0.298911989,0.586610973,0.114477001));
    r2.w = r3.w * r2.w;
    r3.w = dot(r5.xyz, float3(0.298911989,0.586610973,0.114477001));
    r2.w = r3.w * r2.w;
    r3.w = dot(r4.xyz, float3(0.298911989,0.586610973,0.114477001));
    r2.w = r3.w * r2.w;
    r0.y = -r0.y * cb0[25].x + 1;
    r2.xyz = cb0[23].www * r2.xyz;
    r2.w = r2.w * 10 + 1;
    r2.xyz = r2.xyz * r2.www;
    r1.xyz = r1.xyz * r0.yyy + r2.xyz;
    r0.xzw = r1.xyz + r3.xyz;
  }
  o0.xyz = cb0[23].yyy * r0.xzw;
  o0.w = r1.w;
  return;
}