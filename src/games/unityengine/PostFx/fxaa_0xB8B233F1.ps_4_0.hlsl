#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[30];
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

  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r1.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r2.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
  r3.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
  r4.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
  r5.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
  r0.z = max(r2.y, r1.y);
  r0.w = min(r2.y, r1.y);
  r0.z = max(r3.y, r0.z);
  r0.w = min(r3.y, r0.w);
  r2.x = max(r5.y, r4.y);
  r2.z = min(r5.y, r4.y);
  r0.z = max(r2.x, r0.z);
  r0.w = min(r2.z, r0.w);
  r2.x = 0.063000001 * r0.z;
  r0.z = r0.z + -r0.w;
  r0.w = max(0.0311999992, r2.x);
  if (r0.z >= r0.w) {
    r6.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
    r7.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
    r8.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
    r9.xyzw = t1.SampleLevel(s1_s, r0.xy, 0, int2(0, 0)).xyzw;
    r0.x = r4.y + r2.y;
    r0.y = r5.y + r3.y;
    r0.z = 1 / r0.z;
    r0.w = r0.x + r0.y;
    r0.x = r1.y * -2 + r0.x;
    r0.y = r1.y * -2 + r0.y;
    r2.x = r8.y + r7.y;
    r2.z = r8.y + r6.y;
    r2.w = r3.y * -2 + r2.x;
    r2.z = r4.y * -2 + r2.z;
    r3.x = r9.y + r6.y;
    r3.z = r9.y + r7.y;
    r0.x = abs(r0.x) * 2 + abs(r2.w);
    r0.y = abs(r0.y) * 2 + abs(r2.z);
    r2.z = r5.y * -2 + r3.x;
    r2.w = r2.y * -2 + r3.z;
    r0.xy = abs(r2.zw) + r0.xy;
    r2.x = r3.x + r2.x;
    bool isHorizontal = r0.x >= r0.y;
    r0.y = r0.w * 2 + r2.x;
    r0.w = isHorizontal ? r4.y : r5.y;
    r2.x = isHorizontal ? r2.y : r3.y;
    r2.y = isHorizontal ? cb0[29].y : cb0[29].x;
    r0.y = r0.y * 0.0833333358 + -r1.y;
    r2.z = r0.w + -r1.y;
    r2.w = r2.x + -r1.y;
    r0.w = r0.w + r1.y;
    r2.x = r2.x + r1.y;
    bool is1Steepest = abs(r2.z) >= abs(r2.w);
    r2.z = max(abs(r2.z), abs(r2.w));
    r2.y = is1Steepest ? -r2.y : r2.y;
    r0.y = saturate(abs(r0.y) * r0.z);
    r0.z = isHorizontal ? cb0[29].x : 0;
    r2.w = isHorizontal ? 0 : cb0[29].y;
    r3.yz = r2.yy * float2(0.5,0.5) + v1.xy;
    r3.y = isHorizontal ? v1.x : r3.y;
    r3.z = isHorizontal ? r3.z : v1.y;
    r4.x = r3.y + -r0.z;
    r4.y = r3.z + -r2.w;
    r5.x = r3.y + r0.z;
    r5.y = r3.z + r2.w;
    r3.y = r0.y * -2 + 3;
    r3.zw = saturate(r4.xy);
    r3.zw = cb0[26].xx * r3.zw;
    r6.xyzw = t1.SampleLevel(s1_s, r3.zw, 0).xyzw;
    r0.y = r0.y * r0.y;
    r3.zw = saturate(r5.xy);
    r3.zw = cb0[26].xx * r3.zw;
    r7.xyzw = t1.SampleLevel(s1_s, r3.zw, 0).xyzw;
    r0.w = is1Steepest ? r0.w : r2.x;
    r2.x = 0.25 * r2.z;
    r2.z = -r0.w * 0.5 + r1.y;
    r0.y = r3.y * r0.y;
    bool isLumaCenterSmaller = r2.z < 0;
    r3.y = -r0.w * 0.5 + r6.y;
    r3.x = -r0.w * 0.5 + r7.y;
    bool reached1 = abs(r3.y) >= r2.x;
    bool reached2 = abs(r3.x) >= r2.x;
    r5.z = -r0.z * 1.5 + r4.x;
    r5.z = reached1 ? r4.x : r5.z;
    r4.x = -r2.w * 1.5 + r4.y;
    r5.w = reached1 ? r4.y : r4.x;
    bool notReachedBoth = !reached1 || !reached2;
    r4.y = r0.z * 1.5 + r5.x;
    r6.x = reached2 ? r5.x : r4.y;
    r4.y = r2.w * 1.5 + r5.y;
    r6.y = reached2 ? r5.y : r4.y;
    if (notReachedBoth) {
      if (!reached1) {
        r4.xy = saturate(r5.zw);
        r4.xy = cb0[26].xx * r4.xy;
        r7.xyzw = t1.SampleLevel(s1_s, r4.xy, 0).yxzw;
      } else {
        r7.x = r3.y;
      }
      if (!reached2) {
        r4.xy = saturate(r6.xy);
        r4.xy = cb0[26].xx * r4.xy;
        r3.xyzw = t1.SampleLevel(s1_s, r4.xy, 0).yxzw;
      }
      r4.x = -r0.w * 0.5 + r7.x;
      r3.y = reached1 ? r7.x : r4.x;
      r4.x = -r0.w * 0.5 + r3.x;
      r3.x = reached2 ? r3.x : r4.x;
      reached1 = abs(r3.y) >= r2.x;
      reached2 = abs(r3.x) >= r2.x;
      r4.z = -r0.z * 2 + r5.z;
      r5.z = reached1 ? r5.z : r4.z;
      r4.z = -r2.w * 2 + r5.w;
      r5.w = reached1 ? r5.w : r4.z;
      notReachedBoth = !reached1 || !reached2;
      r4.w = r0.z * 2 + r6.x;
      r6.x = reached2 ? r6.x : r4.w;
      r4.w = r2.w * 2 + r6.y;
      r6.y = reached2 ? r6.y : r4.w;
      if (notReachedBoth) {
        if (!reached1) {
          r4.zw = saturate(r5.zw);
          r4.zw = cb0[26].xx * r4.zw;
          r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
        } else {
          r7.x = r3.y;
        }
        if (!reached2) {
          r4.zw = saturate(r6.xy);
          r4.zw = cb0[26].xx * r4.zw;
          r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
        }
        r4.z = -r0.w * 0.5 + r7.x;
        r3.y = reached1 ? r7.x : r4.z;
        r4.x = -r0.w * 0.5 + r3.x;
        r3.x = reached2 ? r3.x : r4.x;
        reached1 = abs(r3.y) >= r2.x;
        reached2 = abs(r3.x) >= r2.x;
        r4.z = -r0.z * 2 + r5.z;
        r5.z = reached1 ? r5.z : r4.z;
        r4.z = -r2.w * 2 + r5.w;
        r5.w = reached1 ? r5.w : r4.z;
        notReachedBoth = !reached1 || !reached2;
        r4.w = r0.z * 2 + r6.x;
        r6.x = reached2 ? r6.x : r4.w;
        r4.w = r2.w * 2 + r6.y;
        r6.y = reached2 ? r6.y : r4.w;
        if (notReachedBoth) {
          if (!reached1) {
            r4.zw = saturate(r5.zw);
            r4.zw = cb0[26].xx * r4.zw;
            r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
          } else {
            r7.x = r3.y;
          }
          if (!reached2) {
            r4.zw = saturate(r6.xy);
            r4.zw = cb0[26].xx * r4.zw;
            r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
          }
          r4.z = -r0.w * 0.5 + r7.x;
          r3.y = reached1 ? r7.x : r4.z;
          r4.x = -r0.w * 0.5 + r3.x;
          r3.x = reached2 ? r3.x : r4.x;
          reached1 = abs(r3.y) >= r2.x;
          reached2 = abs(r3.x) >= r2.x;
          r4.z = -r0.z * 2 + r5.z;
          r5.z = reached1 ? r5.z : r4.z;
          r4.z = -r2.w * 2 + r5.w;
          r5.w = reached1 ? r5.w : r4.z;
          notReachedBoth = !reached1 || !reached2;
          r4.w = r0.z * 2 + r6.x;
          r6.x = reached2 ? r6.x : r4.w;
          r4.w = r2.w * 2 + r6.y;
          r6.y = reached2 ? r6.y : r4.w;
          if (notReachedBoth) {
            if (!reached1) {
              r4.zw = saturate(r5.zw);
              r4.zw = cb0[26].xx * r4.zw;
              r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
            } else {
              r7.x = r3.y;
            }
            if (!reached2) {
              r4.zw = saturate(r6.xy);
              r4.zw = cb0[26].xx * r4.zw;
              r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
            }
            r4.z = -r0.w * 0.5 + r7.x;
            r3.y = reached1 ? r7.x : r4.z;
            r4.x = -r0.w * 0.5 + r3.x;
            r3.x = reached2 ? r3.x : r4.x;
            reached1 = abs(r3.y) >= r2.x;
            reached2 = abs(r3.x) >= r2.x;
            r4.z = -r0.z * 2 + r5.z;
            r5.z = reached1 ? r5.z : r4.z;
            r4.z = -r2.w * 2 + r5.w;
            r5.w = reached1 ? r5.w : r4.z;
            notReachedBoth = !reached1 || !reached2;
            r4.w = r0.z * 2 + r6.x;
            r6.x = reached2 ? r6.x : r4.w;
            r4.w = r2.w * 2 + r6.y;
            r6.y = reached2 ? r6.y : r4.w;
            if (notReachedBoth) {
              if (!reached1) {
                r4.zw = saturate(r5.zw);
                r4.zw = cb0[26].xx * r4.zw;
                r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
              } else {
                r7.x = r3.y;
              }
              if (!reached2) {
                r4.zw = saturate(r6.xy);
                r4.zw = cb0[26].xx * r4.zw;
                r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
              }
              r4.z = -r0.w * 0.5 + r7.x;
              r3.y = reached1 ? r7.x : r4.z;
              r4.x = -r0.w * 0.5 + r3.x;
              r3.x = reached2 ? r3.x : r4.x;
              reached1 = abs(r3.y) >= r2.x;
              reached2 = abs(r3.x) >= r2.x;
              r4.z = -r0.z * 2 + r5.z;
              r5.z = reached1 ? r5.z : r4.z;
              r4.z = -r2.w * 2 + r5.w;
              r5.w = reached1 ? r5.w : r4.z;
              notReachedBoth = !reached1 || !reached2;
              r4.w = r0.z * 2 + r6.x;
              r6.x = reached2 ? r6.x : r4.w;
              r4.w = r2.w * 2 + r6.y;
              r6.y = reached2 ? r6.y : r4.w;
              if (notReachedBoth) {
                if (!reached1) {
                  r4.zw = saturate(r5.zw);
                  r4.zw = cb0[26].xx * r4.zw;
                  r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                } else {
                  r7.x = r3.y;
                }
                if (!reached2) {
                  r4.zw = saturate(r6.xy);
                  r4.zw = cb0[26].xx * r4.zw;
                  r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                }
                r4.z = -r0.w * 0.5 + r7.x;
                r3.y = reached1 ? r7.x : r4.z;
                r4.x = -r0.w * 0.5 + r3.x;
                r3.x = reached2 ? r3.x : r4.x;
                reached1 = abs(r3.y) >= r2.x;
                reached2 = abs(r3.x) >= r2.x;
                r4.z = -r0.z * 2 + r5.z;
                r5.z = reached1 ? r5.z : r4.z;
                r4.z = -r2.w * 2 + r5.w;
                r5.w = reached1 ? r5.w : r4.z;
                notReachedBoth = !reached1 || !reached2;
                r4.w = r0.z * 2 + r6.x;
                r6.x = reached2 ? r6.x : r4.w;
                r4.w = r2.w * 2 + r6.y;
                r6.y = reached2 ? r6.y : r4.w;
                if (notReachedBoth) {
                  if (!reached1) {
                    r4.zw = saturate(r5.zw);
                    r4.zw = cb0[26].xx * r4.zw;
                    r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                  } else {
                    r7.x = r3.y;
                  }
                  if (!reached2) {
                    r4.zw = saturate(r6.xy);
                    r4.zw = cb0[26].xx * r4.zw;
                    r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                  }
                  r4.z = -r0.w * 0.5 + r7.x;
                  r3.y = reached1 ? r7.x : r4.z;
                  r4.x = -r0.w * 0.5 + r3.x;
                  r3.x = reached2 ? r3.x : r4.x;
                  reached1 = abs(r3.y) >= r2.x;
                  reached2 = abs(r3.x) >= r2.x;
                  r4.z = -r0.z * 2 + r5.z;
                  r5.z = reached1 ? r5.z : r4.z;
                  r4.z = -r2.w * 2 + r5.w;
                  r5.w = reached1 ? r5.w : r4.z;
                  notReachedBoth = !reached1 || !reached2;
                  r4.w = r0.z * 2 + r6.x;
                  r6.x = reached2 ? r6.x : r4.w;
                  r4.w = r2.w * 2 + r6.y;
                  r6.y = reached2 ? r6.y : r4.w;
                  if (notReachedBoth) {
                    if (!reached1) {
                      r4.zw = saturate(r5.zw);
                      r4.zw = cb0[26].xx * r4.zw;
                      r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                    } else {
                      r7.x = r3.y;
                    }
                    if (!reached2) {
                      r4.zw = saturate(r6.xy);
                      r4.zw = cb0[26].xx * r4.zw;
                      r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                    }
                    r4.z = -r0.w * 0.5 + r7.x;
                    r3.y = reached1 ? r7.x : r4.z;
                    r4.x = -r0.w * 0.5 + r3.x;
                    r3.x = reached2 ? r3.x : r4.x;
                    reached1 = abs(r3.y) >= r2.x;
                    reached2 = abs(r3.x) >= r2.x;
                    r4.z = -r0.z * 4 + r5.z;
                    r5.z = reached1 ? r5.z : r4.z;
                    r4.z = -r2.w * 4 + r5.w;
                    r5.w = reached1 ? r5.w : r4.z;
                    notReachedBoth = !reached1 || !reached2;
                    r4.w = r0.z * 4 + r6.x;
                    r6.x = reached2 ? r6.x : r4.w;
                    r4.w = r2.w * 4 + r6.y;
                    r6.y = reached2 ? r6.y : r4.w;
                    if (notReachedBoth) {
                      if (!reached1) {
                        r4.zw = saturate(r5.zw);
                        r4.zw = cb0[26].xx * r4.zw;
                        r7.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                      } else {
                        r7.x = r3.y;
                      }
                      if (!reached2) {
                        r4.zw = saturate(r6.xy);
                        r4.zw = cb0[26].xx * r4.zw;
                        r3.xyzw = t1.SampleLevel(s1_s, r4.zw, 0).yxzw;
                      }
                      r3.z = -r0.w * 0.5 + r7.x;
                      r3.y = reached1 ? r7.x : r3.z;
                      r0.w = -r0.w * 0.5 + r3.x;
                      r3.x = reached2 ? r3.x : r0.w;
                      reached1 = abs(r3.y) >= r2.x;
                      reached2 = abs(r3.x) >= r2.x;
                      r0.w = -r0.z * 8 + r5.z;
                      r5.z = reached1 ? r5.z : r0.w;
                      r0.w = -r2.w * 8 + r5.w;
                      r5.w = reached1 ? r5.w : r0.w;
                      r0.z = r0.z * 8 + r6.x;
                      r6.x = reached2 ? r6.x : r0.z;
                      r0.z = r2.w * 8 + r6.y;
                      r6.y = reached2 ? r6.y : r0.z;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    r0.z = v1.x + -r5.z;
    r0.w = -v1.x + r6.x;
    r2.x = v1.y + -r5.w;
    r0.z = isHorizontal ? r0.z : r2.x;
    r2.x = -v1.y + r6.y;
    r0.w = isHorizontal ? r0.w : r2.x;
    bool correctVariation1 = (r3.y < 0.0);
    bool correctVariation2 = (r3.x < 0.0);
    r3.x = r0.w + r0.z;
    correctVariation1 = correctVariation1 != isLumaCenterSmaller;
    correctVariation2 = correctVariation2 != isLumaCenterSmaller;
    r2.w = 1 / r3.x;
    bool isDirection1 = r0.z < r0.w;
    r0.z = min(r0.z, r0.w);
    bool correctVariation = isDirection1 ? correctVariation1 : correctVariation2;
    r0.y = r0.y * r0.y;
    r0.z = r0.z * -r2.w + 0.5;
    r0.z = correctVariation ? r0.z : 0.0;
    r0.y = max(r0.z, r0.y);
    r0.yz = r0.yy * r2.yy + v1.xy;
    r2.x = saturate(isHorizontal ? v1.x : r0.y);
    r2.y = saturate(isHorizontal ? r0.z : v1.y);
    r0.xy = cb0[26].xx * r2.xy;
    r0.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
    r1.w = r1.y;
  } else {
    r0.xyz = r1.xyz;
  }
  r2.xy = v1.xy * cb0[28].xy + cb0[28].zw;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r0.w = r2.w * 2 + -1;
  r2.x = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r2.x = r2.x * 2 + -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r2.x * r0.w;
  r1.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r1.xyz = PostToneMapScale(r1.xyz);
  }
  o0.xyzw = r1.xyzw;
  return;
}