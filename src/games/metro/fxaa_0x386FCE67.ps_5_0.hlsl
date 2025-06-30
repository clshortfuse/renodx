#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Fri May 09 10:21:03 2025

cbuffer cb_screen : register(b2)
{
  float4 rtdim : packoffset(c0);
  float4 depth_xform : packoffset(c1);
  float4 envmap_color : packoffset(c2);
  float4 sph_r[3] : packoffset(c3);
  float4 sph_g[3] : packoffset(c6);
  float4 sph_b[3] : packoffset(c9);
}

cbuffer cb_misc_1 : register(b4)
{
  float4 eye_position : packoffset(c0);
  float4 timers : packoffset(c1);
  float4 clipplanes[6] : packoffset(c2);
}

SamplerState s_clamp_bi_s : register(s6);
Texture2D<float4> t_ssao : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float3 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = rtdim.xy * v0.xy;
  r1.xyzw = t_ssao.SampleLevel(s_clamp_bi_s, r0.xy, 0).xyzw;

  float4 aliased_color = r1.rgba;

  // r2.xyz = t_ssao.Gather(s_clamp_bi_s, r0.xy).xyz;
  // r3.xyz = t_ssao.Gather(s_clamp_bi_s, r0.xy, int2(-1, -1)).xzw;
  // r0.z = max(r2.x, r1.w);
  // r0.w = min(r2.x, r1.w);
  // r0.z = max(r2.z, r0.z);
  // r0.w = min(r2.z, r0.w);
  // r2.w = max(r3.y, r3.x);
  // r3.w = min(r3.y, r3.x);
  // r0.z = max(r2.w, r0.z);
  // r0.w = min(r3.w, r0.w);
  // r2.w = 0.166 * r0.z;
  // r0.z = r0.z + -r0.w;
  // r0.w = max(0.0833, r2.w);
  // //r0.w = cmp(r0.z >= r0.w);
  // //if (r0.w != 0) {
  // if (r0.z >= r0.w) {
  //   r0.w = t_ssao.SampleLevel(s_clamp_bi_s, r0.xy, 0, int2(1, -1)).w;
  //   r2.w = t_ssao.SampleLevel(s_clamp_bi_s, r0.xy, 0, int2(-1, 1)).w;
  //   r4.xy = r3.yx + r2.xz;
  //   r0.z = 1 / r0.z;
  //   r3.w = r4.x + r4.y;
  //   r4.xy = r1.ww * float2(-2,-2) + r4.xy;
  //   r4.z = r0.w + r2.y;
  //   r0.w = r3.z + r0.w;
  //   r4.w = r2.z * -2 + r4.z;
  //   r0.w = r3.y * -2 + r0.w;
  //   r3.z = r3.z + r2.w;
  //   r2.y = r2.w + r2.y;
  //   r2.w = abs(r4.x) * 2 + abs(r4.w);
  //   r0.w = abs(r4.y) * 2 + abs(r0.w);
  //   r4.x = r3.x * -2 + r3.z;
  //   r2.y = r2.x * -2 + r2.y;
  //   r2.w = abs(r4.x) + r2.w;
  //   r0.w = abs(r2.y) + r0.w;
  //   r2.y = r3.z + r4.z;
  //   //r0.w = cmp(r2.w >= r0.w);
  //   bool isHorizontal = (r2.w >= r0.w);
  //   r2.y = r3.w * 2 + r2.y;
  //   //r2.w = r0.w ? r3.y : r3.x;
  //   r2.w = isHorizontal ? r3.y : r3.x;
  //   //r2.x = r0.w ? r2.x : r2.z;
  //   r2.x = isHorizontal ? r2.x : r2.z;
  //   //r2.z = r0.w ? rtdim.y : rtdim.x;
  //   r2.z = isHorizontal ? rtdim.y : rtdim.x;
  //   r2.y = r2.y * (1 / 12.0) + -r1.w;
  //   r3.xy = r2.wx + -r1.ww;
  //   r2.xw = r2.xw + r1.ww;
  //   //r3.z = cmp(abs(r3.x) >= abs(r3.y));
  //   bool is1Steepest = abs(r3.x) >= abs(r3.y);
  //   r3.x = max(abs(r3.x), abs(r3.y));
  //   //r2.z = r3.z ? -r2.z : r2.z;
  //   r2.z = is1Steepest ? -r2.z : r2.z;
  //   r0.z = saturate(abs(r2.y) * r0.z);
  //   //r2.y = r0.w ? rtdim.x : 0;
  //   r2.y = isHorizontal ? rtdim.x : 0;
  //   //r3.y = r0.w ? 0 : rtdim.y;
  //   r3.y = isHorizontal ? 0 : rtdim.y;
  //   r4.xy = r2.zz * float2(0.5,0.5) + r0.xy;
  //   //r3.w = r0.w ? r0.x : r4.x;
  //   r3.w = isHorizontal ? r0.x : r4.x;
  //   //r4.x = r0.w ? r4.y : r0.y;
  //   r4.x = isHorizontal ? r4.y : r0.y;
  //   r5.x = r3.w + -r2.y;
  //   r5.y = r4.x + -r3.y;
  //   r6.x = r3.w + r2.y;
  //   r6.y = r4.x + r3.y;
  //   r3.w = r0.z * -2 + 3;
  //   r4.x = t_ssao.SampleLevel(s_clamp_bi_s, r5.xy, 0).w;
  //   r0.z = r0.z * r0.z;
  //   r4.y = t_ssao.SampleLevel(s_clamp_bi_s, r6.xy, 0).w;
  //   //r2.x = r3.z ? r2.w : r2.x;
  //   r2.x = is1Steepest ? r2.w : r2.x;
  //   r2.w = 0.25 * r3.x;
  //   r3.x = -r2.x * 0.5 + r1.w;
  //   r0.z = r3.w * r0.z;
  //   //r3.x = cmp(r3.x < 0);
  //   bool isLumaCenterSmaller = r3.x < 0;
  //   r3.z = -r2.x * 0.5 + r4.x;
  //   r3.w = -r2.x * 0.5 + r4.y;
  //   //r4.xy = cmp(abs(r3.zw) >= r2.ww);
  //   bool reached1 = abs(r3.z) >= r2.w;
  //   bool reached2 = abs(r3.w) >= r2.w;
  //   r4.z = -r2.y * 1.5 + r5.x;
  //   //r4.z = r4.x ? r5.x : r4.z;
  //   r4.z = reached1 ? r5.x : r4.z;
  //   r5.x = -r3.y * 1.5 + r5.y;
  //   //r4.w = r4.x ? r5.y : r5.x;
  //   r4.w = reached1 ? r5.y : r5.x;
  //   //r5.xy = ~(int2)r4.xy;
  //   //r5.x = (int)r5.y | (int)r5.x;
  //   bool reachedBoth = reached1 && reached2;
  //   r5.y = r2.y * 1.5 + r6.x;
  //   r5.w = r3.y * 1.5 + r6.y;
  //   //r5.yz = r4.yy ? r6.xy : r5.yw;
  //   r5.yz = reached2 ? r6.xy : r5.yw;
  //   //if (r5.x != 0) {
  //   if (reachedBoth) {
  //     //if (r4.x == 0) {
  //     if (!reached1) {
  //       r3.z = t_ssao.SampleLevel(s_clamp_bi_s, r4.zw, 0).w;
  //     }
  //     //if (r4.y == 0) {
  //     if (!reached2) {
  //       r3.w = t_ssao.SampleLevel(s_clamp_bi_s, r5.yz, 0).w;
  //     }
  //     r5.x = -r2.x * 0.5 + r3.z;
  //     //r3.z = r4.x ? r3.z : r5.x;
  //     r3.z = reached1 ? r3.z : r5.x;
  //     r4.x = -r2.x * 0.5 + r3.w;
  //     //r3.w = r4.y ? r3.w : r4.x;
  //     r3.w = reached2 ? r3.w : r4.x;
  //     //r4.xy = cmp(abs(r3.zw) >= r2.ww);
  //     reached1 = abs(r3.z) >= r2.w;
  //     reached2 = abs(r3.w) >= r2.w;
  //     r5.x = -r2.y * 2 + r4.z;
  //     //r4.z = r4.x ? r4.z : r5.x;
  //     r4.z = reached1 ? r4.z : r5.x;
  //     r5.x = -r3.y * 2 + r4.w;
  //     //r4.w = r4.x ? r4.w : r5.x;
  //     r4.w = reached1 ? r4.w : r5.x;
  //     //r5.xw = ~(int2)r4.xy;
  //     //r5.x = (int)r5.w | (int)r5.x;
  //     reachedBoth = reached1 && reached2;
  //     r5.w = r2.y * 2 + r5.y;
  //     //r5.y = r4.y ? r5.y : r5.w;
  //     r5.y = reached2 ? r5.y : r5.w;
  //     r5.w = r3.y * 2 + r5.z;
  //     //r5.z = r4.y ? r5.z : r5.w;
  //     r5.z = reached2 ? r5.z : r5.w;
  //     //if (r5.x != 0) {
  //     if (reachedBoth) {
  //       //if (r4.x == 0) {
  //       if (!reached1) {
  //         r3.z = t_ssao.SampleLevel(s_clamp_bi_s, r4.zw, 0).w;
  //       }
  //       //if (r4.y == 0) {
  //       if (!reached2) {
  //         r3.w = t_ssao.SampleLevel(s_clamp_bi_s, r5.yz, 0).w;
  //       }
  //       r5.x = -r2.x * 0.5 + r3.z;
  //       //r3.z = r4.x ? r3.z : r5.x;
  //       r3.z = reached1 ? r3.z : r5.x;
  //       r4.x = -r2.x * 0.5 + r3.w;
  //       //r3.w = r4.y ? r3.w : r4.x;
  //       r3.w = reached2 ? r3.w : r4.x;
  //       //r4.xy = cmp(abs(r3.zw) >= r2.ww);
  //       reached1 = abs(r3.z) >= r2.w;
  //       reached2 = abs(r3.w) >= r2.w;
  //       r5.x = -r2.y * 2 + r4.z;
  //       //r4.z = r4.x ? r4.z : r5.x;
  //       r4.z = reached1 ? r4.z : r5.x;
  //       r5.x = -r3.y * 2 + r4.w;
  //       //r4.w = r4.x ? r4.w : r5.x;
  //       r4.w = reached1 ? r4.w : r5.x;
  //       //r5.xw = ~(int2)r4.xy;
  //       //r5.x = (int)r5.w | (int)r5.x;
  //       reachedBoth = reached1 && reached2;
  //       r5.w = r2.y * 2 + r5.y;
  //       //r5.y = r4.y ? r5.y : r5.w;
  //       r5.y = reached2 ? r5.y : r5.w;
  //       r5.w = r3.y * 2 + r5.z;
  //       //r5.z = r4.y ? r5.z : r5.w;
  //       r5.z = reached2 ? r5.z : r5.w;
  //       //if (r5.x != 0) {
  //       if (reachedBoth) {
  //         //if (r4.x == 0) {
  //         if (!reached1) {
  //           r3.z = t_ssao.SampleLevel(s_clamp_bi_s, r4.zw, 0).w;
  //         }
  //         //if (r4.y == 0) {
  //         if (!reached2) {
  //           r3.w = t_ssao.SampleLevel(s_clamp_bi_s, r5.yz, 0).w;
  //         }
  //         r5.x = -r2.x * 0.5 + r3.z;
  //         //r3.z = r4.x ? r3.z : r5.x;
  //         r3.z = reached1 ? r3.z : r5.x;
  //         r4.x = -r2.x * 0.5 + r3.w;
  //         //r3.w = r4.y ? r3.w : r4.x;
  //         r3.w = reached2 ? r3.w : r4.x;
  //         //r4.xy = cmp(abs(r3.zw) >= r2.ww);
  //         reached1 = abs(r3.z) >= r2.w;
  //         reached2 = abs(r3.w) >= r2.w;
  //         r5.x = -r2.y * 4 + r4.z;
  //         //r4.z = r4.x ? r4.z : r5.x;
  //         r4.z = reached1 ? r4.z : r5.x;
  //         r5.x = -r3.y * 4 + r4.w;
  //         //r4.w = r4.x ? r4.w : r5.x;
  //         r4.w = reached1 ? r4.w : r5.x;
  //         //r5.xw = ~(int2)r4.xy;
  //         //r5.x = (int)r5.w | (int)r5.x;
  //         reachedBoth = reached1 && reached2;
  //         r5.w = r2.y * 4 + r5.y;
  //         //r5.y = r4.y ? r5.y : r5.w;
  //         r5.y = reached2 ? r5.y : r5.w;
  //         r5.w = r3.y * 4 + r5.z;
  //         //r5.z = r4.y ? r5.z : r5.w;
  //         r5.z = reached2 ? r5.z : r5.w;
  //         //if (r5.x != 0) {
  //         if (reachedBoth) {
  //           //if (r4.x == 0) {
  //           if (!reached1) {
  //             r3.z = t_ssao.SampleLevel(s_clamp_bi_s, r4.zw, 0).w;
  //           }
  //           //if (r4.y == 0) {
  //           if (!reached2) {
  //             r3.w = t_ssao.SampleLevel(s_clamp_bi_s, r5.yz, 0).w;
  //           }
  //           r5.x = -r2.x * 0.5 + r3.z;
  //           //r3.z = r4.x ? r3.z : r5.x;
  //           r3.z = reached1 ? r3.z : r5.x;
  //           r2.x = -r2.x * 0.5 + r3.w;
  //           //r3.w = r4.y ? r3.w : r2.x;
  //           r3.w = reached2 ? r3.w : r2.x;
  //           //r2.xw = cmp(abs(r3.zw) >= r2.ww);
  //           reached1 = abs(r3.z) >= r2.w;
  //           reached2 = abs(r3.w) >= r2.w;
  //           r4.x = -r2.y * 12 + r4.z;
  //           //r4.z = r2.x ? r4.z : r4.x;
  //           r4.z = reached1 ? r4.z : r4.x;
  //           r4.x = -r3.y * 12 + r4.w;
  //           //r4.w = r2.x ? r4.w : r4.x;
  //           r4.w = reached1 ? r4.w : r4.x;
  //           r2.x = r2.y * 12 + r5.y;
  //           //r5.y = r2.w ? r5.y : r2.x;
  //           r5.y = reached2 ? r5.y : r2.x;
  //           r2.x = r3.y * 12 + r5.z;
  //           //r5.z = r2.w ? r5.z : r2.x;
  //           r5.z = reached2 ? r5.z : r2.x;
  //         }
  //       }
  //     }
  //   }
  //   r2.x = v0.x * rtdim.x + -r4.z;
  //   r2.y = -v0.x * rtdim.x + r5.y;
  //   r2.w = v0.y * rtdim.y + -r4.w;
  //   //r2.x = r0.w ? r2.x : r2.w;
  //   r2.x = isHorizontal ? r2.x : r2.w;
  //   r2.w = -v0.y * rtdim.y + r5.z;
  //   //r2.y = r0.w ? r2.y : r2.w;
  //   r2.y = isHorizontal ? r2.y : r2.w;
  //   //r3.yz = cmp(r3.zw < float2(0,0));
  //   r2.w = r2.y + r2.x;
  //   //r3.xy = cmp((int2)r3.xx != (int2)r3.yz);
  //   bool correctVariation1 = (r3.z < 0.f) != isLumaCenterSmaller;
  //   bool correctVariation2 = (r3.w < 0.f) != isLumaCenterSmaller;
  //   r2.w = 1 / r2.w;
  //   //r3.z = cmp(r2.x < r2.y);
  //   bool isDirection1 = r2.x < r2.y;
  //   r2.x = min(r2.x, r2.y);
  //   //r2.y = r3.z ? r3.x : r3.y;
  //   bool correctVariation = isDirection1 ? correctVariation1 : correctVariation2;
  //   r0.z = r0.z * r0.z;
  //   r2.x = r2.x * -r2.w + 0.5;
  //   r0.z = 0.75 * r0.z;
  //   //r2.x = (int)r2.x & (int)r2.y;
  //   r2.x = correctVariation ? r2.x : 0.f;
  //   r0.z = max(r2.x, r0.z);
  //   r2.xy = r0.zz * r2.zz + r0.xy;
  //   //r3.x = r0.w ? r0.x : r2.x;
  //   r3.x = isHorizontal ? r0.x : r2.x;
  //   //r3.y = r0.w ? r2.y : r0.y;
  //   r3.y = isHorizontal ? r2.y : r0.y;
  //   r1.xyz = t_ssao.SampleLevel(s_clamp_bi_s, r3.xy, 0).xyz;
  // }
  // // r0.xy = v0.xy * rtdim.xy + timers.ww;
  // // r0.x = dot(r0.xy, float2(12.9898005,78.2330017));
  // // r0.x = sin(r0.x);
  // // r0.x = 43758.5469 * r0.x;
  // // r0.x = frac(r0.x);
  // // r0.yzw = sqrt(r1.xyz);
  // // r0.x = -0.5 + r0.x;
  // // r0.xyz = r0.xxx * float3(0.0166664999,0.0166664999,0.0166664999) + r0.yzw;
  // // o0.xyz = r0.xyz * r0.xyz;
  // o0.w = r1.w;
  // o0.rgb = r1.rgb;

  // o0.rgb = CustomSwapChainPass(o0.rgb);
  o0.w = aliased_color.w;
  o0.rgb = CustomSwapChainPass(aliased_color.rgb);
  return;
}