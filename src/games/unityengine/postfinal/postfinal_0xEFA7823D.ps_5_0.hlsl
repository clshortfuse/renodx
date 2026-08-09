#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[140];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.SampleBias(s0_s, v1.xy, cb0[4].x).xyz;
  r0.w = renodx::color::y::from::NTSC1953(saturate(r0.xyz));
  r1.xyzw = cb0[136].zwzw * float4(0,1,1,0) + v1.xyxy;
  r2.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  r1.x = renodx::color::y::from::NTSC1953(saturate(r2.xyz));
  r1.yzw = t0.SampleLevel(s0_s, r1.zw, 0).xyz;
  r1.y = renodx::color::y::from::NTSC1953(saturate(r1.yzw));
  r2.xyzw = cb0[136].zwzw * float4(0,-1,-1,0) + v1.xyxy;
  r3.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r1.z = renodx::color::y::from::NTSC1953(saturate(r3.xyz));
  r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
  r1.w = renodx::color::y::from::NTSC1953(saturate(r2.xyz));
  r2.x = max(r1.x, r0.w);
  r2.y = min(r1.x, r0.w);
  r2.x = max(r2.x, r1.y);
  r2.y = min(r2.y, r1.y);
  r2.z = max(r1.z, r1.w);
  r2.w = min(r1.z, r1.w);
  r2.x = max(r2.z, r2.x);
  r2.y = min(r2.w, r2.y);
  r2.z = 0.15 * r2.x;
  r2.x = r2.x + -r2.y;
  r2.y = max(0.0299999993, r2.z);
  if (r2.x >= r2.y) {
    r2.yz = -cb0[136].zw + v1.xy;
    r2.yzw = t0.SampleLevel(s0_s, r2.yz, 0).xyz;
    r2.y = renodx::color::y::from::NTSC1953(saturate(r2.yzw));
    r2.zw = cb0[136].zw + v1.xy;
    r3.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
    r2.z = renodx::color::y::from::NTSC1953(saturate(r3.xyz));
    r3.xyzw = cb0[136].zwzw * float4(1,-1,-1,1) + v1.xyxy;
    r4.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
    r2.w = renodx::color::y::from::NTSC1953(saturate(r4.xyz));
    r3.xyz = t0.SampleLevel(s0_s, r3.zw, 0).xyz;
    r3.x = renodx::color::y::from::NTSC1953(saturate(r3.xyz));
    r3.yz = r1.zw + r1.xy;
    r2.x = 1 / r2.x;
    r3.w = r3.y + r3.z;
    r3.y = r0.w * -2 + r3.y;
    r3.z = r0.w * -2 + r3.z;
    r4.x = r2.w + r2.z;
    r2.w = r2.y + r2.w;
    r4.y = r1.y * -2 + r4.x;
    r2.w = r1.z * -2 + r2.w;
    r2.y = r3.x + r2.y;
    r2.z = r3.x + r2.z;
    r3.x = abs(r3.y) * 2 + abs(r4.y);
    r2.w = abs(r3.z) * 2 + abs(r2.w);
    r3.y = r1.w * -2 + r2.y;
    r2.z = r1.x * -2 + r2.z;
    r3.x = abs(r3.y) + r3.x;
    r2.z = abs(r2.z) + r2.w;
    r2.y = r2.y + r4.x;
    bool isHorizontal = r3.x >= r2.z;
    r2.y = r3.w * 2 + r2.y;
    r1.xz = isHorizontal ? r1.xz : r1.yw;
    r1.y = isHorizontal ? cb0[136].w : cb0[136].z;
    r1.w = r2.y * 0.0833333358 + -r0.w;
    r2.yw = r1.zx + -r0.ww;
    r1.xz = r1.xz + r0.ww;
    bool is1Steepest = abs(r2.y) >= abs(r2.w);
    r2.y = max(abs(r2.y), abs(r2.w));
    r1.y = is1Steepest ? -r1.y : r1.y;
    r1.w = saturate(abs(r1.w) * r2.x);
    r2.x = isHorizontal ? cb0[136].z : 0;
    r2.w = isHorizontal ? 0 : cb0[136].w;
    r3.yz = r1.yy * float2(0.5,0.5) + v1.xy;
    r3.y = isHorizontal ? v1.x : r3.y;
    r3.z = isHorizontal ? r3.z : v1.y;
    r4.xy = r3.yz + -r2.xw;
    r5.xy = r3.yz + r2.xw;
    r3.y = r1.w * -2 + 3;
    r6.xyz = t0.SampleLevel(s0_s, r4.xy, 0).xyz;
    r3.z = renodx::color::y::from::NTSC1953(saturate(r6.xyz));
    r1.w = r1.w * r1.w;
    r6.xyz = t0.SampleLevel(s0_s, r5.xy, 0).xyz;
    r3.w = renodx::color::y::from::NTSC1953(saturate(r6.xyz));
    r1.x = is1Steepest ? r1.z : r1.x;
    r1.z = 0.25 * r2.y;
    r0.w = -r1.x * 0.5 + r0.w;
    r1.w = r3.y * r1.w;
    bool isLumaCenterSmaller = r0.w < 0;
    r3.x = -r1.x * 0.5 + r3.z;
    r3.y = -r1.x * 0.5 + r3.w;
    bool reached1 = abs(r3.x) >= r1.z;
    bool reached2 = abs(r3.y) >= r1.z;
    r2.y = -r2.x * 1.5 + r4.x;
    r4.x = reached1 ? r4.x : r2.y;
    r2.y = -r2.w * 1.5 + r4.y;
    r4.z = reached1 ? r4.y : r2.y;
    bool notReachedBoth = !reached1 || !reached2;
    r4.y = r2.x * 1.5 + r5.x;
    r4.y = reached2 ? r5.x : r4.y;
    r5.x = r2.w * 1.5 + r5.y;
    r4.w = reached2 ? r5.y : r5.x;
    if (notReachedBoth) {
      if (!reached1) {
        r5.xyz = t0.SampleLevel(s0_s, r4.xz, 0).xyz;
        r3.x = renodx::color::y::from::NTSC1953(saturate(r5.xyz));
      }
      if (!reached2) {
        r5.xyz = t0.SampleLevel(s0_s, r4.yw, 0).xyz;
        r3.y = renodx::color::y::from::NTSC1953(saturate(r5.xyz));
      }
      r2.y = -r1.x * 0.5 + r3.x;
      r3.x = reached1 ? r3.x : r2.y;
      r2.y = -r1.x * 0.5 + r3.y;
      r3.y = reached2 ? r3.y : r2.y;
      reached1 = abs(r3.x) >= r1.z;
      reached2 = abs(r3.y) >= r1.z;
      r2.y = -r2.x * 2 + r4.x;
      r4.x = reached1 ? r4.x : r2.y;
      r2.y = -r2.w * 2 + r4.z;
      r4.z = reached1 ? r4.z : r2.y;
      notReachedBoth = !reached1 || !reached2;
      r5.x = r2.x * 2 + r4.y;
      r4.y = reached2 ? r4.y : r5.x;
      r5.x = r2.w * 2 + r4.w;
      r4.w = reached2 ? r4.w : r5.x;
      if (notReachedBoth) {
        if (!reached1) {
          r5.xyz = t0.SampleLevel(s0_s, r4.xz, 0).xyz;
          r3.x = renodx::color::y::from::NTSC1953(saturate(r5.xyz));
        }
        if (!reached2) {
          r5.xyz = t0.SampleLevel(s0_s, r4.yw, 0).xyz;
          r3.y = renodx::color::y::from::NTSC1953(saturate(r5.xyz));
        }
        r2.y = -r1.x * 0.5 + r3.x;
        r3.x = reached1 ? r3.x : r2.y;
        r2.y = -r1.x * 0.5 + r3.y;
        r3.y = reached2 ? r3.y : r2.y;
        reached1 = abs(r3.x) >= r1.z;
        reached2 = abs(r3.y) >= r1.z;
        r2.y = -r2.x * 4 + r4.x;
        r4.x = reached1 ? r4.x : r2.y;
        r2.y = -r2.w * 4 + r4.z;
        r4.z = reached1 ? r4.z : r2.y;
        notReachedBoth = !reached1 || !reached2;
        r5.x = r2.x * 4 + r4.y;
        r4.y = reached2 ? r4.y : r5.x;
        r5.x = r2.w * 4 + r4.w;
        r4.w = reached2 ? r4.w : r5.x;
        if (notReachedBoth) {
          if (!reached1) {
            r5.xyz = t0.SampleLevel(s0_s, r4.xz, 0).xyz;
            r3.x = renodx::color::y::from::NTSC1953(saturate(r5.xyz));
          }
          if (!reached2) {
            r5.xyz = t0.SampleLevel(s0_s, r4.yw, 0).xyz;
            r3.y = renodx::color::y::from::NTSC1953(saturate(r5.xyz));
          }
          r2.y = -r1.x * 0.5 + r3.x;
          r3.x = reached1 ? r3.x : r2.y;
          r1.x = -r1.x * 0.5 + r3.y;
          r3.y = reached2 ? r3.y : r1.x;
          reached1 = abs(r3.x) >= r1.z;
          reached2 = abs(r3.y) >= r1.z;
          r2.y = -r2.x * 12 + r4.x;
          r4.x = reached1 ? r4.x : r2.y;
          r2.y = -r2.w * 12 + r4.z;
          r4.z = reached1 ? r4.z : r2.y;
          r1.x = r2.x * 12 + r4.y;
          r4.y = reached2 ? r4.y : r1.x;
          r1.x = r2.w * 12 + r4.w;
          r4.w = reached2 ? r4.w : r1.x;
        }
      }
    }
    r1.x = v1.x + -r4.x;
    r1.z = -v1.x + r4.y;
    r2.x = v1.y + -r4.z;
    r1.x = isHorizontal ? r1.x : r2.x;
    r2.x = -v1.y + r4.w;
    r1.z = isHorizontal ? r1.z : r2.x;
    bool correctVariation1 = (r3.x < 0.0);
    bool correctVariation2 = (r3.y < 0.0);
    r2.w = r1.z + r1.x;
    correctVariation1 = correctVariation1 != isLumaCenterSmaller;
    correctVariation2 = correctVariation2 != isLumaCenterSmaller;
    r0.w = 1 / r2.w;
    bool isDirection1 = r1.x < r1.z;
    r1.x = min(r1.x, r1.z);
    bool correctVariation = isDirection1 ? correctVariation1 : correctVariation2;
    r1.w = r1.w * r1.w;
    r0.w = r1.x * -r0.w + 0.5;
    r1.x = 0.649999976 * r1.w;
    r0.w = correctVariation ? r0.w : 0.0;
    r0.w = max(r0.w, r1.x);
    r1.xy = r0.ww * r1.yy + v1.xy;
    r2.x = isHorizontal ? v1.x : r1.x;
    r2.y = isHorizontal ? r1.y : v1.y;
    r0.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  }
  r1.xy = v1.xy * cb0[139].xy + cb0[139].zw;
  r0.w = t1.SampleBias(s1_s, r1.xy, cb0[4].x).w;
  r0.w = r0.w * 2 + -1;
  r1.x = r0.w >= 0 ? 1 : -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}