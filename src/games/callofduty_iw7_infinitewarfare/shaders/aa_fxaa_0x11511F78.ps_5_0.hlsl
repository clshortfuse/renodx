// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:14 2025
#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[3];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  if (CUSTOM_DISABLEFXAA == 1) {
    o0 = r0;
    return;
  }
  r1.xyz = t0.Gather(s0_s, v1.xy).xyz;
  r2.xyz = t0.Gather(s0_s, v1.xy, int2(-1, -1)).xzw;
  r1.w = max(r1.x, r0.y);
  r2.w = min(r1.x, r0.y);
  r1.w = max(r1.z, r1.w);
  r2.w = min(r2.w, r1.z);
  r3.x = max(r2.y, r2.x);
  r3.y = min(r2.y, r2.x);
  r1.w = max(r3.x, r1.w);
  r2.w = min(r3.y, r2.w);
  r3.x = 0.165999994 * r1.w;
  r1.w = -r2.w + r1.w;
  r2.w = max(0.0311999992, r3.x);
  r2.w = cmp(r1.w >= r2.w);
  if (r2.w != 0) {
    r2.w = t0.SampleLevel(s0_s, v1.xy, 0, int2(1, -1)).y;
    r3.x = t0.SampleLevel(s0_s, v1.xy, 0, int2(-1, 1)).y;
    r3.yz = r2.yx + r1.xz;
    r1.w = 1 / r1.w;
    r3.w = r3.y + r3.z;
    r3.yz = r0.yy * float2(-2,-2) + r3.yz;
    r4.x = r2.w + r1.y;
    r2.w = r2.z + r2.w;
    r4.y = r1.z * -2 + r4.x;
    r2.w = r2.y * -2 + r2.w;
    r2.z = r3.x + r2.z;
    r1.y = r3.x + r1.y;
    r3.x = abs(r3.y) * 2 + abs(r4.y);
    r2.w = abs(r3.z) * 2 + abs(r2.w);
    r3.y = r2.x * -2 + r2.z;
    r1.y = r1.x * -2 + r1.y;
    r3.x = abs(r3.y) + r3.x;
    r1.y = abs(r1.y) + r2.w;
    r2.z = r2.z + r4.x;
    r1.y = cmp(r3.x >= r1.y);
    r2.z = r3.w * 2 + r2.z;
    r2.x = r1.y ? r2.y : r2.x;
    r1.x = r1.y ? r1.x : r1.z;
    r1.z = r1.y ? cb2[1].w : cb2[1].z;
    r2.y = r2.z * 0.0833333358 + -r0.y;
    r2.z = r2.x + -r0.y;
    r2.w = r1.x + -r0.y;
    r2.x = r2.x + r0.y;
    r1.x = r1.x + r0.y;
    r3.x = cmp(abs(r2.z) >= abs(r2.w));
    r2.z = max(abs(r2.z), abs(r2.w));
    r1.z = r3.x ? -r1.z : r1.z;
    r1.w = saturate(abs(r2.y) * r1.w);
    r2.y = r1.y ? cb2[1].z : 0;
    r2.w = r1.y ? 0 : cb2[1].w;
    r3.yz = r1.zz * float2(0.5,0.5) + v1.xy;
    r3.y = r1.y ? v1.x : r3.y;
    r3.z = r1.y ? r3.z : v1.y;
    r4.xy = r3.yz + -r2.yw;
    r5.xy = r3.yz + r2.yw;
    r3.y = r1.w * -2 + 3;
    r3.z = t0.SampleLevel(s0_s, r4.xy, 0).y;
    r1.w = r1.w * r1.w;
    r3.w = t0.SampleLevel(s0_s, r5.xy, 0).y;
    r1.x = r3.x ? r2.x : r1.x;
    r2.x = 0.25 * r2.z;
    r2.z = -r1.x * 0.5 + r0.y;
    r1.w = r3.y * r1.w;
    r2.z = cmp(r2.z < 0);
    r3.x = -r1.x * 0.5 + r3.z;
    r3.y = -r1.x * 0.5 + r3.w;
    r3.zw = cmp(abs(r3.xy) >= r2.xx);
    r4.z = -r2.y * 1.5 + r4.x;
    r4.x = r3.z ? r4.x : r4.z;
    r4.w = -r2.w * 1.5 + r4.y;
    r4.z = r3.z ? r4.y : r4.w;
    r4.yw = ~(int2)r3.zw;
    r4.y = (int)r4.w | (int)r4.y;
    r4.w = r2.y * 1.5 + r5.x;
    r5.x = r3.w ? r5.x : r4.w;
    r4.w = r2.w * 1.5 + r5.y;
    r5.z = r3.w ? r5.y : r4.w;
    if (r4.y != 0) {
      if (r3.z == 0) {
        r3.x = t0.SampleLevel(s0_s, r4.xz, 0).y;
      }
      if (r3.w == 0) {
        r3.y = t0.SampleLevel(s0_s, r5.xz, 0).y;
      }
      r4.y = -r1.x * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r4.y;
      r3.z = -r1.x * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r3.z;
      r3.zw = cmp(abs(r3.xy) >= r2.xx);
      r4.y = -r2.y * 2 + r4.x;
      r4.x = r3.z ? r4.x : r4.y;
      r4.y = -r2.w * 2 + r4.z;
      r4.z = r3.z ? r4.z : r4.y;
      r4.yw = ~(int2)r3.zw;
      r4.y = (int)r4.w | (int)r4.y;
      r4.w = r2.y * 2 + r5.x;
      r5.x = r3.w ? r5.x : r4.w;
      r4.w = r2.w * 2 + r5.z;
      r5.z = r3.w ? r5.z : r4.w;
      if (r4.y != 0) {
        if (r3.z == 0) {
          r3.x = t0.SampleLevel(s0_s, r4.xz, 0).y;
        }
        if (r3.w == 0) {
          r3.y = t0.SampleLevel(s0_s, r5.xz, 0).y;
        }
        r4.y = -r1.x * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r4.y;
        r3.z = -r1.x * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r3.z;
        r3.zw = cmp(abs(r3.xy) >= r2.xx);
        r4.y = -r2.y * 2 + r4.x;
        r4.x = r3.z ? r4.x : r4.y;
        r4.y = -r2.w * 2 + r4.z;
        r4.z = r3.z ? r4.z : r4.y;
        r4.yw = ~(int2)r3.zw;
        r4.y = (int)r4.w | (int)r4.y;
        r4.w = r2.y * 2 + r5.x;
        r5.x = r3.w ? r5.x : r4.w;
        r4.w = r2.w * 2 + r5.z;
        r5.z = r3.w ? r5.z : r4.w;
        if (r4.y != 0) {
          if (r3.z == 0) {
            r3.x = t0.SampleLevel(s0_s, r4.xz, 0).y;
          }
          if (r3.w == 0) {
            r3.y = t0.SampleLevel(s0_s, r5.xz, 0).y;
          }
          r4.y = -r1.x * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r4.y;
          r3.z = -r1.x * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r3.z;
          r3.zw = cmp(abs(r3.xy) >= r2.xx);
          r4.y = -r2.y * 4 + r4.x;
          r4.x = r3.z ? r4.x : r4.y;
          r4.y = -r2.w * 4 + r4.z;
          r4.z = r3.z ? r4.z : r4.y;
          r4.yw = ~(int2)r3.zw;
          r4.y = (int)r4.w | (int)r4.y;
          r4.w = r2.y * 4 + r5.x;
          r5.x = r3.w ? r5.x : r4.w;
          r4.w = r2.w * 4 + r5.z;
          r5.z = r3.w ? r5.z : r4.w;
          if (r4.y != 0) {
            if (r3.z == 0) {
              r3.x = t0.SampleLevel(s0_s, r4.xz, 0).y;
            }
            if (r3.w == 0) {
              r3.y = t0.SampleLevel(s0_s, r5.xz, 0).y;
            }
            r4.y = -r1.x * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r4.y;
            r1.x = -r1.x * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r1.x;
            r3.zw = cmp(abs(r3.xy) >= r2.xx);
            r1.x = -r2.y * 12 + r4.x;
            r4.x = r3.z ? r4.x : r1.x;
            r1.x = -r2.w * 12 + r4.z;
            r4.z = r3.z ? r4.z : r1.x;
            r1.x = r2.y * 12 + r5.x;
            r5.x = r3.w ? r5.x : r1.x;
            r1.x = r2.w * 12 + r5.z;
            r5.z = r3.w ? r5.z : r1.x;
          }
        }
      }
    }
    r1.x = v1.x + -r4.x;
    r2.y = v1.y + -r4.z;
    r1.x = r1.y ? r1.x : r2.y;
    r2.xy = -v1.xy + r5.xz;
    r2.x = r1.y ? r2.x : r2.y;
    r2.yw = cmp(r3.xy < float2(0,0));
    r3.x = r2.x + r1.x;
    r2.yz = cmp((int2)r2.zz != (int2)r2.yw);
    r2.w = 1 / r3.x;
    r3.x = cmp(r1.x < r2.x);
    r1.x = min(r2.x, r1.x);
    r2.x = r3.x ? r2.y : r2.z;
    r1.w = r1.w * r1.w;
    r1.x = r1.x * -r2.w + 0.5;
    r1.w = 0.75 * r1.w;
    r1.x = (int)r1.x & (int)r2.x;
    r1.x = max(r1.x, r1.w);
    r1.xz = r1.xx * r1.zz + v1.xy;
    r2.x = r1.y ? v1.x : r1.x;
    r2.y = r1.y ? r1.z : v1.y;
    r1.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
    r0.w = r0.y;
  } else {
    r1.xyz = r0.xyz;
  }
  r1.w = min(r1.x, r1.y);
  r2.x = max(r1.x, r1.y);
  r2.x = min(r2.x, r1.z);
  r1.w = max(r2.x, r1.w);
  r2.x = -0.100000001 + r1.w;
  r2.x = saturate(-10 * r2.x);
  r2.y = r2.x * -2 + 3;
  r2.x = r2.x * r2.x;
  r1.w = r2.y * r2.x + r1.w;
  r1.w = r1.w * r1.w;
  r2.xy = cb2[0].ww * v1.yx;
  r2.xy = frac(r2.xy);
  r2.xy = r2.xy * float2(1024,1024) + float2(-512,-512);
  r2.zw = float2(0.554549694,0.308517009) * r2.yx;
  r2.zw = frac(r2.zw);
  r2.xy = r2.yx * r2.zw + r2.xy;
  r2.x = r2.x * r2.y;
  r2.x = frac(r2.x);
  r2.x = r2.x * 2 + -1;
  r1.w = min(1, r1.w);
  r1.w = r1.w * -r2.x + r2.x;
  r1.w = cb2[2].y * r1.w;
  r0.xyz = r1.xyz * r1.www + r1.xyz;
  o0.xyzw = r0.xyzw;
  return;
}