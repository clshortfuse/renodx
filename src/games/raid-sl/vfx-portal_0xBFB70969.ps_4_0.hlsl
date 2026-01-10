#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 01:14:31 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float v2 : TEXCOORD1,
  float w2_reserved : TEXCOORD4,
  float2 w2 : TEXCOORD2,
  float2 v3 : TEXCOORD3,
  float2 w3 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Noise Sampling & Combination ---
  // Samples texture t0 at three different UV coordinates (v3, w3, w2).
  r0.xyzw = t0.Sample(s0_s, v3.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, w3.xy).xyzw;
  r0.x = r1.y + r0.x; // Add noise channels
  r0.x = 0.5 * r0.x;  // Average

  r1.xyzw = t0.Sample(s0_s, w2.xy).xyzw; 
  r0.y = v1.z * r1.z; // Modulate by vertex color parameter
  r0.x = r0.y * 0.5 + r0.x; // Mix into main noise

  // --- Color Ramp Lookup (t1) ---
  // Maps noise intensity to a color 
  // FIX: Using w2_reserved for logic, keeping w2  for UVs earlier
  r0.x = -cb0[5].x + r0.x;
  r0.x = w2_reserved * r0.x; 
  r0.x = r0.x / v2.x;
  r0.x = cb0[4].x * r0.x;
  r0.y = 0;
  r0.xy = cb0[4].zw + r0.xy; // Final UV for ramp

  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  
  // Unclamp & Boost for HDR
  o0.xyz = pow(max(0, r0.xyz), 2.2);
  if (RENODX_TONE_MAP_TYPE != 0) {
    o0.xyz *= 3.0f;
  }

  r0.x = w2_reserved * v1.x;    // Alpha/Opacity
  o0.w = r0.x;
  return;
}