#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 CONST_4 : packoffset(c0);
}

SamplerState samBackbuffer_s : register(s0);
Texture2D<float4> sBackbuffer : register(t0);

#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);

// Noise function for dithering (Interleaved Gradient Noise)
float InterleavedGradientNoise(float2 position_screen)
{
    float3 magic = float3(0.06711056, 0.00583715, 52.9829189);
    return frac(magic.z * frac(dot(position_screen, magic.xy)));
}

// Spatial hash for static scenes
float SpatialHash(float2 p) {
  p = frac(p * float2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return frac(p.x * p.y);
}

// A more stable hash for spatial smoothing
float SmoothHash(float2 p) {
  return frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    float4 v4: TEXCOORD3,
    float4 v5: TEXCOORD4,
    float4 v6: TEXCOORD5,
    float4 v7: TEXCOORD6,
    float4 v8: TEXCOORD7,
    float4 v9: TEXCOORD8,
    float4 v10: TEXCOORD9,
    float4 v11: TEXCOORD10,
    float4 v12: TEXCOORD11,
    float4 v13: TEXCOORD12,
    float4 v14: TEXCOORD13,
    float4 v15: TEXCOORD14,
    out float4 o0: SV_TARGET0)
/* Vanilla
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 v[15] = { v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14 };
  r0.xyzw = float4(0,0,0,0);
  r1.x = 0;
  while (true) {
    r1.y = (int)r1.x;
    r1.y = cmp(r1.y >= 15);
    if (r1.y != 0) break;
    r2.xyzw = sBackbuffer.Sample(samBackbuffer_s, v[r1.x+1].xy).xyzw;
    r2.xyzw = r2.xyzw + r0.xyzw;
    r3.xyzw = sBackbuffer.Sample(samBackbuffer_s, v[r1.x+1].zw).xyzw;
    r0.xyzw = r3.xyzw + r2.xyzw;
    r1.x = (int)r1.x + 1;
  }
  o0.xyzw = CONST_4.wwww * r0.xyzw;
  return;
}
*/

{
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  float4 v[15] = { v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14 };
  
  if (RENODX_TONE_MAP_TYPE <= 0.f) {
    // Vanilla - the true vanilla above for some reason refused to compile when under the renodx tonemap type check.
    r0.xyzw = float4(0, 0, 0, 0);
    r1.x = 0;

    for (int i = 0; i < 14; i++)  // we stop at 14 so i+1 is <= 14
    {
      r2.xyzw = sBackbuffer.Sample(samBackbuffer_s,
                                   (i == 0) ? v1.xy :
        (i == 1) ? v2.xy :
        (i == 2)   ? v3.xy :
        (i == 3)   ? v4.xy :
        (i == 4)   ? v5.xy :
        (i == 5)   ? v6.xy :
        (i == 6)   ? v7.xy :
        (i == 7)   ? v8.xy :
        (i == 8)   ? v9.xy :
        (i == 9)   ? v10.xy :
        (i == 10)  ? v11.xy :
        (i == 11)  ? v12.xy :
        (i == 12)  ? v13.xy :
        v14.xy) .xyzw;

      r2.xyzw = r2.xyzw + r0.xyzw;

      r3.xyzw = sBackbuffer.Sample(samBackbuffer_s,
                                   (i == 0) ? v1.zw :
        (i == 1) ? v2.zw :
        (i == 2)   ? v3.zw :
        (i == 3)   ? v4.zw :
        (i == 4)   ? v5.zw :
        (i == 5)   ? v6.zw :
        (i == 6)   ? v7.zw :
        (i == 7)   ? v8.zw :
        (i == 8)   ? v9.zw :
        (i == 9)   ? v10.zw :
        (i == 10)  ? v11.zw :
        (i == 11)  ? v12.zw :
        (i == 12)  ? v13.zw :
        v14.zw) .xyzw;

      r0.xyzw = r3.xyzw + r2.xyzw;
      r1.x = r1.x + 1;
    }
    o0.xyzw = CONST_4.wwww * r0.xyzw;

  } else {

    float4 totalLight = float4(0, 0, 0, 0);
    float ign = InterleavedGradientNoise(v0.xy);
    float microDither = SmoothHash(v0.xy);
    float dither = (ign * microDither) * 1.0;

    [unroll]
    for (int i = 0; i < 14; ++i)
    {
      float2 posA = v[i].xy;
      float2 nextPosA = v[i].zw;
      float2 dirA = nextPosA - posA;
      totalLight += sBackbuffer.Sample(samBackbuffer_s, posA + dirA * dither);

      float2 posB = v[i].zw;
      float2 nextPosB = v[i + 1].xy;
      float2 dirB = nextPosB - posB;
      totalLight += sBackbuffer.Sample(samBackbuffer_s, posB + dirB * dither);
    }
    // Last samples
    float2 posLast1 = v[14].xy;
    float2 posLast2 = v[14].zw;
    float2 dirLast = posLast2 - posLast1;
    totalLight += sBackbuffer.Sample(samBackbuffer_s, posLast1 + dirLast * dither);
    totalLight += sBackbuffer.Sample(samBackbuffer_s, posLast2 + dirLast * dither);

    // We only do 12 extra samples.
    // This creates a "Zoom Blur" effect that fills the noise gaps.
    float4 blurLight = float4(0, 0, 0, 0);
    // Direction from the start of the cloud ray to the current pixel
    float2 blurOrigin = v1.xy;
    float2 blurVec = (v0.xy - blurOrigin);
    // We take 6 pairs (12 samples) spread along this vector
    [unroll]
    for (int j = 1; j <= 3; ++j) 
    {
      // Jitter the blur distance so it doesn't look like bands
      float scale = (float(j) / 3.0); + (dither * 0.05);

      // Sample closer to the origin to grab "neighbor" colors
      blurLight += sBackbuffer.Sample(samBackbuffer_s, blurOrigin + blurVec * (0.6 + scale * 0.4));
      blurLight += sBackbuffer.Sample(samBackbuffer_s, blurOrigin + blurVec * (0.6 + scale * 0.35));
    }
    // We average the sharp volume (totalLight) with the blurred volume (blurLight).
    // This reduces noise by ~50% without changing brightness or color logic.
    // The (30.0 / 12.0) factor normalizes the blur loop to match the main loop's magnitude.
    float4 finalBlur = blurLight * (30.0 / 6.0);
    o0 = lerp(totalLight, finalBlur, 0.5) * 2 * CONST_4.w;
  }
  return;
}