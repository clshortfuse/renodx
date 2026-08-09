#include "../../../shaders/renodx.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[137];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
  r1.x = renodx::color::y::from::NTSC1953(saturate(r0.xyz));
  r2.xyzw = cb0[136].zwzw * float4(0,1,1,0) + v1.xyxy;
  r3.xyzw = t0.SampleLevel(s1_s, r2.xy, 0).xyzw;
  r1.y = renodx::color::y::from::NTSC1953(saturate(r3.xyz));
  r2.xyzw = t0.SampleLevel(s1_s, r2.zw, 0).xyzw;
  r1.z = renodx::color::y::from::NTSC1953(saturate(r2.xyz));
  r2.xyzw = cb0[136].zwzw * float4(0,-1,-1,0) + v1.xyxy;
  r3.xyzw = t0.SampleLevel(s1_s, r2.xy, 0).xyzw;
  r1.w = renodx::color::y::from::NTSC1953(saturate(r3.xyz));
  r2.xyzw = t0.SampleLevel(s1_s, r2.zw, 0).xyzw;
  r2.x = renodx::color::y::from::NTSC1953(saturate(r2.xyz));
  r2.y = max(r1.y, r1.x);
  r2.z = min(r1.y, r1.x);
  r2.z = min(r2.z, r1.z);
  r2.yw = max(r2.yx, r1.zw);
  r3.x = min(r2.x, r1.w);
  r2.y = max(r2.w, r2.y);
  r2.z = min(r3.x, r2.z);
  r2.w = 0.15 * r2.y;
  r2.y = r2.y + -r2.z;
  r2.z = max(0.0299999993, r2.w);
  if (r2.y >= r2.z) {
    r2.zw = -cb0[136].zw + v1.xy;
    r3.xyzw = t0.SampleLevel(s1_s, r2.zw, 0).xyzw;
    r2.z = renodx::color::y::from::NTSC1953(saturate(r3.xyz));
    r3.xy = cb0[136].zw + v1.xy;
    r3.xyzw = t0.SampleLevel(s1_s, r3.xy, 0).xyzw;
    r2.w = renodx::color::y::from::NTSC1953(saturate(r3.xyz));
    r3.xyzw = cb0[136].zwzw * float4(1,-1,-1,1) + v1.xyxy;
    r4.xyzw = t0.SampleLevel(s1_s, r3.xy, 0).xyzw;
    r3.x = renodx::color::y::from::NTSC1953(saturate(r4.xyz));
    r4.xyzw = t0.SampleLevel(s1_s, r3.zw, 0).xyzw;
    r3.y = renodx::color::y::from::NTSC1953(saturate(r4.xyz));
    r3.z = r1.w + r1.y;
    r3.w = r2.x + r1.z;
    r2.y = 1 / r2.y;
    r4.x = r3.z + r3.w;
    r3.z = r1.x * -2 + r3.z;
    r3.w = r1.x * -2 + r3.w;
    r4.y = r3.x + r2.w;
    r3.x = r3.x + r2.z;
    r4.z = r1.z * -2 + r4.y;
    r3.x = r1.w * -2 + r3.x;
    r2.z = r3.y + r2.z;
    r2.w = r3.y + r2.w;
    r3.y = abs(r3.z) * 2 + abs(r4.z);
    r3.x = abs(r3.w) * 2 + abs(r3.x);
    r3.z = r2.x * -2 + r2.z;
    r2.w = r1.y * -2 + r2.w;
    r3.y = abs(r3.z) + r3.y;
    r2.w = abs(r2.w) + r3.x;
    r2.z = r2.z + r4.y;
    bool isHorizontal = r3.y >= r2.w;
    r2.z = r4.x * 2 + r2.z;
    r1.w = isHorizontal ? r1.w : r2.x;
    r1.y = isHorizontal ? r1.y : r1.z;
    r1.z = isHorizontal ? cb0[136].w : cb0[136].z;
    r2.x = r2.z * 0.0833333358 + -r1.x;
    r2.z = r1.w + -r1.x;
    r3.x = r1.y + -r1.x;
    r1.yw = r1.yw + r1.xx;
    bool is1Steepest = abs(r2.z) >= abs(r3.x);
    r2.z = max(abs(r3.x), abs(r2.z));
    r1.z = is1Steepest ? -r1.z : r1.z;
    r2.x = saturate(abs(r2.x) * r2.y);
    r2.y = isHorizontal ? cb0[136].z : 0;
    r3.x = isHorizontal ? 0 : cb0[136].w;
    r3.zw = r1.zz * float2(0.5,0.5) + v1.xy;
    r3.z = isHorizontal ? v1.x : r3.z;
    r3.w = isHorizontal ? r3.w : v1.y;
    r4.x = r3.z + -r2.y;
    r4.y = r3.w + -r3.x;
    r5.x = r3.z + r2.y;
    r5.y = r3.w + r3.x;
    r3.z = r2.x * -2 + 3;
    r6.xyzw = t0.SampleLevel(s1_s, r4.xy, 0).xyzw;
    r3.w = renodx::color::y::from::NTSC1953(saturate(r6.xyz));
    r2.x = r2.x * r2.x;
    r6.xyzw = t0.SampleLevel(s1_s, r5.xy, 0).xyzw;
    r4.z = renodx::color::y::from::NTSC1953(saturate(r6.xyz));
    r1.y = is1Steepest ? r1.w : r1.y;
    r1.w = 0.25 * r2.z;
    r1.x = -r1.y * 0.5 + r1.x;
    r2.x = r3.z * r2.x;
    bool isLumaCenterSmaller = r1.x < 0;
    r3.y = -r1.y * 0.5 + r3.w;
    r3.z = -r1.y * 0.5 + r4.z;
    bool reached1 = abs(r3.y) >= r1.w;
    bool reached2 = abs(r3.z) >= r1.w;
    r2.z = -r2.y * 1.5 + r4.x;
    r5.z = reached1 ? r4.x : r2.z;
    r2.z = -r3.x * 1.5 + r4.y;
    r5.w = reached1 ? r4.y : r2.z;
    bool notReachedBoth = !reached1 || !reached2;
    r3.w = r2.y * 1.5 + r5.x;
    r4.x = reached1 ? r5.x : r3.w;
    r3.w = r3.x * 1.5 + r5.y;
    r4.y = reached1 ? r5.y : r3.w;
    if (notReachedBoth) {
      if (!reached1) {
        r6.xyzw = t0.SampleLevel(s1_s, r5.zw, 0).xyzw;
        r3.y = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
      }
      if (!reached2) {
        r6.xyzw = t0.SampleLevel(s1_s, r4.xy, 0).xyzw;
        r3.z = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
      }
      r2.z = -r1.y * 0.5 + r3.y;
      r3.y = reached1 ? r3.y : r2.z;
      r2.z = -r1.y * 0.5 + r3.z;
      r3.z = reached1 ? r3.z : r2.z;
      reached1 = abs(r3.y) >= r1.w;
      reached2 = abs(r3.z) >= r1.w;
      r2.z = -r2.y * 2 + r5.z;
      r5.z = reached1 ? r5.z : r2.z;
      r2.z = -r3.x * 2 + r5.w;
      r5.w = reached1 ? r5.w : r2.z;
      bool notReachedBoth = !reached1 || !reached2;
      r3.w = r2.y * 2 + r4.x;
      r4.x = reached1 ? r4.x : r3.w;
      r3.w = r3.x * 2 + r4.y;
      r4.y = reached1 ? r4.y : r3.w;
      if (notReachedBoth) {
        if (!reached1) {
          r6.xyzw = t0.SampleLevel(s1_s, r5.zw, 0).xyzw;
          r3.y = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
        }
        if (!reached2) {
          r6.xyzw = t0.SampleLevel(s1_s, r4.xy, 0).xyzw;
          r3.z = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
        }
        r2.z = -r1.y * 0.5 + r3.y;
        r3.y = reached1 ? r3.y : r2.z;
        r2.z = -r1.y * 0.5 + r3.z;
        r3.z = reached1 ? r3.z : r2.z;
        reached1 = abs(r3.y) >= r1.w;
        reached2 = abs(r3.z) >= r1.w;
        r2.z = -r2.y * 4 + r5.z;
        r5.z = reached1 ? r5.z : r2.z;
        r2.z = -r3.x * 4 + r5.w;
        r5.w = reached1 ? r5.w : r2.z;
        bool notReachedBoth = !reached1 || !reached2;
        r3.w = r2.y * 4 + r4.x;
        r4.x = reached1 ? r4.x : r3.w;
        r3.w = r3.x * 4 + r4.y;
        r4.y = reached1 ? r4.y : r3.w;
        if (notReachedBoth) {
          if (!reached1) {
            r6.xyzw = t0.SampleLevel(s1_s, r5.zw, 0).xyzw;
            r3.y = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
          }
          if (!reached2) {
            r6.xyzw = t0.SampleLevel(s1_s, r4.xy, 0).xyzw;
            r3.z = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
          }
          r2.z = -r1.y * 0.5 + r3.y;
          r3.y = reached1 ? r3.y : r2.z;
          r1.y = -r1.y * 0.5 + r3.z;
          r3.z = reached1 ? r3.z : r1.y;
          reached1 = abs(r3.y) >= r1.w;
          reached2 = abs(r3.z) >= r1.w;
          r2.z = -r2.y * 12 + r5.z;
          r5.z = reached1 ? r5.z : r2.z;
          r2.z = -r3.x * 12 + r5.w;
          r5.w = reached1 ? r5.w : r2.z;
          r1.y = r2.y * 12 + r4.x;
          r4.x = reached2 ? r4.x : r1.y;
          r1.y = r3.x * 12 + r4.y;
          r4.y = reached2 ? r4.y : r1.y;
        }
      }
    }
    r1.y = v1.x + -r5.z;
    r1.w = -v1.x + r4.x;
    r2.y = v1.y + -r5.w;
    r1.y = isHorizontal ? r1.y : r2.y;
    r2.y = -v1.y + r4.y;
    r1.w = isHorizontal ? r1.w : r2.y;
    bool correctVariation1 = (r3.y < 0.0);
    bool correctVariation2 = (r3.z < 0.0);
    r3.x = r1.w + r1.y;
    correctVariation1 = correctVariation1 != isLumaCenterSmaller;
    correctVariation2 = correctVariation2 != isLumaCenterSmaller;
    r1.x = 1 / r3.x;
    bool isDirection1 = r1.y < r1.w;
    r1.y = min(r1.y, r1.w);
    bool correctVariation = isDirection1 ? correctVariation1 : correctVariation2;
    r2.x = r2.x * r2.x;
    r1.x = r1.y * -r1.x + 0.5;
    r1.y = 0.649999976 * r2.x;
    r1.x = correctVariation ? r1.x : 0.0;
    r1.x = max(r1.x, r1.y);
    r1.xy = r1.xx * r1.zz + v1.xy;
    r2.x = isHorizontal ? v1.x : r1.x;
    r2.y = isHorizontal ? r1.y : v1.y;
    r0.xyzw = t0.SampleLevel(s1_s, r2.xy, 0).xyzw;
  }
  o0.xyz = renodx::math::SignSqrt(r0.xyz);
  o0.w = 1;
  return;
}