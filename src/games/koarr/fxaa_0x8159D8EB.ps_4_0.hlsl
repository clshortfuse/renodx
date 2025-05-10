#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(0, -1)).xyzw;
  r1.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(-1, 0)).xyzw;
  r2 = applySharpen(t0, s0_s, v1, injectedData.fxSharpen);
  r3.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(1, 0)).xyzw;
  r4.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(0, 1)).xyzw;
  r0.x = min(r1.w, r0.w);
  r0.y = min(r4.w, r3.w);
  r0.x = min(r0.x, r0.y);
  r0.x = min(r2.w, r0.x);
  r0.y = max(r1.w, r0.w);
  r0.z = max(r4.w, r3.w);
  r0.y = max(r0.y, r0.z);
  r0.y = max(r2.w, r0.y);
  r0.x = r0.y + -r0.x;
  r0.y = (1.0 / 6.0) * r0.y;
  r0.y = max((1 / 12.0), r0.y);
  if (r0.x >= r0.y) {
    r5.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(-1, -1)).xyzw;
    r6.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(1, -1)).xyzw;
    r7.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(-1, 1)).xyzw;
    r8.xyzw = t0.SampleLevel(s0_s, v1.xy, 0, int2(1, 1)).xyzw;
    r0.y = r1.w + r0.w;
    r0.y = r0.y + r3.w;
    r0.y = r0.y + r4.w;
    r0.z = r0.y * 0.25 + -r2.w;
    r0.x = abs(r0.z) / r0.x;
    r0.x = saturate(-0.25 + r0.x);
    r0.x = (1 / 0.75) * r0.x;
    r0.x = min(0.75, r0.x);
    r0.z = r0.w * -2 + r5.w;
    r0.z = r0.z + r6.w;
    r1.x = r2.w * -2 + r1.w;
    r1.x = r1.x + r3.w;
    r0.z = abs(r1.x) * 2 + abs(r0.z);
    r1.x = r4.w * -2 + r7.w;
    r1.x = r1.x + r8.w;
    r0.z = abs(r1.x) + r0.z;
    r1.x = r1.w * -2 + r5.w;
    r1.x = r1.x + r7.w;
    r1.y = r2.w * -2 + r0.w;
    r1.y = r1.y + r4.w;
    r1.x = abs(r1.y) * 2 + abs(r1.x);
    r1.y = r3.w * -2 + r6.w;
    r1.y = r1.y + r8.w;
    r1.x = r1.x + abs(r1.y);
    bool isHorizontal = r1.x >= r0.z;
    r1.x = isHorizontal ? -cb0[1].y : -cb0[1].x;
    r0.w = isHorizontal ? r0.w : r1.w;
    r1.y = isHorizontal ? r4.w : r3.w;
    r1.z = r0.w + -r2.w;
    r1.w = r1.y + -r2.w;
    r0.w = r0.w + r2.w;
    r0.w = 0.5 * r0.w;
    r1.y = r1.y + r2.w;
    r1.y = 0.5 * r1.y;
    bool is1Steepest = abs(r1.z) >= abs(r1.w);
    r0.w = is1Steepest ? r0.w : r1.y;
    r1.y = max(abs(r1.z), abs(r1.w));
    r1.x = is1Steepest ? r1.x : -r1.x;
    r1.yz = float2(0.25,0.5) * r1.yx;
    r1.w = isHorizontal ? 0 : r1.z;
    r1.z = isHorizontal ? r1.z : 0;
    r3.xy = v1.xy + r1.wz;
    r4.yz = float2(0,0);
    r4.xw = cb0[1].xy;
    r1.zw = isHorizontal ? r4.xy : r4.zw;
    r3.xyzw = r1.zwzw * float4(-1.5,-1.5,1.5,1.5) + r3.xyxy;
    r4.xyzw = r3.xyzw;
    r5.xy = float2(0,0);
    bool2 reached = (false, false);
    int i = 0;
    while (true) {
      if (i >= 6) break;
      r7.xyzw = t0.SampleLevel(s0_s, r4.xy, 0).xyzw;
      r8.xyzw = t0.SampleLevel(s0_s, r4.zw, 0).xyzw;
      r6.y = r7.w + -r0.w;
      r6.z = r8.w + -r0.w;
      bool reached1 = abs(r6.y) >= r1.y;
      bool reached2 = abs(r6.z) >= r1.y;
      bool temp = reached1 ? reached.x : false;
      r7.xy = r4.xy + r1.zw;
      r7.xy = temp ? r7.xy : r4.xy;
      temp = reached2 ? reached.y : false;
      r8.xy = r4.zw + -r1.zw;
      r8.xy = temp ? r8.xy : r4.zw;
      temp = reached2 ? reached1 : false;
      if (temp) {
        r4.xy = r7.xy;
        r4.zw = r8.xy;
        r5.x = r7.w;
        r5.y = r8.w;
        break;
      }
      r9.xy = -r1.zw * float2(2,2) + r7.xy;
      r4.xy = reached1 ? r7.xy : r9.xy;
      r7.xy = r1.zw * float2(2,2) + r8.xy;
      r4.zw = reached2 ? r8.xy : r7.xy;
      i = i + 1;
      reached = (reached1, reached2);
      r5.x = r7.w;
      r5.y = r8.w;
    }
    r1.yz = v1.xy + -r4.xy;
    r1.y = isHorizontal ? r1.y : r1.z;
    r1.zw = -v1.xy + r4.zw;
    r1.z = isHorizontal ? r1.z : r1.w;
    bool isDirection1 = r1.y < r1.z;
    r1.w = isDirection1 ? r5.x : r5.y;
    bool isLumaCenterSmaller = r2.w < r0.w;
    r0.w = r1.w + -r0.w;
    bool correctVariation = (r0.w < 0.0) == isLumaCenterSmaller;
    r0.w = correctVariation ? 0.0 : r1.x;
    r1.x = r1.z + r1.y;
    r1.y = min(r1.z, r1.y);
    r1.x = -1 / r1.x;
    r1.x = r1.y * r1.x + 0.5;
    r1.x = r0.x * 0.125 + r1.x;
    r0.w = r1.x * r0.w;
    r1.x = isHorizontal ? 0 : r0.w;
    r1.x = v1.x + r1.x;
    r0.z = isHorizontal ? r0.w : 0;
    r1.y = v1.y + r0.z;
    r1 = applySharpen(t0, s0_s, r1.xy, injectedData.fxSharpen);
    r0.z = renodx::color::y::from::BT709(r1.xyz);
    r0.z = 5.96046448e-08 + r0.z;
    r0.y = r0.y * 0.25 + -r0.z;
    r0.x = r0.x * r0.y + r0.z;
    r0.x = r0.x / r0.z;
    r0.x = min(4, r0.x);
    r2.xyz = r1.xyz * r0.xxx;
  }
  r2.rgb = renodx::color::srgb::DecodeSafe(r2.rgb);
  if (injectedData.fxFilmGrain > 0.f) {
    r2.rgb = applyFilmGrain(r2.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.xyz = PostToneMapScale(r2.xyz);
  o0.w = 1;
  return;
}