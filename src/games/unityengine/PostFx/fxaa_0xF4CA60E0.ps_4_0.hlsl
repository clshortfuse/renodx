#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

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
  r2.x = cb0[8].y * r0.z;
  r0.z = r0.z + -r0.w;
  r0.w = max(cb0[8].z, r2.x);
  if (r0.z >= r0.w) {
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
    bool isHorizontal = r0.w >= r2.x;
    r2.x = r2.z * 2 + r2.w;
    r2.z = isHorizontal ? r5.y : r4.y;
    r2.y = isHorizontal ? r3.y : r2.y;
    r2.w = isHorizontal ? cb0[2].y : cb0[2].x;
    r2.x = r2.x * 0.0833333358 + -r1.y;
    r3.xy = r2.zy + -r1.yy;
    r2.yz = r2.yz + r1.yy;
    bool is1Steepest = abs(r3.x) >= abs(r3.y);
    r3.x = max(abs(r3.x), abs(r3.y));
    r2.w = is1Steepest ? -r2.w : r2.w;
    r0.z = saturate(abs(r2.x) * r0.z);
    r2.x = isHorizontal ? cb0[2].x : 0;
    r3.y = isHorizontal ? 0 : cb0[2].y;
    r4.xy = r2.ww * float2(0.5,0.5) + r0.xy;
    r3.w = isHorizontal ? r0.x : r4.x;
    r4.x = isHorizontal ? r4.y : r0.y;
    r5.x = r3.w + -r2.x;
    r5.y = r4.x + -r3.y;
    r6.x = r3.w + r2.x;
    r6.y = r4.x + r3.y;
    r3.w = r0.z * -2 + 3;
    r4.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r0.z = r0.z * r0.z;
    r7.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).xyzw;
    r2.y = is1Steepest ? r2.z : r2.y;
    r2.z = 0.25 * r3.x;
    r3.x = -r2.y * 0.5 + r1.y;
    r0.z = r3.w * r0.z;
    bool isLumaCenterSmaller = r3.x < 0;
    r4.y = -r2.y * 0.5 + r4.y;
    r4.x = -r2.y * 0.5 + r7.y;
    bool reached1 = abs(r4.y) >= r2.z;
    bool reached2 = abs(r4.x) >= r2.z;
    r5.z = r5.x + -r2.x;
    r5.x = reached1 ? r5.x : r5.z;
    r5.w = r5.y + -r3.y;
    r5.z = reached1 ? r5.y : r5.w;
    bool notReachedBoth = !reached1 || !reached2;
    r5.w = r6.x + r2.x;
    r6.x = reached2 ? r6.x : r5.w;
    r5.w = r6.y + r3.y;
    r6.z = reached2 ? r6.y : r5.w;
    if (notReachedBoth) {
      if (!reached1) {
        r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
      } else {
        r7.x = r4.y;
      }
      if (!reached2) {
        r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
      }
      r5.y = -r2.y * 0.5 + r7.x;
      r4.y = reached1 ? r7.x : r5.y;
      r3.z = -r2.y * 0.5 + r4.x;
      r4.x = reached2 ? r4.x : r3.z;
      reached1 = abs(r4.y) >= r2.z;
      reached2 = abs(r4.x) >= r2.z;
      r5.y = r5.x + -r2.x;
      r5.x = reached1 ? r5.x : r5.y;
      r5.y = r5.z + -r3.y;
      r5.z = reached1 ? r5.z : r5.y;
      notReachedBoth = !reached1 || !reached2;
      r5.w = r6.x + r2.x;
      r6.x = reached2 ? r6.x : r5.w;
      r5.w = r6.z + r3.y;
      r6.z = reached2 ? r6.z : r5.w;
      if (notReachedBoth) {
        if (!reached1) {
          r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
        } else {
          r7.x = r4.y;
        }
        if (!reached2) {
          r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
        }
        r5.y = -r2.y * 0.5 + r7.x;
        r4.y = reached1 ? r7.x : r5.y;
        r3.z = -r2.y * 0.5 + r4.x;
        r4.x = reached2 ? r4.x : r3.z;
        reached1 = abs(r4.y) >= r2.z;
        reached2 = abs(r4.x) >= r2.z;
        r5.y = r5.x + -r2.x;
        r5.x = reached1 ? r5.x : r5.y;
        r5.y = r5.z + -r3.y;
        r5.z = reached1 ? r5.z : r5.y;
        notReachedBoth = !reached1 || !reached2;
        r5.w = r6.x + r2.x;
        r6.x = reached2 ? r6.x : r5.w;
        r5.w = r6.z + r3.y;
        r6.z = reached2 ? r6.z : r5.w;
        if (notReachedBoth) {
          if (!reached1) {
            r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
          } else {
            r7.x = r4.y;
          }
          if (!reached2) {
            r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
          }
          r5.y = -r2.y * 0.5 + r7.x;
          r4.y = reached1 ? r7.x : r5.y;
          r3.z = -r2.y * 0.5 + r4.x;
          r4.x = reached2 ? r4.x : r3.z;
          reached1 = abs(r4.y) >= r2.z;
          reached2 = abs(r4.x) >= r2.z;
          r5.y = r5.x + -r2.x;
          r5.x = reached1 ? r5.x : r5.y;
          r5.y = r5.z + -r3.y;
          r5.z = reached1 ? r5.z : r5.y;
          notReachedBoth = !reached1 || !reached2;
          r5.w = r6.x + r2.x;
          r6.x = reached2 ? r6.x : r5.w;
          r5.w = r6.z + r3.y;
          r6.z = reached2 ? r6.z : r5.w;
          if (notReachedBoth) {
            if (!reached1) {
              r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
            } else {
              r7.x = r4.y;
            }
            if (!reached2) {
              r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
            }
            r5.y = -r2.y * 0.5 + r7.x;
            r4.y = reached1 ? r7.x : r5.y;
            r3.z = -r2.y * 0.5 + r4.x;
            r4.x = reached2 ? r4.x : r3.z;
            reached1 = abs(r4.y) >= r2.z;
            reached2 = abs(r4.x) >= r2.z;
            r5.y = -r2.x * 1.5 + r5.x;
            r5.x = reached1 ? r5.x : r5.y;
            r5.y = -r3.y * 1.5 + r5.z;
            r5.z = reached1 ? r5.z : r5.y;
            notReachedBoth = !reached1 || !reached2;
            r5.w = r2.x * 1.5 + r6.x;
            r6.x = reached2 ? r6.x : r5.w;
            r5.w = r3.y * 1.5 + r6.z;
            r6.z = reached2 ? r6.z : r5.w;
            if (notReachedBoth) {
              if (!reached1) {
                r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
              } else {
                r7.x = r4.y;
              }
              if (!reached2) {
                r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
              }
              r5.y = -r2.y * 0.5 + r7.x;
              r4.y = reached1 ? r7.x : r5.y;
              r3.z = -r2.y * 0.5 + r4.x;
              r4.x = reached2 ? r4.x : r3.z;
              reached1 = abs(r4.y) >= r2.z;
              reached2 = abs(r4.x) >= r2.z;
              r5.y = -r2.x * 2 + r5.x;
              r5.x = reached1 ? r5.x : r5.y;
              r5.y = -r3.y * 2 + r5.z;
              r5.z = reached1 ? r5.z : r5.y;
              notReachedBoth = !reached1 || !reached2;
              r5.w = r2.x * 2 + r6.x;
              r6.x = reached2 ? r6.x : r5.w;
              r5.w = r3.y * 2 + r6.z;
              r6.z = reached2 ? r6.z : r5.w;
              if (notReachedBoth) {
                if (!reached1) {
                  r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                } else {
                  r7.x = r4.y;
                }
                if (!reached2) {
                  r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                }
                r5.y = -r2.y * 0.5 + r7.x;
                r4.y = reached1 ? r7.x : r5.y;
                r3.z = -r2.y * 0.5 + r4.x;
                r4.x = reached2 ? r4.x : r3.z;
                reached1 = abs(r4.y) >= r2.z;
                reached2 = abs(r4.x) >= r2.z;
                r5.y = -r2.x * 2 + r5.x;
                r5.x = reached1 ? r5.x : r5.y;
                r5.y = -r3.y * 2 + r5.z;
                r5.z = reached1 ? r5.z : r5.y;
                notReachedBoth = !reached1 || !reached2;
                r5.w = r2.x * 2 + r6.x;
                r6.x = reached2 ? r6.x : r5.w;
                r5.w = r3.y * 2 + r6.z;
                r6.z = reached2 ? r6.z : r5.w;
                if (notReachedBoth) {
                  if (!reached1) {
                    r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                  } else {
                    r7.x = r4.y;
                  }
                  if (!reached2) {
                    r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                  }
                  r5.y = -r2.y * 0.5 + r7.x;
                  r4.y = reached1 ? r7.x : r5.y;
                  r3.z = -r2.y * 0.5 + r4.x;
                  r4.x = reached2 ? r4.x : r3.z;
                  reached1 = abs(r4.y) >= r2.z;
                  reached2 = abs(r4.x) >= r2.z;
                  r5.y = -r2.x * 2 + r5.x;
                  r5.x = reached1 ? r5.x : r5.y;
                  r5.y = -r3.y * 2 + r5.z;
                  r5.z = reached1 ? r5.z : r5.y;
                  notReachedBoth = !reached1 || !reached2;
                  r5.w = r2.x * 2 + r6.x;
                  r6.x = reached2 ? r6.x : r5.w;
                  r5.w = r3.y * 2 + r6.z;
                  r6.z = reached2 ? r6.z : r5.w;
                  if (notReachedBoth) {
                    if (!reached1) {
                      r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                    } else {
                      r7.x = r4.y;
                    }
                    if (!reached2) {
                      r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                    }
                    r5.y = -r2.y * 0.5 + r7.x;
                    r4.y = reached1 ? r7.x : r5.y;
                    r3.z = -r2.y * 0.5 + r4.x;
                    r4.x = reached2 ? r4.x : r3.z;
                    reached1 = abs(r4.y) >= r2.z;
                    reached2 = abs(r4.x) >= r2.z;
                    r5.y = -r2.x * 2 + r5.x;
                    r5.x = reached1 ? r5.x : r5.y;
                    r5.y = -r3.y * 2 + r5.z;
                    r5.z = reached1 ? r5.z : r5.y;
                    notReachedBoth = !reached1 || !reached2;
                    r5.w = r2.x * 2 + r6.x;
                    r6.x = reached2 ? r6.x : r5.w;
                    r5.w = r3.y * 2 + r6.z;
                    r6.z = reached2 ? r6.z : r5.w;
                    if (notReachedBoth) {
                      if (!reached1) {
                        r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                      } else {
                        r7.x = r4.y;
                      }
                      if (!reached2) {
                        r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                      }
                      r5.y = -r2.y * 0.5 + r7.x;
                      r4.y = reached1 ? r7.x : r5.y;
                      r3.z = -r2.y * 0.5 + r4.x;
                      r4.x = reached2 ? r4.x : r3.z;
                      reached1 = abs(r4.y) >= r2.z;
                      reached2 = abs(r4.x) >= r2.z;
                      r5.y = -r2.x * 4 + r5.x;
                      r5.x = reached1 ? r5.x : r5.y;
                      r5.y = -r3.y * 4 + r5.z;
                      r5.z = reached1 ? r5.z : r5.y;
                      notReachedBoth = !reached1 || !reached2;
                      r5.w = r2.x * 4 + r6.x;
                      r6.x = reached2 ? r6.x : r5.w;
                      r5.w = r3.y * 4 + r6.z;
                      r6.z = reached2 ? r6.z : r5.w;
                      if (notReachedBoth) {
                        if (!reached1) {
                          r7.xyzw = t0.SampleLevel(s0_s, r5.xz, 0).yxzw;
                        } else {
                          r7.x = r4.y;
                        }
                        if (!reached2) {
                          r4.xyzw = t0.SampleLevel(s0_s, r6.xz, 0).yxzw;
                        }
                        r4.z = -r2.y * 0.5 + r7.x;
                        r4.y = reached1 ? r7.x : r4.z;
                        r2.y = -r2.y * 0.5 + r4.x;
                        r4.x = reached2 ? r4.x : r2.y;
                        reached1 = abs(r4.y) >= r2.z;
                        reached2 = abs(r4.x) >= r2.z;
                        r3.z = -r2.x * 8 + r5.x;
                        r5.x = reached1 ? r5.x : r3.z;
                        r3.z = -r3.y * 8 + r5.z;
                        r5.z = reached1 ? r5.z : r3.z;
                        r2.x = r2.x * 8 + r6.x;
                        r6.x = reached2 ? r6.x : r2.x;
                        r2.x = r3.y * 8 + r6.z;
                        r6.z = reached2 ? r6.z : r2.x;
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
    r2.x = isHorizontal ? r2.x : r2.z;
    r2.yz = r6.xz + -r0.xy;
    r2.y = isHorizontal ? r2.y : r2.z;
    bool correctVariation1 = (r3.x < 0.0);
    bool correctVariation2 = (r3.y < 0.0);
    r2.z = r2.y + r2.x;
    correctVariation1 = correctVariation1 != isLumaCenterSmaller;
    correctVariation2 = correctVariation2 != isLumaCenterSmaller;
    r2.z = 1 / r2.z;
    bool isDirection1 = r2.x < r2.y;
    r2.x = min(r2.x, r2.y);
    bool correctVariation = isDirection1 ? correctVariation1 : correctVariation2;
    r0.z = r0.z * r0.z;
    r2.x = r2.x * -r2.z + 0.5;
    r0.z = cb0[8].x * r0.z;
    r2.x = correctVariation ? r2.x : 0.0;
    r0.z = max(r2.x, r0.z);
    r2.xy = r0.zz * r2.ww + r0.xy;
    r3.x = isHorizontal ? r0.x : r2.x;
    r3.y = isHorizontal ? r2.y : r0.y;
    r0.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
    r1.w = r1.y;
  } else {
    r0.xyz = r1.xyz;
  }
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[7].yyy * r0.xyz;
  r1.xyz = exp2(r0.xyz);
  } else {
    r1.xyz = renodx::math::SignPow(r0.xyz, cb0[7].y);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r1.xyz = PostToneMapScale(r1.xyz);
  }
  o0.xyzw = r1.xyzw;
  return;
}