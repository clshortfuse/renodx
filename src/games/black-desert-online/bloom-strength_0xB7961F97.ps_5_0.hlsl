// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 25 15:13:11 2025
// Bloom threshold mask and category classifier for bright fragment filtering.

#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[2];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[29];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Convert UV into tile indices for multi-resolution bloom buffers.
  r0.xy = v1.xy / cb0[28].yz;
  r0.xy = floor(r0.xy);
  r0.yz = float2(0.5,0.5) + r0.xy;
  r1.xw = cb0[28].yz * r0.yz;
  r1.y = (int)r0.x;
  r0.x = cb2[0].x / cb0[28].y;
  r0.x = floor(r0.x);
  r0.xy = float2(-0.5,-1) + r0.xx;
  r2.x = cb0[28].y * r0.x;
  r0.x = cmp(r1.x >= r2.x);
  r2.y = (int)r0.y;
  r2.z = -cb0[28].y;
  r1.z = cb0[28].y;
  r1.xyz = r0.xxx ? r2.xyz : r1.xyz;
  // Read material ID and neighborhood normals/albedo for classification.
  r0.x = t0.SampleLevel(s1_s, r1.xw, 0).w;
  r0.x = 16 * r0.x;
  r0.x = floor(r0.x);
  r0.x = (int)r0.x;
  r0.yz = t1.SampleLevel(s0_s, r1.xw, 0).yz;
  r2.x = r1.z;
  r2.y = 0;
  r1.xz = r2.xy + r1.xw;
  r1.xz = t1.SampleLevel(s0_s, r1.xz, 0).yz;
  r0.w = (int)r1.y & 0x80000000;
  r1.y = max((int)-r1.y, (int)r1.y);
  r1.y = (int)r1.y & 1;
  r1.w = -(int)r1.y;
  r0.w = r0.w ? r1.w : r1.y;
  r1.xy = r1.zx * float2(2,1) + float2(-1,0);
  r1.z = r0.y;
  r2.xy = r0.zy * float2(2,1) + float2(-1,0);
  r2.z = r1.y;
  r0.yzw = r0.www ? r1.xyz : r2.xyz;
  r0.y = max(0, -r0.y);
  r1.xy = cb2[0].xy * v1.xy;
  r1.xyz = t2.Sample(s1_s, r1.xy).xyz;
  // Early out for material bins that always receive full bloom weight.
  if (r0.x == 0) {
    o0.x = cb3[1].x;
    return;
  } else {
    r1.w = cmp((int)r0.x == 13);
    r2.x = cb3[1].y * cb3[0].x;
    r0.z = r0.w + r0.z;
    r0.z = r0.y * 20 + r0.z;
    r0.z = saturate(0.100000001 + r0.z);
    o0.x = r2.x * r0.z;
    if (r1.w != 0) return;
    r0.z = cmp((int)r0.x == 14);
    o0.x = cb3[1].y * cb3[0].y;
    if (r0.z != 0) return;
    r0.x = cmp((int)r0.x == 15);
    o0.x = cb3[1].y * cb3[0].z;
    if (r0.x != 0) return;
  }
  // Compute bloom scalar from local intensity, surface facing, and thresholds.
  r0.x = max(r1.x, r1.y);
  r0.x = max(r0.x, r1.z);
  r0.x = saturate(10 * r0.x);
  r0.y = r0.y * 20 + 1;
  r0.z = cb3[0].w + -r0.y;
  r0.x = r0.x * r0.z + r0.y;
  o0.x = cb3[1].y * r0.x;
  return;
}