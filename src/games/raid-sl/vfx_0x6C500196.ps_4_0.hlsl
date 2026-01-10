#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jan  7 05:46:24 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[10];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Animation / Time Calculation ---
  r0.x = 0.00100000005 * cb1[0].y; // Scale Time
  r0.x = frac(r0.x);
  r0.x = r0.x * 2000 + -1000;      // Map time to a large scrolling range

  // --- Noise Sampling (t0) Pass 1 & 2 ---
  r0.y = cb0[8].w * abs(r0.x);     // Calculate Scroll Offset 1
  r0.yz = cb0[8].xy * r0.yy + v0.xy; // Apply Offset to UVs
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw; // Sample Noise Layer 1

  r0.y = cb0[7].w * abs(r0.x);     // Calculate Scroll Offset 2
  r0.x = cb0[6].w * abs(r0.x);     // Calculate Scroll Offset 3
  r0.xz = cb0[6].xy * r0.xx + v0.xy; // UV Set 3
  r0.yw = cb0[7].xy * r0.yy + v0.xy; // UV Set 2
  r2.xyzw = t0.Sample(s0_s, r0.yw).xyzw; // Sample Noise Layer 2

  // --- Distortion / Combination ---
  r0.y = r2.z + r1.y;  // Combine Noise Channels (Green + Blue)
  r0.xy = r0.xz + r0.yy; // Add combined noise to UV Set 3
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw; // Sample Distorted Noise (Layer 3)

  // --- Intensity / Alpha Calculation ---
  r0.x = cb0[5].x * r0.x;
  r0.x = dot(r0.xx, v2.xx); // Modulate by Vertex Color (Red)
  r0.y = -v2.w * r0.x + cb0[9].x; // Alpha Thresholding logic?
  r0.y = r0.y / -cb0[9].y;
  r0.z = cb0[9].w + -cb0[9].z;
  r0.y = saturate(r0.y * r0.z + cb0[9].z); // Remap/Clamp
  r1.w = saturate(r0.x * r0.y); // Final Alpha

  // --- Color Lookup (t1) ---
  // Uses the calculated intensity (r0.x) to sample a Gradient/Ramp texture
  r0.x = cb0[3].x * r0.x; 
  r0.y = 0;
  r0.xy = cb0[3].zw + r0.xy;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw; // Sample Color Ramp
  r1.xyz = r0.xyz;
  
  // Unclamp & Boost for HDR
  r1.xyz = pow(max(0, r1.xyz), 2.2);
  if (RENODX_TONE_MAP_TYPE != 0) {
    r1.xyz *= 3.0f;
  }

  // --- Premultiplied Alpha Output ---
  o0.xyzw = r1.xyzw * r1.wwww;
  return;
}