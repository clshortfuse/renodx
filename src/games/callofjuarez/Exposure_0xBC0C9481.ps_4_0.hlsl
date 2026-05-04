#include "./shared.h"

// ---- Created with 3Dmigoto v1.2.45 on Sun Jan 25 22:10:19 2026

cbuffer _Globals : register(b0)
{
  float4 TEX_INV_SIZE_sColor0 : packoffset(c0);
  int TEX_SIZEX8_sColor0 : packoffset(c1);
  float fDeltaHDR : packoffset(c1.y);
}

SamplerState samColor0_s : register(s0);
Texture2D<float4> sColor0 : register(t0);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;
/*
  r0.x = 0.5 * TEX_INV_SIZE_sColor0.x;
  r0.y = 8 * TEX_SIZEX8_sColor0;
  r0.w = v1.x;
  r1.w = fDeltaHDR;
  r2.x = r0.x;
  r2.yz = float2(0,0);
  while (true) {
    r2.w = cmp((int)r2.z >= (int)r0.y);
    if (r2.w != 0) break;
    r0.z = r2.x;
    r3.xyzw = sColor0.Sample(samColor0_s, r0.zw).xyzw;
    r1.xyz = r3.xyz;
    r0.z = dot(float4(0.212500006,0.715399981,0.0720999986,1), r1.xyzw);
    //r0.z = max(r0.z, 0.1); //HDR aggresive exposure fix
    //r0.z = min(r0.z, 1.5); //HDR aggresive exposure fix
    r0.z = log2(r0.z);
    r2.y = r0.z * TEX_INV_SIZE_sColor0.x + r2.y;
    r2.x = TEX_INV_SIZE_sColor0.x + r2.x;
    r2.z = (int)r2.z + 1;
  }
  o0.xyzw = r2.yyyy;
  return;
*/

  r0.x = 0.5 * TEX_INV_SIZE_sColor0.x;
  r0.y = 8 * TEX_SIZEX8_sColor0;
  r0.w = v1.x; // Y-coord
  
  r2.x = r0.x; // Current UV.x
  r2.y = 0;    // Total Weighted Log-Luminance
  float totalWeight = 1e-7; // Avoid div by zero
  r2.z = 0;    // Counter

  while (true) {
    if ((int)r2.z >= (int)r0.y) break;
    r3.xyzw = sColor0.Sample(samColor0_s, float2(r2.x, r0.w));
    float lum = renodx::color::y::from::BT709(r3.xyz);
    float logLum = log2(max(lum, 1e-7));
    // Calculate a "Weight" based on how extreme the value is.
    // This formula gives a high weight to "normal" values and 
    // a very low weight to "strobe-like" highlights or pure black.
    // It creates a Bell Curve around the middle-gray area.
    float weight = 1.0 / (1.0 + abs(logLum)); 
    weight = pow(weight, 4.0); // Rejection of outliers

    // Accumulate Weighted Values
    r2.y += logLum * weight * TEX_INV_SIZE_sColor0.x;
    totalWeight += weight * TEX_INV_SIZE_sColor0.x;

    r2.x += TEX_INV_SIZE_sColor0.x;
    r2.z = (int)r2.z + 1;
  }

  // This is much more stable because flickering highlights have low weight.
  o0.xyzw = (r2.yyyy / totalWeight) - 0.5; 
  
  return;
}