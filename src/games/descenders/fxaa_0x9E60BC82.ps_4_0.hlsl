#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Mar 27 17:32:55 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r1.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r2.xyzw = cb0[2].xyxy * float4(0,1,1,0) + r0.xyxy;
  r3.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
  r2.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
  r4.xyzw = cb0[2].xyxy * float4(0,-1,-1,0) + r0.xyxy;
  r5.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r4.xyzw = t0.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r0.z = max(r3.y, r1.y);
  r0.w = min(r3.y, r1.y);
  r0.z = max(r2.y, r0.z);
  r0.w = min(r2.y, r0.w);
  r2.x = max(r5.y, r4.y);
  r2.z = min(r5.y, r4.y);
  r0.z = max(r2.x, r0.z);
  r0.w = min(r2.z, r0.w);
  r2.x = cb0[7].y * r0.z;
  r0.z = r0.z + -r0.w;
  r0.w = max(cb0[7].z, r2.x);
  r0.w = cmp(r0.z >= r0.w);
  if (r0.w != 0) {
    r2.xz = -cb0[2].xy + r0.xy;
    r6.xyzw = t0.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r2.xz = cb0[2].xy + r0.xy;
    r7.xyzw = t0.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r8.xyzw = cb0[2].xyxy * float4(1,-1,-1,1) + r0.xyxy;
    r9.xyzw = t0.SampleLevel(s0_s, r8.xy, 0).xyzw;
    r8.xyzw = t0.SampleLevel(s0_s, r8.zw, 0).xyzw;
    r0.w = r5.y + r3.y;
    r2.x = r4.y + r2.y;
    r0.z = 1 / r0.z;
    r2.z = r2.x + r0.w;
    r0.w = r1.y * -2 + r0.w;
    r2.x = r1.y * -2 + r2.x;
    r2.w = r9.y + r7.y;
    r3.x = r9.y + r6.y;
    r3.z = r2.y * -2 + r2.w;
    r3.x = r5.y * -2 + r3.x;
    r3.w = r8.y + r6.y;
    r4.x = r8.y + r7.y;
    r0.w = abs(r0.w) * 2 + abs(r3.z);
    r2.x = abs(r2.x) * 2 + abs(r3.x);
    r3.x = r4.y * -2 + r3.w;
    r3.z = r3.y * -2 + r4.x;
    r0.w = abs(r3.x) + r0.w;
    r2.x = abs(r3.z) + r2.x;
    r2.w = r3.w + r2.w;
    r0.w = cmp(r0.w >= r2.x);
    r2.x = r2.z * 2 + r2.w;
    r2.z = r0.w ? r5.y : r4.y;
    r2.y = r0.w ? r3.y : r2.y;
    r2.w = r0.w ? cb0[2].y : cb0[2].x;
    r2.x = r2.x * 0.0833333358 + -r1.y;
    r3.xy = r2.zy + -r1.yy;
    r2.yz = r2.yz + r1.yy;
    r3.z = cmp(abs(r3.x) >= abs(r3.y));
    r3.x = max(abs(r3.x), abs(r3.y));
    r2.w = r3.z ? -r2.w : r2.w;
    r0.z = saturate(abs(r2.x) * r0.z);
    r2.x = r0.w ? cb0[2].x : 0;
    r3.y = r0.w ? 0 : cb0[2].y;
    r4.xy = r2.ww * float2(0.5,0.5) + r0.xy;
    r3.w = r0.w ? r0.x : r4.x;
    r4.x = r0.w ? r4.y : r0.y;
    r5.x = r3.w + -r2.x;
    r5.y = r4.x + -r3.y;
    r6.x = r3.w + r2.x;
    r6.y = r4.x + r3.y;
    r3.w = r0.z * -2 + 3;
    r4.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r0.z = r0.z * r0.z;
    r7.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).xyzw;
    r2.y = r3.z ? r2.z : r2.y;
    r2.z = 0.25 * r3.x;
    r3.x = -r2.y * 0.5 + r1.y;
    r0.z = r3.w * r0.z;
    r3.x = cmp(r3.x < 0);
    r4.y = -r2.y * 0.5 + r4.y;
    r4.x = -r2.y * 0.5 + r7.y;
    r3.zw = cmp(abs(r4.yx) >= r2.zz);
    r5.z = r5.x + -r2.x;
    r5.x = r3.z ? r5.x : r5.z;
    r5.w = r5.y + -r3.y;
    r5.z = r3.z ? r5.y : r5.w;
    r5.yw = ~(int2)r3.zw;
    r5.y = (int)r5.w | (int)r5.y;
    r5.w = r6.x + r2.x;
    r6.x = r3.w ? r6.x : r5.w;
    r5.w = r6.y + r3.y;
    r6.z = r3.w ? r6.y : r5.w;
    if (r5.y != 0) {
      if (r3.z == 0) {
        r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
      } else {
        r7.x = r4.y;
      }
      if (r3.w == 0) {
        r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
      }
      r5.y = -r2.y * 0.5 + r7.x;
      r4.y = r3.z ? r7.x : r5.y;
      r3.z = -r2.y * 0.5 + r4.x;
      r4.x = r3.w ? r4.x : r3.z;
      r3.zw = cmp(abs(r4.yx) >= r2.zz);
      r5.y = r5.x + -r2.x;
      r5.x = r3.z ? r5.x : r5.y;
      r5.y = r5.z + -r3.y;
      r5.z = r3.z ? r5.z : r5.y;
      r5.yw = ~(int2)r3.zw;
      r5.y = (int)r5.w | (int)r5.y;
      r5.w = r6.x + r2.x;
      r6.x = r3.w ? r6.x : r5.w;
      r5.w = r6.z + r3.y;
      r6.z = r3.w ? r6.z : r5.w;
      if (r5.y != 0) {
        if (r3.z == 0) {
          r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
        } else {
          r7.x = r4.y;
        }
        if (r3.w == 0) {
          r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
        }
        r5.y = -r2.y * 0.5 + r7.x;
        r4.y = r3.z ? r7.x : r5.y;
        r3.z = -r2.y * 0.5 + r4.x;
        r4.x = r3.w ? r4.x : r3.z;
        r3.zw = cmp(abs(r4.yx) >= r2.zz);
        r5.y = r5.x + -r2.x;
        r5.x = r3.z ? r5.x : r5.y;
        r5.y = r5.z + -r3.y;
        r5.z = r3.z ? r5.z : r5.y;
        r5.yw = ~(int2)r3.zw;
        r5.y = (int)r5.w | (int)r5.y;
        r5.w = r6.x + r2.x;
        r6.x = r3.w ? r6.x : r5.w;
        r5.w = r6.z + r3.y;
        r6.z = r3.w ? r6.z : r5.w;
        if (r5.y != 0) {
          if (r3.z == 0) {
            r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
          } else {
            r7.x = r4.y;
          }
          if (r3.w == 0) {
            r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
          }
          r5.y = -r2.y * 0.5 + r7.x;
          r4.y = r3.z ? r7.x : r5.y;
          r3.z = -r2.y * 0.5 + r4.x;
          r4.x = r3.w ? r4.x : r3.z;
          r3.zw = cmp(abs(r4.yx) >= r2.zz);
          r5.y = r5.x + -r2.x;
          r5.x = r3.z ? r5.x : r5.y;
          r5.y = r5.z + -r3.y;
          r5.z = r3.z ? r5.z : r5.y;
          r5.yw = ~(int2)r3.zw;
          r5.y = (int)r5.w | (int)r5.y;
          r5.w = r6.x + r2.x;
          r6.x = r3.w ? r6.x : r5.w;
          r5.w = r6.z + r3.y;
          r6.z = r3.w ? r6.z : r5.w;
          if (r5.y != 0) {
            if (r3.z == 0) {
              r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
            } else {
              r7.x = r4.y;
            }
            if (r3.w == 0) {
              r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
            }
            r5.y = -r2.y * 0.5 + r7.x;
            r4.y = r3.z ? r7.x : r5.y;
            r3.z = -r2.y * 0.5 + r4.x;
            r4.x = r3.w ? r4.x : r3.z;
            r3.zw = cmp(abs(r4.yx) >= r2.zz);
            r5.y = -r2.x * 1.5 + r5.x;
            r5.x = r3.z ? r5.x : r5.y;
            r5.y = -r3.y * 1.5 + r5.z;
            r5.z = r3.z ? r5.z : r5.y;
            r5.yw = ~(int2)r3.zw;
            r5.y = (int)r5.w | (int)r5.y;
            r5.w = r2.x * 1.5 + r6.x;
            r6.x = r3.w ? r6.x : r5.w;
            r5.w = r3.y * 1.5 + r6.z;
            r6.z = r3.w ? r6.z : r5.w;
            if (r5.y != 0) {
              if (r3.z == 0) {
                r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
              } else {
                r7.x = r4.y;
              }
              if (r3.w == 0) {
                r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
              }
              r5.y = -r2.y * 0.5 + r7.x;
              r4.y = r3.z ? r7.x : r5.y;
              r3.z = -r2.y * 0.5 + r4.x;
              r4.x = r3.w ? r4.x : r3.z;
              r3.zw = cmp(abs(r4.yx) >= r2.zz);
              r5.y = -r2.x * 2 + r5.x;
              r5.x = r3.z ? r5.x : r5.y;
              r5.y = -r3.y * 2 + r5.z;
              r5.z = r3.z ? r5.z : r5.y;
              r5.yw = ~(int2)r3.zw;
              r5.y = (int)r5.w | (int)r5.y;
              r5.w = r2.x * 2 + r6.x;
              r6.x = r3.w ? r6.x : r5.w;
              r5.w = r3.y * 2 + r6.z;
              r6.z = r3.w ? r6.z : r5.w;
              if (r5.y != 0) {
                if (r3.z == 0) {
                  r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                } else {
                  r7.x = r4.y;
                }
                if (r3.w == 0) {
                  r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                }
                r5.y = -r2.y * 0.5 + r7.x;
                r4.y = r3.z ? r7.x : r5.y;
                r3.z = -r2.y * 0.5 + r4.x;
                r4.x = r3.w ? r4.x : r3.z;
                r3.zw = cmp(abs(r4.yx) >= r2.zz);
                r5.y = -r2.x * 2 + r5.x;
                r5.x = r3.z ? r5.x : r5.y;
                r5.y = -r3.y * 2 + r5.z;
                r5.z = r3.z ? r5.z : r5.y;
                r5.yw = ~(int2)r3.zw;
                r5.y = (int)r5.w | (int)r5.y;
                r5.w = r2.x * 2 + r6.x;
                r6.x = r3.w ? r6.x : r5.w;
                r5.w = r3.y * 2 + r6.z;
                r6.z = r3.w ? r6.z : r5.w;
                if (r5.y != 0) {
                  if (r3.z == 0) {
                    r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                  } else {
                    r7.x = r4.y;
                  }
                  if (r3.w == 0) {
                    r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                  }
                  r5.y = -r2.y * 0.5 + r7.x;
                  r4.y = r3.z ? r7.x : r5.y;
                  r3.z = -r2.y * 0.5 + r4.x;
                  r4.x = r3.w ? r4.x : r3.z;
                  r3.zw = cmp(abs(r4.yx) >= r2.zz);
                  r5.y = -r2.x * 2 + r5.x;
                  r5.x = r3.z ? r5.x : r5.y;
                  r5.y = -r3.y * 2 + r5.z;
                  r5.z = r3.z ? r5.z : r5.y;
                  r5.yw = ~(int2)r3.zw;
                  r5.y = (int)r5.w | (int)r5.y;
                  r5.w = r2.x * 2 + r6.x;
                  r6.x = r3.w ? r6.x : r5.w;
                  r5.w = r3.y * 2 + r6.z;
                  r6.z = r3.w ? r6.z : r5.w;
                  if (r5.y != 0) {
                    if (r3.z == 0) {
                      r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                    } else {
                      r7.x = r4.y;
                    }
                    if (r3.w == 0) {
                      r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                    }
                    r5.y = -r2.y * 0.5 + r7.x;
                    r4.y = r3.z ? r7.x : r5.y;
                    r3.z = -r2.y * 0.5 + r4.x;
                    r4.x = r3.w ? r4.x : r3.z;
                    r3.zw = cmp(abs(r4.yx) >= r2.zz);
                    r5.y = -r2.x * 2 + r5.x;
                    r5.x = r3.z ? r5.x : r5.y;
                    r5.y = -r3.y * 2 + r5.z;
                    r5.z = r3.z ? r5.z : r5.y;
                    r5.yw = ~(int2)r3.zw;
                    r5.y = (int)r5.w | (int)r5.y;
                    r5.w = r2.x * 2 + r6.x;
                    r6.x = r3.w ? r6.x : r5.w;
                    r5.w = r3.y * 2 + r6.z;
                    r6.z = r3.w ? r6.z : r5.w;
                    if (r5.y != 0) {
                      if (r3.z == 0) {
                        r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                      } else {
                        r7.x = r4.y;
                      }
                      if (r3.w == 0) {
                        r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                      }
                      r5.y = -r2.y * 0.5 + r7.x;
                      r4.y = r3.z ? r7.x : r5.y;
                      r3.z = -r2.y * 0.5 + r4.x;
                      r4.x = r3.w ? r4.x : r3.z;
                      r3.zw = cmp(abs(r4.yx) >= r2.zz);
                      r5.y = -r2.x * 4 + r5.x;
                      r5.x = r3.z ? r5.x : r5.y;
                      r5.y = -r3.y * 4 + r5.z;
                      r5.z = r3.z ? r5.z : r5.y;
                      r5.yw = ~(int2)r3.zw;
                      r5.y = (int)r5.w | (int)r5.y;
                      r5.w = r2.x * 4 + r6.x;
                      r6.x = r3.w ? r6.x : r5.w;
                      r5.w = r3.y * 4 + r6.z;
                      r6.z = r3.w ? r6.z : r5.w;
                      if (r5.y != 0) {
                        if (r3.z == 0) {
                          r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                        } else {
                          r7.x = r4.y;
                        }
                        if (r3.w == 0) {
                          r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                        }
                        r4.z = -r2.y * 0.5 + r7.x;
                        r4.y = r3.z ? r7.x : r4.z;
                        r2.y = -r2.y * 0.5 + r4.x;
                        r4.x = r3.w ? r4.x : r2.y;
                        r2.yz = cmp(abs(r4.yx) >= r2.zz);
                        r3.z = -r2.x * 8 + r5.x;
                        r5.x = r2.y ? r5.x : r3.z;
                        r3.z = -r3.y * 8 + r5.z;
                        r5.z = r2.y ? r5.z : r3.z;
                        r2.x = r2.x * 8 + r6.x;
                        r6.x = r2.z ? r6.x : r2.x;
                        r2.x = r3.y * 8 + r6.z;
                        r6.z = r2.z ? r6.z : r2.x;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    r2.xz = -r5.xz + r0.xy;
    r2.x = r0.w ? r2.x : r2.z;
    r2.yz = r6.xz + -r0.xy;
    r2.y = r0.w ? r2.y : r2.z;
    r3.yz = cmp(r4.yx < float2(0,0));
    r2.z = r2.y + r2.x;
    r3.xy = cmp((int2)r3.xx != (int2)r3.yz);
    r2.z = 1 / r2.z;
    r3.z = cmp(r2.x < r2.y);
    r2.x = min(r2.x, r2.y);
    r2.y = r3.z ? r3.x : r3.y;
    r0.z = r0.z * r0.z;
    r2.x = r2.x * -r2.z + 0.5;
    r0.z = cb0[7].x * r0.z;
    r2.x = (int)r2.x & (int)r2.y;
    r0.z = max(r2.x, r0.z);
    r2.xy = r0.zz * r2.ww + r0.xy;
    r3.x = r0.w ? r0.x : r2.x;
    r3.y = r0.w ? r2.y : r0.y;
    r1.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
  }
  o0.xyz = r1.xyz;
  o0.w = 1;

  //o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}