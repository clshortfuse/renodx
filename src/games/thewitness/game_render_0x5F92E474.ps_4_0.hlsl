#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) { float4 cb0[4]; }

// 3Dmigoto declarations
#define cmp -

void main(float4 v0
          : TEXCOORD0, float4 v1
          : TEXCOORD1, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
  float3 inputColor = r0.rgb;
  r1.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
  r2.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
  r3.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
  r4.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
  r1.x = max(r1.w, r0.w);
  r1.y = min(r1.w, r0.w);
  r1.x = max(r2.w, r1.x);
  r1.y = min(r2.w, r1.y);
  r1.z = max(r4.w, r3.w);
  r2.x = min(r4.w, r3.w);
  r1.x = max(r1.z, r1.x);
  r1.y = min(r2.x, r1.y);
  r1.z = cb0[2].x * r1.x;
  r1.x = r1.x + -r1.y;
  r1.y = max(cb0[3].x, r1.z);
  r1.y = cmp(r1.x >= r1.y);
  if (r1.y != 0) {
    r5.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
    r6.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
    r7.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
    r8.xyzw = t0.SampleLevel(s0_s, v0.xy, 0, int2(0, 0)).xyzw;
    r1.y = r3.w + r1.w;
    r1.z = r4.w + r2.w;
    r1.x = 1 / r1.x;
    r2.x = r1.y + r1.z;
    r1.y = r0.w * -2 + r1.y;
    r1.z = r0.w * -2 + r1.z;
    r2.y = r7.w + r6.w;
    r2.z = r7.w + r5.w;
    r3.x = r2.w * -2 + r2.y;
    r2.z = r3.w * -2 + r2.z;
    r3.y = r8.w + r5.w;
    r3.z = r8.w + r6.w;
    r1.y = abs(r1.y) * 2 + abs(r3.x);
    r1.z = abs(r1.z) * 2 + abs(r2.z);
    r2.z = r4.w * -2 + r3.y;
    r3.x = r1.w * -2 + r3.z;
    r1.y = abs(r2.z) + r1.y;
    r1.z = abs(r3.x) + r1.z;
    r2.y = r3.y + r2.y;
    r1.y = cmp(r1.y >= r1.z);
    r1.z = r2.x * 2 + r2.y;
    r2.x = r1.y ? r3.w : r4.w;
    r1.w = r1.y ? r1.w : r2.w;
    r2.y = r1.y ? cb0[0].y : cb0[0].x;
    r1.z = r1.z * 0.0833333358 + -r0.w;
    r2.z = r2.x + -r0.w;
    r2.w = r1.w + -r0.w;
    r2.x = r2.x + r0.w;
    r1.w = r1.w + r0.w;
    r3.x = cmp(abs(r2.z) >= abs(r2.w));
    r2.z = max(abs(r2.z), abs(r2.w));
    r2.y = r3.x ? -r2.y : r2.y;
    r1.x = saturate(abs(r1.z) * r1.x);
    r1.z = r1.y ? cb0[0].x : 0;
    r2.w = r1.y ? 0 : cb0[0].y;
    r3.yz = r2.yy * float2(0.5, 0.5) + v0.xy;
    r3.y = r1.y ? v0.x : r3.y;
    r3.z = r1.y ? r3.z : v0.y;
    r4.x = r3.y + -r1.z;
    r4.y = r3.z + -r2.w;
    r5.x = r3.y + r1.z;
    r5.y = r3.z + r2.w;
    r3.y = r1.x * -2 + 3;
    r6.xyzw = t0.SampleLevel(s0_s, r4.xy, 0, int2(0, 0)).xyzw;
    r1.x = r1.x * r1.x;
    r7.xyzw = t0.SampleLevel(s0_s, r5.xy, 0, int2(0, 0)).xyzw;
    r1.w = r3.x ? r2.x : r1.w;
    r2.x = 0.25 * r2.z;
    r2.z = -r1.w * 0.5 + r0.w;
    r1.x = r3.y * r1.x;
    r2.z = cmp(r2.z < 0);
    r3.y = -r1.w * 0.5 + r6.w;
    r3.x = -r1.w * 0.5 + r7.w;
    r4.zw = cmp(abs(r3.yx) >= r2.xx);
    r5.z = -r1.z * 1.5 + r4.x;
    r5.z = r4.z ? r4.x : r5.z;
    r4.x = -r2.w * 1.5 + r4.y;
    r5.w = r4.z ? r4.y : r4.x;
    r4.xy = ~(int2)r4.zw;
    r4.x = (int)r4.y | (int)r4.x;
    r4.y = r1.z * 1.5 + r5.x;
    r6.x = r4.w ? r5.x : r4.y;
    r4.y = r2.w * 1.5 + r5.y;
    r6.y = r4.w ? r5.y : r4.y;
    if (r4.x != 0) {
      if (r4.z == 0) {
        r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0, int2(0, 0)).wxyz;
      } else {
        r7.x = r3.y;
      }
      if (r4.w == 0) {
        r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0, int2(0, 0)).wxyz;
      }
      r4.x = -r1.w * 0.5 + r7.x;
      r3.y = r4.z ? r7.x : r4.x;
      r4.x = -r1.w * 0.5 + r3.x;
      r3.x = r4.w ? r3.x : r4.x;
      r4.xy = cmp(abs(r3.yx) >= r2.xx);
      r4.z = -r1.z * 2 + r5.z;
      r5.z = r4.x ? r5.z : r4.z;
      r4.z = -r2.w * 2 + r5.w;
      r5.w = r4.x ? r5.w : r4.z;
      r4.zw = ~(int2)r4.xy;
      r4.z = (int)r4.w | (int)r4.z;
      r4.w = r1.z * 2 + r6.x;
      r6.x = r4.y ? r6.x : r4.w;
      r4.w = r2.w * 2 + r6.y;
      r6.y = r4.y ? r6.y : r4.w;
      if (r4.z != 0) {
        if (r4.x == 0) {
          r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0, int2(0, 0)).wxyz;
        } else {
          r7.x = r3.y;
        }
        if (r4.y == 0) {
          r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0, int2(0, 0)).wxyz;
        }
        r4.z = -r1.w * 0.5 + r7.x;
        r3.y = r4.x ? r7.x : r4.z;
        r4.x = -r1.w * 0.5 + r3.x;
        r3.x = r4.y ? r3.x : r4.x;
        r4.xy = cmp(abs(r3.yx) >= r2.xx);
        r4.z = -r1.z * 4 + r5.z;
        r5.z = r4.x ? r5.z : r4.z;
        r4.z = -r2.w * 4 + r5.w;
        r5.w = r4.x ? r5.w : r4.z;
        r4.zw = ~(int2)r4.xy;
        r4.z = (int)r4.w | (int)r4.z;
        r4.w = r1.z * 4 + r6.x;
        r6.x = r4.y ? r6.x : r4.w;
        r4.w = r2.w * 4 + r6.y;
        r6.y = r4.y ? r6.y : r4.w;
        if (r4.z != 0) {
          if (r4.x == 0) {
            r7.xyzw = t0.SampleLevel(s0_s, r5.zw, 0, int2(0, 0)).wxyz;
          } else {
            r7.x = r3.y;
          }
          if (r4.y == 0) {
            r3.xyzw = t0.SampleLevel(s0_s, r6.xy, 0, int2(0, 0)).wxyz;
          }
          r3.z = -r1.w * 0.5 + r7.x;
          r3.y = r4.x ? r7.x : r3.z;
          r1.w = -r1.w * 0.5 + r3.x;
          r3.x = r4.y ? r3.x : r1.w;
          r3.zw = cmp(abs(r3.yx) >= r2.xx);
          r1.w = -r1.z * 12 + r5.z;
          r5.z = r3.z ? r5.z : r1.w;
          r1.w = -r2.w * 12 + r5.w;
          r5.w = r3.z ? r5.w : r1.w;
          r1.z = r1.z * 12 + r6.x;
          r6.x = r3.w ? r6.x : r1.z;
          r1.z = r2.w * 12 + r6.y;
          r6.y = r3.w ? r6.y : r1.z;
        }
      }
    }
    r1.z = v0.x + -r5.z;
    r1.w = -v0.x + r6.x;
    r2.x = v0.y + -r5.w;
    r1.z = r1.y ? r1.z : r2.x;
    r2.x = -v0.y + r6.y;
    r1.w = r1.y ? r1.w : r2.x;
    r2.xw = cmp(r3.yx < float2(0, 0));
    r3.x = r1.w + r1.z;
    r2.xz = cmp((int2)r2.zz != (int2)r2.xw);
    r2.w = 1 / r3.x;
    r3.x = cmp(r1.z < r1.w);
    r1.z = min(r1.z, r1.w);
    r1.w = r3.x ? r2.x : r2.z;
    r1.x = r1.x * r1.x;
    r1.z = r1.z * -r2.w + 0.5;
    r1.x = cb0[1].x * r1.x;
    r1.z = (int)r1.z & (int)r1.w;
    r1.x = max(r1.z, r1.x);
    r1.xz = r1.xx * r2.yy + v0.xy;
    r2.x = r1.y ? v0.x : r1.x;
    r2.y = r1.y ? r1.z : v0.y;
    r1.xyzw = t0.SampleLevel(s0_s, r2.xy, 0, int2(0, 0)).xyzw;
    r0.xyz = r1.xyz;
  }
  o0.xyzw = r0.xyzw;
  o0.rgb = inputColor;

  if (injectedData.toneMapGammaCorrection) {
    o0.rgb = renodx::color::correct::GammaSafe(o0.rgb);
  }

  o0.rgb *= injectedData.toneMapGameNits / 80.f;
  return;
}