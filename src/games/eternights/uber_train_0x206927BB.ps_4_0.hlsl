#include "shared.h"

// Pixel shader for Eternights game
// Created with 3Dmigoto v1.4.1 on Sat Jun  7 04:02:59 2025

// Texture declarations
// These are the input textures used by the shader
Texture2D<float4> t5 : register(t5);  // Likely a lookup texture for color grading
Texture2D<float4> t4 : register(t4);  // Additional texture input
Texture2D<float4> t3 : register(t3);  // Main texture input
Texture2D<float4> t2 : register(t2);  // Secondary texture input
Texture2D<float4> t1 : register(t1);  // Additional texture input
Texture2D<float4> t0 : register(t0);  // Additional texture input

// Sampler states for texture sampling
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

// Constant buffer containing shader parameters
cbuffer cb0 : register(b0)
{
  float4 cb0[37];  // Array of shader parameters
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Initial texture sampling and coordinate setup
  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;

  // Setup for multi-tap sampling (likely for blur or filtering)
  r1.xyzw = float4(1,1,-1,0) * cb0[32].xyxy;
  
  // Multiple texture samples with different offsets
  // This appears to be implementing a multi-tap filter or blur effect
  r2.xyzw = saturate(-r1.xywy * cb0[34].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2,2,2,2) + r3.xyzw;

  // Additional sampling points for the filter
  r3.xy = saturate(-r1.zy * cb0[34].xx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;

  // More sampling points and accumulation
  r3.xyzw = saturate(r1.zwxw * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r4.xyzw * float4(2,2,2,2) + r2.xyzw;
  r0.xyzw = r0.xyzw * float4(4,4,4,4) + r2.xyzw;
  r0.xyzw = r3.xyzw * float4(2,2,2,2) + r0.xyzw;

  // Final sampling points and color accumulation
  r2.xyzw = saturate(r1.zywy * cb0[34].xxxx + v1.xyxy);
  r1.xy = saturate(r1.xy * cb0[34].xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r2.xyzw * float4(2,2,2,2) + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw;

  // Color processing and scaling
  r1.xyzw = float4(0.0625,0.0625,0.0625,1) * r0.xyzw;
  r0.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw;
  r2.xyz = cb0[35].xyz * r1.xyz;
  r2.w = 0.0625 * r1.w;

  // Additional texture sampling and color blending
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r3.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r3.xyz = r3.xyz * r1.xxx;
  r1.xyzw = r3.xyzw + r2.xyzw;

  // More texture sampling and color processing
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz;
  r2.w = 0;
  //r0.xyzw = saturate(r2.xyzw * r0.xyzw + r1.xyzw);
  r0.xyzw = (r2.xyzw * r0.xyzw + r1.xyzw);

  float3 untonemapped = r0.zxy;


  r0.xyz = untonemapped;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = renodx::tonemap::dice::BT709(r0.xyz, 1.f, 0.5f);
  }
  
  r0.xyz = renodx::color::srgb::Encode(saturate(r0.xyz));
  o0.w = saturate(r0.w);

  // Color grading and lookup
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r0.x = r0.x * cb0[36].z + -r0.y;
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  r2.x = cb0[36].y;
  r2.y = 0;
  r0.yz = r2.xy + r1.xz;
  r1.xyzw = t5.Sample(s5_s, r1.xz).xyzw;
  r2.xyzw = t5.Sample(s5_s, r0.yz).xyzw;
  r0.yzw = r2.xyz + -r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;

  // Final color space conversion and processing
  r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  r1.xyz = float3(0.947867334,0.947867334,0.947867334) * r1.xyz;
  r1.xyz = max(float3(1.1920929e-07,1.1920929e-07,1.1920929e-07), abs(r1.xyz));
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  r0.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;


  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  } else {
    r0.xyz = renodx::draw::ToneMapPass(untonemapped, r0.xyz);
  }



  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);

  // Final texture sampling and alpha processing
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * 3.40282347e+38 + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;

  // Final color processing using custom functions
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  o0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);

  return;
}