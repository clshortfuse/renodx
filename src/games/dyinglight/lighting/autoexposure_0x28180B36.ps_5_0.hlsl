#include "./lighting.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:44:06 2025
Texture2D<float4> t1 : register(t1);  // downsampled luminance

Texture2D<float4> t0 : register(t0);  // exposure history

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    out float o0: SV_TARGET0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.03125;
  r0.zw = float2(0, 0.03125);
  r1.yz = float2(0.03125, 0);
  // Sample a 4x4 block of the luminance downsample texture and accumulate the average
  while (true) {
    r1.w = cmp((int)r1.z >= 4);
    if (r1.w != 0) break;
    r1.x = r0.w;
    r0.y = r0.z;
    r1.w = 0;
    while (true) {
      r2.x = cmp((int)r1.w >= 4);
      if (r2.x != 0) break;
      r2.x = t0.Sample(s0_s, r1.xy).x;

#if 1
      r2.x = ApplyCustomAutoExposureClamp(r2.x);
#endif

      r2.y = r2.x * r2.x;
      r2.y = cmp(r2.y >= 0);
      r2.x = r2.x * 0.0625 + r0.y;
      r0.y = r2.y ? r2.x : r0.y;
      r1.x = 0.0625 + r1.x;
      r1.w = (int)r1.w + 1;
    }
    r1.y = 0.0625 + r1.y;
    r1.z = (int)r1.z + 1;
    r0.zw = r0.yx;
  }
  r0.x = cb0[0].y / r0.z;                  // Desired target luminosity divided by current average
  r0.y = t1.Sample(s1_s, float2(0, 0)).x;  // Previous adapted exposure
  r0.z = r0.y * r0.y;
  r0.z = cmp(r0.z >= 0);
  r0.y = log2(abs(r0.y));
  r0.y = 0.125 * r0.y;
  r0.y = exp2(r0.y);  // Map previous exposure into 1/8 power space for blending
  r0.x = log2(abs(r0.x));
  r0.x = 0.125 * r0.x;
  r0.x = exp2(r0.x);  // Map target exposure into the same space
  r0.x = r0.x + -r0.y;
  r0.w = 1.44269502 * cb0[0].x;
  r0.w = exp2(r0.w);
  r0.w = 1 + -r0.w;
  r0.x = r0.x * r0.w + r0.y;  // Temporal smoothing between previous and target exposures
  r0.x = abs(r0.x) * abs(r0.x);
  r0.x = r0.x * r0.x;
  r0.x = r0.x * r0.x;  // Raise back to the 8th power to return to linear exposure
  r0.x = max(cb0[0].z, r0.x);
  r0.x = min(cb0[0].w, r0.x);  // Clamp exposure to configured min/max
  o0.x = r0.z ? r0.x : 0;      // Only write when the previous exposure was valid
  return;
}
