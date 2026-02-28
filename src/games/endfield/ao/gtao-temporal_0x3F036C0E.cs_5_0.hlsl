// ---- Created with 3Dmigoto v1.4.1 on Tue Feb 10 15:11:49 2026
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}


#include "../shared.h"

#define cmp -

RWTexture2D<float4> u0 : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4;
  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.zw = cb0[3].zw * r0.xy;
  r1.xy = t2.SampleLevel(s0_s, r0.zw, 0).xy;
  r1.zw = abs(r1.xy) * float2(2,2) + float2(-1,-1);
  r1.zw = r1.zw * r1.zw;
  r1.zw = r1.zw * r1.zw;
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r2.xy = cmp(float2(0,0) < r1.xy);
  r1.xy = cmp(r1.xy < float2(0,0));
  r1.xy = (int2)-r2.xy + (int2)r1.xy;
  r1.xy = (int2)r1.xy;
  r1.xy = r1.zw * r1.xy;
  r1.zw = r0.xy * cb0[3].zw + -r1.xy;
  if (IMPROVED_GTAO >= 0.5) {
    // Manual bilinear interpolation for previous AO (reduces wobble/ghosting)
    // Only interpolate AO (.x), keep depth (.y) point-sampled
    float2 texelPos = r1.zw * cb0[3].xy - 0.5;
    float2 f = frac(texelPos);
    float2 base = (floor(texelPos) + 0.5) * cb0[3].zw;
    float ao00 = t3.SampleLevel(s0_s, base, 0).x;
    float ao10 = t3.SampleLevel(s0_s, base + float2(cb0[3].z, 0), 0).x;
    float ao01 = t3.SampleLevel(s0_s, base + float2(0, cb0[3].w), 0).x;
    float ao11 = t3.SampleLevel(s0_s, base + cb0[3].zw, 0).x;
    r2.x = lerp(lerp(ao00, ao10, f.x), lerp(ao01, ao11, f.x), f.y);
    r2.y = t3.SampleLevel(s0_s, r1.zw, 0).y; // depth: point-sampled
  } else {
    r2.xy = t3.SampleLevel(s0_s, r1.zw, 0).xy;
  }
  r2.z = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r2.z = 0.00999999978 * r2.z;
  r3.y = min(1, r2.z);
  r3.x = t1.SampleLevel(s0_s, r0.zw, 0).x;
  r2.zw = cmp(r1.zw < float2(0,0));
  r2.z = (int)r2.w | (int)r2.z;
  r1.zw = cmp(float2(1,1) < r1.zw);
  r1.z = (int)r1.w | (int)r1.z;
  r1.z = (int)r1.z | (int)r2.z;
  if (r1.z != 0) {
    r3.z = 0;
  } else {
    r1.xy = cb0[3].xy * r1.xy;
    r1.x = dot(r1.xy, r1.xy);
    r1.x = sqrt(r1.x);
    r1.x = cb0[2].z * -r1.x;
    r1.x = 1.44269502 * r1.x;
    r1.x = exp2(r1.x);
    r1.x = 0.970000029 * r1.x;
    r1.y = r3.y + -r2.y;
    r1.y = -1442.69507 * abs(r1.y);
    r1.y = exp2(r1.y);
    r3.z = r1.x * r1.y;
  }
  r1.x = cmp(0.000000 == cb0[2].y);
  if (r1.x == 0) {
    r1.xy = r0.xy * cb0[3].zw + -cb0[3].zw;
    r1.x = t1.SampleLevel(s0_s, r1.xy, 0).x;
    r4.xyzw = cb0[3].zwzw * float4(0,-1,1,-1) + r0.zwzw;
    r1.y = t1.SampleLevel(s0_s, r4.xy, 0).x;
    r1.z = t1.SampleLevel(s0_s, r4.zw, 0).x;
    r4.xyzw = cb0[3].zwzw * float4(-1,0,1,0) + r0.zwzw;
    r1.w = t1.SampleLevel(s0_s, r4.xy, 0).x;
    r2.y = t1.SampleLevel(s0_s, r4.zw, 0).x;
    r4.xyzw = cb0[3].zwzw * float4(-1,1,0,1) + r0.zwzw;
    r0.z = t1.SampleLevel(s0_s, r4.xy, 0).x;
    r0.w = t1.SampleLevel(s0_s, r4.zw, 0).x;
    r0.xy = r0.xy * cb0[3].zw + cb0[3].zw;
    r0.x = t1.SampleLevel(s0_s, r0.xy, 0).x;
    r0.y = min(r1.w, r3.x);
    r2.z = min(r2.y, r0.w);
    r0.y = min(r2.z, r0.y);
    r0.y = min(r1.y, r0.y);
    r2.z = min(r1.x, r1.z);
    r2.w = min(r0.z, r0.x);
    r2.z = min(r2.z, r2.w);
    r0.y = min(r2.z, r0.y);
    r1.w = max(r1.w, r3.x);
    r0.w = max(r2.y, r0.w);
    r0.w = max(r1.w, r0.w);
    r1.x = max(r1.x, r1.z);
    r0.x = max(r0.z, r0.x);
    r0.xw = max(r1.xy, r0.xw);
    r0.x = max(r0.w, r0.x);
    r0.y = max(r2.x, r0.y);
    r0.x = min(r0.y, r0.x);
    r0.x = r0.x + -r3.x;
    r3.x = r3.z * r0.x + r3.x;
  }
  r3.w = 0;
  u0[vThreadID.xy] = r3.xyzw;
  return;
}