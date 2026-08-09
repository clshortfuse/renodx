#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r1.xyzw = cb0[2].xyxy * float4(0,1,1,0) + v1.xyxy;
  r2.xyzw = t0.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, r1.zw, 0).xyzw;
  r3.xyzw = cb0[2].xyxy * float4(0,-1,-1,0) + v1.xyxy;
  r4.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
  r3.xyzw = t0.SampleLevel(s0_s, r3.zw, 0).xyzw;
  r1.x = max(r2.y, r0.y);
  r1.z = min(r2.y, r0.y);
  r1.x = max(r1.y, r1.x);
  r1.z = min(r1.y, r1.z);
  r1.w = max(r4.y, r3.y);
  r2.x = min(r4.y, r3.y);
  r1.x = max(r1.w, r1.x);
  r1.z = min(r2.x, r1.z);
  r1.w = cb0[7].y * r1.x;
  r1.x = r1.x + -r1.z;
  r1.z = max(cb0[7].z, r1.w);
  if (r1.x >= r1.z) {
    r1.zw = -cb0[2].xy + v1.xy;
    r5.xyzw = t0.SampleLevel(s0_s, r1.zw, 0).xyzw;
    r1.zw = cb0[2].xy + v1.xy;
    r6.xyzw = t0.SampleLevel(s0_s, r1.zw, 0).xyzw;
    r7.xyzw = cb0[2].xyxy * float4(1,-1,-1,1) + v1.xyxy;
    r8.xyzw = t0.SampleLevel(s0_s, r7.xy, 0).xyzw;
    r7.xyzw = t0.SampleLevel(s0_s, r7.zw, 0).xyzw;
    r1.z = r4.y + r2.y;
    r1.w = r3.y + r1.y;
    r1.x = 1 / r1.x;
    r2.x = r1.z + r1.w;
    r1.z = r0.y * -2 + r1.z;
    r1.w = r0.y * -2 + r1.w;
    r2.z = r8.y + r6.y;
    r2.w = r8.y + r5.y;
    r3.x = r1.y * -2 + r2.z;
    r2.w = r4.y * -2 + r2.w;
    r3.z = r7.y + r5.y;
    r3.w = r7.y + r6.y;
    r1.z = abs(r1.z) * 2 + abs(r3.x);
    r1.w = abs(r1.w) * 2 + abs(r2.w);
    r2.w = r3.y * -2 + r3.z;
    r3.x = r2.y * -2 + r3.w;
    r1.z = abs(r2.w) + r1.z;
    r1.w = abs(r3.x) + r1.w;
    r2.z = r3.z + r2.z;
    bool isHorizontal = r1.z >= r1.w;
    r1.w = r2.x * 2 + r2.z;
    r2.x = isHorizontal ? r4.y : r3.y;
    r1.y = isHorizontal ? r2.y : r1.y;
    r2.y = isHorizontal ? cb0[2].y : cb0[2].x;
    r1.w = r1.w * 0.0833333358 + -r0.y;
    r2.z = r2.x + -r0.y;
    r2.w = r1.y + -r0.y;
    r2.x = r2.x + r0.y;
    r1.y = r1.y + r0.y;
    bool is1Steepest = abs(r2.z) >= abs(r2.w);
    r2.z = max(abs(r2.z), abs(r2.w));
    r2.y = is1Steepest ? -r2.y : r2.y;
    r1.x = saturate(abs(r1.w) * r1.x);
    r1.w = isHorizontal ? cb0[2].x : 0;
    r2.w = isHorizontal ? 0 : cb0[2].y;
    r3.yz = r2.yy * float2(0.5,0.5) + v1.xy;
    r3.y = isHorizontal ? v1.x : r3.y;
    r3.z = isHorizontal ? r3.z : v1.y;
    r4.x = r3.y + -r1.w;
    r4.y = r3.z + -r2.w;
    r5.x = r3.y + r1.w;
    r5.y = r3.z + r2.w;
    r3.y = r1.x * -2 + 3;
    r6.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
    r1.x = r1.x * r1.x;
    r7.xyzw = t0.SampleLevel(s0_s, r5.xy, 0).xyzw;
    r1.y = is1Steepest ? r2.x : r1.y;
    r2.x = 0.25 * r2.z;
    r2.z = -r1.y * 0.5 + r0.y;
    r1.x = r3.y * r1.x;
    bool isLumaCenterSmaller = r2.z < 0;
    r3.y = -r1.y * 0.5 + r6.y;
    r3.x = -r1.y * 0.5 + r7.y;
    bool reached1 = abs(r3.y) >= r2.x;
    bool reached2 = abs(r3.x) >= r2.x;
    r5.z = r4.x + -r1.w;
    r5.z = reached1 ? r4.x : r5.z;
    r4.x = r4.y + -r2.w;
    r5.w = reached1 ? r4.y : r4.x;
    bool notReachedBoth = !reached1 || !reached2;
    r4.y = r5.x + r1.w;
    r6.x = reached2 ? r5.x : r4.y;
    r4.y = r5.y + r2.w;
    r6.y = reached2 ? r5.y : r4.y;
    if (notReachedBoth) {
      if (!reached1) {
        r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
      } else {
        r7.x = r3.y;
      }
      if (!reached2) {
        r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
      }
      r4.x = -r1.y * 0.5 + r7.x;
      r3.y = reached1 ? r7.x : r4.x;
      r4.x = -r1.y * 0.5 + r3.x;
      r3.x = reached2 ? r3.x : r4.x;
      reached1 = abs(r3.y) >= r2.x;
      reached2 = abs(r3.x) >= r2.x;
      r4.z = r5.z + -r1.w;
      r5.z = reached1 ? r5.z : r4.z;
      r4.z = r5.w + -r2.w;
      r5.w = reached1 ? r5.w : r4.z;
      notReachedBoth = !reached1 || !reached2;
      r4.w = r6.x + r1.w;
      r6.x = reached2 ? r6.x : r4.w;
      r4.w = r6.y + r2.w;
      r6.y = reached2 ? r6.y : r4.w;
      if (notReachedBoth) {
        if (!reached1) {
          r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
        } else {
          r7.x = r3.y;
        }
        if (!reached2) {
          r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
        }
        r4.z = -r1.y * 0.5 + r7.x;
        r3.y = reached1 ? r7.x : r4.z;
        r4.x = -r1.y * 0.5 + r3.x;
        r3.x = reached2 ? r3.x : r4.x;
        reached1 = abs(r3.y) >= r2.x;
        reached2 = abs(r3.x) >= r2.x;
        r4.z = r5.z + -r1.w;
        r5.z = reached1 ? r5.z : r4.z;
        r4.z = r5.w + -r2.w;
        r5.w = reached1 ? r5.w : r4.z;
        notReachedBoth = !reached1 || !reached2;
        r4.w = r6.x + r1.w;
        r6.x = reached2 ? r6.x : r4.w;
        r4.w = r6.y + r2.w;
        r6.y = reached2 ? r6.y : r4.w;
        if (notReachedBoth) {
          if (!reached1) {
            r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
          } else {
            r7.x = r3.y;
          }
          if (!reached2) {
            r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
          }
          r4.z = -r1.y * 0.5 + r7.x;
          r3.y = reached1 ? r7.x : r4.z;
          r4.x = -r1.y * 0.5 + r3.x;
          r3.x = reached2 ? r3.x : r4.x;
          reached1 = abs(r3.y) >= r2.x;
          reached2 = abs(r3.x) >= r2.x;
          r4.z = r5.z + -r1.w;
          r5.z = reached1 ? r5.z : r4.z;
          r4.z = r5.w + -r2.w;
          r5.w = reached1 ? r5.w : r4.z;
          notReachedBoth = !reached1 || !reached2;
          r4.w = r6.x + r1.w;
          r6.x = reached2 ? r6.x : r4.w;
          r4.w = r6.y + r2.w;
          r6.y = reached2 ? r6.y : r4.w;
          if (notReachedBoth) {
            if (!reached1) {
              r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
            } else {
              r7.x = r3.y;
            }
            if (!reached2) {
              r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
            }
            r4.z = -r1.y * 0.5 + r7.x;
            r3.y = reached1 ? r7.x : r4.z;
            r4.x = -r1.y * 0.5 + r3.x;
            r3.x = reached2 ? r3.x : r4.x;
            reached1 = abs(r3.y) >= r2.x;
            reached2 = abs(r3.x) >= r2.x;
            r4.z = -r1.w * 1.5 + r5.z;
            r5.z = reached1 ? r5.z : r4.z;
            r4.z = -r2.w * 1.5 + r5.w;
            r5.w = reached1 ? r5.w : r4.z;
            notReachedBoth = !reached1 || !reached2;
            r4.w = r1.w * 1.5 + r6.x;
            r6.x = reached2 ? r6.x : r4.w;
            r4.w = r2.w * 1.5 + r6.y;
            r6.y = reached2 ? r6.y : r4.w;
            if (notReachedBoth) {
              if (!reached1) {
                r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
              } else {
                r7.x = r3.y;
              }
              if (!reached2) {
                r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
              }
              r4.z = -r1.y * 0.5 + r7.x;
              r3.y = reached1 ? r7.x : r4.z;
              r4.x = -r1.y * 0.5 + r3.x;
              r3.x = reached2 ? r3.x : r4.x;
              reached1 = abs(r3.y) >= r2.x;
              reached2 = abs(r3.x) >= r2.x;
              r4.z = -r1.w * 2 + r5.z;
              r5.z = reached1 ? r5.z : r4.z;
              r4.z = -r2.w * 2 + r5.w;
              r5.w = reached1 ? r5.w : r4.z;
              notReachedBoth = !reached1 || !reached2;
              r4.w = r1.w * 2 + r6.x;
              r6.x = reached2 ? r6.x : r4.w;
              r4.w = r2.w * 2 + r6.y;
              r6.y = reached2 ? r6.y : r4.w;
              if (notReachedBoth) {
                if (!reached1) {
                  r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
                } else {
                  r7.x = r3.y;
                }
                if (!reached2) {
                  r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
                }
                r4.z = -r1.y * 0.5 + r7.x;
                r3.y = reached1 ? r7.x : r4.z;
                r4.x = -r1.y * 0.5 + r3.x;
                r3.x = reached2 ? r3.x : r4.x;
                reached1 = abs(r3.y) >= r2.x;
                reached2 = abs(r3.x) >= r2.x;
                r4.z = -r1.w * 2 + r5.z;
                r5.z = reached1 ? r5.z : r4.z;
                r4.z = -r2.w * 2 + r5.w;
                r5.w = reached1 ? r5.w : r4.z;
                notReachedBoth = !reached1 || !reached2;
                r4.w = r1.w * 2 + r6.x;
                r6.x = reached2 ? r6.x : r4.w;
                r4.w = r2.w * 2 + r6.y;
                r6.y = reached2 ? r6.y : r4.w;
                if (notReachedBoth) {
                  if (!reached1) {
                    r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
                  } else {
                    r7.x = r3.y;
                  }
                  if (!reached2) {
                    r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
                  }
                  r4.z = -r1.y * 0.5 + r7.x;
                  r3.y = reached1 ? r7.x : r4.z;
                  r4.x = -r1.y * 0.5 + r3.x;
                  r3.x = reached2 ? r3.x : r4.x;
                  reached1 = abs(r3.y) >= r2.x;
                  reached2 = abs(r3.x) >= r2.x;
                  r4.z = -r1.w * 2 + r5.z;
                  r5.z = reached1 ? r5.z : r4.z;
                  r4.z = -r2.w * 2 + r5.w;
                  r5.w = reached1 ? r5.w : r4.z;
                  notReachedBoth = !reached1 || !reached2;
                  r4.w = r1.w * 2 + r6.x;
                  r6.x = reached2 ? r6.x : r4.w;
                  r4.w = r2.w * 2 + r6.y;
                  r6.y = reached2 ? r6.y : r4.w;
                  if (notReachedBoth) {
                    if (!reached1) {
                      r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
                    } else {
                      r7.x = r3.y;
                    }
                    if (!reached2) {
                      r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
                    }
                    r4.z = -r1.y * 0.5 + r7.x;
                    r3.y = reached1 ? r7.x : r4.z;
                    r4.x = -r1.y * 0.5 + r3.x;
                    r3.x = reached2 ? r3.x : r4.x;
                    reached1 = abs(r3.y) >= r2.x;
                    reached2 = abs(r3.x) >= r2.x;
                    r4.z = -r1.w * 2 + r5.z;
                    r5.z = reached1 ? r5.z : r4.z;
                    r4.z = -r2.w * 2 + r5.w;
                    r5.w = reached1 ? r5.w : r4.z;
                    notReachedBoth = !reached1 || !reached2;
                    r4.w = r1.w * 2 + r6.x;
                    r6.x = reached2 ? r6.x : r4.w;
                    r4.w = r2.w * 2 + r6.y;
                    r6.y = reached2 ? r6.y : r4.w;
                    if (notReachedBoth) {
                      if (!reached1) {
                        r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
                      } else {
                        r7.x = r3.y;
                      }
                      if (!reached2) {
                        r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
                      }
                      r4.z = -r1.y * 0.5 + r7.x;
                      r3.y = reached1 ? r7.x : r4.z;
                      r4.x = -r1.y * 0.5 + r3.x;
                      r3.x = reached2 ? r3.x : r4.x;
                      reached1 = abs(r3.y) >= r2.x;
                      reached2 = abs(r3.x) >= r2.x;
                      r4.z = -r1.w * 4 + r5.z;
                      r5.z = reached1 ? r5.z : r4.z;
                      r4.z = -r2.w * 4 + r5.w;
                      r5.w = reached1 ? r5.w : r4.z;
                      notReachedBoth = !reached1 || !reached2;
                      r4.w = r1.w * 4 + r6.x;
                      r6.x = reached2 ? r6.x : r4.w;
                      r4.w = r2.w * 4 + r6.y;
                      r6.y = reached2 ? r6.y : r4.w;
                      if (notReachedBoth) {
                        if (!reached1) {
                          r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0).yxzw;
                        } else {
                          r7.x = r3.y;
                        }
                        if (!reached2) {
                          r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).yxzw;
                        }
                        r3.z = -r1.y * 0.5 + r7.x;
                        r3.y = reached1 ? r7.x : r3.z;
                        r1.y = -r1.y * 0.5 + r3.x;
                        r3.x = reached2 ? r3.x : r1.y;
                        reached1 = abs(r3.y) >= r2.x;
                        reached2 = abs(r3.x) >= r2.x;
                        r1.y = -r1.w * 8 + r5.z;
                        r5.z = reached1 ? r5.z : r1.y;
                        r1.y = -r2.w * 8 + r5.w;
                        r5.w = reached1 ? r5.w : r1.y;
                        r1.y = r1.w * 8 + r6.x;
                        r6.x = reached2 ? r6.x : r1.y;
                        r1.y = r2.w * 8 + r6.y;
                        r6.y = reached2 ? r6.y : r1.y;
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
    r1.y = v1.x + -r5.z;
    r1.w = -v1.x + r6.x;
    r2.x = v1.y + -r5.w;
    r1.y = isHorizontal ? r1.y : r2.x;
    r2.x = -v1.y + r6.y;
    r1.w = isHorizontal ? r1.w : r2.x;
    bool correctVariation1 = (r3.y < 0.0);
    bool correctVariation2 = (r3.x < 0.0);
    r3.x = r1.w + r1.y;
    correctVariation1 = correctVariation1 != isLumaCenterSmaller;
    correctVariation2 = correctVariation2 != isLumaCenterSmaller;
    r2.w = 1 / r3.x;
    bool isDirection1 = r1.y < r1.w;
    r1.y = min(r1.y, r1.w);
    bool correctVariation = isDirection1 ? correctVariation1 : correctVariation2;
    r1.x = r1.x * r1.x;
    r1.y = r1.y * -r2.w + 0.5;
    r1.x = cb0[7].x * r1.x;
    r1.y = correctVariation ? r1.y : 0.0;
    r1.x = max(r1.y, r1.x);
    r1.xy = r1.xx * r2.yy + v1.xy;
    r2.x = isHorizontal ? v1.x : r1.x;
    r2.y = isHorizontal ? r1.y : v1.y;
    r1.xyzw = t0.SampleLevel(s0_s, r2.xy, 0).xyzw;
    o0.xyz = r1.xyz;
    o0.w = r0.y;
  } else {
    o0.xyzw = r0.xyzw;
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}