#include "shared.h"

// Pixel shader for Eternights game - Dodge effect
// Created with 3Dmigoto v1.4.1 on Sat Jun  7 05:50:16 2025

// Texture declarations
// These are the input textures used by the shader
Texture2D<float4> t7 : register(t7);  // Additional texture input
Texture2D<float4> t6 : register(t6);  // Additional texture input
Texture2D<float4> t5 : register(t5);  // Additional texture input
Texture2D<float4> t4 : register(t4);  // Additional texture input
Texture2D<float4> t3 : register(t3);  // Main texture input
Texture2D<float4> t2 : register(t2);  // Secondary texture input
Texture2D<float4> t1 : register(t1);  // Additional texture input
Texture2D<float4> t0 : register(t0);  // Additional texture input

// Sampler states for texture sampling
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

// Constant buffer containing shader parameters
cbuffer cb0 : register(b0)
{
  float4 cb0[41];  // Array of shader parameters
}

// 3Dmigoto declarations
#define cmp -

// Main pixel shader function
void main(
  float4 v0 : SV_POSITION0,    // Screen position
  float2 v1 : TEXCOORD0,      // Primary texture coordinates
  float2 w1 : TEXCOORD1,      // Secondary texture coordinates
  out float4 o0 : SV_Target0) // Output color
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Initial coordinate transformation and setup
  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[28].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[28].zz + -cb0[29].xy;
  r0.xy = cb0[29].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);

  // Conditional coordinate transformation based on cb0[28].w
  r1.y = cmp(0 < cb0[28].w);
  if (r1.y != 0) {
    // First transformation path using sincos
    r1.zw = cb0[28].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    // Second transformation path using polynomial approximation
    r2.x = 1 / r1.x;
    r2.x = cb0[28].x * r2.x;
    r1.x = cb0[28].y * r1.x;
    // Polynomial approximation for atan
    r2.y = min(1, abs(r1.x));
    r2.z = max(1, abs(r1.x));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r3.x = cmp(1 < abs(r1.x));
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = r3.x ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r1.x = min(1, r1.x);
    r1.x = cmp(r1.x < -r1.x);
    r1.x = r1.x ? -r2.y : r2.y;
    r1.x = r2.x * r1.x + -1;
    r1.zw = r0.xy * r1.xx + r0.zw;
  }

  // Initial texture sampling and coordinate setup
  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz;

  // Multi-tap sampling setup
  r2.xy = cb0[31].zw * -r0.yz;
  r2.xy = float2(0.5,0.5) * r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;

  // Initialize accumulation variables
  r2.yw = float2(0,0);
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r6.xy = v1.xy;
  r6.z = 0;

  // Main sampling loop
  while (true) {
    r6.w = cmp((int)r6.z >= (int)r0.w);
    if (r6.w != 0) break;
    
    // Calculate sampling coordinates
    r6.w = (int)r6.z;
    r6.w = 0.5 + r6.w;
    r2.x = r6.w / r1.x;
    r7.xy = float2(-0.5,-0.5) + r6.xy;
    r7.zw = r7.xy * cb0[28].zz + float2(0.5,0.5);
    r7.xy = r7.xy * cb0[28].zz + -cb0[29].xy;
    r7.xy = cb0[29].zw * r7.xy;
    r6.w = dot(r7.xy, r7.xy);
    r6.w = sqrt(r6.w);

    // Conditional coordinate transformation for sampling
    if (r1.y != 0) {
      // First transformation path
      r8.xy = cb0[28].xy * r6.ww;
      sincos(r8.x, r8.x, r9.x);
      r8.x = r8.x / r9.x;
      r8.y = 1 / r8.y;
      r8.x = r8.x * r8.y + -1;
      r8.xy = r7.xy * r8.xx + r7.zw;
    } else {
      // Second transformation path
      r8.z = 1 / r6.w;
      r8.z = cb0[28].x * r8.z;
      r6.w = cb0[28].y * r6.w;
      // Polynomial approximation for atan
      r8.w = min(1, abs(r6.w));
      r9.x = max(1, abs(r6.w));
      r9.x = 1 / r9.x;
      r8.w = r9.x * r8.w;
      r9.x = r8.w * r8.w;
      r9.y = r9.x * 0.0208350997 + -0.0851330012;
      r9.y = r9.x * r9.y + 0.180141002;
      r9.y = r9.x * r9.y + -0.330299497;
      r9.x = r9.x * r9.y + 0.999866009;
      r9.y = r9.x * r8.w;
      r9.z = cmp(1 < abs(r6.w));
      r9.y = r9.y * -2 + 1.57079637;
      r9.y = r9.z ? r9.y : 0;
      r8.w = r8.w * r9.x + r9.y;
      r6.w = min(1, r6.w);
      r6.w = cmp(r6.w < -r6.w);
      r6.w = r6.w ? -r8.w : r8.w;
      r6.w = r8.z * r6.w + -1;
      r8.xy = r7.xy * r6.ww + r7.zw;
    }

    // Sample textures and accumulate results
    r8.xy = saturate(r8.xy);
    r7.xy = cb0[26].xx * r8.xy;
    r7.xyzw = t1.SampleLevel(s1_s, r7.xy, 0).xyzw;
    r8.xyzw = t5.SampleLevel(s5_s, r2.xy, 0).xyzw;
    r3.xyz = r8.xyz;
    r4.xyzw = r7.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r6.xy = r6.xy + r0.yz;
    r6.z = (int)r6.z + 1;
  }

  // Final color processing
  r3.xyzw = r4.xyzw / r5.xyzw;
  r3.xyz = r3.xyz * r0.xxx;

  // Additional texture sampling and color blending
  r0.xyzw = float4(1,1,-1,0) * cb0[32].xyxy;
  r4.xyzw = saturate(-r0.xywy * cb0[34].xxxx + r1.zwzw);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r4.xyzw = r4.xyzw * float4(2,2,2,2) + r5.xyzw;

  // More sampling and accumulation
  r1.xy = saturate(-r0.zy * cb0[34].xx + r1.zw);
  r1.xy = cb0[26].xx * r1.xy;
  r5.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r4.xyzw = r5.xyzw + r4.xyzw;

  // Final color processing and output
  r5.xyzw = saturate(r0.zwxw * cb0[34].xxxx + r1.zwzw);
  r5.xyzw = cb0[26].xxxx * r5.xyzw;
  r6.xyzw = t3.Sample(s3_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw * float4(2,2,2,2) + r4.xyzw;
  r1.xy = saturate(r1.zw);
  r1.xy = cb0[26].xx * r1.xy;
  r6.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r4.xyzw = r6.xyzw * float4(4,4,4,4) + r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r5.zw).xyzw;
  r4.xyzw = r5.xyzw * float4(2,2,2,2) + r4.xyzw;

  // Final color grading and output
  r5.xyzw = saturate(r0.zywy * cb0[34].xxxx + r1.zwzw);
  r5.xyzw = cb0[26].xxxx * r5.xyzw;
  r6.xyzw = t3.Sample(s3_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw + r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r5.zw).xyzw;
  r4.xyzw = r5.xyzw * float4(2,2,2,2) + r4.xyzw;
  r0.xy = saturate(r0.xy * cb0[34].xx + r1.zw);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r0.xyzw = r4.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw;

  // Final color processing and output
  r1.xy = r1.zw * cb0[33].xy + cb0[33].zw;
  r4.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r5.xyz = float3(0.0625,0.0625,0.0625) * r0.xyz;
  r4.xyz = cb0[34].zzz * r4.xyz;
  r0.xyzw = float4(0.0625,0.0625,0.0625,1) * r0.xyzw;
  r6.xyz = cb0[35].xyz * r0.xyz;
  r6.w = 0.0625 * r0.w;
  r0.xyzw = r6.xyzw + r3.xyzw;
  r3.xyz = r4.xyz * r5.xyz;
  r3.w = 0;
  r0.xyzw = r3.xyzw + r0.xyzw;

  // Conditional color processing based on cb0[40].y
  r1.x = cmp(cb0[40].y < 0.5);
  if (r1.x != 0) {
    // First color processing path
    r1.xy = -cb0[38].xy + r1.zw;
    r3.yz = cb0[39].xx * abs(r1.yx);
    r1.x = cb0[22].x / cb0[22].y;
    r1.x = -1 + r1.x;
    r1.x = cb0[39].w * r1.x + 1;
    r3.x = r3.z * r1.x;
    r3.xy = saturate(r3.xy);
    r1.xy = log2(r3.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[39].y * r1.x;
    r1.x = exp2(r1.x);
    r3.xyz = float3(1,1,1) + -cb0[37].xyz;
    r3.xyz = r1.xxx * r3.xyz + cb0[37].xyz;
    r3.xyz = r3.xyz * r0.xyz;
    r1.y = -1 + r0.w;
    r3.w = r1.x * r1.y + 1;
  } else {
    // Second color processing path
    r1.xyzw = t7.Sample(s7_s, r1.zw).xyzw;
    r1.y = 0.0549999997 + r1.w;
    r1.xy = float2(0.0773993805,0.947867334) * r1.wy;
    r1.y = max(1.1920929e-07, abs(r1.y));
    r1.y = log2(r1.y);
    r1.y = 2.4000001 * r1.y;
    r1.y = exp2(r1.y);
    r1.z = cmp(0.0404499993 >= r1.w);
    r1.x = r1.z ? r1.x : r1.y;
    r1.yzw = float3(1,1,1) + -cb0[37].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
    r1.yzw = r0.xyz * r1.yzw + -r0.xyz;
    r3.xyz = cb0[40].xxx * r1.yzw + r0.xyz;
    r0.x = -1 + r0.w;
    r3.w = r1.x * r0.x + 1;
  }

  float3 untonemapped = r3.xyzw;
  untonemapped.xyz = untonemapped.zxy;

  

  // Final color space conversion and output
  r3.xyzw = saturate(r3.xyzw);
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r3.zxy;
  r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), r3.zxy);
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r3.zxy);
  r0.xyz = r3.xyz ? r0.xyz : r1.xyz;

  // Final color grading and lookup
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  r4.xyzw = t6.Sample(s6_s, r1.xz).xyzw;
  r2.z = cb0[36].y;
  r0.zw = r1.xz + r2.zw;
  r1.xyzw = t6.Sample(s6_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[36].z + -r0.y;
  r0.yzw = r1.xyz + -r4.xyz;
  r0.xyz = r0.xxx * r0.yzw + r4.xyz;

  // Final color space conversion
  r1.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r2.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  r2.xyz = float3(0.947867334,0.947867334,0.947867334) * r2.xyz;
  r2.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r2.xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001,2.4000001,2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  r0.xyz = r0.xyz ? r1.xyz : r2.xyz;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  } else {
    r0.xyz = renodx::draw::ToneMapPass(untonemapped, r0.xyz);
  }


  r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);

  o0.xyz = r0.xyz;

  #ifdef DEBUG_UBER
  if (v1.x < 0.005 && v1.y <= 0.005) {
    o0.xyz = (0,0,0);
  }
  #endif

  o0.w = r3.w;
  return;
}